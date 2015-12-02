From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 08/10] aacraid: Disable device ID wildcard
Date: Wed, 02 Dec 2015 11:02:20 +0100
Message-ID: <1449050540.3103.53.camel@suse.de>
References: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
	 <1448973589-9216-9-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57129 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757119AbbLBKCW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Dec 2015 05:02:22 -0500
In-Reply-To: <1448973589-9216-9-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Santosh.Akula@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Rich.Bono@pmcs.com

On Tue, 2015-12-01 at 04:39 -0800, Raghava Aditya Renukunta wrote:
> From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
>=20
> Added module parameter that disables device ID wild card binding.
>=20
> Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs=
=2Ecom>
> ---
> =C2=A0drivers/scsi/aacraid/aachba.c=C2=A0=C2=A0| 5 +++++
> =C2=A0drivers/scsi/aacraid/aacraid.h | 1 +
> =C2=A0drivers/scsi/aacraid/linit.c=C2=A0=C2=A0=C2=A0| 5 +++++
> =C2=A03 files changed, 11 insertions(+)
>=20
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aac=
hba.c
> index 06cbab8..87f4f21 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -315,6 +315,11 @@ MODULE_PARM_DESC(wwn, "Select a WWN type for the
> arrays:\n"
> =C2=A0	"\t1 - Array Meta Data Signature (default)\n"
> =C2=A0	"\t2 - Adapter Serial Number");
> =C2=A0
> +int aac_disable_device_id_wildcards;
> +module_param_named(disable_device_id_wildcards,
> +	aac_disable_device_id_wildcards, int, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(disable_device_id_wildcards,
> +	"Disable device ID wildcards");
> =C2=A0
> =C2=A0static inline int aac_valid_context(struct scsi_cmnd *scsicmd,
> =C2=A0		struct fib *fibptr) {
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aa=
craid.h
> index 594de5f..7708a2c 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -2177,3 +2177,4 @@ extern int aac_commit;
> =C2=A0extern int update_interval;
> =C2=A0extern int check_interval;
> =C2=A0extern int aac_check_reset;
> +extern int aac_disable_device_id_wildcards;
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/lini=
t.c
> index 3a4dbe7..2094842 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -1135,6 +1135,11 @@ static int aac_probe_one(struct pci_dev *pdev,=
 const
> struct pci_device_id *id)
> =C2=A0	u64 dmamask;
> =C2=A0	extern int aac_sync_mode;
> =C2=A0
> +	if (aac_disable_device_id_wildcards &&
> +		id->subvendor =3D=3D PCI_ANY_ID &&
> +		id->subdevice =3D=3D PCI_ANY_ID)
> +		return -ENODEV;
> +
> =C2=A0	/*
> =C2=A0	=C2=A0* Only series 7 needs freset.
> =C2=A0	=C2=A0*/

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
