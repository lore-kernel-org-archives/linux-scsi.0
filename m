Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6422B401A0B
	for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2026 12:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785759565; cv=fail; b=kHgSRAoSxaAOatMtXVOjTOaTZpNc3vB2t8fwJ+5KZSPHfZIT1rgsFR9aV/J5WrLOSeuMgAalVJlnKpwNnt/vnM42jocXPJL01A7kB+1YY/w09X4FjB+Bb36F0s/ALeqv/WcJkGEo8PYEVhQuGdhJcFkc9wJEzHyt3aaB0VvBXqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785759565; c=relaxed/simple;
	bh=kQHVRdFvzZZBPUtqqcce3SA7dxtyS460d3izcU/bBNY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=npGclDmok/3wvFGA24VnanImESwaluyIkl4LH94XK59sCWJQ9R4c6dScEPIhyfEaCQ4wpE5XCe1HMncTgi3ZciaWpNjGW10qDuC3kQFDUCHoAvhxZJ1jK4E1eTtW8+i5sZvR7zP6M4NB5932e5cwFeM4g47aMyYQ4JAEv0D0we0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=kvaN8L8u; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=jYcoSEIT; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="kvaN8L8u";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="jYcoSEIT"
X-UUID: 8b8e54028f3511f18dc8c9802ae25ab1-20260803
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=kQHVRdFvzZZBPUtqqcce3SA7dxtyS460d3izcU/bBNY=;
	b=kvaN8L8u8dpy13gIyapbesg4UJRKfg35rQMlnFv5Leqmz3PMzGCnfyTriHLLBNtCkN8HvhM95/CfySCS7KgcfubqjzHyAp+DRKnLUZ+qKzW0QfNBovUc8unjYIpKjuVLRqjjey8Rty1TmiVON6NhJsZiSczcS1Zf/7OaK+QATgc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:fdc3ce52-bbe0-49aa-af8a-d283e534ca0a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:12127af1-0685-46a3-9cac-19d8f3a05ae7,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|836|865|888|898,TC:-5,
	Content:0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-
	1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8b8e54028f3511f18dc8c9802ae25ab1-20260803
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 478473043; Mon, 03 Aug 2026 20:19:16 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 3 Aug 2026 20:19:15 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 3 Aug 2026 20:19:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CMVYnH7dnDar0np804TEfUmF8GCdq1CyzXPQXti7OAItRLgTqiDCjjANnUs0bjdP+eUyOfpnxsWweZx3HbHVNCxVVLJBgksgCmGQ+BCXJQLK+N6Qz6TJOvyqRF25pwuryTrRC5bGQUbzchXRa8CS7v3k9yQJAtaZcRYBvGYd+WtJQOAIBVrqUFXpzmoP9rVSFmjkfmj16un2KOdGNvTJjOOwkVuPrU+c/CyQSCBLT2RI0mZ6KaSZYsL/8hUkO41VwoQ1jbSSc9rjCAlGQSakhUTW4vU46e/tkY83/yoHb57RF92721lO9FOPi7ZNO2C3k+UcZb/JQ6Yaz2kgmRYIJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kQHVRdFvzZZBPUtqqcce3SA7dxtyS460d3izcU/bBNY=;
 b=l9kur+opLIofydOIZEicTIBJmP8DGcUUWTLg98hxLc3Xtb/Z4gSIVat6HZ6BugSbP+GYsHAAEJs46/SDdDDbwJA0bNfFnZRnZZg7SBN63tuJg3itqAGC+J4bzz+JnRPv2+FEEXEutyEG++uaWtuvE4K3fYUY5XHOmImdlF7zeurNfg7X0sJfMycGGmG8Lcw4w8kbLK2Dz++liw71nnJhJonICiU3hdyCSBKpRQemIHpjOOS9PLzb7nPma8XgpwNiPssBIUTHx875ZAEgQolcascGHz0oi8IVJLCgA0Vy/c7stODonhHwFwZrCREPxBYCDDgn/T8y457gxBHHNmZFYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kQHVRdFvzZZBPUtqqcce3SA7dxtyS460d3izcU/bBNY=;
 b=jYcoSEITVfmorj1alh40Pcwp1EUHClAyfg4AQb7+5SSTxTtS3mNZz6TrR9Vt52PdtEK73Nk5POKRejS/nGEaL6tZuQXH7/xGQZuafJvCulG+RbjaH/TJkC2hfmxkbRU+vj5B2q7dzBMo+PysfzJJPD8OKrL7m9gNdEPdMqlnaTg=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7719.apcprd03.prod.outlook.com (2603:1096:820:eb::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Mon, 3 Aug
 2026 12:19:12 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0270.016; Mon, 3 Aug 2026
 12:19:11 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "elver@google.com"
	<elver@google.com>, "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	"sashiko-bot@kernel.org" <sashiko-bot@kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"avri.altman@sandisk.com" <avri.altman@sandisk.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "can.guo@oss.qualcomm.com"
	<can.guo@oss.qualcomm.com>
Subject: Re: [PATCH v4 1/6] ufs: core: Set task state before
 io_schedule_timeout()
Thread-Topic: [PATCH v4 1/6] ufs: core: Set task state before
 io_schedule_timeout()
Thread-Index: AQHdITcCTCfTz9PeO0qmqv9GOVt1fraMQiUA
Date: Mon, 3 Aug 2026 12:19:11 +0000
Message-ID: <a87c952d766446969def1c843d8e86207f9e3b12.camel@mediatek.com>
References: <cover.1785534655.git.bvanassche@acm.org>
	 <68f3346cab2be570839350831f82b6c9233832ed.1785534721.git.bvanassche@acm.org>
In-Reply-To: <68f3346cab2be570839350831f82b6c9233832ed.1785534721.git.bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7719:EE_
x-ms-office365-filtering-correlation-id: fbad5e81-243b-45e0-4ff0-08def1596d10
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|22082099003|4143699003|38070700021|11063799006|56012099006|10067099003;
x-microsoft-antispam-message-info: IzvaQJLN72bz6zuGWQWdqTwH9bsuCKdfjQw7GgM+Yd29aXV0X4DDQty08pBEM+++naDIY8grwGIIpRqCT+PCnOAjVnXABBSFo88NHIGiTDjAL/mQ9TMc4kndZawyexubTdxGTy0bJJiTOoPXZSYvCtpX5/imOJrxlIxncqi4x0iM4Uh9l+S/ZsiBZvSKZnsWOVMQOaxyiSLpPuTA4pp6isr29BjyMPo7svjpZU4+Au4NOyVD54c4/jJ46HE2qTMGN2sbBcfEbqTPg7srWjnjSVoGZ0PnAY3AQM3NGe6SzuT9csVYt7/FXJnW5V1vbcr5VgvTsPUh7mYYWzCYdP3N02MMIx9RrQCGyWmT1Gnvc5jaW/olKfTgrz4JSjMln1U4nVwDC+oLs/6G0PoQDFhhRAEBSsisTmlLzffjOxM1TKhdqUSEjBjk2/+aqoblDmJd9ESpYKVShFFnAP26nmQgSLfI+5WtUzVRdnduxp7mXBWnOGszL3tiWBT1KGnA+f+1QhMxWBQ+wJaWiqonCsfe+0Em9ve3SJMD+wLk/OrbymRer9J+u5s6IkoTWBAgmU22ZvuCb81NyyhdQ5XqM5G9eFRv4gEn792oIG2j5jJpgN4D3f5q1u1RYBkZPnoWHDNkpozEXMryFDZgZ3S3vXI2A67wOfZiw7L1D/XhiQSeaxtkLGF27ryWLW4AWM4pjy39p6y9GxKJ/+pxyligFvb/wmxI7ax87+95dqg2jg2oG9k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(22082099003)(4143699003)(38070700021)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SFdxakJiZ3YyNkxYQ00xR0R2WkJlNXlmYjM2U2ZwcXZyU0dUR0M1ZzdWWDJT?=
 =?utf-8?B?SWc3YnA0c2pvaHVLWFlIVE51QlM2K1A0Q21sbVA3NVE1SkdQTXZ0QWJ2NHg5?=
 =?utf-8?B?RVM3VDM4Q2RObStKZFBHYUZ4UXQ2aStpVVZCdi9iQWZ0Z0x1ZmRpRWRKc3Ju?=
 =?utf-8?B?aVY3S0RUb3VXUjIrcTJhcU45MXEzbnBrNTVtUTkyTDFxMzNUTk9SRUY1VU1W?=
 =?utf-8?B?SFl6bklIWDlLa201Rkczc0t0WnorQnhJZjYxZ2wvQmZMRkFtSmR0U2t1cTdq?=
 =?utf-8?B?RWZqN2hBb01hT1FKMVFOT1N5VVd2aldSeWRQWkE1U1l3SWhGUXlCd0lab1Vw?=
 =?utf-8?B?WitxZzY3ZGR1eVhtMkx6dkZSMWE2L1ZxZVl6N0VYOVBlQ1ZVMXVvL0I4ZHBj?=
 =?utf-8?B?aEhnK0hGdEYrM2NPT0cyTm53eTRVaExmL0tXdmlYSzlWeUh1MGZpYmpmc3FP?=
 =?utf-8?B?Wk83RFc5dTZvUlBGVG40NU1xQXBkMWNXWlF1bDNpVUJWdE9oUUN0RWkrSXlh?=
 =?utf-8?B?b01wamNzeHRCT0hacmxWYlpmQkxHVkExUkd0eDdCSVBlUGF6dTczb0p5K0V3?=
 =?utf-8?B?TndFa1ZjSjFpYk5xY2F0dUtPaENQQVBZM2hmRjBvZXhheFVyalZrMjR0ZzVs?=
 =?utf-8?B?Wk1pVDZwT3lHN2s0WXB5OTZNWkpCeGtuN0k5R0R1Z01vTWp4TGx1QzdzcmVm?=
 =?utf-8?B?bXpqNm0rOVdNYXRCVzY2OFRSNExxY1hqcUlLSU8wejc4UHk1WUt2ZnZuUDFi?=
 =?utf-8?B?SVFTc1BNMG9CcmNpYkVNMVZXQ09ocWN1Y2RDYkNETjV1UmxVeFJvbGdqdCsv?=
 =?utf-8?B?WktGeXZocE4rS1BNME9GbGtKWVgvN25vMkMxa1VPZ2lvM2pkanV1ejdVV21F?=
 =?utf-8?B?M3QxeCtKSHZlUmJCbjMvNGZpblJuYmpJL2lEYXh5ZFFGL29sLzg0aStFVllt?=
 =?utf-8?B?V0NVeXF3MnFyUEV4dVk5a2lrRG1Pcm5qcVJQbEJlNi9RWXV4RmhkL0E2ZVhV?=
 =?utf-8?B?aDU0aS83aXZ1M3JXRjBodjcrL1JUejBqa2o4RkVFR21CZld6c3FyQ2RZU2I1?=
 =?utf-8?B?cW5RYlJkY0xXRUpad1hrdlVQYUVPRTd5bzZldVFGWFY0OVZRZ3QwM1NmVVNy?=
 =?utf-8?B?Q3owUjhXdzE3aWFlbi85L29nUlJ3SFdCWWdHQkQ2ZWVYVk93ODFCTnIwa1FB?=
 =?utf-8?B?MUZsbUttRUR3SGFmMGQ5Y1ZpNFJTQll0a09KWDlyZVNFYlRiRis2OW5JRW8x?=
 =?utf-8?B?b1dpc2lySmJpRVFjb3lzRTZvMVI3VEtONTZ2M1RGb1k3VHROaGVLQ21OWnI0?=
 =?utf-8?B?Mkx2ZWhSYVlKY3NVWDd6Z1prZWN3V25iZzAzWFpOaWhxNy9HWlhCK1dNRHBN?=
 =?utf-8?B?N29JcUpHcXoyZVVBUTNZS3d2azczcUdZWmtyTmZYV3Voenk5cHA0MFN1Uk1X?=
 =?utf-8?B?N0NtVTJuZytNVFlWSkwxMHYwdTJBRGNia3p6WGZLZlB2aGJwS0cyREpDMGgv?=
 =?utf-8?B?WGZVSExRVFBvRmpQaVJnTjQ2OHZVRWJtWFJDT3ArMFVlbk9obHFPWkQrZmo1?=
 =?utf-8?B?TXFDUE44aWJWTk5YckJBQVVSMTZFamlsY2dZV3I3WlB3M2Z2YnZZVnpETVl5?=
 =?utf-8?B?WTlCRkFENlpJYW9UWlZrYkwvNFN0VWxLWHRzRFBva3lKM3JYbjBrT0hMNnh1?=
 =?utf-8?B?M25KM3JiT2hOR1k5S1RtcjZsNE5PYVdrbXhQZVUzN0x6QkNhMjFFQ0pETXp3?=
 =?utf-8?B?cFZ1QzFHR0lvS2ZmSytzN1FmUXBEbVQ5VGliU0JkTjNwVSttOVk4ZEFSekRk?=
 =?utf-8?B?QzRwdGpCbWMvMldhSU02RktSS0gvNWdrN2RXd3ZuOHBGc0x1d1NHVWhrREdC?=
 =?utf-8?B?em1BcUE3TlE3THE0M0tOZENjZDFOS3hqeGd3NFdydDdidFBmNHdCS0pLWmYr?=
 =?utf-8?B?YzdxYlhQRU1QdHZXaXBrb3NXbU5xUUxTSlJvUkZ3ZmxEbFp2dTZ4STV2d1JF?=
 =?utf-8?B?T2lreHg3Z2hTbTltWFk2M3d4QmVYd01NVVVBdlBEWTM2OGJBLy9kTmwySldY?=
 =?utf-8?B?WkhvdXhWWlZRa0I3R0pEcDlsVnhKTVVHNUJSL0lFZXNvTkdRRUJtV3ZnbEZU?=
 =?utf-8?B?aUs2VERNbjBWZzhwVGlFSUZyUy9DNFNCTDlOd0VTazg2YjVtRWVadHN4NTZi?=
 =?utf-8?B?ZkxSQWVHNVFZcGozRExPKzNDd2E2czVKQVFycjZEWWppTjdwLzRWYWh2bElV?=
 =?utf-8?B?OHdvc3dEUzMzQk9POWZrWXk4dkFCQ0JOWDFiL09USE9LU0ZyL3V5endNejdH?=
 =?utf-8?B?b0wxemNSWWdUNk9kU0gvNTRLbkMzKzk4VnFxSkg5NUp5bXJWY0RLd2ZtQW5x?=
 =?utf-8?Q?wO0JDbYyiK3lFIQQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3898944AF74A014F888734F31D59BD86@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: FgioOiySDhIPCxe82t6PRseU+uGSL6LFEfDeDiozh3l2oXKEDZcsXgj2j+JlfuH+O9j2umGRuStVm1zrlP0r+SXgP0+H9wg/o6l4qILhLhyUGJMZJ+dWrNlLEeUokzJELjpafkdkb08F5bdsXUH/Msh1usg6V7a6T5KZbJF4MrhpTmAHfGgrUplt3aXk/B6f3BsYCXT5jWa79iPI19i4es/Lic29cZRKO7tFvrazYeeZGFLyUpKlg2HdOtl02QwQqcHE2x/lNJwgYlUtJWDtdk1+JEHY5juzB0KTd/jEe1hjuTIDbukw8s6bLuuagDt+hrY4Do1SJX7GRCgEsWXDAw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbad5e81-243b-45e0-4ff0-08def1596d10
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2026 12:19:11.6765
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i482LXj97TN+R9/94gXr3SP8Djou906fyZpVeJQzhrmnuhI/PjZbaP4ylW7uxqGWtJJQ79S5JJI59e8wLSDt/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7719
X-MTK: N

T24gRnJpLCAyMDI2LTA3LTMxIGF0IDE0OjUyIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGUN
Cj4gDQo+IFNldCB0aGUgdGFzayBzdGF0ZSB0byBUQVNLX1VOSU5URVJSVVBUSUJMRSBiZWZvcmUg
Y2FsbGluZw0KPiBpb19zY2hlZHVsZV90aW1lb3V0KCkgaW4gdWZzaGNkX3dhaXRfZm9yX3BlbmRp
bmdfY21kcygpLg0KPiBXaXRob3V0IHNldHRpbmcgdGhlIHRhc2sgc3RhdGUsIGlvX3NjaGVkdWxl
X3RpbWVvdXQoKSByZXR1cm5zDQo+IGltbWVkaWF0ZWx5IGJlY2F1c2UgdGhlIHRhc2sgc3RhdGUg
cmVtYWlucyBUQVNLX1JVTk5JTkcuIFRoaXMNCj4gcmVzdWx0cyBpbiBhIGJ1c3kgbG9vcCB0aGF0
IHdhc3RlcyBDUFUgY3ljbGVzLg0KPiANCj4gRml4ZXM6IDIwMDBiYzMwOTcwMyAoInNjc2k6IHVm
czogY29yZTogUmVkdWNlIHRoZSBjbG9jayBzY2FsaW5nDQo+IGxhdGVuY3kiKQ0KPiBSZXBvcnRl
ZC1ieTogU2FzaGlrbyA8c2FzaGlrby1ib3RAa2VybmVsLm9yZz4NCj4gU2lnbmVkLW9mZi1ieTog
QmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQo+IC0tLQ0KDQpSZXZpZXdlZC1i
eTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo=
