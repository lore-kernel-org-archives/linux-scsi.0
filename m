From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH v2 04/17] qla2xxx: Include Exchange offload/Extended Login
 into FW dump
Date: Thu, 1 Jun 2017 18:30:32 +0000
Message-ID: <F3BA4E18-F2DB-448C-B691-46836729C8E3@cavium.com>
References: <20170530175432.26984-1-himanshu.madhani@cavium.com>
 <20170530175432.26984-5-himanshu.madhani@cavium.com>
 <1496272352.2608.22.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0057.outbound.protection.outlook.com ([104.47.42.57]:15672
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751130AbdFASae (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Jun 2017 14:30:34 -0400
In-Reply-To: <1496272352.2608.22.camel@sandisk.com>
Content-Language: en-US
Content-ID: <49DD81219F8D1945AEA139D4B41E4056@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> On May 31, 2017, at 4:12 PM, Bart Van Assche <bart.vanassche@sandisk.com>=
 wrote:
>=20
> On Tue, 2017-05-30 at 10:54 -0700, Himanshu Madhani wrote:
>> static inline void *
>> +qla25xx_copy_exlogin(struct qla_hw_data *ha, void *ptr, uint32_t **last=
_chain)
>> +{
>> +	struct qla2xxx_offld_chain *c =3D ptr;
>> +
>> +	if (!ha->exlogin_buf)
>> +		return ptr;
>> +
>> +	*last_chain =3D &c->type;
>> +
>> +	c->type =3D htonl(DUMP_CHAIN_EXLOGIN);
>> +	c->chain_size =3D htonl(sizeof(struct qla2xxx_offld_chain) +
>> +	    ha->exlogin_size);
>> +	c->size =3D htonl(ha->exlogin_size);
>=20
> Since this is not networking code, why is this code using htonl() instead=
 of=20
> cpu_to_be32()?
>=20
>> +	c->addr_l =3D htonl(LSD(ha->exlogin_buf_dma));
>> +	c->addr_h =3D htonl(MSD(ha->exlogin_buf_dma));
>=20
> Please use cpu_to_be64() instead of this weird construct.
>=20
>> +	uint32_t addr_l;
>> +	uint32_t addr_h;
>=20
> Please declare this as a single 64-bit variable instead of using this wei=
rd
> split into two 32-bit variables.
>=20
> Thanks,
>=20
> Bart.

Sure. Will update patch with the correct construct.=20

Thanks,
- Himanshu
