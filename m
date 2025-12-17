Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8852DBF76
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2025 06:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765954686; cv=fail; b=iWHLyOQuOuC1+V9HV9trbQaTODQSw+0NdE39atKz/YhilN1II5bz1sPXKscyzjpipxQRZ7p7rUhYL9sxdGOpomTOq0hYZ8mZqf9nwfIZE0MjlHl0ZrsQn+UmkTMkCLZiuHWM2cNZfmeLkCVraKFW0cLdX6X4EC9hrEDvA7Fu/zo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765954686; c=relaxed/simple;
	bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JsQQ4GRZk0oueJkWNYkbdN+GnBCBd0l45T5Mp2iQNud/5dq6721g9C4w0PQ4J3kzb/H7ziYzuOSZNSaduQ9wvj3axdiBdWbybRR4oco1u65ROc84bVbA6x4HmLMnVW9NrYf3yoke6jKzNOEmIK6FwX4uT/URNHLtDDXz+Aqlihs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=EfFkvI01; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ujgMK4/y; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="EfFkvI01";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ujgMK4/y"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1765954686; x=1797490686;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
  b=EfFkvI015/TTlLqR8MHnzs3Gk1UH/Bt/ZhViV+0k/kQbIpnN6ox5Uvh5
   357I+vhlksehkw4UBtAXJEjyaN7UlXzNFLVobIudmQVKy5bUm++7tchbR
   JvLqZ8hdZBuXtXxtopDaGND+LI7QfapylhsR3iWQ04+FS1HwI4TwP3F6G
   mqou7A3VLndlIXGJF2NatF12zdSCpUbTE+EBVHVjqUecrn4mE2AN8ZoRd
   x7Yrjsn7nQAJ5GusMBEbbYiTDss1eJ/wt9QMz8Q9SMiggbRhVjSR4wrb5
   +BngChtjYby4d+rdLTO8NmgKeTuiLGtyMr9BfyOI3pjwHnWmav+lEeMWR
   w==;
X-CSE-ConnectionGUID: Ae97P7u7RTadDfu0UfFitg==
X-CSE-MsgGUID: ns38u6/USQu57RGuNxg6rg==
X-IronPort-AV: E=Sophos;i="6.21,155,1763395200"; 
   d="scan'208";a="138039123"
Received: from mail-northcentralusazon11012010.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.10])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Dec 2025 14:58:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KitcFGF1znMPtUZ9prDBppj8ghEM/ZtNzK+XHN6cWd/xedfwYynjw4ULprvXIVhurhfWg+3F6WlwO36xVBdOc1WR1ibu8rkwPao7FshK7WVCoC2hRnNw7Cbq7mhpcVywtUOVlNXrHAGwVmo+5Ktpdv9NiBOlBWKW5O8egkiHxD6FUyAGzoDaVAhzV89LwbicaLYpodixyviktzKhgLebJlg9WnuAhtJvtSf8vNjTt1rqPTYil2wZz1AkGqffhvqd5Xk0dv3dMvLfOw18YTvVyM+SmTtXhPWlDZM2HUxr0N62sP37UKzFg6VuTrqx/6W28rgl0wsRT8DVYEd6lKdIDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=tgND6F3BMhmzpe+YaMxi4u+Sfx4wsJ0gY4EGI+vzRSFN26knSrXQMPstRzey75bLFxONI90lMtrW5H6FohpSa6yMxlKAjuwHBXcGqgTBpgRO/msN20IPTylkBUB5x0ogvOWHYj2ZqB0bdwkpEFs5GG+Jo5fvAYqoDUGVlEplIEdNPblD1iMETBxIj04pqlzYUkjKQbaQgs2QDDedZmr+GIndFgKUJtoDFgz4wiFbep0FDZKWkL1StyJgq8tMVPbjBE+Kao4d5NRpWj3eAPWEkSxX31a21bg1iT1nijkk7z0RSzIlwj7MTaGNPHGMZpZEKo0q+c1IwGY36jsffP64JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=ujgMK4/ySvTH4ycBiQUTtxyvp0Kg73pD7Lz8f6vIDtN+vBPhnv2dCY1ftEvooniQDdMsM/8cGtBoIjCcI3+oPy+cKjx4/T14VTjnHSxXXQUFT33W7Zzb9k7mM9JcuA4KaG2CZnpeNS0J46g4Ojyazqini624MFJh2vLguUMKFyk=
Received: from LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13)
 by CH2PR04MB6934.namprd04.prod.outlook.com (2603:10b6:610:9a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 06:58:02 +0000
Received: from LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::9ba6:7273:90bc:53a8]) by LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::9ba6:7273:90bc:53a8%5]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 06:58:02 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Damien Le Moal
	<dlemoal@kernel.org>, Himanshu Madhani <himanshu.madhani@oracle.com>, "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v4 4/5] scsi: sd: Move the sd_fops definition
Thread-Topic: [PATCH v4 4/5] scsi: sd: Move the sd_fops definition
Thread-Index: AQHcbtAZWb239KPPd0WwsV7PvqOpgrUlZ1gA
Date: Wed, 17 Dec 2025 06:58:02 +0000
Message-ID: <2cbf43ee-d65d-421a-9019-8c0ad7e8fb16@wdc.com>
References: <20251216210719.57256-1-bvanassche@acm.org>
 <20251216210719.57256-5-bvanassche@acm.org>
In-Reply-To: <20251216210719.57256-5-bvanassche@acm.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR04MB8984:EE_|CH2PR04MB6934:EE_
x-ms-office365-filtering-correlation-id: 8d679f28-432d-4da6-248c-08de3d399f18
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|376014|366016|10070799003|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?eVdLcUxVcGdQSS9CTjFab0FjcnpUelljUE53YnlYUldBZXluK2RacUpRSk5K?=
 =?utf-8?B?TWN2aWFHQjBNTmtrK05zRTBmK1lKS0hIQlB5cTVGRWdmdm9TbVpVaVF1aFdx?=
 =?utf-8?B?MEZGRlJRQjhCYy9WZ1N6MlA4K2FrbHBqOEJYczVGbGwvRUtod2R5djdLU3BC?=
 =?utf-8?B?NG81cEVIS21tYmE5NXBqVXF1SGFLamhpMlpSOGdOOHlhSGFLZHBrM1pVTjg0?=
 =?utf-8?B?Z1RBaU55QURQM3dqWTdpaHpIeFV6ZEN0UWpHem5JZGNQZHlYTG5ybVZCTHUr?=
 =?utf-8?B?RWFVYW9qU21ZTVc1ZFhyMmd4V2hmMDdRL05WVTcvVlkydFRXVXZ0WThlaDQr?=
 =?utf-8?B?dm93L2JiNlgyVFhxSTNjSWxlQ3pnbGxMd2xXRHZ3b005QWwxbGVORTlVdEZZ?=
 =?utf-8?B?N2NYa1I5U0VEaUM1YUJLOGxyZTliaGg5RjA0eC8xSFk1Q3hkcVVLckx1cS9U?=
 =?utf-8?B?SFFXVDV1ZlRnV2s5cWdHRmlHcS9La2gyYTdqWDA1NnBlK2VOS1l1Rk9IWGtj?=
 =?utf-8?B?VFVNMzJ2SzIwcUpocUFYc2EvSW81WmpSWGhpcWU5cmEyNTdGOEE3Z1htdWE3?=
 =?utf-8?B?RStJN0NzK2VoZC9BR2c4TTJyNFB5QlF0TFZrS1ZQQUJLMDIxSUN5YjNGVkxK?=
 =?utf-8?B?UzA5WXlEdmhmemxXckRJRzVaT2xJS3hQem52L3JYT0J2N2kxWGVlL3dFbTcx?=
 =?utf-8?B?dGtiUHJiQ09wT2d4bFFrWlNxbUltNDZ4TjlhSk9pRmw2TUZyam96YVB5ci92?=
 =?utf-8?B?SXNDTnJ5ZXlpVzl3emdubmNMWHp5NmR3Zk56dEdibm5iQ2FlckxudXpyREwz?=
 =?utf-8?B?MEsyeXJLUHV3MjFLeExRVDdYeFNmdUhhdXh6Q0tTMmJyR3dRUEMwMG9lYXFJ?=
 =?utf-8?B?TXZuUTNWUmRBdlNjdU14Zm5ENnl1cDd6R0VJRDZTWXYxclZTVmJQSVI0TzZp?=
 =?utf-8?B?dStYc1c2QkRXQUJTNnBqdTFvamlvOGZrVnZWUTFsTjcrZkJwM3dlRThuTlht?=
 =?utf-8?B?N1R6YjNqMnFZSkZ2M2xsUzJmc29rZjdGa01HSlhyckJQdVVDalZ6R2lDMGNS?=
 =?utf-8?B?UDA4Um1jNTBnS3hHNVVlRkRBR2NZOWppbDk2WlJpQVl6Z3kxM1BDejNwckg3?=
 =?utf-8?B?YmE4Q3pveFZSeE5xbVI4c2k4SXliUUNYMXgxa0FkMmRHWmkvcnpURzdtL2JZ?=
 =?utf-8?B?ZDUyaUpMOFFFOU4rLzR0cVg0QXZlemtWZU1rK3B5bGFSVElKenpycll4dUs4?=
 =?utf-8?B?QXhmcCtndncwWGNaZGRoM2pKbkc4RSs2NmIrclFlTkN0RFJzUjRseFFRWEZD?=
 =?utf-8?B?Q2VsSVd4Tk5pU2wvZUx6OXpvbm1RNDJ0RGEzWVo4YkNyQzNqbks3VkZoVzVY?=
 =?utf-8?B?ald4WmxOWlN4M09oRHBsaFNzWnVhWDZZeHhsMjZpYTNRTkZ4eVUrUkdENXI0?=
 =?utf-8?B?RnhaL1AxQmlub05sbmRuMTUzVWRMeXZCMEZpQ1ZsajZzbVVYbTA5NDlrdldz?=
 =?utf-8?B?RjdJck4wUjBweGhiMVN1Z0tMR1V6NFNrZmV4SEFqSjlmbEYxV2FvNXRSOXVE?=
 =?utf-8?B?M0txZko3dmdCQkFwR05mc1hCTnNLUHVnL2ZSTEpidGdQdFZiZUtDZjZFLzdW?=
 =?utf-8?B?andCaHJZdHlLbVZaUkJoMzVKNlRhOUF5TjRpQkFPZmVBWXAzamE0RXYvSXBs?=
 =?utf-8?B?R0VYOEVRK1dWdWc4L3lacExtK09rVnNtSzZUd3VUWE8vemp1NG5RK0lNM21I?=
 =?utf-8?B?TUdKR0o4Slk1TVRkTWtxMXlXMlN1Y3BzVWZ1T0hvRlBoMHdubnZ5Ym5rMnBl?=
 =?utf-8?B?VG52czFLS3lPdHRvemZuMElDa2hzTWJBNzlxTFN0S1FGQ2hmYUZTd3AxdDhZ?=
 =?utf-8?B?TGEyMXVCWitEMXdEbFNtenIvRE1Kc2ZjbE1lVFc1d1hva1JVMVBJY3NRS2Vz?=
 =?utf-8?B?b09wRHMzMHJ6YXN1a1BLL2xHREdPNnlCN0VZOUpLMFNYeFNBOEgwWm82eWNW?=
 =?utf-8?B?Ynp4VzZGdkNrbVY4c29oSFRNMGRtbGxjVzBXL1VQeS9helFEMFNUVC9yZlY5?=
 =?utf-8?Q?qKBO4g?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB8984.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(366016)(10070799003)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VXI2QmlNaHhMZkRJaC9VMmtOdDJ5c3JpaGcxS2VrdE5DaTZaejdDcWZqamEz?=
 =?utf-8?B?dUtSK2J3UmsrQ1ZlOU5Kc0JOamhHNWNveWQ3UG11NmhKU2ZpSWthOVJmR1NK?=
 =?utf-8?B?RzlaQVZLbXZBYkNJWFVKRmpuWm1NQU1nY1U5QWlaUVJYM1MxMEtveVJFYWNS?=
 =?utf-8?B?T0wrelhaZDJtNTFYcGFmM05KcXoxKzRtbTdwR3lodk5LN3ZEa0JFdVRKL24w?=
 =?utf-8?B?dVFjZlRhY245dHFQQkswREVMQ1BnZE5xTEpQSDRzdmdZYlhTeTFIQUhKeUd5?=
 =?utf-8?B?b0wrWXArVTcreXhYUUhYQms5ZG1Xd2V2T1N0S1p3OG1yUXhJM1ZycUtQY1Ux?=
 =?utf-8?B?SndJbGlPZmFwSENIUFhCVnBVMW4yUzN5SVZ1UVhtdjRleWtwN3RkM3lkR2tP?=
 =?utf-8?B?Zm82VXBVL095L3ZPYjNpZW5DK2FJN0xiWGN0MDVQTlBrbS80U1VQUTlHN3hy?=
 =?utf-8?B?bFRzeXM4RHdvUURxZDc1WjZKWXc1WUdiaUNQSHl1RUtlWXphRi9jS3JQbGNl?=
 =?utf-8?B?eUcwdTZwMVhnbmlQVExnNUxRTlZyc3JtVkZlc2J2ejdKME8yUFVhS3pjYURS?=
 =?utf-8?B?ZWd3b1ZHK1lvMlVhS0lwRFMwNmhySDhMRVphQzJpT2FqNWc0ZFRzT2dvMVhn?=
 =?utf-8?B?bnJFdGJxQ0VQd1IwRWZCemZ1NU12RGc2a3VRc1VhWVN0SlNMK2g4d00zUGNp?=
 =?utf-8?B?bnRvbDNlczdXSHV5ZDNDcWFZelN6bTk4Z1M2SjlDVFk0bnhFVmVTTWgzbW9G?=
 =?utf-8?B?LzZteVhiYWtYR2FMdUxLSFJGUFNGTmZBalRGZ2pTY0xiTE04ZXMzcGszTTRD?=
 =?utf-8?B?c1R2NlZtUlFFSkpaQXhKNTAzVjJLZDRCSk1vTDEyeDVBSTNwcXcxc1h5R3Bw?=
 =?utf-8?B?M0xQbG1vS1QvU0llM0tUbGx3WmhNTG1PSVJhMXovSGN4R3pxRnZXWTFvekpS?=
 =?utf-8?B?TUhETElkc2JFMUxNeStuSEJiVWxDQkcrR09pbndKVWt3Yys3TVo3dGpYazI0?=
 =?utf-8?B?bjZHSjlwYXBHNWlMRDQ5Q2RCR0Mva2x5YzcycklldStUZDk2RVpGUWcyU1Ju?=
 =?utf-8?B?RzEvM3l1bkJieGtMbndYbGVUbEliazBvcEhJbis0M3p5em5vTGw3c1NBMVNK?=
 =?utf-8?B?REcvYXdJV2FMSUtidUtGZ1lQKzBzemRoWGh0cUx5YlRvL25wd0hqemZBRHh2?=
 =?utf-8?B?Y1lGZ3l6OWNabnJUQytmaGZBM3FwVUZDTi9KcHBsYjJFMDAyVDZ6a1dpSVFn?=
 =?utf-8?B?MzY4QmhMUnhoV3hpZWtydll0MXNGRk5UMm04MFlQSytaek5xVXE1Z0NMUFR2?=
 =?utf-8?B?cDFlazBjTXl5VHlXazBueDNqT0x6clhYOXBKMHBnUU9GRjE3cTF0cjRzQlRV?=
 =?utf-8?B?bzVWV0o4d3JvVmxOREo4dlR1RTdLamZ3bHcyeVpYbW9uenNuK2ZzclhZM1J4?=
 =?utf-8?B?S3c3VHpuMmRVNjg0UFBITmRVR3RnU1piMUl2Qk5GVFJzUzJ0Yk5jakFIWlBJ?=
 =?utf-8?B?VC9RWlBQVmdMRlBhQzdZQ2ZyNjFRMkJnTVgxeGtCNER0R0ZZZnZzQnZ1aDFC?=
 =?utf-8?B?VkRCSVZiSm5HYjlrYnhSTExwd0w3TFlhNS9BY1lQWW41cDFCbHNlODlHN2RB?=
 =?utf-8?B?bll0cyt5bWdEOFYrOEdoUGtySlIyc3NmdGpjRkQxaUdMQjhHMi8zOXhKTjhy?=
 =?utf-8?B?YzVPZzE5eTRmbEhqNExTS3lRYURQUHdjM2FaRjg3eHFyZm1wajNnUWtYVUwy?=
 =?utf-8?B?V1N4L3VZZVdGdnhqbmN5NDdXTk1nc3Vxbm9jT1l4YUlJUytoaWlySkpDRWpK?=
 =?utf-8?B?ZXhnTldQM0JPN2o3N29mbVpUV09ubmxTWFp4eGl0U24zc2R4cm9vaGRZc2xr?=
 =?utf-8?B?ckp3dTRGNURNUGFFS2NoelRBc3E0Y1ViS014Q3F5aGE3VzlRT2Zja3ZoOVFF?=
 =?utf-8?B?SC9sR2luZVFRMTJnVUhNV1RMNXBERlcwRnBzMWlxL1VmUnpBN1JIMU50MGVT?=
 =?utf-8?B?cGVEQ3ZuMkI2UXcycm9xK0cwQlFmb0MvVUJMSTZGK0hYcmNBUnM0ajRVZk80?=
 =?utf-8?B?N2g4NzF6d0JNY2RPOS8rSldQRDYvL3JKSE1qck9vUkNINUlZWFl1NmU2ZHBW?=
 =?utf-8?B?elZTOFN1YW45VGdhdmJ1UjA3NXVic01JQTVjVXM1R1F2SkdpdUhxKy9BSFdH?=
 =?utf-8?B?SmpPZXRxTFJITVkwZTZ3N1VKOFFNeGFibzhXRFBScU5OYU5IR2FuU1ZaNG1B?=
 =?utf-8?B?MDJjR054TU5iTGVmYlJvbXBmSytnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <02D77FDC0D14CC4F8814A38CE2D1BAC4@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RaieMS13pshDZ7bjJqWnp6iA/8YaB36TBpFYVJETtbzKkOdfzoR6hK5xjsp7RYbNSc/iOEWJvvxRbmJCIvwdeq194iPKhyqZIGqNOxGUfvCGmmYSt9g8GHhgefud5cY8isSnUhHH3FZoi3mku10rA58jpzyp4Mg+TVmLJBvwD2CTXlgIo/UUcUR+LWOknSkTG1hLcgWQBlXDPb79Ch0wSjR8FF9t0kj4Ic9BDwrhZwY+apYhAlvybnYj9r52yepaDf8PQ5mdke76Vg0ZV5dPGTPc4T/9ywIuXlAawdl9o1rNdvN9a6xTNLi9O+mbipl5MTNKdiPplTnOq02QsmKWnDjlGD0qbE8SZB89d1c4FO4stMu8y1iXvpP/Q3Z60jZwf4jN0g1nxB0/U2hoRZ+nGDzGbaMin0BIfS1hwhHy/IFUdSp4FE1L687Us5d1RAnPC9I29zHr3pWKJOAMxAIGQB4HXtDte5l+koJhvzAix3MbFAJlMro/zVy+xyn2QFKrF9dyEvZEGQZzSrpLGtGjEP42lBXhqifRRo4yFu5KrUrHCHJuAG0x/N6RY7jfHnmiSTidgmaaPe24UB55OGWKIe4CnKO6q0S8Kqo8eFqZvYZDepK33u/pusrqzWYVCOr6
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d679f28-432d-4da6-248c-08de3d399f18
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2025 06:58:02.4164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fCYvEYPT7s2Fja1S4GyDAzhhiyUzw0iiHnvzVv66OziqJ5n73d0UqbZyGStwfe1aGo7sShIVxmaEL3Qoup20QmEY0zlORP9pCBDx+MRjIi4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6934

UmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5j
b20+DQo=
