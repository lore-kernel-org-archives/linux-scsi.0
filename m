Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E6EC04FDF
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 08:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbjG0IAx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 04:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233693AbjG0IAg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 04:00:36 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A8459DA
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 00:57:58 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36R0sWDJ005179;
        Thu, 27 Jul 2023 07:57:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=/mF8NYeX+sqHaFpd6uEky3tk6t3HL0oGk+t+zmpxY9g=;
 b=Yohu4K52nOSHcAjPPhWNhRI0xnnY8NRvtPayakAgOPP+6aHVkRKLq76Tljkkt+gLSAXP
 J2P8RYcNl5BJI30tL4SPRziOCD3vPNm8uqxIcgtYzHLe1aFcBV75MYoZ4FFp5BbDnHm8
 08/E3AAPIue+mqm6Pv9wlHwPzpk6A8SjF0bVQIgSL/J7j9nRHE7MT/UgWVOTONpT4M5z
 /U9InUXDKsk375wAUx7sr++PPmUVT7bD6KUwgz55eG7VchLkck/3HmEGhTeTFQYDXaEG
 u4Ub9qCIOqqvjNJ0zkeWpTfaQSpzAiOumbvox2dDs8vWTdzuMImIpBb1wr9ZSSMLBexV ZA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s061c975u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 07:57:35 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36R7R9S0033540;
        Thu, 27 Jul 2023 07:57:34 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05jdm0cn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 07:57:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ANSJU8B1jUqYoFs+q83rljKvVaimIcwBrTVz0zC5xgHsALhvnHApWHIxPZCgQNyMImzSxB6VPXCIfdnKkn7rXbQ2sn36MdLL8vdrpBs2oFmQcL6SadEmk+JysbhAzci4rwk6bllFXk7ryVoA6Pq9BcjnBfvTsPTotpPV2NK7sJN2iFcQ/A9IOKPs9mAmU2BxgDCedzjeUoO51whdb4alu2AhB9ifGw5lxF1LH++LmUrUYcJt3OG2O13mR2iUgxfEErXLzGiEI0zdIdja+wPij/Ggg3mNjqscb4VA1C8X27GfuNXOGRV2Ny/AmV2SvFhIE+AXLtSf/t/hXYJQwscMkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/mF8NYeX+sqHaFpd6uEky3tk6t3HL0oGk+t+zmpxY9g=;
 b=UbVs0m9LHfmdpfAI2SD+ErgBaeOru3iDV2BnbNe04IlX/lmDRiUrj/2PXLqXO31AyZ64M/RdHShamkyAaZ/PnOApBWf2kvYOdj9+lnT0C49m2PVvghIwr42vcu+URtAJxRq1YRMCqO8VqbrY7il/u/YVOZf4tY7BJQ52Jjirbj6iZnlcTdU82zhbSBj8YRsr0LGy8sOItaDCZVRu+Ouazr6ryxl4nrEkPq5EMo4uaMNCtAh+Qn+Xhhi5tj2DhcZsEtLCSlHqSixG/Fimgycr5sgo1ijaQkW8tWJ/9P1qV/dFadxT6Qxc0OcwJER9S3JIOpyMDzk968UgCZp3mu+GYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/mF8NYeX+sqHaFpd6uEky3tk6t3HL0oGk+t+zmpxY9g=;
 b=P4aH1Y7hyZMwsxXvD/4T/e6YVfgYwnzK5f9ABtdAe6tGKlgIu4vqlUgUJKBP6nwsKoAwikPXKURrfA2hHNL4e9W7eHl6Hi1MhzoIdSsS2Eub7Lr6bdT/aJyU049cQwEq48rrIQhsHLDJzYkcy1N3Ip+s8O/MGvgSeLH4IyXJ28M=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BN0PR10MB4839.namprd10.prod.outlook.com (2603:10b6:408:126::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Thu, 27 Jul
 2023 07:57:31 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Thu, 27 Jul 2023
 07:57:31 +0000
Message-ID: <ac3613ea-9969-b0a2-b3c5-0e13141f22c5@oracle.com>
Date:   Thu, 27 Jul 2023 08:57:27 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 22/33] scsi: sd: Fix scsi_mode_sense caller's sshdr
 use
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-23-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230714213419.95492-23-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0083.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::23) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BN0PR10MB4839:EE_
X-MS-Office365-Filtering-Correlation-Id: 47e8c4fb-3607-4379-9615-08db8e772157
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1A9q2BSgJ/e7qOELyIq/GXwnucMZYZQtJkNLkRwykf2N3Wbcs3xmCB3loUgcDtNHD10UrJhsgGPeVRj/hCMTI/rGzzwwyh0xtTEsB+uNoFWQtv4y68AsOESxHIfH0I5WMjeDu/sgptOJX4FR2eYomGAl/brQjELT9JSCSjgySS+oCeO102bWHVSOREpuHCOrOyPho31fcZuga1H/vianF7K5N/SxQMxI5562X2NhKgt+c0yeIOVOGhkPP49JnrN1wuhuu95dZCp8Su8KxMYZ/DdMLIttB6q1GS1LthKq5B/va+Q9BUYSMDe1VKfqFaXV6Ymv1XDM12koTlXCI9fc7bxHsTxoBgrnBICc+2dYD0rZlilUkXYwmuWgmOjGBwRVfN15+LYsXd9MHzu2aOy37I6DhM/TO7GwagkfmOoSK1uhlNQwuthgcEWRox/52Z+0LyjLtCERTXzS1L/j2Ihj+8caStgonnkmEdCY2AUaYkpdFcLZ5byDjJAmqyomWXTvIbW9eMpwKSJag6knPW+9wGEJCUuc/IM3sNbvlx3RpW3sD7KfLWhXZWRN9uz+gMUrhlrnsA4904e2T3y1ysMX3GqTDcqVNgttrzo4JI+J4Qkng42usCwX7L2AXyQeWHfMp3pe1qPE97EC1oh+WMHkSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199021)(5660300002)(8676002)(31686004)(83380400001)(2616005)(186003)(26005)(53546011)(6506007)(86362001)(8936002)(31696002)(6666004)(316002)(36916002)(6486002)(66946007)(66556008)(41300700001)(66476007)(6512007)(478600001)(2906002)(36756003)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZFVQRzJ0TFMzUVREVGhkVHJSVGtoQ1J4Y0Y5S1IzUFN4NTQ3WFh4YzJ5VzJ0?=
 =?utf-8?B?VEdXL0dNb3VoUXpEaGNZSGhnOEVxdjZ1dVZZSm1lQThNL3NaRGtoSHFnd1lC?=
 =?utf-8?B?M2lmNWZjMHhaMVJGZkJ2VTN1VnozU25DdXBSNFVhcGFTbXlWYkJSN1dSQmpU?=
 =?utf-8?B?NzhNSFJnMmVMQmJkbmpnbTRLcW1ndlpSWkxLcDRsSzZJT0RNUDlKNForbTdw?=
 =?utf-8?B?Nm9INDdaOXJybVYxN1BUYVFJZkJXUUZ1eklUODI0S3ZaVDRwUmpqYW1FbzA4?=
 =?utf-8?B?R2RTRDRHelprc0pNUDFwam5mbEtHY3l3TmMzY2orU0Y3c3RWaXVwWkR3REQy?=
 =?utf-8?B?QTVaNTJrSWY4NHQvVlVvOGlQVXVVYm9MVkwyd2ZzRlpGYm0yNmtURXgrbEEx?=
 =?utf-8?B?bzJCRkViVlRYQW9qMXZCRm5NbWFMNER2aThIVkEvalh0QXBUTE9nZjY1S1p6?=
 =?utf-8?B?T09qWWFuSjY5by9jblJpZjNSWk9iNE56bEp5aDZZQnduWTdodHBOU3VucGdl?=
 =?utf-8?B?akFjQjRFbTZHMFlyTlBkY3BtM0g5THdDbVBQc1RyT2ZvcU4zVXVRajU3NlNP?=
 =?utf-8?B?aktvTmp1bGdPNFVxVW8xMXJPL0l2cUNHK01SZzIrL01PMC96VjVjT05admxG?=
 =?utf-8?B?c1VtYUptVFM3NWgvWlE0QVFoQ1pzWHZiTWZGM0FtUjR6T1FCTlduaVByQVEy?=
 =?utf-8?B?ZjdpMWtYZjNqeUU2eUowQXh6Nkc5d0tzY2UyL0xQNVNhdEcvQjJqNUlyWnB2?=
 =?utf-8?B?L21mekxUS3JkdjNOQ0NVRVR5WThoUzRMdHRlcGlWY1hNYjZjWlFLRlMrVDV1?=
 =?utf-8?B?a2NYY2EyeWFBNTRoYlk0Szc1cHN4cERwcnR3QU9hYzJ5WGcxdzdvZzJ1Z1ox?=
 =?utf-8?B?alJSUUh6UlhzUTZQQzNsN0pTOCs3L1dxQ3B1bFRSWDNhOU1JOUFwd3QySEpq?=
 =?utf-8?B?eE81YWVXc0JLVXlKWm1MQnZDSlE1aVdFSjU2Z2R5djhEZ1NtdmJJNVAxZkxV?=
 =?utf-8?B?MEN3LzA3eHRkTkc2dUp1aWdROW9sTXZJZm5LZlFCak04Szd3ak8rYWt0bXJJ?=
 =?utf-8?B?d3RmTDkweEFiZHBsYU5JUjhrQjVaZDdNSjVrVERDNmRoNXdZaEV1aFhQQnZT?=
 =?utf-8?B?cjBPUTF5Vk4zamt2VFZPMEIwdnM3Y3BSbnZ0b0dhVmxyU0ZkOWNubDFOREll?=
 =?utf-8?B?WmYxNURQZlRHc0NSUEkxVlRNQUVaMFpYWnZWVWpjeHp2ZUFrTGd5Ky8zR2ow?=
 =?utf-8?B?bHZieEpxRjMzSThaWkgyQ0NFcmVScjd2aCttREljOGxuaE80K2FoZjI0Q29k?=
 =?utf-8?B?SG5mZVppQVNhaTVqZGE1NlhUUVk1VEhQUDV6N3MzaFpUeW5uVjdHQ0EvbFA2?=
 =?utf-8?B?VGZpTUNUbmRYUHlHOC81RFpMeVdOZ0taVHdPaEhES1BmdEtsTk9NcDBYU2JK?=
 =?utf-8?B?bFBKdjBaUEFWejVTU2hpUzRWeWdPRzFVZTlsZDF5YllIRVplWmFJREpqMGd2?=
 =?utf-8?B?MTdBWkpzV25kZU14WFE2L2ZaWnN1STBPTlYvc2c0a3VpL1ZtSkRkRzVFRzdW?=
 =?utf-8?B?TUZOWnc2VTJMamVoQnl5ZDg4MTRPUzRpbWU0UmJjNVdkZGhIOFJsVjc0eFJE?=
 =?utf-8?B?dEpwOXNTVUpyVGkyRU1jaUxqdm43ZWpsckpxbHQ2WjBoVGswU2JzRythREMy?=
 =?utf-8?B?eFhLVHhXVVdnWTYyK0ZqeUV5TlhBOEl2dEt2OXNrUFV2TW5WSGI2b1A1ME1F?=
 =?utf-8?B?UkxsSEZqWTEwUXN3Wi84ZDJzUlpqdmZmYm9CMUYvT2FHUCtOR29mbnhQS2pM?=
 =?utf-8?B?NlhYbHR0UEwxOGhWR01oUGpoODFwSzQzUDhWQ0VyVjFmaEV4THlOWXhXOU9u?=
 =?utf-8?B?cTlsblNwNHRVOXg1azRBbVgyYTBqbVpJUFFUd1VGQzhxMS9FZGNKWHlQSlFP?=
 =?utf-8?B?K1NJMk8vY01KcFR4aTYwQVZUN0psQmt5TGxKbkk2R3o1bytSaEtWTjJnMHVm?=
 =?utf-8?B?REIvZ0E2N2pWTmNUMnNUN1ZNN2dKVkl3L01XNC9SMUg5K1pQQWZkWFEzVmFQ?=
 =?utf-8?B?SENTZnV4OG1ydUUreFZkNE8rQ2VEUDBJUll5TlFkUDlNd1d3NG9mQkd2UHpZ?=
 =?utf-8?B?K3YrenF2NFB3TkZLblNxcHpiRk16V241UGZPZnVPUnoxZUE5ZFdCL2lNK1BE?=
 =?utf-8?B?clE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: blflTGw5f4SALdNEqbubOt1Bh3O8U63r/aWafbuUqDcUhDDefi0u7RXIdUnllnYJr6en14XSSt+FVXq9hhl0FbqGAROI4DaMjDmtBs5KrNW+mhPFXmeHG3nZ/ksO1XnKXTAooSTLqonPhgtVPaIYBoNLvzGj1X6XXVGd4g+SxC9UAs0OEnWcLrK+XXaqPNv+BzLUfcnkVV3/lCRc3viseoSpYosh43gZX17D9Ij//JK5kkr2mFPl1xfTAxh816qzGSC9Qyh4VMYkO5uQk+rTlDeg2dzqZPTVa23UOyMK55Gr4hrn0Xqtn3/kIxQCVUiRiCCQuW3K8C0/H3ZIlw7hSFNTprKlwBjKzYPAQ/qkm5KEEXpXBWZebMOrf7CVrFISMQu2/4/nmfu1AUamZl5bG4W1gs59ReoCe8SnFpPdOsjnFKlZvAOUR1yGxnkBjrFnQcB6viqHuQSOZgVqrbJDjfdI3IUxA6/DcdqrX2WM1kZJbSveEHRlwslaWKqm3GDrKOjYwg6xHhWTikRQzTq6d/hZRm7r+2PppctuypB89zec3rTtTbbD0qxVr+zt8mC9aFZq/hR3CCs8P1GFXbfrFjnsoG4B77x/ogcY24B1towevK/M0A29jbLcH51mvzFcnvGp9mb1ijYVMVDUh+X6hYfkxmzGT19ipyM4M0c3yEpRqd7iV/f5uS4ONCyGapG/g1VE6MOhxlnX7zzupfBeJpPF2S2V8CvgaghWGox5c27sTUrzHo0joAS7ukRUN/pxTjHob7oR7OZ7T+lNlyjar7sXidjRYMVxuR/MTSN2Ral4JJD9j1HExUqTztZ6begnVqKKkNpMazQcLIlkK04qRpioGdxy87MkMfii45rvf4rHQ1uB87q9PfvNXSJFWGP9
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47e8c4fb-3607-4379-9615-08db8e772157
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2023 07:57:31.6703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dgRX8BgrydKYU97rNOdbaaEP1YWAQFUev93uChM2wrrvbwwkFvWVTYtbm7lS1AtDJAyjR9dsYLrgY1bDcTlIIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-26_08,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307270069
X-Proofpoint-ORIG-GUID: asjm_niK93bXkGq3moMbz3tjM8cReseg
X-Proofpoint-GUID: asjm_niK93bXkGq3moMbz3tjM8cReseg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/07/2023 22:34, Mike Christie wrote:
> The sshdr passed into scsi_execute_cmd is only initialized if
> scsi_execute_cmd returns >= 0, and scsi_mode_sense will convert all non
> good statuses like check conditions to -EIO. This has scsi_mode_sense
> callers that were possibly accessing an uninitialized sshdrs to only
> access it if we got -EIO.
> 

sd_read_cache_type() -> sd_do_mode_sense() -> scsi_execute_cmd() may 
never return -EIO without getting as far as init'ing the sshdr, right?

> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/sd.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index deac35fb520b..53719cf9d86e 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2966,7 +2966,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
>   	}
>   
>   bad_sense:
> -	if (scsi_sense_valid(&sshdr) &&
> +	if (res == -EIO && scsi_sense_valid(&sshdr) &&
>   	    sshdr.sense_key == ILLEGAL_REQUEST &&
>   	    sshdr.asc == 0x24 && sshdr.ascq == 0x0)
>   		/* Invalid field in CDB */
> @@ -3014,7 +3014,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
>   		sd_first_printk(KERN_WARNING, sdkp,
>   			  "getting Control mode page failed, assume no ATO\n");
>   
> -		if (scsi_sense_valid(&sshdr))
> +		if (res == -EIO && scsi_sense_valid(&sshdr))
>   			sd_print_sense_hdr(sdkp, &sshdr);
>   
>   		return;

