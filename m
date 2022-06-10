Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A61FCC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jun 2022 06:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243041AbiFJGKo convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jun 2022 02:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346406AbiFJGKm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jun 2022 02:10:42 -0400
Received: from mx4.uni-regensburg.de (mx4.uni-regensburg.de [IPv6:2001:638:a05:137:165:0:4:4e7a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED15C5FF2A
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jun 2022 23:10:35 -0700 (PDT)
Received: from mx4.uni-regensburg.de (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id C9015600005B
        for <linux-scsi@vger.kernel.org>; Fri, 10 Jun 2022 08:10:33 +0200 (CEST)
Received: from gwsmtp.uni-regensburg.de (gwsmtp1.uni-regensburg.de [132.199.5.51])
        by mx4.uni-regensburg.de (Postfix) with ESMTP id B6E106000059
        for <linux-scsi@vger.kernel.org>; Fri, 10 Jun 2022 08:10:30 +0200 (CEST)
Received: from uni-regensburg-smtp1-MTA by gwsmtp.uni-regensburg.de
        with Novell_GroupWise; Fri, 10 Jun 2022 08:10:31 +0200
Message-Id: <62A2E054020000A10004ACA8@gwsmtp.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 18.4.0 
Date:   Fri, 10 Jun 2022 08:10:28 +0200
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
 <ffc1f4910d2b414c93dfa5d331436a53@yadro.com>
 <d3277470-9ef0-9a1a-974d-e80250bd35ac@oracle.com>
In-Reply-To: <d3277470-9ef0-9a1a-974d-e80250bd35ac@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi!

In my primitive point of view iSCSI is just "another type of cable", making me wonder:
Is iSCSI allowed to reorder the requests at all? Shouldn't the block layer or initiator do so, or the target doing out-of order processing (tagged queueing)?

I mean: If there is a problem that occurs even without using iSCSI, should iSCSI try to fix it?

Regards,
Ulrich

>>> Mike Christie <michael.christie@oracle.com> schrieb am 09.06.2022 um 22:58 in
Nachricht <d3277470-9ef0-9a1a-974d-e80250bd35ac@oracle.com>:
> On 6/9/22 4:02 AM, Dmitriy Bogdanov wrote:
>> Hi Mike,
>> 
>>>> On 6/8/22 9:16 AM, Dmitriy Bogdanov wrote:
>>>>> On 6/7/22 10:55 AM, Mike Christie wrote:
>>>>>> On 6/7/22 8:19 AM, Dmitry Bogdanov wrote:
>>>>>>> In function iscsi_data_xmit (TX worker) there is walking through the
>>>>>>> queue of new SCSI commands that is replenished in parallell. And only
>>>>>>> after that queue got emptied the function will start sending pending
>>>>>>> DataOut PDUs. That lead to DataOut timer time out on target side and
>>>>>>> to connection reinstatment.
>>>>>>>
>>>>>>> This patch swaps walking through the new commands queue and the pending
>>>>>>> DataOut queue. To make a preference to ongoing commands over new ones.
>>>>>>>
>>>>>>
>>>>>> ...
>>>>>>
>>>>>>>              task = list_entry(conn->cmdqueue.next, struct iscsi_task,
>>>>>>> @@ -1594,28 +1616,10 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>>>>>>>               */
>>>>>>>              if (!list_empty(&conn->mgmtqueue))
>>>>>>>                      goto check_mgmt;
>>>>>>> +            if (!list_empty(&conn->requeue))
>>>>>>> +                    goto check_requeue;
>>>>>>
>>>>>>
>>>>>>
>>>>>> Hey, I've been posting a similar patch:
>>>>>>
>>>>>> 
> https://urldefense.com/v3/__https://www.spinics.net/lists/linux-scsi/msg15693 
> 9.html__;!!ACWV5N9M2RV99hQ!LHLghPLuyBZadpsGme03-HBoowa8sNiZYMKxKoz5E_BNu-M9-B
> iuNV_JS9kFxhnumNfhrxuR7qVdIaOH5X7iTfMO$
>>>>>>
>>>>>> A problem I hit is a possible pref regression so I tried to allow
>>>>>> us to start up a burst of cmds in parallel. It's pretty simple where
>>>>>> we allow up to a queue's worth of cmds to start. It doesn't try to
>>>>>> check that all cmds are from the same queue or anything fancy to try
>>>>>> and keep the code simple. Mostly just assuming users might try to bunch
>>>>>> cmds together during submission or they might hit the queue plugging
>>>>>> code.
>>>>>>
>>>>>> What do you think?
>>>>>
>>>>> Oh yeah, what about a modparam batch_limit? It's between 0 and cmd_per_lun.
>>>>> 0 would check after every transmission like above.
>>>>
>>>>  Did you really face with a perf regression? I could not imagine how it is
>>>> possible.
>>>> DataOut PDU contains a data too, so a throughput performance cannot be
>>>> decreased by sending DataOut PDUs.
>>>
>>>
>>> We can agree that queue plugging and batching improves throughput right?
>>> The app or block layer may try to batch commands. It could be with something
>>> like fio's batch args or you hit the block layer queue plugging.
>> 
>> I agree that those features 100% gives an improvement of a throughput on 
> local
>> devices on serial interfaces like SATA1. Since SATA2 (Native Command 
> Queuing)
>> devices can reorder incoming commmands to provide the best thoughput.
>> SCSI I guess has similar feature from the very beginning.
>> But on remote devices (iSCSI and FC) it is not 100% - initiators's command
>> order may be reordered by the network protocol nature itself. I mean 1PDU vs
>> R2T+DataOut PDUs, PDU resending due to crc errors or something like that.
> I think we are talking about slightly different things. You are coming up 
> with
> different possible scenarios where it doesn't work. I get them. You are 
> correct
> for those cases. I'm not talking about those cases. I'm talking about the 
> specific
> case I described.
> 
> I'm saying we have targets where we use backends that get improved 
> performance
> when they get batched cmds. When the network is ok, and the user's app is
> batching cmds, they come from the app down to the target's backend device as
> a batch. My concern is that with your patch we will no longer get that 
> behavior.
> 
> The reason is that the target and initiator can do:
> 
> 1. initiator sends scsi cmd pdu1
> 2. target sends R2T
> 3. initiator sees R2T and hits the goto. Sends data
> 4. target reads in data. Sends cmd to block layer.
> 5. initiator sends scsi cmd pdu2
> 6. target sends R2T
> 7. initiator reads in R2T sends data.
> 8. target reads in data and sends cmd to block layer.
> 
> The problem here could be between 4 and 8 the block layer has run the queue
> and sent that one cmd to the real device already because we have that extra
> delay now. So when I implemented the fix in the same way as you and I run
> iostat I would see lower aqu-sz for example.
> 
> With the current code we might not have that extra delay between 4 - 8 so
> I would see:
> 
> 1. initiator sends scsi cmd pdu1
> 2. initiator sends scsi cmd pdu2
> 3. initiator sends scsi cmd pdu3
> 4. target reads in all those cmd pdus
> 5. target sends R2Ts for each cmd.
> 6. initiator reads in all the R2Ts
> 7. initiator sends data for cmd 1 - 3.
> 8. target reads in data and sends cmd1 to block layer
> 9. target reads in data and sends cmd2 to block layer
> 10. target reads in data and sends cmd3 to block layer
> 11. block layer/iosched hits unplug limit and then sends
> those cmds to the real device.
> 
> In this case the time between 8 - 9 is small since we are just reading
> from the socket, building structs and passing the cmds down to the block
> layer. Here when I'm watching the backend device with iostat I see higher
> qu-sz values.
> 
> Note that you might not be seeing this with LIO for example because we
> plug/unplug on every cmd.
> 
> When the network is congested, the lun is shared, we are doing retries,
> machine gets bogged donw, etc then yeah, we might not get the above 
> behavior.
> The user knows this is and it's expected. It's not expected that they just
> update the kernel and they get a perf drop in the normal case.
> 
> How do we not give these users a regression while fixing the bug?
> 
>> 
>>> With the current code we can end up sending all cmds to the target in a way
>>> the target can send them to the real device batched. For example, we send 
> off
>>> the initial N scsi command PDUs in one run of iscsi_data_xmit. The target 
> reads
>>> them in, and sends off N R2Ts. We are able to read N R2Ts in the same call.
>>> And again we are able to send the needed data for them in one call of
>>> iscsi_data_xmit. The target is able to read in the data and send off the
>>> WRITEs to the physical device in a batch.
>>>
>>> With your patch, we can end up not batching them like the app/block layer
>>> intended. For example, we now call iscsi_data_xmit and in the cmdqueue loop.
>>> We've sent N - M scsi cmd PDUs, then see that we've got an incoming R2T to
>>> handle. So we goto check_requeue. We send the needed data. The target then
>>> starts to send the cmd to the physical device. If we have read in multiple
>>> R2Ts then we will continue the requeue loop. And so we might be able to send
>>> the data fast enough that the target can then send those commands to the
>>> physical device. But we've now broken up the batching the upper layers sent
>>> to us and we were doing before.
>> 
>> In my head everything is vice-versa :)
> 
> :)
> 
>> Current code breaks a batching by sending new commands instead of completing
>> the transmission of current commands that could be in its own batch.
> 
> We are not talking about the same thing. I'm talking about specifically what
> a user would do today to boost perf for their app where they have a single 
> app
> using the LUN. Single LUN per session. App uses something like fio's batch
> args. You have it send down 32 cmds. When those complete, it sends down 32 
> again.
> We are not getting a constant stream or mix of cmds from different sources.
> 
> We are not talking about multiple users using the same LUN or even same 
> session.
> 
> 
>> With my patch the batches will be received (in best effort manner) on target
>> port in the same order as block layer sends to iSCSI layer. BTW, another 
> target> ports may receive other commands in meantime and the real device will 
> receive
>> broken batch anyway. The initiator side cannot guarantee batching on the 
> real
>> device.
> 
> The user does this. The user has set things up so they are using the device 
> for
> their one app. The app is sending down these commands as a batch. No other 
> initiators are using the device.
> 
> It's *not* say a shared LUN example like we have N VMs on a LUN all doing 
> their
> own IO. The user does not expect the same perf for that type of case we they 
> do
> when they have specifically tuned their app and device use like I mention.
> 
>> 
>> Lets imagine, that block layer submits two batches of big commands and then
>> submits single small commands, the command queue will be 
> 
> That's not what I'm talking about. We are not getting a mix like this.
> 
> 
>> "ABCD EFGH" + "S" + "S" + "S" + "S" 
>> and that what will be sent out:
>> current code (worst case):    A1B1C1D1 E1F1G1H1 A2 S B2 S C2D2 E2 S F2 S 
> G2H2 (breaks batch)
>> current code (best case):     A1B1C1D1 E1F1G1H1 SSSS A2B2C2D2 E2F2G2H2 
> (reorder)
>> current code (bug addressed): A1B1C1D1 E1F1G1H1 SS...S (connection fail)
>> current code (!impossible):   A1B1C1D1 E1F1G1H1 A2B2C2D2 E2F2G2H2 SSSS 
> (inorder)
>> with my patch (best case):    A1B1C1D1 E1F1G1H1 A2B2C2D2 E2F2G2H2 SSSS 
> (inorder)
>> with my patch (your case):    A1B1C1D1 E1 A2 F1 B2 G1H1 C2 E2 D2 F2G2H2 SSSS 
> (still inorder)
>> with my patch (worst case):   A1B1C1D1 E1F1G1H1 A2 S B2 S C2D2 E2 S F2 S 
> G2H2 (breaks batch)
>> 
>> My better best case (command order as block layer submits) will never happen 
> in
>> the current code.
>> If "S" comes in parrallel, the worst cases are the same, both may break a 
> batch
>> by new commands. But if "S" are already in the queue, my patch will produce
>> (most likely) the best case instead of the worst case.
>> 
>> 
>>>>  The only thing is a latency performance. But that is not an easy question.
>>>
>>> Agree latency is important and that's why I was saying we can make it config
>>> option. Users can continue to try and batch their cmds and we don't break
>>> them. We also fix the bug in that we don't get stuck in the cmdqueue loop
>>> always taking in new cmds.
>> 
>>>> IMHO, a system should strive to reduce a maximum value of the latency almost
>>>> without impacting of a minimum value (prefer current commands) instead of
>>>> to reduce a minimum value of the latency to the detriment of maximum value
>>>> (prefer new commands).
>>>>
>>>>  Any preference of new commands over current ones looks like an io scheduler
>>>
>>> I can see your point of view where you see it as preferring new cmds
>>> vs existing. It's probably due to my patch not hooking into commit_rqs
>>> and trying to figure out the batching exactly. It's more of a simple
>>> estimate.
>>>
>>> However, that's not what I'm talking about. I'm talking about the block
>>> layer / iosched has sent us these commands as a batch. We are now more
>>> likely to break that up.
>> 
>> No, my patch does not break a batching more than current code, instead it
>> decreases the probability of a break the currently sending batch by trying 
> to
>> transmit in the same order as they come from block layer.
>> 
>> It's very complicated question - how to schedule "new vs old" commands. It's
>> not just a counter. Even with a counter there are a lot of questions - 
> should
>> it begin from the cmdqueue loop or from iscsi_data_xmit, why it has static
>> limit, per LUN or not, and so on and so on.
> 
> What about a compromise? Instead of doing while (!list_empty). We switch it
> to list_for_each and move the requeue handling to infront of the cmdqueue
> handling.
> 
> We will know that the cmds on the cmdqueue at the time iscsi_data_xmit is 
> run
> were sent to us from the block layer at the same time so I get what I need. 
> The
> bug is fixed.
> 
> 
>> That is a new IO scheduler on bus layer. 
>> 
>>>> I think is a matter of future investigation/development.
>> I am not against of it at all. But it should not delay a simple bugfix 
> patch.
>> 
>> BR,
>>  Dmitry
>> 
> 
> -- 
> You received this message because you are subscribed to the Google Groups 
> "open-iscsi" group.
> To unsubscribe from this group and stop receiving emails from it, send an 
> email to open-iscsi+unsubscribe@googlegroups.com.
> To view this discussion on the web visit 
> https://groups.google.com/d/msgid/open-iscsi/d3277470-9ef0-9a1a-974d-e80250bd 
> 35ac%40oracle.com.



