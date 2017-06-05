From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 2/3] target: Add TARGET_SCF_LOOKUP_LUN_FROM_TAG support
 for ABORT_TASK
Date: Mon, 5 Jun 2017 15:57:30 +0000
Message-ID: <1496678246.2623.5.camel@sandisk.com>
References: <1496527808-28789-1-git-send-email-nab@linux-iscsi.org>
         <1496527808-28789-3-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:52342 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751077AbdFEP5d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2017 11:57:33 -0400
In-Reply-To: <1496527808-28789-3-git-send-email-nab@linux-iscsi.org>
Content-Language: en-US
Content-ID: <062FB2E66570AE488DA94364C5B48DDE@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mchristi@redhat.com" <mchristi@redhat.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "quinn.tran@cavium.com" <quinn.tran@cavium.com>, "hare@suse.com" <hare@suse.com>, "hch@lst.de" <hch@lst.de>

On Sat, 2017-06-03 at 22:10 +0000, Nicholas A. Bellinger wrote:
> +static bool target_lookup_lun_from_tag(struct se_session *se_sess, u64 t=
ag,
> +				       u64 *unpacked_lun)
> +{
> +	struct se_cmd *se_cmd;
> +	unsigned long flags;
> +	bool ret =3D false;
> +
> +	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
> +	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
> +		if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
> +			continue;
> +
> +		if (se_cmd->tag =3D=3D tag) {
> +			*unpacked_lun =3D se_cmd->orig_fe_lun;
> +			ret =3D true;
> +			break;
> +		}
> +	}
> +	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
> +
> +	return ret;
> +}
> +
>  /**
>   * target_submit_tmr - lookup unpacked lun and submit uninitialized se_c=
md
>   *                     for TMR CDBs
> @@ -1639,19 +1662,31 @@ int target_submit_tmr(struct se_cmd *se_cmd, stru=
ct se_session *se_sess,
>  		core_tmr_release_req(se_cmd->se_tmr_req);
>  		return ret;
>  	}
> +	/*
> +	 * If this is ABORT_TASK with no explicit fabric provided LUN,
> +	 * go ahead and search active session tags for a match to figure
> +	 * out unpacked_lun for the original se_cmd.
> +	 */
> +	if (tm_type =3D=3D TMR_ABORT_TASK && (flags & TARGET_SCF_LOOKUP_LUN_FRO=
M_TAG)) {
> +		if (!target_lookup_lun_from_tag(se_sess, tag, &unpacked_lun))
> +			goto failure;
> +	}
> =20
>  	ret =3D transport_lookup_tmr_lun(se_cmd, unpacked_lun);
> -	if (ret) {
> -		/*
> -		 * For callback during failure handling, push this work off
> -		 * to process context with TMR_LUN_DOES_NOT_EXIST status.
> -		 */
> -		INIT_WORK(&se_cmd->work, target_complete_tmr_failure);
> -		schedule_work(&se_cmd->work);
> -		return 0;
> -	}
> +	if (ret)
> +		goto failure;
> +
>  	transport_generic_handle_tmr(se_cmd);
>  	return 0;

Hello Nic,

So after LUN lookup has finished sess_cmd_lock lock is dropped, a context
switch occurs due to the queue_work() call in transport_generic_handle_tmr(=
)
and next core_tmr_abort_task() reacquires that lock? Sorry but I'm afraid
that if after that lock is dropped and before it is reacquired a command
finishes and the initiator reuses the same tag for another command for the
same LUN that this may result in the wrong command being aborted.

Bart.=
