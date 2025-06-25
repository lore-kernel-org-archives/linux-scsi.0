Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A881946DF;
	Wed, 25 Jun 2025 04:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750826256; cv=fail; b=mjyJvCUchElDq8WhqHYqBgdKo8N53+sh3y/3b25Ju3QXVT/vwuq2r8/LZIrcjpkvnvfCggjk8WdzXPbpDKYRnPmShAYoopKLhBk/n45oGAOuz5AP1txXQcEo7Yr6B/uPzsxx++cD/ci014alncUkVMJhTLUGmtJ5KnF0jtKs5xk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750826256; c=relaxed/simple;
	bh=aEkqF2MMDMiEdFCVZvv9cNsFTUl6tSlOAJcepmaGo4M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hUmuC18aXvf6q4UcWIJpKRXRHW0Xi9+PEfEy4d+3LvupSoGn0jjrGKsseVRlSc/bGLjNJsRkI1Nxt5L0rHPSNQhIOlLZJBsq6jaeB9MDgiweOx8F0NRSJd/AuYH6XKWMbGZFd1IDBa39zn3PHwBszlDv4xoDVajh7aHykrbbJKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uB0mSmje; arc=fail smtp.client-ip=40.107.94.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uB0mSmje"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sJeJlJxrTN/Wq07T4tjMFQXMlMe37fvVZ4bz5ewKYr4UZF62zCeBilCakAiUKF4PifC8a4YkyiBqvdx2kLRtdSYELSVx3p9erOftu70MXgbFW+1Z3Spc7mDDQlAUEUkEkcOywLuU4EBaPPAU2a0WpTH3+ELMzVvEnP5YRONf47GGoAdf5+HMpy8S55PPslfmI86phNZgIppKtto6XaunadvZoRIGtB9lAjpEkwM9GUgjr0y5eSyqTVkPPDk9mE1UsiDEYqPvjLvkq+BNfDKfJjcw1fTv6DOWb2xC7PAxWebLW1xaApBxWbZKVYVRBPqWTPbXiDcrOPQTv8qig28Exg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aEkqF2MMDMiEdFCVZvv9cNsFTUl6tSlOAJcepmaGo4M=;
 b=EwALTN1dRBNjDP9aNaytj8dkbJTSs6S68eb+Uj76m4mNoG3f9J/HyUpZeoOTzvmby7Sg+L9hl122iyud3C4bwVbqK134m+lK4bv2eQ0a2nv+kiDJTGdBwkpkP4NvEet8+2LF2JbzcfHZOl4Duw3uCLTNudy3qgC9aBVcentvhRrDqP4j6sAMKao57wzbvBAwo5Qc44vPDO9JwV4N3hg2wEDwHnDRZWVoRfZwetBKJs/m1jbR8u0/EcUxlDAcFmDjJZ26YvlE5qp/QL6LyGQPdKBPDHQXd5HO/iTYXv8iI5uVKRlqNBtQvzpnhvXgrUQirjU9BK5B+9tEsq77sQ3JBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aEkqF2MMDMiEdFCVZvv9cNsFTUl6tSlOAJcepmaGo4M=;
 b=uB0mSmjeioHkAnneDnBjXfAdVxU+/9LHWJpqFFzszjbRu2Ty1TFU1UWbuLUYAeXfHndQVKoBBNSelxU34WdLCpKlW6CvhZ9ighUjs4n4wmw8UYVbDETa9sJluEpEKDLFyHtDTaZIWij4tHoJhc7AZEJWc+NiE5l89XNS54jxRd8v1NMnCkkc4VX5Hsu/1R+Jbeb140K5fld2h2eMNim+X/0N4LIAbXtzU6H4yJOulHjEalr5SPnMV8DO8JHfqYLDSuZ5YKCa1f+gLt8CoYz986yEwv7qFIivuNHc0CDe/APePUMod0xDgi6GRYaWCvOHlikCnsZ019xkY7ODU9erAw==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by DM4PR12MB7743.namprd12.prod.outlook.com (2603:10b6:8:101::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Wed, 25 Jun
 2025 04:37:33 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%3]) with mapi id 15.20.8857.026; Wed, 25 Jun 2025
 04:37:33 +0000
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
Subject: Re: [PATCH 3/5] nvme-pci: use block layer helpers to calculate num of
 queues
Thread-Topic: [PATCH 3/5] nvme-pci: use block layer helpers to calculate num
 of queues
Thread-Index: AQHb3430P+CX9DOYZUaCqKA3FejphLQTVp4A
Date: Wed, 25 Jun 2025 04:37:33 +0000
Message-ID: <ceb8e40d-04a3-42ae-bdc1-1033cf239073@nvidia.com>
References: <20250617-isolcpus-queue-counters-v1-0-13923686b54b@kernel.org>
 <20250617-isolcpus-queue-counters-v1-3-13923686b54b@kernel.org>
In-Reply-To: <20250617-isolcpus-queue-counters-v1-3-13923686b54b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|DM4PR12MB7743:EE_
x-ms-office365-filtering-correlation-id: 72001f18-c06e-48d1-a461-08ddb3a2008b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|10070799003|7416014|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?b3VnYjc0enZ0dTU5OTBlQTNLamcrSTJlZk4yd1lCT2ZsWnFPaUV4UHRjenZm?=
 =?utf-8?B?SlFpU3ZwUXdLQkJlOGpDNFEySEFsZGpSWFhKTURGWnRLd09NL0ZLb0lMSFZI?=
 =?utf-8?B?LzBpMEZmWkJpQUFPTlZpV1p5aTV1TTZmWnA3enZzL0Q0VVNOMkhCTGdlN1dM?=
 =?utf-8?B?OUJVSlRaQlh5c29kd014eUdBMkZKYUlBQTFJaUdzcStDcjVOS0g5V2FXS295?=
 =?utf-8?B?ZEZreE5zWjNQNUxsdllzNTRyL3I3cnVQc2RaOTd1R3ViT2U4dWRURW51enpu?=
 =?utf-8?B?VEdNTFVzYm5KdGZSbnBERUZzU20yaUlYcVhQOUlEellPQmpOQVlrQzNyM2tG?=
 =?utf-8?B?Q1pUVjV2WXFpV1J1UFNlQlRZY1lpZ0F3VCtqa0hieUpaRzIxWmw5RlNVdFFS?=
 =?utf-8?B?S2VESWlTTnA2OXVGNzNTa3M0RGNXSkkzL3RBcDlEcGNUMFZteUx1NmVhZlpK?=
 =?utf-8?B?TitQRkNxbGRXVjJtRHlmZkZLNWY2KzM4aHVyT1JtMXJXK0hXV092Y0J4cytD?=
 =?utf-8?B?L0FNOUhJQW5mZ3g0bHRWeHpwdWc1eXNMNE5BLy81WWxhcTV6NzJnU2ZRV0Jx?=
 =?utf-8?B?cGFmY255MEkzbHl2RWN0ckxTaDVxSWVsMkNEMmM3S3VjL0VuL0ZaMEduRklp?=
 =?utf-8?B?bjNaOFV4YjlQekFxc2NHbmEya1c1aVFFRW5iTkNkUWdtTWZQUkZkd1d5cmtO?=
 =?utf-8?B?ZlRHdnhBTUt1MGtVKzduTGYrVEQ5ZEIrcExsYUlESHdoRlo4MXFiYjVEbnpy?=
 =?utf-8?B?TlZCSFI0ajlCQnZyaVBjYlJTUjRjTHp4ZzVESnA3bjFPa1lHTXJwM2swN28y?=
 =?utf-8?B?eTF3SjVPQ002K2hZdE1xQmNwaTk1VUhxUWJycEVCVGc1TVRoMTVCRloxcHNL?=
 =?utf-8?B?WEZ0OFdOeC9FRkpXZERrd0UrbXJhU1lmeXlYZEFzWmZITk9QbzRzRC9qWk93?=
 =?utf-8?B?UmdUeEpQelhkVDhBbHFoWEc3cEg0WFJIR0pMYXc2aWx1VkpubUhLTFBUSG5I?=
 =?utf-8?B?ZUg4cjlkbDl4UkVJb29wMHQ5TVZieUpTV2FXRjhRcHBKOXQ0K2pMNHR2NVpL?=
 =?utf-8?B?RFpjNElRT1JuREVJd2wyYmdydjA0N0kvVGhseWFRQ1lIQmdPV0t0OVROaFNm?=
 =?utf-8?B?NEd3b2RZS0VCdVdNU1dDZkxhWlN3bk8rdVJocUZJbUd1aGkxWFovdk9MdTNp?=
 =?utf-8?B?Z1BrLzVCMy9HTysrSUxoaDcxMldtMVdlSWZWOE9PSFdkMzRIQmR2RVlyZXhR?=
 =?utf-8?B?Q0dhOTNmTUpHb1EwR1g3MFpkaUlqREVCc1ZYeWZZbW9BL1BVWjhudkpCTjZR?=
 =?utf-8?B?bU5yVjFwT3kveWVkYWhsMzlxd0dvQk9KQTMzaFE2Z1JwcitFZDhiemtmNTlS?=
 =?utf-8?B?YUxQWG1NWHBZZnNldGFaeStMYVM2T1BiSzI1RkN1cWpuMm4rQlZYWkZUNy9S?=
 =?utf-8?B?NmVRVGJ2RzYzSElzQ0lqenRacWlJdnByS1pDdzAreGpMK09TTWh3dDFiNzV4?=
 =?utf-8?B?QUJKK1Y1RkNUYWRRTEc1bE9XNUFuTFoyVXN1UkN0SWF1NUU3djBzSDQySnBT?=
 =?utf-8?B?UXFvdDkwaWdUQkRRTHR2NkdHcHNFcVpQbTFWVVFYL3g4ZnpXNnpnK1Nxc2Jq?=
 =?utf-8?B?bkIxSW5TYzdtS2FjZFlhM3RvenZhdjhLODh0TjI4eVhiNDRWWUFNYmZackVZ?=
 =?utf-8?B?ZUJmTm5PYVVaR25NdEtHd2J5OGZ5a1ViMlVma0k5b0kzaDBLZ1RjdUN3cVdz?=
 =?utf-8?B?S1FtMWFUOCtNMzVLWXdaejhScUoyVWZ0aDQyT2txTnN3OWF4bVQ4RTJtdFd0?=
 =?utf-8?B?WHg0dnQzNjBWV1lNNUVIcUpyekFWSDBuWmM3aXh0RS9WTzFYYUpyTTJ6VzRW?=
 =?utf-8?B?WlZhaDArODFTQ3hjU3N4bWJyK3lXMFlOWm40TDQxRnBKS3hENzZtdGdCZndL?=
 =?utf-8?B?Smg5NmZIelVrR0ZXY052UFdGYTMza2hUR3A2SmR6V2orbStkOHMzVmJPVW1r?=
 =?utf-8?B?OGFWcFp4SjBnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?T293WnJRZFhLcC82YS9GMXAwQkFzbWtMY0t6TVAyT3FtWU5ZNjVXU0J1dmQ2?=
 =?utf-8?B?RVVwMXN5QWRDUldGZzgwbkpib0k2UERlOUkrSWtTckJTVFZtb1hoMm9HaEpK?=
 =?utf-8?B?em1mRVVObHh1V3BBOG50VEY2ME0yMjE0YnlldE04cXlVZFI3TG00aW5mUkV1?=
 =?utf-8?B?bWRkSHAxK05MbzZIbDh3MTlyRUp2ZzZoUit3cXdrc3lVRHNiK3V5eC9EblQ3?=
 =?utf-8?B?ZEVCZDk1dDB3TERKRGVtTStUZ2lZMjBuaDRJVHQ2QzYrQmxEUEJRdUIzUlZF?=
 =?utf-8?B?NDhvZVFjQlY3NWFqNUU1cVE1QmRLWnh2UWtoTVRteUx1Qy90STE1aTJ1Wm9x?=
 =?utf-8?B?ZGJ6bDh4WHN0U0pscitwSUV3VFptVnFQbGp0aG9TWVFiTzVXRnZDZWlFTzRE?=
 =?utf-8?B?ZWxaVkZsZHZ2M3o5K2sxUlJibndGRXR1OGhVcDlIOWh6TXR0K1FKaVdadkov?=
 =?utf-8?B?djlWSFgzT0Y4bFgzMFdkQTljK0QxMW1jeGtBNTJncEpUeTIxTHFIOUNwY3JT?=
 =?utf-8?B?OWxEYVp5bnlDL1k4dGVlOVRtU0VYdUNEQjlEYlBEazlTZnRueVdlK01DMjAw?=
 =?utf-8?B?TnRLS3F5L2VtWHAzOW1sNWF1cTFzbWxnWkhGSytlTnRJdFV3Zzl0SE9MWm5q?=
 =?utf-8?B?czhzK0c3bzAxTkFYZWwvQjlvODdtODVxcnRYQTNlRGdMZHc0dDd2Mi9nQzFq?=
 =?utf-8?B?bHczeHlTcGdLdkk5bGpqb25LMzFGWjIwelI0RWFxSC81Wk0zckVCMkdWWXg5?=
 =?utf-8?B?TEl0QnF2ZWNRZU1XVUJFdHRvUkxZRitzaUUrOUZreWJPcHhtalZhd2JZWlBG?=
 =?utf-8?B?VEdnS0pQMDlaT1VsRSttOEFHSThlRWdUOVRRQ29XdEhDS3hSZkVUckN2eWV6?=
 =?utf-8?B?ZGJwVXV3YUV3ZHBieEh2S3ZQRFFYclJTcnduYzdlaVg3WXNTbUoxeXZZWTQw?=
 =?utf-8?B?VHgwTGo0Y0hyYUY5am45TUpyMElneWdBTFJmODZXbHN4Zk4xZkJYWnJ2djJJ?=
 =?utf-8?B?byt2VFJaNGtkWjZjdmdWSVAvcnpvaW9TSXV6NjdQRm1aKzVsRUQwM1padk5v?=
 =?utf-8?B?NUl6NFcvUHVGaG1aWFQ5Rm5xdlJCeTV4UTB4ZjRSVzdKMGw1UWM5Mlo3c2cz?=
 =?utf-8?B?R2VORVo1RG5UQkpRd1lXYmFDSnNnclM4cEgrQXhSeDZIVGVGNEI3QzVaYi9I?=
 =?utf-8?B?Y2xhSkRVSHNpcmZCYWQ0elJWNEFuT0lPRWpzSjVFTFY4UUFSU3JFMTU2Tm8x?=
 =?utf-8?B?ajc3SUlzQklPc0hldTNVeGd6MU5RSnRXNGNiYmF4YTd6UVZnL25Mb2FTdXBK?=
 =?utf-8?B?Mml1NmNqSFp5YllqdnRUc1NGNWVyT28rbnZaQ0dXZGU2Zy9LOE9JOWc2R0Jy?=
 =?utf-8?B?QkVGODM5eXBxMlBFbU0wSXQ1N1l4eiszQTR3MWU3aFgvZ29ZcGRBZkNRTnpZ?=
 =?utf-8?B?cUhoMlh5Q1lKRlFjWEZFTlRqUTdFWGpnQSszenhBT3VKMDhCMFIySUsybU11?=
 =?utf-8?B?cDNSaXJwOEJZUjVlWU5QY3F4RkNobnpOM3JqcjRIOU9NcUNqL0k5QjRxcm1B?=
 =?utf-8?B?NGdTazJzRVozdVFJNVU3MjFwamJESTA1a2FzUHdaSTFacFVIbGhhZTdOTG1K?=
 =?utf-8?B?V0VmQ0hvWk9zTmtBMkN4U2ExOHJFOXNXS3JzV0hNT1kzTi92S1dFS2x2V1ll?=
 =?utf-8?B?cVJUU1JsQ0Q5aUMyU3hOb3JBalpydTVTd1RIYUNZcDR1RGRtVVY4aVdIOEkx?=
 =?utf-8?B?dnF1djhjNXlaZjhqRUVEaXZVL3N4VlIrMVpJNGFzdElrdG5KWW81eGZkNUdI?=
 =?utf-8?B?OXRaRFo4NldEWDdNQXpGRTFtUWZ5ZlN6TXBDWDllWFpFTlBiZitEZVJucGF3?=
 =?utf-8?B?Sit4Q2xMRWcvblRZL2xjSVZUdGpWa2FwTHVtU01BWm9Fa2ZoK2VaOFZjNFBt?=
 =?utf-8?B?OXlva3p2ZG5wam5WVDcyOSthSVdZcFM5ZldlY0s0OExnckdrV3Q4UkVsSUtG?=
 =?utf-8?B?L0VaWWVLaHcwYnkyN3ZsNVBnOGdNUXN0TEdiMWk0Rzl2V0FjZW41SDFiVzcx?=
 =?utf-8?B?RHNtblNJZWNlV3lSa2o5dW1kZStYZmNKTkJKMXQ0NmkrZWhiOG5QanZqMXdN?=
 =?utf-8?B?Z3I0RWtaTWR6c3J3TEhmMlhKekZMUFlSMXFKL1d5emFvVFNyNjhNVWdqNG94?=
 =?utf-8?Q?qDT3oXwjIDjYUej5++JY0upO4NOCyolCht+IOEWoTeDL?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C227EA10EAA173419D61D66485C988C6@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 72001f18-c06e-48d1-a461-08ddb3a2008b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 04:37:33.1225
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JQobUOHOOa0TWWZw0AdDgUGusrsAYaM4djIKiOlYSiL/ksTiL+wy2Q7nHToaYRTt9ygLdGOWYAQU89WdMDwcPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7743

T24gNi8xNy8yNSAwNjo0MywgRGFuaWVsIFdhZ25lciB3cm90ZToNCj4gVGhlIGNhbGN1bGF0aW9u
IG9mIHRoZSB1cHBlciBsaW1pdCBmb3IgcXVldWVzIGRvZXMgbm90IGRlcGVuZCBzb2xlbHkgb24N
Cj4gdGhlIG51bWJlciBvZiBwb3NzaWJsZSBDUFVzOyBmb3IgZXhhbXBsZSwgdGhlIGlzb2xjcHVz
IGtlcm5lbA0KPiBjb21tYW5kLWxpbmUgb3B0aW9uIG11c3QgYWxzbyBiZSBjb25zaWRlcmVkLg0K
Pg0KPiBUbyBhY2NvdW50IGZvciB0aGlzLCB0aGUgYmxvY2sgbGF5ZXIgcHJvdmlkZXMgYSBoZWxw
ZXIgZnVuY3Rpb24gdG8NCj4gcmV0cmlldmUgdGhlIG1heGltdW0gbnVtYmVyIG9mIHF1ZXVlcy4g
VXNlIGl0IHRvIHNldCBhbiBhcHByb3ByaWF0ZQ0KPiB1cHBlciBxdWV1ZSBudW1iZXIgbGltaXQu
DQo+DQo+IFJldmlld2VkLWJ5OiBDaHJpc3RvcGggSGVsbHdpZzxoY2hAbHN0LmRlPg0KPiBSZXZp
ZXdlZC1ieTogSGFubmVzIFJlaW5lY2tlPGhhcmVAc3VzZS5kZT4NCj4gU2lnbmVkLW9mZi1ieTog
RGFuaWVsIFdhZ25lcjx3YWdpQGtlcm5lbC5vDQoNClRoYW5rcyBhIGxvdCBmb3IgdGhpcyBpdCBy
ZWFsbHkgbWFrZXMgY29kZSBjbGVhbiB3aXRoIGEgbmV3IGhlbHBlcg0Kd2hpY2ggc2hvd3MgYXNz
b2NpYXRpb24gd2l0aCBxdWV1ZSB0aGFuIG9wZW4gY29kZWQgY3B1IGhlbHBlci4NCg0KTG9va3Mg
Z29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+
DQoNCi1jaw0KDQoNCg==
