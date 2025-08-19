Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D75F1531C8
	for <linux-scsi@vger.kernel.org>; Tue, 19 Aug 2025 06:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755583331; cv=fail; b=fWz2ujz1CKDbsgknchwLTQ7XOxFjgoeqzp8tdUIuOnSXvWL2QzasN7Za7X+g+c5A3ayMkqFftIck+QVxipRj9jhJk7pxE3QGgNnZ279P4ahKbU2s5iK0Y531QdYDfKlyG8ox7j371lJdTN90k9+FaWkOkKVUN74FFyu+98N/GZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755583331; c=relaxed/simple;
	bh=Yo4uDGYFcHbYudM6lCMbHgz8JkNwsBVVfA87l+rGlXU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=C1zYgoaQ7plDZmkq5NEEM6M53yQ4lzOHyNKyZY0/GrfJmXhKU3kp88q665MtCUuq773YM1KFd7l643nTg5LjQJeV8WO8QCvD6UiSmks4kt8X1dyftXKy1eF/B5fh+Qk7TCe9G7ta7TJXo+Y7Nmud02JwQDo642AaA43eMlazIHc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Fy4KY+b2; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=UNp1dPer; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Fy4KY+b2";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="UNp1dPer"
X-UUID: 073ef7147cc211f0b33aeb1e7f16c2b6-20250819
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Yo4uDGYFcHbYudM6lCMbHgz8JkNwsBVVfA87l+rGlXU=;
	b=Fy4KY+b2EGHhoj/1H/RnrE7ieJXnPcIRDgwnBMpsnrocjmUm+z4awqAHa6++kM/7H4jW1Dd+Tp9mYRJJzKBid4ZulCR5KKTjd8NgKuKmB40hBUkVvskhv02LifHdmJq/ZYbrtz0/45jdAl5BPooe4sEfZszHQvbzsVv0YAaKEWs=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:adf2be68-151a-4a74-8df7-98a631fdf610,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:f1326cf,CLOUDID:e87c9f44-18c5-4075-a135-4c0afe29f9d6,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:-5,Conten
	t:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 073ef7147cc211f0b33aeb1e7f16c2b6-20250819
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1248077967; Tue, 19 Aug 2025 14:02:03 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 19 Aug 2025 14:02:02 +0800
Received: from TYDPR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 19 Aug 2025 14:02:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EhRXxd1xlA22S2Qa0XB4Geq3tBpfpw56Jbisb4nkxbVlNcdB0Vn0j08QkXpW71ES2BljlJxq1KWP6NzNP0QspoaVLS7/fqD8Xsv3ezjAJ2UBZL/LUMRUUKA+DigOYB2htusuK6bk4ibdtenqlDubRj4UuaqqvAVIFohHXmzQffsY27cmb1dLTJXl7AfhxW4lMmawp5EhC0uJ1LT8dwD+ufMiR9JB7puJSlD45Mv5Y+IK7PpfV0XAY3szHwiIGuobjJiSZfDntKlBpRzq6YrYREdZJ8kCxPFheUKxgUtej561gYAEd50g6eIALjQE91RYe1QfkJu+1rqMqeZgwuEp4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yo4uDGYFcHbYudM6lCMbHgz8JkNwsBVVfA87l+rGlXU=;
 b=jgjDd7pph8sGZgBAxfMc1lP9anwlXjSRhF519XYPNBmMsDK4Xc9k+vdY1fXuPYFC4xS2U2QJ/n1xCmYTAOC2LOWHuQubV5fIgL/STSb3C0XZzVUHqBeMGVO6ljitmtShVofhG5Q0ivImOh3Hxcsa7IXL3ojp3hOXtmk3iWrmVOuM9z35f+O6qZB0IZ80C5dKJfRVMuKZQ/HsJ6UylHdHhKOVPZgt+Fy+tskSYIrMXrYlvWc+knwV5pQuSHT6ejrdHTwYOnmr/fhi5HVQlxVRoZAGoz23AeDrvk2W+cJ3GQu5o2DHYsBgCI3oZBuh8tgrqXPnyU7qWK6wu0fKiJRplQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yo4uDGYFcHbYudM6lCMbHgz8JkNwsBVVfA87l+rGlXU=;
 b=UNp1dPerRXYaQQ5ZftdxVbcoVvKgH550fLeaz9tpsYUC9fkbAr2OYm4GM1Mzvbzsl7HnSWHwZmhlEbnYbEysfisZgOJYoKCHUBlf5mukXwiTFcYJ1x7TfQDXPHn9qMf5MIXE2A3KgvCF+9TnCNYOjeM29HxEjBn5GBwfBEGfdOM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TY2PPFCD26BAA47.apcprd03.prod.outlook.com (2603:1096:408::9ea) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Tue, 19 Aug
 2025 06:02:00 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 06:01:59 +0000
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
Thread-Index: AQHcDf3ZM0Q56wd6EkKDr8i/XP8dMrRoUl4AgABCH4CAAO0TgA==
Date: Tue, 19 Aug 2025 06:01:59 +0000
Message-ID: <dff5ac9d83bd1cf2a57e84f68275fa2ba80b1b3a.camel@mediatek.com>
References: <20250815160049.473550-1-bvanassche@acm.org>
	 <f54ba94ebb1108bfe6faf2aca7d15e69b0b4a4c4.camel@mediatek.com>
	 <79cce962-b524-4624-a989-640f985669e8@acm.org>
In-Reply-To: <79cce962-b524-4624-a989-640f985669e8@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TY2PPFCD26BAA47:EE_
x-ms-office365-filtering-correlation-id: cb78d09f-a720-4c9a-59d8-08dddee5e949
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SFllSmJjTTkwQStsK2RLeXVZekNmTkxxUXNCQWtzK3RPbEFNSHhVZ0ZxWEZW?=
 =?utf-8?B?NHg0M3RoRVdudGJmWXJwVWs1b1h3QTF6cFoyd0Q3WEx6UXF0cE5JS0NlalEy?=
 =?utf-8?B?ZzByeExqTFV3K21XbUU4ejRHYXpZcUdVa2xYY3J0eVpFdnVTbjZ3RlhMb2l2?=
 =?utf-8?B?UDZabU5oODZpR0FVWm5QcVp3cUpkd1hFUnVvUzExQUZPNEZwMXhLWWlqRk04?=
 =?utf-8?B?RDc0SlpBYjduOWhKb2dZSG5kQ2Nsb3VyOENySG4rdEhOK3hQWDdFaWtBcmtp?=
 =?utf-8?B?T1VNSUdMcDV3dFlLNHZhekptanpjRVZlUmltYTU1RG5UTXpqVC9WYVFEem1k?=
 =?utf-8?B?a1ZHRmZNVWs2citJZktLbTJ1T0pybVQ0bHdrOHNkSG56Z3ltWk1xUHNxdHN4?=
 =?utf-8?B?bUx4MFU5ZmJGeTB5Mzg2NGcxWktXdGVubk8yQlBBSjdKMzFkbDlWVzZZR25K?=
 =?utf-8?B?bkhSeFhCK2pyemg3NHM4cDZSSzFVcnl2STVOc0t4aG9Za2xIY2k0ZzVHczUw?=
 =?utf-8?B?RGV6c1NGQTR3Z0NTZ2FtZU5yYzFOZ3o4cVgwdFJnS3dGODJYQzBUbUR5cTVL?=
 =?utf-8?B?WmMxQkNYblYyR3FkRDgxVDQrenpPSW1OdlFlbGw4eFd6c2d0bGtBN2t1NjBw?=
 =?utf-8?B?VzBTQXU5USt0UG00Ynl1T0xiK0R2NWpiZWowWU91UUdORVFqVnN0elN3NXVO?=
 =?utf-8?B?ZUZGZ1kxT0kzTC92QXNxYmhTRzBtQWhWK1A1K09GR043TE8rb0JLTEg1eW1u?=
 =?utf-8?B?djNHOXVaT2ZRZzdxaWxkZ2Q3N0dnTU5KS2REZDVibEZWMzE4eFc0VDFMYzFp?=
 =?utf-8?B?ZDJlQmlIbER1Mk9oa3ZJbEtFdGFKMWpJM3pBU1FBVDZDZzgrR28yMmhsOFgv?=
 =?utf-8?B?UXo0Rk55emw5K0tkWmhxVVpSMXd5MU5JcEk0RlYwMU54QVlFMDFsdUx0aFln?=
 =?utf-8?B?NTI2VTNUWWMxd0RCRElsQ25ndXNCUzFpem9nUWJTeWQ5aG1oa2N4ak9CRHBi?=
 =?utf-8?B?SjVwZGRPblF3RU5FanhZajhWNVVkNFFDWHUzL3JqYVdGRDRkbmF2dVIyb0Rj?=
 =?utf-8?B?MkNVVEZuTU5zcFNnZUVEWDNEbTcxd0hnemgwL1pKSjZpQWJhKzY3V29Uci9K?=
 =?utf-8?B?YllhVGN6SWFkQnhobWM1a3lMeEhCUDZSaXVyYWFwei9WcnBEaU5hTnJKZDh2?=
 =?utf-8?B?Y00yWEFBeHhkbnhlZmEvWCtzVGpSRUdFR3ExQ01iT0Fod0JPNCtpYU5iajZO?=
 =?utf-8?B?MUdjd2Z5SjlDeHlteWVXSk1nRC9tVDZtek9VV01OeEhIbDJzVVN4OVdIckU3?=
 =?utf-8?B?YWNpdUw4UVFkY3hMd3ZaZUNQQytLeTc5Z214V29YanNEMGtVNjZVc0lQZEcv?=
 =?utf-8?B?dmRadHdsODZYalRCaUZQTzB3aEk4VE12T3FYODFJMXZ5TXphbjJEeG01NFlH?=
 =?utf-8?B?Q01Mc2NGdnNTNFJ2c0E1aHkzb29pd1JhYlQxc28wcEo2aEZiNHJjR1Zobkh3?=
 =?utf-8?B?Y0U0ZzdjUWxqT2t1S21MWkdINEVieFhlWlU1ZGZTa1JST0hSeTNjVWxZWXZZ?=
 =?utf-8?B?TlhzQzhaenE0QmErRzhKVjd3SmFLMmtyRVJYRTlVbzhLQ3Uzd3kzRk16d1Bw?=
 =?utf-8?B?bEdaM0NqNlRYNk9ESE9zdjFUbjE1MU00ZlFwL0pDRXFLS0FJRU5WWWtHOXgy?=
 =?utf-8?B?QUlZbFR0SlpIK0FKS29YOExNK3lZQ1d6S01tRDhzd25OSFNDa0hBc1pLZG1t?=
 =?utf-8?B?S3RDNVVHUkJTeFp3NHRwOHRna0diTHFyeit5RGRwQm5zNWRKZnY3di9Md2g1?=
 =?utf-8?B?L2x1UlJKRkg4RGp3SFN3a2Q1YlY5cE4zODBBTjB4T210cFk0UTl6Tjh0cW9j?=
 =?utf-8?B?R3I1Mms3MGk4SFNsWGhSdXB3UzVsOEg3Z2R3UzFYT0JjTTdYV2hqMVQxMFo2?=
 =?utf-8?B?M3RWZHIvZHY3ZWFEYjA4UUdpTU5kVGpKY2VMSFU0V2UvUEJFUkpEUnJrNm1F?=
 =?utf-8?Q?rYXKYVonKiNhD+0s3O17laFiCDVRb8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OHZjbGJCRWtKbVNmK1R2Q0lSbVpYQ3dIam9zOXh4UjZMSnJvOGsrV25OeFhy?=
 =?utf-8?B?UTlia2xFc1djSTRWcTNQY1lLRTFsTUVTdkxoN2dKVmtrMnFBQkVsNkhGaStY?=
 =?utf-8?B?eGVwNUp1RzZxdnY2a3RINmh0MHlzeDV0QVQ1S0dmaTFBNjBGdU5IaE03L2d5?=
 =?utf-8?B?RXdJSzBwcXNRVm9YUi9vRlVveFA2LzBMMlJIdEd1OXR6UnIyMlVNSzJLV1FF?=
 =?utf-8?B?aVNXeFNmZGhtSTNydWhXeUgvN2lob0d1RUp4S0czYVl3TCtYMHhLYXUvWUFO?=
 =?utf-8?B?d1hHdUFZTmxyNFlvL05rcnNGVkthc2loWU1sb3VyVnNaSEx5UFBsVG5ZWDR2?=
 =?utf-8?B?cTYwYSszbjdzV01GQ0NvWjkrWjJteXFnUFlMS3BjMFNpN0FuTDN1NnNMRjVE?=
 =?utf-8?B?S2k5R1Z3TXhHV0UvV2g0YTJyUFo2dGhIQ0kzekxoODB4bHhUREtaR2tnSzRx?=
 =?utf-8?B?R09hQ2w2cENQZnVtWnJ4OVhoQ0t6bmwwWk5hbXVpZ2lSRmdPM3N1ZTNvODdK?=
 =?utf-8?B?U3ZkTmhRa2trcVpTK2w5ZTI2QTR6VThxN1N1eWxONmozOTAvVnpiT05HWm9J?=
 =?utf-8?B?ZzN0NmJheHpXSldTWmU0WjZnL1FTazVNamt6bUxvNmJHQ2hZa0hITENpdHA0?=
 =?utf-8?B?UWFxNHhoMlJBdXlEOWlxaDk1ODlaaldqTlNwTFdhUzQwaU5Jd1hhTnJHZnlo?=
 =?utf-8?B?ZEVGaVVUYjlDbWhiVlhjMHRqdDVsNzNSMEhOVWhXVmQyZnlxdVhoU1RnT2dm?=
 =?utf-8?B?YlBhTDIvRTlqWXhlaUh1SVlob0dteGFZbXlaMFd3YzMwd3FLSTFCZDkvMUhs?=
 =?utf-8?B?Rnl2T1FRMVROYzVFa1pSeERQV3gyMmc3eU5ncG15QnBWS1BpeWtCdTNZc1dP?=
 =?utf-8?B?LzI5KzFKT3Z2alpVTTQ1ZnN1cVk0bVdHUUlJS0NaSnpOWUxVS2w3ZWg2dVFE?=
 =?utf-8?B?eVVhMDVPR2RhODFpZ3hEQzNJamtDMDhTdVp6WFRlMVBCRTI4OE5ZaUlGcStS?=
 =?utf-8?B?RkllL3g5Z0QxQTlBWHBabWtpRjk5UDJHV2ppRjlEZXpwQlNXOTNIOGV6QUtp?=
 =?utf-8?B?TDNxUWYwZFI3bzVxcis2cklzdVBDb0NaeEJSSm82YUttVG5qZHQxTFQ0YWtU?=
 =?utf-8?B?MGlDRWZMbU5nQmRpMzJKd1VsbW1Rd3hFWWMxTTU5U2FQejAzb2k4Y2hrMEQy?=
 =?utf-8?B?MDVtbWp6UXZNdktjenRHK3k3bWFoUUlESEpLMm43aVBSTXBtOStEWVRLVXl5?=
 =?utf-8?B?RThNSjJyQmkyR0t5SDZ4WkZvcXNkN21SWU1BS2FsUUJLSFN0NnFwaVR1K2dm?=
 =?utf-8?B?R3FQZWF1Mjd6TE4zekJVVjZzMFRjTFFIdFhPQVlWSHFnV3V0Wmlha28yOE5K?=
 =?utf-8?B?N0hIeHZ1TS93Vnp0amduR1FVaVRBYkY5MHFsOGtKendFWVZia2pEUHhIUnFk?=
 =?utf-8?B?YjJpRUdOQW9PRnhVV3dTc2lOUDFGZUgzekhDajdCUDZuRklGOEUzenJlRmpz?=
 =?utf-8?B?Z2tkVHRuUHBkSmxMcHZDS0RIWHpZKys5VzNTa2k3cnVBekVmU294WW1WUW5N?=
 =?utf-8?B?bTNXNlg4WXRzcjhXU2pNVEpQZnVYUHBwSGdwaHljUTRiSU9pV1Vlb01qSWRv?=
 =?utf-8?B?N1BvbTMvOTFTVFljMFhqUUtVem0vMVRRWEs2Wkh3dGVxV0JRdmpZRUtBcVJR?=
 =?utf-8?B?T0ZsT25PUk00c1BNNlA5OFlIVTNuNFc3TlV6TVdQOXJZU09sN3dBbUdLZ1J1?=
 =?utf-8?B?c2RQVWp2M2x0UFd2UjNHSVh2YjdSZklud0tDY2Vmc1dxU09GcHhVUmVSUHNS?=
 =?utf-8?B?cTRla09XSG5rWE5lMG9rcHNNUFlqdmZoQi9PUVIzblRqUHhkQ1R3aU04dEFk?=
 =?utf-8?B?eXd1VUFsa2VyV01EQi9DTEQ2bFZoaVlhNHF3RVFFeC9FS3BZU3pHa1BRT3BI?=
 =?utf-8?B?RFZuOXk0eTdUaXBJdHQvY0dpdE5qWUNWMDF0VlhHVVZLYVRGNzc5MUFsTE9O?=
 =?utf-8?B?Qk5QSk1DVUVkaitxbUR2ZzRlUXFHQ3p4SEJpcDMxWitlZUFDZ01teUtOOWpX?=
 =?utf-8?B?VzJoaXY2OUNHdndtNE9QYTUzSHNiaXRBbUJxMFhoZm9tZGVPMG1YS2Vvanp4?=
 =?utf-8?B?S2w4eW12WVJZL0ZDSHBHTE9VbldhWDIxSUdZcDNtdjRUNmlGY2dzbTI0bEZk?=
 =?utf-8?B?a3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7FD9D58A3634424F932F206BB7D1E4E0@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb78d09f-a720-4c9a-59d8-08dddee5e949
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2025 06:01:59.8928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bBVDX/LCjgH28vcNo+ILsznEQdzLkouyliMUQDcUjXUUl8jp60iRsmzt28H+2MON1YGm0NkQ2g+k84k5nvdwzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PPFCD26BAA47

T24gTW9uLCAyMDI1LTA4LTE4IGF0IDA4OjUzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRo
ZSBjb250ZW50Lg0KPiANCj4gDQo+IE9uIDgvMTgvMjUgNDo1NiBBTSwgUGV0ZXIgV2FuZyAo546L
5L+h5Y+LKSB3cm90ZToNCj4gPiBTaG91bGQgdGhpcyBpbmZvcm1hdGlvbiBhbHNvIGJlIHByb3Zp
ZGVkIHRvDQo+ID4gdWZzaGNkX3ByaW50X3RyIGZvciBkZWJ1Z2dpbmcgcHVycG9zZXM/DQo+IEhv
dyBhYm91dCB0aGUgcGF0Y2ggYmVsb3c/DQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0KPiAN
Cg0KSGkgQmFydCwNCg0KWWVzLCB0aGF0IGxvb2tzIGdvb2QgdG8gbWUuDQpSZXZpZXdlZC1ieTog
UGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQoNClRoYW5rcy4NClBldGVyDQoN
Cg==
