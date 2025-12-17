Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E8B350D78
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2025 12:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765975715; cv=fail; b=H+QxrGBg4CdeSudLSvJlxrQ2bZvEyAe1om7klBh8wG2uiWD/Jrsc5gVpYFYqyl4BqHmojjxLrlWfBJ8b6CqgR6YjYOxYiaTvnr7xfv+sRYLRInF2MaKeAvu4JQpgEH71k5j4GK1PxX50/0X3s3Xm3aJ529K+wfD94IgislUuhLY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765975715; c=relaxed/simple;
	bh=2yWwsueSBnHy4RhoR7Vy0q4lEiCKU9++65qh8FkbGOY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U2KFB3/SsaEKglBPn7WElSYnEyqEde+kSOUIM3aht+IPzbTQOZTzH20rowm5VAcRacgNaPG2bTPHOsXzQSeYqo/isRqWpfS+T+ZKtmigiFlxSFweV9NXkZTcHFYCbQ8EGiRIuiaZPIwjsNDciIYelwlkoyzqunvUHJZb97J1J9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=knia8Gso; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dvqrcymV; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="knia8Gso";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dvqrcymV"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BH6Ndfj2183653;
	Wed, 17 Dec 2025 12:48:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=sDqKMtSCM3qzYRjueQ/QIxhIegEJeW07GXZ+gR7OUg0=; b=
	knia8GsoQ53dsprE95ELJawNrWT5e0Dug8xVscXXzXYcqGzc4eFrsaIsjG8kLDxe
	LdLulRBmqC+hMNMZcpH+zQvHtU18Q14KkOUkHmVPI5GhH00MgnlOH/BCwW8HKNna
	GnMUJNQ3LEmkrPDCqqwdvWHibvpL8CMBbD9u0ukLmypohap2e+0Uev8hyb+FUFZs
	8+t+nq+s8mAYAsSBjcaXR4Fc7FSFHN2BxzBW9I3XDyP9hQL5aSIFh/eIs+2+szJm
	Pnx+OdgMjsKG+ZSo5TaIAuHx/SWHYmBuk96oeBfERBw88joXh9IoMdUlC+LqmKtM
	6KB6VVOEXORSY0IdG87yoQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b1015wsrt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 12:48:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BHBFTMJ024514;
	Wed, 17 Dec 2025 12:48:20 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012068.outbound.protection.outlook.com [52.101.53.68])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkbqtm8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 12:48:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rVaGD7IYXhWT7KlabkuPUmmAcZoYoM6OP+v8+VNa/OsAAlN80+A2+GzJyORi6W4MqQ+PSFKcGZA3SykbplHJ3VclIOXCjNsX23jzKAMquetv0Pb55M7k1Hv+pgVa/I8ie4hJj0PjjK3tTCskQSFvvb+nWdaalfRN8+gorZ0yWuuLFPm/fbbiP1h/TgwYqOc66x/Df24ViZ6TOHV8NR84J1j+G3N9BmjNKo8aEbBSxP3HJZ4Jqk9WtLZMWZ+5RqWOjL0axTjxdD2ZzUudOQ7Dy90GRjzNIIPOnZPnfpbORSsYkaOezkdBN/VmmeKFenL5DxpapubPtUL5Ayh7vgW1uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sDqKMtSCM3qzYRjueQ/QIxhIegEJeW07GXZ+gR7OUg0=;
 b=B0D3ylFZG2mguDNHYpsgaN3zZy7iQ8pPXdYQQAQ79BRv+AMz4/yZTerRQDcN+rWJeW4O+kNFb8i4xmOvxlmEoA3ubiLci1PZuZpT7lcatSJy1aFuf4M37KFsk40sHEFgPjJnNqUa2C3rPtKFGJGMJbsbOgkqMnS49scGjbfJSTiFwdQSkdUICM0hPp2IrzCkjWp0kPkuGOP5JYp3DE0XvnyahZuy7puQA22QpKwKkur8df3IzJdy5OCmyZ7ScGBPdW/7ofFzdKiP/EQpCxlAlkW8O05fZJo8xgBwatxD5ZYt0rDx9OXe7i0OuRJPLnJ1AI8IJ99fUx1sq0dKO5Pd6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sDqKMtSCM3qzYRjueQ/QIxhIegEJeW07GXZ+gR7OUg0=;
 b=dvqrcymVzkFm7o2EmjZ7laMqA40uO1Tj5vab8sKenbCpRbGg0NM3v028q4qF69I+7ZElgx61uluBkSjQXIyiF75cr9Qo6sUF8qeGyeVSuMlZIV7n+30X7kiVb4H3gRkx2DYvPBcPIlsXFjg6KDL+A1q0Z2jmJ9uJC6Qd33kz7kc=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH0PR10MB997593.namprd10.prod.outlook.com
 (2603:10b6:510:385::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 12:48:12 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861%8]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 12:48:12 +0000
Message-ID: <53fcb929-2f19-4702-80f1-1aa059b308fb@oracle.com>
Date: Wed, 17 Dec 2025 12:48:09 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFT 0/6] scsi_debug: fake timeout handling improvements
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        bvanassche@acm.org, jiangjianjun3@huawei.com
References: <20251113133645.2898748-1-john.g.garry@oracle.com>
 <28ec2d8d-0da4-4ca9-9a8b-3c2c42d6de9c@oracle.com>
 <yq1h5tp6cxu.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <yq1h5tp6cxu.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0219.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::17) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH0PR10MB997593:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ece4d4c-939b-4cb7-134f-08de3d6a898c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cW5UeTk1RnpBOElOMU5yR2ZwY3BhN0xySUNjZ2pzaGtoOWMrN1BwSjQ2c0xU?=
 =?utf-8?B?RGZURXlvSUNlUkZyZy8wc0lYckNNNVJTaDBvdUJSNktxdFRWM2U0QlkrZDhT?=
 =?utf-8?B?S2Q3Z0ZJampEblRGU1pTZWNPRWxCQnJMRlh3QjhkMDdKQlhUTEc0ZU1iRFZZ?=
 =?utf-8?B?dWZRb0w2NERsTEFjTWRscWRPUjQrcGl5T0ZDY00wZ2h4OXNqQkdMOTJjSklu?=
 =?utf-8?B?a1BTMGRDU1BUbnJnN3pJRVdyVjBUWVcvSDhYa2haSmxYWUFmL243Vy9ROVEw?=
 =?utf-8?B?dnpCaHU2bEVidWwxTXBqcnArREN4aG1MZmJtbUZ0MjNYTmJRZVNMUmFrc0R6?=
 =?utf-8?B?bHVpU1JUYjVUYW8rR1luRlloekVUQ3lVTUpPV1VrNWc0U2Jkak5zbTV6eWZq?=
 =?utf-8?B?bXFZTnpBSDhhTXJUWWZ4Ti8zUndDUWhFaW1WK2VYOHJmZXpFYUdjU3pZNUhV?=
 =?utf-8?B?TGJYSS9zWFJsSExoOEJtVHh2STBieklNYjNEa3l0Qk5SVXcvUlRlNVZwMDl3?=
 =?utf-8?B?WnFyMTUvNTBncjF5M0dYeTFFeEY0U3ZlTEdUazFvSk5Nc3pNblRTajRMSS9O?=
 =?utf-8?B?TFVFWTExaHNnWnBXZEszNkozTW9KT0dYcjh5OFdIdHlmOFdkUUZubFBFNTJV?=
 =?utf-8?B?b1JISEJsTUlRUzAxN1BsejRnVVpWYjdrVlE4TFhWTjRTVXVMOVBPUFM4ck1T?=
 =?utf-8?B?TnU1V244MXNUVS9DZ2tmMk1uZVFrZEs3MFhBT25keTRsUXpjK3J0dytBNUxG?=
 =?utf-8?B?UXg5SkFsZTUwN2pPSlVibjFPSmtmSnB4SjR2VisvWFJDdXM0QnJtY05WaFFZ?=
 =?utf-8?B?Qy9CVTZNV0dFL245ZDRIZWlENUg3OFExL3N2b1lIYXY5U2NwVGVUNXJxemVv?=
 =?utf-8?B?dnhPWjdmMHl1Uk0zRCtLTEx5VkNwbVQrcEo1UngzNlNrbGZrblJDcUdQRGZC?=
 =?utf-8?B?cTA0MlR4dlVxT1pZK2hOQUFNYUYxOFgwdEpybVh5RDBJcWdkcVhFd3pXSDgr?=
 =?utf-8?B?NHpEWURhUlBydWJmYVFxK2ZyemlpYUdyOWVpbURHNlhmUDNuWStERmtDY2t2?=
 =?utf-8?B?WFBseDU4dEJJZk9saWo4SHhOOWtnUlpTMkJoOE9NYncycVU4bG1OYkNZYUxT?=
 =?utf-8?B?T25UQTJhbDUzMzNpYnJpci9JTTJiS0k5TXo2Y0tINnY4R0lPZ2R4b253c3N4?=
 =?utf-8?B?WTBMQXpzTWtESHV4eHpmRStUT0JDMEloUDZxdnhoNngwTnJLdE16UUhhaGtC?=
 =?utf-8?B?cEVkUXBTYTJjdFAya1FSd0hhSlVvK05xYmVNa1VocWhtSXhFczNQWjdHOGFL?=
 =?utf-8?B?S1M2eGxRZjNnSm5ZbEEzeWM5emNUMGxlV2pPV1pKR0lNazdhc0Q2UTFIeXRI?=
 =?utf-8?B?VEVQTVoyenJYUjk2SWtoVmEwQ00zKzN4YWxDQ01WamYrcCtuSXdNKzYyZkdt?=
 =?utf-8?B?MGRvaDZvcllhV0xEQ0hOZHhsYUEwdUttSGp6NVA3Szhlb0wyMFEvc01tRVZ0?=
 =?utf-8?B?VkJwMHlHYVVNRHU2Ynl4TUl1d2Nja1ljcHRtdnN0RC9lVDNnN1lrUlREaGda?=
 =?utf-8?B?NnpEU0dLRERGVkYrRmZJaVcrVGIxUG1zNlBIMWxObkVQeVNxU2E3bC95TlU4?=
 =?utf-8?B?TnhOSERDNDJuRTJrYXErbFJHL3IxNWEweVFhVHcvcnI5NTgyK2NkV0dZRWRJ?=
 =?utf-8?B?dGVIR1pqWWRDOE9FdFFSZG1zVmNwWEkveXZScDJDVWExakRaSUdqd2RBM0RC?=
 =?utf-8?B?dUY3RVo0RlNjbVBWcTdFN2ExeFBkeGxPbWwxYmpjK28wdHRCU0tvVmFFZ0Nn?=
 =?utf-8?B?Q1YyQUVvcVRCOTR4M0VNKzd5cHIwYWd3RWtLRU5zSXArcDEvNTlIQkpIZS9E?=
 =?utf-8?B?OUVxaU9FeUVhMXg4WmgvcGtCc3MxV2FxemRtbnhzUFV3dDNKbjN2N2xBY2Vr?=
 =?utf-8?Q?DTrEQ4IlkLvbDUgHm50pjfyh0TJQk3M/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bFhxaEFmUVEyMTdzQndSekVHK2dBdmVDaE03R01iR2ltUE4vQzM3RXpYb0xT?=
 =?utf-8?B?bFlIUXFLSVIxMWhCUmZ5Z2pyNzJiaGZVNmEyQ3VUd1RBdmdqcCtIc2orcFlF?=
 =?utf-8?B?WVI4anFXZFZQc0tRSXFGVFZkNWNuRVVNeWZLakt4aFAxSTc3bEZvTk9JaUNC?=
 =?utf-8?B?OUtpbDdKcmptUEEyVWpHV3pOdzlQejk3dnNkNit0TzZoeHFHWVNmTUR0UlBS?=
 =?utf-8?B?SmUyY3NqamcvOG9zYis5anFwRXZRTHZOVENhbGtYM3F5V1BremIyOUdRL2do?=
 =?utf-8?B?Y28xcWlCZU1GbEVBQzQ0aVRUQTZOays0WlRIUFBvTjF6VFNlZHB3QVRvRFZH?=
 =?utf-8?B?ZHZLYmh0WktySElZUUZwQzNScC9vUTFKcjhSaGtZc0xzT3R6WjhwSFhqYnJT?=
 =?utf-8?B?S3EyYVlsN01zcnpYa2YxSm5YUktlM21LYVJJOWhvWHZEa2VjWmxjMzBoV09l?=
 =?utf-8?B?OXBkUmtmcHZzMWIvTFd6cThMendDeXlkL1M2WVRqNGw2dnAvT09WNUtJVGRB?=
 =?utf-8?B?MGk0TWt1SWRKcG02QUQvaDg5NE9ZR0xUV2ZWWW82dzNFOWd4MnF2WjNyY2Nz?=
 =?utf-8?B?VTlyeVRnZnhyWm1wL1l3ejZ6cnl0RW9QUGF5UFJFbERDcmRLd0dHbHBJZ3Rp?=
 =?utf-8?B?ZUpBSEo4Y3cyVEo2aDZONnpwUnFvZkUrWjZ6a3VjN1JxckkvSkFVbGNsNmN1?=
 =?utf-8?B?UTVsWVJSUm1rMS9hdXNpaDNsUVNsTHpaVkcxMm43emJXZEZ6d2NUVm1rbzJh?=
 =?utf-8?B?MUlSbk5DMURteGV3RlJZdDNGVDZMS2kxdW5Vam5XNGtNQ2lvSzVpd1YrR3Uy?=
 =?utf-8?B?THdieldxUHduUmdBNFlFTEZoaEVOYTFjTGlwNVc2RE9acU43OXVudWxPVXNi?=
 =?utf-8?B?Tlh5UkZqSlpHMlFIMVMvRG5hb2J3bjFoZkd2WEY2ZUZMZGRIR0VyQ1Rjbkw0?=
 =?utf-8?B?ZXBHS2dJQVh5UjRudFZwbk9PRFVmeWNDcnpiajBiZm4rdWRRcmU2NXQya0pC?=
 =?utf-8?B?OEI2YUJvemNWQ2lmZW5NcFkxSkozK1FDVVE4Q1NKdnQwaDlHSjE2UWFuclNZ?=
 =?utf-8?B?NWpKZFBTTDMzQ2VUOEc1Mnhmdm1xNXd2RXRpNnJJMkFmRXB4aVBKOGpOK0JC?=
 =?utf-8?B?ZWpsTmhkQ1NpL0VKOVRGa0xCVUk0WXE2R0tKYnJ1eE5YdS80b1MxdjVPL2U4?=
 =?utf-8?B?ZUhxcHkwVFJkaFVnVTJBNkxsVVVHRDF3S2N5dlh3OEJQT2JwbFdKWjMwdmNF?=
 =?utf-8?B?bXZGWndBeVBMeHNadzRpMzRjS0VFUmdqN0Y4aFQyTXhiSkRDSkRVMGFHZDZn?=
 =?utf-8?B?bm5kTVE3M1BZSXRBMHh1RjhWbWxhZ1V3NEZQUkRRbzdEOVNWTGRlbU82S1RW?=
 =?utf-8?B?TDNrVGNNbDRSV0JHcUh1NFoxMHQyMkdJTi9XSFVkZ2pualpwL3hNbEMyWTFN?=
 =?utf-8?B?czZuS3NGWkVZOHRpb1ordDRIVWNFSmZ2b21OWDFYRGZCRU9KOXl2ZGV3L3hR?=
 =?utf-8?B?dUxpOUQvS2ZFVGJOMmtqalVBSXc4cCtOcFNpVHNyUWxVSnJSZEdqSnJQbExO?=
 =?utf-8?B?R2pFV0VzWUg2VGpuUGdNUHM0NnIraGk5L04zRCt2VDEwSGlPVWlybFNyczln?=
 =?utf-8?B?QmdPL0RTb0FNbDgwS1h3YUFDRDc1VTB4YXpGdFMyVzdIQ1J5VUtmdzZwaEJD?=
 =?utf-8?B?T29HaGZubTVsOVFCWWRucTRoeHA1TlVtNDdPK29mZGljVVRvbC9vNzJycFhP?=
 =?utf-8?B?YzFIdGV3aGVLWXRyZUZDM3RHNTdCcnlkbEdTenVJVTF6RkY5eGhwS3ljSk9h?=
 =?utf-8?B?MDMzSFU2SVY5VWM5YkhEMm5yNjhSNWV6aXozRkpWUjB6TlZyM0tTWDBzajBC?=
 =?utf-8?B?aTlYNU9SbXNyVEpBaERtTjIzSDQ0VHBYZG1pV0x5Zm5UMjN2UUFCdE80R1lM?=
 =?utf-8?B?ZDRXRHJOSEV6TmQwSzZmZDBvdzhZUGJkL012d2NRY3diZVlXOVo3alQ0T3dZ?=
 =?utf-8?B?TVlKdURQQW4rL2drSS9FQll3MnhJdTBFd0RXSXhRSk9yT1VEN25IalU3cFhQ?=
 =?utf-8?B?V3JpRVEySFhvRTU4SlkyRkRVZmRaajlFbDZZSzRQUHZqT3pXdXEweTdScnRa?=
 =?utf-8?B?WHdXa0pyM3YrS052S1BuZ1J0My81YVNYY2xscWMzbWs2Y3IrRUVpWkUxQ3dC?=
 =?utf-8?B?SXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	B1Ru8Tm6hd1lTjJNAlbqq+f1Z2ertFsKa3XLHvxSXczWpx74u0EgaI2bdkSNBdzdIG384FJ3FF3V88C2aVOSTltwqbnh1n8rtJe0H+FbP6AfYrLTOtLIVAPD2elebQfHaF5OShLJg68JWSxSO1mQmTOwAWKKc7lOJVmeF49kBKk0cyHcPKLIGG2Vpy8Q4RzrMiVUtFNDrtLxm3OyzWk2ZYYtWB3lO60/jyXePDH97u5dXdQgAelhDzcR6wN+bEl2PmeGWMm8IMkfuoTueYfqnRjdD2evxdSPA/ctQJxGdGqc4HCyaGwy7tfbTgC6dF1C+XQ1X2889cGxde6aEdoeOs5pDTLtYQzGanA+qMBMz8WRgQJEH5JKHacWziCG752dtyum0Wn1+AEX7tL8DRuqiOTZ761GjK1GlEcEOp+YNaOI3yOCkqoI9nZka17Doh0Lkxt9r8TFAdiK+qOjM9s5xXcTvHrVTZvtlU4h34D7oDj6AhS+qQsEgkFm7yUVpu7f82K+QASfed+JlW9x1btjxZkmG2Ub1qSH+MfRlI9gO65g2dV0sNhIdv/PLEPd1kWxU+EypE4E6dPfcFKhtQ8GtHbfqhTnpTlCYHFZYAUB+pU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ece4d4c-939b-4cb7-134f-08de3d6a898c
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 12:48:12.3442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YzkQjoFHUCo96/nRkrUccrURTEg3pHa75aHxeGipJV0ag48Nt8TESjBlO7CxLrNcxIpjpEvMXcyJIFs8SZHkWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB997593
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-17_01,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170099
X-Proofpoint-GUID: mDeatSlkqUrrR669-7o9XwVPEO4aYnbj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDA5OCBTYWx0ZWRfX4RrYdLDmpqI4
 xBGILhJINUGP9J5VJWHHeKY/Qhe/u14y32UIAdurs146BOE/+CWRENJfovvQVsNEKG9iJTkI/d+
 FS9FfMiMurTAn8lPI2Ud3ANNls8lU8I8peLgo2/kZAhr/o60SR70v7wM8kgbnPYRPnIg3XoeluJ
 /SBhvWgJ4OGyDjFim/dXis9gxogl3nQZKkGZPK+ZqmC1gc/7akwN+F8XBTynViGCVlsZauvPu5F
 SuSmCGd5SqxT+aPVRSdyVBaBHkQMsfr54J0v/mR6aQy1TmqCfUVa0TqP2k+6R6pb73d2tF5Is6X
 HJs2kc+IXt180kKMel2/ytOKm3OUlCZ5uBw8/+PxKV0oes2q/EVi6bWLPbbjFRgfcN75S5KB+uN
 h8HmWxGY+0oWsc2Q9SMz3yermqKFyw==
X-Authority-Analysis: v=2.4 cv=GbUaXAXL c=1 sm=1 tr=0 ts=6942a694 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=LWyGfviaRpqOH2zqkcwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: mDeatSlkqUrrR669-7o9XwVPEO4aYnbj

On 17/12/2025 02:48, Martin K. Petersen wrote:
> 
> John,
> 
>> Can you please consider picking up the first 3 patches in this series?
> 
> Patches 1-3 applied to 6.20/scsi-staging, thanks!
> 

Thanks

@JiangJianJun, can you please check the other patches?


