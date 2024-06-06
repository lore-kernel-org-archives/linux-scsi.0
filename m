Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6164B3A1A8
	for <linux-scsi@vger.kernel.org>; Thu,  6 Jun 2024 08:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.58.86.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717663676; cv=none; b=E2FCmE6qrHxSC+d50ZvbG6cT+UKz39xfYS0aaP4U6zgLJ+EY/mig8rqoT1Qd+P397lfFp7Rn/uQdNTNTY61Pu7c0wLEswIKawGH75WbtqL/slU/seS1472f4kfWoOM9IYapSLJLyXha31AVhR1assCFjoKKTOuhVJuVfhEgvjA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717663676; c=relaxed/simple;
	bh=5SCALM9/pCCYNvxyrEIe9yl/FOdRJs0JUlO3rA77C4w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=gcbLBa2tBVF0myP04zi9QtCw4C0YZ7WWZcaemp7JiRP7YFbgycm6Ack76Q3ff/gMspIMlhUlU6cZVEFu0xS7OD/VPUumw3iO+T+1opYA19QDfsDmAWbH4i14l5WPco3frDC0KlZyStIB/gcSyo0VSytLhQB0ygGpI1gXZ/arfCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM; spf=pass smtp.mailfrom=aculab.com; arc=none smtp.client-ip=185.58.86.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aculab.com
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-235-hxMZyz40PyK1pBTMtYucjg-1; Thu, 06 Jun 2024 09:47:45 +0100
X-MC-Unique: hxMZyz40PyK1pBTMtYucjg-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 6 Jun
 2024 09:47:11 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Thu, 6 Jun 2024 09:47:11 +0100
From: David Laight <David.Laight@ACULAB.COM>
To: 'Breno Leitao' <leitao@debian.org>, Sathya Prakash
	<sathya.prakash@broadcom.com>, Sreekanth Reddy
	<sreekanth.reddy@broadcom.com>, Suganath Prabu Subramani
	<suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Chaitra P B <chaitra.basappa@broadcom.com>
CC: "leit@meta.com" <leit@meta.com>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, Keith Busch <kbusch@kernel.org>, "open
 list:LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)"
	<MPT-FusionLinux.pdl@broadcom.com>, "open list:LSILOGIC MPT FUSION DRIVERS
 (FC/SAS/SPI)" <linux-scsi@vger.kernel.org>, open list
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] mpt3sas: Avoid test/set_bit() operating in
 non-allocated memory
Thread-Topic: [PATCH v2] mpt3sas: Avoid test/set_bit() operating in
 non-allocated memory
Thread-Index: AQHatyYXo+PuMyVExkerpGT7XDYd+bG6bGDA
Date: Thu, 6 Jun 2024 08:47:11 +0000
Message-ID: <f5bfddf9ec23402498df688e98f6bb29@AcuMS.aculab.com>
References: <20240605085530.499432-1-leitao@debian.org>
In-Reply-To: <20240605085530.499432-1-leitao@debian.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Breno Leitao <leitao@debian.org>
> Sent: 05 June 2024 09:55
>=20
> There is a potential out-of-bounds access when using test_bit() on a
> single word. The test_bit() and set_bit() functions operate on long
> values, and when testing or setting a single word, they can exceed the
> word boundary. KASAN detects this issue and produces a dump:
>=20
> =09 BUG: KASAN: slab-out-of-bounds in _scsih_add_device.constprop.0
> (./arch/x86/include/asm/bitops.h:60 ./include/asm-generic/bitops/instrume=
nted-atomic.h:29
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:7331) mpt3sas
>=20
> =09 Write of size 8 at addr ffff8881d26e3c60 by task kworker/u1536:2/2965
>=20
> For full log, please look at [1].
>=20
> Make the allocation at least the size of sizeof(unsigned long) so that
> set_bit() and test_bit() have sufficient room for read/write operations
> without overwriting unallocated memory.
>=20
...
> @@ -8512,6 +8512,12 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
>  =09ioc->pd_handles_sz =3D (ioc->facts.MaxDevHandle / 8);
>  =09if (ioc->facts.MaxDevHandle % 8)
>  =09=09ioc->pd_handles_sz++;
> +=09/* pd_handles_sz should have, at least, the minimal room
> +=09 * for set_bit()/test_bit(), otherwise out-of-memory touch
> +=09 * may occur
> +=09 */
> +=09ioc->pd_handles_sz =3D ALIGN(ioc->pd_handles_sz, sizeof(unsigned long=
));
> +
>  =09ioc->pd_handles =3D kzalloc(ioc->pd_handles_sz,
>  =09    GFP_KERNEL);

That is entirely stupid code.
IIRC there is a BITMAP_SIZE() that does ((x) + 63u) & ~63)/8
(on 64bit systems).

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)

