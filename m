Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64812C433EC
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 18:46:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4093420787
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 18:46:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wxOhec9H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgGOSqf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 14:46:35 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:47516 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbgGOSqf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 14:46:35 -0400
X-Greylist: delayed 1342 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Jul 2020 14:46:34 EDT
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FIHt6R157655;
        Wed, 15 Jul 2020 18:24:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=5G0BjHWUZxMdn9E6mO29m9CW3V2ay0SjzvoKoZdc+kA=;
 b=wxOhec9HTklACdHIkRD+Ze2e2v8sac4hGH4Glfj5j/W+QfwWKwZFOrsKfgsv0SwswCq/
 mKC5eMhVxyS5+iVDZ528oAOi0Ox87+uRpbd1FFgyO6wKkuHU39+RkUG1hqSHnf0PDyPP
 2wXgepdcPIWs07GUsAXgINo1/Kb81MER3F5zKJnG8Fy9iMiw+8rSGNwnDoseMJrv4eex
 sWlYmzlAIBNhinVyTlTcjSKenChYW6ry2OEZxHFqtXfAtmIjrRIq4dXTOL586zfx02RM
 ItZalVOvKs6CFTSvsvsjDNpdOFfO5QyyY8zERevPLDTxnji7uE1xdvZYlS5hS8hMK/M9 4g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 327s65kaqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 18:24:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FIDf8O016092;
        Wed, 15 Jul 2020 18:24:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 327q0rr6r8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 18:24:09 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06FIO8GC026106;
        Wed, 15 Jul 2020 18:24:08 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 11:24:08 -0700
Subject: Re: [PATCH 1/8] scsi: target: Modify core_tmr_abort_task()
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
 <20200710104817.19462-2-bstroesser@ts.fujitsu.com>
 <ea36fcc0-d01c-eba1-748f-d5cfa39fa105@oracle.com>
 <0f660dc9-40ee-75a4-2924-761769d9cd38@ts.fujitsu.com>
 <e4d54aed-88fa-eeed-fe9a-20e627c3841a@oracle.com>
 <980ec328-f604-556b-400a-1404c56e34ae@ts.fujitsu.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <a263f857-a582-d262-b347-20687502ee91@oracle.com>
Date:   Wed, 15 Jul 2020 13:24:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <980ec328-f604-556b-400a-1404c56e34ae@ts.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 impostorscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150142
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/15/20 9:25 AM, Bodo Stroesser wrote:
> On 2020-07-14 19:43, Mike Christie wrote:
>> On 7/13/20 6:39 AM, Bodo Stroesser wrote:
>>> On 2020-07-12 02:49, Mike Christie wrote:
>>>> On 7/10/20 5:48 AM, Bodo Stroesser wrote:
>>>
>>> ...
>>>
>>>>> @@ -137,11 +138,16 @@ void core_tmr_abort_task(
>>>>>           printk("ABORT_TASK: Found referenced %s task_tag: %llu\n",
>>>>>               se_cmd->se_tfo->fabric_name, ref_tag);
>>>>> -        if (!__target_check_io_state(se_cmd, se_sess,
>>>>> -                         dev->dev_attrib.emulate_tas))
>>>>> +        spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
>>>>> +        rc = __target_check_io_state(se_cmd, se_sess, 0);
>>>>> +        spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
>>>>> +        if (!rc)
>>>>>               continue;
>>>>> -        spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
>>>>> +        list_del_init(&se_cmd->state_list);
>>>>
>>>> Do we only want to do this if in the next patch tmr_notify can 
>>>> successfully accept the tmr?
>>>
>>> This change does not modify behavior of the core. Please see how
>>> core_tmr_drain_state_list() uses state_list to queue commands after
>>> successfully calling __target_check_io_state() for later call of 
>>> target_put_cmd_and_wait().
>>>
>>> This patch just unifies ABORT_TASK and LUN_RESET handling such,
>>> that in next patch we can call tmr_notify handler with a list of
>>> aborted commands in both cases. The list uses the state_list list_head
>>> in the se_cmd.
>>>
>>>>
>>>> If tmr_notify can't allocate memory for the abort case, we would 
>>>> delete it from the list. Later the initiator would send a LUN_RESET 
>>>> but core_tmr_drain_state_list won't see it and pass it to the 
>>>> tmr_notify call.
>>>>
>>>
>>> tmr_notify handler will not and must not modify the list of aborted
>>> cmds. So if backend just does nothing for whatever reason we will end
>>> up with the "old" behavior of the core as it was before the change.
>>>
>>> The general idea is to send info about received TMRs together with the
>>> list of aborted commands to the backend, to allow TMR tracing and
>>> canceling of aborted commands. But backend must not interfere with TMR
>>> processing in core.
>>
>> I don't think we are talking about the same thing.
> 
> Yeah, probably I misunderstood.
> 
>>
>> For the abort case, let's say tmr_notify fails.So for the tcmu case, 
>> the tmr does not get queued and userspace never knows about it.
> 
> True.
> 
> For the tcmu case tmr_notify can fail only if kmalloc(..., GFP_KERNEL)
> fails.
> 
>> The initiator then sends a LUN reset. For the reset, the tmr_notify 
>> call's list will be missing the command that got the abort, right?
> 
> Yes.
> 
> In core, the LUN RESET will wait in core_tmr_drain_tmr_list for the
> previous ABORT_TASK to complete, while the ABORT_TASK itself waits for
> the aborted command to complete in core_tmr_abort_task.
> 
> So, when LUN_RESET handling comes to calling core_tmr_drain_state_list,
> the aborted command will definitely already be done.
> 
>> How will the backend know to clean up that command during the LUN 
>> reset handling?
>>
> 
> It will not know, so core just has to wait until backend completes the
> aborted cmd - maybe after long time - just like it always did before my
> change.

Ah I see. When I made the original comment and was asking about if the 
callback was supposed to perform some of the TMF operations I was 
thinking we were going to change up a lot of this code.

I think your idea where it's more of a way to notify the modules and we 
are not changing any of this behavior is better since no one wants to 
get into that :)

Seems ok to me.
