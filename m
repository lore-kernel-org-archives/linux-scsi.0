Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B42169AF7
	for <linux-scsi@vger.kernel.org>; Fri, 21 Jun 2024 06:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718952901; cv=fail; b=nQloqXqM8RlaqC5fXL8EQ6UwHvauMM4CSJt6ORrdB/SdSK52pQwJpielPQQutTz0SK7I+fWrVU1xTrGAZVEwCZzNCNNiCOqUO+DTC/E9jymp2jx3OY8FMal+ZPejrPok20xZQ0qCD7UZnnkTfoqc51LaBnfH+JULOl7Payghx5k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718952901; c=relaxed/simple;
	bh=8Um81Bjb/lmJJRgK5i3fhsqZOxtlsGCkqqrNZCE9rZM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cK02u77yFLeMC3NP42VvxO4+GgL7rlF04yBkWc82N6wk/X7JyFB8Oxs/5H3FxuUItw5PuoJzGqxkY8HSyK0qNiVm3n3gSzAn5jx5tWW7ROT9CgUuMho9QgaUeZSvgyXbTf9wZapVwqCHQTmt9a2qY3zKAlrBL0+M6Dg+nHuDvkI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=dQGVwvq5; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=fbESXUrN; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="dQGVwvq5";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="fbESXUrN"
X-UUID: 26203ae62f9b11ef8da6557f11777fc4-20240621
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=8Um81Bjb/lmJJRgK5i3fhsqZOxtlsGCkqqrNZCE9rZM=;
	b=dQGVwvq5v1o8VStoStAaIRn4xqmgnLv0HmVHjaNE/OmKpqdB8IHmxIlsm5W87zGW/tX51pFiFAftsf8HwahReNzqgXU0Q9yImZUVaYBRwvZFJ1q8x6uf1XKG+7QggmbuaiQ/WgUspH1qxkDjatn08ukh3cBDwL1ksbjLV+AOGOE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.39,REQID:faf11656-1751-42fd-bb38-8b24152c6cd7,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:393d96e,CLOUDID:59d5d944-4544-4d06-b2b2-d7e12813c598,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 26203ae62f9b11ef8da6557f11777fc4-20240621
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 233551817; Fri, 21 Jun 2024 14:54:47 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 21 Jun 2024 14:54:46 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 21 Jun 2024 14:54:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XyErZI4QsEXlgrcDCe+k+Ixn9+foBENDTKzjifkYb/yOicmdN6FoDkQsCBdX8Sv3U5OmolP9E+hhiCc//pGQBSQx6f3M+yVSgAvQ4CtMENFQp9+rMz/RFjG6rqoEys0n0243xq/uNPeJ2BMgJG+yt1VDXOX4UhvQhjAzHEYeAz2GfECwKsLnqq5IOisPrt98FOca4vmBz3ydLOltE41WbcgYh0IypxkAxMikhX+aiwUyGFjUXnlBy/w8JPzcxkoz3OHDyLKh9LBUjcmyqyfGXFsPMV+wlPwTenjYhbZ2ZcQjTCRHPN0LwRK7CUFbbz4aguMppfHWCsIxztFDnqP1Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Um81Bjb/lmJJRgK5i3fhsqZOxtlsGCkqqrNZCE9rZM=;
 b=cG17enIno9d6tEWv2+rlzOSh15ntcZZT7T0UGGHVmmpoHqLReesobSTftJCuWJ3H5+4bXmXVwvck3cXbp+Zk8zElmqUHc/G/eYkHoSmNwCTI76nPBkkYfNZS3a2++cCvCgF022bRf5i5RHCnTWJOWTWn8zJZwXZuVoey3hyhY+6gOikrXCVF00a2WvuxwQG/ZrMh6N9fz8TPGjtqHgxFCYwNSM/zbTBYF/kaxM+3dTYWHvCks3VgAK+ED/o3O/of5HHD2JquJBLQegm2OcvNw+LWq4ZM9bhQQfG1a2tGcYgO6I2DVPpeGtFfrVrE4K82GJGZqe4UiLMJnuhwWEjNgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Um81Bjb/lmJJRgK5i3fhsqZOxtlsGCkqqrNZCE9rZM=;
 b=fbESXUrNvcKQ3dio4uuOW8znW81CuZVMZIOABXIWlJITZSBdWOQ4zzZqyETO1Z/Ne5sPVo3/JbtEYoZHolRzDsrY47FK/QmlUUqgy9OpHTXkz9+U1q22zRhUB5Pmy2k0IdZ9xcu45tEteOP8sEcZ1z2dB7dN8oecG5YqZEzAXvA=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB7829.apcprd03.prod.outlook.com (2603:1096:101:17e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.34; Fri, 21 Jun
 2024 06:54:44 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7677.030; Fri, 21 Jun 2024
 06:54:44 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"ahalaney@redhat.com" <ahalaney@redhat.com>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>
Subject: Re: [PATCH 8/8] scsi: ufs: Check for completion from the timeout
 handler
Thread-Topic: [PATCH 8/8] scsi: ufs: Check for completion from the timeout
 handler
Thread-Index: AQHawPrEvEtR2PxEBkyAfPJ3MA8LCbHRzdSA
Date: Fri, 21 Jun 2024 06:54:44 +0000
Message-ID: <054eef8dec43e51aec02997ad3573250b357bee2.camel@mediatek.com>
References: <20240617210844.337476-1-bvanassche@acm.org>
	 <20240617210844.337476-9-bvanassche@acm.org>
In-Reply-To: <20240617210844.337476-9-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB7829:EE_
x-ms-office365-filtering-correlation-id: 10c2afab-95c5-47b9-1ca9-08dc91bf0874
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|1800799021|376011|366013|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?ZGR2am1QU08vOFlWdFMvU1RPbE9pcTVwNW01cysxQ0xxS1IrWU9wV2ZZNERq?=
 =?utf-8?B?ZHl5WjVYNU1neGY4UDRBK0s3VkpEYVdLOC9HVUdyQ2Vqa21SbXNBMzVrdjZK?=
 =?utf-8?B?aXVKaHRyTUJ2UGJTcUR4VDVCQTBQaUgrZHAzeSs1K2NNNTFEYVB1ZHdHM2Fs?=
 =?utf-8?B?RG1IVkd0V2V1YlpKbW5ISi9oMmpaYXFZYXNDaVRpbjNwVkJUb3dmNnpYbUNp?=
 =?utf-8?B?RTZGR0xHQXB4WDM4eDgxQ0xVSzhZMjhrczNNWVpXRHlzdzdwZXlkNXduSmNi?=
 =?utf-8?B?S1cweXA0MndnOVlSL2VwblhRRnp6NXVrdFJSZTFURzUrcHNBaDR1ZDAzcm1L?=
 =?utf-8?B?YlJ0cjhMUkl2VU5mcHgyUkNIR0hkUWd1VnRmcFg2QnVVNGwya2t1NklTMHdQ?=
 =?utf-8?B?Rit4bXJLV01SdXBxeG4zSnZsQkhLZE5JT0UwOStSQlhFdFVvNXBGWkRkN0hq?=
 =?utf-8?B?VHYza0pxOWxQQTFIYmttYU8zbXR1YUd4dlh1S3pqdm1kNHFoMksrT2g0Z295?=
 =?utf-8?B?V3NOc1Izc0VsRUZrT1dNN3JNMjJwUUZXOWRKTDkvbWJOZW9zTEZ0WVlTWEZC?=
 =?utf-8?B?R25rU0dyL3JaOGFqYUFEWW4zT3M2aEdTWjY4WnhXdkt4V2VtRWcrLzQ4WEFH?=
 =?utf-8?B?MG5wYzQvMTFJaFNRUGVPekVyY003VFNxczhQSndGbGRZT2VTYTMybEV6NmpE?=
 =?utf-8?B?dStyUmgyNjhXSlcyMW9YcG9RNkVveEJ3NEdYdTB6N0Z0Q3ptM1NlS29aeU9x?=
 =?utf-8?B?WnZUb3dYV0JqTjdndlR3SFR3OHpaSVVsOVpJVG0yUXJxVFAvYVRsUjF6dTdG?=
 =?utf-8?B?amxiUmNDclYzVDR6Tml0QXUyL0UyRW5MVjQ1dFhXZHZGNWl2VkVLRDRIQXQ5?=
 =?utf-8?B?cGs4SHNidVAwdXRCemd1Q2E5RHdxdkpDS2Q5dnFuVGlPTW1iWGxnSlZDazJC?=
 =?utf-8?B?dERPTUxSVmVXUVV0MGl1cEtwMGtiNEFhYjZ5eHZIcHZmZGtycCthRHVKN3I5?=
 =?utf-8?B?U3lkWWEyYmFYQ0xBOHdYUkY2aGZmd1I5N3UwU2QzL0FEdGlmV3FDUExNZEcv?=
 =?utf-8?B?dVlOZ2FiMGN4UngvZnN4cUdnbHdaUXZLVjRXZXh6ZlFMQlJ3YnIzQWlEdUJo?=
 =?utf-8?B?M2FhcUtOMUxtNXFxZUlTWkdDcGxqSld3dXUremRUU2tyK2haMUJKaVdwVTlV?=
 =?utf-8?B?NG5SbGUweVZzaWJMSEFXeW9FeFdKb1ZzcDJDVWNSRWRwWEptS2UyZFlEMU54?=
 =?utf-8?B?OG1SclNaYkdnR3d3T1pnMThidDNGZzhsclFaTG4yMUlLazRSaHV0QjMvV0RK?=
 =?utf-8?B?ejgxdndSUUFwSWtCUHBZYmJ5LzRoMlZZVTN6NlYxMnpsSFFGUm1LS3R1ZUp4?=
 =?utf-8?B?MFo3c0tmSDUyVnNQdDhCelUvOXlydXRBSG8rY2R0QmFzK05ObjFhZThGcEhN?=
 =?utf-8?B?MGxIaE1LSitVSk92WDVvbzFiYzN0QmtUNUFORWVYZ1hrY0hiamUwZVdVSzk5?=
 =?utf-8?B?WFlMblVJUDJTdWNoRnNrWlV6dHM1Mzd0cGg3TGROUXY4TmxsaTN3em82OUdF?=
 =?utf-8?B?QWRRMmZDZWpwY0RCbDI4c2c1bXRkcHJWN1JuUHY1d1lLS3RtY0t3ZVFlemla?=
 =?utf-8?B?WEhmZHNwaWxuMXpWNmxQRERvd1R6U2lhK1JLNC85MDVmdkhqVm5rWFNuWDU5?=
 =?utf-8?B?T2RoL2FVZ3pPYTd5K3dWK0twUVVYWVJUMTY1amQyNEd2QVMzSGVnUG9UbmR2?=
 =?utf-8?B?bHY5bEVlRTZJN2J4Z2RwT0ppdm95SVoyalJSMlUwOUNhblFIUnhmc1lpUDRM?=
 =?utf-8?Q?YAOD+ZHUEA1bdt5basLdX68zQ2bsnprDlgnRs=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(376011)(366013)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V3lhMmxTclBrNmNHbkRMOExPTXlhUUxQY3FRdHRZTHNVY1dKbFFjZS9BNnZS?=
 =?utf-8?B?V3ltVG42QlpuaEExdkJySlgwRWNrWkE5TWNQQlRsc2JHVUk3N2craHpWUDdZ?=
 =?utf-8?B?TVA3L2V4a29kNDN1aGF6TG9ZTFppc0dmcFlqQlppUm9ZaUt0b1dFNk93TlNJ?=
 =?utf-8?B?WnE3bG9LSTJwejFuNEhNMFhvNGk5RnNKdG9JZTlVc1dHOFBCVGxmRmNoSzVM?=
 =?utf-8?B?QlRaSHNZVGNCM3p4OGxPQ2kxb0tPTGxWdi9HN0xiSkQzaWJWcHFSVER0Zi9n?=
 =?utf-8?B?ZFhKVDlWVkUwd0gzZTJxbHFVVmFuTThzMVVnczJiaEJPcjJEWWVSa245RHQr?=
 =?utf-8?B?T0dpUlVXdldjNTNjcHZyVndwaFhJd0ZYc293ODd4eXdTbVNWR3k4T0lHUkpW?=
 =?utf-8?B?YTJKY3FoU2owVERwUzMrZXoyRC83WHo4a05OeHErTzQ0SkFGT3ZQRGdsaHFs?=
 =?utf-8?B?cXhoL1p5YjNjc2dxRERBcFZFdWxoNWZKcEp6V2IvQllMUUhMSnZXay9iNjda?=
 =?utf-8?B?K0FqSlZSVmNJbTVUOEZJTE1NMlJydkJFTDU2Mzh6RHBCYmt2TTNNb0V4eEZN?=
 =?utf-8?B?UE96NDMyUGo1ZnVBTTZRRGtHOFBzSzNXZ2R1L1pZbnpFU1NTbmQ0Nzlxb1Y5?=
 =?utf-8?B?emxtZXlKdXhQOWJOVy9LNEsxV0NhNHVENkpaTksrN29UVFYvb3pqTGdpQ1Vw?=
 =?utf-8?B?M2YwZ3RpdnEyZEk3eDlVTW9MT05obmhvN0ZaREFJajc0TjZXQ2dGY2VVcXB3?=
 =?utf-8?B?blRYckdtdmNZSVRxa1pCc1owVWFCcmtvS21jNSs5dkhSYTBvOGZvU3ZSaFUw?=
 =?utf-8?B?UlZFandTVFZNTFplVU90aytWUStoL2RBQUpZRzh3bWJndm16S01UV2ZpRkZQ?=
 =?utf-8?B?ZFVIUHhjSjV5UzZ4dDVudmY1MHB2MGdrU0RXUWxka0ZBc01YYWk1TE4veFRh?=
 =?utf-8?B?OGVRUVk5UXphSmhnVXRTclpwUTRzN0xmSVA1YXZXM2pFdHVEWmhjaEoyMVcr?=
 =?utf-8?B?MEpFdEpXTmVlMHdnT0NpdlRYL3VBdVpkVnQ5aDB4dGthUytzTG1EbURGQy9S?=
 =?utf-8?B?TElDb3pLRit0MGN5dUd4NXU5YklzaDhlUjdiM2JvM2JUYk0vKzZGL01TVkZu?=
 =?utf-8?B?YnZ4M0pJWldsa3RPUXRwWEY5Qjk4QkZiK1pvb0JFL2R1RVo2TEErSlRvMXpR?=
 =?utf-8?B?MlB0VkdnYms4ZllidUM0UytMT29wVVFoSnFvTmlvVUtLMmdRbkxOWTNZL2pE?=
 =?utf-8?B?TFR3RW5FbnJreVJzU3poVVJvZnVXdnVRdXFEdmRwOSt2akgxVFpOYjZ4c0pO?=
 =?utf-8?B?cWc5ci9ORGtIb2l1VFVXUjY4UnVJdE5RRk5tb2VyTXZWSkpYeXJmV0FOSW4x?=
 =?utf-8?B?R1FVSDlMNDNRMkZjckI3YUJTNHg4UnJBMGM1L254WUtEK1NsdlptK0pmQkti?=
 =?utf-8?B?N2RWZm9TR1czbkcxaEJUNkNLZ0VIc0x6SE1UNk9sTU8vRlJIdGVTTXp6RXYr?=
 =?utf-8?B?bTRVRjcrY0ZOcEc5aGNrOHJjM3Qwc25UeTQwNlRKOTdhcEYwYVJNN3ljTzRw?=
 =?utf-8?B?QXlJVzZ3RnRyK0tqZmMySEpzNjlHQmthVFNxYU81bUdFN0ZUQVh4eTlROVov?=
 =?utf-8?B?bkRDQkg5enRVMzl3VUdrSGh4Y3lQdXc1dU04MGZNc2hLYnhJUDFKVWoyU3Nl?=
 =?utf-8?B?Y3liYlZZdEZYSVFUTFB5Rm42cCsyL1gxdVdLUDBNbWpockZxbCt2bHhhdks1?=
 =?utf-8?B?SmZ5bTBUbytNakU5Q3JVZU9Qek04UVV2U0tMd0VFYVRwRmpxQnB3MVJGVkFB?=
 =?utf-8?B?ZXFCNVR3UkEva2hSK0VvbThrZm03Yk01Qm9CbjMyVmlaN0xBbk1mUm0vL3dm?=
 =?utf-8?B?THVnUnFjV1RlWi9nUTFKQ0hjdWFwdktnazc5UCt2UU9oNzhkd3JyUUNPNHNO?=
 =?utf-8?B?UVlIek9JUmdTdTh2MEw0dEQxb2FZUHd6eVk2SXI0Yy9WYytHK2VuVjEzREFy?=
 =?utf-8?B?RTMvSXlYV3hYQmdmM0pMSU5NVDlhQmZVLzM1ajJRMU51MVpydjFiN0x4NjYr?=
 =?utf-8?B?RzI1NnI3Nm80VlJFQkJXenJLMmZVRnRyZVFEZTFnQW1qR2pIT3J4Yk1TVlIy?=
 =?utf-8?B?bFg4Sm1CUndVOTRpS1NJU21LdVNBdDNpVEVpSmwxcWRja2JLaFBoODlGMlk0?=
 =?utf-8?B?L3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F36E6698909A2344995ACD7ADBF249E3@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10c2afab-95c5-47b9-1ca9-08dc91bf0874
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2024 06:54:44.6128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XouVBm2wkvQttJYnfaxzePTndRp+sey/zWuXzgsMEgFJx6vhzS/4mMf89PDy3lkjkNCeyjhPFNGj050ZzQR3OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB7829
X-MTK: N

T24gTW9uLCAyMDI0LTA2LTE3IGF0IDE0OjA3IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgSWYgdWZzaGNkX2Fib3J0KCkgcmV0dXJucyBTVUNDRVNTIGZvciBh
biBhbHJlYWR5IGNvbXBsZXRlZCBjb21tYW5kDQo+IHRoZW4NCj4gdGhhdCBjb21tYW5kIGlzIGNv
bXBsZXRlZCB0d2ljZS4gVGhpcyByZXN1bHRzIGluIGEgY3Jhc2guIFByZXZlbnQNCj4gdGhpcyBi
eQ0KPiBjaGVja2luZyB3aGV0aGVyIGEgY29tbWFuZCBoYXMgY29tcGxldGVkIHdpdGhvdXQgY29t
cGxldGlvbiBpbnRlcnJ1cHQNCj4gZnJvbQ0KPiB0aGUgdGltZW91dCBoYW5kbGVyLiBUaGlzIENM
IGZpeGVzIHRoZSBmb2xsb3dpbmcga2VybmVsIGNyYXNoOg0KPiANCj4gVW5hYmxlIHRvIGhhbmRs
ZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0IHZpcnR1YWwgYWRkcmVzcw0KPiAw
MDAwMDAwMDAwMDAwMDAwDQo+IENhbGwgdHJhY2U6DQo+ICBkbWFfZGlyZWN0X21hcF9zZysweDcw
LzB4Mjc0DQo+ICBzY3NpX2RtYV9tYXArMHg4NC8weDEyNA0KPiAgdWZzaGNkX3F1ZXVlY29tbWFu
ZCsweDNmYy8weDg4MA0KPiAgc2NzaV9xdWV1ZV9ycSsweDdkMC8weDExMWMNCj4gIGJsa19tcV9k
aXNwYXRjaF9ycV9saXN0KzB4NDQwLzB4ZWJjDQo+ICBibGtfbXFfZG9fZGlzcGF0Y2hfc2NoZWQr
MHg1YTQvMHg2YjgNCj4gIF9fYmxrX21xX3NjaGVkX2Rpc3BhdGNoX3JlcXVlc3RzKzB4MTUwLzB4
MjIwDQo+ICBfX2Jsa19tcV9ydW5faHdfcXVldWUrMHhmMC8weDIxOA0KPiAgX19ibGtfbXFfZGVs
YXlfcnVuX2h3X3F1ZXVlKzB4OGMvMHgxOGMNCj4gIGJsa19tcV9ydW5faHdfcXVldWUrMHgxYTQv
MHgzNjANCj4gIGJsa19tcV9zY2hlZF9pbnNlcnRfcmVxdWVzdHMrMHgxMzAvMHgzMzQNCj4gIGJs
a19tcV9mbHVzaF9wbHVnX2xpc3QrMHgxMzgvMHgyMzQNCj4gIGJsa19mbHVzaF9wbHVnX2xpc3Qr
MHgxMTgvMHgxNjQNCj4gIGJsa19maW5pc2hfcGx1ZygpDQo+ICByZWFkX3BhZ2VzKzB4MzhjLzB4
NDA4DQo+ICBwYWdlX2NhY2hlX3JhX3VuYm91bmRlZCsweDIzMC8weDJmOA0KPiAgZG9fc3luY19t
bWFwX3JlYWRhaGVhZCsweDFhNC8weDIwOA0KPiAgZmlsZW1hcF9mYXVsdCsweDI3Yy8weDhmNA0K
PiAgZjJmc19maWxlbWFwX2ZhdWx0KzB4MjgvMHhmYw0KPiAgX19kb19mYXVsdCsweGM0LzB4MjA4
DQo+ICBoYW5kbGVfcHRlX2ZhdWx0KzB4MjkwLzB4ZTA0DQo+ICBkb19oYW5kbGVfbW1fZmF1bHQr
MHg1MmMvMHg4NTgNCj4gIGRvX3BhZ2VfZmF1bHQrMHg1ZGMvMHg3OTgNCj4gIGRvX3RyYW5zbGF0
aW9uX2ZhdWx0KzB4NDAvMHg1NA0KPiAgZG9fbWVtX2Fib3J0KzB4NjAvMHgxMzQNCj4gIGVsMF9k
YSsweDQwLzB4YjgNCj4gIGVsMHRfNjRfc3luY19oYW5kbGVyKzB4YzQvMHhlNA0KPiAgZWwwdF82
NF9zeW5jKzB4MWI0LzB4MWI4DQo+IA0KDQpIaSBCYXJ0LA0KDQpUaGlzIGJhY2t0cmFjZSBpcyB1
ZnNoY2RfcXVldWVjb21tYW5kIEtFLg0KSWYgdWZzaGNkX2Fib3J0KCkgY29tcGxldGUgYW4gYWxy
ZWFkeSBjb21wbGV0ZWQgY29tbWFuZCwgDQppdCBzaG91bGQgYmUgS0Ugd2l0aCB1ZnNoY2RfYWJv
cnQgYmFja3RyYWNlPw0KDQpNb3JlLCBpZiBhIGNvbW1hbmQgaXMgY29tcGxldGVkIGJ5IGlycS4N
ClRoZSBycSBtYXkgYmUgcmVsZWFzZSBhbmQgdWZzaGNkX21jcV9yZXFfdG9faHdxKGhiYSwgcnEp
IHdpbGwgZ2V0IEtFDQpIZXJlIGlzIG91ciBiYWNrdHJhY2Ugb2YgdGhpcyBjYXNlLg0KDQpwbGF0
Zm9ybSArcGxhdGZvcm06MTEyYjAwMDAudWZzaGNpIHVmc2hjZC1tdGsgMTEyYjAwMDAudWZzaGNp
Og0KdWZzaGNkX3RyeV90b19hYm9ydF90YXNrOiBjbWQgYXQgdGFnIDQxIG5vdCBwZW5kaW5nIGlu
IHRoZSBkZXZpY2UuDQpwbGF0Zm9ybSArcGxhdGZvcm06MTEyYjAwMDAudWZzaGNpIHVmc2hjZC1t
dGsgMTEyYjAwMDAudWZzaGNpOg0KdWZzaGNkX3RyeV90b19hYm9ydF90YXNrOiBjbWQgYXQgdGFn
PTQxIGlzIGNsZWFyZWQuDQpwbGF0Zm9ybSArcGxhdGZvcm06MTEyYjAwMDAudWZzaGNpIHVmc2hj
ZC1tdGsgMTEyYjAwMDAudWZzaGNpOiBBYm9ydGluZw0KdGFnIDQxIC8gQ0RCIDB4Mjggc3VjY2Vl
ZGVkDQogIFVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBh
dCB2aXJ0dWFsIGFkZHJlc3MNCjAwMDAwMDAwMDAwMDAxOTQNCiAgcGMgOiBbMHhmZmZmZmZkZGQ3
YTc5YmY4XSBibGtfbXFfdW5pcXVlX3RhZysweDgvMHgxNA0KICBsciA6IFsweGZmZmZmZmRkZDYx
NTViODRdIHVmc2hjZF9tY3FfcmVxX3RvX2h3cSsweDFjLzB4NDANClt1ZnNfbWVkaWF0ZWtfbW9k
X2lzZV0NCiAgIGRvX21lbV9hYm9ydCsweDU4LzB4MTE4DQogICBlbDFfYWJvcnQrMHgzYy8weDVj
DQogICBlbDFoXzY0X3N5bmNfaGFuZGxlcisweDU0LzB4OTANCiAgIGVsMWhfNjRfc3luYysweDY4
LzB4NmMNCiAgIGJsa19tcV91bmlxdWVfdGFnKzB4OC8weDE0DQogICB1ZnNoY2RfZXJyX2hhbmRs
ZXIrMHhhZTQvMHhmYTggW3Vmc19tZWRpYXRla19tb2RfaXNlXQ0KICAgcHJvY2Vzc19vbmVfd29y
aysweDIwOC8weDRmYw0KICAgd29ya2VyX3RocmVhZCsweDIyOC8weDQzOA0KICAga3RocmVhZCsw
eDEwNC8weDFkNA0KICAgcmV0X2Zyb21fZm9yaysweDEwLzB4MjANCg0KVGhhbmtzLg0KUGV0ZXIN
Cg0KDQoNCj4gU2lnbmVkLW9mZi1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5v
cmc+DQo+IC0tLQ0KPiAgZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyB8IDIzICsrKysrKysrKysr
KysrKysrKysrKystDQo+ICAxIGZpbGUgY2hhbmdlZCwgMjIgaW5zZXJ0aW9ucygrKSwgMSBkZWxl
dGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgYi9k
cml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+IGluZGV4IGUzODM1ZTYxZTRiMS4uNDdjYzA4MDJj
NGY0IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ICsrKyBiL2Ry
aXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gQEAgLTg5MjIsNyArODkyMiwyOCBAQCBzdGF0aWMg
dm9pZCB1ZnNoY2RfYXN5bmNfc2Nhbih2b2lkICpkYXRhLA0KPiBhc3luY19jb29raWVfdCBjb29r
aWUpDQo+ICANCj4gIHN0YXRpYyBlbnVtIHNjc2lfdGltZW91dF9hY3Rpb24gdWZzaGNkX2VoX3Rp
bWVkX291dChzdHJ1Y3Qgc2NzaV9jbW5kDQo+ICpzY21kKQ0KPiAgew0KPiAtc3RydWN0IHVmc19o
YmEgKmhiYSA9IHNob3N0X3ByaXYoc2NtZC0+ZGV2aWNlLT5ob3N0KTsNCj4gK3N0cnVjdCBzY3Np
X2RldmljZSAqc2RldiA9IHNjbWQtPmRldmljZTsNCj4gK3N0cnVjdCB1ZnNfaGJhICpoYmEgPSBz
aG9zdF9wcml2KHNkZXYtPmhvc3QpOw0KPiArc3RydWN0IHNjc2lfY21uZCAqY21kMiA9IHNjbWQ7
DQo+ICtjb25zdCB1MzIgdW5pcXVlX3RhZyA9IGJsa19tcV91bmlxdWVfdGFnKHNjc2lfY21kX3Rv
X3JxKHNjbWQpKTsNCj4gKw0KPiArV0FSTl9PTl9PTkNFKCFzY21kKTsNCj4gKw0KPiAraWYgKGlz
X21jcV9lbmFibGVkKGhiYSkpIHsNCj4gK3N0cnVjdCByZXF1ZXN0ICpycSA9IHNjc2lfY21kX3Rv
X3JxKHNjbWQpOw0KPiArc3RydWN0IHVmc19od19xdWV1ZSAqaHdxID0gdWZzaGNkX21jcV9yZXFf
dG9faHdxKGhiYSwgcnEpOw0KPiArDQo+ICt1ZnNoY2RfbWNxX3BvbGxfY3FlX2xvY2soaGJhLCBo
d3EsICZjbWQyKTsNCj4gK30gZWxzZSB7DQo+ICtfX3Vmc2hjZF9wb2xsKGhiYS0+aG9zdCwgVUZT
SENEX1BPTExfRlJPTV9JTlRFUlJVUFRfQ09OVEVYVCwNCj4gKyAgICAgICZjbWQyKTsNCj4gK30N
Cj4gK2lmIChjbWQyID09IE5VTEwpIHsNCj4gK3NkZXZfcHJpbnRrKEtFUk5fSU5GTywgc2RldiwN
Cj4gKyAgICAiJXM6IGNtZCB3aXRoIHRhZyAlI3ggaGFzIGFscmVhZHkgYmVlbiBjb21wbGV0ZWRc
biIsDQo+ICsgICAgX19mdW5jX18sIHVuaXF1ZV90YWcpOw0KPiArcmV0dXJuIFNDU0lfRUhfRE9O
RTsNCj4gK30NCj4gIA0KPiAgaWYgKCFoYmEtPnN5c3RlbV9zdXNwZW5kaW5nKSB7DQo+ICAvKiBB
Y3RpdmF0ZSB0aGUgZXJyb3IgaGFuZGxlciBpbiB0aGUgU0NTSSBjb3JlLiAqLw0K
