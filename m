Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0556528DB3
	for <linux-scsi@vger.kernel.org>; Sat, 24 Aug 2024 10:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724494348; cv=fail; b=VuVXnqiFHaHXSf1P9CKp3yv+Edjcm8CUPr/7KQNO0jB6JphCOxmTUCj+G2ajeFgSO7bd3RpsAvIYBGG4P3NslMJmP/i0NiUE8q2pZKApbC/okgcXAEG/U19mEfaVZUCJcOA8WIdaKUJs24Ta9/x3UdHaaT1CkvPZpV6Z+aDmv20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724494348; c=relaxed/simple;
	bh=4Vev5tIFIpv8qPZeEc6oGRuaXlUWp5r3IF7pl1ytGdM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fdd8G76LJFdnZJ9Nzv1tma9wPIGFKkm17gZgfXO7SYdkFv0P5ll1PsO0zMbk4M7f0aI05th0cyj85+XNlcVdstiv5XWvXw5VIYVbgYa66WhIYoVDRGxySvYiIw6Zerwnq9QUz8XtL0jYgJzoVrnu42tOOdjNDKOR49Rp/ym109c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=CB+jsUP9; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=PzDVX9NY; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="CB+jsUP9";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="PzDVX9NY"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724494344; x=1756030344;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4Vev5tIFIpv8qPZeEc6oGRuaXlUWp5r3IF7pl1ytGdM=;
  b=CB+jsUP9XOLT/f3x/aP9QaSygXlfaVcF+5hIbb6geOhRGPLgMBcitOmW
   UVYJ81TUqPj4Din07eNtJSqhplRDz0bfmipnNu+w9n7PXwJHC9I9pxpe3
   /k8B18twD+qqSOVZxIGM8XDMS0i3aeYv/YyE9Qbq8hl2m+9zHfCmX8JUo
   AuCZ8rjE+iO/mclnPnE7w8d6Aj+3K7tWQCBd2nsFOpoNiPXaUiPic7Aq3
   XHRDpQaL8B9plqSC3IE86jy6M3UJnR+WJu+1pL0Spzimv/CV3PQdCv8zf
   ATmFb2jXa+yyJiycFMBw+Byimjze2hOX3YIxja3AEagg2plX/QW+jy6wt
   w==;
X-CSE-ConnectionGUID: Dkq8NStYQwmwFm6nDmn1Vg==
X-CSE-MsgGUID: jWnDbnQUSr2RVJTg5OqqLg==
X-IronPort-AV: E=Sophos;i="6.10,173,1719849600"; 
   d="scan'208";a="25116138"
Received: from mail-eastusazlp17010003.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([40.93.11.3])
  by ob1.hgst.iphmx.com with ESMTP; 24 Aug 2024 18:12:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L51+yV0vpXqOW33adybUOoBGR3pP69IJf5eFz5+NR89LW61/teKQA2XC+rclrFyOJWA3EzKZK0WJ8Bhh7xuF23fhvPXMIlXAyLgEfjgv6TIgrwrcW9bYoRoHGCNVi8sF4v1ZzzUuFpbJLvC0dRBaePE2eR6jEmZJfNqsel1dcje3HofkovZ5V8hTjbTH/8TCUbbb/4my7f83TsB65tUGop7WCtc04TH9OzAnLNvSO17nOpExU0ddsc1s3u/+8/9bW7qtcgABBtpK6jbAyTqScixMN0TEWqjHiXFAFWAQ9KsP45B8XZGqd5CO9INVmeZhpTN/lerHFM7Jdrzr/UIf6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Vev5tIFIpv8qPZeEc6oGRuaXlUWp5r3IF7pl1ytGdM=;
 b=KEzKraQZ16bun8tEzPTNj1azEQJPVhJKvaRrXh3BcFqcZ9fjgCFaSJVTieJ53Y/XAwfZOZdgU4xdx8+DLtm1Rc4MRvC7Zl16GHpzpMVKAbFD/3a3HSRbJ2W/aGIb9VE75NkpQ6Vk0ipdgkD5Gv1zQucYynYlxWphwCD80OF1SaDCXusQ9YE4EBtf2Jg/QXMvoC9HzQgC/8kEplb1pOXpNmUMPiLCI4t+4gWnBoHUSIX7MK7vcBMMKPNUn1p3oDiNVWKo2PDTvdPI4l9OwbuX6yrQ7JN93kmCnWH3lPaNjQSKOAWIgqg6LowE6hSNrhPGzDPVmLL58aV7sprvgD001A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Vev5tIFIpv8qPZeEc6oGRuaXlUWp5r3IF7pl1ytGdM=;
 b=PzDVX9NYA4jZIN3lxgfbd2uFp06opt/qAlWhpCUWam7LEV8G+SUFXEGTfDZPZJOlzi9zr89aB+P35fD6OwOHCQS1sxytJi2iJD9lteUDQbLG3cshC71IgbEqokIKngb5JYjQeEOFpWaDGrRCbuRggw/+zWXYlGnA4JSuhK2zd+c=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6763.namprd04.prod.outlook.com (2603:10b6:5:22b::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.19; Sat, 24 Aug 2024 10:12:20 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%3]) with mapi id 15.20.7897.014; Sat, 24 Aug 2024
 10:12:20 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Peter Wang
	<peter.wang@mediatek.com>, Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>, Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH v2 3/9] ufs: core: Introduce ufshcd_post_device_init()
Thread-Topic: [PATCH v2 3/9] ufs: core: Introduce ufshcd_post_device_init()
Thread-Index: AQHa9NuBB7jG1GLYCEa0ue5T8WYHs7I2MlUA
Date: Sat, 24 Aug 2024 10:12:20 +0000
Message-ID:
 <DM6PR04MB6575B9E2A39172C13377E5FEFC892@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240822213645.1125016-1-bvanassche@acm.org>
 <20240822213645.1125016-4-bvanassche@acm.org>
In-Reply-To: <20240822213645.1125016-4-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|DM6PR04MB6763:EE_
x-ms-office365-filtering-correlation-id: c60b7546-0d35-4f1d-a979-08dcc4253d5b
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?bgawnqJccjhAAtPtCYdot7Zz9Up+vYcFVesb+7b9/V9YotZE9xLPIWavhNGg?=
 =?us-ascii?Q?Lyvp7Y/8k0ka0cwlN5X9hA7d5AOh8T5a9bBH7ix5Z5r80KaK38M01NE31P+H?=
 =?us-ascii?Q?KwP7Sl97yAs1+TZM8XeXLJ9DbAckoanHqagvck18B00nnRpEeLv6Whs7rnyd?=
 =?us-ascii?Q?xPe1QSvkEecawk30eblXb+xpE/I7WoOsOKN4zDZkIdkr4ETviSNl/QcX/Gqg?=
 =?us-ascii?Q?ZjM2VSDqvgz9EcdJVUU/0c1Gu9MGdn2IFtU5ftDS4DV0KO8HxuitQwr0x59l?=
 =?us-ascii?Q?JUJ/0cOHzxySJGl3TQQZ0Hrj+O5Uf3DTaRGiYtwJ23uv0qrBLpHIpHIaOnmf?=
 =?us-ascii?Q?LO5tGj6z3279/AJDACyBIsfbTngAePh2/7Ev/qYhdysyGGM+dPl4WTLSQQB+?=
 =?us-ascii?Q?FVAdVEwhWNwXSz/HCrRK3AKXmImuvibpKYvZPhcLWCRT1l1wVn9aPlYTi0LM?=
 =?us-ascii?Q?DX3A7npmxe2BheHKUyUgUiSCW+if7wbU/HM5R2cLuoMXzru+Lav2AMpFI4At?=
 =?us-ascii?Q?CKZa9f5P1xkbxqsAueIptks6ecEjj3gfJk5mKbHX/uNYMXYOZDvO4S1fhqb+?=
 =?us-ascii?Q?E/6rZD3gr8b1tYzpJWwSz5z6/tKUEb4cj/3lUmaQgbqljDNYBxVkSmQLyixW?=
 =?us-ascii?Q?OAfm2S8q6XOd0W17x0HvkOvE4M8PG251cVzUyonh9Ctg0zmqQjKjvUr5nnEw?=
 =?us-ascii?Q?YM84matfTRt9kjCWxzWu1ov1hE4XH8E59AKmA0RDf1HfahoWrv8KlvXFop7r?=
 =?us-ascii?Q?sGIRfrynJLwm5ZRpz/iiPb0HKtY2CxuWhy8tieLTDxM3G9decaGeX3STLT4/?=
 =?us-ascii?Q?NsHnbFZipZrSrjmRM4QsTplWpAc3YfCRXCtC8iFFR2BcDOsMfbxmaZY2bvks?=
 =?us-ascii?Q?/4MFyZ3f/yvHUUMpwBGaUk/GOl5jq0xzk0N1fMKPOwhPlntpHtDYIFq5rmE/?=
 =?us-ascii?Q?2QO3IwqdUk9ZyEAY4Wx2YG2XjqO5Gx3CPS9tUCnkcH9YHv9hQXADB4VN+PPV?=
 =?us-ascii?Q?dSEcYMaX7mcMcOW1YMeUSyZ05LxJZUlD3ju2Bm/5Z1QTuwJ+IXRzirvy8l/z?=
 =?us-ascii?Q?ynAb7h/l4JIJ1mUb8VMRq1NRRLwI8AizQbHyYnXd70ZNu3qb6xPlTGKKdxj0?=
 =?us-ascii?Q?Z2IVJto2G9Q6Y6qtisCSc7Kxdrr3S2G9VqakvAxkn4AlxVveC0LF8nY8YbnJ?=
 =?us-ascii?Q?zVmTm34sd24dxnTvu3wFVdwUL6cj8nclFwFzRjeTT3S36XvVEgKS7/ejO/P9?=
 =?us-ascii?Q?QaqHdMzna54kfrgoONdUgfcNFYrkm6dkLub0jjWUAQqxpy+0ka7w1tvLluWP?=
 =?us-ascii?Q?BM+D7uZCFeaip/EOsDY9OmFuPCkeMeQQFR6mitwc6BB8oC/uKj40LaMKgb5r?=
 =?us-ascii?Q?vLvlPagG8LhE98M11blfOyhTTUBbIKzmrQHFrkZSInwvfXTzzw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?q9SywCYcZX5Bn+p+8taLS6ndBZkL9XxWHqx3rp9eTisdmm4fmOBL3nkafdjP?=
 =?us-ascii?Q?IqKDiy+fkyppuJF9q0NsZOMxFcr449AAc0QJixeG+ApvPIP0/s4f6UUJWKk2?=
 =?us-ascii?Q?CiKLTpi79euhoi809Gg408cX2YBMN6+zj2kzu0mtPQopw8083wn1ZjxafpiE?=
 =?us-ascii?Q?SScx/cvIxGgq75huyYxyBWa1I5hRuA6bLMEIac0i/3gU08egbTnwGVJqhiV3?=
 =?us-ascii?Q?UCm06IlTL14ayKib8IZTqIkdHbu/OUEWGKPsruQZAzG3P5cwAiPN8+86JZX2?=
 =?us-ascii?Q?VnGMSWC5b8M+d121NQ0+b5YQOXWXva2hekCvtg++tQXLiQEGJ8UTKDL3Ag3F?=
 =?us-ascii?Q?IWu8i1baTJGtu0WUqt+u2Z3nYTcYb6QoDBl7ctchqeE0J6Hh7pcIPackbpq0?=
 =?us-ascii?Q?WbjZ7Kb2IgNVKFLBtKqmLks0Br+Z7yx42R90nnzQqRvNNJkOJRyevNLSMyGa?=
 =?us-ascii?Q?+erntY5kvr3FcVz1Mqt/RHkmiok7Yv5D4kG8ZvLFCLVW/2uHH+TkTCRi6pg/?=
 =?us-ascii?Q?5OZNSVkTIBxyQjFDZjR2+M6fwaw6uagxcM0z4ToGwM3lIJTqUjJbcsj/UlOJ?=
 =?us-ascii?Q?QQyEahS8bcvAD1YI/bVnGe3MwaF5D3TZ5JBurg+6wkin7Pu1epKaSZjuo8BE?=
 =?us-ascii?Q?E2pXa7fJN0eJOQHHEWOZo94BmQiAL2xLrHSVlR9oO6p4n1vVFS8GyDkOWE6A?=
 =?us-ascii?Q?zABi6XuPYaH3iAzckoooPX3w/9BHG5Ozp5Fn16SjXkzQoBX3Z3ku8Xo7Bu8w?=
 =?us-ascii?Q?ndTG4bg/Ne9Crfdo6Jq+eH9zJwWW8ueS6RPnfxEXJNhGBhPVVMzB8xW7J3g4?=
 =?us-ascii?Q?5OQ0atQnSPkVkXrzYrOJId25Ze+/bswq2vXr9C2OjX7yaEVw8lp3c0nALxyc?=
 =?us-ascii?Q?Y2TfbuiiOThgnfX/y24SHa+wnae13tWH/Io4qdxahrMxmcXUBZikEUzFcuLp?=
 =?us-ascii?Q?i9nZVZ5wbbfF/gam7H/vul+KjUy+YZI5otPGNdWubqepWegSREBNDH4kIwmc?=
 =?us-ascii?Q?XhiG0vJI58uG7oROsAeJ/VzdpgX4uXk71r527WVchm87Nt3s7C9XaJIUc4dF?=
 =?us-ascii?Q?ggh9j/VdofnnLTp105w4kuVNrdLb5gn+hMSFNdMaYyAuLKcvdv1xR+4L2b3n?=
 =?us-ascii?Q?HgsZGDZm3PNFoE5ispFsrpXY/sEhOWH1z33bBUrhSj5QB56tZ2jHZF/W9wV2?=
 =?us-ascii?Q?ga04vvH5jx69qOfAzoU1u7i/ViIZKDwaF6YCWf5EW2PYUUkGp8lpBZkoq1aN?=
 =?us-ascii?Q?54UuQCbID3SC4SAK0Z5Ze9gL9azidKztNvGm0z6Dgg0y49UucrKlRGUs548f?=
 =?us-ascii?Q?dOwj7Sa26pKXgvH42iS8QMZ/wEuLxPn95vrhcI9JtXWnWi9jMJFLRQh9bSVG?=
 =?us-ascii?Q?iir6vPEXHI0L5wx/bB4Odr0K9ERg/k+pQLIyMQggm1jvds3UJf6VWi15F16g?=
 =?us-ascii?Q?/iH2fRHIF1lo/fC8Fl3lASk8cldD02sjrzQlmjC6dxhoZpk6dQOz9nuxgXuq?=
 =?us-ascii?Q?tN1r9ikGqhend6rDjM0ptAtOvTix2RbR7c+PTTjXX20o3hIBwEXvWnPrBREE?=
 =?us-ascii?Q?HT9liBq6CIUmoQQRFXXnigMhkxdSqTcYnJ93x+g7?=
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
	UR2TxRGTavN3uJGJMK5Ubc6+64XLo65QihpO6hzU/nDPIVP3i6hNfuv6rvY/7TUt7JDnO6qg9WjBvQhE8XAIKcfy/20xPlZi5j+DKoBJJhA1U02WNH5k9sr94XR9HQVrNjqRnD6k8jDfYWHRxYkgovQJPDmXqZw1RbyY+I26kjcaeXcFu+qwcvaUhWEU4BSOcrm+48H5vbO/u9tN+gL/tDvsGrpO/kbHWD8nfII8UXNBpWCI4BOpVd3gcN/OSa1vUfmw45zObstCwq5EyGl1XsF6yG43TF84EnQ+tzYrIW+iD5aLbZ6htZhGu0qg8GbTu4vFsUH7RYj03/KWni24RQrwYdKn7C6HWCxW94UMpyoFBpJ49CHnWlu5DLhDHH/JWKPhee86NmsTJhU9wpXZr3jNc6FHLUQqfTjAJ80rWUoR5q4G8Fg0DwIT5EVmsQCsOmSdWEkDViJrsZQxKgwn3QLDJXUNcxuvdsRrlvugLYPbcfaO+eita5WscuVDH0mhzhfLeLIjKCJiPUuA4cJGjSxKbUbYCHgWtA2pKs2spi6XYOnOM+a8nEoV2LDoguRcZGuKJk9apSZf3X7jiw17aoX724nIwCE2MiFhgO6GUeAvVX1I86hFV3G0ODjeQEvr
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c60b7546-0d35-4f1d-a979-08dcc4253d5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2024 10:12:20.1607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WEsfq8v8UqajmZTMERTzKZ6W7dR5jhoG9skaK6po4lgG1QDV9MXVypJlflAkYSKxITYxu6ncJWAY0W8FQRkUbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6763

> Prepare for introducing a second caller by moving more code from
> ufshcd_device_init() into a new function.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

