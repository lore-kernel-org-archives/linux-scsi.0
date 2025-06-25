Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2048.outbound.protection.outlook.com [40.107.94.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437FE13D891;
	Wed, 25 Jun 2025 04:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750826084; cv=fail; b=u4iR2ATRtkfkjeykoGNmpV1qb5hoTZSb9IMKtmjeBo+qKEvus7IFC8vN9asRm7NJZrUk7LPY7+JWA86tw++FRQlZfkpOXJ8lu9sS7XL7OyA5pVD1llQ2UF2bK7yr4rl/qQYki+kGP0vR9e98SSu2OrggVz3cQzbQvfaSDqAt9Bc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750826084; c=relaxed/simple;
	bh=AMYnbtTUj9R3BBt2ec1UE0V4gWVqBeo06zHueN80/V0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RIgOECXjQFRtV2aSv3EHgb+vo36/JxXIC2cJs/H1ZN2o7hMLc1KnbiiaQJ8iBmuVYQJLzUZNo0AmfeqiXE8jmJUzYt9ziFIgfps+kzktE1+YjQNkuioLZQRBrYlIH9pAUf7p9074FgqPqKMiNne64rwnmNxGkWAp2OJbNDJu6Ss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bKar4J2E; arc=fail smtp.client-ip=40.107.94.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bKar4J2E"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aMGmTBH3Rw1nTwPOHQLV8PDSfOiXpOAlW6EQevDB0VKoEz5nwMbuim+XRECm+Ei67AUQQU4HLg4Kg1uuSjNt2XFF/PhwyJyOEk+B5bCnqtLfDtq7XUBZxsVkhN698LNStGPb1BZGAVSeVpgUcmStad2I6ikJ8DcgpEcKhvmVogXmVyp2X1wfXZdP2Xy0jR/jGBlxBLrQJI6VL1mrv6hYeUMcb9j043a1aUShBtsUKKQ4D2QKceb3k97f8nG3l/p6LvMXeUsbPNyUl4G8LVayU0W7ie877JjMnM3khicfNDn6k4xX7NWb07G79sQP5x4QosbUlyIftnxf4FzkzR+EIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AMYnbtTUj9R3BBt2ec1UE0V4gWVqBeo06zHueN80/V0=;
 b=gzbfA2Sl/JsEYEsK5yhdwwZJkC1F+nGf67Cs7ewxfKLiQjUEY1u5+1csw37o0UgDnLQfRYGQUN2vuoNIAjlCUprJITcBrIuyc9a1X+eZ03cpi39Xiv9uoCfF4D9olux183B+1Mhu7wrpY1+l2t59W+VE+JJLXcdcORMuqHMZvDG+gM4sFhCwMDnbIt1olQxFjxotYTkhdZkqj3erVfGjqSyotqiWoLi34r7J6J+XspzoPhTIVBzE2NvvbVPYGmu5z8OPDIZdZDg5Bc9AcFfGnJWCe4vosb1VxuzASkdx7jGXSaznZzYDR13AUdToKUgb3qkVPekqXTO3KU+aud9fjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AMYnbtTUj9R3BBt2ec1UE0V4gWVqBeo06zHueN80/V0=;
 b=bKar4J2Etr/+s32LdGGcrL4PGPqsStDOa1MCiLlSrlYG/tc239lHvOTPm+UwHkYavlVsjJTsdqXR4QoAKG1tbP/dlwBcP0eivbxMl+4SlmXj+Oh1V/83Td7lsSyeZjZJZqLjM0JVAi1Ul1eW9cuDCrHwmj/99EeeISvXtN3Sp/HYMTd/x34ENNct3L91gAEbWDcDn1YJa/QdpIsTnitJLYt0C/YrElGE7dOXc2z2DTKAHIrWfX1n2acdrhpH+aYSD+TVvjOff9u0RP6mOQT+UTwnBWudcsCrJ0MCCRNdWO1u81q4mcwb0oZdEhVxG25Xa3wGM/I3i2MoN98tb1IYSg==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by DM4PR12MB7743.namprd12.prod.outlook.com (2603:10b6:8:101::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Wed, 25 Jun
 2025 04:34:40 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%3]) with mapi id 15.20.8857.026; Wed, 25 Jun 2025
 04:34:40 +0000
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
Subject: Re: [PATCH 1/5] lib/group_cpus: Let group_cpu_evenly() return the
 number of initialized masks
Thread-Topic: [PATCH 1/5] lib/group_cpus: Let group_cpu_evenly() return the
 number of initialized masks
Thread-Index: AQHb343eSghfSadRh0qWnlQQ2jWW9LQTVdEA
Date: Wed, 25 Jun 2025 04:34:40 +0000
Message-ID: <933f2a1e-8a57-46a1-bedf-73ae3d67ed4c@nvidia.com>
References: <20250617-isolcpus-queue-counters-v1-0-13923686b54b@kernel.org>
 <20250617-isolcpus-queue-counters-v1-1-13923686b54b@kernel.org>
In-Reply-To: <20250617-isolcpus-queue-counters-v1-1-13923686b54b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|DM4PR12MB7743:EE_
x-ms-office365-filtering-correlation-id: d0f661d7-65d5-485c-9654-08ddb3a199bd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|10070799003|7416014|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?S0didlFONWFCZmJ5em5oQWdkdlNZYmNpcFJYSzNMRmVOR2hrRURtT3pUTXlQ?=
 =?utf-8?B?U1haQUN3S1VQV0RMa3ZXbkorOC9jeW5vSkhGMzBGQ1I2VWthaVZleTdjUzRs?=
 =?utf-8?B?M1EwbHIyVkVDNnhQN0NRTi9LM1ovb1NZT21BOHY1V1RuaUlyYVd1d0c2RE4x?=
 =?utf-8?B?NSsvZjMxdGxvUG13SXoreWFMYUQ4dXh6SUxqOVJIT2I2UTFwbWJER3ZNM2xV?=
 =?utf-8?B?c0YyMVhKWkticzgxZTRWQUtMU0dXTVE2clptREFCbmRTb0IzMnFGbjhZcVFT?=
 =?utf-8?B?aEpCVWNpaFR2OW9IT0RKN01NeU02K1BSdXdac3M5Y2pMZjdoU2ZnVCt2SmpM?=
 =?utf-8?B?TCt1U2tFU3AxN3ZwMXRYT0dMdG9NYWJYS1lGOUNHWG1CbTM5dUkvK2JOUDVp?=
 =?utf-8?B?RlJwZzhWRUZibEJBZnR4Q3gzNWx0TFpGTU0xK1pXRTY0b2FiTUxtYWw2bllm?=
 =?utf-8?B?ZzlsdzR1bnBSZDhqekduSStHM1Rqajh4VjI2V2xwUTNoMWVPNUhBb3ZmbHhJ?=
 =?utf-8?B?Mm0zYXR0OWtoMlpXTHU2SE5QQWFnSlkxdGdOVWFRaGxpQlRXQVFhRmtxbzBF?=
 =?utf-8?B?K1F3VWpJRTA5b3A5SjJJVyt5M2dIOVNqc3Z6dzl6RTZ0VjN2OG45K09wSjY0?=
 =?utf-8?B?QWd4T3RpeXh3NnRKQ25WaTVhK25WUmxzN3RBQ3pkOFM1Vy9YM2UvSTd6a1lG?=
 =?utf-8?B?eUJWdFdSOXpaNWNnb2oyeUtxcXhRbHdpMm9MTWEzY2kwdldKQ255UFdaVi8w?=
 =?utf-8?B?OW9SZXE4aUZReUxCbnFZWW9acFRRY04vcDFWdXhiaWtMQzRyZE9JdlRrYm41?=
 =?utf-8?B?ZTEwdDJHcHRJS25tWVdDVFFVaUxZbW44cUlnU3dLZHVYbTMyQjVORVZqYThm?=
 =?utf-8?B?VHFKZ0dSS25TWHJhTFlKZmRyd2Y1WXZSZzJNNjg1ZUxSWUdtU0liTG1ZZi9G?=
 =?utf-8?B?b3ZvbGgvR2F4ZUFESlJtWmFQaXZRdW42UWF2ZldvZVNEUHI1WHVOd0xWdjJh?=
 =?utf-8?B?WWxyU3dNNmExcVdSTGh2UnpPNThoV3BIM3U3OHIweW94dFRBaGJTbkV6TGM2?=
 =?utf-8?B?dzRacHQ5dkRpaTdGbnduMmVyVDJZMTJwenJETFlrMEZMN2J1aVdnYVk5bmJX?=
 =?utf-8?B?WDZENlpVcUY0dEFubmFLUWhxTWVRa2ZCREsyUm1Ra2Jqa3d0TUE1RHMxdGY5?=
 =?utf-8?B?VXp2bE8vUWRmOHJTYVBBSTZNZnhqRE01elYwL3VTMkcwMnVOb3RkRDBabnVZ?=
 =?utf-8?B?STN1SlFzRERad2MzQkQ1dDk5MFBSYnU1SFBHZUh1SnFkalk4NXRtVlRETXdZ?=
 =?utf-8?B?cHppemFwbG5sL2FqTjhKSERoRzY4ZEF3ejF4S2tlNTRQK25iTEZIQ21zQnZx?=
 =?utf-8?B?N0ZFRG9KUzNZUDRkWUo4M2wwOEF1SXZGTTlYdVFUZHVVUWQ0d3QrWFFQbFVN?=
 =?utf-8?B?eEc4MndiQnZTOFZTc25MZ3F3MnNlQVpka1J6Um9ZWCtOU3JzT3FUT1RGeHd2?=
 =?utf-8?B?Ykl3YVFLMWQ1dlAxRGxKWXVRRWI2VnN6WmxveEFLTXp0QWJadHhuWXhiYmRB?=
 =?utf-8?B?WVk5ek9PcWlpSzArR3o3dEhSSm5zRExMTE9ZeTFZNmtwK2M3T1dJcFZDc0dG?=
 =?utf-8?B?NDdJTlU0OVhPbU4vQkY4eSs0K3I4S1ExT2haOGd5UjZoTjZxNURPb3lkanFL?=
 =?utf-8?B?WVNNQndkRXl4a3JPRGxvRUwwTU96N2xzZi9hOXZQdG1LSFA4cUZTaFhRQnNz?=
 =?utf-8?B?YnlHVnJUZWtWejVuNnlqTG1OdXUzdFpQTlhReVA0UENVa1lSMmN3VElGaFRC?=
 =?utf-8?B?bXBFVXVYOG9sZTB4UWJaZjJxclNoZFBydVVqQWh3dzJlbG5KVkVNTlR1cDJs?=
 =?utf-8?B?OU5nZlhmVEdFV0wyd01tMGp5eXRDZHNHazVEVStpR2pCSUFOMElEZ2Z5Q0ds?=
 =?utf-8?B?SGM5b2hXenZZY3FqSGdJWS9HV1RLMkZYV1l6TlJCczkyeEw0UDFSWXVsa09u?=
 =?utf-8?Q?WEKeu5Dfif/HNzo0qa4r8z9hSXJZNQ=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VE9OSHdYMVZWdXJnaWxNMW84YXBTdlpXVU8zRmFSMlJvV0FNT1VWa0FlOFBO?=
 =?utf-8?B?YzhOc0FXalNBd1FLOXNCOHVOT2c5WEMzR0VUWEZlZTFMVzdJOUNENktSM1Mr?=
 =?utf-8?B?UzVUU3NwOW9sVUxXSng2SHJkbG9RbGNrMXg0WGlaYzhTaklOMXhrYUx1OWw4?=
 =?utf-8?B?QjBTbkFTOFhoUmU0TEZXNGJhNkR4TklHR3dqV21WZVNxallTSlE4aWRCY2M5?=
 =?utf-8?B?VTg3dlRPMkdVdWhjelFpZG9QSVZCWGZMSjNsc1E0SXF2Sm5WWGQ5MmhRTFR4?=
 =?utf-8?B?Mm5xQ2tNcVJETzJQaERKZVY4Q3VLTThGenhDU1IrbnFiSE9mdTFKTUpIZ1Uz?=
 =?utf-8?B?MWF6N0ZRK0ZjSnlXZzh6VUxjTUVQU0N6TlhSWWx6cUFZaG1kdllqOTJ4Y0pz?=
 =?utf-8?B?dWc3U1cySVYvcGpId2lkbGI1dTBOYlJhN09laVQ1YlRvajNwL3JiWVZaRlIv?=
 =?utf-8?B?bjRMQzFkWDNiVWtNL2ZNeDFMMHJBcmtTb21HeExuNkxXaGg3cEQ5WDVYbWQ5?=
 =?utf-8?B?VUxtMFhnVUw4WU93RHZ5STFpZHdXdzFEeTRuV0ZkMGxlUHR6bk9MVFQwSTBW?=
 =?utf-8?B?cHpHSGtQNEN2aFZySmxlaDRBNHdLZHN3YnpDUDBXZlpEZEhNdC9YQk12dUF5?=
 =?utf-8?B?eXMzemMzSjlYM2UzR0NCTTBzVFk1QVJ6Tk1Ja05xbWorL21jM3lHTThZV3hT?=
 =?utf-8?B?NGJVdnlxMlE1elNsTFJiOTVUV1cySnNKbGpONDQ2alNYaHJPZlQzZ3M0N0Fn?=
 =?utf-8?B?RVFGK082a1BCNFArOVN6S0RVNWdEN0xYaUVYeU9SOWN4RzZFd3dzWndyaURF?=
 =?utf-8?B?SVNDRUw1eFJMQklSV2ZTL0U5NGZ0b3JwblEvdUpLVHRJWEtNblh2ejBUT01s?=
 =?utf-8?B?MDZHa0xiZHBObXFGWlNsSFZSK1FpNnZBbGlEOTNaVlNJbTQxZ1E4Z240WUdr?=
 =?utf-8?B?MWJKYnpwYmZrc09hekJvNlRNclcxamxoTng3aVhITGJjSGZyTFBBb1hLNWJS?=
 =?utf-8?B?bnZ6NTNHdXNBdDE5bVFsbmNFeE40YjYvMkpMLzRRZ21WbmNIeVQwWTYreXZa?=
 =?utf-8?B?ay9LQXRGOUc1c1RvOWc0UTR2S3Z2clV1UGJUbWJNemVzbHRDajRZc3p6SFpK?=
 =?utf-8?B?a1VXWG5MbmFTNUU2VzlKOHViYlZyam5oeXViOHgxUndDRzE0M2dTMitWeWNM?=
 =?utf-8?B?WE1vNUlFS2lVZDRLWGV5dzBhNTArZHBjRWxzL2psak0rRklpT083RGpvSjNQ?=
 =?utf-8?B?YnVSYXpXK29hTHNOb0RZV21UcVhPZ1VmcGdSU3hGV25YbjNOSlJpVXNvOXRm?=
 =?utf-8?B?ODFGMEMyWFpXcGJXREd1VXRkeWdLaStVd04vQXE3ZTdQMWhqQXBxdkhZRFRO?=
 =?utf-8?B?Y1JJVktpTkxFNWtRRlVZVERIVkUrSWFocEdzekdac29rdkIwREN5WXlSYWxN?=
 =?utf-8?B?OG01aU5vVjlPMkxkYUoxRTBwN3ljaStPRVZJUTRFRzNkNms5aCt1UktsS0hP?=
 =?utf-8?B?dnRiSWRxSWNyMkJJOVlITnhZeGNubFhvMTEwWkVCVitiQ2dJSURlcWRlWVdM?=
 =?utf-8?B?Vm1Jd1paN3YzREZ1QVAzcFpxSGNxSkdlR1o3a3k1bTNIakNRNnErQU9NSUdj?=
 =?utf-8?B?Q0RYSGs0Uk4xUmdDOHJJZGZNQ3hqQysyaHdWak8rZmtKeEgwYnBtUXFEWnlS?=
 =?utf-8?B?dkd1WWJRNTc1cXBJbm5SRWRtcDBmZm1mYXhNK0dIS2VpdnJpTTlCSEpGTi82?=
 =?utf-8?B?UWFERCtmYlM0TFlCWm5sMGJFMkphOGs2bUVNZ2h5Sks2ck1XM1BsbTJwelps?=
 =?utf-8?B?Wmd4ZlJCTGZZSmZPMUlmeUM1bk9aZXpqOGdFN2puWllOUjkrRFF4YzRVWXJX?=
 =?utf-8?B?T0VnZTgycFFVWkVQVFMrNEJ5cjlvNzlGaHRMdVNTaVZwSjFsZE1PMHRpaVRa?=
 =?utf-8?B?M3F4R1c5SzFmKzFRVWY0R1UzSTV4cEoxMXJ6b1JTOHhJUFJwdUNQeGlhYVVI?=
 =?utf-8?B?NnE2L20rUndlZERkN2JqN05iYUdqeVlJYlRSekFwYnRWeEVaUDB6RGd4N1I1?=
 =?utf-8?B?NEFvZTZnSktVWFRVandGYTU3djAxNit1b0d1NklKYU1mSWRodjBxSk1uYnI4?=
 =?utf-8?B?Z1ZQU1RXcjJYNlN4bUJueE5QREtsRVh4SXlKcDRwNnlQTzh6SndJVmdJNmpD?=
 =?utf-8?Q?P3AoXnI6zWjGfcRB89M+/bSmryGEqbrYwv/6KjcYHzzI?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0FAEE615B4883F49BA04CDF404944352@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d0f661d7-65d5-485c-9654-08ddb3a199bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 04:34:40.6560
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YGQLuXdWCiED+g2Es+WDVAK50ix5wCmh/mJ7ndOpzghGVvYU2uU+Xjc9l1Ctr9FBDzAzpH2kZqjvKZGBBMX3YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7743

T24gNi8xNy8yNSAwNjo0MywgRGFuaWVsIFdhZ25lciB3cm90ZToNCj4gZ3JvdXBfY3B1X2V2ZW5s
eSgpIG1pZ2h0IGhhdmUgYWxsb2NhdGVkIGxlc3MgZ3JvdXBzIHRoZW4gcmVxdWVzdGVkOg0KPg0K
PiBncm91cF9jcHVfZXZlbmx5KCkNCj4gICAgX19ncm91cF9jcHVzX2V2ZW5seSgpDQo+ICAgICAg
YWxsb2Nfbm9kZXNfZ3JvdXBzKCkNCj4gICAgICAgICMgYWxsb2NhdGVkIHRvdGFsIGdyb3VwcyBt
YXkgYmUgbGVzcyB0aGFuIG51bWdycHMgd2hlbg0KPiAgICAgICAgIyBhY3RpdmUgdG90YWwgQ1BV
IG51bWJlciBpcyBsZXNzIHRoZW4gbnVtZ3Jwcw0KPg0KPiBJbiB0aGlzIGNhc2UsIHRoZSBjYWxs
ZXIgd2lsbCBkbyBhbiBvdXQgb2YgYm91bmQgYWNjZXNzIGJlY2F1c2UgdGhlDQo+IGNhbGxlciBh
c3N1bWVzIHRoZSBtYXNrcyByZXR1cm5lZCBoYXMgbnVtZ3Jwcy4NCj4NCj4gUmV0dXJuIHRoZSBu
dW1iZXIgb2YgZ3JvdXBzIGNyZWF0ZWQgc28gdGhlIGNhbGxlciBjYW4gbGltaXQgdGhlIGFjY2Vz
cw0KPiByYW5nZSBhY2NvcmRpbmdseS4NCj4NCj4gQWNrZWQtYnk6IFRob21hcyBHbGVpeG5lcjx0
Z2x4QGxpbnV0cm9uaXguZGU+DQo+IFJldmlld2VkLWJ5OiBIYW5uZXMgUmVpbmVja2U8aGFyZUBz
dXNlLmRlPg0KPiBSZXZpZXdlZC1ieTogTWluZyBMZWk8bWluZy5sZWlAcmVkaGF0LmNvbT4NCj4g
U2lnbmVkLW9mZi1ieTogRGFuaWVsIFdhZ25lcjx3YWdpQGtlcm5lbC5vcmc+DQo+IC0tLQ0KDQpM
b29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlh
LmNvbT4NCg0KLWNrDQoNCg0K
