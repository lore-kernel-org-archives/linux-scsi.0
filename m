Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEC34F201
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jun 2024 08:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719218390; cv=fail; b=h9zo8eKx4+xsbfZivXmB9QOWDMs+4BJZL8FU1uiFYlK2tkTuig9fRk5x9UoG+aIqhF3REbQynmEeySaBcUspEVoKK6VyIN5sJkMcdtDKbxOHiImIuapz7gGP8gMuXfnYdJ4mFEnxLPx2RUEfTgFrswVPRpWe3qOq2YIxGx9edUI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719218390; c=relaxed/simple;
	bh=mHXJmX/TUJCI7CsuFs3SkFIHypBhoRRXHJ8yDX1TgdA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=U02wA978yzugsfPKygvCzNiJ1C2ckHZADZ5BLpMOt70yH+LnVdHitgcoFio/ynyYtUK4p4Qa5SZBWw0WJUyHTZvoUkHj2bCzskq9f1QtGomVet7h3xpLB3f1TZ9FubA4hi90etsSg1O7aaiamfh5mYrZ0cCuJL/TCLhDPOCBgck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=rTjJImbv; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=XNaAmXWu; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="rTjJImbv";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="XNaAmXWu"
X-UUID: 49fec52e320511ef99dc3f8fac2c3230-20240624
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=mHXJmX/TUJCI7CsuFs3SkFIHypBhoRRXHJ8yDX1TgdA=;
	b=rTjJImbvY++C8EC8NtB4D30M8kYWA1VVhRSHUMsGXLBuVSDJVSexCXL6fGGnChEkho7cCTR9y8aKw0r1dIFJFrXDWFtNmRK/0lqKaCDEYFO6NE/NJWsx2Lx4rUuLmb3S3mxJdbB8mbCuq3VMrFU+Q2KdNX7Fsqhl+B4xkZ2gKyw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.39,REQID:51c4734f-4ca4-4444-84d7-54ed6b46e7d0,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:393d96e,CLOUDID:cfd4f244-4544-4d06-b2b2-d7e12813c598,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 49fec52e320511ef99dc3f8fac2c3230-20240624
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 402262698; Mon, 24 Jun 2024 16:39:36 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 24 Jun 2024 16:39:35 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 24 Jun 2024 16:39:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vs8o5+xrp+c4id5o6M1LqF22pO8ff11FXqlIwnKmAt+qZhcM9Lg3lpNNieC0I9KZo7vnkBq+Qyu9p3DToWuX1tXnNK7zGB0HkRAxPDXeFYPGYvqZZPsTdcGu8C2ibL8LE6wFiVMOHinivpmoKvcLHxviHNuem9ZzzgHpRavEkKCt9/C/LKcANsUyWlUnMk4qcdg+ogBE1gGaNAZP4XOfl5g84h0kGrqTnWeiEd3oxTxdm95jpIdBhmvEtP0421Xf+fLbbIB1rbpSaj8fBFyuugiKeHxFZLGoh5jsSz6vSQggLqQwf8grm8xVaYgs8QB431d2ZraB9HyNThDcTNKlWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mHXJmX/TUJCI7CsuFs3SkFIHypBhoRRXHJ8yDX1TgdA=;
 b=fJiRZTkHkUrPPh4VC3NZ5nNMJDqEMmP6rV+vyBXh4qePnEZytojDAyz3hOMRKvidLh9tPB0xN5rpqovXqVkF6ptD+qK02DUH7zvaB6gNEdxYMtnv/kTofiL4fIuZlts8iVwjhZj0gosyxvCVSSknPKh7rOBVfXJAYTsLXE5PpFWI9uf/295vQnWoxnf0nYCHvDRV+0QEi9flud6uQc01Ai35kSAtYvDJvuJ0mmj/k3cJ/4dWCrEgJx6bUGLLwxPRGK7dJ3IpNEFDIF0ITNXnQcw3LuMw9uPkGuVe2SGwINwK8DuciVxBJCvECGmRMXu9rY22s0CYZUXlecijGtKGBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mHXJmX/TUJCI7CsuFs3SkFIHypBhoRRXHJ8yDX1TgdA=;
 b=XNaAmXWuF2eXNFRQjgh6eqWchzLtOI+fUxV0iPN8GinQaRLSQ6ygnFRq75I3xVAFYMpvbPYrwDD7mZf3ehxyG1FtSibgzn1emjqkzqvtvfK5Vp4XWAOKVkncKVBVtn2+Xq/M/aqkoKbLA67qwy0xHKI//BnUdXjFc9RIUgUMXmA=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB8033.apcprd03.prod.outlook.com (2603:1096:400:45a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.28; Mon, 24 Jun
 2024 08:39:33 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7698.025; Mon, 24 Jun 2024
 08:39:33 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>
CC: "quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
	"akinobu.mita@gmail.com" <akinobu.mita@gmail.com>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "cw9316.lee@samsung.com"
	<cw9316.lee@samsung.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
	"yang.lee@linux.alibaba.com" <yang.lee@linux.alibaba.com>
Subject: Re: [PATCH 4/8] scsi: ufs: Make .get_hba_mac() optional
Thread-Topic: [PATCH 4/8] scsi: ufs: Make .get_hba_mac() optional
Thread-Index: AQHawPqwKbv0TQl2o0+nWJUdsY0VxbHOrmmAgAAMTYCAAtqPgIADzJ0AgAFAOgA=
Date: Mon, 24 Jun 2024 08:39:33 +0000
Message-ID: <016a1877dcd96b5a81a52d253cc6c9132e8d113f.camel@mediatek.com>
References: <20240617210844.337476-1-bvanassche@acm.org>
	 <20240617210844.337476-5-bvanassche@acm.org>
	 <20240619071329.GD6056@thinkpad> <20240619075731.GB8089@thinkpad>
	 <93539579c4eb5bacc9dc9afb726294f44cec7dc9.camel@mediatek.com>
	 <20240623133324.GB58184@thinkpad>
In-Reply-To: <20240623133324.GB58184@thinkpad>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB8033:EE_
x-ms-office365-filtering-correlation-id: 0ad74055-be18-4ed4-444a-08dc94292c08
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|1800799021|366013|376011|7416011|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?SkpHRGtsT2p3UnVvQnVUdzdZSXFDZmk5QVVBNnphNTRWaXJTemRQVy9FazZs?=
 =?utf-8?B?aGlDNnhEYitvZUgwOGprVlA2T1N5a1RqSU1oWDdJWDhEd2htSG13Z2pIOFFk?=
 =?utf-8?B?cHNSVFY3ZHo5cUJvY3RJenV1bk5RUy81ZkRSQzdTT3NzbW9FKytlWmlpTDdY?=
 =?utf-8?B?QkN6aERPeTUvZENBUEJDTk1JNm0xY3ltS0FSR3g1NGY4Z2o0dVMwRFRUS3Z3?=
 =?utf-8?B?Rm1rQVlEbHQvcUFhUzVBQ1Y3TlZVc2pRWjB2WTVxbmpSTC9KaTdRQ2ZpdGZO?=
 =?utf-8?B?ZXlwS3psamJ0Y3FJdGNkZmx3TjAwTDZSdGtxTm5sNGcwaUFFeWZHNDM5YTJG?=
 =?utf-8?B?bXd3aW1xa2ZrdFRlWkQ1NjFaMmxwbTcyK2wxSnJ6YmtUd1QyWmdOSGF6SWE3?=
 =?utf-8?B?ZTVjeTRiTGJLZngrcDlvRTZncjZUODBoTWovcm9kN3oyNnY3UjI4bUtvdDBn?=
 =?utf-8?B?bTdmaktkWEU2SHNKQWlKMmZVRTI1MTZpQkxJM0FVY21WNnArR0RQNjRTbHpv?=
 =?utf-8?B?cDBvNWpZU1VJdGtPMXBrLzNleUFFSVZzWUdOdFBheGlJT0VuMG1vbit2VUNC?=
 =?utf-8?B?eFUwQTBzVnNiYm1BcENXYXplcFNRejhrRGltUTV5c3BZeGJoRHlrNWczTnpm?=
 =?utf-8?B?elkzaHV0YjljdmU5cTZZdldDd1I0d2cxNytEeldQY2h2bVhQdThaZHlhUUxG?=
 =?utf-8?B?RzIwMXFZeGxrbjZOa3NSUnFpTEFzaTYya0Z0Q05OK09tckZrdlRpS0hleEVB?=
 =?utf-8?B?ZUdyZE9WWmN0MlAvcmRUMkNubDlaSFlmRTVJUHFrai9BL2VXdmdIek1xdEg3?=
 =?utf-8?B?R05aNndyakQwekZYVFkzQzMzc2tycmllUFZDU3QrU1VWaCtHMmVyK2dMZFVU?=
 =?utf-8?B?by9yaTg4cnNqWHhOdTVyYk5ocU9rbnpwdGZnSS9KL2dkTlBhcEtTYS9hQytW?=
 =?utf-8?B?cFZyUS95MTVZT3ZQYkc3QWFJNDdGWkVNdXliT0FlcU9IdGYzSnFtb1NzSzZO?=
 =?utf-8?B?QnMrNzF3UFNNWkNnN1ZNZEFlQUVRUW5KNTZ2VHp0L1pEbzJLcUxyYUFRZmwr?=
 =?utf-8?B?VGpob0FLb3pIaHEvemRxVGVtdGNIQi9YcExYdVhVNUhOQ0dZenZiaUNMMDdD?=
 =?utf-8?B?eVJFN2h0SGt5MDhpV3p4emZ1NWZYeDZldk4vajZ4eGdVM0h3bjhuaXFxMmgx?=
 =?utf-8?B?SlpXcm50VGYwQlJTdGY3REhya3NJczZIbGQzSGdjZDhJUEJSZUllV1BvV3BK?=
 =?utf-8?B?QUcvV3RqYyt2UDNJeEdaNXNIcWlST0R0K3kvUy9XeVZGeEZCT3BBQW0rcjhT?=
 =?utf-8?B?bndOdlo4VmhLdm1NM2JFYkhYS1NYRllFWWdVMVdoblBBcUNINW9LZ3lSamJK?=
 =?utf-8?B?TkdLTGRjNSt0L2FLVmtITDdoVEVENFlpc2J6Yy9ZWjhQVXgyd1VwV2htbk1h?=
 =?utf-8?B?bUh5c2VsM0pBM2ZTSHlsejl0ZEFTTXl2K0hIUzIzWUVYRUlXK0xRNi9wWlVP?=
 =?utf-8?B?SFZUalBybXdiTmZoME5iUEJuVHdtbWJIQmx2bFphM2xKOFQrTnBQZWpHSE9E?=
 =?utf-8?B?R2o0NElBTXpDdklzRW0rVHVqQUYzOWFNNE9tV05kZFFCNFZLVzlGUml6ZnhD?=
 =?utf-8?B?bUc0RUNBUmduMlFxVnBDRlZSNzQwam5RQjRQWEQ5VEYxdENXbkZYNmxId2ls?=
 =?utf-8?B?RlVaZmJMclV4alJZSFpHeU83TEd0clg5dkJwLytGZEorcVVPSTBmclVBbWY2?=
 =?utf-8?B?S2hnblpHOUViWm9BWmNnK3JSRXozUzN4UlVHVVVMMWJ3VjdraExvOXpIcGZU?=
 =?utf-8?B?T0VLOVAvNUdUT1ZNcXpyRmxPT0JURDRmR0NLOTFIUmVXQTMzTGpZbGRycEdt?=
 =?utf-8?B?ZHdsNFJGNVdJQjhZVk5nQ2xFa2JKRE95eDRPUER1VkhlYlE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(366013)(376011)(7416011)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Qno4SEFSUStlR1ZZeTdUdDBja1RSUVYzVEhqSkdReTc1QUJYOFRXYzl6bnMr?=
 =?utf-8?B?eFBSMTRIQUF3QVVFUEZuQmpXakUxdUwrcDVCQjN6dE9jZ3ExZ2tJQmRIVlVB?=
 =?utf-8?B?dEtabEhuTENSREdRcENKRmwwd3ZTb1NwbzNxRk0wTU1iMTNCRDZtUk1seWt0?=
 =?utf-8?B?ckltOUpLdTdLOUNHZjF2QUVEUDhWU3dCb0VLa0JDZ1JvVXlEUW1wVGE5TThV?=
 =?utf-8?B?aEpzaEkvUU91ZkNTemdlT1Zuc3psc08wSEdpMkdsSHhiRzJpNDFPRmsxTndP?=
 =?utf-8?B?NFFjMHdPK2xOVHZxY0Eyc2xPZmJ0MHIxcC9GdlhIN3U2RUgzTW1PL0lXZ25W?=
 =?utf-8?B?L2xCRWpyUVFhd3NKU0tjVlNzaDQwVlRZMm1tZnVBaVlXd01hMXBGUisxNWd6?=
 =?utf-8?B?NVBJNmsvZFdiU3Bpd3dSOGVjVlB2RHFPeEtJYzhlSnhvZHNsM0FLN0FDNHd2?=
 =?utf-8?B?TXU1RHBlWjNpYXk0SGtlZkpyT3RyYTJmS2dON1RmaVE3ZC9oU1FnenNqdDRv?=
 =?utf-8?B?MDVjd0s3eElIMWYzWkFSQnlFbXI3R3dwTjdmelM5T1JRUVR6MHFjc0NRVjB4?=
 =?utf-8?B?QWh2R3JXRUFBS0RxSTNUL3pGSWowLzJyOWJ2RmdZMVZtcytKRXJkd1hRT2Fh?=
 =?utf-8?B?NUdHOHhvTDgzUkQ5VkdCMUM0ZmdaZ1pMNElZbWVBUjQrQ0RLWStJb0YxTXFD?=
 =?utf-8?B?MEc4RWlFdktqYncrdmxKMDVWaHVWUHhUQ3RvaWpic1ZMTW5BSm9mc1VHdzZ6?=
 =?utf-8?B?ekVaTHp4VGREZXlrTU1RWDdPRC8zMXAxUSt3akV1a1cwdHE2ZlpwMzBnb1Ux?=
 =?utf-8?B?UXVVQ0VrQWZrUjFxVXpPT0MrenBnZVlZQy9kMjZwbUNaSTVQWkNkWmliSjVZ?=
 =?utf-8?B?M2d4aHdXc2pQWHdkUW5rRlBYd1IyKzF6TVZRYVZ5VHY4d2xITjR3SzVKWlZB?=
 =?utf-8?B?ODgyS3Y2eEJtMWpRQW8rekNoNCtzSG9ZNFdUNGFOZk55OCt1c2R2bEdld0JJ?=
 =?utf-8?B?K2VMVGdZUEdoTmRIK3BNZnFaaytwTUpSd1A5aVZoTjNqNEUzRlNqd1dsNXAv?=
 =?utf-8?B?NGlyZ2xYZDBaaE9vZlI2MTVYeHRNNkNsbGdhOTFRSS8zeXZ1N2p5OGJwcjFD?=
 =?utf-8?B?KytJOXhteGhYamcraHI1WHlvYVIxcG5Cc2poRXd3VmtpNmxYbmdDY3ppaDIv?=
 =?utf-8?B?U0diNTFsa0JLSnEzU0FjWmlBR3Y2ck1UY3Mvcjd1QVdjb1Q5VmtRUFhneXV4?=
 =?utf-8?B?bEl3cHN2RXdidXVpdkJnbjMycXR0cVUyUVdqRVNFTjIyQUNKNW1yNlIyRUZM?=
 =?utf-8?B?cnVYK1NyNzFNL0J3Nlk1K1ZrL1dlQklGT2FRWTQ4eEZPNnBPNkNjaHR1TElC?=
 =?utf-8?B?M05ENkpVZmNaS0tiSUYvS2psblFjZlFSd3JLK2U5VlJPQkw5dFNZVVhEeE4z?=
 =?utf-8?B?OFlLRjdUVU9XbENocjU0MFVhNks1RTJ2amZzamdNa0JCY2dCeGJVamgxNkc2?=
 =?utf-8?B?MFFUZlRQTnQxNVVDdWlQbDdhK3AzR1pIazI1ZDlKQmMwU2FWdlExR2FZdGc2?=
 =?utf-8?B?OXRNMWtxS3JHMHRVdHVwVVI5NUE3ZlVMRVZsZjZaM0c1elpJaTRTYVRtYkJT?=
 =?utf-8?B?ZTlpZFVaUnA4VGJpYkRRbmdVQnhvbDUyMUJsZVl2cE42dTU0NE0xZ2VsamhJ?=
 =?utf-8?B?cEJVaHQ2SlgvNUlmNGxWT0NPRlN0Uk9BaHB1eWdkUjJrb3ZWUlVFSDRjMFR1?=
 =?utf-8?B?dU4yQlhXdWUvbWRQMEVGTzg3K0gxT1VycjNqeldLSWFEMi9MWURlWm16NjZr?=
 =?utf-8?B?bGg5WmRNUlpkZGRSVjViRGlmZWEzU2dyaTdDT2F5OTUyV1l0NzY0NlltRXRn?=
 =?utf-8?B?YXcxOFpxdE16emxnc1BDOXVzZ2NycFBjQUdVaDNTU0o4bUdKK3RUdElUeXp0?=
 =?utf-8?B?akRMSlgzV3h1cG1KL0l6YXVPcnJpU1VTREliK1RhMkQ1amR4eWlqSFNwMHhm?=
 =?utf-8?B?dXBDNTRrMld4eUFpUkQ0WVhmaWozUmh4NnIxdEZDRXVVbjlhVXpGd1dwWFUv?=
 =?utf-8?B?eTBPRjhFNXBhOE5NRmQ5T1YyVm9XZjJmZ21INmpGbTNMVHllME5MSER3QjN0?=
 =?utf-8?B?K29kcThYRURqSGRjcytsSEFCK3Y3T3pWUi9VTmJpc2l1YVZ6RFNZaHJYaHZI?=
 =?utf-8?B?bmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3BA083870050824D8BBE02C228FC992D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ad74055-be18-4ed4-444a-08dc94292c08
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2024 08:39:33.2522
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aazL16SD5kC7YA6vJ4jQ5lj8NrnxFNAoMVfuXRSx1Ah9L/xIt8jmAUcDUOAsK3orX3pxsIJ7RvqlqRMsC/8aEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB8033
X-MTK: N

T24gU3VuLCAyMDI0LTA2LTIzIGF0IDE5OjAzICswNTMwLCBtYW5pdmFubmFuLnNhZGhhc2l2YW1A
bGluYXJvLm9yZw0Kd3JvdGU6DQo+ICAJIA0KPiANCj4gPiANCj4gPiBIaSBCYXJ0IGFuZCBNYW5p
LA0KPiA+IA0KPiA+IEl0IGlzIGNvcnJlY3QgdGhhdCAweDFGIGlzIFNEQiBtb2RlLg0KPiA+IHVm
c2hjZF9tY3FfZGVjaWRlX3F1ZXVlX2RlcHRoIGlzIHJ1bm5pbmcgYmVmb3JlIG1jcSBlbmFibGUu
DQo+ID4gU28gdGhhdCB2YWx1ZSByZWFkIGlzIHN0aWxsIFNEQiB2YWx1ZSwgbm90IE1DUSB2YWx1
ZS4NCj4gPiANCj4gDQo+IEkgZG9uJ3QgcXVpdGUgdW5kZXJzdGFuZC4gTXkgY29uY2VybiB3YXMg
dGhhdCBpZiB3ZSBjaGFuZ2UgdGhlIG1hc2sNCj4gZm9yIE1DUSwNCj4gdGhlbiBleGlzdGluZyAn
bnV0cnMnIHZhbHVlIGZvciBTREIgY291bGQgYmUgaW1wYWN0ZWQgd2l0aCB0aGlzDQo+IGNoYW5n
ZS4NCj4gDQo+IFBlcmhhcHMgd2Ugc2hvdWxkIHVzZSBkaWZmZXJlbnQgbWFza3M/DQo+IA0KPiAt
IE1hbmkNCj4gDQoNCkhpIE1hbmksDQoNClllcywgaXQgaXMgYmV0dGVyIHVzZSBkaWZmZXJlbnQg
bWFzayB3aXRoIGRpZmZlcmVudCBtb2RlLg0KDQpBbmQgd2UgY2FuIG9ubHkgdXNlIDB4RkYgbWFz
ayBpZiAweDMwMFswXSA9IDEgKE1DUSBlbmFibGUpDQp1c2UgMHgxRiBtYXNrIGlmIDB4MzAwWzBd
ID0gMCAoU2luZ2xlIGRvb3JiZWxsIG1vZGUpDQoNCk1lZGlhdGVrIGRlc2lnbiBpbiBNQ1EgbW9k
ZSBpcyA2NCwgU2luZ2xlIGRvb3JiZWxsIG1vZGUgaXMgMzIuDQoNClRoYW5rcy4NClBldGVyDQoN
Cg0KDQo=
