From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 16/22] qla2xxx: Improve RSCN handling in driver
Date: Wed, 7 Dec 2016 12:32:29 +0100
Message-ID: <0e7c68c9-1ab5-bd55-2a63-3da1cba1810e@suse.com>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
 <1481056251-2310-17-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1481056251-2310-17-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/06/2016 09:30 PM, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> - Save NPort ID early in link init.
> - Add session deletion for TPRLO and send acknowledgement for TPRLO.
> - Enable FW option to move ABTS, RIDA & PUREX from RSPQ
>   to ATIOQ.
> - Move ABTS & RIDA to ATIOQ helps in keeping command ordering and
>   link up sequence ordering.
> - Save Nport ID and update VP map so that SCSI CMD/ATIO
>   won't be dropped.
> - fcport alloc does the initializes memory to zero. Remove
>   memset to zero since It migth corrupt link list.
> - Turn off Registration for State Change MB in loop mode.
> 
> Current code blindly do State Change Registration when
> the link is up. Move SCR behind fabric scan, so AL case
> would not get erroneous error message.
> 
> Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_def.h    |  12 +-
>  drivers/scsi/qla2xxx/qla_fw.h     |  59 +++++++---
>  drivers/scsi/qla2xxx/qla_gbl.h    |   2 +
>  drivers/scsi/qla2xxx/qla_gs.c     |   4 +-
>  drivers/scsi/qla2xxx/qla_init.c   | 150 ++++++++++++++++++++----
>  drivers/scsi/qla2xxx/qla_isr.c    |   6 +-
>  drivers/scsi/qla2xxx/qla_mbx.c    | 123 ++++++++++++--------
>  drivers/scsi/qla2xxx/qla_os.c     |  48 ++++----
>  drivers/scsi/qla2xxx/qla_target.c | 237 ++++++++++++++++++++++++++++++++++----
>  9 files changed, 501 insertions(+), 140 deletions(-)
> 
[ .. ]
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index 44be150..3caaf06 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -3655,78 +3656,106 @@ struct tsk_mgmt_cmd {
[ .. ]
> -		/* FA-WWN is only for physical port */
> -		if (!vp_idx) {
> -			void *wwpn = ha->init_cb->port_name;
> +		if (rptid_entry->vp_idx == 0) {
> +			if (rptid_entry->vp_status == VP_STAT_COMPL) {
>  
> -			if (!MSB(stat)) {
> -				if (rptid_entry->vp_idx_map[1] & BIT_6)
> -					wwpn = rptid_entry->reserved_4 + 8;
> +#if 0
> +				/* FA-WWN is only for physical port */
> +
> +				/* To Do: For Target Mode, changing WWPN during
> +				 * runtime cause Target un-config problem.  The FA-WWN
> +				 * should be saved in separate field.
> +				 */
> +				if (rptid_entry->u.f1.flags & VP_FLAGS_NAME_VALID) {
> +					memcpy(vha->port_name, rptid_entry->u.f1.port_name,
> +						   WWN_SIZE);
> +				}
> +#endif
> +
> +				vha->d_id.b.domain = rptid_entry->port_id[2];
> +				vha->d_id.b.area = rptid_entry->port_id[1];
> +				vha->d_id.b.al_pa = rptid_entry->port_id[0];
> +				spin_lock_irqsave(&ha->vport_slock, flags);
> +				qlt_update_vp_map(vha, SET_AL_PA);
> +				spin_unlock_irqrestore(&ha->vport_slock, flags);
>  			}
> -			memcpy(vha->port_name, wwpn, WWN_SIZE);
> +

This is a bit odd.
If you already have code for fixing the to-do, why is the to-do there?
And if the code doesn't work, what's the point of including it here?

I would suggest removing the code; the comment should be giving enough
of a hint of what needs to be implemented.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
