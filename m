From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] [RESEND] qla2xxx: fix potential deadlock on
 ha->hardware_lock
Date: Tue, 09 Oct 2012 11:47:47 -0700
Message-ID: <1349808467.3776.48.camel@haakon2.linux-iscsi.org>
References: <506D80C2.5040405@linux.vnet.ibm.com>
	 <alpine.LNX.2.00.1210041500010.9942@pobox.suse.cz>
	 <alpine.LNX.2.00.1210080922250.28357@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1210080922250.28357@pobox.suse.cz>
Sender: target-devel-owner@vger.kernel.org
To: Jiri Kosina <jkosina@suse.cz>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-driver@qlogic.com, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, target-devel <target-devel@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Arun Easi <arun.easi@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

Hi Jiri, Andrew, Arun & Co,

On Mon, 2012-10-08 at 09:23 +0200, Jiri Kosina wrote:
> Lockdep reports:
> 
> === [ cut here ] ===
>  =========================================================
>  [ INFO: possible irq lock inversion dependency detected ]
>  3.6.0-0.0.0.28.36b5ec9-default #1 Not tainted
>  ---------------------------------------------------------
>  qla2xxx_1_dpc/368 just changed the state of lock:
>   (&(&ha->vport_slock)->rlock){+.....}, at: [<ffffffffa009b377>] qla2x00_configure_hba+0x197/0x3c0 [qla2xxx]
>  but this lock was taken by another, HARDIRQ-safe lock in the past:
>   (&(&ha->hardware_lock)->rlock){-.....}
> 
> and interrupts could create inverse lock ordering between them.
> 
> other info that might help us debug this:
>  Possible interrupt unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&(&ha->vport_slock)->rlock);
>                                local_irq_disable();
>                                lock(&(&ha->hardware_lock)->rlock);
>                                lock(&(&ha->vport_slock)->rlock);
>   <Interrupt>
>     lock(&(&ha->hardware_lock)->rlock);
> === [ cut here ] ===
> 
> Fix the potential deadlock by disabling IRQs while holding ha->vport_slock.
> 
> Reported-and-tested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---

I'm fine with this patch and have applied to target-pending/queue for
the moment.

It will be moved into /master + included in the next PULL request once
Linus merges the outstanding /for-next series into -rc0 code.

Also please have a look below for a few more related items I noticed
while reviewing this patch..

>  drivers/scsi/qla2xxx/qla_init.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 799a58b..48fca47 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -2080,6 +2080,7 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
>  	uint8_t       domain;
>  	char		connect_type[22];
>  	struct qla_hw_data *ha = vha->hw;
> +	unsigned long flags;
>  
>  	/* Get host addresses. */
>  	rval = qla2x00_get_adapter_id(vha,
> @@ -2154,9 +2155,9 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
>  	vha->d_id.b.area = area;
>  	vha->d_id.b.al_pa = al_pa;
>  
> -	spin_lock(&ha->vport_slock);
> +	spin_lock_irqsave(&ha->vport_slock, flags);
>  	qlt_update_vp_map(vha, SET_AL_PA);
> -	spin_unlock(&ha->vport_slock);
> +	spin_unlock_irqrestore(&ha->vport_slock, flags);
>  
>  	if (!vha->flags.init_done)
>  		ql_log(ql_log_info, vha, 0x2010,
> 

So while looking at other ->vport_slock + qlt_update_vp_map() usage, two
more items caught my eye:

In qla_mid.c:qla24xx_disable_vp() code:

        ret = qla24xx_control_vp(vha, VCE_COMMAND_DISABLE_VPS_LOGO_ALL);
        atomic_set(&vha->loop_state, LOOP_DOWN);
        atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
 
        /* Remove port id from vp target map */
        qlt_update_vp_map(vha, RESET_AL_PA);
 
        qla2x00_mark_vp_devices_dead(vha);
        atomic_set(&vha->vp_state, VP_FAILED);

AFAICT all callers of qlt_update_vp_map() into qla_target.c code should
be holding ->vport_slock.  I'll send out a separate patch for this
shortly.

And in qla_init.c:qla2x00_init_rings() code:

        for (que = 0; que < ha->max_rsp_queues; que++) {
                rsp = ha->rsp_q_map[que];
                if (!rsp)
                        continue;
                /* Initialize response queue entries */
                qla2x00_init_response_q_entries(rsp);
        }

        spin_lock(&ha->vport_slock);

        spin_unlock(&ha->vport_slock);

        ha->tgt.atio_ring_ptr = ha->tgt.atio_ring;
        ha->tgt.atio_ring_index = 0;
        /* Initialize ATIO queue entries */
        qlt_init_atio_q_entries(vha);

The usage of ->vport_slock seems to be now either unnecessary, or a
result of some bad merge outside of qla2xxx target mode. 

Qlogic folks, can this (leftover..?) usage of ->vport_slock now be
safety removed..?

--nab
