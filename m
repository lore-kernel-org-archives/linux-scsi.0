Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B87BC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jun 2022 05:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379711AbiFQFy3 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jun 2022 01:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiFQFy2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jun 2022 01:54:28 -0400
Received: from mx2.uni-regensburg.de (mx2.uni-regensburg.de [IPv6:2001:638:a05:137:165:0:3:bdf8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1105B66CB3
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2022 22:54:25 -0700 (PDT)
Received: from mx2.uni-regensburg.de (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id 63AFA6000057
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jun 2022 07:54:22 +0200 (CEST)
Received: from gwsmtp.uni-regensburg.de (gwsmtp1.uni-regensburg.de [132.199.5.51])
        by mx2.uni-regensburg.de (Postfix) with ESMTP id 418AE6000050
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jun 2022 07:54:22 +0200 (CEST)
Received: from uni-regensburg-smtp1-MTA by gwsmtp.uni-regensburg.de
        with Novell_GroupWise; Fri, 17 Jun 2022 07:54:22 +0200
Message-Id: <62AC170C020000A10004B106@gwsmtp.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 18.4.0 
Date:   Fri, 17 Jun 2022 07:54:20 +0200
From:   "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To:     "open-iscsi" <open-iscsi@googlegroups.com>
Cc:     "Chris Leech" <cleech@redhat.com>, "Lee Duncan" <lduncan@suse.com>,
        <linux-scsi@vger.kernel.org>, <d.bogdanov@yadro.com>,
        <k.shelekhin@yadro.com>, <linux@yadro.com>
Subject: Antw: [EXT] Re: [PATCH] scsi: iscsi: prefer xmit of DataOut
 before new cmd
References: <20220607131953.11584-1-d.bogdanov@yadro.com>
 <237bed01-819a-55be-5163-274fac3b61e6@oracle.com>
 <CAFU8FUgwMX_d85OG+qC+qTX-NpFiSVkwBtradzAmeJW-3PCmEQ@mail.gmail.com>
In-Reply-To: <CAFU8FUgwMX_d85OG+qC+qTX-NpFiSVkwBtradzAmeJW-3PCmEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>> Adam Hutchinson <ajhutchin@gmail.com> schrieb am 15.06.2022 um 20:57 in
Nachricht
<CAFU8FUgwMX_d85OG+qC+qTX-NpFiSVkwBtradzAmeJW-3PCmEQ@mail.gmail.com>:
> Is there any reason not to use time as an indicator that pending R2Ts
> need to be processed?  Could R2Ts be tagged with a timestamp when
> received and only given priority over new commands if the age of the
> R2T at the head exceeds some configurable limit? This would guarantee
> R2T will eventually be serviced even if the block layer doesn't reduce
> the submission rate of new commands, it wouldn't remove the
> performance benefits of the current algorithm which gives priority to
> new commands and it would be a relatively simple solution.  A
> threshold of 0 could indicate that R2Ts should always be given
> priority over new commands. Just a thought..

I had similar thought comparing SCSI command scheduling with process scheduling
real-time scheduling can cause starvation when newer requests are postponed indefinitely,
while the classic scheduler increases the chance of longer-waiting tasks to be scheduled next.
In any case that would require some sorting of the queue (or searching for a maximum/minimum in the requests which is equivalent).

Regards,
Ulrich


> 
> Regards,
> Adam
> 
> On Wed, Jun 15, 2022 at 11:37 AM Mike Christie
> <michael.christie@oracle.com> wrote:
>>
>> On 6/7/22 8:19 AM, Dmitry Bogdanov wrote:
>> > In function iscsi_data_xmit (TX worker) there is walking through the
>> > queue of new SCSI commands that is replenished in parallell. And only
>> > after that queue got emptied the function will start sending pending
>> > DataOut PDUs. That lead to DataOut timer time out on target side and
>> > to connection reinstatment.
>> >
>> > This patch swaps walking through the new commands queue and the pending
>> > DataOut queue. To make a preference to ongoing commands over new ones.
>> >
>> > Reviewed-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
>> > Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
>>
>> Let's do this patch. I've tried so many combos of implementations and
>> they all have different perf gains or losses with different workloads.
>> I've already been going back and forth with myself for over a year
>> (the link for my patch in the other mail was version N) and I don't
>> think a common solution is going to happen.
>>
>> You patch fixes the bug, and I've found a workaround for my issue
>> where I tweak the queue depth, so I think we will be ok.
>>
>> Reviewed-by: Mike Christie <michael.christie@oracle.com>
>>
>> --
>> You received this message because you are subscribed to the Google Groups 
> "open-iscsi" group.
>> To unsubscribe from this group and stop receiving emails from it, send an 
> email to open-iscsi+unsubscribe@googlegroups.com.
>> To view this discussion on the web visit 
> https://groups.google.com/d/msgid/open-iscsi/237bed01-819a-55be-5163-274fac3b 
> 61e6%40oracle.com.
> 
> 
> 
> -- 
> "Things turn out best for the people who make the best out of the way
> things turn out." - Art Linkletter
> 
> -- 
> You received this message because you are subscribed to the Google Groups 
> "open-iscsi" group.
> To unsubscribe from this group and stop receiving emails from it, send an 
> email to open-iscsi+unsubscribe@googlegroups.com.
> To view this discussion on the web visit 
> https://groups.google.com/d/msgid/open-iscsi/CAFU8FUgwMX_d85OG%2BqC%2BqTX-NpF 
> iSVkwBtradzAmeJW-3PCmEQ%40mail.gmail.com.




