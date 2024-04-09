Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9194413C69E;
	Tue,  9 Apr 2024 15:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712675233; cv=fail; b=H7tzzS4vKKrEE/WK2yQp+TJaNCvbxy7xoR0DJj0bf310SEYcLy0PBP4bn4kzIOcZnf5bLo2LsZGbaPeiPwUTJDB2Y+SZwJRRAhns2jepqFQ33+N5lFin/PxGMCy/HsRomtFCeY7bVZPIxoEO/Jb9C5y66nkCbSnBkGzmBnEQxA0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712675233; c=relaxed/simple;
	bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=t7qpD8JA+5z7Y/qCe6Q1mZ3UGAYZDFdV9iwcBe4xUzUy1gjkbTXW/bw4qXZOUdiXkmJUh/gsrEU8XfiJ7OiQ7L1+tLKdS4cIpg8udPqvgD7tI/M7A5cngFrbv2Mw1cbcv6v8eEt7v4m4jLvrQMli/yIO8joWrl3g39Fhr4YAsBo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=BSPFo1nr; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=tOfz7ynw; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BSPFo1nr";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="tOfz7ynw"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712675232; x=1744211232;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
  b=BSPFo1nrzRb1QA2LzXO2MUpMXnKGAgGBrXR5kZWu0PBq2kZbBUyMdSah
   cG1v9NkcJ4cWFZlveZQVcyYz2JNkAsRc4+6xBkxHQweQUmGb7A+jhNTHS
   PG/5MpCNfKMpodf6gLRD9kxjDRJ0HlUAYcfHwBmy8uo7BSZTKm6uppby+
   0CKq88S2PABYEIyc0rE7WxxtfErJIyCkrqPHMd8/goa9NydZAidzFqbA/
   7hpJRx3fVX1DffuMjNG2kpZNB5QGBI7vOXfSVYUUq85f4AMkLu+BQICFV
   GGyk7/oVwoKyn6n+gwCAgAfQp1osE52ZzPCcAfDbJbPfVOpA2HqLgrB+O
   w==;
X-CSE-ConnectionGUID: JSgZ2AsTSn6w9fcFTrC6Hg==
X-CSE-MsgGUID: wJbStteSQtys6FRHNkk2tw==
X-IronPort-AV: E=Sophos;i="6.07,189,1708358400"; 
   d="scan'208";a="13424485"
Received: from mail-dm6nam10lp2100.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.100])
  by ob1.hgst.iphmx.com with ESMTP; 09 Apr 2024 23:06:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D21r3By1EU0zQomaZ/DWWL/EytNQN6aWZzQYV59GdFjQ089uQzSqGhSr/ZBqvMtnrPTdOyTMjpMUA9hdW7P/Aa4R/g1D9RcyYJLB0n/QEdXkMiYZgC4QvG4UkLF/Ru+Es4hP2RfGtbmT/PQLxMf0gGPoEr+NObf1NLIdhzM0nHM/wXGT4H19Xb8dUuPGiEhvxpAEKz2+ESe0TFlrNrnyF6oZLpXrORhTtt3r7+UUYS4QgslnhRzBsmF82vWZ4mX59LZfxuGHHmMGoS6W8i6qAASt/GmKNEXoeVOpO+O8Q/HW2czmwH0Fp/lAsNTKQej3bFxrwK3JhYGzl2ek35F+1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=aKDHqNIFFCDV5aA38ZLEFUlNvVEkVgH0i30aa8fIRPxfHCffSE5iOSKJVCjPU6916l7jY0a+cWB1TlZQxEnKue+gcutppc0IBxjE11BCNdpsEIhj/i/2W0ll2kokndmoyvCzRpvdFfF7NjXF9vGJAUdtWOA57gSeSUN41AwNxde45gqvB193eNg03+5cLYul4XtjFCO6kfgf7JMdUGvw4Pn8HgrF2MVzSgmfx0LHbBMpDvPVlXd/tcVwt1FKVbD0Hngg7s4jHIBtCaRQcK9vqYgxnGruR/cOW04paI8UU3YOpY33bSTzUmiIZKM6NOSqkiyPN3SQkCmaomhZZ2K5AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=tOfz7ynwygQW7wsNlUeuJ2DNUaK1qOsJ9gUNM46jTEGga/NpRxxO2hzuSJUxym6aXNLkrUv16PjLJGhJDBGdAmV5P6Zk5+SnopAu4HRXABoXBb7PFtseQJckIvJJWH59tFmy6b+sQFwE4NJ/Yr5rrLDRmwOcRXEKSOSK8EudxUQ=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CO6PR04MB7715.namprd04.prod.outlook.com (2603:10b6:303:af::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.55; Tue, 9 Apr
 2024 15:06:54 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907%4]) with mapi id 15.20.7409.042; Tue, 9 Apr 2024
 15:06:54 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "Martin K.
 Petersen" <martin.petersen@oracle.com>
CC: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>, Sathya Prakash
	<sathya.prakash@broadcom.com>, Sreekanth Reddy
	<sreekanth.reddy@broadcom.com>, Suganath Prabu Subramani
	<suganath-prabu.subramani@broadcom.com>, "Juergen E. Fischer"
	<fischer@norbit.de>, Xiang Chen <chenxiang66@hisilicon.com>, HighPoint Linux
 Team <linux@highpoint-tech.com>, Tyrel Datwyler <tyreld@linux.ibm.com>, Brian
 King <brking@us.ibm.com>, Lee Duncan <lduncan@suse.com>, Chris Leech
	<cleech@redhat.com>, Mike Christie <michael.christie@oracle.com>, John Garry
	<john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>, Kashyap Desai
	<kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, Chandrakanth patil
	<chandrakanth.patil@broadcom.com>, Jack Wang <jinpu.wang@cloud.ionos.com>,
	Nilesh Javali <njavali@marvell.com>, "GR-QLogic-Storage-Upstream@marvell.com"
	<GR-QLogic-Storage-Upstream@marvell.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Alim Akhtar <alim.akhtar@samsung.com>, Avri
 Altman <Avri.Altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Krzysztof
 Kozlowski <krzysztof.kozlowski@linaro.org>, Alan Stern
	<stern@rowland.harvard.edu>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-ide@vger.kernel.org"
	<linux-ide@vger.kernel.org>, "linux1394-devel@lists.sourceforge.net"
	<linux1394-devel@lists.sourceforge.net>, "MPT-FusionLinux.pdl@broadcom.com"
	<MPT-FusionLinux.pdl@broadcom.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "megaraidlinux.pdl@broadcom.com"
	<megaraidlinux.pdl@broadcom.com>, "mpi3mr-linuxdrv.pdl@broadcom.com"
	<mpi3mr-linuxdrv.pdl@broadcom.com>, "linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>, "linux-usb@vger.kernel.org"
	<linux-usb@vger.kernel.org>, "usb-storage@lists.one-eyed-alien.net"
	<usb-storage@lists.one-eyed-alien.net>, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/23] mpi3mr: pass queue_limits to bsg_setup_queue
Thread-Topic: [PATCH 03/23] mpi3mr: pass queue_limits to bsg_setup_queue
Thread-Index: AQHaioub9+2YrgllmkCiyzR4qkk0obFgCgYA
Date: Tue, 9 Apr 2024 15:06:54 +0000
Message-ID: <c612d599-d431-4cce-925c-de81072db8f1@wdc.com>
References: <20240409143748.980206-1-hch@lst.de>
 <20240409143748.980206-4-hch@lst.de>
In-Reply-To: <20240409143748.980206-4-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|CO6PR04MB7715:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 PYk4+Wz6DON27UERXufcdB+IxrUnQmdqdPM9n2yWCCca2e7k7KzoOGrI5N5qw/u/D/el0Fx0G4QGDPe5MtjIDeDMuZVaybtaZvf9ulBenm9hXW/cPB9w+lfY6avK4UDJLnTjZ9etivE/B26gdmMSu4V2mTX/N/WlqD1DfjY98iugJr/wlh7IJCRFjQGQNjmtF9u2DtJwTKTrQgDwla0HTrN/GZG1civP3gA3jqZv71rY4oQMH/NVF6q6dSGwCc1xRz8VN5S4TGJqqSIjvc9rgraXiKzD4RtzJQR6bhE010J7mxVy8X1yEeSHy51oR76eJpKQdGNrGtPY8s7RgxsEQIGIBRYjHmDB2rxD+Xw1My/zKZ6DN3qs+3NWFmdhEyTnQi0E/JIjekgYS9rECOKXXvUhtDKeBGHxU1+DipJDeyby1rlrEQC/xpJoVRn5GPwsC0f5sKxlNu5gh/FjohJOeWGgxyh6MEVQz7uvzZ7Q6ZxrRKabl4tXiEXPCFLnUnprzKiNjup7muxbYYs0U0zJ06oVu+JRKq34JWHnq0/M3Qu2Zi/26DkXSra0/bjWHOZ/WHZPVxiGrtGkS76q2t+wRZlAV0T9Eqkz+iJ7eCszT+jOr4Za3wcvprsd+x76VyRifcRNZmHEcpurpqrNvbHAUBHGocrGrGcBymdlwef2+Yc=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(7416005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bWM3eXdZbDZhMnhvWlBWaE1QeE4xSUlxeWRzajZyRFVTUGErUUcwUy84enZl?=
 =?utf-8?B?clNibWNlcktFMjZjTU4zaytOZWJKSlJqWGM3RksvdTgyZGk4RnFvUlhlZlNO?=
 =?utf-8?B?Nml4eGRjR2Q3MUpiYWJFUVZHWTg1NmVxRUJTcE9WNTFockhMY3VHa3lmVzZv?=
 =?utf-8?B?Mjg5L2NnUHAzWXFYNFZLUHM3Q0VTNCtBcFNkZTNHMzhZcEhCSytQWGJ3Zncw?=
 =?utf-8?B?Rms2UmZLOEpJVGsva0RKQlcxTUNzMkFJdFRTWTEwVmdjTTltcUZ0S2twaEdj?=
 =?utf-8?B?ODN1WDZ1MHh1eEdmdFAxMThJSnJDWDl6aVdjU3E4OHF2YU9OZ212UXVJbGIw?=
 =?utf-8?B?UlFjWXlPY1NRMjR0aGVLdWVMU2xpaHFpM1djSUVROU1HaXFmaEtlUVdrams3?=
 =?utf-8?B?ODBMVEJSNWVQeWtOaU1VNlhZRjdoYzZjR3NNM2loTlBaUk1OME9BOUJmYU1w?=
 =?utf-8?B?dTBrS29DYUY5eVc4bm4xR3hLY3YwemEyOHdHZWQ1N2FMZ0w5TFlpOGxzQUtk?=
 =?utf-8?B?dE5HNElWTmFBQWI0dTRxWEFBRmE2OEYvcmlhbFhLdHpvajMwclFNemdrWlNY?=
 =?utf-8?B?bHVZTlpFL0lPdmVEZUYrUWZrdmNLWm5NcWJGYVBiTzI4ekJtVjNPQ0xUZElX?=
 =?utf-8?B?M3d1ZU1xdnYxbDcrQWZMRUdWUDJnZmNibmNtTzc3M2RsOEk4NVhONGdBWmRt?=
 =?utf-8?B?UVBxakFUcSs3TUtaWDcvbWpDQWJZS1htRmRRcDdueWFIY25rbmVOTko3b2Fk?=
 =?utf-8?B?VWdiZE1aSUpoUUhlRVkzY0k1K21Xek5WdjRzUjFnNXpPVXdQRGcwdldtSEZh?=
 =?utf-8?B?WmEwL0ZHK0I5bVhOTTV6d244RkZEeUtmMUZPVnVzcnZoNnREdkorSVZPUDVi?=
 =?utf-8?B?MUVlK29ORUtSWEZjV1cyQUU3KzNZVFI4SE1ScDIrazdHUmpGUDJkSjZScDhD?=
 =?utf-8?B?NVVUZ1pMME11N2xtT1RaQVVMbzllNUkyUjVxWVpYRG5qL3dQRVVpYnp6ckIv?=
 =?utf-8?B?SzRhckVtc0RvQXpuc0pCWTlSSW9KbG8wa2EyMlBqYUlYWUpXQTBHSDR0UjdD?=
 =?utf-8?B?NTFrejQ0SW5OdGl0Um1mUEQ2NFhGNVdWNXNMSHJpL2g3YmhTNEZ0RE0rNTJV?=
 =?utf-8?B?c0Z0ZE5GTmpaSkJvR2cwTFhkZk16RTBqY08zTy93VFdXOG9vL2RQTUMvQmxD?=
 =?utf-8?B?M1B5QW8yRnR3UnJUdnU3MDJtSnZwb3hNNmlVSDljUUZxOEZXS0FrSEN5VndC?=
 =?utf-8?B?cEVWSU9XNHFBL3BoNkM5ZE94UEJoUmhETTlabU4xK2tpRmQ5TktzV3dFRTBF?=
 =?utf-8?B?MlhaSWFlRUpjUmJPRTRwN005WkZyTm5Cd2hjYUdIVTRzT1MvUVJwOHlYNUl6?=
 =?utf-8?B?YkppRVVlblk2WVZxU0d4WUliSkt4V1drQk4xaG5pVlQrMFRpSyt0a2RFWVJY?=
 =?utf-8?B?S3ZlUDlEU0dyb2FDSkdrdlo1ZmxRUHhCS0lwOWg4a3JuV0MxNndCUmxrQWJJ?=
 =?utf-8?B?Q05qMnd0NmRZQlNIcU10K2ZkRG9QWE5pZVlTbzlGemlDS21HMDQ5MnhjVnNF?=
 =?utf-8?B?VWVPOXdiSHpsUUJxQ1dMSUcwMHJrbVNOS011UlV2V2wxaHVDZ3lKVjB0ZEE0?=
 =?utf-8?B?K3BOZkxkQytqeitkcEZJZkhHRmNzN2RHN3p0UFYraFJNQVcrTjhXQ01vb2li?=
 =?utf-8?B?R2lQeHhmVnRXMk8wNU9vQk5CV1Q0dkYzVjhZd0VmWnRPTE84NVVCSG1QdENu?=
 =?utf-8?B?cTFuUUgrRnlMYTFBRllQOGk4RVNoVTFPR3hSYU9DUi9QaXdVVk8zNndYK0Y1?=
 =?utf-8?B?OHNFeVZTY2JyRG0wdWRDbmF2NTVQMm9tbklUVXRwWHVsd2tUem1iTG0xa1Zt?=
 =?utf-8?B?NWJ0ZzUvN21jVDVCQ3FWL01aclJUc2h2ajh6Z2lmUnl6eDU4RUk2MFZURXFn?=
 =?utf-8?B?ekJFT2xITUhDRTQ0TGIzVGJRQk1ZbkZheTdTNHdwYXFiSDFLTHg1ZUJQNnRQ?=
 =?utf-8?B?bE1xak5HamZnY1liSjZWVWJJNVMwWVNhN1I4M00rM0FCM2NUNHk5dDZkSHg3?=
 =?utf-8?B?amUrOGg0ZVRxa2w3ZlBNK04xcDVXWlViTFBjeHB6REszbUc0R1Mwc3MyZDQ0?=
 =?utf-8?B?Tjc1cmFhdTlIcFBqM3BZUVdCTEpLU3RKd2V0NEVWQkx3RE5vcjBNdlJlVnpF?=
 =?utf-8?B?OXNqbVJzdHloK0RONUMva3B1S2ZOTDlJUCt5SDUrV0hkVG9YdXRuTzdvY2F6?=
 =?utf-8?B?UHVIbGRXN0dSNFRydVBFWmV1MThnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BEF42466D1E315439B35F2972DD23CEE@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lEQxZhhN0RoMR+WZOoMAQEb8HfZ0GjocVOdGTsLwdDc3sGNIF8MQOSjQvgq1yqVdPqXtppBMFzqoNZp5Ejrq2Dh/LoFZgvS+8mBeAIRiDBwsMOO0nxEigTc8DmG6iYPUBDLNUNCDys8SWrGiZqQSPicBDmLnH/iN7MnbcCPoXFXJ/wfxqRolekkiPqTdQlQAhKXgkR1bO/1DQt4ztwMVgDqABbMZebXAToPSQFQDBayH7qj/tbkFTSBpAuY+Tjj1oAM89JVKgXGkfUc4CZ3P1p6JFDVwplB11Ol9Z3KRqwNQ0w1S3TnHxTNho4mo1GFWgOcfbqRSKMDsEKXcnC0vE12aRvgV03wY+90aIIbeexJv9qwyZV8y/lMM5lfe4To8oN7uB08ElXQkuFmBEPav3lSbISKNY+3FbQSAz9vBuFeBaOfeYzwxWebexcWqw+k0LOIl35hHct1KjVTXMuo/1z6gGBoVnIebHr+umBU9+HqsXErZiNYGTKQPDrgZhKniCOjq62thuMsW3ZPsmnYW/rkmIpxBNEP20mR3XfHU1a9FkqPICSz+TgUmQb+CecqrFDS1oW52YD4/4IjsKBN3h3356rLdnAMga0beskMAwakkJLZFoo7+IVoSqtsEB2js
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b8feded-7b75-4577-9566-08dc58a6b18b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2024 15:06:54.6251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CEm2XUIkgO8L2QhJwGrZxXsHDmCtnRAmaXHaTXFmtrVifYlsY/8WVDg2az5yPplpSaChVFrTkrBM2ETwJqMsS3QAqCPIPsjM5dKJN2x/sTM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7715

UmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5j
b20+DQo=
