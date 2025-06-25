Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447D71E32BE;
	Wed, 25 Jun 2025 04:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750826274; cv=fail; b=TrWZ/ycWqm5eUOT4qOXqRE0bf5WuFiSKGMtt8UFDxUEm83wWlM2MMQfna7MZ/vgqyiCkTvwpiTJlwnp5PkiCYgX510FrkGx8rA332cEKIK/2zEeFC5KFPpLsSe9IRCDTpoW/e8FxX1i1luZOpsdfp5WEaoIt3FteQfAZio54E64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750826274; c=relaxed/simple;
	bh=XwKQXs4Mimu4b1UHUT5NvbEPPLhqthn0rkHgjpClr9E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GTZQnZ7YIy+r3OdVIf2g0nWpb+tmWeK6/d2Ne2aMoilzRCWB5Ayz+0v8mg43Kh08bFOrkS5bevP5c4h2nt3AAWIA7CSIYgQpuoxVKX4jESq7JBHRMMvjlpvFEVVzCLdoRI+g+G0sZ2hEN6xAbYZX1lLrmEhml+y5R3Ji6peIJKo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=slnSFQt7; arc=fail smtp.client-ip=40.107.92.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="slnSFQt7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CF+pD/U+spn6BnM5Z6ZYqwrrGi9xIe3tKqf+tohbLZp08j4wsqRCyXH72FIf/NTr8SX47d+smavLJRbHeIQSnmkzBfOPZdkXstDlKvBlNc9HJJWIV2OkXMG8G4tnl7EHl6MXoGPgYSkUbqTiBB1Yn/pIIYl2UNa/s89reAOKOT2RQ5iwk3wK0RLjIkJHmo845SmIiY/eE3tL0uOf1EvJTCBchrIVyRL58r+lIdS1R0/D7zUl+JQN/xFvmuXsowBNFMZrKp0zloPi4FwiQO1UfnEJCOzHEeLwSN6L9Qw2wXRc5pAdXOXUZHFsniFAubA4ugRnIkSF63egN0Wm/gOn4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XwKQXs4Mimu4b1UHUT5NvbEPPLhqthn0rkHgjpClr9E=;
 b=NF2XsgL/hGlqfTzxSjzkTmBzIIn6WLMrIOqrPBxe9JYVclomN565oo5ZyqsuaXS0piDoN1koSo04NMQv2I4syC6S+uZbf1RSSGxjDzo+woOQhkI9wlUCWPzkDJVma8myPRKG+qslMU0wVKjFLybSN0Lu4uxDPp+fX75WXCo8Cn2TMRqd9PL9leQEZOvmOc1/H0y3HJgGbTis5nJR2ofFMPj7jS2eqkM+3mFu2cOcABs5TiNO7jvUGjhJNMz6B9HwHhRwXiIChKj/yQNPm3lcV8tqRfaOFj4TO/jcv6z07wzS94P0vlDVdOUCTUpKXcsTtL/Z0wR/ei38v9ckLnAQKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XwKQXs4Mimu4b1UHUT5NvbEPPLhqthn0rkHgjpClr9E=;
 b=slnSFQt7zhkGSB53tsctmnX99qWxuwBzOd0OHvt167XjcnSgSWR0Chwgb5zmCjL3bQ40UT+/SKdjKaFbKbeiI20cF82JJneNPd9TEgDhhWY90mDxR2RDMDUodd1oiJkLdQswOnlmOY3dx8q357G6es7ZM7mMNuPNVHfYImdgRTqnrogtRDmzJEXxfPqCjYK8gnGQQYAh5eQtmzH9MQTmGi0W9LTa6qxr/77TE5UiKR28MmTMUf3NzfrXUCE+vzRS/osdjE2JpAaEx0Gah4A0HRpWguCcp3YSImmNP1titkBlyUFn5TTtGV0QwxcVBuQY7StfIAk18r27bLDs7HvMRQ==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by DM4PR12MB7743.namprd12.prod.outlook.com (2603:10b6:8:101::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Wed, 25 Jun
 2025 04:37:50 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%3]) with mapi id 15.20.8857.026; Wed, 25 Jun 2025
 04:37:50 +0000
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
Subject: Re: [PATCH 4/5] scsi: use block layer helpers to calculate num of
 queues
Thread-Topic: [PATCH 4/5] scsi: use block layer helpers to calculate num of
 queues
Thread-Index: AQHb344LueSSEHsWWkyY3J6bhlwdTrQTVrQA
Date: Wed, 25 Jun 2025 04:37:50 +0000
Message-ID: <383bda13-b846-427d-92cc-d0edc965d60b@nvidia.com>
References: <20250617-isolcpus-queue-counters-v1-0-13923686b54b@kernel.org>
 <20250617-isolcpus-queue-counters-v1-4-13923686b54b@kernel.org>
In-Reply-To: <20250617-isolcpus-queue-counters-v1-4-13923686b54b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|DM4PR12MB7743:EE_
x-ms-office365-filtering-correlation-id: 3b9bb6f4-cd60-497d-3509-08ddb3a20b01
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|10070799003|7416014|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?eldPMTdrSjVyelRZL1VBdmN0QnNVYlpMcmtpdVRKVmpPdGRZYk5ZTlJXeUZ2?=
 =?utf-8?B?alc1YTF5WStTUlRLV3p2S0lVbnhpeTREaXdUS2FLaXF2dEhvbGVvTHlDRTNs?=
 =?utf-8?B?Z3hpamV5SW9wQXF6UHJWcVFpSDRTOXBPcjJLckdXNHpMQUhqcXVFeThrOFVm?=
 =?utf-8?B?UGluNnJ3QnZkbEpqY2xrTlVSeHFGaWUvWE9KcVNoYnRSaHl5NlFlbCtSblB6?=
 =?utf-8?B?TkdtbmxuWjQzTWZhS21KS3ZiOU5rYmRic1o3T1o1QkZKaE1Rc1lzTjlrbXJw?=
 =?utf-8?B?YVdBQURIb09aTERVTzY4OTloNkZaTnFxQ3pTR0RwTFpSR2FwZGlKdVNzc3oy?=
 =?utf-8?B?T1dGbGRBQkV3QmNOZ1phSHo1NnBmS2hvNC81eW1ITXlqblBUUkFjUjcxWjJV?=
 =?utf-8?B?aC91THNUc1ZCemlTYzZUdzQvQWtKWDVjSnVsOGxYSTRjRmIxanN4eUdPTmFD?=
 =?utf-8?B?ZlFCUVg5bndwR3VhYVpaTTlhOCs5NkUxaWZCVkUwNFdRcTFwNS9RSlgvWFkx?=
 =?utf-8?B?bzJZZ3F4YVVVQTViMW5uZDJPWUhVZ0IwNmY5dzdoOXE0SWUrTHhHMVRmSkFz?=
 =?utf-8?B?VWVnM0hPTjh4SUJtdUpCZWtCc1d4cjFtMWdTeHBnTSs1YlQ4bFFPMmNRcDVy?=
 =?utf-8?B?NkxadkJmV0ZXakZsN2JJc056bk5rUlBMditKellIOW5vVjVZT1BBbndQZGpj?=
 =?utf-8?B?djB2MzJBUXVOczIvcHlMcjZjN21TbGFOaVFmNTYxTEx4dWpnZUJQZWtBeHpW?=
 =?utf-8?B?TU02c2NCbHIvUEFtNmx4Z1hjYk1FWWVlNTRSOTVZQzVHanFYVGtTQjlDZHVT?=
 =?utf-8?B?Q2RkcjYzQ3VPbGdTK2JXa3ROWUdscGxLM3RnVzRzRktLYmx0ai82Zm5sc3Nv?=
 =?utf-8?B?YmN1UXN6SDA3SHcyQ0F5REUvZDJTdFdhcjBCdnBBakNTM0VZWkViU0U3bkZY?=
 =?utf-8?B?U1Q1dHlsOUtoTDlXT2Y1NStKY1pGbUN2aGVIWG52MlQ3TXB0TlZyQ2FscHJO?=
 =?utf-8?B?QVNicWI0VUhiWHh0VmFZd2xsWXpJbW9lN0hnS2hpOHVEbWxhbDRvTWdDMlhJ?=
 =?utf-8?B?aGsyVTZTOFZhZUU5Q3VDbHFzRjlsZ2JMRlFsZGdqc1BNWk1XY0JkcXNjcE1H?=
 =?utf-8?B?dGNVbGR2M0RPdzhSZXFBYlBjSFQ0bGF4L3E5UnhucUJPMEQydGhMZUlQVFFJ?=
 =?utf-8?B?a3lTeFhkYnJuMVNYYUpXWHM3aWxxeEM1VUxVWUpyK2JjZGllQVNrZ0JBN0pr?=
 =?utf-8?B?alJXNFBLNFhVKzRCQXVvUEFkVUhobVIxMkJ2ckF2emo1MDg5USt6bFp3SkVK?=
 =?utf-8?B?K3hjMUR5VytQT1U3MFBETU8zTWNLdlVZaXFSQmNEZ3RrN0JWcEVoenpsS0JR?=
 =?utf-8?B?c0laa3JtTWJlaU1JNjJBbnVQcTE3S2lqdkdHSnNSVFZZOUlDOVV4THlSa2lZ?=
 =?utf-8?B?UGlzdHVTbXk0WXFvZStEMU5OU3A4ZGtGMXNaeVovWnBZT2FmZndmMTNaYVRU?=
 =?utf-8?B?Znl5SG9hSnVIMllBaWZzRmVSMzJER2UyUndTQTNRT0tncHlUMkpCSnVzR01D?=
 =?utf-8?B?S1IzcVdhdlVOSEFGTEZta2xxenVGVFcwOUhXdU04akFqanhkNWNSTEx2bzhE?=
 =?utf-8?B?RVBqZklRYlhhWElJZTMxZWN3OUF1QVVjWndKRmJxbmNVT3kzZkpHZjRkMmZS?=
 =?utf-8?B?SFM2c0tVOTZaR0J0T2ViaW1pS0pZM250TWs0b2JjS2FKT2RCb1hPMDdzdklx?=
 =?utf-8?B?NWxITmtIbCtYNzVOdTdaUWRNR2hJQVloQkYxUk1hUUJDRE82OTBldDlTb1FC?=
 =?utf-8?B?aGYxbWhqVDluY1ZCSW5GVzZVb3RDV3JQbDEweXFWQ1gvOU5DS1dycnlMZkZw?=
 =?utf-8?B?LzlDNzB5aTF3ajQwbnFJUU90NlNBM1h4NSsxc2ZLT1REODdydXhjK3VwZjl2?=
 =?utf-8?B?RGMyYXU3c2wxV1EzTXNsdjJiRGY4cHFQNXFVKzV5T3NBK25yTHpPb2hqcTIx?=
 =?utf-8?B?RGNEZHhDZFRnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YXJKb3RjcU9WUXlDWk5zRkJhb1BBYWdKVjU3cGJoSW1NR0U4d1B5MS8wS0Rp?=
 =?utf-8?B?S25ScWpJL2NQMWFjTHh3MGlLR011Z3JmNlZBRkFzNFlORHJvS0wzdE5jUXdO?=
 =?utf-8?B?L29GbmlaRFR2NFh4MHNCbE9ubU41VlI4K3pHci9ta0tTVGlwNm1meEtWYUlB?=
 =?utf-8?B?RFVqREZzRTBvWXpObDQ2d0R6V1VPV3pHM1ZBczN6cHRTdTl2QkVBeFRxelVz?=
 =?utf-8?B?d3NvRjMzR2tkY2tQZmg3MmFsc095b1FTYjE1dmlpWmlTRWl0cVhteXNtVEhz?=
 =?utf-8?B?bU0vQVZWOUdwZk43cUdnUXMwUmVramQ0NDVYV0ZHTE53eWhTbUpOcjZYMWRO?=
 =?utf-8?B?ZzFNbU90QnZWWmMreWJWUmtkekhDREFWYjFqWnFYZU5iWVoreHluanlOcDFD?=
 =?utf-8?B?ZVhMSUUzOTJkZDBYNDArb3ROVUtZc3hic0IwMU5lZm1ta0g0cHpkU0hsUTNa?=
 =?utf-8?B?djBuOG1Bb1pieXVDMEM1U0FFeGhhUlV0RzFMbmZpbm9oYnpyMDVxRHUvZC9z?=
 =?utf-8?B?WmJWWEo4cW5CUVZlQlZZRTlNaE9MdjExWkRpYnBCVFdLUk5HcnZVaDl1aXY4?=
 =?utf-8?B?Zy9uclp0TU5NdGJVVkZaRVdPWEs1Z0dkc1c3cy9uaUxYR2sxVWpoeTlSNUtU?=
 =?utf-8?B?VnhVUkFoL0NiSmpGSHZWVnR6amlZanZUVmt5WDNNQ3RSRWdSRWhFN1N6VUYx?=
 =?utf-8?B?N3RDS0hFRUoraHY0azV5OW1WRUhqZXQ3NEtrS0I1czhIT1N6VVVNdncxUndV?=
 =?utf-8?B?VGg3TWxsUFFsQkw2ZU1DZHQ4dURNVmpaQ0dPQVRvKzJrQUZ3QnZkNGFDN3Nq?=
 =?utf-8?B?T3Q5M1ltblRQRE54UHpaMC9JRCtkazd1TGdLc0JjNE1NSG5zMG1LMmplbTI1?=
 =?utf-8?B?SzVSRFpib1VnVHFnOGR2WWFuZSsrSXFUejdXREhpaWcrblBzYld5ZGhEOXd0?=
 =?utf-8?B?QSsrRXk0ZUZNRUNydmllR3p3b09PMHNEK2tKaVl4Yk1UaGpldlZJNGt6d3Zj?=
 =?utf-8?B?WXZ4R1UyaXZTaGZobk9zL0tyVlg0bDQ1SURPcUhpeEdyZ0xvTzh3UGY3eXJ5?=
 =?utf-8?B?MzA5K2poUUVEN1k2bEdabFAzd2RKZUV2OUp0dmx1Y0I4WmZBR3U2MlBvczZ2?=
 =?utf-8?B?Z2tUaXlKWmdYL0YvVkhBclZqc1grVXo3cW53elVLMi9qU0hMMG05Q05iWlNn?=
 =?utf-8?B?RzRlM1I0SEJKSmdtY29Cc1lNYUVFL2NOb0tnSkdLaHlMYThHRFhnZ0UxMEt6?=
 =?utf-8?B?bm95QmpJSndlYW1ubi9KM1BEYWphb0JUTVpBSm9vZDNvcDEvci81QUpyYmZp?=
 =?utf-8?B?T2xOa0R4VTJjV2FjRDBIeUNIVlNieHY2QXg0WjFndTZVWWJBZU1iWEJCcDFl?=
 =?utf-8?B?Smt6UjdNYUVMdDZENG81Wml5UTZVVU5lcjhpQlpXMnR5allubGY4c01Udk5n?=
 =?utf-8?B?TVJGUFVNQ0pSN2NMMldJYWlBcHQxcmZsUGp2cWZUcmQ3eXkwKzdGVWVRK0Nk?=
 =?utf-8?B?MzRkVXhTem10cWV1eEt6SkxiWkU1a2oxQ01RaUpJd0RQU0IwWDVGQmdPYlRD?=
 =?utf-8?B?MTNYT2dNekFvQnd4SnhrejlEZE9lVVFQVWtRckFKUWN4ajA1cFhqTGdWL29l?=
 =?utf-8?B?YVpHUzFRbUR1N2VnRDlWYXM4TitacnY4b0pGVmxEODUzZnNScldaRGRkYmVG?=
 =?utf-8?B?RHFFbWtnUnUwTkRaZ2MvbVRKaldObnQ5T2dGbnVzM21mdTAzcHJua1RmSFkw?=
 =?utf-8?B?UFAySS9UZkZrNjM4RjlWM1NmM3pTZ0lxemxXdytCODg4WkVVV3RueHRFNkx3?=
 =?utf-8?B?SDViZVZPOHo0T3BjNC9RWlNKY3Zya21qS0hPS0xTZ3FIeVplNGU1dFB1VDkv?=
 =?utf-8?B?Wkp4YnliU3M0b1V0OGl3ZEFLWWNqSVRFM2U1aUhPVGNMbFJDUTNONkd0Zmth?=
 =?utf-8?B?UjN6djBiNVNTTk8wRnlKQ2xMQmFHU2VuMklKalFSb1JtT05kNGI2Qzh5MkV4?=
 =?utf-8?B?N0QxUm1IdFZvS0wxa2FZSlVmc2k5L3FoYXFIYUdaQjZGMUFTMCsyTUpHdTlX?=
 =?utf-8?B?Mk1veERTYjl5LzVIRzdkUkd2dkwvZHJmTkh2QWZQLzFXRUdUZnpMN3FmZit1?=
 =?utf-8?B?eU9wdDBsQ0p2Mmg4NUpvSlFpTStKVjlmbzUvRWZqeFVQT1ROdG9PRkdrR0l0?=
 =?utf-8?Q?cLcV7Kldt5PhgZBRBmCgJWlFEv2o7iGJW4x9gyaKbQZd?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0CA89FE9F723CE4B9073A120FBB5C85F@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b9bb6f4-cd60-497d-3509-08ddb3a20b01
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 04:37:50.7096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xje49ioggABHau/H/rbP2/SQmbQGJF/DhD5tdily2uZdNOe49MCkl1vdwZEdlzj10y2VFJtAwSc9SeV+9X0/pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7743

T24gNi8xNy8yNSAwNjo0MywgRGFuaWVsIFdhZ25lciB3cm90ZToNCj4gVGhlIGNhbGN1bGF0aW9u
IG9mIHRoZSB1cHBlciBsaW1pdCBmb3IgcXVldWVzIGRvZXMgbm90IGRlcGVuZCBzb2xlbHkgb24N
Cj4gdGhlIG51bWJlciBvZiBvbmxpbmUgQ1BVczsgZm9yIGV4YW1wbGUsIHRoZSBpc29sY3B1cyBr
ZXJuZWwNCj4gY29tbWFuZC1saW5lIG9wdGlvbiBtdXN0IGFsc28gYmUgY29uc2lkZXJlZC4NCj4N
Cj4gVG8gYWNjb3VudCBmb3IgdGhpcywgdGhlIGJsb2NrIGxheWVyIHByb3ZpZGVzIGEgaGVscGVy
IGZ1bmN0aW9uIHRvDQo+IHJldHJpZXZlIHRoZSBtYXhpbXVtIG51bWJlciBvZiBxdWV1ZXMuIFVz
ZSBpdCB0byBzZXQgYW4gYXBwcm9wcmlhdGUNCj4gdXBwZXIgcXVldWUgbnVtYmVyIGxpbWl0Lg0K
Pg0KPiBSZXZpZXdlZC1ieTogTWFydGluIEsuIFBldGVyc2VuPG1hcnRpbi5wZXRlcnNlbkBvcmFj
bGUuY29tPg0KPiBSZXZpZXdlZC1ieTogSGFubmVzIFJlaW5lY2tlPGhhcmVAc3VzZS5kZT4NCj4g
UmV2aWV3ZWQtYnk6IE1pbmcgTGVpPG1pbmcubGVpQHJlZGhhdC5jb20+DQo+IFNpZ25lZC1vZmYt
Ynk6IERhbmllbCBXYWduZXI8d2FnaUBrZXJuZWwub3JnPg0KDQoNCkxvb2tzIGdvb2QuDQoNClJl
dmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg==
