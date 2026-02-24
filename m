Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AA3168BD
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2026 05:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771910987; cv=fail; b=sM/GUvwUYFmaLvxst6FIZmYtA5vCjfMjv8D8af5aBM9dwCVx1XSEAAoFd6zdndpIlJFSIEHzlj54w7blQJqUrMOunXnFlcPk4VFMQl/TFKQvR03ZGuTkZusxrp4I5e8+I/8GlZWzhTJbiHqB6eDGI50J884if+gBgs7Y+2zTQ0w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771910987; c=relaxed/simple;
	bh=Gofza8qNvKdUx/Zc6aaWh7QvTVAGvN+fLymDr99Y1iU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fKsIY3HeCq9le3/IKFcoSm1k6XlyW5A7wzAc2s6JWV1t7tVD9SUI7P0QHByvHIExha8Ep2ucLoEwu/+rOn4+Tdq3s/fp/Rn89SBPpFulcyWSRkmkOa8p3C5GBjuaobebPy5ZzeaRHJqnWIuxvCWKjyD4JvXvIDsrKqodcsFGMOk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=BxnJG5h3; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=GTXBkFTl; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="BxnJG5h3";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="GTXBkFTl"
X-UUID: d1bb2d46114111f1b7fc4fdb8733b2bc-20260224
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Gofza8qNvKdUx/Zc6aaWh7QvTVAGvN+fLymDr99Y1iU=;
	b=BxnJG5h3FrwVhMYsC8Ya5H0AK7M/4yGq7oYRlYQghdHYvjo3nRjr7ZPM6hMsyGsLc8bnfFJHXij6JG/ovC2Q7wLdIpv99S3w8RqrztTtEwR6hyp+JmSdhn6XOy8uy3LpRY0sPBisMfi24/Hz1oLuCs+gZNsky5KJ0lWtiy4qpj8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:b6118daf-7451-4700-830a-eb7413bc4abd,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:512cece9-ef90-4382-9c6f-55f2a0689a6b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d1bb2d46114111f1b7fc4fdb8733b2bc-20260224
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 72127015; Tue, 24 Feb 2026 13:29:41 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 24 Feb 2026 13:29:40 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 24 Feb 2026 13:29:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YD7Vw2+1+f5W+uPHm6YoLnaQt9mt66MMou7BEnX651jETJPFI3f9B0eLG5NQSq1uyJjqGqEnFScufQDk8zoUpc5Ys9/HfcFjACgMYD33z2twZtNMPob8rAbggElbve6OaaTWxFFLvjOe4Cf0bZ1hMpc3wIx2e/B4UcLk57gMflttbnuO0piTcRq9FUdQOeKVMGew4wv8PIT3CXITwkkRroN2B6tC8eMQ1X3kIyW5cOmIKgDA0Y1t3rosEn83QWg6a7c2wYJoEYxYFLyntMUQpKLoiYHAXYM+bVPTvsuubJi2gyEnMGJcIJW4+bB/AGQNKNpLzWGzrhpNO0n7Tu2ymg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gofza8qNvKdUx/Zc6aaWh7QvTVAGvN+fLymDr99Y1iU=;
 b=D0I+YCdkl7GUQx2cBnYiRGgx1noBjbDJKk1t6gTKoSEfA8T8xKPBtW0QdkF3NMW913tntZJtV0IIvLxrbIV5R56i9cTvk8y5VI8P3iNeV4G87H/xCFCMayTgU9F9xvo3YXH98JmFhwRum8N5f1fpgWstuQOGiRh9kd1n1jb7pQkgYFJvkufQu+Dc4anNQviG1atgcU8acmQirOPaNfRpfXH79zupXlUqSQcIH/fgoH5jfESIRxYyB/JA8Sqe0e1OgbJlu2RYtE7FerICtqPMCrFN4XSSQ28DZe6iyGbiAm4+kaNIm/DDppRE3Yxlc5GRVAK96vdFlsfgd/joonL7bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gofza8qNvKdUx/Zc6aaWh7QvTVAGvN+fLymDr99Y1iU=;
 b=GTXBkFTl1OhDXo4j7OmmjJjfhxGTLSjXfvQjC49ZEGw5JsIH2RacHxjnCrE9186ePrWrueXjppcArUYr9tXoqBQU/wKTQy1aJFGjPZV1egwanF4MoYgaZ1U0Bkz0E0g7eYw89EKr2NF2ZoHGVqtMA5F8pRcsrUaF+DSQxRQegn0=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB6763.apcprd03.prod.outlook.com (2603:1096:101:66::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Tue, 24 Feb
 2026 05:29:34 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 05:29:34 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "avri.altman@sandisk.com"
	<avri.altman@sandisk.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: Fix possible NULL pointer dereference in
 ufshcd_add_command_trace()
Thread-Topic: [PATCH v1] ufs: core: Fix possible NULL pointer dereference in
 ufshcd_add_command_trace()
Thread-Index: AQHcpJGdyX5pkVn0gEmR1tR/eLThzbWQhk2AgADNrIA=
Date: Tue, 24 Feb 2026 05:29:34 +0000
Message-ID: <399765bade9b7adcca89a94313e71635d1336172.camel@mediatek.com>
References: <20260223065657.2432447-1-peter.wang@mediatek.com>
	 <5017b907-16de-4d7f-a7c6-dbc504ffd1eb@acm.org>
In-Reply-To: <5017b907-16de-4d7f-a7c6-dbc504ffd1eb@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB6763:EE_
x-ms-office365-filtering-correlation-id: 796119e8-7a2b-46c5-943d-08de7365b197
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?aWNKaUxncnJrRzRxQW1ONnFqTlFCMEdyVGhSZ3FlMWtUOC9UaGxUSUtmNHIz?=
 =?utf-8?B?R3ArWGFUOUhreC8ya3JFRFZ2VktNaTBBMFZmRmpWK29DbnRQUVRQWEJUUDhG?=
 =?utf-8?B?N3hkTTJHejF3djJTS1FKMDlOVzVpV0FHSUNmaEN2UzRmVjdIMUVJVEdTUUxm?=
 =?utf-8?B?N2IvaXl1V1Y2amxlQ3AwRnYxb3hua0xkQ0Y0ekp2SHBRSHdNejN3NmxvTkww?=
 =?utf-8?B?UWx2VnhRd0NmYnExZzdDbUJrZFA2QUFaMFFLY21SNk1TZVg5WkM2VDhCT1FW?=
 =?utf-8?B?NlZxV0VTM1FDVDAvRUh4U2htWVNVVHdxM21qVlRzR1RLYmFPT0tHUEZiNEls?=
 =?utf-8?B?MnBLT1k0eWNKL0RFSU9BY1lVSk9ZMVB6V0YvTzFadDArNUVmaE8yWFROZ3hl?=
 =?utf-8?B?WVN5cFVSdFIvZ1pqK2xxWDRhQWc0MDB3K1U1TlphR3dLdnVWQzN3Nis1WGZJ?=
 =?utf-8?B?cDRGbHBaTWJPQmE4MEhpQkxYalFzRVE5cGMwS1pjeENJZjdLdVE3S2JIT0pt?=
 =?utf-8?B?Z0hoRGNlNzJ0bWhjOHd4QndyU3IybFVvMmcxZlEwc0U2Y1lVci9xUTJNejFS?=
 =?utf-8?B?dUZzSHRhMmVLaVRzSVE3cVkvWmRrMzJuRWpUYm1GSkR3aXBubVZERmdrODFT?=
 =?utf-8?B?V0dlZ3Z6TjVuNzdreUNnc0VzWDBFa05RTW1jVDE2WUhhTEtLRDNSQXRpUE9V?=
 =?utf-8?B?RjAvTmJxVUZRZGZlaVhhQkZTektiRFoxbE1hclo3WEdJdXY4MWU4QWlDMTlv?=
 =?utf-8?B?OU0xQU4wRVZVMmE3WUlHckRUUHAxcmtOTGNLeTIzU2hyVmN0RUZnMGZWVFZD?=
 =?utf-8?B?bndQV2dEaXRUTC90LzljTy9CT3l5R0lsRHdyb2gzTmNxMU85cHR0RW00QktG?=
 =?utf-8?B?dHpTTWo0TTBHZHV1RlZzdTdzTldFTGd3K1VvK2F3YlZZMUxqZHBRS05XOHl0?=
 =?utf-8?B?Um9GYmwzU21WblpJdXJDNTluempVcFl2UnhlcGt0b0czbkpkYThOREgvTDJr?=
 =?utf-8?B?Y0hLSERnM1ZtQ2RTcUNzOVQvOHBWN2VBUFdWcmVaSCs2bC9HMWRKcDVWSGVq?=
 =?utf-8?B?Q2ZXLytvcmVwWWVla2svbDJvRlB5SjFBYy9STU53UTRHQTlvejUrc0pQY1JY?=
 =?utf-8?B?MlU3U010LzRPZVNZS0lCZWhhejlodUJOaU5XYUw1SWpuZndXcEV2YWo4YjFD?=
 =?utf-8?B?TEhTczJyVU9CUm5qbmx0cUdNTm9FQ2xYemlSVldtNzJITXA0T0pYVU5BemF0?=
 =?utf-8?B?MGFheHBLUThaaEVzWDZvbkV1OXdIYWdYYXpMUUVESGhNdnIvUmFYWFdSeFov?=
 =?utf-8?B?QlFWMkpnSnhUUUFMVUt1ekhKNndTRkNrVHdqSjBRK1c1ckQzU3FtM1pvZVI2?=
 =?utf-8?B?V0VpSVYrZXVnc0ZLMnJ3MVJRVzQ4SlRXazk1clFjTXpoWkpOTDZxT1pSQkVq?=
 =?utf-8?B?T3VDQ0FSeHlta3FVMUx1a09hY2Zvdkw0TjB0Q0FZOUlGNXdFUHlHSW4yTTND?=
 =?utf-8?B?dXJBQkFGK1lhY2dSYlhDOFF4NmxzRUVyQ05qU0FOYUZzTERXUmI2UUhuWjBs?=
 =?utf-8?B?VFA0bE94TjFEWXFkaTVJNWhCUHFUN2lNZHFVcGEzQlVUQmVpelhPK2FHT1Bt?=
 =?utf-8?B?eW1tTlBITGs5Rk95VCtpWXZ5c2NlZE5BYU4vYWM2b0NjeGd6R1l5VTJqczlO?=
 =?utf-8?B?aUNmbll5Zm1iSmdGWTRScFZSMUlzUUgzc1NuV1BoVEVCTmxqaWNUaFhwaEZ5?=
 =?utf-8?B?ZkFKWnEwbUpGZ0ZxbDgwTGVqK2g4bUVyWTRxR0d4b0pkbmZDc1RPSTJmNW9s?=
 =?utf-8?B?OU9rU1RCVFg2ejVKWUU1VTRNK1ZUMlBzc3g4WDhXRjMrZVEvWmo3eWxOOVhV?=
 =?utf-8?B?N1NmMEhTRElxWFcrZGZIcTZaOFFGcWYxdCtWTndlV2ppUndhOUZwOSs3eXdh?=
 =?utf-8?B?YVJEQkphdnJEazNhdTJCb0trMm85TmZVT0k2aDdKUk5SdjVZcnJIL1RScmhB?=
 =?utf-8?B?Zy9VSVBNWnBwQzl3ZHl6dC9IWktPMFpsc0xvdlRyendnaEE2RUNWWndnRjBX?=
 =?utf-8?B?eS9ZV29TRkFyZVFPSmFXSy9iOGt3aW5OaVpocDJ5Q3RlNHdwM0M1R2JCUkln?=
 =?utf-8?B?VGRpYnRSQWp0S09BOS9SVnRxa24zRWxKcVZ4N3hHWFVkbzJFWlgrcU5zaHR2?=
 =?utf-8?Q?741YT+TmvNNnkgW1dCsVkr4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OHZrRGpONjhYQmE3QTRpemg5YUdDVWFXWkJWMjJocmRPV3JFK0o2SWtSSXMv?=
 =?utf-8?B?RS8yMjU5Qmh1Qkc3Ukp2dzMwKytDVU96TXFFODhZZGNlZSswVmwxNm10eHY1?=
 =?utf-8?B?dkI5aGhDWVVGYWxoN3JORndzejdtblBidHZZQWdlOXJzM3R0L2NqbURMak5x?=
 =?utf-8?B?NU5EcXVwOXhJMTdRRFVOa0dMMU1ZcVlXZSswMHpJazN2R0d0Qk9wNzFLVkpU?=
 =?utf-8?B?bERMVG55M2VDc0hMeGFTT3dzTWMrYlVpUTEvMWVvd3E2cVRJVHI4Y0JMS0Yz?=
 =?utf-8?B?N3h5WkR3RitUcWJVZ3RYZGRjRkJKa1pVSkVSY0dYalluR0FiTEZsbk1kOTRF?=
 =?utf-8?B?R25vYUh3VlVlZjJiOFJzR1hrRmtya3FLNlYwNFIxUVpuWHRTbFJ3TjRsVlln?=
 =?utf-8?B?V1RNZGY1d3M3b2JRVzJHcy9Qc3ozcDNWTHdJQWkyOEViM3JuY1k0d1NsZHZ1?=
 =?utf-8?B?enNPa3IwSmhob3l5TW1rcUg0ODFVQ0d2M1NZT3FIVDBUWG4zVm9IOEd0UmVv?=
 =?utf-8?B?WUNZRXlId3ZuTkJ0TUIwb3UyclRPVUVtWGNwZmpjek1QcGRnejk1Ni9GTW12?=
 =?utf-8?B?WFVJK05RMUVSR1RTRWkyVUtxcEt5QXgyRkJwbUpnSHZmbkoxSFRUNGhXNndD?=
 =?utf-8?B?SG1tenUyWEtZTUFSZGtuUC8wNHlYUER1Ym1LNzR3UXFJSGdTYmVtWlkzMyt3?=
 =?utf-8?B?b0FDclBuYVdDUnJtMXQyMDBrcWZwamE1WE1scmwwbmlJSC9ISHFWYUdjQjZx?=
 =?utf-8?B?UmpWayt0VWNPc29zQ3ZWZnc1MmE2ajdJWk05WFpzaDA5WmJweVh6enpJWFRi?=
 =?utf-8?B?MlJDTWRiS1MyWUFCc0NiWkdyYmFvcmFYY05YajZTYmVORlVuMG02ZGJYbGNz?=
 =?utf-8?B?MkxZTDBVNlVPL1VHdU9zRU84bktJSlgzM3RWb3ZGY1JOQVNaZ0RUYWtmRkdh?=
 =?utf-8?B?NENUdE9QY1FNTmx4RTFjSkozVm1CM0pkcXUzWUNqMlFxRmVodkRLd2xyNk5H?=
 =?utf-8?B?TEk3UVFoM2NOdFYwMmhhdDk0VnZwNy8vZytYSDBMcjN3KzczLy84aXlsbGEw?=
 =?utf-8?B?dXo0OHNVY2J0S2lGVDN1Wkt3Wmh1T1ZuV3FjZC94bWNCV2ZDUXJWdnRFZGk0?=
 =?utf-8?B?azV6WmcwNElSTXYwSmppWnR3YTkvWWlVOVdYL2dyempxUnZ4ZXNpUjZmYlRG?=
 =?utf-8?B?UlhWTUdXRWhNTXlNMEVsVFZIcWp0bzRxeW9qSmNyLzd0MGtkUjgrSDcxNGw3?=
 =?utf-8?B?WTVkc2RwR28xbDFJVGZHWW0zN0ttaDVhL3V1VkVhcU1xU3UySXBtdGNvZWpi?=
 =?utf-8?B?VGNrZ2R6RkpMQTZ4V0FFejRONmltdFlaWUlVY1RFMWJIa2RZa1A3RllNeUlu?=
 =?utf-8?B?WFRIakJNR004c1U3RG55NzZRZFBtOFRrdlpSWVJCTS9BckcxRWJETldjZllZ?=
 =?utf-8?B?OW0wRXVpRHFQRHVWZExsSEtXOFZUWEp1TTRmUXFucDJ6QlpPZUZKUTlGNGJY?=
 =?utf-8?B?L29NZWZIZ2lFMGQwa2hYZEdBaWVqMmNPMnZ6bXgvenUyT2I4TXgrR1RwL3pJ?=
 =?utf-8?B?RlhqNXhOdURnQWRhczh6azNZdnZ4Ni9wVlZFN3l2QjJIaXRGQlB1dWVYeHlZ?=
 =?utf-8?B?QkFWZi81ekFpOWsxV29MVVVqQVArZkJMTHo5OUZnOEFFN1lxM2psUmxGUVRL?=
 =?utf-8?B?SEQ2Y0JJYWtQVzljT1ZBZ01FbGJDNGdwTTdIRTh3WWRrZHNhTVVDRitBdmh4?=
 =?utf-8?B?TGRiQ0F6S2ozeDVXaHhKKzRSanNEY21WRktIQ2Zvc2tPRjRYU0Q4My82MVJo?=
 =?utf-8?B?MmxrV1B5cEpyRzBFUFB0TDZoU3dMUHAvTm9Ibkp6ZFJaSHdJeVo2SVVFcWNM?=
 =?utf-8?B?YXZqTnRuWTBIKzB4ckZiRy9heWNtQnZhMGREMEZlV0I3YVo5aG0ySk5DYTdV?=
 =?utf-8?B?MUZ3WWx1c0ZIK1cvVDcwaURiaHhyOWNaMDQ1eDRyUDFlOGNLZWh0bDU5UGdU?=
 =?utf-8?B?T0tYcUg0Z1hnbWxiVjVWcGhydnB2SEM3OXMzU0p2TFNvemVNZk9ZWnh0Z09x?=
 =?utf-8?B?dzF5NUovWEMrUVVRVHhrNDM0KzNreGFDc040NjVpc0Fwa1NqU2hYVGs2ODVj?=
 =?utf-8?B?UXl4ZkIzMHhyM1lseEtMcFdrSlE4clhMSUFLT3htS2hBNGNEbGdGUXdqVllx?=
 =?utf-8?B?Tk4wU25kZU56VFhrS0p4K1MveThlTjE5UkVvTTl6VjBkTWZWYUxNTG9wVll3?=
 =?utf-8?B?a3VMUkx6c3pQeVVUa1V1UU15bTEvQXJnbmdoQjVpZUlwODRkeFhXdlJrdnlC?=
 =?utf-8?B?Znhncm5DTVlTY2t0Vm9mZWY3SXRXSjZiOHRvTC85YTAvV3NwOFRRSzZXanZH?=
 =?utf-8?Q?AT1r0JMLqptJLqI8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2BE199776FB6564E963E17C6372FECC5@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 796119e8-7a2b-46c5-943d-08de7365b197
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2026 05:29:34.1224
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PBWNSLl49Z/IDpw/vmSVEOrLdAXzYfQrlxMDD1crYgdMHoelZvFgU/79hiWaD58e73SpKU4lvirBiLnR0og1VA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB6763
X-MTK: N

T24gTW9uLCAyMDI2LTAyLTIzIGF0IDA5OjEzIC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IFRoaXMgd2lsbCBjYXVzZSAiLTEiIHRvIGJlIGFzc2lnbmVkIHRvIGh3cV9pZCBpbnN0ZWFk
IG9mIGEgcXVldWUNCj4gbnVtYmVyDQo+IGlmIGEgcmVxdWVzdCBoYXMgYWxyZWFkeSBiZWVuIGNv
bXBsZXRlZC4gV291bGRuJ3QgaXQgYmUgYmV0dGVyIHRvDQo+IGludHJvZHVjZSBhIG5ldyBoZWxw
ZXIgZnVuY3Rpb24gdGhhdCByZXR1cm5zIFJFQURfT05DRShyZXEtPm1xX2hjdHgpDQo+IC0+cXVl
dWVfbnVtIGluc3RlYWQgb2YgbWFraW5nIHRoZSBhYm92ZSBjaGFuZ2U/DQo+IA0KPiBUaGFua3Ms
DQo+IA0KPiBCYXJ0Lg0KDQpIaSBCYXJ0LA0KDQpUaGUgZGVmYXVsdCB2YWx1ZSBvZiBod3FfaWQg
aXMgMDoNCnUzMiBod3FfaWQgPSAwOw0KDQpBZGRpdGlvbmFsbHksIHNpbmNlIFJFQURfT05DRShy
ZXEtPm1xX2hjdHgpIGNvdWxkIGJlIE5VTEwsDQp1ZnNoY2RfbWNxX3JlcV90b19od3EgYWxyZWFk
eSB0YWtlcyB0aGlzIGludG8gYWNjb3VudCwgYXMgc2hvd24gYmVsb3c6DQoNCnN0cnVjdCB1ZnNf
aHdfcXVldWUgKnVmc2hjZF9tY3FfcmVxX3RvX2h3cShzdHJ1Y3QgdWZzX2hiYSAqaGJhLA0KICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCByZXF1ZXN0ICpy
ZXEpDQp7DQogICAgc3RydWN0IGJsa19tcV9od19jdHggKmhjdHggPSBSRUFEX09OQ0UocmVxLT5t
cV9oY3R4KTsNCg0KICAgIHJldHVybiBoY3R4ID8gJmhiYS0+dWhxW2hjdHgtPnF1ZXVlX251bV0g
OiBOVUxMOw0KfQ0KDQpUaGVyZWZvcmUsIHRoZXJlIGlzIG5vIG5lZWQgdG8gYXNzaWduIGh3cV9p
ZCBzZXBhcmF0ZWx5Lg0KDQpUaGFua3MNClBldGVyDQo=
