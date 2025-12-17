Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703222DBF76
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2025 06:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765954601; cv=fail; b=oAYtPEwvseoBjFChRboKMc8k4Qrqscb87guds86jHAEa6502YBoBgdN7YPeBCi6jUcROQCpnm2LyLZU09vSdFVCA+jnCZinzNfP0ykVo1+t3AnKLxwxu8DDDBRlqJhfeiUBNsi2pfDi9eYtDqq+BgBmLhAbHvTl8cYCJQDnQ2Zk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765954601; c=relaxed/simple;
	bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=t4a7cd8ci1Aq1azJDIMYFNRqj136IHtwKW5IDMWEk4T9NMyPs/pPndVGimR1FQmIy8swx0TkLKdNG6SOHgZ/blTDcHwC3LvEFPhOtXTs+GrDPEfovErtL+V3Q9spYXBFUFec5PzfkC1e3yxcwxzeYuaeIpKUawbCrsV8581T71M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=UbVmzeOl; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=zJYktEQB; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UbVmzeOl";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="zJYktEQB"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1765954601; x=1797490601;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
  b=UbVmzeOlrRIcbRcRq7zluvytaB+KPteDAWtdzNbD+BI38zElseR34eRZ
   66lOu3Z+49LzY1bz4kZ3Rp6cpCBUR64qhAqyFWp9Mf+yR2W5KNNlGm60X
   tVNtPnyC9iUHNaKexbpLUWnoV5DGBOsmeuJvPcR1GJZzOJd5aTbvYs3a1
   zs/xMYwkJNrnv7dZzQzy588CJH31JBOAXTT95RJAPa0gz6aTwf1aTMS2Q
   tJbiTUHAY0mJ4pLEHbIQWn2dltPVj65klHDjxyCp7PsK2dpG+mqSzqpX7
   oLHYbYaztv8rH+8zyzxp9WORELPp6as3rMkCPXLDlodWprUjq7GJKSyF2
   g==;
X-CSE-ConnectionGUID: RiB3YFE5TF+cm0u5yMKyKA==
X-CSE-MsgGUID: ekROFpw+Qa+Fq7z9cXunew==
X-IronPort-AV: E=Sophos;i="6.21,155,1763395200"; 
   d="scan'208";a="138039069"
Received: from mail-westcentralusazon11013030.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.30])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Dec 2025 14:56:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l5frrJCVKbRKNGvanhc0Od3ftVHTrNaK7VWWmG+4WivstiL3ks3KkzH/LruQWtcZ9+0eBfR8++K4/siT21LuDBVtsYBWatIdfNc+966HpHHB8/uTKXMHMjuf25nEKxKAOUhoMz2quGQnCdvTbYlX5nionEX/qX5itDbGMNntxDrlp+AjO+UdJAzTNZqKrvAM67DcLxNjICyvrQWC9AFfffKFXmijnU0YdhTOB+/n7iEO3jOHy7fveBoX8PW+PDeOn7D4cycP1fexXwptVhjZJa8L/20CvM5FpXxez0tVvEvc9eXZoOKrizAP/R+zfIxRGDjZceVM0sBV2JMvWSBjDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=jeuMgBahZ4RXKgYTfmUCkeqs5r6poO8zkwuNi6FzqWXjV6YzSUrlu/3jagXbTRrYopoLuF8HJErW0kBuvUJT1OF1pZ1D8QURCIECQzXYnUgwxWaYS9lNi/heEpgjYcf1GbP3W4svAUujuEp3YxxzDtZ4ilAuzWtn+VRVJwbrAm9sSSQy0bVgjuNXnTaMasj3jlz4SpZz3/768UwSkAQTOGmLODYz3kRmKNj8gaXQytcTkgb2ngtR5T25n2ozv/YydJTEF+hMrzComHTX5NII1oPG9sJlqmMVN5vB4/i/IfUpZWMD6DxWGFmYRVxYk092xYc5GMGVYbkLUREC/DUNpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=zJYktEQBR4SUFlaSxlFbPyaKVRQnvXLzXX6N4iVc30/NwT01TS6jx1t+G9amLdXmEVDle1cwzXlEBNOIOMfHSJi0hv7cIlfYEs6lbuYynW3iEDKApvd/o6cUZbL4xVqyvzuRurJz8Sb8fQuqcjQVWzPf1pAelXpSBYyNOpKDFW4=
Received: from LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13)
 by CH2PR04MB6934.namprd04.prod.outlook.com (2603:10b6:610:9a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 06:56:38 +0000
Received: from LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::9ba6:7273:90bc:53a8]) by LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::9ba6:7273:90bc:53a8%5]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 06:56:38 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Damien Le Moal
	<dlemoal@kernel.org>, Himanshu Madhani <himanshu.madhani@oracle.com>, "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v4 2/5] scsi: sd: Move the sd_config_discard() function
 definition
Thread-Topic: [PATCH v4 2/5] scsi: sd: Move the sd_config_discard() function
 definition
Thread-Index: AQHcbtAR8vx9g9QiuESI7+rPi8gEjbUlZvOA
Date: Wed, 17 Dec 2025 06:56:38 +0000
Message-ID: <26ae1c89-03a8-432b-90c8-52e9e0c6fdef@wdc.com>
References: <20251216210719.57256-1-bvanassche@acm.org>
 <20251216210719.57256-3-bvanassche@acm.org>
In-Reply-To: <20251216210719.57256-3-bvanassche@acm.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR04MB8984:EE_|CH2PR04MB6934:EE_
x-ms-office365-filtering-correlation-id: 6a6c0fdd-4ec4-4688-7b44-08de3d396cdb
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|376014|366016|10070799003|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?bENtMk93RUhUTjV5QlFwUFdhZGFWRTdTVTkzd1JxUWp3dVNWOVU4b3FmSHNQ?=
 =?utf-8?B?YlkrMzJWdlVLaDFoU2RKTDAvWGxCUmxkK3NHRTA2cTFpNUR0Ym5zR3ZtVnFk?=
 =?utf-8?B?b0RZOGRZMWJKNnlVYkVhK09xV0dvT3RlVEdEazAxNVM1WWUxSTR0L3VrUVJl?=
 =?utf-8?B?SjN3ZXB5dVkrM3E1TE9wWVhkempwSGh4Y2xNZlNKMlpsNEF6YXBPYlB4a2NX?=
 =?utf-8?B?Z2hSbUNaWnhUSXgwWXFFMW1TbHVNN2NxL3NSWnc3Sy9DMjlsMW1ycDBkZGlG?=
 =?utf-8?B?THhaamdlZ2NwK1UyMlRiV2hYQW9VZGppY1NuQmo3SXNIVWxoRGdYejFBSGZt?=
 =?utf-8?B?QzZaQUR3VlBGaFVWTWpBUkdmQnhKakJ4dmQ2WWhNZ2ROOU5RcFJ1Y1NpQWU3?=
 =?utf-8?B?NnRTTW1LSlB0QUs0TkNrQ3dSYUxwUUJMTWtjYnRWWU9pRHBNL3hqTEVRKzhp?=
 =?utf-8?B?bm1pM0wrQlU4YzFZaG5NdWdmV0Z5YUVnT3FabFJqWEtsMjhrM3NIY1gxNXFO?=
 =?utf-8?B?MW1VUWpLTXQ5eTlGanBNQ3RpS25tSnNWaXZsN2tyRHZVeFRlNmVXd2ZjVFFp?=
 =?utf-8?B?YlFDTHlxd1NqTGpFUXE1QnVEZmlnWVhId2Yva3dFV0pWaVErazFjYWVPR3hO?=
 =?utf-8?B?clkvSFk5UmhBTUZSbkNabyt0S1I5ZnFkNDBSdUI0NXAzVXJjbFU0VXIzbkV0?=
 =?utf-8?B?QjNrVzgyb3F5d0NvMVgyT3NIRXliak9BSUdaTFdoSUhQYTR5RFdRTm9YL3R4?=
 =?utf-8?B?Vy9aRy8vZFNoQllHaTdrNUxuUlJET2c3emNBdkowTTVMS05MZjFSaUIwNHNJ?=
 =?utf-8?B?V3VEWjAyNHBEYzZIbTBUR0p0RThnN3NXMlc3ZFQwU0FQOTFPZFpMS0lndnlH?=
 =?utf-8?B?enNJUVVhOXhHMWxRSklkLzVLcTIyL1NITU1PS0hRek03VEZTV0pUMndGYjVX?=
 =?utf-8?B?ZmtKNjhQVFFxeWg2cEMzL3RZclp1T3d2NHQ1aTFRUjRCWUMyeUxvSTlhSUUz?=
 =?utf-8?B?eWN5clIrOWlDUldqSFAvUFRiK2hKSmMvR001WFV5TUROQWw3TXExR0hRWFBD?=
 =?utf-8?B?UDQ2Z2VWVDRQb1dKMGpPS0hWQWlGSnMwZ3BDS3hHVlZqdjBzaXh4QzYzNHhT?=
 =?utf-8?B?NTAwYk1UbmIzcXJaalBsQU54YjdjV0RNM2R4ZVVKTjR3V1V1d1V0cGNuajB1?=
 =?utf-8?B?eDJIL1FvQXhCbWluYjNQeUpkQnp4Z0JTa1VZZEtaT3Y2S1djdjRsa2tCa0dS?=
 =?utf-8?B?ZTllVnhnRTVpRVdhTHMxbEJaakhoU0RXN04rUUJBMXdkdkxOMlprQVZlM3JH?=
 =?utf-8?B?d0JjOUVBeXkvZkptWmpGVk1OMThPdCtYSURoWVBxLzZzY2Rta3FyTk9McXdQ?=
 =?utf-8?B?U3RPTnhycU1zaVNnenBoNVJFWU1HNTlNRUprM3dGT3dzVTFqVnBUaEw1NEFJ?=
 =?utf-8?B?NTNlVWxFQkxYWENGR2tOUVdsckoyQzd4VjBZVTdoTkVYaE9IbGc0WUM5T3g3?=
 =?utf-8?B?b0ZWSUZtT0Q5dk14NUcwVElRSXROeS9sOGtIcU5QOHZLaDh3Z3ZIWHlpK003?=
 =?utf-8?B?aGtKa3FoNUdFUXVIYjk2Q3hJeDlaNkMrZHJvQU1Ib0paZWRpSnpUcmRoL29w?=
 =?utf-8?B?WG9Eb2JleHJBazYrS2dENWtjKzhyUkN1WHdyWGtpTStVQnNaSHk0dk80eHZR?=
 =?utf-8?B?QjkxNHJHSUJpdFVWbHpVTjhVMkNUVGJ1eWFuNVBYcE8vZ2ZmdEtIYXFZUS9O?=
 =?utf-8?B?L0cwdnNrUkVaR1VJeUEyMzZ1NFVmWEZkVXdvRXlYQlh6UTJRSHJxMk01VGNP?=
 =?utf-8?B?MDNKZDNuSDhyNjNUSW5SVmlEZnh4dGtFT1MyZXN5dXVLd0NwelcxRFo3ZmJB?=
 =?utf-8?B?NWhRU3c5RElVelB4cTBmWnJoc3FDTzFTenB2V2pUdldyejNSbWdVNTdjbG5V?=
 =?utf-8?B?NFdleDJaN2lSQWdvMFRMYWNYSysyQzVCbUgyekNwa2gvZWdySTQ5ZFJCdm84?=
 =?utf-8?B?VnM0SnZmYlNCbkNCcWNFMHZ3cTRmUEhnN1FYcStGdXM5SCtqdFh0Y1M2TVN3?=
 =?utf-8?Q?Tbn3HL?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB8984.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(366016)(10070799003)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eUlIcElVSzhBdEFnRCt2LzZFZjloMmNJdW9ucGd1bE55Ti9vZHFpanNpRUMw?=
 =?utf-8?B?S01ibm9Yb3J4bGhEa24ybEFqcnV0enZYUGhBYXM3WHRNYzkwdnVESXNDeDRz?=
 =?utf-8?B?c2xVZ0Erck5rRFBUT3FNQnhBb0UxUGJtOXBMQ1V5ZXM1NFRNay8wUFI2S2ZN?=
 =?utf-8?B?WWNFdCswUUprdXFxV3owejBVeXJJVHZwY3ptWC9RbjhUb3M1c2dWSkdiZlUr?=
 =?utf-8?B?Y1Fmbng4UlFCc0U1NVBGTHR6azlKTnQ4MVZ6QTRiOW0wQTRyQ3A1ZGdWM2tC?=
 =?utf-8?B?RloxUldUMXcyR1RXSWVKVmtEWXkzVzIzZy9kYW5JSWNGWlk0ZmtScVhxWEpR?=
 =?utf-8?B?c1BjMXhEbm9jd3NjZ2RuTXFwQUowV0hESEZUalZUZVhmdE5WMFdiNmdjQkMr?=
 =?utf-8?B?Y2k4ekZjVk83Yk81dWhHbTB6NUJVdjhvUTJieDA2SU9wNmEwdk5WVUI2dG0r?=
 =?utf-8?B?TDVrSG1SNTlMRnVRdXFNd3ZmOWs1dE9DVGlBWmxjdUwzemhuUFhMVnRtN3Y0?=
 =?utf-8?B?T1ZUQVFITTBjWEFxWkk2eFArckNJUzYrMzJxYUVPdlZ5ME1nQVlMMnhPMEF0?=
 =?utf-8?B?QTIrL0lDT0ZnWnFrMWxXZ3NpcTFUaVdDZGY2cSsyZFcrdmI3SElQaTJpdFpS?=
 =?utf-8?B?WmdNZ1UzY053UVYwbkJUaW1yZXRVb29tTkxJdjZwQjlkem1hUG1Cc0Eyek1a?=
 =?utf-8?B?eHNKenpSK2FoS0xaLzB4VFVERGVzeldZRFoyN3B1WEhENzF0aWxORVRWczJV?=
 =?utf-8?B?M29tWFU2WnJQSXRTSCtENGwvSzV3Vjh2eFBUd3praFJrcElhem5DbC9CR29a?=
 =?utf-8?B?WnB5RWR5OGxycFdBM1dPcWtaSUE2NFdjd2ppbmx2RjNkbDhPQndseVlEZ21z?=
 =?utf-8?B?UklKYiswd1ZGb3BiZWxmbm1QWTdmS3VYSWJYMVk2c29vYmxIbGpUL2tvOFhX?=
 =?utf-8?B?QktTTm55UDk3VEo0QUZMdytoSDk3L0ExaXNVcktDd3I3dVFaR0NKL0QyZFNu?=
 =?utf-8?B?cXZObnk5b3dOTng1TTVQRkdlVUhZWXBmNW85cHJUMlNSUGI2R1dPUFkyZWZV?=
 =?utf-8?B?QkVYeU1qbFljL2lLM1RPNnhhZUtHMkgwMDQvdnJ2aVZIbnlSUEFoWVBCeUF5?=
 =?utf-8?B?VE5kemg1MERqYnFuekJOQXZWa3JxOGhoUHA4OXk4TlUremc4K0JNL3JtVy9E?=
 =?utf-8?B?NVcvQWE3WklXMlFqaC92czFYTTlRZVYrUFUxWVJCQ3hQczFYQTR0TVJrVm1i?=
 =?utf-8?B?RFVZcXU1dm9kWUR5L2diRGxvcnh4K1cvN0RSTnJkUDRzNFR5Y1BuMWJuWTdi?=
 =?utf-8?B?ckhoeVNOYVEySFRad2pRTDRBN3Q4K3RpZjhPTHA3RHRhTERYTG5IRThxU1My?=
 =?utf-8?B?Z0syL3ZqNk5RdkVTWVkzWmQ4R0JOTk8ycTQ4YXZ3bFg0N3RLT09DRXZuTC9q?=
 =?utf-8?B?T2FlME0vKzJRQVM3UEhSdFV4WTVEeTJBUjB0YW9KeDFwYk5lMjEzZ1lURjhx?=
 =?utf-8?B?Z3VJVHYxcmRWYjBtR2YwYzBJckhBRXdNYkVScFR4aUc0YmNzckx0SGU0RndP?=
 =?utf-8?B?MTJBK1dlRk5PSHBnVzZBeXBNZzAxQVRQWUpSRmtMRTg2NjRPY2tLcFk1MGZH?=
 =?utf-8?B?STQ3VDJPNEZFZFM1VERVakMybVJmVjcyblF5SURtMTNnc1R1eitnRHEva01Z?=
 =?utf-8?B?NEZMT1ZOMW5DZy9lT1p4d0pBS2ZOeStEWDNybDdFV3RZR2o4d2lqclcwN1pt?=
 =?utf-8?B?aU5xWWQ1b3JMYnpiQm9sQ3duczFOSzRTZEk3c3ZmbFkweTlDSFk0Yml3ZnlZ?=
 =?utf-8?B?RzZUcHN4TkNiM1dsM0x4VXFxYnhmTk9XNU1zZFJiQmFmQ2t4TEN4UCtkY1Fh?=
 =?utf-8?B?QkF5Sk5IMWFNVkVvZzJ0NHBYQTZIUHl1L1BlWHF1QUlqV0FuZ092NWhRejB2?=
 =?utf-8?B?RUVSKzJrWFpsZ2NEVnhQd0o1aGVqOUVsZkhESkJpdDR2UFJnNkp2d2Z1d1pK?=
 =?utf-8?B?c01JTnZldVVGc3ZyTEFTbGhQajdrOGVwdU5oRUdRdFQ0TWkrZ1pGOFdwaEk3?=
 =?utf-8?B?QUhOVWo2WGlwVmQ1OVNLWnlDa0hIN1lzSU1JWkpMSWJRMGtHeldnWDQwRjUz?=
 =?utf-8?B?Y2RCWXNSZXJBdUhaWnZFQjRVRWtmQnhnVVIzUUZnWGsvOHlEMmxMMzF4bWNX?=
 =?utf-8?B?UUdpNlhXckxIVHZybHdiNlhQajZIQXNUREFmU2I0bWV5OFk5bTNoWFFtL0tV?=
 =?utf-8?B?cU1HckNNWW1ONHNXZWNRQXlRRldRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8008FBE05B56B746A1CE7EF6965FC8B1@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vUkaX9E4fseCdKmFSsp/ooYg/WrzLCHvCqWMghztc/wOWBss+yNLmJDdcaBIXUPW5zwwhFfIw1U4HDzl7295e1VD1fNC3aCWOZ4KT+k4sxfqoBjC5aHZsBby+xncfRQC+pvEYa1wVOy3t2r6cGbP0zMYUCRDB8o6JDJf0JUUpsjuqSPsv6DvtF3TW5b0DGfcdpRt6iw3cu+hsyiCY6/T7eOpidKRAd1ViEA8MVBWjdxNaNJUvrjb2/t0Y5Crj46p6GXb1c7pfDE4w2OtW6HSiNqcP8lVxEqpE8eK93RXoCedeAn4DBDysevkNHnUxkyuwYZQcGkaRvw/DXyTHyDK53ZEwWTQkwyAwFLY/+G0tG82TgI2Znw+TI16OTLOLCYN+LWWnC4YG2KyW0G0j4aEccVThjVnDtiOk+fmd06aKfKxw5iKs25y0E4C+AH1Yfl+7znFwdkqaecJUJL28JDJCUb07gbj1RDrUAnZrZuTl/qIsXpQZhl8/RQt6uIIQGNJHfLDJUqVeSxis9RkSAigsr8SNmclkQ/XnUjKT6XTuTzMzcawtcfH0dLZr0waY6ECyt5QuBZspCL77ak22erp3hDnB1/K4i/rr0w3wxwuwgz+D8lTOH2BmBuektbk6hD6
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a6c0fdd-4ec4-4688-7b44-08de3d396cdb
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2025 06:56:38.1859
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tpZY1boZ0UW33YwTd4BSFmsjbuWLoNExTdOW3tp0vMYEVeq2uTzJqenoF8oluW7YxVtHcCclKD7sSyW84Q6wFULV2c2VCo89HmqgFAlGrWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6934

UmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5j
b20+DQo=
