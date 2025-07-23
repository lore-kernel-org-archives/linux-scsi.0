Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363762E3702
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 07:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753256974; cv=fail; b=ce6Wq9dwEnn9sLH/+DNXO0NnQboD12o/pRldTZonEDkagJ6Xh/qKDKym7/OyWCQ2bJqsFPGjfHaVBI8xpr839XOrsP/SMvUDevFEA3bCAZWIXSA74K0tnp52jYUaXMB9aueu9oLJQW1NiZijTW8WAimHDc3/fwAThcQ8VHeKHcA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753256974; c=relaxed/simple;
	bh=GHDhmqiLmnL/MS1zkwfTkkJb/plT0jZhicgAvNZxheU=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=N1ndUC/pElv3CRTEGCjaobqFKjpqeqaoDnYMfQ8cs9upOsY+r017LoqxMPO/zNnGbi1LpdYqnqrEZ0Rs2VhKDDTsEU1cBi0qe1HHeMvwSf/Orrsyun3CO7nEIkuqKpJ2rs3W8AXpD6WkcSNSP++WtLQIqqzsz2KwNHzexn4XtBQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=g5RkIgtp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PzGwuhUY; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g5RkIgtp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PzGwuhUY"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56MMR5Hb023402;
	Wed, 23 Jul 2025 07:49:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LDinDOpqmTAEJQLL3aEcUVupCR2Co43TVd18RXS26N8=; b=
	g5RkIgtpHgo11y/YgNySWs0NaoM8MsFzDwO2guQDkv8eytcyBE/xnY3m8MlA9z9W
	LkF+27ehQ0KVMxjSdzEGlXPmqcpX6Ew9N4kB/DjEXLehPHrq5p7bcEq22N6AnhJ4
	67Lv6NONbiJ4TYIwqdEJEZKO7+bk63sTQ4SPkcoiU9eud3Z2oLy/HEKpR1kr1GRI
	yxn0PR//oBiTshZzUOgnGKaVK9i+uzCALYLXWyZadyUixUOyvlcsmMWOH5TRr4pF
	7aM1/oi4SqhRDnDHcHP9/YdMiAj9B1bJmGt7u+CrmPVZazvmNVw27wK1oITcfCu8
	DuorG5LGkdLzsaI/q0SX3w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805e9q05m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 07:49:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56N63sZt031476;
	Wed, 23 Jul 2025 07:49:29 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tgk7f1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 07:49:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sTgiSuN7cVZEZx3GIC5nfGe2ld6K1LzLA+VgWJEfbQUJ540w1MhEK6ZdjAgOvD3lp3m8767gY9a6IakR3sxgttZdi/wb0KCBc7hv5PZZ8y9CHLEkgRW1wQHSIM98w8OnGo1TUhOs4DAeSgz9Ybljd6o6AbJh3KuqBv5hfiMFIxhf/NZVA7Xeb1oCZ7HXa62ZUnxHhNtMjcTqnjIzDdpSQxg/j9KZAZSZgC52/YvBruVfpZo6wMPnJgJT6ay4Rnx6WebrDiMAa5LgplYN/mAOjVkawhoXfIBA2u5Zp6ibFjZNbeCCrMO6ZuPZWuh51LGNd3GIcF/OKazDrvllv7BU6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LDinDOpqmTAEJQLL3aEcUVupCR2Co43TVd18RXS26N8=;
 b=siBrWy5FNKy/QWPtEbyQ9phjxAxIh99UjITRp/kfe0cmiqAZcHQQPoXqv0yP8lMveCa+upf738Cv/xeXXK15ccBhE47w24WuNS97+KhHZE71h3ul8wHV5VdvemD+uEQz3OsEx37zZXH2NcQO9GaPZo/01kFQ7FUTYC2pujo6BzAFkpGFnApIDOb4NirL09Hr5900gZnxkGti6tnU0469zCVUqCD6FxGGsLBihltVBoxYcIWoVZbpqQABuzS4beVPCBEyl5P8wMmvGGCyO1pjs9bXN/n/IPITGPs+JGrzc84X1W4/If63A2QCmOjlJUhqhxkfHxio3gjjlVw3HiWrGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LDinDOpqmTAEJQLL3aEcUVupCR2Co43TVd18RXS26N8=;
 b=PzGwuhUY+bZNHaHAMyuKCL80UjOawRYclR0B5LnDWXafPKVFDawXjT0UYU/jj2AX+97h4Ls+jRe9M3i8RMxtmalJBUg0L7J4GXbddNqWTsaON2mXXWSaFFd9dAX15zZ0lN0/YRMoDrW8YmWWl6GYO72HDolQOB6ohdAChe0vk20=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by BLAPR10MB5172.namprd10.prod.outlook.com (2603:10b6:208:30f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Wed, 23 Jul
 2025 07:49:25 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%3]) with mapi id 15.20.8964.019; Wed, 23 Jul 2025
 07:49:25 +0000
Message-ID: <2edb2812-f650-4b23-af6c-0aa36603f0e4@oracle.com>
Date: Wed, 23 Jul 2025 08:49:21 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] scsi: libsas: Make sas_get_ata_info() static
To: Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20250723053903.49413-1-dlemoal@kernel.org>
 <20250723053903.49413-3-dlemoal@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250723053903.49413-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4PR10CA0026.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::20) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|BLAPR10MB5172:EE_
X-MS-Office365-Filtering-Correlation-Id: 860345c2-c159-48b4-ba95-08ddc9bd70d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ME16WmZCR3NaQ1dzUnNqRkQvMTdIc1FmNnUwc3ROUGt5eXdwdHJBM2dWOWU0?=
 =?utf-8?B?OWN1TFBkeTV0Tjl1Y3B5d2tyQkZRTU5vWElYRldiQkNVUHhOV3crTnkrRkZ0?=
 =?utf-8?B?bm9GS2ZKMzZ1aUF5R2o0ZXBKcXlTczhkT0JoOVJBbTg0dEg4ZGhIaktpa0N6?=
 =?utf-8?B?cStqbmRHQ0VDdmVmWFpNKzBORVFoMEg0NWl4dDhtQjFTS25ybmxZcjhZQmxV?=
 =?utf-8?B?cXliS0grSHRqcExieDcvR1k5aTY1R2k5allDdVhOZHFkbVBYankxczUyYXQ4?=
 =?utf-8?B?bWVVNG4yQWVYTmhUWll5dXJzdFVyK1VXS3U1ZWxkczdoWUFQYWJEdTB2VmlT?=
 =?utf-8?B?Wk1tZTBtL3ZMblBFUkYvaHljYWZzUzdoZFluNmVlb0VDd3oxYlFHbDBxdDJG?=
 =?utf-8?B?Wk5XTC9aY3pVakNDY2o2Qmt1d0lxTmdrSlRKeFN2bGlpYmhBL0ZiYnBpV3Nv?=
 =?utf-8?B?TUo3UStkNjVDaDZxN3ZHaFY5YWFhSENoTkxhVUhFcWMyeWpBSHgrT0RnT2xY?=
 =?utf-8?B?aEVWQ3ErRkRDRGpIRGh5dHNEUlc5Z3BGcVNhUWVybldrNEdKYWkwRThvbE9r?=
 =?utf-8?B?dHBWUHpmV0JMTlN0MWV4VGpKRXdwdk84anNSNDVpcHVrTjNKUnZpdFhtcm1C?=
 =?utf-8?B?YjZVNFdLMzBVTzdOU0JPOTB5N1JTcm0vYUtjTCt3Vk56aU5XKzdzTVBIVkNn?=
 =?utf-8?B?MVFnM084Y01wS0VzUHZVcTd3eVpTenR6UmR3YjF2aXlpRElVZ0tBRjlScEVG?=
 =?utf-8?B?c29KSXVCaERUbVpuWk1nd01WdFN5eGFQUEh3dmxpQ0RMU0RQQ1BFbEdwNHAz?=
 =?utf-8?B?aGdnYWdhL1YxKzJnd2xaWGxvOExmK2JycGduL3I2TWRKaERDdnV0Mm1UT2RH?=
 =?utf-8?B?Y3padmZkMTlZL2R5YnZHN2hKYjBValdhdG9qUVJpekNhaUNhemRRZ1p1dDN5?=
 =?utf-8?B?QklPc21uVjV4c053WjVSWUVGaitGSlBKanFiWHBPam40dC9TMGlBREdsZWIw?=
 =?utf-8?B?bWV4MjZqMHo5ZkwyeWFMQVlqbTZNM0RYR0R4Z3Nwd1NFZTF3WDlKOXJlakxQ?=
 =?utf-8?B?Slc2QTdCZTVYcm5Db29ZL0pHaW8vRllhczYxMFFHWFJyNEsrUmcrVVJRRVd6?=
 =?utf-8?B?RFhFM2xkdXN0RitCaVNiTFhDV0ZPa3RibFo3YnlGTC9wTlNBaEpZNldEV3RS?=
 =?utf-8?B?Skk1V045N0YrOTZzSlptdngvbnpzS216YjFHM2d4d0xhdGVOT3NUdGpnWldO?=
 =?utf-8?B?c2xyNjBUcXhYWWxJWUxnN0ZLSjJzWjhySjVER20zanZsblQyL3lDaU4xNzB0?=
 =?utf-8?B?QTB5NmtVcDlpMkYyYWJGMWNvNG9vdWFJU2xya2hxODd0cjR6eEVWNlNiS0c4?=
 =?utf-8?B?anNBYzFNQSsrZitYWEJkM1ZXd3ZhN1ZZcWdQQi92OU1SVGM2UUk2bzdFS0dR?=
 =?utf-8?B?ZGNkaWt2clpGZ04zUU94TTZwTTRYV05IM0pyempMUHZCQ0kwaUlOMG8rcXZq?=
 =?utf-8?B?MGFZOHdvS3dMYXFKUFllTE13WThQZmlIUE5MZjZaelQ4ejVRTUtObzJ4U3lp?=
 =?utf-8?B?WHQ0U0Q2N3pRVGtiOG9BaXR1MXh4TStNWTU5WVNBYjNaOFpORVMxTld2UDdK?=
 =?utf-8?B?RURScDlzSVhtSUdQZnNBMEthcFliV1VkMjBrMzZnQ01SeEtzMDJwVXRZclA1?=
 =?utf-8?B?UXN4Tmg1Qjczci9NbVpoRFpseFJ4bG1GdnAramRHMERSRmZUSWNlRk85cTRQ?=
 =?utf-8?B?YUpnTmlrbU83QmlIMFlCcEg3Uk9ocTBXYnRiOXRtZ2NVZUVGZWRxN29TcGMv?=
 =?utf-8?B?ZEl0WVA0NEw4ZlQ5dmxpdU1LOVJSOXhrK05yM1luS1lSR1pxc1NSWXFKaXZQ?=
 =?utf-8?B?RUhwV0Z3Nk5rNWsxQTZ2OWNVWElrdHNRbmJ6YmYyOUN5SFZ3elZ2amNVV0Vp?=
 =?utf-8?Q?5E7zCCsUfyk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QnlxQzZiaGtBTmtCZ3hsb3pvTGI1anVlclJ5NmRHSzhSRysxK3JUS3dicFdy?=
 =?utf-8?B?d3U3aTRDT0c0elM5aUpZMjByQzhZUnl4aXhoRHk5NmpCYUJ6Q24xaTNUaDhy?=
 =?utf-8?B?bVVVd3RKeldwR2xCMFlpcXZ6RFhSeU5EVjZuYkozb25qNUVpK2I3eVdRaW9K?=
 =?utf-8?B?RS9DNjloOUJsakg4THVxblY5Nkk1ZlZQSWxuSUcwTlI5V2N3RnpTRUYrL0VW?=
 =?utf-8?B?MWkxZzRDTVkyb0JKWE00TzVvR01MempwbWFTK3J6Z3ZCMGo1SlhNdlp0Y1Bo?=
 =?utf-8?B?d0hYVXAxbnRSNW5wdDdrLzg5eHM4SG40TlRJckdRNThEQkNQKzNpVVBmUU5n?=
 =?utf-8?B?eWtlYUFoY3U0Rzd3eHlreG5rODh0MUpVd1JsNlAvd2RDekRXN3Q1dkNkdlc1?=
 =?utf-8?B?TGRhaVEyNVlwdXZ3SGxicFNaRnhkbEswdnNJWE8yZGtCOXVzZEkzZmNZM2VM?=
 =?utf-8?B?a3IrRHUrS0pncnZWWk85akNEWnNsUW9sNXhCR3hKcVIrSEdTK3lHSkZ4QWpa?=
 =?utf-8?B?ZXZra1pQOE9UN1FZTVVIWnR1ckxsQ1RxZWJ0dWNvNFNUcWhTaFYyNkN5RUhr?=
 =?utf-8?B?ZzRnN2F5alNPdFpSRnVKWjNsYjFLc0Y1QlU0Qkg1YUoxQlF3SjdobnhzNDh6?=
 =?utf-8?B?SjhhNEZwanhoTVBNOTVxb3kwVnlIMnN3UUo0cDFnWGRqNGg1dkVVVDZCSjZB?=
 =?utf-8?B?M0RsT3R6RnYySWp3SXVsU0pCczlrMWpuWi9LdUVST2VIaktrT1pHbkFMakNR?=
 =?utf-8?B?Z1AxaythOXJWTU1LNUJYYTBuNHNqRmNOZEdENDA1V0hIdUV1SjRzRGdzanNH?=
 =?utf-8?B?MjBmejVteW9HL3FhSTlnbG1uQXhJczVSaGlZb0JlcHdjUWdmK1QvRWVFMytN?=
 =?utf-8?B?SUQrV1hnYXUvdWdvMlBIeDNMQzlhalZDWkFyaWh3QTJJQXUySmk1Q1lVWDRn?=
 =?utf-8?B?eUJkMTV1Mkc4MEl5bkhYS0pDM3ZWdXF1blBBeDEvdXBTTk5xeU44RnF3dldp?=
 =?utf-8?B?Y1FZMWF5TDZkdThjdXgzVHZKUERTNzVTR0RwMmhqcjYrZWxOU3JoUUp5RjVH?=
 =?utf-8?B?cWhXK2RQdWROK20wY0diR2RIY21pdHRocVNXcDYrNEpQVlhGeHlSc25vbGhj?=
 =?utf-8?B?R1VDREUyVld1TmlyVmhSQjc0R3BpYU8zYkNGQXorejBjcGdIMkovN0htU1pE?=
 =?utf-8?B?aWVVNHlySWJiMWFBWWlvNkcvWEZ0aXVydlpHNnZyR25zTURSWi9Idjh0WjQ2?=
 =?utf-8?B?ekZ0eFNydWY5dTByOG5pRmIzRisxaVdhdm5TUE5QNldad21SK3VXM282alNr?=
 =?utf-8?B?d092R2FQM294blJ3ekdVcGJTdkUrLzFWL04veGNQWGRBYXNZem5VbmNkWXdl?=
 =?utf-8?B?QjhYZllZNGhrd3Fja3FrWWU1WDRNc1N6bUViakNMalcvbXN4TXpiQzVOWnZm?=
 =?utf-8?B?ZW0zb1VQS0duKzBDT2RwK1pJMDJ1S0RWcVFsb3J0V2VRSEJKM3RIQkJZd1No?=
 =?utf-8?B?UE94VzZiOTM5VlVSZzBYWGJjbnF2RmpBWGNVUzdHWkducnc4ekk3dVdvNDBs?=
 =?utf-8?B?c0s4S0RjNStTYjN5M0FtZi9yK2U0M0FYMHgyWG0zU1FIQk9CZHFoM1J6NjMy?=
 =?utf-8?B?MmpEUTFRY3BnNTRoOGl3MXBoK282VFpSRjRwdVJGRTdBZitlSWR0YXd6R0I1?=
 =?utf-8?B?SkQ1TmluQmM5U01MK1JaL1FuVFFNYjdKUXZPRlV0SmJyY0VxdEVsR2dZdVNF?=
 =?utf-8?B?NWI5MUcxNGIwWXBsdU94Vk5GVjQyb1EycTFueTZub2hDN3BzRlpmL1dqY2th?=
 =?utf-8?B?ZG5SQ3M4YmJUNVcycmdWd1BoTmYxVDNuS3lORUF4aEtsbkRzcHc3L21VU0oy?=
 =?utf-8?B?RFJTOFIzNGlFc2owYWhpMGg2NjZDbTRsSVAvQkdiQUd1RCs1SVROOVNvMW0w?=
 =?utf-8?B?M3dkYnVoRHpkemdzVng1eGRqWGlHZDdoVjJlQXRvL2h6R1FtOGxiMzBQWGRD?=
 =?utf-8?B?K2V3bk0rTUY1S2NmVFhsZG42VFA4TnNucXprcGFiMm5JaE5UbkR3RmdSaVdG?=
 =?utf-8?B?Vi9heG14QWM1SnpMaVplL3c5dnJKQ1FGbE1QUFN4ZVJvY3VZUXJvUmsvQW1j?=
 =?utf-8?B?WWsza3V1aXk1a1BzSVpGS1VKR2VjYXJ0L3VNRTc5aFg1ZmRiZ2VEcjFQNkJZ?=
 =?utf-8?B?Tnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	X4+xcR2/4+5a0lEQUHkVkSxY0nnR1Z3l0jXxJlimnXAj8aOYMdyTYzjpXsPoxTGcB9rv1B1OEN+oPjmMxmtyRdiJqsefuiK63yO9GHcc/HgzAMeEdsaYiAMR1/KscY28gm0fPTa05xLz5WLxc7EHZKIWvkDD3AoB8LGJJlcfcfkOfEwnqRgj+0MOGTKItqqMVXANPSW+xGZyRC5FJM/i4DxA3hbLnWRC1q/1bNl8nV51G8QMUAJbrnYj9YY60Rt7/H7/giV/b/2XVGoynlNigdJqA7D3Md1f0Y5csVeGyrOLqxFX9D9DO3bDFfg/UX5doRPGDD32PNaZ1wr80T9teLX+iFIgBR6vnTl09tinFwbKA6ckMQ6cKVuZb1sepfDofWGe5i0VUfIv5Yhj4Dj8Vy7G/HiJJIJo5fOsvN7ExxdgSNyM4QIKfICE22c8G+0IswvmmM3AZwwnVWyAZ0efxwLOvJ4o0dmK5fs9haN4iaUGflvQcNb89WzkiORGZTnmfRSWj3rfjPpRYpK5Jp44aqX7hTawU+SNkatRbP4iCkKifWFzJ0d6R2UFRYY4eXXLU0rGu26QprPheo5wtHkaniRHugIAvB6v2gUbqlGbbno=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 860345c2-c159-48b4-ba95-08ddc9bd70d3
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 07:49:25.6811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: my11qLV5uD0xnTSbF6zo8UFo9Np+GRW+/lY9SEmgjhknJ7xXWwHH04gZxoe/b/H3j4SWHHWqf5XbNs64J6BvWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5172
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_01,2025-07-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507230065
X-Authority-Analysis: v=2.4 cv=eqbfzppX c=1 sm=1 tr=0 ts=6880940a b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=dstPm2xCaPb_4xe_crAA:9 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:13600
X-Proofpoint-GUID: r2sDxQBZCAIVEXnvRscmPuqQEkEsnGeh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDA2NSBTYWx0ZWRfX9PV3LmrONQJJ
 /c1EWWR+T48D+A0DKXF3its9tDkSyjGtSIiOaraImf1VZiYuEW7qqbwKJK4Fh4GHtxXI8D3CHaG
 nCqThHOD9LjOsvwCYBtbjlZHQ0W0yNRO27NdQoeiey/VAAg23mly9Adx/8gqcP5dkC/NuVahXI5
 ts32rrDMm3gBhoOdC8JP7oRBEMpYEPHPNVjJmCgpZwUAyf7FVEDZ0+JO64SFFJ+eS8aI7ZKupXL
 ElKb0bYbbA/D1G4M/cQWpN6kTTeoWgS6ljCellx6gEnxkl9sR6Pu/1n+TFco/NbXMFbGD8Kb1wH
 hM/329w1JqJEKHV/lmNPZYCwdC5AL0JKoKu/Q0X+EioijpVVuChdDfXnwOLopU7cy0pjiY3h070
 JA3GHie06TT/uQ3PNga4uvjBklRFW9/fazwz5bB+kVtohuTdxooU0tMHTbSshHpAi2nXZk+n
X-Proofpoint-ORIG-GUID: r2sDxQBZCAIVEXnvRscmPuqQEkEsnGeh

On 23/07/2025 06:39, Damien Le Moal wrote:
> The function sas_get_ata_info() is used only in
> drivers/scsi/libsas/sas_ata.c. Remove its definition from
> include/scsi/sas_ata.h and make this function static.
> 
> No functional changes.
> 
> Signed-off-by: Damien Le Moal<dlemoal@kernel.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>
