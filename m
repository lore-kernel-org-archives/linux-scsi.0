Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 399CEC001DF
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Aug 2023 20:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjHBUO5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Aug 2023 16:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjHBUOy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2023 16:14:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B289B2685
        for <linux-scsi@vger.kernel.org>; Wed,  2 Aug 2023 13:14:52 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 372HJ1aN020882;
        Wed, 2 Aug 2023 20:14:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=fVyin2TlIzqJY3XtsAkwUvngaoYC0wvtN4/Ukqgl40U=;
 b=Ey7MaC2j+ERyJwxhS2dZEpQCSOztnROy4dezYVCjxbdHi7JVcFLkP+hOcSjy/Hp8bzd1
 HZyhH3TeALb2x4YWwN1jBSJINZTtQBQkKN6qYuzfJC/bFk09G1Z7EOHwjinOk556gH6b
 wGI3GqGsgMd53K2q+t7lZFXSOr2WGZfiqasjD0dspXJ6I3drTqQWi5ssrtf7UDMK/08k
 zJNNFrr5UuauGxPnfByMRlCMfpEYpL9kGHekFqucGCgjhSEHCHaThYGmFmHdyRhAdfBQ
 QeVgd5bEYzlQU77iSVobsRSk5Iq31JlgUa6/xwJ65+CPm34noIl5rmnZPwEDWT3pQCES /A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4ttd88em-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 20:14:50 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 372K7cR8020537;
        Wed, 2 Aug 2023 20:14:49 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s78nd1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 20:14:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VG5QcP+BA2a9VffxVxALbW3+aTWA8ej0+DEnr2nOmI3mDquJ+Bzrg8FSuzu4YQXMgIK9zSx/UePcB+cA7AxZhiuwEBXCdKhqGA8WBtKSx8fcXeX6MzQw513d2RIr5O0+b55YbtgDuUHSCmom2I2nw8V/DRvuALLuhl9ekqrzyaAZyk9TTpN33AO0X+OE0JX0onwSIgfnS8hmJQgYLRNU0Gz1OuocqBmJOPD8sOrozHPIssoZZbFbz9oyOmphXqbWbCY2m9IawPXg2f8nT2KYcaF+HNPDZdBapTXHnoECHnCqCnp+Oc3YZLEK5v7RjEQv+oKS2RXA1FnUsRvnsXH76g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fVyin2TlIzqJY3XtsAkwUvngaoYC0wvtN4/Ukqgl40U=;
 b=XK121SnrRdv8OzQon0LgzoerbnzCrqlefH9UsiQZoRLF5oH4478bSAqXaB5qPrgSK7SQB/uJ+yyAPRNPhJmczRtbhjcO8tMo75ZVOerubdSYTy0BIf2Fqm6iqcNXj+gRsc3x7Ouf0OzqIiIjLLpb2O+wp9UK0TbUGkLsVRUUdEU5XqvQa/HEuOoeHet2y1v0DJUsRUcNgFuCW9nijjUuGwRoRz6Yz3kW+Ykna78pjFFMb22VvSqUWVrdP34lmLisPzk8+Bz1lbieL7nQLQHWjwS91YByYuJ4RA1uMUYuMT5nMmvMymo4Pv7tmg1fThSutS+KSd6/wRTFdAFtQ0gXLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fVyin2TlIzqJY3XtsAkwUvngaoYC0wvtN4/Ukqgl40U=;
 b=R9m3JD21wE22u0/gY8R2Cz145mrzB8s1lpqJkTrbFsX7IOOYh5KDRakADOgmloVLKq0IW2+2G6czgMx4XYhO48B2whHlf6BBxgnI/DzTgFYjq7dr7dnSqQEwqyzPNuF1RqqGKZEbAARFzrxnkSO85ODRJ/0+sUi6Iz/oNTRR8ww=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SJ2PR10MB7708.namprd10.prod.outlook.com (2603:10b6:a03:574::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.19; Wed, 2 Aug
 2023 20:14:47 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::31b3:ba23:4678:9f5f]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::31b3:ba23:4678:9f5f%7]) with mapi id 15.20.6631.045; Wed, 2 Aug 2023
 20:14:46 +0000
Message-ID: <8526703b-8d93-7803-0d1b-5e8096e75995@oracle.com>
Date:   Wed, 2 Aug 2023 13:14:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 07/10] qla2xxx: Observed call trace in smp_processor_id()
Content-Language: en-US
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com
References: <20230801114057.27039-1-njavali@marvell.com>
 <20230801114057.27039-8-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20230801114057.27039-8-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0043.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::18) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2943:EE_|SJ2PR10MB7708:EE_
X-MS-Office365-Filtering-Correlation-Id: 1330dfb1-4e65-4281-2e6e-08db93951e05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ximLf8ygg156hFIIRFMTbZjTcjYV4sQUcAF3OD6PAM6ZNunaduXOYcuAN3yu4n7o9bqaHNHD6rBzg74fDqwr9JCaW0/D9PsID+9q7JV5P3LR0Wl0HCoZLEPAebJ5oP7i/efkG/W8nykYMNnKhF+T2+SH+ID4HUIGAEalsFpY+RyyyFZNkFmX1UbrH0XtzLVeygQ/KZPR9cLxQ9ysmnS6hp3JZbRX5SuIfH7mkrQM5lHDNEMBWdTwT9J66LZ7Xmp8EcmFb3OLGAsbkmGr2mo89ZvvUaqrCikvTIcle7DMZYBCDZTNUcKhSDROLD7u4SQ/71fqC8OqF0NUEhq20WlKmj0ybZuYynriP96JZJJSkDIUKxYTyBc0PpbwHuGjK8NGEHxfzqW7iuOjSlkPFq1oe32cbsm0qFP34mc2ICsBa2CTqFOPeE4pz4IqYthUPOgM9zUqJZ7wkxWotp9Aj3OET8d5GbB6FK2UVQ6XAhq3MK2lq2FFWFJGwjunvgcYTOr+kyspwzdubslnZHHBBZnVd5CWaWFZtj6B2jWrbsJp9WdqjZ1fK+2pbbNNzYx74KZe/NagIbsMG+K8mPwEHKjESnOQT9bfY87AEz2rdweS7DSGdY04b94X8xIWIEmxtoHqSVvBg9aElIpI2EkVXp0vGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(346002)(39860400002)(136003)(366004)(451199021)(36756003)(86362001)(31696002)(478600001)(6666004)(6512007)(36916002)(6486002)(8676002)(8936002)(41300700001)(316002)(31686004)(5660300002)(6636002)(44832011)(4326008)(66476007)(66556008)(83380400001)(38100700002)(66946007)(2616005)(186003)(6506007)(2906002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OHB6dnMvNnA5dmcvNGtVdzZkSXIrSDMzb2svbDVxeG96SGpmRFphTHpZb3pV?=
 =?utf-8?B?WVJsbFZCUDd1QVZkWCtjSGZiTlJJVUFzSFloenA0UWtxa2E3UUJvbzNuSWZY?=
 =?utf-8?B?Mm93SVBDdGUyZ1RFazdqelExaGVTRVkwa2VsYTFINnY0NGVucVpSaDNsRysv?=
 =?utf-8?B?ZkpSMVlLS0UxSmhRVEZsUjVYYzJRVjMxRTlvODdsRjVsUDd0S2lqSW9iRkcr?=
 =?utf-8?B?ZFpKOHptRnFJVXlBdDZVM0plekVCTWtRSGhFZkNWUzhscUNYeTFCUVJnank4?=
 =?utf-8?B?QkluQVFPdWNtM29BSzdCN3locXQ3MnJxeEVES1FyeFFpdlYvbGtVUlhWdlNT?=
 =?utf-8?B?VGJRdVcwNFpRa2lqVlk4K2NxVjFtQ1VFWEpRcDlvejBkWWlwdHM5MzhKa1J4?=
 =?utf-8?B?ZVJCS2x0ajE2dzNKcHErMnFiSzRzbTA5Wi9rT3ROMkt3dkNqQWt4NmtSQUhF?=
 =?utf-8?B?ODlWOVZCL3Z2VUxJeDgxaWxoK0E1V1dBVjluN3VnZndQUVBtM3I0SG90RURi?=
 =?utf-8?B?cGFvcU92SUF1ZWZPSnQvc3E3MGEwK1BXdlZ6Q1h6L1BUQ0xESDZheWZDQjBw?=
 =?utf-8?B?MjhVeEpVZHBHVi9hZEl2NzdEN0x5bWkzVzR5ZXRMblJ6UmxIOXZMSkh2N3hK?=
 =?utf-8?B?aW4rSTNOZ0VqWG5OQno1dzgyaTloeFRVZVAzV0NwOG9YMUEzRXRXRnJ6VEYy?=
 =?utf-8?B?cy8zTXBRaGhwamVxWE9WS1pTa2ZjSnBCOTVad3N6bHNyTWVrcG9rMCthQzlL?=
 =?utf-8?B?QzNLN2ZHKzJ4VWlVRWMwUkFqN045d01pekc5ODJnOGNSVUtac2FiUFdKRzBU?=
 =?utf-8?B?Sm92bzF0Tkp2bEF5MmZJaWVUTkR2NkluM29EanFGamZhclh3WVRIRXgzbXRl?=
 =?utf-8?B?NGE1NUVKb0V4TEpGQkJiY3k1VnZGa2MycUNhOXB6NWw1UjhZQjQwcmZ5NzdM?=
 =?utf-8?B?QUZLMnFkKzFNL1ZIKzdkOXFDUHhzaGg5c3FseFdDR2c0cnZPS3JBUWo5N3FJ?=
 =?utf-8?B?dUlwL2NnQlE0UVBDUDFwcjJQc0dUT0tCQmo4M1NpaDN4TE1NRFhINmJocHRa?=
 =?utf-8?B?ajJGaW5mYUdJczJkeGEyVTkxeUdsY2h3aGlKdHZCaDI4MWZ0MGMrUGE2NmRz?=
 =?utf-8?B?bGZ5cmJXL3ZoU0ZQa09MQ2Z5WS9TdVZUUFV3UGgxcnZ4Uy9EeUdNYWY3WDU5?=
 =?utf-8?B?a1loc2Y2eEY4NXMwMFB0YlpxdjMvVXB0dnQvQkhhQiszYWRUVVg0emFraktx?=
 =?utf-8?B?eHg5K21rRmxaSTJ5aStyS0M2ZUxveEp6U3hnQVd0aldyVU9GMUF4REwwQlY1?=
 =?utf-8?B?cFlPSmd2ejV3S20yQVZEejQ2eDduVHQ5Y2E1TFQrTHBLdjcxQmFhV0M3MGZu?=
 =?utf-8?B?NlRuVWMwQlZtOWZweThCWHF2V2NKc2xNakc4LzF0L1RUb0hoOWQxY3BMNlYy?=
 =?utf-8?B?U3hTRC9yUU8zWWEydUFEZEx1THBYVzdBMnhxeThRRncxQmJVWEtnM3hwUDR5?=
 =?utf-8?B?VjJDcHpOSW5xRVVHQUxYMVJ3djNTL2pnMkxoMzB5MmF1RHloTmhDUWxSMG9T?=
 =?utf-8?B?dHRFazQ5dUVVb0NQbTJWVVlpZDFLeU1Qbi85TTh4WFpSQS9HSzZEV0s4cElH?=
 =?utf-8?B?TGhPcVZucEJpMjk5OTUxU0kxSituL1U4MFZrQU4wYWZRR1Z1cit3UW16dE1w?=
 =?utf-8?B?R0xwcldJY09rOG5hWEIzMURjMmI3cUhibzROVzR6VmptTlVvYnBIT2VqMTFO?=
 =?utf-8?B?cTdOSDdHSzlWWnVYeWpqdHlsS2UvbDJIdld2Vm4vT2J0OVdiR1VYemlHc0xh?=
 =?utf-8?B?TVNUZHM2TVhHTmtWSi9NMms3SkFmM0NJNE9TZ3N2eVhiWFpjY2JVN1JydEhq?=
 =?utf-8?B?bHZoZ241bDB5dy9ycHE3dlhpYjVOMUNkNHZvOUZhOUU3T0g0UUdPeVNaL3BH?=
 =?utf-8?B?bm1OcnFrbGVIcFduUFF4ZHBabEwyV3k1cUJDWWR5UnlkbHYxMllIaWdMcFlZ?=
 =?utf-8?B?Ny93TUF0YXh0SEI2SXJsU1h4bmtBSGpBckYwaUUwQ251ZlNNa0RZbmhhd3Rx?=
 =?utf-8?B?dVlHQzUwMHBuQzJVSU9ZR1RmZVl1UkV0eTNDazVhNHQ0VWluaTNVbXAzTjhk?=
 =?utf-8?B?K2dWVDdVSHpyR0YwUG1qaVFtbVdkUmlwaGs4QnlxZHhpQ1k2Qit6NlVQaVJy?=
 =?utf-8?Q?dWavhAak8PlvnQxl8eQZloo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: d3wXcBULVxuUOE6gkqX9rOZGdOpaaM3PrMrO4fsJ1V/XBfVUK+KB/4JwsIxGso3pW62OT2Cb0Aqigx5BJLHV88Zz/lm96V8xdPFWQ5K46p5kXLf7OmBquF4T5kaTWYa13ucIJmJZlyBga9yHkJ/B2CqKv6znOLl1dM8C76zBCLhy+znzU2Gk5/F9ULHlMBGAS6swsu8z8ykcLZ2cRO4ALJifUxgAswwlNzbe7UEvNuD298sI4pcVkTsKXcz3GS1bY3gg1K4Atb0z8ci7ArroF5qcVWCMKvNjqTElBt9utnxZSBLFT2zBDMXlD8+SlIltvf64S3v7e/gikqbxzaRftFx7VJVceobOAGMPUme8bYRCP/IjP4nB0zgokH+aPpsLkpfwLdu+gFXe6Zfq/Daij9h7Vrz2a6oOjnoATBp7ifBvSkQHnk+gAX3wmp4jY0ckADt/Bk+lTYN0Md4SDNoNmISQYVTlkz7sP70L6j51VlpUtlczj4x9DfnjVrJ9WN4h4gsDdCN8ISNloceV0nHlirZ3OKnJkVA5oHd1dsdNjI587kDB4Af7kAJCJu5+kNHbsmD2s64dX1JOuuP0jQvzolk3IYH1hc4ZBDAtoPZTt8L4q9wNt6TuKkiyfwVUd53qk9N8l3VZpID+N2Tu9aM7hjFLA/xF5d44wO2uILocR/Gbwkdrjud4EDsxmWrLtunX7hu7/JDH3DtdeWlbwOBbMRKJspoCa3RU9oDMxDeZ7Z+DzFekIeEltntC/qR9rfN2xQC7rLcpT0lEVQ4d+r0wOPBzZTPVC1XIiwU4oBR0e+s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1330dfb1-4e65-4281-2e6e-08db93951e05
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2023 20:14:46.8948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D7GWhWd9+RnVjoGpEZ+ZSxtfXE7ItVdx+MzEZl1yMrMwC7Lcz+SEyfqpY2BBQSF+vNT/lU3kVpS8bnONgWT4Jv6Ps8HZg48eEc+i0ZfhKK4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7708
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-02_17,2023-08-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308020177
X-Proofpoint-GUID: OY-fWKxY_OtV_yMcRJhWiGdNSGZTW6IN
X-Proofpoint-ORIG-GUID: OY-fWKxY_OtV_yMcRJhWiGdNSGZTW6IN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/1/23 04:40, Nilesh Javali wrote:
> From: Bikash Hazarika <bhazarika@marvell.com>
> 
> Following Call Trace was observed,
> 
> localhost kernel: nvme nvme0: NVME-FC{0}: controller connect complete
> localhost kernel: BUG: using smp_processor_id() in preemptible [00000000] code: kworker/u129:4/75092
> localhost kernel: nvme nvme0: NVME-FC{0}: new ctrl: NQN "nqn.1992-08.com.netapp:sn.b42d198afb4d11ecad6d00a098d6abfa:subsystem.PR_Channel2022_RH84_subsystem_291"
> localhost kernel: caller is qla_nvme_post_cmd+0x216/0x1380 [qla2xxx]
> localhost kernel: CPU: 6 PID: 75092 Comm: kworker/u129:4 Kdump: loaded Tainted: G    B   W  OE    --------- ---  5.14.0-70.22.1.el9_0.x86_64+debug #1
> localhost kernel: Hardware name: HPE ProLiant XL420 Gen10/ProLiant XL420 Gen10, BIOS U39 01/13/2022
> localhost kernel: Workqueue: nvme-wq nvme_async_event_work [nvme_core]
> localhost kernel: Call Trace:
> localhost kernel: dump_stack_lvl+0x57/0x7d
> localhost kernel: check_preemption_disabled+0xc8/0xd0
> localhost kernel: qla_nvme_post_cmd+0x216/0x1380 [qla2xxx]
> 
> Use raw_smp_processor_id api instead of smp_processor_id
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_inline.h  | 2 +-
>   drivers/scsi/qla2xxx/qla_isr.c     | 6 +++---
>   drivers/scsi/qla2xxx/qla_target.c  | 2 +-
>   drivers/scsi/qla2xxx/tcm_qla2xxx.c | 4 ++--
>   4 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
> index 0556969f6dc1..a4a56ab0ba74 100644
> --- a/drivers/scsi/qla2xxx/qla_inline.h
> +++ b/drivers/scsi/qla2xxx/qla_inline.h
> @@ -577,7 +577,7 @@ fcport_is_bigger(fc_port_t *fcport)
>   static inline struct qla_qpair *
>   qla_mapq_nvme_select_qpair(struct qla_hw_data *ha, struct qla_qpair *qpair)
>   {
> -	int cpuid = smp_processor_id();
> +	int cpuid = raw_smp_processor_id();
>   
>   	if (qpair->cpuid != cpuid &&
>   	    ha->qp_cpu_map[cpuid]) {
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index e98788191897..01fc300d640f 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -3965,7 +3965,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
>   	if (!ha->flags.fw_started)
>   		return;
>   
> -	if (rsp->qpair->cpuid != smp_processor_id() || !rsp->qpair->rcv_intr) {
> +	if (rsp->qpair->cpuid != raw_smp_processor_id() || !rsp->qpair->rcv_intr) {
>   		rsp->qpair->rcv_intr = 1;
>   
>   		if (!rsp->qpair->cpu_mapped)
> @@ -4468,7 +4468,7 @@ qla2xxx_msix_rsp_q(int irq, void *dev_id)
>   	}
>   	ha = qpair->hw;
>   
> -	queue_work_on(smp_processor_id(), ha->wq, &qpair->q_work);
> +	queue_work_on(raw_smp_processor_id(), ha->wq, &qpair->q_work);
>   
>   	return IRQ_HANDLED;
>   }
> @@ -4494,7 +4494,7 @@ qla2xxx_msix_rsp_q_hs(int irq, void *dev_id)
>   	wrt_reg_dword(&reg->hccr, HCCRX_CLR_RISC_INT);
>   	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>   
> -	queue_work_on(smp_processor_id(), ha->wq, &qpair->q_work);
> +	queue_work_on(raw_smp_processor_id(), ha->wq, &qpair->q_work);
>   
>   	return IRQ_HANDLED;
>   }
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 2b815a9928ea..9278713c3021 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -4425,7 +4425,7 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
>   		queue_work_on(cmd->se_cmd.cpuid, qla_tgt_wq, &cmd->work);
>   	} else if (ha->msix_count) {
>   		if (cmd->atio.u.isp24.fcp_cmnd.rddata)
> -			queue_work_on(smp_processor_id(), qla_tgt_wq,
> +			queue_work_on(raw_smp_processor_id(), qla_tgt_wq,
>   			    &cmd->work);
>   		else
>   			queue_work_on(cmd->se_cmd.cpuid, qla_tgt_wq,
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 3b5ba4b47b3b..9566f0384353 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -310,7 +310,7 @@ static void tcm_qla2xxx_free_cmd(struct qla_tgt_cmd *cmd)
>   	cmd->trc_flags |= TRC_CMD_DONE;
>   
>   	INIT_WORK(&cmd->work, tcm_qla2xxx_complete_free);
> -	queue_work_on(smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
> +	queue_work_on(raw_smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
>   }
>   
>   /*
> @@ -547,7 +547,7 @@ static void tcm_qla2xxx_handle_data(struct qla_tgt_cmd *cmd)
>   	cmd->trc_flags |= TRC_DATA_IN;
>   	cmd->cmd_in_wq = 1;
>   	INIT_WORK(&cmd->work, tcm_qla2xxx_handle_data_work);
> -	queue_work_on(smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
> +	queue_work_on(raw_smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
>   }
>   
>   static int tcm_qla2xxx_chk_dif_tags(uint32_t tag)

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

