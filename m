From: Vitaly Bordug <vitb@kernel.crashing.org>
Subject: Re: [PATCH] mptsas: fix dma alignment
Date: Mon, 7 Sep 2009 17:45:38 +0400
Message-ID: <20090907174538.67c7cedd@vitb-lp>
References: <20090902010331.37889a2c@vitb-lp>
	<0D1E8821739E724A86F4D16902CE275C1C8EAE0A19@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:56006 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbZIGNot convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Sep 2009 09:44:49 -0400
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C1C8EAE0A19@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

=D0=92 Mon, 7 Sep 2009 16:42:54 +0530
"Desai, Kashyap" <Kashyap.Desai@lsi.com> =D0=BF=D0=B8=D1=88=D0=B5=D1=82=
:

> Can you send an exact link for "465ff.. commit"?
>=20
Sure,=20
http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
commit;h=3D465ff3185e0cb76d46137335a4d21d0d9d3ac8a2

> Thanks,
> Kashyap
>=20
> -----Original Message-----
> From: Vitaly Bordug [mailto:vitb@kernel.crashing.org]=20
> Sent: Wednesday, September 02, 2009 2:34 AM
> To: Moore, Eric
> Cc: DL-MPT Fusion Linux; linux-scsi@vger.kernel.org
> Subject: [PATCH] mptsas: fix dma alignment
>=20
>=20
> From: Yuri Tikhonov <yur@emcraft.com>
>=20
> fusion mptsas: fix dma alignment
>=20
>      Since the 465ff.. commit from James Bottomley relaxes the defaul=
t
>      SCSI DMA alignment from 512 bytes to 4 bytes, then, in the mptsa=
s
>      driver, we should explicitly set the alignment to the workable
>      512 bytes value.
>=20
>     Signed-off-by: Ilya Yanok <yanok@emcraft.com>
>     Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
>     Signed-off-by: Sergei Poselenov <sposelenov@emcraft.com>
>     Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>
> ---
>=20
>  drivers/message/fusion/mptsas.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
>=20
> diff --git a/drivers/message/fusion/mptsas.c
> b/drivers/message/fusion/mptsas.c index 55ff252..2334f26 100644
> --- a/drivers/message/fusion/mptsas.c
> +++ b/drivers/message/fusion/mptsas.c
> @@ -1843,6 +1843,7 @@ mptsas_slave_alloc(struct scsi_device *sdev)
>  	return -ENXIO;
> =20
>   out:
> +	blk_queue_update_dma_alignment(sdev->request_queue, 511);
>  	vdevice->vtarget->num_luns++;
>  	sdev->hostdata =3D vdevice;
>  	return 0;
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
