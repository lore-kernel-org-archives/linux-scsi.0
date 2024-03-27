Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BAB131BA7
	for <linux-scsi@vger.kernel.org>; Wed, 27 Mar 2024 14:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711549853; cv=fail; b=PrxNXQqKBNtwEuPJj8Ss8n1D7qVaNtKcSdy7PPCZs7SsooXNe52TKACLt9+kP4cXO4PeKG9FF5dBN4a5BY0Ab9EXqDBEbZbAL4cnC6NvYGm8FmBFtmKPjzOFF88h3re9G26KQo+6lQ+0GKYHP3BT+N+rt/sVIuVl8iCTv5Y0N/Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711549853; c=relaxed/simple;
	bh=x0NvThV3UfQq66zhZ00Rrb/dvI32en6UixUDysE7uAc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JjZqh0RR+eUyN9Qt2D44Z/cq7w8B775/wqmkRfuEWfRqGvqX4hqdUGAMnZkLIUW6Gp1+7ezFx79kNYNIFX7KBytHbzGyDk8AJBpBcWTuefctYhh/0Nr0iKe4jEHURdn3S1MZ5U1XLKEZKRBXIA8pKedD/vvoQ2zlaZdqd+UlBek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JXgfWFLd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=j/qqHmpx; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JXgfWFLd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="j/qqHmpx"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42RDg2mQ021883;
	Wed, 27 Mar 2024 14:30:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=cyE6/v7VLJ7wNaZSDMNYSfsKQUimgJhV9iVb3zdBAaw=;
 b=JXgfWFLdRujnuMpodpxQYAxaMFANH/a6O2sQ763zXYQ5ZN+yfYCS4KiK8/v6g1aGAtMZ
 YaGYtEOs8AjVd9yQqFwOzhgUGnmQI3xwKwfsWUY9C0DY1yZsjlBRxUoxKLxT2Eg+INkW
 6ceEJ2TsLLyxTZUfhZ/lOPaJrzhN79Y39Hd6KuIFnxPrOvjQIxU5yvc5bKIIz04DoWeh
 JphxFAIoKmJSDpAICrpDv/kNnmRY0EfAAijfBu4fLOaTDmHsguil8xqGkb6LEhdtQc3b
 RjaPdmlWb6D1bU3gDkBzMwX4V9z5vfcBWjaRYOV3VCjYPHnBT5x4nm4wWE+XQh1jWjIJ uw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1ppuqghq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 14:30:42 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42REBp6m014406;
	Wed, 27 Mar 2024 14:30:42 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh8m0rh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 14:30:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dHJM8jrlFpsXF2cFMXBI7wv4RwiaqQZgtOO1uUMbmfHO6uaJqk/MEwo6nfIDruGeePFrvmXIvi2nn2kGLGybXXlNKffnD+8X5bU+gvvVisFSwRAig698xMt4oR1UQ7nvZPL7wMk3SQKdOMCFcvb2Gb632brIMoHKZ6quUg3oGkSNGuJRYp/gTtYy5eZb9pb1R8Bs45EXsbr+ZHzN/uMz8WhDGg2fjC1EZd1+A+IUldirChKwYajRnCZLq0bKphPBO4bstXjDiUqTdn2sX6K47VAdb02r1HUbcltVKNxHCxf/OZWnGHWC4NGFii2FHGiTwQRWCQCGJSVHLS1qCENQpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cyE6/v7VLJ7wNaZSDMNYSfsKQUimgJhV9iVb3zdBAaw=;
 b=A3canCjSI2asIcWwsUb6BBrefYym3Iqkz+DYYWrRJfb6oj1kLMvx4j7MUSg50jpL7SDc7OOWxA1uNKQji8FuQxgJPXCl7sovHiAM5Yr2lxTxFPcqtn55FY2jqguEfVZSuw65uCg/AaTtFfgCQTifIj3WEavvqyooplQc3kOzlbVz0n6/dI6BVpi6y3yHP3FnZehxspxVTZ1sApZOJOw/j/xGMViWyHW50twY5KQ5cmfRZnGRSUsJBadVfltoXa36pQCd1EpNX4127SUgyDqG58PHUB3EgOjAQY4NA1/XaVcCsQGp41y58WLRlsCzE4sysJ2AyBJoq3psC69a3LbHIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cyE6/v7VLJ7wNaZSDMNYSfsKQUimgJhV9iVb3zdBAaw=;
 b=j/qqHmpxAeMMc1fQ+BnYO89WFnyPaxwt5mkV4G5rQmU4jHW4oEjZNXd6qX39AwdJDOUt+JKun1THw5TkRsNrarZCuPVzFSPlXJmaM+/uwa1dJIYv/hOwuWLSmNLJZ/uY/uQcx1SIrdPRZYujneQU023Lavg1z2LfO8ioqIuMvU8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA0PR10MB7382.namprd10.prod.outlook.com (2603:10b6:208:43f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Wed, 27 Mar
 2024 14:30:39 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 14:30:39 +0000
Message-ID: <eea268fd-64dc-4725-b1cb-c3650a26aa24@oracle.com>
Date: Wed, 27 Mar 2024 14:30:36 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: libsas: Fix declaration of ncq priority attributes
To: Damien Le Moal <dlemoal@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Igor Pylypiv <ipylypiv@google.com>
References: <20240327020122.439424-1-dlemoal@kernel.org>
 <763a19c8-83a5-4041-ab1e-3cfac3b470a2@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <763a19c8-83a5-4041-ab1e-3cfac3b470a2@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0170.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::39) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA0PR10MB7382:EE_
X-MS-Office365-Filtering-Correlation-Id: 43e4d9de-b8fa-430b-3ed3-08dc4e6a7994
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	XmnVejwKS5Y+B0TVCHQ1CMmBuJF53tCYPpzAqRivleTIdQZc5vFwu8Jq0+YvDLAnpakbZv532G0Nwp92tm9aD80SrqjtMW4ZodHKpLz5vrByvCEEprX3OiClzw02hsJ6HsAvSGA1YokuY7EDdmS6/NIgTIgugF4B9CssMX8hdXDCXEaaBJLJbGhyqszL60mxVqC04nQ7rosd+bV8O/E5wmz3UdfMLXGnacgSiN0TKaSK50/vmgaFEYJqk4RtQrxk3lLM2W9bW8V9xIHuBWI1Blb2MvdBOIOe/THKRxWFrpQTQ4qTrjKucaJluRHEfp0qaLVFWZ5b7q61P5XSVwIOQrdUXBrqxR250tqu5qqyZEHkXhqJmbBAkRJBmzGBR+WTYg132Dh9sk2QFX4sCWo5EYiC4hWMCE4w6RQFa1EieHcxMRadtVTx2ymYFL6/OluhrPXQEDrkWXSAd0F1FH/IFki56OIlAG4vrzixoVf67td+FkrQFx+PxuIAUdMgD7zcTXEunWw8lN/cO4p8PYu4o8mFiYbklZldmWkVYS4hh9L6TTkrsofbEC7PlbwFRThBZQWuaz9w/NTvnh5oGx1/nNcKVfGnNmeaRAJl5eYXNRk+46j7xQWHQTHwYZDZzUjVS4iBBepYLAs3+9aAVKt6MRqhV7yFZD6jW7koe1yxKo8=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?dU9vREJHUDRFR3NNazVmc2ZaSGs4Q1V6U3pWSjBjNE9uVFhYY3NxdjBJaTYy?=
 =?utf-8?B?bkZkdkJ5UUswcTd1azk3WXBPTTV0U2tYd0dCTXh1YkJ0YVBFWjBOdkRZbFda?=
 =?utf-8?B?L3hHZDF2MVl3ZTJIaUpYTWJuNkpVakVGaE10V0NNU2pTUXdpdWszcTJYb0l5?=
 =?utf-8?B?a0I0cmlhY05WSU14RnlyRU1XSkdYaGd6bjBhenlvaTd1dTlTODhyTUVQQU5w?=
 =?utf-8?B?NmJQeEFHU2oydnhHZ1VqV2xaUXByejR2TFJhUkVla1lGT1c3TXVSR2xjamFk?=
 =?utf-8?B?alB0T3JtTFQ5SDNWV3o2T3JtaDlkZVpnZC9NSE01N3NaanVpSERtRFdzQ3Ba?=
 =?utf-8?B?TGQvZUJMY2Ywb0k2MkVXUjIzNzlxVTVMdE1nV1p4MFB5SnBJeHFVV2NvMnNw?=
 =?utf-8?B?MzZpM2VRR3lzVG5MaGhRcGZMYmM5bVVRc25YS1dDWWdhNCs2Z3lxakJyemtB?=
 =?utf-8?B?Rkk3VXllS1ZtZ0l2TlA2dEJ0RkVwaGhzSTNFOTh2NW13RFNGT3VTMHVHazRP?=
 =?utf-8?B?aHR3QS9LMWIxNHZWODV3OGRjUUpwU1VPaDBmS0pTQk1vejhQWnFROFZTY0Rk?=
 =?utf-8?B?MUNaWU1HY0UreE4xNFhsTU1YdHlYM0J3SWtNMGRtaGhYWnkwcGxiWE5Iejhk?=
 =?utf-8?B?dE5LRlhYVDRKRXRmNVRzbVMxUnQxR0lDbW1UTnFzTzIyaFg5L1lnd0s5YlNU?=
 =?utf-8?B?bk4vem80RjFxeUdxUWszUWpTVEoxcWJ5Y3ZaMVlzbVZOeFdpejRkQk1wL1VI?=
 =?utf-8?B?aUN4TXVDWWM4L29aanFUUHJLR1dHeVJkTzVTTjVOT2JXbG1VMERIUFFGSThy?=
 =?utf-8?B?emo0MnRIY3d6UkRabHNxcHQ4amU4K3NUc1J1My9hMVhIWWI1eUtnUEtOU3hH?=
 =?utf-8?B?MWNneE95K09ybWNkRkZNSVg1cjJsY3Iybm9kZmVCT3VWMjVicFZiUzh3dlBE?=
 =?utf-8?B?YjRrSnN3aThJTUdZMnRPZFNVYkgzenZMMk5FWTRKRU1yVzIwMFBPbTVENkE5?=
 =?utf-8?B?d2pOQnV2SFFnUjFJS1FNRGtXcVdDRFFnbW9UR1l3N1hnYUJrd3E1SlVFUlcy?=
 =?utf-8?B?YzJIMGtwTEdXMjBzc2tCT2hzVkdnN1lsQlVLZzVRZERNT1BLVldWTERCT0dw?=
 =?utf-8?B?Q3RqWEZBRkVDdjF0OFloaTB1eEF4SlVJTEZoS0tWdGhTb1NIQlMyWTlqYlJZ?=
 =?utf-8?B?WE9LVXRnd1d4ZTFOZUtpbUVTSWh6VGhTNW04VkJOOG1VMTZvNm5qTU9zNHdK?=
 =?utf-8?B?b0dadXJQVFNFNkRyRGxaRFFOaldjejE4TWlvS0VlaTRxYTB3Zm1tZzlVeUEx?=
 =?utf-8?B?eUhRWkh3QmZUamE2VDhuMi9tSThFY0p2Um5acm1ES0dlMWttUzBVc1lSS1ZG?=
 =?utf-8?B?STY5SHA4WUFOSVlKZ0x5RUthUXJaQXJDdXd2RGd3cU1TRDBiQnBvRlFWSUJz?=
 =?utf-8?B?c0dtS3BTSWN2NlB0TXBQTExYTGZWMFM3T1JwSWptYmkyeUtoUFNYQnREL3VF?=
 =?utf-8?B?MWJrbU5RZHVMcklZWStNdWxVL3l6Qm4rWE9QQTg3dHk5alVnMDZiT1lkQytV?=
 =?utf-8?B?SXB4ODlXamxCMFE1dlRiN2RES3pUeGs1UDFQQVZhK0RTQ2dWdDJ2dko1SGNY?=
 =?utf-8?B?a0F3ZmFwZVFZNUwzZWhDSElhMVpkMWJZUE0xU2U4c09mYVVQUDRPQVZkRmlT?=
 =?utf-8?B?c2gwaFQ3TE9JR01Wc0pxeThFNFYzSFpEalZ3YTJyUVJWYUdqMU1DNGNDQUZS?=
 =?utf-8?B?NUlGL0VKcjlpWWZiN0NRT2IvaEJnWWJRRWtXTkh0Z3VIOGdFRzFOUDJEamhr?=
 =?utf-8?B?djBPZ1ZPOVBvVEZmQWlpcFBOcUxhanZuRjM1Z0poNFlvZkJQbS9za0kvcVZP?=
 =?utf-8?B?NXF6dytZeUVsNWhGd2p6bExXTEJGTWZlMnpVblNiNzAvUWlucWRiOENRN1Mv?=
 =?utf-8?B?cWF4SFhTaHBPM3ExcVZrM04wT2VCUndhc3hOTlM0em9DaWZIVzYzcFRNQUtk?=
 =?utf-8?B?aXZkZjYyZ1dKWjE0c3Y2bHJ0K0FZQm9WWWNSbjBiMGxPazhsS2JFKzdTSnZT?=
 =?utf-8?B?NThrVE4vQWhZak1OTWw0UlJETngwMDhwMzNyeTZ5L09QNjJteElqc0YxRUVW?=
 =?utf-8?B?OWtZbWRBcmJFUElQK1ZJaVYrelhLMENEaEQyYU5FZTJyV3ZRaVVBRTJKT2RY?=
 =?utf-8?B?dHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	+9Xcq7SlWc0uyWqevqnmus0Ui1BLhB9qlOhumjT2maeoZ5/QlWzsDD87l/XTLfY0M7YJ/9crd1ymCrCIYGdeq7y3fHd+YaITKjVT1KpYD23gGVKofZs4xevepDtNP0Jqx0CpAGjcvmsdssq+tiLYYf8i5xGJ5TdV3OyTam+jZG7NPECVw7q4Jofkph/GLlRLeZ9LIJsO/jAgUkV4VS8YzltuAWvPKAJlIIuF5+3mJTxKfwVL2wtMyxNrkf5B9FCQkMuX0C7+esxUEDOPFsdm8eBASYhakeJuj11gO1U1++ImarqCzyIISEtQfKtjuXkvO09a+Pn1KGESghAPb/v/PDI7uidnsk/HCbCpMslVjSm7KKgeYavwmlr1Bj/Xa3PvyAv8n0RXzQIXVGsVX2cFBx1plovKf9DYnbH78tdckQUCVsGFIc5WzDgG2CitFzcsfDLTlcB1wEKwV+rTOkfUgMoSbZRg35ryP5C56kXfEJldnOfp4QDvbxo7BReMan7P//FEW/RfvYyYkQFKwNsOIBOUih7AGTVJIh6BZ+S1Mloo3Tn8YQkiVHDKoScVolimFA20JT8Z9vRc5DUlCIe2t9TNYP6PvlKMNaXzp0E/l4A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43e4d9de-b8fa-430b-3ed3-08dc4e6a7994
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 14:30:39.5384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: npK1f3gfT/P4upd8XRB90kPVML1TDex54pjWyUhJpnPPrk8mD1myF15V+sS3Ww/QXOH9/QD52bIyLhy9htO0Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7382
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-27_11,2024-03-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403270099
X-Proofpoint-ORIG-GUID: 7fZimGws41zExWAi7tcpjmEzYRHqOxN3
X-Proofpoint-GUID: 7fZimGws41zExWAi7tcpjmEzYRHqOxN3

On 27/03/2024 02:13, Damien Le Moal wrote:

- old address

> On 3/27/24 11:01, Damien Le Moal wrote:
>> Commit b4d3ddd2df7 ("scsi: libsas: Define NCQ Priority sysfs attributes
>> for SATA devices") introduced support for ATA NCQ priority control for
>> ATA devices managed by libsas. This commit introduces the

nit: /s/This commit introduces the/That commit introduced the/

>> ncq_prio_supported and ncq_prio_enable sysfs device attributes to
>> discover and control the use of this features, similarly to libata.
>> However, libata publicly declares these device attributes and export
>> them for use in ATA low level drivers. This leads to a compilation error
>> when libsas and libata are built-in due to the double definition:
>>
>> ld: drivers/ata/libata-sata.o:/home/Linux/scsi/drivers/ata/libata-sata.c:900:
>> multiple definition of `dev_attr_ncq_prio_supported';
>> drivers/scsi/libsas/sas_ata.o:/home/Linux/scsi/drivers/scsi/libsas/sas_ata.c:984:
>> first defined here
>> ld: drivers/ata/libata-sata.o:/home/Linux/scsi/drivers/ata/libata-sata.c:1026:
>> multiple definition of `dev_attr_ncq_prio_enable';
>> drivers/scsi/libsas/sas_ata.o:/home/Linux/scsi/drivers/scsi/libsas/sas_ata.c:1022:
>> first defined here
>>
>> Resolve this problem by directly declaring the libsas attributes instead
>> of using the DEVICE_ATTR() macro. And for good measure, the device
>> attribute variables are also renamed.
>>
>> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> Fixes: b4d3ddd2df7 ("scsi: libsas: Define NCQ Priority sysfs attributes for SATA devices")
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>

> 
> Forgot to add John to the distribution list...
> 
>> ---
>>   drivers/scsi/libsas/sas_ata.c | 12 +++++++-----
>>   1 file changed, 7 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
>> index b57c041a5544..4c69fc63c119 100644
>> --- a/drivers/scsi/libsas/sas_ata.c
>> +++ b/drivers/scsi/libsas/sas_ata.c
>> @@ -981,7 +981,8 @@ static ssize_t sas_ncq_prio_supported_show(struct device *device,
>>   	return sysfs_emit(buf, "%d\n", supported);
>>   }
>>   
>> -DEVICE_ATTR(ncq_prio_supported, S_IRUGO, sas_ncq_prio_supported_show, NULL);
>> +static struct device_attribute dev_attr_sas_ncq_prio_supported =
>> +	__ATTR(ncq_prio_supported, S_IRUGO, sas_ncq_prio_supported_show, NULL);
>>   
>>   static ssize_t sas_ncq_prio_enable_show(struct device *device,
>>   					struct device_attribute *attr,
>> @@ -1019,12 +1020,13 @@ static ssize_t sas_ncq_prio_enable_store(struct device *device,
>>   	return len;
>>   }
>>   
>> -DEVICE_ATTR(ncq_prio_enable, S_IRUGO | S_IWUSR,
>> -	    sas_ncq_prio_enable_show, sas_ncq_prio_enable_store);
>> +static struct device_attribute dev_attr_sas_ncq_prio_enable =
>> +	__ATTR(ncq_prio_enable, S_IRUGO | S_IWUSR,
>> +	       sas_ncq_prio_enable_show, sas_ncq_prio_enable_store);
>>   
>>   static struct attribute *sas_ata_sdev_attrs[] = {
>> -	&dev_attr_ncq_prio_supported.attr,
>> -	&dev_attr_ncq_prio_enable.attr,
>> +	&dev_attr_sas_ncq_prio_supported.attr,
>> +	&dev_attr_sas_ncq_prio_enable.attr,
>>   	NULL
>>   };
>>   
> 

