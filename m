From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH 1/5] sd: configure ZBC devices
Date: Mon, 1 Aug 2016 09:24:18 -0500
Message-ID: <CAJVOszD7C9a3tHe=z=fM1EDd+eZERJeT0676KNMjvoT=EM1UJQ@mail.gmail.com>
References: <1468934710-93876-1-git-send-email-hare@suse.de> <1468934710-93876-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:34699 "EHLO
	mx0a-000cda01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752395AbcHAOuI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2016 10:50:08 -0400
Received: from pps.filterd (m0075551.ppops.net [127.0.0.1])
	by mx0a-000cda01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u71ELVrL035725
	for <linux-scsi@vger.kernel.org>; Mon, 1 Aug 2016 10:24:39 -0400
Received: from mail-qt0-f198.google.com (mail-qt0-f198.google.com [209.85.216.198])
	by mx0a-000cda01.pphosted.com with ESMTP id 24j715rd00-13
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 01 Aug 2016 10:24:38 -0400
Received: by mail-qt0-f198.google.com with SMTP id 93so255043830qtg.1
        for <linux-scsi@vger.kernel.org>; Mon, 01 Aug 2016 07:24:38 -0700 (PDT)
In-Reply-To: <1468934710-93876-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Damien Le Moal <damien.lemoal@hgst.com>, Hannes Reinecke <hare@suse.com>, Josh Bingaman <josh.bingaman@seagate.com>

On Tue, Jul 19, 2016 at 8:25 AM, Hannes Reinecke <hare@suse.de> wrote:
> For ZBC devices I/O must not cross zone boundaries, so setup
> the 'chunk_sectors' block queue setting to the zone size.
> This is only valid for REPORT ZONES SAME type 2 or 3;
> for other types the zone sizes might be different
> for individual zones. So issue a warning if the type is
> found to be different.
> Also the capacity might be different from the announced
> capacity, so adjust it as needed.
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/sd.c         | 120 ++++++++++++++++++++++++++++++++++++++++++++--
>  drivers/scsi/sd.h         |  12 +++++
>  include/scsi/scsi_proto.h |  17 +++++++
>  3 files changed, 144 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 428c03e..249ea81 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1972,6 +1972,57 @@ sd_spinup_disk(struct scsi_disk *sdkp)
>         }
>  }
>
> +/**
> + * sd_zbc_report_zones - Issue a REPORT ZONES scsi command
> + * @sdkp: SCSI disk to which the command should be send
> + * @buffer: response buffer
> + * @bufflen: length of @buffer
> + * @start_sector: logical sector for the zone information should be reported
> + * @option: option for report zones command
> + * @partial: flag to set 'partial' bit for report zones command
> + */
> +static int
> +sd_zbc_report_zones(struct scsi_disk *sdkp, unsigned char *buffer,
> +                   int bufflen, sector_t start_sector,
> +                   enum zbc_zone_reporting_options option, bool partial)
> +{
> +       struct scsi_device *sdp = sdkp->device;
> +       const int timeout = sdp->request_queue->rq_timeout
> +               * SD_FLUSH_TIMEOUT_MULTIPLIER;
> +       struct scsi_sense_hdr sshdr;
> +       sector_t start_lba = sectors_to_logical(sdkp->device, start_sector);
> +       unsigned char cmd[16];
> +       int result;
> +
> +       if (!scsi_device_online(sdp)) {
> +               sd_printk(KERN_INFO, sdkp, "device not online\n");
> +               return -ENODEV;
> +       }
> +
> +       sd_printk(KERN_INFO, sdkp, "REPORT ZONES lba %zu len %d\n",
> +                 start_lba, bufflen);
> +
> +       memset(cmd, 0, 16);
> +       cmd[0] = ZBC_IN;
> +       cmd[1] = ZI_REPORT_ZONES;
> +       put_unaligned_be64(start_lba, &cmd[2]);
> +       put_unaligned_be32(bufflen, &cmd[10]);
> +       cmd[14] = (partial ? ZBC_REPORT_ZONE_PARTIAL : 0) | option;
> +       memset(buffer, 0, bufflen);
> +
> +       result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
> +                                 buffer, bufflen, &sshdr,
> +                                 timeout, SD_MAX_RETRIES, NULL);
> +
> +       if (result) {
> +               sd_printk(KERN_NOTICE, sdkp,
> +                         "REPORT ZONES lba %zu failed with %d/%d\n",
> +                         start_lba, host_byte(result), driver_byte(result));
> +
> +               return -EIO;
> +       }
> +       return 0;
> +}
>
>  /*
>   * Determine whether disk supports Data Integrity Field.
> @@ -2014,6 +2065,59 @@ static int sd_read_protection_type(struct scsi_disk *sdkp, unsigned char *buffer
>         return ret;
>  }
>
> +static void sd_read_zones(struct scsi_disk *sdkp, unsigned char *buffer)
> +{
> +       int retval;
> +       unsigned char *desc;
> +       u32 rep_len;
> +       u8 same;
> +       u64 zone_len, lba;
> +
> +       if (sdkp->zoned != 1)
> +               /* Device managed, no special handling required */
> +               return;
> +
> +       retval = sd_zbc_report_zones(sdkp, buffer, SD_BUF_SIZE,
> +                                    0, ZBC_ZONE_REPORTING_OPTION_ALL, false);
> +       if (retval < 0)
> +               return;
> +
> +       rep_len = get_unaligned_be32(&buffer[0]);
> +       if (rep_len < 64) {
> +               sd_printk(KERN_WARNING, sdkp,
> +                         "REPORT ZONES report invalid length %u\n",
> +                         rep_len);
> +               return;
> +       }
> +
> +       if (sdkp->rc_basis == 0) {
> +               /* The max_lba field is the capacity of a zoned device */
> +               lba = get_unaligned_be64(&buffer[8]);
> +               if (lba + 1 > sdkp->capacity) {
> +                       sd_printk(KERN_WARNING, sdkp,
> +                                 "Max LBA %zu (capacity %zu)\n",
> +                                 (sector_t) lba + 1, sdkp->capacity);
> +                       sdkp->capacity = lba + 1;
> +               }
> +       }
> +
> +       /*
> +        * Adjust 'chunk_sectors' to the zone length if the device
> +        * supports equal zone sizes.
> +        */
> +       same = buffer[4] & 0xf;
> +       if (same == 0 || same > 3) {
> +               sd_printk(KERN_WARNING, sdkp,
> +                         "REPORT ZONES SAME type %d not supported\n", same);
> +               return;
> +       }

It's a bit unfortunate that you abort here. The current Seagate Host
Aware drives
must report a same code of 0 here due to the final 'runt' zone and are therefore
not supported by your RB-Tree in the following patches.

> +       /* Read the zone length from the first zone descriptor */
> +       desc = &buffer[64];
> +       zone_len = logical_to_sectors(sdkp->device,
> +                                     get_unaligned_be64(&desc[8]));
> +       blk_queue_chunk_sectors(sdkp->disk->queue, zone_len);
> +}
> +
>  static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
>                         struct scsi_sense_hdr *sshdr, int sense_valid,
>                         int the_result)

-- 
Shaun Tancheff
