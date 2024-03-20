Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF7F8C04
	for <linux-scsi@vger.kernel.org>; Wed, 20 Mar 2024 01:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710899244; cv=fail; b=qPWXlYu4GcX9BIYsy/RUyNiwg2YLGsFTfh07bLK5CgKHvJwyFUBA4lPrmNOVXXs742srL59OZcTuikUkrGEgzPi1CDQiJtY9o+3J7DAoSWKsJ3IxuyT7YW+WqpxQDyucpxPLXWQjIKRdbOp+bJSQvX0ZgCjxBhhJLeD5hZN++lA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710899244; c=relaxed/simple;
	bh=Skref3klBN9NU38Qw7t2TvMqO3ajVwF9CFLnHp+9ZYM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J+5EtLMVQXf1txpA6luxBD/iIfV2eMXL585rAqhjARQfqYgQ+iuvMmEr6y9vCYw67Embe6AohELQQiYc+8UVuGTKh8OHdmllfXkwTONlndHdzJc8ZFYP8qi9QggP81De+4+B+aknNQIOtHgmOq9NaXRaioQ8uEDjoSksmEedG5I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=SmMZtyTs; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ni9Ph4sY; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="SmMZtyTs";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ni9Ph4sY"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1710899242; x=1742435242;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Skref3klBN9NU38Qw7t2TvMqO3ajVwF9CFLnHp+9ZYM=;
  b=SmMZtyTscIjfVaHWPsblmCbWKnVvSvls7cqWvtD6p+BX2tjCAQu0WRHq
   hpmc/9sAccTx/wUywQNWX85zaoknZPZCMsS2Phjeh/8ti9LuJDTeED3Ml
   0k3WhjGgMLB62xh+OPfNQJczH9IBlJ6Tic987G8ltP13duVUbiAH1QRRJ
   riUSTR3mc4Ls18hU8Mat6V0jFB13v0PVWP13UGYeJ55EHT6xBOzv09dUB
   +cX/wkd8ccdmbbdBvuEG8IFGgxjYyCcWVcYGMdDg1+CT0hCMMwkAXKvgz
   rEfrwNzLonW1FggawuVtdd59bTuMuZhJenbocD3Az8mhV0w2QfYdjuneC
   w==;
X-CSE-ConnectionGUID: oRegOYMoTQW+cLgWXa8hMQ==
X-CSE-MsgGUID: 5Zx+OuxlRQ+fKQRJAlWyog==
X-IronPort-AV: E=Sophos;i="6.07,138,1708358400"; 
   d="scan'208";a="12002520"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by ob1.hgst.iphmx.com with ESMTP; 20 Mar 2024 09:46:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bPVncGwdgHsMboDpex8XhgjmL1J23zQAhLe/GN+CSdye0L//pdUAXnuKmZuEYIUYsQGveBeB+knpqbA+ql6XIv8WNt6S0bwo0nLbVOqwgBMniv4FMyUHcpyRg3Nc+FPvRJGkv9qFjGDqKmpQZxUsYnZJ3BfrAEYL7Da5ZcZBBIMv6e7l5Z5N8IdSmdRq8sRl132rJg/+60Rh9Zc+M0DgJmcUZx+wc4O+9hftkQKeyzPpg0zvcfD6K8ERh2o88nC32me7QoXxIYgMy4u6OsAyKltbXdgCCaVCH3e34ImunUcZBNUmke7T8RipM8CH54bZJF7nsODbFOpTL7PYKQS5VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HIuNOpfSP14cOmCUopcngoxzgH3HvFlPyL9CqxnO9LA=;
 b=mFfofHaajJ39vYonBnUs6LNvhTMsFGcRH33hJ49IeOkRMMUCYn1WDjHuOdilxIQ9dIvB/7y6yFIuwYGw3K6+ycIuUL/rG12TscR6+BaLAHmsJHI4JC980a3SJLg3RCoEG9R+XtITL3fGmmkl3xd1E4qYpoYM2VJzP8dkoEf0icKe/7sgWp48rZDGfIHnpIxa9Ap3c7n8dydQtuATy81iU5zJWQLfFSXSqi2mVHRy8tFZSZCxq+yV77jObJ4XFgR5xCOco0xWlAcklM2Zg2lRfu/WBlLpNwobP5L6/KVEiVkuhJvlzsNT7YzBUwIOLzWxPbCQuP6oLVbK+wI4A55nxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HIuNOpfSP14cOmCUopcngoxzgH3HvFlPyL9CqxnO9LA=;
 b=ni9Ph4sY3oLKQhyIq6FYYBYZ/ZeODxxxBCBBwRddUadcR+AA+aEjrMpUhSaJKWAiGaaeVBhyx8U3AGN5GqeEOvNpUkyt4s45GKMSpu+hYH2mZsyNIpVWIV1aBX91WbFoNetSkvwYvG+9/4XppWKBHp6Vv1WNvlnAbatoq1y8zUA=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 PH0PR04MB8474.namprd04.prod.outlook.com (2603:10b6:510:2a0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.30; Wed, 20 Mar
 2024 01:46:11 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::c9e3:b196:e5ea:909b]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::c9e3:b196:e5ea:909b%4]) with mapi id 15.20.7386.030; Wed, 20 Mar 2024
 01:46:11 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K .
 Petersen" <martin.petersen@oracle.com>, Douglas Gilbert
	<dgilbert@interlog.com>
Subject: Re: [PATCH RFC 1/2] scsi: scsi_debug: Factor out initialization of
 size parameters
Thread-Topic: [PATCH RFC 1/2] scsi: scsi_debug: Factor out initialization of
 size parameters
Thread-Index: AQHac4D6hvnyM4MWv0aYaeYgVa7hx7EyykSAgA0ffgA=
Date: Wed, 20 Mar 2024 01:46:10 +0000
Message-ID: <rzhvj5uieq4ers2ocmwmkivtbfcjyhvvpmx4ufj7ii3tgndr4r@6jpf2tanpmcy>
References: <20240311065427.3006023-1-shinichiro.kawasaki@wdc.com>
 <20240311065427.3006023-2-shinichiro.kawasaki@wdc.com>
 <b62b8f7d-abb9-470c-a042-c0710710da96@acm.org>
In-Reply-To: <b62b8f7d-abb9-470c-a042-c0710710da96@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|PH0PR04MB8474:EE_
x-ms-office365-filtering-correlation-id: 4d7b5cc3-6966-4820-72fa-08dc487f8513
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 KT82BkvKssUh8+hhTzETtt2Ucx69x2rImsXWdJ6aG864nzutoWRWXMfnh7x6nqqW1/nBUAE/gzGfMjudcQpV5K4/07Co2Y+C7WjaF8hCnHkvVuEDg5MlRjtVCrIvSQoW8DovnO5bYXomM2O6zQHdMggWpNlxyANSkcM+Z+YjSfAG/nrNqH9K/2T84ieaSjbOsuzGhNwtqjOGOLFCIZMciGQhaiv+LCXyJzWaF8zeztwkcwDKNL1iBmxUKAauz0kW7OfJooOD1aFfHpCZXcEhZL5GdwpkfZk24oknJc+0D1g8DRw/kL0y7zW8zHn5Z0/Y7VLi9JpCeDRlD/A/NfxbN0Eklc3FXQKhBFPR0DEn2xoQYGCLG+0dmxpfJ72IVunda5ehwumSbmRmEsk1i4Kfq2mNQQf/m+CSXxpYzpE9GDQuUvU2nmF4yuSDoF0FDCdY2yVJYokvKtL7DgkNDOAjMCCK/1QRugMC+eJPqyOkdiSXhk/HDNC4pGdNV2uoeq/sSsBihAdfrNfhWmqzZ+2nZRym8+zhB9nY8/VE8x6UOP79jJ5B8tadg6uoMWmPRZcjLR2aQbq+qNI2+HpZo+tzbc+t/Py2Khag2FvRLLHqCVDcD13U/0jqfV5jYRbLf2+QGpOxWQ2OPCSJ82HLmpINPJJMH04ljPk/fmgWb6pepAFGVlqS9oM4gUvXUiso8RvGTbnDKEyyI7X83Pu6hUox4l4g0WSSvdpeRQPlIN0m5Yg=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?t8aoj4rDo4XfaZKKsQg0Ehwj0KZRpKwBH6Fa2JWGiHAdCV2N7xxR898hILTC?=
 =?us-ascii?Q?s9BZhuoG52sCtOmq0f56F5kVm1y3S+asFpmzfRVQhJ9h+iFRQquLrEprncJM?=
 =?us-ascii?Q?EPn7PspBwPAbknGV9hVid+zQ8RUPdOrPVn4xIcxeiM0kwyVC6ArukoADswoU?=
 =?us-ascii?Q?dQJiCKhkl4M734Axe+4Cvij/IppLregYnBNsT22HZctpfdxeRn1vLaSqEBmB?=
 =?us-ascii?Q?BwVdd7aPwt8xnqojYqtORfp8X2JnwOsZRJog6EIaNdhX3ZVZUk5ai+h1m1Qs?=
 =?us-ascii?Q?QZKLZnYWngsrpZigm35swugCSlngpTBitVL27jB5GN3n7ueAXLhIC/ApE07Q?=
 =?us-ascii?Q?4lr0mydiUdxnqE7gaDq7qhDA2nv4fKwxNXEvNKUJScPVIpaZt0OIXjPAYoxP?=
 =?us-ascii?Q?1L67t8WHaYJ0I8sSOZpRNmk1wAJtqEj8SL6Mk4JRzNIrtviW+IPrRcNwalA3?=
 =?us-ascii?Q?uD+ldf/YzYnC3GF5OXyVF8ZObS40mj1kJBYyxo2vuDmXazi6wbyLVyUHPkZp?=
 =?us-ascii?Q?uXtf5JPuTno1MxY3iSK1gjaNHo2AavimnihZlCtXySka1HXq5WAAwT9rF8oI?=
 =?us-ascii?Q?oTsoreJ7IXTzsc0DeKgPWyMAm3fZUU7OVHTQGpr9cmvkoX2DZmiTcq4Y7jdK?=
 =?us-ascii?Q?upS53V/1tXVvlHV66Dm0KOPoinhw/T55mGOoEBf1k1ASdcXdsFy+8ji/3F7+?=
 =?us-ascii?Q?K0/06J2E+nnHb0XC2uFmxQ5wZqUcazbudQcylqKn38W4Ps1Gw3aaZXmP9Jae?=
 =?us-ascii?Q?dJpevGQLQODvWkhCOoifJuQ8tiWW7vGL/eoUjn1YihrLSMRtAAlisEVKgLNo?=
 =?us-ascii?Q?7Ey20TfAYRIxphfEVf8PBJ/VClPn6nzmLcIshlGlZKIEQHy1lq82LhnOCqfG?=
 =?us-ascii?Q?rgD1kFCl/v5xfPYTyvZuE0tHo8X03sW87bJKxZDkPrDYIeK+kq0RdxZc2nw0?=
 =?us-ascii?Q?CFFEub7seIUZ+V/7oLeAxfbuIWjSYCMCv9EV+JJ17KH1WaF5yIf0xmBVog5A?=
 =?us-ascii?Q?cimshyYOOmOfAGkJBGpQYCFnr9HFBKXeLevA2xyT4Y507tFAeu6/24CLxuuN?=
 =?us-ascii?Q?txWVnResXuIrweFpFLHfy7jQkpEMPe4LVuqPjMTzvxiHFGa2Nj09JuBDX78Z?=
 =?us-ascii?Q?8OmolZv7m7+TAFzDfeSkjH6s+powyYrjEFwWgsuxSyU34G2gSSymaQ/FEQZi?=
 =?us-ascii?Q?jMHkowgFY40ept2H+Bg8G8ieatzNiaWzDzW4WixSmXJLfFxYu1fbdZ02abSN?=
 =?us-ascii?Q?xQmFgoUxRbZS7brehC0AHFr4c57Msq4b4MkuSwBjEYu6ZFck/aX9dK0HNoWQ?=
 =?us-ascii?Q?awr12BA7Y+NucSq3gvKWtfQuaWCpHbjdb+whBDlpp4Ardq6Xu4ZLGG7CVNAZ?=
 =?us-ascii?Q?6fUN5wK63l1RMBGi1bYftV5MD/8sGPNBZpwIWAP7EGZofNy50qs6qoyCT36y?=
 =?us-ascii?Q?9rD665XtEChQoXcg2PpkLv4+XT50a3iW+bPlrCi/CbYtYi+/LbpgGuixYFL+?=
 =?us-ascii?Q?X80QVuI6v0AMCcn/UDIl7FKud17K5L6flnTyZyLmgc7FdJ4SmUbwYwjnfFHl?=
 =?us-ascii?Q?1UWtEly/ros1ImdyTDnUupQ375TzxOtqJQR37jYglJOHeEZix92xg1D8NAX7?=
 =?us-ascii?Q?e8o7kYT1DjJBA7wErMMgDQ4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9D8AED5E6DA6944699C436F3FF7ABA98@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8B55EaHv3p1J0EnkDcIPMa6125Z+4DHXArEPLXYupp/u44RtXSedkcaQMXBV8x8UTdEE3bH9sQOiS1uA4ByJ/FAB0ZXY4fBwP7NsvgDsRqNO6dM2R85gEZiB/wfkehjeQWx+Cwx4YvLHy37YDAyd3rWrs11Pm1ziMOJQAnldMBuN26+ToYnubLp21HgdcnHNvtjeSkVKPuOSf2NxNwrqSW0zXpAk6peYcvsEBUoRQlBz+HXrd45PVNQOcYkyepRk3vZO8AblXkcPB/hn0A78Ubo2O0UzV6wIFY8Ltxl1ePSF7JTGtTtqMO+Dcm04dMRiSSRD3+7StAiIfrcsEp7AvGoFURO8vFpcMnRMZzWcKqWchGFVvGvi8695BNOjeKBbQleHi/Puhi8DO97kfg+PiOHhPXh1TLCkSQP6zFN2g1WLGFokSHBejWNrqeTDlrnCah3W37spX3ctAay+Xvf4VUcBJ1MgGihcy8BczzTA8sQhbVFUh6KInuyPKgt7jSnziuErKo6q7HuMotJvgnoOUqFBjBaQKG0vOotvuctgrdMWuWO40o3uKtuyy8qBvpDGhsL+Z/OhJVDxe80ojDvkpyi8v/+2KdeRCSmWoaB6dPihkjkxIlZWs/DDDL6Vn444
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d7b5cc3-6966-4820-72fa-08dc487f8513
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2024 01:46:10.9911
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tn95rYMIqa4lM5f5R155ZFU5gD9b1iBTyDnYTUmOWJx8NfvI286v2QYAXXRm0tPo7e77Wj7/8ECv3OkLL7RVhCKaptSLX6Z/5JTMq6KiExM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB8474

On Mar 11, 2024 / 10:22, Bart Van Assche wrote:
> On 3/10/24 23:54, Shin'ichiro Kawasaki wrote:
> > As the preparation for the dev_size_mb parameter changes through sysfs,
> > factor out the initialization of parameters affected by the dev_size_mb
> > changes.
> >=20
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> >   drivers/scsi/scsi_debug.c | 52 ++++++++++++++++++++++++--------------=
-
> >   1 file changed, 32 insertions(+), 20 deletions(-)
> >=20
> > diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> > index d03d66f11493..c6b32f07a82c 100644
> > --- a/drivers/scsi/scsi_debug.c
> > +++ b/drivers/scsi/scsi_debug.c
> > @@ -7234,10 +7234,39 @@ ATTRIBUTE_GROUPS(sdebug_drv);
> >   static struct device *pseudo_primary;
> > +/*
> > + * Calculate size related parameters from sdebug_dev_zize_mb and
> > + * sdebug_sector_size.
> > + */
> > +static void scsi_debug_init_size_parameters(void)
> > +{
> > +	unsigned long sz;
> > +
> > +	sz =3D (unsigned long)sdebug_dev_size_mb * 1048576;
> > +	sdebug_store_sectors =3D sz / sdebug_sector_size;
> > +	sdebug_capacity =3D get_sdebug_capacity();
> > +
> > +	/* play around with geometry, don't waste too much on track 0 */
> > +	sdebug_heads =3D 8;
> > +	sdebug_sectors_per =3D 32;
> > +	if (sdebug_dev_size_mb >=3D 256)
> > +		sdebug_heads =3D 64;
> > +	else if (sdebug_dev_size_mb >=3D 16)
> > +		sdebug_heads =3D 32;
> > +	sdebug_cylinders_per =3D (unsigned long)sdebug_capacity /
> > +		(sdebug_sectors_per * sdebug_heads);
> > +	if (sdebug_cylinders_per >=3D 1024) {
> > +		/* other LLDs do this; implies >=3D 1GB ram disk ... */
> > +		sdebug_heads =3D 255;
> > +		sdebug_sectors_per =3D 63;
> > +		sdebug_cylinders_per =3D (unsigned long)sdebug_capacity /
> > +			(sdebug_sectors_per * sdebug_heads);
> > +	}
> > +}
> > +
> >   static int __init scsi_debug_init(void)
> >   {
> >   	bool want_store =3D (sdebug_fake_rw =3D=3D 0);
> > -	unsigned long sz;
> >   	int k, ret, hosts_to_add;
> >   	int idx =3D -1;
> > @@ -7369,26 +7398,9 @@ static int __init scsi_debug_init(void)
> >   		sdebug_dev_size_mb =3D DEF_DEV_SIZE_MB;
> >   	if (sdebug_dev_size_mb < 1)
> >   		sdebug_dev_size_mb =3D 1;  /* force minimum 1 MB ramdisk */
> > -	sz =3D (unsigned long)sdebug_dev_size_mb * 1048576;
> > -	sdebug_store_sectors =3D sz / sdebug_sector_size;
> > -	sdebug_capacity =3D get_sdebug_capacity();
> > -	/* play around with geometry, don't waste too much on track 0 */
> > -	sdebug_heads =3D 8;
> > -	sdebug_sectors_per =3D 32;
> > -	if (sdebug_dev_size_mb >=3D 256)
> > -		sdebug_heads =3D 64;
> > -	else if (sdebug_dev_size_mb >=3D 16)
> > -		sdebug_heads =3D 32;
> > -	sdebug_cylinders_per =3D (unsigned long)sdebug_capacity /
> > -			       (sdebug_sectors_per * sdebug_heads);
> > -	if (sdebug_cylinders_per >=3D 1024) {
> > -		/* other LLDs do this; implies >=3D 1GB ram disk ... */
> > -		sdebug_heads =3D 255;
> > -		sdebug_sectors_per =3D 63;
> > -		sdebug_cylinders_per =3D (unsigned long)sdebug_capacity /
> > -			       (sdebug_sectors_per * sdebug_heads);
> > -	}
> > +	scsi_debug_init_size_parameters();
> > +
> >   	if (scsi_debug_lbp()) {
> >   		sdebug_unmap_max_blocks =3D
> >   			clamp(sdebug_unmap_max_blocks, 0U, 0xffffffffU);
>=20
> Please remove sdebug_heads, sdebug_cylinders_per and sdebug_sectors_per
> instead of making this change. While these values are reported in a
> MODE SENSE response, I don't think that it is valuable to keep support
> for heads, cylinders and sectors in the scsi_debug driver.

I see. I guess we can return just zero as sdebug_sectors_per in the MODE
SENSE response instead.

I noticed that the three variables you suggest to remove are used in
sdebug_build_parts() also. It is not a good idea to remove the function
and drop or modify the partition table generation feature, probably. I
think we can make the three variables non-global, local variables in the
function. What do you think?

>=20
> Thanks,
>=20
> Bart.=
