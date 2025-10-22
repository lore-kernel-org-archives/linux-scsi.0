Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225E2322A30
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2025 12:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761136773; cv=fail; b=R/OHIKChVCVB9EllzQzJ6kW2IhmwQrrEYCfYJ31lSvkvvQaIdxwmdlkLP7+t7SJPXz1MXT9judvdckAscXrG2BFm/fynhqShCT7CENjSS6Nbi5v6olFJyJChlbsZiR00/W4w+kVKj1AHq/BIR/hooIg+N8Vm5/rVgFIDXqoJinU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761136773; c=relaxed/simple;
	bh=Wq0qt30ImeeZ/gChsrWpw6Hty/i97ncLJT6LEZxEcnY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ke3NzYITWAryBkFx9fbWR9OJOIsbZcFZfVtflhf7cSiWHyXEJ2XEIZnJhWekSjeakejk5MsfwV3gATsZXyZsrV2lJnfXpODzviGOyBuGC40RIYtn0FE6yvXAjcXPN7Aio3KqW5RRImOc4/H4fWAJPwURix3wAWlhkwDoDh0oDpo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=J+lImPX+; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Ek7RHjo6; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="J+lImPX+";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Ek7RHjo6"
X-UUID: 267e3702af4411f0ae1e63ff8927bad3-20251022
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Wq0qt30ImeeZ/gChsrWpw6Hty/i97ncLJT6LEZxEcnY=;
	b=J+lImPX+LXRg7ZV6kw+IjuWwq+pgq2ZFLDVWuU7ksPG+l58kqzByGwcFgOGaNuPp7Y+SOxEwQlrpHXVM/GM8x5JzA4DvqKoEm/L2NKIAxvOlL7iPC+wMLSgizLKlKAQomzlfLBaLxtHCVrE+aYQ39EOyHvIFWz6reGhhbVO1Am4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:1e65632b-af3b-44fa-aa88-6fc30472de8a,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:c64becf0-31a8-43f5-8f31-9f9994fcc06e,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 267e3702af4411f0ae1e63ff8927bad3-20251022
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1573723350; Wed, 22 Oct 2025 20:39:28 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 22 Oct 2025 20:39:26 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Wed, 22 Oct 2025 20:39:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WdEMWG72+msQHFzop4kWdnAbHFkFVCHM0psTVT4CJGH8yF+Ej5Bt1M1IaieVeW1QPcxSCFG1wX3OXJDq3WQU6dcvVCDnEKA5zXBQmAeghc+tKE97BjP+OLweuweRUnrHIdGJlxM9MsFty4Sv355hRctTmHcJjt/38zmv951Nu2sqdfEiUP1V14y8Fx8kC66HkAHuI9+i60Wi2QL//COEzr3qbswzNglFEUyjKlVdkfoRE2qaR9PZoi82GshZ8I0pHl3ZvkOGWtR3fBcXZTrNXBrkg15U5ZrfeIGxAPG0kXUtK9p9otCde/MwMRaU0rdueOrOnRzq24St8R6uHAKJyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wq0qt30ImeeZ/gChsrWpw6Hty/i97ncLJT6LEZxEcnY=;
 b=sM4zkWTq05KePmJFS/oQ9IapcztfSjeaLH48+2HWTf/pZZtXlbtvUFYRGeYxkL/KQaZ1tAz25JKtM++aidNBImCmmv/x6KXI3ybiH4XHgssPz2+xc7O1F0w7m4wkc0oBMGUuome6Dx1S/2SLwr7j5eLQ+g8C6VWcLk5jRvRMZ4xFBYlv/D49W7dYztJNyxZfFinrmNV5VDAAU8HpUVfjA6Z3YoaUpUMQfukPqR3VPU1BV496HcAXdIIwoSDtzHMSwdp0LobotApdfFPTeEkt4YQDtTT3tnQwRXLVvaLVzX06sXWnXLKwGKCxZLUDxFEDObtu4hUx8QkRLzXFaFhfeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wq0qt30ImeeZ/gChsrWpw6Hty/i97ncLJT6LEZxEcnY=;
 b=Ek7RHjo6KePBYOcC+xJPom+CT4zkk0ulxvgnMSsBcA9t51H6j48FNfON14GgxgvCCapG9dJtv6ZldJvDw/SWtb3V9k9jJ6Xrby973zt24Xi5W3bYm4jmN1Lgu7E9/OqQEaC0PU6e7b2ReK6V05cQbcyDPL0oh5G0jKsj31pcjLs=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB8162.apcprd03.prod.outlook.com (2603:1096:820:ff::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 12:39:25 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 12:39:24 +0000
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
Thread-Index: AQHcPUVzmnY3uUn2AU60C/91apcezLTGBUiAgACFlICABBZ7gIAAnS0AgAC1soCAAMhMAIABaryA
Date: Wed, 22 Oct 2025 12:39:24 +0000
Message-ID: <1a96e934dd59dcc8016d69b84d25cb6f9f4f3823.camel@mediatek.com>
References: <20251014200118.3390839-1-bvanassche@acm.org>
	 <20251014200118.3390839-2-bvanassche@acm.org>
	 <22dd7d580444be92d0029694468cdddf1ac98f13.camel@mediatek.com>
	 <569fcd05-4d77-468a-bc8d-c86d0a5dfc8c@acm.org>
	 <bc0ac3e9f44bb3c6e0f06efd7372b21535ac07a9.camel@mediatek.com>
	 <62ec19d2-f7ee-445d-be97-098acc1f390b@acm.org>
	 <c47fcb9200d4e969b8200a8c2cb4a4af35883047.camel@mediatek.com>
	 <c80b73bc-b52a-4735-ba04-c1e7f6a353e0@acm.org>
In-Reply-To: <c80b73bc-b52a-4735-ba04-c1e7f6a353e0@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB8162:EE_
x-ms-office365-filtering-correlation-id: 8394db73-8231-4441-d701-08de1168083e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?WFFkdEovNUtycDl1K3djTjFnaGc2N1JFc0NKci9oUVV0ZWNVOEVIdkR1YnBh?=
 =?utf-8?B?Znk4WnZrcnJSbUFwbGk2R1RNRDJpSGFnODRhK2VuMDdXakNzMEJTRkFqTDdQ?=
 =?utf-8?B?ZndSU1Y5Z0VkSHZ3UnFEOEF5bTU5ZHdNMGJ4MDc0VUZVZm9KL3FMS2ZSbTV1?=
 =?utf-8?B?V2pHZE1vK0JERWVjK3V5Z1pTU2J0a0Y0Rkt3ZDFPdUdVVWxZWDl1bnJVdXpk?=
 =?utf-8?B?MDhDK0phWFgvZktEeEhiNzl1bXVkV0g4ejZHTEVCRDJiY1VhNndHZmRhbTNV?=
 =?utf-8?B?NlFMZFNPQ3hYaDFpNnBIRUt2T2J6WUEreVdjcTFvMmsvbVBPZzFyVWtmTDFq?=
 =?utf-8?B?d3JwWVU1dGJ1YjBIUkR0M2FOZkxGdmo1RDdsOTRwWHJ3bFN1ZGZoMm1wRC9w?=
 =?utf-8?B?Ni9tcUE3S3l1UkdvRmVCaGpjbHYzYjRicE9OWlNQMHV1ZEtRMnBUczVmRy9J?=
 =?utf-8?B?OEY1ZjFjKzVyWHNEVlNKMHFmakhhc0hsNE1pdm90cVpCeWU5RkpIUVRqbmZP?=
 =?utf-8?B?TDdsdm1FM0lZUEpvS2R4LzRJbkRnUE5JeFluT1Flc0dmZkNqOFZ2Qk9QSEV0?=
 =?utf-8?B?UExGeTU1MExRVTNxZmRqSE5pMS9NeTVrbmpuWWYvMzFVOFdDY3FiL0RhamxO?=
 =?utf-8?B?MG1Da205KzdRK0NtVStZRnViMGpnWnZiZllEcG9MUTdUR05zelY3Q2RQaHFI?=
 =?utf-8?B?RkdGSkJNRXMxUXZEQlFKQ1VqRDZ0NmEvdGlybTlmd080dFVEUmFpakNpQm9E?=
 =?utf-8?B?UVBRbFR0QWdidlNWeVhsTGZMKy9qTTdZSW9qWitLWWlGTnRST241bnBNM0Nm?=
 =?utf-8?B?K1R2a2traE9UNnJvRXNnU1VWZ3lhSkdJaE1JOTBqVHdvRTN4Y1V6aWdtd2Fy?=
 =?utf-8?B?U2FTT1pGblVrY1dvSzEwK1Axakkrcm5wak1LcTZZVkpOc25PUHl1UTVXMmVn?=
 =?utf-8?B?ak1ibTZZcFUwTGZpNXppS1JwL0QxZVA5bStUWkZjZDhFT2ZLZDRjRER2K2JI?=
 =?utf-8?B?eFZidjErdDVpbEZHcFUxeE0wUC9hT2lOYmF4MzhCU0d5WWZuek40UG9JdUtL?=
 =?utf-8?B?eTdoVkdaSnZiazh5ZzFUaGM1Tm9uOXZWdnA3V0JCeGkzYTZvckliTlJQYUhF?=
 =?utf-8?B?QmFBUmlESGFoQ0ZIcFE4WWxoZStYdWNaZXFCM0lTaGtrWkJMamJKeXVKU3o3?=
 =?utf-8?B?cC9HdHlhTW45R05HejZPR2hQcXZISUp3ZHlZVzB5U0t5aTBBRzZoMzY5WmVk?=
 =?utf-8?B?RUxrM2R1R1RZS08yem96RW95S2VzaHV4bGl2cmczK0s2UlhKTFMwTm9VWU9E?=
 =?utf-8?B?UTRvVkpYVm03NTl3bjBnc2puM21oRFB1TUdnMzZneDdiZGF3akNKaW4wK1BI?=
 =?utf-8?B?eVFENUxDeUZrUXlDcDk2dTkrWFByS3hYekUrZXN5UnAxTnZ0b2VwaHdzenlx?=
 =?utf-8?B?VDNMSElOeWRMRGtGbzdmS1pkbVk0em81UitXYmFRZ1U0V3hMcXltQWlEMU93?=
 =?utf-8?B?STI3bUJzaEovVCtpWENYeTVjbG5qc2xrZ1RrQXkrL1IzKzlXaC9DU0pTZ0tK?=
 =?utf-8?B?Y09EV01LZ3F0OXJJQW8vOUphamRtWHNFTk1BRzZCNnhNenpBZmlPaSs5YW8x?=
 =?utf-8?B?NGFTd1ZKT0hIVU5INVBueExrdDlyQlNuVVFZOUlnOUJUZGt3K0gwNXhqWVV3?=
 =?utf-8?B?ZTlYamNsdzVqZVhKOHdLWmFPdTExS2hIY2l2TXo1cjRnUWdQRHY3TC9ZZHBG?=
 =?utf-8?B?ZVdjblRZV2tSUjA1Y2dBcnhrcVRhQUpSUHJ6SjBBT3ZSaEIyTCtrd2JDRzh3?=
 =?utf-8?B?c29BUHhVYk43TlV5all6OERYalQ1eGxUaFBnRWVBSWUrN3hMMXNiS3gweHJV?=
 =?utf-8?B?bFgzV1RsNFFoejdlTEp6aGtsV3owRkFyY3BDamtTRUw2aGJpWDlvVTJSV1JQ?=
 =?utf-8?B?TzdKcEVlZ0g5dDl0Y1pZZ3g5eWZjZG4zdmV1UEZ2N0ZreHI3S1lDeWNYOEQ4?=
 =?utf-8?B?NUdFYkRxeUJBclRHd3IwSWw0RUd5ZUhjYVJaT2xLNWxXN1hpenF1YUxWckEy?=
 =?utf-8?Q?cA+RVv?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QytJeWlHWHpDTE1nZVJLS3BLVFMzY05QWGp4bTZZYnlCMXJBTTFMRHhyUnZP?=
 =?utf-8?B?a1B5UlU5dWNNQ0c0K3RuRFpBZ1VzVU9TcXU5K2paOWNDZU04M2xzREVSbloy?=
 =?utf-8?B?VXkwd2dOc3p5VmgxTiszanZSZUVmUnB3SnFWdStPOXRLcURoUlp3ckFiUkxD?=
 =?utf-8?B?SXREeExVWHJ4dDNUaXgvbmp3SXdUdVlnaUVCaVM2RkhBdjQwYlMvZU52bFV4?=
 =?utf-8?B?alNjM0UyaDEzRmFwSm45Mk8rcGZiL2FOS2ZQa2RtV1V5cE5GYngweW5uNXNT?=
 =?utf-8?B?MWVWSVgybEpTa0VUTzk5YTJIMmZtTXNFU3NWV3IySkgwZHdSVE4zSDFUOGNx?=
 =?utf-8?B?UzhHYXg5Z1dKR1NwckVaaEhBazZIQ0VBQkJYL21BMzhMMzRudk5naDhOejRh?=
 =?utf-8?B?WFpQRW1uRVBZRTM1b21RRkU1RFduYW9MYktOWHhVWGNiN2xkQlU3V0xJaUhv?=
 =?utf-8?B?clVMZjk2Mit0OGFCSjRHcDlwOHo0N0ljSlFmRVlZV2YweTJCTzhlK1Q2WHl3?=
 =?utf-8?B?azhWcmMyZTdxa3J0dUZjUldBZ083Y1I4MXBCQUJsM2FRc2hpQ2pDazJ5UXNp?=
 =?utf-8?B?cUo3MVkwdlduY0w0WktEbW1nbHFRWjNiUXpiWmF3bXVON3d0aFpFV0xjSnpT?=
 =?utf-8?B?ZW01RE1DUmR5RWI0RHdpbmVWV3NlZmJ5SW11OTYxSGdLYVRzeXl1YmFDaXA3?=
 =?utf-8?B?S3ZIM2p2WU10Uk4zWGVmYmRMMzd4YWl4bW1yVFFvNS9uS3h3OHVTYUJ6UmxO?=
 =?utf-8?B?dW1WemdPZUxqM2E4eHkyU21rbFBTUDRjMVhMUzhUc1AvYTJqcUtIYlRCZXEr?=
 =?utf-8?B?cTNNYXYwdEtCVktKdm9HWGd6YzRzQ1ZmOUdyTHhqWFVacGxJamFvZDZZL0Nv?=
 =?utf-8?B?ZUdMbzR1cnBHWlJwMmJlQU9uTVJWalVEU3JuQzRhaFl1cFhKMkFLSzAreGkr?=
 =?utf-8?B?ZlF5NVRMZ2I2d2t1RGY1U2dEcU9oY0tjWkswTDhFQXJvaE9hTVBVZnBvK3ho?=
 =?utf-8?B?ZWQ0YzdTeFd3SGxpcVl0eitVZzAzMUJpVTZ3UWJFQVhaK2xNMWJScVlwV28y?=
 =?utf-8?B?WHBkVFhrcWE2RXJMNjRiSnJJZmlUQm11RGxtQVo0Z1QzSlBrWURUZWRjYlEw?=
 =?utf-8?B?KzE0dzA4dzFrNkZyRTJxdG40cEsyT3BHQ2E3bDhSUUI5ZHR4ZFM3VU5KZE5r?=
 =?utf-8?B?MkhGZ1NJMjhla1RNUTU5WHVBSHdvc2RLZ0trckN5YS9yaGk1VllNR0JMYWFU?=
 =?utf-8?B?YnFnK1IwSU5pTTRRQXNOc2E3ejEybFpvVXRhUkppNTBEdy9SUTRDVHAvQ3B0?=
 =?utf-8?B?Wjg5elEwYTI4TXYxQnRnVnI5QnVvRWcwQTRaV3V6ZkJmUDlKL21hajl3TjMy?=
 =?utf-8?B?YThaT3E1WURPL3NmZFBaRHU3WkxvNVpJcUFxYk5wME9obURZR3MvT1dEbTBI?=
 =?utf-8?B?UFNndFdvcnVzdnR2YWhmVTF6b3NsUmtEakRkQXFBNVZEMVprd2M5MmJrcU1W?=
 =?utf-8?B?ZG9Fa0k2V1crNk1jTktmVXhvSW1lell3YWtHaWpKdi91aEo1WkwwVXFCVTJ1?=
 =?utf-8?B?MEhzUEhGYmJHYnAraDdsRllwN3NqTFF6cGtWOFQwSER3cm5iVDVoZURadytj?=
 =?utf-8?B?N3YwN0ZYOXBuQ2piNUtkRXYzRWkrUHBYaUhnTkRCbzRPRjlqQjdEaXFYSVRQ?=
 =?utf-8?B?K09aZlVtVWtxY25SWFl5Q05JOS9MU3hXQWVybWphMXBCbllZdytkL3ZraDFO?=
 =?utf-8?B?SHpQelRrLzRvaTNsaUV2Y242TmdxYUtrMXBIL3VkWXdhamgrUmhwOWEwZ09L?=
 =?utf-8?B?ckR3YWpjM3gzZGlrVWx2VU5uZXJiT2dncERsMWlORE0vN0JSMElDVDUwV3E3?=
 =?utf-8?B?SFY3QmV5SWZuTmRaWTh6dkp6cVN1eDN0a3pVSlpML05ZanduL3VzUFF4N0RN?=
 =?utf-8?B?WCtydFg0YUpMSTljcVZvaEFIMEJNaFVGUDMyVkM1WEJLZld3cEtyUVVJSitB?=
 =?utf-8?B?b054M0cyVTR5NHR3WVB5SzRKTkFlM04yRmRnR0RWZFd0RURhb21xNzR3dWJs?=
 =?utf-8?B?YkpNRVlyMVJVaDBkeE54d0lCYUo5dDRFQkVyTXdmUFUvT0NBTlFzTm9uQ1p4?=
 =?utf-8?B?WVBYbVcyNzJBbEM2S200bCs1Y2tzcjlValVzUXFUZWc4V2dESGFzNU5zbyt4?=
 =?utf-8?B?aGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1AF08C6CF9E1F5428750D8349DF02A26@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8394db73-8231-4441-d701-08de1168083e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2025 12:39:24.5767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /EFj00/Din+0wDtDkini1zKt15QyfgagyqpHyNUgRbtE+exQDHfvj/uyFL/NIY6L4/SofN8z9JnDukvmOjgKyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB8162

T24gVHVlLCAyMDI1LTEwLTIxIGF0IDA4OjAxIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRo
ZSBjb250ZW50Lg0KPiANCj4gDQo+IE9uIDEwLzIwLzI1IDg6MDQgUE0sIFBldGVyIFdhbmcgKOeO
i+S/oeWPiykgd3JvdGU6DQo+ID4gT24gTW9uLCAyMDI1LTEwLTIwIGF0IDA5OjEzIC0wNzAwLCBC
YXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+ID4gQXBvbG9naWVzLCBJIG1pc3NlZCB0aGUgSElEIHBh
dGNoLiBIb3dldmVyLCB0aGlzIGNoYW5nZSB3aWxsDQo+ID4gbm90IGFmZmVjdCBvbmx5IEhJRDsg
b3RoZXIgc3lzZnMgZ3JvdXBzLCBzdWNoIGFzDQo+ID4gdWZzX3N5c2ZzX2RldmljZV9kZXNjcmlw
dG9yX2dyb3VwLCBzaG91bGQgYWxzbyBiZSB1cGRhdGVkPw0KPiBIaSBQZXRlciwNCj4gDQo+IENh
bGxpbmcgc3lzZnNfdXBkYXRlX2dyb3VwKCkgaXMgb25seSBuZWNlc3NhcnkgZm9yIHN5c2ZzIGdy
b3VwcyB0aGF0DQo+IGRlZmluZSBhbiAuaXNfdmlzaWJsZSBjYWxsYmFjayBhbmQgb25seSBhZnRl
ciB0aGUgaW5wdXQgcGFyYW1ldGVycw0KPiBmb3INCj4gdGhlc2UgY2FsbGJhY2sgZnVuY3Rpb25z
IGhhdmUgYmVlbiBtb2RpZmllZC4gSGVyZSBpcyBhbiBvdmVydmlldyBvZg0KPiB0aGUNCj4gZ3Jv
dXBzIGluIHdoaWNoIGFuIC5pc192aXNpYmxlIGNhbGxiYWNrIGhhcyBiZWVuIGRlZmluZWQ6DQoN
CkhpIEJhcnQsDQoNClRoYW5rIHlvdSBmb3IgeW91ciBkZXRhaWxlZCBleHBsYW5hdGlvbi4NCg0K
UmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KDQo=
