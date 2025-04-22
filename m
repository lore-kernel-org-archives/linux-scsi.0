Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792F1281376
	for <linux-scsi@vger.kernel.org>; Tue, 22 Apr 2025 13:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745327283; cv=fail; b=u8DrPCSDPMBnlBAfNU12dgKST76ms812EFxPjIAfWS5Jon/Vf1RgAtsV66pTc5wr7sdtcy7oRMYRUYPsoEaWZAvRQoupQ9KCTT2PsL4bzcezQNl1YrxVsQMRyiWHgjdOSPoUwBcIfYC/hYrrGGvIvwIhTVZlQfw54h+aqmIQ//E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745327283; c=relaxed/simple;
	bh=z1fkfrGDKCcSeG4BWuPsVIdWtPybcd94yCs0jsZ7mro=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S6WQKQAfR9u8fEq+RF+0httc6ckazLfWyfr4aSzv8NjEW13m535eXj0k6IQd6GLGx8otGqBnSpPbh8xyfNYdyGPV06Zo2KMZYsayQmpoPrqsswuKzu/mCZvBZTI/83yLj6Y3ee/8DiwqutmTUEmHuybMzo3s+5OPfatiRsBQBFE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=g03LZL6i; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=WgSgqE9D; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="g03LZL6i";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="WgSgqE9D"
X-UUID: cde1dcd81f7a11f09b6713c7f6bde12e-20250422
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=z1fkfrGDKCcSeG4BWuPsVIdWtPybcd94yCs0jsZ7mro=;
	b=g03LZL6iXpOmr7faLZ9/GN/S1ThAC2d+8FIPXssPkwrxfE9VOxmbDgcflF3OVt+9pwbWLs5ouKCkZVlFi/I3ND+CsuLBSi12S2E1qvMnTCxW1WEzWMfRuY5WCJEGlZXX4BmBAv/TBOWWVDo9g54aEaxFxRzHauayI1HC3rFnaCU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:a6a71ff1-81ec-4a76-a6e8-8e6162c60cd5,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:1c5f7a2a-2448-4c17-a688-fd64fca576d1,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: cde1dcd81f7a11f09b6713c7f6bde12e-20250422
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1905698550; Tue, 22 Apr 2025 21:07:54 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N2.mediatek.inc (172.21.101.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 22 Apr 2025 21:07:53 +0800
Received: from TYPPR03CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 22 Apr 2025 21:07:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XtoLNNT7DGnsC0rGGWqI6UdXNh5pe4S5H24PYpzbitSCZ/rMAn19KUsMJfp9DgVjZcAeHtGzzl1zr185o4I6tv6Rskh5WTuJDTuASP66b5RbHetRkD7p+FUJ15R6H6v/LAcBJqS45+AIZHVxTg1n6Efj6BWK47eha2q3uIxnN0KIc1ZZqWxPdoSE+E2oyA4b6q0sFk0pF+y1/0fxM392CjTimCooDkpZHBOGU3l91EhPNSXd7keIDPeUSCsH1wgOBlMss5l4fuSq4QCo8bo5dI4C0YyeA84loZmaBIMsNC+5InpM2smQzEHtepIuDUyKMd339Uyaejoj1Qx/KTjZNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z1fkfrGDKCcSeG4BWuPsVIdWtPybcd94yCs0jsZ7mro=;
 b=gSsBKDysIYo9MT+BJBQa3ZjhPajBbfwXX6UPbbSJqnD2FIWMarUQWVS1eDX8P4IyPzl4fMAsstBv00DSKbyq5SWdHcoqrSJ1dZrpaAZ3T0Y+FBzJFcfhq91i0gzMgWzpexDw6fKnK0P3/7Sns+AsU1hbzrG1NHIWo3UqwUtlZ/FDHqLKVz9HcWJx/Jear3iUC47FaL101yssf/FFGeZODgp5o1h28eIq3WV0UjB7ow4oserEqITatjiVF35MH2MmBNrkFPtYDNPOGXdApLZ3TYyfyywXfqznwAvmygU9n1toa993IhJ0m5q5RxaXbG0uw8iQiAnAlZkicZ3bLajLBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z1fkfrGDKCcSeG4BWuPsVIdWtPybcd94yCs0jsZ7mro=;
 b=WgSgqE9D8DiOHWrT7bkoNzUAs6cyd223wXrzBFQHiJqWnyzfZZoH8gW5Z0u6SbkhovS34wu/x8amzVbAz78qZC8LfV8gwy0Q0vdtjFHWLJK0oskitA5/iwZMLV2gp3QYtyNcV+6K7PzyNHQoCBo2SprTHB/L3ggP07Yu2GZsKJs=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB7606.apcprd03.prod.outlook.com (2603:1096:101:148::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.31; Tue, 22 Apr
 2025 13:07:48 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8655.033; Tue, 22 Apr 2025
 13:07:48 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>
Subject: Re: [PATCH 12/24] scsi: ufs: core: Rework
 ufshcd_mcq_compl_pending_transfer()
Thread-Topic: [PATCH 12/24] scsi: ufs: core: Rework
 ufshcd_mcq_compl_pending_transfer()
Thread-Index: AQHbpN56xYfiOTSZp0K/37ODiF6R37Okb0yAgADPF4CAAqNCAIAAlXeAgAdOPIA=
Date: Tue, 22 Apr 2025 13:07:48 +0000
Message-ID: <bfd92254331b18f3ee697a8762012caa33973215.camel@mediatek.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
	 <20250403211937.2225615-13-bvanassche@acm.org>
	 <0390adb9d0ebed4ba4b386453d20175b1f3a0709.camel@mediatek.com>
	 <84d20bdc-fcd9-42e4-939f-a3ec0422e646@acm.org>
	 <41c2d72bb792a9fab243e2586696db91205c63bb.camel@mediatek.com>
	 <e739732d-bc04-4c8f-a129-b974434ce4b2@acm.org>
In-Reply-To: <e739732d-bc04-4c8f-a129-b974434ce4b2@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB7606:EE_
x-ms-office365-filtering-correlation-id: f72bf990-79bf-46b5-cb1c-08dd819eae12
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NmFrZnIzQy9LYzFPNzQ3bkUwa280bEZ1NXYwUFZla093aG1Nb2h4RDk0cnov?=
 =?utf-8?B?UUg2ME1tc1dEckFBQzRrVXR4NlFYMjY0bi9icysyVHl4MUhRZ2I1YlBMMWdK?=
 =?utf-8?B?emFjcGw5YXVYWlh0bXppRGxuZnhZYi93Rnk3MzNiV0ZTcUQ3YXY0TFVXQlRk?=
 =?utf-8?B?WHdNOGxYRGYwVy91UWRxOGIxek50SnVzTEJKZmlwbmhKM3lLS2p2WXN3Ukd1?=
 =?utf-8?B?TzNlVnBLSWRzRzFnVW9Od243MUZzblozaTFpNkpycTh1VUduL3FvR3pJS2RG?=
 =?utf-8?B?c3ljSklmcExuc0ZhVVJNSmVFbGw4MGNPL2FYWFFZNU5VSjhneG55Z05YN1lU?=
 =?utf-8?B?WHVnV1YwNVZpWXdTcjMwdm9aRnYyZ3hIeGlaVFoxdEM4NnNBMW1OVHUzSE5O?=
 =?utf-8?B?TDJhY21oeEpvdGd2Z0p3bWNaOHErVElUMStKR21HRm53TTBVV2pNUmlmc1E1?=
 =?utf-8?B?K2Z2cUJGOGk4RDc2S1MvbzVvSnU4K051c3VpNXFTak1adlFVWVhCeWRvbnd0?=
 =?utf-8?B?SU83YndWbGtGLzRtdUJRNzM0N3pWbERkMS9PZE5GSkNENDRuWnJ5TTJMRVY5?=
 =?utf-8?B?SVFoTWMwcERLMzNxL2JERm16dUY2OWVBcGJuRWhCMjJ2VlI0VXQ5OTlUeWV0?=
 =?utf-8?B?b2Mvd2xsM3R5OUpRcm12cFI5M1BrYVZFdHJQWVRjak1UMXdZUTJnQmdEYlVj?=
 =?utf-8?B?clZRR2crMkxXenpBc3JaeUFYcDFpc1JxTk85dkU1Q0FCMTFOVU1QZmlDZFIv?=
 =?utf-8?B?a1VWNEVzcXp1ZnZSZ2s0SXBZTm9YcHdsZEd1ZDl4YVI4YTlXaUdXMmRWSkJV?=
 =?utf-8?B?bEUyUTFBN0Nua2FUUWdPZjA1R2E3RjJXUUFpQkFvUksvWENjTTMvd1VQNTBQ?=
 =?utf-8?B?SXVjd3EzZUVMNDRraVE1ZElwRjBVKzFqK3dxcjV5T054UUduK2NMNmdsd2V6?=
 =?utf-8?B?eUQ0aHZ6M1h5bXAzUEd0NldvdzB4bXpONU1PVWk4eHkvREtDQ0dFY1RTQlMz?=
 =?utf-8?B?V0IwNklpbE50cE9iQ3FvR0F4YXV6Z3ZNeEpoMUQ5UjUwUjBLRnVTbkNtS2tx?=
 =?utf-8?B?NEp4Z1I0U2ljb0laSHVPbUV1TndQMkM2SjNDZnZHbXQ0ZnVHbXo2bUtIL3Ur?=
 =?utf-8?B?OUx1MUpJNjdzUy9VN2h1WTluaGJaMmkzd2lWWXdvZXlSejNDMFpKVmNuR3Qv?=
 =?utf-8?B?OHdWNXFZRjBTNnV1MU9JTC9kT2U2UkJ6cEdTQ1lUOG0vN0t1c3RmSFhFdldr?=
 =?utf-8?B?SncrelpvMllSTktVN1p1d095L295eDZrSmRwZGl5NXNyYXNHYTVMK0FXZkNB?=
 =?utf-8?B?ZDh6cjFHTXlMVERMTzdKM3l4REttei9WdWpndXBVZHYzaGRCL29TZXNiNXhP?=
 =?utf-8?B?VHFSNGpPS3NybFJmbkRGaGxBdjdiaEZUOEtkWkdzZThmVXZmZjcyTElCNERT?=
 =?utf-8?B?STl6T2JMdXk1dG15RklpWjNFVkJ3bzM4cm1IREpkWXV2S0lqK1Njd2NkZStZ?=
 =?utf-8?B?TjUrcnRSYkhFYzRFeG9HT3M1dWhmOW5uVVhWcXM5NzdSbnlzWVF1VWs0M2JU?=
 =?utf-8?B?K1U4bmphUXdBRERvTko5ck1BOWMyV3drR1BHTkVWbFBBUmlPeWZtLzdZd3RG?=
 =?utf-8?B?L2hGSnBONTNNWnM4RGdVeUVXY3V0M1FqZ2ovMHN3VXJWMm8xcndhbmJjcnVi?=
 =?utf-8?B?MzV1dWJvRjlvMmFEYlBaNlVXM2NnSzdQOVZIbXVZRWpSRHZsRk8rNU5CQktr?=
 =?utf-8?B?NGVOMFZkU0cwbDNnT1RRVEpWV3BPTGdhSWZVUEhXVHJVWkgrN2JJbm9mT21a?=
 =?utf-8?B?V1hwYjUrMm1BSW9mRGxGQm9NaXVhcDRkRDVZdnN2OVpqOVhqWUhaNWxidlY5?=
 =?utf-8?B?UmNKWDVRVTIzUWlHOW01QzNEblhvbW9CdXJVUTNBb2hubmxpWEhDSklIRGN5?=
 =?utf-8?B?aERIelFyVnNrNVBWN2FnR1hldjI4UC9Ia1dQNGpuT01MTTYwNUJYWnRPTGFM?=
 =?utf-8?Q?rA5dfMi6Gg6yo988JOCnB78UrWzK0o=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TXdJTk1lbGozenhYTkVJYTVBdHFvUGVocG1xK0ZvTzZ0N2tkaDMxQ2hoc1M1?=
 =?utf-8?B?Q2pUWU9MeE5jRkt1SEwvTDIxSzI1MmR4QnE2cGlRNFQvZk1wc3dUY0d3RGxS?=
 =?utf-8?B?OUFKVFY5MUJrY2xTZjg5NlF3T0NTWVkzOHIzK05NcXFCaFhXd3pEcXBkcVR4?=
 =?utf-8?B?QjhiZE9DRzZUU0lOTSt6NnZJM2c4QmF6SmVNcGNxRXNwazlMWEhpQk1iVFlF?=
 =?utf-8?B?WVFaSmRIVnVTNDFKdi9OalhUMk0rV2ZEa0ZFL3lDKzFWYm5rYUd0Mjg1VmM3?=
 =?utf-8?B?ZGJON3NPY09TdnpUYWF0OEhvMUc5cW1RdFpZNE1Vblp1NlBQd1Rad0ZXN1lB?=
 =?utf-8?B?bUw5NDdxNW9vMGJueWo1eG05N3J6ait4Ui9vS1IwY294TEl2SGo2Ty82Zi9r?=
 =?utf-8?B?dm53SG83a2M4R3Q4MWVWMFFoMXlCR3NWMCtMa0poeEVBWlVlR25uZkY1R04w?=
 =?utf-8?B?T2t1ZDh3N3VaVklzVnBleGJQWklhVEdHQi9US2xPenk2TTU5WjYvaW43TW9P?=
 =?utf-8?B?eHJkbGVwdENKSjBnUTM3b1o3TVlMeWNDQXg3WmwrMEhWMlB0cldscHQwVTQ3?=
 =?utf-8?B?VEwwRm9QR3QzaWhoQjNlM2w5Q1ptdFNVMitDV1JnRlRmZ2J2bTBtbXB6eE9O?=
 =?utf-8?B?eVA3endkdzZjRjdQWm5hb2ppT2lMcTNrZGlEaUVWaldqL3JYbm0ybGFEVjUw?=
 =?utf-8?B?c1J6bndkWU9SR3VwQ2M4QkNtU01iODJCN2FPVi9kSjUwRFB0aS9kelBvdU1r?=
 =?utf-8?B?MjBwbTRNeUd6V3lXZFFxRiszWVBoa0Z2TUJBbTBnU1ZoKzRyYmxScjR5YTEx?=
 =?utf-8?B?alU3U1RmZ2wrbG5od3RuZ2FLZDNoL2RjYzhOWjl0cjdmbkFDcldqa0FCdzZl?=
 =?utf-8?B?MCtXQmdpcDUwVmtmRHo1UWRJeGlmZnZIYjZSUG5EUVAxL28rYjBld3Zmc0tk?=
 =?utf-8?B?RzZGS25LQml2SXlxNEZrd0FweUhmM2RGTExES3ZZVVFTT1hDVVFlcWpLZmhi?=
 =?utf-8?B?bEtrQjFiWWNheDh3YklzRllkRVoxeXkxM3VLaGIvUnRtZ2tXR252eUtjVWZI?=
 =?utf-8?B?d0wrbDlhYXRXL1dkT3hmd0tyYmVsUzdYclhMclE0MXpmbjExc1BVYXEwc3BD?=
 =?utf-8?B?ZzVBU3BoWW5tSGNwekRGTzNvaC9iNFQzQkxvR1E2NC8wWWVYMTFPcnYrZTRG?=
 =?utf-8?B?OFhnWnFVVDdYcGh6cFNOVE14eUtqQUxmQ2NTcGdRQUNnTkJlTGt6bGd1SGNq?=
 =?utf-8?B?eVBRWkdjOEgrWTV1WlhOOU0yU3Vyb2F6dHJWVFVrVDJaYUFzdi9lT2haOWs3?=
 =?utf-8?B?UFBTcnpXa1djcFladWZIN2lkdHhWK1NqUHdra0NpTWVoUjh5ZHQ0bWFJQ3do?=
 =?utf-8?B?UTVKQWoxQ1IweGJLcWM3VnFZTnhBSUN0QjRpTHBwWVVUWEh3dmRZRU80NnRm?=
 =?utf-8?B?b0w1SDZLMmNXVnh6YmlScWdmSmN0TE9yMk9IclVqOVhNYTJSdXhtb0dJYUQy?=
 =?utf-8?B?WFJ5Sjh0Q09FN05hVUtwZ3I4R2J3UHdOYkhVWS8vdWE4VHpQMFdRRzNoSlBE?=
 =?utf-8?B?RnNvenM1VGRzclh6NDk5dHlaMlg3UXFPQVJvY3FRaVJOa2Zpb3NKWkhvY3dl?=
 =?utf-8?B?aHlNaEY0bnd4d25JSlExKzg5UVgrcUpMVEhiRzkzaFVaZHVYVThjc0xWQXBq?=
 =?utf-8?B?czhoMlk0cXlvZTNobUR2eXNTZ1Z2T3FvdkVIcXdVSVp5S0N2SGwyaWJWZEU1?=
 =?utf-8?B?UzNWbVpINHBSZ3ZDYjc4eFh4anJSak8vWlVaSWJTQjRnSWYwTXphKzJPTDNH?=
 =?utf-8?B?SWdvV0RwMWRVUFF3SkhIL09ZYzFnYnQ4NmlHVGhnaE1TQ2xkWGFCdEJGYnlK?=
 =?utf-8?B?T0Y2cVF2N2hDRDNFUW5VUENzdjJzYVMrMXdCYWQxVU1tbGRRQzFXOEExRzYy?=
 =?utf-8?B?Rm9hbThwNnZKWGwrNk5RNm40b2k2bVk5TjBkb0hiSmwvUGxHbmdRNXlIbWNk?=
 =?utf-8?B?dWlrRHFLQTZKc1BLUHEwcEVaNWk0bUtUYWFlb0V4L2wvL2lRL2t0VmlSeXZY?=
 =?utf-8?B?QkxRRG4vaHdEdDY4RzRORjZUUzU0VjhSTXhFSWFSaEU1NSsxRjlvRmVIMHNE?=
 =?utf-8?B?SzJnMWxOVUYvQlU3QmxxYUQ5Y3lPSWE0UXBVNVo1b0hNVHBaM0UyRWF1UVYw?=
 =?utf-8?B?Qnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3AD96AAC2385594B8A6970FA3A807DAB@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f72bf990-79bf-46b5-cb1c-08dd819eae12
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2025 13:07:48.1425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3QcKwpNDzq52GGVWgtGB9xs5YADP/VGfJbukuTHgYXVjMMRiDM8CniqWeSFjx8+gq2qwzQgE+qpz3Pb+zCfs7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB7606

T24gVGh1LCAyMDI1LTA0LTE3IGF0IDE0OjMzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IEhpIFBldGVyLA0KPiANCj4gTXkgdW5kZXJzdGFuZGluZyBpcyB0aGF0IHRoZSBmdW5jdGlv
biBtb2RpZmllZCBieSBwYXRjaCAxMi8yNCwNCj4gdWZzaGNkX21jcV9jb21wbF9wZW5kaW5nX3Ry
YW5zZmVyKCksIGlzIG9ubHkgY2FsbGVkIGJ5IHRoZSBVRlMgZXJyb3INCj4gaGFuZGxlci4gVGhl
IFVGUyBlcnJvciBoYW5kbGVyIGlzIG9ubHkgYWN0aXZhdGVkIGFmdGVyIGFsbCBwZW5kaW5nDQo+
IHJlcXVlc3RzIGhhdmUgY29tcGxldGVkIChNUV9SUV9JRExFKSBvciB0aW1lZCBvdXQgKE1RX1JR
X1NUQVJURUQpLg0KPiBObyByZXF1ZXN0cyBzaG91bGQgaGF2ZSB0aGUgc3RhdGUgTVFfUlFfQ09N
UExFVEUgd2hlbiB0aGUgZXJyb3INCj4gaGFuZGxlcg0KPiBpcyBhY3RpdmF0ZWQuDQo+IA0KPiBU
aGFua3MsDQo+IA0KPiBCYXJ0Lg0KDQpIaSBCYXJ0LA0KDQpZZXMsIHVmc2hjZF9tY3FfY29tcGxf
cGVuZGluZ190cmFuc2ZlcigpIGlzIG9ubHkgY2FsbGVkIGZvcm0gZXJyb3INCmhhbmRsZXIuDQpD
b25zaWRlciBhIHNpdHVhdGlvbiB3aGVyZSBhIFVJQyBlcnJvciBvY2N1cnMgYW5kIHRyaWdnZXJz
IHRoZSBlcnJvcg0KaGFuZGxlciwgDQpmb2xsb3dlZCBieSByZWNlaXZpbmcgYSByZXF1ZXN0IGNv
bXBsZXRlIGludGVycnVwdC4gDQpBdCB0aGlzIHBvaW50LCB0aGUgZXJyb3IgaGFuZGxlciBtaWdo
dCBjaGVjayB0aGlzIHJlcXVlc3QgdGhhdCBoYXNuJ3QNCmNvbXBsZXRlZCB5ZXQsIA0KYW5kIGp1
c3QgYXMgaXQgaXMgYWJvdXQgdG8gY29tcGxldGUgaXQsIHRoZSB0YWcgaGFzIGFscmVhZHkgYmVl
bg0KY29tcGxldGVkIGJ5IA0KdGhlIElTUi4gVGhpcyByZXF1ZXN0IHN0YXR1cyBtYXkgaW4gTVFf
UlFfQ09NUExFVEUuDQoNClRoYW5rcy4NClBldGVyDQoNCg==
