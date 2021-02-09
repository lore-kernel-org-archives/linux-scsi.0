Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFC16C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 23:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0A7F64E4B
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 23:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234632AbhBIXQO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 18:16:14 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60872 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234575AbhBIWdn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 17:33:43 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119ItPnZ080343;
        Tue, 9 Feb 2021 18:59:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=LXQt5NPbpMBGIGXjnR5sSrvt6KZ8poW87e8GnYtf/A0=;
 b=i+EIBR9VOYvtIjaKmDnQjUqUapYkp4Ef/dyvLuGic5Zviy1eeaAPR7mSHKhvNh4bd2sb
 NQOUlRC2Dt3c9HbiKX7U9oo62v492XriS9aO+KbDz6+u7EdWTtLkHPLdNUrv7dd0HOAo
 pb4bAHQKWfA1chBtMtuE6ImhYSXqfiWo+pSVObCVVQmviOmfhpCjaLVGE3AlGNZH/eip
 8qWajbQqGg+lXzhrE+KNyV3+u8lHy01CeULvpU9QdbZ5Hwf3DTnnMIgHGXiCHSHx7f5K
 ylELv2NAjKj0Q/MXMgMaN1bZTXrb6IoMp1+f2QWcIZ7IHp2Ww4v8k4GHGDecScza1svm PQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36hgmagsgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 18:59:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119Ij2vw001504;
        Tue, 9 Feb 2021 18:59:38 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2170.outbound.protection.outlook.com [104.47.73.170])
        by userp3030.oracle.com with ESMTP id 36j51wgtuk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 18:59:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I/l7BwP5dePzUE/GrZhaA2XvDHSg3J7mvoU+4Qg4SyNEaDLw2RA186xpJ5rlFXs3hr5LnxVdnkvZqDWiT9tGHV+DlX4fuwKg3vwVOFasKWfftUYDO2CZlDTybvVSVCTssBHWm+T861k1Sm76qhZ1dsBJfUi1DvwqHG4MqBqtB2Esll0etJriBBlHbqsqkuym/xk2pJ+evY8OcZM/jjmJhirq2umEb2QEt25gBSLMUOObcF5oLsV8fhi69cGSJP+UsoxXR9No+avUzhk4Xatz2wFFENe8OZ0drL40OLbhMFogsTYfWXWg1wnuvAiCQZGraiSKozfUqpXf1hR4Ak34BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LXQt5NPbpMBGIGXjnR5sSrvt6KZ8poW87e8GnYtf/A0=;
 b=amqnQSjtyRT2Sh8HdNVnVuQY4pyDJd+WFhKuCl1xIK7TqzVVQWN+35EUzhdFLT+ha+KQKv0qzBAXmJwLptn6lMhark9lHXuCmuTMFjeB5o+8VK71/bHfKGczUNc2rM4N9KGu3S6JqplvT8PO0s6Ex6irKUxg6VUwI6FYjL7IYZpRSkKubEFJV06wTG/LLBA+R6wK+Wa5bCxPdad2bi+IrCjIn06dTV9+fi/07W43eiV4SkMZosLOqc+ll+GrPBqfN0HZ7ofLWZjapTDnw7oF397QQVPDI2xJ0n9Qg7H/OgkPI6vf7c4DoYnPtFxL5PBPvjPgWTqN7DqLSOcI40N/LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LXQt5NPbpMBGIGXjnR5sSrvt6KZ8poW87e8GnYtf/A0=;
 b=D4WIGrHGIy/UsoTSCljZzbwUSocesJhM85Sp/GdgBciBqPT9hO3IRgDBdd0qpxA09YRNcx05jIQBe1wMtS3NpDus7NDz8sYSaIvv8+fYuSFIhLMN8Mr7CTd4Ju0uWnF+PCnuXMZWBL6VJNsCOGsayJ0zrj4asUCW0Exz8giJK64=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4719.namprd10.prod.outlook.com (2603:10b6:a03:2d1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.20; Tue, 9 Feb
 2021 18:59:36 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 18:59:36 +0000
Subject: Re: [PATCH 10/13] target_core_user: add backend plug/unplug callouts
To:     Bodo Stroesser <bostroesser@gmail.com>, Chaitanya.Kulkarni@wdc.com,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
References: <20210209123845.4856-1-michael.christie@oracle.com>
 <20210209123845.4856-11-michael.christie@oracle.com>
 <c316642b-0b9b-49b5-0d1f-db1d1fea9e99@gmail.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <439e3f72-e786-967a-c07d-54cb826e2683@oracle.com>
Date:   Tue, 9 Feb 2021 12:59:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <c316642b-0b9b-49b5-0d1f-db1d1fea9e99@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR03CA0084.namprd03.prod.outlook.com
 (2603:10b6:610:cc::29) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by CH0PR03CA0084.namprd03.prod.outlook.com (2603:10b6:610:cc::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Tue, 9 Feb 2021 18:59:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5edf3a3e-6a0f-41fc-e30f-08d8cd2cd85d
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4719:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB47194A92EB27F1D4C04CCF0FF18E9@SJ0PR10MB4719.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2iOVKIqtTbcxUwLOGEhHEpp0RMPL7h4vuZsFvKja3LXve1HT3gFAPV5XQGs/Zcnp05zbxw4MH7Z+Mu+QpPgtVOD10J+cs+EjMB3yNNApQUU3kE9MvWFUto4GeCGN6BzSLatQn1+ajCOf+Nnbuf6vDGerpQIvImj72y3G9BoiZt8MKQzULELIKETTVZVn/ww+U7fxhQd6NdApufePdoaBB1/vm4tulJ5O1yhLmHSBGSwk5NsP5ai7H174PyWRVMjdW9OFN2KMmcoSw7MhAWYgd6ij53X4WQRJwr6WOQGsQ4fWDeuo/7aHovDeVqLGsYFfESV7SSNRieISaV+tyVnFn7J9lQLhjDA0k7NeZSLnfBp59vI9SdEzCAZxWk0UF+0NqaqSXSS+ICVKT+/z9RMo2OHeYN3R3XOVojVlqWS0DxySLPvg0OSq3eIbRuAW9ewqMGKl7IALu7K0uRsVgNKIVXJcVpNG0O09F9wbv39zoOBhkm3xU0kiURxtPunjjSNwjU+PDjze23I2bOeqmXSBQxB/yu7PVRuIqy5gwDDauRUGsYOmeWJSIjpNnJYDD9k2ey9FSFYn3p9ACV1Zq+hc6aGCyiKp5MucRKJGsXAvtlS94WuN5e4pyFNUvSpANnpY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(396003)(376002)(346002)(36756003)(66556008)(8676002)(31686004)(16576012)(53546011)(6706004)(66946007)(66476007)(956004)(6486002)(5660300002)(186003)(316002)(86362001)(31696002)(26005)(2906002)(8936002)(2616005)(83380400001)(478600001)(16526019)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?b2h0c2ZBZmwrajlqakU5eVdSTm5JbFBqNUVTYTRRS25iWVlSRGFNTFg4T0FH?=
 =?utf-8?B?SmN1Qmo4clRzT3lBaUdpVGN6akpwVUxQc3RZbkdyRE9KUGcrb2ZXQloxNTdX?=
 =?utf-8?B?QWNKL1luR1owOTMvTTdYZE16bzc5eGEvV21UWlI5blgxS0p3ZnlqMjFUdVpI?=
 =?utf-8?B?TVp1ZEJJT0dxNWZZWnR6eVo5ZVdsVFRqV094KzJrKzJ6Yjh0U2hZVExPTHky?=
 =?utf-8?B?TDdVNlhaelhPdEFYZXdIRCtieEtsYmRWTmxId0dVU2JydTdQVUFUaS8zd1Rp?=
 =?utf-8?B?QWtVQVErbURFU0VZY2hiWXIzK1ZOZ1ZPNWVncnkwdzhzY05LZ2lreVNtd2Zp?=
 =?utf-8?B?ZnVmaktVaXJWazNkbDRyNnE2R3lNSWdVMTJYK3crYnM5Ym81dlYxNkh5MWpO?=
 =?utf-8?B?ck9XRFNxeGVzcDRuMUllMjJVQnd0RzhTRnQ0ekt6b1cveS9mWE0vcTN4WkZL?=
 =?utf-8?B?ampMdWE0S0k1NE9JS1ZuWGpld2w5aHE2YmtEY1JFWHF3UHZDbDhpMUY2UXJK?=
 =?utf-8?B?QkZsTmZ5ZXVQbmM5dWlPcTQwWTkxN0J0V21LU1hDN3M4czBwS0tBT3puSHRR?=
 =?utf-8?B?Z2paOWFyb0lTSit0cDJTUjZLKzd2RWNFUk10b3V6ZnFVOWF5eFRLa2hjS05Z?=
 =?utf-8?B?ZlY1dy9pUFN3OFIwT0ZtSTNiM0RldTU2Y1hNRTNEK2JkT1pnS3loUjI5b1Rr?=
 =?utf-8?B?K0VWVEZMVzJvRUYrMWp2Vm1ZNWI1VzZsMEJ6QTdIbER4VEJNR2pNUDVUeWhs?=
 =?utf-8?B?Y1hqbDF1VUx2VjFHcmdZd1FxUHRWQ3RnNFV3UG9DOWt0ZGFVQnZwZExreWlH?=
 =?utf-8?B?YXBwVkZKamNtcmlxQmtBR3IzbFJreUpWYzU4c0FoMEZGYVBCVk5HdGxvVVV6?=
 =?utf-8?B?NFdmUS9ZOVF0Rm5nVlFZcTNaSE1MdCtLNkloejJHQldtSUdUdFFRQS9WclJ2?=
 =?utf-8?B?eUNqOVI5RmRZbGVydVI3NWwxNHdKczRickVUUkN3UjlQcmUxSUdDZVp4QVYr?=
 =?utf-8?B?Z3FiK1ZnREdBdTJyYWRiQ2xORmFFM3JJMW15ZU5VVmhHRlRCT0lVVFZIemhw?=
 =?utf-8?B?d2VWTnorQVFTQzlIWS8yakkzOHMrZGV4RkZMZUdVS09MQmxkcHdWS0ozTTYx?=
 =?utf-8?B?MzduRUY3b2Y0Rm56SG5oKzQxalhWL1lxeWhIZEtJdnhCdEoyRk5JTzFzR1B1?=
 =?utf-8?B?eWtIWkFuS1BxL3U5aGN6WFFYUE9xTzdlTEpxWG1adEY4eHlHbTRMM2t6Qkhs?=
 =?utf-8?B?a1NqRkpCVDJwNHlkUHlGWC9BSEw4ODg5MWJ6NTlDZlhBdkZQRGpyd25EcGJC?=
 =?utf-8?B?L2ppOTNWL21PTFoxTmRxeVhRdVJ5MlpKQ1VzR0k3b20wYUFQK2daTHJTdVhn?=
 =?utf-8?B?WXBRZTdQazBmOFFnMEZyOCsyc3d6Z0o5QW15UUZUQ3luRVl3MVd2OTdSUWhw?=
 =?utf-8?B?bVlWWGV2eXhlZEJCcmJLWGhpQXZ5UE45TVd5UzNtL3NMZUF0L3FXQ0l2ZWt0?=
 =?utf-8?B?YXZnSUd2bDB0eUNRY3VTck92bGFqYmNoN0c0dVZ1Q1p3UWtmYzM2Uks0TFI5?=
 =?utf-8?B?MjdZUWwxYUJ5cHQ2emJsZmNhYWR1c3l3WG9JRzlpVWJhVHJYUTYxenI1YlQ5?=
 =?utf-8?B?eWRNVENwK0RDRDNBVERJT0pOSlYraE10cmh0bFgxSmQxV2o5MnFaMmhzRS9Z?=
 =?utf-8?B?Z0N6T1pUeVVIRWhtQXJPbTM0QXYvSXgyb3ZwWUU2blcraUR2U1pRTEFSTnRz?=
 =?utf-8?Q?Ixbz2sTvRp6asC9iknzOA1EnFTMhj/KkW444Qru?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5edf3a3e-6a0f-41fc-e30f-08d8cd2cd85d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 18:59:36.8540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mQ6XNHM0bi4kiZmERmHXOlhTszi5MLmG6yhuHH/uAfirlhRfwtfLsxsN0WU8oGeryyU7RXCZXFu8oTqG8bG6P5R9jquKKBDD2SflaRG86jw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4719
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090089
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090089
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/9/21 10:32 AM, Bodo Stroesser wrote:
> On 09.02.21 13:38, Mike Christie wrote:
>> This patch adds plug/unplug callouts for tcmu, so we can avoid the
>> number of times we switch to userspace. Using this driver with tcm
>> loop is a common config, and dependng on the nr_hw_queues
>> (nr_hw_queues=1 performs much better) and fio jobs (lower num jobs
>> around 4) this patch can increase IOPs by only around 5-10% because
>> we hit other issues like the big per tcmu device mutex.> 
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>   drivers/target/target_core_user.c | 27 +++++++++++++++++++++++++--
>>   1 file changed, 25 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
>> index a5991df23581..a030ca6f0f4c 100644
>> --- a/drivers/target/target_core_user.c
>> +++ b/drivers/target/target_core_user.c
>> @@ -111,6 +111,7 @@ struct tcmu_dev {
>>   	struct kref kref;
>>   
>>   	struct se_device se_dev;
>> +	struct se_dev_plug se_plug;
>>   
>>   	char *name;
>>   	struct se_hba *hba;
>> @@ -119,6 +120,7 @@ struct tcmu_dev {
>>   #define TCMU_DEV_BIT_BROKEN 1
>>   #define TCMU_DEV_BIT_BLOCKED 2
>>   #define TCMU_DEV_BIT_TMR_NOTIFY 3
>> +#define TCM_DEV_BIT_PLUGGED 4
>>   	unsigned long flags;
>>   
>>   	struct uio_info uio_info;
>> @@ -959,6 +961,25 @@ static uint32_t ring_insert_padding(struct tcmu_dev *udev, size_t cmd_size)
>>   	return cmd_head;
>>   }
>>   
>> +static void tcmu_unplug_device(struct se_dev_plug *se_plug)
>> +{
>> +	struct se_device *se_dev = se_plug->se_dev;
>> +	struct tcmu_dev *udev = TCMU_DEV(se_dev);
>> +
>> +	uio_event_notify(&udev->uio_info);
> 
> Don't we have a race here?
> 
> Let's assume that
>  - just here the thread is interrupted
>  - userspace starts,empties the ring and sleeps again
>  - another cpu queues a new CDB in the ring
> In that - of course very rare condition - userspace will not wake up for the freshly queued CDB.
> 
> I think, first clearing the bit, then doing the uio_event_notify would work (without need to take the big tcmu mutex).

You,re right. Will fix. I have the same issue in iblock and there
I made a mistake where it per cpu when it should be per task.
