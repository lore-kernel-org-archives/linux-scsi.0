Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F144A279334
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2025 06:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765954757; cv=fail; b=nus27TyIsrd0ysy7OVXV2vhH3uhB63j2po5UuSwWIryjg4MIihbUobn+7nknKqo3q254BQDW8XLOnIF/1P+orZWv9y+g79W37WhRocuhMAw2s24THEB9LM5sRILk9Z6hKNAWedCXTlFvbXUxpKNYKzZJ7qKQLatxy/bZwpvZrUQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765954757; c=relaxed/simple;
	bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=B3j2qEVp1CY9U+IblrdgjbfdJkj4Rzt1grsFZcP8dVkSHVTFOUfS6SemieWR3LrZvAuZEk4sSCqK1R+t4syJBx5bMXm5qdnydYpAhYKns3ZgRxuZjYX8SnLQoKoFSP2nv+EkTE6joZM05cf2OJFoiiD4O9bntjP+6A5xZ8zv2w4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=HV2je6XH; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=gdS64Qbc; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HV2je6XH";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="gdS64Qbc"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1765954754; x=1797490754;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
  b=HV2je6XHH5f1JgmDJO/pfI/o/xjplhXkBKsU4izttHwpWr7yJ/rmwwhf
   w+aSwp0KyEXNtOC87ZPEa7Al0yjbrzpSWZU0eiQy65R57R1qaW6XnrEWK
   vyHgCfR08S/HUwKZsDOXeOmiQRUVTu+z8RS0AQLQqcjyxlP+2Jqmu+hx7
   o6RsqAfzxlJo+pwmEdM7T9kOLBS61WxNwP4gsh5wyWpo1Ch4mL7hPjxeG
   GUI+pLvIKSnmV5DgXzG7hXcbSJsDMUlCxZOesftyXLHOU6RwT2SZjFEgE
   9YqqIrqoGyzz9/7vf33+vj75q4/VChymuJ30mH2g7brnPr7fTjDlHNODw
   Q==;
X-CSE-ConnectionGUID: PYX0xP+kSS+IZgsIJMiE8w==
X-CSE-MsgGUID: Hg5A02uJRAq4+dXlgUxAHA==
X-IronPort-AV: E=Sophos;i="6.21,155,1763395200"; 
   d="scan'208";a="136672354"
Received: from mail-westus3azon11012000.outbound.protection.outlook.com (HELO PH8PR06CU001.outbound.protection.outlook.com) ([40.107.209.0])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Dec 2025 14:59:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dCu7NMBmICdZLanC4tE+aoDYRmQ6yUn4Yb3O4GyhhRGc7Ap03ok0Rw4AUzNErhNwj2NYC/XwvZkMUpZDd7QjW1n+SIu5HCkFv+g46y0S5ftzP8sXGDKbjJsWu4o6Kf5I7+SdAN6j0MW+j46ldh/2xL/H1ac9A+qHeDVgUP2y0Fe57j3r8a2AG5IGqruYU34DOJSd4euig8DO4PUdm/tBkqJiF7YJQ6PjhWQW99mXie+xpK/i4O0n7sJEHRAZbI5Ox4F7W5YxiVYuf9qLtJVHdpeTIt2ouP9NwI0d5xOF5q1pyEiObysuhgQg8jCLqMfVGjUe8PqulXdF0NB5B/nSvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
 b=Cqv4UR84W4Rv2i0lNTYaTqqWAnpytne/+TIdx/sOr5o9hP9qIdBD7pB2xRES2LdXGTaYgwtyK5IHgci8uaowOj3gGQE12xR78QQ+jwoRq8+qYd2U6t0U9GCgmmGXvc7alWB9K4Y2wZudCV488NqWDU3RTbmeKzH5D6QpmTdBn2aamanyNu+Zu1yA5afxeN1qa8cGnPDmYoACJUIUMAam6WwobrmP4PwqA/a+h/xff93HIjwmDTS4+fj7gmyg19VKAJM/aN+Lko1WbaDBZh8xv2d1JgssI7TA/uR/sA0MpEYUkuQ/q36cgPOlrJbXjSFd28PORI+AcAvvCWeiRlsyQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
 b=gdS64QbcPGagj9xggbv1Mxx3PzqEnJ1R8QH8zaQtdNEiCk8/XojTNEHjXcXD8oFNeekEr1x6U2GObp00joJfNWcI58vaenwrdIYTp/CYm6dteQBbJEEKuxjTIdXh8pwonq4YiIXlcV+ByvR/15jy33jDWRnUzupQ1eYlFNbQgcY=
Received: from LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13)
 by CH2PR04MB6934.namprd04.prod.outlook.com (2603:10b6:610:9a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 06:59:13 +0000
Received: from LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::9ba6:7273:90bc:53a8]) by LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::9ba6:7273:90bc:53a8%5]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 06:59:13 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Damien Le Moal
	<dlemoal@kernel.org>, Himanshu Madhani <himanshu.madhani@oracle.com>, "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v4 5/5] scsi: sd: Do not split error messages
Thread-Topic: [PATCH v4 5/5] scsi: sd: Do not split error messages
Thread-Index: AQHcbtAdF3cbboJRNESwYsHz8YXHHLUlZ6sA
Date: Wed, 17 Dec 2025 06:59:13 +0000
Message-ID: <2c49d568-e8c2-44aa-b85b-ecb49406a976@wdc.com>
References: <20251216210719.57256-1-bvanassche@acm.org>
 <20251216210719.57256-6-bvanassche@acm.org>
In-Reply-To: <20251216210719.57256-6-bvanassche@acm.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR04MB8984:EE_|CH2PR04MB6934:EE_
x-ms-office365-filtering-correlation-id: 94cc40d5-e77c-49b7-eb58-08de3d39c93c
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|376014|366016|10070799003|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?NW55NS90Z2ltcmw5WnBIMVplNzh0N2lLMXcxLyswS1VLYWcxTWJsQlZsMGFs?=
 =?utf-8?B?aStFNnc1Zzhhb3FkME1IQVhuYjlGUk9rV3pEdC9YdzRvV3FHMlNxSlRkNzNw?=
 =?utf-8?B?YmRoYjZmUkRMSTdjWVJBeE12YitXU1UwQmptZVhTWEcvTmZ0RlRpd2J0bEtE?=
 =?utf-8?B?c24xbFlHUkNIUElVNVdjUzJ5aW9uL0IySm5QZU5YejR6OWdNS3FJSGZKemh6?=
 =?utf-8?B?bGNReEp5QUNNUEc0ZUlNYWdFMTF4TVNLL2oyWUxwbS8vVVBCUTh2dkpVUWRF?=
 =?utf-8?B?cGpheDBOeVZRODVmeW05SmlDRFQwRDdESENUMEVlMkdZdmxzYlFGTUVHTURn?=
 =?utf-8?B?TTBTbFQveGsvNWp0RGtGdWh2azFHODJRZ1VLSDNCR001TG1ZeVJkbzQ3Q1JO?=
 =?utf-8?B?bzdHL3ltRWdDUUhqQUw4QzFHYjZ0RU1zRUN1emJBMzh3ejlheXdXemhSaERv?=
 =?utf-8?B?YVJQVGJwVFgrd0VSZkJkcTE1bjRSWDFNMTlyZG90QmlRVUUrWWV0YnNyelgz?=
 =?utf-8?B?M3Z2WllDRzBXZ1dIcWlVc0dzTytObG96NEtkczlLTVhyS3ZRTXh5RWd1blVD?=
 =?utf-8?B?QURId0NGRk8zN3lwRmJ0RkM3SVQ2cmxWeGdLbXFXcG8wcGljY3B1SldRWElT?=
 =?utf-8?B?WmNjOFZWK1Fvakg0SkRrRVlMeVhvb2VLWi9wazVONVpnenFvS3VQdXNneEdB?=
 =?utf-8?B?SEd0d3V1SnlRTVFWUEtpNHVKdXV3NWFnVXlUcENGaVlDejA1OUgrRFVwaWVU?=
 =?utf-8?B?Qy94cmVRU0NadUU3enE2MlNzNkg2Q0RKWlk5cXJvUU84TG0rWkRlMFl6YUVh?=
 =?utf-8?B?K1cxd1gxOWs1N3JFYWJoemxSTFc3N2xoM0l2aDBvQUdwd2pMTU5aM01IMUVi?=
 =?utf-8?B?RmdVQVdCVVZlUUU0UnlldEkwMExESklGY0thS01BQlBMV3ZhNzk4RmN6YmZ2?=
 =?utf-8?B?VGVra2pVdUxtQzhRdytEa28rZFlMKzF3U3RQYlJTQytFdlJCaWVWd1I3Wmla?=
 =?utf-8?B?WmtCMWoycDVWeXhqbE40Rlk3N0NrRVRKVkhGUnMzUnIrK0lZQlBjcDYrRnR3?=
 =?utf-8?B?aVM1QXFnYTNVVlZQeFgvN01XeTE3aFZjandGZExmb0lxQllVN2NPL1BOejNj?=
 =?utf-8?B?TlY5aDR5akhpS1k4T3IxS3REcDg5MWpZblN5RlduZ3RhZysrVnRZL1Yrb1lp?=
 =?utf-8?B?T3BoSTBHdlNPTTZvMnNTL0E4ejI0dXk5L0JaR2NkUkVMdDExRGgxaWQ4emNZ?=
 =?utf-8?B?NXFoTndXSnFxcFY0NUxFbUtUUFJaWkRpd1hHSjkxNG5jQXpmeWJOb05XN2tq?=
 =?utf-8?B?eWhIaXpPcXZQd0tRb1Z2cjc1RUluTlB4Y05LVU9PSkxLejlsb0lscjI3T2Fr?=
 =?utf-8?B?OHV0aGVqaWg2WnFpM0E2V3B3YnJHVkpvczJza0lSNlQwTzlKRStwOTcvZXhw?=
 =?utf-8?B?bzVLYnJqVTRmQXBucHVSNXFvclFqaml2Y1Q2RnErRkY5TDd2eFgxMFVuTnM5?=
 =?utf-8?B?b2lEUGQvUkhIZVlFaEUvZ0NFT3hsajhFbEhsbCtIeFhpNFgycWJHMmh2c1RO?=
 =?utf-8?B?d0Y4UmRlTzh3Qk5CL0RueG8vRmFOTlZVdHFXY0ZyVTJsTDJLQVJFZDZqUXZL?=
 =?utf-8?B?OE41Y1o0SkROUVdtQjF6NTJDSUpieSsvUE9sd0pBYWdOOG9EVmtxcEJrcGV2?=
 =?utf-8?B?NHY3SDdKdGVMc0lJZnRNQTh6QmFLTy9YWm42Ymgzd2w5WGlnWVZ6Uzg4MSs4?=
 =?utf-8?B?RW93bUExYjhZbzRISWVzdGptbHZCQ2tGWmdTbWNsZlY0T2ZKd3BZTllXamFE?=
 =?utf-8?B?R2NxMlpPYyswOHhicTNDaCs2b3hiMFNZYTlNK0RJSFNpMk5tZjNrRk5VOHNP?=
 =?utf-8?B?MkVTbFlHWU1aaVZJbmNpRTN3QnlRSFJFZTVDVTNWeUlvdlNJdG5hRVNrTDZQ?=
 =?utf-8?B?ajR6V2k1clBRbWFkejhEQjk4T0tyRCtQQ1VrRWVkbnVrSE5YK1VRVDdSYmRu?=
 =?utf-8?B?K3MvSzJoMkZqWlQrZTVZS0l5QXRvczIvcUlPalVQT0VxNFFyaWQzQjBkL3Y1?=
 =?utf-8?Q?Mm6xs8?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB8984.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(366016)(10070799003)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UVhyK1V5clFBNWJ6cEdRSG1SWHNTVjgxUlROaHg4QnJTdkhnQjNKWE8xcGhp?=
 =?utf-8?B?TmdVekdaR3BqdUdURTJENDR2U1c2bldhRkZ6dWh5UEtveTRyY0hhTDJXc3FZ?=
 =?utf-8?B?RisrVE5zOWJHN1RBMDhHbXdDSEZXT1BpS1FMU21GdWFGUVdvZVRwcnBCSU5j?=
 =?utf-8?B?NDluRlY0NjBHOUtuWlR6TzM2b2F0VStLMTE4cFZGYis1WGl6QWpvL2p1R2RR?=
 =?utf-8?B?a3R4c0cycWJEYjdBMUxQUGVTZUs1SWdNVzB5QTRScVpYSDQyeHVkL0pjVXRj?=
 =?utf-8?B?VGNjVVhkT3JkaUsvQStRU3B6bFlzYmQ2c0ZqUWlVUytBay9QTlhWZG45VVM4?=
 =?utf-8?B?TzhyVE01S05TbGVERHFRbFNCeGVuSXFmajhkeTAxTW96eXYrWlRQc09NUTI2?=
 =?utf-8?B?QVJYb3BuR3BwWDdsUUppVUdrTy9OV0VXY0Jlb2pkY1Jyd0dSMDZUdDVOWkZG?=
 =?utf-8?B?Q056Ylo0elFrc29ORXl3MEpaOEFiRC93bGhNUDRsY0VBVkxjcVFEbHZRbjd3?=
 =?utf-8?B?Tmg3VHlxT29iYmZJSkZJM2hNd25zL1hUTXBJYktCb0dLdGE1WC9VUmgvTFJ5?=
 =?utf-8?B?bkxSWDl3RU01RWozNmErZ1A0a1RjZG0rTGk0K1ZDb1MyRUdmYkJNblJYMFc3?=
 =?utf-8?B?cXJ0Q1ZEVS9aS0UwUHc2cFNNZ3ZaNitDMkplUno4M244dEZ3NWN1UWJHeTRS?=
 =?utf-8?B?ZlRkSXppVXlPMyt4dzFWRjF0d0xMeTYwT3R6YmFWRnF0alN2Zm5oUmVHOXUw?=
 =?utf-8?B?M3o3aGM2Wm8rMU9rdjF4ZHg5dEpBR1dydkE0WmtKbExwNnZ1eE9HcXBaYnlk?=
 =?utf-8?B?WTRvajBUVEkzUmhWanlsY0JjaUZqV3RVaTlJOUdvUDdiM1pOMG1hY21TeXFw?=
 =?utf-8?B?ZjNzOGFzVHZ1R0tqU2FJeEZVbGdKNUlCU2NLYkk2OFRhN2NNaCtidHBFQTdt?=
 =?utf-8?B?Mm9HR3VLeGtNeHJaZUN4YzlJREpjVExjY0RhRVhRUEVFK0Z6bXpzS1IwQ1du?=
 =?utf-8?B?NEk0UFRZb1FIdjQ1a3JEYkVwNC9Vc01FaTArNDNwNFFTZDRiU0pBTE5WK1pv?=
 =?utf-8?B?NDl4UFBoS2tBYXp6bTJJVEtqOGN0Y1J6TWlBdTN3SVhiQXJURWZOR24zT0Fl?=
 =?utf-8?B?Qmw5UGhsU2EvSGZ6QXFPWjY0Vmt0anJUVHd1anJvRFNPNGROV3l5WkVVK2E2?=
 =?utf-8?B?TFpZS3VCMzlQUVc4SjhldUt5M09NeDdXUDl1ZXVRYThLMXJFREZ2QXMxN1hP?=
 =?utf-8?B?bmJXM3hCSHA2N2k2RWFKZ1hhejBiQjFONTV0OXdCVkNTM3VsaXpNZGJKd01t?=
 =?utf-8?B?b1ZSdXJvOTZZZFVrQlBpMHlRNXJMVVdzQVJDVVZLMVViMW9oc2VleG5ha3FW?=
 =?utf-8?B?QWo0Q3hJQi9UMU9uVXd2ZjBNelFId2g0UFNqTW9LZnB6MWhKK3hpSmVzZ1FL?=
 =?utf-8?B?MTMwN1V1K1hsWVQ2SjA4NFMwSU91ZUdxNWp1RndwcnBjYTVmMnpPemtRdWpW?=
 =?utf-8?B?UTFWaUJyMzRNSjk2a1ovdVVCNE4zZDAxS3laenF4eXFkVTZObTZzNVMrVDZ5?=
 =?utf-8?B?Q0NUb0NjT2hScCtMOXhjNUM1bjNMVlo1Tyt3NHROK2hOYWtXbjFybzhFZkN3?=
 =?utf-8?B?K3lJSVZEbnNBRG1OV2FVbndoTnF5WnEwQlBHWTlldXRQazdYRDNaeEw5aEdO?=
 =?utf-8?B?RVplcVN1ait4Q1Q5bGd4RmF5UDFXc014MHVzRnNrR25TVXNBSUd4bGgyRmkv?=
 =?utf-8?B?ZWErNXJSQVlyOXNQNG5Kbi9DWEJCbWJuNlNuUmdtUE1iclBpelViSUM5VCtZ?=
 =?utf-8?B?TE0yOGZha1VyVDJmRlMraXZFQnVHTFJMbVhwbHBKL3drS1dCd0dmOUFDSmFU?=
 =?utf-8?B?Rkk5RndoK1p3U1g4ZXlJZEV3RmlqMUtuS2IvcVhuWTliTmEyOUFhYWZhaG5n?=
 =?utf-8?B?SGw3NlBpSnNONjlZSHJSbzBoS3RiN2Q1RjFwdDlwazduNndFSW04SVZvYmIy?=
 =?utf-8?B?UFBGQUZPV3Fla2RvUUx1MVJUQTdQallMQzlSUEtYaHhmcUVEeXVwcVJjMEFS?=
 =?utf-8?B?eWZVam1ndzNicUlhVWJDWXRVODJoWDNXWXlTMnJHb0l1TWJLREdHWkNiTGs2?=
 =?utf-8?B?UFAzNVFrWlVSdjFud1dLRG1UQnhhMUxEUGM5MXBVUzlXalBiOHp2VUdBVVNK?=
 =?utf-8?B?dUhaWHhzcGp5ZnNOaUhpYzF3RGJCQ2w1SzUvNldCR3hmVEdCQ1JDOE1oL3kv?=
 =?utf-8?B?b2NvbVE2K1NEblhxZ2hCYnpjTU13PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5B960035061F86439BF6479C792848C2@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qdXl3KUIyJP4UD8oXJ/THOeOC87pgk1SwlDEi5lAn4GnLm8Yfx71iLf9xc0NIj2UFOKtKu7hP+azIF9x3HSJ9VfMiQr0FJYCMj2iFvnVG9RlWQSnVbVf7PRhHWNsJyIl0e0575sKOS9sdJV7VbipzFKB7qDoGAbtVjxyCy9+R4ZsJsnmFbsDKRMO5gx+eWwSwWiR5AAu0204bn+mdl5X7SGIaD2FMvT/Ou657+mO3Lmawd8wkuRnsOWrH8c69m8NaLF/9aHzh7DkgbTh4W3TrX3Ph7Qkc9KGm2s8yKkBM3Z7viXG8+klCqsg/s619TP7urSkSNeM/4LTewegtoVW96jByCuj3oUGWcz7abP+kFtJKx8PLwf+Rx2HM4SyXZPy9/Exd5wuDiO8+daTzZxp3PpxMiQ0P9fYCdwu4vG083dfvR3NQ8DmuRQzTjT9MNr3VqL+3nwHgMXFOQNh0VBbIfbFq2cOzo5UDVtLIZedBsh6+2q3d6aMmPdUwx5/EMUoccQsBEBXC7ilQdH1ZZNJAd8UEFj/AfONDlkuBVcG4isG1po+Hl81XrVBGdFdVNMlnKNTFXwx1Ac3klzFhI0H24CcDCinwZXQSqbeQfYPU7xnTtTgq5nuh5b83Q+XgdUS
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94cc40d5-e77c-49b7-eb58-08de3d39c93c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2025 06:59:13.1745
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8xiIuDtkVBpmFq8OIr3oL/J8XMqcgjeEKsj6RvqEua/k/CNAt4rhVjpZPJN1ieMHuNUobRoTaEj7E2H3zN/S5jOHe8MbovQdc/aU/MSiPgw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6934

TG9va3MgZ29vZCwNCg0KUmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMu
dGh1bXNoaXJuQHdkYy5jb20+DQoNCg==
