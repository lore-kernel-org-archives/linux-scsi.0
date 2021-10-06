Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDBB8C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 04:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1BAB611F0
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 04:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbhJFErq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Oct 2021 00:47:46 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:52280 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230152AbhJFEro (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2021 00:47:44 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1963rkJN024850;
        Wed, 6 Oct 2021 04:45:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=IrYGNhALXRfQxoZX+z55baQRYkAPcH9oJavf/FM6M1o=;
 b=ivU6Otyw69BwV3Pu83Pus51bzv0vK4BzdxpuiAO3v0CcgtM5f9xdL92eUbetLimDG0Eh
 nwLtchxCehaMEXLeoyp8A7TND/VKJcPR7RFdFZ4eE/iRjr0UpX7g7ENB78u0wdu+1cWB
 uSW39cwgfB7/nbUgQtvM7r7g5l3KK5WhGfCmEaHmpHst78Tp+bgQf4fZFwRUVATJ1d1t
 X3e+y7H//eOF8iENpWrhl6xz/m9Y+6CtK4Dv3/CXdGyxeK9a2jMAVRey6Hu4mvzg2JWg
 HhDol89jpOyT19puScmtse+FHQtgRBaEk8vPlyqh4aTamJ49m/3eZMJUgbyWK3KwBy/y Pw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bh10g93g5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Oct 2021 04:45:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1964ih7U111374;
        Wed, 6 Oct 2021 04:45:37 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by userp3030.oracle.com with ESMTP id 3bf0s7ra5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Oct 2021 04:45:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i6oTyiRfZcYVvW+A7LOdib/PxAXMHV9dIYJulw7G2edqXQhVbEdkek/1mhVWYDxw9PckXxux98Dt1vlo+zUjYJa2DbRTNoKONoF5JXaduVdQZn60ZdCZWts0UGH+fx2BGB33ckVfA2DBd9/U0en6MyguxVJD7leHQzdsHZOyE7W4ztRlpvvqrkvGIcHFOAQDGcUsU1mswe/rn/Uq3GyEMR33JnxbN1faHvC2jt6USB+01lYEglh84jVBkhsaKFmSTSX1I7lrcKlA3nmlDFg1MNwTyMo/N77yO0BlB0Yibc1URpUlEDRZ3NgGwhdRuSrUrUqtU/vZgEUMVFhn+63h9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IrYGNhALXRfQxoZX+z55baQRYkAPcH9oJavf/FM6M1o=;
 b=RT6TApaaTu8ngiqkxgu7wapbmlH14hBWn5rvi43BP9wRLDUUXmIuM9yDY4o3p548eRIwTPwD7sAEQlN77xLMEWgzseocSxnTM8duWBTqpzK6PQ7ajHy4JDdDOWkEwXEfmEsF2Z1byiJ6pXZisSObNPAAIKCK/X9pDSbZYj7MOvM87IW8TZKh3uKzqbbLlOqoW765S6pNMk3DPtLWdbJZV/wSjBzVKRRiYahrTOsf9IyR+TcFPoOmLbtbVxjGbaRZuCpjMK2l8Yv7bM4VLtOP3j556cY9lBZD+zu6biRaondQFNcEBmNOYR1Xos94idvE9hEN6nua1ym9se7Wx8ZBsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IrYGNhALXRfQxoZX+z55baQRYkAPcH9oJavf/FM6M1o=;
 b=b3YnNcz2w1kx5x1hUoJBWGHnAqjnJmy/prqwTxmEJpjNOrQsWss3XadE3UzrOPvN92hbQjP4bhQMDDnLfzhYkcFGwFXfWfeFEVb+SGvFhHM3Gyz7hSFRj3meeia4RoJ3Ae/ExC+N6LtPmu0wLuIsMR5QKuBNfdM0ZYdX14M0424=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2425.namprd10.prod.outlook.com (2603:10b6:5:ae::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.21; Wed, 6 Oct 2021 04:45:34 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4566.022; Wed, 6 Oct 2021
 04:45:34 +0000
Subject: Re: [PATCH 1/1] scsi: fix hang when device state is set via sysfs
To:     lijinlin3@huawei.com, qiulaibin@huawei.com, bvanassche@acm.org,
        wubo40@huawei.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        Lee Duncan <lduncan@suse.com>
References: <20211006043117.11121-1-michael.christie@oracle.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <57607b77-7d3c-1a75-78c2-4a15d8863c82@oracle.com>
Date:   Tue, 5 Oct 2021 23:45:32 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211006043117.11121-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0124.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::9) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by DS7PR03CA0124.namprd03.prod.outlook.com (2603:10b6:5:3b4::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Wed, 6 Oct 2021 04:45:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08dd1c45-2bd5-4d83-dcf8-08d98884225b
X-MS-TrafficTypeDiagnostic: DM6PR10MB2425:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB24258A2A5CFCB2EB6508C058F1B09@DM6PR10MB2425.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c/1V4nwDFSLCZNVdXeF2IyAnE9mUevrKk6VewsBJwcZWbHbgO+lLnn9q/eKp8xV1QHtfIhtAPkCC0DYuSs/9mhH2nbpyBftNXH4Yu1MIDXBh5pV3J9MwcE5/6AwRqJyEO7tORAI3Zp8tT3SxtVLpjkt9P1SKVl7bhLmjp85+WjJcTfuI+26Iw97gHewynb+gOJ5irmwO30aKayrvQ98IdvitBORLzZ9eBdemY3BLz31fWihQkzukWf18Q9p3iR+Um3dovMUnS/IdqJGdtVP4O+w6HBCPDBy8mkZFwOixAonxF4kB2trpO157E780vTjiG/PYPkw2yKg4tonrCwz0sjlT8Ov9F3wUDsESMAMQlbgWuG23Py0eokXDpKUk+capI/5yTQnwTDJUr2XtG3hh/uTD2uaCXf7NMesFIEsNAF+iNkTfMvZOjP620XtMBzR51RIdxvj+KPrcyQh5LwJz+QWL13vLIFB0UaDatwHNOWQJqoTYKD50/k3D77JN1W7rgitDM1Rsd53W5vEdoqWsSi1iwj6NNWjOdpTIEN4Fb/8n6eNxpRVGZG7OQGWlvX2ZajLe5gF2HbdmicVKofLZRBkPfJ9eCpVCNwoV3OLjfa2I2W8gncIewZBwVLhvni6V2Mx5fhaKNu2TZMlvf5f9V+FxB+o/3fX+syL1pARsDbnSgFgZ1q9M2ABXgWjfLD/BFMtZBscACpNA4TKrjlLacXOwyLXU3UHIRAhDci4JtLt4w/etKdynb0slrR2vceK5IGMBrOO9bs0vLLGZzTSnhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(31686004)(36756003)(316002)(26005)(86362001)(186003)(16576012)(83380400001)(6916009)(2616005)(66556008)(956004)(6706004)(66946007)(508600001)(8936002)(2906002)(5660300002)(6486002)(38100700002)(66476007)(31696002)(53546011)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmhLSmpDMUU3YU9LZXUxc0tBNE9GdWVDai8ra1lFRlRNdjZocndhdzRsd05v?=
 =?utf-8?B?dndKZDFMVUlqaWl5R3VuTis3YWlMQ3ZGQlpmWGgwb1hDcmhzcUtBZkhHZFJZ?=
 =?utf-8?B?cXVadzlHY1NqdFc3T3pTMUl4dFBqT29aWmw3NnlFUUhOWFNycTVwWVZ1L0g4?=
 =?utf-8?B?YmVIMkxzNGtpWm02OXY2bm5pemRWdGZFM0RGM00vbk91aG0xRzNYbllHWHpU?=
 =?utf-8?B?QSt5QU9ZdU1DeCtidTNrY1ZIREJWN1V6bGdsM1AxZ1JVeDBhTHg5UmN0aUFQ?=
 =?utf-8?B?SExwMHhFdk5Ja2owL2k4NFRwQXpvMFViTU4vOUg3cWdiUXd2bE1RZnJ5WXJ5?=
 =?utf-8?B?bWFjZ3hlbGdyeU04WHM5QnJUZzIrZGdaUlBwRlUxN3FQNHppU3lxUmZpdXBm?=
 =?utf-8?B?NXhIS0FpZFVsUHZFalFnckRqZk5vUDRFTTRpaVFjU1lwME1pMkNvcytnVnNt?=
 =?utf-8?B?RmVmMHJKME82MlZaOWRnalFYQzZscmh1TGthUXpqZ0twRTFRQ1hvSGxnVTFG?=
 =?utf-8?B?ZEg5TmRpc2VESlhMeGROVTFjOUdkTi9pc3RUUTNJOTlYNXdjS2hsakRXTlcz?=
 =?utf-8?B?d0pJY2Rndi8va1pyWWFWTTdNMHd0MEp3N3hNRVJmTC9xVnZ3KzdtbWhLME1I?=
 =?utf-8?B?VVJ1MGdnazF2OUZpV2pwYW1hTmsxZmZLSVgva1d2Zk5QeHRlTUZoa1hObVlI?=
 =?utf-8?B?MDdzZTA1bFFNclZCbkhjWWt4S0ZzN0Z4WjIxTHFiVzFOTThvamVuYklWNmtU?=
 =?utf-8?B?VE1VMFZYYVhqSjR6NXQ4TGFKakpVRFBsQll0WEQrVkdPckJObkxleDlicXNu?=
 =?utf-8?B?THRrLzVHR2h1V3ZBMXNjSE4xK2ZYWjFLY2hXZ3ArQS9OOWRydjZkdzhRWTBr?=
 =?utf-8?B?UG8reDlwR1RHK0NWWitFNnM2dU9qcVo4eHMySTVJMzB2RnAzMU5SZ01ibmpT?=
 =?utf-8?B?dm40dUxDR2ZMRGtHU1JEOHhYdkxBekdmcFY1Yk8rKzdwTXJwbFZDRHZHdDBZ?=
 =?utf-8?B?LzNWOWlpeDl0MXdOeDdqVENKajVNZW5HZDJhMTZqQkcreDNxTlhIc1p5Ykx1?=
 =?utf-8?B?c3ZwUnhSMTU4ZGpZWVhQUEttT1BocmZDSHo1bTZ1VFN1TGRkNC9QOElEM3l5?=
 =?utf-8?B?VVZQd21CUFBDa0o2RGMvZHNmbVRYVVBWZmt4SG13WXFNVzJOZjJDRnk4eTI3?=
 =?utf-8?B?aUthTytyMEpRbmxabXlYbzdaanZWb0orTkRtaDVUSTZ6a2FXU1JlbitEZVA1?=
 =?utf-8?B?UkxlcWNwb21SMENFQkYwN1psblBBcTBwYzZUMHhveHB5dUtBT04rTnhFc0Nz?=
 =?utf-8?B?c3JOWTk1c2RQUHlaMTA5Qzd2TVErS1VldEdseElQblorQWxtRmprbE1TMjZW?=
 =?utf-8?B?dkxNRTNEYi80V3dBbUN2V3hXS1g0Znc0WmlDbFRVeEhNUHpqT2ZzZkN1emgv?=
 =?utf-8?B?aFFmZUtNR3VDN0JDbnp0cjljKzFFamIyM25iSXd0cjRiaVdUUzBXSzRXa1dR?=
 =?utf-8?B?N1o5dUxrK3VvejNoUWxtQVNlNUlxSzRrN1hMeE14QmxvNkpXNUZCQTQvTGFL?=
 =?utf-8?B?SVU1R1cwZ3NuR1VycnVzMmJGczVUSVV0UTFTK0g0UnNhckZ3YllkMm56c0w0?=
 =?utf-8?B?Q3ZNbU5lbUllVWJnN1BUMDI4aHlYVFhtT3h1N1Q3aWYwdWxQZVBqS1YvNnhU?=
 =?utf-8?B?S0kwUWF2bFluNHVQM2xTR0QyVjcwUGlyZE9qbFpXR3gwTnpPK3ZZN0gyS3hI?=
 =?utf-8?Q?0wbP50m4oK3A7GOrY1vooVbxf5gwjinvssH2Lqc?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08dd1c45-2bd5-4d83-dcf8-08d98884225b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2021 04:45:34.4371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hb729LBlzbswXjwCXbdVJZvKkcOO/HjtMnw4XFPoacVzCWJ9AAJZXyV3mkQlPIEimd0nIiZ+FK6gYDlo4miLD29Qr0E34qV16WVBdzNmU5U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2425
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10128 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110060028
X-Proofpoint-GUID: qtBJKNgA2yS8A6mgOxchXoLdwIbHIFJA
X-Proofpoint-ORIG-GUID: qtBJKNgA2yS8A6mgOxchXoLdwIbHIFJA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Cc'ing lee.

On 10/5/21 11:31 PM, Mike Christie wrote:
> This fixes a regression added with:
> 
> commit f0f82e2476f6 ("scsi: core: Fix capacity set to zero after
> offlinining device")
> 
> The problem is that after iSCSI recovery, iscsid will call into the kernel
> to set the dev's state to running, and with that patch we now call
> scsi_rescan_device with the state_mutex held. If the scsi error handler
> thread is just starting to test the device in scsi_send_eh_cmnd then it's
> going to try to grab the state_mutex.
> 
> We are then stuck, because when scsi_rescan_device tries to send its IO
> scsi_queue_rq calls -> scsi_host_queue_ready -> scsi_host_in_recovery
> will return true (the host state is still in recovery) and IO will just be
> requeued. scsi_send_eh_cmnd will then never be able to grab the
> state_mutex to finish error handling.
> 
> This just moves the scsi_rescan_device call to after we drop the
> state_mutex.


I want to maybe nak my own patch. There is still a problem where if one
of the rescan IOs hits an issue then userspace is stuck waiting for
however long it takes to perform recovery. For iscsid, this will cause
problems because it sets the device state from its main thread. So
while scsi_rescan_device is hung then iscsid can't do anything for
any session.

I think we either want to:

1. Do the patch below, but Lee will need to change iscsid so it sets
the dev state from a worker thread.

2. Have the kernel kick off the rescan from a workqueue. This seems
easiest but I'm not sure if it will cause issues for lijinlin's use
case.


> 
> Fixes: f0f82e2476f6 ("scsi: core: Fix capacity set to zero after
> offlinining device")
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/scsi_sysfs.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 86793259e541..5b63407c3a3f 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -788,6 +788,7 @@ store_state_field(struct device *dev, struct device_attribute *attr,
>  	int i, ret;
>  	struct scsi_device *sdev = to_scsi_device(dev);
>  	enum scsi_device_state state = 0;
> +	bool rescan_dev = false;
>  
>  	for (i = 0; i < ARRAY_SIZE(sdev_states); i++) {
>  		const int len = strlen(sdev_states[i].name);
> @@ -817,10 +818,13 @@ store_state_field(struct device *dev, struct device_attribute *attr,
>  	 */
>  	if (ret == 0 && state == SDEV_RUNNING) {
>  		blk_mq_run_hw_queues(sdev->request_queue, true);
> -		scsi_rescan_device(dev);
> +		rescan_dev = true;
>  	}
>  	mutex_unlock(&sdev->state_mutex);
>  
> +	if (rescan_dev)
> +		scsi_rescan_device(dev);
> +
>  	return ret == 0 ? count : -EINVAL;
>  }
>  
> 

