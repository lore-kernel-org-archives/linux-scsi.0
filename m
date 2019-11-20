Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08C77C432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 09:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC94622440
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 09:55:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbfKTJz6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 04:55:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:58002 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728320AbfKTJzy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Nov 2019 04:55:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 369C46998A;
        Wed, 20 Nov 2019 09:55:51 +0000 (UTC)
Subject: Re: [PATCH 2/4] scsi: mpt3sas: use private counter for tracking
 inflight per-LUN commands
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
References: <20191118103117.978-1-ming.lei@redhat.com>
 <20191118103117.978-3-ming.lei@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <3bce6271-1f6e-355c-f8ac-378904d4fbe2@suse.de>
Date:   Wed, 20 Nov 2019 10:55:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191118103117.978-3-ming.lei@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/18/19 11:31 AM, Ming Lei wrote:
> Prepare for bypassing sdev->device_busy for improving performance on
> fast SCSI storage device, so sdev->device_busy can't be relied
> any more.
> 
> mpt3sas may need one such counter for balancing load among LUNs in
> some specific setting, so add one private counter for this purpose.
> 
> Cc: Sathya Prakash <sathya.prakash@broadcom.com>
> Cc: Chaitra P B <chaitra.basappa@broadcom.com>
> Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Sumit Saxena <sumit.saxena@broadcom.com>
> Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>,
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Bart Van Assche <bart.vanassche@wdc.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c  |  3 ++-
>  drivers/scsi/mpt3sas/mpt3sas_base.h  |  1 +
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 15 +++++++++++++--
>  3 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index fea3cb6a090b..9c2d374b3157 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -3480,12 +3480,13 @@ static inline u8
>  _base_get_high_iops_msix_index(struct MPT3SAS_ADAPTER *ioc,
>  	struct scsi_cmnd *scmd)
>  {
> +	struct MPT3SAS_DEVICE *sas_device_priv_data = scmd->device->hostdata;
>  	/**
>  	 * Round robin the IO interrupts among the high iops
>  	 * reply queues in terms of batch count 16 when outstanding
>  	 * IOs on the target device is >=8.
>  	 */
> -	if (atomic_read(&scmd->device->device_busy) >
> +	if (atomic_read(&sas_device_priv_data->active_cmds) >
>  	    MPT3SAS_DEVICE_HIGH_IOPS_DEPTH)
>  		return base_mod64((
>  		    atomic64_add_return(1, &ioc->high_iops_outstanding) /
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
> index faca0a5e71f8..9e9f319bb636 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -467,6 +467,7 @@ struct MPT3SAS_DEVICE {
>  	 * thing while a SATL command is pending.
>  	 */
>  	unsigned long ata_command_pending;
> +	atomic_t active_cmds;
>  
>  };
>  
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index c8e512ba6d39..194960dae1d6 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -1770,6 +1770,7 @@ scsih_slave_alloc(struct scsi_device *sdev)
>  
>  	sas_device_priv_data->lun = sdev->lun;
>  	sas_device_priv_data->flags = MPT_DEVICE_FLAGS_INIT;
> +	atomic_set(&sas_device_priv_data->active_cmds, 0);
>  
>  	starget = scsi_target(sdev);
>  	sas_target_priv_data = starget->hostdata;
> @@ -2884,6 +2885,7 @@ scsih_abort(struct scsi_cmnd *scmd)
>  	    ioc->remove_host) {
>  		sdev_printk(KERN_INFO, scmd->device,
>  			"device been deleted! scmd(%p)\n", scmd);
> +		atomic_dec(&sas_device_priv_data->active_cmds);
>  		scmd->result = DID_NO_CONNECT << 16;
>  		scmd->scsi_done(scmd);
>  		r = SUCCESS;
> @@ -2993,7 +2995,7 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
>  		MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, 0, 0,
>  		tr_timeout, tr_method);
>  	/* Check for busy commands after reset */
> -	if (r == SUCCESS && atomic_read(&scmd->device->device_busy))
> +	if (r == SUCCESS && atomic_read(&sas_device_priv_data->active_cmds))
>  		r = FAILED;
>   out:
>  	sdev_printk(KERN_INFO, scmd->device, "device reset: %s scmd(%p)\n",
> @@ -4517,9 +4519,12 @@ _scsih_flush_running_cmds(struct MPT3SAS_ADAPTER *ioc)
>  	int count = 0;
>  
>  	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
> +		struct MPT3SAS_DEVICE *sas_device_priv_data;
> +
>  		scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
>  		if (!scmd)
>  			continue;
> +		sas_device_priv_data = scmd->device->hostdata;
>  		count++;
>  		_scsih_set_satl_pending(scmd, false);
>  		st = scsi_cmd_priv(scmd);
> @@ -4529,6 +4534,7 @@ _scsih_flush_running_cmds(struct MPT3SAS_ADAPTER *ioc)
>  			scmd->result = DID_NO_CONNECT << 16;
>  		else
>  			scmd->result = DID_RESET << 16;
> +		atomic_dec(&sas_device_priv_data->active_cmds);
>  		scmd->scsi_done(scmd);
>  	}
>  	dtmprintk(ioc, ioc_info(ioc, "completing %d cmds\n", count));
> @@ -4756,11 +4762,14 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
>  	    mpi_request->LUN);
>  	memcpy(mpi_request->CDB.CDB32, scmd->cmnd, scmd->cmd_len);
>  
> +	atomic_inc(&sas_device_priv_data->active_cmds);
> +
>  	if (mpi_request->DataLength) {
>  		pcie_device = sas_target_priv_data->pcie_dev;
>  		if (ioc->build_sg_scmd(ioc, scmd, smid, pcie_device)) {
>  			mpt3sas_base_free_smid(ioc, smid);
>  			_scsih_set_satl_pending(scmd, false);
> +			atomic_dec(&sas_device_priv_data->active_cmds);
>  			goto out;
>  		}
>  	} else
> @@ -5207,6 +5216,7 @@ _scsih_smart_predicted_fault(struct MPT3SAS_ADAPTER *ioc, u16 handle)
>  static u8
>  _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
>  {
> +	struct MPT3SAS_DEVICE *sas_device_priv_data;
>  	Mpi25SCSIIORequest_t *mpi_request;
>  	Mpi2SCSIIOReply_t *mpi_reply;
>  	struct scsi_cmnd *scmd;
> @@ -5216,7 +5226,6 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
>  	u8 scsi_state;
>  	u8 scsi_status;
>  	u32 log_info;
> -	struct MPT3SAS_DEVICE *sas_device_priv_data;
>  	u32 response_code = 0;
>  
>  	mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);

The above two modifications are probably not needed ...

> @@ -5225,6 +5234,7 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
>  	if (scmd == NULL)
>  		return 1;
>  
> +	sas_device_priv_data = scmd->device->hostdata;
>  	_scsih_set_satl_pending(scmd, false);
>  
>  	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
> @@ -5431,6 +5441,7 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
>  
>  	scsi_dma_unmap(scmd);
>  	mpt3sas_base_free_smid(ioc, smid);
> +	atomic_dec(&sas_device_priv_data->active_cmds);
>  	scmd->scsi_done(scmd);
>  	return 0;
>  }
> 
Otherwise:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 247165 (AG München), GF: Felix Imendörffer
