Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B486ADD
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 07:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753257185; cv=fail; b=bPLv7XYmYAnXzliemkZYvgfO3hqBk2bXzhmxBMrJ8Em+mBHBjw/aqvPZQ/W0wFDQ7QfkfDRdz2nJ0NrDz4acWEAeq0nZUMciJeRPOqEnTEqrwsk5yVpB6fiXZFWAPu+m2qeToxDjXro7hfof+dThKNyCgs88lMTpxLUbn+es72I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753257185; c=relaxed/simple;
	bh=LM8ASZ8ryv0VqrMh9wBAEjGjLWdL6xcBS6T+XOVUUgs=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NBivMLGidN9omdViItw1JxLqZDVBEm2cTaTynCMwu73Wiy4nwF1Vk76gVgrgCBDTnoE9zyhb1BRm9twilK9ZovSnivSOxiZgDyBTOmHnQZ47tvGxCjbpAXPDmDCWOPDa24p78D9eEdXcjSD0cqY6ipAqreD5ZSTXCGgt+DdO+yo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ezD3ia3Q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LpC6LCPj; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ezD3ia3Q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LpC6LCPj"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56MMQi6t030624;
	Wed, 23 Jul 2025 07:53:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pqaRu/bnMj0s98PL/yXBG6i1B0kzj0B4w/smyb15pOU=; b=
	ezD3ia3QRJxpUDTMiIFD3Y0ybey2f8GVudR7J16o/gC5IgyyA0mKg/DDiV+cnrc+
	EDu68qzlfPq+N6qyR+xYKsJuHazV6NGHtmiAIgi59XBFtsanm434b4pKuIzmamQD
	0zxENviH7W/myaW5NB8uBRwlrGgf1RHpheKa3RpekOGSBjQ1xU4ZCUGLeKy084+8
	8XVRMp4KkzC1tIBlYMROwu139C22k6VpJkPGiq5TmkHZAvpFjSP1gVLQxTPIWLh9
	/iw9/F9afYhaa+GYRmzBlSwShZktt8cwxE72PLhWG2VTQDCiHPKLowTct63yGi4m
	iQ56KB9HomO03ddMXUeiwQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805e2evyj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 07:53:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56N7QSOJ005877;
	Wed, 23 Jul 2025 07:52:59 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2060.outbound.protection.outlook.com [40.107.223.60])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801ta9gvj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 07:52:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZS0xwcAUbhocRi7tgkV29GWPoP0wiaNcYtYfvObs4o8J0AmuwwBHMoHEgBVxzlTxxuYENUgzdw4wrhhECvsG78FkTmQChtW9zdZVdcJrWuil7xlj2Rai0GSoLEglD1AHsO5QIAhkDFmfc1eyKTSJpEw2pF9TEYOh72cQGDW58OgS0VIVFOcIS7jdnpkJBX3OkcWG3rI3Ur9RsfGNxGTjvbypHM0au6tMmBahNMvfY6lsLhWmvCByqzFIg9qZ3Gieu0O7jrY2aZvDnIzXbKnT5EXOa7J4jn69hw8IquSPJCkS2OxvQexnKVWFUibD/BK4NqiSGcS4Onv+m6d+YBJ53w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pqaRu/bnMj0s98PL/yXBG6i1B0kzj0B4w/smyb15pOU=;
 b=OKac96DEVK87Ocd3hPGejXZcJ75Qe1OUtZ9ZnZpdKN6qmSlYlQwOXw/xl2jZebn1ZQmHBTb1PAA7rbCSncMw45Q8ISpGfQo29C5KDl464pNbhu2yT1MYtF4NIqjV5BET2tUsFZkR4vS0JLdezqSexgMai9B7fQky8Nvm1Q0t5QrwmW3oiwWFM58XC8NhBX6DI8i+6sZiWsQGucfPKg03a/+/o5QbV/TOGnkHGLq9Xz5xwAb5/UJmdd/R569TeomcBxPz3AKth9sI02XiikFrSgPepemp3WlEPCuMJhjASAaG0rpJQWuTcPlpbkgV3lrdA3UfhS6kmTCvCWZjjYPdxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pqaRu/bnMj0s98PL/yXBG6i1B0kzj0B4w/smyb15pOU=;
 b=LpC6LCPjcAm/hCEhzWHFNx66auhuDiVzwpToDAue3JXMpHvRtbpIBnsR0uzoSPnjv9Z2k3PZoZtu3l/3CGIRGHPQ1Sa7LseeC+9uKp/s5WmpUvepKjwLt9wZahWq0w4vnqwkCiKzzUkWzG9BXG1kHy9dGQoDribQ4RHej+wPXB0=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by BLAPR10MB5172.namprd10.prod.outlook.com (2603:10b6:208:30f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Wed, 23 Jul
 2025 07:52:56 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%3]) with mapi id 15.20.8964.019; Wed, 23 Jul 2025
 07:52:56 +0000
Message-ID: <455b2819-d28e-4692-846c-6f078ab0d0cf@oracle.com>
Date: Wed, 23 Jul 2025 08:52:43 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] scsi: libsas: Move declarations of internal functions
 to sas_internal.h
To: Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20250723053903.49413-1-dlemoal@kernel.org>
 <20250723053903.49413-4-dlemoal@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250723053903.49413-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PEPF0000017D.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c04::48) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|BLAPR10MB5172:EE_
X-MS-Office365-Filtering-Correlation-Id: 316217ae-1a7c-4a22-bbd7-08ddc9bdeee0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bjNHQzVhcUVPdUtONkQrazhkc2FuMTgwMEg0RVRaM2RYUHZsTjlaaERZbTlW?=
 =?utf-8?B?T1JrOERDdk1kTHVmNVFuUzZjMHhHcXRaV1BRMmI3WitUSzMvWjNDSmk0ZHN1?=
 =?utf-8?B?ckpKUkxwQkxjdXlWeEl6d1BiU0hGRmhGZDhCZ3RjdUlxeElhQXJSL1U2Tmlo?=
 =?utf-8?B?a3BGUVNqTk5KS3pPNFRkSFgvQXRnVVRIekRyMEJpekZXQ1c5WjZqbWp0aDl4?=
 =?utf-8?B?aUllclFjdGhhZFJ3c3kvc2xvV3A3a2o4M0Jjcit0Qk5iMVU4NEQyUXNjV1NS?=
 =?utf-8?B?czZBVEJCL1M0bnYxcm8yaFBxcWhkQUdXdGlzYmF4UVh6ZGltaGVkMHhvRHFy?=
 =?utf-8?B?a0VZekRRUlYyNkp5ZjZhbEdaY3BKNytPd0tiMUNnZE96TGwrR1g3VWRuVUJm?=
 =?utf-8?B?QW02YUdSckN1N0xVdzBWeGxJOTNheWtoTkRiT3cvay9ieXI5eUJURVZTUlFp?=
 =?utf-8?B?M01UVm5KalBhOWxDakpLbFZZT3hNRDFGOVdjRU1YMTRDT01Cdk4wV3lPZjJo?=
 =?utf-8?B?blVoSVRtNW9lUm42T3BlRUs4Z2lTRnFTZFJzbTY1Z2VSQ0FSenlhWXB2a01N?=
 =?utf-8?B?UG85Rm5Ob3N5TUNkbUpiZ1laZTJ5L1gzWUlZbkZBKzVoVjIrTHF6L0pwZ2dv?=
 =?utf-8?B?cHVjNkVNSnhCY21Rd2RnamNsd2pvVTR3MEdkZlhJVlNUN3lENGVqaUF5TEly?=
 =?utf-8?B?R0c5TmM1blB3WVhzVEIrNW4wTFBsakdLRTNvSVoyNmhxdEg1ajlrRnEvWnkv?=
 =?utf-8?B?MjNCUWNkYW9kSnAwLzZpMnFGbHNCVFJ2OGpqbFk3UFlrVkx3YkZMcVV0UkF1?=
 =?utf-8?B?b0NCRFNmZk5jREtsU2QrZXExYVJkWlJoTzJWck91MkFGYnJwZnVrd0xBZ1Vj?=
 =?utf-8?B?NXVIY1Rra3JoazNtZnlaY25FWGlzcktUWUtQYnVRNGhuUm1GdE9TSHZxbG5w?=
 =?utf-8?B?d1R3MjZtS01WcHNXRjdWZzVqMjVtb0VEalZKVHBzYWl5VmoycHF5NFhhYkEy?=
 =?utf-8?B?azdiZ21URnhnNVNXSVAvKzk3UWsvMWpBc2ZrRDNPL2tyMmpTRWEvU3NyT252?=
 =?utf-8?B?Z1pJcnIzdlU5M0F2aGR0N05sNmJ2TFhodDNjNElYcWNLVGtFRDhNK0VXR0ht?=
 =?utf-8?B?a3ZPRU9pTW9keWkxSzNrdzNWWkZVVkFiSEoxbi81NVVrc1VWdzlVWEVSMHNW?=
 =?utf-8?B?RnNldWk3azQvbDFQTUpmdTVlaUlSZDVMeHNPaUw0OFdKNi8zbGs1bmNWM1lE?=
 =?utf-8?B?bzhSdEtOS2pSUEtwYU9lYmxPZ0tBaFUyamkxcnhPaCtTdklSS1RnVXNCRHNu?=
 =?utf-8?B?cVgvT0tVMnhVaUVjNE83dVdSakF6ZFZORTBtMTBCandnS2NkUUpFWkhNYWE4?=
 =?utf-8?B?VjZEQ0J3Y0V4Z3lzZEh6eTFpUURkMFRvMWIwTTlEMkh6Zlc2bUxFeW8ra0t3?=
 =?utf-8?B?UWZqaTRCdVVKUnY5WUxjWGc0YnZ5eWxudStJaG9iYXlIZ3c4UXdqUU51U05O?=
 =?utf-8?B?SVNvOEVISFBPQW1kanRRNzFlS3dzUGl4OFFtdS9WOFN6RVpuQ1FPV3F0UWw5?=
 =?utf-8?B?Qkg1b1ZZYXQ5WXo3ZEpaSDZSQS9yNWxib24xZVZhSjRzT3dzY1lDTUg0NzZY?=
 =?utf-8?B?cDh3S1NMTVcvdDIzSWNoTm90Q2Z5MUZLSmFITHNRSnhCQ0hQVjJxc0pROUZo?=
 =?utf-8?B?S1M3L3ZDaUNTT0Yxa0MyUUtIY0todEREbUlvYkU3dmZXbHhGK0J0S2RTNkhk?=
 =?utf-8?B?QUh0YndQWmdwWStWWXc0eGZOSkFFM21XUjlUR0ZCWDFGczNYNktnM20yQzV5?=
 =?utf-8?B?K1QzMFBUK2ZvbUlieDFEY0o0Q2FkbDF4RVVPS0p6UHZHQitWS2ltUldRVEt4?=
 =?utf-8?B?eDBXZHZMZjZXQ015dnI3T2ZrZUZlYmJjVFQvczQwamFjWlhRaXVNZTZwUkU5?=
 =?utf-8?Q?k8W2ZsSgxJw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y05ZS1NQcHpObWVNbTVEYk5qZ2dMd0xWMEphcEQwZmNnbWFwNkgwSlVhS1pt?=
 =?utf-8?B?b2tTeWFLZG00akpsbGY4NlI3N0daOThRWFl5UXNpWHV0MkFSK3R3NWNlZEw4?=
 =?utf-8?B?eW9oL2N6S1hIakFqNkpBamtlK1hNTGRWMlpEaUw1eklOZHpFNlM1akovM21k?=
 =?utf-8?B?RjFvRGN3VXBlbTR3MjgvYkw1U3RqZmtzL09ZamdvNDk2MGVCVFVzcWpxaFNC?=
 =?utf-8?B?VUtoRXplQ3RYd0FYOXRqQjhBdWRoZURNVGNNUklCTTRYcHhDVnNTSTM4RU9F?=
 =?utf-8?B?ZFl6MEd5M2JxcGZ3a1c5WlNzUzhyZTA2YTEvQlE3ek9yeFhsQjZiS25FTm1U?=
 =?utf-8?B?bExwZ0x4OG1nU0o2VUVKSmpTQ215RWhMcC95eHc2eFlyM1dWZUI2Uk11NDRk?=
 =?utf-8?B?N2YxOEtJbVZ4WGY1Nk5rUldhVzFZeVRqajlONUdRR2hGbzFkZ3J1bVNHQ1hs?=
 =?utf-8?B?TmlpZk5xQVBzS0ZpbVhldmpYR2QyZ2E4aXIxRXFSTVpoRnBJbkUyd2pSL2lF?=
 =?utf-8?B?cnpLUjZZNGZaS0d3YW0ycHJqRWRBTkRZNDdsdkorNjhBemhTQitVNnJHUnVk?=
 =?utf-8?B?WHU4UHNRTHYrTlRmcG5vLzJxT0dQTm1HTWZ1a0NNR0g0d0Z6cG5aaTc0V1h3?=
 =?utf-8?B?bkRZdG9GTWRnRFJDUGRHczBpTHRLaHZEY01xNFI2MmNBQUptdTFQWFptYno3?=
 =?utf-8?B?UlVCclhqZHE0U2pjeDRaRWhUQlZEWVJ6RTl6dEZLaytsWFY5STNRZzNsT3FM?=
 =?utf-8?B?U2tIQVRJa25nUW1LQUZHMUczby9xTzRsVkhuMU9GdG93OHl1aUNmenM2RTlk?=
 =?utf-8?B?YTNLQnI3eGltOE55NGhLODBsWG9vQjYvekZ3akpYYWFzNEpzQzd2R29FdHl1?=
 =?utf-8?B?Q0JQQVJKTjAvR2pBZGRDN2hRTDQ3bGdHZDJVbVJucnBEVGdWRldFMzBkZUll?=
 =?utf-8?B?d0J6MzhqNUFtZWxBMnZsMWRERUc2MHo2RDBMK0dQRXRyaERDbjNKdXUraENF?=
 =?utf-8?B?TlZwR1BMTmJCS0R0MCthWitqMzduc1YrRzNZRmZ2RFdiUHZ4TlZZM2pEUGcv?=
 =?utf-8?B?U2RoUXZSc2IrdDI5Y1l3azkwZXZwR1hxazBuOGZ5Y09Wa1pPTk9ubjZHQmxW?=
 =?utf-8?B?MktYQnpKbFJnSkRqNzA2L3pNdFpLb1RjSHVidU9NUWtZMkkwa2ZsTXVTcEJi?=
 =?utf-8?B?b2RVTGx0c3puWGdWSkwzdXhEL3N0Y0ZxdDZndzRKRXRnSkVDc0VkcmticnRS?=
 =?utf-8?B?VkVWUEEwOWp5M29SQml3NDVvYnVwaHpsdXljVGlaRjRKamZlRFRRQkEzaHRQ?=
 =?utf-8?B?ajI3YWlSYmFiZDFmSDJsSlArZUxlUDd4UHk4dG5hSHhpOHlzdXpjMDBvRW00?=
 =?utf-8?B?M04wTk93MnFLSlJOV2xZR3Z0WmdoTzV0QzNLaHV3NnpYcTlWNGgvWElYZXhE?=
 =?utf-8?B?MXRBRlZNdlJRZEFKYkFEL0R4M3ZoT09qZ2ltVm5ScjJIRmtpbmwxU1FkMlpG?=
 =?utf-8?B?L2F1TndjYURaenVabUJOalpKWWVPN2IvK0g3V05kT3ZPWTdtVHdKVGJWOG8x?=
 =?utf-8?B?cjNJc29wcDRXbnFtOXlZMjJjZUU2QVl0WHlaSVlaQnkrOUpQWVBWdFBoWGFV?=
 =?utf-8?B?WmxUVEtKTjVnUWpsbEZzQU5zdVZpUXhXN1BvcTZCZFRQcDd3Qlh4ZTRTbVFE?=
 =?utf-8?B?RUcxRHhJQTk1MGhWdVRjTEVSaE5BM0pFTUJjSDdldCtvWG5xZXh1TXZ3YXVS?=
 =?utf-8?B?VEVaSkJDZmkwYmRzRnpJWnUrQlgxdmc1c2FHcURIRm92dCtEQVUzakdQTU5N?=
 =?utf-8?B?OGhIWG9ZWEJvQW9kMDJ2RzZScm94NWlRUnQ2UFhqK0FqMWMwRlUwK2ZwZ3Z0?=
 =?utf-8?B?Wnk4dW5JcVZDSHZNZEdpM1JZNFVCUWRSTmsyRUY2MFJ2WGQ0WVExdERuZ3Fu?=
 =?utf-8?B?MmlhRHR5Wlg2a05MV1dzT1U2Q29rampTVWQ0OXpkdjB3dDRlUDV5b09GdUZQ?=
 =?utf-8?B?RkJ4TFlwaEVMTGcvWGQvVzM1bWdyQTZBSmNCZGZsOFhSN2cxdHV4RkJJc1Fn?=
 =?utf-8?B?SG1reHpNdXlUUTFoZHhEUTZ1OXNMNE9SYUM5bndkclc4ejVQYklLTkpWMW9B?=
 =?utf-8?B?TG5seEpTeEpqRytubTU1Ym5JYzlUN2plM2RvRXpQa1NhN3VFVkJvbXRNdDBZ?=
 =?utf-8?B?T1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MwzolPZdlEyLgMJ3NYG3TsAQ3TpOBBmNUWbZyCW489vIi1HyswMww641GDNB2LLDXbE8G+hlOnxzmzUHWBmAstjYp6C5YGjxsKvVk8Gf7BxSoQnnbWLbPIJOvbi1crF1YvRx/N3KqBgPbBWtYQoevobCmGO/I+4TaPjGOyqZ+7++yaZCSNIkzRPdtl4vHFZ6T4FI6hgmE8NJwFfeWN3HLeS6231GlRdwC1rjXyanT0ulQqzmk1B8w4SchOerm3dFgXE9dWG9W4HxdQ3bDgkgkt9FCJy3zh0tSeiGBU7TQTecDox2q5PMe+9hiDvsM8NWI737RzjG/hVp8L582NdvjveyvBMLAN5SJFV0TVOJ3UKsvW4t4I7v4ZIqTcYoGaR38rMx2rHLZil3oJ04pS8iQMJWyE1PB0LVMVMiONfqLq3Rm/hqE0MLN3LCtLU/1mFV3yzMnN+mRS+ZTMbPsozzcjn0mXWPtGON5hA/an4hEclcWtDinkOnJCKaGgOXBCNr78PacLQvPWrlIBxcq5CNMi7W4OiEe9/Z5QF9VxnMwvWdtZog5DGdiAZVHWkz7zciyvivUdwxE5C/AperCGVKXF3gEeDXfFnh/BR0z9fZNnQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 316217ae-1a7c-4a22-bbd7-08ddc9bdeee0
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 07:52:56.1995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cQpD0pMbAVofNgHhtlAPdQILfgybSh6/T/ou6wnSqFYuF2EgrMIUom0Ql+ys/YnAj5Z42Xr/JpOOzFRnHBe4Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5172
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_01,2025-07-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507230065
X-Authority-Analysis: v=2.4 cv=WaYMa1hX c=1 sm=1 tr=0 ts=688094dc cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=yPCof4ZbAAAA:8 a=3UCxY4NukCG1yz1CnrcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: _cZsrZiqS5cQw8EpNjI4p7Io9qNoXiSY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDA2NSBTYWx0ZWRfX+QdGYcgL1eX1
 CxExIKs85NoD0dGuPJShAGsSwmfC9vdCgJsjrIuDur1nE9yYQ3UbsuhOU40bRrmQByYwBIJpenT
 512LEKrV55KSexPGbcD/6bXHQE525tdUDBjeAj87SEk+aaXP+6ymTSclBLK+K4hBurnJ/H6tGE2
 vyu3kmB7B8UJrOofiUvpySSDzsYQc23w3DUcFDGQMe1vhPuREAXKAlpcw0+/1+OI3r4fU4/f/rB
 UP5ky2n90/dN5NuES6Vcaoh8Kfrxbteq4rFxriWWLnKR8+jzRiju+GrBJ2wCGjm710EutQMjl14
 +jh6JAzlKtaM/6O1G3jucp9SmiBDp38qevDo8jjMMTiqOmNnM8CmLHAe/qwLqv7EdGGgSBsOOu+
 zaRsE8FWCOKxos1wDckap3Vk2iD1wj50D3QkyonH8nH+KrmdGmMzQJ9cl3SU+D4sDOm5RGnH
X-Proofpoint-ORIG-GUID: _cZsrZiqS5cQw8EpNjI4p7Io9qNoXiSY

On 23/07/2025 06:39, Damien Le Moal wrote:
> void sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q);
> +void sas_ata_end_eh(struct ata_port *ap);
> +
>   static inline void sas_ata_wait_eh(struct domain_device *dev)
>   {
>   	if (dev_is_sata(dev))
>   		ata_port_wait_eh(dev->sata_dev.ap);
>   }

this function stands out a bit now. Why make it inline?

> +
> +void sas_probe_sata(struct asd_sas_port *port);

Apart from comment, above, which is really a comment on an earlier patch:

Reviewed-by: John Garry <john.g.garry@oracle.com>

