Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FE41C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 11:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbiDHLtp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 07:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234499AbiDHLtn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 07:49:43 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5313A9B5C
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 04:47:38 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1CE711F861;
        Fri,  8 Apr 2022 11:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649418457; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7HpLWdLIhv6gyxYCRapSoAvHbYMZxPh3ub3JqpWxG0k=;
        b=YSXGbR2USSAwIubpxzZW2OjqpJseD2lkFAIqgvrjAgsxuut6MiSsYtQPmIyPjm83njLYFX
        u7bnJu3Goop86d8PMj+UfJTvH+KPRYEXDUN/par2I/Wa40ZVNQ/POcYWaQW9GWHPtSJSC4
        RifdvgzQaDMCVC/EeXjNcO0rnFZtJ2I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649418457;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7HpLWdLIhv6gyxYCRapSoAvHbYMZxPh3ub3JqpWxG0k=;
        b=1406MoRx9Y72zuqdMUWBoU39hufJs9jvQlQvQb4kCXCZ0B9hYi2uHq5Qw/1aGhrny127Uy
        r2GamCToZTb6JaBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DBDBE13314;
        Fri,  8 Apr 2022 11:47:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id dy0NNdggUGLgAQAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 08 Apr 2022 11:47:36 +0000
Message-ID: <9a74d51e-5506-e1d1-61f0-67632541a146@suse.de>
Date:   Fri, 8 Apr 2022 13:47:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v3 1/8] mpi3mr: add BSG device support
Content-Language: en-US
To:     Sumit Saxena <sumit.saxena@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, bvanassche@acm.org, hch@lst.de,
        sathya.prakash@broadcom.com, kashyap.desai@broadcom.com,
        chandrakanth.patil@broadcom.com, sreekanth.reddy@broadcom.com,
        prayas.patel@broadcom.com
References: <20220407192913.345411-1-sumit.saxena@broadcom.com>
 <20220407192913.345411-2-sumit.saxena@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220407192913.345411-2-sumit.saxena@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/22 21:29, Sumit Saxena wrote:
> Create BSG device per controller for controller management purpose.
> BSG Device nodes will be named as /dev/bsg/mpi3mrctl0, /dev/bsg/mpi3mrctl1...
> 
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
>   drivers/scsi/mpi3mr/Kconfig      |   1 +
>   drivers/scsi/mpi3mr/Makefile     |   1 +
>   drivers/scsi/mpi3mr/mpi3mr.h     |  20 ++++++
>   drivers/scsi/mpi3mr/mpi3mr_app.c | 105 +++++++++++++++++++++++++++++++
>   drivers/scsi/mpi3mr/mpi3mr_os.c  |   2 +
>   5 files changed, 129 insertions(+)
>   create mode 100644 drivers/scsi/mpi3mr/mpi3mr_app.c
> 
> diff --git a/drivers/scsi/mpi3mr/Kconfig b/drivers/scsi/mpi3mr/Kconfig
> index f7882375e74f..8997531940c2 100644
> --- a/drivers/scsi/mpi3mr/Kconfig
> +++ b/drivers/scsi/mpi3mr/Kconfig
> @@ -3,5 +3,6 @@
>   config SCSI_MPI3MR
>   	tristate "Broadcom MPI3 Storage Controller Device Driver"
>   	depends on PCI && SCSI
> +	select BLK_DEV_BSGLIB
>   	help
>   	MPI3 based Storage & RAID Controllers Driver.
> diff --git a/drivers/scsi/mpi3mr/Makefile b/drivers/scsi/mpi3mr/Makefile
> index 7c2063e04c81..f5cdbe48c150 100644
> --- a/drivers/scsi/mpi3mr/Makefile
> +++ b/drivers/scsi/mpi3mr/Makefile
> @@ -2,3 +2,4 @@
>   obj-m += mpi3mr.o
>   mpi3mr-y +=  mpi3mr_os.o     \
>   		mpi3mr_fw.o \
> +		mpi3mr_app.o \
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 6672d907d75d..f0515f929110 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -148,6 +148,7 @@ extern int prot_mask;
>   
>   #define MPI3MR_DEFAULT_MDTS	(128 * 1024)
>   #define MPI3MR_DEFAULT_PGSZEXP         (12)
> +
>   /* Command retry count definitions */
>   #define MPI3MR_DEV_RMHS_RETRY_COUNT 3
>   
> @@ -175,6 +176,18 @@ extern int prot_mask;
>   /* MSI Index from Reply Queue Index */
>   #define REPLY_QUEUE_IDX_TO_MSIX_IDX(qidx, offset)	(qidx + offset)
>   
> +/*
> + * Maximum data transfer size definitions for management
> + * application commands
> + */
> +#define MPI3MR_MAX_APP_XFER_SIZE	(1 * 1024 * 1024)
> +#define MPI3MR_MAX_APP_XFER_SEGMENTS	512
> +/*
> + * 2048 sectors are for data buffers and additional 512 sectors for
> + * other buffers
> + */
> +#define MPI3MR_MAX_APP_XFER_SECTORS	(2048 + 512)
> +
>   /* IOC State definitions */
>   enum mpi3mr_iocstate {
>   	MRIOC_STATE_READY = 1,
> @@ -714,6 +727,8 @@ struct scmd_priv {
>    * @default_qcount: Total Default queues
>    * @active_poll_qcount: Currently active poll queue count
>    * @requested_poll_qcount: User requested poll queue count
> + * @bsg_dev: BSG device structure
> + * @bsg_queue: Request queue for BSG device
>    */
>   struct mpi3mr_ioc {
>   	struct list_head list;
> @@ -854,6 +869,9 @@ struct mpi3mr_ioc {
>   	u16 default_qcount;
>   	u16 active_poll_qcount;
>   	u16 requested_poll_qcount;
> +
> +	struct device *bsg_dev;
> +	struct request_queue *bsg_queue;
>   };
>   
>   /**
> @@ -962,5 +980,7 @@ void mpi3mr_check_rh_fault_ioc(struct mpi3mr_ioc *mrioc, u32 reason_code);
>   int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
>   	struct op_reply_qinfo *op_reply_q);
>   int mpi3mr_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num);
> +void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc);
> +void mpi3mr_bsg_exit(struct mpi3mr_ioc *mrioc);
>   
>   #endif /*MPI3MR_H_INCLUDED*/
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
> new file mode 100644
> index 000000000000..9b6698525990
> --- /dev/null
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -0,0 +1,105 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Driver for Broadcom MPI3 Storage Controllers
> + *
> + * Copyright (C) 2017-2022 Broadcom Inc.
> + *  (mailto: mpi3mr-linuxdrv.pdl@broadcom.com)
> + *
> + */
> +
> +#include "mpi3mr.h"
> +#include <linux/bsg-lib.h>
> +
> +/**
> + * mpi3mr_bsg_request - bsg request entry point
> + * @job: BSG job reference
> + *
> + * This is driver's entry point for bsg requests
> + *
> + * Return: 0 on success and proper error codes on failure
> + */
> +int mpi3mr_bsg_request(struct bsg_job *job)
> +{
> +	return 0;
> +}
> +
> +/**
> + * mpi3mr_bsg_exit - de-registration from bsg layer
> + *
> + * This will be called during driver unload and all
> + * bsg resources allocated during load will be freed.
> + *
> + * Return:Nothing
> + */
> +void mpi3mr_bsg_exit(struct mpi3mr_ioc *mrioc)
> +{
> +	if (!mrioc->bsg_queue)
> +		return;
> +
> +	bsg_remove_queue(mrioc->bsg_queue);
> +	mrioc->bsg_queue = NULL;
> +
> +	device_del(mrioc->bsg_dev);
> +	put_device(mrioc->bsg_dev);
> +	kfree(mrioc->bsg_dev);
> +}
> +
> +/**
> + * mpi3mr_bsg_node_release -release bsg device node
> + * @dev: bsg device node
> + *
> + * decrements bsg dev reference count
> + *
> + * Return:Nothing
> + */
> +void mpi3mr_bsg_node_release(struct device *dev)
> +{
> +	put_device(dev);
> +}
> +
> +/**
> + * mpi3mr_bsg_init -  registration with bsg layer
> + *
> + * This will be called during driver load and it will
> + * register driver with bsg layer
> + *
> + * Return:Nothing
> + */
> +void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
> +{
> +	mrioc->bsg_dev = kzalloc(sizeof(struct device), GFP_KERNEL);
> +	if (!mrioc->bsg_dev) {
> +		ioc_err(mrioc, "bsg device mem allocation failed\n");
> +		return;
> +	}
> +
> +	device_initialize(mrioc->bsg_dev);
> +	dev_set_name(mrioc->bsg_dev, "mpi3mrctl%u", mrioc->id);
> +
> +	if (device_add(mrioc->bsg_dev)) {
> +		ioc_err(mrioc, "%s: bsg device add failed\n",
> +		    dev_name(mrioc->bsg_dev));
> +		goto err_device_add;
> +	}
> +
> +	mrioc->bsg_dev->release = mpi3mr_bsg_node_release;
> +
> +	mrioc->bsg_queue = bsg_setup_queue(mrioc->bsg_dev, dev_name(mrioc->bsg_dev),
> +			mpi3mr_bsg_request, NULL, 0);
> +	if (!mrioc->bsg_queue) {
> +		ioc_err(mrioc, "%s: bsg registration failed\n",
> +		    dev_name(mrioc->bsg_dev));
> +		goto err_setup_queue;
> +	}
> +
> +	blk_queue_max_segments(mrioc->bsg_queue, MPI3MR_MAX_APP_XFER_SEGMENTS);
> +	blk_queue_max_hw_sectors(mrioc->bsg_queue, MPI3MR_MAX_APP_XFER_SECTORS);
> +
> +	return;
> +
> +err_setup_queue:
> +	device_del(mrioc->bsg_dev);
> +	put_device(mrioc->bsg_dev);
> +err_device_add:
> +	kfree(mrioc->bsg_dev);
> +}
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index f7cd70a15ea6..faf14a5f9123 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -4345,6 +4345,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   	}
>   
>   	scsi_scan_host(shost);
> +	mpi3mr_bsg_init(mrioc);
>   	return retval;
>   
>   addhost_failed:
> @@ -4389,6 +4390,7 @@ static void mpi3mr_remove(struct pci_dev *pdev)
>   	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
>   		ssleep(1);
>   
> +	mpi3mr_bsg_exit(mrioc);
>   	mrioc->stop_drv_processing = 1;
>   	mpi3mr_cleanup_fwevt_list(mrioc);
>   	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
