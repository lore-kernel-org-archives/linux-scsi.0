Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C8B13B584
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jul 2024 08:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719996802; cv=fail; b=OVs6p81eapciZ5i8eFC5VVMu3SW1Z5WJCLB0eMfGS1Vv0V7p9fisEzD5k3SZSgFNPvVxebau7/wglH26yWfjMgDmGz3IsCuVwkDWZgf2Q67tsFUWdN9SX+5DwrioYQ64esuLaH8eaAHa8dL+e9yJ18OWLxRicEuK2yTDPrZoey8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719996802; c=relaxed/simple;
	bh=Z2bkR2AZv9Yblgs7Ldiax2hzEvPexnqG1n43rbRvR80=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QJq4xPctJMJvO0Vc238UHxuyjEID8AXAbDgoNMz2RB9JbtAD4CojRAqZ/Izmm3nuzo4b+rxdUXLZhbycRH7fY9Ph/3/URDs0btEotwPT8lUpfb2tCWLhFsbVp7Nj/ckTl0hVxXsS+nSaXWxLgBdMqcQmhlgRCzQILLefGBhv9qw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Q4yHedAL; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=s2XteApI; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Q4yHedAL";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="s2XteApI"
X-UUID: abb83cc6391911ef99dc3f8fac2c3230-20240703
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Z2bkR2AZv9Yblgs7Ldiax2hzEvPexnqG1n43rbRvR80=;
	b=Q4yHedAL5pSehYgcXH5o8SEUADqvhwy3t5yoPfmBt4t8TpRZ7kCkr9H+E534U6VaOgXYz7djARQ54izGCWucI3yOEKB+jtjElW+YuDBZDOuW+1ydN/PiNcalW2ntxV3DC2pagjxqGZvSwRab1PcM/OciT7+dPEZ22agFlecbuKs=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.40,REQID:d6661caf-6182-4c1e-a2f8-658d13369fae,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:ba885a6,CLOUDID:b3e809d1-436f-4604-ad9d-558fa44a3bbe,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: abb83cc6391911ef99dc3f8fac2c3230-20240703
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 799643616; Wed, 03 Jul 2024 16:53:08 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 3 Jul 2024 01:53:07 -0700
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 3 Jul 2024 16:53:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JgGEJQ7rbH3fRTxvTpIgb+TkmHZtQMbYRpw6tCpaKIMb2W2E9uhGbirMfe9EIeQfixdTjCLaq4qbQZsP7gYZgmAIUeeTPgJu4rwvEP09Vtj5395Q14qKsNCACMN6OlcXq7QgnwbrhUTDk0KXnABH8XSilu5gCQvI2el4C1fLB4DGsUl2KO8YIUxddzT0eLOsib9PY1lD+4AwXrkIRHRFYF4SCRslNvE3R268Betqe91iV88jtRs7uMi3xtUNifCd9iiVPwxiQO8hMS+jlago/2wot/V5HIYdLpLdrES1dvLtx3JX8E0elAJdnoiGkDdY88B20EVccYBjgqbXQQiCyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z2bkR2AZv9Yblgs7Ldiax2hzEvPexnqG1n43rbRvR80=;
 b=HfyGvd76HeBuI9p84/7iOU/zp50EJxXJT8d5wL4whnLUBuWIyTAL0dVhwZDOngz9Uoyr4D7jDS5EwmQQ7HKOc0ZO+eR8xwZhO/IpqYtH68N0o6wRJ4yTUX7ieOlQ+6R5UBHJHWrhVwIrQqR6oPxzMo8K5KQWGGrhDmwZ6mtRzP9fcFoK48pbUYFe7Vp+C4ZBSTEqQJS4TncF1KQf8zVuIc3ANfEyjHaVN7cDHZ7wQmJ2QM0yMXBjyZ95PgqxYV2Iz0LxSNV+GvSiD1T8g5MGGYITD54kZYgZZM9PvMOw/XgbJdFmimLFmFNmdjmR1XpxkNw2HQ1cxxG5rPrZyDyySQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2bkR2AZv9Yblgs7Ldiax2hzEvPexnqG1n43rbRvR80=;
 b=s2XteApI/DAtbWSYadSOryFjlAZvM3yQ/KZz0N9S0/Cirav4GrXi3Iwy+nI0LRgSLoXm79LbWnd6XZpOImLqbgnq3B6Ao9oKcnhpL7CDvWjweAjpE8AseTWWcRWasKWSqtkwxWrXgs/SgCXZiQQd4bFg41m7VibN3Wjhyd/rka4=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by JH0PR03MB7656.apcprd03.prod.outlook.com (2603:1096:990:b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.25; Wed, 3 Jul
 2024 08:53:06 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7719.029; Wed, 3 Jul 2024
 08:53:05 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
	"akinobu.mita@gmail.com" <akinobu.mita@gmail.com>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"cw9316.lee@samsung.com" <cw9316.lee@samsung.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"minwoo.im@samsung.com" <minwoo.im@samsung.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "daejun7.park@samsung.com"
	<daejun7.park@samsung.com>, "yang.lee@linux.alibaba.com"
	<yang.lee@linux.alibaba.com>
Subject: Re: [PATCH v3 7/7] scsi: ufs: Make .get_hba_mac() optional
Thread-Topic: [PATCH v3 7/7] scsi: ufs: Make .get_hba_mac() optional
Thread-Index: AQHay+FdSzs5kWYjwEuWnAVK7NEzubHi+qGAgADqFgCAANBcgA==
Date: Wed, 3 Jul 2024 08:53:05 +0000
Message-ID: <cfbe5681a2134bbd7e377932ac8c9a61d3f2fe61.camel@mediatek.com>
References: <20240701180419.1028844-1-bvanassche@acm.org>
	 <20240701180419.1028844-8-bvanassche@acm.org>
	 <0b1a9acb836a5ce5467ec5e2327b750ace51ad82.camel@mediatek.com>
	 <31ba05cc-3ab0-465f-8d3c-b0e32e13f583@acm.org>
In-Reply-To: <31ba05cc-3ab0-465f-8d3c-b0e32e13f583@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|JH0PR03MB7656:EE_
x-ms-office365-filtering-correlation-id: 165b545c-f9f6-476f-d7b8-08dc9b3d8e08
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?OSs4QTdFV2tGTW1FVnBldWNZaXVhZmJpSDdpcGFXWUNiSU52T1ZJQjFJMUVF?=
 =?utf-8?B?NHdrdmJtcVY4VERQWUtmelB3QlZNdEpRK2lPOFpHeGc0VzA1QW9aNzhXcmZQ?=
 =?utf-8?B?WGE4ZDg0eGFwakdzTUNZRmxublRuNlA4RU1RRThJeU9ZZGloSEJsTGlkY0pt?=
 =?utf-8?B?em9yM3FZdFRxY00zQ203dDdRbldONVVuRjJpZS8vcGQrZGc3Y0FESC9JdWx2?=
 =?utf-8?B?czdsSnIyaGtGaHdLYnpwME1vM0lkZFZtZWd1L2JGeGhDcG41MStKVWJoTEhk?=
 =?utf-8?B?bElrblh3SzJwemwrSlhRZlIrbkNvYzQraThBYUtZUEo3clMwV0NjMTZ3ZTVM?=
 =?utf-8?B?TG11aHcrWlRMZkgvM3gweFdrNWRXNE5mMmIyVGRrTEFkRHdQRFBMNm5TODVM?=
 =?utf-8?B?N1N5VmRpUjluTzVoSFJQUDkrMDhUV3d0LzRxaFNaS1FEcTVIYjZzTTl0YURC?=
 =?utf-8?B?VWdNbEoxTXpYMHQzMnNCcnFvUXRpL1VrbWFGV1BjTEFEYS9OT1RFQ3hWOG83?=
 =?utf-8?B?SG9vSWJpREUwUEdLUkxyVXBNNUxqL2QyMTZTeDFiQy9lVlJXcDhWT3U3SkVL?=
 =?utf-8?B?TFRYUXpqaTVkY0s4S3o2dEJvcy9jeUhrTUo0ei9HTUZNZnJlQkhVRC9WZno5?=
 =?utf-8?B?ajdoSXFjMEVKQnAzdjZjTkxnR3pQaDdBUHZ1VDM5dDc5RTJ0dVZmZE12anVY?=
 =?utf-8?B?RENyYzg5UjBwR3o3bG5URnIyTjhVeml5RWFmR1lGVm1acGZ3OHNaR3VraDho?=
 =?utf-8?B?eWFrbENxOEZDWlF3WkNBZ0h1VllxZTYzMmFsVzBjaVVFSHdmWnpONzdvYmFZ?=
 =?utf-8?B?U2RITXRUVWRwMHIvbGtYMFdmZUl6V2xQdjNab1AvbEtJcEM1WHg1QVlqT0dj?=
 =?utf-8?B?c0kzWUQ3TnZuZ3FSYTd0b3paejVTV0laL1ZnNG80eDY3YnFIM3MwZkNOUk5t?=
 =?utf-8?B?MjBjWVlrdTFSdkJVenZQV1MwMVBBVkNHNWhkZmMrYkx5eFhYZ3BmQVBuTm9I?=
 =?utf-8?B?aUFkMnIvWlphdm1xRllrSVZXZThrY0NWSWRyN3lSbHJhQTFTTmpVOEYzOHNm?=
 =?utf-8?B?WmpzMFVoZTJEZTUxYTY5YVZIVFlEdFU1NTZqTE1VYXRjcDlvbVUwV21GWEpG?=
 =?utf-8?B?OU1WM0c3eFB3R2JEU2U1OG9DN21SN242T1Eybkc3TDZ0b25kenZLcy9qRHpS?=
 =?utf-8?B?L0VUZGFJV0tWcUo4a20rcnlPQTZKZDY1ZHhucFJFN2tJSk9kWFVHeEptRWMv?=
 =?utf-8?B?aDJSazExVUJveU55TEh5TzFRRlQrSVNhd1kvM2dLbWNCNmRVaGk4anRPVWln?=
 =?utf-8?B?RHdVRFpQREVPdW4rd1UvN3NFeE9KZjB5dlRNSGE1MS92S3htUW02ZG5iSHpn?=
 =?utf-8?B?VEdSN2w2RGorNVBKWVpGSVRON3JBbkJIRlJhQ0pTRkJ6Ni9MQ3plZDhVTjAr?=
 =?utf-8?B?UjFFcHdUWUR2Z0xlUXB0a0tsVVV2MlRiM2E4M1hGTVJrQ1ZnUyt0N3ArUE1L?=
 =?utf-8?B?QzBSTXFXcXA1QVJjRkJyU3FFTlY4cFprQkt4WkVaT3VKLzJ0cXI4bGtCUVdp?=
 =?utf-8?B?TzdTVUxzYzFlc0pubDRVWlFBeEhhdGFRTVkwVHFma3FHN2VZcTFsUTRMcDM5?=
 =?utf-8?B?elZHN21oRHN0RnUweDFVNHdDVTlEbUs1QVNOekZ5K0dIQncrVHNLMTIvQzE0?=
 =?utf-8?B?ZkZnTFdjUDdqaGx3N3pWeG5tdXU3Ym5UakZXa29vczZaS3Y1c25hZlJKM3VP?=
 =?utf-8?B?NUFBaTJSd3haSmdlU3pKdXNzSk1pVFowclUrQytQYUd6MHRrNUFNWVh4ZDNo?=
 =?utf-8?B?TW5IeHRaQnZ5bzNJYnpGZkhwUldaVmJ1UUtKcW1tdnZjZWJjYmN0OGNiWTNl?=
 =?utf-8?B?bGl2b2xzTzBlcjZTYUFZRXk0a3dFdHFaY0FFajZjS3ZKYUE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YkZqdXh3Tys1N09DRmlYYnhqcFdZTjdQUnJOWk5ZejdVaE55azRpZlFuNGZD?=
 =?utf-8?B?bUpPZ0Q3QXFkTHBmaVFUMHZrTkE2UzZMN3hSYnhZakNXYitkYlYvRXYxZEFF?=
 =?utf-8?B?R0hwNHQ2NlRXa2VTSStPbHQ4Qm1nVHVuaEltNFlrRXJWa0pyd0p3eHJUNmlK?=
 =?utf-8?B?N0w2Z0k0R0dxM2J6dHNHMks4VmJuMFhtWU94Wis0QS9WdGFTTWl1RXoreGhu?=
 =?utf-8?B?YVZXd1VwNHhsR1NrSkE1YTk3b1h4N0wvTkdEUGMwOU9kWW42cW9GTk8xdGFL?=
 =?utf-8?B?SUVnYTBaYjRMVi9aMjZHcllwaEEzYklZOTNTKzZWcDFyWDB2Uk5SQWFBRjIv?=
 =?utf-8?B?U1hrTXFPaHlEUUFIbW5tS01NQUFZU0NWQVF6VkJCMHhtL3pEN1NvdG1xN1BW?=
 =?utf-8?B?U0Jqb0lkaGVtUU1hamt1M3NBOTladTVtbnducnUweERCQ2N6VFkyR3RyZVJL?=
 =?utf-8?B?Q1JrVHB1S1krcmJlTUFMeFVaa1kyN2xSUlV6M3dVWVN3aEx5UnQvbVdjRmtW?=
 =?utf-8?B?UzBuZVJ0T25LbmN4ZkZBcjVpTHJJbVZOcHk0QVJoNmRCMEVBUHZxd2ZmT0ha?=
 =?utf-8?B?SUVuRzBtc0V4dVNwVWNYZ09ZcU9BWXo0dDJqUENPTTZOYmEyZjdKQ0VMSzNh?=
 =?utf-8?B?UTVoTFl2MG9yMFZ0cWMyeXc0QzBlRGRicGlwYStJQktVNEF4Z0ZCSFZtM0Rl?=
 =?utf-8?B?WFdJcGxqb01SZE1JL1Q1ZEpnN3h4SndZVDlsc2NzWEdMN0dXa3lWYUk5Z2I2?=
 =?utf-8?B?UW56c0R1S0VZS0dIQVF3VWo2NytVMEpFTzlyZEJleHprN1M2MU4zbFFBNDVk?=
 =?utf-8?B?ZDd4ZC8ydFlObzE3ZXJ4YlFOZ1VxbWhKVkVLRU1JTTJxS1Q3NkF5dllVYS9y?=
 =?utf-8?B?NTEvelVhUy9VdUJ2YXp4aHg5VVNEWGtET3NRRVdLcGZLd1djZUo4OFpFb2Nt?=
 =?utf-8?B?bEl6eUQ5UVFpcjlkTjNjRzFUUjdqOHdxWVEvSnMwNmhud2pjcENnM2xUQ2Q5?=
 =?utf-8?B?R0psWnI1MkgvS2V4c0Z5VUN4aTNXdVhuMFNhSW8wU0FKWHpiNHM0ejZWdFUw?=
 =?utf-8?B?aE9JV291MWVLSmVEZkpZalg1UmdJcVlDb0VVWGJ4VmFTWTF6R1JJM0ROZk9m?=
 =?utf-8?B?dldmMnlGbzJ2dUc5VXNsWjBRVHBjQU1NRGNSVjFkbnZKTmtjMWltWU9jVElL?=
 =?utf-8?B?aWhSckxJUHpCRnJXbytnZWdzOTJFL09lZE9mNW1Wd2ZBTjNUVERpaW95RzBK?=
 =?utf-8?B?V1NWNitZaHBjbjc5SlV3ZTljM2h0d1BJaVRDZjh1VktoSWlEOWhzUms0Yk1t?=
 =?utf-8?B?c2F1STdQcU1zek1ZUGFVc2FmOXAwL21CeEpXUnRQWHY5ZFdmNDNNbG1UZHpk?=
 =?utf-8?B?T1k3RkdXUVpWZlh0bEFYNTF6eDhKU2FUSWE0TTl3WlNiUmtmSmFDak9sSUtI?=
 =?utf-8?B?UFM5ZHNMWFBKM2g3M0l1bjV2QThBRGhiK29Dc0JHRWJCRnJnQU5UaWFLN3dK?=
 =?utf-8?B?M1dtNlpnWFFZelgwL0RhemRXclVKejZYaUpmWmZScnNPdGlGNnkrVklYMjh1?=
 =?utf-8?B?UXFaSWNTR3pQWUpzV2lVMm01K2FCa2R0SDd4cDFQTVhJZ2w2OWFlVTV3cGQ3?=
 =?utf-8?B?RjNERHIyWXRmMlVBVHRLOFNxREsyUllvNkxPOVVkQk9xb2dBU3NjaW5PUitS?=
 =?utf-8?B?YlZCZVM2V3JhTHoraHlXWTd4WldVL3krU0tjdjNoUWFhWnBrR2ZoazNWT0ZL?=
 =?utf-8?B?Y1RpRzYwNDlockVwMXhuMTVYeXdYcGczTEhwY21mWUM0Q0VhNzVJSWpwbVBy?=
 =?utf-8?B?c1VKNFhsb2M5RXNjcGNpWFhUc29GMjV4YWxqTm0xa25xNEM5S0JVL044UGFN?=
 =?utf-8?B?VkcwcTVVOGo0WGxZSkRJR0YrbGN4dGhMbzlXWERubC9CVG9tUy96M0tiNWRx?=
 =?utf-8?B?c0FxRXFMc1VWdUc3SG5sa3VVSUdSV2trUklWR2F2bGVrZW85RDhCRDRuRW5v?=
 =?utf-8?B?TDh3OXBXN3lDaE5nNklzY3NqR01VelpoOGQ3VEFUdVcrdVhXUFBQRnBzaXhk?=
 =?utf-8?B?bm5nQ1JFZi9NbmJjS1ZyMGJ5dmdWMlFXSGUvbndUcXJjaW1zdy9kOHdWYzdX?=
 =?utf-8?B?ejVHd2pDdktLeWlMK0FmWThxa2pqU3Bpa3FGRHB1Z1pRZ2tJVWUxbEp5cG16?=
 =?utf-8?B?bFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D8E6916E8AAAB549A41826683A39A7F0@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 165b545c-f9f6-476f-d7b8-08dc9b3d8e08
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2024 08:53:05.7854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8JtrUnrjYPx1ssvhcF+tO29WUTRvFh/mMoqYnNBgVmUxSdvx1qr8OHW0SloKx2dAa5NLqMUUOP80Vyu4xmW4JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB7656
X-MTK: N

T24gVHVlLCAyMDI0LTA3LTAyIGF0IDEzOjI3IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgDQo+IE9uIDcvMS8yNCAxMToyOSBQTSwgUGV0ZXIgV2FuZyAo546L
5L+h5Y+LKSB3cm90ZToNCj4gPiBCZWZvcmUgdWZzaGNkX21jcV9lbmFibGUsDQo+ID4gaGVyZSBy
ZWFkIFJFR19DT05UUk9MTEVSX0NBUEFCSUxJVElFUyBzaG91bGQgYmUgU0RCIHZhbHVlLg0KPiA+
IEJlYWN1c2UgTUNRIGlzIG5vdCBlbmFibGUuDQo+IA0KPiBJIHRoaW5rIHRoaXMgbmVlZHMgdG8g
YmUgZml4ZWQgaW4gYW5vdGhlciB3YXksIG5hbWVseSBieSBlbmFibGluZyBNQ1ENCj4gYmVmb3Jl
IHVmc2hjZF9tY3FfZGVjaWRlX3F1ZXVlX2RlcHRoKCkgaXMgY2FsbGVkLiBTZWUgYWxzbyB2MyBv
ZiB0aGlzDQo+IHBhdGNoIHNlcmllcy4NCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQo+IA0K
DQpIaSBCYXJ0LA0KDQpZZXMsIGVuYWJsZSBtY3EgYmVmb3JlIHVmc2hjZF9tY3FfZGVjaWRlX3F1
ZXVlX2RlcHRoIGlzIHJpZ2h0Lg0KDQpUaGFua3MuDQpQZXRlcg0KDQo=
