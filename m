Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2092DC433EB
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 14:26:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B69F5205CB
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 14:26:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="qmKZCR9s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbgGOO0L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 10:26:11 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.2]:44567 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725819AbgGOO0J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Jul 2020 10:26:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1594823165; i=@ts.fujitsu.com;
        bh=y2XFR0UAO5pdByWxUg+B/R6uemx1n0gYUH4Ehm6FZqw=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=qmKZCR9sNnCsD5IoN5gVWSN6M2Y2kuM65yfYNylWWW+8yf8wWNRRdosYyG74lrkEn
         nxNI1HCXC5J0JnDwrAgIlX4zE5uJYf6KR2ByvoJ4KDGOvhPZZjeEJCwHMrY2HQCsry
         yvoBw8/d1lWT3gkQid0aXDbgUdE1IeXMKDCMSmmcnPJobaXFXhgZTyO6u362HjuQtj
         27RODxUCqTXL4m9EPOXkAAmKjWU/SVTOwQ8BWUfPViioSKLt7w7q89dbu0sEio8Vqj
         lrqRjqNb77w4cS0gusymg/PbU7Wlo1RVGDyps66zWWwr/uQ2YI5NXHf07rTdyOqkMj
         p38l8/UMZoA7g==
Received: from [100.112.192.107] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-2.bemta.az-a.eu-west-1.aws.symcld.net id 54/E4-44658-DF11F0F5; Wed, 15 Jul 2020 14:26:05 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRWlGSWpSXmKPExsViZ8MRqvtHkD/
  e4Mc9E4vu6zvYLJYf/8dk8XfSDVaL1qVvmRxYPD4+vcXi8XmTXABTFGtmXlJ+RQJrxrdPS1kL
  1qtXrNi9hqWBcbdSFyMXh5DAZEaJl8c2MkM4/YwSb2+sBXI4OYQFnCXmbHvPBpIQEVjDKLHo9
  VImqComietLr4FVsQkYSKyYdJ8FxOYVcJS4/XUxI4jNIqAq8WjSQ6A4B4eoQLjEsxX+ECWCEi
  dnPgEr5xSwk3hzcxdYObOAmcS8zQ+ZIWxxiVtP5jNB2NoSyxa+Zp7AyDcLSfssJC2zkLTMQtK
  ygJFlFaNFUlFmekZJbmJmjq6hgYGuoaGRrqGlqa6hqaFeYpVuol5qqW55anGJLpBbXqxXXJmb
  nJOil5dasokRGNApBYen72Dsf/NB7xCjJAeTkihvBDN/vBBfUn5KZUZicUZ8UWlOavEhRhkOD
  iUJXklgjAgJFqWmp1akZeYAowsmLcHBoyTC2yIAlOYtLkjMLc5Mh0idYtTlaHk0bxGzEEtefl
  6qlDivE0iRAEhRRmke3AhYpF9ilJUS5mVkYGAQ4ilILcrNLEGVf8UozsGoJMx7nx9oCk9mXgn
  cpldARzABHbHxMy/IESWJCCmpBqZQ4+hkjZv1t/M9woMPS1iebqz0XqM3k5dp9oMtGy9beC5j
  Tblye88BcYPTxS5fF3CsKRNftHTf197QGQK3hP+erHIPZJncIHiZIzShO2PLO6Gl2xseCBj+E
  Nwm8MSNPYth180E09inTU3bpAWNDh/ke5Hv3W76jE0ki/nh4/dvfdTSPAOn6MpXW94L/zXV17
  dHfqaLwia2hVwHi+Yu7359Mrjhyakg3xcmLe3q1h7vnSd1Ne7wSFSuWCwtH/Ni9dUVQfrp28+
  lv2yvECi2rPD5JV3+c6Epz5wmBcNv05iKXl2pTJfkyy+ceb9RtsLY8fdv7YOdUbcEZI1etD/k
  4q14fHpC5WFZnclH01oVlFiKMxINtZiLihMBTMOBGG8DAAA=
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-17.tower-267.messagelabs.com!1594823164!274048!1
X-Originating-IP: [62.60.8.85]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 5499 invoked from network); 15 Jul 2020 14:26:04 -0000
Received: from unknown (HELO mailhost4.uk.fujitsu.com) (62.60.8.85)
  by server-17.tower-267.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 15 Jul 2020 14:26:04 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost4.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06FEQ0iD017578;
        Wed, 15 Jul 2020 15:26:00 +0100
Received: from [172.17.39.90] (unknown [172.17.39.90])
        by x-serv01 (Postfix) with ESMTP id 82E6D20489;
        Wed, 15 Jul 2020 16:25:51 +0200 (CEST)
Subject: Re: [PATCH 1/8] scsi: target: Modify core_tmr_abort_task()
To:     Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
 <20200710104817.19462-2-bstroesser@ts.fujitsu.com>
 <ea36fcc0-d01c-eba1-748f-d5cfa39fa105@oracle.com>
 <0f660dc9-40ee-75a4-2924-761769d9cd38@ts.fujitsu.com>
 <e4d54aed-88fa-eeed-fe9a-20e627c3841a@oracle.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <980ec328-f604-556b-400a-1404c56e34ae@ts.fujitsu.com>
Date:   Wed, 15 Jul 2020 16:25:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <e4d54aed-88fa-eeed-fe9a-20e627c3841a@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-14 19:43, Mike Christie wrote:
> On 7/13/20 6:39 AM, Bodo Stroesser wrote:
>> On 2020-07-12 02:49, Mike Christie wrote:
>>> On 7/10/20 5:48 AM, Bodo Stroesser wrote:
>>
>> ...
>>
>>>> @@ -137,11 +138,16 @@ void core_tmr_abort_task(
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 printk("ABORT=
_TASK: Found referenced %s task_tag: %llu\n",
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 se_cmd->se_tfo->fabric_name, ref_tag);
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!__target_check_io_s=
tate(se_cmd, se_sess,
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 dev->dev_attrib.emulate_tas))
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock_irqsave(&se_se=
ss->sess_cmd_lock, flags);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc =3D __target_check_io=
_state(se_cmd, se_sess, 0);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock_irqrestore(&=
se_sess->sess_cmd_lock, flags);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!rc)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 continue;
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock_irqrestore(&=
se_sess->sess_cmd_lock, flags);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_del_init(&se_cmd->s=
tate_list);
>>>
>>> Do we only want to do this if in the next patch tmr_notify can=20
>>> successfully accept the tmr?
>>
>> This change does not modify behavior of the core. Please see how
>> core_tmr_drain_state_list() uses state_list to queue commands after
>> successfully calling __target_check_io_state() for later call of=20
>> target_put_cmd_and_wait().
>>
>> This patch just unifies ABORT_TASK and LUN_RESET handling such,
>> that in next patch we can call tmr_notify handler with a list of
>> aborted commands in both cases. The list uses the state_list list_head
>> in the se_cmd.
>>
>>>
>>> If tmr_notify can't allocate memory for the abort case, we would=20
>>> delete it from the list. Later the initiator would send a LUN_RESET=20
>>> but core_tmr_drain_state_list won't see it and pass it to the=20
>>> tmr_notify call.
>>>
>>
>> tmr_notify handler will not and must not modify the list of aborted
>> cmds. So if backend just does nothing for whatever reason we will end
>> up with the "old" behavior of the core as it was before the change.
>>
>> The general idea is to send info about received TMRs together with the
>> list of aborted commands to the backend, to allow TMR tracing and
>> canceling of aborted commands. But backend must not interfere with TMR
>> processing in core.
>=20
> I don't think we are talking about the same thing.

Yeah, probably I misunderstood.

>=20
> For the abort case, let's say tmr_notify fails.So for the tcmu case,=20
> the tmr does not get queued and userspace never knows about it.

True.

For the tcmu case tmr_notify can fail only if kmalloc(..., GFP_KERNEL)
fails.

> The=20
> initiator then sends a LUN reset. For the reset, the tmr_notify call's=20
> list will be missing the command that got the abort, right?

Yes.

In core, the LUN RESET will wait in core_tmr_drain_tmr_list for the
previous ABORT_TASK to complete, while the ABORT_TASK itself waits for
the aborted command to complete in core_tmr_abort_task.

So, when LUN_RESET handling comes to calling core_tmr_drain_state_list,
the aborted command will definitely already be done.

> How will the=20
> backend know to clean up that command during the LUN reset handling?
>=20

It will not know, so core just has to wait until backend completes the
aborted cmd - maybe after long time - just like it always did before my
change.

I don't see a clean way for error handling if tmr notification fails
in backend. Do you have an idea?

Regarding tcmu I think if we run into OOM, then losing tmr notifications
might be one of the smallest problems.

>>
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 se_cmd->state_active =3D=
 false;
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock_irqrestore(&=
dev->execute_task_lock, flags);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Ensur=
e that this ABORT request is visible to the LU RESET
>>>> @@ -159,7 +165,7 @@ void core_tmr_abort_task(
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 atomic_long_i=
nc(&dev->aborts_complete);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>> -=C2=A0=C2=A0=C2=A0 spin_unlock_irqrestore(&se_sess->sess_cmd_lock, =
flags);
>>>> +=C2=A0=C2=A0=C2=A0 spin_unlock_irqrestore(&dev->execute_task_lock, =
flags);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 printk("ABORT_TASK: Sending TMR_TASK_=
DOES_NOT_EXIST for=20
>>>> ref_tag: %lld\n",
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 tmr->ref_task_tag);
>>>>
>>>
>=20
