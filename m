Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC356171E69
	for <linux-scsi@vger.kernel.org>; Sat, 31 Aug 2024 12:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.58.86.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725106855; cv=none; b=s+5mqVw33A/iiNaQf+jQjG0QJEJUgCAZ5F/ElBVmNTNIF6ik4c0xHjGa3qjNFkCh3yLkHN3eXtcjJyLs2QJ74lWGagXid7qFr4rGAWwBRPNb9yugfk3rjLZN0V5gTE1RQs8oWKe+H3YWwQTEXloprfZo8dJ7kqcYyMVxIBE6nCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725106855; c=relaxed/simple;
	bh=CkWWS37IlEOEjjmY0J5uwLIvh7WFn7azN4Gid73fZGE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=KVJWmKP0HD6c4b/tGmNpwUscq67hhNjSf+SuRmQWMmA0BfNVj6jACAzZsC1XyOUqo/mt/Kqf3XDlQ7b7zo5bvadt4bkEIa45TMqeo9N0B1u8Z+9y8aQ645rBjSmAC4Fq5jIAY4jsOYfLRTJyqUJc/TBZx4owwqPsWK3VCJL5AE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM; spf=pass smtp.mailfrom=aculab.com; arc=none smtp.client-ip=185.58.86.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aculab.com
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-245-CenmDodWPzGjVn3OQypgUA-1; Sat, 31 Aug 2024 13:20:42 +0100
X-MC-Unique: CenmDodWPzGjVn3OQypgUA-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sat, 31 Aug
 2024 13:19:58 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Sat, 31 Aug 2024 13:19:58 +0100
From: David Laight <David.Laight@ACULAB.COM>
To: 'Yan Zhen' <yanzhen@vivo.com>, "sathya.prakash@broadcom.com"
	<sathya.prakash@broadcom.com>, "sreekanth.reddy@broadcom.com"
	<sreekanth.reddy@broadcom.com>, "suganath-prabu.subramani@broadcom.com"
	<suganath-prabu.subramani@broadcom.com>
CC: "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"opensource.kernel@vivo.vom" <opensource.kernel@vivo.vom>
Subject: RE: [PATCH v1] fusion: mptctl: Use min macro
Thread-Topic: [PATCH v1] fusion: mptctl: Use min macro
Thread-Index: AQHa+HYKu7a4N74T3UW6jrHZO4NnXLJBTt4Q
Date: Sat, 31 Aug 2024 12:19:57 +0000
Message-ID: <27dfad1261db41988d31dbb62af13fc4@AcuMS.aculab.com>
References: <20240827113922.3898849-1-yanzhen@vivo.com>
In-Reply-To: <20240827113922.3898849-1-yanzhen@vivo.com>
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

From: Yan Zhen
> Sent: 27 August 2024 12:39
>=20
> Using the real macro is usually more intuitive and readable,
> When the original file is guaranteed to contain the minmax.h header file
> and compile correctly.
>=20
> Signed-off-by: Yan Zhen <yanzhen@vivo.com>
> ---
>  drivers/message/fusion/mptctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mpt=
ctl.c
> index 9f3999750..17798edf7 100644
> --- a/drivers/message/fusion/mptctl.c
> +++ b/drivers/message/fusion/mptctl.c
> @@ -1609,7 +1609,7 @@ mptctl_eventreport (MPT_ADAPTER *ioc, unsigned long=
 arg)
>  =09maxEvents =3D numBytes/sizeof(MPT_IOCTL_EVENTS);
>=20
>=20
> -=09max =3D MPTCTL_EVENT_LOG_SIZE < maxEvents ? MPTCTL_EVENT_LOG_SIZE : m=
axEvents;
> +=09max =3D min(MPTCTL_EVENT_LOG_SIZE, maxEvents);

IMHO the arguments should be swapped.
=09min(variable, CONSTANT);
is better.

=09David.

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)

