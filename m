Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF3145BE0
	for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 07:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709193087; cv=fail; b=BcDxUaRFc1KPLzY7Y5SIivVf6nJA47nkGIqPd3iZeP+/mnoI/EIKGzK3dTzoK+/fjSqGcr1V99Wl8/XAv0d5LFwhOZGXyYosCbf/gPyZSFffGcFfb62HAzDnJfkH5GT5aQIjLfyO5i8m5ZR5IBDT6DlL69EHU0PmyUIpr2D02AM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709193087; c=relaxed/simple;
	bh=WdCvl/9iQ1xM+bnmOn2DyMJbzUaUQ6P7ESl0lJtWqlI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QlnMqyhKrjOztr4x9fGQV1T24gYBb1dCngYWYFTSr6ufpj/GEuiSj0aGTY2HmWpTapdKRFAx/c4BRvXPd2gQkF9e9G7JfJEBZDVjrJogKmVxaMmHQvguguRFUiq2RhBS6WY8fY9D37Pg3Gy9VPNbMgXjSIcUJ6vwHrQvF0Az9eg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ijlK4sYe; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=ie77ZZxm; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ijlK4sYe";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="ie77ZZxm"
X-UUID: 4fed70aed6d711ee935d6952f98a51a9-20240229
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=WdCvl/9iQ1xM+bnmOn2DyMJbzUaUQ6P7ESl0lJtWqlI=;
	b=ijlK4sYegs4Mq/KwS+ONPaxjv9R0Ms6SEEU4G0iIWpSrNDTNoiJymDALoe6cHEYayrJYupw4jv/6gdKR8bBhaXZ6ZNILxHqfbBqzAHMtdC0AO2rIDRaCETIujpKQ3+K9oiRoScMVbRShL6dRfNd0HOW5wjLbzQHpO4d9iow56ic=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:5194e453-1ab1-413c-8657-ead3abe53bb9,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6f543d0,CLOUDID:be8cd88f-e2c0-40b0-a8fe-7c7e47299109,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 4fed70aed6d711ee935d6952f98a51a9-20240229
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1848668278; Thu, 29 Feb 2024 15:51:14 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N2.mediatek.inc (172.21.101.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 29 Feb 2024 15:51:12 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 29 Feb 2024 15:51:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0gWkKSwj9m1mEk1NkIg9muOllCadl22sWku/i9rjOBBu33Fy6HqDy+jBBIsaUJn7Bp5gA7fXg7QBnOdX41HdHupV/uAxu51X65Uq3umL6dfHB9h7dNDDRoSZpzZVUT21UlV39nfW2aBxsvrGqfh9jH9+apqwBGv2YU58k+Ap/LYXCBWYJoido+7XN4be1OUr2BGTgnBLWjufogQxsk3BpDMkwnAuwB6oLbJan6oTvxcmlndaVt8uaDpTY5wv2XGeZXo83klh5ZdB2Z/b9asFYjXfYS4V/HURO7Hg0kGbpsfI7NmZENO8/15byds9EUpxTzuh6r4UaLuXSkw/r0yxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WdCvl/9iQ1xM+bnmOn2DyMJbzUaUQ6P7ESl0lJtWqlI=;
 b=V8WBL5YTHmorNFCMKO7rRTpSmkQ+CQ0nPIEXnHufL3V6ncnFzoRgIV1sqspeFzrNuhOzylrxgWnKB7SkrBeQ/+slaDasNHByda2JBJnt4sPZpaPUJLq2AQ83vI5rgZwb31FaduOu4tEmLIUBb5MjN/BfXLcmjB/pHMit2KliEV4alfAQGg3yDWG5CKofP9j5gg2GPcbRcl5aVRYNSNQLrumelyjUwR+BiQq8p2XUaZrqGoTSVJmvqWNUlGJO+dQS8MfIN16Gd1mpPntvLLONahcqh3zuR0EWB++Sd2cX1YJlCjil8gXrntvj/7YNRTVXKHGqYMhRWMQ4+jYR0KqEgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WdCvl/9iQ1xM+bnmOn2DyMJbzUaUQ6P7ESl0lJtWqlI=;
 b=ie77ZZxmF2UaUu478NF+8Ghj/vj6aFIpwtLTLpDewIDPnmEcofwjElgGlTJGZGSYK9YGHCxOKAcFx1kqLeA+Xk7u/NZdLTei2O40fDPG8Ate+DAK/ZoDafWB+hAhNOynzwGBlHN9fdl0YyFMbGXbTQOolrexfd8Oz2W2/WBsld0=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB7413.apcprd03.prod.outlook.com (2603:1096:101:140::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.41; Thu, 29 Feb
 2024 07:51:10 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::7416:94cd:75d9:12bb]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::7416:94cd:75d9:12bb%3]) with mapi id 15.20.7316.037; Thu, 29 Feb 2024
 07:51:10 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "quic_rampraka@quicinc.com"
	<quic_rampraka@quicinc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
	"quic_sartgarg@quicinc.com" <quic_sartgarg@quicinc.com>,
	"quic_bhaskarv@quicinc.com" <quic_bhaskarv@quicinc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"quic_narepall@quicinc.com" <quic_narepall@quicinc.com>,
	"quic_pragalla@quicinc.com" <quic_pragalla@quicinc.com>,
	"quic_cang@quicinc.com" <quic_cang@quicinc.com>
Subject: Re: [PATCH 1/1] Revert "scsi: ufs: core: Only suspend clock scaling
 if scaling down"
Thread-Topic: [PATCH 1/1] Revert "scsi: ufs: core: Only suspend clock scaling
 if scaling down"
Thread-Index: AQHaagfdnu/7dWEB3EK21x4WVKWgnrEg9A2A
Date: Thu, 29 Feb 2024 07:51:10 +0000
Message-ID: <a585c5a82fdb36b543d48568d0c5ae1265642f26.camel@mediatek.com>
References: <20240228053421.19700-1-quic_rampraka@quicinc.com>
In-Reply-To: <20240228053421.19700-1-quic_rampraka@quicinc.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB7413:EE_
x-ms-office365-filtering-correlation-id: ca2252e3-4419-44c3-74da-08dc38fb31d1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XSHbB9L9WJgYIRmLuAdVE6daL0ZONXCbe+wfngqHckupIp/dg5r1W+oSLZGF+ypyS5UoSuEwYOOkcBM+CmVjw9yxLHbuGKEoFj1koIoPiYkEfneZZ8Ti84RdbhoIjGmtoNZBW4XszYmWEHGhmpxyBTREtD9r1QQXNdQ2nBdw8JFUzychjKO7rdiKVgnmaFK5UKshka7IMdpj0SJan6X4RfG7TpH9HVKhKxU+WZxdhlPZxYqoh7Xz/OCrZIDAk2kzqZARw7t6QOMz9QPgV+i6bt3BPAtSzQb31ow7ik/5n6FVFumW7Bn1bHRvg5y3nBLoK9O7hCrrKe4SkrMcrSv0IIp3rMJXcWNLcA0+yqe/DR4Y8OvxA5P+UUnjoaQKgVHf1zOXXhDcGmsEX9W8FsWN3oSw82En+UG2Ya2zvbkmHiHQgKOM+Ohx4VeYgBag5+ESRzZnkLsFQcPX+GuME389sn/tegVLzuA6ECauqMto3WKiK0DTFp0peSH0LqlL4bXXKvtCjIccb4y+U5MBCjRcDWrJRQjuVWKD9t+oQwwX4BDdCwajtYq9iUJouPbRFg9PYfSN7YT3cvZ3Slq8xsQUllZpDnaYox2QWNl89v+fmzuDrFf5sBnqoepeQMVYERxeV5hDAlX/MwXHN4RdZLt44/ipJGqW/pVzW4XkjH+c4sAGLlTN4cMP2dB8Oo//I9f2RNzEj0kYHt6FcV/LTZahWBIXHnarEjccD3NZ0VIEXIY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OWNXdVV3K2VESFljZ0o0V3FwcUJTYWtjRjBONEFmNE5zclQxYjJGdkdiR20v?=
 =?utf-8?B?eWpxd2VZcXNFQ3MwZUVkU1BvcUZyenVDY2FvdjRIQXBOT2xORCtHb2Z5NWE3?=
 =?utf-8?B?RkM3U0l5d1kxaUpYNGdDL21ROVlMcGtsOTNlajA3b0FhNkhub2p3NGdPV1lp?=
 =?utf-8?B?SnI3TVlIMmF3OFNnQ1BQQXlWT1FUeHJPOWhqWnNGUmZuTDdQakpvdWVZcnFy?=
 =?utf-8?B?ckRrOHgrck43RDFVdlBwTFozQjhzVWc1MFhsa2YydmdkeS9sSTJEN0ZBSlQ5?=
 =?utf-8?B?K1pjcTB5eEYvTU5HMnp3NzROSzUrL1VZanpFaU1QTEhreUk2eE54enkvSzNZ?=
 =?utf-8?B?am43VmZ3bXRUejNJVHI2Y0pSU213bzhaZWRmWHNLa3NDM2w2VWdPL0psYUto?=
 =?utf-8?B?ZEdCaUd0YWEvMjBrNktQdlJZUTdZZUhsWU44aS9yV2JXcTZGbExFekdUaFhm?=
 =?utf-8?B?TW1PWjdqOXVOeWFtcmVYbWEyUkQzakdCSEdLazhKZCtCdWVRWHJESUFXSVBa?=
 =?utf-8?B?SGNSODRYTzlmSGtJcFlpSjlKMzk0RDYvL1BjeEszazNiYTlQVFRqdU1YUGVC?=
 =?utf-8?B?WUVtc1labXc1NTVEdU1BK2JVT2NKZEZEWU1rdHNXMml0ZlVEL0FzRXRuWm9Q?=
 =?utf-8?B?ZVY2dHRBOTcvbXg5MERic3hzWWNLb0RIR09CMGh1Z0ZORmFYTGp4OThveUFs?=
 =?utf-8?B?dGM2MmJMQWhFUk0yS2QvaHVxQU5pRjVPaEpUSU1iSXZXSHNqbUFDV3NoKzM5?=
 =?utf-8?B?UWtjRWxSc0Mrd1lGMkVVNVM5SlZqWTdnRmZsOGEvOXhUM0tGMFVwS0pmdGlm?=
 =?utf-8?B?WDYxdnFBMjZwRDZ3TlhFMmMrYTVmMXc1NEZSZWthTEZjQXhUR2JiTHlObTZz?=
 =?utf-8?B?UjBsTVg2VUZXemd1Mkx6L0xMMDAzbUtvcEJrbjkxRGRTS3g4WDFXd2x4TlF4?=
 =?utf-8?B?SGpTQmx4a3llbnFuaEJRSlQzYU9KeG9nTEoySEFvQ1MvWDNHNko2NHFRTm5o?=
 =?utf-8?B?d2o5ZU9ualQ1VzhIbmI4S2hHNUdNVGxQYTY0a1pMWC9ZS0VweEVTUTgyT05L?=
 =?utf-8?B?M0V0TTZJVDRHOVIyNjFNOVlqeXAyakMwQjFOTTJCbThxWHk5ZWRrMnd2YlF0?=
 =?utf-8?B?alZKTVU5OExBM1B2ZXBzbElWWjY2REpJMnl1RWxqeitmRnYzM2xaM0t4RHZt?=
 =?utf-8?B?TVFueDhuQzlIWERHNHlEUTBEWnY4ejNzSDFmUVgrVnhKMUJKNE84a1Z3ckRZ?=
 =?utf-8?B?Y2F0MjEwMmNUUVdqTWZZQ0JCZ252WGhWVWF3K2hPWktKb1IrZnVWUW5kOStF?=
 =?utf-8?B?UjU4VGIzRUNQejZMMEtlaHNiT2k1N0RlcVF5RFBZZTY4eXk0SGlaWFBpTHc5?=
 =?utf-8?B?RkxLRm1sZEVhTGlKRXJtbTZ0c1hDekllTGtjdHJqTHdaZlhaZXhacVN4Umhv?=
 =?utf-8?B?YTJBdVdYaGZQdUNnZUVhb0FZV2I5VmNmSCtmejVBRXh2NVBxbk81SGdndUtx?=
 =?utf-8?B?aTNtMFlaWGlReVI5UFM4dmNQZGhZc2xzeS90b0Z4dXpWV2xGU2prd1ZSTEto?=
 =?utf-8?B?V3oyVHNDUGJVZVhaWGZUYmpuWFc2TENac2lyZnNjbWkzaHlZWXhVT0VtazZS?=
 =?utf-8?B?SnJ6aGtpQWR5UkwySXkwb3Nhb29jYmpNcmJiQ2cxa1ZsL2VEblQyNGNsaHUz?=
 =?utf-8?B?aCtGM1pQK1M2M0F2c0VMNUdVeXlXbmwwVTBHZXNpRGlROFprbUkyK1NaWGgw?=
 =?utf-8?B?QzhWUWZ6aDBwRFZJeTdlVjRCRFgweU54THk1VkxxZlRPQ1d0TmJaUGdPV1VW?=
 =?utf-8?B?Z1pScWdOcnlVK1kzaGxDT0VSa2NPYXVlcFY3bUJPaXVpc2lkSzFJbG5qbmNj?=
 =?utf-8?B?MkIzbkNrT3IwRWlxSmhPWWFXWVlQVzZVR0Z3N0VjZnI1ckRHVHpoaFFZOFJm?=
 =?utf-8?B?aDBGcFYrVkxUbnNQYW9xMldnaHB2d2lyNHgxUlZicGpVeW15dnQ3bE9IYnlu?=
 =?utf-8?B?eGIycFp2eHZLaHN4OVhwODFOMHdCRWp5YWh6VE5kTk9QWkdmWEdza0d2aDlS?=
 =?utf-8?B?LzNzSDV2UGNLTURlRlFPeVZTL1g1V2JiZklDRTJQaWppM1JQcnlXNmVMcFVz?=
 =?utf-8?B?RCttc2w0akEwRGlMVm5ZS1lscXk5aUFEUEhqOWNZRDYxdXlFK1d3cU4zTm91?=
 =?utf-8?B?UWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FA9F2CE6BD9BB147B028F7F96DC1512B@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca2252e3-4419-44c3-74da-08dc38fb31d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Feb 2024 07:51:10.2938
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EWcu2pq8fTSDOR5HjK8cXruXxD1xdhkOomjbk63zkJF9MbqLps9r6i5Y7KA/I4mHK1yGMzAv/M0ZCAAoDkcxLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB7413
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--17.018000-8.000000
X-TMASE-MatchedRID: Q8pJWSpPf0PUL3YCMmnG4reiCVGXv/W5jLOy13Cgb4/n0eNPmPPe5KWz
	WoIRiV9DM/Se/q/gEyf5MiS7M8c1eGmXMi7Ntyo2pFf2dGv7wxsrHkgIan9a0SO+wFOLVym1lUN
	mxPSthYIhXi7xgp14qwG2ORx9EyapKc+6Aaw3enk0JY9d6s3vaRkqnRJng/51w01zN1c0miKZCs
	VMpT1jV16FB/q0mbf0EXZsEx4MC5f4lfGKH6YdS0hEDfw/93BuLqhZKRR3/85h7WbOnt2TB/Jsg
	56Y/kw9IXuvUou2O0ILt8T2ka0+Exoeu+OCiwrSngIgpj8eDcDBa6VG2+9jFNQdB5NUNSsi1GcR
	AJRT6POOhzOa6g8KrUWwVcO4iiCNpQGMymt9TMDrM5uvOteIqHxxTsbtE7kkcPnJcQg1xU0=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--17.018000-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	10CFA54C1C3411760D93ACC3E48BE679E912B6B73099FB1DF4DBB15C28B1708C2000:8
X-MTK: N

T24gV2VkLCAyMDI0LTAyLTI4IGF0IDExOjA0ICswNTMwLCBSYW0gUHJha2FzaCBHdXB0YSB3cm90
ZToNCj4gIAkgDQo+IEV4dGVybmFsIGVtYWlsIDogUGxlYXNlIGRvIG5vdCBjbGljayBsaW5rcyBv
ciBvcGVuIGF0dGFjaG1lbnRzIHVudGlsDQo+IHlvdSBoYXZlIHZlcmlmaWVkIHRoZSBzZW5kZXIg
b3IgdGhlIGNvbnRlbnQuDQo+ICBUaGlzIHJldmVydHMgY29tbWl0IDFkOTY5NzMxYjg3ZjEyMjEw
OGM1MGE2NGFjZmRiYWE2MzQ4NjI5NmUuDQo+IEFwcHJveCAyOCUgcmFuZG9tIHBlcmYgSU8gZGVn
cmFkYXRpb24gaXMgb2JzZXJ2ZWQgYnkgc3VzcGVuZGluZyBjbGsNCj4gc2NhbGluZyBvbmx5IHdo
ZW4gY2xrcyBhcmUgc2NhbGVkIGRvd24uIENvbmNlcm4gZm9yIG9yaWdpbmFsIGZpeCB3YXMNCj4g
cG93ZXIgY29uc3VtcHRpb24sIHdoaWNoIGlzIGFscmVhZHkgdGFrZW4gY2FyZSBieSBjbGsgZ2F0
aW5nIGJ5DQo+IHB1dHRpbmcNCj4gdGhlIGxpbmsgaW50byBoaWJlcm44IHN0YXRlLg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogUmFtIFByYWthc2ggR3VwdGEgPHF1aWNfcmFtcHJha2FAcXVpY2luYy5j
b20+DQo+IC0tLQ0KPiAgZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyB8IDIgKy0NCj4gIDEgZmls
ZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5j
DQo+IGluZGV4IGM0MTY4MjY3NjJlOS4uZjZiZTE4ZGIwMzFjIDEwMDY0NA0KPiAtLS0gYS9kcml2
ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ICsrKyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMN
Cj4gQEAgLTE1ODYsNyArMTU4Niw3IEBAIHN0YXRpYyBpbnQgdWZzaGNkX2RldmZyZXFfdGFyZ2V0
KHN0cnVjdCBkZXZpY2UNCj4gKmRldiwNCj4gIAkJa3RpbWVfdG9fdXMoa3RpbWVfc3ViKGt0aW1l
X2dldCgpLCBzdGFydCkpLCByZXQpOw0KPiAgDQo+ICBvdXQ6DQo+IC0JaWYgKHNjaGVkX2Nsa19z
Y2FsaW5nX3N1c3BlbmRfd29yayAmJiAhc2NhbGVfdXApDQo+ICsJaWYgKHNjaGVkX2Nsa19zY2Fs
aW5nX3N1c3BlbmRfd29yaykNCj4gIAkJcXVldWVfd29yayhoYmEtPmNsa19zY2FsaW5nLndvcmtx
LA0KPiAgCQkJICAgJmhiYS0+Y2xrX3NjYWxpbmcuc3VzcGVuZF93b3JrKTsNCj4gIA0KPiAtLSAN
Cj4gMi4xNy4xDQoNCkhpIFJhbSwNCg0KSXQgaXMgbG9naWMgd3JvbmcgdG8ga2VlcCBoaWdoIGdl
YXIgd2hlbiBubyByZWFkL3dyaXRlIHRyYWZmaWMuDQpFdmVuIGhpZ2ggZ2VhciB0dXJuIG9mZiBj
bG9jayBhbmQgZW50ZXIgaGliZXJuYXRlLCB0aGVyZSBzdGlsbCBoYXZlDQpvdGhlciBwb3dlciBj
b25zdW1lIGhhcmRod2FyZSB0byBrZWVwIElPIGluIGhpZ2ggZ2VhciwgZXguIENQVSBsYXRlbmN5
LA0KQ1BVIHBvd2VyLg0KDQpCZXNpZGVzLCBjbG9jayBzY2FsaW5nIGlzIGRlc2lnbmVkIGZvciBw
b3dlciBjb25jZXJuLCBub3QgZm9yDQpwZXJmb3JtYW5jZS4gSWYgeW91IHdhbnQgdG8ga2VlcCBo
aWdoIHBlcmZvcm1hbmNlLCB5b3UgY2FuIGp1c3QgdHVybg0Kb2ZmIGNsb2NrIHNjYWxpbmcgYW5k
IGtlZXAgaW4gaGlnaGVzdCBnZWFyLg0KDQpGaW5hbGx5LCBtZWRpYXRlayBkb3Nlbid0IHN1ZmZl
ciBwZXJmb3JtYW5jZSBkcm9wIHdpdGggdGhpcyBwYXRjaC4NCkNvdWxkIHlvdSBoZWxwIGxpc3Qg
dGhlIHRlc3QgcHJvY2VkdXJlIGFuZCBwZXJmb3JtYW5jZSBkcm9wIGRhdGEgbW9yZQ0KZGV0YWls
PyBJIGFtIGN1cmlvdXMgdGhhdCBpbiB3aGF0IHNjZW5hcmlvIHlvdXIgcmFuZG9tIGRyb3AgMjgl
Lg0KQW5kIEkgdGhpbmsgeW91ciBkdmZzIHBhcmFtZXRlciBjb3VsZCBiZSB0aGUgZHJvcCByZWFz
b24uIA0KDQpUaGFua3MNClBldGVyDQoNCg0KIA0KDQoNCg0K
