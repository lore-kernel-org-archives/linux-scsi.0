Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97A4EC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 11:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbiDHLza (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 07:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235220AbiDHLz3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 07:55:29 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D6C3B2B7
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 04:53:23 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C33241F85F;
        Fri,  8 Apr 2022 11:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649418801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bjwaftTc+q0RzGA7ol867i8l2rbeZwDDyycdnr0e4A0=;
        b=KVx1LYRUJ2ydGeXTHSNLZYdeY/tWe15cwFYcDeBh9XW7v+pfswciVLmH1vIUd4Kr+3eQBF
        13AlcaK1UCnLBsrIkx2AG40IFSt21BKeQnUfLpeS1L8m/6UElh0I7aEd/ES8R1NQwolLur
        KYvDu+tifjPSAd6noNhu/PhF11OdK2U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649418801;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bjwaftTc+q0RzGA7ol867i8l2rbeZwDDyycdnr0e4A0=;
        b=BTnYRWlqrh/ZggJoNWyNLsCbszx6W6hmGAh9rCbZeEfqyWxZWO3zjrPZs5Rfxb0Q7TruIj
        Fx+SesBMOK6ZFECw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 837FD13314;
        Fri,  8 Apr 2022 11:53:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id G6EvHzEiUGJDBAAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 08 Apr 2022 11:53:21 +0000
Message-ID: <92345d5b-c089-a178-7221-ab6eb6772534@suse.de>
Date:   Fri, 8 Apr 2022 13:53:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Sumit Saxena <sumit.saxena@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, bvanassche@acm.org, hch@lst.de,
        sathya.prakash@broadcom.com, kashyap.desai@broadcom.com,
        chandrakanth.patil@broadcom.com, sreekanth.reddy@broadcom.com,
        prayas.patel@broadcom.com
References: <20220407192913.345411-1-sumit.saxena@broadcom.com>
 <20220407192913.345411-3-sumit.saxena@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 2/8] mpi3mr: add support for driver commands
In-Reply-To: <20220407192913.345411-3-sumit.saxena@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/22 21:29, Sumit Saxena wrote:
> There are certain BSG commands which is to be completed
> by driver without involving firmware. These requests are termed
> as driver commands. This patch adds support for the same.
> 
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
>   drivers/scsi/mpi3mr/mpi3mr.h          |  16 +-
>   drivers/scsi/mpi3mr/mpi3mr_app.c      | 397 +++++++++++++++++++++++
>   drivers/scsi/mpi3mr/mpi3mr_debug.h    |  12 +-
>   drivers/scsi/mpi3mr/mpi3mr_fw.c       |  21 +-
>   drivers/scsi/mpi3mr/mpi3mr_os.c       |   3 +
>   include/uapi/scsi/mpi3mr/mpi3mr_bsg.h | 434 ++++++++++++++++++++++++++
>   6 files changed, 871 insertions(+), 12 deletions(-)
>   create mode 100644 include/uapi/scsi/mpi3mr/mpi3mr_bsg.h
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index f0515f929110..877b0925dbc5 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -89,7 +89,7 @@ extern int prot_mask;
>   /* Reserved Host Tag definitions */
>   #define MPI3MR_HOSTTAG_INVALID		0xFFFF
>   #define MPI3MR_HOSTTAG_INITCMDS		1
> -#define MPI3MR_HOSTTAG_IOCTLCMDS	2
> +#define MPI3MR_HOSTTAG_BSG_CMDS		2
>   #define MPI3MR_HOSTTAG_BLK_TMS		5
>   
>   #define MPI3MR_NUM_DEVRMCMD		16
> @@ -202,10 +202,10 @@ enum mpi3mr_iocstate {
>   enum mpi3mr_reset_reason {
>   	MPI3MR_RESET_FROM_BRINGUP = 1,
>   	MPI3MR_RESET_FROM_FAULT_WATCH = 2,
> -	MPI3MR_RESET_FROM_IOCTL = 3,
> +	MPI3MR_RESET_FROM_APP = 3,
>   	MPI3MR_RESET_FROM_EH_HOS = 4,
>   	MPI3MR_RESET_FROM_TM_TIMEOUT = 5,
> -	MPI3MR_RESET_FROM_IOCTL_TIMEOUT = 6,
> +	MPI3MR_RESET_FROM_APP_TIMEOUT = 6,
>   	MPI3MR_RESET_FROM_MUR_FAILURE = 7,
>   	MPI3MR_RESET_FROM_CTLR_CLEANUP = 8,
>   	MPI3MR_RESET_FROM_CIACTIV_FAULT = 9,
> @@ -698,6 +698,7 @@ struct scmd_priv {
>    * @chain_bitmap_sz: Chain buffer allocator bitmap size
>    * @chain_bitmap: Chain buffer allocator bitmap
>    * @chain_buf_lock: Chain buffer list lock
> + * @bsg_cmds: Command tracker for BSG command
>    * @host_tm_cmds: Command tracker for task management commands
>    * @dev_rmhs_cmds: Command tracker for device removal commands
>    * @evtack_cmds: Command tracker for event ack commands
> @@ -729,6 +730,10 @@ struct scmd_priv {
>    * @requested_poll_qcount: User requested poll queue count
>    * @bsg_dev: BSG device structure
>    * @bsg_queue: Request queue for BSG device
> + * @stop_bsgs: Stop BSG request flag
> + * @logdata_buf: Circular buffer to store log data entries
> + * @logdata_buf_idx: Index of entry in buffer to store
> + * @logdata_entry_sz: log data entry size
>    */
>   struct mpi3mr_ioc {
>   	struct list_head list;
> @@ -835,6 +840,7 @@ struct mpi3mr_ioc {
>   	void *chain_bitmap;
>   	spinlock_t chain_buf_lock;
>   
> +	struct mpi3mr_drv_cmd bsg_cmds;
>   	struct mpi3mr_drv_cmd host_tm_cmds;
>   	struct mpi3mr_drv_cmd dev_rmhs_cmds[MPI3MR_NUM_DEVRMCMD];
>   	struct mpi3mr_drv_cmd evtack_cmds[MPI3MR_NUM_EVTACKCMD];
> @@ -872,6 +878,10 @@ struct mpi3mr_ioc {
>   
>   	struct device *bsg_dev;
>   	struct request_queue *bsg_queue;
> +	u8 stop_bsgs;
> +	u8 *logdata_buf;
> +	u16 logdata_buf_idx;
> +	u16 logdata_entry_sz;
>   };
>   
>   /**
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
> index 9b6698525990..3136f5c5d164 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -9,6 +9,386 @@
>   
>   #include "mpi3mr.h"
>   #include <linux/bsg-lib.h>
> +#include <uapi/scsi/mpi3mr/mpi3mr_bsg.h>
> +
> +/**
> + * mpi3mr_bsg_verify_adapter - verify adapter number is valid
> + * @ioc_number: Adapter number
> + * @mriocpp: Pointer to hold per adapter instance
> + *
> + * This function checks whether given adapter number matches
> + * with an adapter id in the driver's list and if so fills
> + * pointer to the per adapter instance in mriocpp else set that
> + * to NULL.
> + *
> + * Return: Nothing.
> + */
> +static void mpi3mr_bsg_verify_adapter(int ioc_number,
> +	struct mpi3mr_ioc **mriocpp)
> +{
> +	struct mpi3mr_ioc *mrioc;
> +
> +	spin_lock(&mrioc_list_lock);
> +	list_for_each_entry(mrioc, &mrioc_list, list) {
> +		if (mrioc->id != ioc_number)
> +			continue;
> +		spin_unlock(&mrioc_list_lock);
> +		*mriocpp = mrioc;
> +		return;
> +	}
> +	spin_unlock(&mrioc_list_lock);
> +	*mriocpp = NULL;
> +}
> +
Please return 'struct mpi3mr_io *' here and avoid having to pass a 
return pointer.

> +/**
> + * mpi3mr_enable_logdata - Handler for log data enable
> + * @mrioc: Adapter instance reference
> + * @job: BSG job reference
> + *
> + * This function enables log data caching in the driver if not
> + * already enabled and return the maximum number of log data
> + * entries that can be cached in the driver.
> + *
> + * Return: 0 on success and proper error codes on failure
> + */
> +static long mpi3mr_enable_logdata(struct mpi3mr_ioc *mrioc,
> +	struct bsg_job *job)
> +{
> +	long rval = -EINVAL;
> +	struct mpi3mr_logdata_enable logdata_enable;
> +
> +	if (mrioc->logdata_buf)
> +		goto copy_user_data;
> +
> +	mrioc->logdata_entry_sz =
> +	    (mrioc->reply_sz - (sizeof(struct mpi3_event_notification_reply) - 4))
> +	    + MPI3MR_BSG_LOGDATA_ENTRY_HEADER_SZ;
> +	mrioc->logdata_buf_idx = 0;
> +
> +	mrioc->logdata_buf = kcalloc(MPI3MR_BSG_LOGDATA_MAX_ENTRIES,
> +	    mrioc->logdata_entry_sz, GFP_KERNEL);
> +	if (!mrioc->logdata_buf)
> +		return -ENOMEM;
> +
> +copy_user_data:
> +	memset(&logdata_enable, 0, sizeof(logdata_enable));
> +	logdata_enable.max_entries =
> +	    MPI3MR_BSG_LOGDATA_MAX_ENTRIES;
> +	if (job->request_payload.payload_len >= sizeof(logdata_enable)) {
> +		sg_copy_from_buffer(job->request_payload.sg_list,
> +				    job->request_payload.sg_cnt,
> +				    &logdata_enable, sizeof(logdata_enable));
> +		rval = 0;
> +	}
> +	return rval;
> +}

This is a very unusual programming pattern.
You allocate the buffer only _after_ the command has been submitted, 
risking a failure in buffer allocation even though the command succeeded.

Please convert this to allocate the buffer _first_, then issue the 
command, and then evaluate the response.

Same for the other bsg handler functions.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
