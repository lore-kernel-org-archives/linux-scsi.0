From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 06/20] [SCSI] mpt3sas: Provides the physical location of
 sas drives
Date: Fri, 19 Jun 2015 11:19:46 +0200
Message-ID: <20150619091946.GC7462@c203.arch.suse.de>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
 <1434102153-38581-7-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36799 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654AbbFSJTt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Jun 2015 05:19:49 -0400
Content-Disposition: inline
In-Reply-To: <1434102153-38581-7-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org

On Fri, Jun 12, 2015 at 03:12:18PM +0530, Sreekanth Reddy wrote:
> This Patch will provide more details of the devices such as slot numb=
er, enclosure logical id, enclosure level & connector name in the follo=
wing scenarios,
>=20
> - When end device is added in the topology,
> - When the end device is removed from the setup,
> - When the SCSI mid layer issues TASK ABORT/ DEVICE RESET/ TARGET RES=
ET during error handling,
> - When any command to the device fails with Sense key Hardware error =
or Medium error or Unit Attention,
> - When firmware returns device error or device not ready status for t=
he end device,
> - When a Predicted fault is detected on an end device.
>=20
> This information can be used by the user to identify the location of =
the desired drive in the topology.
>=20
> Driver will get these information by reading the sas device page0.
>=20
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.h  |   2 +
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 238 +++++++++++++++++++++++++=
++++------
>  2 files changed, 201 insertions(+), 39 deletions(-)
>=20
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3s=
as/mpt3sas_base.h
> index b79ad4f..293ad23 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -317,6 +317,8 @@ struct _sas_device {
>  	u8	fast_path;
>  	u8	pfa_led_on;
>  	u8	pend_sas_rphy_add;
> +	u8   enclosure_level;
> +	u8   connector_name[4];

Minor nit of different indent here, don't know if it is worth re-sendin=
g?

Other than that:

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                       Storage
jthumshirn@suse.de                             +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
