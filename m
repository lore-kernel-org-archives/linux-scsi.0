Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CA5DC43334
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 15:41:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240307AbiGNPlQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jul 2022 11:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240169AbiGNPlP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2022 11:41:15 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821B23FA36
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 08:41:14 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26EDck6e008489;
        Thu, 14 Jul 2022 15:40:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=7Grha4IY9IfMclEQRO9/THNu1FJc0iGeWAAvL07HBtk=;
 b=aDCE0dPNQQxMyHJ1D0DQPzncfw4tyGykgjd1uaj1DZX8dZ9hGvk7U08j+wuYTMBmwglX
 UZhLCmxWZSGTb9adOBYBGMK89/ClP2TtxfrT3imcpzgVedHm8OQ4EhhAKYVRxsstje8n
 DOyAgxmqaCpZEz20dNHIP4VcpwusisbT8NWvOr5BXuHMWAb0dHfkf1c1sQt6/NNYwM2p
 gNrBlbHdQrLIUI+QHTkEXwUBcXI9IXxBeUnNmeSa7ud+GMz+H5bx7lbiB6Rw0TdnCg6V
 aBEbOerdsDgpDeNv0aLvFK1mC+dtGvWzcvWu4pg0/kUcDVDVFra1zsx0gaa8U3G2FMPj eA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71scdnrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 15:40:57 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26EFagSS015845;
        Thu, 14 Jul 2022 15:40:56 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h7045nrxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 15:40:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JqsdXV5/Vhe9Mc5weHppy9x9YfwEx2JfUaV6sit2UIV/T+t2FhnDzYIeAi8Lc3yXjiLnrbXyhEnjqSa+8kxTBL6iPao7b9OSz1ZP2cMPvW+EDXvFkxgSQm6QBpLSH5wy274nP4hKuyRrMAoGpSvDu52iBlJjjY5ouaIof74jfvSDFAtfzbXeXcW+oxhLHvodm4zyeQBL2tO7eO4x9FS48Ln+IKOSS4LOcrSFk98iT/bTYj6V1GL0eHcb1drAdCY2pku4Iw4bvSLsUYtHGvdi4QHrZiBDkcAJPEz6WLjXNgIV9ThlquAwmjLg/QExH8DZYIQKQo0EZVqOXhjUDRiHXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Grha4IY9IfMclEQRO9/THNu1FJc0iGeWAAvL07HBtk=;
 b=EWAby7WJTpGY1Jf/uGP1XdvYZUpn0lspf9oenB6NjDXsWxFHYOtDtovSpxRXEbl0OAvgCiJP5euO7kc4+/+0HQiw2tNCjwyht82/Nj/wY+TH51L/D1C3To5s5/6l5EzE0MrgwVvUiR+tZRbdGO56TMjAWVy7obNkaaBEy5axc1I0/cVG3NlC30pHhjSXIQC1KYX5Q4Z2uvR3cszPktZSCF1NKQyWm9Ib2bB2mgEwgdkdkZSx7fEyD+luWTF6MgOatkCd/A4TLssYdquWZbogjgfaQzxHkk1dYrmzvI3w5E30af8keMDiEojPrK7AEv+Olyam3eB+CuAhVt82Mp9WfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Grha4IY9IfMclEQRO9/THNu1FJc0iGeWAAvL07HBtk=;
 b=avwBiFk1AoRp7nSLS5YuY+AxKvxeZINLETLCkr4xr6Q2x7stis/Qd4bO5noO++AdtGFuVEHJkU45JpLc6wyAQNSWTyMXhT0jWfzKthsArSJuWgM2UG9c8QT/VkoulDgGhVGAo+q7IQsMqs4flx6SkW5gKGlsa+fKKxCO2jJZAz4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN6PR10MB1283.namprd10.prod.outlook.com (2603:10b6:404:45::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.12; Thu, 14 Jul 2022 15:40:54 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5417.027; Thu, 14 Jul 2022
 15:40:54 +0000
Message-ID: <7b540a5c-16b4-d990-f4a8-8b69adc9599b@oracle.com>
Date:   Thu, 14 Jul 2022 10:40:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH v3 1/2] scsi: core: Make sure that hosts outlive targets
 and devices
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>
References: <20220707182122.3797-1-bvanassche@acm.org>
 <20220707182122.3797-2-bvanassche@acm.org>
 <8fa5f4a0-fcdf-365d-8c42-9ab4041f2a8e@oracle.com>
 <88942839-e618-010b-07a7-76e0a302b1c3@acm.org>
 <97718f6c-9635-8980-ec04-739241a3984d@oracle.com>
In-Reply-To: <97718f6c-9635-8980-ec04-739241a3984d@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR08CA0056.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ca6cc87-16bb-4223-6dc5-08da65af3d12
X-MS-TrafficTypeDiagnostic: BN6PR10MB1283:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5cmfBIJE/sBS+kIHwczje7nsWBpfCZeYY4TbAf4TTXf4QT/1gJfT+I8CVyCc4ucLasmmFsSOh3MsH+WiZAFb0pSBKarST/PDQC4yO2PMYHxO8CdQlzjrCBb/XhDkw4BzuadIYW1IMfXbnH0oRb6I92XC+1VmD2okhncet74CDW8Kumj7D9xQq0WMk5rWELVhWG0a5YICCFg0gz/oUjA1hRju+0GvKe4wKB7GmI2JTvrhry8qItkV7zczyO8QAWyEw8Vo3mfLf+3lctr2/8Jco/dWFqBYcLepeJMOLUNfvVbC+6PBPg3IX1m8XQ/S4xFfiKwMDxcLij5dU5bMTJLsjuQuKq3clSNLx+hm1KMsqiwwfrZ7xnKmR/e4Xry5SmKjG/3zq0pKJbyxA8ZxfR6pyZtQ7Vgb4cyzQHlAq3nKEH/uJA01wct173+7INcovm6l9SJlyea4Et5ZX5zNdGLdwGgLn9DYeu9R1s54hwS7Xq2WkqQ3G6TCMvKdPctoVKZTY+YD2H95NOiegdOueHgnqTOqBedC9gVTk/LCEnOgE1Qf36Sii6wYuQRvz0/n7Fc0JCPVUiycg4G9cy7L12UKITse27B/CmFjJFSxiF5q0o69lD0v2VJdtclvk9H+aPijWIRf+z1NmqwUkKh8QqnDfzbbFhju4F1R4yzKcLem9rTg5ZAoqO67CAwiBnZn6Mdko1Wl9E7KXPzk0QLkUxF+nVNWKE+fYAw7ZctcfgjSM4jYvugMFXINb310e8vWOJvQspiDGYcCgZoxGebQ2ISRCW1osmReugpwQpc0f07Jt0OnLtu/fMYyYPvuE5ft2Rr+5GUnK5yM5P7SuPxqrOdglL63UEoCqJz8K4JWrRx7KHw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(136003)(39860400002)(366004)(396003)(26005)(83380400001)(6512007)(41300700001)(53546011)(6506007)(2616005)(186003)(478600001)(2906002)(5660300002)(6486002)(110136005)(8676002)(54906003)(316002)(36756003)(66476007)(4326008)(8936002)(38100700002)(86362001)(66556008)(31686004)(6636002)(66946007)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z21GNUdvUEdlRXVLLzJBWFpVSGlxZUlycG81Y04wL3JIeFQ4REM4UXJMNytX?=
 =?utf-8?B?SzRpTE12YUh4SHhYM0RrbS8reGVhMDI2cnRKdzZnOEdHOGVsYWlWVG9YUlVv?=
 =?utf-8?B?ejJrSmpxRVN5SmYrcDJZUVQ2YTFWVm5GSVpraW5mVGJoc0szdTE4VFB4UjBz?=
 =?utf-8?B?TnQ1MW5ZZVEybUU3dDg1RThzdy9peDJoRHcra3NnRU9ZVjRJN0V4M1pRMllq?=
 =?utf-8?B?MzFPbHdHSERTNmQva2YvT05xd3V0WHZFOUtTdEdmUUkrdUdEemtjQXJDU3dR?=
 =?utf-8?B?amV4V21tWWtnV2VlUlpmYkN4UmdVMXQ5d1Brd2U3ZDBBbE02M0V1SUFpeHNo?=
 =?utf-8?B?M3dwN3RqclFsWG1BMmtZc0RTR3NzWloxc211RFRuU1VQTVh6enpNYW5KM3JP?=
 =?utf-8?B?NmRjaUJjcUtoY2dSdFZEejRubnNXb08rKzlGK29ESGtvRkFpNkhvdk42Z3Jl?=
 =?utf-8?B?MzJGb0REUTZ3VWJ6czRrbU5KT2ZXMFNwRi9rNy9DcEhlRVl1b3MyU3NQWEli?=
 =?utf-8?B?M0pPazlTb0xwakMzd0pHTXFGVC9uOGpwNnNqemh1UTR5S050aEVxc0FQK3Z6?=
 =?utf-8?B?VDc2S3JmN0dqSERzUkhVR3hiS0p6OTlBdUhFbG5aVjZzU2pGNUdPaENTR1Nu?=
 =?utf-8?B?aThPOUtsY1ZxRForY1UrQkx1c21mcEhKeXlwVDBkQTR3TUNNV0t1dVAraE1P?=
 =?utf-8?B?UStnMnArTjlhbkRtY2xENWVzd1VGZTdmd25SbWhhRlNGNmZ6bloyRVpWOCtJ?=
 =?utf-8?B?d3o5TUJKRDRhOFFiRnB3dUx6UkNpc05aS1M2TlhWT2NzQ0k4Y2trRm9VNTFZ?=
 =?utf-8?B?VHN1cGVyREFPUFhsS1ZmWG5Sa3BjODZIbG1yanhIcEg2ZkpUeFBjL29HY1pM?=
 =?utf-8?B?SEw4aFFsNzV4YXVkaSszV2ZHUW9vcnFXeEtGYkhLVFg5NUR0dy9UaHF5TFd2?=
 =?utf-8?B?eEFyY0oxR3J3SmtSN3NzSFVsTTN3WWUybnFVZVkvR2MwR1JLZmliL1I1VGw0?=
 =?utf-8?B?aE95TTNaT0FuZjJ1SGE3UzltRGxwV0k2YklxVEFRbVgxVWJKaWRyZXVwaEYz?=
 =?utf-8?B?azlqdUg3UEJZNmJXNUFvOTZIVUViMXFmbzFSaGhKQzcrNE9tcFZGeStkZG1Z?=
 =?utf-8?B?U0VoS2dyTWhCSHMwNWJBdVhxVFQrSTk0dkdBUXJheTVlR1VxQVk3OVZ2alVi?=
 =?utf-8?B?TVhDYVZKRVVjYXdWVDlYYWRLUmJEdVpZQVhWTGhnU2pSMGVMSzhYQWx6Rmk0?=
 =?utf-8?B?cys2M3gzelk0R2kya3o2a3pFdkJuMkV4anE2cUdzZkpiMC9ScitaYkZlWEZT?=
 =?utf-8?B?QXd1VVNGWnVjRkF5Tk0zUTZoQlltVGpuc2Mxby9PaHEwUS9kOGdtSHFqdk0w?=
 =?utf-8?B?YXVtWTJ4ak93T0h3TUVWOTg2MTBsVEhqODNvOW1tcWZXRkYwTVRBK2FlYkFM?=
 =?utf-8?B?d3FFWHphUnBrUzBjY0xIaVE5Sjc0ZDg0d1ZVNkdXVHJzK2E2Znc4WThJUUZk?=
 =?utf-8?B?UUF3OUhubjR3K1RKb2E5L3RTMllOdm9vZVhEaWNiUnNyK0ZHbFlxQjUvQmpL?=
 =?utf-8?B?MjBWVDB5Qlp2Q2pMb0JUWmNJTWxaZEtOOWpsdkN1aTJVcUJlVnZkVUxWRFhj?=
 =?utf-8?B?NFdlMmtlUU9xd1V0VFNpNXlCYWVLanpIUmRBSnRtcmU0b1RKSC9DNEM4Ui9Z?=
 =?utf-8?B?OGs5Wllyc3d6SW8vZmVaelExbkJDa3B3SVFuRjJVYlYwRmNaTHN2UGNYRjNI?=
 =?utf-8?B?SjJFbG0zVkQ1UlkwbnZDN2JrQ1UrUXBpYkhkNVp6YTRYK1V3U2xJYXR2S2c0?=
 =?utf-8?B?dHpqb3lTSEtkZlVHZkE3WHVKTVA2UThVQldvd1FYRGtmemVKa0c5TEZoS0JS?=
 =?utf-8?B?aS9iZTBWTnp2NXlIZGRWV214V0tvUC9EUEUxY1JtY3pTYkxlTnFZMTFUbVZB?=
 =?utf-8?B?RHZlak5RaXErT01oRnluOWE4ZlpUY0I1ckRKUzlnak5yNW5tUExjYlBLekFq?=
 =?utf-8?B?bGlENGNwSTFEWnlnbmJjZTZ2cW5ycEZzZjJ3TGdpczM0U29wQU4wRHp4amI0?=
 =?utf-8?B?amhCL0VpdmhaUHpKdW5MVTNGWjJkT212cURCK00vZnJBYm9zNUxrOTlxQUpR?=
 =?utf-8?B?eDhpOUF0LzBTZG9hQjVwdjY3eWtrNE9QNytYTVB4dUJ2MmMycDVuOWxoZTY4?=
 =?utf-8?B?bFE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ca6cc87-16bb-4223-6dc5-08da65af3d12
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 15:40:54.6521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bSRaenN/lXA/rNpIv8RAJL8S6A1eIzvfz3FM5D0hAyNUpAn2Xolh1mnsvY31W+bIl6hFYY3gpsqchN6gzYOksvZBzmJMaVKOTYqrbEHD/7M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1283
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-14_12:2022-07-14,2022-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207140067
X-Proofpoint-GUID: 3WIp-MAvHHkAgtKmwFnyQ6fn9vWkwDlj
X-Proofpoint-ORIG-GUID: 3WIp-MAvHHkAgtKmwFnyQ6fn9vWkwDlj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/14/22 10:32 AM, Mike Christie wrote:
> On 7/12/22 5:29 PM, Bart Van Assche wrote:
>> On 7/9/22 08:57, Mike Christie wrote:
>>> If so, could we move what are doing in this patch down a level? Put the wait in
>>> scsi_remove_target and wake in scsi_target_dev_release. Instead of a target_count
>>> you have a scsi_target sdev_count.
>>>
>>> scsi_forget_host would then need to loop over the targets and do
>>> scsi_target_remove on them instead of doing it at the scsi_device level.
>>
>> Hi Mike,
>>
>> Thanks for having taken a look.
>>
>> Could the approach outlined above have user-visible side effects?
>>
> 
> What kind of scenario are you thinking about?
> 
> I think we would have similar behavior today for the target behavior:
> 
> 1. With the current code, if there is no sysfs deletion going on and
> scsi_remove_target's call to __scsi_remove_device is the one that blocks
> on blk_cleanup_queue then the target removal would wait.
> 
> 
> 2. With the current code we have:
> 
> 	1. syfs deletion runs scsi_remove_target -> scsi_remove_device and
> that takes the scan_mutex.

Meant sdev_store_delete -> scsi_remove_device

> 	2. scsi_remove_target passed the SDEV_DEL check and is calling

Here I did mean scsi_remove_target. It's being called from something like
the fc or iscsi layer's transport threads.

> scsi_remove_device which is waiting on the scan_mutex.
> 
> So here scsi_remove_target waits for the deletion similar to what I described
> above.
> 
> My suggestion just handles the case where
> 
> 1. syfs deletion runs scsi_remove_target -> scsi_remove_device and
> that takes the scan_mutex.

Meant sdev_store_delete -> scsi_remove_device

> 
> It then sets the state to SDEV_DEL.
> 
> 2. scsi_remove_target runs and see the device is in the SDEV_DEL state.


Here I did mean scsi_remove_target. It's being called from something like
the fc or iscsi layer's transport threads.

> It skips the device and then we return from scsi_remove_target without
> having waited on that device's removal.
> 
> 
> 
> 
>> A different approach has been selected for v4 of this patch series. Further feedback
>> is welcome.
>>
>> Thanks,
>>
>> Bart.
> 

