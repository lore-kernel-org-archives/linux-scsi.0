Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DA77C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 16:05:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2023D610FA
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 16:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234198AbhDZQFp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 12:05:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:44108 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233919AbhDZQFo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Apr 2021 12:05:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 19757ABD0;
        Mon, 26 Apr 2021 16:05:02 +0000 (UTC)
Subject: Re: [PATCH v3 06/24] mpi3mr: add support of event handling part-1
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, sathya.prakash@broadcom.com
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
 <20210419110156.1786882-7-kashyap.desai@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <1f03c0a0-e9a9-3782-3948-4a11ecb43826@suse.de>
Date:   Mon, 26 Apr 2021 18:05:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210419110156.1786882-7-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/19/21 1:01 PM, Kashyap Desai wrote:
> Firmware can report various MPI Events.
> Support for certain Events (as listed below) are enabled in the driver
> and their processing in driver is covered in this patch.
> 
> MPI3_EVENT_DEVICE_ADDED
> MPI3_EVENT_DEVICE_INFO_CHANGED
> MPI3_EVENT_DEVICE_STATUS_CHANGE
> MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE
> MPI3_EVENT_SAS_TOPOLOGY_CHANGE_LIST
> MPI3_EVENT_SAS_DISCOVERY
> MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR
> 
> Key support in this patch is device add/removal.
> 
> Fix some compilation warning reported by kernel test robot.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
> 
> Cc: sathya.prakash@broadcom.com
> ---
>  drivers/scsi/mpi3mr/mpi/mpi30_api.h  |    2 +
>  drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h | 2721 ++++++++++++++++++++++++++
>  drivers/scsi/mpi3mr/mpi/mpi30_sas.h  |   46 +
>  drivers/scsi/mpi3mr/mpi3mr.h         |  202 ++
>  drivers/scsi/mpi3mr/mpi3mr_fw.c      |  195 +-
>  drivers/scsi/mpi3mr/mpi3mr_os.c      | 1454 +++++++++++++-
>  6 files changed, 4618 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
>  create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_sas.h
> 
[ .. ]
> @@ -612,7 +1942,25 @@ static void mpi3mr_target_destroy(struct scsi_target *starget)
>   */
>  static int mpi3mr_slave_configure(struct scsi_device *sdev)
>  {
> +	struct scsi_target *starget;
> +	struct Scsi_Host *shost;
> +	struct mpi3mr_ioc *mrioc;
> +	struct mpi3mr_tgt_dev *tgt_dev;
> +	unsigned long flags;
>  	int retval = 0;
> +
> +	starget = scsi_target(sdev);
> +	shost = dev_to_shost(&starget->dev);
> +	mrioc = shost_priv(shost);
> +
> +	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> +	tgt_dev = __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
> +	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
> +	if (!tgt_dev)
> +		return retval;
> +

Return '0' on unknown SCSI devices? Really?

> +	mpi3mr_tgtdev_put(tgt_dev);
> +
>  	return retval;
>  }
>  
> @@ -626,7 +1974,37 @@ static int mpi3mr_slave_configure(struct scsi_device *sdev)
>   */
>  static int mpi3mr_slave_alloc(struct scsi_device *sdev)
>  {
> +	struct Scsi_Host *shost;
> +	struct mpi3mr_ioc *mrioc;
> +	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data;
> +	struct mpi3mr_tgt_dev *tgt_dev;
> +	struct mpi3mr_sdev_priv_data *scsi_dev_priv_data;
> +	unsigned long flags;
> +	struct scsi_target *starget;
>  	int retval = 0;
> +
> +	starget = scsi_target(sdev);
> +	shost = dev_to_shost(&starget->dev);
> +	mrioc = shost_priv(shost);
> +	scsi_tgt_priv_data = starget->hostdata;
> +
> +	scsi_dev_priv_data = kzalloc(sizeof(*scsi_dev_priv_data), GFP_KERNEL);
> +	if (!scsi_dev_priv_data)
> +		return -ENOMEM;
> +
> +	scsi_dev_priv_data->lun_id = sdev->lun;
> +	scsi_dev_priv_data->tgt_priv_data = scsi_tgt_priv_data;
> +	sdev->hostdata = scsi_dev_priv_data;
> +
> +	scsi_tgt_priv_data->num_luns++;
> +
> +	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> +	tgt_dev = __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
> +	if (tgt_dev && (tgt_dev->starget == NULL))
> +		tgt_dev->starget = starget;
> +	if (tgt_dev)
> +		mpi3mr_tgtdev_put(tgt_dev);
> +	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
>  	return retval;
>  }
>  
Same here. I would have expected -ENXIO to be returned fi the tgt_dev is
not found.
And you can fold the two 'if' clauses into one eg like:

if (tgt_dev) {
  if (tgt_dev->starget == NULL)
    tgt_dev = starget;
  mpi3mr_tgtdev_put(tgt_dev);
  retval = 0;
}

> @@ -640,7 +2018,33 @@ static int mpi3mr_slave_alloc(struct scsi_device *sdev)
>   */
>  static int mpi3mr_target_alloc(struct scsi_target *starget)
>  {
> +	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
> +	struct mpi3mr_ioc *mrioc = shost_priv(shost);
> +	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data;
> +	struct mpi3mr_tgt_dev *tgt_dev;
> +	unsigned long flags;
>  	int retval = -ENODEV;
> +
> +	scsi_tgt_priv_data = kzalloc(sizeof(*scsi_tgt_priv_data), GFP_KERNEL);
> +	if (!scsi_tgt_priv_data)
> +		return -ENOMEM;
> +
> +	starget->hostdata = scsi_tgt_priv_data;
> +	scsi_tgt_priv_data->starget = starget;
> +	scsi_tgt_priv_data->dev_handle = MPI3MR_INVALID_DEV_HANDLE;
> +
> +	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> +	tgt_dev = __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
> +	if (tgt_dev && !tgt_dev->is_hidden) {
> +		scsi_tgt_priv_data->dev_handle = tgt_dev->dev_handle;
> +		scsi_tgt_priv_data->perst_id = tgt_dev->perst_id;
> +		scsi_tgt_priv_data->dev_type = tgt_dev->dev_type;
> +		scsi_tgt_priv_data->tgt_dev = tgt_dev;
> +		tgt_dev->starget = starget;
> +		atomic_set(&scsi_tgt_priv_data->block_io, 0);
> +		retval = 0;
> +	}
> +	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
>  	return retval;
>  }
>  
Ah, here is the correct value set.
(But wasn't it ENXIO which should've been returned for unknown targets?)

> @@ -836,7 +2240,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  {
>  	struct mpi3mr_ioc *mrioc = NULL;
>  	struct Scsi_Host *shost = NULL;
> -	int retval = 0;
> +	int retval = 0, i;
>  
>  	shost = scsi_host_alloc(&mpi3mr_driver_template,
>  	    sizeof(struct mpi3mr_ioc));
> @@ -857,11 +2261,21 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	spin_lock_init(&mrioc->admin_req_lock);
>  	spin_lock_init(&mrioc->reply_free_queue_lock);
>  	spin_lock_init(&mrioc->sbq_lock);
> +	spin_lock_init(&mrioc->fwevt_lock);
> +	spin_lock_init(&mrioc->tgtdev_lock);
>  	spin_lock_init(&mrioc->watchdog_lock);
>  	spin_lock_init(&mrioc->chain_buf_lock);
>  
> +	INIT_LIST_HEAD(&mrioc->fwevt_list);
> +	INIT_LIST_HEAD(&mrioc->tgtdev_list);
> +	INIT_LIST_HEAD(&mrioc->delayed_rmhs_list);
> +
>  	mpi3mr_init_drv_cmd(&mrioc->init_cmds, MPI3MR_HOSTTAG_INITCMDS);
>  
> +	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++)
> +		mpi3mr_init_drv_cmd(&mrioc->dev_rmhs_cmds[i],
> +		    MPI3MR_HOSTTAG_DEVRMCMD_MIN + i);
> +
>  	if (pdev->revision)
>  		mrioc->enable_segqueue = true;
>  
> @@ -877,6 +2291,17 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	shost->max_channel = 1;
>  	shost->max_id = 0xFFFFFFFF;
>  
> +	snprintf(mrioc->fwevt_worker_name, sizeof(mrioc->fwevt_worker_name),
> +	    "%s%d_fwevt_wrkr", mrioc->driver_name, mrioc->id);
> +	mrioc->fwevt_worker_thread = alloc_ordered_workqueue(
> +	    mrioc->fwevt_worker_name, WQ_MEM_RECLAIM);
> +	if (!mrioc->fwevt_worker_thread) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		retval = -ENODEV;
> +		goto out_fwevtthread_failed;
> +	}
> +
>  	mrioc->is_driver_loading = 1;
>  	if (mpi3mr_init_ioc(mrioc)) {
>  		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> @@ -903,6 +2328,8 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  addhost_failed:
>  	mpi3mr_cleanup_ioc(mrioc);
>  out_iocinit_failed:
> +	destroy_workqueue(mrioc->fwevt_worker_thread);
> +out_fwevtthread_failed:
>  	spin_lock(&mrioc_list_lock);
>  	list_del(&mrioc->list);
>  	spin_unlock(&mrioc_list_lock);
> @@ -924,14 +2351,30 @@ static void mpi3mr_remove(struct pci_dev *pdev)
>  {
>  	struct Scsi_Host *shost = pci_get_drvdata(pdev);
>  	struct mpi3mr_ioc *mrioc;
> +	struct workqueue_struct	*wq;
> +	unsigned long flags;
> +	struct mpi3mr_tgt_dev *tgtdev, *tgtdev_next;
>  
>  	mrioc = shost_priv(shost);
>  	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
>  		ssleep(1);
>  
>  	mrioc->stop_drv_processing = 1;
> +	mpi3mr_cleanup_fwevt_list(mrioc);
> +	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
> +	wq = mrioc->fwevt_worker_thread;
> +	mrioc->fwevt_worker_thread = NULL;
> +	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
> +	if (wq)
> +		destroy_workqueue(wq);
>  
>  	scsi_remove_host(shost);
> +	list_for_each_entry_safe(tgtdev, tgtdev_next, &mrioc->tgtdev_list,
> +	    list) {
> +		mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
> +		mpi3mr_tgtdev_del_from_list(mrioc, tgtdev);
> +		mpi3mr_tgtdev_put(tgtdev);
> +	}
>  
>  	mpi3mr_cleanup_ioc(mrioc);
>  
> @@ -955,6 +2398,8 @@ static void mpi3mr_shutdown(struct pci_dev *pdev)
>  {
>  	struct Scsi_Host *shost = pci_get_drvdata(pdev);
>  	struct mpi3mr_ioc *mrioc;
> +	struct workqueue_struct	*wq;
> +	unsigned long flags;
>  
>  	if (!shost)
>  		return;
> @@ -963,6 +2408,13 @@ static void mpi3mr_shutdown(struct pci_dev *pdev)
>  	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
>  		ssleep(1);
>  	mrioc->stop_drv_processing = 1;
> +	mpi3mr_cleanup_fwevt_list(mrioc);
> +	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
> +	wq = mrioc->fwevt_worker_thread;
> +	mrioc->fwevt_worker_thread = NULL;
> +	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
> +	if (wq)
> +		destroy_workqueue(wq);
>  
>  	mpi3mr_cleanup_ioc(mrioc);
>  
> 
Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
