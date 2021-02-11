Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7D6CC433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 16:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BA8864DE1
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 16:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhBKQvc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 11:51:32 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:44130 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbhBKQtZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 11:49:25 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BGi2TT155250;
        Thu, 11 Feb 2021 16:48:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=JdbEVUDGu+IjVrZAwkt9E5AEWFYsTFH6bYfFu63taBo=;
 b=fwlDMLrVICUIKykG2srGR0z5/ctmraH6uWcsyME0irIa4W9/LppDqYGumhwMwjCPIXRi
 q1xr/91XNefmzozu0mJxVRTaVgNxf9RneYovB6rHMN8fzj/ePTBgFc2h9Ka1XwtL9R5C
 s47GucygsNlR5rR3NMcCWxr3QG4URFHeF+UPw82/dLYWhHRR8IyhSQS8LcUX7mtbnrt5
 eUqq2eiQbNC1HgVUfSAzjx+9EbLjg7g3N0cMV3UzrW/QWHvU1HrYz08+azVUYGMpyjTI
 3MC8/k9y+H/HB3KWpRQfzMMeU0/puyhgG06YGzafPpHSwt16amEGCTw1oTbpm7uQhuWV HQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36hgmarcp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 16:48:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BGk559136154;
        Thu, 11 Feb 2021 16:48:15 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by aserp3030.oracle.com with ESMTP id 36j4prsns5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 16:48:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SqilRhTMiQ9E3iXkBpkhu+vZowaDS8+2z+YnugL2CyIrmoKFokibVMLZsv2x5O82qSgRKY6tlQvsGjb/jdLBXFXOYoi54qCJhU9h4d9tMVM26BDes/KVAKKDKL0XrrZeT9b7Bpz4RcmKDhiF+B/Ymzm8+F/VaDgQDjzKaMCdW4hbacKpxUh1AYcd819X3WhNJmxrctUqfFmZEt1gX2SX+SwBfxpWN0TWFiNWEdO1xyGDjB7G+W1dcK95uEE+rcFXmLva8JWdyqBr4mQ4oiqAUaJpj+B3flKZjXQO/Old7jjNnsuDc6+GkmoNnlpYc7Q2ayiordNuvwxhkXrsVBXmqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JdbEVUDGu+IjVrZAwkt9E5AEWFYsTFH6bYfFu63taBo=;
 b=C3FtfsWS2ML10aR8xzjCF0xQUswxyBmDHerBOSAHyqOfD1bAHtxEExcRSWQPF/YD6cPZvy5bZdLJ9SZ6V+KWX7uaTamh3zAPKCTSjfXrVwMoS3bS648miHc2asKq3EKnYzAHBhOUUE8ssx8HJbJgaKyRa+XJiasw7T7rzFbAcHU6u0MCd/GHPhYUY6vxwDs8bOEtazOyuQdm0GrVlzbQ2ofR0EzTsc86to/f/qjPGT7q4AwLdugbaVUw/zCn8Tk0atcXw8CyMmJGWF4hzIoWePzr2S+9oy+5X5CBfO/kklM3NhhQ3UFGaneD5jJcaqrXRGcT53pB5t3li7boPg72jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JdbEVUDGu+IjVrZAwkt9E5AEWFYsTFH6bYfFu63taBo=;
 b=Xpq7Aav+92DGnTlUbc1X+esEhk+xsZ07qfVEYrnhY7uQ2Lgv1IjpcbvJn6Aqa9y2SXJUFPIVGXtgmvlYkYIoZbGKstpXYSwdWLpBcu1xL2PhOmWgvnpujys2S1bGX/1zWnoeP3WwtKS7UKFxC67rirvNzPAeYG9zNTO0ijIK88M=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4794.namprd10.prod.outlook.com (2603:10b6:806:113::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 11 Feb
 2021 16:48:12 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::793a:7eef:db3b:ad48]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::793a:7eef:db3b:ad48%5]) with mapi id 15.20.3846.027; Thu, 11 Feb 2021
 16:48:12 +0000
Subject: Re: [PATCH v2] scsi: qla2xxx: Removed extra space in variable
 declaration.
To:     Bart Van Assche <bvanassche@acm.org>,
        "Milan P. Gandhi" <mgandhi@redhat.com>,
        kernel-janitors@vger.kernel.org
Cc:     GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        njavali@marvell.com, jejb@linux.ibm.com, martin.petersen@oracle.com
References: <20210211131628.GA10754@machine1>
 <ccf393f7-cbfc-fb8c-6f73-bb502eaa54f3@acm.org>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <b44bd29e-389c-634f-333d-edc88b3d7be9@oracle.com>
Date:   Thu, 11 Feb 2021 10:48:10 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
In-Reply-To: <ccf393f7-cbfc-fb8c-6f73-bb502eaa54f3@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN7PR04CA0267.namprd04.prod.outlook.com
 (2603:10b6:806:f3::32) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.30] (70.114.128.235) by SN7PR04CA0267.namprd04.prod.outlook.com (2603:10b6:806:f3::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Thu, 11 Feb 2021 16:48:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 475c9c9b-d63e-4250-8617-08d8ceacd1d3
X-MS-TrafficTypeDiagnostic: SA2PR10MB4794:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB479467D3782EDB58D7BCB6C5E68C9@SA2PR10MB4794.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H9XxaaalisJncfgkPulmRXOuwrtV1U/a2ilQTotqjSTjR8PGtGjpbFu2Yit+or89OicPwkqUjyrFf7ikCTgf3CvVb4RXZGpffiIOnLnXJWkAQFj8Qcx5D+0Sha69dR14lta9iezpVgIkPOqGMQPq5X3uIsZTMJGKkavZoQELC9PyKSkwQzncB1vvp+1usrjZcmccJn5owqew/eGkz9W+dqqKP7Bmx+WaG3Gwm9xFyVH8kW426OAreixL7wlpbohsIDC2CJswngVbsoAlQ4Ju0LN+KEKHIVZgE8+UEr3IhAcONTpBTD8SwMneAd/cf5CrU8RUZM+7A8zqeT9NuT8KY9Jyc5jrqPq/G1vPfFWGzhvCMp+MBRJn6sSYKTxAc73sdmFQknBU117YdX8qfai3sQ9IFQDovgWbPKY6E4yzdIwvTvohunAbUw1AX55Q8DQkww0BfJXtVPpMtEvkd2jLG3LNoKjSm1uR5riPVLVUvHVZu6QOq3R2xkKs35PgLmDCSM8v5P+HsQi7g2m2eXEqqPnZY0oxxMfr9lMv0a3wE+1MlXYR0yN0nPnjo5yRzyV2ja75L2P+H/jV/AbnL2ad/Ip5maP2FPVrz993N3LPywA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(39860400002)(346002)(376002)(83380400001)(53546011)(186003)(16526019)(66556008)(6486002)(31696002)(66946007)(26005)(2616005)(110136005)(44832011)(956004)(86362001)(316002)(31686004)(4326008)(8936002)(5660300002)(478600001)(107886003)(8676002)(36756003)(16576012)(2906002)(36916002)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TWJvR2tVR0hEZVB3SkxGUmM1TVhVaWVhb1EzTXhzZFBkbmFVU1BEQlNQQXF6?=
 =?utf-8?B?cDdVWW0wZXNoQXBKUVVFOTRSUTBndjR3SG1HT2ZOVUlWamY0RFBjUTlnRzlH?=
 =?utf-8?B?OEtQS2pGdVJ3d1k2WU1FZU1yODYvL0hNWVVvRFh4Y1dBWm82eEZsNWVUYURH?=
 =?utf-8?B?VXhBTXJBT2R3Qk95cDRBTVpmKzFHVW9aVWMyMXM3cnUza3g0aUo2citBTlFr?=
 =?utf-8?B?MWFnSnZYVGI4bTRLVVBKZnp6VFJvMlZYcVgxM1V1UytJZ2RabDRHN1JOdVJL?=
 =?utf-8?B?bVFMN3lBSlRsNU4zZUhJSFdXaUVvbkxWRWltN1Rabm1aNDlFTk9ta0VLZ0w5?=
 =?utf-8?B?UTJVazkzK3Nva0dBd3VPck5OT29xcjk4c2VFbEpzdiszM1RhVkh3aHZ1RTh5?=
 =?utf-8?B?dFB5YVNYMVdIWmhXZHc5d0d2aHkzOEYvQmt4NWdwd3hueTdPREpUa3ZwcWFp?=
 =?utf-8?B?czVreWpaQTM0WG81cmFDNzdYaTVzbWhWU3MwckNvRm5RRDZDUUtxYzlnWkpB?=
 =?utf-8?B?c1FjNGFzeStrNG9MSFpzWXAvd0VZb054MDJlalF4R0FJNGtvcFRUUFVEQmJj?=
 =?utf-8?B?eTF5WnB0SmZuemgvdFpUeUtmSktwYWVOUTBucXR3ZlMxY2tXZGJGeGZzOElG?=
 =?utf-8?B?QmdiTHpnZlZ6a3kwZmo2MDJhNGJoVUFhbk40UzduSHhTd29QcGkyQWpzK3Zw?=
 =?utf-8?B?VXR6RE9zS1ZObExSWW5UbnNwZEVFdzJ0OE5zR3JkZGFFRXFhb1VCb2lkYkVM?=
 =?utf-8?B?aU1xbXJ1aHg2ZlVRVlQ4T01ialhkVHpJcGpFYklVdDZJTUtWWHY1QklCYnRK?=
 =?utf-8?B?TzJpQ3YxRjl3ejU4aEJ6MTVlYU84TFF2VEZxUUhaYXpxeFJTQ3RjSDN3M0hD?=
 =?utf-8?B?ZXFwS2Q1Mk9IVTZxS3ZyY2luMDFuaVM3VXJxSkw3S1NvK0VuYldsS0Ezd3p2?=
 =?utf-8?B?WEE0SnJBcTA3Tk9VTWlXZ2M3bCs5OS9FOG5QLzJsMHBwMmtxbEZKMTBsSzJa?=
 =?utf-8?B?Yk1rL3MzZmc0RmR5L1B0YjVEaEZTM0s0WXJ6YTZXSSt1Tk1kL2kwaXkzMG1p?=
 =?utf-8?B?ZXl6elQvcUNNOTd1SW4vdXI2UG5zcUJpYkZvZHpQZjR1dTNQSURmd1Jnaisx?=
 =?utf-8?B?d0JtRUlHUDQrUDNvSktkem04OUlqYUpmRElNdVFTTjhjNjVwbTV5ZWZhSlE5?=
 =?utf-8?B?MWpibmdOcjNuRUcyYlAydStPZVJYbG5odHdEYllFK2RMNEFBeHIvNUdFcGNi?=
 =?utf-8?B?QkdoYXQyN0VCb2JoU0NKUCtpL0EvWFNpVnpPelJlcW5qUmdOMEFRUG9XZTA4?=
 =?utf-8?B?M0l2bVN1SjU5dWl3MHIyTXFCbkFqMUlocEpOcC8rdGJJeFlWTlZSbkk0cGla?=
 =?utf-8?B?NklkZ0dMRkFCVGJlQUFBamVVRzFCSzZFeFZXWG5xWlpyVDZFUmZIaXZvdWRy?=
 =?utf-8?B?SmVKeGpEYm1NQTdsaUl6dFVsRFBUaDRTdnhSVXRvOEV2Y1JGeFVoc2tPczRn?=
 =?utf-8?B?ZlpRTmFuWHYyR1VHSEgyZ3RzZUlBRlUvczlOTUxsbjVRcFhJbFR4RXRIMlRl?=
 =?utf-8?B?MG0wbnl3Vk8wWjVaZnRuc0U3NStmRUFJTzVXRlR6UEU5eVIvZEZ5SnQ4Qmhr?=
 =?utf-8?B?SWFiQWRrNmlValN0NXVpRy9iS3BsQmNDWm03eEdYK2lXYS84RGluYWNqZ2dD?=
 =?utf-8?B?OTQzY1R1QWxhTEpTVUQwcFZYRVN0eGxQaWlOMXZocVB0WjZtcVZsQUUrdUZ1?=
 =?utf-8?Q?Ty9P0jRgMgwDGqXanoRCXlvSNI62p3cvrBi2BX1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 475c9c9b-d63e-4250-8617-08d8ceacd1d3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2021 16:48:12.3752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yYUbvNeOB08bVou9KMeeZ8pO6Hb7jDgcKuHeWgYyry5wpUlnu+o1m5rDiLFyS8V/wpbRDdM0JynVKKojVIuZeM4H3nsKf0CtkGkUFwHpIzA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4794
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110139
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1011 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102110139
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Milan,

On 2/11/21 9:57 AM, Bart Van Assche wrote:
> On 2/11/21 5:16 AM, Milan P. Gandhi wrote:
>> Removed extra space in variable declaration in qla2x00_sysfs_write_nvram
>>
>> Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
>> ---
>> changes v2:
>>   - Added a small note about change.
>> ---
>> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
>> index ab45ac1e5a72..7f2db8badb6d 100644
>> --- a/drivers/scsi/qla2xxx/qla_attr.c
>> +++ b/drivers/scsi/qla2xxx/qla_attr.c
>> @@ -226,7 +226,7 @@ qla2x00_sysfs_write_nvram(struct file *filp, struct kobject *kobj,
>>   	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
>>   	    struct device, kobj)));
>>   	struct qla_hw_data *ha = vha->hw;
>> -	uint16_t	cnt;
>> +	uint16_t cnt;
>>   
>>   	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != ha->nvram_size ||
>>   	    !ha->isp_ops->write_nvram)
> 
> I'm not sure if such a patch is considered substantial enough to be
> included upstream.
> 
> For future patches, please follow the guidelines for submitting patches
> and use the imperative mood for the subject (Removed -> Remove) and do
> not end the patch subject with a dot. See also
> Documentation/process/submitting-patches.rst
> 
> Bart.
> 
> 
Agree with Bart here.

What was motivation behind this patch?

if you scroll through code, i am pretty sure you will find more than one 
place where spaces are not consistent (especially 15+ yr old code).

-- 
Himanshu Madhani                               Oracle Linux Engineering
