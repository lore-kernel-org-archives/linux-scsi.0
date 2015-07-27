From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 2/8] qla2xxx: cleanup cmd in qla workqueue before processing
 TMR
Date: Mon, 27 Jul 2015 10:11:48 +0200
Message-ID: <55B5E7C4.7090401@suse.de>
References: <1436904049-27707-1-git-send-email-himanshu.madhani@qlogic.com> <1436904049-27707-3-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbbG0ILu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jul 2015 04:11:50 -0400
In-Reply-To: <1436904049-27707-3-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 07/14/2015 10:00 PM, Himanshu Madhani wrote:
> From: Swapnil Nagle <swapnil.nagle@purestorage.com>
>=20
> Since cmds go into qla_tgt_wq and TMRs don't, it's possible that TMR
> like TASK_ABORT can be queued over the cmd for which it was meant.
> To avoid this race, use a per-port list to keep track of cmds that
> are enqueued to qla_tgt_wq but not yet processed. When a TMR arrives,
> iterate through this list and remove any cmds that match the TMR.
> This patch supports TASK_ABORT and LUN_RESET.
>=20
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Swapnil Nagle <swapnil.nagle@purestorage.com>
> Signed-off-by: Alexei Potashnik <alexei@purestorage.com>
> Acked-by: Quinn Tran <quinn.tran@qlogic.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
[ .. ]
> @@ -3374,14 +3462,25 @@ static void qlt_create_sess_from_atio(struct =
work_struct *work)
>  	unsigned long flags;
>  	uint8_t *s_id =3D op->atio.u.isp24.fcp_hdr.s_id;
> =20
> +	spin_lock_irqsave(&vha->cmd_list_lock, flags);
> +	list_del(&op->cmd_list);
> +	spin_unlock_irqrestore(&vha->cmd_list_lock, flags);
> +
> +	if (op->aborted) {
> +		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf083,
> +		    "sess_op with tag %u is aborted\n",
> +		    op->atio.u.isp24.exchange_addr);
> +		goto out_term;
> +	}
> +
>  	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf022,
> -		"qla_target(%d): Unable to find wwn login"
> -		" (s_id %x:%x:%x), trying to create it manually\n",
> -		vha->vp_idx, s_id[0], s_id[1], s_id[2]);
> +	    "qla_target(%d): Unable to find wwn login"
> +	    " (s_id %x:%x:%x), trying to create it manually\n",
> +	    vha->vp_idx, s_id[0], s_id[1], s_id[2]);
> =20
>  	if (op->atio.u.raw.entry_count > 1) {
>  		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf023,
> -		        "Dropping multy entry atio %p\n", &op->atio);
> +		    "Dropping multy entry atio %p\n", &op->atio);
>  		goto out_term;
>  	}
> =20
Pointless indentation change.

Other than that:
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes

--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
