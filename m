Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853E329A5
	for <linux-scsi@vger.kernel.org>; Fri, 21 Jun 2024 03:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718940752; cv=fail; b=cmiq/VghP2LvvOMGqLl1X0ws4q5lUi4WS+NCga87HvnXu1izU/emZ7jryyU6CpUUbULz+sPkUHH8KcfK2ET12tBuZZ8+ATHSnw9RkeqppJW8iDS/MbuWGb7aVhCHhTH1dJ+cwoXIhWrNkGUVe81q3V8jdnQ6owoDAGI3OP4fs4Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718940752; c=relaxed/simple;
	bh=q5PgybQ83gomshbsJwAzmH7y0wuQp95IJmo6rx96p4k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jkY3kL6oiLZeCivlTn6xhfA1jvypkKyv7dxYme8pj7rP2ac8gn22YB0JSWtdUiadVUgoHUpewKpYIfhy5w/4pGsAId6zIMv4T5ZpU1IzJWP67v571aR5NLh0ltebzphPaZLYgnT0/vPWoMTLlin4uZtrSEFzqZD57B0ukgVpDXw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=lo8GB4zf; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=bPYfAOZ0; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="lo8GB4zf";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="bPYfAOZ0"
X-UUID: dff85d302f7e11ef8da6557f11777fc4-20240621
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=q5PgybQ83gomshbsJwAzmH7y0wuQp95IJmo6rx96p4k=;
	b=lo8GB4zfEGIYThlYJvyXFW3SL7hyrbMGjqw4fEFgMx/0DcirfH3Ty3XMcsMoeCfr+saXjL52ZQK61qEWgbIy5URHGGsXo3uri0mEGiV+LLeFxfGl9YLs5mAIQi0nNoto+ODYKNIVgP6XfNrHnAAlE6eY9kiBPq40Suovf0xfR7k=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.39,REQID:37b43693-3c2c-4274-afb6-36a9d15f577b,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:393d96e,CLOUDID:da42da88-8d4f-477b-89d2-1e3bdbef96d1,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: dff85d302f7e11ef8da6557f11777fc4-20240621
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 107495101; Fri, 21 Jun 2024 11:32:24 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 21 Jun 2024 11:32:21 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 21 Jun 2024 11:32:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AhYwUkZoiccM0tBEVpHb3pmqy2BZbCpk8B+WIOHzuPZu8rDGA2JgaFhPuinRY2DSenLzB9sgs8ZnNgQ79QCXBEmXQPSgFyGnCeGKeab5z5poR3KGMCIznXCw/jF4fe2hUXSVa/QXUMGH/U98eang1uvq/n+7whrMOrJFN1U7xcn1tqVjguX+FzvsN6e2RGaOHNVkOnrMFsuLXKlA/2qEIyiW9AwBEyjNRIOnL87S1xsChdQTep8TgcG2dTYpeJltx6G1uaOsBO7v/OY1jSEHJOJQ2lNtwB3TTHww6q0ByY2fyLZxqIfMzLJW6IWdXePy9fdD+w0wQVF1mJfeI0RFxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q5PgybQ83gomshbsJwAzmH7y0wuQp95IJmo6rx96p4k=;
 b=EhGTmco/oCqKjgXwbbEH4RfiAXyxX7a60M4Q7gUcKPzLiDUGkC3sFPqCHplT3a8MUmRBvyE7sNbebAjdKHTYRE/dAbtZwu855joDIKZeqpDEoEC9DzOH2bdNWWCE//vHhcx3byDp0z0fRSjddNIHBO2u5DoNUuTnehKYzqsxaUazzASVp/e2ISM+OG+YrLtUqvjeJ8ISCogMng5XziBMakcrE38kt4mWXAtHhh1zobXSM34GBI+Fgh06hOhz8AispxEERgk1e07+oCnjZQKA1Wq7kj5msQQk1Gi3190wxan3N5mdn7nqCnJ8alE8offJq3JIXuxk23zh/AjH+8mSfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q5PgybQ83gomshbsJwAzmH7y0wuQp95IJmo6rx96p4k=;
 b=bPYfAOZ02RUT2zchh3zN+qOTm7pIWXjK7eK1YlqJwoSnC8qhPhU1/D2NjIsavV7NMZkFAN7iNofmjqvYvniFFp8XfQI53ZIEBobbwliH74BkAFr3FylCQe+D43oj6witgwcprumcxIYgKeMBNyrCdSOoBL4n/Sh7S8f2K8P/ivI=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by PUZPR03MB6853.apcprd03.prod.outlook.com (2603:1096:301:da::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.21; Fri, 21 Jun
 2024 03:32:20 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7677.030; Fri, 21 Jun 2024
 03:32:18 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "quic_cang@quicinc.com" <quic_cang@quicinc.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>
CC: "quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
	"akinobu.mita@gmail.com" <akinobu.mita@gmail.com>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"cw9316.lee@samsung.com" <cw9316.lee@samsung.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	=?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "yang.lee@linux.alibaba.com"
	<yang.lee@linux.alibaba.com>
Subject: Re: [PATCH 4/8] scsi: ufs: Make .get_hba_mac() optional
Thread-Topic: [PATCH 4/8] scsi: ufs: Make .get_hba_mac() optional
Thread-Index: AQHawPqwKbv0TQl2o0+nWJUdsY0VxbHOrmmAgAAMTYCAAtqPgA==
Date: Fri, 21 Jun 2024 03:32:18 +0000
Message-ID: <93539579c4eb5bacc9dc9afb726294f44cec7dc9.camel@mediatek.com>
References: <20240617210844.337476-1-bvanassche@acm.org>
	 <20240617210844.337476-5-bvanassche@acm.org>
	 <20240619071329.GD6056@thinkpad> <20240619075731.GB8089@thinkpad>
In-Reply-To: <20240619075731.GB8089@thinkpad>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|PUZPR03MB6853:EE_
x-ms-office365-filtering-correlation-id: b2231bcb-d5d7-4d22-c58c-08dc91a2c0aa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|376011|7416011|366013|1800799021|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?MVJPaGdlRXdEcUR2TU9kZHVwZkRpOEloVGhVNkt5RXVmRy94T1lSUk1hZy8v?=
 =?utf-8?B?QTlvcFRNV2l2OEdTWHplR0k2cTVHRWpVOE1YaUExWW5Oem9LNmJNOHppd0p0?=
 =?utf-8?B?ZjMxV2RIeHkrN2Z5WXNxTzNrQXRBTkJPYktiNk9zUTExTlhydFVlRWUzaHJh?=
 =?utf-8?B?elpPMWRsZWswTmdlTzVoMVp6K2MrWkkrKzBPb3BSOTZDNWViSmVLbUluOGZC?=
 =?utf-8?B?N3cydWlhSGxRT0xHNDVSclR3czBMMW1oWmYvODRlSXJKMjF6d0JXYjd6a21q?=
 =?utf-8?B?NjdxZ25STysvK1hlVEI5RStkbHpYeG5VMjF4UGZYRTRnTGRNNGMzOFpzUnRa?=
 =?utf-8?B?MVpxNEgwVHQ1ZzVpVS9rWFU2OWFVZmZBSkNQMDRVMUg1bXYzbmppcGhxQzNs?=
 =?utf-8?B?bVkyZDhNaEVTRWlzbTZrM3BBOUlqM2ppKzdSMWRzbDlsdENDR2FkU3YvemxO?=
 =?utf-8?B?VFR1djlwNlMzRnNNL3R4UEZEcUFZSjZNRjUvZGZvN0p2SUF3NnVwYm9rV0Z5?=
 =?utf-8?B?anVXUWFkQWNOT0Fqcm5zZHBYTDhhZUNVRTloVmFxbGlrc3JOa1l6NUQ1TVBp?=
 =?utf-8?B?Ti9ZVmw1WTY0QjQwZms4ZU11elRqejNHWWJSNFByU1Q5SFIrL3kyRElzZHNx?=
 =?utf-8?B?cC9VVGl2WSs1RkNUUE5oTElLSVU3YmVNU3QxczdvS1grdXl0bXZSc1ZjTWVp?=
 =?utf-8?B?bHVCdVpuMHVTT2xWdXdUZVNVT2VLUEtFaTFyeWNyMnY3dFhuS1JnbDV0NlQ4?=
 =?utf-8?B?TFlOR3B0RmZHN0hUSkFNUU1QY1pQbEh6aVNzSzFoVC83UTdQSGRRUlZzenVK?=
 =?utf-8?B?cHl0S1dZaHRtcFNqa200d0RGM2JxajlzclRSTm9RS0YzekVvK1ZxY2V1WDhD?=
 =?utf-8?B?cjJ6TU9yYWw2dTBaL3h4YllLLzAyaVRnRFYvNjBnenRVQTY0OVdPak56dkhT?=
 =?utf-8?B?SnFldnpXb1R1SHhzY3dyMmYyWTRMVnNTNzF1U0ExRkFpNWw0R1BvSGIrVHlq?=
 =?utf-8?B?OHJvS3VZbEdFYmJtemlKaG1KNDhZa0YwdmF5UGpWRWR5TFlRdk9nekNEWCtW?=
 =?utf-8?B?ZVJpa1BvbEg2MU9lSVZ6YlNZK0dRUEhEOUQyakh0eTNxdkVBQkN6a3FHakMv?=
 =?utf-8?B?Q084QzRMbmh5ZDZ4UE5YUmRXWU00RlBFamNsTGkyd3I2Z2J0N2ZzVzUyVlF6?=
 =?utf-8?B?QjhQUTJVYlkrdmhaaGdUNlROc3hOU3VYK0ZNT0xFMlc1anpaZTZZVml1QnpN?=
 =?utf-8?B?ckpMMFVraDk4Sms5WmhKNUp0NHdiRXBiam1iWXcweWpoa0Npa1VtSmZWNzk5?=
 =?utf-8?B?Y2l4ckpEd0dtRWY4SXd2dTFQLy9hVkNQMlVkUmVpdHdsa1RxUmw2WWY2RFRt?=
 =?utf-8?B?YkpYVVhNZUpzKzN2dldmZ2hjdWxJaEMxQ1pkaXpJVU5KOXd6amJKbW5IQ1NO?=
 =?utf-8?B?Y0YrclBHWElJbEJKUG4wQzN2N1BEd0JhTmY5bmVZaTB3RDdlV0t1OVY3TEky?=
 =?utf-8?B?SDgrOGtzYVdoMmx6TElROUROL1NFUDlqVGRaTGFNOGJHY2FzZ056N09WbFBL?=
 =?utf-8?B?cWQ2aXhpU3RkZVRZajNRVFRUcHh4NVVKZzg0Z3AvQjdqVmE3eDh3dlYwdmZW?=
 =?utf-8?B?Y0pwdXQ5K2czQU10VFl1Uk5RMTJUR2ZaMlhkc0lXSFZIN0RKMGxDVGZGWU9s?=
 =?utf-8?B?aG9MZTZGZm1YdmJBc2pmK0Y0M0hkeVJuTkZhQ1JRRWNOOWd5QWEyY0NzUUpX?=
 =?utf-8?B?STZHM0phSnVRVEZ6NEx6ZVROYUw1UzFUME94U29KT3pnMXE0aFh6VnlSVEZ2?=
 =?utf-8?Q?hqvRpzzmTiHmQ0IuQY8V2AGTzO3xo1Vx/FtGE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(7416011)(366013)(1800799021)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q1BCQjhEcGg2R0VlSFFpSTNRNktRSldVSHZKVXF5TUFrc05IUkMrME05WmZQ?=
 =?utf-8?B?OVZDNGluMGp0ckVBQUJIUUdpS3JyeUZBRnZWdU1yRkZ2aWxaL09vK2pOcTZL?=
 =?utf-8?B?am1nbHZOcmkrQkdwMnRMY1V3K1RwS25ybzVJUGZIUnBFaFFsdG5HRTV3TEtD?=
 =?utf-8?B?Nm03bkZRK2UyMUlTMzhvODZsSzl3THQyanBjV1pDM0RKN21MZUVIbEZNbUdM?=
 =?utf-8?B?NEdMZjFETWZpMGVJUHVQem9sM051WW1zWU1xQ0N4TVFYVkdWWmpOZUxGVnlQ?=
 =?utf-8?B?N0Z1ZnlPMGNmUC90RVZUbjZnRk9lZTdPV1R0MHorNENwM0dRT3FjcVRpLzQ5?=
 =?utf-8?B?YnZ1R3YwNmZrODFzSjFmSTVwRWVPWlBTMmdjbXBVelhyRTY2Z0V2bUVGUFlo?=
 =?utf-8?B?ZEFSSkdLVndNdWgwTGpXTkI0UTNPWnkzWjIyMG1GUUN5YmpOdGJnL2lHTmJo?=
 =?utf-8?B?MWFiWjYvb0ZGYVIvc3NJTUdyNUhKRysyOHc0TXQwR0dWeVVORDJTVTVFUmMv?=
 =?utf-8?B?V0J5eEJBY1Jxa1VFY2tuYjJqb2xsb2lqTjdzR04vYkFTQUhQRmdHWi9JNlJR?=
 =?utf-8?B?L2p0eFVzWUp1V2lmdzIyb01vdTQzS1VRSUZyRkxXcUR1c0VCMmtBM2FYemNs?=
 =?utf-8?B?Vmd4RkJpbXRNK3licUVDMlpyRklBYVM4NlRMOUZsUFBhcTF1Mk1zUGNuM0lT?=
 =?utf-8?B?czRkdWFLak9PSFloWDBXWVlNbTQ4cURVU1hvUVdxeUpnazkxT2U1dzRaOE5z?=
 =?utf-8?B?TXBSK092dzN6dmN0OXUxZGZyeHpiUHZYbk95TkJlV2U5L2NrZlh2T0hQZEZq?=
 =?utf-8?B?djAxVlhQL3ZOMUF4UjIvRldVZk00Y0xkeEk4ci8vZWJiTWFxdnJhTXVyYjAv?=
 =?utf-8?B?NUNoVEF1Y3NXT2Y2RU5HMUF3VjBJeEF0OWZpdlNlSjY4cEJqbjZjeXp6UG5T?=
 =?utf-8?B?Y2l6SndEWTdkaWV6R296aWlZQ2dSbDVMTGtNbzBuWnBYS3JqbDNSTmVJNllC?=
 =?utf-8?B?U3pSRGpoTzJLVnlacG8yazk0dTl3SDJnbzNHc0NyTUhLVVdVaU1GNGpuZUd4?=
 =?utf-8?B?OCtkYm1HTzJUd3dYOGRvSGJReitXRFo0eWFKQWQrbmFTVWxPcVhpSmRvNzlZ?=
 =?utf-8?B?N2Ywc3dzMkhSclhKSENmbWV4K3htd2xYNExiVUlaWHE2bitENFhkNkE3Qkxu?=
 =?utf-8?B?ZTIwSTZPUnU0VUlBWlNWSFFQZzZDYzF2Y08yOGlXSmNTT3Zwd2l1Q3VaUmpI?=
 =?utf-8?B?NTV2L01MTEJaVW5kMDZ2VE1rYmNmV1VvNy91Vm5VZ1JlVEpwaEg1MjRqS3Rm?=
 =?utf-8?B?MDQ2alJQSFIrMHVFM3R4bE5WR2wzNnJIWnJyK1l4OEhjbkZZeG1ocVhFclBH?=
 =?utf-8?B?V0g5M0MvS3FTNk9LMjVHMDNsZnFFVkJST2xma29WK3lnRFZUZlNvQm96cnZa?=
 =?utf-8?B?U0NYNW9hRXNjdWlSdTRuRTZnN2Rxd3N2QXFXUnR5bUJhMHpETzVVdWUyQUtJ?=
 =?utf-8?B?WEwzL1J0OWhIdmErazNiRHI2K1lkT1BCeW5hQ1RHTjRiT1BKTnhqOVFNWU9w?=
 =?utf-8?B?Z0Z6ME1taGUzdHZ0NE1DSkV2MFpzL0hwSS9wNFVJWTBXSmNYeUp0alhVM3NH?=
 =?utf-8?B?dTlLVHcvVEQxM2tPMDNxck5BM01VWWFBUERrdXYyd2UrcXBTTU83NzR2YThx?=
 =?utf-8?B?ZDIyM2hnQ0xkZDArclptMFk5Y295TytuR0QyajF1T1l2aVpLcjBheGJFQ0pZ?=
 =?utf-8?B?bFA5ZHB4Ui9mVWxuQTJyaStlNnEvd0pTWWIzczUzNVZIbzFBakdQZFhCZTVk?=
 =?utf-8?B?R1M0a01FN0hOSjhEUks0OXBIQXFiSlJoVlVJcnA2VHJlamtSenFPcTllbVU2?=
 =?utf-8?B?cmZKczluVHc1QUFSbldiTTJJTlZ1VWhWNGtZeWgrdkQyRG50SXpJMks4T1dz?=
 =?utf-8?B?WDdtcG1hcTlzWjVka3hQcWJLNkplamludGViL1BWVkVlSkY0S3NCQW9INDNS?=
 =?utf-8?B?K1ZoUmxEcnNzNHIzd01GTlh3dUlvRUlEeHNRWTI2eXlQZ3NFZ1loS0lXSnRG?=
 =?utf-8?B?QU5kL3hEL1IzSG85RGlvVkdGTGVOMnFReFhQTFFROHFMY1BnNW9kVkpURXdT?=
 =?utf-8?B?QnRTK0ZCU3hPYldtMHRsRGd0U3BjRnl3dkxDNzlXQ0x0NTB4bnpPbG9LUWVR?=
 =?utf-8?B?N3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E3FE0B1F6BC168408D28689E7EC6E19E@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2231bcb-d5d7-4d22-c58c-08dc91a2c0aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2024 03:32:18.2557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ryBijHq7Gjwx+rf4hTpVvMcDblue7tJMAHsxL9pf5oPPvCDnTmHXX5v2GTiEgi5lW/nPiRaqwp97GRzwerXTPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR03MB6853
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--9.839800-8.000000
X-TMASE-MatchedRID: xSJL/ht5SGDUL3YCMmnG4nbspjK6JP6qvWY9kbV8t/eKlJ71TX9+g/eJ
	lqUEMxA/cRrta9x/OJG+5H/OLvvH8wgZq3Uj5Ixcl1zsjZ1/6awL8TGleseLPLuqk4cq52pzCKh
	uU3rY4TBYvlLFf8RlAIdziXCvHmFESSOWVJeuO1DSBVVc2BozSnJnzNw42kCxxEHRux+uk8h+IC
	quNi0WJOCNPs98WBOVx2A1CBbyqQDkgK59bCXqYcjWMLU80gJEftwZ3X11IV0=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.839800-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	3A8F9E98C2104A6F7144B71167932FE6191086ACAD444A90B16F69894CB611672000:8
X-MTK: N

T24gV2VkLCAyMDI0LTA2LTE5IGF0IDEzOjI3ICswNTMwLCBNYW5pdmFubmFuIFNhZGhhc2l2YW0g
d3JvdGU6DQo+ID4gPiAtLS0gYS9pbmNsdWRlL3Vmcy91ZnNoY2kuaA0KPiA+ID4gKysrIGIvaW5j
bHVkZS91ZnMvdWZzaGNpLmgNCj4gPiA+IEBAIC02Nyw3ICs2Nyw3IEBAIGVudW0gew0KPiA+ID4g
IA0KPiA+ID4gIC8qIENvbnRyb2xsZXIgY2FwYWJpbGl0eSBtYXNrcyAqLw0KPiA+ID4gIGVudW0g
ew0KPiA+ID4gLU1BU0tfVFJBTlNGRVJfUkVRVUVTVFNfU0xPVFM9IDB4MDAwMDAwMUYsDQo+ID4g
PiArTUFTS19UUkFOU0ZFUl9SRVFVRVNUU19TTE9UUz0gMHgwMDAwMDBGRiwNCj4gPiANCj4gPiBU
aGlzIHNob3VsZCBiZSBhIHNlcGFyYXRlIGZpeCB0aGF0IGNvbWVzIGJlZm9yZSB0aGlzIHBhdGNo
LiBCdXQgSQ0KPiBiZWxpZXZlIHRoaXMNCj4gPiBjYW1lIHVwIGR1cmluZyBNQ1EgcmV2aWV3IGFz
IHdlbGwgYW5kIEkgZG9uJ3QgcmVtZW1iZXIgd2hhdCB3YXMgdGhlDQo+IHJlcGx5IGZyb20NCj4g
PiBDYW4uIDB4MUYgaXMgdGhlIG1hc2sgZm9yIFNEQiBtb2RlIGFuZCAweEZGIGlzIHRoZSBtYXNr
IGZvciBNQ1ENCj4gbW9kZS4NCj4gPiANCj4gPiBDYW4sIGNhbiB5b3UgY29tbWVudCBtb3JlPw0K
PiA+IA0KPiANCg0KSGkgQmFydCBhbmQgTWFuaSwNCg0KSXQgaXMgY29ycmVjdCB0aGF0IDB4MUYg
aXMgU0RCIG1vZGUuDQp1ZnNoY2RfbWNxX2RlY2lkZV9xdWV1ZV9kZXB0aCBpcyBydW5uaW5nIGJl
Zm9yZSBtY3EgZW5hYmxlLg0KU28gdGhhdCB2YWx1ZSByZWFkIGlzIHN0aWxsIFNEQiB2YWx1ZSwg
bm90IE1DUSB2YWx1ZS4NCg0KDQpUaGFua3MuDQpQZXRlcg0KDQoNCj4gT29wcy4gQ2FuIGlzIG5v
dCBDQ2VkLiBBZGRlZCBub3cuDQo+IA0KPiAtIE1hbmkNCj4gDQo+IA0KPiA+IC0gTWFuaQ0KPiA+
IA0KPiA+IC0tIA0KPiA+IOCuruCuo+Cuv+CuteCuo+CvjeCuo+CuqeCvjSDgrprgrqTgrr7grprg
rr/grrXgrq7gr40NCj4gDQo+IC0tIA0KPiDgrq7grqPgrr/grrXgrqPgr43grqPgrqngr40g4K6a
4K6k4K6+4K6a4K6/4K614K6u4K+NDQo=
