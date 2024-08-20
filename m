Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DECE148FEB
	for <linux-scsi@vger.kernel.org>; Tue, 20 Aug 2024 06:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724133609; cv=fail; b=WEtGno+MplMsRjiP8fMwm8mEl0DQL6hGzpAROKtyP/nFU3auZ9YG6KAfqpOJcxeZ5nWBjlyJKva3/Hw7SRYyqNk8bCpckjKPGgBkCPJ+eRLWVZ6kKO+ErVmwvkc2eaMKkvXaPlN1Q9wdygUBgFn4Aon/qlK9yw2uyNB08U9HdsU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724133609; c=relaxed/simple;
	bh=3aUUbwBI0VigVJsHFKjeVY2U1HU2D1+jZ8UaaZV1OkU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YyM19kQqUWQmlGAljFg7amyi6h9IWy0ISA7ryie+wvf7lsigpuWStNPruFQwcl0/Ctzkflfwmf0xB8d5cTfmMx1Ubv4GAmaLIKLbdYmLk0U+SETLYoLZOp7WNNsT/ANLq7NaoiqBAQViaFSER5FTk4P7Tq5hunaQoaNU/qVQZZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ZWpaxRSE; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=RuPqRnPz; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ZWpaxRSE";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="RuPqRnPz"
X-UUID: 6ee16a5a5eb911ef8b96093e013ec31c-20240820
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=3aUUbwBI0VigVJsHFKjeVY2U1HU2D1+jZ8UaaZV1OkU=;
	b=ZWpaxRSENAtYfBMOfRCi8XI9ecWtL0OZNllRDQOtjYHJR5JbCcKROUGnqpgM7BMmEU194Uxi/MW7gZudee1RSRcnpgV+4LYRHnARuxEFU/cIaIAJ5YAgD5pYc9fuGw0QGcUrgbeJ7YSKfti1ybIA4R3esG0SivsIIXRuOOyanOQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:82852271-c6ab-435f-bea0-440939d75ca1,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:b6d8b85b-248b-45cb-bde8-d789f49f4e1e,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:1|-5,EDM:-3,IP:ni
	l,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 6ee16a5a5eb911ef8b96093e013ec31c-20240820
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1860770815; Tue, 20 Aug 2024 13:59:59 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 19 Aug 2024 22:59:59 -0700
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 20 Aug 2024 13:59:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dpj45X1lnpxmGNAjDT4GbdFFeSAaZA4YhTChbVg5grbwXH770C5AEFP7p/8Ah5NSlT2rWiu+4v2ks/K4N54iidBWl8w3NGUjA6xDBkCmIbXF+rq7FLf6BcxaB3+E2ClzdrlSYXbZBPM245B/Y+c11AZSrAD0AuN6fccUCBgPWauXITMMsEnDIfMR0+oXRDrJQO0wxddVn7NEL+8aP/rc2+6MiOL6q4hQ5UuZjKpg9e4kmgkf75nxCzwocyPmhz3LglPJAN71hrhULT3G4FjbPt04JN+68ObOzFhfivlFGROw8ZUgp0Ezkr5C0e2VsGISoA2gF9WmuTvgf0Ydfa4pkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3aUUbwBI0VigVJsHFKjeVY2U1HU2D1+jZ8UaaZV1OkU=;
 b=iu03MqWKZfxjwWkLRbF5WDwpVU6fk3PGGD8KOS9Ve4WqmcVvpwRlzpTeDwRkXQmFBJ19Szn5o0tGU4LKg44msvaXyiycwYaa7cM9iOPX2WwKOcI2bUMaKvhw6kKKWUxRMPF7xvPBvnjkU+MY0XAS6B93IhLMa29AAcSjZNY7x0KrIW40FHoYizHobD6/GB6b7NaiCPR/pnU/tfd2d9pf8gsKmjarYMlCHr31/mhVtJK5PV66WKD92IXAIUYRvqxv6QRh43vt6OmFIRTL+WjgghrBhLQdosQ9dbCYWbqg/e08rfRlfw5jB+iSe14duS0Rsr6/zt+bpu9q11P5Lm/Phw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3aUUbwBI0VigVJsHFKjeVY2U1HU2D1+jZ8UaaZV1OkU=;
 b=RuPqRnPz1ft/cfIAnVSvKkdge44ZrOX/TFHPHVZn5Xi+CZp4Z5bHp8OI/sJQ9PLwr81WWzcOfxtyOITFfYROu5fPmrnyWKlhRQ1rDQqzkNbRbt8IaSd6n+FWdQ+rvRCpInA2cD+zXpBVwq29JEuZZbRMXsRZ/1M6rwUNO57+1T0=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by JH0PR03MB8254.apcprd03.prod.outlook.com (2603:1096:990:4b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25; Tue, 20 Aug
 2024 05:59:57 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7875.019; Tue, 20 Aug 2024
 05:59:57 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "james.smart@broadcom.com" <james.smart@broadcom.com>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "sumit.saxena@broadcom.com"
	<sumit.saxena@broadcom.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "satishkh@cisco.com"
	<satishkh@cisco.com>, "johannes.thumshirn@wdc.com"
	<johannes.thumshirn@wdc.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "sebaddel@cisco.com"
	<sebaddel@cisco.com>, "njavali@marvell.com" <njavali@marvell.com>,
	"suganath-prabu.subramani@broadcom.com"
	<suganath-prabu.subramani@broadcom.com>, "kashyap.desai@broadcom.com"
	<kashyap.desai@broadcom.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"vishal.bhakta@broadcom.com" <vishal.bhakta@broadcom.com>,
	"chandrakanth.patil@broadcom.com" <chandrakanth.patil@broadcom.com>,
	"sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>,
	"shivasharan.srikanteshwara@broadcom.com"
	<shivasharan.srikanteshwara@broadcom.com>, "dlemoal@kernel.org"
	<dlemoal@kernel.org>, "anil.gurumurthy@qlogic.com"
	<anil.gurumurthy@qlogic.com>, "mwilck@suse.com" <mwilck@suse.com>,
	"jhasan@marvell.com" <jhasan@marvell.com>, "tyreld@linux.ibm.com"
	<tyreld@linux.ibm.com>, "michael.christie@oracle.com"
	<michael.christie@oracle.com>, "chenxiang66@hisilicon.com"
	<chenxiang66@hisilicon.com>, "sudarsana.kalluru@qlogic.com"
	<sudarsana.kalluru@qlogic.com>, "nathan@kernel.org" <nathan@kernel.org>,
	"john.g.garry@oracle.com" <john.g.garry@oracle.com>, "mrangankar@marvell.com"
	<mrangankar@marvell.com>, "sreekanth.reddy@broadcom.com"
	<sreekanth.reddy@broadcom.com>, "hare@suse.de" <hare@suse.de>,
	"GR-QLogic-Storage-Upstream@marvell.com"
	<GR-QLogic-Storage-Upstream@marvell.com>, "kartilak@cisco.com"
	<kartilak@cisco.com>, "skashyap@marvell.com" <skashyap@marvell.com>,
	"linuxdrivers@attotech.com" <linuxdrivers@attotech.com>,
	"ram.vegesna@broadcom.com" <ram.vegesna@broadcom.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 01/18] scsi: Expand all create*_workqueue() invocations
Thread-Topic: [PATCH v2 01/18] scsi: Expand all create*_workqueue()
 invocations
Thread-Index: AQHa8CdyUuAGyUG4t02FlZbBUXxuILIvrA4A
Date: Tue, 20 Aug 2024 05:59:57 +0000
Message-ID: <083f77d22f96c12a6e061963db4a83269461a6cc.camel@mediatek.com>
References: <20240816215605.36240-1-bvanassche@acm.org>
	 <20240816215605.36240-2-bvanassche@acm.org>
In-Reply-To: <20240816215605.36240-2-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|JH0PR03MB8254:EE_
x-ms-office365-filtering-correlation-id: 17dd6936-a4c9-455a-6709-08dcc0dd51c5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TTVVY2QyL2pvNnc2T3k4aFMxVnRERlp6N3Jsbkt6VGp0TVJDM1ZQSFhOTU1p?=
 =?utf-8?B?R0Qrc3RoVnFSbEJGRm90bHdzMmwwNzgvbGU1YW1aYXkxOGxEK21rMzhmYko0?=
 =?utf-8?B?MURvS3ZNQ1RNZ3BMVUF1TTZhbHRrZU1hSXZjWU5aSGMydTlOMEp1T0E2b3VB?=
 =?utf-8?B?aW14cjhFNDRSa3h1UUF4OWNnZzFRV1hFRkxBSThwNXBxUFlZUExuR0ZVM0tB?=
 =?utf-8?B?bHlUNk9zYXZCZ2k2QXI4OWFiVE9palpFcE5lWk8wYjJkRDd0eTNvVHdsNUlt?=
 =?utf-8?B?UkFQN2RoYzJRYW1BazYzQjYzViswcnk2Mkp2a3ZnbFhKd3NISXk4S21Nd0Yy?=
 =?utf-8?B?dGRXZWpFaWRBMGN0TjVnOVFFOGlWUlMvenFtUnQxWHJaL1FGQk1hT2lsUUhR?=
 =?utf-8?B?cTVPeUp0MlNkSjVBRU1VciszZjllKzRhbVp2VmZyMWlNNlpXQVBRZkx5cmpZ?=
 =?utf-8?B?ZjJBRzRzN1lOdUgzY3huRnZJNkZ5K1FJWjZSMkFPZDVLZGt4K1VsczhOZjJi?=
 =?utf-8?B?Rlp5QmhmSUtvZEV2S3dvUG9JK1JoY3QxQUFUbS9RWnp1RCsrTkN5a1RFaGZx?=
 =?utf-8?B?Qm02ZjI2TG1IKzFEaG9pbEphRHZuNXBHVWtmUVQ5RW1IaG9SSVZLSGpXTmRJ?=
 =?utf-8?B?LzZ6eFlwTUsrZFQvVktjcVFXcXpERVNhalR1VXJLY3pZQi9BZ1hGMjJGUXU1?=
 =?utf-8?B?aDg2OTlMZVVlMk5XZEpMRUFya3NpOG8xZmpaaERJU1F0UzV0Q2tyVTlXM2dj?=
 =?utf-8?B?cURyOUNGeDdDMDRvQUZ6R3hmMm9HKzRGZ0owbStSbEdtb01YOWl2UUR5Wkpt?=
 =?utf-8?B?SVB5SVVPc1VsbkYyYTcxVnpsL2IxTHBXMUVDRXRpWUVlbCtlZXIybUovNjVH?=
 =?utf-8?B?MlVQUVphMWluZmdNdWVoenBhSHduZWU5Sk9Nc0NSVDZNMmd3NUhvZGZ4Z2w1?=
 =?utf-8?B?emFsVVZPNGp2aVJSSmpzcnhGT2NlWE0zUVVQMnhpTnVFU2s4aXJRZDVWSFpp?=
 =?utf-8?B?OS93VDdLcGQvRVJjekpWTjk5eHdiMkF4bExiRURsVW14RkNIUVI5ZTZiQW9Z?=
 =?utf-8?B?WXcvVnRldnViM3lGWDljMmplYXFWUWlVMExQaWdXOWZvUFJFKzBIZmxUeVZk?=
 =?utf-8?B?VC9vL0U3MlJFMWVTRXY1bU1BRHhTM0hRM2hialgvbzFxZU9Ud2xxdE10TkVu?=
 =?utf-8?B?ZkdEQkFac0EzdGp5MkZHanFSVUppOWhCZkxXRGd3Tk55S25sZkxCL0tyeitZ?=
 =?utf-8?B?anV6WTZ1QzF2QXh0NGVOK0hIYmxIUnFxS0ZnbHlYSjk4Z201SWVWQXFKYlg1?=
 =?utf-8?B?VVFxb3V1RFE3cXlZNXJkbUR2aDlqMkFITERTRWx6M0RXeUhZSXFBZnl3U1JR?=
 =?utf-8?B?VnJncnNQcVhVNDdxSGtEWllyZHhsbHNuM0dKVDRuTTRHS2J3OTdsaHdoWmxj?=
 =?utf-8?B?QnYvY2pEWlVuOGFKTldIdWVva2h6aFo2eXZwak5yNGJNaFdKSXphb3FjczUx?=
 =?utf-8?B?L3FoZnRCbmdSakI0OW05bXI3MmNIN1QzWmwyM0p1M0F2K1pjcHZKR3h2Qlg5?=
 =?utf-8?B?VDByQ0JvMmhxWkplNlVWRUpkWXc5UVEwQWpnQk5MT2RFSzQ4dklXdGkwOTll?=
 =?utf-8?B?WU5ETmQ0TVpuVEtMZU5VZEQzWlIvKzg2cExzakxRS3V0RTY1NUphVnNCSW1U?=
 =?utf-8?B?ZXNNVVVSQXU0anhEREpabU5hdXNNWUs5ckk5WnF0N2ZYcWxraUsxV0NzVFV6?=
 =?utf-8?B?cnF0UEVwQ0dGR0FXR2EzR1dRc0s5MVdRMGFTWlBjanNqRHllVlVGc1N4aDdj?=
 =?utf-8?B?a0FhZG5acFE0OWZsUlpVbnAvUVVwNGx3TG1aSllUV2pNZGU5K2czeGpFRmtU?=
 =?utf-8?B?YUhmUXNLd0Jpc0JzQWxCMUdpMXpucXM4SEU5dVQ2N2xsaHc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bFM0eGc3RWhsTnlvWnduNWRlSzR0Qk1hRG1Zdm1MNmkrRzk1YTJOcEdTTzVk?=
 =?utf-8?B?VGxFc21xL0ZGd2JxOGpZcklhR3dpdnFUSTltT2JrcnNuWlM2NitQY2NseU1E?=
 =?utf-8?B?ZndUQ3BUNjhQNkRTUWdVN2hFUEllUlR0aTlkUjBmbU93bXVKTWtJcVBmR2lj?=
 =?utf-8?B?RWVBRGo5QkRuOXdLczdnNGhGVHI0V3VidDFYYkEyWjdOU3lFNEJtemJQaHht?=
 =?utf-8?B?cVA0dVRaRk1GQ25BenlVUnJlMFR0Z3MzQlZlQ2VFcFdhaHU0ek9BdndzQngv?=
 =?utf-8?B?bDFOdDRQN01VQUphckFCQzJ5M3cwZTlwNW84Tk5sZ1loM2lTL251TThINFRm?=
 =?utf-8?B?V3M5ZllyaCthOTE5TFNhT1EvR2xkaGxJVk5NMWdZb29IeFZreUtzU25EVVV3?=
 =?utf-8?B?bENmU3IwUmRLS2ttejlEMkUxTENWZVVhYUMyTFhicytIYXVnTWFTWGd6dHl0?=
 =?utf-8?B?WldEMnBXUGYwaFRxZjQ3YnFMZkhWREJkTVljaHB2UFV6OCthcStQNkIxKy83?=
 =?utf-8?B?aGZnQVF1QVZ3eG9ic1BaT2lkUXhSL3loUVFTT2FITThLcWRpSXY0NVFOTkhO?=
 =?utf-8?B?Q3FCU0RyZjRYMFVxdzVmQXAyZFdRYlNIczlUcVVqNkl6ZUNXclpPVHgwdDJk?=
 =?utf-8?B?OEVpMXRzemYyTGdPSWpqUG90dG1hUkg3ejExY2JQWnVDS0E3WUtUQmd5SFhX?=
 =?utf-8?B?MTBESDNxcnlYV0lKQ0l1WmM1V0R4WnhlWmtnekorcWx1TkJuZW1vUDdQWDZz?=
 =?utf-8?B?YXR6My93NU5NVDlpYUdKeVZRNW1CSlNVKzFpcjFmTXpkMk9nYkgwZTFCZGRa?=
 =?utf-8?B?MENLdXpOVXlHTDdTQWxIOHBFSzBjUnRidmRhdjB4ZENtdWNnMjVpWWlUM0Vt?=
 =?utf-8?B?Ky9GVTBuL2pYSUtMdFRFNjlFMiswcDRGYXlKRXVkakp5eHdDTmw1UnlsZWlN?=
 =?utf-8?B?cENQcEpYQUJLVkJnMHYwdGoxMmNMSTdSWkpUVlBSSzB6VDlRczlGSzQ5dGsz?=
 =?utf-8?B?Y3Bhb21pdGQvUHpkWFc3THhTZ3NZVGtjTzQ4b1NYMk92N3M5UmFnMFRyaEdk?=
 =?utf-8?B?d2Y1dFZhSVRzR2ZCN3lDVGptNVI2b0g3bmRYWmN1dThaRFNxU3J0UTMrV25D?=
 =?utf-8?B?VTUyUUpZazFDTG53d3FLSU9KeVUvdUcxRWE2Z284NTh1eWRqaVh3Q0RNNTht?=
 =?utf-8?B?Mk5udWRRbE9CSlNlVGh0SDh6akt4ZmYrWGd3aStxd2gzVFpEeXpFbmFVUHRB?=
 =?utf-8?B?RklFTHpqbmRzN3ZnUkhmYWp4VjMydnZ4ZGp5amF6VWRyL2VoZVNOcDltcXR5?=
 =?utf-8?B?R3E5V3VUVU0wVjdUU0lxN2NwOVh3UFRmamYwY2VPcEgzTC85OHZyRkhGendr?=
 =?utf-8?B?UFhuNk5FU0hyRTdNOTVZdXFIY242b1NTRnlGQ1EvaUQraXhtWm1ENElXcm9a?=
 =?utf-8?B?a3FiRlR1OFg1eUQ0ZWdwVEI1aFdJWVduNjhsbExkRG0rb3RwMS9PWUZ6a3A4?=
 =?utf-8?B?NjByM2ZWa2NLYnM3OUQySWc3OFNYLzlnWDh0dVEyMEQ1cUVtN280ekJUQVRv?=
 =?utf-8?B?YmlKV2dOM1BnamlOaU1Lb2swNTg4N1FTNDJvU1l3ZG5Gck5IZm9VWVh0OXdq?=
 =?utf-8?B?UDZHV3RnTVJhc0JjZ3laVU5xY3VHZHpveVpaclZGZEJtbTczcm5qQ2J6Z24r?=
 =?utf-8?B?cG5nY2NFRHJOR1VjOGZiU1R6WmhCMmVINjQ0QnZMQ0wvOEpKWlNBT0ZPZkFZ?=
 =?utf-8?B?NkpIcStoK2xQaVRGRHlHSm5Ecmk4ZEF4VkZzUUxtbEVIdlkwdTBra0pvY2xI?=
 =?utf-8?B?amlMVTROL2ZqWmVlb1BtMStHZ1dnc0VpV1ZtSnNKQ1NJUnUrSTg2Vks4dnV3?=
 =?utf-8?B?NVkwOVRJVUYzbmNDVmlRMHNOMGxvaVR4SS9VTGlUcmw0NnNaWlVjZGRzNzJl?=
 =?utf-8?B?RWI2c0ZNanFNZmNuZnlHakpzdTNoSVV4M1JVR0RJZ01aS2NSRnpJV0duL3dQ?=
 =?utf-8?B?WkkrU2pyVTZEOTg0R2hRQ3R6eDl3am1McHFkZjBnQ2dueGZSNzYxbi84ejlP?=
 =?utf-8?B?bWs4ZFVVVVBpdmt4UlBQdlM5N3ZwUmMxcmhraUF0VGVUMFNqSTR6UmdpbEtk?=
 =?utf-8?B?bHJRSGJPN3ZRT0hWU3Nlc2Roc2JTNU9UeDNwaVp1SVZXeHI5UmFQcDlWcVpY?=
 =?utf-8?B?ZHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6ED16BEFEEA1C04EA005261F67B3E8AC@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17dd6936-a4c9-455a-6709-08dcc0dd51c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2024 05:59:57.1526
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dJZjg2GObck9XTXpWYDOe4sAJXxqKUP5yCa36ul7dUfvJNA8gM5RtPsDUP6YMnCoD0m27Q7AFqdpZlxYxJb8CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB8254
X-MTK: N

T24gRnJpLCAyMDI0LTA4LTE2IGF0IDE0OjU1IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgVGhlIHdvcmtxdWV1ZSBtYWludGFpbmVyIHdhbnRzIHRvIHJlbW92
ZSB0aGUgY3JlYXRlKl93b3JrcXVldWUoKQ0KPiBtYWNyb3MNCj4gYmVjYXVzZSB0aGVzZSBtYWNy
b3MgYWx3YXlzIHNldCB0aGUgV1FfTUVNX1JFQ0xBSU0gZmxhZyBhbmQgYmVjYXVzZQ0KPiB0aGVz
ZQ0KPiBvbmx5IHN1cHBvcnQgbGl0ZXJhbCB3b3JrcXVldWUgbmFtZXMuIEhlbmNlIHRoaXMgcGF0
Y2ggdGhhdCByZXBsYWNlcw0KPiB0aGUNCj4gY3JlYXRlKl93b3JrcXVldWUoKSBpbnZvY2F0aW9u
cyB3aXRoIHRoZSBkZWZpbml0aW9uIG9mIHRoaXMgbWFjcm8uDQo+IFRoZQ0KPiBXUV9NRU1fUkVD
TEFJTSBmbGFnIGhhcyBiZWVuIHJldGFpbmVkIGJlY2F1c2UgSSB0aGluayB0aGF0IGZsYWcgaXMN
Cj4gbmVjZXNzYXJ5DQo+IGZvciB3b3JrcXVldWVzIGNyZWF0ZWQgYnkgc3RvcmFnZSBkcml2ZXJz
LiBUaGlzIHBhdGNoIGhhcyBiZWVuDQo+IGdlbmVyYXRlZCBieQ0KPiBydW5uaW5nIHNwYXRjaCBh
bmQgZ2l0IGNsYW5nLWZvcm1hdC4gc3BhdGNoIGhhcyBiZWVuIGludm9rZWQgYXMNCj4gZm9sbG93
czoNCj4gDQo+IHNwYXRjaCAtLWluLXBsYWNlIC0tc3AtZmlsZSBleHBhbmQtY3JlYXRlLXdvcmtx
dWV1ZS5zcGF0Y2ggJChnaXQgZ3JlcA0KPiAtbEV3ICdjcmVhdGVfKGZyZWV6YWJsZV98c2luZ2xl
dGhyZWFkX3wpd29ya3F1ZXVlJyAqL3Njc2kgKi91ZnMpDQo+IA0KPiBUaGUgY29udGVudHMgb2Yg
dGhlIGV4cGFuZC1jcmVhdGUtd29ya3F1ZXVlLnNwYXRjaCBmaWxlIGlzIGFzDQo+IGZvbGxvd3M6
DQo+IA0KPiBAQA0KPiBleHByZXNzaW9uIG5hbWU7DQo+IEBADQo+IC1jcmVhdGVfd29ya3F1ZXVl
KG5hbWUpDQo+ICthbGxvY193b3JrcXVldWUoIiVzIiwgV1FfTUVNX1JFQ0xBSU0sIDEsIG5hbWUp
DQo+IEBADQo+IGV4cHJlc3Npb24gbmFtZTsNCj4gQEANCj4gLWNyZWF0ZV9mcmVlemFibGVfd29y
a3F1ZXVlKG5hbWUpDQo+ICthbGxvY193b3JrcXVldWUoIiVzIiwgV1FfRlJFRVpBQkxFIHwgV1Ff
VU5CT1VORCB8IFdRX01FTV9SRUNMQUlNLCAxLA0KPiBuYW1lKQ0KPiBAQA0KPiBleHByZXNzaW9u
IG5hbWU7DQo+IEBADQo+IC1jcmVhdGVfc2luZ2xldGhyZWFkX3dvcmtxdWV1ZShuYW1lKQ0KPiAr
YWxsb2Nfb3JkZXJlZF93b3JrcXVldWUoIiVzIiwgV1FfTUVNX1JFQ0xBSU0sIG5hbWUpDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4NCj4g
DQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCg0K
