Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9FAEC001E0
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 08:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbjG0IDy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 04:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbjG0ICq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 04:02:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA422D68
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 01:00:21 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36R0s9Dv018913;
        Thu, 27 Jul 2023 08:00:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=krB/mgaUaraOtPELkNXMT9nekV3FqeC/EBHWfsMzuHA=;
 b=S8YgTN1rS/idD5yRdju/AvOIu/P3MUoj/0SWpXFJ248Wb2Y5x34w21FEhf65NsoO6hct
 ax+hnHnn1qCUSAj44EEyMh+AdavMM2F3jrhltmq6WaYUjY+d5YvX1vFQcaeTjP8Mo5FD
 JOWOrweHU9FXWsx/jWvQra8lI0IVETQUtL5L8NRUyhYWukkxfbX7OV+4ZRHZNBC8KtgZ
 Mj6NDCQijcu86mWmu/r+0MfgMQV98LoL2dfhrTQw+yIJ53oINvuUyzweMfXaMNyBpN/v
 VUJRSBSUpPlz3X+UAojfnOU040K47cZI1ZyYFBeGwdNeU2jcGaWXPFB6Wm/DzizfFPeW 7w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s05w3s64a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 08:00:10 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36R7gjB4026224;
        Thu, 27 Jul 2023 08:00:09 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j7sxdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 08:00:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TXhEKLAkUPnwVa0cI5/2YSwPyEUj1I7PE2K/jKu843j2+CC2gQkefRZgsB7rU5QEV1rEBq3BDElEUofgN0wsReJPs1OEq7SISRO06iYBpEfpzVIcR2CHQ58oyMk1at6DuSVzkyU0/YliMHlUFeYkKekzaL5p3wj1aGDcf2YCprqdA3iLf9jfvUqjHRV2AWpToR7y7MchMmlVZJYHDK1gD33QGZEfWzodc2qFug0sNIIvrixo7TJRCNkGa0DYlBfUSM1Nj0ML2zPcCHlWN3rOpmqH95mqkP6w/F591p8FIgA+55BNr1EOwd8hqIOr8+1slQ6OR+G2Dwv4aSpk8jho+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=krB/mgaUaraOtPELkNXMT9nekV3FqeC/EBHWfsMzuHA=;
 b=OpcRFkRc+FgBl4KL4KqhXap5LtSNwGWNjZJx+6YBjP/CvovJMIkQs4DcrjQPTLLkn6TAVaNaj718qAt3N73YK8Bxe4EjVe35hFxKBtnzXsE/+2dAl1wFYXMWJEhsgd91Oaaz3el9Bgfl1f5cgeucKrflHwOaOWxh7+GHJvBRj9qt+eeIUiHrrQ5YrnsTFflb5+bJTHyn6B2hNjyGJhqIBl+6LJEWS8/1zz0l6dYRapGaE1Fc20NttVjQxO0P27byLM7QSdYPnOCTsWPV3JSqJqCVtTQK0XY3FzoE8w1RUpzFtpag8ePluBzSEnfOa3kPJTRUFjICTMamCmDvxJROcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=krB/mgaUaraOtPELkNXMT9nekV3FqeC/EBHWfsMzuHA=;
 b=d05xvRCb9h9f2m4sV4Y6gbrsr00O1NGQinuZ5YppaSymDqdpupsTLvjYSkxvsGyGDqGjB4TZlz8HUNzQiHq1RwTn+JNwaqQdAGzEqIJd/rOsgELm2nzyBKoK2jhitFfQyKlevD74hduINNX4Z50XiEy/n+TnzJkJhMqv4dote6w=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BN0PR10MB4839.namprd10.prod.outlook.com (2603:10b6:408:126::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Thu, 27 Jul
 2023 08:00:07 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Thu, 27 Jul 2023
 08:00:07 +0000
Message-ID: <808d3cbd-cd77-b283-59ff-e34b8a504053@oracle.com>
Date:   Thu, 27 Jul 2023 09:00:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 23/33] scsi: Have scsi-ml retry scsi_report_lun_scan
 errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-24-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230714213419.95492-24-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0012.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:150::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BN0PR10MB4839:EE_
X-MS-Office365-Filtering-Correlation-Id: cc9729c3-14bb-43fa-3cfb-08db8e777e0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +EqfHn/L/EFO8Ck6H2FxPa740/YdDvg3G2ThJBPyNxtZDzpxSkPhVBMgj6B5KEgySFsXeR3bIoiaSbUdYposqW98DwJoljb3qNZLDlDlM9IOSGdJ/RE8hGTzWSK6WuX4g8rLFnpSS9Pp4bbPQUpVIRVPXaVur97wJ8arOITsCSHjCIsI7HE09xIl60WJwaruDem5PBsnmrtLtkXvg8Df3sEObWc9WG8/o87y+4Nc72ONwW6Sz0iG4sj5qBU/uc//V36pfCEWSwbbS1EaypNQF573EVp9f1RPLzl2tXdeo2uLYC0Ui2eYOU704RupuBif14M9bUJvdmH7rTXX956x2dCwcOvqbBuqTaZgTz8uqbbHpLjvm0SY2v7WW4oGAkPS1YXYTXXgUn+Hu+YNUNwj7nJyWRhTAl/cmpMf3srdNqF29AwpOXXAcLoIHLEzmO7VLyyjiObAkx6sZurORegu0+yMtYStf7fJJPa6Kw/B+OqCdW7dod2fTEfajIhsWSRkPT+PliupLe+isAz2VE47q/g1v+YkJ+e2wzFkno90VOfmqIQZORG5xovwYHgRriUn1gsB5YupMYHSkgbzKBpdR1SCUVzu3xchGVm+yUT45HLGGKSOK4HENLc0+tANqKW2IS4t7S49P85/13rtCOZXdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199021)(5660300002)(8676002)(31686004)(83380400001)(2616005)(186003)(26005)(53546011)(6506007)(86362001)(8936002)(31696002)(6666004)(316002)(36916002)(6486002)(66946007)(66556008)(41300700001)(66476007)(6512007)(478600001)(4744005)(2906002)(36756003)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UEZ1b2luMWJlbEJqSVJIbXBmUXZ3RVVpM09sb3ZEcURTVHBIQndla1pzbUV6?=
 =?utf-8?B?TXpZS0FtUmFiTHljTGk2b0ZWVGNDNnFiTmpCQ0RqckhLTlVPZEQyeHE3V0dH?=
 =?utf-8?B?SEI1MVRPWnByY0RYRkoraGhMTXpOR3JSczNSVDBidUdGNXMxdFJGY3VSZjIy?=
 =?utf-8?B?bTVGOUJhZEQrd3hZMlJPeTgrcndGRmhKSzVIdFJ5RkhBamE3cjMvUlI5V0RD?=
 =?utf-8?B?bUNtcjlMZlV6ditxYU5HcHlpSjZUdW80TkMrNEtqQ3JOVFNibUptKzY4K3Ns?=
 =?utf-8?B?Q1QrY2I4aVY1a0FVOE5rSWRydDFwRTZuWGVKWGVOdi85OWxGTXhkTitLSjVR?=
 =?utf-8?B?WEhWMHVTeXVhNFpQUTl4eFp2Ui82eVFzREZvbEY4Qkp6aERrVTlYL2xReTZu?=
 =?utf-8?B?Y3p3Sk5rWHhCdmxSNFh3T2FjWnZHTHZoWVNsWjU3SXFra3pVY2U2aUVNclJz?=
 =?utf-8?B?K1hGeHRjNHBrdTFHRERmS1F1dTVLbkpKYzQvekhVeUdlWGFNWnV4d1dUVW1C?=
 =?utf-8?B?TzBjcUc5cEduVFI5Skw4T2MvNFNpU1p2bG1qRWRhOTZkbU14b0s0ZWZXUVl1?=
 =?utf-8?B?bklpbnNab242aWZyZWhMNXdYQ2dZaGVONVJ5OHRPUjZjNWdYVktaZW1XWkNZ?=
 =?utf-8?B?ajBvdFh6QytIN0ZRVmhNTi94anU1R2s2Q0JmYkMwQUU2b1A2Y0JpVlczYkN4?=
 =?utf-8?B?dkxoWWt0cEFKSGc2WG5qYmU5UmsrOFB3d2RGbkZaM3dvQ1lvQmxBZlNoWWxq?=
 =?utf-8?B?eHlqeVRsQ3JYcG5zdEg2ZFBnUk5rRk4wUlcxS1Bic09qZm1ZK3hpd3o1aEs5?=
 =?utf-8?B?dzZyYXh3S3B3Tk9jUlQ0aTY4bkdtdzE2L2dKOWs4QUN2UTRYRjFrSllXSDVO?=
 =?utf-8?B?MmZRdWVzTEdGSHprZlhyTDIvSHZSeDBPaVNHaVA1aENKYUJwdmFVK0dJM2xE?=
 =?utf-8?B?Uzk0ajdOaXdlQW1GTU1sQkpoOTBjd1BUaWNiOXNITWI4K0liSXJXa2daZWJZ?=
 =?utf-8?B?V3B2WDhkdzUzRnpPZk1WME5FRnZvVm1zakgwV3dpOFBtS3RmbFZvZTVHb2xR?=
 =?utf-8?B?QnJCOGpyR2VrWE04ZHFTdFV3dURxdXZmdWZpR0RiNkRYelVhMHRZM0p4dldq?=
 =?utf-8?B?K2NtODFxVndBVFNNMU9oaUFYY1cyazEyelI4TnJLRkN5RnNLZWlKN3R6N0NP?=
 =?utf-8?B?VElFTC9QSDZIRDRuK2JYUStZKzlLbUJBaUNEemswZE5UeGJkejZqTjVpemdJ?=
 =?utf-8?B?Vnp1bU0rZFJIRHNUenJxL1hxeExsVXNYSEVBWXZLdSt4U1RMcngwdFo1NU43?=
 =?utf-8?B?ckZZM2s2eGt5U1FQZnFxdGFrRVB3K3pOcGJEVTVnaS9FYWR6Z0RJNEpBQWll?=
 =?utf-8?B?ZnF1dCtLYzZiQnp1R0xpY3k3M0p5KytGU1RZSkZnaFdjcXZKaTNNdGxwM1hI?=
 =?utf-8?B?dUZVSUNWNWtaZk45RkpjWk9lM1lSeGVVZUpCTnI3ZnBJK1RyakZXZGhXS3pD?=
 =?utf-8?B?TGErR0laL051UkV0UGt6Zmo4ZmZWVjgrZ0hCNGMxL250azgrblk3YklCOVl3?=
 =?utf-8?B?dFgyT2taMGcwa0ZDekt1Z0dTbThtQ0h4MDE3Z2o3djNlK01hSy9rVWswZGtH?=
 =?utf-8?B?cEpmc200cFNFQVdJKzQwV0FPMTg0bjhaZkFkSEJYRWlUSTBGRHVoL3hQR1ZH?=
 =?utf-8?B?Z2NvRzRPQkJGS2FXNkY3R0EzcFdnTWR0L3AzTWYxbzYyb1AwMktXcnk0cVA2?=
 =?utf-8?B?enE5eUhaM0thakRmWTlIRmJkdmdtWW8vYWRha1FoTk1HWFgreExMcmczYUJk?=
 =?utf-8?B?YjBHS09YMjRmelVnVkR6WXNVakZKSHVNeW14MjVrMVMyWDRNVm1HbzM3R2ls?=
 =?utf-8?B?VEJURU43V3BQSGc4azR2Q2x5ZFlQRXdxT3p4M1p5eFdnRlNxRzRtRVFJdTBD?=
 =?utf-8?B?TGNGK05zS2ZIK2tpcjhNTUJVYVA4d3BBV2JiYXNrb1lHZE82S2Q1TE1pYitr?=
 =?utf-8?B?OVBmdWtLeDUyMlJMcGE2YUc1S1FXWWhTdHZnVkhiOVNzN0JWd3RWMzllZ3pS?=
 =?utf-8?B?ZTV5Zk1MZzhaS25EUFpuV0o5Y0UxYXNrczduYi8xRW1wc09FcnBBQnEzQUxE?=
 =?utf-8?B?aVpmUE1Rakw2cUY5QUR0VzN2UUlXY1FHek5WRVNKRFR2VTZzNzl1M2REQWtZ?=
 =?utf-8?B?c0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: XVINFuU00XTgFYMkJNEy1oYMkR0d3OAhLqfwFl0IJoXgPTiftP20Zc484oGEGpKuYMjVU5tKWF/8iijMP2POqcXlI72LEXH2J40pDtvfMkv8bn2u/NwWgdtMjd4S7HEtou+N/xpJ7LKFr8yi5wPIcZheRkfIIPdpzSl/PIrGzsnfIdKR5Dt9thZXX7HIOLlfSNADXn9WQYcYpuDat/6yQjWOGAS6U0vaCbWa14tXOn3JWRn2HYBVR797ICCoY+cJz3X5OoGkhrcrv3bOyagRQvBTTUcJ0LzkEKvGR5SOQzBIYVIA1GUZJc0aufzSnqIEMYK2FNXlQ9v6IIyFVYjt0qC3rLeAUGE2boWfmaMcGaMQsj349bzkq2Jeb8sC4fI/yY2WrRs28GHdgNMB6hVQsVgMCsYqYrzzEYsPvaszxc8q8mE8nyMk7aBswkmZj4O/ZVUXym41c20bJWpFK0TvIhdDQqMrfWL6ehWW//kQ2ZkJ7DnIEWuhIKjh/KZ3t+q+8tVlk/D4VB8JFrDhFZX4LQj8Y5/roHwWXZ1E4Cz6cWDWxocDDjnLnKB1SdvxbSwqd8HCrhSRN3VL8HrQ5ODxNyVDKJy8Ipv30DvFqThMetIJVQZGQJOCzk/OzUVv5sbGc3syjZmLn81CY2DtLs9Vv9SbrVasH6VrGC9pu2GWtV5DIOeQKttKo9bYhBbOYDtKWhOJm4jrShrq4n8k2wAj077F+exQe7zlfEqFeWnnm0U9QOVInHto9Pm/+7E0Sm+kU0JDSq+7SXZlapU0DFgG45RU4Tpq5o25fViKGMmszTViivoDCNVMSy/5D5FDoWuR8fEIrqAjNuvc6MH7bhqOTmyV1CUZB5UbsBVQMWw0Mvfi62WgtDRnVAbdVpuBXCuH
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc9729c3-14bb-43fa-3cfb-08db8e777e0c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2023 08:00:07.2138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iUWmDjk+ucwLc36uEuFTiZd0IRS4b7QClYhvxRd5CvYqCo4r7XbR7dom+lVxr83wqAszelYSsUrE6dcYRcIEaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-26_08,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307270070
X-Proofpoint-GUID: RWy1Xf_Zmi1P8pHvTI9BTWBoJ3RvFeK7
X-Proofpoint-ORIG-GUID: RWy1Xf_Zmi1P8pHvTI9BTWBoJ3RvFeK7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/07/2023 22:34, Mike Christie wrote:
> This has scsi_report_lun_scan have scsi-ml retry errors instead of driving
> them itself.
> 
> There is one behavior change where we no longer retry when
> scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
> for failures like the queue being removed, and for the case where there
> are no tags/reqs the block layer waits/retries for us. For possible memory
> allocation failures from blk_rq_map_kern we use GFP_NOIO, so retrying
> will probably not help.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig<hch@lst.de>
> ---

Reviewed-by: John Garry <john.g.garry@oracle.com>
