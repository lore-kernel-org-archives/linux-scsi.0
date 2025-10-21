Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695421DF74F
	for <linux-scsi@vger.kernel.org>; Tue, 21 Oct 2025 03:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761015866; cv=fail; b=a/rUG0PxQLKxUuBFzc6nnW44b2WIeh5kH7gg/nhP/eWcQQeQr4NW4UHYSjJT2gPvZXDAVfP1RFXPgcSwLWC0G/rjyRXE5f/p5h4CGVQ9AdI6glEEtt8rU41Xe9RCQf1ms8xeSD2rfiN0vkmHlfHeFQHCbkLUTwHlmy0b9W/peXo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761015866; c=relaxed/simple;
	bh=0KdBG7BPVAKXdBl8mVQ1SBzBG9Wf7tzHhmaz/PK+SXw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DPw+vLRKb3QrR4UIZVvI/rv0KbHKmqOF+T/hP2BelAqQuWgqe55hW+X408GGR4m6Dncd6ZgmAMQyejTSdQRQO+ipgw+suoe/z8ciR3H3x2FePb9u7BDFxXRIs/HeoCZHPPeRRGKsTYc1t7mjkNanYjsZk1clAsWV7sN6Y2zI/uk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=uYzDB0xj; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=AsKUW4zD; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="uYzDB0xj";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="AsKUW4zD"
X-UUID: a2080c10ae2a11f0ae1e63ff8927bad3-20251021
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=0KdBG7BPVAKXdBl8mVQ1SBzBG9Wf7tzHhmaz/PK+SXw=;
	b=uYzDB0xjyHVO4CXQqiHNZ6iwdxD7OwOIXJy3RKnTYtVw1TwdQoy81sbd+70AEbRpIWk/Tq+fMehhVfkYA3MjJBVyM7fzAKDR3Ecqf6GOtYjX+0xCYLl+3YoyNZZeaNiAjZd2dIwXZjjUnvG3U+1AllBw/o32Qn5Wc1B/dX8KNcg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:32983eef-a6c3-4b6a-ba05-a1f324af642c,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:f58862b9-795c-4f99-91f3-c115e0d49051,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:99|1,File:130,RT:nil,Bulk:nil,QS:n
	il,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a2080c10ae2a11f0ae1e63ff8927bad3-20251021
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2144342491; Tue, 21 Oct 2025 11:04:17 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N2.mediatek.inc (172.21.101.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 21 Oct 2025 11:04:16 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Tue, 21 Oct 2025 11:04:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kXI0Xj/Fj8mexjzyJGKMOeD9OpGPRalG5vHntTVjS9EleRghlnoNl9cBM3CEua4W7Zike3thPErKRgWs2z9MUsH68cp8t763zsSClSgd/rZJru/9zYuZVP2Zdco0opMPrgRhdoSBiAZLIAIHnpiddZBUGML5EJIlxbM+S32WWKWe/6ucx6/fC/X4Mfs0mczyP08+cF0uuhx/s7sNC0tsPHU4n4W3o0zBxlSzzh9D6j0BTdlgNw9zssF1GH5cPVyZgyA8vYj/FpAwmtkqT4MCuXZe63dAtKIwIE3k20/d1DQtmj4SRFGnUr5x93whQBl+A84+/nOi0qxdub9ZXH66Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0KdBG7BPVAKXdBl8mVQ1SBzBG9Wf7tzHhmaz/PK+SXw=;
 b=XeX6uBBescHu2Rym5mbVdMLA/W2zYDvdewfagGATmbgZc1fZzuQSUJN4QKekUW5gnk/uY5ISnZywsNQRAIBA+FiThuHLwks4RXvZ1Z+ndO+lNQL/0RDxv/Gej1n0zJpHmRpW30FwCapUAoPuGhZDE+Sfr8teh8FLV2bI07XySBrf9D3ZPH1gbX6z4CrJTL8uEE6B7IRbLGpXZjV7WbxMqZSXyou0/ccj1fcXrkqJ0I9qlE4H7ay0D3QpMwMYckzT2bmli75+d8eGBgRrcOLaX+QkHcLmMeJe4D3vMEnf/DgEPFXl/zK4zz29Sp6IOBCmjhb2qtDyGZgER5hDpFewuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0KdBG7BPVAKXdBl8mVQ1SBzBG9Wf7tzHhmaz/PK+SXw=;
 b=AsKUW4zD1/y+UNFBgOi6CgkSYotP9AvKXPLXDpb3MlbeeeyC1A3FcVCACPV6yk+w2I59JNHxcD6gD8KSMLWnVx7u/VBOA5qOQAtgCsf0SHPTgELutF5jIu01T3HbBhv8Ma59tsKT5oHtTq/tz1PRniJjp1fpBpUlmTvzutbuh64=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB6894.apcprd03.prod.outlook.com (2603:1096:400:287::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Tue, 21 Oct
 2025 03:04:13 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9228.016; Tue, 21 Oct 2025
 03:04:13 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"chullee@google.com" <chullee@google.com>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@sandisk.com"
	<avri.altman@sandisk.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>
Subject: Re: [PATCH 1/8] ufs: core: Fix a race condition related to the "hid"
 attribute group
Thread-Topic: [PATCH 1/8] ufs: core: Fix a race condition related to the "hid"
 attribute group
Thread-Index: AQHcPUVzmnY3uUn2AU60C/91apcezLTGBUiAgACFlICABBZ7gIAAnS0AgAC1soA=
Date: Tue, 21 Oct 2025 03:04:13 +0000
Message-ID: <c47fcb9200d4e969b8200a8c2cb4a4af35883047.camel@mediatek.com>
References: <20251014200118.3390839-1-bvanassche@acm.org>
	 <20251014200118.3390839-2-bvanassche@acm.org>
	 <22dd7d580444be92d0029694468cdddf1ac98f13.camel@mediatek.com>
	 <569fcd05-4d77-468a-bc8d-c86d0a5dfc8c@acm.org>
	 <bc0ac3e9f44bb3c6e0f06efd7372b21535ac07a9.camel@mediatek.com>
	 <62ec19d2-f7ee-445d-be97-098acc1f390b@acm.org>
In-Reply-To: <62ec19d2-f7ee-445d-be97-098acc1f390b@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB6894:EE_
x-ms-office365-filtering-correlation-id: 814540da-d698-4ed6-5f26-08de104e83c0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?NGpCbEo2TjhKNzhWUHBySlVZWGkxeURKZXNONFB6SlZhekVwenFVREhGSDFu?=
 =?utf-8?B?U1B2cTBWcDZoZUYxY29FdVgxU2VWOGxkTEhWQi9kMWVPSFAzcWJBWWYwTk1z?=
 =?utf-8?B?Wi9mUjYySThsb0pLVXNETXIxZTNZajdSS244ME1LMnE5RDBwWHBrSmJNLzlH?=
 =?utf-8?B?UUwyYzgzYjBaRGtHYWxkbTdpaHdzYWcrSTNJT2xVcmlHZjFxTDIzLzVONlph?=
 =?utf-8?B?T1JUSnFhVU5Na2NHTHZWbEp1R2xoYWZySmRCWC9ldk56UWwxR1RCZVF4OHFx?=
 =?utf-8?B?YkhucHlpcTBSUlNpMnRSbmJMcnhZNUxRRGhhZjYrYWFWNUFPdnpXSDBQRmNX?=
 =?utf-8?B?d2tpVllJdGFjYnVuT0wycEF1MFV6SUk4Y3hMaGwwcHhSSVU0eHNkd2dLcEVz?=
 =?utf-8?B?eTJwbDhSMitMWmRoN2ZxZXJSNjk0aHhjdWxMa1VwTWxlbzc2NkJWR1VuRHRT?=
 =?utf-8?B?RmpBR2t3QXhCclg1b1VBYmw5am1Nem01UlI4T3B2NjBJRitEbEphTkcrcHZJ?=
 =?utf-8?B?ZExBc3Y5Z2ZsbFYrbExUUFp2d1lFKzY3MmRuTDltakJFZ21iMTMvOFJqN0tr?=
 =?utf-8?B?cVljVUVyVkQyRmR5Vm5ScjlhMFpod3VTMWU4c3Q2ZE5ra3ZDeTdXRHRoQkJB?=
 =?utf-8?B?MytZVWNrY3FpZWcyMG1ocHJLenY2ZGNtelI4cm1NVUxlWS9GVkRBc292eUd1?=
 =?utf-8?B?THROczFMR3diZkNFVmFBQ0x3N1VEZDZEdXlnN0U2ZVg1Z2M4LzdKVTlsZHc2?=
 =?utf-8?B?b256Si9FdkJPdjVtY25MK0ZoSCtTY3Y3cHlpVHJucSt5Y3lYUjU2UjRmZ0Fm?=
 =?utf-8?B?QUZmUG1nSU56WXZpQVh0UitReUVQUTYvQ3crUnJVNTA2THJIejJpbFNHR3R6?=
 =?utf-8?B?OHpRcXNvSCtvY1g0SU9yVWszaFFyRWV5YzhGeDJmd3E2SitXWXJCQ2JzYVRv?=
 =?utf-8?B?bXA1OGJwcVl5UHRob1JyOUFVZG1MM3dNUmFUck92aEJCMmc3UTlvRFJ1V2Iv?=
 =?utf-8?B?VVJXUzJGL1FUY1JNazBBRW1CRUVheEtvWEZPMUEvK3JFUmNsWDhCYnNGWEtr?=
 =?utf-8?B?RFNQZzlJSnZ2bm1uR29QbkFyS2N5RVRxUkpBN203eFRFY3JXdkZTRGpKZ0dp?=
 =?utf-8?B?U2ZpSlgrKzU1VWJFV01Bd3VFcTA0QWZtUGxQb3JOS1J1Z2V0aHRia25oZXV1?=
 =?utf-8?B?WllrZ0hsbXNGT1ZRYTFBUVRVQkFvS3BTSmI3bjBYQ1krL0ZvYjFLUDdhN1lW?=
 =?utf-8?B?NlFhUUQ5TUMrZWVHbzVoWmFXS2tLR2RNNnhOcnQ0eXJhcWdYcDNuQk50QmxU?=
 =?utf-8?B?Tlo0YUlhUU8xNXRpVGp6c0FsT2xhRDlpdy9tWmJ5NVNBTnZoRzAvNE9mcG5s?=
 =?utf-8?B?UW9BaW82OUFFTnhpVmhZTDVJTWtLZlg1L2MycGphMEpKNXB4V3dpZzduRGFV?=
 =?utf-8?B?cXl6ZUVURWl6MWVuOURzL3grc2NCR0xrZGF5N2R1MXJNN3NPUnVKZllzWTY4?=
 =?utf-8?B?SFRmZEN5c2pURkpnbWxSeG0rVFp0TVZDYkkvbWt0WXp1MEJNTFRZT1NLaHNa?=
 =?utf-8?B?UjFZVlB0TW9ud0k2SFR2VUNnVktrdllIWG9zTnVDUGEyZFNxMGpsMmFudUpE?=
 =?utf-8?B?bnBpSVcxdVJKaXh0UGpzWVlVVkpiNE9NaGZvOSsrRXM4WDlLR1VQZWN3QVdj?=
 =?utf-8?B?eVFEU3pzYmlxMnhOdWFIMWFhZlF3MWxzU0ZsamMvUEoxOVFpWmRmTkNQZzhL?=
 =?utf-8?B?RGRDRlYrWUVIWkJjeGRDb2JCYVdLcjVXRThnWm1Wa2E0cWcycnE5QjFsMEhy?=
 =?utf-8?B?TzZZS2lXbTRRM2JrUmRMVXhsdk12dUtUS3VicUFNWlFneUxhaTZhN1k4UW5W?=
 =?utf-8?B?S2JDUTdLbTNJRHJjQ2ZEWlg4c1dZOHp2MXVNWEhMK0VVaWdiR1JqRlFkRkRh?=
 =?utf-8?B?eXBpTE15MXdjSHhsaUpkZGRxaHUrTURvQmd5dGpZYVlpdC9JRGx3RWpFWVdJ?=
 =?utf-8?B?QXlxZThUbk56UENLbWx0d0cwTlpYSE1FTU9GUUNHQjJmbzlyeHkyUHAweVl4?=
 =?utf-8?Q?hcT696?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R2tKcWhJQXQ2SVExYXc3KzFBRkZEOWtWazlXRi9NYUlQUFhacmVybmdlVFRi?=
 =?utf-8?B?d05LaUhjQzFqWVl5Um5PWkRpRjVlNFlsQUxVK0ZKTUpxZ0dnbWRMY0pKQ1RG?=
 =?utf-8?B?UW5UWWtMMWpwdUR5eWUxbzZ5cjNSKzYzVnBYSmpGYzEvMWhZc1h4SFVjYzlY?=
 =?utf-8?B?RnJnQ0lJZ3NJYURLbkgxNG1tb3I1NU90eTVyeUg5S0hSMnNLbnlhamp3aEZo?=
 =?utf-8?B?dGIxUlB0V2o2dXIvQjN2QUJiODd4bUY4d0FTSStJMENNWis0R0U5d3gweWdH?=
 =?utf-8?B?VklNRW9uNThxRUlDU091MXB3VXZxNXVDdXJGbThtdTkvSFRVWFl0MmVTcDd4?=
 =?utf-8?B?dE9BeGN2Wk1ySytyNC9zRlNzSzY1ZEtmclR1WE5CVFkreFdMMmNrMFJqL1Zr?=
 =?utf-8?B?cVppMHZ6MzBwUVBnOTkrYVJ0WlBpSDBiODFUUWlCTHNuVjBpcHVRRUxadkJD?=
 =?utf-8?B?eTY4dDVjWkxRSVZoVnhINUpyRlVoOVlkTHpLR1pyaFI4WHgvbTRsSThWUTcx?=
 =?utf-8?B?RjRGaWtwM0JiSzhOOUhTalNVOXJWMWE2UHIwWHdKTFk1YzBMZXdWRy9OUlFp?=
 =?utf-8?B?d0kwais2ckhBU3BkTDBHTkY1QmVxVWpzTW5wMmljakF6NFpHUVFxb2dKSmJE?=
 =?utf-8?B?bmE5S0tZOGc4OTB4TU1LSGluRFV5dkxsbzhTaW95amYyd01zRXNoVC92b29p?=
 =?utf-8?B?c2NCaUtHckdIL05VYVFiSWUvSmhVT0UvWldkb1ExV2picTM4ZDdFcVBaYjht?=
 =?utf-8?B?bXpiYmlTVys2WlZzQWRCMG9PSDgrWExOK2ttdnRaUGFPWGxrR1UydnNvVDZP?=
 =?utf-8?B?S2V3ZzRXVG9hR0FPWTJRT09vaFhGVDlnSHRrbWFSbDYzZ21nOGR6cVVLR2h0?=
 =?utf-8?B?SjNOWFM1bWhxL054cWxNK29ZcjJ6VkVjZWQ5MVRsczZ0TDZBWHV2dTlrTjRF?=
 =?utf-8?B?MGtTRnFzSWJhYzNlUTFwVGZxbGx0UFB1RDdKSnNwUWVpb2UxaW1jalAwUDJz?=
 =?utf-8?B?aGN4b3o5STZhTjRYcmkrL200aVJtL3RpRVhBTG53K0NiVllGZ1ZYeWI5dXR6?=
 =?utf-8?B?TGpxRGJTYXF5OG5teWhFeDdONkhEZHlFWC9PdHIzVEZZNHVGU08wMmFNMEt2?=
 =?utf-8?B?YVFQQ09CaTRiSzBRVmtxb2dISjY2VDBSaUUveEhDNnZwMk40ak5JSUVZTTVZ?=
 =?utf-8?B?bmFkYWsxQjB0bnU3bVdSd003ZDM4QjA1Y0VSQm9qN3NpQVQxNFhQcmt2MHNy?=
 =?utf-8?B?aC9sZnlxcTBqNS9WZXN5NXJLd25vMEVVdWZwZUgyL1gzVHBsTUwyOE4vVVJx?=
 =?utf-8?B?UHhjcDR3bm96T3dEQ2lFQUp1RXhLZ2hRNEsraDduUGVPR2hsUEZOTzZ6YzIz?=
 =?utf-8?B?THVjMEU3MUhEVlljTEV6STgyYkJpM2dkZFlqQ0F4OTB6YS9ySkZ6TjNqK29M?=
 =?utf-8?B?YllQdGtWQlJQVVM4UG5aWTRCcFlJSE94V25QeUpTMTIxL3J2UXBVKzJvU3dn?=
 =?utf-8?B?YkVncW16dFBESXlNR1I0U2NKSkgwYVZEc3JNa0M2TUhNWGUyaGxxZDhSZFRL?=
 =?utf-8?B?aUlLL2FLL3lFOFJpYnRFRlVLUG5McEtLaHNUT05WSTlGb05KS0kzNktUeHNp?=
 =?utf-8?B?dG1BdGRydzlRREkzZURJbXZSakRhbUtZOGRMM1VmbWFZMzZ2SVlJOVJJbzRi?=
 =?utf-8?B?cEtJRWFPL1orWFdORU9tTTRJejBsMGlLVVQwZkpQZUlaenFCL1dBYVlXY0Rw?=
 =?utf-8?B?bXE2bVdKTjhGbHZjNzBLVFgzbGxvL0dYckJrUXRKQmF5dDhvdkNXWEk4UVNo?=
 =?utf-8?B?ejNMRGdvSC9MbVg2Y3ZkOHphTDdxUEtNMXRkL0tCR2E1cU9GTVMrMjY3WXA0?=
 =?utf-8?B?UEtwSDJqakV0Y2VqbmVXdnJaeC90UmVzd2pxQUpEeUJHc0daZUhEc1U1WDVv?=
 =?utf-8?B?WjIzWlBNQTNFUzY1ZmdUQWF0ZEMySkdza1E2V09mTk5uTGd5K2RlTGtPcFAz?=
 =?utf-8?B?S3BmNmtlWEZaZlZNOWoyNmZIQlc5L2duSkN2TjZhejYralF5TVZOenZXNTdw?=
 =?utf-8?B?YjhKMk1GZnZwNlJZMXpYS1p1Y1F0TUs1UmFXSGo5elczU0hvcTVOdGJtbWRG?=
 =?utf-8?B?WTZFR0xkVjNwdW00alRFd2ZFU2dIaEdHSVp4SHBxSExiTVJjNkdKTkt1MW9L?=
 =?utf-8?B?OXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4AC9562B1F20A94284DBD511FEDBC449@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 814540da-d698-4ed6-5f26-08de104e83c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2025 03:04:13.6905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1/s2mqKj4kmjYQVhqbCzHaJiPB6WGgWvWtRRY8T0PKuJZ9ducn49Th1EniZYu8ipzocQo0kjmyv8HwPB9RtiCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB6894

T24gTW9uLCAyMDI1LTEwLTIwIGF0IDA5OjEzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBIaSBQZXRlciwNCj4gDQo+IFBsZWFzZSB0YWtlIGEgbG9vayBhdCBjb21taXQgYmI3
NjYzZGVjNjdiICgic2NzaTogdWZzOiBzeXNmczogTWFrZQ0KPiBISUQNCj4gYXR0cmlidXRlcyB2
aXNpYmxlIikuIFRoYXQgY29tbWl0IGhhcyBiZWVuIG1lcmdlZCBpbiB0aGUgdXBzdHJlYW0NCj4g
TGludXgNCj4ga2VybmVsIGR1cmluZyB0aGUgdjYuMTggbWVyZ2Ugd2luZG93LiBTZWUgYWxzbyB0
aGlzIHB1bGwgcmVxdWVzdCBmcm9tDQo+IE9jdG9iZXIgMTE6DQo+IA0KPiBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9saW51eC1zY3NpLzZlNzdlMzFhY2VlOTVlYmNiYTAzYzU0ZGMxYjM0MTczY2Jh
ZjgzMWUuY2FtZWxASGFuc2VuUGFydG5lcnNoaXAuY29tLw0KPiANCj4gVGhhbmtzLA0KPiANCj4g
QmFydC4NCj4gDQoNCkhpIEJhcnQsDQoNCkFwb2xvZ2llcywgSSBtaXNzZWQgdGhlIEhJRCBwYXRj
aC4gSG93ZXZlciwgdGhpcyBjaGFuZ2Ugd2lsbA0Kbm90IGFmZmVjdCBvbmx5IEhJRDsgb3RoZXIg
c3lzZnMgZ3JvdXBzLCBzdWNoIGFzDQp1ZnNfc3lzZnNfZGV2aWNlX2Rlc2NyaXB0b3JfZ3JvdXAs
IHNob3VsZCBhbHNvIGJlIHVwZGF0ZWQ/DQpXb3VsZCBpdCBiZSBiZXR0ZXIgdG8gZW5zdXJlIHRo
YXQgdWZzaGNkX2FzeW5jX3NjYW4gDQpjb21wbGV0ZXMgYmVmb3JlIGludm9raW5nIHVmc19zeXNm
c19hZGRfbm9kZXM/DQoNClRoYW5rcw0KUGV0ZXINCg==
