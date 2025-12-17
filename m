Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE592DBF76
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2025 06:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765954650; cv=fail; b=cK5hCLlhVpqEpCNaX3dQHKauA4uE6VpXmhpjIeeB/SwUWZDySM+wOcuUStYRvdo4HNBmZBfzBnw3fPWKsHidHorlBNklGswhkZadajDTVZ7yeIMMtbOpJkMrx6DWkWFU2wKfrkthF1mGazuZ4flHB2YATOkAvF7/A4ECJXDMaHQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765954650; c=relaxed/simple;
	bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KGM4bI//IHRQ0V6cn1x6zIR+/svnNelZjbk0wZC2GkhH+uyy7srIpMpubgR1IRIQco03nuyuiUu4H889sh+VKmv8wTkcipvfHH5yirKi+wTNu8K0Adwk1O4rd7ufro/TWrA3yE4PcJR0IAfbP7CBpq9UB2Psvbj8gKsFt8LwS4c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=qaBwitjr; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=bGq7BC0C; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="qaBwitjr";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="bGq7BC0C"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1765954648; x=1797490648;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
  b=qaBwitjrZC9L4N8FzK+7tHSs/uelmzOsibdHHEsB3N91Bu26f0CvfeXf
   n8fJGqfVVmJo1hhdvctcL9DkN0kbDX1ZEkwbL8d4pa2ynNipK8y1F0zlt
   xJMhBWmrt/2pguwfMOQcsrWL0P6NKP59NdjaFL0gQMvIec5L9uks7MR9O
   IMJB7duUxMAAtEguqlmfOB8FqMLzsLLmd+2uC8q3JixId34GLZOLb4DU1
   tmSHQuMVUug87BktuaiQ3IDi1M6Q/1240K7+tsdLb+SPFEOFY1QajVXJP
   8WSQo133DqKnCaiStATZqgQMYAy8rARPIptbnQFDpindfXLx6js+xghic
   A==;
X-CSE-ConnectionGUID: KA14Fn0TRNaoknpmXg5inA==
X-CSE-MsgGUID: x/QP3QkKRuOP1gIEkM+M1Q==
X-IronPort-AV: E=Sophos;i="6.21,155,1763395200"; 
   d="scan'208";a="137105108"
Received: from mail-eastusazon11012005.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.5])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Dec 2025 14:57:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JN4LIE9LHzed5eQgiDHrBSxnYRM7twDCJ4YoZJNy/lpbK4v+YEmFePULzmWaiq4BCIiv9/UpxplU4Ca5FL7b0FcDTYaX/p/tIFBg9bNnixnvpMX/vMwWTSKozj4yoZh8u38j1Q72BDHURIA3kmkPUUsHcMLzF5PTKsbtWkUQgmCWsYi6U5dHeiNCrWdRK2SR5ygi0a3fpA/JJIYBPQTddiijgImNBGTsHbeHMCj8NGFP1AK3DrhFELTQkfxQue5YkXnArwxWzv+tCg/dKVeDsxsMqymGGzjAv3Qy0EpTCI66g6sDXcJJNl2b1Mowvj6h4nqbuznsA4bI606P37aREg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
 b=dr8QG3padSNgVgFhe7Y7E/qcjkrlT1i2gbr4xumL1xj1xLX4Gu6XxzMFPPvYJp2ZNOS2+EvI/tBFIA/FlJbZnTRYQ3qLdJnvxbRHAapGiStEeLIC6+kUbQHsBh/9WHlg1pyElzn73mO8znL/UqXgkUv/ifsePbidkKy5yzM821R5Gv8YfWyimZQhqfXuRu9syLiXAcuvXv9i5467aBn+Q80q+PiINnXNP3FFrtKPzNwbO9g2kw1MusiNmDXX450wiQxlpIavYJRUgU3jPsLcg0DKiKMdumfDr4SOC65/h0K/unaCo0GdqdcZOsiQbUYo5KL3mvNS6luiWmxIhsAazA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
 b=bGq7BC0C81FnUZw2E5JBnCscfBBtj5CyeYwUi++nJwdAGGE5lmP2Hge8Vf5FdCBIJZEh+W41HOkubPyd1URPfwzsH9EHKosz7gNjAs90S9Gcm277xLwXSRRe5OXz6kjyUNYmU/FG9t1Opk+E9VAd7rA5kYx3bbba2fxbmWyfp1Q=
Received: from LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13)
 by CH2PR04MB6934.namprd04.prod.outlook.com (2603:10b6:610:9a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 06:57:20 +0000
Received: from LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::9ba6:7273:90bc:53a8]) by LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::9ba6:7273:90bc:53a8%5]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 06:57:20 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Damien Le Moal
	<dlemoal@kernel.org>, Himanshu Madhani <himanshu.madhani@oracle.com>, "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v4 3/5] scsi: sd: Move the scsi_disk_release() function
 definition
Thread-Topic: [PATCH v4 3/5] scsi: sd: Move the scsi_disk_release() function
 definition
Thread-Index: AQHcbtASN5CyNBWfD0WiC6q0sd0iy7UlZyWA
Date: Wed, 17 Dec 2025 06:57:20 +0000
Message-ID: <222dcc40-ff98-433b-8b6e-2f3762a2df1e@wdc.com>
References: <20251216210719.57256-1-bvanassche@acm.org>
 <20251216210719.57256-4-bvanassche@acm.org>
In-Reply-To: <20251216210719.57256-4-bvanassche@acm.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR04MB8984:EE_|CH2PR04MB6934:EE_
x-ms-office365-filtering-correlation-id: c0cbfa71-81b9-426c-86b6-08de3d3985eb
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|376014|366016|10070799003|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?R3o0WTJDeTRZV0MwU0sxTnNJYVZnSFowWk9LZkxQeXhsQVZ3cE4zSEJhVkN3?=
 =?utf-8?B?MVM4WmhmbklGTVpvSFczZFo2Q2FZZmNIZlZ2MTZhTGtPdEVOeW8xOTlXUk1B?=
 =?utf-8?B?SEFWdk8yeUNXYXRjVHQ5MElUQVVWMm5tU3ZmWVhOTDU0UjlXd0NYVzlKOWxp?=
 =?utf-8?B?TnRPQ0x1dVA4TWRqTElEZFRDUnZGbGp6am84SXB6d3p4OXR1dnpseXBPWmtT?=
 =?utf-8?B?RHUrcFIwZlM1WWVpSDQ1UE5tMXpLM0psK3NCZmxJT08rRXZrb0ZuOW9CRGNw?=
 =?utf-8?B?S3UvWFBFRDg5NXZJbElwZG5HdkZoY1F5dzlicTllMDh2MDRrSW9rZWN5SllJ?=
 =?utf-8?B?SThPZmYzUXN0Mk83UWQ5bmp5TXMrc3R5c2VFZWNXS3lhaEV4RTRGS1MxYUw5?=
 =?utf-8?B?Q2RYcFcxU2ZjcWRNK3dPSnNVaS9BSFh2aloxMWhFNkZ5aU1SUVJLMG5yVDJh?=
 =?utf-8?B?dHZBcDBxTXB1a1NaNXpNVGE4dVl0eUNvRnZoR09NMDd5MkpkRlBnU2dvWGR5?=
 =?utf-8?B?VVpXemxPckVZT1ljMWRyUWp4M3JzMjZxbi8xbVc0NHNGSGEreGl0d3dOZmRq?=
 =?utf-8?B?NE13QUUreGdGWG9OckdNSWtPMnJBUGp1Tk5qRXRaL1luTW96MVZpUkRBR29k?=
 =?utf-8?B?ZWV1cmdOY05rc3ZWaEIwOVE2TVZYQ1hOb2xRQ0o3TjdjZ1RycmI1TG5yOHZt?=
 =?utf-8?B?MFBqaVJodEs2QkNuOGUyK1NUZFJnYiszR1R5NzM0MDU5SXYyUU1halBISjk4?=
 =?utf-8?B?cmhGVmJuZXFWTVQrdWhtSEhKK29qVjQrTHM3Vnh6cHorMEJxbzNyeEw4dmRi?=
 =?utf-8?B?YThTUmg0ZlNDZHgxNGJ5NnNlSWkrb0hsZjVoeGYySjVJY1dYZW0yKzVhRFEy?=
 =?utf-8?B?WDkyNUNEVFJNUm5QanRCKzJsKzBXTlIzZ0JiVmh0OEkrcmQ4OFc1VkdkUEZI?=
 =?utf-8?B?NkxUdUdQZVRua2dRVjVZejg2emNBdmtwNkFVT1kyM1ovKy9jUjdrVWF3L05n?=
 =?utf-8?B?dlZ0UU5QTkNUNXJTOEZtTnNCTlE1ZUFhQTJQdUNvSUdyNzdsVkg5TWUzY0VP?=
 =?utf-8?B?aFRrWGpVSk1hQzVsOHl2NGFQeEtPbmdrVWxTSnFMcUJ5MGlDNFdOMnVGcTk1?=
 =?utf-8?B?MXJWcnc5K0hHZHNlWU1EcjNSdmFFSlQrOExkcm1WUVU5MjY2cXUvN0g1ZGU1?=
 =?utf-8?B?QS9BYW91ejIvM3VTL3A5VDhoQnFoUG9GNlNxZmF1WkswcmNuWUgxQU1JTlE4?=
 =?utf-8?B?UnZ0NnVKSk5rNXYzNENrS1lMelVsc1Iybm54a3hHbVZNZ0VjaHd3UHV1aTk3?=
 =?utf-8?B?TWZyRWl0bzY1NERMekE2QjFvUVh0aURQVy9hRkZtQnI0L1FybDJVWU1NZFhn?=
 =?utf-8?B?M0swZjZsVmFJY25CdHEzVWZrVkdUcDhubEQ4eUlMcDQ5elNDUFBXdUYrSE1P?=
 =?utf-8?B?Q0ZJL2tVelh1QjhMN1V5K2d0QUExOWJJejZKRGlSWWU5RElzVGhkRHhtTm1F?=
 =?utf-8?B?emZ1L2hlNFJjL3ZzRFZWZ0M2dlUwT2ZzbERhbkN2MStBdUdxT0hnSXBaSWh3?=
 =?utf-8?B?WFNNNHZvMU5TS3dEY1Q2emRyL0ZBZ3hoNVI4OWpyZm5GOGtiS1R0TWwyQ0Nq?=
 =?utf-8?B?Qm1hZGZ6NmZGamJYVk8wNUhBQ2ZEcWZUS0laa3NOUXd5RGhaem54OFpJZjdy?=
 =?utf-8?B?MkkzMS9qdnM4ZDVKR05kcm9adWRCV3VtUzhpRmRlcFMzVG9OV2pkb1R3bEZj?=
 =?utf-8?B?dkRtWkdJeWY2R0trUHg3MzR5R3h1RS9iRnhPS3lrQ3Z5U2xwT3dnaGJMaXp5?=
 =?utf-8?B?QzZqMFQvak05VTJuaXRGdG4rT00xSnFCWnN2SFlnU1VFUDhaTityN0JpQ2J1?=
 =?utf-8?B?ZWVWWVV2b3FlZll4M0hrRnFxL3lvY1VTRnFtWjhMNXE4Vm1LNlJadnZITjl3?=
 =?utf-8?B?QnpMSXVRMDhEbnA1TThIWmU2Z0xNdDh0WDBiYVNXVy8wNnd2TGhqbHZCOXRo?=
 =?utf-8?B?OFpmQmttYjczOXVVMGdhNWZMengzaVVibkUyTWF3ZG0zdVBqdnZPTFY5ektR?=
 =?utf-8?Q?dJkzeK?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB8984.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(366016)(10070799003)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bzBEZUJLckRaOC9ibitUKzRFMmt0elUxNndyTXp0S2haN3p3RGNLL2o3b3My?=
 =?utf-8?B?L0RSWFR6OU9lSTR3YjQ3M2dTaGRSbDhJZ1gzWHU1b0xsUVZXSXVJdkV3cjJ1?=
 =?utf-8?B?M1BYZDlGRW1zenhhK0oxSE16ZmhuQ3daSTJrV3NIL3ZTSlNQMWt2WURxNHor?=
 =?utf-8?B?TU01aU9kYUNFOXFJZ0s1a2RWQXI5Wmx6cnJicks0SzVXUGh3VUVkdSt5MWZm?=
 =?utf-8?B?Qy9pMllWTnF1MFVyelNJclp4ekVVVzJHbEcxbWpWdjc4WjlEblJ3Vklzeldu?=
 =?utf-8?B?Nmk3S0JYdncxWEVyZzJOaWxtVDFvT1lHaklRUVloRHAzNXJkc1k5S25wZ1kv?=
 =?utf-8?B?Yk5Xd3NJZkVUcFNFQ2dZV3NuQ05jTFdiakpsRXFKYnFhV2ZVVjhyc3pNK0VW?=
 =?utf-8?B?aWZkbW11MDllS1hoR0RXM3ZiOFk5WEVsV2hMMTFuK0N2SDY2M0JRYUkwQXlV?=
 =?utf-8?B?QVRWSEpKbWwyN0thM3I1cllQKzZwTUV0aHVBMUVWQlFmTFRESko4cnB4cEFR?=
 =?utf-8?B?VHA5T3QxZ0xKbFlZZ0U3QzlPN3UzYW9pVEpSTWJLbnQ3bnVWRWdhUWtmWHMy?=
 =?utf-8?B?R2cyczJ3MDNJRmxxYmd3NFNJNHlYanJsSG9ycExGNUpkNFFjYk40REYzQzhP?=
 =?utf-8?B?R2hCT29WbHpHbEI2cmtxanBrQ0NjeGJQcE5QRXZqcXR0UGlpMHBCdXRVdGN0?=
 =?utf-8?B?OTU5RkUrVy9YYjZNelhOWlV0YnIrdWJPWm9sMDBaSlpwTTFyemJQUTg4MElT?=
 =?utf-8?B?ZjlnOEp6YlJWNkxBSCsxQlJDSFBaQTZHajJNMm5CbFVUeW1NZ2cyNW43L2w0?=
 =?utf-8?B?Q3pzTHlBNFpheC9BSFAvT2xHUUUzTmp1MGNMRUlyai9YaHZLZks2T2Z0UnI4?=
 =?utf-8?B?d3p2Uk1COEtDa25HcndLMTIzVlpnTUR3SUtjL1dwN2NraE5yMUNzWnBkMDhV?=
 =?utf-8?B?clBQeWwrTFJoUkVNVGVPSzU4cHBLd0NHV2ZTTThjRzZaVk5DazBhbkI3RUc1?=
 =?utf-8?B?VSttdDAvR2xYZjhLL05rMEJBWDZaV1RqbVNhUUVkKzFwVVU3SnpWNG1ZVUZD?=
 =?utf-8?B?WDRocVV5MGpEYWtJeUU0bUw5UklZTVNjTjhmbjZMZGxzUDEwbmRQZUJja25J?=
 =?utf-8?B?Y2lGV1ByYkZrUkx1RGJWRUMrL3pHbUdWdDFLYnhaZzFCY0tjaG1oT2g2ajY2?=
 =?utf-8?B?MG1OYUdwTVJ2Tlc2dXplVXh6NlBFZ2Izb2g5cEw2Z09WdFBUMWhQWkt4d1Zk?=
 =?utf-8?B?L3YxVGFzQXQwekRVWlgrdHZkTTYvVUc4MUZhVXRaRUdCZVVjckoyV1Z6cFdP?=
 =?utf-8?B?NjhueTZTRUVmMTdsWmRQK00zQzJhNHIwODdLaFBMVXFtSkRTaWlzd2k2S3Vt?=
 =?utf-8?B?bVl2dHdRS0dQZmFCTENMU0krQ2dtWVZMN2owNHBIQmtFMFR1aDhTY1dUZUxF?=
 =?utf-8?B?aWp1Zjg4eW9mZm1Bb0NTOGtkNjVlOXBjbGw0Q0t3L1Q2dXhmS0JuN2xNS0Na?=
 =?utf-8?B?bzRyUmZFU2s2NHIvMURYbWpINWpuZnlqdGpwMjdVL21VV0R4NWRIcWhXTzBS?=
 =?utf-8?B?YjZPYUxIUUJCSGZZUWJsU29iS25WYU1jMW5GZndheXpUbGpCSjNPblNNR0Fr?=
 =?utf-8?B?UVhMejlvMUJ1NXIzRlc4QVZqbFAvMURJQTRTRFYybHVRUnpyY2Z4RVJ2M2RF?=
 =?utf-8?B?RHoyUy9naExXNzZXaVJxdWhzeXFXQldXK0R4SGtwUXNqZWE4OVpiYitJMEpq?=
 =?utf-8?B?Ty9yVW01K055SkYyUUFpUm9ycTVHckY2UkFhQW9HQnpFR21NNmx2TDlvWXM4?=
 =?utf-8?B?eUc5WHFtcGFzT1NmaTAxdXRQNjdpdEt6bWlweng0eE9ud0hCME10NnViQXVL?=
 =?utf-8?B?UDRJRzg2OXZtUTdQR0tIUDhHcVZGV1J5YVdKRjExaDN1N0lKNjhYOVArSTZO?=
 =?utf-8?B?aHVCeXhZNnpqNTJBZkdMV3BUOHFjMkR6Z0xXM2ZEa29xMHp6WDZxMTYrVGdv?=
 =?utf-8?B?cHREbWlCNkh0U1NNdU9ZUXhodXlEWUJZVTlNVzU4TjlycDJNUG80eDdkZDJy?=
 =?utf-8?B?RE1uTFJ0YmxaWDJmMVRZdTh6emhJaWxmb2czRFNnazZzVnpjaUhTc2FWTTJy?=
 =?utf-8?B?UXc5c0tSd2x3bFdpNWxESFp6UWFFRGFVZUxPZlNNRGdHcW9IK3EwT0JhTEtW?=
 =?utf-8?B?cnUvZjk1ZzVIV1RVcWhmZ1BQUGFqSFRlNGl0NG82NXdUNHhhdVJuRWE0OHF3?=
 =?utf-8?B?cTI5RzMvczEyMFVXZUFNRzNBell3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <72B25886E419E94E85E820F93836EF89@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	t9klrjnm/PSS/Dt5nsd3GwNR/GVemW+TlPavY43Iw7zX6g/14p4gaQJ5XnqEc6tXGDocVFBsE5iXWRnD32A8AqyQAPm9YVi2+nWEtIrrT9K9HimeJLnErQMkFj6Ij/yjUv0XdrfCpGE3LenI2F0l9btDVKWw6XDmhvA+sHfet/oCHAqfrBuYShdmVDiRPh1VtK8zfW3WqZ4YHxmpAo70QpgcVY2FyogfgbKY0oHKYDoorCrmLFASLOIgnsfR8ZdaHKtwnuoJpNAvKJuSRDorVXeKpIi9hyVwRYkB7vifV/6gVQo207G0qfiQaJkZedv/TQv76vlTFRBktJiq6itsEfNZckUMrYdUmFOeglJdba16ylLyKxDRUWE5LXt3K/A1ysv6VwahwFcgEqiV/fjM5YKZLNYgiQVqxh+KUG4bwzmz82ZFbXSkdm7xJ7ouw6UdMbvnUwFHtW/4ohoedgv+GE1Qe4nUGw11lUUmI8PKv9RoNwYIC7FlNMZiVwfRspd11uLKDFOgZc1Px0EfHdxU2HHjgy0KzKpwqTMQQe+JBgScG5fbO1AJwcxkmrisqp5aiG1gsM5B5+Rx3Fd1S/62P951Ejg8dxPLsQJIw1YMLzt/1HecqSgRZ5yF+7Ryezo8
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0cbfa71-81b9-426c-86b6-08de3d3985eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2025 06:57:20.1948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QIyyCJFX+ZbFkWqktkAB08m1iNgpQq97JoiaU7YfuIKa6hPQX6mURww39mNQX3hVesdeGWnTx1WSLJGVDIMLcJkRCADXZkBWG1r72NIAx9w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6934

TG9va3MgZ29vZCwNCg0KUmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMu
dGh1bXNoaXJuQHdkYy5jb20+DQoNCg==
