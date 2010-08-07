From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: tcm/pscsi: Removal of struct scsi_disk access from
	pscsi_do_task()..?
Date: Fri, 06 Aug 2010 21:01:50 -0700
Message-ID: <1281153710.9098.0.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:25441 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750706Ab0HGEF3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Aug 2010 00:05:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Greetings hch and Co,

With this todays TCM/pSCSI cleanups pushed to lio-core-2.6.git/lio-4.0,
I am currently looking at removing the last two remaining uses of
drivers/scsi/sd.h:struct scsi_disk in pscsi_do_task() and
__pscsi_get_dev_info().

The latter is easy enough as the modern LIO userspace tools no longer
depend on this 'pSCSI claimer' information from $PSCSI_HBA/$DEV/info, so
I have go ahead and removed it this reference.  The former case for the
main I/O path for struct se_task currently looks like:

        /*
         * Grab pointer to struct gendisk for TYPE_DISK and TYPE_ROM
         * cases (eg: cases where struct scsi_device has a backing
         * struct block_device.  Also set the struct request->timeout
         * value based on peripheral device type (from SCSI).
         */
        if (pdv->pdv_sd->type == TYPE_DISK) {
                struct scsi_disk *sdisk = dev_get_drvdata(
                                        &pdv->pdv_sd->sdev_gendev);
                gd = sdisk->disk;
                pt->pscsi_req->timeout = PS_TIMEOUT_DISK;
        } else
                pt->pscsi_req->timeout = PS_TIMEOUT_OTHER;

        pt->pscsi_req->retries = PS_RETRY;
        /*
         * Queue the struct request into the struct scsi_device->request_queue.
         */
        blk_execute_rq_nowait(pdv->pdv_sd->request_queue, gd,
                              pt->pscsi_req, 1, pscsi_req_done);

        return PYX_TRANSPORT_SENT_TO_TRANSPORT;

My two questions are:

*) Is passing NULL for struct gendisk *gd into blk_execute_rq_nowait() and hence
   a NULL struct request->rd_disk acceptable for struct request->rq_flags=REQ_TYPE_BLOCK_PC
   usage in pscsi_blk_init_request() and pscsi_blk_get_request()..?

*) Is there a more sane way to locate struct gendisk *gd from struct scsi_device
   for the typical backing struct block_device TYPE_DISK case..?


Thanks!

--nab

