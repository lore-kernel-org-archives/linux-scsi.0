Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 049AFC433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 19:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C99696142B
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 19:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237076AbhDUTqu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 15:46:50 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:59333 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236125AbhDUTqu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 15:46:50 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 0F9F92EA417;
        Wed, 21 Apr 2021 15:46:16 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id 69cym-djHsaY; Wed, 21 Apr 2021 15:26:29 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id AE8812EA40E;
        Wed, 21 Apr 2021 15:46:14 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 07/42] scsi: Kill DRIVER_SENSE
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
 <20210421174749.11221-8-hare@suse.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <d3748963-a903-61f5-04fc-64a2f7f533b4@interlog.com>
Date:   Wed, 21 Apr 2021 15:46:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210421174749.11221-8-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-04-21 1:47 p.m., Hannes Reinecke wrote:
> Replace the check for DRIVER_SENSE with a check for
> SAM_STAT_CHECK_CONDITION and audit all callsites to
> ensure the SAM status is set correctly.
> For backwards compability move the DRIVER_SENSE definition
> to sg.h, and update the sg driver to set the DRIVER_SENSE
> driver_status whenever SAM_STAT_CHECK_CONDITION is present.

I may have missed it but you probably want to do the same
backwards compatibility DRIVER_SENSE trick for the
ioctl(SG_IO) implemented in block/scsi_ioctl.c . That way
DRIVER_SENSE will appear in the sg_io_hdr::driver_status byte
when check_condition_sense are set for both these cases:
     ioctl(sd_fd, SG_IO, &a_sg_v3_obj)
     ioctl(sg_fd, SG_IO, &a_sg_v3_obj)

And for bsg which uses sg_io_v4 for SCSI commands you set
sg_io_v4::driver_status = 0
in all cases. If check_condition and sense are active, why
not set DRIVER_SENSE for consistency. block/scsi_ioctl.c
includes scsi/sg.h so the DRIVER_SENSE define is visble.

Doug Gilbert

> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/ata/libata-scsi.c                   | 13 ++------
>   drivers/scsi/NCR5380.c                      |  2 +-
>   drivers/scsi/advansys.c                     |  2 --
>   drivers/scsi/aic7xxx/aic79xx_osm.c          | 19 +++++-------
>   drivers/scsi/aic7xxx/aic7xxx_osm.c          |  1 -
>   drivers/scsi/arcmsr/arcmsr_hba.c            |  1 -
>   drivers/scsi/ch.c                           |  2 +-
>   drivers/scsi/cxlflash/superpipe.c           |  3 +-
>   drivers/scsi/dc395x.c                       | 13 ++------
>   drivers/scsi/esp_scsi.c                     |  4 +--
>   drivers/scsi/megaraid.c                     | 10 +++---
>   drivers/scsi/megaraid/megaraid_mbox.c       |  8 ++---
>   drivers/scsi/megaraid/megaraid_sas_base.c   |  2 --
>   drivers/scsi/megaraid/megaraid_sas_fusion.c |  1 -
>   drivers/scsi/mvumi.c                        |  1 -
>   drivers/scsi/scsi.c                         |  7 -----
>   drivers/scsi/scsi_debug.c                   |  4 +--
>   drivers/scsi/scsi_ioctl.c                   |  3 +-
>   drivers/scsi/scsi_lib.c                     |  9 ++----
>   drivers/scsi/scsi_scan.c                    |  2 +-
>   drivers/scsi/scsi_transport_spi.c           |  2 +-
>   drivers/scsi/sd.c                           | 34 +++++++++++----------
>   drivers/scsi/sd_zbc.c                       |  3 +-
>   drivers/scsi/sg.c                           |  9 ++++--
>   drivers/scsi/stex.c                         |  4 +--
>   drivers/scsi/sym53c8xx_2/sym_glue.c         |  6 ++--
>   drivers/scsi/ufs/ufshcd.c                   |  2 +-
>   drivers/scsi/virtio_scsi.c                  |  3 +-
>   drivers/scsi/vmw_pvscsi.c                   |  3 --
>   drivers/target/loopback/tcm_loop.c          |  1 -
>   drivers/usb/storage/cypress_atacb.c         |  4 +--
>   drivers/xen/xen-scsiback.c                  |  2 +-
>   include/scsi/sg.h                           |  2 ++
>   33 files changed, 68 insertions(+), 114 deletions(-)
> 

<snip>


> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 737cea9d908e..9122d05563d0 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -498,9 +498,11 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
>   	old_hdr->host_status = hp->host_status;
>   	old_hdr->driver_status = hp->driver_status;
>   	if ((CHECK_CONDITION & hp->masked_status) ||
> -	    (DRIVER_SENSE & hp->driver_status))
> +	    (srp->sense_b && (srp->sense_b[0] & 0x70) == 0x70)) {
> +		old_hdr->driver_status |= DRIVER_SENSE;
>   		memcpy(old_hdr->sense_buffer, srp->sense_b,
>   		       sizeof (old_hdr->sense_buffer));
> +	}
>   	switch (hp->host_status) {
>   	/* This setup of 'result' is for backward compatibility and is best
>   	   ignored by the user who should use target, host + driver status */
> @@ -574,7 +576,7 @@ sg_new_read(Sg_fd * sfp, char __user *buf, size_t count, Sg_request * srp)
>   	hp->sb_len_wr = 0;
>   	if ((hp->mx_sb_len > 0) && hp->sbp) {
>   		if ((CHECK_CONDITION & hp->masked_status) ||
> -		    (DRIVER_SENSE & hp->driver_status)) {
> +		    (srp->sense_b && (srp->sense_b[0] & 0x70) == 0x70)) {
>   			int sb_len = SCSI_SENSE_BUFFERSIZE;
>   			sb_len = (hp->mx_sb_len > sb_len) ? sb_len : hp->mx_sb_len;
>   			len = 8 + (int) srp->sense_b[7];	/* Additional sense length field */
> @@ -582,7 +584,8 @@ sg_new_read(Sg_fd * sfp, char __user *buf, size_t count, Sg_request * srp)
>   			if (copy_to_user(hp->sbp, srp->sense_b, len)) {
>   				err = -EFAULT;
>   				goto err_out;
> -			}
> +			} else
> +				hp->driver_status |= DRIVER_SENSE;
>   			hp->sb_len_wr = len;
>   		}
>   	}

<snip>

> diff --git a/include/scsi/sg.h b/include/scsi/sg.h
> index 7327e12f3373..a90703cf15f4 100644
> --- a/include/scsi/sg.h
> +++ b/include/scsi/sg.h
> @@ -131,6 +131,8 @@ struct compat_sg_io_hdr {
>   #define SG_INFO_DIRECT_IO 0x2   /* direct IO requested and performed */
>   #define SG_INFO_MIXED_IO 0x4    /* part direct, part indirect IO */
>   
> +/* Obsolete DRIVER_SENSE setting */
> +#define DRIVER_SENSE 0x08
>   
>   typedef struct sg_scsi_id { /* used by SG_GET_SCSI_ID ioctl() */
>       int host_no;        /* as in "scsi<n>" where 'n' is one of 0, 1, 2 etc */
> 

