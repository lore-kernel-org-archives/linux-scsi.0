Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2075.outbound.protection.outlook.com [40.107.243.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB33266B45
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2025 21:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739482006; cv=fail; b=PEK8hGwomqtlBisynQlh+qB+mBoh6t3jyZirf+AFqRJacAchu0wsa9DRAoN3VwwUXkHuvcUgk3hM7rWGeJrXxxlmCGXnuWLScTarSDqsxge4SQnlGBy8cre4ovGOdAtOY2K0xcfYGbuxgj/iSZDnolTlWJ966/YY8dlfHMh30kI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739482006; c=relaxed/simple;
	bh=3qm6fLn+RwmGyUKWhme3m0A6QnPgN66AGq0p9z/jL4M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qUI6UfCyWvHFEGzCjY9TselBmTC3e1VgJ2HcRfyMYgVg3tGrpuUPR1c3K0v+vzklYpHLUzOb01tlDNrb93+afPrNeJ3Xt9MEhMEqv+MR6ilq77KtWyaH0xt3QxJghZFB5u6k4DD+0NEyfqWqqoOGW1+q+fzVFPVk73QGFCyuJTw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=v8XFDrC5; arc=fail smtp.client-ip=40.107.243.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="v8XFDrC5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V6cTZginwEk3uqewquzRAynqw+rM9Y5h7ViW62k2untOX1WFBitMrte4wMLFGcmI8cW/Nygh0dvDDhEYp78FU3JGV6nrdksWJIotaRgaw24jGB8cHjxP0luPLQDRMzBwPeG7NEf/uc7CMdVe5KJ/vbmEVE4o8YqhddHrKvvaHSuZrh8PAPs8vHgdf4uDbxohxQEKj6C1/YmwufQ3hsiZ7rJl5ZZBLJH3iwOMpx0C/6tvzGoGeCAZwAnwNA0kR0OcQf/HYo/1lBCGcDWGwPlQ6NqpqOHqW6Td9lsF2ycLZK3rqzEV7rGcduCbvqFYrc+Y27OlFpQHeLtQv60ps7m9rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3qm6fLn+RwmGyUKWhme3m0A6QnPgN66AGq0p9z/jL4M=;
 b=X97MeEJ7UX2hHC0QhcrbuyJGUT6vJZh+0EaynFvd9X2VXncGHw2YJ7bhfEH0KQDdai5fJ7zPp6f171WZoVoiv71KTiKZd98V2ms+8FETjK+796ltaHM03p9X02U5nsNqludEte9CfT/DcNkD0CfawB2+Kg329lmyWFFdrvMJiQ7LN8Sj82Ev8ZbNbhe4fR9ulG2SyzJnIzznHY0zTb+PeZUePJdHSxHZXRCRZEhidI6N9mJmKZHk90sgshTuVn/VFfXdcrMxBGmw8nFRk42YxY3GmOseSsywOOsLNcVdgxunacMvldNdxTOymPt9E9Q3VnLJ4M/FVzrPRCPUztIUuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3qm6fLn+RwmGyUKWhme3m0A6QnPgN66AGq0p9z/jL4M=;
 b=v8XFDrC5YQJtcxeFEZT04lqfSFy+aDp5uekHPQlabQyx9IXMJSBBzI09OP5+9e4J96uvtwi2sK0GqlsrdS1ou+j2PqckS2dT3ONCm6AQdNapvvtEHVNkBDZ6MKt8RKNSHSUhJ+KZSah0QPOh1TNA4DWhZOkZzbGA9FN31/wqGUHh2WSu3sADRiLnc434uzY/KyLRmoiTRKFGYg9DTxdO4xVDG0pn52SCYhEtmHzBNqOaFcpqh1bLTYIYew0FliJdqwK4C44ELPXPyAbujt4w+FxScrqEWkhzblxA/mjGRQyX9gqRUATDdL+TYSva714smWQHKnFRSAkXnDfU4Sr/tQ==
Received: from PH7PR11MB7570.namprd11.prod.outlook.com (2603:10b6:510:27a::8)
 by PH8PR11MB7991.namprd11.prod.outlook.com (2603:10b6:510:25a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.16; Thu, 13 Feb
 2025 21:26:41 +0000
Received: from PH7PR11MB7570.namprd11.prod.outlook.com
 ([fe80::f249:c679:94d9:9898]) by PH7PR11MB7570.namprd11.prod.outlook.com
 ([fe80::f249:c679:94d9:9898%7]) with mapi id 15.20.8445.008; Thu, 13 Feb 2025
 21:26:40 +0000
From: <Sagar.Biradar@microchip.com>
To: <"martin.petersen@oracle.comjames.bottomley@hansenpartnership.comjmeneghi"@redhat.com>
CC: <linux-scsi@vger.kernel.org>, <thenzl@redhat.com>, <mpatalan@redhat.com>,
	<Scott.Benesh@microchip.com>, <Don.Brace@microchip.com>,
	<Tom.White@microchip.com>, <Abhinav.Kuchibhotla@microchip.com>
Subject: Re: [PATCH] [v2]aacraid: Reply queue mapping to CPUs based on IRQ
 affinity
Thread-Topic: [PATCH] [v2]aacraid: Reply queue mapping to CPUs based on IRQ
 affinity
Thread-Index: AQHbcz0tB0IW0OqxSE2ZE7WljSjIKbNEoY/mgAEygn0=
Date: Thu, 13 Feb 2025 21:26:40 +0000
Message-ID:
 <PH7PR11MB757026166DDB8068830AE420FAFF2@PH7PR11MB7570.namprd11.prod.outlook.com>
References: <20250130173314.608836-1-sagar.biradar@microchip.com>
 <yq1mseqwoaa.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1mseqwoaa.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB7570:EE_|PH8PR11MB7991:EE_
x-ms-office365-filtering-correlation-id: 40552f5d-469d-44c6-879d-08dd4c751b1d
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB7570.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|7053199007|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?cx8t6VJo9t1jK8YMCd5fnnJbTewBsVVgHq7A5j7sE4bfsSb27F2HMonf8U?=
 =?iso-8859-1?Q?yTr98aGRsFd8KZGaR2610lsojCOlLEOmLvXn6uCjJ2IQb6m+IUFc5vcZwM?=
 =?iso-8859-1?Q?iIZSeF8jpLf7qD2uuwGkoZRixRiJ1Yy3m6K9iC3x/1TqgYj5WHZV7L/7PC?=
 =?iso-8859-1?Q?Qsu/mNcO9Y3/xAOysL1JUzhJf5tQApyam5nli66DreWr+9hef8JWnqMG/P?=
 =?iso-8859-1?Q?dwVTQhAdH47tQqCkbiUyXRJS3fCKsiIYDDpqOTbHxmXwUe2/yg8ol20IBk?=
 =?iso-8859-1?Q?PxC2vjOVOFcrb3zVcO7HDBqC5VUnNrv42jh+bOXAxAF+SYVqUW0JH3yN4j?=
 =?iso-8859-1?Q?58NPzJquYTyqKsGATYWMNsKr4Sk23S4pa+ureTo0Klh9Y6Fzx8fpMup9if?=
 =?iso-8859-1?Q?Gn+Vchook01waBOOQ8hPOevjfx6/G6J7vk5LY4BEtcBOCFGxhTf566ipM5?=
 =?iso-8859-1?Q?K/P/d6fZdt1JmjR7ZV3JK0dyHDhWaF91N7vfpMvFlXlsIAURmmYi13LxWF?=
 =?iso-8859-1?Q?JBfj9TPRv2XTSpgvHIBqumPVYSxTT6IIvIcF4aOsnuGSaPrVORKkJ8yC+j?=
 =?iso-8859-1?Q?qLMrNyrzCsGvdprnN4xQxPQ67y/GVRPp+gRI5fbZbAY6XlaoyxCEeHXof+?=
 =?iso-8859-1?Q?UUDAJ0hR7gnk9rJ82edlWrLDP6R06dPWIz/btS1OsEhFX+MmGLdzDlYsSA?=
 =?iso-8859-1?Q?U+pMcgHhgLsWLqo8Dmm8zrsnDF0ps8f2nh2XFvsUYyKE0O1hdbhkRLZZdS?=
 =?iso-8859-1?Q?quTVxKoK/p189c3MiYQn4DYc8x2kJmz2IUxy8BXSu5LTNeffStuPh4XC13?=
 =?iso-8859-1?Q?PR+QEe0yNSOO/6OPcoqHDmQreKkxMTC5bU7M7Ud7WXcq7pgEVIBvgEJ4UX?=
 =?iso-8859-1?Q?1weaVyYQbB5BBQekd8IJV4YRqYGGLJAWNhjOIKRuXc0ifvN5y+UOQIpjQa?=
 =?iso-8859-1?Q?gpe2kXWRW7igVnugCqBJZaXQJM2gzDOyoD1HYX/I/8tWSeElKJeoaCXixn?=
 =?iso-8859-1?Q?sznCqBrnQ+IfrPULEsHV7GnzX06YKkcsSVuvWU408CvXVSizYpHp1mG4iC?=
 =?iso-8859-1?Q?vq6UkESMw0LQGBk6OKeGG1iyc6xe872P5rhzXK/MtwcQX9AlB9TwOSihgs?=
 =?iso-8859-1?Q?be0HlZudkSwHoJ+5eJNvwLn77kZ7L2HXLURdJ/MqSMJYPjAnBZIJvG6dOn?=
 =?iso-8859-1?Q?uO1h1XF91BR2OoK90969wIjNJE/XPFv5YSFPeSabXjtiFErM7c2+O+LeIg?=
 =?iso-8859-1?Q?SuPtJFWYyFM3yEBlwlNzspaSFy8gLtxVu4F+oX5UeTEvsnkpNRWw9ms3UR?=
 =?iso-8859-1?Q?HB3KGd3fj8IZL94dAq1T9Hq/7CTwvwAaH0DFSO+oiPnOVqSWrwtboyVRAX?=
 =?iso-8859-1?Q?85M0fqNhV1uuIlEkmWMiIhD6US5mZMXtLQVV7k7I9YdesBylFvNDVx/rJe?=
 =?iso-8859-1?Q?3wuRlQvosogCBy2kAbhslyUvKVYLYCkEdw7/wC5AdJPSbPhJrocgb6TP+Z?=
 =?iso-8859-1?Q?dlReV4F+qVWVfwPHG+cl8X?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?0hTcfEGQt8O+kpZAMLCo5B/sZCOvA4HN4i/SHxhYex+O5W80y6Dzf/GHVH?=
 =?iso-8859-1?Q?dWvca44T1LhpfWT0zT9sXPOkz9iuH3kyzc4XPn9DPJftrGa88jtLuu9xrR?=
 =?iso-8859-1?Q?u3PpHxGazROrO7zhPG1vcwRnWOUlAqeChmoe04/4w3slp+/WoDLaVghwT/?=
 =?iso-8859-1?Q?8knxQnng87ve049q+dnv1j8OCjOcRwRkqGk39bRfFOs90rYcTIuP4ujTpL?=
 =?iso-8859-1?Q?S4ZPSLmZGiuvKJvnNSqY4dKoovzh58UWYrk8hAKVlKAbkwBEJHP1BMOaC4?=
 =?iso-8859-1?Q?deUdkASP5iS7YXI5Otdg4KxQwa9FTYzoUmyKhlQc+q56LP+2ZkpVZlria3?=
 =?iso-8859-1?Q?1b75zbclQ58CXu6MNcJm/co+DUOjfOr4L8C2Uiknpe/TF7nbEiO9i53C/x?=
 =?iso-8859-1?Q?pb5SpDWWYTwWrCi8+XMtwSTrzBDafm3SW6apuVD01jzL172pt086b5byWJ?=
 =?iso-8859-1?Q?q2f3JM07oP0d1qH+KHMQBDKW1zqSnTxcjAl2mjAQaQeTWQrzFXDoRpkJx9?=
 =?iso-8859-1?Q?CA3cx4WnZsohHZjDPBudytbynJ2vwX8NmMV4R0R4VdtEWxLT5LGZWmaE2U?=
 =?iso-8859-1?Q?vQUD7kmwMI8USRYXq+hoRtuld1vWfcomK4KSqPKGFxG1HJu1o01M1zj11w?=
 =?iso-8859-1?Q?/e7FsjqHz8yVMOHDp/Gg5RS9UZjkW6HBIE04OJ8WMKSkHQdNQ8YDeBOHQ8?=
 =?iso-8859-1?Q?HY7viUKsH1b2ynD8GNdFzTtqNct/Wdr2YazCJE4oLSzYh6F8WEhpGc3L2X?=
 =?iso-8859-1?Q?rAoT8GdVEjAVk8mNrZv2+TCOWQhS3c+VFlCR1aky+/PBm9u/Tkn0s5g/wM?=
 =?iso-8859-1?Q?q8wWOQazsnBJJevOKHs0na0lXNZRpXJgLacLlm+cbMcSKrgNEUPkfyPTW8?=
 =?iso-8859-1?Q?FzLHmixIKKIo2e2p2wToSt6NUj2xBv4qqWUsnsoC3tRrPymv2bELDdvt7i?=
 =?iso-8859-1?Q?ShJe+NzFDQJq7ZJj0muLFBgra+9fw7l9EyPEQRqk2yfWREFNLHdXm/UR6G?=
 =?iso-8859-1?Q?HeQpfqMG+IEe1tUPELlCQ3viyJDipw2lUW2Wn1kH4/sV7Fb4bh91Dic2U+?=
 =?iso-8859-1?Q?6CTXF9cHLAd6bGtbqPOXXMa4IMggsnoV6xZGt5D+A0idTClb6U6eYNj/tz?=
 =?iso-8859-1?Q?BLsyUiRYYa1nnBojBkBuLBVc78UmMbwMqMnt3Y8Z0W76HdRVIRq+qeJ/0g?=
 =?iso-8859-1?Q?RZ2XngEzaRxYhrET7F05Uoh2VPMI9K3Ez1ji0aXdavU2HFiMxjEm4aHXWZ?=
 =?iso-8859-1?Q?hULmTknwFETal68pr9fgkKA7qfhYfjP9qsBa4Y5y4MjkH1szZvjA740nz5?=
 =?iso-8859-1?Q?hHlYRn5LY8GueiDi0cMLe2Ni3bvlmBxOBJBGFlvqQlYvD+CTci2oBkchk/?=
 =?iso-8859-1?Q?B1tu84d4wU/v9lReX5sWMZtajXXWCrpf3eCf5xqkjtOWohg+FNmG2ciGUe?=
 =?iso-8859-1?Q?u5udgT76UpYeIPhizFtGGhQcEK92Eb9rPpSTFAWPvYeOZZCK5fqvhrCeZQ?=
 =?iso-8859-1?Q?ZoEmZQU8cjEFwPqdx+X+nBEMyCUFpAG9Ih2v4IskCg5AOYQtv2hONiZVNd?=
 =?iso-8859-1?Q?ClKbyREMHFHN+LBgnidfTV5E+oDubW7jhNpUfITnEeFHG0iI/vQgZy0Tz2?=
 =?iso-8859-1?Q?omnj0cOlqwOMavgcGWmVladbN0dVg6nr4s?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microchip.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB7570.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40552f5d-469d-44c6-879d-08dd4c751b1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2025 21:26:40.5887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ngsD4VQt63ugChJ4velVQPy89PMXsPjTLix8hn31pNvr29GnH3K5X+1Ik9fLKzoRCpZSkB2ZWbA7gpuOrYmT5OW1QJ0LuML8i8hRyuDgeLg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7991

=0A=
=0A=
=0A=
=0A=
=0A=
________________________________________=0A=
From:=A0Martin K. Petersen=0A=
Sent:=A0Wednesday, February 12, 2025 6:56 PM=0A=
To:=A0Sagar Biradar - C34249=0A=
Cc:=A0linux-scsi@vger.kernel.org; Tomas Henzl; Marco Patalano; Scott Benesh=
 - C33703; Don Brace - C33706; Tom White - C33503; Abhinav Kuchibhotla - C7=
0322=0A=
Subject:=A0Re: [PATCH] [v2]aacraid: Reply queue mapping to CPUs based on IR=
Q affinity=0A=
=0A=
=0A=
[You don't often get email from "martin.petersen@oracle.comjames.bottomley@=
hansenpartnership.comjmeneghi"@redhat.com. Learn why this is important at h=
ttps://aka.ms/LearnAboutSenderIdentification=A0]=0A=
=0A=
=0A=
=0A=
EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe=0A=
=0A=
=0A=
=0A=
Hi Sagar!=0A=
=0A=
=0A=
=0A=
> Add a new modparam "aac_cpu_offline_feature" to control CPU offlining.=0A=
=0A=
> By default, it's disabled (0), but can be enabled during driver load=0A=
=0A=
> with:=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 insmod ./aacraid.ko aac_cpu_offline_feature=3D1=0A=
=0A=
=0A=
=0A=
We are very hesitant when it comes to adding new module parameters. And=0A=
=0A=
why wouldn't you want offlining to just work? Is the performance penalty=0A=
=0A=
really substantial enough that we have to introduce an explicit "don't=0A=
=0A=
be broken" option?=0A=
=0A=
Hi Martin,=0A=
Thank you for your time to review and giving your valuable opinion.=0A=
There are two reasons why I chose the modparam way=0A=
1) As you rightly guessed - the performance penalty is high when it comes t=
o few RAID level configurations - which is not desired=0A=
2) Not a lot of people would use CPU offlining feature as part of their reg=
ular usage. This is mostly for admin purposes.=0A=
=0A=
These two reasons made me opt for the modparam.=0A=
We and our folks at RedHat did venture into trying few other options - but =
this seemed like a nice fit.=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
--=0A=
=0A=
Martin K. Petersen=A0=A0=A0=A0=A0 Oracle Linux Engineering=0A=
=0A=
=0A=
=0A=
