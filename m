Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA48257440
	for <linux-scsi@vger.kernel.org>; Fri,  6 Jun 2025 06:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749192195; cv=fail; b=RHN3eSoB/UEgQoTxQITJod5ZdU5PDodDk05tEkobN0B+i28A+ai52PQd3UPE14ZkAmWzNtO9RvCYONm8Ije6lkuL8Av+/b+uBIqxl/gNCFzE538FfcJPGTpYURHAY2ravYZo/pStNDIHHFZptfSVN1hjKUd2SA22DhUvt536oFc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749192195; c=relaxed/simple;
	bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u3LHicGhB21N2HT0aHci5kcx+wsa3mJ9PSKexl6qRKvWGh/agWMiEiqQYIOUS+aC4xMgfxUQMBV+QKoTWYzrcnDxXOvmXoq4VFfNXNU0mGMs5xI51RAqDPMfpq6MZNgolWPW8PwmH6bJ89dO1Yt2bgd/YlM9SUQ4i8XiL0FP4Gk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=WYub85rq; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=y3Hudxvv; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="WYub85rq";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="y3Hudxvv"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1749192194; x=1780728194;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=WYub85rqsKUJX7svsACdEYTRUafrTtXhY7E2f1yAyetiBwRe2OLpxwan
   DkqsO9MKkKQ+hHmXAn+irm24049tbWSCmAjSxdNjm0gepoHKOUAUsbrU3
   X9FgZlwPXgJDGq/Khmt2lijow14WAV0K04D7XL0mYYCFaljUx55L5V+Ce
   BvMRvdQwRf7vVbm66m0jLoC2N1SM5ErZvpWLKu+Nrq6RE5iUK0n649kHZ
   7rO/RP2vjNqn0kSJBEEeRKILefvAdzdtc0tI0BNMhAtzAO7z7iIuyMHJ0
   XnWDbjxFC2WLo4i3MyJmXa0zRNTJbCsyZRw5sO+T+48ngrKgRzwQg6cBB
   g==;
X-CSE-ConnectionGUID: pPqpwkYtRXOTXoKJOq8QjQ==
X-CSE-MsgGUID: 7oNULrq1T/KNwwt3aP6wBA==
X-IronPort-AV: E=Sophos;i="6.16,214,1744041600"; 
   d="scan'208";a="84850769"
Received: from mail-bn8nam11on2079.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([40.107.236.79])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jun 2025 14:43:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZZBEfiDeV3JbXa5kYzB9CkTwwYjoMQjAjj6DFK2YURsJfmQ/B4ofEh0CpPXiWbLY94sGwzZzGaQ8lYy3RDq7VmkG/B3OYQmHmp5J6GjSqBVrNmaoxU6AoKRbcHQkmyhB0raph+NId6VCueCT8uA9UBiz5XOR4nvgf3pz3XfWgDpGlopisV2NQ7T8a15hOe7AIO6PdtKo6AgUmhcpRC6c6mUuv7H6EqqdFeERZANJVxv7AwelSEihPv470S/B4FcYZidAtBo7s2ffhUX6I1wOrLQEKzShsGOobw1aeko/oDU/TH+pD5yqxNWW3dDWXnHsPc5ujVZL5xiDz/atf4QCnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=u9umBlt0hjx4Xq1qfh5GmN6w9H9Vsb74dbPpDerPIG7nBsDLVo304ae9rxEeEdfhLzPeSE/5+0KKAfHTqx7QF7xF0BEKsdKKyMidquh7wwGAAT8mvTZPAi4YpXaPhoJIjKjOMCO1RNqDK+XPKIGeF0mV1HXJ5OK2/wRFCqu8czJ7a6mBQJ4DoNIZ9BZiHQYo1GgXeszogzZn12O1uyzhmHRf65I8Wlz8TmLu3E4KzuSC7qdlhKhL6yboW4wUw8lUE6mKPCeKfhRCre/PIzTa1l2YTFxigLVl3BxZ8G5oHt+sr8QUqXATaQ9SJDHPJXTa5T0wdryenYiCuHvQfHCH7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=y3HudxvvM/CtG4ytgirIiIjLd1hqEAIVyMVfcTW4QbAViCIJqwV4FHNZIqjUcSUlMnzgE1X8hUhEQSjiE2iGUmA7B5RJyTJ6koIrfI+t5jGHWDDgoykY1rKs7+x8Svcbrqh2CcHXass+FWisun9xdDIcc88pMB9n1799qWuC/k4=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CO6PR04MB7716.namprd04.prod.outlook.com (2603:10b6:303:aa::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Fri, 6 Jun
 2025 06:43:10 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%6]) with mapi id 15.20.8792.034; Fri, 6 Jun 2025
 06:43:10 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: Remember if a device is an ATA device
Thread-Topic: [PATCH] scsi: Remember if a device is an ATA device
Thread-Index: AQHb1qQgQp8du4S0u06XRoUwZ7uF9bP1rz+A
Date: Fri, 6 Jun 2025 06:43:10 +0000
Message-ID: <94ef809e-b650-41c6-b4c5-d4879b23530d@wdc.com>
References: <20250606052844.746754-1-dlemoal@kernel.org>
In-Reply-To: <20250606052844.746754-1-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|CO6PR04MB7716:EE_
x-ms-office365-filtering-correlation-id: 35300c7c-dd03-4698-f00f-08dda4c56720
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|10070799003|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?c21iNW95R3d5dXZZdnNnZHFJc0pyQXkydHRFTWtYZXV2azVacW9XSXpiOE5S?=
 =?utf-8?B?N2dOTGl4dFE3dllqdWRDU3VKNDM2OUFucEJrYlZRbFEyOW1IWFg4OUY2UFIy?=
 =?utf-8?B?UC9sNUtLQk9GeDR4T2RMbmlHVDhzeWRUQWREa1Btc2lVNXdaNzc4ZTVrQ0l1?=
 =?utf-8?B?QmVIcjdEbDFwUkwxN1FHQlZDd1RLQXFWQWZnNk9RMndQaDY5emJHeWFRSUdY?=
 =?utf-8?B?elNYQ3ZzUUIrZ2Fqd0hrZEtLSUVMOWV5UW5ldWxWQjBNeHViRjJYUkNzTVho?=
 =?utf-8?B?ZVBnUmYxYi9Zb0J2WmttdkkxaFBneU9OOWl2bnkyaEFRWjRqSGRsZTRBQXd6?=
 =?utf-8?B?NGxGSXRaZmZYaEUxZlFYaVVyOGt1ZzZZb1I3K0NrdU1idUdlV3o4M05PRUIr?=
 =?utf-8?B?S1IrQi90Tmh4N3FaQkNOQkg5YUtjKzBQU2c3dk96SnBEUkV6cWhjaHFSTjZC?=
 =?utf-8?B?cmhMaFV5NVUyWWdyTmk2a1pyTTl1VmVWY05iQUh3d214KzR3VnR3aEhlQW9D?=
 =?utf-8?B?aVNmeThOYjJ3czNUZjZxZ09YcGk0V3lob0NpTkRrdHJzVlE5NUdvcGJmQ1M0?=
 =?utf-8?B?RUppbDNLR3dUbkE1TktXUmE1OXU1S2hwNFdFVEE2WnJWQ283Q3dtaldRckpq?=
 =?utf-8?B?ZWhMWkpmYVdkM1hjZ2taRS9vaG8zdUd6eXMyVkJ3SDJETFpRMUIzZEhEUWpN?=
 =?utf-8?B?Y2RHbXpyQWRRSEZmVTdlN29VUS9uRW50ZEdCUXFuTGFWZjdzak83bnFhS0hL?=
 =?utf-8?B?UEQ0K29hNmJndVV0V2xMdndmbnRMcUV2WEZZcWZBUVJuL3pXUGtmcFVOb0th?=
 =?utf-8?B?cXVQWlZtekhBUnlIcytPY2pyUzNpRHJubmFRQmV4Mk1iR05hVCtxOGpCeEU3?=
 =?utf-8?B?WXFGRVZTYkNhZlhlNlU3OHhPSGNQM2c2Zzk3YlhsWUNOSGk3OHlaN0RQYkRD?=
 =?utf-8?B?ZmF0Zjd3WXNhRlI2UXlPd3BJOCs3aUxtdkJYY3RKVS9DVGYvVlc0dEpIZCti?=
 =?utf-8?B?aDREMFU5WVptR0VHeWFIbEMwSDRTRzFZeFlmQkIvMVI3dmp6eFE0QWFuVmNo?=
 =?utf-8?B?WVRCa3RNdUlvd0xpb0dITXdlR2pHeGIvL09KeGRFSmJsbnduVWtUUlAwSVFD?=
 =?utf-8?B?R2xpRG9UUk8wTHJweUNlOG5iWjZwZ0ZEVWFXMXdBY3oxS3hDYndGRXhESytO?=
 =?utf-8?B?V3BxWC9ZaDJtUXBNaUJkSzdhbG1FMnVDdWVicVZ1c3N0NUtucDJEdEIrMlRr?=
 =?utf-8?B?Q1B0SURwM2g4b0tnWm5zQ1JrTkFPQU9jbEc1bXVXU3hhbzhqMHVJTTFLRFhE?=
 =?utf-8?B?VmU0RVN2dGYzZ0hHTnppMGNOYW5oVXlvaXhxeS9jRkhTd3h4dXFrbVVzNEdV?=
 =?utf-8?B?amxPVHM4WmF2Z3RJQThMS0R2UUphT3VxSjFtQ25SdVNsd0pwQU5LOVJpREtp?=
 =?utf-8?B?b3NHZ1BoenpCS3B1MlA4N2F1aEpRclN5LytoWG1XT3FzL3FEeklxclRJdU9C?=
 =?utf-8?B?VCtUbVU0bzRQN1RnS3hVVWFuMzJLZ3JwTm5CcFNTekk2QUx5MURLaVhJeEtW?=
 =?utf-8?B?NFBpMWxrTFFOZWtibTgrM1dqemx3ZXkraDlidHFjY09rMEFvaW5XTndXNTVr?=
 =?utf-8?B?elNXWENubFZLM3pnajE4RWNOMVZqOFlYeFVBcnJ5aVFoaUdVUG55NUJFM3FG?=
 =?utf-8?B?UkZtQ2hRME5JbVlqRDJpUGU1MlZkb0FMTzkxa2VvTWlrOGpxT2VwMTBZOVY3?=
 =?utf-8?B?MjU3dmplOVhyZ21iM0xDakxybnV0Y0pVcTBOalNmVlFtTlhNZUgzeVBIdk0v?=
 =?utf-8?B?RDhwOUM0WUZWY3hxZFlOUzN0MzRiZFNlUThFZmxHY0NQblZ0a3prMEZ4ZWRZ?=
 =?utf-8?B?VjNsVWVJd2RxVHhVT080S1RsQkZ5cHFtTVI1RU5rclkxcHovcWZZNUI3czhi?=
 =?utf-8?B?OHZPYlBYai9TTEcrT0JiSXNYUlhpa29tbHRkenJFcStNYjFydVpjaWlYL0JQ?=
 =?utf-8?Q?R8+JnFkb9iH0PFudvLq6lz+51CIDYg=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OExPL0J4aGtKZzByT0NvUXZjbXdpODZ0dmFTWkJvZGVqZW4yVjlDZllvb2I2?=
 =?utf-8?B?MnVxUC9GSzR0L1U4ZlFDOGNGN3NQcUtqWXRJWlVnNEVEZUQ2cGN2UE9pS0RF?=
 =?utf-8?B?QjhsVllhV2RPZkRBa3J1NGxLUXJpRElKUXBSOWVOZGFXVnhTTE1ZYzZVaGky?=
 =?utf-8?B?bmtwVVQ3QjZIZkVlRFoweUJGWExBckRoVzZSWVRaRmVtTFYrc3FaNGhXdEJv?=
 =?utf-8?B?SUwrcnhCc1ZJc3lkRXdvaEwzK0V6eDJoendhYWllTFlQT3MvckV1aXFVSncz?=
 =?utf-8?B?K3g1eitLTG83QW5rN2FIR29UbXljRWFFaHhmcWdaOHdBRkxHU1VSQjJpYXJR?=
 =?utf-8?B?Sm91RlZMamYybmc0ZUYwMTNRS3l0UnpxQW55QmJtQTVVc0FaR004OVFvU1VP?=
 =?utf-8?B?NEhpaW94UzhpY21YVmZYNTRaSzdJWmVKQzJQTERibU41Q1R5UUJmcVEzV3dh?=
 =?utf-8?B?b015alhuSHpTVFY3YVkzWkNiTTRiYnAxZDNTaDdGd3hGRFRTYU1hR2RZSVBR?=
 =?utf-8?B?b2pqdjl1Q3pGZk1aN0dzelc1UGpLWFNlWnZ1L0NXTkxIQ3g4bTJvdG1DSWo3?=
 =?utf-8?B?dG5BTWwrUlp5Mk4renNUM1Uzc1hhMUowRGV2Z3pteDZielhQb29WbjR3TzFQ?=
 =?utf-8?B?cmJhSFQrcVZEQVJ2Q1loSTNhWGNiWHpRdWtFN0RQVkxxNkV1enl2MUdzcGZn?=
 =?utf-8?B?amFMUTByMHRBTW9wSmtTSnFiMjdEbERFWWV3eFFzOXZyaXFZbG9ISnVDNmJn?=
 =?utf-8?B?VXNxd1FTd0hTUTlNUUhzVG9CV2hlRXJicVJsczNkWER4a05ZNFY2VWdhd1hO?=
 =?utf-8?B?cEt3d3BVMWxZejdCT3NXaDVTZ2ZnZUFsMkFFM003aFZtcGJxaGR2T2JXTSt1?=
 =?utf-8?B?RTZGa0YyenExZGhWeW0rQVFYeFBMZkJkZHJuMm8xYzNuWWlWOE80dFNKZmlM?=
 =?utf-8?B?RmJPK1hyckRPcExTSUJHVkc1VWFYY1NSYTFQOEZlbGZ5KzNPVDhxUDV4VlhS?=
 =?utf-8?B?Q0tZeFVkVlNTRVhxQTFKL2g2SWxMRWJ6RGhqZW1McjhmN0NnZVVzcnhvTkVH?=
 =?utf-8?B?Mk5FRXBKSFcxZTUrczVQcTg1dngydmVGVi9KbC96cXJsS083T2FlcG84YVVI?=
 =?utf-8?B?RmdqUGtMbnpycFlWS3BEbVB0ZjNmdWhTNWtRQk5UZHo2NWd0RTRlVlBNTndM?=
 =?utf-8?B?b1JWVVh0WHoxY1ZUMUxnUDdkZXZSTjc1TzMvLzJ6UTVmQ05nRkdEekltaXRw?=
 =?utf-8?B?VmdZZ09mNWFJUGNxUVR2MGdWaTJnc0FLN2VURlV0RjVqNEdhRTB1MXJZQloy?=
 =?utf-8?B?RzRSbUNJVTNjWGVNYy9kVUFObmRFSjJzeTRRQ3Vja3ZJUVpqQ0diSENFNGRW?=
 =?utf-8?B?QjJlTjU3UHgyTy9rSHBQVDV3dlIzNzV2QS9uL3AxUEhyU3p3a21JdGNYU2hs?=
 =?utf-8?B?Vm5GR1ROcEdubXE3bnh3b0ZBb0FWSHdTTVdNRVF2cnZ1cVlMWTdiaVd2RVdk?=
 =?utf-8?B?U3U2VlMremNXNDVmZDduV1V5SkdDV0xLNlQ2akJRaGZ0M2xFblVjLzZUeXRX?=
 =?utf-8?B?MVlpNldoY2JiWVkzK3dYWjFrRzlPWFZYUnVuSEt5dWRwUk55NHlnNzFvYjRG?=
 =?utf-8?B?UXVjN0l1bDQwZGxyV1p6Y2Z3V1dZMHZlZnlVV0xwbWFVYWQrR2IyMmlzRWtI?=
 =?utf-8?B?c1NlZkdBZ2l0VGVpWG9ybUEvRlBHWjRxQzJGRTcrYXNQNTJWWkZDOTNTWVRV?=
 =?utf-8?B?SmF4bmlOL0ZsRy9OMEFGUVV0ZkpCSzBNWmlRSExWaEdlZmVMR2JrcEUvM0ZR?=
 =?utf-8?B?UzNYY0RCMVl3cWpJMzR3SnZCVzBxcTRVNURueTlzOStIZTRxZEZ3ZDhQU0xv?=
 =?utf-8?B?aVRPSG5Mc0pHOThOb3JNcWJjMmxiTjVhKzd0ZldGWHNKUnlxVnpHWUd0MXlj?=
 =?utf-8?B?MlNUMmVGdVZiUlBnWXlweTM1MFBzL1BBdGlPMytncEtSN3lJTzJzcDVSbSt2?=
 =?utf-8?B?MkdpZFptT3Q1NHRoOUZzcWFKZEo3YVhjRk5KQUZMb3JRT1ptNFk1cTc3bm9M?=
 =?utf-8?B?V3hRNXlyY2t0NUxtVjROLzYrbnU4dlJrODdCdU5yUkpCZjJyb2FLbG5Sbzc4?=
 =?utf-8?B?YmpsWWE5ZGlBQnVLZVUzUlR6ZytRd0NxMEZBUUNkY2VSandUNUhXVEJnRFRB?=
 =?utf-8?B?SWt5T1FmYjA3VmtrRko5ckRreXpkNnlQS2ZXWEJ6TFZiWE5md2xaMXRBeGda?=
 =?utf-8?B?MHlVT0tSQlJVUmFGS2xrcEduZ3p3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8787D2A48819BD48A523706B84D46D14@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Frqpk3PT9iWAEYY6X8AoATEpyUzmC+sMKNoYsOsAmVDLNZgYPNrtw8vsB2yb9ii/69zQxalHOCyOM045UFxDOmf/MvllqfYn82lfQaq8uwIKED+frpCBxbcBLcqG6I30F6WK8HW1nDQkVgnxe3D0B03UrYYwY2ZIIW0pwjVfRZn8P6C42vCxh6FkvWZ9+H7BpF/fnI/D2HlUB9QkhcFa5jdAzXgvPVcLSKnXcFK8ihStiYZcT4a/PMRv0e4QbPVaL2EPnNRI98o7vMQ14rY8NvZMJgYka4DpGPhtTWepSh8sZ4KkBgbA7qR9tgiacKoYS0RsRQISrCrCjYb9DI4E7J1Rnc8luQvPyG8eCf2dU0ngRDodjnbo0k209niksmgTi4OdDVWwujevZhrFhtaZasGPEdzLZXefRShIppUVsUIRjmyHeHj/7DWZBfJAUJOTzHJ6DcFu8gGMr4WrsIUCRYhKI4HwcN12lRqQdBTa2sNlxkxlBf1v59b/OKJdGxVPWNcpnjGW5j5sMvjh4q4tF11cVWtCFjgaHV5UvPENlhnhj4+/cRLUez1yPxl08NyCfRtKD6c1xURm8BkLFB65De9IUmWU7K00/2KBoNR+6CkLf+FVfcV19c/ZSHJ1tVC/
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35300c7c-dd03-4698-f00f-08dda4c56720
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2025 06:43:10.1857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pRSpjZiirbUTNJV353z7idcrIsMDBx4QQ1i1h6msXgXlZsQ7ceXHF5kFpen9ZWwhwMFyTJMSz3sXg2cpKPJKahQfMoFa+X1a7TAL6p9Kst0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7716

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
