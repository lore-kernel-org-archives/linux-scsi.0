Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BFB7C04FDE
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 10:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiLIKN1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 05:13:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiLIKNW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 05:13:22 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873AB389F2
        for <linux-scsi@vger.kernel.org>; Fri,  9 Dec 2022 02:13:17 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B97nj8Y018277;
        Fri, 9 Dec 2022 10:13:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=24MWjlAXbWCzNUVs2bywfiOmeyqqLHeszP09/niZdAM=;
 b=JISbIjC0y0l7Pe78SjGfu6s4/2o2ygdvXgxUEM5Wgafcw8AdITXlA4+zG/5+z4Z48gu6
 7XPqkIOQ8VukdPDBUU/eOCBmqL5VC0NBBPaSXzgP31Jzr1LSRtKd2j2TRPrO98hIFSRI
 yKR8XlWU+aFxJwbkf2LNRRCRoOhyn2CV9FKiHMqF86ACiyc8PQHClsXGL4WHOiy8FY6i
 Fq9Ue3/gFQCEvfNQiYm7SlHls+KvcVq2kQGvIsiy/pCiliEsmwkaiW2UHerZQAtdLSFw
 eslrNru2zZPWA0eKwyoui652/MQ8YaQ8zD/mGWEnq3qkYttV2kXnB+cy5EXPsMbF40pg iQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maujkmpru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 10:13:09 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B98HSnJ019722;
        Fri, 9 Dec 2022 10:13:08 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa8k4tmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 10:13:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cDYyihZ/XXveylTcihpJB9KuahfojguceGd8yn+VByz3AqS15whq7V9AnnqxAymLiqgSecDK3uzMXF2AFtbNolYfgaKiKd9PxurhdB+JvvmMiPJiiWN3fCoFNHTalD0G6btpGZAvjdYkqHzNaYDdENJG2HqnxWHVMTVrk5B9q0zI2fifnzpKGfvH8Ws72eUmFWW6INxY0rTQWtcUyvlKiTPclSU7OtQa9L/U+X4CAhZQj6ho5v1as2hMMogPZpVsjclO9tMPGprmqZuiIeFp60xfZxo89L6ILvh++U8efZ16VGjT5m/jJ5pkRo3f+p4cSfLNsu436MMbRaOBmnxCRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=24MWjlAXbWCzNUVs2bywfiOmeyqqLHeszP09/niZdAM=;
 b=IzHDJlvwVuNCWmGbc7ObXkOE/MIX3ffPTXpeMrpRzPl3WeFbRcP1Fxu0/nX+nutbYUCY7s8RXXK62Qj6fZ/0cr9u6PtQ3C9eVhkVSbe0p3/HYQr7KCT9oUuLP4VFv226Pk0MIvUY5xIPgBYXrCuZrHzCUl52nUkKWdWwGmUXVW3PWnGBAVNDiA584gkVvpQfP0+Cvl5hoC4Hcs4d9Oa7SD5gRmRJ63JRq66SuBzYYiZtUYxdSoohUocImLAZ2rVAdLQhDE3517kEnJ0LbdddUmlt+tQH64n5qaSILVMbxHodfLSUeW9IheAojlYxcBpLGQGYl/kNXXGEal1JKra+wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=24MWjlAXbWCzNUVs2bywfiOmeyqqLHeszP09/niZdAM=;
 b=UltUoK+t3XVVDISB/Jh92jk2815sRnnIB3hGENYkuC6aHpEKT6mYe+UPfecuTKvxJABKZBKQPqaSBreZ7xpHaK4Ryc0qvq2k898W2YRZlm5VlPrpO/UCdmGCbb0rK/WKTZ5HHnZPPtW6F9pbiruQk8XDMCrX+HDEsAflLGhWEEM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB5927.namprd10.prod.outlook.com (2603:10b6:8:85::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 10:13:06 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5880.018; Fri, 9 Dec 2022
 10:13:06 +0000
Message-ID: <b4f81013-79c4-6e17-39cd-306d984a914d@oracle.com>
Date:   Fri, 9 Dec 2022 10:13:01 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 09/15] scsi: zbc: Convert to scsi_execute_args
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-10-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221209061325.705999-10-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0047.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::35) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB5927:EE_
X-MS-Office365-Filtering-Correlation-Id: b67b8dbf-6820-42a2-1fcb-08dad9cdf721
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dNndoFnvskGHIbV0WuCt32uJtwf7xpQBgBEBeiqBXyEhR+VzuuCHhTLIHbIIbFBngTHRp8DBLYTNqDrIOKTo6L9Brq+q1YJUF+i46nrGeKF+gn5Q1XxUcg2VMwV/AjirWfDcx5/3vyhISsTx+DY2JJRWPXjUa1HTu7SBnkm+5a6xkEwXuLSq+V702C548HXw5Z2VrEWzw5M3Ga1Bxm/TXP86t50DP35uaKR2H0DwomiogYKD7qN+FIBECSnmm1PIUe5a8jS+hoR98D5Vs7QLEuOHeXFoNj9C3OiGdZkPokomgYoV0F4fSJK0xkHdMN7ZJCGNcjtYLRdaQ/rdyDoseJDVZ6KK5kvH9CnUz6iaiMHh8k2VtToKKLwVPzZAXyewBZZ7P2oOiTlyxHcQp/qIGFZ0CJeWIfVHIv2bYqIkfD3Els3uZ/9JWQ/Foqz6EKA8nZtPx9dfo8fLkBdIvLr8RB5/wqLgvKWNFcT4g9i4uOU68zlSqHYvaOQ9HABACpzCF4IQBJ4DibSb0ACA0XNqF6q/UC9bV80yRy5Eb0NHegCnbCpYS6m82nmO90szoAa8/cWII5SDoG3dqLhPuNlTsm/t0mf+wWQQF9nliEUSreMlX338f+c1f/bEG7YaEuojRdsJc1ZeWQBXwy9tkXy2b/u2ofGvMq8fSgth5ThSpsg1Vg8hXPXP9CFmS4x7EZJkLnwk9J8q8Vffi3Zqa8DYKwmkxHzGfx2JyhzGQl5iEoA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(39860400002)(396003)(136003)(451199015)(2906002)(31686004)(5660300002)(66476007)(41300700001)(66556008)(316002)(8936002)(36756003)(8676002)(66946007)(558084003)(36916002)(478600001)(6486002)(26005)(53546011)(6506007)(186003)(31696002)(6512007)(2616005)(86362001)(6666004)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UlVZYXNObElWa082NzRQZWVETGpQQ29ySnpVajVMWjRvb3hGV1ZLaG1Da2tk?=
 =?utf-8?B?dWd2cUJvbTg0STRaYno4endXRktBWFBjWmVyMG5KN29xUVhtWnVpZ3ozZGhk?=
 =?utf-8?B?aVAwM3JMOG8wNEo0bEt4SEc4WVlNZDNWZTZUUUoyTlQ4angwNFFjcnh3NmVp?=
 =?utf-8?B?OVYzS3BzSm5BdUZ4TVRRVjBTUWhaeWVlVEs0a0h1RXdodTZqNjJNK0VETVpO?=
 =?utf-8?B?ajRpS2FHQUdwODlHT3NxYUpGMjhGL0NRVkwza2hDT0pwamVVMHA0cWsvdGUv?=
 =?utf-8?B?dXVLU3p5QXBXZXRaU3NKRU5xeWxFMjFad2g1T2pJRmtZU2VJOUVJTE1VdXRX?=
 =?utf-8?B?M3hsOWJrcm0wWEpRUTdNc2J6ajB0cTVVMkJDWWg0aWtKR09KZXBHNGtYek50?=
 =?utf-8?B?RUJPdDB5MFI2cmo2empSY0dPbXNGSm4xVXYvMnh5RzM4cWUyNkZLZi8zc3o1?=
 =?utf-8?B?ZDI5T21tTjRFU3lFYkZJanVYMWRiOTdtS2ZxcEJOczhwbDd4eFhzZER5WGYv?=
 =?utf-8?B?bk4wMzJoN0RveDYzWVFMV0tSdGhtRm1FRENMUHVxbThvejlpYWRWYkNPY0Yv?=
 =?utf-8?B?ZU1JbkY0d3NjMHdhQnpmb3pRSFJwY0xjYytVbGpmZWcxcTB5dHhVU3dKdDlH?=
 =?utf-8?B?STkraHB4WDJYbFo3U1lyYm15U0RkOHlmbngvWnZZUHlpYk5PMWFWSThoQi9Z?=
 =?utf-8?B?NTdzNitCdjYzeHZCaWdPSGQ4eCtsVjhPME9MbkRFSEMzMDBNbHNHTnJacFR3?=
 =?utf-8?B?a0RQMk9jcHpuRGxyME92bEZoZzc3UndQczMrUDBmUUZxa2ZIdkZxNHFGU1p3?=
 =?utf-8?B?V1BRWVAwTWhZSC9iTGxnQi95SDhHaCt1Y3F1NkVQN0hDdXdNT0grUjAyUGhT?=
 =?utf-8?B?QTJOenNSbFlHdjIxNDE4cVVHc0FmYUc5R0Q2ZGNQNExQM0FwbjBnamlETmpM?=
 =?utf-8?B?UDE1L2ttaEpnYmcxUFFvMENFSXZibFZYL1BwNTRoWEZqRFc4Q1hmTzRIc3BK?=
 =?utf-8?B?eVdubEhjMU50REM5OFBPRHFSRmlFRGUyOXB5K0E0OGlPZlZWSFRlbktDUjFx?=
 =?utf-8?B?dG83VkJMcTRBM0NjZTI0RGZCUmFDTERmdjRyelprNHlOUmlDZjNsdzZVK25j?=
 =?utf-8?B?RUlsaDlkWTRwYmljTVRzTFo4SzNpS1JmdGh0cElJU011NWJrYnNNc3VVckpq?=
 =?utf-8?B?VTJLUGsvdkJTQkk3WExhU3prWTVmbVN0aFZhZ0JySnZlRjd6eFRPTGs2akxH?=
 =?utf-8?B?OVI3NG53NG0yY3g4WlNFdXlLZUlXZjJlQWFwNUJWSTFPZW5NYzR4Y1ZCR1E4?=
 =?utf-8?B?L3hONFNFbk9YcjB2YnZsa1hGN1JEbFU2b3VrMmZyTkQ2NlZKcHhSUjZ4K2xI?=
 =?utf-8?B?OTVvajBySFFCYTFhWE1WNFExTmthTkhEMWtmdFVjZGlnQXZIWkR1ZWN6bUdN?=
 =?utf-8?B?L3RlTHZ1bVlBVUlvZHhtRXBwcFhsd2N4eEI0bStnOEtuUmFta1NjcTVWeFZt?=
 =?utf-8?B?M2RKU3ZLcFVqTG5GWXo5c3ZXZzhRaXJSMzZ2YThwRHhYbFNpWXVIdWg4Qmgv?=
 =?utf-8?B?dHNaQlA2UzlMYmlJSHhISWtCb2JtVDd5Y0d6Z3Y2Ry80N1NxVEhqMWJmQVZn?=
 =?utf-8?B?YWsyUzQ3Q2hXMVUvOWliRkhSdnFENmVFbWZaWUJ4K3lCRHIrTEhpL01yVUNx?=
 =?utf-8?B?N2RRVnlreEpZUVdLMDhpU0pYOUN6MGxuUnN3Qit1NHRTVXBsSlVBRjhSeE9H?=
 =?utf-8?B?MGszTU5BM1BFMnBmdFZSc25TcCtkdjJYQStYdUk1SkNsUzFwZEk0Q3NkSXNO?=
 =?utf-8?B?N3VxSTBMYllsV0E2eWIvQXlNMlNVeW1pSUtPNGcrc2lLL2RJaHpDQ2JzU3dm?=
 =?utf-8?B?WGRCZkxWUjdlZTlVS2tOdVlaYjQrZmJtVEJBR3hoSExhYUpVSHozZW44akcy?=
 =?utf-8?B?b3RTTWR4Y2c4aTgrTTVpWm9TMElOUlJpMFVrbEFmMmR1UDNwVmRldGM0VjFB?=
 =?utf-8?B?YmFRSk1kOE5VU0RKd1lUUHJlbGQ4azR6M3c0a1ZmVzcyZExtelFGVzBjclBG?=
 =?utf-8?B?czJnQnprNTFKNmJpZ3hXWU1hMUJwcnlMYU1vb1pISTRUTENvOHZQdWRSY0w2?=
 =?utf-8?B?R3hwL0NmQ3hqci9mUDIwSm4zTS84cWIvVHZhVzFBNm1uWUJxbm5zR3BwZ0tR?=
 =?utf-8?B?OUE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b67b8dbf-6820-42a2-1fcb-08dad9cdf721
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 10:13:06.6512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I8Nuy/ntpoj/j9zPbCsc8i0upGvpXHi9shzv/Na5X2+p545TFVPPT6onaKjxY7txu72gCRGbJVRGLw8iiHD54A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5927
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_04,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090066
X-Proofpoint-ORIG-GUID: j0kT8ugittYLVwYwk3LX2aEBtWJolX6h
X-Proofpoint-GUID: j0kT8ugittYLVwYwk3LX2aEBtWJolX6h
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/12/2022 06:13, Mike Christie wrote:
> scsi_execute_req is going to be removed. Conver zbc to scsi_execute_cmd.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>

FWIW:

Reviewed-by: John Garry <john.g.garry@oracle.com>
