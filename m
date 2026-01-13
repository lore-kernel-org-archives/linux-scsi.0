Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865C32E54A3
	for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 07:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768289120; cv=fail; b=uKVKR3nk3bRKCXPDxGIga3h07Mr8ocAfwfNkUsuxOrqYv3/i/ADUhmErNiZZ0VnLNIuEweC+Gr4rBmofVFsy/2Z0czAF0MUwQVZxZ6eXSK1V/d5aaOFfHCl5t8ysg8NqvjM5nOI0D+P7tLB4h0MibGr3q6+iEFUuVlhUHu/TJwM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768289120; c=relaxed/simple;
	bh=16dgxFegyKI9fYRsGlU4A7DSDdoU1tK29rkWukCi/PE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lQK/09qjdDHVjVWWYE8a8t6S02ip7zKxBsvuV0S8AC+RC2jqsyV8Kt8sPmEh7NZ6/F6GzrgDDG/HwQ9PXkr2aNo8efh5wEQlLQ08rW1guzqfzUA2GzC3ntn6Eu8F5rMYVQ5aqegIHg/QLpMVyoDrdS89qSRFHT61fa7uAnq7880=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Qm478y/Q; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=qQC/LtWh; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Qm478y/Q";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="qQC/LtWh"
X-UUID: feae11eaf05011f0bb3cf39eaa2364eb-20260113
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=16dgxFegyKI9fYRsGlU4A7DSDdoU1tK29rkWukCi/PE=;
	b=Qm478y/QfWfryU8sFTyKoCNED/9Q+akMhzyachMp/FY/gh6AzRkQHzTftjh5g2rhYKao9vOBacG5A4qZP6avrAb/HlSeU0I4CtZhvWIMwBwL1c4syFIOCYUChHTgcoZnEqwcqupymtKHCctdXtl3klu5yHIxl3xYGa0JNomMyrY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.9,REQID:e9a5b4cf-17ea-437c-835d-87a6c3b5319d,IP:0,UR
	L:0,TC:0,Content:2,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:2
X-CID-META: VersionHash:5047765,CLOUDID:bcdf77ef-16bd-4243-b4ca-b08ca08ab1d8,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:4|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: feae11eaf05011f0bb3cf39eaa2364eb-20260113
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 145768104; Tue, 13 Jan 2026 15:25:10 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Jan 2026 15:25:05 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 13 Jan 2026 15:25:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wkIBNyS5Dh4xAzG4OTSkDubulRalKR+Xiuje95hZCq5arbUTlfCfVuX0AV/1F+yOTTpGf5vnlDwE1TOLxVRAgv34ngiCvuWszY+nk2BcbYy3FXN7eOf8EAbRlo74aQ3ZrS6kVpp1+N5HYcNl2EdzeN2KB1FdUpKp+fXanHXgQr5+EPy6avlu66Hxuq2HrBZfV7mRMUZpGH3DZwzxQX5U4gbpv5V4r7kyaExXwENzkJAwR54sH9UYrIShf8geNYkhB5DZ6YHvRZt4IQSuxi4ILusi60urJnbUj6TWbzKgSwXcqVEuVoAHztxhMxm6P72LKpiWa6bdtjN4xFJUE75LlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=16dgxFegyKI9fYRsGlU4A7DSDdoU1tK29rkWukCi/PE=;
 b=D1G1VpBy2CEGS/qY2uhKZOmpdIjuJOALIAnzKJLdvr925PPQc/HdyOL23YZ32o+2vuC1/HqFkgJ112TQnBZFIcVEOS1OoBrBmqKS5uDunHkkTgA5VFQr5ynByFPdsEX4zNqzPyu7Yinl5oRSC9bQM2yGyJYOendFzQdNhzI10D9BTMTwr5FexQTDNs3dAI4CYtqUSkFOua6AF8tZP5FzRHIM0a09LVIMBUjRA1XRk2KnpqSJG5MjtDrMvmUmeCeEO51dZePQ5T8KP7CuA6IkKfcnSHSMqCnXvPQaWZSrYLazrAw87V8/oJe/IoVE+sdRO3pUqZbgHqy059/xcd24dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=16dgxFegyKI9fYRsGlU4A7DSDdoU1tK29rkWukCi/PE=;
 b=qQC/LtWhrRBtqflJyvJTzUF2/6y9q7i3PfqyzRn7IgWIN7htHobTgJROTP6sSpV0mXolRcXABZ3yR47etutSRMh9/PiuUaOxOwPVJO+EjdeLQl2mfmpTdJTRQKmnGGF1lnJDKFIsicb4dxJxxX7RgA2JbG0P0qcjkhNJ9WpAl1c=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYPPR03MB9498.apcprd03.prod.outlook.com (2603:1096:405:313::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 07:25:02 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 07:25:02 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"john.g.garry@oracle.com" <john.g.garry@oracle.com>,
	"avri.altman@sandisk.com" <avri.altman@sandisk.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>
Subject: Re: [PATCH v2 1/2] ufs: core: Only call scsi_host_busy() after the
 SCSI host has been added
Thread-Topic: [PATCH v2 1/2] ufs: core: Only call scsi_host_busy() after the
 SCSI host has been added
Thread-Index: AQHcganBO5w4GGw3Y0+qxTboi8G9MbVPuCGA
Date: Tue, 13 Jan 2026 07:25:01 +0000
Message-ID: <c00386a9fb2e9b15be970d1ec957e87828c8013f.camel@mediatek.com>
References: <20260109205104.496478-1-bvanassche@acm.org>
	 <20260109205104.496478-2-bvanassche@acm.org>
In-Reply-To: <20260109205104.496478-2-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYPPR03MB9498:EE_
x-ms-office365-filtering-correlation-id: cb282939-e778-4e8d-b696-08de5274dd8b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?NmxMN2hCcjlJOEVmY3dpbFhFRHRVUHJBTHRoclV4SzdZLzM1dEo1UmFURnVR?=
 =?utf-8?B?OEQ0L28ySkNna2Z3RzV6MDFEWWZiUlMzSFFjRnRIamVnWEtrL1k2WXdRYzVI?=
 =?utf-8?B?ZXFRS0FqRUM5aXFCWmRCY0I5dHA4dEUyU2xWTzhhaXZmcysrSWgzVmF6VnU2?=
 =?utf-8?B?S0J0ZkttbThWVStHbHhwRk4rWm1HdDBRWkZZekhFYnpxVGh0WlhTdThIKzRv?=
 =?utf-8?B?MDN5UkEvSnVIYStRNWtlNnRWd3BSaC9rWHFYb3dzbUg1bkpmcTBKNUE2Mld1?=
 =?utf-8?B?ZXpLcWEvaFVIWlltUVhuUjA0eHZpRUxNYjY5bldsWENpVXpvVHRvTnZxS0M0?=
 =?utf-8?B?RHMvZTIrV3paNkVqSklVMThLOVhyeDk3TVRUVDBZamlFY2pvVzhzRVhDNVFp?=
 =?utf-8?B?NnNvV1pmcllpdzNjRXAxTVpYNDlOc2xUZ2RhWFpzWkxHN084RStheENqWkVy?=
 =?utf-8?B?bWxseWlzZE42U3BTT2JCRHhUakFmem5UaEN2UG10b2lmT3lXZXJOcVV2SUhC?=
 =?utf-8?B?WWZHam5jYUFMWTRCbUlkVG5idmU0MjEvUXJaTjZKekU3cnNxZHVCSDRDUmRh?=
 =?utf-8?B?Ky9jRjFGRzZVMXdKVW9idUxKV2lvNlFGUXArY2x4QVpHNUFSbGd5ZzNDa3VY?=
 =?utf-8?B?QTk2T21GWG00elJaYWRlUGk5eEhLV05sYmFxbFovVTJaWGdtaE43eHpuVmpl?=
 =?utf-8?B?RDFWSTltaFRCVjgyaFVPYlJtMWo3aThaS25yenN1UFU2RzdZQk5icks0TlZ5?=
 =?utf-8?B?OGlQNzdpcjdlMitZSDdOOTl2dGxCUXBXaWI1UVpDdmYvTUpDSEcwd1ZxcGRn?=
 =?utf-8?B?SjF0aEFVWkpNUCsyMTVOMlpKMVBRbTdqTnN1RFdmc2VDOEs4UUtnOUV0STlU?=
 =?utf-8?B?WlNCV0c2NkszaHprNDRvZHQ3bGR0ZERoN0RkRTI2dWw2bWFicmUvTTdMSHB4?=
 =?utf-8?B?UVZ2SGtFRmVRSmxhTzlublE3cTNhYnhsZzBlZ0thQnZpY1Q1MG50MmJOQThh?=
 =?utf-8?B?MDMweEIxZDUzbHdlY1dOL3NxdFZ0MkFxL0kyNXEzbTdDZ3ZXUVRzR0c3dkdX?=
 =?utf-8?B?ZFVicVFIUVIyN0JtY2JPZklFUUNlam1PNnJKUkJFdU4vK096VmYvbHd4azRJ?=
 =?utf-8?B?MzNYVzVySDBpemU1Q1FXd1BkWnN2bE1UcTQrREJVVDdraUFGTGFZbmNqTUdR?=
 =?utf-8?B?M0paWlFPS2o1RzhMU0Eya3hPK2tmNUlZTE81b2Vyd2ZaWWwvMnhwMDh5M0kx?=
 =?utf-8?B?N3BhYTNiYTNTZ1Y1dytEMUhBUEJJbmZFaTFHVzk3UnE5RUh2K2wyVE54TmpW?=
 =?utf-8?B?RUQvNkUzN1p0YU9sdTQ2MzdadDFPRWp6TUJmNHFvbDRsOUFVcktvL29ZbFdK?=
 =?utf-8?B?Vml0cnVlUFVCUWdLeEdSeTJOdVR4RVBWQnpWZzVsdVZCWFhhcVBhYzgzQUxJ?=
 =?utf-8?B?Ky81MXVVd3c3b0RNWDU1L3BlejdrWjFQYW5pYW5acGpSanpBNnQwU2luYnF6?=
 =?utf-8?B?OUg0TFEyL0doYTAvd05RVlc1SEw3bGVVZ1pVcndtNzhCUDArMWhSR092dzIx?=
 =?utf-8?B?MXRPSUVuSGowbEp0QXRZZ3c2bDU5Q2VzOXBNZXBYeWNieWtmbWZsMlY3Ni9a?=
 =?utf-8?B?Rk1rQmJ2M3p3Mm5Id3RPZzVFamZ2eGxPc3JvUURITFI4ZkthVWo4elVJYzRX?=
 =?utf-8?B?eWFXbjNhQ2g5dytRaCtQRThGUjBHS1FnSkdiZ1dKc1VKWFEzQ0ZwVXJkSG1Z?=
 =?utf-8?B?OWlMZVhqMmwzUXkrb0RsM1lWa21CYXV1eHlqNVRJN3Vydk9Tb3J0dXpNSThE?=
 =?utf-8?B?a0Ezc09uU2ZYUmdXekkyTTVia1NSWXIrSGh0Q1psei9jWWU3WHNveUgxcEFW?=
 =?utf-8?B?L1ZSRHl1ZjZwQ2FoQWRvN3hCaDc0cGhnb2JqaVQrN3Bmek9DZUFpTE04c3hk?=
 =?utf-8?B?N3lEL3RvaHNmdkd6V2Z4NXNrMGZodlRHejdScVJxLzh0dnhQUUJrM3pVOURQ?=
 =?utf-8?B?VUZrWEdmL0VmM0xiTzN4WmFGZ3p6bU1VcmxjUjVjSG1aSkhVUUx0ZUZPU1hN?=
 =?utf-8?Q?PBjtMk?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MDRyVW5IamllZnIwZisydEJMVzZiOERBemxMZG5pZUNwTlExay95UjZPeCs2?=
 =?utf-8?B?c0IvZm1XdEplR2ljd2llK3hGS2ZMMy8xQzd0dUp6c3J2bnI1aUVnNW45OEkw?=
 =?utf-8?B?blA3NnBnS0tOSUZTb3hGR3hWYUx4ZDkwQ3VDSXV3VnlXVFRoeXpSQmtxcUZy?=
 =?utf-8?B?eHNFU0ZNUlNWSlBXUUdQRHl2aWhqNDRSbGdrb0RsYzdRMDA3YkhIdWVaTHQ1?=
 =?utf-8?B?U1VkcERZVWtoYW84bXIza0RPeWtrWm5nbGp0NGNyR2NWOGs0VkJ1VHpIM1l3?=
 =?utf-8?B?YzBhenFXTzE3b1ZjVWlTZGVnL05rMFE5a0R2SkRjMEFMNUJlc2lRQkhuWmU4?=
 =?utf-8?B?U04rNFQ0ZXRxeWx4WEJmQXVGQlJURk1KdkJoMk5DN0VQMjFSWEdaZnI1SmpZ?=
 =?utf-8?B?T3gxZGhiaHBOci9IVzZTUTlyYi81Q0dtUUVsSkFNVmNrNGZaWGs0MDFvVUdC?=
 =?utf-8?B?WDhIeTRPS0VONUVCcmV6UkZsejdYM0R4NGt3bitFRDFVMlpsUHdIMUlEcTBt?=
 =?utf-8?B?bzZ1aU5GQzBBOHdSbGRwK3greHRXTjhLa1hCeDBGK0pTWWhTZnY5UHloZ2Vt?=
 =?utf-8?B?dkQrMHRRYkR4SnZHNHZMSUI4djNXemVZOW5vdnhvdFNFM0FRaHFtZFNGUWRy?=
 =?utf-8?B?dWVLRzQxbk5jQkxGQTFpRmVXYmFJd09FYy8zVGlHVHorYnozOHhsSU9Yd1lY?=
 =?utf-8?B?WTJDREFiNVVab1JhWEN2SW1Qa2NkS2dTT3BGRFNYWUhjb2lhUFE5cGp4WXRq?=
 =?utf-8?B?WTZMYmM3YlJpc0w1ZFYzd3daK2haOUZLWnh2ci8wMVpqcjh0eEo3cHhJczlM?=
 =?utf-8?B?b1JQSG9MZ2FNMy9WS21iNlppZXIxMUtQM1RobmFvenVpczQ1NEpxRnU2SHNW?=
 =?utf-8?B?NzVlT2RZY3NpU2lVdGpMU1NMS3d5djlvWGhpV1dWQzB1c1Q5L0dJajlQdWlk?=
 =?utf-8?B?SHM3aytGbzVJSnZRSGpUMk56TmFuMWViSkc0YUFjamhoQ25iWitMaDJrQ3Ix?=
 =?utf-8?B?bHAzT3JIbkZVMWl1K2VCUkdmL1FldzdZeDhPSUFkTUExZlZLeTF0amZkYnNW?=
 =?utf-8?B?M0pnMW0rL1B4Q0ozRXU4Ui9ZNlBzWGhXWUMySVNnVjdaSzgrdFc2enZ1UXZO?=
 =?utf-8?B?QlFVRjJlMnZJOFZXRjlydWNNWkZWc2VDeExrcFRSUzk0czRXNjJhNDBLL2NU?=
 =?utf-8?B?U3RMTm9Rcyt2VmkyTUZOTjNQSVZCem83TGlpTHorQ3pFWEgzYzVGOThaeERs?=
 =?utf-8?B?Rnd5MGs4OGxuWFpaR2dFb01yOW1pR08xUkxnZzNmZzJkUTBsWVppcy9IaytU?=
 =?utf-8?B?VkJ1cStJSzV5cTdVWGdUWmdTYVdDMERFNkEyak9ZN3MwTkVhWlRUVUpkSjJB?=
 =?utf-8?B?Q0h4UlpsZnFOdGFkMFE1RU5pYXZ4aVRjWWkxYUxUUnBVS3JhSmNydXU4Y3FM?=
 =?utf-8?B?UDI2SGpOaXhaQ3ZVQnVtL0JPQ053UkFFT0R0ajJMbHRrOTNNUENNS0RWYzFt?=
 =?utf-8?B?UDFYRTh3YTkyY3pLR3dNWS9sRVA5U1hRSkFJWEg1V1dmeElKWC9hZDhoczJ1?=
 =?utf-8?B?U3hRVk4vbjdON3F1azRtK0pXVzFvK0grU0J1cG9admJiNTdGZnVOenFOazY1?=
 =?utf-8?B?ZHFXRlFaSkV0SEsybTZaU2daekM0dlRWTTNML0RsWUpiQTdOaDVheS92a1Jq?=
 =?utf-8?B?ZlVqcWFkVWg0MFFkV082TkRuaGFDZ0lRTjFrR1QxMk0vSkl5d0RxMTVBcE93?=
 =?utf-8?B?amNjK3NQbGRqeE44dU0vRGhkRzlZN1I5NU5ncXc1NS9la2VoZGYwMFU0c3pr?=
 =?utf-8?B?MEtESFpCQWYyU1Z0aXFqSXFxVWtlMGl5RGVHWXZzdmR6TmFNMjBnMzFPQmk1?=
 =?utf-8?B?bWZ1enpUbGUydlF0YjJvWGZlZmZVNlZaS1JDUmNxbzRLK3J0ck5TRE9VSk1F?=
 =?utf-8?B?TDlLWjVWaWhlZE5BNE02cUhGU2NQeUJEZHVRc1krUWQ1UzNxWjEyN2cxaXVB?=
 =?utf-8?B?d21qSkFxemJ2Z2lnbHp4bjdkOHNTZUFSekUvVFUzSC9OL0NuTGk0T2VkSzR6?=
 =?utf-8?B?OFFPSlo1T2RLSkV6T2ZOeWczdDY3MnhsQ21ZajdST3FLeld5Y1duV1JYcWNa?=
 =?utf-8?B?S2dSQ1Eyd2FYOW4vaTFBaGp0K1ZGKzRBVWZpWFo3ZldoNHYwMUxBRitFcS9u?=
 =?utf-8?B?a1JJYklQOWJFeXVQcXhZUkdocGJFaVlJZU5CK28vUUJjWXFTK01RMFhSVjJw?=
 =?utf-8?B?RDc2dkp2ZzdSZHY2OEVUTHMrbHBkMDNnUnppVmZ4UDNvVkpONC9VQUVmbzRk?=
 =?utf-8?B?TFk3SEhOM2ZtKzUyZnB0WDdUa2dNd0pqM0NBSTRYWWdZTExDSUU0cnhBKzJC?=
 =?utf-8?Q?0NlJZBgBOEACHQow=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E41B47599E26B468E8C0C17406F0F2D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb282939-e778-4e8d-b696-08de5274dd8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2026 07:25:01.9681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xb9/ksmUrt5ovUGUj+M7swSxUG6y1Ax+Zk1nG7HF1UUJ1WXG2S0O7IbutZCla5MU26S4q4oY3zJlvGrX3SKkdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYPPR03MB9498
X-MTK: N

T24gRnJpLCAyMDI2LTAxLTA5IGF0IDEyOjUxIC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IHNjc2lfaG9zdF9idXN5KCkgaXRlcmF0ZXMgb3ZlciB0aGUgaG9zdCB0YWcgc2V0LiBUaGUg
aG9zdCB0YWcgc2V0IGlzDQo+IGluaXRpYWxpemVkIGJ5IHNjc2lfbXFfc2V0dXBfdGFncygpLiBU
aGUgbGF0dGVyIGZ1bmN0aW9uIGlzIGNhbGxlZCBieQ0KPiBzY3NpX2FkZF9ob3N0KCkuIEhlbmNl
IG9ubHkgY2FsbCBzY3NpX2hvc3RfYnVzeSgpIGFmdGVyIHRoZSBTQ1NJIGhvc3QNCj4gaGFzIGJl
ZW4gYWRkZWQuIFRoaXMgcGF0Y2ggcHJlcGFyZXMgZm9yIHJldmVydGluZyBjb21taXQgYTBiNzc4
MDYwMmIxDQo+ICgic2NzaTogY29yZTogRml4IGEgcmVncmVzc2lvbiB0cmlnZ2VyZWQgYnkgc2Nz
aV9ob3N0X2J1c3koKSIpLg0KPiANCj4gUmV2aWV3ZWQtYnk6IEpvaG4gR2FycnkgPGpvaG4uZy5n
YXJyeUBvcmFjbGUuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5h
c3NjaGVAYWNtLm9yZz4NCj4gLS0tDQo+IMKgZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyB8IDYg
KysrKy0tDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMo
LSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jIGIvZHJpdmVy
cy91ZnMvY29yZS91ZnNoY2QuYw0KPiBpbmRleCA1NjJkOGNmZmM2ZjYuLjY5NjMwNjc3YjIzZiAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiArKysgYi9kcml2ZXJz
L3Vmcy9jb3JlL3Vmc2hjZC5jDQo+IEBAIC0yODMsNyArMjgzLDggQEAgc3RhdGljIGJvb2wgdWZz
aGNkX2hhc19wZW5kaW5nX3Rhc2tzKHN0cnVjdA0KPiB1ZnNfaGJhICpoYmEpDQo+IA0KPiDCoHN0
YXRpYyBib29sIHVmc2hjZF9pc191ZnNfZGV2X2J1c3koc3RydWN0IHVmc19oYmEgKmhiYSkNCj4g
wqB7DQo+IC3CoMKgwqDCoMKgwqAgcmV0dXJuIHNjc2lfaG9zdF9idXN5KGhiYS0+aG9zdCkgfHwN
Cj4gdWZzaGNkX2hhc19wZW5kaW5nX3Rhc2tzKGhiYSk7DQo+ICvCoMKgwqDCoMKgwqAgcmV0dXJu
IChoYmEtPnNjc2lfaG9zdF9hZGRlZCAmJiBzY3NpX2hvc3RfYnVzeShoYmEtPmhvc3QpKSB8fA0K
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1ZnNoY2RfaGFzX3BlbmRpbmdfdGFza3Mo
aGJhKTsNCj4gwqB9DQo+IA0KPiDCoHN0YXRpYyBjb25zdCBzdHJ1Y3QgdWZzX2Rldl9xdWlyayB1
ZnNfZml4dXBzW10gPSB7DQo+IEBAIC02NzgsNyArNjc5LDggQEAgc3RhdGljIHZvaWQgdWZzaGNk
X3ByaW50X2hvc3Rfc3RhdGUoc3RydWN0DQo+IHVmc19oYmEgKmhiYSkNCj4gDQo+IMKgwqDCoMKg
wqDCoMKgIGRldl9lcnIoaGJhLT5kZXYsICJVRlMgSG9zdCBzdGF0ZT0lZFxuIiwgaGJhLT51ZnNo
Y2Rfc3RhdGUpOw0KPiDCoMKgwqDCoMKgwqDCoCBkZXZfZXJyKGhiYS0+ZGV2LCAiJWQgb3V0c3Rh
bmRpbmcgcmVxcywgdGFza3M9MHglbHhcbiIsDQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHNjc2lfaG9zdF9idXN5KGhiYS0+aG9zdCksIGhiYS0+b3V0c3RhbmRpbmdfdGFza3MpOw0K
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBoYmEtPnNjc2lfaG9zdF9hZGRlZCA/IHNj
c2lfaG9zdF9idXN5KGhiYS0+aG9zdCkgOiAwLA0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBoYmEtPm91dHN0YW5kaW5nX3Rhc2tzKTsNCj4gwqDCoMKgwqDCoMKgwqAgZGV2X2Vyciho
YmEtPmRldiwgInNhdmVkX2Vycj0weCV4LCBzYXZlZF91aWNfZXJyPTB4JXhcbiIsDQo+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBoYmEtPnNhdmVkX2VyciwgaGJhLT5zYXZlZF91aWNf
ZXJyKTsNCj4gwqDCoMKgwqDCoMKgwqAgZGV2X2VycihoYmEtPmRldiwgIkRldmljZSBwb3dlciBt
b2RlPSVkLCBVSUMgbGluaw0KPiBzdGF0ZT0lZFxuIiwNCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdh
bmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KDQo=
