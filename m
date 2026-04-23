Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CB4311963
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 08:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776931711; cv=fail; b=G0bfSX1ilRh34E1KIeIDoV7NecfnbCT95WVFxWVQ9qttcomHinQ0RaTYjivHEpHOD7bBvvIHKqKK26+maDy4/d7iw3x+okrQLAX7oO0Ual7zufOChXmlSgGitrS3VWhLfFNiWGyAmoHwP/77r6rp7KsfWNbOu9JpDTLfbAHZTXo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776931711; c=relaxed/simple;
	bh=IyoXoDY/9F7EjNXlC4clzg6ZeZwr+enwl4qcAX8jEzQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JxcFxXjhaMvx8NOb2z/ae8xGQJXKO0eaxhxb0FcS/+i7dCT6Wto5NUYytjaeDKlpv4YTk00/wEoZtBN3RyYKiIoWxe7xNzoKqUkOJ1D/2GH/jrNy9Yt1KZFqxwjU5hoDPJZm0F76igkJ5kRHGE23Bmlomgn+w1aQns7UItHH0Kk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=SkR5mUAN; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=YXJc0nZ8; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="SkR5mUAN";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="YXJc0nZ8"
X-UUID: 99e49fa63eeb11f19a16598d5ca7f8ec-20260423
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=IyoXoDY/9F7EjNXlC4clzg6ZeZwr+enwl4qcAX8jEzQ=;
	b=SkR5mUANNHihSdNqOXVSO2iKhhnIaOPmA7QgkObKPqm2Ir+zfBbyam37Rc4pmFDNkeZsUeCqGoTq2BtLO0mrDHmiOs10jrl7mmK5Yn2d/gVi9iqMBWHcBF9UBD10K26Gg7yYs2qOH4rcEb77PQegy0bN1IKfdr3WS8chm26SrYI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:25f97a76-24e1-4f4b-9641-e3ca5bacea57,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:0ce47c64-469e-4eb6-aeb8-4b21454b0f32,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 99e49fa63eeb11f19a16598d5ca7f8ec-20260423
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 999029095; Thu, 23 Apr 2026 16:08:24 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 23 Apr 2026 16:08:23 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 23 Apr 2026 16:08:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fESoQj4+lfbZkD5rO1Yt9uSKZf+I5I63BpULa7OmkQSoTCFtod+0YkS8mI+c3sVH+pjBMNSszu3OjjXQP7UQHHMEPmdUneANnHH7hL2FYrRdqTRLFyIZ6OIdBzImgHv9ChONlxC5U7RtK8sEHUOAy3hxMVUwpgNxAg3H5FGfNi3SZCLfXBleCEaPutYEvBanCgrNxDM3oyUpJw4sOQ5a/4l/9TBIIhmK9zh+3ZKrpHl3ZSoOozohbxnNn2Q8WQ0luCDxPs+FpQXekdKsEvZti4Ii6ucmEtuzvEk9mmwnl3u43RMEuVcGJUmDUjQYtPSQ+F7H5dWbU6xC2+H7uGHQKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IyoXoDY/9F7EjNXlC4clzg6ZeZwr+enwl4qcAX8jEzQ=;
 b=jvrJXVrqNIyP3XvD+zoFFFMA9e5C1bce9/gbFhA8gtlfy2bgAAjFFPp+cDGy9AzCZ5WtDHbTIxoylp4qrgiw4ykbynqIqBxo3KLcm5PpUVHPRlXdYy/FvDGrOQK/68VhYP47THeyUxIU5jj4YmgK1OncbLQYlCzeq1B+8ETVq1vIVboi7W0Za7+reSqWvVKgT7Gk0dryg9hkfr7rogApnxhI2hPo/TALEIDb57fFkJ4bVz+k9L50jEOXcfPnqviQmNxtd9+/hYeifsQ9yK47CXxK42Npo16DkY9thrpNFnqdadZQS1Tuu4yS5R64781slXicEfyWAKP97zaM3sH7AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IyoXoDY/9F7EjNXlC4clzg6ZeZwr+enwl4qcAX8jEzQ=;
 b=YXJc0nZ8CaiK+tXbC03ehwL/LGWbVJ8C7wNMS1qzKeI4ShBa7dV8drWYbtg+fyNkKyji8ihk1cl66dSmPl0cviklWB7M1dcUN12d6ECEhhYM/1u/eyeQqTcoAWzLz11qOZxYdmkTjrJ5gGbxZAn99Bf2KVaQQ64r4y8AIG6TTiM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KUYPR03MB10046.apcprd03.prod.outlook.com (2603:1096:d10:94::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.21; Thu, 23 Apr
 2026 08:08:21 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.20.9846.016; Thu, 23 Apr 2026
 08:08:20 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "can.guo@oss.qualcomm.com"
	<can.guo@oss.qualcomm.com>, "avri.altman@sandisk.com"
	<avri.altman@sandisk.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>
Subject: Re: [PATCH 3/3] ufs: core: Optimize ufshcd_add_uic_command_trace()
Thread-Topic: [PATCH 3/3] ufs: core: Optimize ufshcd_add_uic_command_trace()
Thread-Index: AQHczrGOUq1Ly3XnN0iBS/EhVvxRmrXpOOKAgAC2PwCAAM1rgIAAkLsAgAEGBoA=
Date: Thu, 23 Apr 2026 08:08:20 +0000
Message-ID: <5088d11b8e74995411354a18786cad7c21fc63cb.camel@mediatek.com>
References: <20260417213027.3506742-1-bvanassche@acm.org>
	 <20260417213027.3506742-4-bvanassche@acm.org>
	 <a186b02b00694be3e89cd49d477c050df4bb1cf5.camel@mediatek.com>
	 <31c4e534-80e1-455d-8057-8b71a7616de5@acm.org>
	 <24b3f4f1e6d723c6d0aa5a559fcb142b32e0c9be.camel@mediatek.com>
	 <3c5f2db7-9190-4aa3-b69b-c9dca8a2998f@acm.org>
In-Reply-To: <3c5f2db7-9190-4aa3-b69b-c9dca8a2998f@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KUYPR03MB10046:EE_
x-ms-office365-filtering-correlation-id: ea8212cc-2e54-456e-7ed4-08dea10f7bb3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|18002099003|38070700021|56012099003;
x-microsoft-antispam-message-info: bhnLfFmkPe8ARksHIC+e2KYKdzEbfZ+UC+ZVDZaOZy0rEsTnw6B37TL1dmW6c3IENdZm/xZy3gTRSulWtn5Nc/j7aSvYPEe1SAsR9/bmPQQHKsy3lfaC5RLdzMSVVFylouBNF/JY/GkfKG9GjQXpAQLU5JKvqQdO1tevetEUIiZS28SjlX//PAcEZPLXZXHDw35uhzLkc+Lffiti4yqBXVeqLtf+iZTtEuloZrwjf98FoKaXnNKWm7hgEJqS/rf3c8Ak3l6fyLpfq3e1OsarpF63sQn3ZdKqHB20/f2+ldtjkcfi88NxGkQtIz7/lDRjC1zHAujqnB87r+DWoub2uLqDwj4N6ubARA7OxOhsb7/6HbtAzIVARLzNaDnyvT//2P6oOHBmMIdnFzsdx3qIEhf8uXKwguYE+nD4f53TisRFqVTtCuMrfC8mJXvG+hO+qngeWYrvxJkFQN6qZFhfWQLLy3lOxlAaiaYPiwlpftx+XyxtgQmr+s5R56qKjSKQIt90HsSqXnnGgxJUK/w/KQJwvYHZxNIwPaWoW+lYso+5tWca2oAKguG9mxrOtYuBjJSadaMbtlGUkHuVf3JhArl/Wxj8NJ+5hwzgC/ko9T6G3NxCNpM+ItxYS8JnDZ8e+BhUQfTJ5zsNAlEJmCFVGwRk+3FdnzROHpW/vtv4IPT7pl30UnfbbrXn/QbNZxk3n6gEVzOTw5Jbs6ivIL2qsqwpOOsP/ClbU/rjs/iYhor7g59VSQ710FPfwhRbTQfApfrsL134FyM6S97r9djctYytQ9/+X/KbubpDR9JQWTk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(18002099003)(38070700021)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Yld3NVdKWHkzc3dIL3FVNXVKTGlncURONFdGM2tRNEtVYWdYQWd6MzRVY05X?=
 =?utf-8?B?M0svMkdNa2xXRDA4UUJDdmNHd21JV0hDVzBsQ3RvVnNqcUtyV0NreTFUeUs1?=
 =?utf-8?B?czM2UmRJaVNkK1NTM1dFblhHRk42b21NcWU3aVJkb0RVai92bW5zTTEvR3F0?=
 =?utf-8?B?dzZDT2UvbjNMSDVWVlo0ZjhIRTVaWmppVU5ZZXZmMHJnTDhhaTFwZWtCbEF5?=
 =?utf-8?B?REpNR1ZpUk9rdUsvUytpVEVKWjY2aVN6eGNGeTk3Wlk3RTVIZTVyTVpOckJs?=
 =?utf-8?B?WS9rUWU1ZWNVUUZEMHRZRWsyczV0d1YwQ3EwOUJ6ZUtHUGh5bURxYVBYd1lx?=
 =?utf-8?B?NURycHdHcTBHcldNME5ML1FNa3loOWVDZlh5VFdEVUdrZVZiWjBRa0J3bzFM?=
 =?utf-8?B?NUtYZ3AxUjVNZGQ2V2pYRXNaTEJVeStnaDVyWTQrbmxSVjVaWmhJRnliYVNI?=
 =?utf-8?B?U1RaUFR4aVcvajdENUZsRnFGbktkQUQzT2VadkY3bklvOWpWcVlZTmM1RzNv?=
 =?utf-8?B?SStxckM2SHR5UWpEYW5tMjRXN093dWlFTGQ3VkhHT1FRRHhscDYrbVVyTzBB?=
 =?utf-8?B?dEhKM2oyNDhLZGo3bGlUV1RXNkgxc1Jsbk5PbVJRSmFLblUySXBma09iM1Ja?=
 =?utf-8?B?cytlWTc3V3FBT1EraXlNSVNVTUdFNkx4d3Y4SFp4QzJPUXBEL0VlVkR5ZUZi?=
 =?utf-8?B?S0ZEcmN5RUNMd2ZSYnpaSGxtSGExaFFrdUc3YmdDUk1NRXJ2NGdidlNsTE4z?=
 =?utf-8?B?TDdiaENYZDJxWjRjUGl1VHp2YSsxeml1RzNVcThKWk80N0dmb0QvZHV3dlFy?=
 =?utf-8?B?ZHV3anEwOEhrczNpcG5uVWltLzVuNkRrN2NndmxGdURsQkN2eXFjOVJ2Vzdu?=
 =?utf-8?B?bkJqbzVyLzMzMjlNa0Q3QnV3enBoQVJvcnc4R0szdUJDU21UbFl1UHhuZWxV?=
 =?utf-8?B?SnhqcGp1cWFXR25NTXhHSVVpQkgyNjlrZlR6dDVZZExRNnh5c1lvQTMweEpC?=
 =?utf-8?B?VWNpbG5ldWdWRjFFc0VDK01qQ0trSWxVV2E1T0tpb1VWQi9yaDZuZ2t3V0FH?=
 =?utf-8?B?aXBXNzhSbVBzTytQTFM1SDh6blYxdDBGYWJCYnFxRFdBY09ERlNXY2tkdUhV?=
 =?utf-8?B?WTlWRFNDK0J5enZpNzBEWWgzeWFheE8vc2JtVDhPMGJ0ZThkMWpyMU1PYXhp?=
 =?utf-8?B?ZXlHT0g2UTNKYzU5Znd1dUxxRjRIYmQ4aTFnTHlxNXhreHFpSDZVc2U5OXk3?=
 =?utf-8?B?ck80UFBiWGVqdmwzclVDNTlTMk5hbzBrWmJES0lreXhJOVFxM05YQnpOWFMz?=
 =?utf-8?B?bnZDMGQ4QVI3L2V4eHlIaktiMlhmWi8xSnhjd3ZIK3NqMzUzcjZKdUNBdXJi?=
 =?utf-8?B?ZThPMzB3N3c1aFF1OFJhVWYyS3VSZEFSdHpLdzVvZW5LTmgzMDhpM3FzUGJJ?=
 =?utf-8?B?ZmsrWUVibXIwRWY1aDNDOXRRdm1ETjNMVk1lcHVjamtLSGg3VTVEVmJXN3Zj?=
 =?utf-8?B?Y2xESFdXL0poT1pKOGJBQW5abmlaOCtRcHpFY244MnJiWEljU0hwczRwakk2?=
 =?utf-8?B?ZGpYcWNnSDFWa0pWWTdESzF2bjU2aXdoUGVqWU9hTVJrbExvUlFPanF6RUhs?=
 =?utf-8?B?VVY5WG1UcDd6RWswODYwenJIcWVjcmp2V2NwWU1WMERIL29DMVJjVVRaRkpG?=
 =?utf-8?B?b0RKZGFUNnM0VkxYbytQb2I1ekdQSGZWOGU4NytXVVc5cmtFWEkyaFdDdGlJ?=
 =?utf-8?B?MFc3ZG9jbmFIVElXVEhBVEsyUjdIZ1hudnFndW5yVFQzOVFUQ2l0aXVJdHBR?=
 =?utf-8?B?SUpxazRoSk1vUUQ3NkxHaHRFaURpYXRyWkNRd2RxOVFOd0t1cmV4THNIeFRK?=
 =?utf-8?B?SE9RdGYrTzc0TDdwUldMQ2dtcGkxUXNjd3lBWXN3UzgxMjA0L2ZEdFZhUUx2?=
 =?utf-8?B?Wkp0OVlnNWZZckloUUxsM2tmL2JEZXJCZy9qRDdKSE5KckcveC9OZ2dHbVZW?=
 =?utf-8?B?UCt2K25xUEVLd2pQZG1OYlZZbkxNOVVrKzVxVGZSaFc5Ym53Y3AzMUhFa2dl?=
 =?utf-8?B?eE5zNk0wRDF4WDRyVE52c2ZRWUFvQ3JEY0xqNWxkeXNlYWpOSy8vem9aRk9t?=
 =?utf-8?B?anZXVVd3aGltOUVBMTl0Q3NqNXlDYUFZWVBZa3lsTnBjTkUra3dVOHB6UGNt?=
 =?utf-8?B?RTlYOUt1elpjVUR2bXA3LzRVQzM3cnEzVXVSOENkNVJDVFJjS0pvZk15bjJh?=
 =?utf-8?B?T3NFYkdqcW5wU0tnUWVCM1phSEdEOXhWL0l2UVlZM1hRM0U4bUZIaVcxcVdI?=
 =?utf-8?B?SW10L0tmOUZ1QUtsci9DYVM0bllNMUNDNXZHN2RGMm54WitQbUpWdHljczNW?=
 =?utf-8?Q?HS7KznlGV0VxHX+g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E77553B14B6FF4DADFD4886652FA8BD@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: pwjZj4Hc/nA3wYXrTF9+/JvwOhRS610k1Kn3j0CcdYq2UmT4qV6R+2RNlvsPSWRMnqkr2Gv/fAbSQ20byd2CNh1dPiL4qmCHfV0QvtTFPIgoKSnmAw8g1RLhHRaUBN3QwesOQ0fdRqfMRqzv7Mk3vhPUiI4yg41AAuRcsLHnrtpQy3ZUoz90hMZ1XOo4wLTtZoDHzr1yLFMBuVrLom1uoLRs3BtaWIh5lmpSuIIbMJa2tB4dXUpJ/zpPIvpZtQ+L4IreIUjqi2K7YZtTrTUz25QnSd5QkkiHINZe2ZS6mwcB23UBRDr1o3k6F4EBy7J37DtiHSCh35HuQwbJB8pHbg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea8212cc-2e54-456e-7ed4-08dea10f7bb3
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2026 08:08:20.4937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m5NkuR2D4Mv95nN58iObM36CPX/iJAkBDzWSqj2+nfnIxHd7P+3Fch63YqDw0YwX9TQBm2MqFuwY3yNf+spF2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUYPR03MB10046
X-MTK: N

T24gV2VkLCAyMDI2LTA0LTIyIGF0IDA5OjMwIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
Cj4gSGkgUGV0ZXIsCj4gCj4gSSBoYXZlIHN0YXJ0ZWQgdGVzdGluZyB0aGUgcGF0Y2ggYmVsb3cu
IFRoaXMgcGF0Y2ggaXMgaW50ZW5kZWQgYXMgYQo+IHJlcGxhY2VtZW50IGZvciBwYXRjaCAzLzMg
aW4gdGhpcyBzZXJpZXM6Cj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNk
LmMgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jCj4gaW5kZXggYTQ0ZWY3ZTk3MTI1Li43NjQx
NmVlODhiMjUgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYwo+ICsrKyBi
L2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMKPiBAQCAtNDYwLDIwICs0NjAsMTkgQEAgc3RhdGlj
IHZvaWQgdWZzaGNkX2FkZF91aWNfY29tbWFuZF90cmFjZShzdHJ1Y3QKPiB1ZnNfaGJhICpoYmEs
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY29uc3Qgc3RydWN0IHVpY19jb21tYW5kCj4gKnVj
bWQsCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZW51bSB1ZnNfdHJhY2Vfc3RyX3Qgc3RyX3Qp
Cj4gwqAgewo+IC3CoMKgwqDCoMKgwqAgdTMyIGNtZDsKPiAtCj4gwqDCoMKgwqDCoMKgwqAgaWYg
KCF0cmFjZV91ZnNoY2RfdWljX2NvbW1hbmRfZW5hYmxlZCgpKQo+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCByZXR1cm47Cj4gCj4gwqDCoMKgwqDCoMKgwqAgaWYgKHN0cl90ID09IFVG
U19DTURfU0VORCkKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjbWQgPSB1Y21kLT5j
b21tYW5kOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHRyYWNlX3Vmc2hjZF91aWNf
Y29tbWFuZChoYmEsIHN0cl90LCB1Y21kLT5jb21tYW5kLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgdWNtZC0+YXJndW1lbnQxLCB1Y21kLQo+ID5hcmd1bWVudDIsCj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCB1Y21kLT5hcmd1bWVudDMpOwo+IMKgwqDCoMKgwqDCoMKgIGVsc2UKPiAtwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjbWQgPSB1ZnNoY2RfcmVhZGwoaGJhLCBSRUdfVUlDX0NP
TU1BTkQpOwo+IC0KPiAtwqDCoMKgwqDCoMKgIHRyYWNlX3Vmc2hjZF91aWNfY29tbWFuZChoYmEs
IHN0cl90LCBjbWQsCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHVmc2hjZF9yZWFkbChoYmEsCj4gUkVHX1VJQ19DT01NQU5E
X0FSR18xKSwKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgdWZzaGNkX3JlYWRsKGhiYSwKPiBSRUdfVUlDX0NPTU1BTkRfQVJH
XzIpLAo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCB1ZnNoY2RfcmVhZGwoaGJhLAo+IFJFR19VSUNfQ09NTUFORF9BUkdfMykp
Owo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHRyYWNlX3Vmc2hjZF91aWNfY29tbWFu
ZCgKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaGJhLCBz
dHJfdCwgdWZzaGNkX3JlYWRsKGhiYSwKPiBSRUdfVUlDX0NPTU1BTkQpLAo+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1ZnNoY2RfcmVhZGwoaGJhLCBSRUdf
VUlDX0NPTU1BTkRfQVJHXzEpLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCB1ZnNoY2RfcmVhZGwoaGJhLCBSRUdfVUlDX0NPTU1BTkRfQVJHXzIpLAo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1ZnNoY2RfcmVhZGwo
aGJhLCBSRUdfVUlDX0NPTU1BTkRfQVJHXzMpKTsKPiDCoCB9Cj4gCj4gwqAgc3RhdGljIHZvaWQg
dWZzaGNkX2FkZF9jb21tYW5kX3RyYWNlKHN0cnVjdCB1ZnNfaGJhICpoYmEsIHN0cnVjdAo+IHNj
c2lfY21uZCAqY21kLAo+IAoKSGkgQmFydCwKClRoaXMgcGF0Y2ggbG9va3MgZ29vZCB0byBtZS4K
ClRoYW5rcwpQZXRlcgoKCg==
