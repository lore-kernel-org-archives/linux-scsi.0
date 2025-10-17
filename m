Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE2329ACC2
	for <linux-scsi@vger.kernel.org>; Fri, 17 Oct 2025 08:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760689818; cv=fail; b=G9VIZkmQiLTthHJoY3dXC5qkKRhLcPNSmx+qABm2neb5Y7qC7Vi/iGkGKiQDiK0L8qaA40+sukLVzDlmnYpQ5VnLz6ZgpLY1Fc9zU2WAiwfLBggUMLQuInb01/QxAnVQFXxYFlhhBfeG6QaQNtWfW0HDqAE/lBuMv9Yfw2Uoneg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760689818; c=relaxed/simple;
	bh=YOIyPpGhS7gwAujGA+QPJSncF9m4l4v9QMVfRtsKLUE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BIbgdbkdXUwBVCbQHUD4MXwpAKJpwI0b0MfRytf4UJMhPbje0JCJYAgKhc6BVf/EXTI8gLcOXcOvrRgIFaTr+r1qprPQzkPieX+3fw9R52qJ9hpV28nRTPLUsX1iT1YzLGVtsekdxkEbXFwhXGV3W3PsLG2NxFq/LV7VGWuT+T0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Ef+/elTx; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=aVAdKwkU; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Ef+/elTx";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="aVAdKwkU"
X-UUID: 7f851d3aab3311f0b33aeb1e7f16c2b6-20251017
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=YOIyPpGhS7gwAujGA+QPJSncF9m4l4v9QMVfRtsKLUE=;
	b=Ef+/elTxdQMHItT1wCmA8qM5TmLosybXrHC9aj2PZzzkbu1449GrzbtGMqj7bMe9yA6+3UQdDvtS4OhoRdxvhEXNjW/wzm8fQYMfB1WuNS8sxI3nYxT/KC0ASw0Y0Z6hOCDuAbQRG6zbZDG58ddCzRuiLRxuB5dy5/m20/i8L5g=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:8444f7b2-ab8d-449a-b220-e4f3911e785b,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:44085286-2e17-44e4-a09c-1e463bf6bc47,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7f851d3aab3311f0b33aeb1e7f16c2b6-20251017
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 466800728; Fri, 17 Oct 2025 16:30:11 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 17 Oct 2025 16:30:08 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Fri, 17 Oct 2025 16:30:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CPGOUblmeo9eEPWSnb5NVAsFDUB3JWlpmDIMNoYyXtsI4uk/IzazniO3jglW2Bn6WCveJAp3pkNo90804th63QusukDDXkaza9dk8Jg5fd2NNQqzpsXZ8ywErRNeuIFSiattMzuHi7mfW+Jd/qBNpGgJE909JotTU4wFSTUExm31AP/qrssLj4+ezKVIBDd4zJ07FSKKpd/9/9L2EiA5epCJlj+qHfXk376E34FVgrnZW8mB85oUuAWBaL6MIgEJ1jSnWvlTqY9M3S/Yyk321CkITGum7xq1n72o37aSGoiTPTE0jzis/0ZN8XhjW1LGNGgwPXg5eJriFAg63QN9CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YOIyPpGhS7gwAujGA+QPJSncF9m4l4v9QMVfRtsKLUE=;
 b=MOTHAq3Q0hDxRPhztORCJ8puqxT0VWxrahOlOzADLTzNXm1y5+bQ5em1gOywHNhf8Wf7eqN2KFpmohi9ldbWRLD3p4kwUIzZOlTO4Llu5yqzf1Lrxd1T1E0tjay/HV3G++aPb5KaavkhK1uLG/T6GLedWzzbwUgyXUJqN7lSP9BOEJhG7YEAAepXtzy67vNGKRuGI0lTE0S+Oo3K6vWD3yodefIS07rvyNVUWy+c36TlH0AgAmPdl/LBZJTDX+WVi4xEPFnfhhpzb+31ofn7ZvTTPbwGPj/HyQtKlveuSbAHT/ksHeO4NUn1rwvzuTWedZgaIMt8NpAANY+NbgSJRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOIyPpGhS7gwAujGA+QPJSncF9m4l4v9QMVfRtsKLUE=;
 b=aVAdKwkU3PZ2BUF7UDD1l2if7QGWBD2XzQQr9MeUs1+xq7L943+1N7uKXU0stua/w3fX2c5rzUw8D8qMgzEh2YIggXBD9QR3tOUEJy4s0YXbi32GfC61Wa5B6wqjydz45XT1z7RcKDXwRhMsxw2qa0vfqXm5YReOtVkFQZDPxQg=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB6847.apcprd03.prod.outlook.com (2603:1096:400:25b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Fri, 17 Oct
 2025 08:30:06 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 08:30:06 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"ping.gao@samsung.com" <ping.gao@samsung.com>, "chenyuan0y@gmail.com"
	<chenyuan0y@gmail.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "alok.a.tiwari@oracle.com"
	<alok.a.tiwari@oracle.com>
Subject: Re: [PATCH 8/8] ufs: core: Simplify ufshcd_mcq_sq_cleanup() using
 guard()
Thread-Topic: [PATCH 8/8] ufs: core: Simplify ufshcd_mcq_sq_cleanup() using
 guard()
Thread-Index: AQHcPUWp3PSIrumWeE2oB4dsU/GkMrTGBe6A
Date: Fri, 17 Oct 2025 08:30:06 +0000
Message-ID: <f1b138adfdb5dde77ffa61f1c0bd14d4e8a225a6.camel@mediatek.com>
References: <20251014200118.3390839-1-bvanassche@acm.org>
	 <20251014200118.3390839-9-bvanassche@acm.org>
In-Reply-To: <20251014200118.3390839-9-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB6847:EE_
x-ms-office365-filtering-correlation-id: dad84a24-45e9-4162-d2d7-08de0d57607a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?L0grVkkzUngxbHJwck1rMlNqeU9PS1Fmd1ZWbkkrWndaeU9vamc0d29PamZo?=
 =?utf-8?B?RU0xZVBPR294Z09hWFNnWnFrRUgzZVAxZkN5OVBLRG0xbUM5anJESytYNGxi?=
 =?utf-8?B?Zmk2NVBOTjdFSDNISjZ3dmt5YnNLQ2F4alJoQVM1S1lIV2oxSU1lZm9xZFdx?=
 =?utf-8?B?MWl1MjRETENrVnFpVFZMbU42WktWVnpYVHh6K2d5bWJmUmovSS90clYrTzFF?=
 =?utf-8?B?a3haVWJMUWlxdENKZzJxMTE2NHl6UGVsYWd4NGdoWWFYbU9yVHFMRldDU2VZ?=
 =?utf-8?B?TUNreHRTN25nNDlPVjFhS29tWUwxTTJYQjJuOEpDSy9IMThNUVF2bjdXSjRW?=
 =?utf-8?B?UTgxUk9hN0d3Y2xTSnNkVFJ6Ri9FUHhZa2pxTysxWmNnMWJQcjlETTBqeHR2?=
 =?utf-8?B?QVlYTjNwY1FHbkVEZzdRYUFiNmZ4SFJRV056d3hUcUtBbkZnK2tPNGM3b2h2?=
 =?utf-8?B?RHFhcUFFcE0vbUhoLy85ZTlPZUtGb2czaVRqSUZWbldjZXVNL2EvcURZUzhH?=
 =?utf-8?B?S1g2MGQ5VzlnbkZxaSsrZkNWYmoxVktUSFlYQkNzUEc0NTh2U2tMckxweTNn?=
 =?utf-8?B?WURHb1c0Y1A0YWFHZkVTOFlHS3lkUnFLZWFNZ1dYYXk0SFdOc2YyY1E0czZR?=
 =?utf-8?B?QytNY1VhUElNTzRBZmhDNzcrZ2RQRGFMNzJCUmVLSGUybTlRLzdWL2ZRUENN?=
 =?utf-8?B?MFAvcVBZTEJJckF3ZVl2bFBPb3NoWW9qOFJjWU1Bd2NuTXErSUVsNGowTC9w?=
 =?utf-8?B?UmdkTHVZWVluRkt6SG1KZWZQOUg4TkdjcnVVMXZLcENLWVJpck83K3kvZlpJ?=
 =?utf-8?B?WnVlM3ExeW42ak1oQzRKdDcvd3g1TzU4d0RwUkVJQTVSUXZFdERBaUF1eWh5?=
 =?utf-8?B?Q0VmNEt1Q2E0TnlNVUFLQWtYOXNDZytxNDdPR1FDZ1JyS0xHR2NheVZ0SUdJ?=
 =?utf-8?B?MlNJRzljd0Q4K3pRN3UrV0xHWFQ3dk15ZnhIL0x1c0o5ZTJvRlpCc1ByTTJt?=
 =?utf-8?B?SHY1MHFTZUUyMjRYZTdpcWs2ZDBlNVZKL1B4bjVGaXRWbGxQWGVKOEdHOXFQ?=
 =?utf-8?B?Nkt3MnRCMEM2Kzd5RlNZYXVvdzZKQlZkcTJwUXQ5TXo0UDFEZGN6UjlzcW1O?=
 =?utf-8?B?andNZ2plT2hnK1UrYmdaOUMwY3grZGNDUmlFM2Ztdmh4Q2E2OU1MajFlZ0Ru?=
 =?utf-8?B?VWN6R1NhZ2RXa0U5VGV3andvRTZlRGxBRWpvcUFuRTdGMitMbks4Z2ZTT3dm?=
 =?utf-8?B?eWtLdUgwUjFUV1AxWDhxWUd4SFpIU2FNSEwrbFFXc1lZMGcxaDY5R21QWlBx?=
 =?utf-8?B?NlB2RTNtdk5WeVd6ZzVIZWo4WjZaTjdubkhsMFIzbW42cWIrRHlpeXVrU3NX?=
 =?utf-8?B?RmRCbGd3dDZjNEs5alVnc2JySEtka1J5U1piQlI2Z2VPSFNWczZ6cGhURkk1?=
 =?utf-8?B?OGY3eFRRY1BDS3c3M0h3QmRVVEdqOFUreUlpckJlS2g3ZUtPK09Od2I2b1Uv?=
 =?utf-8?B?ZnQyZWVLZTc3RVNjQjg1QnNtUzYrZTkrUFVmQzJLa1BVT1ZoM1oxTENjcHc3?=
 =?utf-8?B?aXBndWkwekc1WkpUamNtM2tWNXpyME4wQnVBYmJoNFMzbEpCTm5TdFkrWDRx?=
 =?utf-8?B?ekozZmVYN3JxbE42MTdpOGl2Z2NnKytnUzIrS001ZGlHMVM4dmVsOXhOOEhT?=
 =?utf-8?B?MWZkVlhOU3h1U3NveGhtdmRScHVwdmRucGY5RHljYi8zcm13TkNsaERBbHVB?=
 =?utf-8?B?VUIvbVJ0UEt5eXhDamVVSGsvNHcwR3RTN0FRQ3BjdmpBYVgyOFRRTzVmY3VP?=
 =?utf-8?B?dU9zUFlObXFNaHlycXQxREJSOVJpeTVYVlp4UVozN2lOZXplb3M2YUJpMWxs?=
 =?utf-8?B?Tkt5S3Q2WEFraHNsSzdGeTE1NHVBbWp2ZUlPcEE5Tys4a3YrY0dVK01teUp2?=
 =?utf-8?B?NmlqOHJIeXFGK1lpbm5aRnRXMjZZY043aGtHbnYwdjRjR0tqOHdTL2ZJQVZx?=
 =?utf-8?B?WWN4U0l0WjExWFdNdTJXNzZMT1NFenZmSjd5RzJMUy9vZi9sUzBHM3d6OVNi?=
 =?utf-8?Q?L64MHi?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T0lvOEkxdzVzTG5WMTJFTnRLZ0lkRTM0ekJVMURVSCthOHBkc0hsaXl5UitZ?=
 =?utf-8?B?TDFKSlRNdWFZeGZWSkphbmVmeXNVUWFxRzFyQVNRZ0NMcDRVd0d6L3pXYjFB?=
 =?utf-8?B?QkpnVDFrcUF3WE51RTFOaUdCTDliL1ZDUEUzWnNTT2c3S08rK1JvNnlQQzYz?=
 =?utf-8?B?RWJUVFpPSnhBMURMWjFlYzBMMVRqdW1wT2VZektuK2UvWHZhdFRuODBvRStR?=
 =?utf-8?B?L0owaHJSeFU4U3ArT2FJZTM1bUJDcmRSTVFlMExpaExJa3Y4aEF1aDZ1WEFh?=
 =?utf-8?B?clFRS253WWdBclNNTnYxa2NoWG5WTW1mWVZKcERhRUpwcFh1ZDBQd2syanRD?=
 =?utf-8?B?dWUzWkZMSFlHSzdFV0lpN1BkYTh3amExT0VBaVRHSUhMU0V4L20ycmlmZVRG?=
 =?utf-8?B?czF0SWsxS3huYWpPanE0Q0RwQTZMejEzVmdoU09Ga290aElScUdIUEpQRkl6?=
 =?utf-8?B?SnlIdUM1eFJlbDdBUUJFU0RIQkNYL1lrWDFoSTZVSVpGeFR5V0JsVTZSQnJL?=
 =?utf-8?B?NkFvTWNpdUpqY01nZnpZcDRXaWhON2t1STExTmtkYUNXby8wdnI0QTlUNDZM?=
 =?utf-8?B?UndIRDVSRmZZNGNTdG4yRWZ0M3YxSGY0bWUrb3pLMDBvaHRBNWNPMnVCcXI2?=
 =?utf-8?B?aUhibG9ZYUtEMksrTlkzRjJ5cDV5WkdNOWRTZlYxTFVpMU5PMkdKbE11WjhP?=
 =?utf-8?B?UCtMbTFaWWk5NklVS3RsVXN5STh1clJRbGd2OUpoUUt5TE5kK0VSTEVRMHJE?=
 =?utf-8?B?eCtwZHZTMVdNSTduRGdPVEpHckliTnE0V0tqc25wOGF6aVZqeXlMUEZXV0Rq?=
 =?utf-8?B?TWZFVU1Rc2tJOGtOM2RCOXgzNGhvazZPM2dRbzhjOWF4Vm5vRFZQNlNzOEs3?=
 =?utf-8?B?TTNWTlhRaXdqeEJUazBhRFJwQ2hvRHpQb2dhOUx3R3J2d0J4MDI1S2VqNklt?=
 =?utf-8?B?NkJxR2xuQ0lBbEdZUHVLMmFVLzU3WkkyTis0elVRU2s2STVwbFVyVmovRWc2?=
 =?utf-8?B?elNpaUxCK3ArSEhVbWFGeHZSOGR5eHphY0FubEo4N2JWRzhLMmpNWkhvRS82?=
 =?utf-8?B?WHY2UjBIWndaTlRYMFdrRlBsbTByaG5wZkdVdkJ6dlYxRDB3dVdSSkVTZExH?=
 =?utf-8?B?SlFPdE96NlBTaGNqd2h2SUxSTjNFM0kvcVZVbmxMbnJncEJ4czQraXFsMHFX?=
 =?utf-8?B?eWdTL0xYR2d6RlFYZ0R4Q1JnMmt4MFYxYkVsYVlNZmc5cFUzQmx4RFlPSFQ1?=
 =?utf-8?B?UjN0SXQ4SFBpaGphdVlYSm00QlprdUt0dk91T0hSRyt0WnR6S05wVlU1Nm4w?=
 =?utf-8?B?cmR3WjlXbk1PTlE1NHhoZzkwNE96UjhBeXYvUWxka1JuTVJ5UFJQUmhaOXVk?=
 =?utf-8?B?Q3lFbVlwdnB4am5NMFhBRitTQVRTYXEvRmdpNExqNHJxY2ZteDNhZ0tZNXkv?=
 =?utf-8?B?S1FIWjVoTVkvNjFnakkvZmlVUXg2R01pTHpPTFo0a0oxZzhFTUZSSHJCbVl2?=
 =?utf-8?B?K0F6UFpxcllZLzNSRHdabC9yU256clpCY2JzSmZycDVvYkgyRDA2Z0wzdFQw?=
 =?utf-8?B?d2dzdGN2ejYweTlFZnhqQkZxL3EwcEdFeEJDOFRzK2lEdktEcE5lc2NkMyt0?=
 =?utf-8?B?S3lCQUpjMnA0UWJ1R0djZGwvdjU5cjE4Sm5vUXhOY1BadHVWY3RaSDFHVFhK?=
 =?utf-8?B?ZlBCTGNHdVJpd2cxYm16UUV6Nk1DRHUzbkEyelc1T2JIUGQxZFpodlFqK2hm?=
 =?utf-8?B?WE5OSnZnMWpURm9VdUFPNXE0VGdPdUJzRE5WbVVHVHJvd0VKWWIxZU1DNzYv?=
 =?utf-8?B?Snp5RjB3Q1lnRkZwUkU1WkRKT0RSR0hzL0cxK1ROWm45RmFWQ21qSTEvWHlw?=
 =?utf-8?B?dDEwOGx5RDk0NXlTOHZsMlNBbmVXdTJmK1VWZXZscDg5Z0QvSldEdFdLU1Bs?=
 =?utf-8?B?bTB6MW1YZmhSNThQTFRzd1l0bUNCUTRkR09acG9CemJxWTJ3ZUEzRXZQbjI0?=
 =?utf-8?B?S2FyM01yOEliUS8wSWlrSktaNHQwbTVsaUhVeXNhNUhhWDRaNDUxR2lEVk12?=
 =?utf-8?B?VTFLZDYrZDQrckxlQUwvdHNvRSthWm1uS0NGcVIreGx0RzFpc1Freks1Mkh2?=
 =?utf-8?B?a0huendibEZDSHdxNlBhSlIvaUl2cWoxR3l3Z2txZW5ENmVHS1U0K1pnUVA3?=
 =?utf-8?B?a2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EBB509D967F96D4A82F0E55069E7CDFB@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dad84a24-45e9-4162-d2d7-08de0d57607a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2025 08:30:06.4551
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GTacu5CDeZmfGH6YtuqIUup1MCFX5xCPtKrPNHScOKInLXWrqdZopPHPK9jbdD00+8iKU0eWxnvOpEOu9zPuRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB6847

T24gVHVlLCAyMDI1LTEwLTE0IGF0IDEzOjAxIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IFNpbXBsaWZ5IHVmc2hjZF9tY3Ffc3FfY2xlYW51cCgpIGJ5IHVzaW5nIGd1YXJkKG11dGV4
KSgpIGluc3RlYWQgb2YNCj4gZXhwbGljaXQgbXV0ZXhfbG9jaygpIGFuZCBtdXRleF91bmxvY2so
KSBjYWxscy4gTm8gZnVuY3Rpb25hbGl0eSBoYXMNCj4gYmVlbiBjaGFuZ2VkLg0KPiANCj4gU2ln
bmVkLW9mZi1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQo+IA0KDQpS
ZXZpZXdlZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQoNCg==
