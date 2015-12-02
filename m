From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 07/10] aacraid: Fix AIF triggered IOP_RESET
Date: Wed, 02 Dec 2015 11:00:32 +0100
Message-ID: <1449050432.3103.52.camel@suse.de>
References: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
	 <1448973589-9216-8-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56648 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755423AbbLBKAf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Dec 2015 05:00:35 -0500
In-Reply-To: <1448973589-9216-8-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Santosh.Akula@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Rich.Bono@pmcs.com

Hi=C2=A0Raghava,

On Tue, 2015-12-01 at 04:39 -0800, Raghava Aditya Renukunta wrote:
> From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
>=20
> while driver removal is in progress or PCI shutdown is invoked, drive=
r
> kills AIF aacraid thread, but IOCTL requests from the management tool=
s
> re-start AIF thread leading to IOP_RESET.
>=20
> Fixed by setting adapter_shutdown flag when PCI shutdown is invoked.
>=20
> Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs=
=2Ecom>
> ---
> =C2=A0drivers/scsi/aacraid/linit.c | 1 +
> =C2=A01 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/lini=
t.c
> index 6912efd..3a4dbe7 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -1454,6 +1454,7 @@ static int aac_suspend(struct pci_dev *pdev,
> pm_message_t state)
> =C2=A0	struct aac_dev *aac =3D (struct aac_dev *)shost->hostdata;
> =C2=A0
> =C2=A0	scsi_block_requests(shost);
> +	aac->adapter_shutdown =3D 1;
> =C2=A0	aac_send_shutdown(aac);
> =C2=A0
> =C2=A0	aac_release_resources(aac);

I don't quite undestand that, the following is from aac_send_shutdown()=
:


229=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* FIB should =
be freed only after getting the response from the F/W
*/
230=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (status !=3D=
 -ERESTARTSYS)
231=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0aac_fib_free(fibctx);
232=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0dev->adapter_s=
hutdown =3D 1;
233=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if ((dev->pdev=
->device =3D=3D PMC_DEVICE_S7 ||
234=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0dev->pdev->device =3D=3D PMC_DEVICE_S8 ||



in line 232 you're already setting the adapter shutdown flag, why do yo=
u need
to pre-set it before calling aac_send_shutdown()?=C2=A0

Thanks,
	Johannes
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
