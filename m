Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B344E1A0BFD
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 06:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753251144; cv=fail; b=XRnFfrZKdUQBAT5hBOmmFU4oGPGGMPLd+ZK4xlOGqYoidXRybx3WZs+kRI4qXTmNPawfp7p/9DbW8oj4Nrh4BYERbiRXawSGrPibQ2KZ2bQ23UdQddsxT9HFEdNVclR95Zd2xz9s0HbFmnkp7lKSsMPAgvipRJvqjoOaIJGR7sU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753251144; c=relaxed/simple;
	bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=O4tDQD407mcHulXFvcUySIEX+ck08Rby/hHgWd9+OtialJhCoOvgqa5Iamo3LyvZsGtOFJIeLfP97r1AoeKPRkr71nToogTKvP0SgmnbeyECBMZ9SoxbAmoyvdrEKy3UfLTXAuz77LeSyeF7sDM3xrZAa1mHr8mTt+HWAAEMpL4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Jgx77D82; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=FKvJdBx7; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Jgx77D82";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="FKvJdBx7"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1753251142; x=1784787142;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=Jgx77D82myO48XZ26E9Zg++LTSsCKQlqIbknnUUYHun1ihj3liRjjOgD
   n7sVQyc6gn94TwDUT5nPAhnrPpXFgNs/RtXt4mgqQjZJ02/6bItEVlP5N
   sMdU9Z5miE3kN4ZuS98ratYWNc9ICBCk4Z0n4duzfwOXFykV9zERB57lA
   AsXCQLc+l/hici3OioRRRnm9It0ESt+JvuQ9Jfo4oxwNgVrpni1fnTPSe
   giXqZJClDHQHfn9iVAnQ55Al3CtMFnScrBdwx/YoQyKUwukCJfdbO6TzP
   m1snJTSE/1uWHeybeH9t9W0u+j/I9DPz4By0fntApRetNmpDBWFBSFam/
   Q==;
X-CSE-ConnectionGUID: pCC7vauCQnK6yoI37dP2/w==
X-CSE-MsgGUID: UNfSFe8PREi3xYavXom+BA==
X-IronPort-AV: E=Sophos;i="6.16,333,1744041600"; 
   d="scan'208";a="95432456"
Received: from mail-co1nam11on2049.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([40.107.220.49])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jul 2025 14:12:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uKQ9JTLU7qwtH1P2B0Suz4pjn9lO4N7q1KBrATXhUNyAE3jhnynuBogOnHZzueMszy643f9+c9+D7FXP19oicjzmsQ6ot0ab2TMlM5HP0hUoxH4x+3CAyy7m/5Pvtzv5LD99C5kkPn5kRou8JtbO7TAlPTOMTEXN9qaS2Ce6uR5+Fon2cPQiQg4DgFAT0wf11zt4LuG6upQENkjiTUe0sFvwNaEaXItMz22pH7KoceJCPeWM6oo1+mhQWw/k6EIcqpQup1v7KeHfATOQmeTN5XpDCB+DQbxXTf+tWbvV8ckBwk+fNPwsMoUVU1YIORvHZXG8uAImikuCgRP/SrL2Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=awUpGLzJUxb38WbfkmHXGypqqvevNWfTY1FFHL6TkDELqWCeMQMJNfPc9O66sgfzKlVoBK1m9z2ZxwLqOqgHNN3clsam2xuBaCoxHJN5TPPAwcZ1E0wZIs6s3QjfIakDcF+NBACVFZHU9tCKFh8OC6Y4DOThz416Zg1PBWqYJjD5CnJAMTbr55ilMwguH73k/fGq169mIN/jZLuM0hCUAXBzr7E5yHoEcpVnXbGq1EH1ZtaV3Y55zXH41pXLmYAQnyJBGpOpJq5lIirMvpg2isX7wCh0XzCwdfUcu5amBxdInSH6bOyh6s8ocO84SbB/aH+2uhhcB5ZWsj8NtD+Ejw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=FKvJdBx7ygKSnWbRjGwtAa1T2QKXdStDcX1NZGHQppH0oPIK7wXsstdnCSVf34rY6j0USy8XB9tFXwGJemRuDwjC4YNYmpR28eIu4lEanOASDhS/ClxrZsc8u55bEm+gOit6P8z/copxmE9M0crJpS02+TZt/PubgtSvIDoGFUk=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by LV3PR04MB9151.namprd04.prod.outlook.com (2603:10b6:408:27c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Wed, 23 Jul
 2025 06:12:19 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%4]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 06:12:19 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH 1/4] scsi: libsas: Make sas_ata_wait_eh() inline
Thread-Topic: [PATCH 1/4] scsi: libsas: Make sas_ata_wait_eh() inline
Thread-Index: AQHb+5R4SltvFLWR30GsS0RrsFctrLQ/OlSA
Date: Wed, 23 Jul 2025 06:12:19 +0000
Message-ID: <c7310bf0-3212-4036-a1fa-07041161f22f@wdc.com>
References: <20250723053903.49413-1-dlemoal@kernel.org>
 <20250723053903.49413-2-dlemoal@kernel.org>
In-Reply-To: <20250723053903.49413-2-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|LV3PR04MB9151:EE_
x-ms-office365-filtering-correlation-id: c0b364e3-1424-4d43-1a43-08ddc9afe1a1
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|19092799006|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?L2JScDNkVko1c0FNNHZKSnk4b2Flc2NYQUxqNFBEc1pDQU9sbUpQQndoRE0x?=
 =?utf-8?B?d2JiMFlnYWlUNkRQbkM2Y0xERm4rclhyWjRoUTBZc0V6MG92cCtwNjJMN0VO?=
 =?utf-8?B?SFlvaHZ4bUNUUW82R0ZaaUhha2gweEJRQVFzZFRVMHRzNVM2NWQ3czRsTVE3?=
 =?utf-8?B?NWdVek9LQi9uOXhTVlNsVC9oRi9tN01wTXdJMHZINFV1eTJmZXdHVzNoNXNQ?=
 =?utf-8?B?VVM3REt6aFBocmhHNHNUT3FrZWUxOHJjZ3k3VXhGaC9PRkRaMmIySFQ0VXpG?=
 =?utf-8?B?a2IzR1BqU25KYTBuMFhBZll4Y3dnKy96NEVWR0xGc0FPaVVKRHozMEorUEpa?=
 =?utf-8?B?b04wWmxnZVIxelNnYkJ4VXdaVG03Rjl3ak9iTVk0RkpQdG40cE1ZODk1bm51?=
 =?utf-8?B?S2U5eUQzTkFzZnQ1NWhKMWRpYVVCVTRFVnhzUmVNckdSSGtFS2NPS3EvcUZL?=
 =?utf-8?B?bWVvczM0ZGpDdlNGSlZJVXBJRlJGbHZvM2RBdG9vazlaZjFEOVFyV0NLdlFB?=
 =?utf-8?B?VHJLbnRuajk2L3JJV1UwZDUvSjgzLytlVHU3MUNLUVVsdTNHRkVFK3dSRGhy?=
 =?utf-8?B?VDRXMXVhOUtPeS82eTBnaWVxdU9xWmRNYk9DQm42WnZubW9hMXdNWDhscko4?=
 =?utf-8?B?WU9temJ5ajg3NndwbGpERmFBRzRJd0hvVnhNZStxaTB2TjZmZy92WlM0N2pl?=
 =?utf-8?B?U0w4Si91NzVzcW91TzhKdTZBaDVhOGV6UlZqeUhJWVFwYnVqR2VnQUM0eWQ0?=
 =?utf-8?B?azZud1g0QVNhK2lGR00ybHdyU3VvbUVhQUh6VTFvbzgvMjJnY1VLY2lUNy83?=
 =?utf-8?B?SlFyTUZjNC9oM3NsWEY1cnd2THZhaEY4eWNLRWdGM245VXovTEo2d2V5OGZG?=
 =?utf-8?B?QzBFRkJyL1o5SUJXUHgweERuZ0RJVEUyRUlwNGE2MmZjcnhRWGRVeTVnclEx?=
 =?utf-8?B?Y3JDbVZFaUtDaG1oL1VnRUZnS3l3d0tqSjZpeFhLWjdzQlhzcis3MjVvdTF4?=
 =?utf-8?B?T3UrcGRmZ1pMQllZam1ZaGp2dlJnU0RQd09jbnBIZ0JuSVpicFY0Mm1EbGxl?=
 =?utf-8?B?bWY5Q0doQjdSR3pQVEp5aytvVGpDNU01dElxeDcwTVhrSllHZzQ1U1JNckFu?=
 =?utf-8?B?TXNTaWVYYUtjQnE4SEIvVHJDbzRCVEVZV0Nnd0t1V0RNN29LdEhSQjZ5VEtG?=
 =?utf-8?B?c1g1NVk4OHlFYlFYYktQSFlZM09GWXI2VjZFUWJNY0JGTUtYeFlrdzZianMv?=
 =?utf-8?B?bmdRUjROZUV2R1NVdnlBb3M0QityY09XZDR5VVdEMSs1VlpnTy9tcHdHMlR0?=
 =?utf-8?B?aU12TWFaNjNSRm0rNXlCZnJIWFZraGsxVjMxakVEaG9OR25qSTVHRTdkSHdI?=
 =?utf-8?B?bGpRZStpYnltNmErbHkwS01yaUxQckJhV1MxVWNtU3F0NXkxL1JaRmJjOUcw?=
 =?utf-8?B?Rmltb2RjY1FWKy95SnprcEtsQVRSVmZtRmcrOVpGc3I2Vy9Oa01oOHpnK1Uv?=
 =?utf-8?B?WXRwYzBFTmlqNnYrZ3hMSVR4NnhkbnFuU1FPQXRRZk1YNkxPSGNTR284cS81?=
 =?utf-8?B?QlA4amVxaEZWeCtJQ09GSnJxdFc4VHZNSGFBWjBoZVlGSWZqUE5paExiOSto?=
 =?utf-8?B?ZkttR29wdGxsV3NDQXlwdm1aUUwwQXF0QU5yNWxwaXZWendtTVVMQ1JLUXds?=
 =?utf-8?B?aWZDejc2eFZWcjRERjVPRko5R3ptL1JIUUFBZElNMEJmV1Y5eXpsMVdKZDl5?=
 =?utf-8?B?U25NODhZd3BkeU5sUHZkcDhJRHpkZ3JNY1ZabWlNV1JHUFdtVkpWOERmNThN?=
 =?utf-8?B?NnVGNlAxajFhQmxYTDlTNk4rWG5hTWVLNi9Ca1JjT3I4S0FlRXhwVWJwZFdN?=
 =?utf-8?B?UFN5YlorSWtNWkllbXNKeERIREhjZ3kvU0gzVFpTYXQra0Z4dThVbzdSUXpU?=
 =?utf-8?B?UWNmRE9vWHBYZEVqODY0R1FIcGtncWROYVh5dkxVNGltRzI2c1M1TTRWWkZR?=
 =?utf-8?B?ZjhGZ09zc2hnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(19092799006)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?K1lxK211VlpQSnZzYWIxdnhWUDk1dGJOTU16T0tBeE9WVWw4ZW9RRzN5NHF4?=
 =?utf-8?B?cUlNdWVCcEM4UGZFZUNYc3V2c3Fhcy9tMk0vVFNzclFxQXR2RE5OMG91VjFv?=
 =?utf-8?B?NGdrR21VUFVMS3Z0ZW5rS0hsZ21Lc0o5VWlHaWF2ai9UWWJRT3dZNUcvS2pX?=
 =?utf-8?B?bGpGODlvcStoajhKVmx2VDlNUnJFK0kyWUJCVkwyR2pMUXNsaU5HaW9jTU13?=
 =?utf-8?B?UCtYSFR3T2xrZHFjY2haU3dPeGpVYUJEYlZPZ1B6RmFPQ1dvUDBNMDBoQkJt?=
 =?utf-8?B?THgrSm5RYjFIWGZEbHIwY0RmenRQTHc1aDEycWJvdTQyTGMvVzQ3UXNFUXVT?=
 =?utf-8?B?YUtobVNCN24zSzI5aHRybVJ6bkdvZ0tvRUkxQ0xXWEx0bDlXd0VrSXVTc2l2?=
 =?utf-8?B?QnR1SGpXR2kwZFJTTWMzbTNBYy9pdGFKK0dCUFBCSFp0aHBhRVFXeml5ZXYz?=
 =?utf-8?B?Y1YxLzl1NEZadnpIUVA2RzFTcnJpK250SWlqRUlmNElYTDFURytCeVkwUmZ1?=
 =?utf-8?B?M1kvTjBjVE1vZzFrc3NMZ1RBUzVPQXN4bXpKTi9VZk9HaVJXeHBiQlZGUFFm?=
 =?utf-8?B?OFluU2x4a0xjbUhVbTJhZnRFUk5ZSDZUWEs1ajRsZnBEb1I0d1liSDdhWGFV?=
 =?utf-8?B?YW5wRktxMC9ZR0dPbVBSUHBPdHZIaDlWODlkTjVqQ0RucHpiR1R1Wm02cDlT?=
 =?utf-8?B?QW1lYXl2aEV1RWZaV3BUM0FVMHpLTTlLdWt3MVVnN0FjVmM0QTFSZkdBZHlH?=
 =?utf-8?B?SEwwbXc4QUw3eU4wbENpc3ZkdFkxV3NWVE9IRmFCWE4vZmlWUElxUFdDZ2RT?=
 =?utf-8?B?YjVBeTR0cU0vL3V2VjErVzdQYkc3c25RbjdTUEtFNFlsLzN6TThTQlErZ1B6?=
 =?utf-8?B?Njh4TGNhdmoxOEVyRjEvOUl3YTFWQVFOeHpwZFBGamY0Qld6bE9paGxhZmtw?=
 =?utf-8?B?Ynd4TW1LSE1hVVVtSkV5bEtBemJQeXNRRmUxRnhDZFZiUzgxdzBLSGw4Nkx4?=
 =?utf-8?B?VmZhdjl3SkdXa01FYnhsblVHeGQrOHJJUXAxb3NBTWxjNzBqNXdjYzBaT2dC?=
 =?utf-8?B?aEowazlsQzFtWHBna2VtT25rSjJZdkw1bk52clFtTXpjbVFYWi9MOEUzUXBZ?=
 =?utf-8?B?YU0yeW82MkdmTlI5eER3aUlSV29vZWxyRGVQdmdpUnUrVG1oWUJPTHprNzJy?=
 =?utf-8?B?QStzZnhYZk93dEFEVFBUOW9tamlvUUtpYVBjYmVDVmdXUVVWVlduVzNTQlBK?=
 =?utf-8?B?OERrV2VycXJORXRDU1pKRVZHdHJKVFhtME50NGtnNG5XeWYrQnkraDZiZlNx?=
 =?utf-8?B?YWlmc0FqaDdWaW5PVVJiTWR5WGJZTGRudTRDNnRscHAyeXRYS1VNaTVJVFNt?=
 =?utf-8?B?RWd5MGhtL0VUTllBTWdqRkhiOUpzOUNVcEtJNVp2UUlHQjJDUzVlY2g1cUpG?=
 =?utf-8?B?ekJxQSszZ3BMU2lHOUpSdG1yT3dCcDVsM01hTlJxc0k0L3h5ZGI2RGtLVzlH?=
 =?utf-8?B?eEw5R0FVREZXaW5KWXQ5KzdvR3FzK09Kb2YrQnM4Y2dpM2pOTk41NVJPNmp3?=
 =?utf-8?B?SXdWalhjRkJMendnOFl2Rnl2UU01SGhzQVVwMlFuVzIvSXRLRzE3TFpGRU9X?=
 =?utf-8?B?YjVuUGJJK1RZYVNPelliQ2hrMHY4MmlzUU5jSHU0eXBuVUpXQ1h6dWVqWU43?=
 =?utf-8?B?QnliYktSaThGL1owNFlZM2dHSE1lcDFRamxOSHo4TnlTNkFUK2VicHBKQUFW?=
 =?utf-8?B?NmYrSWJFWTgvWVBWOWRKTjZKNGV1K0ttY0lKMm5OZ1RObnZ1YUhTbDdZbE1X?=
 =?utf-8?B?OFlhYTJFZDVRbDVXeDBqSi9Qa1RNV2xGdGtUZ2ZhTEdGdWpjdTVjZ3R1WXJl?=
 =?utf-8?B?QVNGeGZVVzRlTVJxNG5KSVFoZWpIZzFMNUt3dUxKb3BXUlhnSlY2VTNWTUIy?=
 =?utf-8?B?RWdBdEtVRFlJN3JiNUM3ZVJDSXlWejhXSmd1RkV0TFFkYWFhTHB4UDJpVm9G?=
 =?utf-8?B?VEVwenZOTjFlVDhzSXVhU0hOdTI3T3NqS0pKVkZJMEZSWUVKcUdiV2pFYTl4?=
 =?utf-8?B?YmdKZElJYkpnZHh3SDc5dzJFMEFSMFpxbm9kRjcwSElwSThMQmIwSWhISVFX?=
 =?utf-8?B?ZWtYbFpySmxsbW1zb2RkejRKUjdnTW12VEd5d0hGQ0pjZ1dnREF1SjdnNVB3?=
 =?utf-8?B?bFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C4ED5A0981024E4289B7F729E10E6F6F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	x+QC8xs764pfCgkCeCk+kuolQqFc+ocvcMYamON6pq9KwQKhZ24JZaFYVyVEC5iKxrie7yrB/ggje69r+NUBZ3HIXng8DSMeeGh0WOEfq801FaWyOopWwkvIjqggMerOXkTVxhob3pD6td9GEwh8p+nkMT0NmLft1h+Se/86pzac3LVE6/iGMBDvvNTrbziETH7WUCQ7nI5oY6a55it2ASJHzd3sA95IFKydmsk17sQf4Zkw9udCLyCbFXaUQFsG/IHAd/j7vZrSbD/lyTc4L8JlMDGviidNuMuVArfs9xdxjp5vsiFe3HWyXpxNLtga0ZvITQk1qd7BeiOXGU6AzoVLEp7zsooEaSYMq4YpRWAkJIEoAZL2iGpcFAK7SWbQPN7x/yb4H+XSoxh/qSMzo5eY8W+A5e8Izyo70Sz6no+LwY/MImhixm7bitF0SZxrnc/STKFSplAskD9uZLexrWsyLTLLw61ZS2xlCiURAEFmeYWh7oWTe+yyZ9LFg9h53PAzsruWb3P7HyYWNujFVGysrcvw/m4L/3UmMKBovmusdSMTEfMY1L7R3g1vqQnPfWaouXU4bajXs5bRvVfBuY0BAhW6+1NLQMJihWd3XTbsEuI6Sulw1xavaNqLTwx0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0b364e3-1424-4d43-1a43-08ddc9afe1a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2025 06:12:19.8150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XtLAkTw8AXA6zJvgCJ8h9TeU0QgiFBYzqkxDy37fNIno3icWft6kE/20/wlErR0oHSMZ9J2Vd3BjGOgV8Scq0Hp1ijC0S3R6bS8/ddS7Yfs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9151

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
