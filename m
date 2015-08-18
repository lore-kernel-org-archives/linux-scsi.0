From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [patch] cxlflash: shift wrapping bug in afu_link_reset()
Date: Tue, 18 Aug 2015 11:58:46 +0200
Message-ID: <mqdsi7g3okp.fsf@c203.arch.suse.de>
References: <20150818085743.GA3965@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49194 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbbHRJ6t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2015 05:58:49 -0400
In-Reply-To: <20150818085743.GA3965@mwanda> (Dan Carpenter's message of "Tue,
	18 Aug 2015 11:57:43 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, Michael Neuling <mikey@neuling.org>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:

> "port_sel" is a u64 so the shifting should also be a 64 bit shift.
>
> Fixes: c21e0bbfc485 ('cxlflash: Base support for IBM CXL Flash Adapte=
r')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/mai=
n.c
> index 0720d2f..f97421d 100644
> --- a/drivers/scsi/cxlflash/main.c
> +++ b/drivers/scsi/cxlflash/main.c
> @@ -1179,7 +1179,7 @@ static void afu_link_reset(struct afu *afu, int=
 port, u64 *fc_regs)
> =20
>  	/* first switch the AFU to the other links, if any */
>  	port_sel =3D readq_be(&afu->afu_map->global.regs.afu_port_sel);
> -	port_sel &=3D ~(1 << port);
> +	port_sel &=3D ~(1ULL << port);
>  	writeq_be(port_sel, &afu->afu_map->global.regs.afu_port_sel);
>  	cxlflash_afu_sync(afu, 0, 0, AFU_GSYNC);
> =20
> @@ -1196,7 +1196,7 @@ static void afu_link_reset(struct afu *afu, int=
 port, u64 *fc_regs)
>  		       __func__, port);
> =20
>  	/* switch back to include this port */
> -	port_sel |=3D (1 << port);
> +	port_sel |=3D (1ULL << port);
>  	writeq_be(port_sel, &afu->afu_map->global.regs.afu_port_sel);
>  	cxlflash_afu_sync(afu, 0, 0, AFU_GSYNC);
> =20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                           Storage
jthumshirn@suse.de                                 +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600  D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
