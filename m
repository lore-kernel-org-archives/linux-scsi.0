Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0AE6A342
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 06:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719901500; cv=fail; b=TDNZJmcLt4dWs6TEZ5WU6NUWFFFco//deFWwCRMw/rduBehKsiYprIHhv0aVLRpJIIU9tc5tNfg0uF3xp3Qq11BaCYrTj6VcjctYmF4+AtEpLSSfNuiR/zCW95jB/8viVOUGkmnAL7AaW8mGUnVt1Np+s0mACNNBicpdGCfiERo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719901500; c=relaxed/simple;
	bh=Xazcg2qJWiFmmxaKY2Fbqk0X6izbhJlpExQxz8GZ1vo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KWHzmkkp1EEOR4THOoTZsRLAWZPE83TG08FYwjjh01vWnEejf5snGm/eua9KxexqigkOjPMeoTrI0/LX8YdGSEAO4C5pMgriD3u2wciuZ8Wiym+cgQnyMV+pqKbkfVCaAkvidCBFN+aBsHX5OeThLblUxXzXtB0J0hFFaj6cVMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=U31DGyjl; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=graEgme7; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="U31DGyjl";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="graEgme7"
X-UUID: c9d44e68383b11ef99dc3f8fac2c3230-20240702
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Xazcg2qJWiFmmxaKY2Fbqk0X6izbhJlpExQxz8GZ1vo=;
	b=U31DGyjlSunfs3tfaaOftca4GJKFv0/ZY1UJ8BZ3xlBqboW+s/1s/xJgMSsfFF43DRq6LTYpgQirNS2tdzwnzAUEk0m02yiskYt3eBC+ELx4yqEidG5Aj+LeivSz/xqTd5E8Q6GGMa5tOtJZwnZZqI4cu99HBB5U+4nVRYs1aHQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.40,REQID:976869c6-8b28-49c1-838b-a9c8cfd6fcdf,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:ba885a6,CLOUDID:df58fcd0-436f-4604-ad9d-558fa44a3bbe,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_ULN,TF_CID_SPAM_SNR
X-UUID: c9d44e68383b11ef99dc3f8fac2c3230-20240702
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1422299060; Tue, 02 Jul 2024 14:24:51 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 2 Jul 2024 14:24:50 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 2 Jul 2024 14:24:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T5i28qfEe6qoiMD09CykL70VxHpohdRYNk04akiZ1dBZdIZ2n4tWwwJIMTEJIG+DaQhnDbnIo+qrnVlWrOA5SarBcGehRR7hni3b8/oQmIHRevwartYrw/SXkWMvkJcKJa+cIs+FuSBggwQp23FU1CVfxlhJAPqNVRN0H66H0GoLfsZ4ZMzSYI3rfkMZxS2L11KhWlJGJRNTUYFcy9qcJ9GeU50/A5RxHMPIPRJaXCUwV1JpSNRdFzWD+aVkYiP2cHV702UDafgrF6SpCa9nwEtcyyAZHG6tsSO8Vxtc6rAVQRm/3HtU/5FRteRMYM3zlq2uRgJJP+uF8swyj8QQuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xazcg2qJWiFmmxaKY2Fbqk0X6izbhJlpExQxz8GZ1vo=;
 b=D9p7u+lIaluCh8jA5ydI9len4YG/75r93wBR9G1bhuWTbQI4VPyCKrpvobNM81aUKQkAnATHqsrsEroNNtr+TwgMrI7Z8zoaMPvAfzgHML5+Xx+m7j/mXC3vkcPTRsSJXFpSV3CjG2N+6wNE7QkG71Vhd/sGzggvEh8QjpY57EyntY/ku0Hyz22+n27tq7B2maJF+Avrb+QoFlh4u9bOvZ2fqj+cHwX+b4cZMp6EPYqQ07Eu+g+P0uPiimQ73c+LIhNwmhbSLGd3yz1VaenXxKke92eMKpLPEswEYvTDaxh7QIFoN3BhI/wcArY41RJErxRDXrwYHsu5rbjhoHO1vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xazcg2qJWiFmmxaKY2Fbqk0X6izbhJlpExQxz8GZ1vo=;
 b=graEgme7iZE8o8AxwEfjGDEniID2puCrK5/ojuttuzZSlREv1uInn6LZRfg5J6cTwM6SxtXWBYDTk0IO0Wkhqpsno3NK65fIw+SF1hVFcBuYV0VS6uNOOG5FWBhhY5QxzR7tQp5wyoBSaiGs7yA7I7QUfvIsSmKqrpS1WD3A3Q0=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB7708.apcprd03.prod.outlook.com (2603:1096:400:432::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.32; Tue, 2 Jul
 2024 06:24:47 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7719.029; Tue, 2 Jul 2024
 06:24:47 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"cw9316.lee@samsung.com" <cw9316.lee@samsung.com>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>
Subject: Re: [PATCH v3 4/7] scsi: ufs: Rename the MASK_TRANSFER_REQUESTS_SLOTS
 constant
Thread-Topic: [PATCH v3 4/7] scsi: ufs: Rename the
 MASK_TRANSFER_REQUESTS_SLOTS constant
Thread-Index: AQHay+E5Bf8UuuGUk0ypgGsTrPVQT7Hi+U4A
Date: Tue, 2 Jul 2024 06:24:47 +0000
Message-ID: <d05565d1addb6a8ca3feb08cde7ba64419e692a9.camel@mediatek.com>
References: <20240701180419.1028844-1-bvanassche@acm.org>
	 <20240701180419.1028844-5-bvanassche@acm.org>
In-Reply-To: <20240701180419.1028844-5-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB7708:EE_
x-ms-office365-filtering-correlation-id: 49d2c35b-b341-4df4-8199-08dc9a5fabf4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WmMzbWllYm1kcFRNTUl6bGRoN1RsbE1YS1RDWlNZUy8xTTMwQm1VSHVISmZw?=
 =?utf-8?B?cExBa0hYclRTQ2dRR1RBQVEvTmxLU0Vack1aOWdCTDNvN2s0NUZxdlY1OG1W?=
 =?utf-8?B?d1ZjNUFPOEk0NWUxM0ZJRXNpZXBVT1BRdjlVUXQwaTBJamtqMDZENWpCL0g1?=
 =?utf-8?B?TS9PMDdlSUQ1VXZwazU3WU1Cc0NXQnVZUW9vUUVmaFNDak9lMXdrQjlIWVZC?=
 =?utf-8?B?T3cvMGxYcGRtdC9wY28rV0Jjd2hUaDJZQmpOQWZzeDBxU0NlZVEzbW5Ub0ov?=
 =?utf-8?B?NHNTWXBxK3NmWGpsMGdxajM1bDB3OHd6aUFlelVUUWMyZmJyRUJEQ2NxQUJk?=
 =?utf-8?B?RUU4M3BCQkZIWWFnbHA4TzlGK3F3dys0bFhDZzFPbzA3cXV3cy83ZmxkeThQ?=
 =?utf-8?B?WENxL2RjSjgrVEVhUFgzQ2xSVkE0RWdXRjFCLytoeEt0NU9PRXNENWJuSlpw?=
 =?utf-8?B?UkxtNlBpdXBqMlQrOEt1R0dhWENpRzJGa0pyRlJVNVd4Q3JlTCs5MC8rL3Zw?=
 =?utf-8?B?d1NyVXNMcU5qV0JFaDliZi9MTjBKclI0TFhKc0gvdmVSWk5wdjlhR0NWcnRL?=
 =?utf-8?B?aE1qK3ZUVGh1YXFJQTN2aElCWUU5L3ZPZlMwZUJOZnNFZWx6eStWeFc4NXZi?=
 =?utf-8?B?N0VJZEpSTDIxK1RJZi9XbEdkcUtwMGE1N0wyUXhDbWsvY3FkZEN4cE1aM2hM?=
 =?utf-8?B?TTArb2toU1VwcEVaTXk0UzkzbnVIRVZDUk1zNmE5TjVaclY2cTl6SXNvNU1Q?=
 =?utf-8?B?M2xCN3BIbzU1NGhmSmcrT0l2Ri9lYVV4c3VZbDNKc0wxUWhKK3pGa0cyTW5U?=
 =?utf-8?B?OEhlaVp4RFB3SExTMDgzSFJySW9KaDU1VlI4WlFtTEY3S3lBcVVBM293YVEy?=
 =?utf-8?B?eEJPdEFIbmtiMzFNM05CcTNUTkkxbVFHMjM5L1pEOUhpOG1RaXVsaEtOUXNO?=
 =?utf-8?B?VC8vNmt3OFl0czV0YmJyeWNyVGxjS3VaMFFjcitwRkFlWUJXaEExTm9KK1VF?=
 =?utf-8?B?eTdXUVd3eW5Eakt0K2k4MVJQMExWdHVQQmhlb1NKY1U3U1FiMjJmVlV3QXFx?=
 =?utf-8?B?VWs1MTBTa0JMQ284cUs3NWJNR2VoZHpxOHFnQ09KeHpHdStHU05jOFp0MW9E?=
 =?utf-8?B?T1I0aUdQY3pqdllKc29rVnpMWFBYOXZBOVNyVmE5RGZlVXNMS1dzTDdLa0E3?=
 =?utf-8?B?UERycFhKcjhyWXd0czJEOWF3UktFaW5oNHhrQU5wUlgwMzJGK1lUT3hnc3M2?=
 =?utf-8?B?SEFLQ1owYkxQNHd0Uy9rY2JyMVVDTGxpUnBTblU2SGFhUndFdnExb3hpd0da?=
 =?utf-8?B?cncwSjRTNzhzNHpPRFYybzg0NXpVVDVWMkYvK3A4TXgwWnp4d3RQOWpJVElt?=
 =?utf-8?B?eGhhQkcxelZRN1dBVVBNUklkSXJCWnZHT2pDK2ZmaGdndTBYQTMveG1XUSt1?=
 =?utf-8?B?cmFIVm5QVnpiNzR1Zm1UOWUrOGFhY0V2aXQrZ2pES2dUYjhoa0VvNUNkNXZS?=
 =?utf-8?B?RitDV1N0ZE84RFcvQ0pNRnhRZEpvMEFUbGVoVTlKT3ljWTFlL1RmTnhSNHQ4?=
 =?utf-8?B?c3NYSEdVS2ZLMUJFNlNkUjNrK2RGQXhCbGkyOSsyeW9aZXZadG1vSWFyRDFG?=
 =?utf-8?B?RGZDMUxjaGg2NVVVR21jZDVZc1c1RnA2eGRGNTBSdnFxbjhiYzhaUDluYlhm?=
 =?utf-8?B?d2dBd2FFMVdCeGlxS0FRU2RYcjgrM0FVV2YvTFROZjdSYnA2b1lJZWlMV1R4?=
 =?utf-8?B?RndRUWhGNXJHZlNVRmxSa3YwSTFoenZNaEtnY1dlZmxYb3dZTGl0cDhJY1N1?=
 =?utf-8?B?Rk9CTkhGWEJPVTdjd0pOK241aExuWTNhT1REUEVTa05ZOGtlcGhkYWw1WHk2?=
 =?utf-8?B?MWdoMnVJb0FOa09SS3FNL1NaVmlCeFM4ejRpUzJrUnRmQ3c9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WWpmemc1S0FsM2Z1VnBTVm5FL3EwdmpVZGFrVUF3NThxOW5mTGJjQ0NFMisw?=
 =?utf-8?B?UmcwdWl6Ykc3M1pJeStWWFkxOS8zZEkyUHFXODlEOHU4Y1VkL3gxQVk4SWdC?=
 =?utf-8?B?Q2tzRTVWMlNTeGxpR2s0VXhZaXgvWGVmMWphU3R1QWNFMDJxQncwTjdVNXBo?=
 =?utf-8?B?THlyS1lsOW5LQ2pVbXBwQW1vY0VqdTFZbVMwMjN1bjgwbmVYOGVHWXZONE9u?=
 =?utf-8?B?dEhtY2FqS2g4NFdNRXZFZE9WeFFWVHIyb3crbU01WXpCRXJWWkljcDJ0RVJF?=
 =?utf-8?B?bTJtWGlReVdVd3p5akxnUWFtajc1UkZXbW1kSlg5QXBhejkxS2RZUzNVS3dX?=
 =?utf-8?B?dE9xYUthQmhnUGxxcUdwU3NFMERlVkRPT25GUVpheXEvSFQ5RWg5bTJqcitQ?=
 =?utf-8?B?b0RyaVZBekgzVEtjVU9pNFozWW15RzFZVlpENW1CWVpxUFVtanJmOTI1djRJ?=
 =?utf-8?B?R2tTb21zZVd4cDJJSGtpbitraVRBMGdDTEl4RzR3ZWsvQjV4TlNoMk8wdjBJ?=
 =?utf-8?B?N2d0QktOa1JTU1NoWWtIdlVRU1N2MTdZajU2SGN4WWFnejQwMDJuZ000azly?=
 =?utf-8?B?blhMQllqUkYzYi9HSXJ0VHFFNm9kaHE5dHdFVFVtV21vTytnNmhHZ0hMOFJ2?=
 =?utf-8?B?NlYwMlZqZEJFZThHZ3lobEV5b2NrNUdaSFFDTnpNQmdvQmZidjNReUtKVnJE?=
 =?utf-8?B?c1gyMytTNWc4bllLL3FZMU5ZbnBhTWxGbnRmeEZkTnhreU1Rb29ocy8yWVZY?=
 =?utf-8?B?TWYxRjgwR2crWk0zVTRpT201b0xLYXpjUkZjY3lNL0Z2UmFFTGptVDZwM1VD?=
 =?utf-8?B?VThGNnpzcGhUWVM5bUFldm1Vc25ObFRHSThNL2tpeW9hNnp5SStlQWgvN3RT?=
 =?utf-8?B?bmJaWUxHMlN1V3NuUnA4clZTOTZ2S3BZU2VVNktzQVlDUi9YU25rcGhKUnIx?=
 =?utf-8?B?ZEN4MjN3ejJoS1QzVUlMNjFjSHo4ZDV4WElQSGtzclJuUnNyYnFuejlKZWdq?=
 =?utf-8?B?c2tnMy81OFVaM1k1c2lDSlFlcEVwS1NBTCtPRlZJSXR0ZTYxQllaWk1OZzZ4?=
 =?utf-8?B?eHlHWERCQkdhL0xSYTdEUCtkYUNqRFFyN2FsaHNjOTkyR0hnWXZKRk9yb1hR?=
 =?utf-8?B?Nko5OUorZDlNWDRNUSt5ODQ4Sld0TXlKMXV6YU04MVFRajlWd2lHaEpnSkt0?=
 =?utf-8?B?S21wcHVINUNpWE9EQnljd3ZYb0R2aVhKOXJwRU9iYTVtZ1Z2NHJ4cEw5N2Jt?=
 =?utf-8?B?bytTekF0NWQ4ZFJUeVJYMXc0cmQ5TW5kWXZZajVuR004a3YzQ3dWOGlNVUlW?=
 =?utf-8?B?cmU2eEZVR2kxcDJBd3ljN0ZJN0QwWHhvdSsya21LVm5wOEg2cW1yZzg0c3RF?=
 =?utf-8?B?N01vSWRVbk1wRDhTVE1tYW85WHVValpxeEw3MU9YeFBTLytWTEs4amFEaWVX?=
 =?utf-8?B?SHB0QmNObk9TQVZBbFhnQ1paMVc1NVowVklwS3FVVnkxL3RoVkE1WENMNGgx?=
 =?utf-8?B?aFhVOTFaT3lQTmVMVFBoV2QrK2k0dlZoWS93YlZsWFlsemlocjBsbnpIYUl2?=
 =?utf-8?B?NGE3b1ZOV3Z3bDlTaytXL2Fpd3NiSXF2Vk0rTTNFcWZNaWNTb1VrdklZN0Jp?=
 =?utf-8?B?TTVGU0JXMExRV3B3RXpSWjEvVWl4R2Eya29ybHlYMVFKb0hpbVlkVFlBSDNo?=
 =?utf-8?B?WHRaOXY0RFNUeFdkUkdobG5idnRvU3NTYXl3UHJvelFWbmVqcjEwWEc0TEJl?=
 =?utf-8?B?cng5eTkxZnBLMzcvMUJjL2pLbzNDSUlFTUJRRCs3OEt4dWxWbnN5eEV1Zko5?=
 =?utf-8?B?Z2txdkJ4bDVZTVdBNlZiMnAxOE10d0x2WHVPQ0FrUXVIQTEzRkU4aHp2dlE5?=
 =?utf-8?B?bC8zR2hmekJsME1Pb1JUcGNVMjhIL1g4eWtxSlN2T1ZnNzlUbmwxRDNFSW9D?=
 =?utf-8?B?ODJOamhyaVFVME14b3NHa1RDSWNkQVdnbWU1WHVXLzlyMG1pTGRRRE5kTERn?=
 =?utf-8?B?VythcC9XNnkyUXc0VzdJUnZ1RnhRR3NiUkJ4VmxtWVBXZFo4elEwbkJoTWt0?=
 =?utf-8?B?dENjcVBKVkIvU1hBeWNleG5MeThhZmZ4aFMxYVBRbjlUN0k5dVgwd3VRdjkx?=
 =?utf-8?B?SDAvT2JTKzh4Zkdmb2FNZVd6ZjRtazFxaTFnL3NrdzI0V2FOeG9RZ2hXTEVU?=
 =?utf-8?B?QWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <44B6F22A8B6D874EB2806AB45D817316@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49d2c35b-b341-4df4-8199-08dc9a5fabf4
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2024 06:24:47.6849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BCOtAniJowfmoKvPLTbKLsfYeTVbMMERnHteYw6v14aX65twi8IDzlG9D7Xrqr60pCeZ36GadzoVK7fYntSPJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB7708
X-MTK: N

T24gTW9uLCAyMDI0LTA3LTAxIGF0IDExOjAzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgUmVuYW1lIHRoaXMgY29uc3RhbnQgdG8gcHJlcGFyZSBmb3IgdGhl
IGludHJvZHVjdGlvbiBvZiB0aGUNCj4gTUFTS19UUkFOU0ZFUl9SRVFVRVNUU19TTE9UU19NQ1Eg
Y29uc3RhbnQuIFRoZSBhY3JvbnltICJTREIiIHN0YW5kcw0KPiBmb3INCj4gInNpbmdsZSBkb29y
YmVsbCIgKG1vZGUpLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFu
YXNzY2hlQGFjbS5vcmc+DQo+IA0KPiANCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVy
LndhbmdAbWVkaWF0ZWsuY29tPg0KDQo=
