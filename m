Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6633DC001E0
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Aug 2023 19:53:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbjHBTxy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Aug 2023 15:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbjHBTxx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2023 15:53:53 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826E419AD
        for <linux-scsi@vger.kernel.org>; Wed,  2 Aug 2023 12:53:52 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 372HJ8cW031643;
        Wed, 2 Aug 2023 19:53:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=PuMH9KyRmALGLu54zC46EtCmrheKXjDAYDWtTmFuXwE=;
 b=KT0QcLTD9rjJALPDFua02Zy4QtDa9VOUXMiK9sbC61hkBk2Seaov5cdxp/LzyC1VAJkc
 GkiFaw1chWEdhdfDSQtMcBI7qMP3RnxOIAaEuC7fFx2rjmoOO/dhWiROIKe3BBc1I3aW
 4ihz8pX8mHFtV4mM0JrexE+jHKFgR0VBlv7NHCxZPAhbqy4qOnSbuCZP6PzbUdpc8NGs
 l2TW/lFlRQ4WR/H9slGJNt1uXLCczPhAhLR5OnLcUTJefz7Uslji7fr5h73ntOMI1eM3
 EQfoZTAxzg9FxWdVsa/Yx3cvNh2vTz47emp5yjQcwRoP5bGnfniX1Huc2ZhJsMNpKhcN uw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s79vbt60h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 19:53:49 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 372IV1tK006670;
        Wed, 2 Aug 2023 19:53:49 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2044.outbound.protection.outlook.com [104.47.74.44])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s7ewha9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 19:53:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ec4Acm2qNFtUWlAgqyl0HBa+iG65r/LYMq1Y0jpDLeSvpZDkqRFQcydxqp9G4uiZZxfdWBL940g2b0Y4UiRBJuLnsefLVbdndx6+N3yboQO4N3T2aRkmzwpPWLxFxkAahbd7mWG0mVubbX3AP0f/nn0j43Be+h7APea2D12OfWuttdedssqKMzwoYcbtXJwjGx/hSPxWmBCXMO0CFcTEXI6LuVqjhQv8AMQKZBT5a37lWpbG7BOqa5KkGORdcfOv1H1PtEZ5g/znBoeVjekO0kMTIxgwqEBOLepNAvzl86AdYiFHckNOcccbbYeNk6S8aDTLQvHwRfaYQLStyeA35A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PuMH9KyRmALGLu54zC46EtCmrheKXjDAYDWtTmFuXwE=;
 b=LcsJ76ZvZpBn42VuQuK1QigxdTJ7zHxRziMih6hvv3Dt53Y0JTMSG/azGsD+VbXhS8P+mAeEN3eTXnz1Jq89UbO1kYY6QUbF/hSqdX4P6ZOed5pxphOGrik+UjMFg4QtJfmp4xUn1hr1Kcpy+sXp1RQRiDuuwuBhrXa9r8rxfCgGCEffZzr/0PtQAQtsvIKPBtG4u5mkU0L/g4X2WNlbSMIe3FFzAhsyD+/D0ZtAHdzfvMGLbjPUqPkxE26hSxo58fD3FdHGdIL8M1kC+badkJ338kpJEQx2JOcvsa2kt9hQ7hO2jox4PTSD8el3yyZ07P+kP/qhsOjtGO/NwMkDYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PuMH9KyRmALGLu54zC46EtCmrheKXjDAYDWtTmFuXwE=;
 b=SszNYPztwN4NIjgm0KAVWcNOvA6NVNuLR1nkeO3vx8YLAHejzxUQ0eibPDaavaSzIm3qb00xlDRIgcFazQh3Vc2qdgUmUxNlsiI7OBufYlgmzaQLQlG211r4S8/FuXjXtatL1N0hqUQrlNN7U/HiPD4LcPsOsl/AiEKudCzreXA=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA1PR10MB7830.namprd10.prod.outlook.com (2603:10b6:806:3b1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.45; Wed, 2 Aug
 2023 19:53:28 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::31b3:ba23:4678:9f5f]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::31b3:ba23:4678:9f5f%7]) with mapi id 15.20.6631.045; Wed, 2 Aug 2023
 19:53:28 +0000
Message-ID: <f30e5221-594d-6bba-9c65-88390b1ed45e@oracle.com>
Date:   Wed, 2 Aug 2023 12:53:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 05/10] qla2xxx: Error code did not return to upper layer
Content-Language: en-US
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com
References: <20230801114057.27039-1-njavali@marvell.com>
 <20230801114057.27039-6-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20230801114057.27039-6-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0125.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::10) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2943:EE_|SA1PR10MB7830:EE_
X-MS-Office365-Filtering-Correlation-Id: f03a4427-de41-413f-a914-08db9392242a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zClQ5sKkbRQrOH7oL75a+PCmbmmQkw8qpw/6/BTA3xnMFxkca1l/YO3glFzvBtlMbzi0kGPI9mPZcahBSIV2JYuYEb3WfWxQ9RBTpnfGW68tp26zCDNen1J0dJRI2PH6z0TP2MdtZS4ZNPlTlDKaLElwh8gPZQmKjA4qRgnrDKt5PW8e/4Q6Ehiby3EFYaVunUDUoZ+Q1Ohh4bLtTgrOHuQcGiF8AxVJRjmc6B/I1IJFmlEC2xiusAiKrwqIlG8tyucGXMqeKA9hgkaxTaaRX+hBQp/1caq7Z+UpxLgspgDic4sQ3RUUwegMXph7ggzWedUWKvNvzu0A6FpjjRw79FzBF2L0o0R09g4zbTUsrb1whLXymoFQK1pf51zMziHtiuNs8Ojn8MKD8ttjVvkmuwtfAJKMNAztsPkHcNcQmztUH67bRx3dBvWX91Av5kcD7w7435H/4iHGB395E3fRv6BCFnmfM1Pabtix0HDR6/LnR5nJkIdNtspD0u4UOZ1DStcnPzmVeEx6nXtLfHeH3c7dA4Ez/UKWWYKwaDDTSwLVMRPBgp0jCjsWtyVVxENFov967LsoCo4ZMBFiEsc3sTPHWajc3LD3sBPVdnitXvsPJy/4Oe6Vj6sZetV7GZ0GlwQLl/geuG4gktRTDgInCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(346002)(39860400002)(136003)(366004)(451199021)(36756003)(86362001)(31696002)(478600001)(6512007)(36916002)(6486002)(8676002)(8936002)(41300700001)(316002)(31686004)(5660300002)(6636002)(44832011)(4326008)(66476007)(66556008)(38100700002)(66946007)(2616005)(186003)(6506007)(2906002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YU51cUk3ZHNtZDBhWVRveFhxZG1Yc05GYUs3eEdzT1lOWndSQVF0SDNkMkMw?=
 =?utf-8?B?K2ROT040SEpaNnRzc2VUeTlmOXFSSXB0MVljNGlhaVRJVXNvY3JMQmxLRGRE?=
 =?utf-8?B?TlNMNXd4OFp4TTdIa3Z1Uk95KzJDalpWZXB1elBUaDFpelBNcW8xVWJtSHFP?=
 =?utf-8?B?SE4xai9vU0xIK2pEN1JlL3oxcTljTW1HYTBOTmgwNTZYelR3Qlc4UDRHWUVr?=
 =?utf-8?B?Z0RwZlBoV2QzU05sUit2azhhN1gwSEdZSlVBZmZhVEo2cHl2T1NCa3hRaGJn?=
 =?utf-8?B?ZnE0SjJiVllPWFZVSzZzU1I4bzZubk9BTEZpUzltZ0RnMml3UDVhUkZaTHdZ?=
 =?utf-8?B?eFZMaVRobmFEdlAzTHNiVHZrU2k5WFAvQ09mWENNeEppVGg3WFJFM3d6TnVu?=
 =?utf-8?B?d2FwMkRYb3Roc0xrbTRoTkI3TGdPUHpDcnFpWkgvdnVkQThLVHRjR2wwVjlH?=
 =?utf-8?B?RTdUN0ZVLzFrdzdvVFZHZ25Zck5DcnFQUTY4ckdnQTVmR1JWL2l0LzdoNC9Z?=
 =?utf-8?B?ZlYyRk9ZYTI2K1RscWgrb1kvUlVqbU1rTDNRYi94MXBzM3Q2S0VRb3R3SkxU?=
 =?utf-8?B?b3hZcDNId1pSMGFSMlpZM0IydWV1ejRPUUd3TUZ3Z3VkRjZZSXZlTVNhcDZt?=
 =?utf-8?B?ZytGM2gwZDliSXZnOUg0KzZMRENhOFYxeDRTcG9aZVUrWTVEQlAraHlEWkI5?=
 =?utf-8?B?MU9NTEVJN0NGVXljQlhRZDNtOTJqdlhtWHYyaHlBUmVEOExKL2JKaVEwYWR2?=
 =?utf-8?B?MzVUN3g4V0oxZmczTk5DZFdybGY2MHRMUmFySjY0NEE1LzlsSHQwRW4yYmho?=
 =?utf-8?B?cndPR2FvYWUrZk5NMytuZWNmekZwTFNGaHpCOFJXUG9ZS2dDYjRZWUxsTENo?=
 =?utf-8?B?ODA5TUZpZThCYzQ5OXlFOWl3cExvRUJKdEFLWjlXU3BSL1p2Nng0cDV3NVpq?=
 =?utf-8?B?TFdZbGRRRUtNSTJzWUo4bGY0S2YrMTBkbVJPSkFLVUVMZlB3aEtLaVRyeFpw?=
 =?utf-8?B?eXdsQTJrUmQybTRsMStXNXVFVHlvNGVJeFh2WjFMdVNpRTlLa3VqU3dmSFdJ?=
 =?utf-8?B?cis3cHEyc0JuMVEvZ3pmQy8veGIrcEF3MkhLY3I0OTZacjVoOVpZVlRMQWZq?=
 =?utf-8?B?UEZ5VzJ3T0N4U0ZBR2R5ejlCVHhESTRkTWFHdlV0bkpwOVpXeE5HTTRjVmhX?=
 =?utf-8?B?WWlJNjhVT0l6eXdJeEJMMVkrMXAyeTl1V29NaFBQZGdyTjNzUzRpY1JuazY5?=
 =?utf-8?B?aUtRSmhhbkJGZ0RVeFhHRzlNSWplTTdHS2Z2UlAzVXNGRHNtdlVxL2Yya3NB?=
 =?utf-8?B?QVpBaThJbCtBYU45OWwzcnRxRkRqZVZtQjlBWEpmVzdkdys2bk0xVlYvRm1J?=
 =?utf-8?B?QXFhQjJzNUlvT3ExSG54Ri9DTktMTWFoSnZIZ2JDdVMvcTRqNXZhVWNMLy9v?=
 =?utf-8?B?RmtNdFdhcWovVzVTck4zVVBhL1JGQ0FJYkE4SkxJNmpJSmxHSGw1UjM5WEVn?=
 =?utf-8?B?SDk4QjVhYlg2VnRZcFBIS3VTS0lyOGJMNEd0VzVZQTFTbXVibXFtdjY4QTZI?=
 =?utf-8?B?cUtIam53L1JmZ1JGVm5jMFdiSDdpUlhaWWVJZFhVTVhKdHJ6b1BuWk56VU9Y?=
 =?utf-8?B?aTJQNEx2SlhocGZHbHNzQ2trcHR5OVE0UUpENkZia1k5VjdaYzNyNFh4eHBO?=
 =?utf-8?B?dFdCYW9VV25qUmFCSGFaTG1QWE1HNGRuSEFoMVpyS2FTNW9ncVNHTlVNdlgw?=
 =?utf-8?B?WGRGMEZyMEU0MTI0L1BKNHd6V3ZBbUN2eTY3OFR1NXJ6VTJIZGFDSTJMdGxO?=
 =?utf-8?B?d3laSUEyUTFHbmlEd1VqbnRmUGdNWGxhc1hUak1iR0VLZERVSks2ZlhTcGZT?=
 =?utf-8?B?MGdqcVpvc1RkZXhCOTlsUzlqQllWUCtUYUxkcUkyOEI5QUk5blhIeWUyMnNK?=
 =?utf-8?B?QVk2a3JlWjZ4cnRnSm1CTyt1NTFLRElZak1rREZIc0pJZDlUQXN4TFowTG12?=
 =?utf-8?B?eEJVVjJPWW0zbE5vYnlwZ2JYK1UvcnZ6eDVwaHViOU5hZlMrZzlJaHRIVnFn?=
 =?utf-8?B?Y2dwdllVbENxY3p4cWFTRGo0RFlORzIwWDRPallmMDFISXhzQWtHVmhlVDBY?=
 =?utf-8?B?MHpMUjNHRTFQWUdKTHVMWUVRelBhRXNJZlBoSGhIY2d1MWc4bWZzUWNFVE9C?=
 =?utf-8?Q?kcpzt492kDXQCb/63plD5lM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 2QzLhTnorFpddyTyXvW03CFxEj4OMvULqOLUGn+MvBceHP/jQqqDRQIEkaII/1u/PYCMGQFZZSbJO0MPQxOaaqONdICLJfND97dw6mXMujYyn1+IHsYNz21XnGxyidpjCoYnciy8M1Cf/yCpfJsWc3RTDBqL3Y7Gs3VT0qQ9hgxI4UCKmQozslZTwmx2/KFpeFEA7JuOGkzgyicbgikZJgGb6Xr9pn/etceraClqmEOJNm8VB/81Sn+lVJRA+xrSOz/U8PVcNoi0ATIq+y+LWAex72n3jqte8pffLAuRE2hdeBgE5HJjV5wb3sYEYT4EeuF0PUKBtMMqBqc2SyVFY0uCSVh5MiTxcCWyxHBmxmx1V08fCWtjSJm9qC9YqoOssv8m8WWO/wPc2N70XCAKp4GpHU9Iu8aMOXSm97d4EjmSHFyYEgwHvPpSuts9kddMwvG9yutMrkaoANfGd5H9hrj0LQl1/8FIrQWNLYVVKysBaw215UBB/naPrMkPZm4GTRErSkT/T9zT9Rbulck7Q4+eUKzVqmKB59e/ajbDmDlF4FnvSfpmZ0RfBeatYx6pYELA83V3Vu7bDfMuVJXi4zaP/jo4IhsP8DHlhMMHyhWebA3z5BrcyIqeeKSnukoBULNDn/4Xf04RFfERyFOvGG9cx6H90mtFaCXtxKU74wH7qK6qytBX8EALRf97lgwGDdXysQUfUJRIY8I5Z722pXQdoRBRVTWlnqYDFam+L08iTY+MQGaXyGm19oloCAUbhjY6CMN4vBoVbSW4bVQTKcAQL0NIpIXAwWqASoPiux4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f03a4427-de41-413f-a914-08db9392242a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2023 19:53:28.6205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mlTV1WdP73erTRZphmin0eefCTGvt55eU06cXXu5QCBcpsCkjN25qYtJ+yN6EDtBkf92OGyTZtG5WLLjiTz3MEtprJO9kUovDuIwwoBit9M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7830
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-02_16,2023-08-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308020175
X-Proofpoint-GUID: mvdL-UNbstvTC15GmOgJFo1BzBf3t6g_
X-Proofpoint-ORIG-GUID: mvdL-UNbstvTC15GmOgJFo1BzBf3t6g_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/1/23 04:40, Nilesh Javali wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> TMF was returned with an error code. The error code was not
> preserved to be returned to upper layer. Instead, the error code
> from the Marker was returned.
> 
> Preserve error code from TMF and return it to upper layer.
> 
> Cc: stable@vger.kernel.org
> Fixes: da7c21b72aa8 ("scsi: qla2xxx: Fix command flush during TMF")
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_init.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 7faf2109228e..3ab90c159034 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -2223,6 +2223,8 @@ __qla2x00_async_tm_cmd(struct tmf_arg *arg)
>   			rval = QLA_FUNCTION_FAILED;
>   		}
>   	}
> +	if (tm_iocb->u.tmf.data)
> +		rval = tm_iocb->u.tmf.data;
>   
>   done_free_sp:
>   	/* ref: INIT */

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

