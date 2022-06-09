Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E961EC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jun 2022 07:03:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbiFIHDJ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jun 2022 03:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbiFIHDI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2022 03:03:08 -0400
X-Greylist: delayed 391 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 09 Jun 2022 00:03:05 PDT
Received: from mx3.uni-regensburg.de (mx3.uni-regensburg.de [IPv6:2001:638:a05:137:165:0:4:4e79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8691CA5D7
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jun 2022 00:03:03 -0700 (PDT)
Received: from mx3.uni-regensburg.de (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id A25BF600006C
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jun 2022 08:56:29 +0200 (CEST)
Received: from gwsmtp.uni-regensburg.de (gwsmtp1.uni-regensburg.de [132.199.5.51])
        by mx3.uni-regensburg.de (Postfix) with ESMTP id 2727D600005C
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jun 2022 08:56:29 +0200 (CEST)
Received: from uni-regensburg-smtp1-MTA by gwsmtp.uni-regensburg.de
        with Novell_GroupWise; Thu, 09 Jun 2022 08:56:29 +0200
Message-Id: <62A1999B020000A10004AC3F@gwsmtp.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 18.4.0 
Date:   Thu, 09 Jun 2022 08:56:27 +0200
From:   "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To:     "Chris Leech" <cleech@redhat.com>, "Lee Duncan" <lduncan@suse.com>,
        <d.bogdanov@yadro.com>
Cc:     "open-iscsi" <open-iscsi@googlegroups.com>,
        <linux-scsi@vger.kernel.org>, <k.shelekhin@yadro.com>,
        <linux@yadro.com>
Subject: Antw: [EXT] Re: [PATCH] scsi: iscsi: prefer xmit of DataOut
 before new cmd
References: <20220607131953.11584-1-d.bogdanov@yadro.com>
 <769c3acb-b515-7fd8-2450-4b6206436fde@oracle.com>
 <6a58acb4-e29e-e8c7-d85c-fe474670dad7@oracle.com>
 <e5c2ab5b4de8428495efe85865980133@yadro.com>
 <48af6f5f-c3b6-ac65-836d-518153ab2dd5@oracle.com>
In-Reply-To: <48af6f5f-c3b6-ac65-836d-518153ab2dd5@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>> Mike Christie <michael.christie@oracle.com> schrieb am 08.06.2022 um 17:36 in
Nachricht <48af6f5f-c3b6-ac65-836d-518153ab2dd5@oracle.com>:
> On 6/8/22 9:16 AM, Dmitriy Bogdanov wrote:
>> Hi Mike,
>> 
>>> On 6/7/22 10:55 AM, Mike Christie wrote:
>>>> On 6/7/22 8:19 AM, Dmitry Bogdanov wrote:
>>>>> In function iscsi_data_xmit (TX worker) there is walking through the
>>>>> queue of new SCSI commands that is replenished in parallell. And only
>>>>> after that queue got emptied the function will start sending pending
>>>>> DataOut PDUs. That lead to DataOut timer time out on target side and
>>>>> to connection reinstatment.
>>>>>
>>>>> This patch swaps walking through the new commands queue and the pending
>>>>> DataOut queue. To make a preference to ongoing commands over new ones.
>>>>>
>>>>
>>>> ...
>>>>
>>>>>              task = list_entry(conn->cmdqueue.next, struct iscsi_task,
>>>>> @@ -1594,28 +1616,10 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>>>>>               */
>>>>>              if (!list_empty(&conn->mgmtqueue))
>>>>>                      goto check_mgmt;
>>>>> +            if (!list_empty(&conn->requeue))
>>>>> +                    goto check_requeue;
>>>>
>>>>
>>>>
>>>> Hey, I've been posting a similar patch:
>>>>
>>>> 
> https://urldefense.com/v3/__https://www.spinics.net/lists/linux-scsi/msg15693 
> 9.html__;!!ACWV5N9M2RV99hQ!LHLghPLuyBZadpsGme03-HBoowa8sNiZYMKxKoz5E_BNu-M9-B
> iuNV_JS9kFxhnumNfhrxuR7qVdIaOH5X7iTfMO$ 
>>>>
>>>> A problem I hit is a possible pref regression so I tried to allow
>>>> us to start up a burst of cmds in parallel. It's pretty simple where
>>>> we allow up to a queue's worth of cmds to start. It doesn't try to
>>>> check that all cmds are from the same queue or anything fancy to try
>>>> and keep the code simple. Mostly just assuming users might try to bunch
>>>> cmds together during submission or they might hit the queue plugging
>>>> code.
>>>>
>>>> What do you think?
>>>
>>> Oh yeah, what about a modparam batch_limit? It's between 0 and cmd_per_lun.
>>> 0 would check after every transmission like above.
>> 
>>  Did you really face with a perf regression? I could not imagine how it is
>> possible.
>> DataOut PDU contains a data too, so a throughput performance cannot be
>> decreased by sending DataOut PDUs.
> 
> 
> We can agree that queue plugging and batching improves throughput right?

Hi!

Isn't that the classic "throughput vs. response time"? I think you cannot optimize one without affecting the other.
(I can remember discussions like "You are sending one ethernet packet for each key pressed; are you crazy?" when network admins felt worried about throughput)

> The app or block layer may try to batch commands. It could be with something
> like fio's batch args or you hit the block layer queue plugging.
> 
> With the current code we can end up sending all cmds to the target in a way
> the target can send them to the real device batched. For example, we send 
> off
> the initial N scsi command PDUs in one run of iscsi_data_xmit. The target 
> reads
> them in, and sends off N R2Ts. We are able to read N R2Ts in the same call.
> And again we are able to send the needed data for them in one call of
> iscsi_data_xmit. The target is able to read in the data and send off the
> WRITEs to the physical device in a batch.
> 
> With your patch, we can end up not batching them like the app/block layer
> intended. For example, we now call iscsi_data_xmit and in the cmdqueue loop.
> We've sent N - M scsi cmd PDUs, then see that we've got an incoming R2T to
> handle. So we goto check_requeue. We send the needed data. The target then
> starts to send the cmd to the physical device. If we have read in multiple
> R2Ts then we will continue the requeue loop. And so we might be able to send
> the data fast enough that the target can then send those commands to the
> physical device. But we've now broken up the batching the upper layers sent
> to us and we were doing before.
> 
>> 
>>  The only thing is a latency performance. But that is not an easy question.
> 
> Agree latency is important and that's why I was saying we can make it config
> option. Users can continue to try and batch their cmds and we don't break
> them. We also fix the bug in that we don't get stuck in the cmdqueue loop
> always taking in new cmds.
> 
>> IMHO, a system should strive to reduce a maximum value of the latency almost
>> without impacting of a minimum value (prefer current commands) instead of
>> to reduce a minimum value of the latency to the detriment of maximum value
>> (prefer new commands).
>> 
>>  Any preference of new commands over current ones looks like an io scheduler
> 
> I can see your point of view where you see it as preferring new cmds
> vs existing. It's probably due to my patch not hooking into commit_rqs
> and trying to figure out the batching exactly. It's more of a simple
> estimate.

Is it also about the classic "reads stall when all buffers are dirty" (reads to a fast device may time-out while writing to a slow device)?
There the solution was to limit the amount of dirty buffers, effectively leaving room for the other direction (i.e. read).
This is NOT about which SCSI commands are scheduled first; it's about lack of buffers causing a request to wait.

> 
> However, that's not what I'm talking about. I'm talking about the block
> layer / iosched has sent us these commands as a batch. We are now more
> likely to break that up.

Isn't the block-layer the correct place to "tune" that then?
E.g. Limiting "read_ahead_kb" (which can be rather large, depending on the filesystem)
Some storage systems "break up" large requests to smaller ones internally, causing an extra delay for such large requests, specifically if there is a bottleneck in the storage system.

So are we "tuning" at the right spot here?

> 
>> functionality, but on underlying layer, so to say a BUS layer.
>> I think is a matter of future investigation/development.

Regards,
Ulrich

