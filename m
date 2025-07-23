Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF1225A2A4
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 06:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753251307; cv=fail; b=msef1Fskns00/DP64uwjzhgtj8nUlt4CFxDy9gM6lqO9RHAQwB4K3GV7LVviq4YQgK7gcQumNMnmmDKEH7lzTYbIBmTCHVstNR2EUklc47MqN8Z/71J5hXETLS7C+XINiBkWyvqxKdI5fImRHFK/wMGImPJEyhKgqwzZejZMY+Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753251307; c=relaxed/simple;
	bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=F3vSKuXyqSKSqXbuGTTfX2YqioV+s64E9Th6JEwvZGJZ6WhOfzEolP2GPTfTStcWZilAzkXPdE5O0xw96DK6jXmNFZyQWn3nmzjqxie6sZib1nLsz0upNUAW2V8W00N2wytcS6yBlCkTjMpsQFNVQ/j746xTWLzQF1Xa2eXGi20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=r5eQGl+Y; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=t5iyHRRw; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="r5eQGl+Y";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="t5iyHRRw"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1753251305; x=1784787305;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=r5eQGl+YedhFKrsrKVe40v+dxNtH37QoOfVTdAfDB/Zc/fyiL3XqGDsA
   p5shmWXvF2XllNokfLlXmLFRIlMLTe2Nk7OjqFXZUr9zH9LX4pk/HeuuR
   HKJMcuS5a2Um2c3/k4JDVKI4cyd0NFXqYBGxJXyDsY0TZUsa+L9uCEEUr
   W+F38PBgRyzuSQaxqpFVpoVUlR9RzGWb0qoD0QLMOxGqWPmQaPjYLtJOE
   yw619yA2VEncDAakcb7od8J2Nnwt4B1QYf/TswFSfdbmJL28NSDsYJkGT
   CgZZFzPnVwpR7RSTAQqhSr04aGXwJkeupeS0fFurU+P6jeUG1olTpKP7n
   Q==;
X-CSE-ConnectionGUID: aIU9BiEpS4q/pTPpRAWlOg==
X-CSE-MsgGUID: WksJ3HnfRhaIBXPID/rrFQ==
X-IronPort-AV: E=Sophos;i="6.16,333,1744041600"; 
   d="scan'208";a="95068417"
Received: from mail-bn8nam11on2048.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([40.107.236.48])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jul 2025 14:15:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iRW+X6nUGZIn9xVnlHRVMCdL7MyD0qKd4HXmU//HAcBa7fs/BWvZSNtzs3Q80S8VFceHFQMQ6LFJAPrJSHsMx9CfsCuaEC47d/wARYqSDXtO5d2bzn8E22sG5SQSXag0BspI+/+3aD6SAZUNhVFg0SQY/Gn/bmo0QllOBNal1FaiOTvYPX8vxcXPvMiYWiDathOKGaAu3axTSBcvj35rz0IuNSfp78l3RHReW89PId2I6M1mbCwXQjrNRchC5rgKeT1zLPp5X9wVTzn0g8FXV4P5eAi8TmpqJXGTq/67dBo8pmEcfhxqbM0KJxWaCXNHnD0Yz0qxASEmR7CelVdPIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=vzu4eOPSgBGqdb3s6kFFKlko9vYVyhad5Qf/5jyiFSdoMPRt1k32BkRoKh1UJeSzxa/fpnLCK12vq6Fwi+e1NEadGAe3nNLGkXfTzpDDo1Ok5eouFOVzXbCzfZLorHXVxCwUP94+hw2kxbqLSOiwcuXs83OTMBuFUr055bO3OAqxwEzo8tF8JeDL/ouL60Zk31IwqBZyirzNO97Xt3z1g+Va8C81cbqG0W/Hw397O2Ef3eXx5Qvqya97QgPKJllHhFnkbFw9bGkEeS4TNkR/jFU35ClG+h3j1A3nT91ze6jQd48aDe9N0HtfHEyiE3h6p97W8Xbd5uZ+evtWC/wl7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=t5iyHRRwAJN8Cp4jnPfxKJqFAhoKLEEmFPp9hCe4fvAen4PPY2F3E4T9gWn/WfOYJOG7p4Q4oeSIpDCwCFHEagRqWY4bFpKo7GjRbVBmB+ODqjGw/tNwzAyzu0CopN/fPke2Uhne3kUwTGsLR89falUXslm+Qky4ERjw8/jJIMM=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SN7PR04MB8642.namprd04.prod.outlook.com (2603:10b6:806:2ed::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.29; Wed, 23 Jul
 2025 06:15:03 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%4]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 06:15:03 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH 4/4] scsi: libsas: Use a bool for sas_deform_port() second
 argument
Thread-Topic: [PATCH 4/4] scsi: libsas: Use a bool for sas_deform_port()
 second argument
Thread-Index: AQHb+5SCg1U13jJWHkaVfTkFG3KwerQ/OxYA
Date: Wed, 23 Jul 2025 06:15:03 +0000
Message-ID: <f4351a85-ecbe-4201-89d9-51248495ff4e@wdc.com>
References: <20250723053903.49413-1-dlemoal@kernel.org>
 <20250723053903.49413-5-dlemoal@kernel.org>
In-Reply-To: <20250723053903.49413-5-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SN7PR04MB8642:EE_
x-ms-office365-filtering-correlation-id: 6706485c-a2b8-4ada-9490-08ddc9b04306
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|19092799006|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?dUphOE1FUzNFUDZlNU5KdkI5TlNTMFNMYXBQQ3dqdzRIY21BMVpsUWUxNVJq?=
 =?utf-8?B?ZldmR1JZWEJobDZjSzdUTTFWR0hZVmwzMTBTVGQyUm8ra0ZXMDhlWXZ3SWV3?=
 =?utf-8?B?VSthY25vK3MrSXJXeU9UMm5xUGQzMzdaRDd2aWlnMlU5VDRyVkpaMkZ0R3lD?=
 =?utf-8?B?RG9QZzdJWkNLcjUzTTFnUnpzUDNhMW12b3BKaVJpc2FrM0xDcjV2Rjl1QlFt?=
 =?utf-8?B?N255OEtRQVozNFRaRkVaYmJMZ0FyMjlHRXJkczNxcHFKU2tFN0E3amxyTUN4?=
 =?utf-8?B?UGhSK24zUGF5S3VNMnllZVlCUDlHUWJJWTVaQUtpQVFUQkRUM0Q3THlGa3cz?=
 =?utf-8?B?c3Ixdlp0ODVTZ2ZCUkNNODZYNlNSSkloT3RSbVFtd0lKbndCbVpubWZ3RFhC?=
 =?utf-8?B?ancwYSt3TEl1cmNSNnc5OTFyOU8zZjZFbThiSFYyenJTVGlLbWJMbnJ3Yll1?=
 =?utf-8?B?STRJa3JFSlp2RUdNK1VvemQwTUh6MWo2UXZrTFFxak5sTlJYU2MxaTBMVDJj?=
 =?utf-8?B?NkJmTDJpeitaVEM0QlpYeXhZZEVWcUF5clRnNDZxcytEUGMxZ3R0M0tZdUYw?=
 =?utf-8?B?Qzcra25KZ1FMWllMM01uUmdTRDNsUjM2UGtwVHZZQnk2ZHR0Vm50clY5YWMr?=
 =?utf-8?B?N0NqYmxESXFEK1NSYWtiSjhSMVRmWFUxTGZwMm10YjhWLzNmeWZNUVhQYmQ4?=
 =?utf-8?B?ZnVnSngyQ1kzbXQ4dzdiN3RyUW13MjdzUms3bk9OZi9HS0FqRFdDUTlIUDZq?=
 =?utf-8?B?dWkwUHNlMWJPSnZoSG1Rd0dGdFJVdkZjVHZWbFRSNnpjVGUxWG5YUkswNzVK?=
 =?utf-8?B?RG1tdjRmZldPVk9lQWFLMFdNbzl4d0FaQTIzRUZISHU2UHBNNldXck9Sd3Nq?=
 =?utf-8?B?Q0hTQXhqWDNvNmc1d2ZUTzZ6SmxPY2tmRXI3MW9HZEVkUzdiVXZGM3NqWGZz?=
 =?utf-8?B?elZaYlFWRlhtWlA2bCt0enpQK2NqWW9CRTJ4NldnUnR1Ly9MVDJ3Q3RxZFNh?=
 =?utf-8?B?YmtKb09aalkwWjNISFNzVjdQT1Y1YkhydW1paDQ0eUtDZkJIUHgwWU1iYjVI?=
 =?utf-8?B?V3lpdDRONzNZV25wVHZKbVVnOVZnZVBKeWlGTGpjbnBtM2ZTRW9XVCtPL1hT?=
 =?utf-8?B?Y3ZlaGN2YkpQMmVvT3UyV05DUk5LUEVJTVU4bXE4bzVWczFXS2F4dTJJTmVm?=
 =?utf-8?B?RDd1UWoxN0x2ZUdIVzB2S2NvVXl3TXVwZ0hqY0lEWE50TVNXTUV0ZXMybkpr?=
 =?utf-8?B?WGJKdEdhQ1UvRzg4ejJQMUtCQmp1eEh5U3lKQXhmYVduaFZrcHhpUm1acVRq?=
 =?utf-8?B?QjJqUVNiSHE0SVpHM2IxWHZOckxSL2RqOG1zSkxUcm9YMEVvWTRvU244em8z?=
 =?utf-8?B?VUtocmU4MG94V3EzOVV1QnNSeXBoUnM0OG1reXBmb01lOUlXV0FnQTZSZUhV?=
 =?utf-8?B?N2dTREwxRlBKTDF0WHB3NE9aVkVzTlh3NFh2NkZQWGpnRlFBdmJEbENJTUJQ?=
 =?utf-8?B?K2dqd2MwNFc5anpWWGU5R0VKcDZMMFE5U2RlaWdOVkJLdzhmazRqQ1lWVDk2?=
 =?utf-8?B?OEo4c202RWhORHJ6UVF2UXdFSTJBUkhNVDY3TEhYbW1KaXFTaWhjZjZpaERp?=
 =?utf-8?B?ZTZlbE1DT3JXcWJlMHNGd2tvNVNRK3g5ZG9UQVBKKzFqQkpFZDMwUEpTbXhK?=
 =?utf-8?B?S3Q1ejUvbEtzUkIvWlQyblVKbDlycDlDNVNOb2NDZjNuVm5rQXZ6a3Y2MUxv?=
 =?utf-8?B?Uzl0M0J5UVdqdUErOFRjVlFPNktsR1RNYjhoRUcvVUlEVWJ0aHZuczJKOVZj?=
 =?utf-8?B?L1VzZXBZVEZBUlFyZENJNTlMaXgrV1IraXQ4VXc5dkN2bGtaQ2s2ZHpNSHdt?=
 =?utf-8?B?VGNCSktKR3MxbHpvaktVSGs0TVp0aFA2cm8yMW5CaVAzdnlGOGFZc21hdE5O?=
 =?utf-8?B?YlkzK09tNmdVakJTRnhwcEZoYTUwNVNvd2preEI3VGFaSys4UGxycXh4ZzVL?=
 =?utf-8?B?ZnQrR1pZbmxnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?c3N0citGM1JFb20weVNFZmYwdzAzOTk1SW9wUFl4c2JkQ3VCb3VqRGJ1UWtv?=
 =?utf-8?B?cVlVSll1YmN0d0U2VnlzdFNrOEh0NXRmTGRtbkF4YXo0MEpIbFFuNGUycUdJ?=
 =?utf-8?B?dlBiRnU5RGtsY1AvTmcxNzZRREJZTlhKQkNuRWMxUFpXbTRkUy9YeXhkWk5R?=
 =?utf-8?B?WjZDWkNaaVg0VFh4cnJZc080Q2xIS211cDAxaGh1T3VWdFUzRS93ZVR1VGo2?=
 =?utf-8?B?RjRjbXVZTnhGWU0rTnM2S1ZJL29ZeExIR3pMYU9JUVNxOWR1eWlGcFpuUmIw?=
 =?utf-8?B?ZklScSsxdHdMUUdjTmVQRS9la1VCWDdpODdWcU1kdEpYdXJ1MGpmZ3B5QnZH?=
 =?utf-8?B?empIYmJldS8vS2dkaHpZWGw2TEpQTFFQT25xY2hwTmJkNDR1eXd4NFV3NnRu?=
 =?utf-8?B?dUhpVWNkZy82YUxEMkNKL2IzRkhPUDVyd1prWkdtVVBGZVhhaEduR2hHK3B6?=
 =?utf-8?B?NmNxN25ER3Y1K3ptUFJiQzhDOU9BQkhreGJteG5mVngrSjJ3WmNWeXJVMUkv?=
 =?utf-8?B?VjRiOCs4STBxbnlBQzExRkRDdkdHRFJIVm44S2luZ1RjK3B6aUhCSGFGOTRI?=
 =?utf-8?B?UnZ4NU5XaXZPdXhSNUlMWGNodFJ5aUt5VmpDQ1loek1XcUdpUmFkRGlzRHVE?=
 =?utf-8?B?VXBRV0dFYXYva2dobkNRZStYUmhhMUozRjlYeUZnai9NaGc1TTFCMkxDS29t?=
 =?utf-8?B?YmFRaVNkelJ1Qjk5UHN2LzRmR0NwS0svME1iQnlhblJqNExnM3B1QnhzSXY2?=
 =?utf-8?B?V1VLV2h2c1JZOWZYUTZ6dHlwZGl6SzhFRWNWRjVMeXMwSlVmU2FuZ3JJa1Iy?=
 =?utf-8?B?UDR1eGZwM0xBSExVRmZ0QURnRWMxZjBXK25ETWNpTGZUS2dOdlpPOFNqWWRx?=
 =?utf-8?B?eGZSQTQzUjQ2SU4vL1h0RFZzOXlha3VOZGFEL2V1Q0FTMkRndVZmTzBmVWlO?=
 =?utf-8?B?NlNaYnBOeHgzKzd0NEpRVkcwM3dGdVlMelZZTWc5b3VBUEhoVTkvaHNjZjdB?=
 =?utf-8?B?WU5hMjlmUXZpRzN0ajBFa0x5THk3bzRLZ2ErZFovN2ovSG1BU0ZJOUtPcGMx?=
 =?utf-8?B?NndrSE1mQ0lTWmNjZmdYTmRXZWJTZmM4eVFWbkd2clV4a2ZOSWFlRk9ORHZq?=
 =?utf-8?B?RVFsakVvaFlLVUU4ZWNGeVU2WEhqU3kwemJMQ3BpWUhYVWdOUGlzdnRLQ01U?=
 =?utf-8?B?ZTZGUVNkaG5nVFFkZVoweG9lYlBtMGc1TXFWQVk2U3h6NUNoVWJONEtPNzJY?=
 =?utf-8?B?bWx4enBkNnc0bXZOaEFrWVlsUWRCU0RReHNaZXNqbE9teVRCeXJnRzc3aStV?=
 =?utf-8?B?RnlJaUsyM2VzY1F2UXFxZ1d0c3Q5UTlMTjB1aDVGOGFCZGdnRnYycklldnJ3?=
 =?utf-8?B?c2JVWE9QMWNpV0hYU2hiMERPcmpWbHhvSndBRGpoL3ppNFNWcm1hR0xaMko2?=
 =?utf-8?B?WENhOUxKTy8yMnJLZHN1UUgyRFB5d3RyVlN3V2lRbEw0cFdvNCtrRFI4QlJP?=
 =?utf-8?B?U3pFTW1kQVlqMkJBZzFXWVZLU3E0eHRWMlRnUjNkbmdzWmNGMkk5UldHQ2sz?=
 =?utf-8?B?eWxzR1lLeUkyT3QvMXlVYnFuL1JjU0IrUzVGZnUxcnVHbFdORTl6bFVUaDNn?=
 =?utf-8?B?Q0Zzemgwc09mZndpeEtDekV2L29VTDJxdm80cW1xTVgreGhYV1k5R3hmM04v?=
 =?utf-8?B?SGZ0ZHZzSDNRZzhJeUJGYzhBeEZmY1NvTU9FUkxDL1QxZmlWekY0bjNHOTZO?=
 =?utf-8?B?cnZRSC8rT1lqZWxUZy92M2ZUTmkwUU1zbWVKWFBoeWx4R0JVT2NTZVBZQjlO?=
 =?utf-8?B?c3o4ZlFGbzN4VXlTelduL29tbEhmUWVIT0x6eDJrOHdjTm1KdzE2blMwWWor?=
 =?utf-8?B?N01XWVJvcmp6ZG5QTHpiMXY3RlhPMDBCSlRqQjkvYXBmVG9CbzJxV2dmelZ5?=
 =?utf-8?B?Yjh5b0RaWk05WHZ2YXZBM2R5eGNVbHk2SHdrQ3p5RzI3UFJUemV2TkxhNERW?=
 =?utf-8?B?bmFJamFFdjYwKy9yZTdaTys1N3VIcksyVkZOcXhRYWp2cTl0NnE1UXd0alMx?=
 =?utf-8?B?NkZtOGNMU0U0SDZuaU5vOEljc0JwOVYwQmhvOXRoY3BvbGtHczZHRGgyZFh2?=
 =?utf-8?B?T0RqZDlaRHJFU2NtdmVhSjhKWU84c1NwOFErVXhqL0FwNGFHVXA3SU8vTnZi?=
 =?utf-8?B?NWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9F8D364995733D4BBD688B7759299E8C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RcZQH4uM0K2bcU/oV4GPy8XVzBs/TAXAOPa5TWSCfSrIMq6ShC0Buz5/Hh4e5jb29s55zB/2XQXlvOlpBUpB7aDLWVvpf6eEilI9975nvL5ZLofdByJ1Lk/7ace/Dg/28dQ6F3EKnaOSsPfQYE0Gk90I7piHXEWUzTI2ycb9Br/fJzzoL45jg4+p5OwUoWNP3hOw+ZbililOGbKQ0FTW2b+vk9+UizeqjjIPkLklbujiymJss/UEHo+9srg3N5NxEBFLeTJqZw4KEjTfE8F6hHodVCq2l0zCxlvt1+mz4lnCz0e96hFXawkYbWJiLaErEYxcN0LvZFnP7IF/gSNJeN4S84esWTBWp2ObAdDuMEm+/SxLEplvg/ePeWmwtViIlTkI+D/Kky2nfI2HksJdNLUv1lMimKtubGhBpse2KeNcLP3atDZr/HWS4uTqNlavJ11UqbdetOMsPKWqIjRoUoSrYX4VEWGxJiILQaST56aBcwJCpjdGxKVHsDq5HWAnAGldaeMD13jW7LjlA5gmRD4PyZh7jOx1szR2VGMG8Tus9gyZSr9YE1G2CgmuuAwWw9o08fQBspKjhaaHDJxfEdRUBiqs84YgSEDTEkICnr4feeHWjGqT4MYhfwfJzEMr
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6706485c-a2b8-4ada-9490-08ddc9b04306
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2025 06:15:03.1794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 333F/jqkpsrkrNBCiIwLWuUVX3cGZP1WDWqPnDeMv3cua4xfpLjHEOrCfiTjBrlSaEuMWxESp3v8PFCrDqGbjK3Jo6wuP6xT5ATTzj+HkX0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR04MB8642

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
