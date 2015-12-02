From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 05/10] aacraid: Set correct msix count for EEH recovery
Date: Wed, 02 Dec 2015 11:27:23 +0100
Message-ID: <1449052043.3103.60.camel@suse.de>
References: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
	 <1448973589-9216-6-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35046 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757770AbbLBK10 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Dec 2015 05:27:26 -0500
In-Reply-To: <1448973589-9216-6-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Santosh.Akula@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Rich.Bono@pmcs.com

Hi Raghava,

On Tue, 2015-12-01 at 04:39 -0800, Raghava Aditya Renukunta wrote:
> From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
>=20
> During EEH recovery number of online CPU's might change thereby chang=
ing
> the number of MSIx vectors. Since each fib is allocated to a vector,
> changes in the number of vectors causes fib to be sent thru invalid
> vectors.In addition the correct number of MSIx vectors is not
> updated in the INIT struct sent to the controller, when it is
> reinitialized.
>=20
> Fixed by reassigning vectors to fibs based on the updated number of M=
SIx
> vectors and updating the INIT structure before sending to controller.
>=20

[...]
=C2=A0
> -	if (!dev->sync_mode)
> +	if (!dev->sync_mode) {
> +		/* After EEH recovery or suspend resume, max_msix count
> +		=C2=A0* may change, therfore updating in init as well.
> +		=C2=A0*/
> =C2=A0		aac_adapter_start(dev);
> +		dev->init->Sa_MSIXVectors =3D cpu_to_le32(dev->max_msix);
> +	}
> =C2=A0	return 0;
> =C2=A0
> =C2=A0error_iounmap:


This is for EEH and suspend/resume isn't it? If it fixes MSI-X vector
calculation for suspend/resume as well you probably should tag it for i=
nclusion
into stable as well.

Thanks,
	Johannes

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
