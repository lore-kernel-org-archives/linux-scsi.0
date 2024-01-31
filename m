Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF36F9CF
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 02:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706668598; cv=fail; b=A+ZtPk+8GD8yCraT00ZoiFphMgfgyI4dIUQa5TZhCyHFta7ZIMcLZ5uw6uxwZ27xv1BM4v33TjDWVTf7kKn4EGi8gSvJF1qKbUCUVhZ3m+SqoKSzF87AF7naAY3aSXhLGmPXu6iO1pnbm2SA1n6R+QEAdjowqiE9So7ZQs4jdnY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706668598; c=relaxed/simple;
	bh=HsIhiN+MtPOxkKJlWGbGDUyljr25OE2xI/2pNZdzOuQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Bo7Wdj2WLi6EhzzALzaTB3+HVdenWgDkuAysUM5ASjBvbR+IBa1D1V+qh/GJ70yki6wuul7PLr4VIqWcLMGgyFi1zb86C6lP+puboDYer1GEMFQgDJTQyC41W/OIvBhek6RcBRDY9oqBuwNBzpGCl/QRQ+N0xm1j7J3EtaTzcIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hplX5DaN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yhuUGodN; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hplX5DaN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yhuUGodN"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxUv8026019;
	Wed, 31 Jan 2024 02:36:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=o1wT/ZZfnahup/IuZpT0x4ZhcCeGFkQzGz3sKZ8PwQY=;
 b=hplX5DaN424IvtTUiIDTYCtL0fKk57Isybr/TAxuJgIwRvuhTVkDMzuOQK1NJSEYfoKH
 KbiBheSKTLRvpyh8l7ObohV94/t3C0MHklBHYjVHG7oq/ljs3GUu76FrbdZ2VC/zFM9P
 JSyiefmIqpMR+YlZHvSfCdUm735SnhM6fZViCmIiAWFWW9Q7RTiEcnEOuOnqAb8MxSjM
 n7nBUjjffEggt3RxxiH6MPDAKii/m4+mlDA1oIhDh7+BxCvp2tSBRNlAqVj0F87b5/7f
 PTYyUkaNogam+w4ctB3PBXoEKkrUsrOCrn1hIN4lslIzBX3MQF8AHQfQ56qCuaxAjun6 5w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvrrcgr69-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:36:34 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40V0eTjr008435;
	Wed, 31 Jan 2024 02:36:33 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9encfr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:36:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PFtOditJVnmmDLKE/q4VBJbbQQSdnkGtnOHa50PQev9YS5bgS4gdj7x5oiXV9eWJ1tpUonADMMM8tVtPOwasmvIRFBHJdKAkayiCzesBhoVwRD6NsjTVhbVFmgm/s64FtStRDZcHVBjDhgxHi4OX+3vtExKC71/8d8akG6D9GncEkwVZdJo0jaVhHs3jTAj6LTJT8377WXj7lTjvmbseShoMEiXdM6kvMpbhCLYvrf8PvUVCYzmlnSKZxqxDrsPVAvbzO+cC+V5MuN/U1nYfN/m1AZN5wjFYuO5OGQ2u0LSJjsopmIEBRQr7d2L0pK1j8C3J2FWiuO+NWroMmxuY+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o1wT/ZZfnahup/IuZpT0x4ZhcCeGFkQzGz3sKZ8PwQY=;
 b=Y24jI3kOQ53m8C9CK+9KopiZCGh1xVcOonydqRQKa40xj3vQMqTpiLJK0F1uUiiRsuXYeixUTkoNNHq/gyoEqinzZl8xS32BSlRWcBFjWFZ6j74d337bWo8so+ROwV9ikkxYA9ScU9mWfzfoIvoOh4FeAzeZFmEG0zZaJ/JnUfR0ghpswwnM/w9NW8gw9rP1r8Vdu+dN/O4ShXMcSo+5S3awNDbnAUzhHPs4PRz1Af5P7FN5MyCIMjH5gZP6R3JZaedTuJMhZeWSFeBddtfVd7yhB6JrWnpcfhfKIb7Jk7lp2RsTNEobvpKJuUf8l2Caqjl0I+bnwFu/rJQmDZhacA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o1wT/ZZfnahup/IuZpT0x4ZhcCeGFkQzGz3sKZ8PwQY=;
 b=yhuUGodNnBNAau2T3mogcOb8tv9P5o0Ce2aYudHYWlnaYsHJoDIwhBg5yozFOdcE7BRMtFFbZfSTs9vbyLx1jnJNOcKbEyfiv1zhyPMmFnR8zqY2AgUgSWCLrY9VIGv/CkPFauXPNd8kB6pdO6tFDmwF/Ge9Jl5DqDxIsC60p8M=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by MN2PR10MB4159.namprd10.prod.outlook.com (2603:10b6:208:1d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Wed, 31 Jan
 2024 02:36:31 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b%4]) with mapi id 15.20.7228.029; Wed, 31 Jan 2024
 02:36:31 +0000
Message-ID: <c7e8d70b-9e64-47cf-9db4-07146c233459@oracle.com>
Date: Tue, 30 Jan 2024 18:36:30 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/17] lpfc: Remove D_ID swap log message from trace event
 logger
Content-Language: en-US
To: Justin Tee <justintee8345@gmail.com>, linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, justin.tee@broadcom.com
References: <20240131003549.147784-1-justintee8345@gmail.com>
 <20240131003549.147784-5-justintee8345@gmail.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240131003549.147784-5-justintee8345@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0287.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::22) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|MN2PR10MB4159:EE_
X-MS-Office365-Filtering-Correlation-Id: 03e51353-6d5b-42e1-65f0-08dc22056f2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	sz5Hbe9XLMc4XocsG3j779zV5o3HtAnxycGMRHF4E0XE1mUHMaR2iOttEi+UFB0LeqprAqomBf+ST5QYTVbu8buB70pfamudx13FaF3NV6EmqeO6FmRVd4PKeaQ0VaU7/zZyUpmYDZZRleKfDTiwKoa/6Zxm5/hoBCTA0wsqkbp+0AE/DLqZmfEM1pUrSPD0nFE0ZLUOF4/4cB944ahQMSGiIzE84VTcC1BE1qEEwQW2fu66YOrZiTTJNVx8u3IrZfbWX6bWQrRmerpbOvuCVHZL2MqqZg865/nnroDrQGbD6KIzbplsw824ZDWlxzB1ulR3gOdG722Qom1sZ6BlVNCFlmZozT1fsPn/b8AJmpk9pX5dQ8HytM8M4Waphfgig8zhyAVsfjUyWac78W8hQOmLE7toGoQqLRxr7eeXYE7aOMZYlsj8H4iu/Hh0260D0Lb8Ok+6kNRrqGVOvqVaQbabIs6BhHFSIpEqt00evynsrFQWKXyye5FNzz68r66a+cSAulBRlbQIT8FQpruY9r0XAzke4UEPM9RI12LDyBTQ5xiPB00fSujZWlqY3SBoG1MXQ+Xk5CQdtl5D8fo/8zHSudf2Ee9n/6tnVpA+i9QBE8dhWba9fecAPvxmIV+EOUIUC8e9Dz399FMoz2vgjQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(396003)(136003)(346002)(366004)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(31686004)(5660300002)(66946007)(26005)(6486002)(66556008)(66476007)(2906002)(83380400001)(53546011)(6512007)(36916002)(6506007)(8676002)(478600001)(8936002)(316002)(44832011)(2616005)(4326008)(36756003)(38100700002)(41300700001)(86362001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bG1vYUNuRlhNQmlNV3NyREhta0RnbTRyYUJlTVFsQmlUNHQ5MXdSSEw5Titz?=
 =?utf-8?B?YkdBNkhOMGdLb3ZXNFBOTldkVE4xWkpjTFpoOW5KM0ZTdWtGWHBEcDBwMGZr?=
 =?utf-8?B?ZjZmUjRka21sYXJUNk1hN0c3ekdpcGt6aTJudElxZ3lTSGxucHBmcEI4T3NG?=
 =?utf-8?B?T2VmTjB4Sk9iZkhQT2RwWUhad1VSY2V0VlVXSVo0OXlxQVBRUytOSVhhL3pM?=
 =?utf-8?B?U0ZscXFFb1hSYUtOWmxnUDJsQWtKdVhLYkJ2UkZyNm1OYTZoTG9VbG8vZ2k0?=
 =?utf-8?B?anFOeWFockZOcU12UXFrWkFPV3NRMi92UGRKd25Id1V1b2NOb3dIdGFvMmhL?=
 =?utf-8?B?QzlSZGR0TnZpTzlJRllVUnk5TlczUUt3UHFzd0kvTThJRUNySXZzb3crNThM?=
 =?utf-8?B?YnJWenRKWG9qV2hkUlVUMlNVR0xFSFNYTTJxZVFRbUpBWDZ1R3JZM2FkY0Zw?=
 =?utf-8?B?U0R2NFo1TE9ZODA1RG01ZVgwTmFZeVpldzBwUkV5UGg5ekRoV0xHNVJvWDlT?=
 =?utf-8?B?aU9GaCtBUzgzekJtOEJPOER3QmdFWUdEaWsybVJEa3J2Q3l0V3VzM0xudUUx?=
 =?utf-8?B?aTFDR0hnUklqTGVxZ0ZxNHUzaHkzbjdVelRCWEZOQm1aeEVpL2JHUVRHSDhR?=
 =?utf-8?B?bVdCN1kyY3J0TWwvWUIrZUJsb3hWLzRMU3RvSUcxQ3lXa3B5OEdNZFdmd1hL?=
 =?utf-8?B?SlV3ZExWMGRTejdXaUNrNjhSR3RZR3lRRmxDWnNmRnJ0QmF1a1hEUlNNNWpt?=
 =?utf-8?B?MGJUdnNPWDZBcm93bDBQb0x5dUY0bEhhNW90RzJna3UrOTNPcGNpVUJHd1pD?=
 =?utf-8?B?Mjg2VUUzMDQwczhhT202dndVNXR1VzZJbW5xT0dPRmZ3N1FrNDhBZGFqNGlM?=
 =?utf-8?B?dHA1clhkaVNzeE41U0paOE5MTTV1cnVtdkxmb0RSbmhQaWdEOHl2VGFpdlFN?=
 =?utf-8?B?aG5EZDNMUHFsSTBsdEhjSUNtSlBTTTdmRklpc1A2Ly9FeEx5Skh2aFBzU2RQ?=
 =?utf-8?B?WFpsWXRnbVA0YlJYOGVkMjR3WHQ3MVZ3Q1g5T241ZCt3U1VYN0xNSEw4MTdJ?=
 =?utf-8?B?a2lOa280RHJPUVRHV0MwMkZ6VyswVitPOVpLTzBka0hmdENFOVFtRGZzMmhT?=
 =?utf-8?B?NXJWUFl2cDg1N1NTU0wrTGtmaTRHelFHUFlJV1huYTA0T3pLbFhXWnFtcTFm?=
 =?utf-8?B?d1ZIcW5xZ0R5Nk0xbWY5eEJMVjBqcnA1M2NyWCszaVR4QmYxOTU2dGdWclAx?=
 =?utf-8?B?VHhYUE5rYitiVWhJSGVzeGtjcW9IZ0ZyOWFzSER6RWlVaW5LalcxbVZDWDQ4?=
 =?utf-8?B?NVNtdU9GZXQwMTQxZkdqbnI0emJGK1BxVkQvditiOCt1KzN4bmRiOGJGbkxQ?=
 =?utf-8?B?R0NVMDNIU1pXNURnendjQzBGUjk5RTB1TERVZHJiWFcrTWZHcmRWTmwwd3Nu?=
 =?utf-8?B?NXlKTDVLc3JPU2pyVTBkVExLTXJCYzJ3VU5nUEY3czV2L0wrZ1V4OTN3b3dV?=
 =?utf-8?B?U3gxQVFHV3VBSEtTVHJienAzQXNzWmhwYWsycmVpVTNRYlVtRm1JSnRXWWpK?=
 =?utf-8?B?QXFWUXQyRmVKM2JIVjZ4cWRZOFVtQTdaWEN3cDlQb1FsRG9FOFdPb2c0OUNV?=
 =?utf-8?B?RHdxSnZVbFNETVR6N3ZlQkxnNTBPeGtkUkc0YmJtblB5ZHEvWEd4N2R4Mlgv?=
 =?utf-8?B?WXN2NkxCNXhGL0d6MjZRcGJzRXpkK3BqLzB3ZzUzMkpXOWtkZ3ZzWmFPUkIx?=
 =?utf-8?B?VlNHSnB0amdKL2lndjR1eW83OVNhRXdGU2szN2d2TmFObWdLWlNRYzg0ajdW?=
 =?utf-8?B?Mkhoa3ZtZ2MxT2UvYnVUUHorU0todnd4OGFUb1JaTVdzUllBZU0rdjdSL2Yz?=
 =?utf-8?B?YitkSFBtUlhyNC9qenluNWpsYXRFSjlPdU9iVGlNNWZ2N0FBVUxWa1pTUlRa?=
 =?utf-8?B?TVJadFZNbXdwWGsxaHdKYkEvRU5FazRzVjREQTFNK1BVZC9ldzd2ZTNBN2R1?=
 =?utf-8?B?SzAydkJLZGVwUUZGTkd6SEd1VEhzWTJzV2dEdXpRQnlZaW5TZ1RTQ0I3aHpw?=
 =?utf-8?B?ZWpOM1lmZ2Y5ZmdBRXo0VDBaYk12Q2prTzNLWE12TDQ3WnEzaDFiczZEd0FQ?=
 =?utf-8?B?My9yNEQ4WFhnbHNid29peW1EYkk4aWduV2FLbFMxSXkvVjFaK282QVAvRmJu?=
 =?utf-8?B?TXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	bvSdFjNSq8VBvtHb/iKnRo1nejmCDztvHikDezM9DkaEergERhK3MtwJE56Ib+7ScD6rZKOFFCegyjDHr9XFqmMbkDqoQ8HF+6mCsgZ6BJAHkPhbWlWamBtKe4jPNfN8ESqiMa7qCmVhFIaippw/Qzr5adECdxywb0lpHEB/kLlKblrE+yR8i2qURQwEMI0oq4wve6gqjQmAS+SRqEKEWchcOJ7+oAy9L/cLg6awaASaiM3a79hn8bs+z3fEMlFbeTeB15kBMcDaG1aleNTkIht5Zw5mrBBlKz5tu3pDgQAVNUodeBMASmXOhAfYpsE0mCm/aMOI8hbamRJXaRQ5QBpWIOT0JZrugPqb/k9jkpXjkeKH7U80JYwcgSNPPBzul4Y4WE6d9vAVKjMXze6hZWDxHd+fYdhMfPve0u0wDW+8E/cTCev+w7N624m8S5ulvMPlqBqv2ovJBAbvMqtAiVDJGTxllvyZmpuuvOw0+MVFvCfH4vXSQ9pRjFoxNwvFZ/Ekq68+T7HP4wIhawFeCvAUqWYQt+ls6y1q3azNliIkuHvtyGI/8R23SQ32evVpf8jSXMCPUnjUa2XxnXnsRrL9Zv6+Srfe2kq0Irc+jk4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03e51353-6d5b-42e1-65f0-08dc22056f2c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2024 02:36:31.6581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NASnVEwivkhkyGfA5I8/BC0xKlda8NjiMybiaLSBM9LweM/QQ2r9Y6pH9U+JqhOzJsD6zuVjzKA47xq5d2Uz9vI3rxLUb+uv/qWvP03ojh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4159
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_14,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401310020
X-Proofpoint-ORIG-GUID: N2-xUVb5d7MTa0HYo8y8kOMyo-OtP92V
X-Proofpoint-GUID: N2-xUVb5d7MTa0HYo8y8kOMyo-OtP92V



On 1/30/24 16:35, Justin Tee wrote:
> D_ID swaps are common during cable swaps in a SAN.  Thus, there's no reason
> to log the event at a KERN_ERR level with the trace event logger.
> 
> Change the log level to KERN_INFO and the normal LOG_ELS flag.
> 
> Signed-off-by: Justin Tee <justin.tee@broadcom.com>
> ---
>   drivers/scsi/lpfc/lpfc_nportdisc.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
> index b147304b01fa..0bc93f346d90 100644
> --- a/drivers/scsi/lpfc/lpfc_nportdisc.c
> +++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
> @@ -434,7 +434,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
>   		}
>   		if (nlp_portwwn != 0 &&
>   		    nlp_portwwn != wwn_to_u64(sp->portName.u.wwn))
> -			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
> +			lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
>   					 "0143 PLOGI recv'd from DID: x%x "
>   					 "WWPN changed: old %llx new %llx\n",
>   					 ndlp->nlp_DID,

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
