Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB7A28374
	for <linux-scsi@vger.kernel.org>; Fri, 19 Apr 2024 19:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713554908; cv=fail; b=UrK98QBKipjtD0Kp9FXL1ENC/CiVMLlFIayYAjg7knVCzTneflGHIrpgEoMsSdMqw5rppD6FMgjetFOwF+pb+31GzN2bs62CcAzKXNs8L/6o4TSvz9fJO6JV17MjiJnHQZ9VrlxXyunkU0sDhioFGJSkBng/KiRbln9k2igf6JM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713554908; c=relaxed/simple;
	bh=BtMeUB2KhvJ3UpBB9Pr5ZJOjtPF6Sfzhi8GlpWdryng=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VMm1UNLae3iPvwOtD4mT82WW6GqmeItB/KAF2c8sJ2+Uc2Tim3wKf5JZPaE4cuhMgvzd7oDTqHpWAX3JpTAnKZOBQIYRd3rhxrniRX5ZA73kFlytOo9dtnjWD6pJIo4dpZIcRXUOEOamw7KuRjzFtwJKA+cmkbybJiRmxeNlsSY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jDskiw/e; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=R//5GFz7; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jDskiw/e";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="R//5GFz7"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43JJEMgQ027195;
	Fri, 19 Apr 2024 19:28:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=iaEFl7zFevoG7XVCVyI+ZUbS1yIAWBKl7BTZnMkXgF0=;
 b=jDskiw/eT7ujz2IM3A4Rdy2a5SyiNnhX179cFb7ucQLG4wReYHVTdFb6QM1icJqRoK6z
 TODmjTsb7wcJEvhhVChBpFWuIONwcaauyurmECYcMyfAv/7MugRB5b5zEZpQg7saQbbP
 kCc6PFkZxJsO+rrBa2C1MvEn4VmMLQORVztQqVskosSd37tHewbh7n+FHKPclskF1xhJ
 gJIvWZ2B3txELl1uR0gkOpVnmBnAFC9ziRglkru7nypuOTHE4S2jRKZOhncKQ/6UKKPv
 DklkesmVc0LC1VmG2t7MhVyjDefIex6cWqK6WbqnOn6ib4lhtiqf3VX5xT0JNIj73juK GQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xfjkvdj7a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Apr 2024 19:28:23 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43JIk1Ro014301;
	Fri, 19 Apr 2024 19:28:23 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xkc980cpq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Apr 2024 19:28:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e3voNz0eX3q3EN2PQbt1q32pOyZ+sq/GYEFm93noZnpghTsqUBJHlCiRc3lWFv84LQ722PxlN+IHNhnAo/uAnPvAUrR6SpM6XZkWMCXZgDRlZwJi+Q3kUjYYepcm/N88m1y/jUDxGEcMeUOvIdStUL2gXsZhsxKEHYCWGLVNPMqZgY7rbbzewQl8bzMMjS/SNj/TgmCIAYRdSm2gsKgMrOrs70S0wkWLuMgKQcY1XJ1xAR6D/B2PcJLnoW9pM/OjnvVfypo1BSf/X/Ji4m3LKNTZcabJRSaO5dob2MExp8cDY/+QTWDldkUrhc9EkUkFVypYfoui2p5nsCsgLGowLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iaEFl7zFevoG7XVCVyI+ZUbS1yIAWBKl7BTZnMkXgF0=;
 b=ofF+ostnvCQHdbyEkdro2k1hkLmo1BUXgZt3kREM7zzU691RM3eo3PNss0MAubYdILLwVFX//j5icu2IVXyG87niMvu20mvknRRBoic0AITTClNLNN7RS+a2FCuNkGzFnm1gwHjQ1nAjkPG6JeJEPpsqhs2YfD03whJGsdVw2e1XJrUFlzIC6fYX2BKyZwQ2fxPClUuWVPMDlnF9j5/hDfo/a1R+NOTqo/CPrRQbcm5U6MG+OO/mQaA0eCUTRjsQjFn68LoukPm7T70lkbH6c2x8gPjOgEiSlV8QHf+KVuw2FhZNvHRC7XauT0LQv8MHnuigzch5k4vBaMx913ofxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iaEFl7zFevoG7XVCVyI+ZUbS1yIAWBKl7BTZnMkXgF0=;
 b=R//5GFz7c0z2sWVOc2ez/QP0IhYRzyGLdsPxePqkldFJ0gGG2h10c1PdDK5v0I8rBjlTOO7zU+FKNnffVhs0kym48qonZsYoA+tNOcsozRNdV0G3/auvujekQIV77kZEBY7+SqY/Bg87/Lw4UqgGh7Prpw7arsZlj1bVYlbUrWM=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SN7PR10MB6331.namprd10.prod.outlook.com (2603:10b6:806:271::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.43; Fri, 19 Apr
 2024 19:28:18 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%7]) with mapi id 15.20.7472.042; Fri, 19 Apr 2024
 19:28:18 +0000
Message-ID: <d82ee3b2-ded7-4020-a286-e9aff060572e@oracle.com>
Date: Fri, 19 Apr 2024 14:28:15 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] V2 scsi_mod: Add a new parameter to scsi_mod to control
To: Laurence Oberman <loberman@redhat.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, emilne@redhat.com, jpittman@redhat.com,
        jmeneghi@redhat.com, Bart.VanAssche@wdc.com
References: <20240418181038.198242-1-loberman@redhat.com>
Content-Language: en-US
From: michael.christie@oracle.com
In-Reply-To: <20240418181038.198242-1-loberman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR14CA0044.namprd14.prod.outlook.com
 (2603:10b6:610:56::24) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SN7PR10MB6331:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a415820-d6aa-4b31-3f16-08dc60a6dd98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	6K6PzfotCA/xNxJ3EzJzPEyyaSKJNjKljM947vK/LoxITkXuPmGUGriXW+BkNtWpwqiXOh0deYKGeSi3pYBgl0KK4L1kfuM/OQVQCfR7jYUw62xg0/qm+cBXp8brQ951PMBCkmqxI7GyzratzIxObCXCHrhL01tiAtWe3cTfy8cUB3bYatmlwT/SnMibFKspFjojIx6+tLRs+iNv10OH/E4bgoY8iLQKDjKcQdEBLAWvvxRToiJQDtMQTEyTz+3e4M1u8nLgF63BBislwfqCKUV+WlDmPCMs2nGNvPKeMxb38Bh7REbjW1WCKTHD+B/QJiswolXE9+tVcDY9UMnfL81+5cozxdWhXWgSgDNp0u2/7G2pcI+aePnUOB/2398sDXtglIizmXFTnbb+hi5+ZkshQcAEbBdUoJXt7IQgzxZABOOMzRhfIfgdFsqHlFdckOgp7VOX/h3SjAPREmsbs1CzF4rK2q8V4gc1uXlIBJncp7rRs/r/WCpugP9qILpvY7IObD+Ycutb0dlE9/xCyYj34YANaXyrtXOE3oypUwvEN9ts00TguBGYL/F57+hI9PCNbxOkgSd3fQCOphCQ4sLJrrisEgKTDu8L+R5cLx68O17NjdnkucrH/Zxd6++MgKbGb9wIAwQ6jMZ11Bv5ip+deDuxrOeW9F2QZv5Eytc=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?a1JTbU5NL2N0RXZDSkY0VnMrNk1YVDJpb2J4OVZ2MVl2bWx0ZE9wd0lHdWYv?=
 =?utf-8?B?WmNPTHBzYzRvQUxPdUFRSE5Tb0t4Z0k5NHc3RmF5d25ackgrY0grQm12UE1q?=
 =?utf-8?B?ZUIwRm1OZHcyM2JxTDlNczRRZmVjMGk1SXN0dENnUkorOGlybm9nU3pWMm1w?=
 =?utf-8?B?MTVxekdHMnNBMTRIWlNVWHdqNjhtMjFtcVpYWlQzRmp4SlJVbDBwVXp5QS9j?=
 =?utf-8?B?WXZxWXRsMU9iL3VHeFVrbzNPZmZHeFBjZVgyQlZTYkpiay9jK29MUW85TXNv?=
 =?utf-8?B?ZTRTSy9Zdk5ZaENWenVEZThpdzVsT0RqWW5NOGZnNE5xd1FiUWM5WmduK1E1?=
 =?utf-8?B?Y3JRdWNoUzRJRHN5L2lRSVJoMnloNTc3Q25DV0toeGpvN3JQWGppOTBwLzJC?=
 =?utf-8?B?ejZBSVBUSnBRZmdjaytpRmZocG9CWGR5V0ptaFA3QkdDWXIxY3NKZWwxU3d6?=
 =?utf-8?B?c0xjY2Nwa3p0ME5mbWlhQjNsZ1poK3hqM3FxVXBDTCtoQUJOZExTVjVLZUUx?=
 =?utf-8?B?ckVERHpsZ0EwRFlFQnhtb2ZTYXoyTVMwQW8rMTRLZVhWWTJOdWllTzJBdUo3?=
 =?utf-8?B?bkpiWm1NZGhNQmNFWGlpK2lLd3Y1NXJ6T0ZKTm9CRm4zcEhKaHhUb2kwSkZC?=
 =?utf-8?B?ZlVZS1hscTgxa3pndThuNXpFRmk2UUtzbHJGQTE4dzhHVzE1aVVGK21hVERW?=
 =?utf-8?B?WGdGVml0Z0t1VEo4WjNQckdYT1JQdDNXdjdSWTd0L01pNHdOMnpEU29nTmRx?=
 =?utf-8?B?THdZc0g2SlRINHF6OVp4Y1V3RTF1TXRieko4b2FGd0VuT295cFByVmNIcitx?=
 =?utf-8?B?MVhQU2xiQTFrRGdXMmIrS0tURnRIakN6NE5QdEpZNW51QXZ4VHduOXdack5T?=
 =?utf-8?B?Rk02bTNXUXZyMmpBemQ5aXJvL1ltOVB3cVYrZW02aE1ZcGlyVGpVODRyVFRI?=
 =?utf-8?B?em0zd3VHNllPYmo3K0JZaHlZdWdlLysyQitCTDFqaHJxTEVyNFp1T2lCN3hz?=
 =?utf-8?B?ZXpXRjM3NWxkYzZmd0orU3VCdmVqa052b2dkanlLNURWZVRxM0d0NEh2enVW?=
 =?utf-8?B?bWpyZU01UVNBZTVabmkvR1UvS2RzUSs1bWJMVjhGdVQ4NkV4RDFmTTFuNER4?=
 =?utf-8?B?elNYMEJQZnF6S0Q1QWMyL1QrNVhjcTA0RnBFYzI2ajR1dU1BZjlUdi9ienRl?=
 =?utf-8?B?NUwyS2ZnQ0lTVVJOWHN6Sm9WUkpBR0RIQnVocGdTbGV2OEFUTFVQbmRiNmFK?=
 =?utf-8?B?aVo4S09aa3dlQUlLNWFURXE4cTVGTThNN2dIVHVVa1NLWEpEekNWVUVaSFFp?=
 =?utf-8?B?ZWMzYWdvVzlrQmFUMHp1TERSM2tIZi9Gei9MWWxlWkZMb2kxMzlUMXNnL0xi?=
 =?utf-8?B?UXlDUEZqWEJFMElRQkYxWk9WMWxIem8rdDdIZThHNUJmOHRiKy9yTzZvN1ht?=
 =?utf-8?B?OVJMU1NNMWhFU3JDUjJXcGlLZWdtSlJ1LzZHdDZLVkZHeGZzV1dsTDhVM0ZU?=
 =?utf-8?B?Y2xjam02a1djUGhBOUI5N0E1VEEySlRvODM2U2lGdCtHLzlpZmJZWlNSamZw?=
 =?utf-8?B?T2p6aUtybkN1UFd1WEJoZjd4ZVU1ajZXUHJoVzJ0NzZHdC9HN2VyYnEwRGNW?=
 =?utf-8?B?aTQwb2tWdGRuVFRzYWtZNHhIN09FdWRZN0g2WTBjSlM0ajcvSUNTRVIzbVE3?=
 =?utf-8?B?Z2hMQk42K3NEdTJ3MVNLMnByU2tJcTVER2hjQTZTZGpteHhZMFpQazYzUzIv?=
 =?utf-8?B?bDJOc2lKUVpYTS9Db29wQUlxNVFzSk56c1NXamE5OFJxUG8xM3dYMmZZM01i?=
 =?utf-8?B?SEdGa0hDRzk3cnBMdVE4dloraGRvL2wwZFNleTFSS20xVmpyYmZkLzFXeFVT?=
 =?utf-8?B?aU1CTVhaU1dzOWc1d1dCcUFqMFlzMzZkV0xzM2xPY3lwYStta3BITDZab2g3?=
 =?utf-8?B?WU8yakJwVU5Dd3F2dGcrcmh5MzRxZU51K1ZLQU1rWGdMN0Roa003dmtZOFVx?=
 =?utf-8?B?UG1jcVViWkloTWlab2RnWDhmYm5rWlRmRlNhSndNMSt6RlBtNmVlSm8wRWdo?=
 =?utf-8?B?STVuTEQ5Z0licmM1SmhIQUN6ck9nUUdCYmRVRHFmQWs3TExqWUlGazhTdWpU?=
 =?utf-8?B?UUFNVVMrc2xZbEtHL0VIUHk2RG1DRk5pMUVHLzg2VEI3VEpEaytxWS8wRTln?=
 =?utf-8?B?MFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	we8Zk5Xt9e2TeOH4p8U+Ir0AqymE8vgwOppplCjKKTYOVRxOczvSBGDacPj07+zy93mTSEP3HPDGNbvhAqG3F4o0nliBVwrfrA3Njz9g6rfAPmTO1BH9PWYSHLJqzQu4yz+QROOuB4OuZzkBfrsLR2MXsy3BwIiEPU5T8PStcDKVvdD1H6pLCB8VWL1aivlXXgBUzU79clOiG5RJBNae+kddsOae7/c6i7NntZdI+Q6nsGEnRTOu8QYIWcTmyja0hWWN0+0YbWuK23nnlFUXWSjGwzW6XsFhzUVc0UF7jql02zi/gwrAZlr8eRQroJeXYkRGa8iVMAuokxlBzeGuStH/pH69sh8oSgRXMffQB9Oi9H7V7R6LDGW7sBd1ltKrz4TAp97C9ATtkHEXM1BEx6SlZElSGqKAiRYsXdRzg7V+/+vn2eOqnDFFPdGp3xoR6r8Fsd+3OyvFecQDYF/CkO1B6JJPJuoAj1f8KFMFyWfN2qO0qv2yHxmrcoT2C/wTTuHZ9jmjA0Vgvqilq67plsfimfK+j2Ap32aqF1sBruCupEa+p9DEPlmhw6NxaCtRB0WuTnTCA8XhRAY3SLXCGXIx2pg5HMAx1tcxTEpgTto=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a415820-d6aa-4b31-3f16-08dc60a6dd98
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 19:28:18.0253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BiC338CxaDSKJXHv4tHcG2+6iG8y3ghz5e09YtT6gMmi2d5Dm7BSComosZyLMP7IhMxyGOrYNJQ4x+FCtM2omnum4p9dB7YpPqkZWTvqFcw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6331
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-19_14,2024-04-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404190150
X-Proofpoint-ORIG-GUID: tOfqiIFu15Nkd20PPYTJ6cTxSNr9JRVM
X-Proofpoint-GUID: tOfqiIFu15Nkd20PPYTJ6cTxSNr9JRVM

On 4/18/24 1:10 PM, Laurence Oberman wrote:
> Resend of this patch as V2 against Martin's tree.
> Changes: Removed initialization of global variable storage_quiet_discovery
> 
> This new parameter storage_quiet_discovery defaults to 0 and behavior is
> unchanged. If its set to 1 on the kernel line then sd_printk and
> sdev_printk are disabled for printing. The default logging can be
> re-enabled any time after boot using /etc/sysctl.conf by setting
> dev.scsi.storage_quiet_discovery = 0.
> systctl -w dev.scsi.storage_quiet_discovery=0 will also change it
> immediately back to logging. i
> Users can leave it set to 1 on the kernel line and 0 in the conf file
> so it changes back to default after rc.sysinit.
> This solves the tough problem of systems with 1000's of
> storage LUNS consuming a system and preventing it from booting due to
> NMI's and timeouts due to udev triggers.
> 

I didn't see v1 so maybe this was already asked. Why can you use the
existing SCSI_LOG infrastructure for this?

For example, are the printks that are causing you problems specific
calls that are not already covered by SCSI_LOG, like the sdev_printk in
scsi_probe_lun? Do we just want to have those covered by a new SCSI_LOG
value like SCSI_LOG_DISCOVERY?



