From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH][SCSI] megaraid_sas: addded support for big endian
 architecture
Date: Tue, 10 Sep 2013 22:11:52 +0000
Message-ID: <1378851112.23501.53.camel@dabdike.int.hansenpartnership.com>
References: <201309061020.r86AKpAY015172@cosmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:54132 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab3IJWLy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Sep 2013 18:11:54 -0400
In-Reply-To: <201309061020.r86AKpAY015172@cosmhbs0.lsi.com>
Content-Language: en-US
Content-ID: <C93535F0E141214EA2648D9EC7179B3C@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Sumit.Saxena@lsi.com" <Sumit.Saxena@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kashyap.desai@lsi.com" <kashyap.desai@lsi.com>, "aradford@gmail.com" <aradford@gmail.com>

On Fri, 2013-09-06 at 15:50 +0530, Sumit.Saxena@lsi.com wrote:
> This patch will add big endian architecture support to megaraid_sas d=
river. The support added is for LSI MegaRAID all generation controllers=
-=20
> (3Gb/s, 6Gb/s and 12 Gb/s controllers).
>=20
> This patch will be applied on top of recently submitted patch for Hig=
h Avaibility support- http://marc.info/?l=3Dlinux-scsi&m=3D137799326426=
659&w=3D2
> We have done basic sanity test @ppc64 arch and @x86_64. Additional te=
sting/observations are welcome.

Well, no it won't actually; it gives a rejection here:


> --- drivers/scsi/megaraid/megaraid_sas_base.c
> +++ drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -5097,8 +5142,9 @@
> =20
>  	for (i =3D 0; i < ioc->sge_count && kbuff_arr[i]; i++) {
>  		dma_free_coherent(&instance->pdev->dev,
> -				    kern_sge32[i].length,
> -				    kbuff_arr[i], kern_sge32[i].phys_addr);
> +				  le32_to_cpu(kern_sge32[i].length),
> +				  kbuff_arr[i],
> +				  le32_to_cpu(kern_sge32[i].phys_addr));
>  	}
> =20
>  	megasas_return_cmd(instance, cmd);

Because you didn't take into account this patch:

Author: Bj=F8rn Mork <bjorn@mork.no>
Date:   Wed Nov 21 09:54:48 2012 +0100

    [SCSI] megaraid_sas: fix memory leak if SGL has zero length entries

I fixed it up this time, but could you please work against the misc
branch of the scsi git repo to prevent this type of problem in future?

Thanks,

James

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
