Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F2528EB
	for <linux-scsi@vger.kernel.org>; Mon, 26 May 2025 13:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748265681; cv=fail; b=Uikplb64fFKtRnma3ZJJE7yCYrDwaV4QkwRN6lIlI7fUHwrlJl6e1D4X7kqdA/8KDj2EEoVRbQNKpseNb0gfWHk+9FArd5E/4OJp+UDAx78MGHLjDkNV/ITInGW2lsTshX27X7SoGM2Go1KznCdy33gkhD+c5Pp80X8E79Pqn0U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748265681; c=relaxed/simple;
	bh=PTXXHTrAQFDHJMJK9a5zez2QB8ug+8K2U3qrUy24+mE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CHPZXj6T7y6dAWuisFh6fCBbemOOXtxeMDH2BQxOIvQauEyrIT7/HKcNE07jXTYlm+zA/VFnopP0LsDnO1E6fUkb7mhBR3QSAdVlTFTdg4Isyw+iHWDgUAh6VqZvEzJLnmD0UZ4CaM5iDsFEVZz5Ur6+E6EbH48/4XSRji3P/yY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=kioh1/+h; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=bCgm60Nc; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="kioh1/+h";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="bCgm60Nc"
X-UUID: 4ce5f02c3a3411f0813e4fe1310efc19-20250526
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=PTXXHTrAQFDHJMJK9a5zez2QB8ug+8K2U3qrUy24+mE=;
	b=kioh1/+hkjsOl1Xy8VMUwfBXpA7OltPWaLPoAunmj+wPlXEXc2h6EcyApbiFJ/qrpN0mY2r2MljBSTpy37w4ghUW0c7ZE0eRndEZt+km0OznTVtPkYEl3fvQ/1uUMgz+rySYEaINU3oqmXLmsHiZAMz2DhspghHhVEXzlyCOu18=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:874d93ca-78d4-460d-bc1d-f1cc0f909993,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:a630fd57-abad-4ac2-9923-3af0a8a9a079,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 4ce5f02c3a3411f0813e4fe1310efc19-20250526
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 564863336; Mon, 26 May 2025 21:21:15 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 26 May 2025 21:21:12 +0800
Received: from TYDPR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 26 May 2025 21:21:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pK/9dA0HwcA7qpiC8I/Mpf4P2VViE8Lwv5SK8wJ9zskToeeXleKLtk5w1jk04Ur3XHvRiRlyA2GqKZ7FgHOZLSQ4VhuwJxJ8OWgb3h/XH39R+0d0HDxdnxKxmx4bq0V/GTYsQZIouk8w1f8GqR3X7hEhdS9NFoDjPovJvx+0jPFbnYqSbrflzYu+s6318bt41wxwOcUo8/e0pCEK1p4jpDWfNsPUbggnap2AKzoQGRN3eE3rkxipuzpY4Lc1Ts4gUzn5N6JITmcWCTlM7QG7175Kauhckv2RWR4c5TEah8Ql2z7wKtZpjMT8t51ANz+s+eokIVoxgdiZZsy0cMRYDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PTXXHTrAQFDHJMJK9a5zez2QB8ug+8K2U3qrUy24+mE=;
 b=mT97HM4c1kYPIZzmLtiQbgNcMBsMJjvSfSoI3j6Eo4Trl1vgP7p1HXZdVtxt79k/sHx1mpKLbM8ht4PMv/sm9RR7BlhfesCHPl8Ai9IfoDhyE+wUU2ht26JmpiBK+mVESMHUwF3OmPEpM8PbVmezEiGINOh1tAQQLQUHavzUkNIsx/SRMhiL6DUETtqBbbscmBQl4+VczYEIKhM86u2+1DfXxjbR5tX4Cu7ErGc0RYxhhZpOdeZO0WsPb5UrVaCIFruz7cAsvFZ9uPoyA5Xe6Og4NKLfstjs+gPC+fUXoi7ygIAPcxWjNZvrRy2S6aTpQaRTCYLYYDYbxxiE+e/JIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PTXXHTrAQFDHJMJK9a5zez2QB8ug+8K2U3qrUy24+mE=;
 b=bCgm60Nc8z5zjhcjUbvycLDvy5IJ8otQ1xcfQeB4X23YCY+WXUta76AeMrdt26AjQc1v26+aW3ETtGgDzOo4F3TpuPEAGGFdHXc8nkkTQYTepOK9glFPBsvdeyMuJ4xVe8VhjPzX7g1iJjpuuUoyrNpxfEBoA6EGd5KcSLctmUo=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by JH0PR03MB7975.apcprd03.prod.outlook.com (2603:1096:990:3f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.24; Mon, 26 May
 2025 13:21:11 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8769.022; Mon, 26 May 2025
 13:21:10 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "avri.altman@wdc.com" <avri.altman@wdc.com>, "jejb@linux.ibm.com"
	<jejb@linux.ibm.com>, Sanjeev Y <Sanjeev.Y@mediatek.com>,
	"santoshsy@gmail.com" <santoshsy@gmail.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: core: ufs: Fix a hang in the error handler
Thread-Topic: [PATCH] scsi: core: ufs: Fix a hang in the error handler
Thread-Index: AQHbzB9auVPXGDRIzkKd3VohNkQZa7Pk6deA
Date: Mon, 26 May 2025 13:21:10 +0000
Message-ID: <2ab0ae98fd101d893d4f20112771cdb623fbca67.camel@mediatek.com>
References: <20250523201409.1676055-1-bvanassche@acm.org>
In-Reply-To: <20250523201409.1676055-1-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|JH0PR03MB7975:EE_
x-ms-office365-filtering-correlation-id: 30131a4f-afd7-4b81-e653-08dd9c582e45
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RUNLMldDRmhJbTVTckJNUDlCOVRINEQrbFgzQkxobEl4VTVrSy9uc1ZQYklL?=
 =?utf-8?B?WDVpNXd2bUt2amtKaE1MdDkyRmEveW1OR0J0dDJZZlBIMFc1ZDgrVjVmZmda?=
 =?utf-8?B?Z05xZUJsb21WQllYOUJ5SW9sZFFVTWRRWWhzRGdXZzdQdGE3aDJYdktCUDNH?=
 =?utf-8?B?dUpydkl1QXVvQm0vNENJak1VR0pSOVhjakhOdzBCQ2ZEVnVrQXhrdlEwSm42?=
 =?utf-8?B?OTQyR0RPMGkxTW1ncGVJZmV1VE5GQ05TNHQ3dHg2empVZ0pJeDU1TW4zOUVv?=
 =?utf-8?B?UzgrUFRYQlFXMUM1bjNoU2pBNWFXRFBKMG1zcEtnMkxkd2FhTjlFWHM4dk94?=
 =?utf-8?B?TFhnRGhoRDJJN0FGZm5yWm01cGtRVXFCV1cwSzBZaFZvM1ZDNXVzZlhyVE52?=
 =?utf-8?B?UlJIcUxlRitCQ210NkhYSnduVXEwSG94RWJaSmVZaFNIdTlLTzhveWdWaFZB?=
 =?utf-8?B?czhnS2lVVjhMSjVURjFmWTlHeUpVZ0I3eVBRVnBQaXBnUGlGTGJ1QTdPT09N?=
 =?utf-8?B?NUh2Tm5PUHRmWDRneXlYT3VGdlRmRkdhOVIvQ3F1cDhmVjVGMUd3MnVsejZz?=
 =?utf-8?B?VXNjSHgwbFZtaHdEWXE3ekdIMkppd3FaNi9YY2txQWJobHQzb2Y1U01NS2dt?=
 =?utf-8?B?SXpLZnNPMmczMmppa21yV3kzMjBKTTFESE1LcnRSeDJJa1dDNjVIcm53WGN4?=
 =?utf-8?B?MlljMXR5ZHBTWk56blY1ajYvd29jQ1d3NHhqSjFQUWpsTHNDeXBuTnpLSmVN?=
 =?utf-8?B?T1lqaUZWd1NLc3hKU0d5Kzljb0JpYTdjamNkYlJaalhrQkRmRnVLalRYYVZX?=
 =?utf-8?B?VEZWSis3SjlDQVRvcGRqazRBaXJ6SU5va3MzSVlJckhQOHlpZlBrZmJqSlhC?=
 =?utf-8?B?ZDljWUtSeHBGay91V1lmSXlsY0NmT2FCRy9UeHVrT3lzUjJEWWxWNFdnNlFT?=
 =?utf-8?B?UkE1SmJCRWpUWDZVdWFsK0NSdGdZZkxOZ1ZZRmQzejhscXJLdkR3dHJ0bXNi?=
 =?utf-8?B?M3hjQ3NWR3RvcEZvY0c0RDhYbDlZK1dlbkVhL0F2c0RENWkzMzdQYzhTSkdn?=
 =?utf-8?B?NitkYUxPRmFCNnA3MzM0RTJvZ0htTG8vdlp3dnIrcDRlTFJ2VUF2MzB0a2FX?=
 =?utf-8?B?UWhDK05WbjFGTnZPZ1hOUGN6c2tHT2RQYVp3N0lUNjJENVBCd1lSb24zQVo4?=
 =?utf-8?B?WkdVNS85cGlZQ09NWlpRNFhwMVVXUWlHTm45N3R0bmxXUmkwbU5qZm5VZFIv?=
 =?utf-8?B?bGlmc0lQU1AxVmkxMjJ1di8rbkhHRWM5OWNLeXhwYXZFUjg4RW9CR2pqUVhG?=
 =?utf-8?B?T1VHWFdFTDQ1Tks3eG1SU3hrY0tKTXoxKzdPRldSMm80ckM5aUFEbmhURlVF?=
 =?utf-8?B?dEd1MUxTR1ZReGJGZFk3U3pZNUgyVi9hMlgrV0JscmpKN2tDeUNMZU55cTQw?=
 =?utf-8?B?SXZLL0FJL2s4bHF6blBDOWxOcERCQnozMUErRWdJaGp1ekViUkl5MU02TFNt?=
 =?utf-8?B?OUFldGhienF6a3FiNUkvQk1uNzk5ZWNJNkEvWXdQdVdUYVNXUHF1TEswSkhx?=
 =?utf-8?B?OHlIV0Y0cDVVdUtDcnh3WG13RmU3MENEdjRVd1FxamFmWXVUT2FFWEZTZFJm?=
 =?utf-8?B?M3N3Q0tINVNhalFCNitscjlhVVdKbStidnQ0UkQxTERkenZTVGRjNml5dDVi?=
 =?utf-8?B?QVFYR3N3M2hYMlQ3VjVJOU9JeURUclNtWllqRDAzQXRBQW1seGZLQUUxcmNU?=
 =?utf-8?B?N3lPUzFEWkxXUkJvSm9lR0pzMGlkN2gxYjJkSWZhYWNibUxsQ3RSNHlqSnU3?=
 =?utf-8?B?MDRDNDUwdlRZbU50QWpNNm5QSzRrb0p1cXdIRXhaNC8rbGZ0eFRwQmY4TXlX?=
 =?utf-8?B?NHBXaFdzQ25zV2ZyYzcvSS9TWStNMXZiWWtvYmx1UWhvQklmanNZQjZCaFdW?=
 =?utf-8?B?c2NiWmV2OE54aXFzNDZlS0YwemJRRGJhanUxWDA4Qk1xUHJURDJOV3Jwdyts?=
 =?utf-8?B?SlZ2ZXo1V1VnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SFQ0L3ZNQWk2SkI1SHJ2anRsL00wd1RXazI1TW9QNVhuTjRmOFVlbDZzR00v?=
 =?utf-8?B?dlN2dkVXUVJtY1QxMlJyR2FHKzVveHVCOE9vNFJmK3Rvck41Qy90V1pVWVZG?=
 =?utf-8?B?aXZPcCtoMmpSZnErUjh0R3RQN0NwaUFxejA4Z1R1QlRNTzBEWHV4SGJjY0lh?=
 =?utf-8?B?Qk0rb3FaNk1NMFVubSs5UklKeXl4RVdLMnU3a2wvUkF2Ni90ZTFoTWlQcG01?=
 =?utf-8?B?dUlkN0RlOXh3Rk9MS1Qrdlc4c1BMSk53dmMyRHlHUmFNMWh4M0xhVU55YXpD?=
 =?utf-8?B?M2hnamJmVHp2ckdPakNtWHgrdDR0Z3F4UnVzV1p2UVdReUpINXVkbFRHL2Yw?=
 =?utf-8?B?WTRHdFlhZTJEeng4elhmU2k1OGFyM3FvaG1kckdoOHNkL0NvQVViek5iYll3?=
 =?utf-8?B?Mmc0czZEQ3lScExrNUs1T0d1SlRUbE5kWFZqY1hMRU1LZTdyTUtVME9RbDNy?=
 =?utf-8?B?MUppcXpzQzY1cFhPZmNVdjU2bVBkMkRaUEJpSkVEajRId0hyd1ZXcjIrSHk2?=
 =?utf-8?B?aTJpbGl4OW1XQVFjQXpuSzVBdlVJTWlTRkVjczRDQ3A0VDlFREtvblRrOEsx?=
 =?utf-8?B?SFdDWUxLN1REL3VvVERVSUlYMGxianhESDhrUXBxRDhHbUc4SUdIUk5HMHdH?=
 =?utf-8?B?QThuUUMvQnN1VnZxUW1pdnljUEhIU1Y5NU1lYXE3b3dvTHJpc1JCSmh4N29k?=
 =?utf-8?B?WDdjVWQvdVlIdE1RS1NYZ2JnRURtb1FiMi8rcnk2czBVQ3pxSlR2TXZYMVVX?=
 =?utf-8?B?emFTUXdUNlR0bUZmU2piZ1R2RHFYSmVJZGVYSzdzTmRDSXRYcWJuSVRMZk5h?=
 =?utf-8?B?QU1LNjM4eFZlT0RIVjdmaU9oKzZLakhaOXkvMGhWYUszQjBqYytRR3RqL3I0?=
 =?utf-8?B?bjhXQ3prUDhZcnVEWVZ4VWtYb09UNFlXREU5WGxUcDJjd1g4RlVOYVV5VGta?=
 =?utf-8?B?ZzFXMUd5SDg4ODZ5U2J1WGZZMUoybE5WMnd3WGdYTGZiTGlYanVTWll6YzJa?=
 =?utf-8?B?SVhWTERDSzU5TlB6QW5RNkgvb2prL1BaR0FsNDFld2hidDdSMWYzQlUxc2JD?=
 =?utf-8?B?SUt2NDVITDYwaFZ1a2ZqYWlDbUM4REtHcDJwV3l5Qm9JUEVYdXpWdWtQbXZD?=
 =?utf-8?B?bmRpZ1lzVlQxaUI3N3FKRzdaQUxYLzhiM1hxdzFqOTk5Q29admVnR2ZTZlNM?=
 =?utf-8?B?cHdab2pxQ0JyVm9ncTQyU29uQ3c1K0d4NlBESjBTaHBIQ2ZtSUlzbGtRc1p1?=
 =?utf-8?B?d3Yxak13VjZ5OTk4dnJZNXZ4NDZlSTNoTm5aNmFXWDM3dFVWWXcxTHdPR2lK?=
 =?utf-8?B?N2p1Q3N3RW5RVUMwamd2Ujg3OVZVanRKOG9zVHVBVk9LK0FOZnNyTmlmako0?=
 =?utf-8?B?eUVWUGNhcmhnWWtrczJZVE10VGxnQmRFRk9DTUxyVCsyenl3TEtMWE5rbkRW?=
 =?utf-8?B?bVVwcXNtWnpHcWljd3VNQnZrQTZvNmJ2T1lkZXJOZVI2OFZQeHpNTWMxWVJE?=
 =?utf-8?B?d3RKUm00YkNkMWlQVzBWdjIwZGhCS1JzUi9RcG82VStWVnU3aUVBSUt4aTQy?=
 =?utf-8?B?SjhqbndtYjM3d0FQcjBVdXM1Q1NFQVVUMWZPREFvdGZPNmV3ZmRqUVI5Rmxj?=
 =?utf-8?B?cDlNWmEzUDRtaVBhVUdYbllHY015ZVdTMWRIVG1IdjhsVk1RNlRFaFZEVzJJ?=
 =?utf-8?B?NVd2WWcvVFQ1UXhSak5RT05oN25TTDVmOE0za3dzYytSMGdFMkNmTUt2RVVW?=
 =?utf-8?B?V3N0N3dFM1pldTF2T2Z6RXNsWmFpN09pSS9jWDNuTHFFYi9ucldpbXppRkVX?=
 =?utf-8?B?aGFZL3V2QU1zVVhwRUJGY0c1dzQyM0xQeXdPNGRRbUc3VkQ0SHdQVW9XMzhp?=
 =?utf-8?B?emdVbW5ibzhFcUQ1UlQ2V2NyczhHNHNNMHFrdDczRG5BTk1kaFJEZjlieDdD?=
 =?utf-8?B?SzVkWENCdnVoSWtnVWpzNmFOU0QvTGV4ZlVkczVWZFR6YXZ0YS9maHNZRDNv?=
 =?utf-8?B?cDBOYVpQRE9XNFFicDdsNyttSmZvWEp0cDZ4cTJVcng3VHduSjZkSjhBcnFB?=
 =?utf-8?B?NU9NckhvUFRBYVpOOHVack1INHJ5NUtYL0xnSTFEMUxsWnI2eld1NVIwSHpu?=
 =?utf-8?B?T2ZUZkJWSjNVcXM2Tzlaakc4cGxkVGRLZWZJSVZzdmlxNHpLQSs2RmpLbXN6?=
 =?utf-8?B?UWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8FE88A2A44557047AB0AA300A279A55A@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30131a4f-afd7-4b81-e653-08dd9c582e45
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2025 13:21:10.3745
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zaiipiDaHnGC4Ey3H96ZXVWwRYarBhSCXeharNhdZv7l91ZNh1fcXZQllkJAxlhSEEdVt5d3+uxI3q76JuvsnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB7975

T24gRnJpLCAyMDI1LTA1LTIzIGF0IDEzOjE0IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRo
ZSBjb250ZW50Lg0KPiANCj4gDQo+IEZyb206IFNhbmplZXYgWWFkYXYgPHNhbmplZXYueUBtZWRp
YXRlay5jb20+DQo+IA0KPiB1ZnNoY2RfZXJyX2hhbmRsaW5nX3ByZXBhcmUoKSBjYWxscyB1ZnNo
Y2RfcnBtX2dldF9zeW5jKCkuIFRoZSBsYXR0ZXINCj4gZnVuY3Rpb24gY2FuIG9ubHkgc3VjY2Vl
ZCBpZiBVRlNIQ0RfRUhfSU5fUFJPR1JFU1MgaXMgbm90IHNldCBiZWNhdXNlDQo+IHJlc3VtaW5n
IGludm9sdmVzIHN1Ym1pdHRpbmcgYSBTQ1NJIGNvbW1hbmQgYW5kIHVmc2hjZF9xdWV1ZWNvbW1h
bmQoKQ0KPiByZXR1cm5zIFNDU0lfTUxRVUVVRV9IT1NUX0JVU1kgaWYgVUZTSENEX0VIX0lOX1BS
T0dSRVNTIGlzIHNldC4gRml4DQo+IHRoaXMgaGFuZyBieSBzZXR0aW5nIFVGU0hDRF9FSF9JTl9Q
Uk9HUkVTUyBhZnRlcg0KPiB1ZnNoY2RfcnBtX2dldF9zeW5jKCkgaGFzIGJlZW4gY2FsbGVkIGlu
c3RlYWQgb2YgYmVmb3JlLg0KPiANCj4gQmFja3RyYWNlOg0KPiBfX3N3aXRjaF90bysweDE3NC8w
eDMzOA0KPiBfX3NjaGVkdWxlKzB4NjAwLzB4OWU0DQo+IHNjaGVkdWxlKzB4N2MvMHhlOA0KPiBz
Y2hlZHVsZV90aW1lb3V0KzB4YTQvMHgxYzgNCj4gaW9fc2NoZWR1bGVfdGltZW91dCsweDQ4LzB4
NzANCj4gd2FpdF9mb3JfY29tbW9uX2lvKzB4YTgvMHgxNjAgLy93YWl0aW5nIG9uIFNUQVJUX1NU
T1ANCj4gd2FpdF9mb3JfY29tcGxldGlvbl9pb190aW1lb3V0KzB4MTAvMHgyMA0KPiBibGtfZXhl
Y3V0ZV9ycSsweGU0LzB4MWU0DQo+IHNjc2lfZXhlY3V0ZV9jbWQrMHgxMDgvMHgyNDQNCj4gdWZz
aGNkX3NldF9kZXZfcHdyX21vZGUrMHhlOC8weDI1MA0KPiBfX3Vmc2hjZF93bF9yZXN1bWUrMHg5
NC8weDM1NA0KPiB1ZnNoY2Rfd2xfcnVudGltZV9yZXN1bWUrMHgzYy8weDE3NA0KPiBzY3NpX3J1
bnRpbWVfcmVzdW1lKzB4NjQvMHhhNA0KPiBycG1fcmVzdW1lKzB4MTVjLzB4YTFjDQo+IF9fcG1f
cnVudGltZV9yZXN1bWUrMHg0Yy8weDkwIC8vIFJ1bnRpbWUgcmVzdW1lIG9uZ29pbmcNCj4gdWZz
aGNkX2Vycl9oYW5kbGVyKzB4MWEwLzB4ZDA4DQo+IHByb2Nlc3Nfb25lX3dvcmsrMHgxNzQvMHg4
MDgNCj4gd29ya2VyX3RocmVhZCsweDE1Yy8weDQ5MA0KPiBrdGhyZWFkKzB4ZjQvMHgxZWMNCj4g
cmV0X2Zyb21fZm9yaysweDEwLzB4MjANCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFNhbmplZXYgWWFk
YXYgPHNhbmplZXYueUBtZWRpYXRlay5jb20+DQo+IFsgYnZhbmFzc2NoZTogcmV3cm90ZSBwYXRj
aCBkZXNjcmlwdGlvbiBdDQo+IEZpeGVzOiA2MjY5NDczNWNhOTUgKCJbU0NTSV0gdWZzOiBBZGQg
cnVudGltZSBQTSBzdXBwb3J0IGZvciBVRlMgaG9zdA0KPiBjb250cm9sbGVyIGRyaXZlciIpDQo+
IFNpZ25lZC1vZmYtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KDQoN
CkhpIEJhcnQsDQoNCkknbSBhIGJpdCBjdXJpb3VzIHdoeSB0aGUgdWZzaGNkX2Vycl9oYW5kbGVy
IHdhcyB0cmlnZ2VyZWQ/DQpCZWNhdXNlIGR1cmluZyB0aGUgcnVudGltZSBzdXNwZW5kL3Jlc3Vt
ZSBwcm9jZXNzLCBpZiB0aGVyZSANCmFyZSBhbnkgZXJyb3JzLCBpdCBzaG91bGQgdXNlIHVmc2hj
ZF9saW5rX3JlY292ZXJ5IGRpcmVjdGx5Pw0KDQpUaGFua3MuDQpQZXRlcg0K
