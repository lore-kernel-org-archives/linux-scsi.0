From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: ultrastor.c is a bit-rot
Date: Mon, 17 Mar 2008 12:25:35 -0500
Message-ID: <1205774735.6767.148.camel@localhost.localdomain>
References: <47DE8736.8020405@panasas.com>
	 <1205767383.6767.139.camel@localhost.localdomain>
	 <47DE95A9.8060502@panasas.com>
	 <1205769786.6767.140.camel@localhost.localdomain>
	 <47DEA3F3.7070908@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41757 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694AbYCQRZj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Mar 2008 13:25:39 -0400
In-Reply-To: <47DEA3F3.7070908@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>

On Mon, 2008-03-17 at 19:01 +0200, Boaz Harrosh wrote:
> In Hebrew we say: "You make me drink Kerosene".=20

Sl=C3=A0inte mhath as we say in English.

> An "obvious enough to apply the best straight line fix" submitted bel=
ow:
>=20
> I say dump it, it's unused.
>=20
> Boaz
> ---
> From: Boaz Harrosh <bharrosh@panasas.com>
> Date: Mon, 17 Mar 2008 18:40:03 +0200
> Subject: [PATCH] ultrastor: Fix for ISA DMA allocation
>=20
> "obvious enough to apply the best straight line fix" submitted
> below.
>=20
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> CC: Andi Kleen <ak@suse.de>
> ---
>  drivers/scsi/ultrastor.c |   24 +++++++++++++++++++++---
>  1 files changed, 21 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
> index f385dce..04441eb 100644
> --- a/drivers/scsi/ultrastor.c
> +++ b/drivers/scsi/ultrastor.c
> @@ -255,8 +255,9 @@ static struct ultrastor_config
>    unsigned long mscp_free;
>  #endif
>    volatile unsigned char aborted[ULTRASTOR_MAX_CMDS];
> -  struct mscp mscp[ULTRASTOR_MAX_CMDS];
> -} config =3D {0};
> +  struct mscp *mscp;
> +  dma_addr_t dma;
> +} config;
> =20
>  /* Set this to 1 to reset the SCSI bus on error.  */
>  static int ultrastor_bus_reset;
> @@ -646,12 +647,29 @@ static int ultrastor_24f_detect(struct scsi_hos=
t_template * tpnt)
> =20
>  static int ultrastor_detect(struct scsi_host_template * tpnt)
>  {
> +	int ret;
> +
>  	tpnt->proc_name =3D "ultrastor";
> -	return ultrastor_14f_detect(tpnt) || ultrastor_24f_detect(tpnt);
> +
> +	if (!config.mscp)
> +		config.mscp =3D dma_alloc_coherent(NULL,
> +			sizeof(*config.mscp) * ULTRASTOR_MAX_CMDS,
> +			&config.dma, GFP_KERNEL);

Error handling here, I'm afraid; dma_alloc_coherent can return NULL.

Other than that, looks great.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
