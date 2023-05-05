Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78B73C77B75
	for <linux-scsi@archiver.kernel.org>; Fri,  5 May 2023 15:44:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbjEEPoi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 May 2023 11:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232938AbjEEPof (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 May 2023 11:44:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EA4156B8
        for <linux-scsi@vger.kernel.org>; Fri,  5 May 2023 08:44:34 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 345EY5S1015377;
        Fri, 5 May 2023 15:44:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=wspfctVyons1fUSSIoUxH/Zt/jAkww1F3MLE47fnvas=;
 b=0DwAfizeY6a7mv1eo9rUvFWleOvHd799GUgGQOO6kHbxEwl+3oI746c2n3QL0FkNX3ia
 lQwj33GBepIO8twlh+D+RzKYI9R8rhOspHt0q6qhtktoJKNZy+YoNLjA2UUpt2ERIpi2
 cpjhBhU/KHABqtdhQhWAjVCr4St95AuRPgh0xmSrZN/n0UEwA2w0OcySCRK6PlpLfizE
 t4hy3PxPg+zi5Tbt/TOnsMCNidnbZ3r8Fil5HOTLs8GkckNgdVLcnGKGv0odudFyKIT3
 331PLfAYbFmB/LlvWe16O5hF2b+ff63el7cM9R4WpFXUvjzAdF20r5eZjWWSi5gdQiJk mw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q8t145a6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 May 2023 15:44:10 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 345F4tPk020742;
        Fri, 5 May 2023 15:44:09 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3q8spa1dna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 May 2023 15:44:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gkunEIuXlKggwueVlTk5nlsJUUaENMkLZmj1Mdo6yazxlnXUES/uURjtjYPpEsNvAucnEhz/oH0N6htT8K4aHAO5yOugwmqYP/uEcYyiiwyYuQnhCpRpV0ZIfXhI7ICycQMn99OYWbgjBXUEEbAM6Pm/JxWzit5HkZcaIUycThC5L/QRQXeMn6dczJNUAYoDUjS7lKrewUHRRm51UPr9VMM2w1gc0GOABoqxfITL1FRg70UYU7xR8awGMHtbaGtJr7jJ8FLW/H1fOVPfyCVJYlM6kqCXCi3CJtiGF6FNv3jbvApyWDmRuyApgCOxF3qA0U2eMnQoGJpSq0g5GlJWEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wspfctVyons1fUSSIoUxH/Zt/jAkww1F3MLE47fnvas=;
 b=CBqVPUeXmQjEIMvLuA6ynRIpWyuPd48vGdAAXzIVN2tY/XDBjDR9iwBP1vAUFHBMBKvXrw+P83iCBgWJ9NfQuy5vKiZsW7O3T5T1FvVYkbTBfdcEG/N9MyuibZJcxp/oUnRfkaWXV+FN2kcbq2eVSz3mRf9oJfBoVpZ8uk9+3pusThkI0X4fpOASx/OsKtpuIUMikKwsKLDWFWU4mEh47jx0A69bIQIMrPpTwc1ICbXJ+GYwih0C0dLWpLhbg4Bf+6WWffIVyT2NFvtRvMqBkUIlxVZwhP5A1CpbIhyDD5zdBK8ELtmJtoYdWfpw9eNYN3Vgmpt77OKhSugrZ12pLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wspfctVyons1fUSSIoUxH/Zt/jAkww1F3MLE47fnvas=;
 b=IJHtMCqFzoOgm+9sQVu6Xpqq5dxMIbI9inkrJ6A5BY9qmN25J1rFmUpX8qx61o8Dk5uHK6iPPK8IHYkVZv4d6S+8aaUMuv7m6+D+7MhEYWap0i3Ssya/RDsiGGCmYPespkpBxbvAB12SYhNX+1CUfCW2xbi5lchXnIgobqWycbE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5629.namprd10.prod.outlook.com (2603:10b6:a03:3e2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.27; Fri, 5 May
 2023 15:44:07 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::264c:5118:2153:91ef]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::264c:5118:2153:91ef%12]) with mapi id 15.20.6363.027; Fri, 5 May 2023
 15:44:07 +0000
Message-ID: <cbb74079-678b-912d-ce26-c1a8555627d8@oracle.com>
Date:   Fri, 5 May 2023 10:44:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH 1/5] scsi: core: Rework scsi_host_block()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, Ye Bin <yebin10@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230504235052.4423-1-bvanassche@acm.org>
 <20230504235052.4423-2-bvanassche@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230504235052.4423-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR08CA0065.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::39) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ0PR10MB5629:EE_
X-MS-Office365-Filtering-Correlation-Id: 111759c7-c584-4cb0-28a1-08db4d7f8fcd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6mLVRQF+ZIZ+xTwxiff+H0FrbrJ7oNTLhQcH2VRVbqA1A8XTfwONLLGKpESmSFh13IuVSEPjqYA53COgnPAYAAtM27cBVzJgx21ZQul1UthSHjc+wYfeX7ep1E1mnupOh8+AtQvuR/ctdrvyIc4iE7gku3tJoI3rFqdcm6QLGLqPS6/eLvUWJ7i4TQR+U0CK5OkBOAE62icTmJUmdyrN+0GJ7bMpCF0cHpFrzvV8gpIojwSdcKw1gWF/tXUvc3s3MBN89dtdmss6uvQYdVDN2bT0q6nbxp9WUnPR3PqmFcaQcFhB9vrUnH1SV4xNUIISltINoeqwsT3y87vTQjz5HKwbyZvAmAM5VAv5G5i/IEBjYlzB9TpGmOeTa5nUtY+vlquEGhoLAXCoLrZUBAS25aLpmlxPD8dagImRH6VtjRvcJVCiyBm584MiB+xpkbZcYxtgoRr3FLk9LrHOgi8I5iRYTcR4colWeh59980NrVqe26i3E9gqmTOQz/vAQVhOk5ts3fMVyh26H0iu0I2w6wy+ugTa72HU+s47LF5VxmLZGlw1+KQa2Fkehc2r6+iomAH0Sl9sjQQS4lQ1HY3xg/SSFNLu9AizG0uI4SnxfyeCzcduOUIZm1agSfoNWywmWlNPPeWPqKc7wron7RiUFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(136003)(396003)(346002)(39860400002)(451199021)(86362001)(2616005)(36756003)(186003)(2906002)(31696002)(38100700002)(83380400001)(5660300002)(8936002)(8676002)(66476007)(66556008)(4326008)(6636002)(66946007)(41300700001)(478600001)(6486002)(316002)(31686004)(26005)(6506007)(6512007)(53546011)(54906003)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MS80a2V4enh5Vjlya0hXTThRaUc4L3VvZGpnSC9pV3Zvejh2eFF6bkxrL3VU?=
 =?utf-8?B?VlN5ekE1K2Z3Rm93T2tzdm95b2kvZ1NjYk9vUklKb254aDFjT1V5WUlDYkhi?=
 =?utf-8?B?SHNjcWVTZzUyMy94QnByUE8vU1hRZ0VWZWdYK25GOTFlZ1IyZkRrQVU3ODls?=
 =?utf-8?B?SFA0TG95aDZEZzI3cjJDb0RDdTBSTGl4Qmh5Z1Q3SmViUGNHNVJrZ1lzN0xU?=
 =?utf-8?B?U3E4ZUgvMDk1ME5yb0R5Ny9xbnFPZkRZY25BbHlzMlE4MlRuMkJKVlZNeE1v?=
 =?utf-8?B?aWxsVU9sVUVteW5YZml6cUtieko1RysxVHdEN1dmMDFpVUpsaVVaWUZ6eWJa?=
 =?utf-8?B?Tm9jOThCaEFzMzFtcnR3dlQvTGRSbTQwWnRvQVBoS0Y1M3VaNUpweExaRXMv?=
 =?utf-8?B?Y3VXU1p5V2R1dVJmNWFrNEZUaVZHRG5UeGhPQk1qK3MrWE5hdUJvd253b1d6?=
 =?utf-8?B?enRyYWNkZS92SlVERzRTYTFvMTZCZWM3dDVEMllQazQ2WUw4U3RtUkpGNGp5?=
 =?utf-8?B?ZUk1dEI0eldEZWdDWTh4UmZmTmo3akk5Q1J2WmZvemEvbXhlMmpCbTRjZFl2?=
 =?utf-8?B?a2txRWJueE1DOUd5UGxTV2p0cmJ2TDVUSm9sM1I1YU5UQm1Vb0ZteDFGdDJa?=
 =?utf-8?B?ZldTSWhYVDNVS2xsZGtPQ0RtaG9MT0JsYkFVY1IwVVhXbm10K3dLM2RXd1M3?=
 =?utf-8?B?ZnFtQ2FQUWFtTEZTYzJxaWNmc1JMdzI5M2VURWluMmpram5vS0N1amhLeGhW?=
 =?utf-8?B?VXBiR0wzWFZzQWcxVlNZVjlVRjJtMWhyWkxIeFhUL0JJOVI3cEF5MzByaHhw?=
 =?utf-8?B?c0hseWZ5R3MvcGdXdHVrT2d6a3B0TzdVRDdBUnBnQmREL3BtLzJqZU1RSUlK?=
 =?utf-8?B?MjJrS2dXcXptZkdrbXpndVVKZFU3cFMvbmduOG9PeGdiaXdNdzV0K1VmbXRU?=
 =?utf-8?B?ZEVlaCt4N2hmZFBGend0ZU1JMjhVcUJXWWhYc05POUdDMnFOYUFGVTErQzcx?=
 =?utf-8?B?cjBSOHFGaFlaazEyNExwYlhzYWFRci8xQmEyTEpTQ0RHRWdIbWVLRTJCTFpF?=
 =?utf-8?B?d3BWWGxmR0tNN3k3S09UVmNaNGVpMmJmYTBnZTEvNHJJclFMaFJSZGdISHE0?=
 =?utf-8?B?aHd4QUZNVW40RlRLL1c3SXV0SWlERFU1cUQrRnpMb3BJaldBMzlwN0llUTZV?=
 =?utf-8?B?RG8wNG1qcHA5V1VZZmx0UUpUN2wxQUFBZ0p0NGV5STZNd0FVRFh6aGNhSXBh?=
 =?utf-8?B?ZXZxZzR0MC9tVkNTZGRYVmFqbWhjMDVBQnUrK1M4UGRwcGdadWFFTmlxQnBr?=
 =?utf-8?B?RWUyYWdsNVVLQlVXZ3grTlZOQ2xvSE9vT0xwLzJUSFRLRE1XMXArZm9SYjJw?=
 =?utf-8?B?U3p1dVRjd1JFZVhRRFd5cHA5Vnd4OHB0NTNONTdtcDJiNWI3d2JHRGdhZ3VH?=
 =?utf-8?B?TlZTdldUUWtMQUx1NTdlSU9FWitZckxqZENudG9qeks0VkJRaDQrY0Fob28y?=
 =?utf-8?B?UnZnTE9xbEFwUG8rNzFtQmYzYmVIYnFUb2dOa0RZUFV1N1Q1WmF2cnN3clVO?=
 =?utf-8?B?UWlSRG56Z0Uyckh2OGNYM2txRkRkUkFxaWduZERSdmIwZ3RydDlWUXpzb2VW?=
 =?utf-8?B?bXY5QWVxQzF2K0lMYzhnRHZSNlhKNXl3aG5WNHRvaDdnMHUzb1RLWmRpTU9h?=
 =?utf-8?B?WlF1ZEpiVnVKYVJkMFMvc2czcEZGdmR1VzFOQW9VT0JVK20vNHpNaWRTRzIv?=
 =?utf-8?B?Q0pJUzhFQkdNZ29waU9tcW9DRUd2RTJlcldwWXpBQlg5YU13ajd1alJ5dnV2?=
 =?utf-8?B?WGcvSzZ0ZWtUSGtBT05RclUzQ3lmRVQxQ1hEYktQY3ZBWHZzNDBYdGtnVkFQ?=
 =?utf-8?B?K2lqQmx2ZnBrcXlrRTVCeUVFKzBXTTllNzJJbzlPVmFFdTErSTEyMWV1R3I4?=
 =?utf-8?B?WkVKNUs4M29BRkJMNEFCS0pCL2NyZUxhUGZtbFArQzUwck1DY1FPbktvUUlW?=
 =?utf-8?B?ZXlCUXMybVhObTBYMmdQcXFMZDlBZmRMYk5yUW45UUtmb0NEd00xZ2QrMDlG?=
 =?utf-8?B?VW9xb2RqZXhXcTFYdnBMZzdFYVhtb2JIWk5TU21va0dLT0pTeENpREtzMXBr?=
 =?utf-8?B?REJKS05oRElwZ0dCa1dyb2JSVGJyaU84WXFmZ2FXSHp1SXVUYnZ5SUpWbWd4?=
 =?utf-8?B?aXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: F07aBT4DaEe8EVbsuXT7aLl+SiHDIlEey/05ydXX4W4An0uihjbE7AiLHIhkxXN7iZtFxu2Negh3QBWiMa5fhITYMlizAPBfNFSgxNcuNz1CQyoPVVuiDHlOp+jbuysXPQE0s+FKw4dKJsGStlGyNtZSPv2amyLAdbzJFZi6hpPWXgEIfjbioIAO6ZQF3E+P/hBYxwM3AFqDY78eDhS+kqPr4i//ZfwojPOGXMAETZcRmvlJr+Y4T6rk/dRuBILLaYhXddTkzl4Jfbvev9xm+pgKbXLo/uRLlsR4NgCHeLq41JxBq7nL97EUelZYy5OOn3iJNz7dBp0zkJvRc9rYibz5J2KjtQ7kRrqyqiJqNdvHMyZMnIKFXO0lMJeO5jT+4RAkszBnaH1J5UOFmAFdHWcDm5+yrvnnhw8dOzQNWysD5FPsbAi1cRf71qk9suO4BeBFv7gWvKi0zdBmEzsDdvyibbJNnjyTrPfGO1c30n9iOdNsO4FPsRhO3gBxrMJRlZHFy4LnEyxQZy8tRMRVkw+ahmpHwqhcwH8do+7P/jJifs8MNXUiJyXXTCUfOwdhnTWzM/5YclWiMtmOpQUD3cLj8WMIDem19YGqMuaMYLkUscG/6AWebHbwjLSdx6KY1bfB/AJWl1SqmVUsQKU4i690bkWQSc8+gzxP2x92tIcLS2Su1XjZkFASaR4X/DXINdZFPUh/gxMqNv09+eT26dJjmAxSmcrQDmpUPGPcrTid5scC2IXdBxG/JLOZL49i1/1mHY2ugqbr3KlaZVpNB39PLXRRAti10xP8lGCTMo8hWuKG+EjmnnMG6HrlsGsG9zKgSfTFvRAMI4pvLKBUr3B4AeMpZRIfGM9cpkPXynglU5/i1wKAB7vRa6fB4DRn5Ctkdj+L5zwzP+bbOv6hZL24sp4ikeMh6OG/PA5p064=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 111759c7-c584-4cb0-28a1-08db4d7f8fcd
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2023 15:44:07.3016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6BWmUvtp/L+MXOE5S4/6Pkp5KSOj3Ygp2lUWTxu9qSWZV66HnwlbicESIkJAgOO2aiemVwD/0dIjl2IXzqXAYgWDu56yoo+AKcJ63aKn6Hw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5629
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-05_22,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2305050131
X-Proofpoint-GUID: JHQNbhDN_RGZBBqy7IH_OzGax8ymeh7h
X-Proofpoint-ORIG-GUID: JHQNbhDN_RGZBBqy7IH_OzGax8ymeh7h
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/4/23 6:50 PM, Bart Van Assche wrote:
> Make scsi_host_block() easier to read by converting it to the widely used
> early-return style. This patch reworks code introduced by commit
> f983622ae605 ("scsi: core: Avoid calling synchronize_rcu() for each device
> in scsi_host_block()").
> 
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Ye Bin <yebin10@huawei.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_lib.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index b7c569a42aa4..758a57616dd3 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2939,11 +2939,20 @@ scsi_target_unblock(struct device *dev, enum scsi_device_state new_state)
>  }
>  EXPORT_SYMBOL_GPL(scsi_target_unblock);
>  
> +/**
> + * scsi_host_block - Try to transition all logical units to the SDEV_BLOCK state
> + * @shost: device to block
> + *
> + * Pause SCSI command processing for all logical units associated with the SCSI
> + * host and wait until pending scsi_queue_rq() calls have finished.
> + *
> + * Returns zero if successful or a negative error code upon failure.
> + */
>  int
>  scsi_host_block(struct Scsi_Host *shost)
>  {
>  	struct scsi_device *sdev;
> -	int ret = 0;
> +	int ret;
>  
>  	/*
>  	 * Call scsi_internal_device_block_nowait so we can avoid
> @@ -2955,7 +2964,7 @@ scsi_host_block(struct Scsi_Host *shost)
>  		mutex_unlock(&sdev->state_mutex);
>  		if (ret) {
>  			scsi_device_put(sdev);
> -			break;
> +			return ret;
>  		}
>  	}
>  
> @@ -2965,10 +2974,9 @@ scsi_host_block(struct Scsi_Host *shost)
>  	 */
>  	WARN_ON_ONCE(shost->tag_set.flags & BLK_MQ_F_BLOCKING);
>  
> -	if (!ret)
> -		synchronize_rcu();
> +	synchronize_rcu();
>  
> -	return ret;
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(scsi_host_block);
>  

Reviewed-by: Mike Christie <michael.christie@oracle.com>
