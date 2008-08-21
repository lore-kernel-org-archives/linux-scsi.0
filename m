From: Vladislav Bolkhovitin <vlad@vlnb.net>
Subject: Re: [PATCH 7/8] qla2xxx: Explicitly tear-down vports during PCI remove_one().
Date: Thu, 21 Aug 2008 15:16:04 +0400
Message-ID: <48AD4E74.1010303@vlnb.net>
References: <20080814043632.GL61889@plap4-2.local> <1218688622-71361-7-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:52349 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758829AbYHULjq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Aug 2008 07:39:46 -0400
In-Reply-To: <1218688622-71361-7-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Andrew Vasquez wrote:
> During internal testing, we've seen issues (hangs) with the
> 'deferred' vport tear-down-processing typically accompanied with
> the fc_remove_host() call.  This is due to the current
> implementation's back-end vport handling being performed by the
> physical-HA's DPC thread where premature shutdown could lead to
> latent vport requests without a processor.
> 
> This should also address a problem reported by Gal Rosen
> (http://marc.info/?l=linux-scsi&m=121731664417358&w=2) where the
> driver would attempt to awaken a previously torn-down DPC thread
> from interrupt context by implicitly calling wake_up_process()
> rather than the driver's qla2xxx_wake_dpc() helper.  Rather, than
> reshuffle the remove_one() device-removal code, during unload,
> depend on the driver's timer to wake-up the DPC process, by
> limiting wake-ups based on an 'unloading' flag.
> 
> Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_def.h |    1 +
>  drivers/scsi/qla2xxx/qla_mbx.c |    2 +-
>  drivers/scsi/qla2xxx/qla_os.c  |   13 ++++++++++---
>  3 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index 8c5b25c..431c19e 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -2236,6 +2236,7 @@ typedef struct scsi_qla_host {
>  #define REGISTER_FDMI_NEEDED	26
>  #define FCPORT_UPDATE_NEEDED	27
>  #define VP_DPC_NEEDED		28	/* wake up for VP dpc handling */
> +#define UNLOADING		29
>  
>  	uint32_t	device_flags;
>  #define DFLG_LOCAL_DEVICES		BIT_0
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index bc90d6b..813bc77 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -2686,7 +2686,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *ha,
>  		set_bit(VP_IDX_ACQUIRED, &vha->vp_flags);
>  		set_bit(VP_DPC_NEEDED, &ha->dpc_flags);
>  
> -		wake_up_process(ha->dpc_thread);
> +		qla2xxx_wake_dpc(ha);
>  	}
>  }
>  
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index e0880ad..26afe44 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1775,10 +1775,15 @@ probe_out:
>  static void
>  qla2x00_remove_one(struct pci_dev *pdev)
>  {
> -	scsi_qla_host_t *ha;
> +	scsi_qla_host_t *ha, *vha, *temp;
>  
>  	ha = pci_get_drvdata(pdev);
>  
> +	list_for_each_entry_safe(vha, temp, &ha->vp_list, vp_list)
> +		fc_vport_terminate(vha->fc_vport);
> +
> +	set_bit(UNLOADING, &ha->dpc_flags);
> +
>  	qla2x00_dfs_remove(ha);
>  
>  	qla84xx_put_chip(ha);
> @@ -2450,8 +2455,10 @@ qla2x00_do_dpc(void *data)
>  void
>  qla2xxx_wake_dpc(scsi_qla_host_t *ha)
>  {
> -	if (ha->dpc_thread)
> -		wake_up_process(ha->dpc_thread);
> +	struct task_struct *t = ha->dpc_thread;
> +
> +	if (!test_bit(UNLOADING, &ha->dpc_flags) && t)
> +		wake_up_process(t);
>  }

Sorry, but as I already pointed out, such approach doesn't fix anything, 
it only narrows down the race window. Increasing distance between "set" 
and "test" operations changes nothing, because in a kernel with 
preemption enabled preemption might happens in any place in the code, 
where it isn't explicitly or implicitly disabled. For instance, between 
lines

if (!test_bit(UNLOADING, &ha->dpc_flags) && t)

and

wake_up_process(t)

or inside wake_up_process(), so it would operate on already dead data 
pointed by t. I can see a lot of call trees where qla2xxx_wake_dpc() 
called with not disabled preemption, i.e. not from IRQ context and not 
under any lock (the driver doesn't explicitly disable preemption 
anywhere), for example on path 
qla2x00_do_dpc()->qla2x00_fabric_logout()->qla2x00_mailbox_command().

Also, I don't think anybody can predict on which maximum distance 
between code pieces side effects caused by CPU's out of order code 
execution can be seen.

If you want to make it better (but I'm not sure that complete), you 
should disable preemption in qla2xxx_wake_dpc() and insert memory 
barriers after setting UNLOADING bit and before testing it. But I 
wonder, how much advantage that would have over a simple spinlock as I 
proposed? The disadvantage can be seen pretty clearly: it's very 
non-obvious, hence quite hard to analyze and error prone to change.

Vlad

