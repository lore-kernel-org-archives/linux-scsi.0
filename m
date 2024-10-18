Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A0717C7BE
	for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2024 05:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729230806; cv=fail; b=tlMkUdUxPfdG53yZyjGWVgLkyJVRdo1oATGupEPyyYIaqTlPVQW+W/+CufcVRPuHv2Shlr/xDFoih/8A4SdXWxeg6oOB1h0DXvg5oRdb/9ZjX57Ne10t/5WAalbKvPyh/UD+zKGztiOV4I9DVEFQU9nigTVt8ozP0usDrFMG/zM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729230806; c=relaxed/simple;
	bh=uLfLg00qLko2ZBjZruld2uDCOu6UmiQcWua5/0nn+jA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cHzIk0KZLfvu7zXZ9BUM02VQtPr0CR3uSymUUeMyspO5dGCF+8cJZOBwCprTIRavCww7fWr3cSsVRFwiaoP2MA56a4YcLPARdhifz62WFADQGHkA7HG4R1Vh3XegjOGfS3MIxFu007+pX9CTl9TbgzS9JWyTmWtJ5RB7QTMqopg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=dQLnDkWD; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=BNtIj+fU; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="dQLnDkWD";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="BNtIj+fU"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729230805; x=1760766805;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uLfLg00qLko2ZBjZruld2uDCOu6UmiQcWua5/0nn+jA=;
  b=dQLnDkWDC/spevvJY+iqrqyIKXkBluJh+4zhvSLFPzilQUhw3DwtmeNq
   RLq/GFs4vP8cCzpnXxICToPURLxDAljYcWzo9lUKtFfAkg1atOcp21Ks3
   efFNhmmuhXXyXGMDZ6b47QmNNKATR+sgsDafSyzmR7gOnBKaVppYeT9OU
   PoyRksRi40V14cotVY9iixB0k3xnwdbiR8BZ7LNIB+H+dpHEplX/UA0Oe
   YUMwCfKC73lQ5hgaDvXhOYBZ9eDzXR2k2iuCuxhj/5UQuh2RSbRmHxjac
   /KjGQ9ewmwKeUIDGt8bIld+DaftX1vegvpUUcJkDcB72zJGzTVMLdeptD
   A==;
X-CSE-ConnectionGUID: teXysj/aRkKxf2BBTTSy2Q==
X-CSE-MsgGUID: 5fnsyLYTQ2yRGlPhHTYDCg==
X-IronPort-AV: E=Sophos;i="6.11,212,1725292800"; 
   d="scan'208";a="29357982"
Received: from mail-southcentralusazlp17012012.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.14.12])
  by ob1.hgst.iphmx.com with ESMTP; 18 Oct 2024 13:53:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NZ6nZE5q3CbJx93SwZHM478AiN6bZCr5R086Myax0YHrt0IDDiDEJvk/N8yO8Xywaq9gxCog1hIWtta/QO8FufujDzKD1HszOhuFWVmvP8yINMcFnCrsPCgQZ/Ot9s4f0ncUNm87EntI9PPzY4NBmUvVBvS/S/2QukAXrXrhVvpZk3/cYvRIekMCrnkXC0LrW4oOCsjAEw1BvCwwFARGLcOwejX7Ct2ODoHRKW8xwNjI4osqLhhslyaMdhmYzcCK9hgok5WPrdzTfV7wy/M/0Bkhi3LjAJdF2TLlgFlLteoRheCnou1Npfh3wYlfjN2GyDrtNa2qP+qaTxlZq9tujg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aufecSz004xf6nDemcytes4ZbUbL4KHJWE07Ffj61GU=;
 b=N1IJrkH93lqw87SdtLXGDDUbBAz0P/AN3mdyRmBSNiiINrGtByCgb1vGlx+tAIKgPIKKfrQivw0Nq3LmhY+oYaN88oJy8ZRviHYKYOshdDk4JdJs1LQMoF1yjWYoSepwdNYXSzLbt3G/0XpBxlZOfdNTfwgtHFGnwsxnBi03YqIwVtxhIvkHQL5mIcTsUFShGAJRuUZHdw8TP+ojE6ilE/7D93Brf2q6oumixqNaPar4SCepWGBLK2PAqAFO/SpCriL4saY+sUYKwWKOlCvXsMY6uh0S3ninIzRu6WuORYlJkiBIjN6b03RjzkQ628vBf1ToKN51xEuLEoRu1Z0huA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aufecSz004xf6nDemcytes4ZbUbL4KHJWE07Ffj61GU=;
 b=BNtIj+fUyHDQUFaWLZjsHS6o4tJymyftryeXByT+/CoUHZKPQ7axSaBDrFrkOJkDSfgzpZVg0Tf3NmgynsJjlU3OLl+RF+dLTmzdky3FcynhWd8UigGY+WRxoyYnWPqnWlcnP7GFvJN4YYItQ87oov4dCYs3k9cDKz8fe6pvlL8=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 MN2PR04MB6333.namprd04.prod.outlook.com (2603:10b6:208:1a5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.19; Fri, 18 Oct
 2024 05:53:20 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%7]) with mapi id 15.20.8069.020; Fri, 18 Oct 2024
 05:53:20 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>, Peter Wang <peter.wang@mediatek.com>,
	Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, Eric Biggers <ebiggers@google.com>, Minwoo Im
	<minwoo.im@samsung.com>
Subject: RE: [PATCH 5/7] scsi: ufs: core: Simplify
 ufshcd_err_handling_prepare()
Thread-Topic: [PATCH 5/7] scsi: ufs: core: Simplify
 ufshcd_err_handling_prepare()
Thread-Index: AQHbIBA2dKiC4SBy9UuQgQnda3op/rKMA14g
Date: Fri, 18 Oct 2024 05:53:20 +0000
Message-ID:
 <DM6PR04MB6575CBAB006C0228F1520268FC402@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20241016211154.2425403-1-bvanassche@acm.org>
 <20241016211154.2425403-6-bvanassche@acm.org>
In-Reply-To: <20241016211154.2425403-6-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|MN2PR04MB6333:EE_
x-ms-office365-filtering-correlation-id: 522077c9-45ad-4e96-4731-08dcef392be1
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?0GHe0zSqWbo2VUW034PaSNwH5+l/Nmgu8qt+eGQOKgL07e0qE8nvPzAwd1HT?=
 =?us-ascii?Q?OZ105eWi/Lq9MVVRkX4wG3j6JJaWGpL9zFEa6W5qzD1En8VecXJn28NNcocM?=
 =?us-ascii?Q?o92tEKl8vVRIJSTUjWWSsQjsJxBUQ72WhU2xGFgjiWdksPGtInMc+nFA8Dvb?=
 =?us-ascii?Q?Uvy2hbIy7hrB51yeNu9yihqUvZaIhRaJocZdgr+a7zrlmhhvg8keX/Q56CZJ?=
 =?us-ascii?Q?Y3gdaEbsPILkmg1PHMUA3T58Nn58u3St6ca9M+FUqhTvJfiG0/y/V8Urmeh3?=
 =?us-ascii?Q?ER8x3Zq3uxwIQ6+lXy1qWoi1t/oC2QzMRLI9zk1DOqxt8exXzfbScCvL4Kpe?=
 =?us-ascii?Q?pjMJ9m61Q4a9kt+2RlePD0Ngy7pCHuZ+c3XTBh5nNn546Njxy7QNHA04tTBK?=
 =?us-ascii?Q?UG8sVZeACwdkZWFeruUfnQzRoImoqPxTch0QZumd4a890lh1LdqtYvEAo5YG?=
 =?us-ascii?Q?hhODZjjjsg5MmIuWu1Sbg6K5CyCQ96gpi2+NeWxI95zZdKoDu++EnkfhEXxG?=
 =?us-ascii?Q?N6RLS4k08hwy53NX4eD27oJbk3agj/Igtnrhrj2ZGgbKBXB/OmF3NF/P5qzb?=
 =?us-ascii?Q?nvBE/4dai7KBu/vXaIdySy3xY4altVRoHn/r6yL0OVsqW9Fthl6I2SM6W5CV?=
 =?us-ascii?Q?ANDT2orztBv6AIGzW3wqPw4fAx0oDjLA7QiQ5lwI8fA7hsON/9iVmNIY3MC/?=
 =?us-ascii?Q?BxTymBlZVvncN8xtnLQWgtsY/2SVe3F7lSrUPx+ZiqycVFSAJ0bSm7TqVfbu?=
 =?us-ascii?Q?l2YCEg2cOz4BoItUAIXpliS1no+4tJDvQIhKz1OLiwcLEfJzsbk/Iv2JrHZl?=
 =?us-ascii?Q?q2Sb7EPh4F6bPmxRAQQV0JZvlJTsITVDPMExdCXSQ9HYwUQ9QaFzA1CkhTUa?=
 =?us-ascii?Q?xe6g+YEZpl0gVv1bBsrJxIXCw4KEAmhq7BmEDAkj8sBH7XH/2czsiowLja5l?=
 =?us-ascii?Q?knINul+m8GO3bwpHidMfDnB6Er7vsxKdzCwGhFKpqto/FuVu73W32JRS5d43?=
 =?us-ascii?Q?IxkuLgffPAC8RW56R3HH+iiSww9ZGWQueTrQh7Fhn3R/iH7riYPdALhpyDr1?=
 =?us-ascii?Q?8aeZWcyHuBmoNmXo08FxWMZ9nfAB4YXXi0OJsqfvyD8AEyRskGjOOsrJqbm0?=
 =?us-ascii?Q?y31QZ6pvtDDcB4Scz0DhagKH0ciJ/Cw4UEPoBBpEhhy3iG1TuqZ2amHouHjE?=
 =?us-ascii?Q?fvtMkO+oN9DA/steBimLRbwI9C5oshTTAqud6wrbHouPVEyY/Ho4SHgUOhwd?=
 =?us-ascii?Q?IykaEkJN2BcChL5NkPtsFpdBM8NlaekuTvK+rtN+WuWDwTBvxshqKlPgWV63?=
 =?us-ascii?Q?3iW6IC30wzzHJVIJeoE3RzUVG9EKctoBAd+Bh2xY2kDBzB5K+5uvBELuRG4e?=
 =?us-ascii?Q?0sFJegM=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?7PKhHB0GwkY6oVFmBszbLl0FPhFvK6uA/Mu1ByfxCSuy1o41zZRV0B4CUWAH?=
 =?us-ascii?Q?OAmV4zQhJDrzZ/7pvGkLyNHVQpknCXwqNnfPxyCnetB6sjxnPGEBb460gp4V?=
 =?us-ascii?Q?2QRDeoctDSNvhuRSu1PaAXTbsxC4wn58BKcieyA+zl+LDs3NVA6kf65tYjC2?=
 =?us-ascii?Q?ELy8iKPfTfKFr6SM5ref36UkCGbTq+HbTfIO2Erf5xb/myTe5XzZN1/NBK2P?=
 =?us-ascii?Q?HEeQCzJ633UwZLMZxtIz6lzedaSIOx0hLwY2ek7bFVxoMFYJT+lu9RtgCtze?=
 =?us-ascii?Q?RmoIwsBfIu/ALWGFrc3VftasRAXpopVqqGGXc2BaQbvpBBxRq5/wT2Rgfkt9?=
 =?us-ascii?Q?o6pE6wA2obLqhTY7Vvpwstut97yzsoJReQmr1N4+NY/gVw5YuKnKPs16nKlZ?=
 =?us-ascii?Q?RBQ+c2IXdn68IeOp8yKqtD81hVm+CbDU1Mk8g9vk6rtlmPRe4alMUIXd9xaL?=
 =?us-ascii?Q?y5OgJafxHfSW3NoJCCccTW3/F7e0IEy8vLGqmyEZo6qfCmcvVXScT8ncKzd/?=
 =?us-ascii?Q?I/FqC00REp4ICDSkrc22bRuBueMUmXyOGWDyYVVnGF3sXq1IxG0hxgkqescr?=
 =?us-ascii?Q?y5gqr56r2SzByI/NArV8MQL2L6X77aWY3jWEvzUHI6i0pCXwRPHiEhhYR8aV?=
 =?us-ascii?Q?J6J7w34BFnvG1eE7JPNptaS/Il6AgvEsybvhphp/+oc1sMszJ995RFxXxHn4?=
 =?us-ascii?Q?ze54zaYHHh/Se3p0EcvQ9y0nIz/HMkX4wsY89LPyUz9PVmkaUQnYm5tuwGbe?=
 =?us-ascii?Q?8z1RfcmwldxdQoqH/8BKNgooV44RkFwDE+RNCa5ARZ+AqSs1s1d5Gr2cCLjy?=
 =?us-ascii?Q?QTc5Wc1H9kIDmxyaDS/oEzVd5bS5fhciLFZ3uNxqOCGJYvAua6T957n9Gg1T?=
 =?us-ascii?Q?rkUULP117QUgKoPqcQvWoCjBda64vRBa+Fxuhh6hclCQ5A3rFPgwEvX/6xkY?=
 =?us-ascii?Q?2f1zAqh+d0xWKrXx84ae9eMMNfZ3lBcYVglyWJ1E06wmMBvPkO0d12gK9YhH?=
 =?us-ascii?Q?2CRrBMFjhiJ5YnIifEopkeBT2JxU/xm+4sn0kD3sjG3G1u9LxpdVdz/KPkIv?=
 =?us-ascii?Q?rNqPuNGtQtzAZ32YNcPyvCUkZYpGMrAdckxBvmr/8Zfjy53BD0PtTYGxWDML?=
 =?us-ascii?Q?jefB7u6tb31avdH36jtJtYAwTd04HkCQeFfWPKH5CqzBUCenDi93cy1JfY/y?=
 =?us-ascii?Q?7GNiQbXy2E7AA8AimFGCqdIcgwA0WO0RpCMIfxWRMIgfIi39ORDHoHysywVj?=
 =?us-ascii?Q?jEbv6Xl8VJDkWBirkAnjW3oKSJc0YfsGNnr21tXw0TnQXofGgUvzCZU029Nx?=
 =?us-ascii?Q?OryD84kpi+vupW1PR2T0ny3G/RSR32bQzy8fTYf7PNndGGZsEZlk8TBLKahr?=
 =?us-ascii?Q?s5Xq38gqMbYPeNMTtsOjEG7Fz5dOADqmyVF24XyL4sTMcMyzZekhCka6mZMF?=
 =?us-ascii?Q?Xg4pyvhKKldbgoQo8+UIzNE4hNGggLLW2j+9/SHLGl4CC2tKGeLk1nW1Bdq4?=
 =?us-ascii?Q?mSwhPKM+Sln3lWYRomkxmrJRtT3fo7vosl20IU2mrCcR8C0dQzPqDW5NG/+C?=
 =?us-ascii?Q?cwFK8zzBcfCBfmw7ir+Lca9gWxCUQUGAMqBZzWoK?=
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
	ORD0eeXYRG586ZIDknKn2gsfolInIKE6Pji26AuhF+R935a40k7Eguo3MLophNz0sCb5ILo7UjmtyEbtKq6cG0ugF1bTziDRGeFgkFoSTVXpXwBHs8pCTQGiJA7Ub9EFahXFaWBYgS6qylx/9tB9N//4AEa884MZ0V7CKlerqFNrWlhgfj0cL+d5gUaySHYAHus5A/RufgbQj/SOxnlJ6KKfA9Qj8NIydbJHGyJ4Df4bgFcLXR87NDENbRCZbLQ9ZSOgfEqa1i9icH7TpRdhdc78g03/yokO/EitJoeNDWFq5/zx4Pv2M7c3ZG//lTgLCkYryLoEKfsaQLHk83ncojtPOjGgRRvdGdtkLMIHke5mDcczEKexQ/PAqnwmIgbXp0gNywkA9D1icIMJ4Fzn7Q5B4t46p2sJf17Myiy/Qr22XyPB77oSC39SARUucqVxz21LEeh3wB9MVR8rON8oA3cMOsE//EXMORJEUipaVk3hWaPcli8jcZVRPDzdQnydBI0HTGIncyIBus3z8TAY1bSJCxLA+Ks4kElTnhuFgs9oxolDIVp/ioLf2G9kCQaEtpSCnKyku65DZd0QcaXXo5bLwzP0QI2i6dVzrt12lGhhGFnUVTl5hn5npBxoAOJ3
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 522077c9-45ad-4e96-4731-08dcef392be1
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2024 05:53:20.8011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PBwVE9afZQYs5CGx/N1rUwo/NQi/Eg59j+XUtItPn6h8MWnnGc9jj+bN/Jn2IUyPMh8N61BtyJKCfPc7E4Bz6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6333

> Use blk_mq_quiesce_tagset() instead of ufshcd_scsi_block_requests() and
> blk_mq_wait_quiesce_done().
Maybe also add a sentence indicating that this was the last caller of scsi_=
block_requests hence it can be removed.

>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

> ---
>  drivers/ufs/core/ufshcd.c | 19 +++----------------
>  include/ufs/ufshcd.h      |  2 --
>  2 files changed, 3 insertions(+), 18 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> ff1b0af74041..75e00e5b3f79 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -349,18 +349,6 @@ static void ufshcd_configure_wb(struct ufs_hba
> *hba)
>                 ufshcd_wb_toggle_buf_flush(hba, true);  }
>=20
> -static void ufshcd_scsi_unblock_requests(struct ufs_hba *hba) -{
> -       if (atomic_dec_and_test(&hba->scsi_block_reqs_cnt))
> -               scsi_unblock_requests(hba->host);
> -}
> -
> -static void ufshcd_scsi_block_requests(struct ufs_hba *hba) -{
> -       if (atomic_inc_return(&hba->scsi_block_reqs_cnt) =3D=3D 1)
> -               scsi_block_requests(hba->host);
> -}
> -
>  static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int
> tag,
>                                       enum ufs_trace_str_t str_t)  { @@ -=
6379,15 +6367,14
> @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
>                         ufshcd_suspend_clkscaling(hba);
>                 ufshcd_clk_scaling_allow(hba, false);
>         }
> -       ufshcd_scsi_block_requests(hba);
>         /* Wait for ongoing ufshcd_queuecommand() calls to finish. */
> -       blk_mq_wait_quiesce_done(&hba->host->tag_set);
> +       blk_mq_quiesce_tagset(&hba->host->tag_set);
>         cancel_work_sync(&hba->eeh_work);  }
>=20
>  static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)  {
> -       ufshcd_scsi_unblock_requests(hba);
> +       blk_mq_unquiesce_tagset(&hba->host->tag_set);
>         ufshcd_release(hba);
>         if (ufshcd_is_clkscaling_supported(hba))
>                 ufshcd_clk_scaling_suspend(hba, false); @@ -10560,7 +1054=
7,7
> @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base,
> unsigned int irq)
>=20
>         /* Hold auto suspend until async scan completes */
>         pm_runtime_get_sync(dev);
> -       atomic_set(&hba->scsi_block_reqs_cnt, 0);
> +
>         /*
>          * We are assuming that device wasn't put in sleep/power-down
>          * state exclusively during the boot stage before kernel.
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h index
> a0b325a32aca..36bd91ff3593 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -928,7 +928,6 @@ enum ufshcd_mcq_opr {
>   * @wb_mutex: used to serialize devfreq and sysfs write booster toggling
>   * @clk_scaling_lock: used to serialize device commands and clock scalin=
g
>   * @desc_size: descriptor sizes reported by device
> - * @scsi_block_reqs_cnt: reference counting for scsi block requests
>   * @bsg_dev: struct device associated with the BSG queue
>   * @bsg_queue: BSG queue associated with the UFS controller
>   * @rpm_dev_flush_recheck_work: used to suspend from RPM (runtime
> power @@ -1089,7 +1088,6 @@ struct ufs_hba {
>=20
>         struct mutex wb_mutex;
>         struct rw_semaphore clk_scaling_lock;
> -       atomic_t scsi_block_reqs_cnt;
>=20
>         struct device           bsg_dev;
>         struct request_queue    *bsg_queue;
