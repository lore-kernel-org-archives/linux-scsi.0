From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/17] lpfc: Fix crash in fcp command completion path.
Date: Thu, 17 Dec 2015 09:18:43 +0100
Message-ID: <56726FE3.4030802@suse.de>
References: <5671efbd.clWBAkJdlw7R8CdX%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771AbbLQISo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Dec 2015 03:18:44 -0500
In-Reply-To: <5671efbd.clWBAkJdlw7R8CdX%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 12/17/2015 12:11 AM, James Smart wrote:
>
> Fix crash in fcp command completion path.
>
> Missed null check.
>
> Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>   drivers/scsi/lpfc/lpfc_scsi.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_s=
csi.c
> index d51f751..3162469 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -3908,9 +3908,9 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, =
struct lpfc_iocbq *pIocbIn,
>   	uint32_t logit =3D LOG_FCP;
>
>   	/* Sanity check on return of outstanding command */
> -	if (!(lpfc_cmd->pCmd))
> -		return;
>   	cmd =3D lpfc_cmd->pCmd;
> +	if (!cmd)
> +		return;
>   	shost =3D cmd->device->host;
>
>   	lpfc_cmd->result =3D (pIocbOut->iocb.un.ulpWord[4] & IOERR_PARAM_M=
ASK);
>
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
