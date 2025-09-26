Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.154.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEAF1D6AA
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 06:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758867860; cv=fail; b=acP9DjorjRLkMDDIGUYnq3LCNtRpSkTR0be7luH9JsPr7h68Cb/EyLgYHdR6ZR9JvLShKDgbVbUdAN2RlL9BmdH4dr+KFbJ4J2pDwhuwNzxX7JNWGe/V8Kxn9SZ40PFLAUYMzU/NF/VNJ1ivYuKxVaIimesnkCmE7YNim9B68j0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758867860; c=relaxed/simple;
	bh=aZ0Gs8iy5zWwpbrDQTP7SjySeL0m0jexlm0mpxnaOBI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=g1tVm0MYynA+PHzWNvSaS9I906pcoEos40MoQJLYwmkDrEXkR1Qa9eFYmy2gz/TFheDfT08g01B7lreym0mUgQYlQx+gfRrq7XU6C5k+hUA4vUTzG0xTWNI3fgixUItdQZH9SeHSSJ6T8LE+NRsAc/T5ct8S01ggPOVgK92uj/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=apWrKS7k; arc=fail smtp.client-ip=216.71.154.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="apWrKS7k"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1758867858; x=1790403858;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aZ0Gs8iy5zWwpbrDQTP7SjySeL0m0jexlm0mpxnaOBI=;
  b=apWrKS7kZZ2/L6wx8cyAQD9LgHwXYOrn6KzrpxQbmpHZTcFGHXIwnetY
   p/rhusCod5mRQShx8fmIVs7QuFkCbIIZ6aWEw1my/eda97m0x/E5x01hr
   woFAcfRE7q5+U4FKVoj7wMfWtW/e30zu+UgTYD2YUKpTI8U6WUO5+gZo/
   sqaf0/QOzcKpGcjDR+fCLj+7RlPyZPFgmhqM3jktIns98Em0DOZjVjxwz
   2wjQ0bsJY8E+hRvvXQxGHJpczLK+K5UbGxInMePsrUJZwqpHOl1UylObo
   iCiBcf3aOjuWn14l9YTIOL7nzhb0evxk7h/qilZ4qfN/xuliJOAf/KMHf
   A==;
X-CSE-ConnectionGUID: 4MtKXIBGQsaU+1FcnumLKQ==
X-CSE-MsgGUID: QXxDauNcTqyzQ07dw/VA5g==
Received: from mail-eastus2azon11020073.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.73])
  by ob1.hc6817-7.iphmx.com with ESMTP; 25 Sep 2025 23:24:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qCfAbwgP+MAKPBxYG0c5Qx1MVYXm7yWY9ZSj5hq8K425YLS4cyeQ5UbC+5iM9DUO63594n/4q8rxCU8sDnAdwA6QccFXplxp0NSEnYHtVqYyCiq2S6JAjfoD8C2pML6NPWzW6PalBCrn8jdIqrNR5AWUXP2M4gSIAvU4Os828NilJBb16TO6YtVeMg5dzYOYCjL+pJxFx5GwJxu+nTWqzCNGXdyDGsiId0MMImHEQQpic+v8OUlvSh3f+ufGZpl25Vboztoh+C2HTeSl3wp/gDEu+0Bdv+GEl28USP0l21yx9vrJExmhI3RdNDVFOK3db3dbMkHg2b+WUUew2Gsz9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=snXee2OrWVJwip2av+FPbEF0r6q0GSfrfq6Z4giqXT8=;
 b=WOovXB56CqZKVozr8f9drqDPlgtJnnOofTrpMOO6caEs7Rv0ZYlrM4nwJYi4X1iWCdpUQF5sPKHre/zWaOoKpG7N6r+ignkCws05oDLf+CCiLWVXY95HTIOiyQ7S54qWCORN5oTbOpNM4hd2IUeZ0zflzon1Z1VRzpqTbPrimBMiquLJIVqO/yyAv9zLnh7g4az4bVNknQD10a3XsbdZbvGUatLHHSlssk2ORSgT8kj8SEcoOjTx2OCuP4cMROHsBCpWNkp/Swb97ZZxM94E2QRFNsTBk64EUTjHGW1+PipPSgGEd6MWyn4SBujKdfVLgoz8S1B/iARTuEr9MOrsOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by BN0PR16MB4334.namprd16.prod.outlook.com (2603:10b6:408:149::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.11; Fri, 26 Sep
 2025 06:24:13 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::df4a:1576:a40e:5491]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::df4a:1576:a40e:5491%6]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 06:24:13 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Peter Wang
	<peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH v5 14/28] ufs: core: Change the monitor function argument
 types
Thread-Topic: [PATCH v5 14/28] ufs: core: Change the monitor function argument
 types
Thread-Index: AQHcLZJ9F80TAh+HwkSeeG2YpGC3VLSlAH6g
Date: Fri, 26 Sep 2025 06:24:13 +0000
Message-ID:
 <PH7PR16MB6196B3B0D72946C8341BE287E51EA@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250924203142.4073403-1-bvanassche@acm.org>
 <20250924203142.4073403-15-bvanassche@acm.org>
In-Reply-To: <20250924203142.4073403-15-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|BN0PR16MB4334:EE_
x-ms-office365-filtering-correlation-id: 3a913254-0435-4649-e179-08ddfcc54ff6
x-ms-exchange-atpmessageproperties: SA
sndkipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?ykEPNkVyXBhAq/8B/thna06t9mFZBAxks1RTolUAEjeGpf6EjoShLzf8uRcX?=
 =?us-ascii?Q?aXsTbChDb8TeLwCurzCY2adZNFuLFFCGtd1aUGowCnum3EUEfksNQiFhbpLM?=
 =?us-ascii?Q?/t4c2jcQKm9tISyTtHkYOsouumnLQpDIuL/bOHgw4+HcFGUklYAVRG+cKInu?=
 =?us-ascii?Q?JCBkerycL49Y8kjiUOSrR/EEVrrUiQOkLdUwzSzvG1HWLE5wSDvUIORjGHTJ?=
 =?us-ascii?Q?9qIo++WR1NzxByh0wYeKNcrkm5EdkzE9sb19ZtDM3GozZQkGbwgMBUMhfrf4?=
 =?us-ascii?Q?xzVAmPNEWPRHaMzi+jqVWfk5SLe/2q9UYE/+lo9Jq0FyfH94BGSq34hPFe4r?=
 =?us-ascii?Q?L48PjGeIXIv6LzP2EaJ5aMmGgh526wYrl5GmT+K17bmVhnSGYc8WMKak831M?=
 =?us-ascii?Q?TO2W815vTH6hoQGD2ICh3JYaZtqz4LUPm3l61ZvvYMAZ8YqHuvLnObiyMeOq?=
 =?us-ascii?Q?vlCnZGQaTdyYl3m5NkykV6rmg8vjFHS8rSseq18OMGVm5tgm1LwciIsNyPNq?=
 =?us-ascii?Q?wWMC5ztHFc8oFh5iKHTeYGi00mg9Y/cH4KFRGO0yLIoRHyWR8F02zrLpkVZk?=
 =?us-ascii?Q?OR9HOn0whXiYZK4BQTQUwbLDqwqQb6xWBUAOgoKpWPruV2qA0ofpDx3S110/?=
 =?us-ascii?Q?WlgBLNShPgzNWCm+eh+EfQrr28Eo2LbnMwJzTaa+gBs23xI6Sho9lEq9dPrh?=
 =?us-ascii?Q?WW8StOxNNzZaa1c4PPNVGV68dUdga2hN/ttup0NMB3QSTvQpp6PdN9xmn3Vg?=
 =?us-ascii?Q?VE/LMpU/1Xb3DTMk7nPoxPyvDJok8lyBAdQadMBSZtJRKklJ9I3E18Gi/S26?=
 =?us-ascii?Q?LY8PmY+Wa14RawZIOoYC/5t0xhma56rg9mz8ArucbbGITXx4sZEF9Dlq0DZY?=
 =?us-ascii?Q?oT5Jz6e7kQsh/1bXYka4bXqsi1693dMqAEWYn9aprqUbh3+ojzpAmv5VDOJ8?=
 =?us-ascii?Q?RfwPU2Kq/XP1Knwk7EJKoNpuPdT4R8FKtf13v6xLGG6TWWWQHLxy5/Byp4PQ?=
 =?us-ascii?Q?ceonRQxx5tok0Ygxm0xrxm9ILCrMnbidkVIukrOehdnoF++z20cQ8U6pHoAl?=
 =?us-ascii?Q?ZvdMl2QbGSU1UpfF75ybZ+uov87xOw7xufFgjcxffiG8MDrzTgeSorY7fYMw?=
 =?us-ascii?Q?+hE2SVd8mN3B/2eZBLC2iz7ewfx3M60/VlldP1pOFjNJDhIfoF7C7i0RmjoE?=
 =?us-ascii?Q?eiuqf7Mi7eejBA4qQLYJnaJA+p+Z49qxM2c0EXomAtJHyCcDhOSqfymaG9W2?=
 =?us-ascii?Q?QyHtSuqH8hIWctEcX8vQEf2YOswVVc3G5JTN+gk6b0WURTFS0vRBL/J1Uf7m?=
 =?us-ascii?Q?owP6p2YVZvoz0HTgcbLkgndDmux7h83Vk/PN8/9ek2EbhSlh5lwRmj0IuCO2?=
 =?us-ascii?Q?m5hXe9IWDNqWfb/O+Zz0yLu7fC2vuMbEsxv25g0hELFOJF57d5J86I/bUlMG?=
 =?us-ascii?Q?co+5HhX+oY3sU5GT/Jv2qV5TaJTU9w9QtEOJgOeg1se4dIkjWdbjyw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?q4LNVaPna6dkKvshVnkss3+CP9FXqPrmFXLC/YnSKGqzTUSwGQIo0vgAHq/2?=
 =?us-ascii?Q?LjLKylD6PSv9BTH9dNMhkRHgRekQyFxRxCsSk1qk3wDjnz71b9CanJ/Jp6J/?=
 =?us-ascii?Q?pew6ir8U19lJwcove3J53DFRjY4Qz8pgucoGFAgFUKRAk04Dw9w7xMXmIdMN?=
 =?us-ascii?Q?vqzgPEJ7ZRgE5iMqKCVjEwCZj3EmWKowbAIL1/+YZ0xknbUOQjeduGL+j6y7?=
 =?us-ascii?Q?VB0dQ+9RileotlKVoh5jYVYxKH0Smk78aLdWR2b7m3/Qr9wFnYk+bV5glCQ9?=
 =?us-ascii?Q?rHgOTRsYWlkiqMkn4AFIgUH4yInX6ZJmJoJejy6FmS8JXv6etQv0Q+pECn34?=
 =?us-ascii?Q?vk4sdJvXtLXbX0F89YlLALyLueLxzVyD20Bu3l7bLvOdAJRS2Bs0Vz1PHNRY?=
 =?us-ascii?Q?Osf6DFtqP1LnvlgsdwZsF3NVsmIZu+iObT85vN85XNx2B4A4hLgntboBEJul?=
 =?us-ascii?Q?Sh7Gl5scV3VZgGj5htK6vVgLP9ohcSqo2KdX6JIOxpBrZxcjUMXaCvvPWzm4?=
 =?us-ascii?Q?sPvyYYA/+Bioev1/24nLQCQZGRjMkHutW4aCS5a5lRf3pxbR0dcb7Y/yBd00?=
 =?us-ascii?Q?Jc6XwSQI6mBvnVNSpWiMN47q6M8Od/UyjuxBlH+ev1cyZ1LCbfUHy2qlst/f?=
 =?us-ascii?Q?9gydb3v99/cxubq+dAJt2gzluLKK+Sg3r10299R8MeshxlITYMs29AHXjB+Q?=
 =?us-ascii?Q?HMxDFBBNoGM/2blZsC3GDS/NGNc0JyY3up0NHiyl0xroWnrLzxCdZcyMhQe6?=
 =?us-ascii?Q?KeoO0QX9vLq14vzzdrmoLcgv8P3V3I18rVkXKVxLPcdtSlQeFLfsAeeyP6a2?=
 =?us-ascii?Q?ft6UDYH3FFLu5EMRd+OFDfofOfpzMyl0xxnW/VSbchg97DKcVeDAb4zqYb6z?=
 =?us-ascii?Q?2vvHdNiM5yIK0wubOUEfC90u69OYcJtWKA30hp/DdCT4I0adUnXQEi+8fJHE?=
 =?us-ascii?Q?5Zxs01GUfZXN+vOL+K8G6bG2ZMr/kTuaxPN8ODtnSwgPvMOyd8XUiXKMqN1V?=
 =?us-ascii?Q?v1O4TNhNNT+d0Tw9a9DYtkij5cGS1vV9zm9EvJ0De5uSQKv4nW13fhZOAySj?=
 =?us-ascii?Q?yTesWSITs1sgIZiUfHv6oSyo1HCvMeunIWVADUJVZOD8SLMzWfuKzKz97In3?=
 =?us-ascii?Q?HgDU/H71VwuprtNWJMpDoRw+Nk+H7067y7XwHc2E0cOccVgMJ8gLfsLANEv9?=
 =?us-ascii?Q?BKP0rhbURKuo4bA3KmRn2S0Xa3CkDiba6d2OAfj03VD5t1T0vC387og913pn?=
 =?us-ascii?Q?kw5c6pPOiRum3dKqsyo7UmMCVTSiIwMAfnWmGgA1oXbiCZta6dX9/IOuwN5f?=
 =?us-ascii?Q?Hwr2ByTewky+G5YHVvJGb5C75JOS362NqcxqvP0P6YwEN8itQyN6GhmZlB1f?=
 =?us-ascii?Q?U5tQ8TZJwkbIc4xFcJkAwpzPW/3294xaXj30BsC4I3he6GCqSvKZBztqDlc+?=
 =?us-ascii?Q?xkwFiuGJr4YOU9zj+hP94VvTJrxZ46pgQj6vnLEtNS9+irGi9sCzNHgQCnwR?=
 =?us-ascii?Q?4L33lwssdfRzS3E/CVgTyIaaN89rCyPVYMTVFFRAibK5+jx4UuEqWY3AEv6a?=
 =?us-ascii?Q?2j8ESnBodcXsJcz7icpXuNVt0kst6ZkAszOkBAwc?=
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
	NKs5WiTDAdkmeLbxl3nNucXirthANvlVIKOBbJBFkTUMVmlA9ofjEYh3a0XO8oOixxfMRWtENfnohtha65MWirCDGTRy3XX+Rf5o0lJfywbhQO/ymfUYqo//o7Fwa0znWTDot8nEvX5Xx/+hDca9xua0q16elr1Gbc+HFsX4d0GH54X79oL0y7cmgajXgoah3FxCAiEmNsgAZTMg3jaq8dGS7Jbs7mc1WKMeXrNLp6cQzOwpaAHg6IjQc+pQNkf9+5+eZHoeTPtMGbPRO9rpLO+s+i9zVAYuEwMlcSt90N3ETb+p27ADVtbsOQ/57gZAg1GSsvVDBeTHO2OfmR7yDWlR9mL2QFjd+GlTb7dj6z7ZlB7vRtRyJUwDXEgfrKqVph5QDmLoyj3st0in87FaNj9yo4VKmvd/zJGT0tBbeIqPfQ0/oYIDMqQ1yULJXhW3DA+TcoX5iyAB57Q8qD6rIqkelCyY3Eh9Rh97Baz5UizyCGXtEm1Kv6KnZH31s54kmAmaWLExqawDXeUc6kPdsO66Zlvv2EJmwwQLC22wNX+08YWW+J1WcmNJGsCWlE+6kkRCkwd7P6dW74W4SjwyIm2BtbhaJIqeA+yeO7EIFPmYDo6/FFmCguzIpLQvj5+djnenDK1FEjSt9TBgfIUr3A==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a913254-0435-4649-e179-08ddfcc54ff6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2025 06:24:13.6367
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IPNE1amOkGNsXMjSBOpVWcXTo4oYuJHI8HzZffxwBq8vseXf9pFUYz5yE5Ry2sIfoH1d3cFCx7VFsOsStFdqNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR16MB4334

> Pass a SCSI command pointer instead of a struct ufshcd_lrb pointer. This =
patch
> prepares for combining the SCSI command and ufshcd_lrb data structures in=
to
> a single data structure.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@sandisk.com>

> ---
>  drivers/ufs/core/ufshcd.c | 44 +++++++++++++++++++--------------------
>  1 file changed, 22 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> be8fd3b15d5f..ec1c8bdf07e6 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2294,19 +2294,20 @@ static inline int ufshcd_monitor_opcode2dir(u8
> opcode)
>=20
>  /* Must only be called for SCSI commands. */  static inline bool
> ufshcd_should_inform_monitor(struct ufs_hba *hba,
> -                                               struct ufshcd_lrb *lrbp)
> +                                               struct scsi_cmnd *cmd)
>  {
>         const struct ufs_hba_monitor *m =3D &hba->monitor;
> +       struct request *rq =3D scsi_cmd_to_rq(cmd);
> +       struct ufshcd_lrb *lrbp =3D &hba->lrb[rq->tag];
>=20
> -       return (m->enabled &&
> -               (!m->chunk_size || m->chunk_size =3D=3D lrbp->cmd->sdb.le=
ngth) &&
> -               ktime_before(hba->monitor.enabled_ts, lrbp->issue_time_st=
amp));
> +       return m->enabled &&
> +              (!m->chunk_size || m->chunk_size =3D=3D cmd->sdb.length) &=
&
> +              ktime_before(hba->monitor.enabled_ts,
> + lrbp->issue_time_stamp);
>  }
>=20
> -static void ufshcd_start_monitor(struct ufs_hba *hba,
> -                                const struct ufshcd_lrb *lrbp)
> +static void ufshcd_start_monitor(struct ufs_hba *hba, struct scsi_cmnd
> +*cmd)
>  {
> -       int dir =3D ufshcd_monitor_opcode2dir(*lrbp->cmd->cmnd);
> +       int dir =3D ufshcd_monitor_opcode2dir(cmd->cmnd[0]);
>         unsigned long flags;
>=20
>         spin_lock_irqsave(hba->host->host_lock, flags); @@ -2315,14 +2316=
,15
> @@ static void ufshcd_start_monitor(struct ufs_hba *hba,
>         spin_unlock_irqrestore(hba->host->host_lock, flags);  }
>=20
> -static void ufshcd_update_monitor(struct ufs_hba *hba, const struct
> ufshcd_lrb *lrbp)
> +static void ufshcd_update_monitor(struct ufs_hba *hba, struct scsi_cmnd
> +*cmd)
>  {
> -       int dir =3D ufshcd_monitor_opcode2dir(*lrbp->cmd->cmnd);
> +       struct request *req =3D scsi_cmd_to_rq(cmd);
> +       struct ufshcd_lrb *lrbp =3D &hba->lrb[req->tag];
> +       int dir =3D ufshcd_monitor_opcode2dir(cmd->cmnd[0]);
>         unsigned long flags;
>=20
>         spin_lock_irqsave(hba->host->host_lock, flags);
>         if (dir >=3D 0 && hba->monitor.nr_queued[dir] > 0) {
> -               const struct request *req =3D scsi_cmd_to_rq(lrbp->cmd);
>                 struct ufs_hba_monitor *m =3D &hba->monitor;
>                 ktime_t now, inc, lat;
>=20
> @@ -2357,6 +2359,7 @@ static inline void ufshcd_send_command(struct
> ufs_hba *hba,
>                                        struct ufshcd_lrb *lrbp,
>                                        struct ufs_hw_queue *hwq)  {
> +       struct scsi_cmnd *cmd =3D lrbp->cmd;
>         unsigned long flags;
>=20
>         if (hba->monitor.enabled) {
> @@ -2365,11 +2368,11 @@ static inline void ufshcd_send_command(struct
> ufs_hba *hba,
>                 lrbp->compl_time_stamp =3D ktime_set(0, 0);
>                 lrbp->compl_time_stamp_local_clock =3D 0;
>         }
> -       if (lrbp->cmd) {
> -               ufshcd_add_command_trace(hba, lrbp->cmd, UFS_CMD_SEND);
> +       if (cmd) {
> +               ufshcd_add_command_trace(hba, cmd, UFS_CMD_SEND);
>                 ufshcd_clk_scaling_start_busy(hba);
> -               if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
> -                       ufshcd_start_monitor(hba, lrbp);
> +               if (unlikely(ufshcd_should_inform_monitor(hba, cmd)))
> +                       ufshcd_start_monitor(hba, cmd);
>         }
>=20
>         if (hba->mcq_enabled) {
> @@ -2385,8 +2388,7 @@ static inline void ufshcd_send_command(struct
> ufs_hba *hba,
>         } else {
>                 spin_lock_irqsave(&hba->outstanding_lock, flags);
>                 if (hba->vops && hba->vops->setup_xfer_req)
> -                       hba->vops->setup_xfer_req(hba, lrbp->task_tag,
> -                                                 !!lrbp->cmd);
> +                       hba->vops->setup_xfer_req(hba, lrbp->task_tag,
> + !!cmd);
>                 __set_bit(lrbp->task_tag, &hba->outstanding_reqs);
>                 ufshcd_writel(hba, 1 << lrbp->task_tag,
>                               REG_UTP_TRANSFER_REQ_DOOR_BELL); @@ -5620,1=
9
> +5622,17 @@ void ufshcd_release_scsi_cmd(struct ufs_hba *hba,  void
> ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
>                           struct cq_entry *cqe)  {
> -       struct ufshcd_lrb *lrbp;
> -       struct scsi_cmnd *cmd;
> +       struct ufshcd_lrb *lrbp =3D &hba->lrb[task_tag];
> +       struct scsi_cmnd *cmd =3D lrbp->cmd;
>         enum utp_ocs ocs;
>=20
> -       lrbp =3D &hba->lrb[task_tag];
>         if (hba->monitor.enabled) {
>                 lrbp->compl_time_stamp =3D ktime_get();
>                 lrbp->compl_time_stamp_local_clock =3D local_clock();
>         }
> -       cmd =3D lrbp->cmd;
>         if (cmd) {
> -               if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
> -                       ufshcd_update_monitor(hba, lrbp);
> +               if (unlikely(ufshcd_should_inform_monitor(hba, cmd)))
> +                       ufshcd_update_monitor(hba, cmd);
>                 ufshcd_add_command_trace(hba, cmd, UFS_CMD_COMP);
>                 cmd->result =3D ufshcd_transfer_rsp_status(hba, lrbp, cqe=
);
>                 ufshcd_release_scsi_cmd(hba, lrbp);
