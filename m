From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] mpt2sas: Remove queuecommand wrapper
Date: Tue, 5 Jul 2011 10:16:25 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED70157FE25D8@inbmail01.lsi.com>
References: <20110704192713.GZ4061@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:58269 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752449Ab1GEEqd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Jul 2011 00:46:33 -0400
In-Reply-To: <20110704192713.GZ4061@linux.intel.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>

Matthew, I am fine with the patch, but just wanted to double check we do have included  changes related to below conversation.
Mpt2sas and mptsas driver wants IRQ and preemption disable when it enter in to qcmd callback.

http://140.211.166.79/mailarchive/linux-scsi/2010/12/23/6887919

~ Kashyap

> -----Original Message-----
> From: Matthew Wilcox [mailto:willy@linux.intel.com]
> Sent: Tuesday, July 05, 2011 12:57 AM
> To: linux-scsi@vger.kernel.org
> Cc: DL-MPT Fusion Linux
> Subject: [PATCH] mpt2sas: Remove queuecommand wrapper
> 
> 
> Now that mpt2sas no longer uses the serial_number, we can remove the
> wrapper that acquires the host_lock around queuecommand.  This is the
> most contended lock for one benchmark, and on a 8-socket machine this
> patch leads to a 70% application-level improvement.
> 
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> index a7dbc68..67708b3 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -3680,9 +3680,9 @@ _scsih_setup_direct_io(struct MPT2SAS_ADAPTER
> *ioc, struct scsi_cmnd *scmd,
>   * SCSI_MLQUEUE_HOST_BUSY if the entire host queue is full
>   */
>  static int
> -_scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd
> *))
> +_scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
>  {
> -	struct MPT2SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
> +	struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
>  	struct MPT2SAS_DEVICE *sas_device_priv_data;
>  	struct MPT2SAS_TARGET *sas_target_priv_data;
>  	struct _raid_device *raid_device;
> @@ -3690,7 +3690,6 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void
> (*done)(struct scsi_cmnd *))
>  	u32 mpi_control;
>  	u16 smid;
> 
> -	scmd->scsi_done = done;
>  	sas_device_priv_data = scmd->device->hostdata;
>  	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
>  		scmd->result = DID_NO_CONNECT << 16;
> @@ -3814,8 +3813,6 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void
> (*done)(struct scsi_cmnd *))
>  	return SCSI_MLQUEUE_HOST_BUSY;
>  }
> 
> -static DEF_SCSI_QCMD(_scsih_qcmd)
> -
>  /**
>   * _scsih_normalize_sense - normalize descriptor and fixed format sense
> data
>   * @sense_buffer: sense data returned by target
