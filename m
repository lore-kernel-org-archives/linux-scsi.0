Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142EA511E6C;
	Mon,  7 Sep 2026 16:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788798321; cv=fail; b=eI5y6K12YDJLsJCxlCAj+JcjHL69hSUWDBEyN9zL5Q4AhNIXBBPQJe1zUISjZyK1HP9xL/FcSSSb9KrKIePLsAcChdY/ydIQ75i1PP6dCkTB6KaRCG0dOqnyaHpVEm7vbaXmcobtxpKFWzH/FWbYes4TwH5gAxBePxAPkhvP1fA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788798321; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jAZjaGWewbfm3ed86NJOUvioSm0uCNqKrJ+cg9YfzwUjAtgLo1jyAueIYc0ICkOxyf6irWCAggCdJ+ysTRSfXhdDpvP/8jLbtdhUOlh2Nnxp6mQ2gxfARKEam9yNcNyZELKzOn/8BdhimXWmJpeDrYm0bUevHoIWndA0zsORwDM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=hBOu9Og9; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Vjh6Ls6k; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hBOu9Og9";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Vjh6Ls6k"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788798318; x=1820334318;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=hBOu9Og9V3Lkz/XmI+LKgunWYZpjwfKALUbZTnxuq7bjDxL85v3w/ZEY
   zMoJjiGdbBYkrTZJxk7kpcuSeo4fyrqRtQ/QeqHHwlbkLjp33SfBuW4Yn
   dAfVhEE74/8rRSTtKDW2NyvY27XBzeg7Ji7mKIyZlrePBPlXN7DbXmKDb
   BN1SgQJg6SL8bny0Smd0uTNJzuyZycdUYOYz6NRcjZBAvvQhdm0YN/xbf
   /X+vEonmVbY7w58pOiUyedpWZPvV7qGn1C6xKxWRQuMC7MPfYw3IqJEUE
   2uln8v25W7wkNRaknQeBgxYBo2rOFa/dbdVyKW4wJOGjV3I6YQMZ3wejQ
   Q==;
X-CSE-ConnectionGUID: +4L1OxklS+eQtKcubxTrsw==
X-CSE-MsgGUID: 7iWAq/CURcW6mRSbOJTCUQ==
X-IronPort-AV: E=Sophos;i="6.25,267,1779120000"; 
   d="scan'208";a="154170990"
Received: from mail-southcentralusazon11012066.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.195.66])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Sep 2026 00:25:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yUGr+UnlWXdpLbANoYmPEsko7d6GopgEqyRp+7fyhLll8PLQ0rENwQQu/nMeq73dQK65kdwpEYvVJUGRjBWuUdtYVuW+91so+0g4IMGI2HDfpd85zjDYGqQ6z8dXz6SJTQtBhB4eLSSebMKxVr9cC0tZm7SFb+8gYVEwtyxs8ePTQSFPGB2A5hoTCGV2+3J/IAMnSR/4LSX5oXRF5cLCt/A/sZkd4oXGQ18FMBtDajCt/k9PPBC9t2Nzg4GnfKKJVvNG19LTQc1NnAchPwtIDtlOrgjBTy6BYLka/IneUOEtOJVpeU0b2yUjo+mAj0N9JZ0APGzqrNDlv81MUCnLLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=fxN5lqqwaeqhEBsJCZ2yYW6Vcph23KQHihscpKgKVHSI6eH0E7F9ws+nLYKYmQkXb4bzoawqy0OMngh/ZdGCG14V61saH7hLCzd9qie4dn/bqIwjbh9ufijPBHh3V/Z2qPXN4JhU3sM2oOlUrcsrVkgqwphqK5JhDLwggh/Jrc8+mkXsN4kKG5L89ZQVd1uCLNP7eg0jQyRMyLJuz+LB5o90R4vMOrZC6SZnOS/N0j8dbs4eZOE6KugYTEZbwyeUfuGySp7KYTKpk2yzgyT9NWMl7Vfq55jivp9qU/bHRpVfj4LArxLPIzLhBJjFrIQ7UChJop+G3fcr6x4QVHPwAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=Vjh6Ls6khdeGZFVXrHh0Md5aYzy+OCLDUHGGi38MN5VFLQlwvTxq/FuVFIsocXsRoKtlxWrUGPD1rUWiioxzF4xnfjmYvoFXMjuWHARpPE8UEqpbPBUvDnHNk3FjJhYh6y6cHH9pKI18A6jA7DFPZWHKpQUGTH4BmKtzwYT+KcM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BL3PR04MB8154.namprd04.prod.outlook.com (2603:10b6:208:349::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 16:25:13 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 16:25:13 +0000
Message-ID: <c8774870-f79e-47fc-8e94-2e32f3229b71@wdc.com>
Date: Mon, 7 Sep 2026 18:25:08 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 38/40] s390: scsi: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-39-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260907024343.1046387-39-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0429.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d1::10) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BL3PR04MB8154:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fd465ee-8952-48f2-5955-08df0cfc97fc
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|7416014|376014|23010399003|1800799024|366016|921020|4143699003|11063799006|56012099006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	nHjBofBfMQ0dsypLmC6Se2/5bOYY6zdFL2IGMeRu70zN8vZuR4avDzWJIH2TwEfbHu8azZtGj59xxgwacwWW6CE386kbYkz8oq9+1asn3RkQiqXjeA9gCy2WclG+jSGL5rw2eFl0p6nXTAmFW7dsj+O9cIZxQFCDeD59mg1nTXMe89S3T4hUBBeT7ObXvwadmfCxHzDYenQvcH5m3PSETpX12dGfhc3hYhYKzioUIAA/d+e9IYEnDL8dGWRwfbXvLp32lAjjeTy5j2CnJ72UR83OcDfGQ+E08pHHKMorsQ061SIjhizHmH9PNrCDcnVjB1BDCIR5FXVqeLzFUvbhjJECmmh9szKpOYVkTYuC/KtnrNWlHij8c5vK/Bg1VmMCaAhdVsiDAqIoTtXiySuR4wGB5ACGnLLYOoUu1zwNITXm/SuL1UWB+Vg8bPtxIgBP4wMV5JOZkUy3lHjlh2MLh+ujrwaS7ZznISWQB10zXVk8WYswF8zL3HzTKScK2BGKTgqQ2VPsceGSV/IBWDlwEgkNtDZACWU4DbSGzVq7xwfo6AjRYKYcRc+Aln/XVaATNuEpMPqBdUQz/1jtTTlNpNePyoBJ0ic5xkothugIU6aCqCiZ9srOXD21Dww91iZbYR23kHQvgm+4HcZ141Gb/GEN85aq5SXfkaxmov2PShFAt4/oMi2IobxFV30AJXs3VfiAZoJiEoc2zU1dFdikMA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(7416014)(376014)(23010399003)(1800799024)(366016)(921020)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WENUMTBnVFk0NHpLYk9GbVdINkt2WW82cXlFdWs5WlpqTjQyazZMWTVibDQ3?=
 =?utf-8?B?S0xJWW1NVDB0T04rdGI1RDh4dkZPS2dtTzhPdGlnTlpGeURYdElKK2VGYS94?=
 =?utf-8?B?V2ZjcFZlQkU0YTQvK1ZUOGJYekYzbDd4RVAraEFUdExhdXYxNW5lbWJsYUNq?=
 =?utf-8?B?cUJrVFNWWkZiVzlTN0pwQzAxOWdqbDQyY1dkS3BKRE5SN2d6eG11VkpxUHBh?=
 =?utf-8?B?bDVEdDZVQWI1VGU4Tk9ST1Q5VGNYeDFVQjRCN1VmVUx3V2YydzkwZWhGbDlm?=
 =?utf-8?B?WXNrNnNBQmVzUmZ1RHZaaE5hS2FYSVJHNmFmdTZiYmhPV2RPVmFWUVZMMVpi?=
 =?utf-8?B?N0VTb3Q1THRwcHJmRkVFQ0hhbmtzSUxacFZpYnlHc3BPeHo2QUJGRVhDU3Bk?=
 =?utf-8?B?SUtGYjVnWHoyenE5eTdUWWtLSFc3V3pzb3FBNEhuUjM5dTQ3T1ZFSFJ2OWtq?=
 =?utf-8?B?dDVvNmNwZDJ4Mlh1SmNLTVpNM2ZIYnBTSWlycFpQR20zQTljRmFMOUs3YXZL?=
 =?utf-8?B?RUtibzVtWnVseGRwMnl6dWZkTWo0a0tJT0pRWHpvT2dkWDZFUjA3ODlCekJs?=
 =?utf-8?B?SHJFaHJ5SytONnArVk1zNXRqbVR3Rnc3azhZRjI4VlFseFVnM3JzVWROcm1M?=
 =?utf-8?B?N0ZDQk5FbDZHNkxEdWtTb1hWelkxazVuVUFvM3JFQ0J6UFlQZEJ3ejVUTk1h?=
 =?utf-8?B?RXlZZGVLenZacllOOXo0NkJZRWhzcnoyck9DME0vSG11MEhVYkllM05vQ0NF?=
 =?utf-8?B?NnJXSFRwUnJOSWlLY2IzZVdlOTRwcDdJNDd1ODRHUDV5UFJGSk9KMyt0cXRM?=
 =?utf-8?B?M00zRmdKTktTb0NhUXpZaFppdzQ2d3plZjlIcWp5Y0pOeW43dWVPVFA0dlB1?=
 =?utf-8?B?TURsVFM0aWFsZzMvNWZ2N1p0ck1zVFhXQWs4VmRRVERqNHBoSjVDZkZwQ0Vz?=
 =?utf-8?B?ZlZWV0w4ZytGL29QNUcwTEpUL0RwTG1KZm9QVUhmY3hTNTQvWDl5Y3FMNjNx?=
 =?utf-8?B?OGFHN3RJNXNIYXIyWTFxT1VvSHpORnpaY1pwQlJ3a0RQa1NjNExHSjIwczNw?=
 =?utf-8?B?dFhpVWZHeTJLYW0rQ3c5cmRIR2VhUlBZUCttR1c3SGZ0Y1Z6ZitldkVCbldF?=
 =?utf-8?B?K2x0cmtsckFQYUFkai9UTEtZS0pOSHVtNXg3V1dRRlVFaDY4bWpaUTJ6WG1M?=
 =?utf-8?B?a29GS1pldTViMUh0SENOd3JUQ2tDR3ppRGZ2K0pvbFd3aUdhV0pSUjUzTzJj?=
 =?utf-8?B?NkZVQjN3QThNODhveVduek1yc2xnQ0YzK0xFU0lSREQ2OWs3bE8zNkZnNWV4?=
 =?utf-8?B?blVtaXRxOGl4czJyTks1QXYyMlFHTzhhSGFzcGdGNjNoZzVFWDF2Uk1KTjNB?=
 =?utf-8?B?TUlOVTdpUVM0ejYwenJ5b3JwWFhlSVp5M0R2THY2TTdOMEJFamRCOHZ6ZHp2?=
 =?utf-8?B?QTVMb3MwR25sdm12U25mYmRzelQxaVUwakJKckRRUXMxRkE2TWFkVHhVZFRp?=
 =?utf-8?B?dlhadndTME0vRE8rSVhlV0hNYVI1dFdveVlCKzlaOW54SGtTbThYaWRFVjcx?=
 =?utf-8?B?dzh5dnZrMW5aMXNabnVGeG1zcHJKbmttcXoxeDhLeHVUTUwxVHdUMFJTV0kv?=
 =?utf-8?B?ZUtRMWF5UG1CcTk4dWpyN04yYnVjREhRaXp5V0FwMkJCNjNadWdWd0FrMkk2?=
 =?utf-8?B?aWpLWjh1UDhzNFVlMUdqVkwwNEpZQWI3L1lXUG0xMHl4S0psY1hoRVhteUFC?=
 =?utf-8?B?cFhtTmpJTkc4NHJtOXV6VlpWbkRDeU9FR3BmUmV3L1NPZG04TkNkSnV2L0hH?=
 =?utf-8?B?SGpuNTNvb3pQUngrcEs5OExLV25qUlgwdHczSUEyNG01UUxQaE8vSHdoTDd2?=
 =?utf-8?B?SEtUWUo0RWlmY3FuK3NxckVIOW1YZ0VWaUFWb0dZcVZuQm9nSlJncUlXSHQ5?=
 =?utf-8?B?bVJLenBKZnlBaCtScmE3NlBXOUdKMHBvaCtFSGwweHRoVklFeUtmL1o1QTAx?=
 =?utf-8?B?ZzhOOC8wZVpPWVJvMFVMTkJBZEdlclNlWS96b0lhVnEzMUVzeENQcG1OaU1S?=
 =?utf-8?B?bk9uMlZyM0cwVVJRaEtrVFNIQWVVczI1WTRzV2hOZnBEdTkyOFduRTd3VDY4?=
 =?utf-8?B?WXVOemk1amdKenYveDZVU1hNUXIyUFBqa2d1OTFFa3B4eFQwcnhRODJvTS9u?=
 =?utf-8?B?QlZWUG85Y2NvRlNBNjVQOEhsYmxNVHd5VTBzeEpGSHZsRGJpV2RlVTNQcEk3?=
 =?utf-8?B?NGdjazZnWXhoZTRhWTFPRWw5NWxpaFJHa2IwRTdrT1JhbEpuaUVFbWhySER2?=
 =?utf-8?B?OHVQTHVJMDJ1UFliakpVQ3hNNXFtWGNXQTZrMTc1Nk9oMFpyNjA1a05Tc0RF?=
 =?utf-8?Q?RMr26RwbC3H1ioUY=3D?=
X-Exchange-RoutingPolicyChecked:
	FGZzlZ8cSXnL4egoUK+wgX46rTkPNpVNPYOU7DBGf5+wZPvsraA9udMhMLyD0OUN7454CPXhsZ/BVQsrMnx/WiFiSEl/yPFLgFn4+9Jz2Dw509FQAs0i6KaNyxcmhwZnlZWbBGTHBTw70G4syMkTDyyGvUeUFcfFNR3HHNS7J7fVnijjnArbha+ct6YHqPYAk1hUAJFuH9E67hD4DPGIZpEJltJHhefLXzD9KFu6h5ocr/eD9oJo+XoDrIcrIsCSj9pAqqEIuVa0qnOosNe+rrUEI4MLrc8wcrMQZ+WojuLJuUWiKNpbm/GeWtr+winG6dTmJgaUFJ6/Kq1qh21XGQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6GNiG8vMAA16/mUpSN2g0Ib+dqnR/KR7Yz67mSKz030SJHrL/EBGPxFqVz4IH3SlTehzQ8Gb+xLuHptPhzQoQo3FU7sA3eni2bfLN0QOckwPdihgJW/6VjHIKkUyDl94yktOMzy0UZbU9x8OILnw5l2q5qJAGIzOmmkLHyC4EithL/eEYysGkZT3eXdh/uVDXJ6K+eZj+/9sDWfsMNWhOiD8niv0OBqnNElDvAT3t6A1xB7EFNOWgDMadRedV+WB36IB5pbOjzBpxZ1YPiAajJhDF5b8apWz4HDqytX3jzTkL699mRYBvz3Gg+3bKX+YduRxo9lYIgdzEme3j2ZAEP+OR9e+B3W3uQ6ViWUkoACrzDvwYyxQ6aRLK+iNxapC26GUZzHFsusJVmCIkL/39J7YsDWHrTMaESgm93CaPkmJmr0mHhe8MeeK1Icfmc9JNlUhMPWRBesVMKIfk5j91kEZSrw4mHunjjVzGMbm1V0y60+R8iwbk95tcLoVyUnNfi06+etR4wjEA5jGDbKjmkF22mCyKkxUxqAhS3vbfeOK59+lO6WeK0KUT8KLR84R+qPZM6B2ZdRkwewz6eNPILmuti/uA9fNco+9QXPcauezPmIJnS+/aiugbGGn5xny
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fd465ee-8952-48f2-5955-08df0cfc97fc
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 16:25:13.3197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wC2bTvncI1qUT7axv6DIwv3Xb46DeFNiaC/+Xcqa96v3xLtA+PvjGlvwuF96tdFPcg9g/0LWe7UUXzlECBoS/ZTqy2+Xlges6kwKTSdZfNg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR04MB8154

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>



