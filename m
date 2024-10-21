Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65608C0B
	for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2024 08:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729501094; cv=fail; b=ruZeNGV42CJTGgidaRfdcMYnjOPw95n9z493/r/9EbYhkvamFrcPr68tUO1X3xEVLwVMSMfH926aVt+8OVWCyID7Tt6yvptQoqTss8e1fhXgwxCfG7z20BOnmO1X8q+5RH9xMBeap7LwznKl3/xjYPIeSyf0w/BoFlpmaLjtVnE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729501094; c=relaxed/simple;
	bh=e5I1NOYVyuVfyHSQbO98cIJAsk5KhhyqQCOIw1+SDhs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ufpqfr2E7QPVgHUEoVzexo9+o/DZE+IMWlf6/AeSrqImUgIBL+o/gr259kkhdALXPjevXyvhLDWF7CM4yw5ZoDHWjH4l819snOwwkvkjz0UGBT6uRAPxUzDaV754iwX6PqujXN07nhsgvPbXPuOsMCiHsoS0FuaxwYxm9fAghII=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Uh53gz1k; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=O96aQiX0; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Uh53gz1k";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="O96aQiX0"
X-UUID: 9790c0348f8a11efbd192953cf12861f-20241021
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=e5I1NOYVyuVfyHSQbO98cIJAsk5KhhyqQCOIw1+SDhs=;
	b=Uh53gz1k9ucM5b79UgB6bGV/aLZRAvV0NecdFIHakkvPqzwhe+UMQz7QC87UtO08aXajJ+9iZv/9nmaFqFMrRooMTLHCpJqmmGlrAdGgq7774DPp1uyhWwQfztoAoByHN4fpsNuJcLi0R5kYW58lOUtCNDUrGYbivr1Lwa4IOv8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.42,REQID:6705cbaf-09ac-431e-a17f-fef66c77eaaf,IP:0,U
	RL:0,TC:0,Content:2,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:2
X-CID-META: VersionHash:b0fcdc3,CLOUDID:edad1f0d-1043-475c-b800-3262c01ea3e5,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:4|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 9790c0348f8a11efbd192953cf12861f-20241021
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1439403288; Mon, 21 Oct 2024 16:58:08 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 21 Oct 2024 16:58:07 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 21 Oct 2024 16:58:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aO/u12ucKVlg07fZPbTnvyecqq7cHYdEiyyZKzRhK39IsLvxQGRnsIdmy8XHSGvF+zjS9PpE3ze4sNK3vMBn/2Lu9GyNsuYDoceFW+/yTx38+sEVUlFXSurl5BV5NoW+kSS4Ei9h5ItiMYWlTFsPb/9U7DZo1au+ZWF1moyrF/pLiyzMVQ5gvJnpjtajGpaf4Bn8RZKsRiT7owJyYRADCsRtdOwRMPMiXHWXAp0Ep+kuFIwCu37J1nJNae2dB3aY0PvXgM47AXJZ20LAXefnKfX4pujsz/LnBpXmXkn+dDYKclMdVnbLvsFoIqEgflFMu73csIA+bTl4Rx+6Kqhyhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e5I1NOYVyuVfyHSQbO98cIJAsk5KhhyqQCOIw1+SDhs=;
 b=QrUG2cZxthVuU7McOfBIEEkqJpCeuJ8bTZ+cUeKq5I9dPBu1z1LSD4HG1jU5EKl4CYFbpZNPxWWOxq7XO143j09qE3ik9jmBOtCf4J2zmRCdiBGhWvH4FmLqPjnSFEkQc1WHlLkyiMS/WqvyCTfwXbp6uglgxAPQlWhcntqdJP9aoHxu04sXG6IAOB7haQAIBLgmJtWM3aZ2PZJFF68/DJkjRdvjzxhFRYOrCHUudGn4gmpM3q4U/D52EM3tHpi4YkBBQe1wgxD/0HWRnL0HVbZbmruXulRM3Wc5eWDp6klqaQMAXidR2RCEQxJ+LlAfkdWPZfCLJoqGmfa+e0GDeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e5I1NOYVyuVfyHSQbO98cIJAsk5KhhyqQCOIw1+SDhs=;
 b=O96aQiX0djue3e+MOdSMbuFp0LFiXXAWnVAdfC8luuOg3/Z7uTT9HnEQc/yBQyZBUESuSvh3tVcx/SXyn+8tJbUDaXFrmHDZWeT20oeMQK6/HtfarML/O0gjBfpDttgfZY0htclK78XOf6uAYymUZjtSid0BoWhJMVNs54PU07g=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7127.apcprd03.prod.outlook.com (2603:1096:820:c9::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Mon, 21 Oct
 2024 08:58:05 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%3]) with mapi id 15.20.8069.027; Mon, 21 Oct 2024
 08:58:04 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "ahalaney@redhat.com" <ahalaney@redhat.com>,
	"quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>
Subject: Re: [PATCH 3/7] scsi: ufs: core: Simplify ufshcd_try_to_abort_task()
Thread-Topic: [PATCH 3/7] scsi: ufs: core: Simplify ufshcd_try_to_abort_task()
Thread-Index: AQHbIBAy2JNuXxv/g0SYfbYgTHMRALKQ7o0A
Date: Mon, 21 Oct 2024 08:58:04 +0000
Message-ID: <a0749a3e946971eb50ed803f7fb3ec6ae50a33cf.camel@mediatek.com>
References: <20241016211154.2425403-1-bvanassche@acm.org>
	 <20241016211154.2425403-4-bvanassche@acm.org>
In-Reply-To: <20241016211154.2425403-4-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7127:EE_
x-ms-office365-filtering-correlation-id: ee6e3424-4eff-4dae-a5a9-08dcf1ae79c5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?QTF4eFZMVFY2c1F4alZoSy9lT0JES04xbmJVajNvcExLRTdmRFdTd3dNc3F5?=
 =?utf-8?B?dUJhRm15UWhuY2F0LzZYelVBMSs5eDRtbkR3OGVicjVwWXg5cklEZFpGUmhl?=
 =?utf-8?B?d0NyZDI2QlU4L1M0VmFUWFdKMGtjRmV5UDVFckhIaTNwMDI4U1g3TnVCT3pY?=
 =?utf-8?B?VzNxS01neFFXS0MxNjlteVFUTkduRGg1eFNubnFEVlFYb0VjTmFmci9JdXla?=
 =?utf-8?B?cndUWTJOempoYWxQNDk0YnFpa1B1dTNYTCsvNjlWSEREV1dhZWxWbUZkZ2hr?=
 =?utf-8?B?cUZ5MzA2MDBvZ21SeGhMQnV5a0g0TWw0T01XcDdlcHJ4d0xsR0FwTWdZcVFv?=
 =?utf-8?B?M29XTUhmTHFUZWg5K0F3NGgzcUh3WXZ3MFNWd2JHd0kyWE80RkFsMWw0amVS?=
 =?utf-8?B?d3VnTWdlRWpiVllQRlhjZ0Z5ZWpuSC9GSjBJN00xV0cvZi9LcW5TM0lGODNu?=
 =?utf-8?B?ci9sMU1PQzVNYW9nSWRnTkxUOG5FZDc5YVZzT3Jucnh1c2xLWDBINjRpMWRq?=
 =?utf-8?B?REJPMW1SS1RkZmxWc1VvY1ZtUGFqTlNzYjNBUmtwMzJxVm1jVlV1YkIyNTkr?=
 =?utf-8?B?L0Zzbm9Na1RmblVWc3NtY1BaZW1uQ3pKU1QyTUk1eFd2K25LajlIaUk2U2cz?=
 =?utf-8?B?NFFjdzVTY0t4Qyt0ejlyelRDVjg0cE5Ca05CdjJBZ0VaVlpudlhVUUlDRWxa?=
 =?utf-8?B?eUYwWFVzbzdDcVNSRnFuRWlJZ0NtM240R3dhdi9Qc214amNqRGpueVR3Ym1D?=
 =?utf-8?B?aUFkcXRkZ0h0MWJ5V2NleDMrS2xrclJFSUV6MUppNDY2SFlBNlF3anJDTjR2?=
 =?utf-8?B?Z2IyYWR5MDdwbitsM1l5RFViekdpeG1LYlNPMTFCRm5MNlpNcE9QSk55Wk53?=
 =?utf-8?B?TXV3ZHlQaFM2dVNFc3djM0J5eVFDeTJYRENuWVJZckNIYlUvcjZ2VmJuaXRG?=
 =?utf-8?B?OUVYRXFYYjhRVklzT2EvRitKWSthSjRDckJENzNpRFlzQ2xLcGdlbzQvdndT?=
 =?utf-8?B?cXZsbTRJUlZKOXZBQmxTbStOQUIzNjlraWJTS2Jua2dQWE1TSFZ4NlNJT3c2?=
 =?utf-8?B?YW0yKzlzSlZqUGEyeFhUS1BjRlJJTGpWbldIdTlhcWQ2RjhjeTRxaUFpOUxq?=
 =?utf-8?B?S2RkRG1YY1JvVHMxajA4WWdHWXpEMWN4NFcvSUVsbDV5NkJzMGg1TmI0aDZp?=
 =?utf-8?B?Y0IzWWRiL1llcjhWTlhoSDUzQWhLU3FubmoxaWpFdkQ3OU5VcFIxVWdHS0Zt?=
 =?utf-8?B?UEtYeWdyaU1LMTdkVWdrMzIwOElnVEJ4alNMYXFCaGdOUGRvV0pJanlXVUd5?=
 =?utf-8?B?ZDZidkpQU3BscUlGNlE2Y0M2anVSbkxlSDJ4OUVyanlYNElnWXQzMm1kNCt3?=
 =?utf-8?B?SnI2MUloTXZNQUdaUnpEWWdQV1hldStna0x1YTVrQW9hb3VabmdjaGZ5dlVI?=
 =?utf-8?B?Q2hnMHA0b0ZXTTJ1dGZQK3FCYzdYbDJGMnVwdnQzTFBpcmRGUngvSjJtZnFF?=
 =?utf-8?B?ZzlZY3RiSVFwOHZiUXJ3aG5qT0RFd1BBVFdrTGN2SnNIaitNVVpQSWhQdzZN?=
 =?utf-8?B?TTQzZ2hhYSt0TitLaXAwMkQwNCt4YnNZKzQ1WDEyVzg0dDFLS2xCc0NLelda?=
 =?utf-8?B?dDZzK3FRVWk5bUhHa1YrUzRaNzFZTGFhYkR3aHBPNVBKYXpzSjJFSU9SbXVW?=
 =?utf-8?B?cFhVUFFSQTZGaDNmMlQvdk9VTGZONS9ETTJsblZ3aGtEeEprM3o4elhhY2hR?=
 =?utf-8?B?STFjeWZWT3prdGV6V3hIUUdsUXkwbTQvUGxUTzJwUVgyNGtMTUdGK2ZGQlFL?=
 =?utf-8?Q?M4mPM4UtWH30dMiYK37z2SfcH57zxq4z7LXjg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?elJRU2prR2EwYVZZTFZvZFQxWnMvWHkyd3o5RlB4KzBIWmpYaVNtUml1a3lo?=
 =?utf-8?B?QTFwTmZHVnduUjdod1dqZllHR09WZUhNdkhLQnBzL0VxOGxjZjBzL2JPM05N?=
 =?utf-8?B?c1BwTStCU3JhRG4weHlFejJXQUVQb08rZ1VkNkV4MGZXc3B3SkhtekQ5Rjcr?=
 =?utf-8?B?aVJwOFVORm1OZ08yY0M0YkVydmlPN0diQzZNbEhhSTNqOU92R1VZQ0ltZTYx?=
 =?utf-8?B?ZnN1amZtN3B2SFNmUGVCenZkZzVFTm9uMW81QkZwcUlvSlI2MTNhYWJmRW9z?=
 =?utf-8?B?L3Q0WmRKWXVVdDVzZUxCUUI3MWFDT3Z0RWJUTE9WVVVxUlVzOXlLOVJyaDh2?=
 =?utf-8?B?SGNqMjFFUWZ3TGU4dTZCd2JrOStqcm5zZ2lDclU2TXV3SGxqNDczSWtUUjM0?=
 =?utf-8?B?VmFOck9KZnFQSEtqNTJ6MzZxMFZuT1ViVThTc1Jkc1c5U05SZlBEZWIvVDJK?=
 =?utf-8?B?ektENlJ6Q3l2WXdGdTgyMTlSTVcvSVRaY2wxWEhlU3ljanZ1ZnNtc1pJTXNz?=
 =?utf-8?B?S1dMcm9YSFhGQ3dacXUwN09wbmRacExrekQ4M2M2U28xWnFRa2NTR2t2cVo4?=
 =?utf-8?B?TW9RSzZRd0xYSjlCTWMyMWx0OE0yVzFkRU5abUZDeFUzSGY5c1ZmVXloYjhT?=
 =?utf-8?B?ZVpMNHdtdW0zWkVzVkNuVklYREtLRFNHSUNrMFcwazZsbG5kTzRRVFd6ajNs?=
 =?utf-8?B?QXk5SVhodmF5YXJTV2RTdkoxZjZvRVNUWVFJWGtzTFJaWDRzZmIrVStHY0VH?=
 =?utf-8?B?M203Y292SmRBMGJ4eW5panhHWk1ZSE1hVFMwLzhsZEZRQ0llZDBncm1neWNp?=
 =?utf-8?B?bTZLbHBnRVJ0MXJZVjlYTGZQMklxaWRYZk9neHJoSmpPK01UOGdtVzJ2NE0w?=
 =?utf-8?B?MzFSaDJQRzdqOFVmeGlnaTV0VW04RmtGaUFlakpVQkwvSlZiVWFNSGlab09S?=
 =?utf-8?B?MEhMdFZjQVFXSHJ2T29DRHllR0dkWlZXYzZ5aFJUWXVTQWpCbnJFL0N3MGh1?=
 =?utf-8?B?WHFadkFHTDVJNVc5WFZUQmJhc21jN2RSdG9EOW5lWmRlVGRHb2h5WmE2OVcw?=
 =?utf-8?B?MFZvTjFLcVpPSUFGb0N5cERGbmYzVVdha1JZY0FYYm9qNm5kTmh5UjM2c3BW?=
 =?utf-8?B?RTIxL01qaSsyVCtCWWZIYUYrM2RBdFFDU1k1L1ZIZ0xYcVpZbWN0RHBwYUFX?=
 =?utf-8?B?aEJjelZvYlJpYmRsT2c0RWFERmFjeEFtRTJZUWZwQkhIREFVc0h3TVFRaUxi?=
 =?utf-8?B?Z2E3M3RDYjRnVHdBa0ZxOUtjTXJWeDk3UytVOVdJWFAvSWNacFZaNFhLYWtm?=
 =?utf-8?B?TUVNeFYzRXVOYlU3S0cyRHlKWmdwU0lHY1NzTm9PcitrL3I3eGYzaUdTbC9D?=
 =?utf-8?B?Rkd2WXNTUzdMaUxaMjVFUklWcWZHUU9pUWg4cUpkaHdtMTRBTkhjSk9VT2VM?=
 =?utf-8?B?TnU1ZkxUcVh2aUh5NmdnS3g1c3JEQlVMaE1MT3RIdy9HR0NQVFFWRlZUdU1N?=
 =?utf-8?B?NThNQlBQWGpLdEN0RVczUm83YjdFSTg0YnBXVWYyUG8zVUltNk00MFFmOTF4?=
 =?utf-8?B?TVhLSnFUNEg0TExmWWZKd0sycFd4eURPcFlIdW5Xa25qQzYrRUVVMXBLSmhI?=
 =?utf-8?B?UmU4cjZGQlM1U2VPVDM4b3BKVWdGaXNUNllPRGdORFY2bHRoY1FST05VL3Ro?=
 =?utf-8?B?cm5rbE1icnFOR0Y5THZiZXdEUnp1V3Z3NWJRSzIxTlN4Ym9DMmkrbnRWdnV2?=
 =?utf-8?B?RTNwWWJKbjdaZDQ5VFJhZUlEVUlodUNmc3hySnZERlRUNzFEU0VWbTh3dERn?=
 =?utf-8?B?OVY0Zk84OTBCRUNGOWlsdCtScG5BM1U5WWJRbXhmeE84MG9mRkt5TVpQekdi?=
 =?utf-8?B?WlhuNG1XcUk1VzFzTUs0REFuQVhnMTRMYTdGTUVKRVRZbnJSK0tYeGxsYXgy?=
 =?utf-8?B?UWc0ZnNKeVR6N3NhZ1pDcEtVVE1UVE5BeXd6S2U3WmZuOTFVM1BCdFBLd2s1?=
 =?utf-8?B?bVFEOUpvVEFxS0ZnMUV6UnFSbUtobFdiQ0dOcFE0UGppVyszR0R5bUhiL053?=
 =?utf-8?B?RElxSElvMzhoNkQxN3o4bytiMzdVNWJIelBvTlRyN0hvMmZiVXp5SGdXanl4?=
 =?utf-8?B?eGdkeFF5Y3p1QklhallsekhSV2pMS0QwdG9HQ28wUjNrOTZTcDZ3bldJSnJM?=
 =?utf-8?B?SGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ACBEA11995B95C4ABAD796E86C48D33C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee6e3424-4eff-4dae-a5a9-08dcf1ae79c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2024 08:58:04.9087
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IhZ3XzCz0OwirYfbr9ueCRbP0qS/SYLruRN3d4OsZornUw4/jCI65ZDHmTtH+Zsc/LLNZN2b5qfP7NVkrIBTqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7127
X-MTK: N

T24gV2VkLCAyMDI0LTEwLTE2IGF0IDE0OjExIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgVGhlIE1DUSBjb2RlIGlzIGFsc28gdmFsaWQgZm9yIGxlZ2FjeSBt
b2RlLiBIZW5jZSwgcmVtb3ZlIHRoZSBsZWdhY3kNCj4gbW9kZSBjb2RlIGFuZCByZXRhaW4gdGhl
IE1DUSBjb2RlLiBTaW5jZSBpdCBpcyBub3QgYW4gZXJyb3IgaWYgYQ0KPiBjb21tYW5kDQo+IGNv
bXBsZXRlcyB3aGlsZSB1ZnNoY2RfdHJ5X3RvX2Fib3J0X3Rhc2soKSBpcyBpbiBwcm9ncmVzcywg
dXNlDQo+IGRldl9pbmZvKCkNCj4gaW5zdGVhZCBvZiBkZXZfZXJyKCkgdG8gcmVwb3J0IHRoaXMu
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9y
Zz4NCj4gLS0tDQo+ICBkcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jIHwgMzIgKysrKysrKystLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyks
IDI0IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZz
aGNkLmMgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+IA0KDQpIaSBCYXJ0LA0KDQpBcyB0
aGUgREJSIGNsZWFyIGV2ZW50IG9jY3VycyBiZWZvcmUgIXVmc2hjZF9jbWRfaW5mbGlnaHQsIA0K
dGhpcyBjb3VsZCBwb3RlbnRpYWxseSBjYXVzZSBhbiBhZGRpdGlvbmFsIHVzbGVlcF9yYW5nZSB3
YWl0LiANCklmIGFuIGFkZGl0aW9uYWwgd2FpdCBvZiAxMDB+MjAwIHVzIGlzIG5vdCBhIGNvbmNl
cm4sIHRoZW4gDQpJIHRoaW5rIGl0IHNob3VsZCBiZSBmaW5lLg0KDQpUaGFua3MNClBldGVyDQo=
