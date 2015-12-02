From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 06/10] aacraid: Fundamental reset support for Series 7
Date: Wed, 02 Dec 2015 10:49:38 +0100
Message-ID: <1449049778.3103.47.camel@suse.de>
References: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
	 <1448973589-9216-7-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54692 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755423AbbLBJtk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Dec 2015 04:49:40 -0500
In-Reply-To: <1448973589-9216-7-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Santosh.Akula@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Rich.Bono@pmcs.com

On Tue, 2015-12-01 at 04:39 -0800, Raghava Aditya Renukunta wrote:
> From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
>=20
> Series 7 does not support PCI hot reset used by EEH.
>=20
> Enabled fundamental reset only for Series 7
>=20
> Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs=
=2Ecom>
> ---
> =C2=A0drivers/scsi/aacraid/linit.c | 6 ++++++
> =C2=A01 file changed, 6 insertions(+)
>=20
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/lini=
t.c
> index f88f1132..6912efd 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -1135,6 +1135,12 @@ static int aac_probe_one(struct pci_dev *pdev,=
 const
> struct pci_device_id *id)
> =C2=A0	u64 dmamask;
> =C2=A0	extern int aac_sync_mode;
> =C2=A0
> +	/*
> +	=C2=A0* Only series 7 needs freset.
> +	=C2=A0*/
> +	=C2=A0if (pdev->device =3D=3D PMC_DEVICE_S7)
> +		pdev->needs_freset =3D 1;
> +
> =C2=A0	list_for_each_entry(aac, &aac_devices, entry) {
> =C2=A0		if (aac->id > unique_id)
> =C2=A0			break;

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
