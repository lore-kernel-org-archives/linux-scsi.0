Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9A53D81
	for <linux-scsi@vger.kernel.org>; Wed,  9 Apr 2025 06:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744181527; cv=fail; b=RWOL3HSEFL/dFn8caecPSo8lorpfcMolgck167DDZaOyprHBbnMrPQYh0RacH4qHq2dwjt7BtPwhSrABe640P+0Z+8GiI/xKfNMAOA3ndAlybKDthD+V4fuDTX6fgD9Mc8Gp0gAQbUnZwwP3Cr7g/B1WVef5O4WZbmuzKyuZbu0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744181527; c=relaxed/simple;
	bh=GkWZfKdlEfEck53nzZ2NLpO4AHIMO6CpXx7a6AVNT/I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lB7/9mhQIh/sLfOCigC2UQBTt3zL9/oMY9YkAqr/agEtxooa8XtprVZj9Zu+yNc/+QCFBn8oVklAkDYQmRcww7AryinYuqQpwxiKDdkXy1pB3EWtn6Gj+ySfco5vanyDlmhmfQwionagIX2t8xlJS5oWIHgf7FOKvsybXobtgFg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=Nlj0Schg; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="Nlj0Schg"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1744181525; x=1775717525;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GkWZfKdlEfEck53nzZ2NLpO4AHIMO6CpXx7a6AVNT/I=;
  b=Nlj0SchgsY0w9UI70aTUYRS7M6AltMiBhERzL71m2WefAETXVw5i38Do
   acdf1gRFraj6GFufwXGrwIHP5AMxVGsCkXbOApwxugzf8TGJlWMqarJ8X
   luqMQ0eG+l8XrV8Y+ErzF6GN5ypRb0jEWDIPbI4ofsgumSQdB3qY1vNRP
   lY2YzerT19KEbbdn5/Lk3Rsw+f4YHHpkGNfmTLO5hheWkGxUbVwN4myaK
   OUnsICJRjaPezPUnxU0vzw8d3z7R6P7mTEji08YmSZKC2OygcCbzlwj3K
   bXXphk5kZIbUKcLAuoLQfwvVWcgInCyFOseUY85SAAI6+ZHyeNK1XD3+s
   g==;
X-CSE-ConnectionGUID: 0LXuMPw6QLSEZxcsNoS/8A==
X-CSE-MsgGUID: K7A0X5tlQaWH9WM53pLsew==
X-IronPort-AV: E=Sophos;i="6.15,200,1739808000"; 
   d="scan'208";a="80386266"
Received: from mail-mw2nam12lp2046.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.46])
  by ob1.hgst.iphmx.com with ESMTP; 09 Apr 2025 14:52:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B9gHIdK6PLacLkCcX3Zpy8PO/nFEYFbZdJu0CQEhuMgiY12FCXSvscPMnI/KoUIyxmu7bNyoKu8a7bdjHydBD5AI6OLg47oFb57mPHZNiE4pJyqm9Bt1HtYcUWKc4c9iR/AfAQMqU1BTAcUuiWnoYBnk5XidgpmAdtfetk17jhghTvJAkyHAD3w9CcNq3GVPIz2sOVo0Ga202EfNOTY0yTzZyqHpgUwnwFJtnIeKP9qeN613MyK4m8Ik9+MzNtKDFJYKMIs77+AmfsrkICb+ANpKnI79U6WjiRV4CUz9iMh8iwg0XTburqU9CVk3A43m8PQZ46kDXmK6EejluZyIPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oacyQGrwiuO8Bqv/snIF4XaUeUo+qTwxrPljVV6I3XU=;
 b=MLQrSqOC8zSy8Zn1vaZf67yGOH0uKP/p9klZ6ZTcMAiKJJWauDCTFX+Kf2LsuTNNlPtkL8LCvCfpg1zJoALEMwtjSPe71As3P5C/SJCgc+NRe/ahP1p3wHBFMd9jz3ia2XjtoBM5JM3RZSVglSjr6EddquZ5KqFA1ri79Maeavn/8PezQp4PhDz2p3g/BOjiKw/HeyMynqbTJZjRUHqi9NXcontb2azy/eccvTdTfPtSb67ReGGd5T86uTD3IyTe5s5149aa40Qzao2awhhvL3s5VzkF9Jd5ZpkFFpjFCrGCIjHvc++WKm29DNxYScvsCec/mGo9sClTp8o9q6zxPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by CH3PR16MB5513.namprd16.prod.outlook.com (2603:10b6:610:17f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.21; Wed, 9 Apr
 2025 06:52:02 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::fff9:726d:943f:6852]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::fff9:726d:943f:6852%7]) with mapi id 15.20.8606.029; Wed, 9 Apr 2025
 06:52:02 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Peter Wang
	<peter.wang@mediatek.com>, Avri Altman <avri.altman@wdc.com>, Manivannan
 Sadhasivam <manivannan.sadhasivam@linaro.org>, "Bao D. Nguyen"
	<quic_nguyenb@quicinc.com>
Subject: RE: [PATCH 17/24] scsi: ufs: core: Call ufshcd_mcq_init() once
Thread-Topic: [PATCH 17/24] scsi: ufs: core: Call ufshcd_mcq_init() once
Thread-Index: AQHbpN6V9NJsk8hDy0GM3IlFpnibW7Oa7D5A
Date: Wed, 9 Apr 2025 06:52:02 +0000
Message-ID:
 <PH7PR16MB6196C7D2CAE1E37913264AA0E5B42@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <20250403211937.2225615-18-bvanassche@acm.org>
In-Reply-To: <20250403211937.2225615-18-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|CH3PR16MB5513:EE_
x-ms-office365-filtering-correlation-id: cfaf77d6-cd06-4abe-1b9c-08dd77330876
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?zE/hJcJpDAbdv9UDQ9C0TGyE0NPA74Aa4NckxY70+N/7J5G2IoFsI2la46Bz?=
 =?us-ascii?Q?Z0Qzf96/tJQip8tS3PhE2Skae5NzZgSpBwBMvWFMLgsggrM8Zx/dTkGyFnzI?=
 =?us-ascii?Q?EWTJj/8RlKZhmlb+4zlQjFUToDdBANneznIaERwHfKyKj+r3cVt8Smvwx3SW?=
 =?us-ascii?Q?TSeJ9iQB/ZwW2u4TpPDTI8nNcyTUA4hDFVs1l9bd9xcbV17iqyeZ5YaQ6cAO?=
 =?us-ascii?Q?UnIr47afhi752vX0Rd34bCVpeU0x95hcvAOedKVZJz8B/jH/5PUqvksTn1Sw?=
 =?us-ascii?Q?zXOPKMIcupIip247PqPuVDwCOqgX3OtstHdBgqFNnomFUfz6xFVpsExMAhLg?=
 =?us-ascii?Q?nP6FdQvHWNpHT6y8cI1DmZ44gWEkS++ZK6SjZUgNmau87QEJFjqIJk6nQMgj?=
 =?us-ascii?Q?4kG278grG3QEN40AgVxgTEoWCggdQbtIMzhlwsztbSzJUrqQUP84D0tX5+Fn?=
 =?us-ascii?Q?2sHtxwcVl0IxIMnClGKz4XzEUM/lsfYdfLHdKXywlAXYnjrGOSI4IyluyGub?=
 =?us-ascii?Q?YDP9Covuh25SIimKiaP1C/CXGWBaSgMgX9mRJMl2qXL2fGaaavKykzgAhMST?=
 =?us-ascii?Q?sQYpieZSC5l1IbLpXS+NUQpbuFWgCspvLhFlnY67ffCaQv83sjKDVK1kb0o1?=
 =?us-ascii?Q?Dy6/T6epC4/t7uu5xeFyBnwtzpRRpnw3a9Hq4XeaS9bocCmRUU27XF6y4JQq?=
 =?us-ascii?Q?LVOgDm7RevNHpqjAQEb8jm1Fh27zwM1SBUqSI2dRUDq+jktjAqyS07XNUV/s?=
 =?us-ascii?Q?AGAxfUHfb5epkpUsNHeqv66+s7cIeldVMAw8sz2sRE7qjDcFU5UZ530SSul/?=
 =?us-ascii?Q?3UYLKXfCg0f2DUQ6PbkGRq+y8GYTfeC9uMWR0iRKldMfBGqAhvyre98kXqaz?=
 =?us-ascii?Q?9CilXjYYYHoMZTH+WtGYwNOTOGChPXwFFJHoCol27FELBdA8s+DKjRfp0P6G?=
 =?us-ascii?Q?Nz0YtyLTeHsV8VvnNsWfb2T/ncZv66GlwbrLik33PJV6EVB00tPfSniUFAfi?=
 =?us-ascii?Q?KRqm5KI1i3m6bk7TiF1WODVRAKh+zCqFbL1hB38nJKY26KZLrUU+vgbXs8NU?=
 =?us-ascii?Q?Da2ksDmcJhBb4NKPh5JEn1DMYUG95iyHMDyqFHRrUIPTxhS8Jp4kcBU4Cz/r?=
 =?us-ascii?Q?kCfzJwacQtoAHIT4f/VYdL9vNZFMdPbAmLik7N4yWDnWE04pxxTIGZqLn0BU?=
 =?us-ascii?Q?ejNpwdubEXCzwFIBzMEOHFruJSOpXgH9dVz+A8nFFhzqWW8X9kErizt9rEIJ?=
 =?us-ascii?Q?8CBQCC8qJlD/KQ0YUWIiFwhOoW7+tcSwMUjMIJu3QnID1b888pWZXbWrTCpW?=
 =?us-ascii?Q?iTc7Q0PVnm3uBxqhZqN3GO+KZ/mZOGoAOX4eENO3h9KrOYb9pC7Fcisx+qNr?=
 =?us-ascii?Q?lcrjJoH1ilzmbiY9QiTFKFaOpSOtQn5Kkp+VyMpr2TNgGPkTGRAWnOc54g5n?=
 =?us-ascii?Q?4pgnDxhMh9iyS+yNfM/O3TBuu1kEVpQo?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?h0cMlOK8gqgqLfr6PG7tmT/fYTnwFmAXu81RDLddHsl1blQny1bzkkRlISFW?=
 =?us-ascii?Q?2zNiUZ3MKSwAhr0oy2j/B8s/i+RbI1OrMvBfoDReEapTAfOfiHJl4F8ZpvZR?=
 =?us-ascii?Q?NJAh/fsK43IaM5BfYPmopz1sF5/rEOUhgdaVkm1ofkgrjiABH8ywvtLgyJ7k?=
 =?us-ascii?Q?ivloqSb0IgU0choMw/brxbxBMl3J8/gfv4DdSLC9xeW0M6vWf1ndd2/cEZYM?=
 =?us-ascii?Q?qxHeF38gfuNxw5c7WKO5GE+xu0I93wSrdV8SyCnJUUQGYExhJp1CVSjq1QnF?=
 =?us-ascii?Q?a+wMfT5GKjcORtcq/Y1I1AnW7u5HJMxxIXlvUlD4GO2ZxeGbnv+HJvRWr7U9?=
 =?us-ascii?Q?Khny+NDm2vnhl+eLjixvgU8/oiBeJVDStWwJ9f4mj2OyOPzGppnvY69bacGo?=
 =?us-ascii?Q?v3hLHG6iQIg6Grw93brGUf9AEYdZ8GmnfGfMIVD5OhQd563nn4FRm4ek8Axr?=
 =?us-ascii?Q?JLSEg+YZ3WARfiZYQayOolAMEiGXGF4YKTiCmW7LOw74BbYUMeunF3Klot2Y?=
 =?us-ascii?Q?85coyu1MhTcl1V1eUedbUKhYbPp2gxwqgKg2cIw43g6wBLCK7cw3sIA0UyAe?=
 =?us-ascii?Q?+LZAPElfMUJFJWPoT4QiDEBgpKR3/P3L/PIGmDguU1ou4vMfzYsM9/79E0bv?=
 =?us-ascii?Q?XAySMbJ/4FVqJvfArYmdXnyRkLWgUX9B3t43ZFVQJV5iKZdkoNwXbnIll0iz?=
 =?us-ascii?Q?xqJ7Ce9DsTkEF4P/5LcwMCeMJ+x5Ma9KzYyuoJyCHzenFHsy6MUpTp8zhyUU?=
 =?us-ascii?Q?lsk1mPh4lBPjY4uBvtCQrl7MqW35JGpC7Z+R3b5Sex4v3SKUup/GDt4Ddb2u?=
 =?us-ascii?Q?0h00UP7JHWY6zymVrsKXrnXdVIb85yrJDLm4MRDcgavDRHRjgnf3bVOBqwb5?=
 =?us-ascii?Q?OjjYDDcPg6wQyjZsiG8UEuw+KUo7mdiNxvzqhuuv/cBnVPzW/nw9zSNQMVUy?=
 =?us-ascii?Q?p5MG1FPM6eSQJtYP1ZqUSoRpyU6rqyGKbgXx9h890vrr29XAHluUN6nb6P2H?=
 =?us-ascii?Q?P1LSl1japznwIb574MqMAvLqhBlSQJqEVkHGaQlkz0eBvB1SzGRcuUZU1EMP?=
 =?us-ascii?Q?DkkWqMnWFzoKr9azeguIO3Cfi0a3IsNkYrnNiIgivK6K1IUWU3ntiKNoNX11?=
 =?us-ascii?Q?WOeQkxfbcELqkMfPoITF15UZv2uT/1CqvdwNx+Bg5WRbab8tl0ZalG4TU8Sz?=
 =?us-ascii?Q?Q9hxM6gQXbHug+TBVxrC/O9Qg0TxW1o8Q/4su4JEib5eVjwq7POxbBuo8SGQ?=
 =?us-ascii?Q?O1bfT0iIFt1vgRVY6BCnpgv4KYJEq4pC4fDPRsmBiW2Z+XwP/YOf9ZAmoMe8?=
 =?us-ascii?Q?50muZZNPL7MpVHTsmhYu4r+H87RMaUDNCUzKYm0A41+VxE476Vxf8UQ3apAn?=
 =?us-ascii?Q?QRrslYgIqNzXPPZIeBZbAHt90euteo/3WRFDnaGAMcniJl0vjOdvu5NoEnby?=
 =?us-ascii?Q?MNcBqgA8aSdu8EuKwIC7fC14zFqrkc4FDh3LNbWoajQKFxrFBwiWwjhW0scL?=
 =?us-ascii?Q?ilN+0axkXTwTUBllzA02SnCBMwHLerDQdYfRirW58DuogiLsWbZVCR2q8Br3?=
 =?us-ascii?Q?/3W/EF7xoe4VsrozLxm9ho+Akv0taDh3f4w/2AOb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gfTxiXbTD2uroiGJC3TNQOfPC6vhxG+RHu/cj3mOf2kbKM6lKXjJjgYwv+yz4Q0I5+JxIAOLBEm/IMTQq5Z+sMxhPBC3Exhrgwc8rQ0QCLr17IuCutLXqOa9czD5OQUFUX7MvAtzk6G46q2yW4lnGD+xfBzQSfT9ai7WsREJOPbmMdvE0A38emIqXyCM04Nrs1b5bc/yG663qReIghgDxnJo15gYeeHCDxmx+UgJa0btu7rGQz9iJlgxarrXl06/jv167YM9OrdWEJXknIw96s61vGwGgEcpweYklZM/cyaszyXaNcrPOIhVMuLmmmdV4P0Ax3lCgQk15+TdX3cjxNj6mr3TcUKu+3sJhORkL0pD/+Pcmo+HB/fQZjhKtu5exQH2rjOjhJEooUPo4TOaQjqDgsnVMJdcSgdfUi5NLlkN6nTIXLeM2DX19f76EtzH0+ZpNc3+0m9mkcpzlc/4KAVb0nofkwcysRFeIODdL5C914D0VdfwSA8h4QcIJgBZPkWUtU9i2AV6FwDv2t/RiPTg6XcnG1BHzFN77+lKhjJ6HX7woAAjVplsTFpPQ/xcF0bTMz7x7hi3m7csuPFO9iV0tkiteQnFx3qjnqhprjdpUb2kDANf0tbgtkaGFLwv
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfaf77d6-cd06-4abe-1b9c-08dd77330876
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2025 06:52:02.5068
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a00OxpX1c86+9SsLGP63BTroBJ0P7k+sWnzsgLG+LiaeE8VD709EInED9XYyQ484sOZ/z+i367B/cgsPQRceKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR16MB5513

> Make sure that ufshcd_mcq_init() is called once even if ufshcd_alloc_mcq(=
) is
> called twice.
Maybe elaborate the commit log, or even the cover letter,
explaining how patches 14..20 fits in the bigger picture of removing the lr=
b array.
Because it seems like you are going through a lot of trouble,
but essentially the queue allocation flow stays a 2-phase process as before=
.

Thanks,
Avri

>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> acbf173a3732..6dcac4143f4f 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8733,9 +8733,16 @@ static int ufshcd_alloc_mcq(struct ufs_hba *hba, u=
32
> ufs_dev_qd)
>  		return ret;
>=20
>  	hba->nutrs =3D ret;
> -	ret =3D ufshcd_mcq_init(hba);
> -	if (ret)
> -		goto err;
> +	if (hba->host->nr_hw_queues =3D=3D 0) {
> +		/*
> +		 * ufshcd_mcq_init() is independent of hba->nutrs. Hence, only
> +		 * call ufshcd_mcq_init() the first time ufshcd_alloc_mcq() is
> +		 * called.
> +		 */
> +		ret =3D ufshcd_mcq_init(hba);
> +		if (ret)
> +			goto err;
> +	}
>=20
>  	/*
>  	 * Previously allocated memory for nutrs may not be enough in MCQ
> mode.
