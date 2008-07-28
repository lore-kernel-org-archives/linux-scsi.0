From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] qla2xxx: Fix dpc_thread race on the module unload
Date: Mon, 28 Jul 2008 11:07:45 -0700
Message-ID: <20080728180745.GE12762@plap4-2.qlogic.org>
References: <488E02DE.5080100@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:28409 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757600AbYG1SHq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jul 2008 14:07:46 -0400
Content-Disposition: inline
In-Reply-To: <488E02DE.5080100@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-driver@qlogic.com, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net

On Mon, 28 Jul 2008, Vladislav Bolkhovitin wrote:

> This patch fixes race on dpc_thread field of struct scsi_qla_host,
> which can lead to crash on the module unload.
> 
> This patch is against 2.6.26
> 
> Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
> 
>  qla_def.h |    1 +
>  qla_mbx.c |    2 +-
>  qla_os.c  |   36 ++++++++++++++++++++++++++----------
>  3 files changed, 28 insertions(+), 11 deletions(-)
> 
> diff -upr linux-2.6.26/drivers/scsi/qla2xxx/qla_def.h linux-2.6.26/drivers/scsi/qla2xxx/qla_def.h
> --- linux-2.6.26/drivers/scsi/qla2xxx/qla_def.h	2008-07-14 01:51:29.000000000 +0400
> +++ linux-2.6.26/drivers/scsi/qla2xxx/qla_def.h	2008-07-24 10:07:39.000000000 +0400
> @@ -2425,6 +2436,7 @@ typedef struct scsi_qla_host {
>  	void			*sfp_data;
>  	dma_addr_t		sfp_data_dma;
>  
> +	spinlock_t		dpc_lock;

As James mentioned in another email, there's something else going on
with qla2xxx shutdown process which should be addressed...

>  	struct task_struct	*dpc_thread;
>  	uint8_t dpc_active;                  /* DPC routine is active */
>  
> diff -upr linux-2.6.26/drivers/scsi/qla2xxx/qla_mbx.c linux-2.6.26/drivers/scsi/qla2xxx/qla_mbx.c
> --- linux-2.6.26/drivers/scsi/qla2xxx/qla_mbx.c	2008-07-14 01:51:29.000000000 +0400
> +++ linux-2.6.26/drivers/scsi/qla2xxx/qla_mbx.c	2008-07-23 19:27:20.000000000 +0400
> @@ -2683,7 +2687,7 @@ qla24xx_report_id_acquisition(scsi_qla_h
>  		set_bit(VP_IDX_ACQUIRED, &vha->vp_flags);
>  		set_bit(VP_DPC_NEEDED, &ha->dpc_flags);
>  
> -		wake_up_process(ha->dpc_thread);
> +		qla2xxx_wake_dpc(ha);

Ok, your change looks correct here...  This is defintely the correct
way the qla24xx_report_id_acquisition() routine should be triggering
the DPC thread.

I'm guessing the backtrace in "Gal Rosen's" report pointed to
qla24xx_report_id_acquisition()?  If, so, I'm not entirely sure we
need anything more to 'protect' tear-down...
