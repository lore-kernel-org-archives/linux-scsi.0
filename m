Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D3E248894
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 06:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753251211; cv=fail; b=UVwaOlAnA+HKR+cMAcddGoxk/BXsKTyffkRTubLbtgnSBF23iuzseIWaJgcNNhdCTK3f9gNuIJwRtEQj2Cm1UlD0z5yV+ipU8ypdQ6qS2FYRCk+kZSBFEJxXTlSbbpa8F9OFKQ4TP6EurDJHWsmPzWueSdXjhWGGiBYY4N0cAw4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753251211; c=relaxed/simple;
	bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sQeT2G9pe3xAZVKSBYvGM4x4zTJPN0HbhWfpPPn/7Mynct2LwLujUmV1ds4RXFQqXTi+xoSJjSWDl/On4t9Z+5WXDTnrDFSDhYa4fsqz/BtZehwC7/HAmC6yhbhqDIezn3W/cC3wSwR5J3XVfN0/B2JQgnSdRBoUtw/TSKMru90=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Of4az4Q8; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=vMxB/eeb; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Of4az4Q8";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="vMxB/eeb"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1753251205; x=1784787205;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=Of4az4Q8ggrpFwVBVGpl5Rpmas2qtum9zu5DhHp04hRkqR/sj4zOiNHn
   cc1PbeKQYp53m8eILR0+EMwpMNP6d746OHwChGu239668r17JJIc1N7c3
   5NCFyV0P36zaeE1visb6MbFN6ctNqWXnV0haTdu4msBCYeplAg71pziP8
   CKnxGGGaYNei6ACX/PTW/TeSP2zbILlomqaon3meOhGkTS65Imkbw3GuC
   IwZAxUEG22RQLayc3jS8lIGJyaR7YRzrj0wRQY2ZfsU4S/e58u7s3/x/9
   F1a6/vqlTSszz3GjQnU49cJqa13Fv/wB2OhCc21+Nv/KFFwrgO/LT9dFs
   A==;
X-CSE-ConnectionGUID: 5VypTguaTXaDaneBA4ol2Q==
X-CSE-MsgGUID: NNqED//oRzKqJPtL3cGiLA==
X-IronPort-AV: E=Sophos;i="6.16,333,1744041600"; 
   d="scan'208";a="99813969"
Received: from mail-mw2nam10on2049.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([40.107.94.49])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jul 2025 14:13:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mb5fWcOCVG9FdX4lk2cz63JS4yiOjTbrlKBm7cd0uoZjiu8nguMGZzdGGKViz6uYbULyoGyw7ivta8fiLOcT9qb3v3YN/WnlLoSmFSXOl86AgqUGfPcEqIGWvMPPRdne1pz1F/zSSqbD/JZ2UlZH8EjaYxO2AsvSSWGPN9w2m99HwlN330gyLcgw5RCpaPQD2mgqsfZPJFIgyIXHWncdxdAESBiRFezM6mrCOMIB9dZaxTg/n+S0gV3jAaD6vqAKZQ76Z+rX7ZDSIG57AzP7E5DWh2wxB5s6nWwWzFX+YZ0ONg2NT6mqbj9MO93pIYUmC4a3weWEZ1DTTa5QZohJ5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=O6xmSibJIpYJ3+jW+nlo78GjFWuosUKGhog5/XHc/mTy+4FzCn96+pkaprMboMTqeodj+mDeVIxmLE369pMK0WsQ4Kley5lfqbIrG3P5ermMozEPOZAFnK8INtp/rtoGb87c70XVQck3B0QFgdHUnVGPmDBDYOSyQpDC4T0RFZGFjj1EJ4F2JAkMevCkvuAPx0FAhqu4DllMWLksGsK8TWFVbn2kcw2WXrNnAYBtecQN6CQ2R6yMUqXd13xgUtYLxzW/xMyM1CAJyDlcMPDnYIy9Qc3Ysk8ozxaniYBL+iRmF+6Lbs/EoZYb55eq7glzK6aqICRaSUvfS1wwjFIFQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=vMxB/eebCBNB1P1aZ8KvC7yMiEDXYdlR+sFyPoB5oDkLTeQ+zpWNrxYgAiTchPM5okz2M8hRU2sO3L5QigG4Ib5DwbmPI6DCN3/+VdIFpPoOnpKFheGDBFLM2EWCYE6gsFn+q22eptYAxqAesqx2U34qSdBj3SmG+d5n5IN3h74=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SN7PR04MB8642.namprd04.prod.outlook.com (2603:10b6:806:2ed::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.29; Wed, 23 Jul
 2025 06:13:22 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%4]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 06:13:22 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH 2/4] scsi: libsas: Make sas_get_ata_info() static
Thread-Topic: [PATCH 2/4] scsi: libsas: Make sas_get_ata_info() static
Thread-Index: AQHb+5R5CQrELMoSu0yuSNMwiKBTy7Q/Op8A
Date: Wed, 23 Jul 2025 06:13:22 +0000
Message-ID: <49bea56f-ad9d-41af-a29d-e817cb9187be@wdc.com>
References: <20250723053903.49413-1-dlemoal@kernel.org>
 <20250723053903.49413-3-dlemoal@kernel.org>
In-Reply-To: <20250723053903.49413-3-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SN7PR04MB8642:EE_
x-ms-office365-filtering-correlation-id: 8f65f408-5472-4c2e-1381-08ddc9b00717
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|19092799006|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?eElSVDFNUnNUQ2YyYlJsR0JqZm1GUlcxbWJzbXVNN3RKdGFHc2Zhbks1YmdK?=
 =?utf-8?B?bS8wN0VYRWEvV1JRWTE0RUhLa3dGOE5kWDR2M2N3UUtRd3RnRkxzZzJqVjdH?=
 =?utf-8?B?WEg3WVhnZUhEQ1FEUWphWUF1bDRta2dWS3J4Z2NDM1pwbTkwUXdCcm9rZUIr?=
 =?utf-8?B?RDRFYnNiUDhNOUphZWwyVFdIUDVvaUgzMkN3WmZzYThjNWpBM0RtWXFHMHB3?=
 =?utf-8?B?TVZtZWhRNXBHTDNtVEV2Qkd6RjJPanlOcTBtTFNpRUREcC8vOHBFWEZnZEhw?=
 =?utf-8?B?NEpFTEQ0RmZBOU0vRXprMkZsd3FWR3ViL2pkNW9XaWIvbGVQY1gvT2xMYVIy?=
 =?utf-8?B?Q1MxUVZvZE91QSt5TWFJZkRXeVRCOENReVU2eUx2Z3dZams4eUR2SzRpa0tq?=
 =?utf-8?B?dG9OdVFHY3VrNHZUU0o1YVdYQThQSTd2ZXRULzQrckVaM3RBNjhueTUvUmhJ?=
 =?utf-8?B?V04zVlc4OWxLeHFMMUdKek0vbXpxK1A0bk0xTjZ1WXZCRW1aT2xSdjFGbEZS?=
 =?utf-8?B?MFBxbmRKc3BzR05BTjBEZm5hNmUxeGRRZW9Bem5qVnIrblYvTmh2UHFKdWoy?=
 =?utf-8?B?QjVaRVFndXBIb245L2dOVE9xd3dIMWtud1dMd1VNTjBwSjRJblNpak9OcDNk?=
 =?utf-8?B?QzNmMEdZWGZ5VlE2OUdZUFNhODI5c2lYQWNUcnYya2JrVDRRais4Z3F2bk1z?=
 =?utf-8?B?NE8yaVhhcTRvTldsc29FSTZMZ3JxWWk2V3hQNXF5WE9WT05scUptUVNROXU2?=
 =?utf-8?B?Q3hJUGY1Z2RsQmluN2dpbFJlYnRpUnJZQ3gyT2Q5NmhyMy93dFAwWnNIWWps?=
 =?utf-8?B?TDE0Ky82cFFLZU5ZZnhYaUFIT2FlU0dHd3VkRlg4Y21jRDdkTFdaczY4RkF4?=
 =?utf-8?B?OTUwNk1OVStHVExVYjZhTGRSdWJwcjB3YUpHSHRQeWF0ekl3REVKQnJKcmZI?=
 =?utf-8?B?ZEgzR0hOZ3MxMVgzLzlqWGZSbjFueXc1VHJtM1hqazRUMi81RlhoUHNUblhD?=
 =?utf-8?B?T25FYlptR3Jjcm5hamVXM3VlalBJY1hMS2JLTnBYNGV4aFlXNlIveGYrMkU4?=
 =?utf-8?B?UHFLbHdWQnVJRXdkK0RvaTJ4K0hXWm5oN2MxTENvQlhZb2VKa0l6cW9aLzVJ?=
 =?utf-8?B?bmgvT1JYd2FQbUJrUER0T2pSS0lsY0dYbHhMZWVSbkZ0NXMwYTZweHpvdEt2?=
 =?utf-8?B?ZU1PdHVzdi9ZckxtdGhLRElVNy9mVEhWc0dQUHRLUGNZZkRHV3NjSlUyVG5E?=
 =?utf-8?B?OU5lZDYrUzM3djhZNGx6Z2dMYy8zZVJxNVVuampUTTZOeVUrQS9TVHFJME1S?=
 =?utf-8?B?SmgranNNWkFFNSt3UWdpa1hRZlozb243Z0wrSkhETUJ6QmVnUk5jb2p4L29C?=
 =?utf-8?B?NEY3Y1NETDBGOUVuU1NlTHdGMlpIRkptWlJDM3ZTM1VmZmM1VjhhUUY1c2NP?=
 =?utf-8?B?ZlRURnN4aytwaWpndUNLVmRNZEVBaU40U01GQVRmUEViUjRydEdSaFpwUENL?=
 =?utf-8?B?Nm03SHZ3VzN1Tnp6NkhvQjlrZE1nQUpZSHNxSnc1TE9tNG1OL1M0WWJQZXJ3?=
 =?utf-8?B?cUNJckE4RjRzdGcrNld3Rld3eEtGYyt1aWVFUVN1VTgzMk1BM2pBNEFMVnlk?=
 =?utf-8?B?ZEFOSXlXV1RxcHlpRDhkUTQyRTNRTCt6WlBzTFpudC9lSWpZc09JeHZBUDZB?=
 =?utf-8?B?bGZMS2d2ZStDNldPMVFZVDBIbkNRcUNiWEdNY3ZGN0drTDhUQkQwMnE5TXZh?=
 =?utf-8?B?d2ZtcW83ZmZCc0NnVlU5cUNYb0t1Y0dBRHB1cy95cU10WEViUExDRDVLdVVR?=
 =?utf-8?B?NmVVYVFRaHJyMEsxenhhNFREd1djV1ZuaWt5WDlId0ZrcGFvUS9tQkVCVDhZ?=
 =?utf-8?B?OCtTdVVyUEhQQjFxc1NqMDNYY1dMZFJCdUZqTnZuTGpuZEZ6MzFQUnB2R3c0?=
 =?utf-8?B?VURCZU9UVnpldFFUWmFKNC83NUF1elRxRGIwUlN4c0ZTemc4MnA5cmR4U1Nl?=
 =?utf-8?B?aGJPb25FNktnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZENsM2tEaWQwcmg0ZnR0L25KNXhOTTRhTHZ0S1YwOXJQVWtNSFRHV2pIZlZa?=
 =?utf-8?B?VDBNUWJSQ0RMdmNmdldEUDZYRGs2ZCt2bXkyRTBVYjVNMkR4TmVCT1E0RkE2?=
 =?utf-8?B?R2JTYWZJY2x1NXM2dFdGdUxSVGR5eXoyYlR4WmNyN25zK0RKT25mMnJXZDJE?=
 =?utf-8?B?am84TE4weHVjTjlvVHR1OG5lZWpLVzZZRnZmakx4WWlCRE9JSEhJSCs0Tm0v?=
 =?utf-8?B?djkwbWNpeS90VWhMRWdFUmw3cHhXV2gzSC9JS2lDTFk2d0hkVU8vcUN4cU9C?=
 =?utf-8?B?eTI3cktEblFvdTd5OHJMSHJkUlkxL2d0bDQ4dmYzcHozT1R3WXRwVFF2dkxV?=
 =?utf-8?B?L0tvN2lGQk5IQWw2QmpJOTAwaWk3bkdkVks3R1RkNDV3TWRreldRMkd2TXFS?=
 =?utf-8?B?ZFN5bHdPblVwZ0dYUlA2aTg1SVlpdkhCZkhKM2RDL1hQVlhwcnVTSHM1MW9N?=
 =?utf-8?B?R2pOaWs4d2JqQlFOZzBnelhaRmppazRPb042WmtpVnVXQTFyNXdMZGpveVUx?=
 =?utf-8?B?a09Tc3pKL28vQlRWNGE3OUFiZTVPYmt5SkNYbWN3TWFWalQxTk1iYWhsYk5s?=
 =?utf-8?B?WXRpbDh6SzkxLzlZaVBCVlJTQjFHbG1RRkE4aE5VK2hmemVoVUlNSEJ2YTds?=
 =?utf-8?B?a0J3QmQ4UkhkdDRoaWJRQzRuNDUzSXFlUHJXbnZEcVJIQUY2VnlQUkpFOFpB?=
 =?utf-8?B?M1JlQnh2SlM5Z0lkR0NuaDhVMzNtaG1EWmxCek8yWDR2OGZibXY3R3VkY0RO?=
 =?utf-8?B?VSt2aURiZS8zUkhjSE9WVnBJQVk2OFJPdlU3ZkdKWVByUXJIQW5aZWpWNzUz?=
 =?utf-8?B?Um9zL3hTWG9oandrY1JZS0VEWUJQL3hVZHB2K0x2WWZENE8rZXFjMDZyUjdp?=
 =?utf-8?B?S1ljYThVZGNHb0lHRUZ1U3VSMDZvRXdXQlc3bG5PRzFiYjNSK05iVU5VeVY3?=
 =?utf-8?B?Y1V0bk1FMlR0VVVwdVdybXU4bit4SFhFRWRaVHhMekNkVXI2TGtsaDRFcDBQ?=
 =?utf-8?B?THFmNGRQUHR4aGxncTEwRERsSFp0Z3BLQmFwSzJhRjc0eVJxWlFjRnlFUHNT?=
 =?utf-8?B?VGRERmhNK1VRZW5nS3dnY3BoK0lyL2gwQ2lPRHVPN1BYZ29KeDJIM1VoVXhX?=
 =?utf-8?B?VmlOcXBTQ1VMUXZLT2k4Z1RtRUM1REZ3TGNFSFBVY1J1ck9vL2I5cEFiVUZj?=
 =?utf-8?B?Q0h0L0ZCWkJDb2lEcm1lTFJqMU1UUWVOY3dwVElMNkNGZHFqUGx2ZGgxR01D?=
 =?utf-8?B?S05OajB4U2VoLzh3ZC8wdHJjTW54dDgxc0hqUWo4a1UvOXBPbTYzUmVXQk12?=
 =?utf-8?B?aFcyOFc3dFlucjdsWUMyOFVGbnZJcFFERTJiMUk5RzI3S0FCZzVmMEU4UWF6?=
 =?utf-8?B?OXNYd1JMcmFpWTUyVmVBRUlxVGlpd040UjRRb3pYQmpxdm0yVFdvM0kwd0la?=
 =?utf-8?B?V2FhaVZQWlNOZm5iRTdrUUVnUjdFaEltM0daQWRQN1NBVVNtWVBEci9iK0hu?=
 =?utf-8?B?MFMwVXcwcWlCQmk1b3VDTXNENzdybWk3WERaazYyMUVsaWoxWExsNHg0amlz?=
 =?utf-8?B?a0NBd1dHYkxYdWMzMllnSERnZzdHdGhPZ2dFdGxYa09CRGlkQzRPaC9Lb2JM?=
 =?utf-8?B?S2tTV3NWeFl6bkE1Z3M0TGNlTFlsSnl0QlU5SXZFb05VNmQ5Y1MrZjF4Vjhs?=
 =?utf-8?B?M1pPY0hGZ0l1bkhCVUNWSmhVYTVBNU1kNWdoZE8xNkR1YTV2ZnpBd1h1emdH?=
 =?utf-8?B?ZFRGcjloK1RmTnhWUEgxQTJrVGxtUHplcVEreTlJeHpmOUxQRXFWTUdGOHBy?=
 =?utf-8?B?VytLcjY2NUt1WUtrNkswVC9Db2k3eDJrOUNoNW5TZWQxbE1mbXhpSVVkOW13?=
 =?utf-8?B?L1gwU1hRcmlyQXlwRFJudjFGSDJSQ2pvYTBxNXhsOUY3ZDMxcUdpOXA0dlFQ?=
 =?utf-8?B?aGZIVGJjOW5RNzM1cmk0TTVvc2ZZdklSc3lobzYvYUFRdld4OFFGV3VlUE80?=
 =?utf-8?B?bzJvZitHMVFzUFNTeUgycU1GSTg1UHhoSlM2RHIyM2ZyQk1UbTZtVC9JQ0Jj?=
 =?utf-8?B?QUQ5bEZ4SkJWYzlDVHZwSVA0Qm9uVVc3RzZvK3pOVm5lTk4zU0k0bnpxNXl5?=
 =?utf-8?B?bnpwck9MbTZSSkJyK1dUQkR4MVRPZWFNQXc3SllsVFhuUTNUY3V1bWErYlpZ?=
 =?utf-8?B?SEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EE08065728CECB4E99BA8629841289AC@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	r2K7p5E/7m0MGuwMJFkMemEgAwpbT5pvT2un/WYJc1mXW5tJQdsCpX7VvUb5C+wCM2Omn9HtYYuNfOmgiMoE6sXD4EgM6EudGr8xqH52VmQhbbWT92y7P+rGfJLovFRsNhgOsEZ0qyV3B6f75xZkPqf+dtlyqVxW9cysmAfDAvhH5wUVtLj8O5pSXsuxfpee0BUDTyuk9qCtMnUuHAtYnQmTwOgCGMjGiBX4DN5zuV9rEeOu4nEGMD2nXrzbz5rucHKd00b3YqyTymc/iKgLKoYOcuNXJOERmi5cdgrfO+P/bFR6mMtmL6imRmeqc73uU+ITUu86gXys08Mg/+euLiQr6r2lmXWZ6AfN3zjhtu2rDQbYebBrYAFIMsWEn5JNv2UecddB8AT88xEtCII/DQR9x/Gi3hHBpB5g56JIIvKJ5lJXR3gn/NGDunJc9CakrmJjkKMGjzDBKPWc9H9uFuvwfLO3weB+oTZC5um0NtGADlOAJ376pHCEk8adT1/Pr6BcDZffXeoEgPhDiTWnfNSuRSLxjua0cfks+Nng86tvmICETzgtMilvjg1O2ejw1c3AARCWL/i/EF7x/r1hhiCAeSmEEbD+y4P/nye9H91st+KeUobhmHdDugnQkQZ8
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f65f408-5472-4c2e-1381-08ddc9b00717
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2025 06:13:22.6836
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JKrsBY/JNYAe7miGDmGDtthDtiPbfQQuAD3u8QzyKx8mbNYrLhwSjgcirZpgRInqoMQLBqsBU9fh5qDanBRWFiRxuzTvRIJ9vTpBd+AgjFk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR04MB8642

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
