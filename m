Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656BF1CF5E7
	for <linux-scsi@vger.kernel.org>; Wed,  2 Oct 2024 12:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727872949; cv=fail; b=W4KiAYA+4nm7L/9GRc05aTFCJzi7dO3GceAE7qYL112NQKf7kc2vqhe5Syw2N34NCeTmZ+wQoX/3sNAO3q6wqNG1tV6TNG8SNToRptpq20owy6ylLonUUPqS3qj5dsBZ3Y6IaL63zn8RTyaQsYRh7bbmPG2S10x6Xb1AgeCQ3+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727872949; c=relaxed/simple;
	bh=wK+BUsfeNjzJnZcHYKB/gUyloSlWK07wCF01kWlyW74=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lbPLyoAFH8R54vyI65OecpWKU624a+ziewtxehmZvCFQvKSRiBeCO6g+/vsD0gISiauQWkp+tosiFuyBlw65WdS+ngTSfvpCede9KZWkjBgxBK8NKscOAZlAC0cKHwqbvj4I91I907/WX58zC0NeVqmwlPusu+KGkR1qSKu3T/E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=bwnAolLQ; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=oz38nRp+; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="bwnAolLQ";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="oz38nRp+"
X-UUID: c29b619080bb11ef8b96093e013ec31c-20241002
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=wK+BUsfeNjzJnZcHYKB/gUyloSlWK07wCF01kWlyW74=;
	b=bwnAolLQ4jac4LR7T3f1Y02HGPtRfq1oaCYEAU+f0Qqhmr27igPoHB7s4mtA0dgad+68TFdRPiBsJAFmUhIyQuZpURe1UMH/SqKo+ZaGIKnZjg4LoxBE09EoFbtZa27tu7LdFXmOyJE/CscCYMbmfi4+ftkmsv13xejMGaO1UCk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:191692f9-1554-44bb-b54d-6ae9d2e3b899,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:06bc15d1-7921-4900-88a1-3aef019a55ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: c29b619080bb11ef8b96093e013ec31c-20241002
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1399523041; Wed, 02 Oct 2024 20:42:18 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 2 Oct 2024 05:42:17 -0700
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 2 Oct 2024 20:42:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k8MFMb4wb6dqUbArwNMFzkLy41oG3GdvMpXl4VfpZgB/dro3mkzqrAigEREwHoLnUUOqA56ODw9VclAvNHQotW5515h/IlpfBMGjSX/4+ylylTCtJuFdFiI67J6qG7YytWJ0rai+tX+Wcej6l5ACaP281xa4yp3RqUslvb+RMYrEcCIvK/kqOpGXUIRAzIXIjTBNvWEFQ3UU+DfuO8P2rNtOZIliQd35AN7jZ5PDe48vLZ2VyYssdv6hYXN88c4/ZqNH1NoV7mZaEdCRviZXpjd9zJDzG0Wy18NaXYB39IUlFQPNMtTqO2shBASsqb3ojCrxPHrPtsUqP4AiNSGmFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wK+BUsfeNjzJnZcHYKB/gUyloSlWK07wCF01kWlyW74=;
 b=OjEgxHQ43BW2FZu5RSXUHp3uDZ/7RRqRFRx2BPMaF6sj0GzTTQT61xtqV7anTIlRELztoe0N9s0cIuWLz+PyNrE0aiCJ3WR+gBTvmZmFqIyqHDE0oOyHo8GSs/iH5xJ+huJd/Kf+IjHgMZGkK8WWcSwYS5ziltDkSMhYAedOWNigRXXBwGD76P/5wGDXKkj/P0p5AkHCTmrMD8Y9SpWg4DdLNXgEnRQ3TeYeUjKfgdyT9Sxx/YeL1wFvVCmKcGrezlAddg+m+IZkuOTrfKq21sXTG1WQoa68KRcQmIAGBuu2JCDi49AsWkkLAMxOY5+FrgRvLsMofFmVQ+sxFxsZYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wK+BUsfeNjzJnZcHYKB/gUyloSlWK07wCF01kWlyW74=;
 b=oz38nRp+XUJXNnSB0lOx/XhM7+nxPV1LVuWX+9KPKoeHekLYIzu+Ce9sP2QaVrAMx85CzgEhaASnE1nnOde2kwmOWOSpU0ks8jxmbyalDBtg5p9q71fWgDHZqSU98Dy6mgaru8eN3uix04sf7412qSO8c/6/ajxrXh+eCg3M9/Q=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TY0PR03MB6823.apcprd03.prod.outlook.com (2603:1096:400:218::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.25; Wed, 2 Oct
 2024 12:42:14 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 12:42:13 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: wsd_upstream <wsd_upstream@mediatek.com>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v10 2/2] ufs: core: requeue aborted request
Thread-Topic: [PATCH v10 2/2] ufs: core: requeue aborted request
Thread-Index: AQHbE+Mn3m6Kz/z9nkigLrxdmIZYWrJyIqsAgAFGjwA=
Date: Wed, 2 Oct 2024 12:42:13 +0000
Message-ID: <69a77b95da27fa53104ee74ecae4e7da2d1547cf.camel@mediatek.com>
References: <20241001091917.6917-1-peter.wang@mediatek.com>
	 <20241001091917.6917-3-peter.wang@mediatek.com>
	 <6aba27a2-d59b-4226-806b-4442cc26c419@acm.org>
In-Reply-To: <6aba27a2-d59b-4226-806b-4442cc26c419@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TY0PR03MB6823:EE_
x-ms-office365-filtering-correlation-id: f55dd0d1-3282-4718-05d3-08dce2dfa3ac
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?eWoxcFhUS2E1OTlqZEliRXdkVysxdVpsKzZQSXc2Nk4wV0R0dDBYYW9ySTRG?=
 =?utf-8?B?RWdJOFZWYlV0TEhtT05WczFreDFWWXlxS3NVVjBRUDI5VUFjSWtBbmVMb1Ju?=
 =?utf-8?B?Y29VMTNyM1JqNjljNysyUDh2YWUrSWlFT0VNS1RLK3ZSWFVTeUMwL2NIS0lK?=
 =?utf-8?B?NitJOGlkWHZCY0ZhdmUzcm8veVhnSWhlWmZ6cTk3L3d1NXJra2dRd1NHSzhR?=
 =?utf-8?B?bEZVcllPR1NpWE04cHRvOHZTUnE0WWgxZnpEbnFCVjM3bFpiUGJPTGpRVnhR?=
 =?utf-8?B?RktZOE9KMm9Ga2hSWUIzQS80WXVjKzMvMWVCNG52NlI5bkJ1ZEVrMGhKamhF?=
 =?utf-8?B?YWdqeVhsZUh4WEVqRzFtWFBycU5wYlo0eWtpVllrbEpRVCthbTNvUVpGd0Ft?=
 =?utf-8?B?WmZrcDY0VjBSbGMyelFVaWh1eUxWaDkrKzQ4aFhGY3BremZjaGdlNkhxb2Nj?=
 =?utf-8?B?bm9JQys3Zy9rY3ZIczlDSjN5SU5Cb21QU1dhUjY3bkI5UmlobDZ2YW5JWUlG?=
 =?utf-8?B?anY0WmY4eWkrV3lXOEhVUW1CbFllWm5IN2h5V2NWeGNyUEpRSWRvT1RRVnhz?=
 =?utf-8?B?VDd2Y2xoTGZpODFTMGZmeGlhc1JTNVdmZVIrVHl1MnNJSjM2VElHUVliMHI1?=
 =?utf-8?B?VndhWktFZW00Q0VsQlFZeXl4Y1l4WFl2WXJYODRvUHpuanFLMU1obmNTRHlI?=
 =?utf-8?B?R1djdHIyOEZwM2xnWmVDTVQwUnc5Y1MvMHZLZVRFckdMRzV5Rk9mR3BUZllC?=
 =?utf-8?B?dFE2MmFzWUtYci9mRm5SQWY0Uk4ydnBjTTBwbS9jV0RocW5rdjNSQ1ArbnJR?=
 =?utf-8?B?eTJteTlEamQvYk02SmI2eW9NTEJqVm5OSktIczRKZ3dhc1dGYXpDRG9oY3Zo?=
 =?utf-8?B?aldwZERheXVNTnAwOUh5OU5hbGpFTEJTQjhGTWlna01XREJ0YW4vMDlVMkdu?=
 =?utf-8?B?Y1hqaDBYMkhNRFBWWDQrVjRRSmNGaGJZcnA5a3BIRmJ0bWFzZUJuZU9lRG8y?=
 =?utf-8?B?ZS9waW9QRDhKT2tvcDE5QTVUQWZrUnRMRjA3MzdYbnZYN2xSL3VnNUR0aGRr?=
 =?utf-8?B?SlBYWXc0a3VLSUlPeVl3YmhqOVVHb3FVTVJqWEpQSllyL01ZRndXRGg1YkNi?=
 =?utf-8?B?anltcFJCYnNOWWVqcGRKV2F0dzlRTmxyRndwcEdEOEh0ZjRoZ2lWQVMxNDd0?=
 =?utf-8?B?SFlMVHVBektRYmswV3E4NDF6RmI5UGQ4djlUTVk3UjBNVlkzSHJKcUxmeG4r?=
 =?utf-8?B?OC9veUpVaGZpeTJHUjh6NlZySHkvSGx5N01NWjlIdEI3UFBXaE8vejFpazBr?=
 =?utf-8?B?cXdVMXYxRk12T2pSdG1OelVDZUJqWUFpbjBMSnkzeE9CejRqYjMwcUFzTFpG?=
 =?utf-8?B?bG0zK1hNYW4xUnZHOTR6UXNMT3h4NEZOYm95bEJQZG94emxjZE55WjZ4cXhI?=
 =?utf-8?B?Y0Z1L3E1UUVjUzVnSWMvYS9kMXJoR0ZQMXdkazF5am1Rd0hYZkR2UlhRdVJ1?=
 =?utf-8?B?aDFsWWZVSnd2REpldXFKVENVcXV2N29zbFlWOUFqcFNTVmxseTM5dlduRHl6?=
 =?utf-8?B?RGkrb3NmZjVDYSt3VHM4K1hkVmRFUVhWNFMwZUhwQXVrTmtqcjFEeFhQV01k?=
 =?utf-8?B?UXUvd0ZuNGRlZTgzZnJ5MHBpbGFHQlBEbGZIcyt4dElnVS9QS2p5R3VudG5a?=
 =?utf-8?B?UUtQSktHRTdsYnRCK1h1Ym1yeXdzVGk1R2NRTk5SdTB0OFFtV24wOHdFWUdi?=
 =?utf-8?B?UEFPQ3BKUXczMm9YaUZBYXRnVWRHTTFPSW5MOWUvUVN0USsvU2ptQUF0QzRQ?=
 =?utf-8?B?Q25Fa0RyTSt5S0pjMll2UT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bWNhYU5tbkdXZkpldExFNlRFRjdwZ0UrRnpkcUdpN0Zab25ud2JkK3JzeXpK?=
 =?utf-8?B?dng4dWhabmFkdWVMdWJNbXI4LzRsRUJiR0dDSlNzWkswTTdZaHF1SmdVdmlY?=
 =?utf-8?B?RzFwM3c2K29oTSthTnFDTlR1VkQ1VjJwa3k0NkdMRnFtOEU3N2FKM2VYTFFE?=
 =?utf-8?B?WkVRcDJqRy9Uc1BNd1BLN09Sek5Wbm1FSHlaNXAxb3ZsOGl5b1BtMEJKQTZP?=
 =?utf-8?B?dDlqb3pEQk56cFVtYWR5V1ZyU1l3eFlQbTBPdTdrb093emIvUjI0SVJUc0d3?=
 =?utf-8?B?YWFDdGlGOUp4bWNCVlZMQ0xrNTgxeWdVeXhXSHZha2lSMTZReXhNZmNudUJm?=
 =?utf-8?B?WXBWdGtCTWRPSEVFS0RBOVplRFZFcFZDOWgzTUIzVnorYnBvemZaSjJKSXhQ?=
 =?utf-8?B?NE0ySXJQMnI1WXI1RmViM244OUNMdVhZSU1EWGpMNy9KdmVPTXRJUEpraTli?=
 =?utf-8?B?Q1dWeVhYb2VlbXJ5K0xhZ3g4RHNvNW1YbXh4MHhtVlZ4ZEFsdzRjaUV4N3V4?=
 =?utf-8?B?RnJFZ0gyemczMnQ2THc3aWlMNlhSTHZwQmZoT2xnaU1pWTJtb0FRY1laTThQ?=
 =?utf-8?B?MTNHamNHZ0E3UWNzNWxWa3daSTBGWjQxOVJ2K0VJSjBJZ0JZZjlwRDM0MnBt?=
 =?utf-8?B?cDhYVmlXbWJNMUJ5TFA1UTBlb2VBcStEZFdEMWVXV0FDa3pJd1VPNFpVN3lw?=
 =?utf-8?B?dEtRR3JQcDJkb0xzOStuRWZZODlVcjJrNDBRQXFWTG53bnAwcE1aanZUYW4v?=
 =?utf-8?B?V003Vk1QN2ttRkg2NWVteXFlM2xQdlQvZW1LNEFMY3RUYytSYUJPWGFvNWxz?=
 =?utf-8?B?ejkyYzFUbW9mczhlRzdSMEkvNjRFZlV4U2tVTE05cVBxaThDWVpTNzJWemlD?=
 =?utf-8?B?ZEdGZzBiTkpkUGQvVzZjWHZTNGZXZGxvUE5iUEJ3cERLc3ErL3dlZ3pGNzFN?=
 =?utf-8?B?b2ZVbkRoVnZDQnR5cGI0djNrWDZNNW41WEVJcW1NOHdQZ2czV3NZSzhoSGZw?=
 =?utf-8?B?THNpTDR5MHRTai9sb0t0NEQ3b0lxU0Y3b3g0cW95dWY1QXZBay9HUDZOWW02?=
 =?utf-8?B?S2dFWi82bWpFRFZYanRNTUQ4N2Y4Z1ltWmFLbVFPeHVlNEcybnI4aTVsSGtT?=
 =?utf-8?B?dkNMUzh2S1NWOGJOVlhnT2FlVjhRSkVxdmF2VGFKMCt6bmpOaysxMW9uaUZT?=
 =?utf-8?B?OEZ0Z0hNWS9zR2h0dVR6aEZuVEZ6K3JGWGZSOTZKTTFUaC80blp2U21INC8y?=
 =?utf-8?B?Wk93UWZ2dUMzb2dyN0xlS0gvbEZVbU0zREVCUDduZzVQeW9qUy9LczBGM2hB?=
 =?utf-8?B?SGYzbjF2OWptSzlxL0lIaGk0OXhLb1N0QmpLWm8zMG1CbFJSWHBhb0wyMjQ3?=
 =?utf-8?B?aXpRQVI5RTJxMDNrOFp1N2Ruem5ObWI0dCtBazZ3VUVJQk5MSXlCTEM5L1lI?=
 =?utf-8?B?QjgwSldOZXc1a0FjSjJVK1FFdS9PMTNsYXdBeUhZZjZUM0RpTktCWEpod3J6?=
 =?utf-8?B?Y1E2WEpjZGVreElKYmd0MS9JdWhSdERjV2w1WlM4eXQ1YlNxSFJMV3NqaHNm?=
 =?utf-8?B?d2syeTJiaVhEQ0VwNElpaUxSelN5QUZ0dit4L2l5SWVMVmUyRGJtcER4aUNn?=
 =?utf-8?B?WGZJRk81d3ZFODlEMVJualhobHUvM2owd0I5eGFMQkZlNmcvUEZka0EzQ2M3?=
 =?utf-8?B?V3Z5Ty9DVFp3b3NTTnl3Tk0xSWw3Ukd2bW5HM0JKOE9aTE4zNGpRa0lDUmpw?=
 =?utf-8?B?RXJ4OUFnRlBqK2JBcE00ODU1eEFZNHRiQ1NHUFFWMGV0UzVBSFlValJ5Q2xw?=
 =?utf-8?B?V3J2UjRvNEpwZmJONWRGWlN5UlhpamgrZEtCWVNMN2JDZitIMGlhbjdKWW5H?=
 =?utf-8?B?M1p4c3VpSkhOOHlGbEd2a2UrQzZuZUVWUHZEY2orR3FvL2U2U3o4YlIwK0ta?=
 =?utf-8?B?S095ZEE1Uk1TMEdmREoxYzBPZlhkcHVLTEhsV0hxSGJ0akF5TTBnWGhnVjlH?=
 =?utf-8?B?U0pGb3dSZllQUlAvOEx5NCtSYktBY0Q3U3VjbWhuUVZqTTlqNjVJTkhFRTEw?=
 =?utf-8?B?Y0dya2hwa21sd3d4NVFJNmRjVDkvSFMrWXZ0dVdGc3pZL2E0YnJlazlOTCs3?=
 =?utf-8?B?ai9oVkdwYmhwcWk3NHQzZlI2MGMyTlFZbXlGbjhuakdCM3k0cy9OU1doL3Fo?=
 =?utf-8?B?elE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E174AA42F0902A40BA6F54845E82DA34@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f55dd0d1-3282-4718-05d3-08dce2dfa3ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2024 12:42:13.1275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iuuAeH2rkX7Y8F9S6H5n4VOO9SnaLmyjv7dGYha7vYyQ7BKwH3Z4jpgT7gPXd34eTIW30ptStuaXcsKKBNT7gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR03MB6823
X-MTK: N

T24gVHVlLCAyMDI0LTEwLTAxIGF0IDEwOjEzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gMTAvMS8yNCAyOjE5IEFNLCBwZXRlci53YW5nQG1lZGlhdGVr
LmNvbSB3cm90ZToNCj4gPiBGcm9tOiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNv
bT4NCj4gPiANCj4gPiBBZnRlciB0aGUgU1EgY2xlYW51cCBmaXgsIHRoZSBDUSB3aWxsIHJlY2Vp
dmUgYSByZXNwb25zZSB3aXRoDQo+ID4gdGhlIGNvcnJlc3BvbmRpbmcgdGFnIG1hcmtlZCBhcyBP
Q1M6IEFCT1JURUQuIFRvIGFsaWduIHdpdGgNCj4gPiB0aGUgYmVoYXZpb3Igb2YgTGVnYWN5IFNE
QiBtb2RlLCB0aGUgaGFuZGxpbmcgb2YgT0NTOiBBQk9SVEVEDQo+ID4gaGFzIGJlZW4gY2hhbmdl
ZCB0byBtYXRjaCB0aGF0IG9mIE9DU19JTlZBTElEX0NPTU1BTkRfU1RBVFVTDQo+ID4gKFNEQiks
IHdpdGggYm90aCByZXR1cm5pbmcgYSBTQ1NJIHJlc3VsdCBvZiBESURfUkVRVUVVRS4NCj4gPiAN
Cj4gPiBGdXJ0aGVybW9yZSwgdGhlIHdvcmthcm91bmQgaW1wbGVtZW50ZWQgYmVmb3JlIHRoZSBT
USBjbGVhbnVwDQo+ID4gZml4IGNhbiBiZSByZW1vdmVkLg0KPiA+IA0KPiA+IEZpeGVzOiBhYjI0
ODY0M2QzZDYgKCJzY3NpOiB1ZnM6IGNvcmU6IEFkZCBlcnJvciBoYW5kbGluZyBmb3IgTUNRDQo+
IG1vZGUiKQ0KPiA+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+ID4gU2lnbmVkLW9mZi1i
eTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+ID4gLS0tDQo+ID4gICBk
cml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jIHwgMjAgKysrKy0tLS0tLS0tLS0tLS0tLS0NCj4gPiAg
IDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDE2IGRlbGV0aW9ucygtKQ0KPiA+IA0K
PiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jIGIvZHJpdmVycy91ZnMv
Y29yZS91ZnNoY2QuYw0KPiA+IGluZGV4IDI0YTMyZTJmZDc1ZS4uOGUyYTc4ODlhNTY1IDEwMDY0
NA0KPiA+IC0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gPiArKysgYi9kcml2ZXJz
L3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ID4gQEAgLTU0MTcsMTAgKzU0MTcsMTIgQEAgdWZzaGNkX3Ry
YW5zZmVyX3JzcF9zdGF0dXMoc3RydWN0IHVmc19oYmENCj4gKmhiYSwgc3RydWN0IHVmc2hjZF9s
cmIgKmxyYnAsDQo+ID4gICB9DQo+ID4gICBicmVhazsNCj4gPiAgIGNhc2UgT0NTX0FCT1JURUQ6
DQo+ID4gLXJlc3VsdCB8PSBESURfQUJPUlQgPDwgMTY7DQo+ID4gLWJyZWFrOw0KPiA+ICAgY2Fz
ZSBPQ1NfSU5WQUxJRF9DT01NQU5EX1NUQVRVUzoNCj4gPiAgIHJlc3VsdCB8PSBESURfUkVRVUVV
RSA8PCAxNjsNCj4gPiArZGV2X3dhcm4oaGJhLT5kZXYsDQo+ID4gKyJPQ1MgJXMgZnJvbSBjb250
cm9sbGVyIGZvciB0YWcgJWRcbiIsDQo+ID4gKyhvY3MgPT0gT0NTX0FCT1JURUQ/ICJhYm9ydGVk
IiA6ICJpbnZhbGlkIiksDQo+ID4gK2xyYnAtPnRhc2tfdGFnKTsNCj4gPiAgIGJyZWFrOw0KPiA+
ICAgY2FzZSBPQ1NfSU5WQUxJRF9DTURfVEFCTEVfQVRUUjoNCj4gPiAgIGNhc2UgT0NTX0lOVkFM
SURfUFJEVF9BVFRSOg0KPiA+IEBAIC02NDY2LDI2ICs2NDY4LDEyIEBAIHN0YXRpYyBib29sIHVm
c2hjZF9hYm9ydF9vbmUoc3RydWN0IHJlcXVlc3QNCj4gKnJxLCB2b2lkICpwcml2KQ0KPiA+ICAg
c3RydWN0IHNjc2lfZGV2aWNlICpzZGV2ID0gY21kLT5kZXZpY2U7DQo+ID4gICBzdHJ1Y3QgU2Nz
aV9Ib3N0ICpzaG9zdCA9IHNkZXYtPmhvc3Q7DQo+ID4gICBzdHJ1Y3QgdWZzX2hiYSAqaGJhID0g
c2hvc3RfcHJpdihzaG9zdCk7DQo+ID4gLXN0cnVjdCB1ZnNoY2RfbHJiICpscmJwID0gJmhiYS0+
bHJiW3RhZ107DQo+ID4gLXN0cnVjdCB1ZnNfaHdfcXVldWUgKmh3cTsNCj4gPiAtdW5zaWduZWQg
bG9uZyBmbGFnczsNCj4gPiAgIA0KPiA+ICAgKnJldCA9IHVmc2hjZF90cnlfdG9fYWJvcnRfdGFz
ayhoYmEsIHRhZyk7DQo+ID4gICBkZXZfZXJyKGhiYS0+ZGV2LCAiQWJvcnRpbmcgdGFnICVkIC8g
Q0RCICUjMDJ4ICVzXG4iLCB0YWcsDQo+ID4gICBoYmEtPmxyYlt0YWddLmNtZCA/IGhiYS0+bHJi
W3RhZ10uY21kLT5jbW5kWzBdIDogLTEsDQo+ID4gICAqcmV0ID8gImZhaWxlZCIgOiAic3VjY2Vl
ZGVkIik7DQo+ID4gICANCj4gPiAtLyogUmVsZWFzZSBjbWQgaW4gTUNRIG1vZGUgaWYgYWJvcnQg
c3VjY2VlZHMgKi8NCj4gPiAtaWYgKGhiYS0+bWNxX2VuYWJsZWQgJiYgKCpyZXQgPT0gMCkpIHsN
Cj4gPiAtaHdxID0gdWZzaGNkX21jcV9yZXFfdG9faHdxKGhiYSwgc2NzaV9jbWRfdG9fcnEobHJi
cC0+Y21kKSk7DQo+ID4gLWlmICghaHdxKQ0KPiA+IC1yZXR1cm4gMDsNCj4gPiAtc3Bpbl9sb2Nr
X2lycXNhdmUoJmh3cS0+Y3FfbG9jaywgZmxhZ3MpOw0KPiA+IC1pZiAodWZzaGNkX2NtZF9pbmZs
aWdodChscmJwLT5jbWQpKQ0KPiA+IC11ZnNoY2RfcmVsZWFzZV9zY3NpX2NtZChoYmEsIGxyYnAp
Ow0KPiA+IC1zcGluX3VubG9ja19pcnFyZXN0b3JlKCZod3EtPmNxX2xvY2ssIGZsYWdzKTsNCj4g
PiAtfQ0KPiA+IC0NCj4gPiAgIHJldHVybiAqcmV0ID09IDA7DQo+ID4gICB9DQo+IA0KPiBBcyBt
ZW50aW9uZWQgYmVmb3JlLCB1ZnNoY2RfdHJ5X3RvX2Fib3J0X3Rhc2soKSBjYW5ub3QgaGFuZGxl
DQo+IGNvbmN1cnJlbnQNCj4gc2NzaV9kb25lKCkgY2FsbHMuIHVmc2hjZF9hYm9ydF9vbmUoKSBj
YWxscw0KPiB1ZnNoY2RfdHJ5X3RvX2Fib3J0X3Rhc2soKQ0KPiB3aXRob3V0IGV2ZW4gdHJ5aW5n
IHRvIHByZXZlbnQgdGhhdCBzY3NpX2RvbmUoKSBpcyBjYWxsZWQNCj4gY29uY3VycmVudGx5LiAN
Cj4gU2luY2UgdGhpcyBjb3VsZCByZXN1bHQgaW4gYSBrZXJuZWwgY3Jhc2gsIEkgdGhpbmsgdGhh
dCBpdCBpcw0KPiBpbXBvcnRhbnQgDQo+IHRoYXQgdGhpcyBnZXRzIGZpeGVkLCBldmVuIGlmIGl0
IHJlcXVpcmVzIG1vZGlmeWluZyB0aGUgU0NTSSBjb3JlLg0KPiANCj4gQmFydC4NCj4gDQo+IA0K
DQpIaSBCYXJ0LA0KDQpUaGlzIHBhdGNoIG1lcmVseSBhbGlnbnMgd2l0aCB0aGUgYXBwcm9hY2gg
b2YgU0RCIG1vZGUgDQphbmQgZG9lcyBub3QgaW52b2x2ZSB0aGUgZmxvdyBvZiBzY3NpX2RvbmUu
IEJlc2lkZXMsIA0KSSBkb24ndCBzZWUgYW55IGlzc3VlIHdpdGggY29uY3VycmVuY3kgYmV0d2Vl
biANCnVmc2hjZF9hYm9ydF9vbmUoKSBjYWxsaW5nIHVmc2hjZF90cnlfdG9fYWJvcnRfdGFzaygp
IA0KYW5kIHNjc2lfZG9uZSgpLiBDYW4geW91IHBvaW50IG91dCB0aGUgc3BlY2lmaWMgZmxvdyB3
aGVyZSANCnRoZSBwcm9ibGVtIG9jY3Vycz8gSWYgdGhlcmUgaXMgb25lLCBzaG91bGRuJ3QgU0RC
IG1vZGUNCmhhdmUgdGhlIHNhbWUgaXNzdWU/DQoNClRoYW5rcw0KUGV0ZXINCg0KDQoNCg0K
