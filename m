From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/20] qla2xxx: Change check_stop_free to always return 1
Date: Wed, 9 Dec 2015 07:56:18 +0100
Message-ID: <5667D092.1030701@suse.de>
References: <1449535747-2850-1-git-send-email-himanshu.madhani@qlogic.com>
 <1449535747-2850-10-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52730 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbbLIG4V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Dec 2015 01:56:21 -0500
In-Reply-To: <1449535747-2850-10-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On 12/08/2015 01:48 AM, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@qlogic.com>
>=20
> change tcm_qla2xxx_check_stop_free to always return 1
> to prevent transport_cmd_finish_abort from accidently
> taking extra kref_put.
>=20
> Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xx=
x/tcm_qla2xxx.c
> index 74c6e9b..366142a 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -314,7 +314,8 @@ static int tcm_qla2xxx_check_stop_free(struct se_=
cmd *se_cmd)
>  		cmd->cmd_flags |=3D BIT_14;
>  	}
> =20
> -	return target_put_sess_cmd(se_cmd);
> +	target_put_sess_cmd(se_cmd);
> +	return 1;
>  }
> =20
>  /* tcm_qla2xxx_release_cmd - Callback from TCM Core to release under=
lying
>=20
Odd. I would have expected target_put_sess_cmd() to never fail.
But if it does, doesn't it mean that the command is hosed, and we shoul=
d
have accessed it in the first place?
Very suspicious.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
