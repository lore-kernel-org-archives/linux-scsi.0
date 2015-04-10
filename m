From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/14] qla2xxx: Add udev notification to save fw dump
 for ISP27XX
Date: Fri, 10 Apr 2015 08:35:18 +0200
Message-ID: <55276F26.4040204@suse.de>
References: <1428606008-14976-1-git-send-email-himanshu.madhani@qlogic.com> <1428606008-14976-8-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60419 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755176AbbDJGfT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Apr 2015 02:35:19 -0400
In-Reply-To: <1428606008-14976-8-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On 04/09/2015 09:00 PM, Himanshu Madhani wrote:
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_tmpl.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/q=
la_tmpl.c
> index 1437fce..7f67fb2 100644
> --- a/drivers/scsi/qla2xxx/qla_tmpl.c
> +++ b/drivers/scsi/qla2xxx/qla_tmpl.c
> @@ -787,11 +787,12 @@ qla27xx_walk_template(struct scsi_qla_host *vha=
,
>  	ql_dbg(ql_dbg_misc, vha, 0xd01b,
>  	    "%s: len=3D%lx\n", __func__, *len);
> =20
> -	if (buf)
> +	if (buf) {
>  		ql_log(ql_log_warn, vha, 0xd015,
>  		    "Firmware dump saved to temp buffer (%ld/%p)\n",
>  		    vha->host_no, vha->hw->fw_dump);
> -
> +		qla2x00_post_uevent_work(vha, QLA_UEVENT_CODE_FW_DUMP);
> +	}
>  }
> =20
>  static void
>=20
Hmm? Isn't that the same as in the previous patch?

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
