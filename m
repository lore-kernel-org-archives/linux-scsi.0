Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59D11CAA7B;
	Wed, 25 Jun 2025 04:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750826293; cv=fail; b=kiGTry10ehMIuQt2BqddGdRjTRupyxUbsX0AdwFaeKWQ3EInxJ/cJF7Iq1C23WiK4wsqbf8SfXGUJDbrPc9O7yt4v4vE7eUoDF/kH4S5UcfaP3imEgy8qNNcqt9LxwoWaVgGpcE4HGtzI+FbgnQZ0uXvEKl5e52JxHmy+n5kiUw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750826293; c=relaxed/simple;
	bh=cyQtMYvtlSg1HhuPezkQ0FZAEptL3OCXF4jBn00U6vw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fPNKCmp0Xfo4Fe0RkBN+m2Hj4PNbEvdWohwXgjgcvEO3/knW1UvTZtl4gAZrcElpDa8cSrHtxhKyPbNdibyNxde96s5+TLe8+RMg86XirOze6CTljsP+U7+xM7RWi2BR2V8f4BCATuB9AaHpszugnP3ULqtz+3T53TNbNanRsSc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Q/Y9hLaE; arc=fail smtp.client-ip=40.107.93.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Q/Y9hLaE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GmoNv/WCNgPf+1Zy9DZtc39rn7mOLT7z9iJ8nlbh+Z1rrqWLqT9iPvTHeYopjtgYPGo9Tz4NjYfpz68pZcs3ga18NaTr303OjS8efw4SaIRjMSQvZl8DuwxdGa4XDckTRJqkztYRKSAvd2MXNx/0VKIvnn4rWz91dJ+soJSpBy+DuBzcxYTh90VLsIN3/riTsk6883ZMnV80F03T4W4VlJbEEns/gX8Nh7YF2Hf8daIXp/DwTC6VlyrIDH/QLue572MfhD1OOCuw3gOaIO9+tQuQGBOB6LIZdrror1q5SBmI8RTOBxAS1FCxXjCmA8F4BdUCaw3FBt1HgnbwfGMPXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cyQtMYvtlSg1HhuPezkQ0FZAEptL3OCXF4jBn00U6vw=;
 b=DzQ4R3h0M8No7ZGqt+GXhcaQ642thyGFboZ7uhNP4oIx2C+15rHXfE0Gm17d5x1tPTv9t0dn0VOMvXwFBeFY/SC45u3Moz6w1OPZq7KLHbTAUevHkDRZpggNRP8oLJklKFysiOutXpuLOXHlAbD6SE7cHO8+DHeE30qHQYv9f+3tvBNEyhAiU+ASVD8QnEZbh3SZRYw0ScOQY+1e7q009z/cIINs7MN9JfThbjh+EXDWVVqnAZSqk+oya/gxHnoJeetl+GjKTWizCRNikxzhRm+p//hp5HJ7hwowVg/Rey1/aZOmit317b8sveDcoPWPtmJLE0P1v90L+/V6C+FeSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cyQtMYvtlSg1HhuPezkQ0FZAEptL3OCXF4jBn00U6vw=;
 b=Q/Y9hLaE+jaH8xyruIue3ICVKki1tvHigKHSiLAk8FbsEF+iBY7s/JbEH1r+LoGpS9SjESntrbuj3gydCXwwim4pENTPGTVs8hpylEi080OwIQ1RQTpMAhkK9cSHxMaSaUHzRSbMzlCzZN6kzP4uGBLeuzEsXXDefjqezjaknQxNytss3NatPdvTIAmCOP91xmTSaX4LJ4E5Fa2Dg2wYuL88T9NHNa25gb6Hii/l372zy/8JtPs7+11aCQx/d4FIEQViwWnXSflwiKO0CNuWiIhHlyiFXB2dZXQjBGaQpR/g/vnpQnRjSvaFi7VPKZqkP+VyagWZ3vN8MVRFb3ENwQ==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by DM4PR12MB7743.namprd12.prod.outlook.com (2603:10b6:8:101::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Wed, 25 Jun
 2025 04:38:09 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%3]) with mapi id 15.20.8857.026; Wed, 25 Jun 2025
 04:38:09 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph
 Hellwig <hch@lst.de>
CC: Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	"Michael S. Tsirkin" <mst@redhat.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Thomas Gleixner <tglx@linutronix.de>, Costa
 Shulyupin <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>,
	Ming Lei <ming.lei@redhat.com>, Frederic Weisbecker <frederic@kernel.org>,
	Hannes Reinecke <hare@suse.de>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "megaraidlinux.pdl@broadcom.com"
	<megaraidlinux.pdl@broadcom.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "storagedev@microchip.com"
	<storagedev@microchip.com>, "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>, "GR-QLogic-Storage-Upstream@marvell.com"
	<GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 5/5] virtio: blk/scsi: use block layer helpers to
 calculate num of queues
Thread-Topic: [PATCH 5/5] virtio: blk/scsi: use block layer helpers to
 calculate num of queues
Thread-Index: AQHb344TLGmcOvsZjEuM9jhwS0anHLQTVsqA
Date: Wed, 25 Jun 2025 04:38:09 +0000
Message-ID: <b8c7f531-484a-497b-b965-df3c27347349@nvidia.com>
References: <20250617-isolcpus-queue-counters-v1-0-13923686b54b@kernel.org>
 <20250617-isolcpus-queue-counters-v1-5-13923686b54b@kernel.org>
In-Reply-To: <20250617-isolcpus-queue-counters-v1-5-13923686b54b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|DM4PR12MB7743:EE_
x-ms-office365-filtering-correlation-id: 572c9707-a17e-4b98-4582-08ddb3a21646
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|10070799003|7416014|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?L0l5alNFQnY5cmZsNWZoVC91UzU2UmRlTTRGU1hYYTcyZGpwQTBzMmJiYlEv?=
 =?utf-8?B?dS9SNEhrQWdIOWI4TGxxUzYwdWlTNVZZRHZlc1FqOEs3U041TG4xUlQvZnZa?=
 =?utf-8?B?YWROYWc4MmJ6MElMNWVHdVduN25IcXpmR1dybTE4dzRLMXBMVkt1bHJaS0xr?=
 =?utf-8?B?ZkFCSm0zc2NKbmQ1UkExZEhmY21zU0k2L3NCY3FaRS9CMm1YbnhRNkd1SmR6?=
 =?utf-8?B?WEdBUUZpNTZxZlRkcTJRQnBMZzg2V0tnYjZOUndxUW9OZlRwSDI0SU9UVlZN?=
 =?utf-8?B?aHFWRzVXSjNjRG1OMytPUGN0RVJtdzRGNWQ0amcyMTEyV0ZRbk1GYmxIWm1F?=
 =?utf-8?B?c2FWUS9LV2hpWnhDNVQwY2Nkbmt2YVNUZVJoLzBKZStCYnpiZDJvSVNBZThi?=
 =?utf-8?B?ZUJXOUpGKzRHTTVyaEEwSnF6WUwvTUZwbWU4YTJrT2ZGdUJuczhsQlZTNFA5?=
 =?utf-8?B?U21HTExPQzBrOXJIbERZMXAySi9IZ0ZENS9ua3NaeVM0NkRwUk5DRm9RdWRZ?=
 =?utf-8?B?bm5QbWJrRDdxb2lYbWcyTjNrb1JXV2QrR3REZTRMeFBGOFYvV3c3czZjTHcv?=
 =?utf-8?B?TkUwM0pWR1BicEZOUTU1aG1INzhRbnR3VlJJVncrSXFzVy9NRFVMcEJPNzY1?=
 =?utf-8?B?R0dSZ29kM1NaRUFSdUNGanZDR1B5d3JjN2FSeVlRMTBLMURZRjdzc1p2dHNT?=
 =?utf-8?B?dEZXTzNyWmZrTCtBdUd1U2NzUDRiQStZS2Y2MG53b2g3dFFqTi9VekYzWjZm?=
 =?utf-8?B?UGRnOVdzbjV2QUhuR2g1MmJVcjZFNUJRaVlwMWFJbEF0M1FFeHBBU3VOTUp6?=
 =?utf-8?B?WXZhR2lDU1lORnRVMmdCNEIxZm5US2I5Nmd0bHZxTlphRFlETHZNbGVXdEU5?=
 =?utf-8?B?RDB2a1czTjNjYzN0SldYT1lWUE8rQ2w2dTEzYzNCZXBUOWNlVG56aE1JdDRq?=
 =?utf-8?B?TVVvaHltVkdTQ3czUDhoVEdXY1ZaSW10c1FOSHloUHYxMmNtVjc4R1B6WXRn?=
 =?utf-8?B?TTFCcGE2cXlOK1M3V3hIUE5EQlpURUtNTnhpcHZ6V0doMFRNMGdBRFlrLytw?=
 =?utf-8?B?K2FwVEdLVGdOMVhmVnFzVm90dmsxOHBNTHRMYWVlTGd0YXkrSEI2WUlRRzlY?=
 =?utf-8?B?ZWJld0h6TGg3Tm1ZdUVrTTFXVmprb1BOTXM2VjVIN2lQL3hsTGFpS3pmUG1t?=
 =?utf-8?B?U1dWbmd6ek54NVFVUWsrU0JvNUxtalptRlZjQW9yTG5tdWdFc2VnOVpiNEZ0?=
 =?utf-8?B?ZnJud3EvZmpQRFFKVWZiWjZQMFgyS0g5cnRPVkswUkFBSktKUXMvSlRScDJJ?=
 =?utf-8?B?Tnd6S29CeHlzY05MN1VRd09KSkxsWndVNy9KYVJPQmE4cDlCK05hUERxWTBp?=
 =?utf-8?B?RmFWaXk3UmJ6bU9WcXhlL2RCZm5jSFlxb3NSUWlnOThCTWRkM2pkSGFPUDVs?=
 =?utf-8?B?QTZ5OHJzR2M2R3ozRm9Ra1VEODlRMzdxWDFXK1IzbVNMSUtmR1pwM2hnVGRW?=
 =?utf-8?B?Q0tSbUlCdDFkb2RySzBaUnNZVmoydVNla1I4ZUVvQ2M3YkhjaytaU0RHNHp0?=
 =?utf-8?B?M1JXZldmbkMyUmI0anBCSVRZL0h6Y0pBYU11blBpYVFXd1Qyc2ZTNFJFWWNl?=
 =?utf-8?B?alVGV1orK05JclBIOXR6SUhsODF2LzdLWERvRjVsN1BXcWM0VytmMkxXWGZR?=
 =?utf-8?B?K1Q5UUdKNTExMFpEQmZNUExybjFmOVpZeDhrbUo5dEovV3hCUTYxeEwwSVRE?=
 =?utf-8?B?RWFNUE5HOEdmSmlIZ21CQlZWNWlLeDVyTFFWVjZlenlRL21yejVXcVBEd29y?=
 =?utf-8?B?NlpNazA5bWhDMGxzbXlrYzFXdTNyazhXb0xIS055WldjYmNDeTYzckZtTmZo?=
 =?utf-8?B?aUNQRTI0QnBXTFRyMCt5MkZmZzRSNkNGdXJoc1gxNWg2ZyttMmJXcGhEaEZK?=
 =?utf-8?B?dTR0RmxTMmpPSk02YTlJV2xQWndLdisxa2RyWUt3YXJIM295cTdNV3hUaXFl?=
 =?utf-8?B?UmgyWUt4MlFBPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZVphV3BiV2t0aDY4WHdyTE5OODhDTDdXbGQ0NHYrV3c0bE9LOEVpbTloK0xR?=
 =?utf-8?B?cGtpSjhmRmJ2Q0hEaGFWNmx0dHRmaERoQnZMeGwzVGZXcWZSelVpQ3lNK0N5?=
 =?utf-8?B?c3NJc0hWdUpNRkVCY3RQcm1WQjR0OVZSMCt4WlJDVU5kL0E3MWlWK2o3ZVlZ?=
 =?utf-8?B?N0tOcktoWnQ1bCtteE8vaUoyR3BvMUpzWGx6YW4vbVIxdEpHVFVoMzlCUjQ3?=
 =?utf-8?B?OUF5dVdLLzdKU3N5SmlMU1h3OE4wazMvS3liK2NZU1l3UE1Kek03dElkOTNR?=
 =?utf-8?B?cEFYTjNFaVM2VWlUMDZLZXNpUmNUY1RTOVR4ZmFYYTBJb0R6NlpQbjFXS2g3?=
 =?utf-8?B?ZjVTUUFTcGR3MWlubXN0U1NBQnhsRGY4NEFJT3FTV1FWMGEwUWNmTk1wYUdh?=
 =?utf-8?B?dWNCVDFPeWUvN2paRmY2dlM1WUVNWE02T0VucTcxSE9aR1I0WTh1aTRuNDVy?=
 =?utf-8?B?eVhLeWd5WFdIU2U4Mk9uTk1MQjdiTDA2c3VQRXZiRGhPcUMzVDVTRFJMZW56?=
 =?utf-8?B?bUdkRXV1bGhmZkhCU3pkR0VmWUxBWTIwdVNFU3V3WEVSRloxUHEwMW51TnU4?=
 =?utf-8?B?aUFSL2RuY2w3NHFZQjFlckgySExzN2ZlaXdQRlh2bGgrK3lYaUkyakpnNzAy?=
 =?utf-8?B?OTFMN1pBdXBZYzN3UWxhUkh6SUg0M0lQbm9mbHY0K3lkblpGSmtRQnh0L3Ba?=
 =?utf-8?B?VW9aYjcxN3Y2VWpsZ1NwbG45UlNFMkJ0S084Zm1ob3ZoYmVWVzgraTA5Q0J0?=
 =?utf-8?B?UldoVkJPbXExQlhwNzRuMG1jZmFxbU9HeFRFN3BpSVhPbXRxUkVjM2g5Vkhp?=
 =?utf-8?B?VDFqTDdIMS91Z2JGamRUeFdwQ1ZGbmVDdUxiZjBScnpES3AxaVYvUkVHdHNy?=
 =?utf-8?B?R0MwUWJoSENHb203UEFtYU1BQjRrN3VreWNVcW1SRGg5QUFnRHREbmZsM00x?=
 =?utf-8?B?QmUvK2ZMejRUQlg4Mk9uVzFFSm1yRU1adWhMYWhGOTdXcG9hL1dJZVZLNHE1?=
 =?utf-8?B?YktJWUxWQ0M0NCtteklWV0oyQ21uaVZKYmpndXFSYW8rdmRVUGJBckhOTENs?=
 =?utf-8?B?TDVmVy9OWTg2aWdKbDdYSEVMZWRmNEY5ZnlHaWxPMVdwKzJYZUpYWHdEUFhZ?=
 =?utf-8?B?ejFONWNnQk42OUU2STh6RWdrVStMcTg4ZjUwL0ljZFdBWm1iV3h3dmh1RDRv?=
 =?utf-8?B?V3kzUmNoTVUvMGdjU2h5d3pydS9pMUMwN2tEb0tSTGQ3T3BpK0ZVa044TjNi?=
 =?utf-8?B?SHZ3c0Rjb3hjTVNXZk9UWFliR3l2SUVIYW5ML04vWEhOR2RFdkUxajQ5MWdO?=
 =?utf-8?B?Lzh5Yy8vWUwvWFllUlYzSWM0S2lhajJ1OGMwVVVRM01YMDUwdWpzbTZJaUxj?=
 =?utf-8?B?L0xTV2xUeXdxVFRVS3FRYTQwVVVZNnNhclVzWVg2bUZCWmlvYXBkL1RQWnFJ?=
 =?utf-8?B?eDZTU3UvbUdrcFFGM3ZQbTB2RGZ0UUtlVWV0TkZNMzd4VjVmYlRWRTk0Uktx?=
 =?utf-8?B?QWd6K0ZWM2xMK2RPRWR3WkczUTBUVkwveU5qemR6UjR0Q1VRbmY1WnBTTUli?=
 =?utf-8?B?U2Z3S3pIeGpBWGF4dEI5NHdFTzA0YXdQRzRUUkowdjJLRmFiTGVlZ2lyUWJk?=
 =?utf-8?B?a1U2dlJLamNHWitkZWRHMkVJZWRHeHFNdnBSV2FTSk9NNkV0VlorTUppWHJT?=
 =?utf-8?B?Z2xQNVJVR3QxUVJZSVoxNUZwaTdDOWNQOXQzZzNjVld5MjJrTXRNKy92OWp5?=
 =?utf-8?B?N2RvU3l2WldZQUhDK0NPSm4yRW5QK3dCVytuZ3RYQVFLZVh6OU5HaklZbi9u?=
 =?utf-8?B?WUdGQW81YllqSThzK2dtZk9VYWIvT3dNaUgyWE1zQnBhSU12R1dTSVpxYjY5?=
 =?utf-8?B?R1NxOS8zblBLaHhNU3UvUDNnSHA0Uzh0RFJpTEwwa1M1eUZzTEdQSmxiZ0hh?=
 =?utf-8?B?Y25ucUVuQytlRUdUNWF5U2VjaFZRSlIxSWQzbVRiV1Z2d1lLZzY3b0tqaC9Q?=
 =?utf-8?B?ajJXMUplTlhWc1pGVXdhQmlTcnVTZXZ0ekFqb2R0VWpXSWxGZHJLYmxBUTBU?=
 =?utf-8?B?VFVYOFpQMnVmSTdGUlhHTGtDdkp6ZEQ2YnJzRWFkQ3V1NGtNb0puZkN6QytT?=
 =?utf-8?B?dG8rZklXVmNCZS8rUVhXSWpNRGx2VlltOVg4NXlRbmo4UkgzajZWSVd1QnpW?=
 =?utf-8?Q?6HOyWA6YHDAyqNAYIlEOA47ZiCJVMfHr98hQaKxxv2Cm?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <86CBE4059142244C91784879737EC1A4@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 572c9707-a17e-4b98-4582-08ddb3a21646
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 04:38:09.5926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z2W5tOwZKJPtEog2iUaKwbnNwAW8E91N6XWpVki/06bGZLb2EW2fAY8hE+OZdE25A5wbKHJ7ljZnlSLh022XCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7743

T24gNi8xNy8yNSAwNjo0MywgRGFuaWVsIFdhZ25lciB3cm90ZToNCj4gVGhlIGNhbGN1bGF0aW9u
IG9mIHRoZSB1cHBlciBsaW1pdCBmb3IgcXVldWVzIGRvZXMgbm90IGRlcGVuZCBzb2xlbHkgb24N
Cj4gdGhlIG51bWJlciBvZiBwb3NzaWJsZSBDUFVzOyBmb3IgZXhhbXBsZSwgdGhlIGlzb2xjcHVz
IGtlcm5lbA0KPiBjb21tYW5kLWxpbmUgb3B0aW9uIG11c3QgYWxzbyBiZSBjb25zaWRlcmVkLg0K
Pg0KPiBUbyBhY2NvdW50IGZvciB0aGlzLCB0aGUgYmxvY2sgbGF5ZXIgcHJvdmlkZXMgYSBoZWxw
ZXIgZnVuY3Rpb24gdG8NCj4gcmV0cmlldmUgdGhlIG1heGltdW0gbnVtYmVyIG9mIHF1ZXVlcy4g
VXNlIGl0IHRvIHNldCBhbiBhcHByb3ByaWF0ZQ0KPiB1cHBlciBxdWV1ZSBudW1iZXIgbGltaXQu
DQo+DQo+IFJldmlld2VkLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gQWNr
ZWQtYnk6IE1pY2hhZWwgUy4gVHNpcmtpbiA8bXN0QHJlZGhhdC5jb20+DQo+IFJldmlld2VkLWJ5
OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4NCj4gUmV2aWV3ZWQtYnk6IE1pbmcgTGVp
IDxtaW5nLmxlaUByZWRoYXQuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBEYW5pZWwgV2FnbmVyIDx3
YWdpQGtlcm5lbC5vcmc+DQo+IC0tLQ0KPiAgIA0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1i
eTogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KLWNrDQo=
