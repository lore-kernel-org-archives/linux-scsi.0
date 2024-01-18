Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D3A1DA35
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jan 2024 15:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705592709; cv=fail; b=qWIr2JHkzx0b4lS20iWFJ0HyEf99cetajMmmB6tmweRp17SsNNqKtFPwlV+s75mIwkEnEFABRJfQLJQUq1YScGr2EYH7MnydKSa2fmUfqCPM9/OmDrWYDHSlFs3ulpDq8MAKUq3k8XWxNcUwBMdH9Gsb2/r2nxPbIKuLNg+ZRrA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705592709; c=relaxed/simple;
	bh=9+L1LMm6lx9hvwnpzYuJMj3ctYKkwZcJ1YToXdbmG1M=;
	h=Received:DKIM-Signature:Received:Received:Received:
	 ARC-Message-Signature:ARC-Authentication-Results:DKIM-Signature:
	 Received:Received:Message-ID:Date:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:Organization:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID; b=VB3kzmV+1QzB8mCU156nVg8EWVMTN92iGtj2mooKqTI4P7QIVXXmiNfCV7MkiOXxkLfQlh9ZFWWOS2lccw1FhMRWQk1UNtv5ObLBj1bQUNXsmZwuKFgaFg1WR9g5fWakK5z5NiBaaR3b9IZUDoEZdO9PlynL9mITkEuE9uq5wXc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Tn42PwPP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=n1bn6EXk; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Tn42PwPP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="n1bn6EXk"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40IFTWAT004874;
	Thu, 18 Jan 2024 15:44:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=NJ43BLo3/uNXESwELxWie8t6ZsO0RCPuA+QwPFY557M=;
 b=Tn42PwPPD854ubJk1Rm340C4SC7lP5CohNBft2QoPB4VgC0w+9qysPU/8Pj2uUnLXm8G
 A+onL9KQ3ne6PMHyEmJZS3grTy7QYgF1BEEFoEZ6G+coCbUwhAR2d32D30PE1G4DNSLh
 QuPbhQXhQgGJtsTg6jQIkrmZQtF6S1VrCDxjLqMOBxdo9MjV2C9JAm8QU06MieiksBTN
 k3VvWcAGyI6VbwNZ3L94OUYEFU46lRLiOkDAQgK2IFYxIWY0r35aO4eQ/VCPtEoCu4DW
 kgWxv9BgD2i1CwUT15+3WMtLeBprLxjrdG0DvIE+nqCWyBxabUc+7uNLjehJ9S/o387g dg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vkk2ub73x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jan 2024 15:44:55 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40IFLhhG035891;
	Thu, 18 Jan 2024 15:44:54 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vkgycya2s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jan 2024 15:44:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nLHijSLzDnOl2iH7JQaJ3jMMUnoheOb4A8cjvQh2BRJn1CeZ77P5XSD+ylr51KCSDJgjfFNpkmsT+crtrqQ6ml99eMxu5O1sJR7jYfAK41ExWROt+KhNHml0WBaGFNineej7O2fnokpDLD89qSNawIsmwuDMXa7a1t5G1DCF/Cn5mHJz1wr50vW82hjdQs1OFCquFd7NewT3CZWmKLomyRfQ8QUEUPe5DHhDvsH7GLeo9JSVTdHvPMaEpxLa/+I3Uk6+4/36Z/WSvndfRJnz8QNsyq4grxiq9XXYu16eqkJ3s1baYK7ElJHBac5xsTJuK5aP9awaFvwpnPVvZhwT9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NJ43BLo3/uNXESwELxWie8t6ZsO0RCPuA+QwPFY557M=;
 b=mD7YBjuSgP39pgUK+3CWuOJG5jJE7qdDASp/+ACBya95/gSEFaj0AjjQBMhOCPyDwyJD+2PpP5qftAf94IOthNVvMFYMY/trB4x3yR6dgvlcVrOkKWKINNt+rGsLc9BZ7VczEKZfBX5tnq32OyJDmu4iEHyI46/n1885DGUDcUsdp/zNxKa1SyIzvGyKpTZ6HzwmtpF+b0bWhuQKFlL3QulueYqU2rJrgxKcSXTnMBJhdgy+HQ4UlDdb1uPS5sXWr6OmSricMjaNSFJ8ppKp/kl9ZIodZSlZDU9l4Jf93REXD11frs66Wy1yZniIgtgh8OcZUMMMl1I4+odiRYof5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJ43BLo3/uNXESwELxWie8t6ZsO0RCPuA+QwPFY557M=;
 b=n1bn6EXkFYKaMn1h/ZYEkYAuGoGhXphF5LQpQurALQ5h3qGv25NgS1NMdbwnDwuDfvebgKH4tDQqI2iEJsuYwvX2c5fToGzVq+jvZXKMGu3Ae+Rs7ZQ7Wt+9DUUoz7MNPuaeefyoWXlpPGe6RmByglRYFxX0C4EEeBqQIa4Kvj0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB6726.namprd10.prod.outlook.com (2603:10b6:8:139::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.23; Thu, 18 Jan
 2024 15:44:51 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::f11:7303:66e7:286c]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::f11:7303:66e7:286c%4]) with mapi id 15.20.7202.024; Thu, 18 Jan 2024
 15:44:51 +0000
Message-ID: <5326306f-9515-4153-9ef2-e978e775a27f@oracle.com>
Date: Thu, 18 Jan 2024 15:44:47 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: Update max_hw_sectors on rescan
To: Brian King <brking@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: brking@pobox.com, jejb@linux.ibm.com, martin.petersen@oracle.com
References: <20240117213620.132880-1-brking@linux.vnet.ibm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240117213620.132880-1-brking@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0169.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::6) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB6726:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b588405-105e-4fed-37ba-08dc183c687d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	++2NOaH3hiluOF5scXo3TLpat1YI3RgLnOfTg6Vc+xQ38cOqlm34REG0TfrdIPmtf9HJSC7yR+6CxXcQD5AN2hAcyjKpmioJGrh5hMsbzWf+4LmQhheJrgGg0bYyg2pN+N4/c5lBVdMTKUGIS0zVHjst/fLOWUKg72T/ZJc9RBw7RUjqeQ/MeB5xQ+SgN6KcKykQsc7p8o1nDT65L1iBn2P+7x7SOOiFM1mafAzw37PeKNJ84e0swsj3oXJVk+R1Dw0QPpiTyEyGzcRd2XdK2qAGoRlc8QXJIIZLqNpjUfFJ4jpKUy20tAuHhvvppi0KyGekwODnCwDFS0GIk70N7tZu5pjHa2J3Ueu7FaDi9q+hpH1L2SqBKimSkGdP97qro+nEhEuEjuvYcnClbD64ejXnNF6t29Bafqh8wS1XQYnqlmCV26URcY66g9rj9/LHOr1Xtkun4/x6Y1M5xzPL0hmGW8uY0ei7Y8XPkX84uNFfhYelyHcMtAFyxrDtbYshpu7pjuepADSJarbHhr49i+H775qNfHSWSeCvFWZTw+B0re5z8NPuQLLCw0eXY8tF+ElqpKYaEz2tFPYIgHUYszkxpcUY9Rq4i/clvcFG/vQcuSrpgwO9j8fTKP9+xU16p4OITKtrH3Rixyb47DQ3og==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(376002)(39860400002)(346002)(366004)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(31686004)(83380400001)(86362001)(36756003)(31696002)(8676002)(8936002)(4326008)(107886003)(53546011)(2616005)(38100700002)(15650500001)(26005)(66556008)(36916002)(6486002)(6666004)(6512007)(66946007)(5660300002)(66476007)(316002)(6506007)(478600001)(41300700001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TlU4MEoyU2FPdFJTUlVLS2FCZmNva3U1cXhRSFlka053KzBiZVdPd3ROMnFE?=
 =?utf-8?B?ZG1QRkpLK3RLekM2dmZnUzNHMDAvRjQ3VWxaNUpQTzdSendoU0NaTHo4NEZu?=
 =?utf-8?B?WUNBbGxGRDFZWTdidG5pMUxCS1pXVE9yZ1hBWnpSUElJRnBXdC9BZzZNeEJm?=
 =?utf-8?B?R2Qwd2JmTk9xa2JzVlBLUVAxeU9zdmdQc1RrZ1NSWmQvRjNiTS9hTVpPT1gw?=
 =?utf-8?B?M1NyWksrZ2ltSGU1emJmaFpqbVh4cGpIS2J0MVlTdmdub3VzRTJBY1BRalRv?=
 =?utf-8?B?RndlTkY1OHluUEVTdW5kWkYzNW1jMkp6Vm5Wd3ZMWlFPSng5ZWRFUnI1d0Nr?=
 =?utf-8?B?U3lSY05PUW5jWjVEQXFZNHo1aVdUNGR4T1FIa2Z5L1FuQjByMVp3YW1CMis5?=
 =?utf-8?B?VXE4OSthWDZpSmJiQ256VGNLM0RGdFhrZUNCRWFFK0ZPWm5NMjZmSnZKOXln?=
 =?utf-8?B?NENUbW94MEptb2VrYjVyS1F2RTF2N091NlJXZXlpYTg0NVdRRHJNb2tzNXlk?=
 =?utf-8?B?NGxqc3FsZXQ2OWJOeUVCQllSaUpaUnpSREhqV280N0pIL0lEM25MS1hvQlpO?=
 =?utf-8?B?N0c5VFY2eFlCVkRIaWNFQjhBV29VcnlsTDJNWUJkNndpOUVtZGszc3F6ZmJs?=
 =?utf-8?B?RWZtclI0UFhYK0x5MkJ3OWxRMm90OUFvOS9IYmpPYjNkallRbE9lR1V3ZEps?=
 =?utf-8?B?TEd1Rkh4UmxYS3BDMUlYVEtYYkhHR05icHI3Z1NOc1V3S1hUdWFCbUtuQ1FT?=
 =?utf-8?B?b3BOV3d6dFBLSmt6VFBFdFU1WVFWZTAxRmtmRi9HbUdUMUVTcm9zeUlhdzB2?=
 =?utf-8?B?aHVaWnB1ckVBQ1p6YmpUSDFDNVg2WW9rMmIvbkoxclNGRk92VkpTNitFd2Iy?=
 =?utf-8?B?Tmx3MEFmTWllWjVDeFZGVE5xUDdmdHNpd0FoUVBET0RPb2Q4eTlUcnk1MjBu?=
 =?utf-8?B?RGlaSWNFd1lYcWpNKzJ1cVVObjNpeS8vSTY0OGo4OWV3ck9ia1lTcEdadHJC?=
 =?utf-8?B?dUdkSjFLVnFoNUtRQjBxam5tdEpFK004UVA1OHhUU0RWZllwQXNGRTh5WDNL?=
 =?utf-8?B?WlRYRmE1b1JFZmpyWFZSSGZqWEhrcGFwVEJLUGppRWlKL0lwbS9VeDVoS1lv?=
 =?utf-8?B?YmkvckF1L3NsdlZBZzdyY0RjWnBHQThjNU1MV1ExSGxNYnNLTXFJd1VDY21Y?=
 =?utf-8?B?eisvSGVWMDExOXBMN1plNTJJTENSOVBsMnUvdVdOcEN5TzMvZU8xMGNmQjhK?=
 =?utf-8?B?S3MvaktCSDRTbGl4cDIwZ0l4YUhYaTUyR2gxQkNDK1VjWGlSbU5pTnN4YVo3?=
 =?utf-8?B?YnVlV0lDOTlHeDFTejlmakVxM2hRUThDT1hhaHhwMzByaWt0bFVJcUFUVlFz?=
 =?utf-8?B?dDQxY1NyMW1FVm11Wm1VNlhGRGV2WUVYT0VSVTZKQ2o0WlcxVWN6UVFibDdt?=
 =?utf-8?B?eXQ4Q1krZVk4WGsrdmNobWJKV09seWNvdnNReXJtVCs0aVNRY3R3OEsxZ3Z0?=
 =?utf-8?B?aEVFMjZUdDFBUWxlalU0Q2xoSFZ2NTB4MGk4OC9iYnEyaThwL0J1STRFa1Yy?=
 =?utf-8?B?U0t5WG9YSU4rUG0wd3lvV3BhQnlBeUYxeW9MSkdZSVpJVDNXMERkRHkveG1p?=
 =?utf-8?B?dzJMNzN2bkFMZk1RWmovbUNKUGdzUkpVWEJnZVkzMTUydzFsVzNHNlQzUVlU?=
 =?utf-8?B?U1dQWVI2aWwzYkV2djRHWTlrRFRnZVZxMHY4ZHVpMVRpQjNpRU13MTkydkZa?=
 =?utf-8?B?VDIzVXZlV0pqZlpsUnRuY296Vnk0THBhb2pGVDhZbmYvN21XT0d5R2FkeW93?=
 =?utf-8?B?SFJBSzhUSExKYU4vUEEzMjdEQ0ZhRnV3RUNHNDErVGZBMlVETVN1ZlBRd0JN?=
 =?utf-8?B?UUVyM09MT3NCcVZnT2JzWnlhYkt1ajZkaVAxZTFucWpPck95VnZWYWNWQ2t3?=
 =?utf-8?B?c3Z0bFlJR3pQV3F0ZDRpUkM0VFI0R3I5VFRiemkwcjdIUFg4SUlQcFlicldr?=
 =?utf-8?B?TXJXUGVpQ29Zc1hseHNITjQxOXZ6Umpaako1MzlYYVkxSUpzNndDSHdSODFD?=
 =?utf-8?B?MXp5OUlUOHg1YjkzQzFKNEovb2toOVBPTnFUUWViSm1UeHJjc2c3dVdoZUU3?=
 =?utf-8?Q?oBewYNDp5mjjCuFoos7kOEIzQ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	slMoI48Jgohe8nuvba3qy1Tj+sNqowqKfusGyJCPGgJDFI5Yg1cfSV1oWjgSDlAJK43EG706LIjIDXy6ejVT9TqM8snHNdfA/aQPRNfY3+KlZfGzFhmSxGK2/Tyz5uoSy3FoyN3jxswPuWsw1+Tw0n81cLRXj4esk3SxyXBwYGAmDk0UtcFDRDLrqof08Q4TztizeJI22pay9iRfSz96++Jvnin1slRI6xWWChS3EUAtfPqx25yt8/Rb2jrbEwCdFpEXUK3veDhlq5SZBDhe0nnqfyypzASmXAqj7pIKLykFYtREmj6Mn9lTNw3ehf+lQaSAfU3rs0hw44jGgWCeexM8JdHgefmwhiGG2ICOrw8nnlqHqhxXMkoD+BR4ICgIKz0HbUxoJlBbol73GsPAY8BzCAUMfR2Zz1at3X5r7CqzHku8jpV+/YEkz7KiHS0Ufy8VL+k/jGlwD9pBelfGuW/4N6MSRs02mrc/fUbzEkpWRI2bS9VmV0rhm6acnRkOwDBD4RBvcba/wECqOp5p62dx9l54BRd26sqa6zCHb2Eo8bhnAjbZ4o13wD76OZIliywMKr0Dx9U5xlJSGgc3XK9Oq86jRplAZ4M1JltwlU0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b588405-105e-4fed-37ba-08dc183c687d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2024 15:44:51.2291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rKX24RBgBi0tQECsDscdm7dYiYT2NvQEacabw9nACf9aWjIL4TiBHTLfR1q9zjvW5KW4jxnlg9eJ2aY0sXx5Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6726
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-18_08,2024-01-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401180114
X-Proofpoint-ORIG-GUID: wd8gjKVqhZfPVsnrZBBTV6cc8tdCBOvL
X-Proofpoint-GUID: wd8gjKVqhZfPVsnrZBBTV6cc8tdCBOvL

On 17/01/2024 21:36, Brian King wrote:
> This addresses an issue discovered on ibmvfc LUNs. For this driver,
> max_sectors is negotiated with the VIOS. This gets done at initialization
> time, then LUNs get scanned and things generally work fine. However,
> this attribute can be changed on the VIOS, either due to a sysadmin
> change or potentially a VIOS code level change. If this decreases
> to a smaller value, due to one of these reasons, the next time the
> ibmvfc driver performs an NPIV login, it will only be able to use
> the smaller value. In the case of a VIOS reboot, when the VIOS goes
> down, all paths through that VIOS will go to devloss state. When
> the VIOS comes back up, ibmvfc negotiates max_sectors and will only
> be able to get the smaller value and it will update shost->max_sectors.

Are you saying that the driver will manually update shost->max_sectors 
after adding the scsi host? I didn't think that was permitted.

Thanks,
John

> However, when LUNs are scanned, the devloss paths will be found
> and brought back online, still using the old max_hw_sectors. This
> change ensures that max_hw_sectors gets updated.
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
>   drivers/scsi/scsi_scan.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 44680f65ea14..01f2b38daab3 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1162,6 +1162,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
>   	blist_flags_t bflags;
>   	int res = SCSI_SCAN_NO_RESPONSE, result_len = 256;
>   	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
> +	struct request_queue *q;
>   
>   	/*
>   	 * The rescan flag is used as an optimization, the first scan of a
> @@ -1182,6 +1183,10 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
>   				*bflagsp = scsi_get_device_flags(sdev,
>   								 sdev->vendor,
>   								 sdev->model);
> +			q = sdev->request_queue;
> +			if (queue_max_hw_sectors(q) > shost->max_sectors)
> +				blk_queue_max_hw_sectors(q, shost->max_sectors);
> +
>   			return SCSI_SCAN_LUN_PRESENT;
>   		}
>   		scsi_device_put(sdev);
> @@ -2006,4 +2011,3 @@ void scsi_forget_host(struct Scsi_Host *shost)
>   	}
>   	spin_unlock_irqrestore(shost->host_lock, flags);
>   }
> -

