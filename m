From: HanBin Yoon <hanbinyoon@google.com>
Subject: [RFC] SCSI support for SMR/ZBC commands
Date: Mon, 5 May 2014 14:28:00 -0700
Message-ID: <CACs+NxSQovDcanMXBbqr+rd=7TCa99DKzxkGQvuM9+_oy3BGBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:37847 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631AbaEEV2A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 May 2014 17:28:00 -0400
Received: by mail-vc0-f182.google.com with SMTP id la4so2485999vcb.13
        for <linux-scsi@vger.kernel.org>; Mon, 05 May 2014 14:28:00 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: tytso@mit.edu

SMR (Shingled Magnetic Recording) disk drives are able to achieve higher areal
density, at the cost of making media write operations to the disk more
inflexible (i.e., divides the disk into multiple zones, each of which can be
written sequentially only).

Following on some discussions in the Linux filesystem community around SMR
[1][2], I'd like to work on adding early support for SMR-related SCSI commands
(ZBC, or Zoned Block Commands [3]). First, I'd like to ask the Linux SCSI/
filesystem communities for advice and recommendations on how to go about it.

[1] http://thread.gmane.org/gmane.linux.file-systems/81970/focus=82309
[2] http://www.spinics.net/lists/linux-fsdevel/msg72305.html
[3] http://www.t10.org/cgi-bin/ac.pl?t=d&f=14-010r8.pdf

I'm thinking of classifying an SMR disk drive as an sd-type SCSI device, as SMR
is expected to be delivered in the form of an add-on/enhancement to existing
traditional disk drives. SMR disk drives will continue to support random read
capability.

As for exposing ZBC to upper layers of the stack, I'm thinking of two potential
ways:
  A) As an ioctl handled by sd_ioctl(), in drivers/scsi/sd.c
  B) As a request command flag type handled by sd_prep_fn(), in
     drivers/scsi/sd.c


For A), sd_ioctl() in drivers/scsi/sd.c may look something like: (not a patch)

static int sd_ioctl(struct block_device *bdev, fmode_t mode,
                    unsigned int cmd, unsigned long arg)
{

... (abridged) ...

        /*
         * Send SCSI addressing ioctls directly to mid level, send other
         * ioctls to block level and then onto mid level if they can't be
         * resolved.
         */
        switch (cmd) {
+               case SD_REPORT_ZONES:
+               case SD_RESET_WRITEPNTR:
+                       error = sd_smr_command(sdp, cmd, p);
+                       break;
                case SCSI_IOCTL_GET_IDLUN:
                case SCSI_IOCTL_GET_BUS_NUMBER:
                        error = scsi_ioctl(sdp, cmd, p);
                        break;
                default:
                        error = scsi_cmd_blk_ioctl(bdev, mode, cmd, p);
                        if (error != -ENOTTY)
                                break;
                        error = scsi_ioctl(sdp, cmd, p);
                        break;
        }
out:
        return error;
}


For B), sd_prep_fn() in drivers/scsi/sd.c may look something like: (not a patch)

static int sd_prep_fn(struct request_queue *q, struct request *rq)
{
        struct scsi_cmnd *SCpnt;
        struct scsi_device *sdp = q->queuedata;
        struct gendisk *disk = rq->rq_disk;
        struct scsi_disk *sdkp;
        sector_t block = blk_rq_pos(rq);
        sector_t threshold;
        unsigned int this_count = blk_rq_sectors(rq);
        int ret, host_dif;
        unsigned char protect;

        /*
         * Discard request come in as REQ_TYPE_FS but we turn them into
         * block PC requests to make life easier.
         */
        if (rq->cmd_flags & REQ_DISCARD) {
                ret = sd_setup_discard_cmnd(sdp, rq);
                goto out;
+       } else if (rq->cmd_flags & REQ_REPORT_ZONES) {
+               ret = sd_setup_report_zones_cmnd(sdp, rq);
+               goto out;
+       } else if (rq->cmd_flags & REQ_RESET_WRITEPNTR) {
+               ret = sd_setup_reset_writepntr_cmnd(sdp, rq);
+               goto out;
        } else if (rq->cmd_flags & REQ_WRITE_SAME) {
                ret = sd_setup_write_same_cmnd(sdp, rq);
                goto out;
        } else if (rq->cmd_flags & REQ_FLUSH) {
                ret = scsi_setup_flush_cmnd(sdp, rq);
                goto out;
        } else if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
                ret = scsi_setup_blk_pc_cmnd(sdp, rq);
                goto out;
        } else if (rq->cmd_type != REQ_TYPE_FS) {
                ret = BLKPREP_KILL;
                goto out;
        }
        ret = scsi_setup_fs_cmnd(sdp, rq);
        if (ret != BLKPREP_OK)
                goto out;
        SCpnt = rq->special;
        sdkp = scsi_disk(disk);

... (abridged) ...

}


I'd very much appreciate feedback/comments on the directions above. Thanks.

Han
