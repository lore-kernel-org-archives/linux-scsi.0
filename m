Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBC8770FE
	for <linux-scsi@vger.kernel.org>; Thu, 17 Oct 2024 06:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729146719; cv=fail; b=J2XnqHxoge1+fTULY1mNypkdzQfqwWcUAfpiNej2YipB9hwAZwFMAPXWxvb4AYHNuiKVQINvsqtTDU2GV5/Dx1WxjNJEqriw3f/JXJhZ89tKuNB+YS+AkmGIqKbHdxP7hehrf+Oi4cbm2VyRt+Vcj6aTgJiFlzfZPm2iNebxJs4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729146719; c=relaxed/simple;
	bh=bzwiv+H6jT367y/YJv00zq1rQWnfrNlAg/W/qppLmCM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KIljktSL9K1/qjiEEZL880kamPU263cKDtnrrb3UW1BSP0QrQLygXECq9M9ttPxRacgM7sjmGEapCt25Q/dEfv0qDfN5wy6Kf5tcVIoxSQ8IpRZn+Yr8LRPVkRhOK3EsrIMaTFPtwD9EXK9Yn3LplMFdCmYL2KByddTZXcv8VLc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=BI15uPKQ; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Psuztng9; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BI15uPKQ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Psuztng9"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729146717; x=1760682717;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bzwiv+H6jT367y/YJv00zq1rQWnfrNlAg/W/qppLmCM=;
  b=BI15uPKQqd/vN6TJ7Huunv1jVd8fifd4pfo18z0csOEhu+dKZ3V8vn08
   cqS3rwgEioQVkYFTW8A4gzgaWRMMArgaLvkBBhSfFKNNkY2EvMjzPfIt1
   aD4U7xYilFdJlWLi/pORgGzh2Bm92ABGxfL5VF6FZfX+blLXLG2c7dYMX
   UIYK1e+S1gPYNCyn5Sl4Qvl3cqV7fDSMbTthooQCd82TXn5w1uWcJHbAu
   5qLXn2bNUScQcM5wjiInPPyT+X7x/7nxDUT70jj3OO/cyAnYgo0PwH7v9
   LkfwyWTE/4MA4zkaNCKzUoxBNu5LrKgDHBSfMJd22OWXUG3CXM+9a3qPf
   Q==;
X-CSE-ConnectionGUID: krY+Ol8hQ/CSOLzRJFz1FQ==
X-CSE-MsgGUID: Z+UIr9jGSRmdZb+pLWDexg==
X-IronPort-AV: E=Sophos;i="6.11,210,1725292800"; 
   d="scan'208";a="29611499"
Received: from mail-bn1nam02lp2040.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.40])
  by ob1.hgst.iphmx.com with ESMTP; 17 Oct 2024 14:31:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GaIn568Lgg0BTPrIqnlEkJ52Tj7Ac4fv+5usxqXNtH0zxGWOdvTTTXhQxgOclWykYVrQ1uK3VBud2/UCwpAWr061n8+7CFZB0ZgrcEiP8YMmEEFrP/OFezULY7p+G40vkIMBvBXW8K++ZKGp9MmGlIqndhGbAFHyArrCEH9fXSI+tUSMwglJvlynnYEB5nmDqKfyCbdvN5KIaSI/72b5arOw0kJqBlJX6orZUyJer1Wky2IT0fbYRG3cSDYrcJRgXFf6tlARJBuc49yVxqUg0F+X124FXlIZcl0OR8ws6LGGsJYJxMg9R7MVVs4KLfKImrD+iT40nmgNlatniWMVmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oy1Ha0zAFvy/S30RkmcwwjlNxtPMGMndJgG6ptip27s=;
 b=hAi7Rco3X/eBI8hMhwYXqXCLh7qW4sDaWKJW9Yumpfp+vEKq6e4QqCN9N/mQi831W4m5nqCAkLkROlZeJ1QKE/QuF7G6JF3eynfZqsByXLidc1T9IPgf0/BlcG627x9BZsvaBqoMJtLxg+f+wm87ff84UasIoHvirT+uzUqsVWggq0WJPWp3zDQrb8SWGA/Si3yxJLOMid4vaBvQJOKEzIwrD1wgQlXc6zQ4BAoR2brPCxF3s3L8KdUm54FupS75fUt+g+HQ7UDSDUyNMvppn+Ma8uZY1iSgESpWPtqzcaLi1uYf7RluhmRpVhc1seWyxxXG8ZAo4xopqb4UsbcbxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oy1Ha0zAFvy/S30RkmcwwjlNxtPMGMndJgG6ptip27s=;
 b=Psuztng93Q3SKM4Jg74VGEtiQkW9YGd0OXUVn1w1EFta9CU5W4+TWU9f0iCS7/x51Tf1WVeiBHa8beTMyIETmsM3vzS41wjve4B9F8UKQ6jCDv/YzYW2CNPIUiY18o/wv7xQ2FTTC7typKLKWWMy4U4uUr3lNvjjyplKaa0VAcY=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BY1PR04MB9529.namprd04.prod.outlook.com (2603:10b6:a03:5b1::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.18; Thu, 17 Oct 2024 06:31:52 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%7]) with mapi id 15.20.8069.019; Thu, 17 Oct 2024
 06:31:52 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>, Peter Wang <peter.wang@mediatek.com>,
	Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>
Subject: RE: [PATCH 3/7] scsi: ufs: core: Simplify ufshcd_try_to_abort_task()
Thread-Topic: [PATCH 3/7] scsi: ufs: core: Simplify ufshcd_try_to_abort_task()
Thread-Index: AQHbIBAh08I1UAJq90+JH9BKaZqXRrKKetJQ
Date: Thu, 17 Oct 2024 06:31:52 +0000
Message-ID:
 <DM6PR04MB6575200F7AC6B1590BBEA8DCFC472@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20241016211154.2425403-1-bvanassche@acm.org>
 <20241016211154.2425403-4-bvanassche@acm.org>
In-Reply-To: <20241016211154.2425403-4-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|BY1PR04MB9529:EE_
x-ms-office365-filtering-correlation-id: ba707691-7852-4c30-5f79-08dcee75634c
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|10070799003|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?S/mRnuZu9W5CjbvkDXqvtfM6lI4Dvd9ZMcHjodAD2pRsPC98EAIXeqdh/kGH?=
 =?us-ascii?Q?14avKyH5jVgF0AMLixrNn0geMIlX9sIlVlUbyMe/htM7u+Mpe18s/4GMoxQY?=
 =?us-ascii?Q?bGJa5zvihScYjxKOiKt+KOpEWAVO2rDJEimHOIH0yF0aBhZ/ZWKcH1aCPQsV?=
 =?us-ascii?Q?6BDHMJvX5D6k68Fi3HCwH/T3auPyuLDrQHdi0WkpSRPtQsY70CC8IzxGNGjr?=
 =?us-ascii?Q?/L3h8C/EXktzr+GTTmWwbWTheW+W14PWgRiH3aIt0bw/a5NCDPczYY9uWfaJ?=
 =?us-ascii?Q?OZUJcrUnIGnh668wqfz7ky1TXhqGO74LL5Bnj3y/yvA62f6vaPEfRypDkv4h?=
 =?us-ascii?Q?sA0F5BU5e3WnMsIk+hhws6Q8UqBPqzZQ6YvFS/QVfTfh7spgACjCKuhBVFEJ?=
 =?us-ascii?Q?66236IiPm5ipPJnfv27VmL8+oolHTSwXkyBqZKk/7u90bG/6o9TPV+dq9htm?=
 =?us-ascii?Q?EbeHGxZytJpTATakBpMNbGV+hlL9Y0rFzVW4m0q2PvOawHc5ecs9xBTXJSV4?=
 =?us-ascii?Q?2ggG7wrl26IfBIzVTu5+MNu9HMf4QLNBfGrxpgZzjz1OGifsL++/y96aLd9/?=
 =?us-ascii?Q?wtz+9XFOsPYZ3iiVNGLh2BJnKmOJ0zkjXxeYkn32dWYpYIMH/FR5jNST6ZtT?=
 =?us-ascii?Q?E37BDG0sobvCXzjD0sOju/kHfzwEhYOSdqtlN8z0CpTqgWiKlxOq6+zlOB/B?=
 =?us-ascii?Q?RjRWbIepIe4BSV6VZonBBd1nbD27oSbT5TJokxZxT3Vk/8ehv2qiKa/h+jDw?=
 =?us-ascii?Q?pzz9ZXNT1Y8gcd+5t1O/YixhgSCgS4zPQqBYFIwruIzAdPyWIkCKxO5KfjbI?=
 =?us-ascii?Q?UezFl4t5BlrsivCIq4LWcSBt5vI52wjZyqworeIIJDtDf9gUN72N4Go5NDHD?=
 =?us-ascii?Q?x9nPRVsIt9/4CoH3S3UFSBRuN5zyIR1qxQOSQqn6jyHtWcrLs9/UfMGYh+4H?=
 =?us-ascii?Q?N9jRoUpQX234kHNTmrC2zBL+Z9yRsUVJNAs0aWs0uTWRrvUQs+KxyPjbUH7c?=
 =?us-ascii?Q?WRXrLAXJLfH1o//tgEGT/9SwhblXRy4de28XkPZhZmmaikzJrsBAHi8zDyaR?=
 =?us-ascii?Q?a5bTaYTP6nsqMUKm9oLdqbmdE2fCPN3jxflyFLZSU3VtNeAuDtTGOtwn97aU?=
 =?us-ascii?Q?oGi5zafUehmdLRpee0s2dqdzc1aRoQRVOOmMlJMlqJ2jhYxdU7hKoNOdRsSG?=
 =?us-ascii?Q?PLL73NoXrZGuOp0AXqC37EbdSnUqUF5XxyzuDaqbh6YBQsl+Rs1RIi9sdChs?=
 =?us-ascii?Q?LGWPrm2h9b5OFZCNCQb+85XCzo28QWI6oNwJ9ZlJMcXlYTDMbxL5NriJLya+?=
 =?us-ascii?Q?7x7fG0y4eZczyY8Cq79X7FXNMoypHI3gf2iA+T/8GZdxfKIy1hxozRjwDLps?=
 =?us-ascii?Q?3wQoNCI=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?rowzrhWKcSi+ZkXaC9VWweux7P5LVCY8UXf6SXOlGrVwipps56RhZSl/IelE?=
 =?us-ascii?Q?ktkqVgwFnt3ATZth+euBuJc6zuSVs09tnQWTynMa2ycaCGkaAa4BJuUcYrOx?=
 =?us-ascii?Q?v4XNN4a7g0pkadUqBS3ST+PxkhyeLEn0b636AH7LeK0WDiatZ6ZtKm3NCyhb?=
 =?us-ascii?Q?OoJG4Sm2woQpYMUSyROz0kGQZjLK37G1BAOw20zd0F86L0yhmsmlYma2mOzz?=
 =?us-ascii?Q?fkFpNp+ioZf3wQ2hjhrMOSZEcIYtgOYZFkchAygu7NYfW5w/2N0QtyaOy92c?=
 =?us-ascii?Q?9bMfTTWolSpiJCD0GSyxmOgYSZZTLcWd/EpJI5u1YdB/Rcrhkh+U2677XNnw?=
 =?us-ascii?Q?UJv4v9sIHIhxdiozq6f3s0ieij3BBYJ0mqev97zVZmPt79v4BVepFic4I/9a?=
 =?us-ascii?Q?DXcyDwbai+p0LuBxvgutUeUH4lnXBwxYAM60QNxVMHzakp0E3pUp35b2lbPG?=
 =?us-ascii?Q?nD0ERATWmOka+1ArpV5jSF2WFbzV/hpFSOmhRRemlA9DGjsSanwgLqdkx8wm?=
 =?us-ascii?Q?qdkqI5Uz1hLiTIdoV+eTKA9tb7kJ5VcvPdA9EZty+dIxhh6BV+lmU6Yu0xBY?=
 =?us-ascii?Q?sDquci+Jz7LIM4p9KGY12BEpZu8ftWdokRNZefsjKKmET39g6nMfjvMi0CpF?=
 =?us-ascii?Q?rf28wkTyZQIi6rvn3AeiwsCtNwJT/gm62nQ6Wod5/6iZhxA+UsrdbN5j1HWq?=
 =?us-ascii?Q?/Mp8W8HqolL1toeMmpwP+1DAmmomtDvw2/GUmU09IT7IyyywhFkKOJYvHHKQ?=
 =?us-ascii?Q?76O74WmssCOj7KJ0Z0fupvClkhO1BnwTx378zBUEc5o4xy6/uVncUfddI2BY?=
 =?us-ascii?Q?9wDJnaMECSvQNGbnC2AyWAaIkexAnznZC52dz6HXPEtuoVkYLNx91k8piuEQ?=
 =?us-ascii?Q?gygoc42krjZYdORgzUQ8jHGPzFZ19THgr0tvbXPUpUVXRQ67xhPZ3HDks0mC?=
 =?us-ascii?Q?N8xdn/eE8q9YpyZZPLuRxIQS2/phwi/G9uy8fwjIIm5yYaXnx+uTESDRFzhk?=
 =?us-ascii?Q?pfVRVJ4Wf1jMQaNnUPN+CpBsCcV6y3ZkMErKKEKfZpp+sVAcPFO/Vduo3M1X?=
 =?us-ascii?Q?/XT3UBNavILiRRSk9qQWG+fo9Hqu6GDYeaiGFVK8tddB6fIEXfCd18kyfkH5?=
 =?us-ascii?Q?TLgUdGaidQ2ncRHQiLi7Ad+m7xGnhGpE22pZHFLkajQ6r4Zqd9DfCXiygZzX?=
 =?us-ascii?Q?HkEXgsoU+uSkcjcXsRnhuUWIPAhfHOPqTmal0T+P9xQoC6j0zkON60fTKbIo?=
 =?us-ascii?Q?JQP7OPIH+umXITUeYajCaaxJxBHYOPZa1GkbkThQQykgN8TLs8KIT8IWYxoE?=
 =?us-ascii?Q?YK+xdyJUHxRQRqKPJvneGxmkU4uCFnE7e6Na4NNGvVBfHjzkz6ksKuivPOji?=
 =?us-ascii?Q?uOGMilNik/qagM8/0tEVSktLhf3pgSnhOchZHJCKVXS1VlEJeRvOzGWAv7Zq?=
 =?us-ascii?Q?xAgaimHXrlOnIgNuHnl7r+y97NKgGG4smj0+YBBZPAljcqb1SxORG81yr7RK?=
 =?us-ascii?Q?9xy77w7SJNuH2Qf+U+KKy8SqSEI56KHrgD7XZY8yU6smaKze1mitbVdFZflk?=
 =?us-ascii?Q?hodIIhlmjAzin04w6CGktQ0epBGH2FLSLQI0FISwXkm340zuDMksY2HcT5Bm?=
 =?us-ascii?Q?aFfRrwTxwLBrZ4/t7hGAbEHAcL3KB/1f1IgErX5Uk34Q?=
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
	Hlqa5daNyAlWL4nauv9oFyS+ZOphsBUGdJyZIRbaQS7mMTQVVwrTX1yWFcRV0zZv0GVkY7cAt/iBts1tcJhBqgBpbpMkyNn9Gfm0IUfU1Wu03hSC5Csi+6Zj9bgy+3G+4g+b9BiTB1JxNgyGZx6iD9Fsqvt8jcw4FLBQD1RmHSAvOAPLawO+RvisYtTmJwFXcLJqyMS4TUggHN39mRfguW+h0UMNQmpxDRkKspDJAYiUEjRKUCtC8AouqZxh/6rOfjW90u/7rVLUthx8yK/Nl3LdL9WCrMcEhRPfPbkbdAKtqr4th5X9UUlUiyuJHgd5iElMICfv8hT/ZogrNR3ZRTU5LVQyBPRp5eTO/Oi00cCX/Sest96PSvQidXGUiDNuPwE/5b02lUQBS51XDHIdPTHfpD6oxYoFU1Jsss4HaHZ2qx173egUJg+vUCJDNG7OPEjOKWKw62L5/IMblkHbh3betRn7VVPeWSV+1OLeajZu9whNwVTD9PBNsrUKhvRS0OQLPLp5NM+DW50+e8WJOwmW07GAun7LoK+EXM72sKqXOCzSM8JAXPeQ4EcEK5C/P/ldL5AzUF4EcmOWdi+3xhCzxI80yIxKL+9S4SkSQb1CAzP792zz2hVh2hwv7x95
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba707691-7852-4c30-5f79-08dcee75634c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2024 06:31:52.3692
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7rrVvXAGl/QO51CeylnfZR42OukCITFG2LpfPB4U26x5xgF1w4Uqz6fwyd4TzeFiBxiQ+j5Gmx/iX54niHE9yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR04MB9529

> -                       /* Single Doorbell Mode */
> -                       reg =3D ufshcd_readl(hba,
> REG_UTP_TRANSFER_REQ_DOOR_BELL);
> -                       if (reg & (1 << tag)) {
> -                               /* sleep for max. 200us to stabilize */
> -                               usleep_range(100, 200);
> -                               continue;
> -                       }
If we no longer use the doorbell to determine the inflight requests,
I think this should be your patch title, or at least a clear indication in =
your commit log.

Thanks,
Avri
