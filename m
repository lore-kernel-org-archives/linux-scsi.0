From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 04/17] qla2xxx: Include Exchange offload/Extended Login
 into FW dump
Date: Wed, 31 May 2017 23:12:34 +0000
Message-ID: <1496272352.2608.22.camel@sandisk.com>
References: <20170530175432.26984-1-himanshu.madhani@cavium.com>
         <20170530175432.26984-5-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:57684 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbdEaXMz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2017 19:12:55 -0400
In-Reply-To: <20170530175432.26984-5-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <641138107279E64586A232EB5187B95C@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2017-05-30 at 10:54 -0700, Himanshu Madhani wrote:
>  static inline void *
> +qla25xx_copy_exlogin(struct qla_hw_data *ha, void *ptr, uint32_t **last_=
chain)
> +{
> +	struct qla2xxx_offld_chain *c =3D ptr;
> +
> +	if (!ha->exlogin_buf)
> +		return ptr;
> +
> +	*last_chain =3D &c->type;
> +
> +	c->type =3D htonl(DUMP_CHAIN_EXLOGIN);
> +	c->chain_size =3D htonl(sizeof(struct qla2xxx_offld_chain) +
> +	    ha->exlogin_size);
> +	c->size =3D htonl(ha->exlogin_size);

Since this is not networking code, why is this code using htonl() instead o=
f=20
cpu_to_be32()?

> +	c->addr_l =3D htonl(LSD(ha->exlogin_buf_dma));
> +	c->addr_h =3D htonl(MSD(ha->exlogin_buf_dma));

Please use cpu_to_be64() instead of this weird construct.

> +	uint32_t addr_l;
> +	uint32_t addr_h;

Please declare this as a single 64-bit variable instead of using this weird
split into two 32-bit variables.

Thanks,

Bart.=
