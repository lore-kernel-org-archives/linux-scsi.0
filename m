Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E8DDC00144
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jul 2022 15:59:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236504AbiG2P7g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jul 2022 11:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiG2P7e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jul 2022 11:59:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6563A8735E
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2022 08:59:33 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26TETanq021500;
        Fri, 29 Jul 2022 15:59:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=sezo8juw1SEuAr0++vJ/GuLMpZ621nd38/dLwX8UjK0=;
 b=laXK7vKKbx7qObELX33SLbS1YT8i4MPGXUH/K6qdsfoYDW1ftSJdA4kL3NIQjJPD8xmx
 t/ADl4j6dzwEGXYze/Qi4yiqR6vb6NaoD9HfeMJkrDsA5Ttxpipv/j+JtA++x29ZqA3o
 cGACmBc2c8upggpDqQjaz/0fgrVQnw1hhrINyGZMjypxAX5sei17zeXtlv4JU7tgw2I2
 OlUCc3emxyNPImOJJ35l8IeZwTzkOc/gp0veVh26stx4ZfEQnRIZ30CHeeo5zDVRD4T2
 oFt7CLffBmToxfsRrj+8/uoBb62fb//51FfAsBywqxif+B/KUOg0ixg4ISBbGqxSb/La Jw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg9ap74vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jul 2022 15:59:22 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26TECX7H023181;
        Fri, 29 Jul 2022 15:59:21 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hh5yymwha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jul 2022 15:59:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PU1K3b7bpUGT9J0owyoO7C+ZCOW9WP7dE7GUihyaVmPE3MzNAsX6HTf0UMtGGBj+DsM2OT1jn4KJzH0l209MxuVbRst5q4HHau6K4bkQKl53yaTg6CgPK1UEWHv8/q7VqMBmsTNmRoJvZ/zyoF0/fxSpEAScXJ8B9EHXmI2tqz7f4WTYzLikeSjrmyTlRyQaCX90Nw9g9tfh1MSRimIPleUwaZijWcgiBCXWrKalQZTXrnKjRFD/ZmGEgmalGIYf3K9Sp9QoyKIItEGfC9mKT9qb1/obrrjSFTruSMl2Ax9JIlf0MdOHRiMQeiHwSDg/sQOiL1V/K15AezKzUq5vkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sezo8juw1SEuAr0++vJ/GuLMpZ621nd38/dLwX8UjK0=;
 b=GvTFUJJuyMhxfDQWD1taFxRl8gC0X7gPtVkBp9602f0/8bX5cE02WeB+hV4p8DK60xdt7qTEcR6Fun5w836p00gheWyY1DhIYRw9FmCMkMdZkMnpLvefT3vomvmgNnf2GajOt8mZ80Koymdt2WGzG1KKphGQ6nKbQi68eZut29AhO67HPzAh1OFH2SJx5z+MyTtSNz/IZxsSfdMw9175uTiqwkUf+mmRcqLA61SjVR2kE14xuQpt3H0L1tp9n3XBkSMaT5WIuc9yLt4LgupddaMVTCPnhwMWTVyUEdznvJBsEFON9EiV2fMO2lJ9dnoVib82TxvOAzgZqDzZhbVKKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sezo8juw1SEuAr0++vJ/GuLMpZ621nd38/dLwX8UjK0=;
 b=rql2CBOfOr/6htiMerf4RW8pwfyBvoErIXRlZJKnP/lCLExSnUIL7Vb6qsjPokakRRW8F2vtunRMRp4Do7fXROhaVw/uXtnDWtj13ieWYDH7SH8NURVSxkFWmvIZZyQicGvvbbHdnRC6c8kitXBlXYmJD5oMNj/ARPSSTXuSKps=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM5PR10MB1833.namprd10.prod.outlook.com (2603:10b6:3:10e::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5482.11; Fri, 29 Jul 2022 15:59:20 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5482.012; Fri, 29 Jul 2022
 15:59:19 +0000
Message-ID: <46756c61-52f9-df9a-2b93-57c71aa6f5ee@oracle.com>
Date:   Fri, 29 Jul 2022 10:59:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH v5 0/4] Call blk_mq_free_tag_set() earlier
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>
References: <20220728221851.1822295-1-bvanassche@acm.org>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220728221851.1822295-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR17CA0019.namprd17.prod.outlook.com
 (2603:10b6:610:53::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59add38e-b124-4115-b17f-08da717b4bf9
X-MS-TrafficTypeDiagnostic: DM5PR10MB1833:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6PvSce9PW5QHyC1efJuSnhrqcKBu3QbKUFwQPB5bl6QTfcpmSdsSgTWfaY0/pkozJmQZu4qmfbhsC4P3VKHh1j+iiLAHZIrXQ2ibf+T6abgSDJZ7NAzQOjCAFRLwLDP9K8lKiT5M6xseTLRm3a124l6yd8JifumA55jvqJN0NTFsfsJeAG3uXu0YNsODbx70aU3Apo7VcEVw+zLCY/NusD+5dekcbimZ1GjfZHbY+OlC9zneO+Bqo0UZQyNXzROf2rm/svmvhWpLkBXyGBCT1zr/mpEJ49EylaIMktz+VVJxJc9pzaRW72JCCtAVEAc/eq74updj33ROukJVdsHFEH/QY4ZMERtfc0SyoNNdhmNzGi57jewFjkxXiXjp81VE7rtuGyx+IsxdMJELpzEehZhUpjngoH9VVbyRVkGRNAT1t4hgi9dRDS39LGNqSgKbAGQYSZn3F2yvksUKP4d3qMghTrpzo4hjvLRoaHeQ6/t2vdpycPGT9YVRR0dnsl0fOBAOw+vlVFXh5KWeMr9vVgf3uGOAwJq91P6NsH4L7hLfoP90GHfiLnS8lAkEGvTgHWx+1jFbcUl/ZYIMv3xoxy5BjXUSKcEYd1sQHkLGJKkSv4+Yf8aIBYOGxiQ0hqeu5y3xCwdcahVrg+TcpUYZD82QusAZDjnl9j6gln5E0L8XHINWgE/hQDQI7Qpy5MexIivauNwYvEwDUwDsGYPWdl+gZp8DuW9Xh1+AaemPtCfM9a7R+vHfnq9YXLkyPc7iydIgh7ll6k0R+VykUlHeQo9ZcOhw26nSAHA/H7q0O9CsGrWxOTEdw6efYMUB1iNrWmoI7vo5bSVdkY6jFNmbqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(39860400002)(396003)(136003)(376002)(66476007)(36756003)(6486002)(478600001)(31686004)(66946007)(2616005)(186003)(41300700001)(558084003)(83380400001)(316002)(53546011)(86362001)(31696002)(26005)(2906002)(6512007)(6506007)(6636002)(110136005)(4326008)(66556008)(54906003)(8676002)(8936002)(38100700002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cjhxZjdDZ1hCeVd6dzdzbXRucStlQ3RZNk9FUDJpZWlQdjVFOVY4eFNYdDdv?=
 =?utf-8?B?cURsTHZsVmFJNUZnQnlWOEsxMXpCU0xIQmNIeFFud1ZqdmMvYlNIWWt0SGFm?=
 =?utf-8?B?clRZU3dFVXlXME5hNFFpM29hQkhBS2xXblpqSWFiN2dHbW4vKzdId0ZBZGJJ?=
 =?utf-8?B?b0JWZlc1QWo4NS9aaCt3ZTRYMFExdjYrUENvQVdrT05ESUJRaWZRamZnbFpZ?=
 =?utf-8?B?OWVhOWI4MjhPV1VxaEV4b3Nxc3I2bUlFbUwyYWpMTFpReTFMUWpxYTVmd3hQ?=
 =?utf-8?B?OVZuMVR6Tkl5Ny80VFFBTkRMTUFVWTMvSUlqRS9wT1N3YTczd0Z6RWx3TzZR?=
 =?utf-8?B?czZmNTdhTWx2Y2FaNTBwMnRkdUd3QXFqekVDYTR3aTM3cTZqbUpjcWlOQ2k5?=
 =?utf-8?B?YW1UY3R4c28yNFhtbDZIaWM5MFNtN050YXoxMVlPVVB6aitoMDl4ZENqd090?=
 =?utf-8?B?dHJPakRNbXpUMXVCNzRkOFR5SWxaU3g4ZVVuZHRpMnpOTTZ3ZjFJS3NCMTIx?=
 =?utf-8?B?dlZrcUt5TkpqNnU3cG9kcXgrNGV2K0VhZGVocFIyWTlPdGtFeXdZSHhmTnU5?=
 =?utf-8?B?c3pOR0gzZ3hrNTNGZjFxcGd0SVpodlN6ekR4ZGQ2Y1RmYkUxU0swRlZ6T0ox?=
 =?utf-8?B?WjIrVGl5dUNlWnVnN3V4SFdUYkZSTDMzMmZrdW82ZWoxbTRQRmh0YTdMS1d6?=
 =?utf-8?B?bkdTMWpXbHp0eUZ3VUpoTG5NdktaZ1Z2aC9vaWVralZEakNteVFDTjI2LzlE?=
 =?utf-8?B?VThJTjVDY1VGRzkzVkZrUDA0UkJHRU5qRnRidzhYTWovbjdrTjdzN1FlK05h?=
 =?utf-8?B?Y3VFeUlGV1dkallnYThhaTZzOTNKYkFCRVRBNm5rSGVIVUttdElZbFN5Ujhu?=
 =?utf-8?B?THV0V2RmY29PLzVOaXZnaXhsemVVQkxYNm9BalhCS0YwV0J1MUZzdkNaSlp6?=
 =?utf-8?B?dzYvbkFDTG4zdmFFL0RBSHVCMHJxQ3I4NGw0Mk96eVdxOGJROUVmZExUUUZk?=
 =?utf-8?B?dXZCb1FSWmRPNnd5QThHbE82Q3dhL1pNcms2LzltOHRVR0FIZnl4UEJyeEMz?=
 =?utf-8?B?c3lvQmpPcjNzTlhEd0FPSXZOdFltZTVhSFhTeFFzVkRxZ2dnWmVjV0dWd3Vl?=
 =?utf-8?B?NUw0c2h6cTA1Qnc5WVo1TU9Scm5yaUhyV1RZL3FzN3RFdzl6R25CbnBPS3kz?=
 =?utf-8?B?cVo1UDU1OVk2OWwrVHJ5VDJBTWswUlB6ZTYzZlZ4K1BnZGVkcVNadkQ0WVNl?=
 =?utf-8?B?ZERhaFkzZWJRTmRyY0VDNEh3cFQ3M1V1MFM4TFpqekpxYU5aTWNWRGhuV0FU?=
 =?utf-8?B?d0lteVJpLzZXTWZjeFp4M1dWWmJkZGxtRTdXTitJL2taMU5kMXJrM0NTN0xR?=
 =?utf-8?B?U2NPVVdOQVNYK3ZSSFpoQjJzQWNQQ0JaRFNRN09qSDZpbFJaN1R4czhHS2ha?=
 =?utf-8?B?QTRSbURuMjIyQ2dMZEZ2YXhTc1N0R1QyK3pzRzl5WVhDRW9CL0ZFU2dRL3dz?=
 =?utf-8?B?OGRWN1Zod0tPZDQ5QmdaQnlCdWUvQ3JIT29OMjNGVHIzTWhVcDBDcGlGYWZ0?=
 =?utf-8?B?MDhOb2hvbk4yOU9LNFg4SUZkbjErRmx5YmpRcU43YWlwN3dKSGhXVkdtUmpU?=
 =?utf-8?B?M1B6K29lcmFiU0pHNWJGczR1dXQvNm9yYkt1MHlKbkZFbnhYVXdYMTRMRmZP?=
 =?utf-8?B?SUZKdUtiK2hINitWQ0NFdWdhL2hkbjBJZTBrYTIxVFdWV3RoNjZzL3FMN05k?=
 =?utf-8?B?WVlxZGdKVjNxUHFZU0pzOUNqWTliYVBzcUYxZXFWdm1lekhpRmxEa3J4SE00?=
 =?utf-8?B?TTJZL0IyQk1pbFRxYjV3dzhoYVZMaERpdFFnOWcrRmx4Q2xZSngxYWdaTkQ2?=
 =?utf-8?B?cmdZMFVxaEs0Q01ScHdNdUczV0VZNjBKbmozdGVpZUpxdFkybmdBOVpnVjVq?=
 =?utf-8?B?YURGY2p4SmpOc0RwQVUvbDd1clVTc3RxYnNhNWZiRTZKQ0F2YlVQWDZPakFV?=
 =?utf-8?B?VDlCMlM1NEN3QlpZSFpKcDlpcjB1bVJJblFwaVozbTNFNVpMMC9Xb1ArNXFS?=
 =?utf-8?B?Z21ac0xQZXYzbW5tdkpqUkF4OHFQTUg2WW04TFp3Yy9uSXk0RmYrQWRHUmZK?=
 =?utf-8?B?akhjMW5Sdkdub1g2UXExVlRxU3VkYmhmZ0p0K0pZUGN5US9MSlNjbUNKSC9n?=
 =?utf-8?B?UlE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59add38e-b124-4115-b17f-08da717b4bf9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 15:59:19.7480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8INiC0dFHXWNkYSb4xkzgtkPhpJRaZf4E+AgdvMRBFvZjPaONW/qQ+Vx/MJxYdTzY66v6IlbxBZ96ph+yxXDZF4We6NZ3ZY9mg0SbWRLAro=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1833
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-29_17,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207290071
X-Proofpoint-ORIG-GUID: FJ0WUFu2yQec0paGhNMm44jku8qKr0cI
X-Proofpoint-GUID: FJ0WUFu2yQec0paGhNMm44jku8qKr0cI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/28/22 5:18 PM, Bart Van Assche wrote:
> Hi Martin,
> 
> This patch series fixes a recently reported use-after-free in the SRP driver.
> Please consider this patch series for kernel v5.20.
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>
