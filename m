Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0811EEE9
	for <linux-scsi@vger.kernel.org>; Tue, 10 Sep 2024 12:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725971582; cv=fail; b=gdxfMcjVI1SLVWWpMGfv/ADVnTwcBAnW6q/xLBR6++iLD7jVkfCOw5f2MkxZoyNJ/N/ij3HZ3yWYOX0P+Qbq+pozsYSTnxzlWc1RpSVvDuX3hDDpiBDm3UI4pL6Ajf6/yAEfFatGfTnugg/x8mLRz++GL3FcRAp+zp2YxHrjilE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725971582; c=relaxed/simple;
	bh=b36e3bh7lwUiE9R6FDcm1ys6rpCnQe1ENFXpmjNP1po=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=U5XJDpFIEnaxZGtbvRqHJfjqTgqs1xb+mpWk6TpL9X3uJOqPi+OAGO4CdUeiqju99i8IIENXrlG/pHN3CqHVmC1lrsrlTIRdEX8AAyGU1iYeO5gc3IRMZ49Dz+WFPvX7hqAvVAW5kR1aQV8uZ80wxVbU68KQ8WddC2lC4+JSMaU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=flMx1oE1; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=gLo4CWpQ; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="flMx1oE1";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="gLo4CWpQ"
X-UUID: ccdf15366f7011ef8b96093e013ec31c-20240910
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=b36e3bh7lwUiE9R6FDcm1ys6rpCnQe1ENFXpmjNP1po=;
	b=flMx1oE1iqdGI0THHUJmqXtd2leGjnYNRa/r5qnO24VOcSNPcMdNxQUNNX8RYSA4n74+6d7VxycGo0Y0q1FtEz9bouMkpH89L0mPjiwSSQu2ffQUKSzgBj96TB/ZcnVLJLffQQZl/TM95AHArgmfxQYLCUJ7/+Az3LdAdeVEQus=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:b5c26337-0f94-4555-b5fb-c326d6c1c8f0,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:c99a7b05-42cd-428b-a1e3-ab5b763cfa17,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: ccdf15366f7011ef8b96093e013ec31c-20240910
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1669974673; Tue, 10 Sep 2024 20:32:53 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 10 Sep 2024 20:32:51 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 10 Sep 2024 20:32:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AEOacfpbCVL8Jei8aiZLO6pj3OTpkpI0bBwgfRF6xVMcwqZjssZr+hC4czkPg+ojmSHgGXsfndlHgzc7TDvdr3JsUQDXNnsyEKMB3Ok6d3YgBdoH2nkuFVdy6Y/pzKlqJ7xlQcHRr36zXpDgnfXvGJza/88+/y8k3LCgBsmEM2C5rByPkDlh1ycBooqKrkonD+IhGhAaFcRTqgrhty+J/lgiEVZ+9W4syP3M0Ij6Qpkk2LDQfphFn7FnEoRnbQR66PrzDz0+Q0N6tCRG1E6C6Sx+sAUx7uqN3AoQ/OA4fFYh70Meo6cqcRn1+6ECItzKt2xSVaTW+qS8yokU7Voc+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b36e3bh7lwUiE9R6FDcm1ys6rpCnQe1ENFXpmjNP1po=;
 b=GEoEndl3mCuLpQUEC5nm8QyeiN+z1IDX6NmboFkvivurRdjHo8FCmT9iYO97LZIX+0f6XK6Wl6tEeHnFKolbOFaGXezNaH2+i4JYa5LUDJMyFaKbbfm0hGR+YTzyd+iZXUxky+bZkiQ2JgKsB7dZbLcGJ4JZNrKnjVSmdiPDw0NTAwF2I3eYBIsBUVqrZXIlHwIi2SFADvhpqmdZ0t3QMTZclo1v6dH3A3ehcXXj2VtBFWgxBNpitb1I9k1xenp7kUBLPFIq7WPzRW1ysJq4Rl7uBp5oDjD4kQbthFkvG70sXcU/TH3b8G8lzxViC+R2Pi9Co/DHqN31ky4AKuLsWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b36e3bh7lwUiE9R6FDcm1ys6rpCnQe1ENFXpmjNP1po=;
 b=gLo4CWpQoBrpsJQhrENtrQWON6BggmGch/U+FSM8d1gEq4vo7Sn05qcIrAawLAmBMW4yEVIWPGs2DvyGmDekKWWNGKE1eJIvoMx/xExIqemyf4GX4FnKmQeui4tRIbUbUi/m6Z2dXvDFwEDZF7uBKygp8opXR1k7f7KuGXlT5lo=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB8225.apcprd03.prod.outlook.com (2603:1096:101:1ad::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.23; Tue, 10 Sep
 2024 12:32:49 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7939.022; Tue, 10 Sep 2024
 12:32:49 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
	"ebiggers@google.com" <ebiggers@google.com>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>
Subject: Re: [PATCH v2 1/4] scsi: ufs: core: Improve the struct ufs_hba
 documentation
Thread-Topic: [PATCH v2 1/4] scsi: ufs: core: Improve the struct ufs_hba
 documentation
Thread-Index: AQHbAw25VTpAlwEJNkyBiIuWOOcRYbJQ9PsA
Date: Tue, 10 Sep 2024 12:32:48 +0000
Message-ID: <017f2934e9854d28e81448d278a1d77766f0e75a.camel@mediatek.com>
References: <20240909231139.2367576-1-bvanassche@acm.org>
	 <20240909231139.2367576-2-bvanassche@acm.org>
In-Reply-To: <20240909231139.2367576-2-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB8225:EE_
x-ms-office365-filtering-correlation-id: 0bd7112c-3ee4-4898-3781-08dcd194ae33
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dFg1RFJycWRpMTE0VDBERjMyNXVvR1hSV211TEswSU5RM2MwNTZSN1lwbExK?=
 =?utf-8?B?RWxUT1F0V1ZoRlo2bnhsd21rOGgxWU02NnRrdy9ySWkwQjRYY2pOSkRTa2Ju?=
 =?utf-8?B?VFhKeHM1L203VHJuc3RpYU1xVHR4dy9FbkFObTA1VHhVaXplR3F0SUVVRFZB?=
 =?utf-8?B?WHNwdUFpTm9SbStqdDlJTUZwbit1TkErcVFGSEJuZWR2UmdRZDJJQUNaQ2NY?=
 =?utf-8?B?M2VmNGxnNVM3dEZ0bjl1RUh4YWVSVDlDYWkvL3VFVGRlNGxtOXlDWDg4TnVF?=
 =?utf-8?B?bzJXNE9pTVExOGUzMFdSdVBlbmczNHJIcnZKckdCQUxVNUVmQVIxUGNNditW?=
 =?utf-8?B?ZVkzWVgzZ2dwQzdhaGg5WGpzTHFFRFdkcnY1eE4zNVZRMmFIU0VZRnl0S0ZN?=
 =?utf-8?B?NXIzT0xOSW5qZ2tUenRRZTBkOVR0M0RFNHVIVjMraVBLbVdOM2JUOGZ1K01y?=
 =?utf-8?B?TnQxM2MwbEdray9ZYzIwUUFld0N0MWc0RFpFOXlIN3NBYzdBdCtzbXY0c1FK?=
 =?utf-8?B?QTZKeVlKdmxRUm1lcWdzRi9rWFJYSmxqU1g5T1BzbHo0NlJUZFZoREJ3RE9q?=
 =?utf-8?B?Y0NhQzdRZG8vMmtoYVpISmR6Z2x2Vk9JN1BQcGdtZHRtOUs1MTBUVTlPaktV?=
 =?utf-8?B?V3JwTXpzdGJwbHlKK3dsN2RJZ3VzZDEvekVuYm0rNENmTTNBZGFmTHl4elpS?=
 =?utf-8?B?S0hURnRQVG0yQlB5Q2VQYTQvTlIzTCtUcXBmbG9GSm9MV09lbjUvMVNNaVlZ?=
 =?utf-8?B?Z01Oems3RzEyaHptUUxSTWN0cVF1WUJSTU1ZeEFNMmJmQnhJS3RHaTgwSDV1?=
 =?utf-8?B?QndlOU1mY1J4dUZ1UjRVL1hsNzFTTzJJcXE5UVhIU2lIUzNwV3FRNk4yTGtt?=
 =?utf-8?B?WDYvRElSMXJvOGVqYnphNi9scFdpZE1PTlFRb09SMnVuUVdrTlp3bi8xVC95?=
 =?utf-8?B?NFNTTko1cEJOeERPMGJwMzBKMkMzR2FtSUJXVjdJem1NbzgzSjNua0p1bGRw?=
 =?utf-8?B?K0V3V1p1UmdKeWZJaVorTnJzcmppNzBiZExaeTBxYUQ1bXZjQzlvZXd0YWpW?=
 =?utf-8?B?U3pHbm1HV1l0TmpqbmpvdkVaSlorbU9EemRLM1FpbXFHVmt5UnlMTXhoaUZL?=
 =?utf-8?B?SDdQeFBlRmV6YjlpbE9Bakk1ZHVuYUNMY3RVTGhTRUQvUXhoMHBrTHd0NEo1?=
 =?utf-8?B?ejBRWnJFOVZTSk9EejBYL1VqTW80U0Y2SGNva1A2M2JMcTVSYTA4RXM2Tnpl?=
 =?utf-8?B?M2JHdXFHejJmZDcyRVM4Z2RGUGRjUE5qdnZhNlRFV0xhcVRlOWlWMDNxRlln?=
 =?utf-8?B?VFBhTTVTWjhjZ1p0cWNJRHFxOElIYTR4OHdKVkZMVm9rdmQ0K0NqU0ZQZEVU?=
 =?utf-8?B?VGU4ZW5ITHBmaWQvYWw0cFplYUQrMitXdlRGelJSYnVhd0hFQUhYTEhjWDlp?=
 =?utf-8?B?VmdhZlEvLzlGaFN0R1dwSEFJaUJkaXhNNmNnRFJqbUMzOEF5ZkNGS0hmaThD?=
 =?utf-8?B?RERtSHJwMjd2YlFhM21IdUVHclNTMjhWOWkxUnUyeEFGVHBERmlOSHM0T1lp?=
 =?utf-8?B?aUNVSmluRkdHcElKdkJVMk5oNnNRUUx5bWtpT2J5YzZHNTVtQlFWdWV2cFdW?=
 =?utf-8?B?RE85NlVRTmhKdkdEbU8yMGpiZ2NlNmRlTmJVUlFHdWdRcFJocStBSWFNYnVU?=
 =?utf-8?B?L0dFNlVWVXIvUjZTTTdXbXZGRStoMzBNRlA2Mks2a0ppbEJOanFIYWNRRjEx?=
 =?utf-8?B?ZUZESFdDZ0hmOXlyUkxRdW91QmgwM3c2eEFiOE96WG8xVmhjSkp1azArZDN5?=
 =?utf-8?B?TE9zUm9DOUVJa0pXdFd3K2dlK0lPNzRqSk1YMlhZbHBFdmRTczY1RzZhUXpN?=
 =?utf-8?B?dW44SVM4bWhqQTBmY2d4TytDZmV1dUd3MnIzenlFK0V3bUE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MklxcjNDWnJjRU95N3RoT0tVcVF3L2NlYXdzQW5LdFp3ZzVuT2FoRFFublph?=
 =?utf-8?B?eWQ1UVlEdU5IQXdhSXcrdUxEQ3FWa3prdGJqaTV4NkZvS2JrbXh2bkZONTA1?=
 =?utf-8?B?ZFFFMGdXbG1zK0RnN1VWWmJoNjBZUWdxcmhkYytqVjVIZExCNjVaZVgwSWpw?=
 =?utf-8?B?NEJQVnJtOTJwSHZBdkdldTltbWpsRnQvd240ZlUxTVBZRjlDelN4N0VCZXl4?=
 =?utf-8?B?SDQrdzZEZ2M1b2cxWHd4R1NLWUxSMEJNY0NGaDVVbGYxQkZGSTU2S0tzZEtR?=
 =?utf-8?B?eEVsV0x2L3NqSDlodWxaMFlaOFRvQXBzUUx4L2VKRWN3Uk1KTlVzOFJGeHNp?=
 =?utf-8?B?NXN5UkRvdys5TU02L0w4NGlIekNNaFBFcjFYZTlLb2ZZb09mazI0ZXJYc3Av?=
 =?utf-8?B?TmplT3ZERjdqb296S0l5bXdKS1RRTGZiRmtJZzA5bnZ3YnptTHQxS0RJeWx3?=
 =?utf-8?B?ajRWeHR4a1RtbkZIZW52ZXFaeDR6UXdZaW1aWE4veUlEaFBaNUxFVjdjMXJy?=
 =?utf-8?B?V09uY2k4a1F1eHorSFN3MnM0Y1pGWjNsOHRTL1lLblZQU0tob3RBVXFpbzEr?=
 =?utf-8?B?bXp1c3NkMUNQZVNIMUlDMjY3L0d6ZThXbDVVd1JrSEhFd0hFUmlyY08xLytv?=
 =?utf-8?B?enhjL1IxYnlGSmx0UkUzVG1QcGpLa2RPTTVMaDZhektCSnBZTlpkeXg5WXBE?=
 =?utf-8?B?aHpMV2pYTFpWbUdWU1dEUnhqU3NIVjBsbXN3V1pTK1NxY2tiR0FHOWFybEd1?=
 =?utf-8?B?dWFVR2RUTXd0enhDMWtjRlBGcHVlbEZGWmp0eENmclNFdDZZUEpSMDBRd0c1?=
 =?utf-8?B?MFBPWWVWSVF3R2MweSs0QnNqMHpsbFJsVVIwbndjS0t4N0pJV0Q0aFJTVTgx?=
 =?utf-8?B?eUNwS3ovRUZLTXVmSGI0Zi83VkY2a1N0NkorY2xUU2VqRFpDZTIzbGtIQVhm?=
 =?utf-8?B?QkxJUWdDL0lFaHpycHdPMWlPOWtNWWZtSHdHRWdkN1RMUFhRRzhCQktZd01R?=
 =?utf-8?B?bHdBWmlDK1dBZ3c5Q0lnSGlPTmhWWGhDQ2ZLajNPRU1PczFhZ1IwRXVDOXl2?=
 =?utf-8?B?d0tVQlRYNnl1QkpZQytTbnU2enZUc0pnMFZJdGJYS0pHc1kyMlNRRGtOaEFC?=
 =?utf-8?B?ZUNPNXN1WnVYWVlWV3diUFkzVTRwZ3lFSVF5REREQTJlMnhxeVFBYXBjcFVD?=
 =?utf-8?B?TWM4NjBHOFRjTjNjNXdFK05RZVd5N1JlWVI4bnR2MmcxQVRGRDVQZXE3cDdZ?=
 =?utf-8?B?QUQrY2VReVVIQkxFN3R1ZVNuZWw1aGE0eHlHN1d2OEVYditiQld1SW9Vc3R6?=
 =?utf-8?B?MWZhcjZuN3RjSGdsWktTaUhzc3F1RVIzL3JZTmMralNzbzJ0YjVrcmY5aEhm?=
 =?utf-8?B?MWpXRHQ1TzE2UERlN09rNGRtVDFRb3E3Y2RMSXNXM0oxKzJ1ZjcyeGJWWWxN?=
 =?utf-8?B?UUNJS0FlU2NiZ0JteUE2eGcxb21GcDI1aDQxN25UN05hUkkyaFFZd0lwcXpG?=
 =?utf-8?B?SW8zZ1pjYkxud0cveGNNRFQrVGl5V0NJNnd4YzJ1RzNDdVZMNDRZd2JpSG5D?=
 =?utf-8?B?d2UvR3VVRDMvZjJSeHdLV3ljYURsZkpkSER6RVZOSG8xN2VxVkx3Mkc5YWJa?=
 =?utf-8?B?R3o4NTNRdm9CUkJkZTI2Y01hTXpQaXRHa1laZllGd3NGQjRJM05va0xiRjFt?=
 =?utf-8?B?ZFNwaitQc0k0MFBGYU4vL01rbFZzS3RsMGYyWUJGQURtcU8wWlEzKzNabjFx?=
 =?utf-8?B?ckVEL0tSczBGY1ZZUCtLQUN0SjZaK2MwVFRuOGhkcEovRTdJbnFlVksxZENU?=
 =?utf-8?B?SFd0T3FYVW9oR2lLUFFXSEt3SlU0STM4Zk4rYjFBYW9qNi9ZSXJlSjFzUzVi?=
 =?utf-8?B?M2daMnllY1BMTmEvUS9YU0NuSUQ1SHRNWEsrTSsxK3pQYWszMTJnUTRqKzN1?=
 =?utf-8?B?Vms1ekhjQjBtb1hYYlJUVVpDSWlnS3BuWS9Fem1jd1Y2L0FLb041THNhMXEx?=
 =?utf-8?B?YW91TUJXQmpGbll0amcvWU02WXVhbHhmTWZFTFRHQkpmQkI5UlRSOVo2ejBB?=
 =?utf-8?B?dFJ2dmJNNWIyRG1lcGdFMXMveUtvWDVZcnlPOGdkdUtHUEE3amlGZnpDNnBM?=
 =?utf-8?B?Z05SeXQrcGhXd1ZMamE3aStxaTFQMHFmUHB0TGhJeDA1TmhGTFdkZ3IzbXRn?=
 =?utf-8?B?eFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <84D690984B272D4BBF6CB41B4DC27B5A@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bd7112c-3ee4-4898-3781-08dcd194ae33
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2024 12:32:48.7658
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QhX/Tzm9ZxSHxo4CiFEVEqqIKfnpstbugvTYTdXvARVB5b5W588EetdJqjb9/EIKHRiI42E5d1jpYhvxErbBpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB8225
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--24.691800-8.000000
X-TMASE-MatchedRID: Y6GLOewO+JjUL3YCMmnG4t7SWiiWSV/1bkEYJ8otHacNcckEPxfz2DEU
	xl1gE1bkfdd9BtGlLLzx1uczIHKx54/qvvWxLCnegOqr/r0d+Cy0xIzVr7Ulb04K0IMk2m3GFqS
	tmy2UyjsRwT4s6Iq4iwqOXUtnX95zp1sDqz+3fc5K2kj7j4ouAO8lj2kHOCDUZ3q824boKrJnXT
	ApdRZecnnkytQFH7SyG+Yd2AhjmEyXBXaJoB9JZ9IFVVzYGjNKWQy9YC5qGvz6APa9i04WGCq2r
	l3dzGQ1PfNKnvccwdw=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--24.691800-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	097F9D6F6B595EF47DD135F07084011E3F510536BAAC6EC8F61B80888AD02A462000:8
X-MTK: N

T24gTW9uLCAyMDI0LTA5LTA5IGF0IDE2OjExIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgTWFrZSB0aGUgcm9sZSBvZiB0aGUgc3RydWN0dXJlIG1lbWJlcnMg
cmVsYXRlZCB0byBVSUMgY29tbWFuZA0KPiBwcm9jZXNzaW5nDQo+IG1vcmUgY2xlYXIuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4NCj4g
LS0tDQo+ICBpbmNsdWRlL3Vmcy91ZnNoY2QuaCB8IDcgKysrKy0tLQ0KPiAgMSBmaWxlIGNoYW5n
ZWQsIDQgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9p
bmNsdWRlL3Vmcy91ZnNoY2QuaCBiL2luY2x1ZGUvdWZzL3Vmc2hjZC5oDQo+IGluZGV4IGE0M2Ix
NDI3NmJjMy4uODU5MzM3NzVjOWYzIDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL3Vmcy91ZnNoY2Qu
aA0KPiArKysgYi9pbmNsdWRlL3Vmcy91ZnNoY2QuaA0KPiBAQCAtODY4LDkgKzg2OCwxMCBAQCBl
bnVtIHVmc2hjZF9tY3Ffb3ByIHsNCj4gICAqIEB0bWZfdGFnX3NldDogVE1GIHRhZyBzZXQuDQo+
ICAgKiBAdG1mX3F1ZXVlOiBVc2VkIHRvIGFsbG9jYXRlIFRNRiB0YWdzLg0KPiAgICogQHRtZl9y
cXM6IGFycmF5IHdpdGggcG9pbnRlcnMgdG8gVE1GIHJlcXVlc3RzIHdoaWxlIHRoZXNlIGFyZSBp
bg0KPiBwcm9ncmVzcy4NCj4gLSAqIEBhY3RpdmVfdWljX2NtZDogaGFuZGxlIG9mIGFjdGl2ZSBV
SUMgY29tbWFuZA0KPiAtICogQHVpY19jbWRfbXV0ZXg6IG11dGV4IGZvciBVSUMgY29tbWFuZA0K
PiAtICogQHVpY19hc3luY19kb25lOiBjb21wbGV0aW9uIHVzZWQgZHVyaW5nIFVJQyBwcm9jZXNz
aW5nDQo+ICsgKiBAYWN0aXZlX3VpY19jbWQ6IHBvaW50ZXIgdG8gYWN0aXZlIFVJQyBjb21tYW5k
Lg0KPiArICogQHVpY19jbWRfbXV0ZXg6IG11dGV4IHVzZWQgZm9yIHNlcmlhbGl6aW5nIFVJQyBj
b21tYW5kDQo+IHByb2Nlc3NpbmcuDQo+ICsgKiBAdWljX2FzeW5jX2RvbmU6IGNvbXBsZXRpb24g
dXNlZCB0byB3YWl0IGZvciBwb3dlciBtb2RlIG9yDQo+IGhpYmVybmF0aW9uIHN0YXRlDQo+ICsg
KgljaGFuZ2VzLg0KPiAgICogQHVmc2hjZF9zdGF0ZTogVUZTSENEIHN0YXRlDQo+ICAgKiBAZWhf
ZmxhZ3M6IEVycm9yIGhhbmRsaW5nIGZsYWdzDQo+ICAgKiBAaW50cl9tYXNrOiBJbnRlcnJ1cHQg
TWFzayBCaXRzDQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVr
LmNvbT4NCg==
