Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 252AAC77B7C
	for <linux-scsi@archiver.kernel.org>; Mon,  1 May 2023 16:00:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbjEAQAP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 May 2023 12:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbjEAQAO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 May 2023 12:00:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01EE612C;
        Mon,  1 May 2023 09:00:11 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 341EIoi7015468;
        Mon, 1 May 2023 16:00:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=wRHgi4dr566Bx3dbXnQzLFuA1+w4ccKyDFSh02Zw8ps=;
 b=URKDUQEAbjRoqFsO26OIJkXc6nMSY5LytM4oWG9PQ6LadWXS7zPFsiKvzlTwWQwQ9kwY
 +bZ8x/7WLrOdctv54LB/xw0LHjEuzRYoba85/8qosFQ2iNvX0LuIGwZRxOYoWyXBkLFS
 +DZAaoZ+ij/tMVe32mPo5dKxEtIhUhU+1Iwy/NNbybMQ1dOQIIPLXDK0IYsj1l6jCUFh
 brWovjn7vhO8+H+scdramFNkfJHsmJzyCUdRgCa8u+1wq07eRHuYXDPER7XOpwAQDZ0y
 9tgwt81/bmMHZlYZSktE4O778Gd4X+AxKfCUXyMz9vI4eOIO448UXYPqltTlyAjaZ6Ar Vw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q8u9ctnjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 May 2023 16:00:04 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 341FLko9002389;
        Mon, 1 May 2023 16:00:03 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2048.outbound.protection.outlook.com [104.47.74.48])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3q8spaurkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 May 2023 16:00:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W7S5oFcyNLTM0O/nJqUZad/UYt2u9dc4mjbEHhrJDb+OGlGbzU/kPd4KzaP19aC0ROrDP7LruPmx/VL1FQJMpMzE3YHYaV5IFzKzrB3rn7/IB4mCSnFXWsbX7nwXczM/5O05m3X7OfHh1opNCH4SHdTy1Fw8nY+Pl2EfJgJTjDtIj+fMu7rsYxI7iaUpTRGIOLNor6G31aMzZkB4O9y49NTFa70guv1gtW22u5+ZIbZmTs96CWTxOb/E96ynPidzc00Lhj70ecCBK/ct6ISopkSr2bNjGlp2+qabdq2SJBFZd2TOZS1GJaGLpBR2ImmhNV/M3ZzsKd9TjC/jKGROww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wRHgi4dr566Bx3dbXnQzLFuA1+w4ccKyDFSh02Zw8ps=;
 b=nxvzTiU8A577iupSR4QyUzvjCJfwomD63KksJw8HtfjBPSomRF80WhGNu9ixzg28DWaBOFOEHKE07eVP+bQrQYaGHExE0a4cyB9tHmkUpv9gzn+d+r9aQzYSEgVkg00EJeXd3k5dMjsxCRVRHSnOrAUs5//qw5yyfSvcspDxnaumAvrjFkeeeiKMtP8RdMn1EHuL+2tgbBPL4GbwP/Ax/bRv5NZJgCYe7OfOmKp3BVlJhZBt/5qI129W10pM+ugFRODBix4JkawIwR/N4wlixjnxynFaPe6tmB9YSJiz/gW/Fru5yf488BXxYArfGfQ20e1m0JCoqqkAKaeow6B4Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wRHgi4dr566Bx3dbXnQzLFuA1+w4ccKyDFSh02Zw8ps=;
 b=bZEwjBF5dj121HIN5/gQhp3j1GSb7mc+4YxL/m8nGjkLEG04C5fQH3K9EBBPl/eoeft877jURG1FV5KFrUbahMD8uGExe+EE5MGMrGPRf8Dqk79mYgsH8rbZ+QOudZ3S212+PacU5THTl7HK2LWsVe8DNji7mS+8qTcNE1hks4s=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4479.namprd10.prod.outlook.com (2603:10b6:a03:2af::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Mon, 1 May
 2023 16:00:01 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8456:ba59:80ec:d804]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8456:ba59:80ec:d804%7]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 16:00:01 +0000
Message-ID: <7c29706c-9481-d4b7-6a92-ea18f9c04145@oracle.com>
Date:   Mon, 1 May 2023 16:59:56 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2] aacraid: reply queue mapping to CPUs based of IRQ
 affinity
To:     Sagar Biradar <sagar.biradar@microchip.com>,
        Don Brace <don.brace@microchip.com>,
        Gilbert Wu <gilbert.wu@microchip.com>,
        linux-scsi@vger.kernel.org,
        Martin Petersen <martin.petersen@oracle.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>, stable@vger.kernel.org,
        Tom White <tom.white@microchip.com>
References: <20230428210751.29722-1-sagar.biradar@microchip.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230428210751.29722-1-sagar.biradar@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0027.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB4479:EE_
X-MS-Office365-Filtering-Correlation-Id: a04e1b01-4661-45a3-0df6-08db4a5d1e93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0VDki7x3DUULwwqQFFk9LCrOYGnEEZvbNTOO79e+pz2Wh7HPeBw/lZ2kXP2CBj5pEADh9xuNdhOtWoNq966h950rZlK1iKBuP0D0zV8XylVJpXPtwmr21v/ulYWBhFdgKmKwt7qyHf19uwYcmK23tCdd1U3E12p/eYq1FpdDwiCXVPA4DzEPJidWScIupGAAIWaZJ8uNsmi4b4zpNZHjEbyC5jZmPKCJLOvBMZciFMQ8p3524NNc9D2bEyN8Hu80pL/ilKUxRGopXSRYoQ3u3N76/25iEwNC5FoixaCj8n3O5B94yyuctkiTtuwzSXiQfYF8M5J0e/YD2vSScmbLGgja3bwK1thLkOzxnY9V0RY28R19IGlBbc6pqlz6DYDkTBqE7th+GKZ0eVDGhBChQIP1nyXmQzoVYkIGx82DJ0bt7E/BppBoHChN3l+8vspSWEfQ6VDIUsLMglz+mfwwgY99sG+6GRHf9XB7jVcbUpKIQglYxh/LrSwBlAxqxAh9+UuVew26HXr7czv/tsqzpmMoNFrsHzocKCja0LA30QtRsOnJWROgMSiSAEqWOtsRZBPSV91hUdnZFFPK3/TfNJUZ86Z+0zYzFudybmXOwlh/leWXVY7JC9/B6ZSGvZJycRJ0WHdtprmS8l0/CJw00Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(136003)(366004)(39860400002)(376002)(451199021)(66899021)(31686004)(31696002)(86362001)(36756003)(38100700002)(2616005)(6512007)(6506007)(186003)(26005)(53546011)(83380400001)(36916002)(6486002)(6666004)(110136005)(478600001)(66556008)(66946007)(66476007)(41300700001)(8936002)(316002)(5660300002)(8676002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TG1XVW94MXU0WXN0YU5Cc0Fnalc2N0xYd1B0bWUxVHVzcXUvUktiN0tuZ0p3?=
 =?utf-8?B?Zk1UMERuZDRBdm93QUVZd3NTaGlnSjZlb0hTMDJqL1gwMnptRUU3ZG9BMDU1?=
 =?utf-8?B?dnJIM2E2U2UwYkhGWFVMNmJhUVF4QWw0ejdNMWhVaUJRWGxpSTRYZkZZMFJz?=
 =?utf-8?B?RFExWVE5L1dOalY5ZGhxNzQ0WmFuUThFVk9Sei9TenRrRDBwNlhOM0dBbWNK?=
 =?utf-8?B?Qm1TUitib2IxSk5Kd3dDb2ZvdlhLL2FCR1gxNDc2bVoxZkV4Qmg2cUNiVmU3?=
 =?utf-8?B?N1J4ODhhT0FqempDRjJBNUlINE1oTnRRY2RLOFppU2xocUFqZ0g4NjhLQUN6?=
 =?utf-8?B?dGVjWmZhUTVtSEtVdW5WeHNEN1RVMVlYdWgreEpHdzNmNGtyYTk4WEQ3cTEv?=
 =?utf-8?B?cHRIOFUzaWtLOXdSZkRLYkZsclNVaUxXdXRxQ3MrRkhpNGg0cExjVUVFamdv?=
 =?utf-8?B?QytDTTJGeE1uWU1mU00wZmkvWVh5d2tCK2xOYXlUdG4rUWp5VTZRNzh0MjNO?=
 =?utf-8?B?eXRCRW93VEwzK2lza3gyL1FsclJadGtUVnpXQ0h3czQ0SVN1VXNpbmYwV3pM?=
 =?utf-8?B?bjhnR2RlU2JDNHpTeUttV2JFdWNXNDFyTFZSSmo1UWdiVjZNNXJZU3VSL05O?=
 =?utf-8?B?OGZET2FqdWxmOFRIUXZUNEdRV09qT09KeHY5M1hkL005alZqdUQrWm5oZUdk?=
 =?utf-8?B?Zis2RHI1NU91czdUOGExU2FjTkhnbWpIc2lDYVVwcDBSY3I0WWxFOFNjRUpo?=
 =?utf-8?B?K0pESkdabmxXaktQb1p4Uk1xUkZsQ1FkYWtCU3RIaWY3UmdxRnEvZUVTYXEv?=
 =?utf-8?B?NVh3ckZYMjFUWGZNZHZ4Tk9uWFFPWHgvdXMrc0JleHdpYVFCbVZ2cWRrd1Aw?=
 =?utf-8?B?djlPWVdtc0xGVDd0c2E2MlFxdkZkMG1lUTNuakhvZ2FtRE1VR1lTYkpuWWla?=
 =?utf-8?B?MTR1cmRlS2VtalJnSk5Qakp5Z2NpcTBLbVFhd3RYcjZIR21vNXlxOGwrK1NN?=
 =?utf-8?B?T2krZm5Fc2ppWm9OTXFlOHVONXlZNDVZdjI1VWpCazViR3QrcHZzRVNxN25L?=
 =?utf-8?B?d2hrd2puZHRIczRPSDV6Zk8wYkQvay91VE9adEpNdE9sZHJnbWVCM3JYQVJt?=
 =?utf-8?B?TEtHYmFKOVRvNjdBM3JWL0ZMTzAxbWw1TVZPdllHQ0l2Tkp5M1MxU2ZnNnBX?=
 =?utf-8?B?SUdzVVlqWlN6RTRaSk5qSm9LREp3b1A4WVlrWm0xcUdSQmlQUExVWU92RWhT?=
 =?utf-8?B?MTdyQUxJbDlmNG9TQjFZNi8wQWh4OUFabnFkV3hFekVSclNTVU8wSTBmYTU4?=
 =?utf-8?B?dVdNMWhBQXhEZExVRFdOU0RmbDcvZHhTVzJKcGRGMkdFWEwwaDhRRW1KZjVG?=
 =?utf-8?B?OUdXMGs0ZGZRZ2FseWZ1WENxQUVPUXd0S1pXeUgyUTNoQUlvVjdwM21BVkRk?=
 =?utf-8?B?RGFNRTRvQWtQcVptcURXZGk3MUtUVU1jOGJ0TmtsVVVKMHpuTkpUVWhucFd4?=
 =?utf-8?B?QUk0YU1XY3dLWEZrVzlnYXhlbmM3eUg2NCtDd3hxL0JTSncwNDc1alNnUnJv?=
 =?utf-8?B?MnF1dXdKR1hQRWdkMEVyOHZUN2ZIa0Z0L2hQUXJaOHhrV3A5cjBDdklkOTh0?=
 =?utf-8?B?SWxIOFgrK3VXemFCRkkwZzNjNVQyTDlzSFlIL3VhcXVVYmUyU1RiTEV4Z2Jm?=
 =?utf-8?B?TGZZdldOaEtBaWxnYzIySzYwREYxSU5VM1ZlWnliUTRSMWY2SUJ0bndzVWk3?=
 =?utf-8?B?RVJXdlJWRzVMWEYxcWxFUGUvK1BzdlpLRlhJeWdsb3d1YWdET3o2R2FpZlli?=
 =?utf-8?B?eVNySWQ4Nm9CTjBUSlhra3p1dGN4VXFhYzFqaTZTbnJwMUloWGhwSVZydUIz?=
 =?utf-8?B?MlVac2hlUTlJSmRCQnNyWHpranIwRmhkYjVGMWQwRkNQZjdISUpueUdkYUVQ?=
 =?utf-8?B?M0lNNGx0ZkkwK0l2OHRvZUllcUlyMFUyQVVxcVhzeHd1QUFtZExkT2NnNGJ4?=
 =?utf-8?B?Smttam01ZTAwcmFpbmV2YWR6c3FWcWM5Y1Buem9OeTlhaFNubEU5ZlpmLzNR?=
 =?utf-8?B?T0g0dVJ4K2M3OGdhOXAyZmZvZ2pVYlFVc1BQOUFlLzdYbmxMeGVXdzVVR09j?=
 =?utf-8?Q?g5kYjgUQEKmBUKkKg7H2cZSwr?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Lq48bd0wnXU+ke75OxJTte8lu9s4G/vMn3TrdfdYcF8HolD0R1nOhk56I3ytu9d9YI5sasizUKofpxiJ1kLHVP/qqoBKdHR701J/p7LsmU6pcZ1AprWE9iyERNzG6svd8EK+h60ZCPQhxA1R4BX6cCjsVPea/+dVDezIJaz4i4LcDXv437ufYUmzsHar2qLoGZMNTzky5rNkRE66rn1PQ3p5NlzOutKuMCPzDvDEaPhs8limudrEAcz+u1ZukmAwptVr5CA4rqXH9TNRTMmD9mrwrty0rxB9pfzc+8nhNLTHkR4bwUD+6pvcxoLZGM+PdOROypnrMTqdlL+RV4IgodHrImmChUOauHr51mVMfhkPrDYKrLg6GoNE1FWOqXFcBrV9LOlxgCkie5NpKzVA9LMoZiuE8dSWimMwxCjtHpVdrUfo0HajnlGpY/Y9iksmfRZxiRPHCp9KRfcTV2/zTmVwuxjLU03oXrsgXtyTq65SeSMQh7Mgo2AD78RBtSaXTx9pF86hi6iIPS6IIGTcZsW+foh2hDLcSHXpnW1PcCzJBH1MvmKre3GoT3Loy0veViLEadnmJn0Dg5MaqDMVdUh2KBLBE0WkikPZLyQqWFjkA4ZngjoT7keDhBSTE/jugyw40Qll9yyKZgUfcpV3lqikJPuV6XpH+LskXUAyWm8KwRv9z6nvOb0gRuFAYjnpe7jbEc8G/ZzDxgXoANS9RmrVmv5jdsoher8uUWpTPHcHoXfS7hUn01uBTxVazBjVkXew1TzFROw+/9DvAoJO4yD0wrF972+rGjnC+O+NHpEFwtvC9LDCoxXt/VOw9x3m4fFJfqRGNT1XR8IfDGlerXhUfzLZsCmZeiAZ6cuKe4gITF60pomyctt+qp2z78a7
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a04e1b01-4661-45a3-0df6-08db4a5d1e93
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2023 16:00:01.0508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8blPDIMevQPEdNVKJqKRMgOm9QDeqf68H6ZzRHF8jOAd0hiYXoQ57lUPCgNmY4yaUwGZulvF8pDpya/QKbZwOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4479
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-01_09,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2305010129
X-Proofpoint-GUID: j1mqOxU8N6-f3Gy2mQ8A4xsHYsrH8_af
X-Proofpoint-ORIG-GUID: j1mqOxU8N6-f3Gy2mQ8A4xsHYsrH8_af
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/04/2023 22:07, Sagar Biradar wrote:
> Fix the IO hang that arises because of MSIx vector not
> having a mapped online CPU upon receiving completion.
> This patch sets up a reply queue mapping to CPUs based on the
> IRQ affinity retrieved using pci_irq_get_affinity() API.
> 
> aac_setup_reply_map() is an explicit mapping for internally
> generated (non-SCSI) cmds.
> The SCSI cmds take the blk_mq route, and the non-SCSI cmds are mapped
> to the reply_map.

This now looks better.

I would still prefer if no reply_map was used even for internal 
commands. As I see, you have two alternatives (to using reply_map):
- instead of using a driver-internal reply_map, lookup CPU->HW queue 
mapping for internal commands by using 
shost->tag_set.map[HCTX_TYPE_DEFAULT].mq_map[raw_smp_processor_id()]
Ideally when we finally support reserved commands for SCSI ML we will 
have a better solution for this.
- if it is possible to send driver internal commands on a specific HW 
queue always, then reserve a dedicated HW queue for them (and always 
send on that HW queue). You may reserve this HW queue by omitting 1x HW 
queue from pci_alloc_irq_vectors_affinity() for affinity spread

> 
> Reviewed-by: Gilbert Wu <gilbert.wu@microchip.com>
> Signed-off-by: Sagar Biradar <Sagar.Biradar@microchip.com>
> ---
>   drivers/scsi/aacraid/aacraid.h  |  1 +
>   drivers/scsi/aacraid/comminit.c | 32 ++++++++++++++++++++++++++++++++
>   drivers/scsi/aacraid/commsup.c  |  6 +++++-
>   drivers/scsi/aacraid/linit.c    | 25 +++++++++++++++++++++++++
>   drivers/scsi/aacraid/src.c      | 13 +++++++++++--
>   5 files changed, 74 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
> index 5e115e8b2ba4..20f8560a3038 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -1678,6 +1678,7 @@ struct aac_dev
>   	u32			handle_pci_error;
>   	bool			init_reset;
>   	u8			soft_reset_support;
> +	unsigned int		*reply_map;
>   };
>   
>   #define aac_adapter_interrupt(dev) \
> diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
> index bd99c5492b7d..6f4e40cdaade 100644
> --- a/drivers/scsi/aacraid/comminit.c
> +++ b/drivers/scsi/aacraid/comminit.c
> @@ -33,6 +33,8 @@
>   
>   #include "aacraid.h"
>   
> +void aac_setup_reply_map(struct aac_dev *dev);
> +
>   struct aac_common aac_config = {
>   	.irq_mod = 1
>   };
> @@ -630,6 +632,9 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
>   
>   	if (aac_is_src(dev))
>   		aac_define_int_mode(dev);
> +
> +	aac_setup_reply_map(dev);
> +
>   	/*
>   	 *	Ok now init the communication subsystem
>   	 */
> @@ -658,3 +663,30 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
>   	return dev;
>   }
>   
> +/*
> + * aac_setup_reply_map -  This is an explicit mapping for
> + * internally generated (non-SCSI) cmds which need to be
> + * serviced outside of IO requests.
> + * The SCSI cmds take the blk_mq mechanism,
> + * and the non-SCSI cmds are mapped to the reply_map.
> + */
> +void aac_setup_reply_map(struct aac_dev *dev)
> +{
> +	const struct cpumask *mask;
> +	unsigned int i, cpu = 1;
> +
> +	for (i = 1; i < dev->max_msix; i++) {
> +		mask = pci_irq_get_affinity(dev->pdev, i);
> +		if (!mask)
> +			goto fallback;
> +
> +		for_each_cpu(cpu, mask) {
> +			dev->reply_map[cpu] = i;
> +		}
> +	}
> +	return;
> +
> +fallback:
> +	for_each_possible_cpu(cpu)
> +		dev->reply_map[cpu] = 0;
> +}
> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
> index deb32c9f4b3e..3f062e4013ab 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -223,8 +223,12 @@ int aac_fib_setup(struct aac_dev * dev)
>   struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd)
>   {
>   	struct fib *fibptr;
> +	u32 blk_tag;
> +	int i;
>   
> -	fibptr = &dev->fibs[scsi_cmd_to_rq(scmd)->tag];
> +	blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
> +	i = blk_mq_unique_tag_to_tag(blk_tag);
> +	fibptr = &dev->fibs[i];
>   	/*
>   	 *	Null out fields that depend on being zero at the start of
>   	 *	each I/O
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> index 5ba5c18b77b4..077adbcde909 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -34,6 +34,7 @@
>   #include <linux/delay.h>
>   #include <linux/kthread.h>
>   #include <linux/msdos_partition.h>
> +#include <linux/blk-mq-pci.h>
>   
>   #include <scsi/scsi.h>
>   #include <scsi/scsi_cmnd.h>
> @@ -505,6 +506,16 @@ static int aac_slave_configure(struct scsi_device *sdev)
>   	return 0;
>   }
>   
> +static void aac_map_queues(struct Scsi_Host *shost)
> +{
> +	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;

I don't think that you need a explicit casting ...

> +
> +	blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
> +				aac->pdev, 0);
> +}
> +
> +
> +
>   /**
>    *	aac_change_queue_depth		-	alter queue depths
>    *	@sdev:	SCSI device we are considering
> @@ -1489,6 +1500,7 @@ static struct scsi_host_template aac_driver_template = {
>   	.bios_param			= aac_biosparm,
>   	.shost_groups			= aac_host_groups,
>   	.slave_configure		= aac_slave_configure,
> +	.map_queues			= aac_map_queues,
>   	.change_queue_depth		= aac_change_queue_depth,
>   	.sdev_groups			= aac_dev_groups,
>   	.eh_abort_handler		= aac_eh_abort,
> @@ -1668,6 +1680,14 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>   		goto out_free_host;
>   	}
>   
> +	aac->reply_map = kzalloc(sizeof(unsigned int) * nr_cpu_ids,
> +				GFP_KERNEL);
> +	if (!aac->reply_map) {
> +		error = -ENOMEM;
> +		dev_err(&pdev->dev, "reply_map allocation failed\n");
> +		goto out_free_host;
> +	}
> +
>   	spin_lock_init(&aac->fib_lock);
>   
>   	mutex_init(&aac->ioctl_mutex);
> @@ -1776,6 +1796,8 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>   	shost->max_lun = AAC_MAX_LUN;
>   
>   	pci_set_drvdata(pdev, shost);
> +	shost->nr_hw_queues = aac->max_msix;
> +	shost->host_tagset = 1;
>   
>   	error = scsi_add_host(shost, &pdev->dev);
>   	if (error)
> @@ -1797,6 +1819,8 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>   				  aac->comm_addr, aac->comm_phys);
>   	kfree(aac->queues);
>   	aac_adapter_ioremap(aac, 0);
> +	/* By now we should have configured the reply_map */
> +	kfree(aac->reply_map);
>   	kfree(aac->fibs);
>   	kfree(aac->fsa_dev);
>    out_free_host:
> @@ -1918,6 +1942,7 @@ static void aac_remove_one(struct pci_dev *pdev)
>   
>   	aac_adapter_ioremap(aac, 0);
>   
> +	kfree(aac->reply_map);
>   	kfree(aac->fibs);
>   	kfree(aac->fsa_dev);
>   
> diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
> index 11ef58204e96..46c0f4df995d 100644
> --- a/drivers/scsi/aacraid/src.c
> +++ b/drivers/scsi/aacraid/src.c
> @@ -493,6 +493,8 @@ static int aac_src_deliver_message(struct fib *fib)
>   #endif
>   
>   	u16 vector_no;
> +	struct scsi_cmnd *scmd;
> +	u32 blk_tag;
>   
>   	atomic_inc(&q->numpending);
>   
> @@ -505,8 +507,15 @@ static int aac_src_deliver_message(struct fib *fib)
>   		if ((dev->comm_interface == AAC_COMM_MESSAGE_TYPE3)
>   			&& dev->sa_firmware)
>   			vector_no = aac_get_vector(dev);
> -		else
> -			vector_no = fib->vector_no;
> +		else {
> +			if (!fib->vector_no || !fib->callback_data) {
> +				vector_no = dev->reply_map[raw_smp_processor_id()];
> +			} else {
> +				scmd = (struct scsi_cmnd *)fib->callback_data;
> +				blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
> +				vector_no = blk_mq_unique_tag_to_hwq(blk_tag);
> +			}
> +		}
>   
>   		if (native_hba) {
>   			if (fib->flags & FIB_CONTEXT_FLAG_NATIVE_HBA_TMF) {

