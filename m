Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F223C224CF
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2024 05:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726034305; cv=fail; b=fwJ5skVf3UyNKFA7/mjjohkHA0sr8Z4gQyIrge10QOW5g4aWr2ExsWLs6lkNvXZESx+rRkB2ndYJwsLYl8t4wL/WfQ64ksmif41fZubP1OEh9c2zQeZlAhsl/jxh1sQns2EZO3U9XkawIWNefKIuO2AIma9sjAHgIl5nKUms8hM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726034305; c=relaxed/simple;
	bh=JDg/ZKfUzs5olsORjkhTasPACOMs8whBqdo1ymc93fc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SCjvccp8a0jHzHzL2qvNmsy29VexdSMHf4gfxj/2DrK6A6AJCmLThLDn/F3Toj/U/DFmoGMAxQODNFKn6kJOkDJKwUKBMQSG2tUYG5pyVhnRL43aOFykE4OEwe/O5ums8+VnG0LuEg5vxKGEGmGy55CbuawSqcWGnLMDw3AyPTg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=aNMHOtpQ; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Uy9vr4FX; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="aNMHOtpQ";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Uy9vr4FX"
X-UUID: d3519776700211efb66947d174671e26-20240911
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=JDg/ZKfUzs5olsORjkhTasPACOMs8whBqdo1ymc93fc=;
	b=aNMHOtpQUK7TYCv8HfYKkyvtcKOHiov9seie5LEm6LAa9zKGm9rPC1UKs1J3KgBtwLM7/MDuUAg909KkjhMahpYTxZrfd8UKRMjq4XwXw4VdufqCC3kj/87VUw2d0NYNZlD91s2TAelXfAy2i4zhTKPmIpsIlxxb8OCoHeYuFho=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:0db03c0b-301d-4fcb-bb5a-ab9c9eacadd4,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:8ed6c7bf-d7af-4351-93aa-42531abf0c7b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: d3519776700211efb66947d174671e26-20240911
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 560102482; Wed, 11 Sep 2024 13:58:10 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 11 Sep 2024 13:58:09 +0800
Received: from HK3PR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 11 Sep 2024 13:58:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fYjmup6loMVWNKNrkFKjjhoNN2VZEwaja+fiIADgLy54bqbdXVrefkyiVRpQchf0y3k/yxdK7l4RTeyhPRMebzzpw904GxM24M4MpeXxoi0B1JTJv8wVf/aQ6NTsiBLuFF+ylgsBXMNNFy2tSR/jgYlfrqVyvLg/DKD5z6K3mAANm0xfXxbBOoYBHKe0r/duOREMqWm7EJa0cFvbeRzK7iq2w14uNPQNz4LFYgwHHv7TXpkmXBy+KsEzNgnAtl65FDV4vvXWZU/9LEz5fIxB2mr2yND5cRywEzgKwNZip1WUORk5oieYF5LnTauo7arnk3d4/vNXTcfZTsYt7XHPNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JDg/ZKfUzs5olsORjkhTasPACOMs8whBqdo1ymc93fc=;
 b=mpoTaTGI4ryWf9rdvYupFJifpFPHgzvTJCcq7AVu3PYgrVRHlTzbPiZQBSgHMeMqpgBLKIea1qbVsZhNLuVqoiNWdnIMNu1z8C3AVjtHnDuLKhSV/6iHtB+8jGOaVGaY6C749IXPj0enrhPjbbH2/9X3j666LlGXy4uSKhlMtsgDeOmuDK4PgqKlB7hFvsacLBnDwa3okEnTwPKGGTaxRAdTsYkfpfU4XloO0rCvgRGWnIOLzVuWxJm08FkBqoAvtMhjPVl2pGFbs84N4xKUsdWSG0u3tyt0s0XLbr7IfxIv/7YqozJGNnGHK55KPP7CQxeVXlKxkl0uoSUD8OEyhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JDg/ZKfUzs5olsORjkhTasPACOMs8whBqdo1ymc93fc=;
 b=Uy9vr4FXdSMybgRrhPNlV+LB3s2OgG27hK2YypBVjFKL89nCgloGZltt2g4uBD71NKH0A4gsksTxNbpQ/HJznLt0Ktc8h5iVsh77AmiA3/dNrw7tZhzyWKNdlY5inVlWTWNCXvkFPmUQyPWAD8DOjf0xAO/MTyQbksG7KsOZdvo=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB7705.apcprd03.prod.outlook.com (2603:1096:400:40e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.23; Wed, 11 Sep
 2024 05:58:07 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7939.022; Wed, 11 Sep 2024
 05:58:07 +0000
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
Subject: Re: [PATCH v2 3/4] scsi: ufs: core: Always initialize the UIC done
 completion
Thread-Topic: [PATCH v2 3/4] scsi: ufs: core: Always initialize the UIC done
 completion
Thread-Index: AQHbAw3IYhBP2chAckuHwldEtq/XGrJQ9XkAgABH9ACAANubAA==
Date: Wed, 11 Sep 2024 05:58:06 +0000
Message-ID: <e7362aa96e27538fb154d926d4fa4134ff6bc500.camel@mediatek.com>
References: <20240909231139.2367576-1-bvanassche@acm.org>
	 <20240909231139.2367576-4-bvanassche@acm.org>
	 <cc8434bc72a8f015acd2acaa6dc9ad84d7c9d76f.camel@mediatek.com>
	 <ddebdbc9-0866-429c-985c-0529ddb4c1ef@acm.org>
In-Reply-To: <ddebdbc9-0866-429c-985c-0529ddb4c1ef@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB7705:EE_
x-ms-office365-filtering-correlation-id: 46ad571c-4f2a-4f26-8d4d-08dcd226b546
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YUZHeWJDVUlZQm5FdHRyYmtsbldRN0RuQjlCUzRIL2F1K28wMFNiUEhiS0x3?=
 =?utf-8?B?RU5BS2o4bVNmc3ZhNjFWam5zUDZXNTY5aFpFTlBBL2oyaXdyZXZiYnkzVWpO?=
 =?utf-8?B?ZDU0Z3BnY0pOU1h2SU9FanFrMjlmZjNPTnJGN2FKR09FZkNwU2RVZ0F5endB?=
 =?utf-8?B?KzI1VzQxMFVGT2RpMEs0VWpLa2ZxNzk3cGVvc3BXeFBKdDRZcWVzYXd5Y3Zn?=
 =?utf-8?B?bmhSZ1M3UVJDL2tCaWttNzZMdmlpenNmY2xsdmh5dis0di9RQml5SDJMc0Vl?=
 =?utf-8?B?ZXFTaStMWGNIU1F0QjlLbXkrODkrYVBHR0lNTHRlNStxaEs5L1M3STA1NTRn?=
 =?utf-8?B?VmhyWTYveVA0UDBwbzF1WWVRc1BDcnNOZnlKZndydDVwamJQS1lYbjYzbHZu?=
 =?utf-8?B?WkNNc2Q3aGdjR1p5MWNLdDVodFFiTU5adGxON0dEZ3UwOVJzekF4bHpUOFRm?=
 =?utf-8?B?aGNVU2d0VS9NTG5lYmR5ODYvZkNhQ1c4OUp1cFFKVUhEQTZwRSttbnZZelhq?=
 =?utf-8?B?eTN1YjFCUkIzb04zQTNhbGlHV3hnalU5ME0vQXZUSk96L2h3RGQ0ZVpPWExj?=
 =?utf-8?B?K2VzbHBPMHBKMWZMWWZ2b293SStMRGpYalplU3pmMlJESlQxeU4wNTJLY3c2?=
 =?utf-8?B?NzdHUzFXbGdVd2pjQURIem40MjAydEhOV2ZFZFlteXdIT2NzaHBiL2h2dWts?=
 =?utf-8?B?RjFyNUtiaE96ZTN4eW1JQlF0Q0Q3c0ZMcUxXT2YxOGI2MEliekJheTdGSGNp?=
 =?utf-8?B?RmQzcjM2QVdYazVoQzJubHRnUk1UaGJEY21TdXltN0tYbzV5R050VmQzcDZ2?=
 =?utf-8?B?WVVyMTFpRG9RTDFKbHdnUGxScWI4aG9zaExnWTlYWHB2OTN2MHhBM2hPSEpP?=
 =?utf-8?B?K082WTBTUE91ME9TOEt3YU9oZ09YUTFROWRnaGJQNWVDdmtvNFRRODR1QTll?=
 =?utf-8?B?SjNHeEJhVmxhM1BGOGpnZk9tamczeC9keSs2eGNHYUN6ak44TFZqNy9Ec2tM?=
 =?utf-8?B?SEVraEQzNEE4WTBXUVZsdmM5b29obEh0OTJYdFlMQnRNckxvd1B5UDljd1JU?=
 =?utf-8?B?Tktnd2NQQ3c5cXFmT20yYngyZWF2dkN6SlNCL294YnJkNmwxUU1JWS9od0Fx?=
 =?utf-8?B?eVNZWk95aWp5dUhRWExoYlAwMUFRYy9WSzlZMVlNVTJIUmJPTVZlOURoMm5V?=
 =?utf-8?B?U0w0YXdJVlk2SktRLzFGUzhHSmJXRmI3UFRZM0lFbGtkeFRBVWp2MTViOEhL?=
 =?utf-8?B?OHhCaGF5RkRVOG5iVWZTR0oxWUM3RHJ5dHU0UURQZCtiR25GVXkvQ0NZTnB4?=
 =?utf-8?B?dmhTcWp2Z0Z0ZHNoYmRLcWY3SnZRMklEUnNVQlhXQkpDdGpycnhqMkpldS81?=
 =?utf-8?B?VUt1SXNZMFh6WjFmaFcrL1BoeHptSS9jaXFLazI1WjM0eXZOSlo3d3BYY0ox?=
 =?utf-8?B?YW0xMUJJc1prTEhOZ1JKK1Y4MitxbzJzZzlaVTFseVY2U3l5T2ZNNUV3ajBw?=
 =?utf-8?B?dlVmeFQyS1g1dnJ1N212N2ZzTktrSDY0eU1vQ3J1ZXllRnYzMlp4c3FXQ2l3?=
 =?utf-8?B?M0tEU2pTWXczeWJnektNNktMQmRpYitjOVF5UzNIc0ZxQmxMUnp6b3dPekR3?=
 =?utf-8?B?ODQ3U2R1VTdubDcwWmd4TXJTcEtPMEJJakxvTGF1VERDdUI1K01DZldlTkt6?=
 =?utf-8?B?RmszYzJxZGJUQzdGVWRqbXlzZ2Z6TWJ1Um4rN0FTdEFLK2x0ZUpHVHlobEFO?=
 =?utf-8?B?clEwRTQ0Ymk2blNLaTR1aDZKdDZCcTIvUFVvUW04L3c4QVRhUG9XL0FPZ1BL?=
 =?utf-8?B?ZmFpcXUvZW4rNUc5Vjhtd2NpbGFUOXNtd1pNQ3l4cEdkRWtVeEg0YWVrMXBp?=
 =?utf-8?B?QkdNRllMR0NDdUgwcUNFRkk3aEsxM0ZVVHNPUjkvWmFkdkE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UHpPOCtZQmUyOVJmT0JqODdFTWlwS3ZuVmxXWlpGRlNKTHIrTjE1ZW5jektP?=
 =?utf-8?B?TTdwNDVnOERqK293UGY3NWtuN3pXeEZocmdrNnJVYzZvSFpSUitralZWblB5?=
 =?utf-8?B?ZG93UDlIcldwMm9GMWFUTkZCdjFCenJ3YWx6VEFJeXc4Y3lHUVNZcnljcVln?=
 =?utf-8?B?dUdtTXNRSkM5ZFdGTjBYbm1UenhNRzZ0T0NmTHZ4MGJUQXdud200ZVR0Mnhx?=
 =?utf-8?B?MUJlZ0hoQjZEeUpPZjhJNjVvb2lOdGd4UkpZNHpBZ0xzRjlvSitEUDF6OTE3?=
 =?utf-8?B?M21MTHIyRmpFMS8zU3RwenlyMjN4V05vNGl1NG0xUTVKbHFxTmtTWGlpRkJn?=
 =?utf-8?B?cDdxM1I1Yis0QzAzY0ZuNmdqcE4rcnNxSFo2WkhrMmhwYlkySXF1ZmpYdjkv?=
 =?utf-8?B?Y2V5eTdya0xaSDc0Q0VEOTA4MGVpTnU3TzRza0xmZ3RIbmw0V2VCZzJ3RDlB?=
 =?utf-8?B?eEp3NUNNOXQ5ekFuN1krSDRKVERZOGEyaElVcEhXRUJvWnFwVXVLVWhLdHJr?=
 =?utf-8?B?dTM3WVdRZkpYdlZOL3Z5MGpWV2VieXRQT3U2aTAyWGk4NFAvdUNhSFpFdHow?=
 =?utf-8?B?amt2dHRsR0U4VmFlbGEwQW4zTmMydCtQSkc5WEhjUXZxeTZNODc5cFplajh1?=
 =?utf-8?B?NGdrZzIvT2RLSzh1SVc3SUpUWVhaMWF4WmhUTnU3ZFg3RWdHVkwxOG53NGNp?=
 =?utf-8?B?K3l5T1d0dllac1grcDZvZmpkTEcrOTN1Y0ZVRGFOVit6WDVOSktjWjlJYmpN?=
 =?utf-8?B?b0dWaUpoTVpuczJ3VUVscCtiUWM4VFhKT1M5WXo3alVpdkhvZm1kWWJ6UzVP?=
 =?utf-8?B?dHRtaWpORHhtSENWUU5NbG04QTJyY2MxalY2d1FlSVBmWG1sVnJrRDFzKzRO?=
 =?utf-8?B?K2F6WU5Md2dOUFd3d2o2alRIZjVjV0hKL2dqOFZiNHdaVUZsR1dQazhjSXJJ?=
 =?utf-8?B?djRqUm96NVJSQUNRc3Z3cDloaXVOb2U2Myt1RnhsTSsrS25ORG5uVjFWTkpu?=
 =?utf-8?B?SVBzaEV1ZGdiN0xPR0dtMWcxbFdKM2ErVmxyYWpPWWVoZ3hOdktSMzdCbkha?=
 =?utf-8?B?TEpHK0Y1RkNqVHoyZUNHelc5TE12U1FTQzkxODR6bmlRenRKNVphNDR6NDMw?=
 =?utf-8?B?bkVEditQWjZkelRPVnQxc0R4MWFDeDE5d0w1M1dFQ0gyZzlscmdpaTk1T1hU?=
 =?utf-8?B?S2JVb2VJWms1ZVg4OWJaZ1F5RHVGL2srdE05RG5uMGhXN3FXdWhpVUxXQzNt?=
 =?utf-8?B?RzdnVzdYY2hTWjZmMlZsT200YXlqajV1Y3g2Zmt5RzdIT2lEV2VUUzRmTkR6?=
 =?utf-8?B?VjRkVmprNjVOWDlFeEhxeDE4N0VybmRJYkMwQnpXaURjam1DcGhSNTQwNkh4?=
 =?utf-8?B?N05ZakNkTEQxQ2UwcVR3SkdnMEw4Wk8zZFZHZThrbS9RV3pxOE5rNlRDNnhx?=
 =?utf-8?B?MnJldFpmQnRZOVV3dy9ldEt5dEZqTzNFUktCWlpiNDNuWS91a1F6cGhzL2d2?=
 =?utf-8?B?dDdwN2dGTFc1NG5UK1Q5ZXVEalIrU1kzR2l2R0xrVXdGaExmdTZwYU5UcXhp?=
 =?utf-8?B?ck0zUHh2dmZJRlFhTGFndXBhN0lmc2N3UFVhU1ZDditOSkdBTExNaE5kZCtM?=
 =?utf-8?B?a0NwN2pOQ1pMcy9pQkVPMHhBT00xLzBxY3RBcE0xcklYOFJRQnVPTWJkYm5Y?=
 =?utf-8?B?eE9ScEh3ZDd4eVBTR0k2eGlDQUV2VmwwY3RIVnVSSTBVdlVSU2dRRHZ4Y29t?=
 =?utf-8?B?WFdFRGpyM0twcUNhLzBLdWdoMFh5RHVPcGo2UWNHS0FqWDJ5MWRqTC9DTG51?=
 =?utf-8?B?cGtkR3gwME9nZXV2TjJyd3czR1JTcGJLZ1R4dENoQ2txOENFTXpsYzdDNUJY?=
 =?utf-8?B?alNNVkVjS0NPTCsrUTNaaEM0dGNtMWdOQ054VmZWaVZHM0RtYnlQUFZqSVN3?=
 =?utf-8?B?ZlBqTzByNmpET3QxVy91cXh2YXdseXFvOW84N2Q1U2c0bng0T1JmTGhwK0hx?=
 =?utf-8?B?OUdIT3lZQk1ib3Q5Ty9pSVJ4YTdSejJvYlpoUGNIQWxQbktQeW9zNVNKTUZr?=
 =?utf-8?B?Z2tHL2I3TktDcjArdURUZSt6aTJTVXU4cFYxZFRtWUpTSm8zQkVlbTVkN0xO?=
 =?utf-8?B?OHh3UVFCTE12ZjdUNUhzc0xZOEdvR0pjWmpVaUN5TnBNbEkyRVNyWDNxRTZt?=
 =?utf-8?B?UHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BD3BD64098076040BBAC9720E4D2518D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46ad571c-4f2a-4f26-8d4d-08dcd226b546
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2024 05:58:07.1088
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aIVXcv3TeTPkupdk2WIcE23FBYbRuLKjZmX8B9ZB97JOfJMbG0Fku3vdXDx913XSLveahaBPmbE73Cl7zDEnLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB7705
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--28.278800-8.000000
X-TMASE-MatchedRID: Nail4dlEBNHUL3YCMmnG4qCGZWnaP2nJjLOy13Cgb4/n0eNPmPPe5KWz
	WoIRiV9DM/Se/q/gEyf5MiS7M8c1eGmXMi7Ntyo2h6L+ZkJhXC75VvfCjIxlu5722hDqHosTZVh
	gLjSOksYzr1NwPWUSumuftkeSnhTgX45573JlOaDNhppZWEmikBLDxzOohy92M+iVqkzCnQjhLW
	+nuKkjlrciZK6fRJYTYE84GSk4VazVFtf7bVfns2tGlKM15tA2naU0BOrP3M8z7Q5F3647KDLKv
	DBLmbBL6GaBBfFrYwfDCwrx7OfXzY5S9RIYp1E+XP5rFAucBUFbAoaK+wS4jY1aWCRWP5Hd+ncs
	xfnaQFtpSQUUBF62MZGTpe1iiCJq0u+wqOGzSV1WdFebWIc3VsRB0bsfrpPI6T/LTDsmJmg=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--28.278800-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	4AB24FF29CCB7BE74E902B296D8EAF4E3F909BDF1504EE3E17EE15C9C7DD1FB52000:8
X-MTK: N

T24gVHVlLCAyMDI0LTA5LTEwIGF0IDA5OjUyIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOS8xMC8yNCA1OjM0IEFNLCBQZXRlciBXYW5nICjnjovkv6Hl
j4spIHdyb3RlOg0KPiA+IE9uIE1vbiwgMjAyNC0wOS0wOSBhdCAxNjoxMSAtMDcwMCwgQmFydCBW
YW4gQXNzY2hlIHdyb3RlOg0KPiA+PiAgIFNpbXBsaWZ5IF9fdWZzaGNkX3NlbmRfdWljX2NtZCgp
IGJ5IGFsd2F5cyBpbml0aWFsaXppbmcgdGhlDQo+ID4+IHVpY19jbWQ6OmRvbmUgY29tcGxldGlv
bi4gVGhpcyBpcyBmaW5lIHNpbmNlIHRoZSB0aW1lIHJlcXVpcmVkIHRvDQo+ID4+IGluaXRpYWxp
emUgYSBjb21wbGV0aW9uIGlzIHNtYWxsIGNvbXBhcmVkIHRvIHRoZSB0aW1lIHJlcXVpcmVkIHRv
DQo+ID4+IHByb2Nlc3MgYW4gVUlDIGNvbW1hbmQuDQo+ID4gDQo+ID4gVGhlIHRpbWUgdG8gY29t
cGFyZSBzaG91bGQgbm90IGJlIHdpdGggdGhlIFVJQyBjb21tYW5kIHByb2Nlc3MNCj4gdGltZS4N
Cj4gPiBJdCBzaG91bGQgYmUgY29tcGFyZWQgd2l0aCB0aGUgdGltZSBmb3IgdGhlICJpZiAoY29t
cGxldGlvbikiDQo+ID4gY29uZGl0aW9uYWwNCj4gPiBleHByZXNzaW9uLiBXZSBjYW5ub3QganVz
dGlmeSBpbmNyZWFzaW5nIHRoZSBsYXRlbmN5IG9mIHNlbmRpbmcgYQ0KPiBVSUMNCj4gPiBjb21t
YW5kIGp1c3QgYmVjYXVzZSB0aGUgVUlDIGNvbW1hbmQgcHJvY2VzcyB0aW1lIGlzIGxvbmdlci4N
Cj4gDQo+IEFsdGhvdWdoIEkgYXBwcmVjaWF0ZSB5b3VyIGNvbmNlcm4gYWJvdXQgcGVyZm9ybWFu
Y2UsIEkgZG9uJ3QgdGhpbmsNCj4gdGhhdA0KPiB0aGUgYWJvdmUgZmVlZGJhY2sgaXMgYXBwcm9w
cmlhdGUuIE9uIG15IHRlc3Qgc2V0dXAgVUlDIGNvbW1hbmRzIHRha2UNCj4gYmV0d2VlbiAyMCBh
bmQgMTUwMCBtaWNyb3NlY29uZHMgdG8gY29tcGxldGUuIEEgc2luZ2xlDQo+IGluaXRfY29tcGxl
dGlvbigpDQo+IGNhbGwgdGFrZXMgYWJvdXQgMC4wMSBtaWNyb3NlY29uZHMuIFNvIEkgZG9uJ3Qg
dGhpbmsgdGhhdCB0aGUgdGltZQ0KPiBzcGVudA0KPiBpbiBpbml0X2NvbXBsZXRpb24oKSBtYXR0
ZXJzIGZvciBVSUMgY29tbWFuZHMuIEFkZGl0aW9uYWxseSwgdGhpcw0KPiBwYXRjaA0KPiBvbmx5
IGludHJvZHVjZXMgYW4gaW5pdF9jb21wbGV0aW9uKCkgY2FsbCBmb3IgcG93ZXIgbWFuYWdlbWVu
dA0KPiBjb21tYW5kcw0KPiBhbmQgbm90IGFueSBvdGhlciB0eXBlIG9mIFVJQyBjb21tYW5kLg0K
PiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCj4gDQoNCkhpIEJhcnQsDQoNCkkgaGF2ZSBjb25j
ZXJucyBhYm91dCBhZGRpbmcgbGF0ZW5jeSBqdXN0IGZvciBwb3dlciBtYW5hZ2VtZW50DQpjb21t
YW5kcy4gDQpUaGlzIGlzIGJlY2F1c2Ugd2hlbiBEVkZTIG5lZWRzIHBlcmZvcm1hbmNlIGFuZCB3
YW50cyB0byBzY2FsZSB1cCwgDQppdCB3aWxsIHRha2UgZXh0cmEgdGltZSB0byBjb21wbGV0ZSB0
aGUgc2NhbGluZyB1cCBwcm9jZXNzLiANCkhvd2V2ZXIsIEkgYWdyZWUgdGhhdCBzdWNoIGEgMC4w
MW1zIGRlbGF5IG1heSBub3QgaGF2ZSBhIHNpZ25pZmljYW50IA0KaW1wYWN0IG9uIHRoZSBvdmVy
YWxsIHNjYWxlLXVwIGFuZCByZWFkL3dyaXRlIHByb2Nlc3MuIA0KSXQgbWlnaHQgYmUgaGVscGZ1
bCB0byBhZGQgdGhpcyBpbmZvcm1hdGlvbiB0byB0aGUgcGF0Y2ggZGVzY3JpcHRpb24uIA0KDQpU
aGFuayB5b3UuDQpQZXRlcg0KDQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5n
QG1lZGlhdGVrLmNvbT4NCg0KDQoNCg==
