Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2041.outbound.protection.outlook.com [40.107.94.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DDD200CA5
	for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2024 18:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730227461; cv=fail; b=AFgpvupLTIxsw+6eifVXYlJ0bdIb5fk3Z6F7DJ5zeMmKVTu2OR+mI1SvvaQiWEq0CSf1bIEiaSCC49MYn798Pi+spCfi0xBv5kzC77/IovEXmsLiTGINN43sL0M5EcjWoxu3s+IoirHIgyxHSlDCPBHGWQ77i6NSb7GZTj4JvUw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730227461; c=relaxed/simple;
	bh=eTjqlIQk7j2zKwiC/ijeS4ejI3qB/5uP80yiWNENIiA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r/L2xGt9QWgZGSaMGEtgXs5lg5ejr76Fz65aHC1vS3Egw6NTUM5SKNu2EztdvtKsATneglpUt74WIRvxyq6xg7Wm+VKRRYug2YU+G2m8WPacu0TKnfyeO58ZrgolkY8r53NxWirUQAsidifTZGI1Jm9rFZIlYDtl7O6RpCoIOrQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=micron.com; spf=pass smtp.mailfrom=micron.com; dkim=pass (2048-bit key) header.d=micron.com header.i=@micron.com header.b=pviak+0r; arc=fail smtp.client-ip=40.107.94.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=micron.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=micron.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=micron.com header.i=@micron.com header.b="pviak+0r"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FdRnuOnBobvvt651VCyYOJijRxQA4Iv6IMBE6fldIvrCH3Ujnk3TOCAo5rKS02nBBUcZ1iwyzEClssjyVa5LvSW/9qW6kkeYbL+O7SVE7AWXlVfn+sn/ht+QPBMdAe/Cef7OGfqLFkPGu6zQCsUvEhtnYEsREL6Z4wQ6CkKOTHmj9DK4bTdCwsPPIyyl2LXaxCpEf/Y8s+rGqvqHJrKJkC0hF5oxljP0jO7uyj4i73vaDSUuigoNCZx+QVo4AFFrAn8n0x3icauKuO8UcMQChPiBFxx/FBV4f/nD5TqUEhCWyIjuVkvSKCMeReuUdn7g6HEcuKU8yfosp3F54RzH2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eTjqlIQk7j2zKwiC/ijeS4ejI3qB/5uP80yiWNENIiA=;
 b=uICLDw180iA2+ZEKL+mQY2E3pnhWqutkgibwv35seqhi+MhhhAR50Z7vTP9IM5ZQk/xUlltig7phs7BIVfrOTJXAnfxnNSpgBpKMZpqRosqTxAJ5spgcpDdNcZf8PUoi+hk6KKmLsS6lKlv8ykV8eut0DoQ/ZCHNhfWVWypgp3TcUnvQGqJ2nMBS9xgCo+WBo+gvcSdGWGv0ggNJRYkXkXiiE+q4hiFQ0rXpz/ZpjJBe2WrUzAHnuhpFY5zZii7Cr4r4OzzymG9U5Omm1LiXDT6sa4K766I9v0BMH4rVcsuN3Xpy2zWOSGD+UQ3FsnV5c6x7psOm4d7UDiXlYscUcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eTjqlIQk7j2zKwiC/ijeS4ejI3qB/5uP80yiWNENIiA=;
 b=pviak+0rO9ctuwyoFjoqxQLmqFUEF3AEoDpKYgG1Fbfm5D1utjFcp7iN09avxSUbbyet//GVQu3MHw88UPHqVKd7nEfuPnesQUSRQPmiwESerlybaTLrulWxQI3wZ58iWXXBAi0v2/kyTM2tFcPAIUNrJN+egCojA3gfySuga8xneEZoOcxWzzXNxnw+vlzaDz8Ib7EONFyUYt/JeJd+/LX0810smiI5kc4cjmmr3nShxeaCYhsnqYTHNkVL46hGG7J4guio4eUjvjneh1rfnpum8RQiq/t2n1VCqEqPuGoMW88HICGleUeJnkv3M9ybHcrg/ocv3uUaLJKjHyYYMA==
Received: from SA6PR08MB10163.namprd08.prod.outlook.com
 (2603:10b6:806:40a::22) by DS0PR08MB8512.namprd08.prod.outlook.com
 (2603:10b6:8:121::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.27; Tue, 29 Oct
 2024 18:44:14 +0000
Received: from SA6PR08MB10163.namprd08.prod.outlook.com
 ([fe80::74f0:61ed:1b4f:6a36]) by SA6PR08MB10163.namprd08.prod.outlook.com
 ([fe80::74f0:61ed:1b4f:6a36%5]) with mapi id 15.20.8093.023; Tue, 29 Oct 2024
 18:44:14 +0000
From: Bean Huo <beanhuo@micron.com>
To: Bart Van Assche <bvanassche@acm.org>, Bean Huo <huobean@gmail.com>, Huan
 Tang <tanghuan@vivo.com>
CC: "cang@qti.qualcomm.com" <cang@qti.qualcomm.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"opensource.kernel@vivo.com" <opensource.kernel@vivo.com>,
	"richardp@quicinc.com" <richardp@quicinc.com>, "luhongfei@vivo.com"
	<luhongfei@vivo.com>
Subject: RE: [EXT] Re: [PATCH v2] ufs: core: Add WB buffer resize support
Thread-Topic: [EXT] Re: [PATCH v2] ufs: core: Add WB buffer resize support
Thread-Index:
 AQHbJ97yrEYEmW+CFkOY1GKmd8K2QLKcgTKAgAAWhhCAAANjgIAAAHaAgAB1HQCAAHcHgIAAHcMAgAAU/YCAADzOgIAAHBkA
Date: Tue, 29 Oct 2024 18:44:14 +0000
Message-ID:
 <SA6PR08MB101639506856CD749E433360FDB4B2@SA6PR08MB10163.namprd08.prod.outlook.com>
References: <330e0b7fce03b2970db80c4b73b611af220b6349.camel@gmail.com>
 <20241029120346.591-1-tanghuan@vivo.com>
 <04ebe6420034ca3d791ea3cac10ebd61970a7093.camel@gmail.com>
 <ab068e04-ddf7-4fd5-ab0a-ecf8bc78ddfd@acm.org>
In-Reply-To: <ab068e04-ddf7-4fd5-ab0a-ecf8bc78ddfd@acm.org>
Accept-Language: en-US, en-150
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_ActionId=5f01882c-3f90-457f-b39d-7a67d325239b;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_ContentBits=0;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_Enabled=true;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_Method=Privileged;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_Name=Public;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_SetDate=2024-10-29T18:38:25Z;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_SiteId=f38a5ecd-2813-4862-b11b-ac1d563c806f;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=micron.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA6PR08MB10163:EE_|DS0PR08MB8512:EE_
x-ms-office365-filtering-correlation-id: 48efd44d-980b-42f3-eb0f-08dcf849afcf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?VERwNXBkUWNzSGRxVVczZGVlU1V1WjZKUEdPRW9pZHhiaG55SUhwSk5oTkQw?=
 =?utf-8?B?V05uSGFsSW1JblFtMkdPZmxoZnY4YWxJVGdSblZ3YmtEaGhOcmhIZ0NaT3BQ?=
 =?utf-8?B?NHpSc3gyTzNpNTRFUDIrNldtOVhhdTR1V2pmbW5DT0FkMWNSYzNEQ1BialRD?=
 =?utf-8?B?Z2g2OHY3WWgzZzU4QWczc3h3WlFMRmFKMGNyUktnZlFGbGM2amdpbmh4aWY1?=
 =?utf-8?B?S3RJaWhsZ1VXSlpzZmVWZ1FjWUVWYXR3UzBiUlNHTFNyNTRqSkMxR1I5b0Fh?=
 =?utf-8?B?WXlxT3NaRkNJaTU0WFVsTnJwQWVKditqa3JWZDB5UXN0c0xHbFhaT21SY3JO?=
 =?utf-8?B?TjlRSWJOZEJQTVIzM01ZRitRYWJvNlp3Q1NrT3IxM091R0tobXRmUC9lUUNs?=
 =?utf-8?B?bGtpUDYxOHV1MnNGeGtNZW02WUdsSzUrYVEvenZqQnkwZHNTa1Mvb3BBVDQr?=
 =?utf-8?B?KzRwWTNjYU1YdnNPR3lialFiV0U0MXlHVWZMTjVkTmxxQ2NjZXdWWElwMHVp?=
 =?utf-8?B?aXpIRjJ0d2ZISzAxY2o1NlYxK3J6ZkhQd0lLU2VqbGhnTFZSZU5pTUUyeWlM?=
 =?utf-8?B?Q3RsSHJqS1dUVXorLzQzaGVCT3Z4UDN0STJZeUFTNjBVM3lhaG5BMjhsa0pL?=
 =?utf-8?B?ZXAxaE9OUkFXQmxtTXBDQXNvWFA0K2ZySmxUc3NlK29PbjRtZEs4RU0xcEJj?=
 =?utf-8?B?czVDblhFNzZyTm9JTzdPc1V2ZGNSQU5ZSFJXVUhtOEg5YzZvSnhNeW9kbmRq?=
 =?utf-8?B?UVJzM05RUDZmUnY4WVIrUS94VTE3MjgyKzNBY3Fub3EvTkRxYzN1QUE1Y2dm?=
 =?utf-8?B?WmlObVAydERTU0NmSXp3VDRzd05TTFMrUnZ5SFZZTG1sc21xaW9OcllaQmZp?=
 =?utf-8?B?RUtydklnU0xCcVI1WllNcWwyU1p5MldZU2lIaEpvYWhISWVXalE3M25RZmJK?=
 =?utf-8?B?NnlBRGZUSzJUYitnMTNjOU8zU2RrTlIwRUpvU21xNnFVVThNenNWbTRHbFZt?=
 =?utf-8?B?NGMwYzlhRzNJdy9TbFg3WS9lVWd3c0lENnFiMzZLUkMrZXZPY3AxUHAvcm5S?=
 =?utf-8?B?d293b1RSNHZHOVdodWZBakFsdWsxbG5YTmFwSjZ1QkZVQk5TSytqY1YvNndG?=
 =?utf-8?B?R0ptZ0tJV2txVlVwa3dDQkxTQmlWSXBkM1V6dW5obXoxUVlNUTJTd21hRlZz?=
 =?utf-8?B?VGhGSHluMjZqTmdYYmY2eEVoc3NyMTFldlU4RFZCUXhrMG03RUJNT29yek0v?=
 =?utf-8?B?d2tadVE3cG9KOGorbEpQb2hIQjlsNGl5MkFIUmJYTTl3Y3IxUXB1LzcyRVFD?=
 =?utf-8?B?amljVE50Wklpa2pQR3FqeCtWdjF2TW1KUUp0aUk2YkZuK1BQam9RbzJ2eDdy?=
 =?utf-8?B?OFpZcGdZaktud3FEMXF4bk9wZEpkK085L3NoeWh1QjFONHRUeEpYcHRRdjFD?=
 =?utf-8?B?R3VLalhEL2xmSFdpbHRXTEVlTmZaRFBybkx4R3RwdW1NTnF5Wjh5Rmg0eGRo?=
 =?utf-8?B?SExkZStPeGUzQTc4WlUzMDZSK2NWSkNtaWc3SkRpN1F2enNLRE1EcVhkdTlm?=
 =?utf-8?B?ckFGSlJnbWIxbTR4TTdTVzZ2ei81OGFQN0E5Q09ON2podWh6bWFBUjVZSEt0?=
 =?utf-8?B?TE5WL1lsU0czQkhORE41ZHhPVE5IZE5NMm5zODF4enRXd0cxSS9sSkxwSmdu?=
 =?utf-8?B?NWZBWEUxZ1JPREc3dVd0VXUyTHNRMHRURlF5M3ZUUEYzcDBZU2ZMdGVLd3Fl?=
 =?utf-8?B?OXd2U0haZHozbjRaQlhzTjNWYy9tS2dDVmdYS3ZHb0doV0pPL3NUQTFGaGJu?=
 =?utf-8?Q?XTV4wejwQB0R9UPT41z8cnXKtn/rrticWghKs=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR08MB10163.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eHplcFg0TFZpbGNyeTkwM1A5SXVqQlBUOFRHUnQ5cVFnRjVhV1pmTHpuL3dM?=
 =?utf-8?B?WkRlN3hxUFhyY21sNHg1V09rS1VQQkNqOFIxdGpQSGtNdUZDZ3hjY2JDS2lU?=
 =?utf-8?B?UHMvTzZ4TUwwTHRuYTBRUytYZW12clZORGRBQ0N3TEdmZXJoK1pDKzJzWmVV?=
 =?utf-8?B?Y2Z4SWhYVzJ2eTFPaytsQ2NLT2UxUDVCazRJZmhpcEJZZjFyVkJqS3lJRDU0?=
 =?utf-8?B?V1FWREhpb2ZTdGZZaEZNVnF2QnpQS2cycnljUHBvaWNxR0Y5cVEwSzFyN1pv?=
 =?utf-8?B?TWJMVmNyYUZ1V3hYQnNVcSt4anBZVi80ZjIveVorRXlOSnJjRktwZjJWeFdY?=
 =?utf-8?B?TTFDZ1hmM1FlVDQ0cTQ2ZnVZMFZRUE5SRWpFUy90U2hjTjNtc3Z0ZVVvcXdT?=
 =?utf-8?B?TVFhQlE3LzVSRjBsKzV4Mzh6QUttWkhpVjlBYWNZRk5nNjI2YnhlYWIrbzNM?=
 =?utf-8?B?RjlZNllGclZpT1NHYnI1TW1iRmdrK2NtVzNLQU5tVjdTYjR4enJUZjd4cUtY?=
 =?utf-8?B?NnVYQ0UyU25LUFhSZTI2R1M4WDhlUXFFNC96cGtHUmhhVjlvTVRyZURyNWZr?=
 =?utf-8?B?MWgwRFRyQVkyOWx4QzA4VGRlaHBkQldRTFBvUHRGcGV6Ty9wWFNhdEl5T2ZR?=
 =?utf-8?B?dTRZcjRNcWozYVBJYS9JSGRabzF6bzh6L1p0YlFURWFiNWhRM1Q2SzJRTWNM?=
 =?utf-8?B?VFJlMzhNYUMxWnEzMEc5Z0VRMzl6S202UzZQdU14Ry91QXpTQjZKYmQ3QzJ0?=
 =?utf-8?B?VzkxNlBRZGt4UVIyeU9jT3ZsVmxTRGxaL2FaSm8vMkg1SDdKRmx0bkk3bUo3?=
 =?utf-8?B?bGZYNWNxU0ZqYWJHZThQdHA2RDV1Q0FYNHExTGpibEFmdGg5SVpWbE9XZHdj?=
 =?utf-8?B?ckRqb1ZrQzg0K3Z2eVJnYkkxc0VtZnBMODZoczlZNnUrOHpWWFVSaVQzZ0NK?=
 =?utf-8?B?dE5ZbFVnSTRTZkVFN2VTYm1VeFlPQkRsYzNpSml0cHlrY0l2QzgyMk9KT2hx?=
 =?utf-8?B?elFDVlRuRElsUGM4ZGxlZm1ObE1JRVNHQlF5emJiRExpb29ybGhJVmp5M21G?=
 =?utf-8?B?Ri9mbG9ueXcra0JPT1RwY2c5M3JKZldCa2FRUVJtWVJoaHJJZEt2eHN0emxE?=
 =?utf-8?B?R2V2SVMyRTFyWFF4TmMrQ0tNaE8vWm4ybWxQbXJsU0tTMVB1dWxQRXY5UWoy?=
 =?utf-8?B?b3Buam9ZMXNKRThXejd6TGYveU5rZWZLdVAxNWVGYlRBMTlKMS9ZOCtoeVgv?=
 =?utf-8?B?RHVEZ09rSDhIdTZUU0pDVFJJZ0owbXpkYThZbGRuck4xRk9GRWU1clZ6RDQy?=
 =?utf-8?B?NjdBZmhRZ0ZBZjM4VklKQnpiZ2NhTWR6S2dzQVJQRmRneFlxcmlmZUYxWVhn?=
 =?utf-8?B?Mi81eXh4YVZQRWhURkZEeW9kUGw2RkorR05DT2wyZWZWVzZpSVFVbnBOZlJH?=
 =?utf-8?B?alM0dlROUXZyU01QMHMrTlRONG9QWUd0ekFLS0ZjUjEvZTFJbk1hcldnT1hk?=
 =?utf-8?B?QVVPNHErU1JyOHQ2bFBQWHNFQlJrYmlZSXdaQzdZWTJzTmx1Nk9oaHh6L1dN?=
 =?utf-8?B?VzJURy91SzROYmxCMnd3UitNYjZpM2g5c1liQlZxV0doZW1TUFFYdVV4RlhW?=
 =?utf-8?B?RVBoOElKOHFEM3RHZThkM0xIeENva3JlZjJkeFViTk14YkVmTmtyaE5JZ2ox?=
 =?utf-8?B?LzNrY3MxdTZJSm90d1ZzbGRFK0tab0w5bCszM2xXOUNVRUFyZkFTdHBVL0s0?=
 =?utf-8?B?M25VWm0wQlFPUUxGMFNwZUJNYVRSMG1Fb0ZIV3hjc0dETUNWc1JNTW1TSTVB?=
 =?utf-8?B?MEt2bkRyQkx1a1RuRjMzY2J1RGloWERoRU5wZVNUdGNPbGh6WFNNNi9HTDVX?=
 =?utf-8?B?Tmx6NVk2UWdwMUdKZzJjdkFaMFJaR21vU0tuZjNLTVZCRytCQXlUVDBPd3NY?=
 =?utf-8?B?eUpxNkRsNnRqbHF3Q3p4bE1qY1Q1d0tERFZMOHJBZ1ZTQUo1ZE1WRFRyZVpn?=
 =?utf-8?B?RTk2dnpQN0VKTkN0TEwraU5HWlhhQ3RxZE1OYmxXL2tEbU9qdVEyNmt4SmJh?=
 =?utf-8?B?RHQ2Mm1GT2lmbS9PU05jM1RZOXh6ZjU3ZU1pdkdnd3BvS1ZvdE5WYzdhbTNU?=
 =?utf-8?Q?MM90=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA6PR08MB10163.namprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48efd44d-980b-42f3-eb0f-08dcf849afcf
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2024 18:44:14.5472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UQ7aTrWc2wls0nUiW9q5slw94vF0nnirhFdsB+pR3s5NOmF4H0CVcLs2fRXAfvNbRaRPJ7a6Gv0Ffr2X2Jv1Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR08MB8512

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCYXJ0IFZhbiBBc3NjaGUgPGJ2
YW5hc3NjaGVAYWNtLm9yZz4NCj4gU2VudDogRGllbnN0YWcsIDI5LiBPa3RvYmVyIDIwMjQgMTc6
NTcNCj4gVG86IEJlYW4gSHVvIDxodW9iZWFuQGdtYWlsLmNvbT47IEh1YW4gVGFuZyA8dGFuZ2h1
YW5Adml2by5jb20+DQo+IENjOiBCZWFuIEh1byA8YmVhbmh1b0BtaWNyb24uY29tPjsgY2FuZ0Bx
dGkucXVhbGNvbW0uY29tOyBsaW51eC0NCj4gc2NzaUB2Z2VyLmtlcm5lbC5vcmc7IG9wZW5zb3Vy
Y2Uua2VybmVsQHZpdm8uY29tOyByaWNoYXJkcEBxdWljaW5jLmNvbTsNCj4gbHVob25nZmVpQHZp
dm8uY29tDQo+IFN1YmplY3Q6IFJlOiBbRVhUXSBSZTogW1BBVENIIHYyXSB1ZnM6IGNvcmU6IEFk
ZCBXQiBidWZmZXIgcmVzaXplIHN1cHBvcnQNCj4gDQo+IENBVVRJT046IEVYVEVSTkFMIEVNQUlM
LiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91DQo+IHJl
Y29nbml6ZSB0aGUgc2VuZGVyIGFuZCB3ZXJlIGV4cGVjdGluZyB0aGlzIG1lc3NhZ2UuDQo+IA0K
PiANCj4gT24gMTAvMjkvMjQgNjoxOCBBTSwgQmVhbiBIdW8gd3JvdGU6DQo+ID4gSSBzZWUsIGVh
c3lzaGFyZSBpcyBhIGNhc2UsIGJ1dCB3ZSBoYXZlIGludGVyZmFjZSB3aGljaCBhbGxvd3MgdXNl
ciB0bw0KPiA+IGNvbmZpZ3VyZSBVRlMgYXR0cmlidXRlcywgc3VjaCBhcyB1ZnMtYnNnLCB5b3Ug
Y2FuIHVzZSB0aGlzIGludGVyZmFjZQ0KPiA+IHRvIGFjaGlldmUgdGhpcyBpbiB5b3VyIGFwcGxp
Y2F0aW9uIGVhc2lseSwgcmlnaHQ/DQo+IA0KPiB1ZnMtYnNnIHNob3VsZCBub3QgYmUgc3VnZ2Vz
dGVkIGFzIGFuIGFsdGVybmF0aXZlIGZvciBhIHN5c2ZzIGludGVyZmFjZSBzaW5jZSB0aGUNCj4g
YnNnIGludGVyZmFjZSBieXBhc3NlcyBhIHNpZ25pZmljYW50IGFtb3VudCBvZiBsb2dpYyBpbiB0
aGUgVUZTIGNvcmUgZHJpdmVyDQo+IChjbG9jayBzY2FsaW5nLCBjbG9jayBnYXRpbmcsIC4uLiku
DQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0KDQoNCkhpIEJhcnQsDQoNClRoYW5rIHlvdSBm
b3IgeW91ciBmZWVkYmFjay4gVGhhdCdzIGdvb2QgcG9pbnQuIEJ1dCBJIGRpZG4ndCBvYnNlcnZl
IHRoZSB1ZnMtYnNnIHBhdGggYnlwYXNzaW5nIGNvcmUgbG9naWMgc3VjaCBhcyBjbG9jayBzY2Fs
aW5nIGFuZCBjbG9jayBnYXRpbmcuIEhvd2V2ZXIsIEkgbWlnaHQgYmUgbWlzdGFrZW4uIA0KDQpG
cm9tIG15IHVuZGVyc3RhbmRpbmcsIGNoYW5naW5nIGNlcnRhaW4gYXR0cmlidXRlcyBjYW4gaW5k
ZWVkIGJ5cGFzcyB0aGUgVUZTIGRyaXZlciB0cmFja2luZy4gQnV0IGluIHRoaXMgcGFydGljdWxh
ciBwYXRjaCwgdGhlcmUgaXMgbm8gcGFyYW1ldGVyIG9yIGZsYWcgYXNzb2NpYXRlZCB0aGF0IGlz
IHRyYWNrZWQgYnkgdGhlIFVGUyBkcml2ZXIuDQoNCkJlc3QgcmVnYXJkcywNCkJlYW4NCg==
