Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A118E2750FA
	for <linux-scsi@vger.kernel.org>; Tue, 15 Apr 2025 07:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744702503; cv=fail; b=At1RgyoxGBMGrg2WgeTYm8jE31Bjjztc8qJU/TgnAzxHwa/5XUySm9vFzURS2kbptFdffrR0Zc6y6MdfIyjhwILBsrPtA1+9tS/wCVx3MpkME/1/srlZwLHNQ1nf78UMNX+y2CvTHwYihoWeZYekc6f5+G4Z5coyY2NijUNE4J8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744702503; c=relaxed/simple;
	bh=+y2lr+xdQAuLUIbCqCT1QyQfSogMDIadhXJD0Hz6bHs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=A2DCNXJ24gmmVA1EW/9DO6s86YIqx6wfQN8dkRNn93Yb0mtG2BRSg2omcay/6eg3sVxNsN9XHcmL8dqs3l0XQQuPY9KbgAfximNlJGXaM8sMNGhnV+ZdBYyXgn9oW0WCI/5CGl0M4ZaEiW13X61dKO3vpihvQRpChwmINovHKxI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ermGZc0B; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Qw0RMaW2; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ermGZc0B";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Qw0RMaW2"
X-UUID: 20df2fe419cc11f08eb9c36241bbb6fb-20250415
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=+y2lr+xdQAuLUIbCqCT1QyQfSogMDIadhXJD0Hz6bHs=;
	b=ermGZc0BlysBMWilunRw3MNSgRbk65zMqcSoUrxgGC7pouAgVtU/NNySIEOAmEZDjiPcUF5CF1pbCdtfDPVEa1MdzLDMHfF25S0FVOxD1fU8qDvLPDOp/MwTGTHiAn8uKmgekgcgnm6rGpAvXY0NvVtsvLUyeuBVOLTpni23aWs=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:e32cdead-8bfe-44d1-89ad-bea03ebbdf70,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:0a3d97c7-16da-468a-87f7-8ca8d6b3b9f7,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 20df2fe419cc11f08eb9c36241bbb6fb-20250415
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 182193288; Tue, 15 Apr 2025 15:34:56 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 15 Apr 2025 15:34:55 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 15 Apr 2025 15:34:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e2ezoYRogswrbQQkMgXMBvexReIl3cVPh3WWCY3phEcmq3njCzdZ90k/xOr3YaC4aiYGnxfM1AgT53qXsKwrZY7Ni1hYdIEeY86J1IRBM4K6oz2owMM14f2YCZPRq2kS4z/Pjrs3ekyqk4eWEZ6U7seebFXwscoTuDO89I21xHT12PGK0hZiAxznHT7SWWtk8d7xKDEOfBHD073HPCuKAo9FXQrYssuZvPB87ahzc5Fh5vCExuVrqOF+vN6H7aBjqy+m0okgdw3hWjo+fCsT8znk8RN9P8K7CEsUBTViaV5Hu5YHLaLcBXpTUWDBQMsLAJXYl4hao2P1uZCzoFPadw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+y2lr+xdQAuLUIbCqCT1QyQfSogMDIadhXJD0Hz6bHs=;
 b=D47iaLIVXfHIRCHDUQJEah7UtGB3yYf6P7V5XstdI2rzRIHrfFveABKJQC2KpjjQtBbPdx3uMNPrl8r7OuJlGhf/4tYK65Muf+NDVuN8iQYwQfdm57h1TibGlYxIllk0czIE0LGxYdCFMBq+DjajzpqwB2f1P82Gp4N7eLhhE+o2n6BRTOy3q+3SVZMX9lxL+oyT0fUGMGmW9Vr5GZTs4O2f9c0cQcu1DhPmL2Y7a6IR1/7kqT6eOx3uxSHuMPXC6ka0qOI8f11FpzV5PwyqfpdhmqSM9HASBHWnWMEJrxgtMvejZFkbDvAfIYhP9nnAaO/G/0F6qgGYyYuHj7IJNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+y2lr+xdQAuLUIbCqCT1QyQfSogMDIadhXJD0Hz6bHs=;
 b=Qw0RMaW28AXR295LIpel3hCCuGkFtuxNv1Mg4jU9nUEOt3jIjjo30PUXNcxKZjVriW9HT1CwWTg8oJ9cJeMWKuVb5QPXWx3TxNhp2yQIYic+PABZN7w/0r2exlUMBlGPrHWAqa+ITkK5ZdDwN6DeztHIZcnD1S7zr9cLlIPBXPk=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7199.apcprd03.prod.outlook.com (2603:1096:820:c9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.27; Tue, 15 Apr
 2025 07:34:52 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8632.036; Tue, 15 Apr 2025
 07:34:51 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>
Subject: Re: [PATCH 10/24] scsi: ufs: core: Only call
 ufshcd_should_inform_monitor() for SCSI commands
Thread-Topic: [PATCH 10/24] scsi: ufs: core: Only call
 ufshcd_should_inform_monitor() for SCSI commands
Thread-Index: AQHbpN53Gh1GlvT87EKyFTs4I2wn9bOkaAAA
Date: Tue, 15 Apr 2025 07:34:51 +0000
Message-ID: <49a26c9eb5699867f74c0bf2e774bddc9ac859e2.camel@mediatek.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
	 <20250403211937.2225615-11-bvanassche@acm.org>
In-Reply-To: <20250403211937.2225615-11-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7199:EE_
x-ms-office365-filtering-correlation-id: 79246551-20d9-472e-29b2-08dd7bf0024c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VFoyWEIycnJleVdaRnJaR0VDM0RVeUF4TGplUjU0dzZDdjNOakpQTkd0My90?=
 =?utf-8?B?QXpFMW9IUVlVeDVKZmhPdFE2N0YydzlqY29qY0d2TWFHRUh2KzBya0dKa0pj?=
 =?utf-8?B?c2NtaDAvRnp0azhlUktJUGRodzF6empzWWxYVE52SGE3SmJxemFlU1ZxODE2?=
 =?utf-8?B?ZnUxMEJqKzdrSVlJcTF5WGZibFZoeGpJK0l3Y2o5amUzc1NRdFRMcU9rTGRi?=
 =?utf-8?B?L2dmSkdMM2J3TGdhbVhzZStSUFY5c2wveHU4V2pSTGhMWTdYcHc3KzUzU3pm?=
 =?utf-8?B?c1M5cXc2QzUxOTdLZmxMRGlEYkY3eXE0M3VHc0tiQStLQjZsb3dEZkdJbnIy?=
 =?utf-8?B?YzZyU1dLOHpSOWdIdHNpRWJSZGQwYm1WQlZGcDl6S0hKRmY3elpxdXVLQTlh?=
 =?utf-8?B?TGdlSjR5azA3dnlMOGpMVWp2NVE0RDQydDZpUVdSUDNrQ2J6R2F2d1ZDK2RJ?=
 =?utf-8?B?aHBuTTFqSkZkME1LMjhaSzhxUy9oRTdjUDdzdkU0TU1veXJCTzBqK1BRcHhH?=
 =?utf-8?B?K2RYSmxGc2ZpVUdjMFVzcFIvMXgzTTBNVC91bE5hUU1seFduVkFxL2dzOW1Q?=
 =?utf-8?B?TmlqZEY0Q0U5b1BYUnd0dlJEY0FoaTlVVUpmdGxTRTBZQ2tsd3RYZk4yMW5N?=
 =?utf-8?B?NzVOMGJBRzA2K3pPRzV1ZXAzdTBaa09nZ3pQQW1WTVpKaEpkc0duTERvMlNH?=
 =?utf-8?B?TE5ZaVhsQWdXMkluYnE3THB1VEZCaFNrWjZkR2M5UTBrSDJtR0JkSDNzY2RO?=
 =?utf-8?B?c09TTHY1TUpIMnU2OWpvZ09zYlk4d3Z4d3BPWTIycGVoc0JrczdqeEpFZGF0?=
 =?utf-8?B?MWhVbDJzaWtBbmJxZHFyaUlhdXdtMm5vMFFLNGZTUW4vZlNFSW5MbGRtVXJy?=
 =?utf-8?B?ekpPQ0YxdW1nelpZK3VHS0tPbHVCdUhDdWxsb3hjaDdsN0NBdzRneWZtTXZE?=
 =?utf-8?B?QUplV1NHMmp3Q2VxR3d2V055QnlpdERKTy9Fbi9XOTFpeXB3NlQzL3F4M1R1?=
 =?utf-8?B?ZlNBYXphVzdhSy9YcWIxeC8yeksrR1h2bkI5Rm1uQzV0U3loRFcwZGRVR0hD?=
 =?utf-8?B?TDUvd2htYmdNOEV1M0VpclFFNkRXUFQ1YlB2QWM4V0t1dUoyTngyRlF5K1Qx?=
 =?utf-8?B?NlljcEw1RG5xbTFNMUgyN3dueUhkZlhKQ0JjOElrWXZIeEY2Q2pNQzV2ZzJr?=
 =?utf-8?B?c0dVVC9FWlRWN3NLUkYwM0RZWEtEakRIUDZrUkFxbkVxZmFJNFM1eXc1MDky?=
 =?utf-8?B?VmRmNmtYRkxNZ280bi9HTHF3K0QzOWd0a3crdWJqdVhRcWk3M0pVWUhtZm1M?=
 =?utf-8?B?bVFSR2xsMHRxTnpCbEtzR0F6YTVJV0FzbkZubGZUTURMU2NuMlpWSStvdmVL?=
 =?utf-8?B?VjZTMEhxRVEwaUN5bitUTHpCUms0SlJTRnBaeVlPMkNSc0R5VmI3UWdQcUg2?=
 =?utf-8?B?N2VSbnd1MHZpcWUxY0hNZm03UzRKaUxBdXVaVjBvSzMvT0QvUGJZdlFOQ2pO?=
 =?utf-8?B?TmNQMzlScWN1M2haRXNSOGhVSmFzQS9rZDFVOXNkd3RPa2NCbDZIRnR4bzR3?=
 =?utf-8?B?NFNGRHQ2Q3ZsWkYrY3lWMUlSRkpVNmRHYnRCT1lncDNMRnhTeVN1NzBBMi93?=
 =?utf-8?B?Z3dNcVRsbmxFMFg4QU5hRXYvYW04Y2NTbkJLMmI1cTNmYXBvTloycm9Mdklz?=
 =?utf-8?B?YlZEeGViOEdvM0JISGM2WExoNjltVzZsK2R1bXJmSVZRYmltdE9salZBaStZ?=
 =?utf-8?B?clIxNG4xNVlRMkdweFNjZlRlTkUyRVphc2tScVllWVBUZVJqMlV1OGRQRjB5?=
 =?utf-8?B?aFlnS0dCaWgvZEd3Q2dlbXdZdk1FWEpsZU03b2ZIbENzcEtJcWNLTG9zREJJ?=
 =?utf-8?B?VUVRYUIrbktvaUJMeE1uUkN2eUN1UE5EQXVmSzlUSlR2STg1bFgyUHdjclUz?=
 =?utf-8?B?ZkNJREx0ZUN6NnBIYzRLc2ttTE0yeW4yVlFmS0IrVXh6QjZ5YkVXZ05PbS80?=
 =?utf-8?B?TDZRUy9KTWl3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QUsyTC8wazNVd1pGL1Z2cTJXc0JFc3JTV042bkc1N0lHWEpCOWNoYnhkMG91?=
 =?utf-8?B?ZFdHeWpXaDJPSDNzM3RodzI2ZUxFWGM1SGd2NlNpWHBjL1NPcXkzOVFHZEhy?=
 =?utf-8?B?SDBtWmFNOGlLbCtJYUNNdlVjQzNkb0VqY1oyVHlPRWlXckEyRElXMzd6d3Fu?=
 =?utf-8?B?cHY2djdkWDdTNENVK1EvSHBxMkowY2l2b1VVUGI2QmpHK1dxTytvUFNISXph?=
 =?utf-8?B?d0RzSHZMNXZaeklEUGtNN1Z3ZzkyS0U5QkcyakcxL29FUXhVWERDanFEQ3gy?=
 =?utf-8?B?OW9UOCtsQVBDVzFZdEVDVURQY0Z3SWIweUorYmFBYytrZkhDUm16TENCdkJi?=
 =?utf-8?B?eCtIcGhiakVXZXlWMGRjVmExTDlOV2N4MWtVK0hZb3RvMVBhR3BlNHMyODI5?=
 =?utf-8?B?V0xYalYveHVrT1Y5KzRZVzhSRmNQTjdRVk14N041QUs0RVd3bXdIQ3NadVFt?=
 =?utf-8?B?VHQrV1F6VzVUelM3ZjFzdGNNV0pON0VMNUdONk1EQlVmSnlJd29FSllRYmJJ?=
 =?utf-8?B?R3pCT2Ywa0pNSEZiRE1QdTFaVUE0ejB4bVhYNVE5MnR4K0hQd2lSNmJrWWd2?=
 =?utf-8?B?S0dJWExVbWJMZUpyRUUzUWM0MGJwT3ErSDVqSExjUE9TMCt5Skx1Wk1QaVpT?=
 =?utf-8?B?dVZxQjRwTGV0VVlpaTBJM1Z3ZlFPK3RlOGpWc0xIM3NWanNObnNTQWdtUk4x?=
 =?utf-8?B?Q0lpV08zcjhsendCaldiS3pLaW9qdFhiY3JzcXFXcTZpdmJXS0RpWENnVVVl?=
 =?utf-8?B?eDBkNFJkY29WWGxOTWg3c3FTMEZCNkZPdEJGTjllUTh0eGx2UFFPNjBxUGVD?=
 =?utf-8?B?MjZ5NTBpbnpDZ1J3UjFteEdhbXlVOVN2WWVHZ2pmTkVwNS93NHFvM0pxSldv?=
 =?utf-8?B?MkFnN2F5a0FxSmgwNW1xVXduZDI5T0hKWiszUlpMUHZSZ2dzVlpoeGFHN3g4?=
 =?utf-8?B?R1JTWWhzeEpQcE9pWlpJNWlaK28xZzA3Tm1iOGo0RVBwcVIxK3ArQUtUUU5N?=
 =?utf-8?B?OGJIbGNiVHI5WnFIdGNnaUx2eUtpNHN4ZjBSdStJelNqOUtTVWhCbFcyNnZU?=
 =?utf-8?B?OXpYcUx4bTk0dHdTb01ZRk41aTJ4K1pQRmM5SVVaYmtTRmhuUTF0OTRjMnZT?=
 =?utf-8?B?dFBXbW1WY1pPY1VrQXI2S3FCRjEzeWw2cXVhanhFS0VUTmhRRGw0c1htTVh3?=
 =?utf-8?B?N0lNOUNxWjV4dzRlSUhERFQ5L2w2MzBGNEFuK2VBaGlYcUVzUkZoZlFoK1N4?=
 =?utf-8?B?VlcxeVVMY0k1cE5PcUpyUVc0UVhvWUZaeDBKWGZQdFZuUnRXdlVGVERvNy9B?=
 =?utf-8?B?bVo3eE0rMEhuQzBTbVBVdUdoV2ZZSWVlT0FsQjRjZXhUQms2Mm0ybGF4SXgx?=
 =?utf-8?B?c1pVbXdldCtrN2tmbnVNQStTK0o2ZHBPbWRBNVYzSHp4dmZPQWNtVC9ZV1Zk?=
 =?utf-8?B?YThRYm1SUCsrWERnWm1jYkJDNjFOZ1hJWkhrdS9pNEJWa2tWUGxnYXNHVmxS?=
 =?utf-8?B?TmN2MjUyK2M1cUJINVFDcGxYZVNQZXpTRkVvdmdzRmJhODU3Zlh4Zis0aWZQ?=
 =?utf-8?B?cFVtNWM2NTVSZjRRWXZvc3UzZmNvUHpDK3QvenNobjRnWkZzdzh6SC9uc2lk?=
 =?utf-8?B?c3ppTkQ0SEIvMStrR0lWMzJUbi8xcjRSSlhhTE1FdmlyanlIRkh6SEVZZVBV?=
 =?utf-8?B?dUpBUlVEd2dBbncwMDQrZlhQSXY4V09xMWVXQjBzdFY2VVpXSVgzczJJSFpB?=
 =?utf-8?B?TitOWUJmMEZPMnJlbTl2OHlBalRiN1l2VEMrZncrSGpXR0FJME0wUU1iYmUx?=
 =?utf-8?B?Vnh4NHN6dzNkbUtObU1paHhmRTR1QU8xSXR5TVhtNWl5MHFybXUyU0w0bDg3?=
 =?utf-8?B?amU4SlhWT2Y2NFh4T1B6ci9zbU5aSE83R3dpSHJDTnArblB3c1dpbS9GZzlZ?=
 =?utf-8?B?R3VNdW8wUUx5MkxIdm0rNnBHOEpUZ1doNmxqRlA4Y1ZHb0xyblZDcW1FNHJy?=
 =?utf-8?B?eTVoOHErMk5GV1NZaVRzR0MrKzJpRmEvbE9vb3lrUmlLbWMzZHJmckJJWm9x?=
 =?utf-8?B?eWppdG0wR3dHSDU2Sm0xQWprY3QwdWVHWU00WUh6cVZYVnZKWWE2eFB1bm5l?=
 =?utf-8?B?dmJsRlV3dStxbm4zNUIvRUxQdCthWEVYQW1mMWFuV2VjUGdZeFFzOWp3YjZJ?=
 =?utf-8?B?V2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B9457C4518681C4AA2DAEEEAB5BA8225@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79246551-20d9-472e-29b2-08dd7bf0024c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2025 07:34:51.7319
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pqJOSl0/Ue30zH4ltTMatJlDqkVHautpjOm5DUzdXmAotmkt+I0XIhL8q1+NKMrHwtvH6Q7sQfNdb62B+Athfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7199

T24gVGh1LCAyMDI1LTA0LTAzIGF0IDE0OjE3IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRo
ZSBjb250ZW50Lg0KPiANCj4gDQo+IHVmc2hjZF9zaG91bGRfaW5mb3JtX21vbml0b3IoKSBvbmx5
IHJldHVybnMgJ3RydWUnIGZvciBTQ1NJIGNvbW1hbmRzLg0KPiBJbnN0ZWFkIG9mIGNoZWNraW5n
IGluc2lkZSB1ZnNoY2Rfc2hvdWxkX2luZm9ybV9tb25pdG9yKCkgd2hldGhlciBpdHMNCj4gc2Vj
b25kIGFyZ3VtZW50IHJlcHJlc2VudHMgYSBTQ1NJIGNvbW1hbmQsIG9ubHkgY2FsbCB0aGlzIGZ1
bmN0aW9uDQo+IGZvcg0KPiBTQ1NJIGNvbW1hbmRzLiBUaGlzIHBhdGNoIHByZXBhcmVzIGZvciBy
ZW1vdmluZyB0aGUgbHJicC0+Y21kIG1lbWJlci4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEJhcnQg
VmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KPiANCg0KUmV2aWV3ZWQtYnk6IFBldGVy
IFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KDQoNCg==
