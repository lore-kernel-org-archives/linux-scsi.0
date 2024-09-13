Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3138A623
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 07:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726211220; cv=fail; b=OH8jNLRCr/Cwc3nDeu0EyP1WkzKXz2MDh9FgE7omxMbYf7qeVYxCGPqbyH5i8B1KPU7RXJiBzbBatsQzZsuEPbYHaX7bO6Pna6XbpydJfOCb4dm5B1ttbOr3h1A+I+0dg+WeR1N9shsJxvyoiAq03tU3m/je0ew2Obh7W2JOsu4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726211220; c=relaxed/simple;
	bh=9bh6jpmI49xTO+ml7Q89ruT/iKoVeA230XJq8+GyBCM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tygSkThHg2MSg6/tpWRNH1AYIGDnzVxeRviQD8tNkW0lwGPSuYEzCPuoHdV5aYIWAPz+GEvZS5YdxvyS1CxSqkuVQDC9VDxxCdopu6GtUeZecJMI9Y1itUlnnbxizOKV2BBtK6ksKIsx12KEZbOhs7W3CK9n18tombdcl0/zZ/U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=BhOoCogq; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=mpFF7WNu; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="BhOoCogq";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="mpFF7WNu"
X-UUID: c09ba534719e11efb66947d174671e26-20240913
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=9bh6jpmI49xTO+ml7Q89ruT/iKoVeA230XJq8+GyBCM=;
	b=BhOoCogqLDer2aEkgtLNQpYVd5h4bELMuGY/wusSM5FcrN1ZwSCtvPWAfV4QI0wonXwXqFABhOfin0nxzR/n2SZ5Swn9R5ak4TTw2XLY/RP6ji0XvDr7dIwpjDEFQ2UTkZO8rNxXOyDiXFOsfTI7Urgr44A1tLVC6ypwtI+WZb8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:4a81752f-4ff5-404e-b18d-34850c56eb72,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:0256e8bf-d7af-4351-93aa-42531abf0c7b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: c09ba534719e11efb66947d174671e26-20240913
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1893562872; Fri, 13 Sep 2024 15:06:52 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 13 Sep 2024 15:06:50 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 13 Sep 2024 15:06:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S7j+MY4nJZR3tOHarBaZHxHDjlH5UFumDoEU9ivGeqO7TrZhJnvaelkWGqd//5ExuFXIybU84f/ay6Xc1gt9ymIf4ANK1Sn7/rUC75ars8MeVlj0UCseCuAszgPqye2C9g2Mi22uNcbArb4iqVJGb4mW7eRTcdEK/eOg+s6uaUS7werdj9d+StsaMbulniCwmiox4nG7vHJMABhpiskjTwBTQ38kHPsPposm1enWUMXo/aPr+O2jnM89FsiNQpo6uNrRB1Vy2yZr4Q6IYPA0AdBwPz/hSffjeDR4Uq2OC8YkPZ5u0z3+n9KmA7+38eYOMRb9ytakxZVTNrc2aeH1dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9bh6jpmI49xTO+ml7Q89ruT/iKoVeA230XJq8+GyBCM=;
 b=D8p6/nCACGFUCvgAAxkYQVPAvt1J0Z3KccWhxCFlr2VqxpugHglJdgmoMxk6k7iTvmsVEHoc+aa34F7utqEstPdk+UcBp/pRPvwuEqNod7Klf3JKQ/SAIQmWihevGYLPQgJsHdWH+hppQXgw5AI8OYJqHO88+1ZjG5Z47EBPpF+WHul3kiZodck+psFeyb7sKDgSt5Q2hmfrcIee1ORRA3N8B9gNxe5aXujUWxWfTmDyCDqVz7gkMVjxaCK1M4Zli+bVGArQTmT4Fgd0VFdvAtELiYnEB7W3pPFbvaHbKaMQdDiiAumq2yRdo39y4X+g6RwItvMw/aQa8ZZFU09qYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9bh6jpmI49xTO+ml7Q89ruT/iKoVeA230XJq8+GyBCM=;
 b=mpFF7WNuA4j+rPCc5RbOZYFtyOKCvTv6/ssgqK99XT05LCKxk+aSCZYq1uR1UseOTrBR7TIvZn+cNSsgBHx2l7YzIVUX89/G8cKvmO5LHCxHvgAtgvuiHU9+mYTNU6vm8vAt21CsMLX9HT8Sq/1T9JIPfrYHd/UNUBeBHtUNNXM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SI2PR03MB6616.apcprd03.prod.outlook.com (2603:1096:4:1e7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.19; Fri, 13 Sep
 2024 07:06:47 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7939.022; Fri, 13 Sep 2024
 07:06:47 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "ahalaney@redhat.com" <ahalaney@redhat.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>
Subject: Re: [PATCH v4 3/4] scsi: ufs: core: Make ufshcd_uic_cmd_compl()
 easier to analyze
Thread-Topic: [PATCH v4 3/4] scsi: ufs: core: Make ufshcd_uic_cmd_compl()
 easier to analyze
Thread-Index: AQHbBWN8cixNT0oANUWrVqeUEDl6OLJVTDYA
Date: Fri, 13 Sep 2024 07:06:47 +0000
Message-ID: <73d686250c6463c22e9899c72b959ad2bfe0d8eb.camel@mediatek.com>
References: <20240912223019.3510966-1-bvanassche@acm.org>
	 <20240912223019.3510966-4-bvanassche@acm.org>
In-Reply-To: <20240912223019.3510966-4-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SI2PR03MB6616:EE_
x-ms-office365-filtering-correlation-id: 43132523-345f-499d-83c3-08dcd3c2a208
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NDRFSDZMSXdHWXpQTSs2RkxJZHBBZ1Q0ZGYvRzVPRCtsYktEaTVySi9xT293?=
 =?utf-8?B?aUE0WUt0UkRjdUs0czJ0ZkZ5R3ZzZHIrMVRhTUVzM2xYTmFwaU9aT08wWUNz?=
 =?utf-8?B?WHh1U29sTUVHV01TdWxpZU1zMnRQZEdDSDFOS0hZdTVRdnRaTGp4TTVvVVhp?=
 =?utf-8?B?RUg4NnU4azFTWlg3ZkZwL1BCTVEzRURJR1VGRGQzUTFuQ0xJT09OeW9CTGhz?=
 =?utf-8?B?ME9kU2dTNnlDWmZ4MVpIc0JGT0pkcEJJOStBa1kzZlBldDFQaXBhQmlVcCty?=
 =?utf-8?B?QVZGR3NQaU9qdlNjalE0UmhzN2FYbXRrSlBCVndTNW5vZ2hHYkVIZXJrUnM5?=
 =?utf-8?B?aU1abE5sUU5OZ1JaN0VjUUVtV1NJYnVrRytSV3d0RWxSYmdSZDF4SlhqTjdw?=
 =?utf-8?B?RWtIN2wrLzkvWFdUeXV2S21idzB5ZWtTQ25UWUJBN2NnNENwUldqc3B5VXM4?=
 =?utf-8?B?YTV0amhwSUR2U2swNTVBd0JrUzRSM09wVDBJTE5Hc0lwRnBmZHR5MzJVMHVX?=
 =?utf-8?B?OGM2T0JJSHFYR2wrNHV6ODJDcyt4amxTYWp3cUJhQU4zYnhKRGZRS1c0Ulcx?=
 =?utf-8?B?bVB5TFk4azNpSDdRbEFTeGlraGNKYTBOQ2lVd0NEWStmRExKbHVnam1rSHdN?=
 =?utf-8?B?Qis3SGhjQnBIZVV6Ymc3MXBweFVaTENXSW8xSi9KQ2lCV3IxMWlPRVVzNHRv?=
 =?utf-8?B?RnNSV3R3YXlqNVhHUXlFZW5lbUtCUFA3eWxYTzlHTk1UWnZWZFNLdUFOa3BH?=
 =?utf-8?B?Yk8yQmsvdnVtNjRIeTRIbGFBSGZrR2Z1eE9TU2lJaUZ1MEt5L1g2VzFEdVJj?=
 =?utf-8?B?SWlaR2VLbjVNWS9ZMEUydElRR1N5SktBVXlyaUFxRWtVQUg0UlpCeXFwMzFG?=
 =?utf-8?B?SXQ1dS81ODhJd1JxMkhVUnVreFpCL3ZQQ09zUm9sTUNJMTV0ZEU2M3dzQkJt?=
 =?utf-8?B?R1htVWV3Z3YyZUVhVnNJQmQyWTBwQ21zK0c5eCtXcURKQXhaWllwL3gzNHh3?=
 =?utf-8?B?YU9WOWJpeHAvaEtwdkJyQW00dnhhMzBTWGZDcUdHUGFpNHh6RE1EeDdLMlZB?=
 =?utf-8?B?NnBaMUdLUGhqMkNzK2NTdXFvU2YwOXFwZ2Y1OTlnOWtDT2FxMjNTUEhpSWIw?=
 =?utf-8?B?Y0hnbHUwc1NNbVh3Uys5QVd2L2c0alREN213U0JRRHNSQi9lbzBGd0MzQzJV?=
 =?utf-8?B?WEpjL090WVkra21ibTNPZXRLOXJ2Z3A0MWkyQjQxaTkvWldOZUR2N29jVEVz?=
 =?utf-8?B?aG1IMlNoek5NZkJsaTRtQmk1Y3RSSURuT3VyRldVSGpqQmJGMUlGTkVRUTgr?=
 =?utf-8?B?bVZiMUNOL2czYVlwclJ3ZkdxeW1sTC90WEt2Q0lTVStTRHp5eFJKRjlDalhY?=
 =?utf-8?B?ZHJpNDdyOXkvRG1zYkhGR0RpNGR2SFF1cG85Znh3YWZtVmdGMXBTZTZPeVpU?=
 =?utf-8?B?Z0FqZ0ZBazUySFh1ZU9HVFRHNmdObGsrdnRad01OU1k0ejNUaWJHajlHT2JZ?=
 =?utf-8?B?VDZkRHozMDYwZVQzZ0ZMMzlYT0xpN2xRbGpUZUhzaHZWNUVpU2FuK1NCVCs4?=
 =?utf-8?B?cmJxazczZGR2T1M2SzJkWU1FRG5nRENBTE9HTjd0SmJVZ1BHL1dzWmRyT2RQ?=
 =?utf-8?B?ZEIvdVBmc1NBU1pwN2o3U1lBRVhkeFRtSnZOMmdzYy9DaVg2Nlpia1R0QlBG?=
 =?utf-8?B?cktmK0t6YUJHQUU4SHFHMWh6ajlBNWtlemJkYzR0aHF3TW5JM2MwNk5sYlow?=
 =?utf-8?B?azcybE5VWmE5RWxvMmxZNDNOMUY3TmlsSHNrSTZQZHo4dGpXaUMvYWw0cTZy?=
 =?utf-8?B?RjJDZEJLYnJPTE1NRXd1dz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WWsvSlZSY2VKYnI5YjVTRFpwSk9BRTZhNDZUcTc5QWdSWmxhb0RqSUlvUzlo?=
 =?utf-8?B?RDhLK0owUlJybVdyWnFKdnhwazVoL0gvbnQ1dW52MFdNSXg3eGFoZHNnamxY?=
 =?utf-8?B?L2Jtd245aC92THIvcGV5MnhZSzJpS0NxNW9IaU5UYUZZOE1GNzR2aExLUzNt?=
 =?utf-8?B?cVBRekpEQUsySXJuUk9zVStBelp6Z1pUdGdDWGJ6VHdRNmpwbGsySVprM3gx?=
 =?utf-8?B?LzJ2VFJCUzh6Qkp5UGd0NWZ5R1QyL1dIUlNLNjhWQk1BOUgrKy9rZzhCSFBL?=
 =?utf-8?B?SVJ4MEtWMnQ3ZE1YV1RDV2Jmd0wrd0QyM3ZndE1RTmw4Z21WV1hBa3prK2Rh?=
 =?utf-8?B?Tks1Nkd2THBHYmhVL0s5N0IwOEZqRm5qaTFKZ3NSc3V0UE9SemVBdWh2dWll?=
 =?utf-8?B?UENSZWxSRDFXOVFsaHJkZnBtd1FDMTlrWFE4WUUvTHVCRmhQKzVpUnFJdytW?=
 =?utf-8?B?N2t2Y3doVVNJclJlUURlc0QwN3dEVWwvOGM4T0trTGdZajlicW5NSitWTUpY?=
 =?utf-8?B?Nk4yZzhmWnNxQ0E0U2srRUpSUnJLRmRZZjJLMnVoQllIQTVUR001Qk1SaDFF?=
 =?utf-8?B?V1RxSzhJNUw0SElOWWlpMVM0TTBlR0pTbjZObTY3ZmNtN1pCWEdibU9pZnB6?=
 =?utf-8?B?UEtuVFIzNG9UZStsZDdBTWdTVmxkblJLOTcyRjU1ckdXaVFCeTAxY3dDQ2Q1?=
 =?utf-8?B?cU5sQVhzWWhkUVVtWmg2S1F0akMyVzB2TDd0TmJCYm84VTM5RnJxdWVERUNs?=
 =?utf-8?B?TitSQTFEalFnVzRTMHRaZGZQUVJHUkRwZDEwOHB5WVVjRjNySkMrbUFrenFL?=
 =?utf-8?B?b0NLRFdLZUZnQTJnOTk1V3RERXFtOGprMHZuc2c5RDYxUVdzRjZ4MEhhSHZv?=
 =?utf-8?B?Y1NWei8vRTZFUWxHQmVuZ1JWYmhrQ2psMEU3cnIycCtzVWdTdldZZVM4YmNF?=
 =?utf-8?B?SDBreWJhUENOdURJN1Z4OXFDS1dTL29RK3dUdDlRYm9LYUtlWm9LT2lzQTN2?=
 =?utf-8?B?WE5RT2k2V3NNTCtKN0JXR2s3RjFFL2MyT2V0RkVoRWNwcVJ3Qmp1ZWhmMUhC?=
 =?utf-8?B?cXQvei9KMWFHWVdmeHJRSTFDdm9yY1dZSHY3SjVSeXhHK1dOQWVzWSthdnNZ?=
 =?utf-8?B?eXRqeGVGMDFEcWlXL3M4dTMxaDhMVmtuaDl4VGJEdmlSNE1Yd1diWTRneG9C?=
 =?utf-8?B?aTRnN0paL1A4TjhoV0dVbW5iSVNtanlEZUxKcTZwT1hDYWFqSE9BcTRwQXdt?=
 =?utf-8?B?dUE1RHJsWG10dnBReDBSMVJuamV5ZUdpL3BoOUNlcW0xOVRwSkd4SjFCT2tS?=
 =?utf-8?B?Umh6ZUdnOEdMTEVJZzQwSVRGb3FxZlJ6b1RHdE1FdlBnelFnQkZxMnA1NVNi?=
 =?utf-8?B?TVJuVytiY3hib1NaQzBiL3BBOEhKUjAvWU5ISDdaM3cxYU9oeUkxNHh4R2lY?=
 =?utf-8?B?KzA2dTFQZGFpcStPQlNCWHVkb1FYTGdYQzJwbXc4WndKZHlZcjRKMlpWZldR?=
 =?utf-8?B?S0F1MVVtZU8rQUVXWGplRDRpTVp2U0RNUmRuUWtQUnZ1OVVCbFRmUEtkNWNq?=
 =?utf-8?B?c3ExZlpZNFBycGZzWHllUit2dVlZR0JqbUczSlRJZElQdGdlMjByQmxrUXFm?=
 =?utf-8?B?MTdScHd4TDVnKzFsS2pFM3h3b0xEQlNER2VBNUo5VDRzaEtoNk0yeitZdFE0?=
 =?utf-8?B?VUsxZlFHeDN5SU5Gd1dCVkJ1ME01QStkUVIxSllma0crWXFpKytFV2d3azNS?=
 =?utf-8?B?OSs3MFVxVGFhQmVWVTgraVdKRThFQmUybzdhblB5aGRSV25tQUt6Nlo5d0ty?=
 =?utf-8?B?VmVWcW9pVS81NEJteVpZdlhlWDJ1OHNLOFo1Mi9jOVpJdVNWd2JEYXRxcHFz?=
 =?utf-8?B?T1M1dXFINThHeHhkY2V5U25LUFAweitCY0psbFpYbVByeG9KbzVFMERHU1pq?=
 =?utf-8?B?dlVyRis4Smt2RHdUdDBmc0drK0FHUndHdTdSd3RwOU5JYW5peFVkUitvNmw0?=
 =?utf-8?B?NTd1SWk2bXFZNEZObG9NdHc2ZnBUWEpydUJZZ3gxUUhnL3dqOUhzV3U0ZWJq?=
 =?utf-8?B?bXhJdm91VURucjZ2Yzl3UVNORE1nUXpyQ1FGR1ZXSnZ0dUFZVElPUjZlNlBM?=
 =?utf-8?B?Q1NONG1HQVEzcWRiSEZiWk9rUCtvdUZQdWd0bU9HYmk3eXVLTVVLMmlhWjhX?=
 =?utf-8?B?b0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CAC82F75C1F30A41A1E58858845C9AB6@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43132523-345f-499d-83c3-08dcd3c2a208
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2024 07:06:47.5318
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2SSzAmAKHp09IECm9ptSE1Qs3lqek1JsPw+9LlhIgREP0HT/3ldHqO+/FllhPd9qHrqcbkm6zzR3G5NpkmWnjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB6616
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--15.046300-8.000000
X-TMASE-MatchedRID: Y6GLOewO+JjUL3YCMmnG4omfV7NNMGm+bkEYJ8otHacNcckEPxfz2DEU
	xl1gE1bkfdd9BtGlLLzx1uczIHKx54/qvvWxLCnegOqr/r0d+CxAq6/y5AEOOslgi/vLS272MJM
	V/Fqds50a60S5yaTEp8DPDA2+oXjO/Guz40Ud3KRGWpKGpvfmnoEcpMn6x9cZOGCgDN6EbfZdHL
	0OBPA3VGVGaPxFYgIXkZOl7WKIImrS77Co4bNJXeU4o2G1kX9CZnzlzlK1OJdQSFbL1bvQAcK21
	zBg2KlfAqYBE3k9Mpw=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--15.046300-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	744D42CD5E8153CC398F177430E437F8BB64D0EDA5CEBA70E248714A688E0F142000:8
X-MTK: N

T24gVGh1LCAyMDI0LTA5LTEyIGF0IDE1OjMwIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgSW4gdWZzaGNkX3VpY19jbWRfY29tcGwoKSwgdGhlcmUgaXMgY29k
ZSB0aGF0IGRlcmVmZXJlbmNlcyAnY21kJw0KPiB3aXRoDQo+IGFuZCB3aXRob3V0IGNoZWNraW5n
IHRoZSAnY21kJyBwb2ludGVyLiBUaGlzIGNvbmZ1c2VzIHN0YXRpYyBzb3VyY2UNCj4gY29kZQ0K
PiBhbmFseXplcnMgbGlrZSBDb3Zlcml0eSBhbmQgc3BhcnNlLiBTaW5jZSBub25lIG9mIHRoZSBj
b2RlIGluDQo+IHVmc2hjZF91aWNfY21kX2NvbXBsKCkgY2FuIGRvIGFueXRoaW5nIHVzZWZ1bCBp
ZiAnY21kJyBpcyBOVUxMLCBtb3ZlDQo+IHRoZQ0KPiAnY21kJyB0ZXN0IG5lYXIgdGhlIHN0YXJ0
IG9mIHRoaXMgZnVuY3Rpb24uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUg
PGJ2YW5hc3NjaGVAYWNtLm9yZz4NCj4gLS0tDQo+IA0KPiANCg0KUmV2aWV3ZWQtYnk6IFBldGVy
IFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KDQoNCg==
