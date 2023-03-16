Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3377C7618A
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Mar 2023 10:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjCPKjg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Mar 2023 06:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCPKje (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Mar 2023 06:39:34 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A8EB1ED0;
        Thu, 16 Mar 2023 03:39:32 -0700 (PDT)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id EE3E7341AFC;
        Thu, 16 Mar 2023 13:39:29 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-type:content-type:date:from:from:in-reply-to
        :message-id:mime-version:references:reply-to:subject:subject:to
        :to; s=mta-01; bh=uoPXoxgv7pdfluieV38/oH1Yaljzc/bpox2WJrZFOpE=; b=
        M4CbqN1+z8ejh1WOfbaGn8D5KyJ58MfjENRX/QVkYrNyjxZF7O850CqnNLy3p0GC
        as/IKzJx7Q1eZfLGWbPCmvQdUVkRHSYcfh+lgQJmgLOOqVkhb+Uwv6jjBfCoNfie
        eb962oCZu7Gm2hMYoU9cONHF2HOt3lKl+/ug2zuWaTo=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id E2A4C341ACF;
        Thu, 16 Mar 2023 13:39:29 +0300 (MSK)
Received: from yadro.com (10.199.20.11) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Thu, 16 Mar
 2023 13:39:29 +0300
Date:   Thu, 16 Mar 2023 13:39:29 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     <mlombard@redhat.com>, <martin.petersen@oracle.com>,
        <mgurtovoy@nvidia.com>, <sagi@grimberg.me>,
        <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
Subject: Re: [PATCH 13/18] scsi: target: Fix multiple LUN_RESET handling
Message-ID: <20230316103929.GG1031@yadro.com>
References: <20230309223312.94595-1-michael.christie@oracle.com>
 <20230309223312.94595-14-michael.christie@oracle.com>
 <20230315161301.GE1031@yadro.com>
 <50afe378-c0e8-7914-377e-ae8c91f82455@oracle.com>
 <20230315191141.GF1031@yadro.com>
 <5a1c2ac4-d7cd-b7fe-cc74-7e58e8fca968@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5a1c2ac4-d7cd-b7fe-cc74-7e58e8fca968@oracle.com>
X-Originating-IP: [10.199.20.11]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 15, 2023 at 04:42:19PM -0500, Mike Christie wrote:
> 
> On 3/15/23 2:11 PM, Dmitry Bogdanov wrote:
> > On Wed, Mar 15, 2023 at 11:44:48AM -0500, Mike Christie wrote:
> >>
> >> On 3/15/23 11:13 AM, Dmitry Bogdanov wrote:
> >>> On Thu, Mar 09, 2023 at 04:33:07PM -0600, Mike Christie wrote:
> >>>>
> >>>> This fixes a bug where an initiator thinks a LUN_RESET has cleaned
> >>>> up running commands when it hasn't. The bug was added in:
> >>>>
> >>>> commit 51ec502a3266 ("target: Delete tmr from list before processing")
> >>>>
> >>>> The problem occurs when:
> >>>>
> >>>> 1. We have N IO cmds running in the target layer spread over 2 sessions.
> >>>> 2. The initiator sends a LUN_RESET for each session.
> >>>> 3. session1's LUN_RESET loops over all the running commands from both
> >>>> sessions and moves them to its local drain_task_list.
> >>>> 4. session2's LUN_RESET does not see the LUN_RESET from session1 because
> >>>> the commit above has it remove itself. session2 also does not see any
> >>>> commands since the other reset moved them off the state lists.
> >>>> 5. sessions2's LUN_RESET will then complete with a successful response.
> >>>> 6. sessions2's inititor believes the running commands on its session are
> >>>> now cleaned up due to the successful response and cleans up the running
> >>>> commands from its side. It then restarts them.
> >>>> 7. The commands do eventually complete on the backend and the target
> >>>> starts to return aborted task statuses for them. The initiator will
> >>>> either throw a invalid ITT error or might accidentally lookup a new task
> >>>> if the ITT has been reallocated already.
> >>>>
> >>>> This fixes the bug by reverting the patch, and also serializes the
> >>>> execution of LUN_RESETs and Preempt and Aborts. The latter is necessary
> >>>> because it turns out the commit accidentally fixed a bug where if there
> >>>> are 2 LUN RESETs executing they can see each other on the dev_tmr_list,
> >>>> put the other one on their local drain list, then end up waiting on each
> >>>> other resulting in a deadlock.
> >>>
> >>> If LUN_RESET is not in TMR list anymore there is no need to serialize
> >>> core_tmr_drain_tmr_list.
> >>
> >> Ah shoot yeah I miswrote that. I meant I needed the serialization for my
> >> bug not yours.
> >
> > I still did not get why you wrapping core_tmr_drain_*_list by mutex.
> > general_tmr_list have only aborts now and they do not wait for other aborts.
> 
> Do you mean I don't need the mutex for the bug I originally hit that's described
> at the beginning? If your saying I don't need it for 2 resets running at the same
> time, I agree. I thought I needed it if we have a RESET and Preempt and Abort:
> 
> 1. You have 2 sessions. There are no TMRs initially.
> 2. session1 gets Preempt and Abort. It calls core_tmr_drain_state_list
> and takes all the cmds from both sessions and puts them on the local
> drain_task_list list.
> 3. session1 or 2 gets a LUN_RESET, it sees no cmds on the device's
> state_lists, and returns success.
> 4. The initiator thinks the commands were cleaned up by the LUN_RESET.
> 
> - It could end up re-using the ITT while the original task being cleaned up is
> still running. Then depending on which session got what and if TAS was set, if
> the original command completes first then the initiator would think the second
> command failed with SAM_STAT_TASK_ABORTED.
> 
> - If there was no TAS or the RESET and Preempt and Abort were on the same session
> then when we could still hit a bug. We get the RESET response, the initiator might
> retry the cmds or fail and the app might retry. The retry might go down a completely
> different path on the target (like if hw queue1 was blocked and had the original
> command, but this retry goes down hw queue2 due to being received on a different
> CPU, so it completes right away). We do some new IO. Then hw queue1 unblocks and
> overwrites the new IO.
> 
> With the mutex, the LUN_RESET will wait for the Preempt and Abort
> which is waiting on the running commands. I could have had Preempt
> and Abort create a tmr, and queue a work and go through that path
> but I thought it looked uglier faking it.

Thank you for explanation. But I think you a not right here.
Preempt And Abort is used to change the reservation holder and abort
preempted session's commands. A preempted session is not allowed to send
any new messages, they will be failed anyway.
So we are safe here. Or did I miss something?

> >>
> >>>>
> >>>>         if (cmd->transport_state & CMD_T_ABORTED)
> >>>> @@ -3596,6 +3597,22 @@ static void target_tmr_work(struct work_struct *work)
> >>>>                         target_dev_ua_allocate(dev, 0x29,
> >>>>                                                ASCQ_29H_BUS_DEVICE_RESET_FUNCTION_OCCURRED);
> >>>>                 }
> >>>> +
> >>>> +               /*
> >>>> +                * If this is the last reset the device can be freed after we
> >>>> +                * run transport_cmd_check_stop_to_fabric. Figure out if there
> >>>> +                * are other resets that need to be scheduled while we know we
> >>>> +                * have a refcount on the device.
> >>>> +                */
> >>>> +               spin_lock_irq(&dev->se_tmr_lock);
> >>>
> >>> tmr->tmr_list is removed from the list in the very end of se_cmd lifecycle
> >>> so any number of LUN_RESETs can be in lun_reset_tmr_list. And all of them
> >>> can be finished but not yet removed from the list.
> >>
> >> Don't we remove it from the list a little later in this function when
> >> we call transport_lun_remove_cmd?
> >
> > OMG, yes, of course, you a right. I messed up something.
> >
> > But I have concerns still:
> > transport_lookup_tmr_lun (where LUN_RESET is added to the list) and
> > transport_generic_handle_tmr(where LUN_RESET is scheduled to handle)
> > are not serialized. And below you can start the second LUN_RESET while
> > transport_generic_handle_tmr is not yet called for it. The _handle_tmr
> > could be delayed for a such time that is enough to handle that second
> > LUN_RESET and to clear the flag. _handle_tmr will then start the work
> > again.
> 
> Ah yeah, nice catch.
> 
> >
> > Is it worth doing that list management? Is it not enough just wrap
> > calling core_tmr_lun_reset() in target_tmr_work by a mutex?
> 
> I can just do the mutex.
> 
> Was trying to reduce how many threads we use, but the big win is for aborts.
> Will work on that type of thing in a separate patchset.

Considering that (if) I am right with PreemptAndAbort,
to address multiple LUN_RESET issue it's enough to wrap
core_tmr_lun_reset and skip all LUN_RESETs in target_drain_tmr_list.
Without any new lists. That would be as simple patch as possible. 

> 
> > Better to have a separarte variable used only under lock.
> >
> Will fix.
> 
> 

