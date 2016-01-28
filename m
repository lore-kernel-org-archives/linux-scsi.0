From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 03/11] qla2xxx: Allow fw to hold status before sending
 ABTS response.
Date: Thu, 28 Jan 2016 09:35:37 +0100
Message-ID: <20160128083537.GH27565@c203.arch.suse.de>
References: <1453914218-380-1-git-send-email-himanshu.madhani@qlogic.com>
 <1453914218-380-4-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686AbcA1Ifm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jan 2016 03:35:42 -0500
Content-Disposition: inline
In-Reply-To: <1453914218-380-4-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On Wed, Jan 27, 2016 at 12:03:30PM -0500, Himanshu Madhani wrote:
> Set bit 12 of additional firmware options 3 to let firmware
> hold status IOCB until ABTS response is received from Target.
>=20
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_gbl.h  |    1 +
>  drivers/scsi/qla2xxx/qla_init.c |   11 ++++++++++-
>  drivers/scsi/qla2xxx/qla_os.c   |    7 +++++++
>  3 files changed, 18 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/ql=
a_gbl.h
> index 0103e46..1bfdcdf 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -121,6 +121,7 @@ extern int ql2xmdcapmask;
>  extern int ql2xmdenable;
>  extern int ql2xexlogins;
>  extern int ql2xexchoffld;
> +extern int ql2xfwholdabts;
> =20
>  extern int qla2x00_loop_reset(scsi_qla_host_t *);
>  extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/q=
la_init.c
> index a663ff6..cf487b9 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -2062,6 +2062,10 @@ qla24xx_update_fw_options(scsi_qla_host_t *vha=
)
>  	if (IS_P3P_TYPE(ha))
>  		return;
> =20
> +	/*  Hold status IOCBs until ABTS response received. */
> +	if (ql2xfwholdabts)
> +		ha->fw_options[3] |=3D BIT_12;
> +
>  	/* Update Serial Link options. */
>  	if ((le16_to_cpu(ha->fw_seriallink_options24[0]) & BIT_0) =3D=3D 0)
>  		return;
> @@ -6410,12 +6414,17 @@ qla81xx_update_fw_options(scsi_qla_host_t *vh=
a)
>  {
>  	struct qla_hw_data *ha =3D vha->hw;
> =20
> +	/*  Hold status IOCBs until ABTS response received. */
> +	if (ql2xfwholdabts)
> +		ha->fw_options[3] |=3D BIT_12;
> +
>  	if (!ql2xetsenable)
> -		return;
> +		goto out;
> =20
>  	/* Enable ETS Burst. */
>  	memset(ha->fw_options, 0, sizeof(ha->fw_options));
>  	ha->fw_options[2] |=3D BIT_9;
> +out:
>  	qla2x00_set_fw_options(vha, ha->fw_options);
>  }
> =20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla=
_os.c
> index f1788db..d94a236 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -233,6 +233,13 @@ MODULE_PARM_DESC(ql2xexchoffld,
>  		 "Number of exchanges to offload. "
>  		 "0 (Default)- Disabled.");
> =20
> +int ql2xfwholdabts =3D 0;
> +module_param(ql2xfwholdabts, int, S_IRUGO);
> +MODULE_PARM_DESC(ql2xfwholdabts,
> +		"Allow FW to hold status IOCB until ABTS rsp received. "
> +		"0 (Default) Do not set fw option. "
> +		"1 - Set fw option to hold ABTS.");
> +
>  /*
>   * SCSI host template entry points
>   */
> --=20
> 1.7.7
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
