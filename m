From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 06/11] mpt2sas: Convert to host_lock less w/ interrupts
 disabled externally
Date: Thu, 18 Nov 2010 12:15:20 +0200
Message-ID: <4CE4FCB8.20608@panasas.com>
References: <1290032349-4959-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:38795 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab0KRKP0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Nov 2010 05:15:26 -0500
In-Reply-To: <1290032349-4959-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Tejun Heo <tj@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>

On 11/18/2010 12:19 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch converts the mpt2sas driver to run in host_lock less mode
> with the new IRQ_DISABLE_SCSI_QCMD() that disables interrupts while
> calling ->queuecommand() dispatch
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> index 1a96a00..e564fe7 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -3304,7 +3304,7 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
>  }
>  
>  /**
> - * _scsih_qcmd - main scsi request entry point
> + * _scsih_qcmd_irq_disable - main scsi request entry point
>   * @scmd: pointer to scsi command object
>   * @done: function pointer to be invoked on completion
>   *
> @@ -3315,7 +3315,7 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
>   * SCSI_MLQUEUE_HOST_BUSY if the entire host queue is full
>   */
>  static int
> -_scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
> +_scsih_qcmd_irq_disable(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
>  {
>  	struct MPT2SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
>  	struct MPT2SAS_DEVICE *sas_device_priv_data;
> @@ -3441,7 +3441,7 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
>  	return SCSI_MLQUEUE_HOST_BUSY;
>  }
>  
> -static DEF_SCSI_QCMD(_scsih_qcmd)
> +static IRQ_DISABLE_SCSI_QCMD(_scsih_qcmd)
>  

How can this (and other in the patchset) can be correct? I mean I expect
that if you remove the lock,xx_qcmd_lck,unlock then inside the xx_qcmd_lck
there was an unlock,do123,lock and that driver was effectively running lockless
before. (like in iscsi). But here this is new behaviour. If it is correct
I would like to see a statement from you that:
	"I have audited this driver, and all shared resources are protected by
         XYZ so ..."

Otherwise how can I know this is correct? I have never audited this driver myself

Thanks
Boaz

>  /**
>   * _scsih_normalize_sense - normalize descriptor and fixed format sense data

