Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603A0374186
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 07:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776844373; cv=fail; b=Du63dKcvpVPtuwZQW8QNxAGrdOq11ER8TA8yC/UKE0cPJFt2bH4HiT2xt1GCoY3agP0DI0i8Qz+ADrnU5vxNRemFl6Ec0uOWHcDZsNuFArWwJSIVT3IRqyiRVoNJ+N+l0TRDsdLwhtcbpGPswNR3cFsysqHHxKv5+4eRE2V3dZk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776844373; c=relaxed/simple;
	bh=XplV0+JeVi0fkLgmKjDkylxORCpyAdVq/yhCWQ3kXZ4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qRVBhup+0Hw65SzOXrPBc48cwJvkc+OABLlOXzhkOkLhnB7lfbLOO4jbaXeYj6vrkA/tD/eZBf5InSFRsU/bC3cgpDlW7jt7t9/rzT/WYAWT7k6w9M9GkiffthZT95PIhfchUfFqGMLzqHiHdrosKt6F74OwxUgEC8N17QaLq6c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=TySgG9A4; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=pPgMH4JV; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="TySgG9A4";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="pPgMH4JV"
X-UUID: 3b5a31103e2011f19781c1a04af40193-20260422
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=XplV0+JeVi0fkLgmKjDkylxORCpyAdVq/yhCWQ3kXZ4=;
	b=TySgG9A4aZkglLFDzIYf+tWkRewFDK/byD8pnNumNzdlW2wLuLrxyWDvKKjebNzxKt3f10bnaL6DAGYIN12bnth4UeR7nkyy31Y5rAl4U/kr4RIksE3/6HagUZcxGHit1QATfPYoa7j+Otu8priJgWZ/WU5nYxhyi8MAsbWqlVg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:6493f40e-2f55-40f2-85b3-6858a8bc1243,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:f6f52ad6-060f-4ecc-9ee0-121eeeb4a682,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3b5a31103e2011f19781c1a04af40193-20260422
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1016638609; Wed, 22 Apr 2026 15:52:38 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 22 Apr 2026 15:52:36 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 22 Apr 2026 15:52:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B+0X7wYAQ3jGieixSYOsmV3mkQQ2b/BBGDhSeXLqUGgYWP2XQy0ETT7urtYYB3AbS49NgDTW+tvf58MTaJ3qrdfJjYB1pXb9YaglQInDujo6cTfEIosduPFZi0l8eg5SPt+XfozDFXbiyhiVQLztzr3j2R6e/dAhzQjhr8rYokqfT1TfXO1Rm8w/Or171DX3yW0uLW/rbkGrcwMi7IrZ9LDRMa23fWif72yrHlgoj0AfMDGA+p0Oe9fQYz3V5HyLpWjXBSBRr3JvZRZqokNLUpZJHp0HoG4z2NdauF8BU/wdLgnmAL9QcDCCoIgJOP7ubrK8l0huBzHMo10aRadpqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XplV0+JeVi0fkLgmKjDkylxORCpyAdVq/yhCWQ3kXZ4=;
 b=YpJIuMgUMcy/+OsD11ssHLQf2JqdclbL/IaNLH/3fcqgY2EWxF1YcVIlQ5kc1L4OC/XP8v5pVkZ4Re42nr7A7sBXIxRRdy/9fU56C4ygBjogie8yQS6Lo5BryZqDo7EgRaj/69Cb0wgxtYdnstBhpcQOVcxdwdCvJx9XPKY7DcnytvldfhqFflvN8GbK8+32FwmmD+1NXvKQtuehda6fS42lPtew24AeYMPxOw1ANSZm/NCNA1xn2Z9Lfo8JzpQtlc3JNYUFeQuq2vy1rbHNn+gFg+XzERNiQKvmk2vjyFW0ho333lRDVMX65+c1R6qQD12f+xrUvW3kmMfBguKMig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XplV0+JeVi0fkLgmKjDkylxORCpyAdVq/yhCWQ3kXZ4=;
 b=pPgMH4JVLtbwa2ulUktoUSj/MzcDDK7jyNICos+KJB592oKFdCLr+XxpgbjPGfhtZa9+f7+ROoJjJmkrS+GKWQK6BOKVRjFCH6vVRV6Ym0RRcS+X8ib/xy3AZoy443wEUWoFnMa+2xlK3DNhtPN6v6jRNWTa0AXTu/2bbZIvp4M=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TY0PR03MB8173.apcprd03.prod.outlook.com (2603:1096:405:1a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Wed, 22 Apr
 2026 07:52:31 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.20.9846.016; Wed, 22 Apr 2026
 07:52:31 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "can.guo@oss.qualcomm.com"
	<can.guo@oss.qualcomm.com>, "avri.altman@sandisk.com"
	<avri.altman@sandisk.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>
Subject: Re: [PATCH 3/3] ufs: core: Optimize ufshcd_add_uic_command_trace()
Thread-Topic: [PATCH 3/3] ufs: core: Optimize ufshcd_add_uic_command_trace()
Thread-Index: AQHczrGOUq1Ly3XnN0iBS/EhVvxRmrXpOOKAgAC2PwCAAM1rgA==
Date: Wed, 22 Apr 2026 07:52:31 +0000
Message-ID: <24b3f4f1e6d723c6d0aa5a559fcb142b32e0c9be.camel@mediatek.com>
References: <20260417213027.3506742-1-bvanassche@acm.org>
	 <20260417213027.3506742-4-bvanassche@acm.org>
	 <a186b02b00694be3e89cd49d477c050df4bb1cf5.camel@mediatek.com>
	 <31c4e534-80e1-455d-8057-8b71a7616de5@acm.org>
In-Reply-To: <31c4e534-80e1-455d-8057-8b71a7616de5@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TY0PR03MB8173:EE_
x-ms-office365-filtering-correlation-id: 0fcce3c4-50b3-4e2d-e3de-08dea0441b8e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|22082099003|18002099003;
x-microsoft-antispam-message-info: G1LPuJium6p2vGgEwwTobhCIOQrYmNbBrJ6AIvQ8HBGYWBhIqmY/edUi6wrJujWCv3TtnPEcBAhQrirqE7HwB7DNI48lWMcj2l4yAHtKbuPB0uocn2TW0A9H7aXD5DX2AG4APA/fEKp7q7jJZyi5HiclfKsQGMm4NFjEPsDjM3b0bPfqiW06KqDIDmTfjEcE9R84xgysvOKH/L392fptb1JDGbBvZKJM2EqKAc05878u3w0cHzKysb60eAfsrUNX6+cC1BOa1uGJ4V1goaOcEAFGpLseUcs+UYk7exdFEbwSSQaZtG3GHjwrMCoTa8KFkeaD63QWhKLQndDMcrmfKOFb9OWPdXUzJ7trmJUrFqKpvyTqY3NRG0JD2PblfPLzDWjWWyDGCMIm3Av2uKtveQ8EiTse/q6aRGgx4375sH3uvcssA0dwCf9GexqRTqEKA0NkF5LDQn5Gfq2zZ2MRhpK3YIeR7qYmQWCi7G/+mjhxjG4Nq9VI7cawWrksn7xh4Viw+kN33VSUiIBMH/4GYv5jw0aZIgz/seVJh9Upyp9tH/gBxW9jlZnrP7pirGX+eeOQaaZKKj2PQLRBuGdNjb7DS4lsd+oLt62FaHrAqkgj600AR7peSnpTfW5np+ZzBBTBK93gZTuws7ak20R/dI8HbUysO421aFH3u7n//061X1f+zguFwAb9R8KttgP7MvR34qB8NEBbx0dSAIl2V01yuo/T8hyFtwjvp15LEPv4TAsQXKXzMna2OIS2XUDPouGpqWOet8okTLzqvgnj1Eb030plKuZmvTG1eQ/Zzp8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MXlXTnlBR0VoTHNpRUxQcy9TbVFIb0VtUkQ2NDZxSzZwRW0wVGpEL0FsQ0w2?=
 =?utf-8?B?S2JRYXVPTmt1U01aYkdDaVRaZ1hSdHd2K2ZqMTU1UVUxdjRxMGN4VjArY0Fn?=
 =?utf-8?B?WU9XbXBjcytnWmRsQkdYdkFNT3NueWUzTDdyNkxTalZJNVhRdy9qYkN3SE1R?=
 =?utf-8?B?N2gzbVBCcVNkYXF3SzN1aXpWZ0t3ZWlHdU9QMFZaQnNnZkwrc3ZYdEhpZTFK?=
 =?utf-8?B?clNuZ2dIL3U0T3pjaEEzdG0rR01yTkRKQk5KdVl3ZVNDVVplZE1QQjA0T1li?=
 =?utf-8?B?Q2VtL0h0OWhZRVFkRE9CUzVrWHpMdDRCVGpjb0x6YnRSd3NyaC8xMks1SHVs?=
 =?utf-8?B?WHM2TzAyTlkvNmFxREhWeHBCUTBMSGdvWGFNZWkvb3FzMGw1S3d1S2N0eWZP?=
 =?utf-8?B?dWo0TlgvaGN6R1graDBqZHpLVk5rSjUvSzN6TzZQNlhjMVRIYk45aUhSZU9X?=
 =?utf-8?B?NHNNN2pCUksyNWVOc1FMbXFqRDBWV0k0Tld6R1lvZkFjWHBrZGR3Q1pVczRO?=
 =?utf-8?B?cnY2OGpxUWQ5OEFNbDdKNUdKS3pBVk00ekZZd29oVzh3ZlZmQXh1MVB1bmlE?=
 =?utf-8?B?akphU1NLenNDWXAvamM4LzlGQTkwNzMzMDNoLzMydUJSc1RDUklvWXBDZ3da?=
 =?utf-8?B?a1VmTWZEVU1pZk03NHJmdEprV3dWaituTlpGTksxcVRuUGJSa1EydjkyU0JL?=
 =?utf-8?B?T1MxcnBwMHVtS2xtWEJ4YnIwZGd2UzVTZmxXMUdrbFV5SWxBWmluL1V2Q2di?=
 =?utf-8?B?Qno2bzRocWJrUndKUnphbS9oUDUzeW5BaXdEUU9jcFlSQzI2WG9IaWRRN3ZT?=
 =?utf-8?B?cGJwWFgrYkNCTmFtTGNXaWdPa1E3bDYySGxsb2xEeU04SlcxR2FTS0pBUnlO?=
 =?utf-8?B?Uk0yRXhMYm1KN0h4MlduenhYYk5pYzhKa0lKcXZJOFVoaThLcjlJNUdjcHpx?=
 =?utf-8?B?Vk1kdGlvL0tpVmc3bkprQVZtdk1wRzkwRTlIcC9KcTVrdkhObFowdkh1NW9X?=
 =?utf-8?B?Q0phb25VVEdXWlVhekFYR1NmSmNQWG14SlMwcnhNVkhOYWljTDZBQnBhbVlY?=
 =?utf-8?B?YklTNDUvUHZmNm9oR0xmVkJhU1pJVitKeStRcWdyNm8zc3JIT21mYlZmQWFw?=
 =?utf-8?B?bnFwam40bDBUUDdRZGNYYk5tejArZEdDbEE5VzhxbUt3YUJBRU1Ka1VVT2Mx?=
 =?utf-8?B?TXQ5cFBmRkhZY3FLdURLdVFzYWlaYVlUT0RwUVV2OG0yOHViYUthZnE1azBj?=
 =?utf-8?B?bEZXdGRhcnR6R3JPQUdJdklvK3RRUy9IQ1liM2hhTmhXVGxEODJQUFJZSzNX?=
 =?utf-8?B?STJGVjZIS3BLb0JOQm9LcjN0UFMvMFJ4ZzZDa1MxWEtxZ1RSdmNabzZNMjFU?=
 =?utf-8?B?cG5CVS9WTFdOSS9mT1h5Z3lxU1c3UDVBNXJ1UHFOMUVUamVIMFJ2WnJZcXJR?=
 =?utf-8?B?VkJVa2VoMFFlRFIyKzh1YlBGakw0cnVndk1DcGkrTUhncDdndWNGeHdGTXZo?=
 =?utf-8?B?bWgxNXRZV0ZmRW05RHlMTitSOXZEdWpPaS9qbFd1QWxQcTlYbkZydi9Qc0xs?=
 =?utf-8?B?bVBsNTBIYlpWZVpUL1JoditPWTFvMWRFQTFrSnFvNlgxWEpldnZyTzJQNjFO?=
 =?utf-8?B?MnVmcmlEb0lyOVFLbFI5QjRiSCtTcDlRTXIyR1ZzdENUaDlLb1IrZHY4V1gr?=
 =?utf-8?B?dHE5c1NFWXF5SERvMDAySnJMUGhLNUw2RHdJbitOZjVaWnZPUklxeGlYSWlS?=
 =?utf-8?B?K3JIRUNST3RzSFU0bFVWT0FpRXJOMUxwcGx1cDhlanc3SjEyY0F4QWF2RUhU?=
 =?utf-8?B?RWRIOUpFbjhlNTExcjBuaXZ6dU5oS0JDTjZkOWFHTUtVdXo2N0RHNFZPaEx6?=
 =?utf-8?B?bkZqaGpkbWVUT0RFYVl0VEhTSUJ2NXZ4WXNKMFJDUVpYaldxNVJNalZqbk5L?=
 =?utf-8?B?RXdDZ2N6TjFsVXBWZ3dOVWRIWWlYSW9QM0grRTVKd2FaTVd1VjRFaWV0UlRC?=
 =?utf-8?B?b0s5cjFJWnEyNVRFbkN3WG84TFBkNmtmQXR5Y0VrM2RsZ3lxZXZJSEJGd2p2?=
 =?utf-8?B?eUEyWXBLWE4zZkV4eUpaeVJLZkREWlVFQkpIL2M4MW82bUhSakxTbGJpZERG?=
 =?utf-8?B?MGJ4eHdWWFdNbVNRS3d3MUpzNzltMUY5cExRWFFWKzk2RjNWS2xhTkVPRHNT?=
 =?utf-8?B?enROOWNTRXphZHAzU3VoRTcyWUwrQlVKSWEwTlpRanJVMktoQUM5MEVPb0xu?=
 =?utf-8?B?M3ZFRlJ3aVFBVW84ZEJRUkFsdGVldVA4K2FLbGI3WjloR05mYUNKVjk4TTJj?=
 =?utf-8?B?UWhZWDA2VG50b3JFMFM0TWdBN29QTVBjUTFYUXlUS3lLb3dmeWR5cHliVDRM?=
 =?utf-8?Q?BYMIHldmzFHMMMTw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3F3487A6D6215F44A37CFEC884142D9F@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: QxiVxjkbLBhz53m10ucEFZIJnYQfF848QnQgB60u53ZUs0YScExCgGanzFtb9vfz/5ZbT/PTIF29GrV6mr9bInEyCsTFH6wi8wg1Pom5TaaDDGrV8rYMtCO7fL0ztKcxsdOurrxpy0eEBustzlgdm2RBZuFIkLbcS+0u6XefHeG48nEhrjq7XDlLVPcUtyEXjRHYpJXC6ejeTEwidj5Ux+mfSj7Kc+v+YVc/+TK0haA7Y2nnYzYIRIWVlmNYmLIjKXkbr+GBh9VkXRVdy7YMCb3MFpoahciBUQKCiMheYIRlejHW/kfLDQKR/fbsrkRVyF0DjAHg2GUpdxUTct6ymw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fcce3c4-50b3-4e2d-e3de-08dea0441b8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2026 07:52:31.3555
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L3ya0cEefSNJWDNgxHat3SJ5j4Q9UFlGDRcAPrE0Jk0B60hDGCKtpxxcFBOgqH1oGJhzQiHcyt6nosvlzpzDGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR03MB8173
X-MTK: N

T24gVHVlLCAyMDI2LTA0LTIxIGF0IDEyOjM3IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IEhpIFBldGVyLA0KPiANCj4gQXJlIHdlIHBlcmhhcHMgZWFjaCBpbnRlcnByZXRpbmcgdGhl
IFVGU0hDSSBzdGFuZGFyZCBpbiBhIGRpZmZlcmVudA0KPiB3YXk/DQo+IE15IHVuZGVyc3RhbmRp
bmcgaXMgdGhhdCB0aGUgVUZTSENJIGNvbW1hbmQgZmxvdyBpcyBhcyBmb2xsb3dzOg0KPiAqIEZp
cnN0LCBVSUNDTURBUkcxLCBVSUNDTURBUkcyIGFuZCBVSUNDTURBUkczIGFyZSB3cml0dGVuIGJ5
IHRoZQ0KPiBob3N0Lg0KPiAqIE5leHQsIFVJQ0NNRCBpcyB3cml0dGVuIGJ5IHRoZSBob3N0LiBU
aGlzIGNhdXNlcyB0aGUgaG9zdA0KPiBjb250cm9sbGVyDQo+IMKgwqAgdG8gZXhlY3V0ZSB0aGUg
VUlDIGNvbW1hbmQuDQo+ICogVXBvbiBjb21wbGV0aW9uIG9mIHRoZSBjb21tYW5kLCB0aGUgaG9z
dCBjb250cm9sbGVyIHVwZGF0ZXMgdGhlDQo+IGxvd2VzdA0KPiDCoMKgIGJ5dGUgb2YgVUlDQ01E
QVJHMi4gVUlDQ01EQVJHMyBpcyBvbmx5IHVwZGF0ZWQgYWZ0ZXIgZXhlY3V0aW9uIG9mDQo+IHRo
ZQ0KPiDCoMKgIGZvbGxvd2luZyBjb21tYW5kcyBoYXMgZmluaXNoZWQ6IERNRV9HRVQsIERNRV9T
RVQsIERNRV9QRUVSX0dFVA0KPiBhbmQNCj4gwqDCoCBETUVfUEVFUl9TRVQuDQo+IA0KPiBUaGFu
a3MsDQo+IA0KPiBCYXJ0Lg0KDQpIaSBCYXJ0LA0KDQpZZXMsIHlvdSBhcmUgcmlnaHQhIEluIGdl
bmVyYWwgY2FzZXMsIHRoaXMgaXMgdHJ1ZS4NCkJ1dCBmb3Igc29tZSBlcnJvciBjYXNlcywgd2Ug
bmVlZCB0aGlzIHRyYWNlIGRlYnVnIGxvZyB0byBjaGVjaw0KaWYgdGhlIGhhcmR3YXJlIGlzIHdv
cmtpbmcgYXMgdGhlIHNvZnR3YXJlIGV4cGVjdHMuDQpNYXliZSB0aGUgaGFyZHdhcmUgaXMgc3R1
Y2sgb3Igc29tZXRoaW5nIGxpa2UgdGhhdC4NClRoZXJlZm9yZSwgd2Ugc3RpbGwgbmVlZCB0byBy
ZWFkIHRoZSByZWdpc3RlciB2YWx1ZXMgZnJvbSANCnRoZSBoYXJkd2FyZS4NCg0KVGhhbmtzDQpQ
ZXRlcg0K
