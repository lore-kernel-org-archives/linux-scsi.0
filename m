Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D543C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 18:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A40B2220D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 18:10:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0K7cvwsy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgGNSKX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 14:10:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43076 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbgGNSKX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 14:10:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EHq5Qj034517;
        Tue, 14 Jul 2020 18:10:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=DSOcYyrYX351gCKT8xKJx9jna1dphGdctQQaAvtBGb8=;
 b=0K7cvwsyIiwM11hCLvQ3yv53x2tEgdNP+r2f6cyfkNgtB39tx8F1pgzxiFT/RrcwJ7xG
 d8ZTB4X9itvRvbpcB50rd70/ymIcPl8QYg4hYbZvJpWIleEDeIbDysPZdh6lDFBlBYQK
 W+oEYCV+Fg7r+vhZ2KfJBJfuUdTJrPNcg6MckiwA9A6gcqBxKR1qkXYS+LWjVr8vpjE/
 LJ+ylCpeoFi5CHy02Tylcutd4QcZJ55pAUIdUMegmmETcdc2m7ITE3syqJ1eMiKAKOjv
 xsg6+zr0GmHSNfD5vZI8n+7TzurAftVKtYF2XOLme0vMzwvC2zmhGFAp8Zw2O06DKLYt Vg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3274ur72dw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 18:10:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EHrbf4115773;
        Tue, 14 Jul 2020 18:10:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 327q6ssh9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 18:10:18 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06EIAHAt015673;
        Tue, 14 Jul 2020 18:10:17 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 11:10:17 -0700
Subject: Re: [PATCH 7/8] scsi: target: tcmu: Implement tmr_notify callback
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
 <20200710104817.19462-8-bstroesser@ts.fujitsu.com>
 <24d9afb0-3ea9-e83b-acf0-b44f04583a6e@oracle.com>
 <b8bb9898-6ff8-2ffb-47d6-d96534c6d315@ts.fujitsu.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <a32b8b9e-c993-6709-b71e-3fbf80d0bdf3@oracle.com>
Date:   Tue, 14 Jul 2020 13:10:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <b8bb9898-6ff8-2ffb-47d6-d96534c6d315@ts.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=2
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=2 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140130
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/20 7:03 AM, Bodo Stroesser wrote:
> On 2020-07-12 03:15, Mike Christie wrote:
>> On 7/10/20 5:48 AM, Bodo Stroesser wrote:
> 
> ...
> 
>>> @@ -844,6 +854,9 @@ static bool is_ring_space_avail(struct tcmu_dev 
>>> *udev, struct tcmu_cmd *cmd,
>>>           return false;
>>>       }
>>> +    if (!data_needed)
>>> +        return true;
>>> +
>>>       /* try to check and get the data blocks as needed */
>>>       space = spc_bitmap_free(udev->data_bitmap, udev->dbi_thresh);
>>>       if ((space * DATA_BLOCK_SIZE) < data_needed) {
>>> @@ -1106,6 +1119,61 @@ static int queue_cmd_ring(struct tcmu_cmd 
>>> *tcmu_cmd, sense_reason_t *scsi_err)
>>>       return 1;
>>>   }
>>> +/*
>>
>> We do 2 stars for this type of comment:
>>
>> /**
>>
>>> + * queue_tmr_ring - queue tmr info to ring or internally
>>> + *
>>
>> No extra newline.
>>
> 
> Ah, thank you. I'll fix both.
>>> @@ -1141,6 +1209,85 @@ static void tcmu_set_next_deadline(struct 
>>> list_head *queue,
>>>           del_timer(timer);
>>>   }
>>> +static int
>>> +tcmu_tmr_type(enum tcm_tmreq_table tmf)
>>> +{
>>> +    switch (tmf) {
>>> +    case TMR_ABORT_TASK:        return TCMU_TMR_ABORT_TASK;
>>> +    case TMR_ABORT_TASK_SET:    return TCMU_TMR_ABORT_TASK_SET;
>>> +    case TMR_CLEAR_ACA:        return TCMU_TMR_CLEAR_ACA;
>>> +    case TMR_CLEAR_TASK_SET:    return TCMU_TMR_CLEAR_TASK_SET;
>>> +    case TMR_LUN_RESET:        return TCMU_TMR_LUN_RESET;
>>> +    case TMR_TARGET_WARM_RESET:    return TCMU_TMR_TARGET_WARM_RESET;
>>> +    case TMR_TARGET_COLD_RESET:    return TCMU_TMR_TARGET_COLD_RESET;
>>> +    case TMR_LUN_RESET_PRO:        return TCMU_TMR_LUN_RESET_PRO;
>>> +    default:            return TCMU_TMR_UNKNOWN;
>>> +    }
>>> +}
>>> +
>>> +static void
>>> +tcmu_tmr_notify(struct se_device *se_dev, enum tcm_tmreq_table tmf,
>>> +        struct list_head *cmd_list)
>>> +{
>>> +    int i = 0, cmd_cnt = 0;
>>> +    bool unqueued = false;
>>> +    uint16_t *cmd_ids = NULL;
>>> +    struct tcmu_cmd *cmd;
>>> +    struct se_cmd *se_cmd;
>>> +    struct tcmu_tmr *tmr;
>>> +    struct tcmu_dev *dev = TCMU_DEV(se_dev);
>>> +
>>> +    mutex_lock(&dev->cmdr_lock);
>>> +
>>> +    // First we check for aborted commands in qfull_queue
>>
>> I know the coding style doc does not say to never use // anymore, but 
>> just use the same style we have already in the rest of the code for 
>> single line comments:
>>
>> /* comment */
>>
>>
> 
> Ok, I'll fix.
> 
>>> +struct tcmu_tmr_entry {
>>> +    struct tcmu_cmd_entry_hdr hdr;
>>> +
>>> +#define TCMU_TMR_UNKNOWN        0
>>> +#define TCMU_TMR_ABORT_TASK        1
>>> +#define TCMU_TMR_ABORT_TASK_SET        2
>>> +#define TCMU_TMR_CLEAR_ACA        3
>>> +#define TCMU_TMR_CLEAR_TASK_SET        4
>>> +#define TCMU_TMR_LUN_RESET        5
>>> +#define TCMU_TMR_TARGET_WARM_RESET    6
>>> +#define TCMU_TMR_TARGET_COLD_RESET    7
>>> +/* Pseudo reset due to received PR OUT */
>>> +#define TCMU_TMR_LUN_RESET_PRO        128
>>> +    __u8 tmr_type;
>>> +
>>> +    __u8 __pad1;
>>> +    __u16 __pad2;
>>> +    __u32 cmd_cnt;
>>> +    __u64 __pad3;
>>> +    __u64 __pad4;
>>> +    __u16 cmd_ids[0];
>>> +} __packed;
>>> +
>>
>> Is this new request and the tmr_notify callback just supposed to clean 
>> up the requested commands or is it supposed to perform the actions of 
>> the task management function defined in the specs?
>>
>> The callback name makes it feel like it's just a notification, but the 
>> names above make it seem like we are supposed to execute the TMF in 
>> userspace. But if the latter, then how do we notify the kernel if the 
>> TMF was successful or failed?
> 
> My plan is to have a notification only. IMHO userspace (and also tcmu
> or another backend) must not interfere with core's TMR handling.
> The new callback tmr_notify just allows backend to be helpful during
> TMR handling by completing in core aborted, but in backend/userspace
> still running commands early.
> 
> Do you refer to the TCMU_TMR_* definitions? I just defined these names
> because TMR_* definitions are in target_core_base.h which is not exposed
> to userspace programs. Knowing the type of TMR that aborted a command is
> useful at least for userspace tracin

I see where you are going. Makes sense to me now.

> 
> BTW: I hope there are enough padding fields in the tcmu_tmr_entry to
> allow additional session info later?

Yes.

One question on that. Were you going to use the tcmu_cmd_entry_hdr 
flags, or add a flag field to tcmu_tmr_entry?

Or will userspace just know its enabled because we would eventually add 
a add/delete session callback to the backend modules. And from the add 
callout, we would then notify userspace of the new session and that 
other commands like tcmu_tmr_entry have session info in it.

