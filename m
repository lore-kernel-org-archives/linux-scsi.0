Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE6631A06F
	for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2025 11:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755518219; cv=fail; b=FdnNXPvz+7fpgZDbvb6kT2VHyqgeG4bEvyEiNdiJKFkMbaWRbhInWKvR+qJpZkeKIuJSUb+ycqhi1Z+qQpsVYC0l2GaRPbw77607aOSIze9ZtukY7lTkET/khbl5AnXbfPShaHweBaZVJ1gm9hH04GFLnF1beX7LbeDHW14jbdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755518219; c=relaxed/simple;
	bh=/3l2qxhB4snoh6Mly6hbRFYXfr08St45FGxTbaLYGPE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nH7u8WlRmJUV1CPZBrD1MVrXCGOW1w4IhZ6T8MICYePVZMBZG1DlHmwIlvNrFrc+G6VtZPKkSb3Zo+PnfVDZ8x4w9AKaK4cxSYdnbIHDWkntAwu93ZNBgk/aW4/Xbsu0yBrdk28j2PLpKxOFM9dh400SST5S60BD+I7l9bIKXVs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=I3afZ6vx; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=jsYP9MjL; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="I3afZ6vx";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="jsYP9MjL"
X-UUID: 6ddd03507c2a11f0b33aeb1e7f16c2b6-20250818
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=/3l2qxhB4snoh6Mly6hbRFYXfr08St45FGxTbaLYGPE=;
	b=I3afZ6vxHHkZVJukisk1jkuNqjAfUGZ4K2hbAeHQz4/CqJhPHfThQtAE84AEP+lHz3MWbjA0dwzNpWVjxXmufovUv6CbtX5mIW6td1pteU3yDQvxivYl1w8+MgqtTKhXklG+LDDKhacSCMEXMFogmnsoU2+rh8/3gU0AdejwWQU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:43074eb2-bb81-4450-bade-da9a1ea1e631,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:f1326cf,CLOUDID:c1909844-18c5-4075-a135-4c0afe29f9d6,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:-5,Conten
	t:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6ddd03507c2a11f0b33aeb1e7f16c2b6-20250818
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 641660822; Mon, 18 Aug 2025 19:56:52 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 18 Aug 2025 19:56:50 +0800
Received: from OS8PR02CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 18 Aug 2025 19:56:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mnlp7hmHCQgWs2GjrqRfAqhOuz36PKOGl3wCi5SIa/6QfmuJCr57qb0zdTD4wyUdtmoijcJwXAZ9e5UZOlQmdIn6WIDLi2vwZMSO5RLwjNKIpXbi0vCXjNImRSL0AOO+qnNlnkSDE/vYbiVzY2o9GBSXqPK56Yjvjr9kA2N7zAf4RUFG2yQ3vSWneEam0L77qy27GlJ0am7rFwrTirTZMAXd+ClLf3oghvmPeP499+xhYwiHIjCUpugkgNCFBMXbQAXLfVnIZl6wd9oyEXbOjw4vMaZZ0kUN6elknL5U8wmnnxZ1NvQsk67rRRKwUv2w6Xmb8ZE2OZ4Ve56p9qO5fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/3l2qxhB4snoh6Mly6hbRFYXfr08St45FGxTbaLYGPE=;
 b=dFbJoXBrnvoVZ0ThgybObcC9uke09ah21Hn4Fjz1oJJysf7zcR4zs50vtMyYrBaSuvX1ePEa69woj04oqVo93ogWsXEYYm5rWV6dWlw0KIureGbRfafDVK4u0WV3EZRfhtUiyD0b3iJmspAi5OaKrqtk1yljr+tOZUaNN+yUuIyQVPSx+eqzvQHXYePMrSB2IcNzeGN9NGuJB1IoFbKIlIMMQPKnPUyD8HTKf39I+YnKoR/neWp9Vwl32aq/2M5y9ekk9HiFOYEkeR7yH3LunaCpP3R/rdwhzhHI5pkfUoHs4QZAb/UWLftHFi7sKaNlcFYEAw/mMAYjRY2YeWDzDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/3l2qxhB4snoh6Mly6hbRFYXfr08St45FGxTbaLYGPE=;
 b=jsYP9MjLermu/GploaZCdu7hPrHJw328XewmKf//kqwfbriHe9diAso9f3oeePKcJnv2vyLhWpIbCpqAf7is/LK/1STcEXktlB6ZkmuU7KMbXcn6UgLU77+XNR1DCKInh+5JOHD9yfrh7Ts2iRIAZf9vRZJnd4mTEEjV5eyQKt0=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB8742.apcprd03.prod.outlook.com (2603:1096:101:204::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 11:56:48 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 11:56:48 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "cang@codeaurora.org"
	<cang@codeaurora.org>, "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"daejun7.park@samsung.com" <daejun7.park@samsung.com>,
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"avri.altman@sandisk.com" <avri.altman@sandisk.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] ufs: core: Only collect timestamps if the monitoring
 functionality is enabled
Thread-Topic: [PATCH] ufs: core: Only collect timestamps if the monitoring
 functionality is enabled
Thread-Index: AQHcDf3ZM0Q56wd6EkKDr8i/XP8dMrRoUl4A
Date: Mon, 18 Aug 2025 11:56:48 +0000
Message-ID: <f54ba94ebb1108bfe6faf2aca7d15e69b0b4a4c4.camel@mediatek.com>
References: <20250815160049.473550-1-bvanassche@acm.org>
In-Reply-To: <20250815160049.473550-1-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB8742:EE_
x-ms-office365-filtering-correlation-id: bffac47d-7cc8-4b87-0171-08ddde4e4ff4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dVlKRlFPNDBtOVN6Y0Uvd1dlL3BJWmJWT0dDeGtJelM2YVV5US9DWEYxMU5L?=
 =?utf-8?B?U3g0TE8raGxuY3ZHZmpYNUJNbzliZ0VTNkpQZ2xMbWRna0Y4WHFHcEU5N1FX?=
 =?utf-8?B?aHNaeW10dEFBQjdlRDJCVkpLakNodmJFUzhka043bTl6L0wzU0FtVUdaWHpD?=
 =?utf-8?B?Nm1CRFBKT3F6dUd6dUh3dDBhZzZwOW5sOUp4bExJT1FxTklMSjNyOHhkRS9T?=
 =?utf-8?B?RFhXUEd6QlNwSG03QXpJdGJYdlFKNzEzelUzMWdicVR0YlNJSitPM1ZFQnRV?=
 =?utf-8?B?eVpjK2lqMDNnZ0ZCcFhvNGZEelYwbnF6SlQ4aVVyWE1aeGhVaW5XeE96cmZm?=
 =?utf-8?B?N0RuUEREME5RdDRQVEQxNDh4UHBySW1UMnZyRkFIdjVCTGRrblR3UHhHUzBC?=
 =?utf-8?B?YlFVNXEvUXBCcjB5a3A2Wis5V296aGt6d3UrcWRBSmJ0d3Axb25scmI5Z3dK?=
 =?utf-8?B?NG5ia0hodjFDdTFsdFV3MkN5RUlYT1pzRXVLREJNYzVJM2taYjNRK0NweUF2?=
 =?utf-8?B?cDZqVlBYWGVxQ0ZRd1Myc2UvY2pMSkxSSHJaSnBpY0x3RWJkWFBadER5ejRt?=
 =?utf-8?B?UzVkY0ZmMFlzOE9MZ1Rubkp2MzEyY0ZrNCtUd2hEMWxJbklDVUdUZmZZRmkx?=
 =?utf-8?B?UG1VbkNRWDMzOTliLzJrVkxnK3Zzc0RJZ1p6MmlUMGVvRGVSZk9zb1BkVUd4?=
 =?utf-8?B?ZFFPSVdnZVlkQVFjanpFdnYwUGcxdVVISHo3YzdXUmlJTDRCc01ZTGErVzFo?=
 =?utf-8?B?RW5kOURMT1MxZzQyR04wNm5EbFVNckJaR2RIWnR3V3dHSS9VZXhneXd1RDd3?=
 =?utf-8?B?ZHUyL2xkQmRqV0hlZXJUcU14SnhJSXNGYm9wNHg1UFJpV0JoZmw5TksreVMz?=
 =?utf-8?B?N0c4YXJzNjhTYkdBTjhCNWUyK2NOSGZrQzVmQlZ6V0JHRGwxa2pzUXJEZ0s1?=
 =?utf-8?B?R2lCUU4xckcyQVZrU1pZaXY1L1MrcWpJVWtZdW9QalQvRnhGNW5HZEFmRi8x?=
 =?utf-8?B?S2M3cjc4NktuYVFNKzJPejdMRVFzajdsV2NwWTRJakVsQURROXMwb2lwaGd6?=
 =?utf-8?B?SVNEelZ2ZmdTNjRRK3MyYXdRR2VUcGNycWNHWThPNEloMkRHZXZxeWZOdzhq?=
 =?utf-8?B?QUhMd09xV2laSlc3UEFqc05LcTlRSlE5eEZVMUYvWjJNTFc2dEhYNVpLbkho?=
 =?utf-8?B?Rkg4VmRRNmhyNDlPR1lZWGtPRnNmMWVqYTJLdW9WL3ZNRHhpaW5IOGdwVGY4?=
 =?utf-8?B?cDR3WGxORlIxd25rUVBVZWNwSVFMOS9ZNG9ZN2VON2lBNjczanNMdW93Ympi?=
 =?utf-8?B?WHBWM1dTeWo2RmVkd3hLWi9IUEpZTkpwNForMDJ5R2FUVnVEOTRqKzZzMjdo?=
 =?utf-8?B?dkpGbGZzcUdqRGNBb0pXSm5VNG1jVkh3dUtOOTk1ZFB1YmQ0MkNhLzZZVEtx?=
 =?utf-8?B?MFhuTm9reUZpUVh5TlN3WkQ5N29oaTFFelNYbHMwQkd6YXRpV1JHRjlnZXNj?=
 =?utf-8?B?YSt1azdWL2NuSTdWaWhGWXhWTDhoMWlmS1d0ZjgrOXV3YVZaVEdHMS9CMFBW?=
 =?utf-8?B?d0U4STh0Mzk3ZmI0L095K1ZlZ0hpeWY0MzBiQUs1N3ZhL25HaUM3akFoWnFJ?=
 =?utf-8?B?WDZsSm0xZUxHZm1BOE9lb2V6Tm01T1Q2SlgvdzN6WFNJYTQxblYwa1lmSnpC?=
 =?utf-8?B?cS9Yc2IzOWpUb2twVDJBaGZNU3VzVURydTJtRDRqL1gwejZkWEU3OXRySXR3?=
 =?utf-8?B?OHo4T3VFUENWeUNDa1pSVDROaVJpeVhpTnkvRlpqL05YRU1QMVNFTTdHRzU1?=
 =?utf-8?B?TjZMcWhReFpBdXZhMDdDcHFsSVpPYlJzeGpsVldZR3NiTzhYRTZGMmdBYWJH?=
 =?utf-8?B?bGN4MTMrK2J5SEZnYlE2a3BFbHZOYWZsQjdOdi9ZR3BsTjZ3dnNsMXhvWjBL?=
 =?utf-8?B?dGE3eFBzNEJyeTJlZUs1Tm1SZkZGV1Y2UTRYNlNaSkxVekE0SmxhN3hjeWNj?=
 =?utf-8?B?dlBRRzNpVStBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SzFodU9mNUx0NFNGc043enFkU2RjS2kvSVA3SEdqdlJPcFdVb0x5UW1XRk9o?=
 =?utf-8?B?QW0xazVKVkRZY21TaFNBZ2l5Z0tCYWhHRW9OL2sxb2tmS1p1R1duRkRYc3B4?=
 =?utf-8?B?M252anMrR3BYYm42N2hQUGpBNjVhWG9RbFhsRDMramtOZko3cEdPaHlxemw3?=
 =?utf-8?B?N3Q1aXFhWVdLVkJ6aFlIanhVY1cyL0dHa2Y3WVJicnVIdzZRV085TzV2RXFq?=
 =?utf-8?B?TWZMUFUrZ24rVzdxNVFWMnptaGlFOExsU3lieDRNTW03d2lHNFc5VUFEd0FW?=
 =?utf-8?B?MCtWd3owVXgwM3h5cHhTeUlDTFJtbC9BMWtDbERWbSs0MjFhOW5OcS9FdjJa?=
 =?utf-8?B?S3dQT3pWWmdEU09ocVdxZ0hFTXdNbFJkeW50Q28rUnlhUm1Fa3F3Z1BWemNp?=
 =?utf-8?B?VEhpUmxtUkRvVnFhc3RPRDlLd2lia1pXY1FFRDhNTS9DVTFUbVUveURQVXhS?=
 =?utf-8?B?WG1NaUlkV2J6OG8wOHRaQ0lwNWJ2Ui8zWXJxeXZNeU0vSWtUUDc2dTVBT3g5?=
 =?utf-8?B?RDVidWh1NUNvYlpLYThvamJxeWRsSzZOb0wxVjQ1LzlLdjZCY1lzU2VHeVZN?=
 =?utf-8?B?amZXclQ0R25xZmorNVNmZjE5elduemNieFVUSTN0T0JCam1IZ3o2RDFmd3dj?=
 =?utf-8?B?MUJSYVBncG9Md3N5Ni9DRGNYV09oVDEzZXpEVFM5ajRVcEFKbFZwcGVMNC8r?=
 =?utf-8?B?dXFXRVZ6TWVRbFovOTdTQ201SVVOcGdkWGlLeWNEZ1c3R2dKLytxV253SEVx?=
 =?utf-8?B?L2E5SU1VaFk1ZlFiSWJEN0gvdjB6RElVZTV6QnhNNEUyckJNMHBRbEVhdDhh?=
 =?utf-8?B?MzRobktmd285MlRvenNVSDVPN1hGTEFjSk9NT01BQjlIZlI2WWpMNE1RdWs1?=
 =?utf-8?B?NkFUUDBNZnRiVDRUeFU4Tjd3NHBrdHN6UnlZdk1Hc1hmREE2UWNyWlgzakRE?=
 =?utf-8?B?ZzVDd1RtM2p5c1E3SFNleU91eVEwU2JPa1BqK2VxbWI0MmkvNkpJUTRUR1Iz?=
 =?utf-8?B?alBhSTBJc2tDRFJKVThUa2tXN3lxWXNYZzBUdnVyWFhQa2o0ek00M2xhUUZI?=
 =?utf-8?B?Q3BSU0pzYm4wUk15aStuR3pOeGxod3pLUWltdGZodUdlZ2hIc3JQbHlFS0kv?=
 =?utf-8?B?d2VOR0Vibzg1RHlQNW5VdnZsMmdOR0ZRRmNVTDVGa2NkcExWQ0FqYVhCMGk5?=
 =?utf-8?B?OW03SnB5U1EzTWNkZjdyYlh0Z0hwaFhoSERpbEpFc1JlZ0RnV1d1N3JPdzVr?=
 =?utf-8?B?QzAvVkdPdWlyVC9sZ1MwbGlvVk16d3JiMGhST2tDQ0d1SXBMcVR6amtyamV3?=
 =?utf-8?B?QWtOUmVLcTZhTEpWdmd2SktiY2JRZWNOaUlpa2VpNjhhQ0lxVExNMDB4cXY4?=
 =?utf-8?B?SU5HbjZBR1ZhVk5Gazh3VTZzL0hJR1QzNVZtcHlhdVZoSVVMMEI2WnZ6SUpm?=
 =?utf-8?B?Rnp6cnhXYlpDdXdTUGw1MEhBRUd3UTNpbzVJVGVabm5HclNDbUdwOXpjR044?=
 =?utf-8?B?ODRvb2w3cFlhL21LeWNveEh2MlVURFlXZXRhbkdqd09KZXl0N1pZMVBEZzUy?=
 =?utf-8?B?cWtoajF6bUF0TytuMlR1SHBVMVo0V2ROZXQ4cU84cGpNbWVVaUlNbFB5WEgy?=
 =?utf-8?B?cFFPR3QrQ3Q1ZXUvSER2a2Y2a3BFbmJUMndBd0NPNkdWbTJFazNCQVB4aTFl?=
 =?utf-8?B?SGJXU3ZjOWUyOUlrQzZSVUZmeTBZWnV3T1lFeUFvb2FrNXpBV0lYSXpUQjU4?=
 =?utf-8?B?Sk16UUFIWE1uc0hYeEl4b1FUSzJhSGU0MmNsaTZmSUlUQ2x5YWxKcWl6QlJC?=
 =?utf-8?B?Rk5pd3NJVkF5MmhYcHhKMTUzVG1HSG94aHk4TUxkNWY2S09KQ0o1T05aVzV2?=
 =?utf-8?B?a2dEamhqdFJkakgwRW0zdXV2bGdqcU1mL0NIdU0rVTg1bFMxNWRYcFBqcTV4?=
 =?utf-8?B?RXozVm01ME13VnNSeHJFNjltNDNLU3lFeXZsOVlkRXRxUUtPWWhFbWdNSEdP?=
 =?utf-8?B?WEkxRVlsa3VhanBFWEFycGVhaEdtaFZTd3JPY1E0cjNxS2dSNEgwa1A0U2xR?=
 =?utf-8?B?NXd0a0IwV2tSS2M4ay9DZkFDWnFvOXA0MTZoWk5PR09SVWpKSWQ2ZmZpUlZG?=
 =?utf-8?B?Sk9zRWt2bWJxYnpLZVFLdkZlVGxUYXdaeUQrRUlEZS9hNTJMOEpPdEdDNjJS?=
 =?utf-8?B?Rmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <65A978BBA447344EB7C7DA5C73A36398@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bffac47d-7cc8-4b87-0171-08ddde4e4ff4
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2025 11:56:48.6216
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dh/4Kh9OxDUQR+HQWrn7jWyhhFmZZRM1VZZHN+Hm4YceleQ7Y1WrAFgK86ciR1SJJWviJA5LiqImKvDTLR301g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB8742

T24gRnJpLCAyMDI1LTA4LTE1IGF0IDA5OjAwIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
Cj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgYi9kcml2ZXJzL3Vm
cy9jb3JlL3Vmc2hjZC5jCj4gaW5kZXggNzE0ZDk5NjY0MzFlLi4wMjdkYzAzNTVhZTYgMTAwNjQ0
Cj4gLS0tIGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYwo+ICsrKyBiL2RyaXZlcnMvdWZzL2Nv
cmUvdWZzaGNkLmMKPiBAQCAtMjM1NywxMCArMjM1NywxMiBAQCB2b2lkIHVmc2hjZF9zZW5kX2Nv
bW1hbmQoc3RydWN0IHVmc19oYmEgKmhiYSwKPiB1bnNpZ25lZCBpbnQgdGFza190YWcsCj4gwqDC
oMKgwqDCoMKgwqAgc3RydWN0IHVmc2hjZF9scmIgKmxyYnAgPSAmaGJhLT5scmJbdGFza190YWdd
Owo+IMKgwqDCoMKgwqDCoMKgIHVuc2lnbmVkIGxvbmcgZmxhZ3M7Cj4gCj4gLcKgwqDCoMKgwqDC
oCBscmJwLT5pc3N1ZV90aW1lX3N0YW1wID0ga3RpbWVfZ2V0KCk7Cj4gLcKgwqDCoMKgwqDCoCBs
cmJwLT5pc3N1ZV90aW1lX3N0YW1wX2xvY2FsX2Nsb2NrID0gbG9jYWxfY2xvY2soKTsKPiAtwqDC
oMKgwqDCoMKgIGxyYnAtPmNvbXBsX3RpbWVfc3RhbXAgPSBrdGltZV9zZXQoMCwgMCk7Cj4gLcKg
wqDCoMKgwqDCoCBscmJwLT5jb21wbF90aW1lX3N0YW1wX2xvY2FsX2Nsb2NrID0gMDsKPiArwqDC
oMKgwqDCoMKgIGlmIChoYmEtPm1vbml0b3IuZW5hYmxlZCkgewo+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGxyYnAtPmlzc3VlX3RpbWVfc3RhbXAgPSBrdGltZV9nZXQoKTsKPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBscmJwLT5pc3N1ZV90aW1lX3N0YW1wX2xvY2FsX2Ns
b2NrID0gbG9jYWxfY2xvY2soKTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBscmJw
LT5jb21wbF90aW1lX3N0YW1wID0ga3RpbWVfc2V0KDAsIDApOwo+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGxyYnAtPmNvbXBsX3RpbWVfc3RhbXBfbG9jYWxfY2xvY2sgPSAwOwo+ICvC
oMKgwqDCoMKgwqAgfQo+IMKgwqDCoMKgwqDCoMKgIHVmc2hjZF9hZGRfY29tbWFuZF90cmFjZSho
YmEsIHRhc2tfdGFnLCBVRlNfQ01EX1NFTkQpOwo+IMKgwqDCoMKgwqDCoMKgIGlmIChscmJwLT5j
bWQpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHVmc2hjZF9jbGtfc2NhbGluZ19z
dGFydF9idXN5KGhiYSk7Cj4gQEAgLTU2MjIsOCArNTYyNCwxMCBAQCB2b2lkIHVmc2hjZF9jb21w
bF9vbmVfY3FlKHN0cnVjdCB1ZnNfaGJhICpoYmEsCj4gaW50IHRhc2tfdGFnLAo+IMKgwqDCoMKg
wqDCoMKgIGVudW0gdXRwX29jcyBvY3M7Cj4gCj4gwqDCoMKgwqDCoMKgwqAgbHJicCA9ICZoYmEt
PmxyYlt0YXNrX3RhZ107Cj4gLcKgwqDCoMKgwqDCoCBscmJwLT5jb21wbF90aW1lX3N0YW1wID0g
a3RpbWVfZ2V0KCk7Cj4gLcKgwqDCoMKgwqDCoCBscmJwLT5jb21wbF90aW1lX3N0YW1wX2xvY2Fs
X2Nsb2NrID0gbG9jYWxfY2xvY2soKTsKPiArwqDCoMKgwqDCoMKgIGlmIChoYmEtPm1vbml0b3Iu
ZW5hYmxlZCkgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGxyYnAtPmNvbXBsX3Rp
bWVfc3RhbXAgPSBrdGltZV9nZXQoKTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBs
cmJwLT5jb21wbF90aW1lX3N0YW1wX2xvY2FsX2Nsb2NrID0gbG9jYWxfY2xvY2soKTsKPiArwqDC
oMKgwqDCoMKgIH0KPiDCoMKgwqDCoMKgwqDCoCBjbWQgPSBscmJwLT5jbWQ7Cj4gwqDCoMKgwqDC
oMKgwqAgaWYgKGNtZCkgewo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAodW5s
aWtlbHkodWZzaGNkX3Nob3VsZF9pbmZvcm1fbW9uaXRvcihoYmEsCj4gbHJicCkpKQoKSGkgQmFy
dCwKClNob3VsZCB0aGlzIGluZm9ybWF0aW9uIGFsc28gYmUgcHJvdmlkZWQgdG8gCnVmc2hjZF9w
cmludF90ciBmb3IgZGVidWdnaW5nIHB1cnBvc2VzPwoKVGhhbmtzClBldGVyCgoK
