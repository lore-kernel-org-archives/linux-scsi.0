Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D3A3C2BB9
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2026 06:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783492222; cv=fail; b=qoQ/1EiTQsUEHoKZSnY5e4ybPb8O+EEu3GYJnw2vv92y9eFv9BuQV2gsYuuNqwu0zjKnowrCZry+E/1/AFquRzkuMdVbY3lPP2Uu83fokcE9n6qSdrCdBcT2KpDUCwCH1F77xkBdfFZfh2Njtg4oAddEe2DyS4jY5IvnXYPz5Lk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783492222; c=relaxed/simple;
	bh=KWzTaQZNDsziq7gMN5GmHjNIMoKTNS2UaToMwcVOt/I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=o9ON3H1OuPMolFvHtNwb1IVvPCeQ/G2nRMuDS3TxxxyetpvbwPnjxHMbF9YTQ1O7D2wRs5F2S8P3kVSlJpuyBX8N9UB9Snflp0/R64MxyCMkvJjBj7GET8oXaVP9i6OG/0qpF5zKrC5ebTA3MhAjNRx1ravFjyQl/ekwKLjJgn0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qZvP7g4a; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qRQqnWKz; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qZvP7g4a";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qRQqnWKz"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 667JCD0K1636566;
	Wed, 8 Jul 2026 06:30:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4g99TPPTiZM6xJU7/TT2Iq928hsewUd2LenRyqx5FZ8=; b=
	qZvP7g4a90IMCEXTMvkrAtmQh8DLr+95JSqYuZXZtIWy/BkdsfCWBZKGWEybSM0J
	Nfyup3mkn274hsRGKMxC7T7oZHtYI0oCe/Zxdrua748RUsNVZH7x4fGbPem2R37l
	WnhfxtqaIXFdBPOJohnfFPCHIb5LM/Q/7wJwyW0xEaqMacylRkilwSsEKsrbifAH
	x2r4rJPJ8+vygXzl9XrpXkoLkea4RPUOXSzTE5UTQK6H3und8lq2Q2wlreZmMd0O
	x5P+yglA/jeSNqyR3LV2zwWAOcLqP6x4LHQvw0XmvbkYprN++qPX6tCIqB56HQEI
	f/hTnMmO8n9zKTm2atVSaA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6t7cq0jr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Jul 2026 06:30:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6686S7GT014709;
	Wed, 8 Jul 2026 06:30:00 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010056.outbound.protection.outlook.com [52.101.85.56])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f6twjxywr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Jul 2026 06:30:00 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=brBo9yI9L103wa4PlZffkmwcgsG9XDO0p42/LpyEbvkwVb4WC6V68uT1gzms1Tu7r1nJwEytpvX2dZLJTn9KFtrhaOIKgN6CffIdRl5//X2r1louRnA/ZlRg6GeQERtgUgF9CjWshcJoHX2kx3jvZgV7NpKtzdF0wP29xYjCJLhLGvos3jtWPh33vsqEYPEuJ3wXbRfntGthbHeAoVZaPuoCWSyvV/nLS8sdwupjql9r9lbSkdHIcMFoFhDu4CLEpVG7kRv1wW6IuZ6lcPFhnueCpqdNwLV2UYySKn+eg64kI4UQsZoJ9u1rsMyudfgnb+D5IaCtz960eRT/5XiJoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4g99TPPTiZM6xJU7/TT2Iq928hsewUd2LenRyqx5FZ8=;
 b=YWeAj+vtegZ2qrGKq1dPfpKtfz7plap2lGDHhQvhg9HnFUVZS4bVq69sKM9pKqxtDPRzRI0MYozUT2bEl4KRc/35HzFXRjhGkSuGWLWvPZwlQxvD5OXELhmZTq0AmULdpRQ/HvIi2upddInioiuwS5Ufo0YerZsj6+KwTWFmXIgtHMIMy8e+ZCHkdEQB4XorOToEQz/erl7svtRbdYXYXCfoMjqndQFEwRZHDUXVYMs5mqvvgnX/qMJ8UVW4JuPEZUTEpKwHTCaXG/+3JODpyuhQNehpwjaDy+KKETOvIbrGaSGuJMcgmMMY0A6mdYiBZCCvrgP9zgymbtyIeu3sKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4g99TPPTiZM6xJU7/TT2Iq928hsewUd2LenRyqx5FZ8=;
 b=qRQqnWKzoMax2OKddPgJFmEX2+8ZZ7RPW+gryDqlanI8LF1EO80EFn9tT6vBTX0X6r45RB5NxaJzDWNsc7CnFc25a3eoLDGW+L+KMRhEdqknYMApOJEIXclCRK3fUoaeVurXQvbHp7u7JNPcNH24LMPndD9GqURIGK6785I6fzE=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH3PPF1D715CB68.namprd10.prod.outlook.com (2603:10b6:518:1::78d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.14; Wed, 8 Jul
 2026 06:29:50 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Wed, 8 Jul 2026
 06:29:42 +0000
Message-ID: <26757492-f9e0-49bf-bc77-4a6f3ae64276@oracle.com>
Date: Wed, 8 Jul 2026 07:29:38 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] scsi: sd: fix error handling in sd_probe() after
 large pool creation failure
To: Yang Xiuwei <yangxiuwei@kylinos.cn>, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: dlemoal@kernel.org, linux-scsi@vger.kernel.org
References: <20260707030333.22245-1-yangxiuwei@kylinos.cn>
 <20260707030333.22245-2-yangxiuwei@kylinos.cn>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260707030333.22245-2-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P123CA0019.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::15) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH3PPF1D715CB68:EE_
X-MS-Office365-Filtering-Correlation-Id: bb367d66-d066-4f29-3d19-08dedcba4b79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|56012099006|18002099003|22082099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	JKzwyzuEVyeNKxJeWYySIkc7Fyctd7XyqCmDVHkrYLN3TgLWs8nHKWXh5Q0sbLoC105u5cdolMtw7i7P8LlzZPF3kVessPHFue81RgEUnIi+1jpKaSr2734DA3AhxaWcG0q4lEnfwB3Y/SAEbivT2ki2VxQUjsaGsBn8wFN/ce+EbNgNGvhBd7HqJYQKrWUCJxf58GmxCmW1Qpu+KEBLdb6WWc/0R3J8u3IUydQFVXblqTW65DFaKoF1lY6nvQRsmyVba32dzBU7HzS7CjP2T8ojNAl+M4Pl4l5ksvqNEGXMAPEWxouCbWfqq/KLjLn5al8EutS/db1fPxp1LUJCexCc2U+5bMoxo893EmNsdAp2G6UuaDxMDFZc4lL2FeZlDXK5UXj3uqL0tcTrl6LUobOFMk7tOStKxxk8EisemnTKWdLYSqa0Y54oBA9yqskTujLnvUTjyZr5ias+VLvL0v/HEmoav8mzWYxYaSICl5GYUAcAe+4Ppe9kIWkO/IqtB8A1fwdok2cUZw7/aAQclKzTqyW3mdPb9UMjYqGxYKgxUwRzfq76Xbbr5m1HPfRgA7/BXWK/09pnwnOSgsKeLB/EfwpIEqLYFWkRql9CyYB4b5iUwX1+MY7Fv53BLY3+YbYLQ+IrITLigm2R8C2ooAw9eOpSr5/4/eSnPuenY7E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(56012099006)(18002099003)(22082099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U2VuVGIvZHhNSThtSWZFU0R5WTVyc0dCZ1dxZWs0RVdQd2VqOUM1MUk2dXVm?=
 =?utf-8?B?QUdoR1VCVE1YZStucktHcm9MU0d0NlhjN2MwNjltQlRML0duR2tJZFZtTFZH?=
 =?utf-8?B?ODIvR0MxVnNzOEpsYXVCWlY5a3lXeUd2VUpFRUp0OHlUbm52OTNaK1dJRVVa?=
 =?utf-8?B?ZEVQTEZScitsUjNGbDJQb0plRmFWYlhYSDZNWVpjRzNwd0dlQThvaHQvUWVs?=
 =?utf-8?B?clE2c28wS1VHeCtMMm5qN08wZXJ3RUhoeXJHTXdzYWNRaHhSMks5eTZvby9P?=
 =?utf-8?B?clUwdUcxR2lNZ2U0YUpablJGa1hYWHMyaG0rSkJISkZ5NldGNDRFcFpnRS9E?=
 =?utf-8?B?S3gyZGRGQ2dWdGl1K1o2VzUydS8ybDBuMCtxNEtJUXVVMko5MnlORCszc3hk?=
 =?utf-8?B?SjV1M1pPWk96Z0dVS2RpdXdqemVUNDdjaGdmd0RLRUFCclFuZWdIM0dHSGN6?=
 =?utf-8?B?bkh5NDUrQi9sOVlVMVFkN2k3VGhPRnVvMTNyV3lEQmFnK3JLK2NYTTgyMGNj?=
 =?utf-8?B?ZysxQmdjMlVTYzRudVd1eFRlWWdGeVp0OC9ac0U5QUQvSmUvMFJhRkZpakRF?=
 =?utf-8?B?WTV0ZHFOcytvMU1DVXNaY2x1RTMrYVNUT0pvL1ZpRERUbmQ1SVBEamdjWW9Z?=
 =?utf-8?B?WFdCUlhxUWZ2bk9BSjZvZk1ON1ZqQzAzdmNObGYxR0ppSjRrWUF4NUc2S0Zx?=
 =?utf-8?B?WXU1aVRGaUlIQWVKQ2pMMnV3UllpaWR2WVFFdkxqcFdIYlQzaExnRDJ0QVhG?=
 =?utf-8?B?WVZHK3lWM3h2RTZIR1RNeU9NWE9ZcFgvSXdJUkN4WTJGTDJkRjA0Vmw0aVRs?=
 =?utf-8?B?SDB0bmI1alEvS3RGckZTdGF1WXNScEhpRzlMR1BTSU0wa3Yvd2JIUGh3Y1Q3?=
 =?utf-8?B?OE5nTnFBc1doYmlSaDdyZHB6WndOdDBzS25BcHpobGtGNXlaQlJPbXpvQlgr?=
 =?utf-8?B?dDlYbDNENFREWC9Obk4yY2pyK3V2eVBqTStuVDY3cnJFK09zUkxpc1N2Yy8z?=
 =?utf-8?B?Y2ozYzFnZzRkZEYxZjhTc0E2aHZFYVNxU0lvVWpOeTErTmp3SDBldTBJS1Bq?=
 =?utf-8?B?WVVDTnpRNWkzeFJlR3NiUGZ4d2RSTUllT1l5S05sWmFEL2N5SDVnczVybWdV?=
 =?utf-8?B?NWxjcmZwbUxUNnN2R003NnltampnbXVZYjA0TUMzZjAwSjJYY29UMjhIVnk4?=
 =?utf-8?B?RXNwYlQ2ZTB5b0N3K3JKb09aaWdGR0ZUaC9jRVZraHdRL040M091N1pFQXdx?=
 =?utf-8?B?M1Q4b0RZaS9yZ2l6TWJvWDY0KzhJUGxIZGtaWVNXVnpONmEyanBkV1VjM2No?=
 =?utf-8?B?UTFOTFhGVnZXRy9TUFBZMlFWVXZxZHdUdUNDL1ErSC9FVmt2YU15eExBUkxS?=
 =?utf-8?B?aDQ3RDVMQytHZTZUSWNNdzgvVVRnVUgwamxHQkRUZmJGck1BbUlYNkNZMU03?=
 =?utf-8?B?L1cyaGJRc0hZUzEvVUIwcUJXWk5sZVNpZURIK3RRZWFhL3RIZVdXM1pvT3FN?=
 =?utf-8?B?RExZTW52TC9KY1J0NVZrZ2hTVVBsTjZ3d3ZUU2J1djRRODVGTDM4ZG9FSDZF?=
 =?utf-8?B?M3hMVkxVdk5SMkpFUTJuQm1uemMyYWVnNWx4WmdKQjR0UjIycm1JNWdlZmE4?=
 =?utf-8?B?bVJWa1BUM0VETlBTMFREdXJXelZPS2R0T3lXS0VKREpFM0I0UjFBcU9JU0l5?=
 =?utf-8?B?Ykt1cTVGMTNwRFVyT1BFNEFvNlhpbHE4SzduZDg4cU1ocS8vMTVRelFqaTlq?=
 =?utf-8?B?bkIzb1RkY0RyUDRsdDZNUEZIWW1QZGUydzZJaTN6ZENXRUt3c0VIdlkwWjVZ?=
 =?utf-8?B?d2ZYTWhnK0lUWlVWZ0FSSEFBQnF3RWIxQUY3TG5uNzhjZ3Uza2hQYVdGTnE5?=
 =?utf-8?B?YktMWG1GbjY1emUxOU9hM0JQeFJxSDd4TFhzMXRqZzRLZktNb2lmbG9sbmFQ?=
 =?utf-8?B?YnkyOGtjR0VHeVIyNDVURUg1VFowdWxIdStxWnpRdm1hSjVmbCtOc1FHZDcy?=
 =?utf-8?B?OXNDNEpTdjZ0YVpFaCthUWdlVE94djhNdmNvVWlZYldFbnE0d3JQMUVJU0cx?=
 =?utf-8?B?QTJEOGRTM0dKT1ZqVGtkTzBOZEJQK1ArTTNGMDRySXMrcGp3TWJVNXFaeDFI?=
 =?utf-8?B?THY5VkZkMmpGaGZuVEZ5dmNqaGlzT2tJRm1zd3dkUi9ta0ZYcDEvZGhSVUZB?=
 =?utf-8?B?b0NITi9iU2ZadXlGN0hBSzVka1Q4ek5oaDVBdnVscXFnb0lJcm9PQWZDMlVa?=
 =?utf-8?B?UGlFcGk3djljQyt4a1hVVExYbGMvVFBZaHlWa3p1RzIzcmV3K2h3RHJYRG9s?=
 =?utf-8?B?cUtSbk90K0FYanlDOHc3amtvNmg5dGtvaUtmQjI5d00yN2ptQTd1QT09?=
X-Exchange-RoutingPolicyChecked:
	Ur4qlYHUpp3/fz2udbAjGYq7mmpvJ6ri+udOSh5Ap9zt8p6FEaD5eKCb/oICFhpHwOeselKVRKcgqygq+jgDGmZTR20rfqzOBYTfnU1fE+eJuQQSpqJTyfWSyOqIFtlCvVr5tzMDvRJBj8idFn8Bo9d9ceeKZiQEJP3Z//l2KXRbHqjD6+Tq28AGCTd8om4QHWvGLvcD3nTSan5vCqKEv6loKCyq0mrZbEFUWQ+vxFGVF6mpUGRXk0RW///6V0L3puAQRzz0N/86UVX/R9Ow9oHQ5ob10sxCIds0GmY1AaTbxKJDwR8t4j4yEiPpSvuYxVXyvdOkE0B0UlEN5Zzhqg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0R5PvckvfMuIV4stDS8P7lx8O3YGHWWHm9of/zavU9nKxWmfPpJSnYREPdOYHOxoZikVkhNrnN9Tr2JmwKCdte+sdM6qwpWrQvC28ah2BvJNeMpN9jVkYg5rukrYa1YARJE14OiJIku1G6w5xaNNjUmqdYzi4E418iw8YWc9meq803e7nxUJYDpOHb+Rfhg0uzAVUf4Z9Ffcuf1Y8Qt7ROJi26mqYzvitzZI5AEAWiMYbZEx4dfvDdgpZaNph8UyDIJOVAgg0/Qd6S4ecxlnp6NmAKcUC7ZUM96faHQnaN3yZ2bQQwvnHnvpybqRwWj0FsGQj5QOhFLXVRWl3kmIU9GiKJ29ci//yotcu4hEW0QWHgcwrgELbw/7P8tgjr0Ycl0bHTFEkctOlfr4OUgsp9FvuSV2CHy/xEHbrKye2djs6UWkC2+vSLM97XCkDOonyZ3Yfe+rdZFuy8y18jpeee8RyH1DgA6rpNrCgZm8PDY3/9IoAlWTbt/kQWSAqVw3iIjFYuhNaAneTuMZvS7ghjn+lW46ii70tW8jTs6EZYUEtjHrr8jjpI24gyHN9TA/ySB9WGtZmD9VOz7/eKrazNhgim5ZapP7kdVLiiG8Nc8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb367d66-d066-4f29-3d19-08dedcba4b79
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 06:29:42.4064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Ln95O0+P2eYrNNDpAx38wKbtu6FTlKr4ZLECnRfXwhk33qxreQJjsdboQh6BUAmM1UYIqjWjNMJEJ85FDLLLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF1D715CB68
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 adultscore=0 suspectscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607080060
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA1OSBTYWx0ZWRfXxBx5oUwvzTr1
 e5RNdkJpb0nM8c0ZhwE67PN5i9IcFxjsIkJ1uPPxPgRyQ/sAFT/+1qcmPJrhHU1drhMe0LZbTEO
 i9G117tPrNT6qlhDlWQhaL1M5MfWb3rPir/iZstwGHEWnHQCCGxHdf/qq6T78UTehSa6FqOzzQv
 c1TEMZtiQaxe56yV9Kli4rffmDndhFUYg/kAGAKyW1pkPvmOiFNmrmZejvR0U2fC8ZbB6wVh7LI
 nxPkf27lBtVhXGmouDgiD0KSs7OrwEu7bfg6rZp+fJFFfbT815/UtVJm2SAvSQvBBEaRtAlDEvd
 FSeK0/wEPwUCnH5+5iyxMHjH/OLooKpdji0bnOWzyGEHLAVC5W/p2+Fpzg91AR4WZBuq4WXacvZ
 ICQFKrHP/xJdIoNsPYNBNOt2F9hCGZqvSPuytzoio4DEfk6TcJ6euhDk6yqpGeMD3ZDuGiGdhiy
 LrVpmr4puc8Q/FTDPwA==
X-Authority-Analysis: v=2.4 cv=P+QKQCAu c=1 sm=1 tr=0 ts=6a4dee69 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=KTYrAC8X6tAVWB8hNSQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 2_oQFV-jpwm3q45-2TcDJW1gfW1WCruF
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA1OSBTYWx0ZWRfX5PIBz++hRAQn
 nkop8wfqkniTKXfdTI0G4njrB95AO/XU8HyPoQxwjWoDIZy+3jiH2K+i7zhd1YK8t43RVRRM1JD
 v8axMee3WaSOaW6iStvLSIsjKOJgchR6P1U0P2KJYMKPtKhnWDLI
X-Proofpoint-ORIG-GUID: 2_oQFV-jpwm3q45-2TcDJW1gfW1WCruF

On 07/07/2026 04:03, Yang Xiuwei wrote:
> After device_add(&sdkp->disk_dev) succeeds, sd_large_pool_create()
> failure must unregister disk_dev and let scsi_disk_release() free
> sdkp. Going through out_free_index kfree()s an already registered
> device and leaks the sysfs entry.
> 
> Fixes: 7179e626b76e ("scsi: sd: Enable sector size > PAGE_SIZE in SCSI sd driver")
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

This is the same as I sent:

Reviewed-by: John Garry <john.g.garry@oracle.com>

However, would it be simpler to always create this pool for LBS enabled 
(and not just when we probe some disk which has sector size > PAGE_SIZE)?

We only get LBS when we have THP, so not always. And we would waste 2x 
64K pages. But at least the code would be simpler.

On another topic, sd_large_page_pool_users does not need to be atomic as 
it is always read/written under the mutex (so can be a regular int).


> Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
> ---
>   drivers/scsi/sd.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 599e75f33334..d18693d390b2 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -4089,7 +4089,9 @@ static int sd_probe(struct scsi_device *sdp)
>   	if (sdp->sector_size > PAGE_SIZE) {
>   		if (sd_large_pool_create()) {
>   			error = -ENOMEM;
> -			goto out_free_index;
> +			device_unregister(&sdkp->disk_dev);
> +			put_disk(gd);
> +			goto out;
>   		}
>   	}
>   

