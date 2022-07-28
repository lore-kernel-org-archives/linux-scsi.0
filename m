Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB47AC19F2B
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jul 2022 18:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbiG1Smf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jul 2022 14:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbiG1Smd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2022 14:42:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D743F7539D;
        Thu, 28 Jul 2022 11:42:32 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26SGxFia009496;
        Thu, 28 Jul 2022 18:42:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=MVAYaMKnvde+RI5omzPq2W4oBo8jOzacpZOHXJpvVo0=;
 b=Cdmi4x5IXUFs4bQK+6pk+9RSpl7Sfr1n9T3QaMH7qyhoi3OEmyv18gLkdDDD8xBrOUjC
 KA5Z+a5ZzLyQ/PrdMjt9Y5VKSljLn1jLdpTHHXHH4cHcZO7rI8G9Av9OBXAWj80aA7Es
 cf5SoNfkNCeI834HAQJHvqysKxS4alvkU3pWGAQDf8QjSpI6sixXGB/y7ARScfC1r03m
 oRb8bFhY9kH0IOBC/1aDYnZFMDPSYCUzrp1GX+Kk2Gq5dDorNve5bPSb3pfEwLz1or8s
 f9SQfe4x+oi3JHCxd2OPFR/Mb6OmbwbW5MhQ1qsuLeMDyV1+6hD5MDFSSqDOaVPAUf/H EA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg9a4wk36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jul 2022 18:42:31 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26SH81Vl029770;
        Thu, 28 Jul 2022 18:42:31 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2049.outbound.protection.outlook.com [104.47.56.49])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hkt7c5ucj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jul 2022 18:42:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZbkBhaozuAwwxxzdqOnZCM2oFI4AmdGLfh9fsNfTSDfSvLJn9KdAx2QZRBcyCvWrLfiQ7fJzKGk1icjDVAY5nK0al3bQN6wB9eT7JiNy0J/36aEcI1LoAgIZXIEVbTlykRW6/w9BAMGkpwxPOcg3JwapGarQs2+FEKsd3AV5wWxbv8fdTzev0U+7l2BQhEfFcuapTc0NmgMph+Y7mu0LNc5ZdIVc3GPCvH+U/X7vMAjhNgnwPM9B+6d2XVkUoX9eE3kZQhP70SL4P9vQDZ1/h4IdLQyIlpNDYLQu4RT/PokHP9aH81MgEU11EUd6VxrRv6MCeIjhboIfjiMHIvq4/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MVAYaMKnvde+RI5omzPq2W4oBo8jOzacpZOHXJpvVo0=;
 b=RJA0/7aaPriLGSCLnxouxiiicEMg/y6n9KVZFIWFvSHSwB4cyaVqF1kHbB5uoXGthAm6OqxyWujAxL2x69Ry8PcLK23GSNo4Ni25wq6MYt3oStyYlZkZinForU2+FHWe+8NsTcV0yLuJrR7fKA9JVC+fTsW2ZkAHi0NfYGT4+4uNs7okwDx9zm+PrdQPlx4B6Gjh6X/PagdY6P4ZLidWlkmqDqCXQID9gTa0yeHl9HrSe891xtmucmYpZ/xXd8f5OiPr/mwUBbjKZUPN18L4HT0xK3RmhmA7UCzeuH/quU/7G8Y8WKesehhvBhNTdn8H5sP53AH4KiWNNXqi8vastQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MVAYaMKnvde+RI5omzPq2W4oBo8jOzacpZOHXJpvVo0=;
 b=EXhkwOdIGtQF1dFoXLKqVYLAepmUT1zWR+8DqpmJSVm3+gX7/q2/MIZdrIlAe+fC16JdmQNQxq9+21WbeSMKnjBBcB2XbTcCPjjQu5t+bw/tgyE39Q+rBi7IGDl0xqDDFFQVlnX5Ugm4N0Nzos2PZ0jLGQ2Ux4pY9qTqBeAmaS4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4566.namprd10.prod.outlook.com (2603:10b6:510:36::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.19; Thu, 28 Jul 2022 18:42:29 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5458.025; Thu, 28 Jul 2022
 18:42:28 +0000
Message-ID: <791a84ff-2046-cb7a-4758-81f4788dfd6f@oracle.com>
Date:   Thu, 28 Jul 2022 13:42:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH v2 0/2] target: core: fix race during ACL removal
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com
References: <20220727214125.19647-1-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220727214125.19647-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR19CA0011.namprd19.prod.outlook.com
 (2603:10b6:610:4d::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4dc635b1-ae7b-445d-3b20-08da70c8ec48
X-MS-TrafficTypeDiagnostic: PH0PR10MB4566:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pq57oIXCPZSkRMsx34rZdCb9MoDJUk+Ru4XUAtWJ73UlVV4/FnM9ixwwmXzevJ9bMkYSf/AkLfP3dYSve9FOZdXfXRv66fXwRXfCdjeHk90Hgn6iRWo+Bou7W6KYq55S+F/LYoSZDqTbZb53oxbPla9/jHrmAZkvsU6jzCcQZDg6JhVcKAMoqqqBvrGNJBTWXxf2ARabUA78Z2gXe27jpqEm8jhagKf3N4CJmkkm1qxOHe6YZb6IrBZNLQLpRawTpuxW2pvR9wj9p3rboPtD1NhCkYcyzjXBStYTseOr04v47yE5GB+OPrMCspjlfTvvDN5L1wyxUg2XeuXe5IOPIIKoLUfZGHze+ce6rk+Eamth9jwgKrZP1OeR60HR77R6/3t4FFynyN6MCj3NYa+YnTByLCWK9ik7HCoAJ4yVuFPDC+/QMSL4sZ4c9xy/ZNt78L87ekUBccf23dFEOPp3lY7uLcFjFIY699T4+ScW5Qu1piEaky/D8QH4KHE5J8JnnIztoQGgeCSPjpPQdvU4eS2wAltNxcYG+dtUY3rZlHyQybwqlhmRlsHmNHwl40rkyPnUpfZvf4cv9L2Co48pxFRgJSNjnWw5Iz2miZU1UDZ7LVZ4lonmBSHxBJt7h1QeTjzzGJdQNBPa0AukoMr62QYD2zzDy7lOuao0RRjqJ872NPwaxvQCI95qC8ZTkK7dv/PGgi0cILt98CEDr0bPdDIYKNl147pvNSsXROqKQPDWf3jnbE9yrn845mIVXHFZ1QeLNSRrMIW5U5TzmYdkQ0XRuYUMLJJsnZ/mFxyFZzD239je3ugjFFltf6dBKNehjEYcaNDjres/j94+CBddpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(396003)(136003)(39860400002)(376002)(186003)(41300700001)(31696002)(316002)(38100700002)(66946007)(31686004)(36756003)(83380400001)(2906002)(86362001)(110136005)(6506007)(2616005)(66556008)(4744005)(66476007)(53546011)(478600001)(4326008)(6486002)(5660300002)(8936002)(6512007)(8676002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?djFpZGxwRXFqcDJUWUZJTnVaWXoxZ29yYlpCUUwybXFnZkdwdUlqU1ViS1Fx?=
 =?utf-8?B?OE5TNk43MENYRkRidFc3NUdrVE5Fa2RUSDliTkw4TkgrMHVkTlZvLzN3elZi?=
 =?utf-8?B?Wjc2OGh2S29FOUs4bVFmVjFYUlhqUHB5WHBOeG00SjdEOFhWcTRhVFc4ZWZJ?=
 =?utf-8?B?UkIySlAzNlBkLzdCcjcvaDhOMCtvZndTTkNQWW9oWXJuT3M2ZDA2bTk5RGJo?=
 =?utf-8?B?VkJCOXhiZmNhMVNiUWIwK2Q3eWhxQ3FUOHFHWWpHNnJuV1A1OU9PQWdGTGRZ?=
 =?utf-8?B?L1FMZ09jQWNxK0tDWndYZnhrcGNyeDIwb0k0YjNTeEtRdFJPNFBZeTFnYVRl?=
 =?utf-8?B?K1NnaGVjdUtjaURpTmk0dXREd0J6UzUyYUQwRWVkYkJpdExMMEJZUkxYNjRS?=
 =?utf-8?B?Zm9DdCtDSG9RN25UbGR2ZGV5cThEeDJqZkp0YUxVZXJUdFJPZkJNVmR1aHlP?=
 =?utf-8?B?S1dFNURhaERBS1dWUGIvdjZYVjV5OVNTOVBhMjArclM4bzU2eG9kVHFVMnlj?=
 =?utf-8?B?clJMR3pmUEdEbXRnZmhvd3h3ZnRPYUd5UFg1ZVJIT2dZSlhRUWg1UnVLZy9Z?=
 =?utf-8?B?NTJyWFpQNjdUaWdjMzZHSnI2RjArRGZCaWw2Y3hBaVQwOUFReWxnMTJDdFc5?=
 =?utf-8?B?TlJ6dnlWamNLZ09ROGZHcEkzYkY2R3lCYlJtZHREYUlWeVJNQ1ZpRjBieU5P?=
 =?utf-8?B?VFNuOXlrYzlWYkFBcjBIeEUzMGhVN09LQ3YzeXZlL0xZZnI0QmVkTHB1czhD?=
 =?utf-8?B?aXRaRnBoZDVRdEZWWFdIaDd0THd3VTB3V1VKVHZVa2VGdG5zNkM1QUx1OWM3?=
 =?utf-8?B?UUQzd2Z6SFV0TmtUN1VGVVI0eEhzUlk2QkMrMmRrV0hDK2llOFFENW5aZGtj?=
 =?utf-8?B?WGdiVDZqRU44R1lBaEdZQnp4SCtZby9NZFJYdUQ0WmVYSnZYeG5YOEdQNGlZ?=
 =?utf-8?B?N09vbkFuais0azNFc3A4KzVBb0NiNGRPalFrZ0VpakZlT1RWdlQxZzhQem5h?=
 =?utf-8?B?Unh0YmFsblNRM1NvTytCc21mWWJYTU1QbkVWN3NoMGJLMjVSWkNlYXZobTFR?=
 =?utf-8?B?Y0E2NG5SSDFuQlFQU0kvM1VEYkxIL0h0SUtVS0tKWUlFSXJzYzBLYTFiamoy?=
 =?utf-8?B?ZjVxVGgvVUxBYStJeHJzRC9FbFAvc1pQME9BVm95Q1UrdUhhbDhaMENNMHQ3?=
 =?utf-8?B?cmJDQWc2M2dYMGhVTGhUelFRUkZIMUczNHVtU2Zoay9oLy8zSnZRdWFTTVJD?=
 =?utf-8?B?VWM4Q0xtQ05pQk1vU3l4VXJRUktoMUwvOWczOE54QTRJbXYrd1h3TUhRS0hr?=
 =?utf-8?B?TFo3REpab3lIaXdkOUdDZDRwWUZScTFsblB6b0xkc3l2bDlueDhUME9OYldh?=
 =?utf-8?B?UzJCNDgyT1pPVTI0OWdmZDZidmV5Um1Ock5MdG1FbWdOSVcyQi9SY3RST3FJ?=
 =?utf-8?B?MzR3YmhMdFE2SFFaMys1RGpqcFMrUGJOVVpkVFpjS3NxYnVFMk9aWm5PZG9r?=
 =?utf-8?B?VzJmbDc4OUt1bnpGbWgwZWJpMGxZSElxTjIxWC9vNUM0Qmx1eWliOUcwald2?=
 =?utf-8?B?cHU1NGU3TmVORjBMbEtuQmtPd294ci9FRWE4RnZIN2VZQU9CQnN0SDlMVHc3?=
 =?utf-8?B?dVd6WnBKR0t5QzA5c2xkekxoUmdRdXBuUW1CbDZUQkVPcWJaQTRhbTFpWDc4?=
 =?utf-8?B?cTZFblBkem1INTc3MURzTmxZWWhraEd0ejJmQm51Lzg3TVdKbVN1OG9WQjJY?=
 =?utf-8?B?T2kyaHJ5UnlRckJsQzBtRWt5K2g3ck0wOVM1SXo3THZSSEt2eGxxMmU1Zmwr?=
 =?utf-8?B?SFppRVZ1SDBGQkN2K0RDQjMzTGtzQWNJY3Radyt2N0V3SmZCQjAweFY3RXBZ?=
 =?utf-8?B?UkJqLzBaNDltbmxlK1lucmwreGQrUlZ1MmhsQjNJKzNIVC9NVHh2UUt4T1Mw?=
 =?utf-8?B?MmZGQy9xNE9UQ05BSVNiTDJCWnFjM1NIV0I1ZzQxVjg0Y0tnOE4xclZTV2VL?=
 =?utf-8?B?VWxvbVhaTnJydFN2UGdqb3pTNEFKeWdHOExDTXNVa3lXVEdnaTNCNkowaElB?=
 =?utf-8?B?NHZYakNSVTg0SW5rV1VaVk84TUZMbUhrSTBCTzRRc0Z5eHMxV2k0NTNmUUVk?=
 =?utf-8?B?eGFZWldJMFdxa1p0Sjl6dXdEUmZZZEJNb1kxckEyaWdQTWFmN1BvT2poZVZq?=
 =?utf-8?B?QVE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dc635b1-ae7b-445d-3b20-08da70c8ec48
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 18:42:28.7835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PP2O4FPgH87YpBOWzofsJXjivt7kk6BeZU04X9a/Cz6+fmzBse6+rAHgfalXJ1GaFBXJkz09OqLoA3yHVUfYGIe4gi5+tMkHiCM3bYe+Glg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4566
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_06,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207280085
X-Proofpoint-ORIG-GUID: adjf0-pCvd3Tz4BOCuvDX4g74JqWMgOW
X-Proofpoint-GUID: adjf0-pCvd3Tz4BOCuvDX4g74JqWMgOW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/27/22 4:41 PM, Dmitry Bogdanov wrote:
> This patchset fixes a race condition due to incorrect usage of RCU
> for se_dev_entry.se_lun variable when ACL is being removed.
> 
> Based on 5.20/scsi-queue.
> 
> v2:
>   add more details in commit message
>   fix misformatting
> 
> Dmitry Bogdanov (2):
>   target: core: fix race during ACL removal
>   target: core: de-RCU of se_lun and se_lun acl
> 
>  drivers/target/target_core_alua.c   |  3 +--
>  drivers/target/target_core_device.c | 32 ++++++++++-------------------
>  drivers/target/target_core_pr.c     | 28 ++++++++-----------------
>  drivers/target/target_core_stat.c   | 10 ++++-----
>  drivers/target/target_core_xcopy.c  |  2 +-
>  include/target/target_core_base.h   |  4 ++--
>  6 files changed, 27 insertions(+), 52 deletions(-)
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>
