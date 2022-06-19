Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E75C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jun 2022 16:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234303AbiFSQZz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jun 2022 12:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiFSQZy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jun 2022 12:25:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1EBA474;
        Sun, 19 Jun 2022 09:25:53 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25J7J9qH000687;
        Sun, 19 Jun 2022 16:25:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=WvE2QlqUz6pO7bNL2b7lyq09HT2iP5/jjrICGXszUlA=;
 b=aMtxAdhjXtSUG0g6QI3uidwmABjTxG2L13PEmH30T+ZZpCJjI/NvyAQ7kP6efOtoPeGu
 /G13Rfoqa0mZzdUYaVp6j9+omQQugqOYY6gt7Tw6Ovhjlms99YpxzDYDybK8m/BKFvr3
 /Z7bkFap31BCLeWxArnSHw0yP7bc4RCdMk/ksJvm4J5P4dpZ9gKzm/WDLXKE2dCF1XPW
 XaZJagF3vGpXkY3AMuhSD9Z0kT69kFyzyRQdR9bf9Ns8DzcvAIhUgaAUbdgFzIFP+yRJ
 9LRvMQ/ltms3aVUogDICLxzkGpOU15ULADF0GV3x5eVzGQXntV9nUp0EkOF1+Xmn/LaO vQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs54chpbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Jun 2022 16:25:39 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25JGAcau016235;
        Sun, 19 Jun 2022 16:25:38 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gs557nqwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Jun 2022 16:25:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZWh+iTnFcTH6K3oOoZTTC6SCjjAYYpQ6VXJbeOrpP7Zip2FkQY0PTIqxszBVuwBAQx7B+iECs+cgGV4m46vYFno/6Vh4Xo8Gt7+NtSTWbIKCUqRwnYYZHhtWvp9yuOJSF1Kind+CooZiJnH/D+e1nKsRpyWDXNRUNtkgCNeeBoRchwOJs25V9Vg4A22FOKIXaw6i2oP1yH4hRWkUJxiuXe0lPs1/kXF+93FMRcRfXhiyrlUrJtERolWOM1Uf4xsXIWFXUjdvh8jmFW4Z0u9ZfcMRzKYeEga2HpdntSrK9UiFikcvuEsiPnngb/ii4rW2N7fTT0H6MIIMf0d+k7sT5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WvE2QlqUz6pO7bNL2b7lyq09HT2iP5/jjrICGXszUlA=;
 b=F6ctRRnzSy6meViQkp/+gkYj6+T6/PMA49KvUrauCtX6HjjUMrXWUXvbWfClEiNCea74QignCLjgxCmCtxgXGgtBFh+vF4NVvNgngufYX8yCF4h13k3AYqed+A5Mwp3oS6G+rWEKVb3PUKcQiGuTwzxQo2le690EEVaqd6tVkKNvCTZGoW+CQFumxTBUaV5UCdMBU7hM3kVx/v7gb0+BXz3QaD6cf1815vSm0ykYv8tx/qfe9sFrVwfrBsXCx8W8Zn9a6wgUEJ4jZR6JW+DBRPduYqRkgi2g2lSgbX4dmS6Chs9MtiK6Qxb/BLsd+hH2W00H7nYu6ZXqkh1Hq4+Wcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WvE2QlqUz6pO7bNL2b7lyq09HT2iP5/jjrICGXszUlA=;
 b=k+3Dr2DyEFUJM+5U4dMZbaatOumr2pkaBD2aego26n0HjARYM+RwvwbPYgvXASVjLsIhErpzdNaOFz5ePRSfZxxXnil2qllfsjEUiRfqH3CH7A81GRGqzduBhhlshYJzaAvGkVGg4cYcPtSM1AZF9vMey7rjH/ojgK3whWwzDLw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB5302.namprd10.prod.outlook.com (2603:10b6:408:117::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Sun, 19 Jun
 2022 16:25:36 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5353.018; Sun, 19 Jun 2022
 16:25:36 +0000
Message-ID: <b154e89c-6b83-2d8d-0505-06fc3615e8a7@oracle.com>
Date:   Sun, 19 Jun 2022 11:25:33 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH 1/4] scsi: target: Fix WRITE_SAME NDOB size check
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220617030440.116427-1-michael.christie@oracle.com>
 <20220617030440.116427-2-michael.christie@oracle.com>
 <Yq7AmRBWtkyqzt0g@infradead.org>
From:   michael.christie@oracle.com
In-Reply-To: <Yq7AmRBWtkyqzt0g@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR07CA0167.namprd07.prod.outlook.com
 (2603:10b6:3:ee::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6da33a0c-e737-4e9e-f12f-08da52105747
X-MS-TrafficTypeDiagnostic: BN0PR10MB5302:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB53023A6A28C7FE04DD8A5BBAF1B19@BN0PR10MB5302.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nkoQrKAFJ+Y1Ai/kuz0GMUfNKvsWpqhviNGtPUXsL5Wg6pd219iIz8J4JCdG02OCeIFbRegvuKDN4CH4i4jdpFNsaZD0DI4PD1AGXLbZeM8YaRVKO+GntlvwMFFT6NLogq9WT2XTMAkTqugUNQakjeGZLqEqYW7pdnZJZL8UG0tF5HmWOHnKB8EZRg0PIVp0Qc7E71qlehLxfIM3G360CsI0LiXfa/bnOulzOVUXpw5qxEhtZkUAnxvWnu9vkZ7WwsdRcvtW7cA3CvvcnzCZzpUvWSEwMJ3KBY+Zgcu7nunKfTinZO4N8X3raWNYlH1TU6xYuOOcdTMcAQGAVVstWa5OXxW/+8ZynE0ogmCrekdWt50k6LCnaLBSDJPD4guwp/cB2BpoiAk6asWJxx3hZJgLIUh2nNuabfdBwei4jI/HQabZbHnB9k6Lxd0710adixH4yCW9+bBaSEchGaVbHyE1pYDEJ7/UfGBR9FXbBKjxycE7BHs/D3IinVH0Q9UjwXduiJkK17RwWfAE/kqvFF3mSid68eagNBVIgKaTnLF0WPmYt/Ebw8pnaKSNO/xm7b8Fxl0XByBgNWHhO3mPOR+nLDI98/9qwYKpyJBnptjROjcdti2JjW1uIud8IbYk/9V+lLQ8Hqejil+zk9vYPvhDqtfZyeR2qw/MZYarDT/4m80rUdISo3pAWgJupE1fvPTaimNEQhEN9KD7YDCx9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6916009)(66556008)(53546011)(186003)(6666004)(31696002)(6486002)(8936002)(6506007)(4744005)(31686004)(4326008)(8676002)(2616005)(5660300002)(66946007)(66476007)(36756003)(316002)(6512007)(9686003)(38100700002)(26005)(2906002)(83380400001)(498600001)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QUxnZ0FneldIaVRYZ3pzdFFTUlRCSVZHTEhIZzBpLzJ5eDJZOFdMdGJyTnR4?=
 =?utf-8?B?MzRtNTQra3ZhdmpDdkJENzI2M1MzS0M5cERjc01MNjJaWlM3dFFldUFBTEdv?=
 =?utf-8?B?dFZFTGliZUJJTE1jN3owOGcxOXFnTGtyUFc5MEtTeTZoN1J2V2NaSU44Y0dY?=
 =?utf-8?B?NlJFdXZyL2FSdEdEeXR2VytPWDhRTkFKZnpkeGNseVNwblZnMC9CZVVMU2RP?=
 =?utf-8?B?N25tZGFLN3ZBUUdVanBwb0tiKzJweXcwVFdGbGRLazdTU21nN0Q2RDZ5ZG9j?=
 =?utf-8?B?K1BxRE9DT0NyY05hVnRMWEkyUnFtd0VmdnZLVTZJYktjNUtTMyt6NHpuMERI?=
 =?utf-8?B?SnI1dUl2MmFHUnhZNS9NUFQxa0kzWUx3R0ZTUU03UVhLTGgvT1lyRDJOQ0c0?=
 =?utf-8?B?VEpVNlVqbUpSWTNKcUdpQnErMUZuREdBQmd1cGpaeXI1d3AyZ3ZrK25tZHhU?=
 =?utf-8?B?WmtmNSsxY0lhMTZyODUvNmNidnN0V1ZTRVpkNUs4WTQ0Q2RxTjJqYjdlc0Ja?=
 =?utf-8?B?WkVLOGMwcEdWN1l4T09IRldFbzByTkdtc1ZpblYzNURLbUNFZzdBbDdiaDNi?=
 =?utf-8?B?ODNLWkgzRTNaSXlBNUxjNm41dmZ6ZTRRd29Kd3NMbmE5TWxGYksrSVFhbGRp?=
 =?utf-8?B?V1luQW93NnlqK1VpSTE5R2taeUdHS2cxUlFOcEtkMHJYTWpyam0yZVllVVRM?=
 =?utf-8?B?MDRPdnZ3MTExZXJpbXg1cUdudG9TQVNMczhORVZ3QXpia0g1L0l4bjFPdlVF?=
 =?utf-8?B?bXZkclNrS1hIMUpCdUxKNXdMTWJEWjRibHYxVGtYUVBjZVVhTHFYb1ZFZVVh?=
 =?utf-8?B?dkVzcjJvcFB6V2Y1TkJQdWRqQWc5THJlYTlxUE9Kd0pxSnd2cVdoTFQ0YkNI?=
 =?utf-8?B?ckpFcWFUcWVWNklCcThBQmZzYUdDOVNjNGs4ek0rOFRDQUxsN2NvMUR1S2Uz?=
 =?utf-8?B?YmtWM2RLcitmSjJOTE1ZQ2I2MjZCd0pNZ0pldC9Wamt2dXVhV0h6bGVYREp5?=
 =?utf-8?B?SU8vWjc3bUdHVXhFYjV2U2JLS1Nrem5yV3BrK2tOL1dGYkE5TGU2Q1VTWGx6?=
 =?utf-8?B?cktOV3pVT09UNHhqRnRpMmJGRHJVa3BTaEJ6Z091R1kzb29RQ0lab0J0TENO?=
 =?utf-8?B?UW5RdVVTZk5Jeit2ODZpRmd1UzIwS2NhRFUxUHVWcW9rKzRpQWNzWko5aHZY?=
 =?utf-8?B?K1RQbXB3MmRCdHIvd2t5bzVYWjNNbWpEQmNJdGhzUGxNV2VvVmFVd3lPM3li?=
 =?utf-8?B?YkxQSXNKRlJxaGdqc3pNeUNPUDFtSzgxTkdwTTBCclB3dDdPZmpiNHpHYkdz?=
 =?utf-8?B?K1NhMm1uWTdLYW9Ed1lWdm45VnJzNElJR3p1ZTBWR2tDUm1FaHJQY25kdi9j?=
 =?utf-8?B?OFZOMXhUVkRsalBFUm1mbm00Z1dBYWdZc0s5Z2tFdk9WekRGM0thYURoaWdY?=
 =?utf-8?B?THJlNGdBOWhEK1RHWElOaXQwT09iL2U1NHF1Ulc2a1lvbm03MXcydGRINmxC?=
 =?utf-8?B?TnJQdXM1UFoxRnMzaXFuZU9tdnRyMCtkQlR2aFkrcVl1UWpyOCtYb2pqNmkr?=
 =?utf-8?B?dnlmOE1aV2tLcU5zQklLREZ6THNhSDIycC9RSmNRTVJLaVRveFptUVRmNHpY?=
 =?utf-8?B?R3JqTWgwQWp6NUdBZ1k0M0wvRFZiWHBTS0sxOUNWT25rVkVHOWhweWhSZXBw?=
 =?utf-8?B?NHdaVmt1MXFhTzZRbzRMNnlveW5RRnRoZnlRdVVCbVduZTF4MFpvY1A3aUF1?=
 =?utf-8?B?NG5jSXMwc0lmREJMRHZzbUpoVldXRnRURnlheHNBNXMvQzJaYzAzSU1xUm5t?=
 =?utf-8?B?aE1COWpmdGljOVc4ZklGcmR5MkJRZTc5ZS9hVndmaTVDRzN4L2R2VmNnWjFD?=
 =?utf-8?B?eHluZWIrZFM3c09jQUFOdEptN3RweVU1NjNBcHRweWdZbFJ3UnEzSXo5MWRH?=
 =?utf-8?B?dEFQaDl0Tk42S3JOMnBYaGVUQXhjTytXZ0kvUEhlZ0tVbWtrNVMwT0hTcUNL?=
 =?utf-8?B?Q2VNOThtSnBnUEhxQk1zTEN2WEJXT2NNejRLNlp6RDNTVlVxVXJoSSt3VEI5?=
 =?utf-8?B?bENqaTh5RzhHaStYakZxd1dFa09OVEpPelZLTVcwb2h6V3IzQk5MMXFWN3da?=
 =?utf-8?B?RmphOUg4YTNKYlV5L1JvbXluZXZ0L3RJd3M4RzJUcExtMkhjYllzU3VZMjVk?=
 =?utf-8?B?Y2p0aGNMMm01dFNnZU9hajYwcm03YjNUV0VkU0hyOEpVRGV2SDNhOWV1RHY3?=
 =?utf-8?B?dEV2WkxET3Q4a1hpU0JYK2txQzRCSnlGdm1rVm5aUmhqKzR6SmhKWnk0V2lG?=
 =?utf-8?B?Z0cvS0RZWVorUmJJd0g1YURhckcrZytjTXZsMk9IZFp3VHRvOHlFOVRnN0VH?=
 =?utf-8?Q?iVjUAy9VAs1rJQy0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6da33a0c-e737-4e9e-f12f-08da52105747
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2022 16:25:36.5039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +mcf/q8HNVraFwzcs8lAJNrPo8bKY1eFx6wuvYoJ+DAxSpP4xN4HoYMqU9bWGKk514jr4utZo10+/Kz/2Mao1m6M+trRvAIMxXIE53kqwMs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5302
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-19_08:2022-06-17,2022-06-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206190080
X-Proofpoint-GUID: pdNmfZjGiXqlDnqBD87iG0FQ2ajd6kJB
X-Proofpoint-ORIG-GUID: pdNmfZjGiXqlDnqBD87iG0FQ2ajd6kJB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/19/22 1:22 AM, Christoph Hellwig wrote:
> On Thu, Jun 16, 2022 at 10:04:36PM -0500, Mike Christie wrote:
>> If the WRITE_SAME NDOB bit is set then there is not going to be a
>> buffer. LIO core will then complain:
>>
>> TARGET_CORE[iSCSI]: Expected Transfer Length: 0 does not match SCSI CDB
>> Length: 512 for SAM Opcode: 0x93
>>
>> This fixes the issue by detecting when the bit is set and adjusting the
>> size.
> 
> 
> The patch looks good and useful, but right the taret code doesn't even
> support MI_REPORT_SUPPORTED_OPERATION_CODES to report support for NDOB,
> so who ends up using it?

sg_write_same allows it. We found the bug because some user just decided
to do:

sg_write_same ... -nbod .. /dev/sdb

and it crashed the box.

I didn't know about the MI_REPORT_SUPPORTED_OPERATION_CODES part of it.
I don't need support for the feature. I just want to fix the crash.
I prefer just returning failure since nothing ever has ever used it if
other people prefer that as well.
