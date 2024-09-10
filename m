Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830531917C6
	for <linux-scsi@vger.kernel.org>; Tue, 10 Sep 2024 12:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725971686; cv=fail; b=pqBhhJ2+MW873BW6vKEjsEPQ1OaUXNRg049NBRWkFRvrLjSFpmQ2lCwekucDHJRqiO6UGoR/kyxCBELSvvZpA4d5D9KPpXiNaZoajz/j86Cxk68lAtBDG5EwW88Pcvzbtdsa2KpXRjdFieElWMZgkaQW141pmvl/m6R+9xcSibE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725971686; c=relaxed/simple;
	bh=mfe6Xvgx7iK1zoRBJSh8UVauCbP8hpqNLeig22LWuXw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CES5l6pifM0IJ4vN5sJY8fROQyDhG8mEJjC6mkiHVANI8ab+cPk+lVtgrPVYlst9FKpJ05cGlIZlM+faCmPn8hpjlcQfXkRC7KMe1/tkuoxxhF3aCBJtIzLoF/hrxE4JHvE/QuJfYmc9N4de6QrJgi6i8xvymFerMKVHvWiKqq0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=fREwroN3; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=VLOtUzzn; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="fREwroN3";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="VLOtUzzn"
X-UUID: 0b5181dc6f7111ef8b96093e013ec31c-20240910
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=mfe6Xvgx7iK1zoRBJSh8UVauCbP8hpqNLeig22LWuXw=;
	b=fREwroN3Q9ppvZ3hjpuLxt1MCfPn26g4mQ2/V6PbWK+jHqS9GMHi3dpY5WqfuDV+D2obCNaBEIWJoWVqoRZKDQlpC68SbdmAJYxzknCfcrgBeKhD422/kt1cUL7D/06Gbn/uhSzK2ApHbVDG3dQ43zYCUizTX4MeQpqLTBhSFIE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:6c1fcdcf-e862-4da3-8d46-5a04561b65e3,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:43ebbdbf-d7af-4351-93aa-42531abf0c7b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 0b5181dc6f7111ef8b96093e013ec31c-20240910
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 609032218; Tue, 10 Sep 2024 20:34:38 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N2.mediatek.inc (172.21.101.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 10 Sep 2024 20:34:36 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 10 Sep 2024 20:34:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UIrwqrRxaT+Vvn1iLtzqGDOkQSizyGE2LmOoA0/0meDgAwXb42Qnqy/J6lnQY4ZmNlp2V+gJAsd0uc4oK+WNjwyntpgNUE8c+8HpMIrfHxl+GyVwvf3h3NbdAPjUfJKQuGwu+IW6dqfCWu7gwos3wTfn0mPLhPP3n0InQ329ebMil72/1SYXLvrsoSVoYK0mzjdqEIIXTxsoKD+ahIrPIUiZscLRmgvHIzouhUJcTC5YKRlOVFbPF8TnepYqyznXxQyOfELfefL9+menSVlzvX7l7jU2tbsz6KYdeVKiWvajXHRRZtFqT1Amd/vj0/SiEB2LjdAfv712FcfNEcVFPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mfe6Xvgx7iK1zoRBJSh8UVauCbP8hpqNLeig22LWuXw=;
 b=LZXJN2hPxPD2m3Ko79t224keWUxWHGZIPx5oP+OpHJvoOtlJSQ+K7bSCOAJsLkY/nSV33pnqrioSXiGsQm/d3t/bv+XTqBkQHtR73zZYxch/8Wim8nF+UaFJQ0DhfMR0uP/NnvZ3EOpNypB+IdIWR72lkJx6xZf54klN9TK9LLYAUxxsBIWs4e4bbzothYf0jj7B1JO+qGCmNMFfW+hScCZ3zoPDppksJn0AZpzK1TDOHGEBQ3VSXqHVcxasJLaRsZfjUg10BYt0Hj/oE9suAI0ahfHNYBoZvp2DVyiHzOzIdBbPK6bKEtRdS6g0c11Kh11J4axTgYISYfgoXCH06Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mfe6Xvgx7iK1zoRBJSh8UVauCbP8hpqNLeig22LWuXw=;
 b=VLOtUzzn9mOmAl0gs2XMzC1V0zqctc4GCZOIJT0RdzceeLGiXxaJt5RBsc0h3UQh6SXyEUPztvpdLw8jAeZW4pK9L7l84C4JOy72A6tCc2M6my8IYVgxOmahJT92y34V7JT5VXVpkzE5CNSvYKOVmxUgVMxZPSljoXl+Qyk48a0=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB8225.apcprd03.prod.outlook.com (2603:1096:101:1ad::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.23; Tue, 10 Sep
 2024 12:34:35 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7939.022; Tue, 10 Sep 2024
 12:34:35 +0000
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
Thread-Index: AQHbAw3IYhBP2chAckuHwldEtq/XGrJQ9XkA
Date: Tue, 10 Sep 2024 12:34:34 +0000
Message-ID: <cc8434bc72a8f015acd2acaa6dc9ad84d7c9d76f.camel@mediatek.com>
References: <20240909231139.2367576-1-bvanassche@acm.org>
	 <20240909231139.2367576-4-bvanassche@acm.org>
In-Reply-To: <20240909231139.2367576-4-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB8225:EE_
x-ms-office365-filtering-correlation-id: 3d95d48b-f90d-4bc5-b900-08dcd194ed8c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bkd0VzJid0d2QTh0QkFYajhHWmFwaXJJZ3NtdlZlVUpWQmZaanhDSGoxVVd4?=
 =?utf-8?B?Z1B6SzRLU3UxT2NvMjNLd3NxRTZ2R1M4eUVIQWl5YnpObUdrZGZPbXg3WVdD?=
 =?utf-8?B?VkU3c2tpc1IrMld2RXlmNEtxbVZnb1J6SlpNRitxZE92M0hzWEJ6N0dTeTJL?=
 =?utf-8?B?OGNUUGZJUGk5Yi9LMkZQcGlxemQ2L21MZ1huUHY1a2wzV1pXS2owb1piTVBB?=
 =?utf-8?B?ODlyOEJjZi8zRVl3TGNvV2NCV1ozQWNhWnNYVFgxUUIxK3piangrc3czQjNF?=
 =?utf-8?B?VFdMeDMrSEVVb1FwUkZaUzBjSjQ2Rm1OZjl6M2RJejdnL2M5T3BqanFiQ01P?=
 =?utf-8?B?VHZacnNybllaVzNMMkMzdjY0NE5XeFV4dG5yV3V3b296RVRoV2hxZVc1eVFu?=
 =?utf-8?B?Z2FFWkNXN3l4WkJCeE9aL0k1TVF3Q1JnQTN2QWZrbmt5dG1QOEtHK1o1M1pj?=
 =?utf-8?B?S0hJdGdmVzFMZy8rTkF5N3Y0R3R5QWRWQzAya2dUcGxQRlBPdWpXZFU4bk9R?=
 =?utf-8?B?Y1ptblhBcGxKdHVNK0Q2VzB5YVlUOHVPZzRZSlpDaWN5b3RjZ3A2eXBJME03?=
 =?utf-8?B?cm8vRFZWQ1RUaHBPUWplSU1xeWVzbUY1SUtuc3RzejJheEk4Y3htSytUZk8r?=
 =?utf-8?B?cmhXWjZTaU03ZGpYaExGYmQ2YXN2UzJkZmI3MUIrR29nVGRWL254TFBqN0JM?=
 =?utf-8?B?bHZONUNxMW5uUUdqaklUUHNBa2QwWlV2end2WWhnODV5NkFKUmhscGxTRElN?=
 =?utf-8?B?d3lRMkxrZzFZcXViU0JFM0dqYkFPdi9VNnRuRzR4UDR6L0cwOC9xbHZ1YVVT?=
 =?utf-8?B?dldmL0RtcThmci82M3FnQWdKSkI4QXE5bUxpdTE2VlREaEJGY1NNU3Z4UGo3?=
 =?utf-8?B?b3ZoenlKMEVpYjhrZW5hK0kwUGFNMStlSFZlUGhxNFQ0RTVhZDNqVWt3SkZt?=
 =?utf-8?B?dVBMOU5FY2tndkgwb1JiUUlseE1ONEhzSUpNTUN3VG1tTEN3STk2bFJqKzVY?=
 =?utf-8?B?YWNtRDhIeDhRNUtwV2ZPTXlzMjBpc1F4REFkZVBrMVI2aVFwYkc4WnhSd3lw?=
 =?utf-8?B?NjNyRzkwM3NvdGZIUDRmQXJKeUxrYU1rQXhpUHp0Mm9vaGxERGM0Z1NvVnc1?=
 =?utf-8?B?S2ZSTGNwRFlBUUZEUWgyZFBrdTVFTTdFM2Z4bkRTYkpFNmEzc3FFOGhJS3FC?=
 =?utf-8?B?NVhyWGMweVdQeEJ5ejJZOG9QWStMK1Y3WVR3VllCTU5ycWxjdDlJanBud25H?=
 =?utf-8?B?WDdpTUQ4R3dZajZZdkl3eVZueTJ0ZUFQcGttZVJrMWZ2SDZqRjBvL3Z2Unpl?=
 =?utf-8?B?bit1VzdkWFlKQkhiMjhCN2lMVjFQZXlmMVpVeVZ0U2pZTGorYWJCNUtrcTVY?=
 =?utf-8?B?NlMxdDhTMW1FWHIwanJGMTFjdTdPcFFmOXJQOGtzZ3J4TGRTNDhhR2VvRWQx?=
 =?utf-8?B?eWpnVU5jdkxNc01SQWtaOEhJWGlWZnhzVmpBenJEQjg1M0RqQWZOaU5CUmpw?=
 =?utf-8?B?SFdXVExHajF3TDJkdzdXRjF3L1MwNUZaclFZVDNWeVpDaGVqN2dKelkvV1hl?=
 =?utf-8?B?b3lJUGdLb0VJaGZXOG8xRTQ4V1FjYjJWZGF4WEpJNXZTUGhDYjJOMGJUYmsx?=
 =?utf-8?B?Tnd6UzRlbkU5YS9wNzFGbmNNOWMrcXNNSFZrWDBsRHRHM2pEYTF0QUtjQkxL?=
 =?utf-8?B?WHYwVWwvdGh5ZFlBSkoxWmowb29KRUlHQ0d5NHU2MGVYSkMwcG11aTlaMDBo?=
 =?utf-8?B?bHdqMEZMSUN5S2lROWJXVnZYUXQxK3ptVjJnSnRKL2JUbHZKK1lnYUFiU2NU?=
 =?utf-8?B?ZERRcTQ5TjJ2YjB2VFUvOW9XWC9yeHlZaFFYMlV1eDh5M3NDU001cENNMU0z?=
 =?utf-8?B?akE2M0RSUWVzNFBVVFMvb3JBTVRhYzVXTjBmNkF6RnJJRXc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TG5Md3d0MnNZM2VFWkxOS0dQM0k0RGlUcVJLNjN0MUd3TXdrbE9wNWdxeU1z?=
 =?utf-8?B?RVV3RkJFMFc4YUFDcS9CSkxvS1oyckpJQkgxcVdlOUhkUFpuZWZyVnRDRWtD?=
 =?utf-8?B?bWk3bm1zL2ZyWW9ld3BaR0tGS0dvYW9zRFBSdjRHRzdFUWNKZWdVZUVxMFN2?=
 =?utf-8?B?OHNCVlZsVytKWGpXZ0JBTEpUUFZyV0ZJaW5ySjNVanUvTE9ockx2aE1pak44?=
 =?utf-8?B?enFhcXVpbUF6M1VKbDZZUVk2aU9aRFFxMWxTNEUxMm9DRnVZUW9oQlVZYkhv?=
 =?utf-8?B?SUp4TUdIVUVJTHh1bFl4MTdLR2pUTFIvWllJUy8yNnRtN1I3U1BPRU5FMnZs?=
 =?utf-8?B?QmZKV2NjMmRqUTNCU21DT2QrbUxrUUZ5N29YbHlsOVBzRkd4Z011Yy9UcStU?=
 =?utf-8?B?SExVV1hGTFV2bkUxV0dXWmJUVEhaL2ZUZG80RnNFWGxhLzNLQ09DS2h6OVpm?=
 =?utf-8?B?QVNDSFZzTEY0M0NkdzJwM0hCS1VOcmRDaGJWVGlpbUVETGZaR1QrSU1hM1V6?=
 =?utf-8?B?WUJYUFhUNTdLRWcvSDc1NTNpQVpTek5PRVBUa1VPZUM2RkNHRUlLYnJjUTFl?=
 =?utf-8?B?Y2dLNUozaWdHQndqSGNOYUxZSjlvaXNGQWY1V2pHT2tpbVpUalpJRWxDeVhq?=
 =?utf-8?B?UVViZkp0aGw0T1JRWXhpSGVlS1pMdnM3MkF2NEc1RWUxd2JjcGhiWlBVRlRi?=
 =?utf-8?B?RHlodWpLYTNxZDdXQVhuQlR5OUYrRmNXalg2OFVKdFo0dWRmWjRoM3kraGtn?=
 =?utf-8?B?ZDE3V0RYL2RDaUl5dVpLcFQ5QzRycy84d2svZFd1elJERStwaDV4WE5NcmtH?=
 =?utf-8?B?cCt0L2RQbjdrSlh4MzlWWmRHaGhkOGtvK3prZzhDZWJ0K0xXYnRxWFhDUm5w?=
 =?utf-8?B?THpUY082Qm1LdU9vRmZTZUNQK1hJeEZJTWJ0dk9vUTZlSHVKUXl6WmczTGlz?=
 =?utf-8?B?b0ZDeDZHbVB6SU5VQVZ4SWwrWWZpSDl1ampKWTc3MjdUU05xbUVVTU1DZkRZ?=
 =?utf-8?B?N2hqb0lZN3g0THBsSDBSNFloS1VyZ0lkTlp4blNVd0pPYnJ0SWhjbUZmU01V?=
 =?utf-8?B?MWczelhhV1BLR3U4YkpzUFV1VjBKRHpWWnNRdFVNNVdhZTVNZEtXR0xqMDBV?=
 =?utf-8?B?RnFzUTFmeU5XYkYzNTF6dDVsaEdXeEl5cTMvMmd6aVdUWWNMQVpsYno5ckxx?=
 =?utf-8?B?dHRIcmxWSjlHMFUzNThJb09oMWR1bmsyRGc2UGEzTlZ0bFFwdnBIRnJzRlZE?=
 =?utf-8?B?Y3dNaVhXcFdMczBhbEJ2RnlxSE5uY3hXZ2lEdEluNVR1ZlA1dUVQQ0dld1Zi?=
 =?utf-8?B?RTBwQkhnWHpicHhlbEtXQnN4RVdMdXpROFlnM3JjQmo5b0dWbEZseFl3Y1JE?=
 =?utf-8?B?d3VISFBKblcyS1c4eGVZVURvNXhGZXpPSEpMM3ZqUXY3eWkxb1hCN1Q2YXBv?=
 =?utf-8?B?OURJYk9DUWxMbzUvTmRkVTN1K3BhdU5URk5CRENQY2tSMGNPbFZYTnJ0UUxj?=
 =?utf-8?B?TFAwa1Y1d1RhTE5Jb3gzdXk0cUhUc3RXMG5NMjNodlJJTDJONHpqb051MGhK?=
 =?utf-8?B?NXVWQ1Zwci9hL0tYTXBEeFFKT3N2SU95VjlubW5SRGxJNDJlZWdnT1NlSjdn?=
 =?utf-8?B?cjVZZmh4bUVOaS8yU3ltKzhtVndxbzl2UzRHVG1DOEpYMy9Tbk5TTVRNTW1u?=
 =?utf-8?B?aHN3RHdxOElOMkh6THNDZ3NEL0orSk5EdGRkZGlTN0lnZUJXajg1di9Zcy9s?=
 =?utf-8?B?SW5rZ0lQOEhHakVCbTMwc0tYbjhMWkd3cC9vdWwrc2NsNXRQeU5vK3JxcldX?=
 =?utf-8?B?ckk0OFZxOThIVW5DdEdRb3drNnJMb0x2M3BvbTVLQ0pzRnRnZmxuUHMxTE5G?=
 =?utf-8?B?OU1ESWhPaXZSM1BsdWx3c2FIRXMxNFBnUnBkTVVLaVpGSkNudmpuMVFxU28w?=
 =?utf-8?B?TzJBNmdxMzJyQXpmSVp2bEg0a1B1UEJMZFNoZEFxV1QyalJrQlJBZUttQkli?=
 =?utf-8?B?b2RFTzY5UitSR1E5S0J1NFB2SmZVejYrQVVZV3BlQVBCOVUrakRrOVA2OGdV?=
 =?utf-8?B?QjI3bU5YTVJjRW5ndlI0Ynk5Z0xFZnA3RVJnK2J1MzlIbWVvUXdTODhuaFdV?=
 =?utf-8?B?QVg1M0Rwa1E2MHpYWHlsbUtIZStJZmNCNFFWOG5mY3pBbDV5YjRxbmhOZmVH?=
 =?utf-8?B?RWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BD03B82E1F46DA4496FB76BD1C560D57@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d95d48b-f90d-4bc5-b900-08dcd194ed8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2024 12:34:34.9995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dDcuv6L9O6mHdvLH4b/p9jzjq4/D7CYq8MV43TnkwWhj6UBsu3dTRB5iJJYosrUKxEJQjycBE7xikPrXXOusRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB8225
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--12.244400-8.000000
X-TMASE-MatchedRID: TDQWNTPftUDUL3YCMmnG4t7SWiiWSV/1bkEYJ8otHacNcckEPxfz2DEU
	xl1gE1bkfdd9BtGlLLzx1uczIHKx54/qvvWxLCnegOqr/r0d+CzvJY9pBzgg1OpKeQsJK8VpjxJ
	SwOFYN/Z/6+XABCnXhZso2fH+hyf3GBntNyPrRBuHov5mQmFcLn0tCKdnhB58pTwPRvSoXL0ir3
	kOMJmHTBQabjOuIvShC24oEZ6SpSk6XEE7Yhw4FlWm6W3JUOWrD7WtSLk2Gl59ci6Tr0umlR279
	AyXsIOhumHc54h9r94=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--12.244400-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	B8F09EDA58DE8946656D36F077D36B380994CFE5FC21F90195BF9B9974FB54AF2000:8
X-MTK: N

T24gTW9uLCAyMDI0LTA5LTA5IGF0IDE2OjExIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgU2ltcGxpZnkgX191ZnNoY2Rfc2VuZF91aWNfY21kKCkgYnkgYWx3
YXlzIGluaXRpYWxpemluZyB0aGUNCj4gdWljX2NtZDo6ZG9uZSBjb21wbGV0aW9uLiBUaGlzIGlz
IGZpbmUgc2luY2UgdGhlIHRpbWUgcmVxdWlyZWQgdG8NCj4gaW5pdGlhbGl6ZSBhIGNvbXBsZXRp
b24gaXMgc21hbGwgY29tcGFyZWQgdG8gdGhlIHRpbWUgcmVxdWlyZWQgdG8NCj4gcHJvY2VzcyBh
biBVSUMgY29tbWFuZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YnZh
bmFzc2NoZUBhY20ub3JnPg0KPiANCg0KSGkgQmFydCwNCg0KVGhlIHRpbWUgdG8gY29tcGFyZSBz
aG91bGQgbm90IGJlIHdpdGggdGhlIFVJQyBjb21tYW5kIHByb2Nlc3MgdGltZS4NCkl0IHNob3Vs
ZCBiZSBjb21wYXJlZCB3aXRoIHRoZSB0aW1lIGZvciB0aGUgImlmIChjb21wbGV0aW9uKSINCmNv
bmRpdGlvbmFsIA0KZXhwcmVzc2lvbi4gV2UgY2Fubm90IGp1c3RpZnkgaW5jcmVhc2luZyB0aGUg
bGF0ZW5jeSBvZiBzZW5kaW5nIGEgVUlDIA0KY29tbWFuZCBqdXN0IGJlY2F1c2UgdGhlIFVJQyBj
b21tYW5kIHByb2Nlc3MgdGltZSBpcyBsb25nZXIuDQoNClRoYW5rcy4NClBldGVyDQo=
