Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CD6BC433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 17:43:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4663622582
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 17:43:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xBxxGz+u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgGNRnb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 13:43:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58248 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728087AbgGNRnb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 13:43:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EHbCS6038412;
        Tue, 14 Jul 2020 17:43:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=cT8Q+dv6j7yYW42I9DFOWwbEvMCTW7Knov93etRKROM=;
 b=xBxxGz+uXttWLW13Ox6Lg+whVN/TSIEjEzLMQxls34PBtNN3rtiHxZUhvEbMdND+Tq0b
 biokbx9MFz988dLNlzQTkESyQpYGMhUJPMHutHB4QQ8L9aAjQSZonRt3ioqYwqGMm+P/
 +SZfiK/ksbFbwfXFCPYcj5prsG3oQpZ939IDWlcHHfc1WbShTbedHkMmwSJwXdT532/j
 aFak2U0iV66ybPu6GzkuCLWXJQtONX9b6DpxNbX53jOhUgqjz/Ap6yTKIc4woCZzto1t
 mA27c4+/rIJcheXNiI1yymXhT1aVAxlP0uJEyWj3BeQCG7oabdwYsCBP5BivtFD71PJ7 Hw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32762neqa3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 17:43:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EHWdlM151505;
        Tue, 14 Jul 2020 17:43:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 327qby4pet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 17:43:27 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06EHhQoL027343;
        Tue, 14 Jul 2020 17:43:26 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 10:43:26 -0700
Subject: Re: [PATCH 1/8] scsi: target: Modify core_tmr_abort_task()
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
 <20200710104817.19462-2-bstroesser@ts.fujitsu.com>
 <ea36fcc0-d01c-eba1-748f-d5cfa39fa105@oracle.com>
 <0f660dc9-40ee-75a4-2924-761769d9cd38@ts.fujitsu.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <e4d54aed-88fa-eeed-fe9a-20e627c3841a@oracle.com>
Date:   Tue, 14 Jul 2020 12:43:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <0f660dc9-40ee-75a4-2924-761769d9cd38@ts.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 suspectscore=0 phishscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140129
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/20 6:39 AM, Bodo Stroesser wrote:
> On 2020-07-12 02:49, Mike Christie wrote:
>> On 7/10/20 5:48 AM, Bodo Stroesser wrote:
> 
> ...
> 
>>> @@ -137,11 +138,16 @@ void core_tmr_abort_task(
>>>           printk("ABORT_TASK: Found referenced %s task_tag: %llu\n",
>>>               se_cmd->se_tfo->fabric_name, ref_tag);
>>> -        if (!__target_check_io_state(se_cmd, se_sess,
>>> -                         dev->dev_attrib.emulate_tas))
>>> +        spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
>>> +        rc = __target_check_io_state(se_cmd, se_sess, 0);
>>> +        spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
>>> +        if (!rc)
>>>               continue;
>>> -        spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
>>> +        list_del_init(&se_cmd->state_list);
>>
>> Do we only want to do this if in the next patch tmr_notify can 
>> successfully accept the tmr?
> 
> This change does not modify behavior of the core. Please see how
> core_tmr_drain_state_list() uses state_list to queue commands after
> successfully calling __target_check_io_state() for later call of 
> target_put_cmd_and_wait().
> 
> This patch just unifies ABORT_TASK and LUN_RESET handling such,
> that in next patch we can call tmr_notify handler with a list of
> aborted commands in both cases. The list uses the state_list list_head
> in the se_cmd.
> 
>>
>> If tmr_notify can't allocate memory for the abort case, we would 
>> delete it from the list. Later the initiator would send a LUN_RESET 
>> but core_tmr_drain_state_list won't see it and pass it to the 
>> tmr_notify call.
>>
> 
> tmr_notify handler will not and must not modify the list of aborted
> cmds. So if backend just does nothing for whatever reason we will end
> up with the "old" behavior of the core as it was before the change.
> 
> The general idea is to send info about received TMRs together with the
> list of aborted commands to the backend, to allow TMR tracing and
> canceling of aborted commands. But backend must not interfere with TMR
> processing in core.

I don't think we are talking about the same thing.

For the abort case, let's say tmr_notify fails. So for the tcmu case, 
the tmr does not get queued and userspace never knows about it. The 
initiator then sends a LUN reset. For the reset, the tmr_notify call's 
list will be missing the command that got the abort, right? How will the 
backend know to clean up that command during the LUN reset handling?

> 
>>> +        se_cmd->state_active = false;
>>> +
>>> +        spin_unlock_irqrestore(&dev->execute_task_lock, flags);
>>>           /*
>>>            * Ensure that this ABORT request is visible to the LU RESET
>>> @@ -159,7 +165,7 @@ void core_tmr_abort_task(
>>>           atomic_long_inc(&dev->aborts_complete);
>>>           return;
>>>       }
>>> -    spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
>>> +    spin_unlock_irqrestore(&dev->execute_task_lock, flags);
>>>       printk("ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for 
>>> ref_tag: %lld\n",
>>>               tmr->ref_task_tag);
>>>
>>

