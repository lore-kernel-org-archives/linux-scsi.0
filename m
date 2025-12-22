Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC2150276
	for <linux-scsi@vger.kernel.org>; Mon, 22 Dec 2025 05:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766382965; cv=fail; b=I8C0/Fr0TuqaG88ohH30B1KGIfArCB1rpvEXXrhyp11trbsCgXFYDfkDXVDCF7wRfksRsMEkfukX7xeTfFI/wxm2Sf1EdRngs4C/os9+hFOj4omStRfMaq6vaqB1yustGcRyG4PPnzeTu+KsVA8qwLf/Z6mAWb7M0hKbc99JVYc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766382965; c=relaxed/simple;
	bh=TCtZmKO6z3C+MzZaa7xfhacC9/oRDqT80Itd2VktxMs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=G6XEPvV4Hgppy5+kOprGb7L8oCkQ/cdlz2KwpKnp/Omn0IUVzPb6ZwUY1N9H3746VN5xbS+qi3S46H6PJnWeFsetT6PDP10j6mU+LN4R8m1gs82Lm7OgziLJs4DGv+i73Sdq62OkjoXzEfmILRiE1LTnwZQKPqx3Yb8vyclslmY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=YPQohJDw; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=fJeUjRxR; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="YPQohJDw";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="fJeUjRxR"
X-UUID: dee01d84defa11f0b33aeb1e7f16c2b6-20251222
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=TCtZmKO6z3C+MzZaa7xfhacC9/oRDqT80Itd2VktxMs=;
	b=YPQohJDwnKdxCj7Y5WesjFWUD62ak47g0Nmzl3nlotbj9lBpXknUMEOMpobL0y4WgzbmADKcw/DGirx2qhHbwF16yVMjTUCkiLrcW76iwewN+VTqpeAqKFgqKTKEzFwz3pmZMIRnsacNvVpgKka/sPLcow1HOib8JF4L9ncFMyc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:b7e5d622-f8d4-4366-9260-8e8890041420,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:757a0703-1fa9-44eb-b231-4afc61466396,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: dee01d84defa11f0b33aeb1e7f16c2b6-20251222
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1374006117; Mon, 22 Dec 2025 13:55:51 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 22 Dec 2025 13:55:49 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 22 Dec 2025 13:55:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PFs0pdTLW9+W9qiep1IRoI2ng2uxmQitZ5xJ64+jtE1pAs/Tvk/TL/w9qvdsO+aFnXmneq2WDwB6+9YGzzpZrnIxlh4xs+0d5cnC9kv8LSzYlVH0RYnwefn18dlnumfLsYK/x957i0/rSrUTtYgsYvZxHuj51XOGv0THtJZW83aKWI/JnQ+GDx03Ua6gY7aWs/VFqRvax62MpXvSi09zNvwb3qzy9XOskHVcBNcFrZI7ahfKKPjUp8KHVDkCu5SEVnVElPWHpOxfqGivYPkjZOo99SN2iAk1AqPeefqsq2BqjDotf9N3gf/LO+ElJlMtS1+5j12q5Ui0K4c/vXRjnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TCtZmKO6z3C+MzZaa7xfhacC9/oRDqT80Itd2VktxMs=;
 b=qLC2mr+wAS46R6u/3nGEbUYsXUzkbQg+IQ5y1y1ZWFNLt+WkzJ54BS8AHk6SSKZCPN7Iy8ROqn1ARcgN6FxHDnRUBWDYzhsCvO9z00wuoNe49vCpHwdF+4Z3Yc53X02UUkALjuQthwVTOPjP07Yb2p/H5vvMlWsdiidBwbfvoHnfYkyqXsFcuOSbF0K/zux0DxxOL09a4OyXn0Ya969mTKid0hk0OsNoAjj+Fg1U0VqVTPHhsIcVdJMirggPPQv5UNU+oWYzPo2wionqkhJaNIs5UuTMvNMmJ2JrLITjUn0qABNZ3gR/fcsM+zgWD+tzF65mGWu9wECoxw1k8pYzmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TCtZmKO6z3C+MzZaa7xfhacC9/oRDqT80Itd2VktxMs=;
 b=fJeUjRxRZsaP2ReINTZsQRNT3LTspYoCRpQQ7ozodnmFViB2fimBh4TollKXBYGCw38AGgwTDmLdlntsvvgjM1jRXFTyascEYMuuod9mfREn1ziIO9uLxGNDheNTB5GaDBJfxSK2n/FXV+sGm+cKZbNt2ngUGLPntp0PhLgAG/g=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7197.apcprd03.prod.outlook.com (2603:1096:820:df::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.10; Mon, 22 Dec
 2025 05:55:46 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9434.009; Mon, 22 Dec 2025
 05:55:46 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "nitin.rawat@oss.qualcomm.com"
	<nitin.rawat@oss.qualcomm.com>, "avri.altman@sandisk.com"
	<avri.altman@sandisk.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>
Subject: Re: [PATCH for rc] ufs: core: Configure MCQ after link startup
Thread-Topic: [PATCH for rc] ufs: core: Configure MCQ after link startup
Thread-Index: AQHccHM2kXmeV1GmHkyH4oME7gZbu7UoknaAgACW0ACABAUNgA==
Date: Mon, 22 Dec 2025 05:55:45 +0000
Message-ID: <e9f1df51050a935fc4e1a2a29066e88bf20f8c02.camel@mediatek.com>
References: <20251218230741.2661049-1-bvanassche@acm.org>
	 <877f7704215c36bfb15808e3a168767845ce09c4.camel@mediatek.com>
	 <6745d2d0-e8c4-407c-a22d-5577997f1ca3@acm.org>
In-Reply-To: <6745d2d0-e8c4-407c-a22d-5577997f1ca3@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7197:EE_
x-ms-office365-filtering-correlation-id: 8677e04d-e109-4bf6-3e18-08de411ec017
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Y1ZURFh4RDVlMzBIcENyTXdTTzlKOG03K0REcmxIZS9pbXFnOU5lekJPQnhl?=
 =?utf-8?B?RmRERDVuUkVrOVJIeFd3ZWpOajMxSzFhZTZsYXNUck4vSFc2c3R6Qy82cVBw?=
 =?utf-8?B?Wlcrc3ZweG9MdnIvTmdkZENNL3gxZTFhM1F2UHlFSnd4KzdXM1FPWGRDYTFi?=
 =?utf-8?B?M3FYd0xxc3FwUlc0VHAyRE5rMWpxUmlkcW5nS2dkUTNBb2pKK0VBOHErcVpm?=
 =?utf-8?B?OENBeDdIM3hzUHRxQmt2S0x2bGFyekhURm1iUzVYS1p2RlF3WGhkclBOUmNW?=
 =?utf-8?B?UjJQVzdXaEp6U3MxdHU3bXlyNURUQmJrS0prMFl6SHBxQUZydTZHdFk3OGRB?=
 =?utf-8?B?ZXN1bnhMNlZYNDl4K0V5c256ZkdvMTBKUXRoTG95MXo3YnhUNFNMQTVTelVL?=
 =?utf-8?B?N2Q4ZHRoMmNLV1pWYUhaOXBjT0tmSTNEUm4xWVQxWmg3cmMzNE5jQU9EV2o2?=
 =?utf-8?B?NlhSWm0yT0JSaXlLb2I3ckNnZXlYM1MvazEvbDFhTkp2MlVjZlUybytDa050?=
 =?utf-8?B?YWZXVUlJbXdlQWtZOTJNd1d5WHd4WmlwV1lFWXNpWjNlSkplSlo2VnJMOWlH?=
 =?utf-8?B?dTNtbnRnNUJjQnJQQWpqMi80VkRWRUJGaXdZcjQwUWZhRUJzcjZHbnFoZ2Ri?=
 =?utf-8?B?REJERGZRY1NYbjBPMXhxTm5wdFRidFp2WjBqZXEzaGs3d3FyekEzWHdUVHpX?=
 =?utf-8?B?WEd4TDNweVJSdE1rVHRqUVdxRWFXRFJaMHNtRGpkbjM0dWx0bEdQKzl5T1Bz?=
 =?utf-8?B?RzlYNG04MU4rNm5WYy9lSStMbkR2V0xkSStIOWlIcU85TXZ0UlRIbHB6TnZB?=
 =?utf-8?B?MDM1ZWVZV1g5Qi9oVVhlbTBNSFdFOGVLYU9USTJGR2hDaTN1bGhGVzJWOVgz?=
 =?utf-8?B?R0hRMGxLc0cvdUFDRG1KNWlSZ2pWSU9SWlpqbkYyZ3M5UDlPVnUxQ0UyRHkx?=
 =?utf-8?B?WlNGNjA2cHB1YVBPdU9yWXM3TW45QVYzTXY4VDJER2t4OHNwUkUydTBpdFU1?=
 =?utf-8?B?dWNDV0xRT0kvTUpxcjZCUE8wQ1VKckZuZ3cvNTloWjdBaFVpZ0dOajVMYjVL?=
 =?utf-8?B?SFhqL09WTHpvU1NXNkdGc1dtTkY0ZFRwY1pSbCtEclRyQ1NuNllTMk94Vm9K?=
 =?utf-8?B?QkJNY2I2V2JRUUljK3k0RTVzQ0ZIMGhKQWdLWFF1U2Y5NXphbE82NkVCTlRP?=
 =?utf-8?B?b1JXd2xkQ3VQb2FtS2tyRlhCYlhBOEM3U2lndklWT0xHbUhTTGRPWkRpT3di?=
 =?utf-8?B?WGhVWFJrZnV5WkFsNmJENUNZUGtEWE1rSE0zb1kxRjJWMm9CYjYwNVhVaDVm?=
 =?utf-8?B?dmJCWlJxR2pQZEFSZmd5R3Q5L1BXSVErK2g4c01PeWI5WkkzWHhLUmdKRVZP?=
 =?utf-8?B?YktxVUF2cE5CWXVmRkNseUNNZnB3OURxUmVYR0loS1JKR1Z5d29iOE9lQ2VN?=
 =?utf-8?B?TzRiU0xMTFFleUV6Q1lUYy90VDVMY0dKbUZSZXJIMUVra1VQU25obE5ib255?=
 =?utf-8?B?U05NNW43UGtGbGJuSHBUUVNhUGpnRDBjakhzb3NIeXlRM05ab2pnQ0hXS0dC?=
 =?utf-8?B?Mmo5S3ZiM0ZlVktuQ3YzaFdaZDNtTDFIM2d5c2czVGxwUERhd0JLdVFqUnNZ?=
 =?utf-8?B?c0lrd2Z6QXYwRlloMWViY3o2TnpkemNkbVJjcTZ0d2gzTHlkRFlpM28yR0wx?=
 =?utf-8?B?TjRMaDk3YnMweVhLLzFYQU1OUFhoM0Y0YmZyZzB5U2QwdjRNUnZwUlNNcm5k?=
 =?utf-8?B?dEVQcjNFVHU4Qy9tSGxaT01oZDdUd010SmVLN0tTZ3phck5mektuM0lOOXV3?=
 =?utf-8?B?RVZSZFBobkdNSCtBQ3FxUzFZUzQ4N1lyaHdVeTFmQlNKSHVPcXdnZ2tIQm5K?=
 =?utf-8?B?VWJIMjhCK1dCd0RwazhDbzRIaDZNT3h1Ym1ON2c0QnUyWUtrbVFzTUw0ZHV6?=
 =?utf-8?B?cXJvNjRlVHdKOXNvRmptMTZDRlZsNkFqb2xTUG5GeG5YNHJUNW1KMnlWbWl6?=
 =?utf-8?B?YUZNZHFMckhIY290dVAzbmd0UVd6L0ZLaUN0SE9vOW83MjlFb2hYNW1ManRC?=
 =?utf-8?Q?Roks8n?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YXU5NVh6UHl6MzJseG5DRlFFYXcxNXdDVGVwSEdESXN0VmpxQ0Jqc2tpQU9L?=
 =?utf-8?B?Sm1EV3hSMTNRdVRydjVqNUNoN0w3cVJYaW50cE1WN1p6QmRMSUJYMXlzK1Rr?=
 =?utf-8?B?V3lEZ2MyemVDcTRyV3lqTndoVFBseEt0S0FWQ294ME1xeG1wN2djcDRROEo4?=
 =?utf-8?B?ZE9Gemo1KzM1RjlqOUdzT0YybllHNTRhNitBZmd1czh2d1RobDU1Y00rL2tV?=
 =?utf-8?B?Uk9PNTJIL0tndzF1YnBIdWRhTUdZcVNhU1AvNGVnbFhBWWZVN3RGQ2VvK1My?=
 =?utf-8?B?bXE3SzFaYmM2ZjBieXlHMUZhREhKazFsSTVjNXZLQm5iT1k2VTQrcnJncnVa?=
 =?utf-8?B?WkpkeC9BUFlkSDFGVWNaYnBvWnd0eU4rbXQ1UkNtMkl0dy95c0hZWG0vTU11?=
 =?utf-8?B?bmdUNEFpMHNBVzZjZ2RJZUJTemkwaFQwK3RIS3B0c21tWDVHVFBhODlBUWZV?=
 =?utf-8?B?SVkzVXNIUU5xWlZLRzN6bnNBRUZZV0tYVXFxVjc4dytJSjRkbVhScnBWWklr?=
 =?utf-8?B?enZmMS9KUVVLSkQzZy9ORXZsV2dtcDRETFFRdHdLNVZRa3FabkFZVmRnUm55?=
 =?utf-8?B?aHlTZ3dyWW5LWjR6ODdBMnpPQU9jQWdJKytNVVNuYkpHdnE4OVNSc3hIOFJw?=
 =?utf-8?B?NnROa05wUVBObjdlQjZoSm0zQ1ExWGlhamhuSHJwVk1KRlY1bjczemR0K1Jh?=
 =?utf-8?B?bVRRc0drWDV3KzdmL2tYUmVac3RVdHhoK2FEZVFSd0EwWkFrUzhHRlhZWnJC?=
 =?utf-8?B?THNncnZxK3hRazlQNldhYXV5dzBOa0tyeGJxQ0k1MVVKcm1xV0gxUldJdEhp?=
 =?utf-8?B?U1g3OERWZ3p3enpvdXlHdUFiaXRFcm45Y1JMREVLS0cxYzRlOXJlRGt5ZUM4?=
 =?utf-8?B?THVuWGltYVVFeTBvVzFGYXliMjZ6N3UvWEhPaFU2MXZ0L0xJc2RVYUwrejY1?=
 =?utf-8?B?bVV3WVZiR2p4azVFOExWZjFzbDRTR29XdDk3MHdsUlJvcUdkdzBtbUIvWDhF?=
 =?utf-8?B?MDlRbEwzdTlLRkp4Nkc4eUhXOWw5Z3NOdmxpYktSZVZUeUNTT3Bhc0FZZUhF?=
 =?utf-8?B?dy9BNVh5QlNLL1ZOSUdKK3h2ZUJZSjByM2hoaVV1OUo1ZnpOQnhsTVZOMWwz?=
 =?utf-8?B?QnpoYmdseGNFVGJVQTNkTmRmRFNwdE9aOWMxeG11VWowNlNuSnpoTEpYVU5O?=
 =?utf-8?B?NFNNZkMvNFlvRGQvWDFMV0lrUjJPMDVjcnFCQUxvU1hTUnM2TDRhNUFrMS9K?=
 =?utf-8?B?WVZuUEtpZTh3S1NKOXM1WkZSVnRJYmhoaTk5WDVBdUxleUlEY2VpYVNCWFJn?=
 =?utf-8?B?Z3Z2SEVYS1pQZDFNZ0p3ei9LaDUwc1R4alhTUWNtVnlSaEZ3UVVnRzQzNVNl?=
 =?utf-8?B?RGd0anZWdUpIM2lPWnZ3dGNpUXZycEVCQ0xNVVRYS0xyVVduTnZTdTYzeVdO?=
 =?utf-8?B?K0hEYXRpWXcwOVdjVzdCcHJ0dENkdy94YlNPTGlrT0hhejhEZ2V6YXp4Wk96?=
 =?utf-8?B?blJlc3hIZHpmM093bzFWV2RZQ0lOOWxMejlmNnY0YTZROGpRUXBqbVdDL25L?=
 =?utf-8?B?NHlqK2dYZXVrR05rcHZzeVkyMzNrUzcwZkNLOHlSVnpPNGV1U2VXRkVxVGJP?=
 =?utf-8?B?MkU4bjZPS25XVjBWa01CN0txRnJVTzd0dUhzMHBwSDlPTTBOWkdoSDJORGYy?=
 =?utf-8?B?RGxnZlRRL0c4c3J6UTRCNWEyR0Vtd3MxV2h4dTRZbWcxdGRlcjVHSkU0MWpN?=
 =?utf-8?B?SlZtSUY3R1p6a3BUajZOaGVPdWd5aE43U0MwaVRxNXV3aktES1JhOUpXS1c3?=
 =?utf-8?B?L2Y1Sk1QMzVZK0d2YTRhSEhBcmNPSWNLL2svZXZsVVJkQ3lqMmFHRDYzaDl2?=
 =?utf-8?B?aWFTZVAybUlnZzh5OUROb25Pb2V6a2NRTHVzYXF1REh3VTJDMzlQTnphL2xF?=
 =?utf-8?B?UHVUTFkxV3N6Y2E0NElwbmRPRDNrUkdjYVp4MDF3WWZFTGJJZ2IvMW9kRXU2?=
 =?utf-8?B?Sm9xZmRuQzh4VlZxY1U0MnFKbGxWQUF4by9wK2pBcTdQSUljbDR4a1kzL1lk?=
 =?utf-8?B?NEJDNmtUUkJEQmdPTmtYMVdYQ29IRW5XMGJXK3g4NzlOYXJTZFVKSlA1K21R?=
 =?utf-8?B?aXowWUpGM3FFRmtmaUZYVWFBQ1JtQXk1VWhYem5pa3c2dURXcE9GdlNVTHJj?=
 =?utf-8?B?MUl3VlJRRjd2VWJ5aEQvcHp3TWFXY1RVN00zUkhVOEhteUFIUHFQdVM4a1Fu?=
 =?utf-8?B?Q2dLQlhJUS9yUlNrSUtScWRhVmx4alhEWmdMekdSeGdPTm11OCtMNTZKS0ZW?=
 =?utf-8?B?elJ3eXFiZXh1OHVDYTFuQ1VaTzhNT1ZkbW5TajVkaTliLzNxcjFRWFRpWC9m?=
 =?utf-8?Q?XJI3COlSFTdXCATg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC549BFC45379F40B9E1168197D634F0@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8677e04d-e109-4bf6-3e18-08de411ec017
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2025 05:55:46.0266
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UKFLqumyWVWQdcQbHQ55H9P7SWQaEkQrbVNXIJvSlya8QYQDsW2umr79eg7+B10bwy4sOEwDCihW10ySWMdr4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7197

T24gRnJpLCAyMDI1LTEyLTE5IGF0IDA4OjMyIC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBUaGlzIGhhcyBiZWVuIGNvbnNpZGVyZWQgYnV0IHVuZm9ydHVuYXRlbHkgdGhlIFVG
U0hDSSByZWdpc3RlciBzZXQNCj4gZGVmaW5pdGlvbiBtYWtlcyB0aGlzIGltcG9zc2libGUuIGhi
YS0+aG9zdC0+Y2FuX3F1ZXVlIG11c3QgYmUgc2V0DQo+IGJlZm9yZSBzY3NpX2FkZF9ob3N0KCkg
aXMgY2FsbGVkLiBoYmEtPmhvc3QtPmNhbl9xdWV1ZSBpcyBkZXJpdmVkDQo+IGZyb20gdGhlIGNv
bnRyb2xsZXIgY2FwYWJpbGl0aWVzIHJlZ2lzdGVyIChDQVApLiBNQ1EgbXVzdCBiZSBlbmFibGVk
DQo+IGJlZm9yZSBOVVRSUyBpcyBleHRyYWN0ZWQgZnJvbSB0aGUgQ0FQIHJlZ2lzdGVyLiBPdGhl
cndpc2UgTlVUUlMgaXMNCj4gcmVwb3J0ZWQgYXMgMzIgLSAxIGluc3RlYWQgb2YgNjQgLSAxIChh
c3N1bWluZyB0aGF0IHRoZSBob3N0DQo+IGNvbnRyb2xsZXIgc3VwcG9ydHMgNjQgb3V0c3RhbmRp
bmcgY29tbWFuZHMgaW4gTUNRIG1vZGUpLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0K
SGkgQmFydCwNCg0KWWVzLCB0aGlzIGlzIGluZGVlZCBhIHNwZWNpZmljYXRpb24gbGltaXRhdGlv
bi4NClRoYW5rIHlvdSBmb3IgeW91ciBleHBsYW5hdGlvbi4NCg0KUmV2aWV3ZWQtYnk6IFBldGVy
IFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KDQoNCg==
