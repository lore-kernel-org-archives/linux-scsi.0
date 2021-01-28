Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB87C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 01:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2351E64DDB
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 01:07:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbhA1BHd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 20:07:33 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46288 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbhA1A4i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 19:56:38 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10S0Y18Z123144;
        Thu, 28 Jan 2021 00:55:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=axaMpJ5TXbppfolp/X/W0oNSr2fKmrFEKmRFoNdmKZs=;
 b=oFlAjTJ/56a38kTH05Z1zrjp4OLazn6O3H+KHtkDMuWsv5ipbVK+kEtqG59WWW523zkT
 fxRpfLljoaQrljmj4nadfiC6ezMKePki5UoNqn8qZSNLJh55/dYJqvUOy9Vc2/sqJkBG
 g1B8XqJEJHmVKBmu7XjJvjCzhdiDXmP5xiSHT8F3Fe8fSkC7t9FraXcoDbz6S5GpX7Mh
 Xw5v/PzuGbOHqyAWdcG+ARxgg6uacERbVVLcdmrIr4yE4Q/p1QFOQlLgDpG/y4Fj+qfV
 JjuB4xj5wy3ih/bwCI0VNDC2SXlUSGS7RC+PIbxDeBTuW0VdCVWVIsVSO0YJkLPde+ZI nA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 368b7r1v83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 00:55:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10S0ZlFL051314;
        Thu, 28 Jan 2021 00:55:22 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2057.outbound.protection.outlook.com [104.47.36.57])
        by userp3020.oracle.com with ESMTP id 368wjt9ees-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 00:55:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nOsWo5Hd+YQhiOxK/0uF+nbuOuKxjjCgrmxYT6dWSLrm9XiE0vVRhMCb19AuuQUUMtEdqBOTkI3GMXozPfZCd5vh2hNo4K5nmmOFGyDoww0L9tj5IrE280kA/mCmEnLQHNYZF4iQoBcKzOqZA38kPW/cU1gSCwCplS5LRNtGcRPU4Iy7v8/3pL2ImNdWji4yoh320BlQSKIv4U6XWLWAATmRKvFuFTCNpKHcygTpu79ARu8/0QTFNR6LEFFbTE0pG9EHkeqDD66MNpMFjwijFpC61roJaetWLNKgegfq7HM/cLPbdYK/1mwHAgjY/j1rSsBTFP2D1Bka/Y57LfsJGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axaMpJ5TXbppfolp/X/W0oNSr2fKmrFEKmRFoNdmKZs=;
 b=IkC7mOXPCgZm8zjw7DlmLwBNaDd7H9evFW4EGLhr2eml9nHDJwvqeeHGUbgHF+ZmYwFLRZ1AnDl7NbTkBBlsvST2D8V+twx6EJXe0hFFQQaupya95q8+8+KFGVjkkkP66BUmDuMVZUdPvQB051RDJRz0H/uxMoZtCn0WX0YM2U5aJ3/SQuLXwaE6hEyB6l+UAUKJ9LAMVvA0qoMaoB1erIUds9m/oaqRtpCFjrGNVML1DkbqoUzxNz9PzkVOcOFncrinOx+BTxjERjB4BnZE/iikwfvtd4ucA4138dZE7pE5ov3o1Mdwdk2ev/ZoFn3d6q31Vx45bqlay8HeAB69iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axaMpJ5TXbppfolp/X/W0oNSr2fKmrFEKmRFoNdmKZs=;
 b=n6dXmtO7owUrhf+V+yq8+xmDBSEdCEuK/oLCd80eiNmHVmem+Ph8WCe2iWhTdydsOwjXu4Vjab9QZ3xSM9tbrkHz2jLqHYm/EkRDjpSqpHWakDWH5073/rSU8t6SN30cFCFHTiDWc1LTUYr66TLg9r69A8V5rG+EnYue/DqfT3A=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from BN6PR10MB1236.namprd10.prod.outlook.com (2603:10b6:405:11::21)
 by BN0PR10MB5221.namprd10.prod.outlook.com (2603:10b6:408:122::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Thu, 28 Jan
 2021 00:55:20 +0000
Received: from BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86]) by BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86%4]) with mapi id 15.20.3784.019; Thu, 28 Jan 2021
 00:55:20 +0000
Subject: Re: [PATCH 5/7] libiscsi: add helper to calc max scsi cmds per
 session
To:     Lee Duncan <lduncan@suse.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
References: <20210118203430.4921-1-michael.christie@oracle.com>
 <20210118203430.4921-6-michael.christie@oracle.com>
 <8cccc83a-4f43-f3db-5f06-5a75f76e293e@suse.com>
From:   michael.christie@oracle.com
Message-ID: <d85be128-9b99-0550-95fb-e52d18787118@oracle.com>
Date:   Wed, 27 Jan 2021 18:55:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <8cccc83a-4f43-f3db-5f06-5a75f76e293e@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR12CA0029.namprd12.prod.outlook.com
 (2603:10b6:610:57::39) To BN6PR10MB1236.namprd10.prod.outlook.com
 (2603:10b6:405:11::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.12] (73.88.28.6) by CH2PR12CA0029.namprd12.prod.outlook.com (2603:10b6:610:57::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Thu, 28 Jan 2021 00:55:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 375ffe45-20de-4259-237d-08d8c32762c7
X-MS-TrafficTypeDiagnostic: BN0PR10MB5221:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB52218DE479CD45FCB0178719F1BA9@BN0PR10MB5221.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J+0qtIgFWVD6+Fnca+7YqaZ9W07/6ahkABNbHfp7x2HRGrtkph7JTW6hR0BvDnlmXONr9/WbFMpw69RhvIbXUe5nDAP0aqb72iNIaLd5QYFtWw/bi8E7L68lmYSPDXX5YcgqbC0IdGOOxH+Xiks0RTA+tR9WWOOmPEPlqLGeeveoKPWHaqr3LA7IwYe1YLN7VZbJt1u1kUXR5+whnunnO/BiKdq8ddc5p1T9JLTc1TDV9hxcQAsxLP7MIqnhGurtfXyLeZPtFlELppABIbPz7+sET3UltgDRIfRVwr2Ww4wgr8oqOK2BNwWSlcXDfOgavpb1lnGWjvbeqLzhhm8N7ppzUoehpevNFL9uBfR/XP/KPKZzY+j8FvsRT6puP3q8qrNQfdja1C2f5rdJhRmEtbEZJ5+qDA4C7TTKnmLEDoV3kLAAXKL5/OBY4zQzM70fmmn9bNaDZAUwJDRspQxhjXrELq5ON+w0bITPvM4+2VuHWttpHN44Z8MAreRj6a/lygeFlby5gbLo+7KOfvXTPWeivjmrGMKIapgm7viDjohpj7NvWjEJshwtxWaNbpy4D2bw93Gs4v/Xzy1jWaS2+iPOTlO2MUujc0RoS5aVYr4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR10MB1236.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(39860400002)(396003)(366004)(31686004)(4326008)(36756003)(316002)(6706004)(478600001)(9686003)(16576012)(66476007)(2906002)(5660300002)(186003)(26005)(956004)(66946007)(2616005)(66556008)(8936002)(31696002)(53546011)(83380400001)(8676002)(86362001)(6486002)(16526019)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dHlTZ1NVbk8zU2NiRGtSZWdiUUoxNXdyZEVzc0tqVXlkRlBCVlNoM1h6ZDRX?=
 =?utf-8?B?UkJHbkZ0Z0xQUlFodUhsZS83M3N6RHlUVjBwU3N0aWpDRExEZEZGUE1VSEFD?=
 =?utf-8?B?KzZ0Vms5MEExd1ZoM2NNVm14QW01NXFYaEgwYmh1cEQvZC9PUTZDVGN0WFl4?=
 =?utf-8?B?bGJOaE5QZDdkcS9hOEl1RG9tdVU3dWk3a015VkxSTzNvZEhJUWgraENsdzZo?=
 =?utf-8?B?VndEdjBNQlRJa0FpWWw2VlZOVlVsTmZMNXQwL2xJVHE4NjFtM25QMEZuQXEy?=
 =?utf-8?B?T0JGK1pvTzB6bjRBWXlaN3ZmT1loMEp6NUg1Q29wRS9uNlhQRHEzZXZESWta?=
 =?utf-8?B?ZFJZZHM5NnBSVXpWdmVaTWJCSittZmYzQUZ2MHNIUUhhL2tBR0M1WEw1djI0?=
 =?utf-8?B?Z2VCTXBtZmxBaHczemtpOWtoeVVpVUxMdXVYeHdkM0lUY2JvbGJYWWdFTEtr?=
 =?utf-8?B?bkNrM3NKMGdqRUg0Ylg5UVNJcENLNHdmY0szVXpBR1RhTGp1dmJyMGRiT01N?=
 =?utf-8?B?MHppMTl6bWxMbndIYlpocnRYZCtNa1cxV2hUVmNzVWt1YUdMVnF5TXZ3eE5T?=
 =?utf-8?B?MWNhbi9POTFPcmZZY1ljbk4xRTRNL0pIN2VwWjBWbmx6Z2p1K2poU3hrVytp?=
 =?utf-8?B?NDBoTWVzY2MvTS9Za212bWMwbUJMOXA2eVBIY1RGTnovMHkxQ0E4MTJmaFkz?=
 =?utf-8?B?WWVOWXpZTlZ1S1UxSnRDRHpDVzhpSWNFajJDelBSRFo1aWp6eS8zL09GYkg5?=
 =?utf-8?B?ckszdzczbHExVERuSWdWSlpyWE91N3BKTlVnZlplckoyK0VTbkpYNG4yYUZB?=
 =?utf-8?B?KzRYVnZ1Mm12UEh3UnBTU25DdWhZeitjbmZUQVNnOVNseDBzSWdON09kUWRz?=
 =?utf-8?B?TmxkNC84YXZycFRFZWpVNEl3Mncya3EzSlFDbTkrYnZVVjZkdDZtQ1pIZ3VZ?=
 =?utf-8?B?OFVZQXIzRkFSOGErUGl0WktXdmNaQmNucVVxTnV2b04wSGFEd2h3aTIzbllV?=
 =?utf-8?B?ei9UblZ4UFRTQkh4QUNreUtwa3ZWSHloZDhadStqRnFjL0IxQXR4Mnd1QlE2?=
 =?utf-8?B?eTA2V2VVeU1zWTRaZUU4TzNjdmpGWCt4M0V6TDBHRmZuQjlKdnExQ1JnaDhv?=
 =?utf-8?B?d1dXdHlLUGJjNG1PQ0V1Y1I3Tlk5VnlsSFkvOWFlSVUzMDBxQzl5Q2V3ODlZ?=
 =?utf-8?B?aVV1ZVRsSHJ3SlY5aDFRNHk2cXJvcm5wbzFEWU5kMkpOemYraXk4b2dtd2Yw?=
 =?utf-8?B?bEpZYStxRDZ1ajNBQUdlRnJVdSszZ3ZVc2FvOGYxTUNhVUEzcG40SE9FeGRM?=
 =?utf-8?B?V2pUQnRDME1qUWJ4VWMrZUlQWm4veWFBWG41NVFqRmhIaWhYd25RQWRFdGFP?=
 =?utf-8?B?WFoyajhrZnBRL3dDaUlwdktIVlNrRkh6OEl4UUpTdGZocmdpOFdLbTlnSk1O?=
 =?utf-8?Q?5dDrsAEJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 375ffe45-20de-4259-237d-08d8c32762c7
X-MS-Exchange-CrossTenant-AuthSource: BN6PR10MB1236.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2021 00:55:20.2423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SWihVjI/IBM9v21LVNMvtjheNzUtSet9AIEXyLt7+YPWL0D/L47WMY4yt5FUur+qnRURPnlg3qveE0DosOQD/NQeYrvCafwmCdBZJjqsHF4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5221
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101280001
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/27/21 1:45 PM, Lee Duncan wrote:
> On 1/18/21 12:34 PM, Mike Christie wrote:
>> This patch just breaks out the code that calculates the number
>> of scsi cmds that will be used for a scsi session. It also adds
>> a check that we don't go over the host's can_queue value.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>   drivers/scsi/libiscsi.c | 84 +++++++++++++++++++++++++----------------
>>   include/scsi/libiscsi.h |  2 +
>>   2 files changed, 54 insertions(+), 32 deletions(-)
>>
>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>> index b271d3accd2a..195006a08e0d 100644
>> --- a/drivers/scsi/libiscsi.c
>> +++ b/drivers/scsi/libiscsi.c
>> @@ -2648,6 +2648,54 @@ void iscsi_pool_free(struct iscsi_pool *q)
>>   }
>>   EXPORT_SYMBOL_GPL(iscsi_pool_free);
>>   
>> +int iscsi_host_get_max_scsi_cmds(struct Scsi_Host *shost,
>> +				 uint16_t requested_cmds_max)
>> +{
>> +	int scsi_cmds, total_cmds = requested_cmds_max;
>> +
>> +check:
>> +	if (!total_cmds)
>> +		total_cmds = ISCSI_DEF_XMIT_CMDS_MAX;
>> +	/*
>> +	 * The iscsi layer needs some tasks for nop handling and tmfs,
>> +	 * so the cmds_max must at least be greater than ISCSI_MGMT_CMDS_MAX
>> +	 * + 1 command for scsi IO.
>> +	 */
>> +	if (total_cmds < ISCSI_TOTAL_CMDS_MIN) {
>> +		printk(KERN_ERR "iscsi: invalid max cmds of %d. Must be a power of two that is at least %d.\n",
>> +		       total_cmds, ISCSI_TOTAL_CMDS_MIN);
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (total_cmds > ISCSI_TOTAL_CMDS_MAX) {
>> +		printk(KERN_ERR "iscsi: invalid max cmds of %d. Must be a power of 2 less than or equal to %d.\n",
>> +		       requested_cmds_max, ISCSI_TOTAL_CMDS_MAX);
>> +		total_cmds = ISCSI_TOTAL_CMDS_MAX;
>> +	}
>> +
>> +	if (!is_power_of_2(total_cmds)) {
>> +		printk(KERN_ERR "iscsi: invalid max cmds of %d. Must be a power of 2.\n",
>> +		       total_cmds);
> 
> I don't like mixing KERN_ERR and KERN_INFO for the same event. Can we
> make it just one KERN_INFO? (since we keep going)

I think INFO is good. This patch just copied the old code, but I'm not 
sure why I used ERR for the other cases where I fix up the value for the 
user. I'll fix those too like the one above this one, so we are consistent.
