Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78CC0C0015E
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 10:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbjGYKeN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 06:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbjGYKeL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 06:34:11 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4735110EF
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 03:34:10 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36P7obpZ019528;
        Tue, 25 Jul 2023 10:34:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=q5eZZ4mD3AdpmRHxcfipyRREgkTDZW/wIP76p6UxOfI=;
 b=yk3l1dgQik+8KP5UxAJVlUS13d29MHev77AC4/kG7AojrHohBKYpwwx6RrHO5BbkS3ZF
 0IX80S7lmxF4/t0ZZXv9C93MJwoVltQ5ZrODbXtZhl0z6qGInF+9SaBvVgXNhNHUlodn
 szagqfsoiH16noK0l5qOiRxp4IgpUcl5OACAMfGQgBfRz0UGuPtUxhM6ML0r/nliWatw
 C95/DF3ELVoLVdr39ewu+22W0+HDGvTX2xyn9cqhaZgvgldwqMhyMkHxj0kZZ8W2XQlu
 CwjebJzWTnv9QEYtnmkZjeJWugLGx9EUNsZE2G6ogH9TTjNBjre36ABfeSUt2x8/Hi3E 8g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s05q1vskr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 10:34:04 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36PA8qe3039863;
        Tue, 25 Jul 2023 10:34:03 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j52tuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 10:34:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PYxisv5ncq4Nbm04Yez+79zlxTuub4KRP02+vMmL18hmpTfokkSJqQ6+JbkFHRLXQepOmjnWRApepbCiNVbSFe7I37+Pkv/9arA+qbh/6PpJ/Vuj4jYWKYJFu31qPASL3orxf8V1JMo+vnhqfZrRwGMsXYGWi7oEJdg5ClnM0yyf2Q0EJFqYbMWFayPAJpSsTkvLfYLmLKQxfM36e4KkaBsTR93C9cN0mVR9zOKI1RobTUo1XZlyjRLCw2mRcRjvrOxVeFAmpnyCbFQrz5kqC5ddotkLEna65kN3YKR2qLROy+rV+v912bS+obprNNC9Q94VBF38H6e/kEebf4fwtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q5eZZ4mD3AdpmRHxcfipyRREgkTDZW/wIP76p6UxOfI=;
 b=RKGC2ehcTZ6Wwkjzst77uD2mdVvV64QGZAHr/xKcrP9O/RxBnYmO6gZ02gpGDW91WKu3X4E1P/1wcuUocEg7bmHVbo3BP6R800uymIqnQZBg+gEl4pF5W4sGaOS4lFB5lRqMpmkg9M+2J2ofSa3TsHX2sDwTtN06XmvCJzz4malNBTvEpoT3XiyX3AEJ2Bb9ATq8Fz/o78CRttn/Z6WrnbhjgQ2GPDxpztEtNXZznA5UpVgK6Ym0eQCTz9cqENvPzgECzvBuMlMS20AdH3VaJRIpUArXxbiEkWrjMwGoO6Up96e/u+ErKcTndHBdAl6ub7a0myU4k6mx8qJV53dMcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q5eZZ4mD3AdpmRHxcfipyRREgkTDZW/wIP76p6UxOfI=;
 b=yYd4N3Kx+BEjqCLJINeJcD58g7R5Zy/o+29tQk3uX590joOFKbGJT9utBWcbtderye/Qb3trMLhHGENAFR7FhPbVLZHuCzPjympHJAeCpUgc/dkLeLLsjWlqzaYMZMi41ml1qKRYwyBVLLk281pGkk+tA0jmGIDxL6nuIIon2kU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA0PR10MB7643.namprd10.prod.outlook.com (2603:10b6:208:48a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Tue, 25 Jul
 2023 10:33:54 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Tue, 25 Jul 2023
 10:33:54 +0000
Message-ID: <c6628bb4-d695-5606-028d-4897f09a3a22@oracle.com>
Date:   Tue, 25 Jul 2023 11:33:52 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 20/33] scsi: ch: Have scsi-ml retry ch_do_scsi errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-21-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230714213419.95492-21-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0161.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:188::22) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA0PR10MB7643:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d290305-08cc-4d14-3ef5-08db8cfaa548
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hp31/Q44F01cfRYEvSfJkZUsZozG7Q5wrbckAqaDbRe8XL0EhNwMNMr8pUDw3pmkbZDEQ/4iKRU9tuv49AX2hKhKldg/qsWZO3x2r0rcdaptCrwGR1Zm0ErWQEVlqB6rh6NA4SZ9mXL4bDGBAIJ4AoIiWSXTDgI3LH4XCoE8i88chPv0HlMCGXt0CfhqSbn69ztMNg3icXs2Zqo1YMfYD/ZlWMWI6A7pIWc+KrDBxAb2kK1cjCpmeTF9IgBXTCOAIac+TyRyPS4mSvsFaEHbELZHaY6XElQ2qO4HHlsTOC0CPt7wRhr6aINNMVhwH6P8Dz5SgRINabYeDoUqHJPEHiPxrMzCgM0wUaWhbUFLDNcBFrY1MWpxk6FltwkgXD5gM/eRha4EM0VKOsHv+EOt1Q1HXpDc0BW+ekfiPYIyDJjmbe6hcWIGzpX57pNDMuh+OrPGIx2q/QXlz4OGqcKM0L4pHIfvCwdVStc7cPjR1qbioGnYp0ldIlC/NGBh7EOOWzfTsgPcGmOqt0HffWLN1nEFHD1pJd2hU7WGvSu2NA9xWaF0mrTclhBtQVLLGR6cFgLQ++zVnEveeaDRRbi3H8QhsCJWWyeWNaogULF1tWBitkNie2ogZsnobYqPoFBLECBSaMJUWx7pen+b1UfHEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(366004)(136003)(376002)(39860400002)(451199021)(6512007)(38100700002)(83380400001)(53546011)(2616005)(186003)(26005)(8676002)(5660300002)(41300700001)(8936002)(2906002)(6506007)(6486002)(66556008)(36756003)(36916002)(66946007)(66476007)(31696002)(478600001)(86362001)(316002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TG5hYmlUdW5RMHYxanhneGlHSWdXYWNwVlQ4YjlOSkorZDZkRWc3NDBCdWpo?=
 =?utf-8?B?b28rWU94VXg4eFIxTGMvbHRDcDAzTXFlTzk5WktibDkwNG1oNXorbWZIWnY3?=
 =?utf-8?B?ajQ4Z1Rkdy9pd0VyMFM2VlpRQkN2SXd3WlU1c1A1YnhrMmxkTWlueXNWNXo3?=
 =?utf-8?B?aERYL0xlSk1wUkw4Zk9mZEsyU2VaVWtlSzFFOGZWNW5IZXpSSStSN1pvb0RT?=
 =?utf-8?B?Zjg0U2tmUVBxcWhRcEx6VlR1aGZvSEIyMGRxSDJ4WSttYUQ4WGs5V1RMd29z?=
 =?utf-8?B?ampYenlkNUZMQXZnWHZXNXcwUDBCbENURStabmxjTkVlNUZUMm5MZDVhZDgv?=
 =?utf-8?B?RzdYRkVYR0M4Y3JITE51a3hmSG80VW5FTEE2UDdWZ3dPd01Vc3MrR1dPMjhV?=
 =?utf-8?B?RFVQWnhJbnF6TGFHZHBoM2VoWDA3UFpSQ0JOOHl6aVpoeit3V0QyYWg4NXFQ?=
 =?utf-8?B?bHZGMjR1RVZUTCtHSHlrOGZVOHc0UHZ3elVrckFYZ2RCcmN0L24zdjVkd0x2?=
 =?utf-8?B?bnZ1bXZjZy91UUwrTlJ0UGNHUjk1QnJpQ1ExcnlNNkdhblBreEh1d2xHaEtS?=
 =?utf-8?B?VkNtZHU1NzNYQWEvajFXdEp2Q0N6WUJiM0ROdVhyd2R5SUg1bnFTajBHbjBE?=
 =?utf-8?B?aHkzb3pDMlhqYy9iendKK21JYjRNbW1CU3FxOUVyb1NXSXdnbFcwUHZWbS9p?=
 =?utf-8?B?TmJhN1VFVnNJd1MyMThyTU9ISVZKNDJWcjhVQUJaWTE2OU05OVA4RTZ5NUlw?=
 =?utf-8?B?STdGM2VEdFB3S2ZIQkhLdGlhWlRUNnNzdTlPai8vSDlkby9rVlpjU0o3cWZj?=
 =?utf-8?B?ekpiUTJFS2xwUFg2b0xRSWJoRDR2M1J2ZDlPZkVwUWtLRlRDaUtZOUVxZk1D?=
 =?utf-8?B?dWxMTmlUbXpvNWdtVUV3MnFvMUgrNTVua0pTd3ZIRTFnRlRsVk1zaHkxZVNw?=
 =?utf-8?B?ZERKQndsTUVOR2tNOW5xZEhwelJMVGFVQnBqQ3JhUTF5SlVnSVMzOUlPSFB5?=
 =?utf-8?B?VndWeDRHSWZqTTNKcTJMNEtSclN4b2YwTER5MS94NHc2dmVGcHQyTU4zOFZ1?=
 =?utf-8?B?bjRGcURwY0pzYktjdzVLZVA1Y3J0K1pBaHB3aCtyamFWUzdTZFZSZjJYUTZh?=
 =?utf-8?B?cHhxMlI4T3ZUK3dRYk1BWnhic3F2S21WYWdTbnY4T0ZkRmZXR3M4MjZsT0Yw?=
 =?utf-8?B?dWE5bmpCZkc5b0p4bVN1OUp1ZThsemNpblNMZGJNUXpWOXVHSWpNTGYydmQw?=
 =?utf-8?B?aE9WUXQ2UzNzdWJKeTAwNHBqb1JiL1oyUERMMGtTQm9lL2ZPa0VPZmxKeHFD?=
 =?utf-8?B?V1BPeHovR2pQM3hEcDBkdW5Jc0RwT2NMVXVMYkZEUWN3WDNJUmN6aURORElz?=
 =?utf-8?B?bk5vSWtTN3hpZGhzem81dURMN2Nkcm0xUWtGWGdWZzIycFlSaTFieGJYMXJ5?=
 =?utf-8?B?UnRSNldzb1J4RmVGVEtMU1ZUOStPUU5SYzJqSjliaEhieEhUOUJRMVVwWm0r?=
 =?utf-8?B?bmg1YlRrb0tNSzY2UEtwcmhIMXd1Y0N5RTlmRE1ZSm85UHd5VlhDR1FpRitD?=
 =?utf-8?B?Q1VldDZtTGlYNkpCUkFVL29zRDhhVTVMTU5UQUZtWFI0bUNsVkhJc0ZNdjhJ?=
 =?utf-8?B?WFQ2b0htU1F5N3NKWDdXWForV1k0YUxORzlDNm9lQ1ZRbC9hMThPemI1OXBv?=
 =?utf-8?B?OVFYZ3YwOWF4SDQ2OGlJc1Z2SXVNblc2bTcrdnRmV2QzenV4c0YrbFZjakNC?=
 =?utf-8?B?dE45YmwvU0NyUE1WME9ZTmNid0E2bjRzYUFVeWlsRnpyR3RYZXBrcHJwVWpv?=
 =?utf-8?B?MjdhYnNkNEM4M1VPTDBEa1ZCWVU3Q2VnVXpZTzNqUGhQU3NBVVQ1c3ZlSmRZ?=
 =?utf-8?B?VXo4aUw4MHJId0htZ1p4OWVZNEt3bU5SZVZ1WENHdWQ4VTRPQ1RVcFQ2SVVN?=
 =?utf-8?B?VklhcnRyTmNxTW9YbHNOZVVCMGpwbStRS0tnU0dLVXYrb1pnaG0rb1N1QmRD?=
 =?utf-8?B?a1p2TW1lbzlqemZGb2dlVFlPR1dDdk9oRG92QU0rS1FFL1NPbmVEcXh2TFVm?=
 =?utf-8?B?R1gxZFB4c1VnVlhCT1B6RXJDWlZvcElTQ1JrWDEvSHJvRFhsUlpGd2dFSjM1?=
 =?utf-8?B?TStjY05KN0VVc1BPK0g1Qmg5WUJWbm5XTnVLaGFtZytYdFRkN21CemJwMjV1?=
 =?utf-8?B?RXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: lh8iCM7t8nFnaMXEQVMO7uV0/PGFvUTSxeymtBPROn18Bn1zXPSt/zOXoQMDL3z12oo3zUga9JLTZqznpOzzvTkt0Qv5PFbk9CMA1S51VWH0XubstuiCHcV5oPTEzcZh0myXCWqwQ1//yI3yPkFGEEWvHG+2aWqOFdBmsIQ3GtHhj1Wto1tgdqYxiRtf67+AiIrTHt689nuTYdX0RhCCgxCvTtAu962EyiHa2Tu6HuCiKbVQ5qGmR49DbpUVtXdQhQir6iZ6J09BGP7h7LjAbkiI+QNEhj6QmqmbZFguOCymxDbWX+7TsNjfcOzWuMebTy/CgA3fStbnIv5FfcHG71V5QqG453m26rpZQrnw/fe48D57CwXNCD2ZogMOdbc4Hvtj1TgEsm5sD6MRLOr6sw1elSBcQutjl2FGu3/3gnzeI9qzTpIPpxERPNKMTWHgITU/4AZ4XAhK+hr1sAVxRIxnLW3c9CAg97f5ogP79/KGRlJi6A9GEa4LMGDinza6BKtcEa2o8jedTMPj75RLidGiP6N3SBMVZpWZWWD75ZXm+QezV7/3Tq+oaTDFudkFdte8QN13gcILWZt/YzIwqriW0Dn8a/sAwqGianGzxK/INwQ1tMGuctuLV0MAWCiyqsjug5K76S3kcDr1Gv1DZJst0scej3cVcHiaSYS/ovv/P6hCozGeZLn/8U7r+JVZWW6Pe0JNLGwDITMraCzNyw+sot3xQWrXkmQbzafiGYfdVAPy+qoZ49sRoWmvZ52eGNVT6fYbUoVeTANl6/Nc6o+RLwkSaNNgPls2bZEbLUK2kcVTdEy8vO07+brDADU2Ju+JAKIF78RF5jdDVB4JSDH+mnwPvpkwTpBn2lXJ6upXYUDbk5mQMJ6Zpyq6uDnS
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d290305-08cc-4d14-3ef5-08db8cfaa548
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 10:33:54.7712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PnZ421pHRNIxvmnLHZRiPmPXBZYA2UGwvi8znHhmATpTiVdLuBOYGTGBa6XoPw4enQtQiRjNNBBma8mohD+08w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7643
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_06,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307250092
X-Proofpoint-GUID: hWGOWAgVr3jiNFAmiUGVJSccep8tulXq
X-Proofpoint-ORIG-GUID: hWGOWAgVr3jiNFAmiUGVJSccep8tulXq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/07/2023 22:34, Mike Christie wrote:
> This has ch_do_scsi have scsi-ml retry errors instead of driving them
> itself.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Apart from a small comment, below:
Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/scsi/ch.c | 21 ++++++++++++---------
>   1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
> index 1a998e45978e..8ea498e6eec2 100644
> --- a/drivers/scsi/ch.c
> +++ b/drivers/scsi/ch.c
> @@ -185,16 +185,26 @@ static int
>   ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
>   	   void *buffer, unsigned int buflength, enum req_op op)
>   {
> -	int errno, retries = 0, timeout, result;
> +	int errno, timeout, result;
>   	struct scsi_sense_hdr sshdr;
> +	struct scsi_failure failures[] = {
> +		{
> +			.sense = UNIT_ATTENTION,
> +			.asc = SCMD_FAILURE_ASC_ANY,
> +			.ascq = SCMD_FAILURE_ASCQ_ANY,
> +			.allowed = 3,
> +			.result = SAM_STAT_CHECK_CONDITION,
> +		},
> +		{}
> +	};
>   	const struct scsi_exec_args exec_args = {
>   		.sshdr = &sshdr,
> +		.failures = failures,
>   	};
>   
>   	timeout = (cmd[0] == INITIALIZE_ELEMENT_STATUS)
>   		? timeout_init : timeout_move;
>   
> - retry:
>   	errno = 0;

nit: can errno be init'ed to 0 when declared? Or in an 'else' part of 
the if (scsi_sense_valid()) check?

>   	result = scsi_execute_cmd(ch->device, cmd, op, buffer, buflength,
>   				  timeout * HZ, MAX_RETRIES, &exec_args);
> @@ -204,13 +214,6 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
>   		if (debug)
>   			scsi_print_sense_hdr(ch->device, ch->name, &sshdr);
>   		errno = ch_find_errno(&sshdr);
> -
> -		switch(sshdr.sense_key) {
> -		case UNIT_ATTENTION:
> -			if (retries++ < 3)
> -				goto retry;
> -			break;
> -		}
>   	}
>   	return errno;
>   }

