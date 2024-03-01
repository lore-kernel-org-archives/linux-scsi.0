Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095BB383A5
	for <linux-scsi@vger.kernel.org>; Fri,  1 Mar 2024 03:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709264870; cv=fail; b=QkE8H6ctQ9OVeucHjJk1i+7gX1Qkr6Vihu3nw3WXUtzi89yJL+DiSm7LUYBxmfMvCz/re1slKY+ZTE0S/X7lncNAb9eLPsI984P6Pn/kN4nQOHqHOu0Q5X7t+a8o5yvbqb+QHYVk2b/K4xdUX1Dvadv8A5HUaGr8xjp1wuVdu0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709264870; c=relaxed/simple;
	bh=0GN7qdpdYevMWCbuXPVo6doK202DBH+cDJwygKCc0yo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GiCYaYajz9XE980bAEOf+/2BQyAuCE3j0OvSlBTrp0ywOtmawOV/dPUU2twLvbWYi6ZDJiKNIFZrDEWKFyu66UJXHP2LlRCeITGml78tYqpsKLnGhrP3zwA3sIDm3E1/in4AVsj6fLyk9dlVn9au6tiZ+w99EC6XcIv6aShj54o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ivpVTUtJ; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=G3S34XYk; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ivpVTUtJ";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="G3S34XYk"
X-UUID: 70c74fdcd77e11eeb8927bc1f75efef4-20240301
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=0GN7qdpdYevMWCbuXPVo6doK202DBH+cDJwygKCc0yo=;
	b=ivpVTUtJEpxwbpp7t1cUZX5jyHCxVm8CqHxItVa+gI7Mv8nzwxpQHp7GD+U2DaaURXUz6m1kBYNrNwxy4TYHe54VDWg9RFwHH/i3dPetMASa1gupLRN+vf9rAMfRF/ylYUIU8NfVtZa/ObY1kZ6PZ2FuWGKii+s8UHRSskV2tIo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:58a23278-c61d-4adb-966b-048cf9c88572,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6f543d0,CLOUDID:be23fb80-4f93-4875-95e7-8c66ea833d57,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 70c74fdcd77e11eeb8927bc1f75efef4-20240301
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1592351212; Fri, 01 Mar 2024 11:47:35 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 1 Mar 2024 11:47:34 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 1 Mar 2024 11:47:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pp9e8OjUNw2rkfHthOoi9FRg3caaFpNloHcXSsIiYYfNkspUDR5Qs+/j68QeNgKStV6C/icb81iW/cipGGJgq8XZt8QahK05Zd+aI8EHY2siDqZOHFHIM6my61eye6KjnBcNpILYADDOJu73J1WA/SzgAptJS7x02hvNPBqL63hOBCEp/hI6MYGvn5GRSa/5vyPHVuwIMiF3a4XxEOg0VihZ/sj5ZZ3wO8fMr/9t1P+eGSUyxPKWmWx7VZjZediE9rgE024h9JxI84qv0zk4LBb4W81jQRsLkVFLr79U20a5SnRV6f0LX6MJzbHmCoKvWZaaGn0f+UHhJ5AKgXbeTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0GN7qdpdYevMWCbuXPVo6doK202DBH+cDJwygKCc0yo=;
 b=R26THsBuPFppFj5M3mybbUxhJH88sHZYuoAeki1/+C/S05Kmqoo4MJy0Ob1dzA+QF4pzDFuoSoJujZ2UwORECzubQS1MnvpIM8eE3V37uBXOmGrqVRFN9+Z9c7qf6tyICIM7U98aGjpeHV1XuImEFvQXyC/o7eSYSEPLCiDylWIALSQ5c+naIz0BdhYYzS6Gsh29i7cCNHNrsdCfmV8iWIerg6ZvkJxwtVud1nQeyUKWr/3ST+4PJkfzSzWpcH1USJ/MtadPOac2Z3muf8+gdAKIyN2IenauDWZPLidYBsMNojOZkJxrObDqHj19jgcCtMUxTveiHl3Yy7iFIL6Efw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0GN7qdpdYevMWCbuXPVo6doK202DBH+cDJwygKCc0yo=;
 b=G3S34XYkCD25dDxfEUbjHTsixDolSpmgb8s3j2HtcVJRe07L0TRkZuAEXspkbBfZ6KcdpBvM2Px1jBEchCIMywUG8i1l2S1jGo4n+YqZMknZPBF4cco6P8lSju41MnFXrnnpE7+8j/Fwh3OMEtkVaNXperG894SpfZcHPwyXBsQ=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB7003.apcprd03.prod.outlook.com (2603:1096:400:26a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.39; Fri, 1 Mar
 2024 03:47:32 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::7416:94cd:75d9:12bb]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::7416:94cd:75d9:12bb%3]) with mapi id 15.20.7316.037; Fri, 1 Mar 2024
 03:47:31 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	wsd_upstream <wsd_upstream@mediatek.com>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
	"chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v2] ufs: core: add config_scsi_dev vops comment
Thread-Topic: [PATCH v2] ufs: core: add config_scsi_dev vops comment
Thread-Index: AQHaauX1xkKSjtQ4wkCCzKcuoBfemLEhlUKAgACrUAA=
Date: Fri, 1 Mar 2024 03:47:31 +0000
Message-ID: <7b4759ea17cb9d0057b3f7a8c4649cf90f8f2d72.camel@mediatek.com>
References: <20240229080435.6563-1-peter.wang@mediatek.com>
	 <140b6a69-eb38-4ce1-b8bd-0dd404800f65@acm.org>
In-Reply-To: <140b6a69-eb38-4ce1-b8bd-0dd404800f65@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB7003:EE_
x-ms-office365-filtering-correlation-id: 2974bfc6-4627-41b5-665c-08dc39a252d5
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rtXrWyHz/DEUxQKeEFXYbrgg9Q0V23lQSD1mGyFq7d0tMrAoQAm8lery6YUUckRa0csWzgh5hEykYcE6majZF2P8IFL0AHyxRUu3x7JAXEVUe8HD42GKrLKmYOykLJ2UsGQ9GeDSCQz2w6ukszOrFmTEqooI3NoqfdMUQ6FT6fI8s0G2T7D0t0Ur4cJa/5IdbsRQU+ZzKwqHqZGzGwvteTOdEhQeIEvzGgtH+WU1dks5KtD/Xbo7Zww5rpG3CrcXlI68Fb+5H0DX8Xfnx/mSKq1KXPEG7YY4XlL/+NbHRfV1ZVN9kOV+yLDOKVOqeQVAjVrPmZLw6NLZLQ39YKihYNDrTY6d4Et8X2JbM84/HNYU6aitp7szSpCDXNnvimWVQxQRW7yplwRmKKjk+zPgoyYLMdAhCtpHksv+GW1lrxB2Fvp7lhhBzR9kiHBaJquFsroGWS+LO2vbMWHOQDVWcMhyUuGO6FAbKKtHKh+1bOKVY7sYsIp08I0Sl6LUxyotD0bFBIZHWqJhyd22UKZ3x9OOhE1M/wIf2WdGBK4rW6QICj8PolbQOXH6PrlNq3wjq1l9OH6KatVpDkzFfScEnVUA+Uj37C6A+X1DXHe088MuL/x41j220aEyFQ70oO7EKAJ0shudK0VikajYcJi/bqKFntGmtO3/eJpDxjCuvMFq1bJvUJtxUXrC92K9LMWWrfG61ruhPP5EFwuWc1Gn1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OFl2dHpJcWJMVEFQSUtjbFZWUUZJWG5IakNJbkc0czRZRWVoaE42ei9wdnBS?=
 =?utf-8?B?UGdEbEZPZ0J4azBna0pMcGN3SHV4aThZTCt1ZG1tQ3RxY243RmhiS0x4U09K?=
 =?utf-8?B?NlpaMm1TR3R0Mmx4cjNCVFZHbUt6ODZyNlo2VGc1OUFBcWJQaWtCY05CaEtJ?=
 =?utf-8?B?azVWY1EwcW5DcWQ1OHBjY1AvK3B1R25QQnhxQ2I1cnFtRTJlYzlNQVJ4dk5s?=
 =?utf-8?B?aU9wcWY2UHFsZVhnZ280RFJVbEtRTjFBNXVoVXNLaHNtMlBEY2lvM1VxZzg1?=
 =?utf-8?B?Sldtdk9IRm10cjJKUld4K1NMWjZOandJaWR5OWtFSVYrY0xvNVNtaEx2bVdv?=
 =?utf-8?B?dnBLait4c1JZUTZaQWNidSsxZ1BhRThGc2ZSbHdJY25rSzZqWFlkd2h0S2dm?=
 =?utf-8?B?OWNEYitxSlZ2R2RzTTdJb1BQZlR1Z1EwSmorbWl5SkE2RGVHQVZUelFBUG5s?=
 =?utf-8?B?dHlkV0VTU0dLd3JldG9KanRtbzBVelhSS3RxRk10Mjhta1pVZ2p1ZTFmOHEz?=
 =?utf-8?B?U3l2RndGVXp5N1JTWjIyMkRjdmgvbmR4NDJLWlExKzBEbXBjaHRxc1RUSEpF?=
 =?utf-8?B?RnVPR1FSbkFRU3N3VXkrdmNheWRVQnNPSXJJSXUvMmZJMzVlMTRiK1gzb0pR?=
 =?utf-8?B?VTRGbGM1bHlRYzViSU9tWWlWNmdWMER4L3hncGRMRzF5YzZDZVE5Z1dhbGE5?=
 =?utf-8?B?bWp6a1poQTcyY0NqbVBpeXpUYzNpaEQzMWl5dnRJbTN1V2VpQXNWZWFaREZs?=
 =?utf-8?B?TUZqUWovOE55TWxhbFBoaDlwQk4rTlBEakx3MEZaeHRERHVRbmthWDVCbmQy?=
 =?utf-8?B?Vm1HL1N6eVNhR3ZEMU5WVHBaVFFCV25IY2FOOS9mUUhmU1ZpQUhjZDd4djQr?=
 =?utf-8?B?Yi82cFRrK296R0s1MytIOURvUlJNL1BiSkZnM1JEMVBYcTNwWkhVR3hNanlk?=
 =?utf-8?B?bzV6K2lxeUthSnhyQmNPQkNHMTA5NlU4dWtzSXlPZlRpK1NsTXBHOWRIL2Z3?=
 =?utf-8?B?c044T2dzVm1vci9wa1V0K3BoYVBXN1pxZzEva3lIanNXRFpSd2ZaRXpPYTl4?=
 =?utf-8?B?RzJ2ZlhLUXhoRUkvYkRmRGdMUnhDL21lbFc0WnloMWt4bHVwTXBCMW9lMVFv?=
 =?utf-8?B?c21RZ2FQcFdlSUlXbklWUHpGRGRtMEIvUTZpRE8rbnJVYzVXLy9ER1ArMW5m?=
 =?utf-8?B?THJwU2JIWmYvanl2ZUVWVWZaODBCUnJaUzBNSGMyc1BBWVdaWDJKNU5EM1Zo?=
 =?utf-8?B?UVc0YnlDRXljVXF6UUhQOEcrTkZ5Mjh1NDVoemZwL2tnam1tdE5FaU03WlE2?=
 =?utf-8?B?bHVQZUVqYlVvQWJTUVlmQVRZRWl1UGZKZWxpenZydG85RmVBRnhNRzliL3BR?=
 =?utf-8?B?RnFhOCtGcERnbUlKdFhydUNIbGI1c1htT1NzWFlvSG14ZTNFVUNFWTNZOC9B?=
 =?utf-8?B?T0JFR2JTcnpLSkVhMHBJUVBJWmlRS3VVU0dCdmxmVmc0eVk1V1U0RHBUOE5D?=
 =?utf-8?B?NmJWZ1VWN1pnUGc1Vi8vWGtuanFQVU82M2NnRDY0ZGFsWGhQbm1HMUtTdXBn?=
 =?utf-8?B?cVVwOUdneGFoNWtsNjczb29TYmtBTm1ZRVZ5MmtEWmJXRXI1OEpXakgyTzFq?=
 =?utf-8?B?MUlZMis5dHVQOWgwY2dKdGtmRjJtQTZZTmNVbWM0dTgwb25KZzdFSmxqR2Y0?=
 =?utf-8?B?UmxwN2ZqeGFMNCs1SFpwNWtkVG5odVU5Wk9DNE5aTG1JUjBleTZUa1NuVXRE?=
 =?utf-8?B?NnNKbHM5UzBheTJ5cHViTEVTaGlyZU02ZDIyeEtNZ3dMZTJ1cUdseGttT0c5?=
 =?utf-8?B?NFBacmNpdHlOdklud29vZ3g3VWVZem9lSFlmSzlMekU2N2daK3dBWUhPU3p0?=
 =?utf-8?B?aFRuUjROU2MrWnVqZE5RWUMvMlBVeUpEa1NpL3VCdUJGbzBNdDl5eDJmMHYx?=
 =?utf-8?B?UmNQU3N6ck5Pdy81YWxmRUJqa29TbUFlZWZkYmRRMGxKN2o4ek9TTStTc0I2?=
 =?utf-8?B?emZjeFR4QlhpUWhIZVg2dnFpMlNZMzI0UTNYMjlNQVc2aVh2dXNnTm1KTEpa?=
 =?utf-8?B?NHkraEh4NUFxaitpZjRWK1BHcS9ZVmJjUVUza2ZlT0k2ZlFLM0tUMHAwb1Rn?=
 =?utf-8?B?cG1zM05RY1dWUlE3RUxyN2IrSGdNei93WWtEZzN1QklOQ0lKZ3JyVTBWYklm?=
 =?utf-8?B?WGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <486D463F821CE54B9CDB2A730415873C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2974bfc6-4627-41b5-665c-08dc39a252d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2024 03:47:31.6496
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rZdOin2oajSZtaKDStq+k/98iKoFgDk0wIkX6xOzUUvrAOepbhou9W2rNeNszufaBfb2s2x6r/yHNxMpXLpxNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7003
X-MTK: N

T24gVGh1LCAyMDI0LTAyLTI5IGF0IDA5OjM0IC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gMi8yOS8yNCAwMDowNCwgcGV0ZXIud2FuZ0BtZWRpYXRlay5j
b20gd3JvdGU6DQo+ID4gRnJvbTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+
DQo+ID4gDQo+ID4gQWRkIGNvbmZpZ19zY2lzX2RldiB2b3BzIGNvbW1lbnQuDQo+ICAgICAgICAg
ICAgICAgXl5eXg0KPiAgICAgICAgICAgICAgIHNjc2kNCj4gDQo+ID4gLS0tDQo+ID4gICBpbmNs
dWRlL3Vmcy91ZnNoY2QuaCB8IDEgKw0KPiA+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9u
KCspDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWZzL3Vmc2hjZC5oIGIvaW5jbHVk
ZS91ZnMvdWZzaGNkLmgNCj4gPiBpbmRleCA3ZjBiMmM1NTk5Y2QuLmExOWQ4N2U3OTgwZiAxMDA2
NDQNCj4gPiAtLS0gYS9pbmNsdWRlL3Vmcy91ZnNoY2QuaA0KPiA+ICsrKyBiL2luY2x1ZGUvdWZz
L3Vmc2hjZC5oDQo+ID4gQEAgLTMyNyw2ICszMjcsNyBAQCBzdHJ1Y3QgdWZzX3B3cl9tb2RlX2lu
Zm8gew0KPiA+ICAgICogQG9wX3J1bnRpbWVfY29uZmlnOiBjYWxsZWQgdG8gY29uZmlnIE9wZXJh
dGlvbiBhbmQgcnVudGltZQ0KPiByZWdzIFBvaW50ZXJzDQo+ID4gICAgKiBAZ2V0X291dHN0YW5k
aW5nX2NxczogY2FsbGVkIHRvIGdldCBvdXRzdGFuZGluZyBjb21wbGV0aW9uDQo+IHF1ZXVlcw0K
PiA+ICAgICogQGNvbmZpZ19lc2k6IGNhbGxlZCB0byBjb25maWcgRXZlbnQgU3BlY2lmaWMgSW50
ZXJydXB0DQo+ID4gKyAqIEBjb25maWdfc2NzaV9kZXY6IGNhbGxlZCB0byBjb25maWd1cmUgc2Nz
aSBkZXZpY2UgcGFyYW1ldGVycw0KPiA+ICAgICovDQo+ID4gICBzdHJ1Y3QgdWZzX2hiYV92YXJp
YW50X29wcyB7DQo+ID4gICBjb25zdCBjaGFyICpuYW1lOw0KPiANCj4gUmV2aWV3ZWQtYnk6IEJh
cnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KDQpIaSBCYXJ0LA0KDQpDb3JyZWN0
IHRoZSB0eXBvIGluIFYzLg0KDQpUaGFua3MuDQpQZXRlcg0K
