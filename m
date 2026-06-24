Received: from OS6P279CU014.outbound.protection.outlook.com (mail-norwayeastazon11020098.outbound.protection.outlook.com [52.101.178.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF0D3905E7
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 07:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.178.98
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782285469; cv=fail; b=TXBUWYRYBjKZHSYRWDg0d4izpjuqfO9Y9D5wrWhhfXlXkVTR1XVFRPxvjaYNT7TcDLclwAen6UqNYEBE1HbLM0WbAK35HZFQk7rzfDq8VNnoPsr8O8dcLNDBHrjnUoIKhgCcYNrjagdxGWBYv3ML5KtEnw23XEPbWpzjOWsP2KY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782285469; c=relaxed/simple;
	bh=VnIQGXOG5nlaPDuKZB/ADp2EHW79N1BWw3wE6cgKcUE=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ZcdGUL0S0xS53DPGvDY03kwGklOP7ymQ85T5mXlwKodjEUSDPiztrE/jngapO7/Nllu19r5g0eHmHPrVmpEW2QFh0mO05Iv9pxKkSoFJ9r0DwlPD2+DbCO8e3E/zQ2mStNfYJ67GNM5t57G+9uerLTljtn/F9OIRFvrnz8RiF4M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=intility.no; spf=pass smtp.mailfrom=intility.no; dkim=pass (1024-bit key) header.d=intility.no header.i=@intility.no header.b=GNi/lieB; arc=fail smtp.client-ip=52.101.178.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=intility.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intility.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=intility.no header.i=@intility.no header.b="GNi/lieB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yYBT3PMuQqYzUTppVoA3lf0zTBxnaaYDZM+drINXOy4EctM92RiUTzy8ytxitsC0na4263uoLlbamPODintyuvKaUxGJ+Dfkm/iN1ISOXo5a4oPucNq2oLZukgNA3WjnvEBqc76f0w9FLX5cxBfbshfh+4igjxrfuvANf+ThiAFrdSqvTkSLZsipKsBH55RXkKYbm3lCtjdpboRQl1+brsl6QUaVBYaAhOnmpAYvyM2S0MNSM35cOcwomkohudPzJ3QgdQIdKS7gXaq62j3/97S5QTknm0tlMQaKgjNaMtvi2rCJx3ZCN+DSx7IX7p/rqBtp5MpBGW5ulOFnuFo+Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VnIQGXOG5nlaPDuKZB/ADp2EHW79N1BWw3wE6cgKcUE=;
 b=ukMxFKF6QPio5dvPFyYIWX016y0a8orZRv85Kd045bmzg+n7iRiNtB/AiOsO6DCSvs2x9y72BJT2Lkr+fF73M4KxhcmOt8WtMMxB6/nu+JzpMQclk4Q89pop6S6QOxNeYiWL7N62jzo8ClfgUvfxtEnP61QgCIz9hVLtSlyRRKRpU7LoNL/KgE3fL3HI1f2Q72NFH5MBthLCL5RdY4L07zZLVE8DPbZ36nN0m+LpjMa1aDIIrCYYoxu3KDtNsYYoi2UtDQlAF3KiWpbftF4Rnfy6LBMkCjyla+8Ke6/BSam+Lxym/LxtygDgV8hzJOknuV76aa24nddEINUIkZVatw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intility.no; dmarc=pass action=none header.from=intility.no;
 dkim=pass header.d=intility.no; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intility.no;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VnIQGXOG5nlaPDuKZB/ADp2EHW79N1BWw3wE6cgKcUE=;
 b=GNi/lieB1Gz14KVG23LvEYzFZhnr9LV553gbKszZbzlSGScKyTadnmnijwa/gV8gobJ/EP3zG80NcCdJTLWBzSWhkkoAc1t+tYy6RgG2xRU5C22CYE7S+9vC9UFrX77+J6HOVKypZetewIn1aqn6Po1YSXJ10nba0MH02F+xYCY=
Received: from SV0P279MB0105.NORP279.PROD.OUTLOOK.COM (2603:10a6:f10:b::10) by
 OS6P279MB1026.NORP279.PROD.OUTLOOK.COM (2603:10a6:e10:54::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.139.22; Wed, 24 Jun 2026 07:17:42 +0000
Received: from SV0P279MB0105.NORP279.PROD.OUTLOOK.COM
 ([fe80::8a8b:563d:c6df:ba43]) by SV0P279MB0105.NORP279.PROD.OUTLOOK.COM
 ([fe80::8a8b:563d:c6df:ba43%5]) with mapi id 15.21.0159.013; Wed, 24 Jun 2026
 07:17:42 +0000
From: Mats Topstad / Intility AS <Mats.topstad@intility.no>
To: "mail@danielfernau.com" <mail@danielfernau.com>
CC: "chandrakanth.patil@broadcom.com" <chandrakanth.patil@broadcom.com>,
	"kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "me@magik.net"
	<me@magik.net>, "megaraidlinux.pdl@broadcom.com"
	<megaraidlinux.pdl@broadcom.com>, "regressions@leemhuis.info"
	<regressions@leemhuis.info>, "regressions@lists.linux.dev"
	<regressions@lists.linux.dev>, "shivasharan.srikanteshwara@broadcom.com"
	<shivasharan.srikanteshwara@broadcom.com>, "sumit.saxena@broadcom.com"
	<sumit.saxena@broadcom.com>
Subject: Re: [PATCH] scsi: megaraid_sas: fix PRP list out-of-bounds write
Thread-Topic: [PATCH] scsi: megaraid_sas: fix PRP list out-of-bounds write
Thread-Index: AQHdA6mLH1xMprsD9kKkqZYiW5Iayw==
Date: Wed, 24 Jun 2026 07:17:42 +0000
Message-ID: <4FE725D3-0702-425C-AAC5-4E0AF86E5EA1@intility.no>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intility.no;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SV0P279MB0105:EE_|OS6P279MB1026:EE_
x-ms-office365-filtering-correlation-id: 49f45ae5-aa52-415b-f6c0-08ded1c0ae67
x-intilityrouting: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|10070799003|7416014|56012099006|6133799003|18002099003|11063799006|38070700021;
x-microsoft-antispam-message-info:
 NSq2E6c7ilXsbOkj/K0d3qJLBXicwJ7GJxNrcrgdD/sFKgZiIYIJNaSvjXfMUTQ48LB29j+xs/dX41yU3M7NgiS0Py67PpzgUIPbvHv1JeiOdC85sybdZp4zcr7nAIE5dDlRBEsLFZw2VYzqkRFf6PJs+TVSwgSjMDWMI00O6zNvmtLb9F6fCFRkb2hVT0hAYx84bOaikapEYxpnnAfmrtlSt3rH75BoQDiqvwq0Q1B0a2bTYEIo5h2vaq9jVqlPA1El1fNsHz6jA7F0H6WIwHgklqbqK6d6pBko2RqQhkQiCZkTZZHUbHbM9RltIUnuHbXvwiiSd4FLfX//TmWs1j1mJe+OlVcsRLBB3Vkj9SgCErIjxO4WaP0ZIEO0iPdvk9YFBEdXDISImEXnWspuf9RWYshCoP29QAxfyi8RUoqpHLKPzyKgCWXsBXGPJhGFFSnLhmAgCf7BTU5XPhsbg85ZGo7rtZ0RSIyVEJMTv6EAi24r85Pe4cLH3z3Cn1BWO+BGRjIN/+g6CEjXbDAEOYt9bHjKMVbHkbcbZzUCJbQc283GB+Iaj/wBU3g5h0SO9bZK3oF7mE4tWRaaV93GMuL3BOmTbNM+Je/c0j/CjH76aF8sLiwl5WLoh8QukMn02OlCH4qz5eCofr8lqJa+BEx3pmfWa5VCny/CUgSwslDCRkvT8dn3R0u23znm8wrKZiSxkZFvlaeIrtdehp2RqZpsuXiRmsw6ZI7/qeUIXP0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SV0P279MB0105.NORP279.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(10070799003)(7416014)(56012099006)(6133799003)(18002099003)(11063799006)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QWVrNnkwY2NGYlBndmR1WFFkdTZSSkJ4cU1CVktmaFZnb2RCZG5na0JKS0tY?=
 =?utf-8?B?VlJsSWRGTms0MVhxREI5cmV1UHpwQkV1bEtOZG1BVURGQnV1dkRjeHhhK3F1?=
 =?utf-8?B?Q091d0lkSVRCdHF2aVhBbzhDQmJrRnpDMkNtOEZSdTJ0UmJuYkNjeHVENkRx?=
 =?utf-8?B?aFRod0FZTlp6VWdNU3FtQUFFbzZZSXVmU2dETlZBNW9kZmtBdTJDOTgrWGhu?=
 =?utf-8?B?d0hicmpOdHhVZkdaT2JlV0dRb2pKVTE0NS9EckFQM3phTlA4WEJhVCtseDE0?=
 =?utf-8?B?eE53bzBOWjA5RkJTcXE1VnNsZ3M3WHpIZklldnRCOGF0QWZTZDhpcUczT1ZM?=
 =?utf-8?B?YWcwVmszNFRBYUdNY2xDdSt0MTgvOW5HZ0VOMlVXUjBwV3pqWUtxN1RDTWY5?=
 =?utf-8?B?WVFsM0lobm0xRTNQTEFiamJXMmpBdjRJTFdBa0p4aGVCcGEvV3oxMkdjQ0Q4?=
 =?utf-8?B?U3Z2MHRpaXc3dGlhRVFFZ3hpM0JoMnczY1NrZWdHNm9RU2s1eUFsUy9JR2Z1?=
 =?utf-8?B?eTYwMXRkRDR5azd6OHA2RkhsTlV6bUErQVhOczRNVXp2dTVpUTlLRE1hUjZ3?=
 =?utf-8?B?ZlVLdlkySmlWVkxISlJ4THZoY0ZpNndUdS9YUUxRK29YUFJSaUorNUNRM0Js?=
 =?utf-8?B?NTVqZ2VtWFZ1WjRkSzZvSXRNa00vR25pVUU5OGpWMnZ1bkRkRExxODdwS1hD?=
 =?utf-8?B?WmExSU4zcDQwR2RZdU95aEt0WlB6R0lORnJEdGJTazFGNWJXdmtOR0dhM2Fq?=
 =?utf-8?B?TldmRFdHb0d4NlUvY0VPbU5uMkdrS0JEK2RUcGMxeXVtcjV2VkRVbzQrTm81?=
 =?utf-8?B?RWhreGRLZE5EQXZOZzUzRzEvOXpHUkdTU1hPQjRtWjEzMmFTV202WHFWT0d0?=
 =?utf-8?B?YWVmd2tnZi94VmNSZ002bkNNUW82TFJXc25ZQkw4ZlVJeWxMZEkweUM4K3BK?=
 =?utf-8?B?UlFhMUNiS0cyWnczaE1SVDQ5ZXpqdGtnWnFnZXZPTjFTZXQrVFlXOHlZaXlK?=
 =?utf-8?B?Uy9qWDRlaTlUalBIRFFFKzlWT3IrUS9qKzJDLzYvSHJka3l4SkFwNWdhNUx4?=
 =?utf-8?B?ODVpMHhtRjdOaXZUNEhSbmFGMTFSMGZydVFzd1BPL1NFNFJVbUZnMDVjbGZR?=
 =?utf-8?B?N1Nza0JQMHkzcWZSNStheGo5NEFqSXZObEVDNnpZQjZvTm1GZ0JWTDVqZHgv?=
 =?utf-8?B?Q3RxZ2VteCt6QmsyKzlnbC91VUcybEprekphTDVkSklVOTBUVkVLRjQrdHlN?=
 =?utf-8?B?OHd0UllyQ3NuUXNTWlNvUm9qamVtU1gwWEMrYWlKQWJJVGFiSytvcGd0b2tF?=
 =?utf-8?B?SUlYTE01V052eXZobEZVazJOVTJya01sRUs4SGZBZHF6R3hEOEQyY3BmSUpj?=
 =?utf-8?B?Y05oMjA0Y3B2cGhpYldGTFV3MlZoZFZYb21zOXRFcnBubGM2Z21qZkljZ2J5?=
 =?utf-8?B?Qm0rRXBlNTkrQUFDdVI2WlNTQy9LOWpROTNTUnNmL0RuaGllQ09PVFVqR1hB?=
 =?utf-8?B?YXBGYXFxbE9tNmhkanlwcjZTanE0NTFEY1hYWmxYcDYvcjlqcm5SSlgrekI4?=
 =?utf-8?B?TXU0UXJweGJpWUxDRjFRWG10VCtkb3Nxc254aTRlZ05SUXI0MmZIQUQzMlV2?=
 =?utf-8?B?NnlvYTlBNjFseVZXVld0MVcyd1h2NWVmN1RYRUpjY05XRUNsdlVpajBYMGoz?=
 =?utf-8?B?ZVJLV3Zvc0sxR0VmNHhLL2NZVFptUytoT3Q1ekZoUE5ObFpJTWRacituVWQ4?=
 =?utf-8?B?U240aEZuVU5HbFFxK3NuWW5yOWY4VVBRKzlaN2RkZjJSbWdJcGUxMVJONVpL?=
 =?utf-8?B?NVBNSG9RaFVSQVk1d2FzLzNqdnpIL09mQXdCWGRWZGd0SlR0bzMyOFBPOFNh?=
 =?utf-8?B?ZmNyT2JxZW1qZjU0bTk0SlBpL0Uzb2NLL3IrbzhjV1dkdUptalpPbmI4QTJs?=
 =?utf-8?B?a3NNcnpaZ3RjRTQwdjhLQ0ZTZlRQY0xsazN0Vnl0RWl3ZzZEZ0FlWW15Tmx6?=
 =?utf-8?B?UGU0ZUZmMGt3eUVyOExkS0VSRFVTM2lzWWRuWTlYNHlQNksyekppVTFJL3R1?=
 =?utf-8?B?MmR5aFVHNklWR1hmSzJnVjhXVkJkL1AxdUhibW5YOUNMWnB3TFYwVld2ajd5?=
 =?utf-8?B?cDVkWDBPWHhsUER3QjBUZjRMenppUC9TRjNKekZuQzl0eTZpZ1c0M05lajZh?=
 =?utf-8?B?UDg0cWFrZDBiS2F0OWhYNy9admh6c0syQkl0MXFQMmdNdlV2ZlZ0OW1FbUsx?=
 =?utf-8?B?UDlZYU0vWGhKcTJ2ZmZuOWZBMGw5eVI3ZWwzdEcrZHoxNkNjZ2NSckFvWW1Y?=
 =?utf-8?B?MkFGSytoWG1hZlhmYWVhSGhSQmhPVGpTUEhlalpDaUIzM2VOSEMvR2F3MnU2?=
 =?utf-8?Q?I1vDWVPNgOsZCtmADZGcLuLrt29xV2TUsAqr5EVP8PGZX?=
x-ms-exchange-antispam-messagedata-1: IjKGeXhxI/I4qTTqOnzwPQil76cKXENXhL4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D68187AD2DA5654B9E690F4C338A5368@NORP279.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: intility.no
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SV0P279MB0105.NORP279.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 49f45ae5-aa52-415b-f6c0-08ded1c0ae67
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2026 07:17:42.3022
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9b5ff18e-53c0-45a2-8bc2-9c0c8f60b2c6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c8kH8sX+GgC5/eVV9KTlmZOCabeM3asil5ElIIWrYZ8Ucf+f2+lEMWsLL/kp8h6xsNuPxC+svw9PMkGeD8DwmdG6LCDlJ6Hl3wojqJhdnz8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS6P279MB1026

SGkgYWxsLCANCg0KQ29uZmlybWluZyBhbm90aGVyIHJlcHJvZHVjdGlvbiBvZiB0aGlzIGJ1ZyBv
biBhIHNpYmxpbmcgQnJvYWRjb20gY29udHJvbGxlciBhbmQgYWRkaW5nIG91ciBkYXRhIHBvaW50
cyB0byB0aGlzIHRocmVhZC4NCg0KSGFyZHdhcmUNCi0gSFBFIFByb0xpYW50IERMMzYwIEdlbjEx
IChJbnRlbCBYZW9uIEdvbGQgNjQ0MlksIFNhcHBoaXJlIFJhcGlkcykNCi0gSFBFIE1SNDA4aS1v
IEdlbjExIGNvbnRyb2xsZXIgKG1lZ2FyYWlkX3NhcywgZmlybXdhcmUgNTIuMzYuMy02NTg0LCB0
aGUgbGF0ZXN0IEdBIGF2YWlsYWJsZSB2aWEgSFBFIFNQUCAyMDI2LjAxKQ0KLSA0eCBTYW1zdW5n
IFBNOUEzIE5WTWUgYmVoaW5kIGNvbnRyb2xsZXIgaW4gcGFzc3RocnUgbW9kZQ0KLSBMaW51eCA2
LjE4LjMyIChUYWxvcyB2MS4xMi44KQ0KLSBXb3JrbG9hZDogUm9vay1DZXBoIE9TRHMgKGhlYXZ5
IGFzeW5jIGRpcmVjdCBJL08gdmlhIGlvX3N1Ym1pdCkNCg0KDQpDYXB0dXJlZCBrZXJuZWwgcGFu
aWMgdmlhIGlMTyBWaXJ0dWFsIFNlcmlhbCBQb3J0IExvZzoNCg0KICAgIFs3NC44ODI2NDZdIHNk
IDA6MjoxOjA6IFtzZGFdIHRhZyMxOTU5IHBhZ2UgYm91bmRhcnkgcHRyX3NnbDogMHgwMDAwMDAw
MDZkY2NiNjRkDQogICAgWzc0Ljg5MDEyNV0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIHBhZ2UgZmF1
bHQgZm9yIGFkZHJlc3M6IGZmNWNjMmVhYTExNWMwMDANCiAgICBbNzQuOTE4MzI0XSBDUFU6IDQw
IC4uLiBDb21tOiB0cF9vc2RfdHAgVGFpbnRlZDogRyBTIDYuMTguMzItdGFsb3MNCiAgICBbNzQu
OTMyMTUzXSBIYXJkd2FyZSBuYW1lOiBIUEUgUHJvTGlhbnQgREwzNjAgR2VuMTEsIEJJT1MgMi44
NCAwNC8wMi8yMDI2DQogICAgWzc0Ljk0MDgxM10gUklQOiAwMDEwOm1lZ2FzYXNfYnVpbGRfYW5k
X2lzc3VlX2NtZF9mdXNpb24rMHhlZTMvMHgxOTEwIFttZWdhcmFpZF9zYXNdDQogICAgWzc1LjA0
MTExNl0gIHNjc2lfcXVldWVfcnErMHgzY2UvMHhiODANCiAgICBbNzUuMDQ0ODg3XSAgYmxrX21x
X2Rpc3BhdGNoX3JxX2xpc3QrMHgxMmIvMHg3NzANCiAgICBbNzUuMDg5NDAyXSAgX194NjRfc3lz
X2lvX3N1Ym1pdCsweGQ3LzB4MTkwDQogICAgWzc1LjM1NTg4MF0gS2VybmVsIHBhbmljIC0gbm90
IHN5bmNpbmc6IEZhdGFsIGV4Y2VwdGlvbg0KDQpUaGUgKzB4ZWUzIG9mZnNldCBpcyBieXRlIGlk
ZW50aWNhbCB0byBMdWthc3rigJlzIG9yaWdpbmFsIHJlcHJvZHVjdGlvbiBhbmQgRGFuaWVs4oCZ
cyBNUjQxNmktbyBHZW4xMSBjYXB0dXJlLiBJdCBpcyB0aGUgc2FtZSBjb21waWxlZCBkcml2ZXIg
ZnVuY3Rpb24gZmFpbGluZyBhdCB0aGUgc2FtZSBhZGRyZXNzLg0KDQpEYW5pZWwsIGRvIHlvdSBo
YXZlIGFueSB1cGRhdGUgb24gdGhlIFNHLWFkdmFuY2UgcGF0aCB5b3UgZmxhZ2dlZCBpbiB0aGUg
dGVzdCBBcHJpbCAyPyBIYXBweSB0byByZXRlc3Qgb24gb3VyIE1SNDA4aS1vIEdlbjExIHNldHVw
Lg0KDQpCcm9hZGNvbSwgY291bGQgd2UgZ2V0IGEgcmV2aWV3IG9mIEx1a2FzeuKAmXMgcGF0Y2gg
YW5kIGxvb2sgaW50byB3aGV0aGVyIHRoZSBzZ19uZXh0KCkgLyBzZ19kbWFfYWRkcmVzcygpIC8g
c2dfZG1hX2xlbigpIGFsc28gbmVlZHMgZ3VhcmRpbmc/IFRoaXMgcmVwcm9kdWNlcyBvbiBzZXZl
cmFsIEhQRSBHZW4xMSBNUi1zZXJpZXMgd2l0aCBOVk1lIHBhc3MgdGhydSB3b3JrbG9hZHMgb24g
a2VybmVsIDYuMTQrLCBhbmQgbGF0ZXN0IEhQRSBmaXJtd2FyZSBkb2VzIG5vdCBhZGRyZXNzIGl0
LiBEb3duc3RyZWFtIHRyYWNraW5nOiBzaWRlcm9sYWJzL3RhbG9zIzEzNjMwLg0KDQpUaGFua3Ms
DQpNYXRz
