From: "K.Tanaka" <k-tanaka@ce.jp.nec.com>
Subject: Re: [BUG] The kernel thread for md RAID1 could cause a md RAID1 array
 deadlock
Date: Thu, 24 Jan 2008 18:32:39 +0900
Message-ID: <47985B37.9000503@ce.jp.nec.com>
References: <478C240F.8070004@ce.jp.nec.com> <18328.1473.26122.647283@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:58939 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbYAXJ33 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jan 2008 04:29:29 -0500
In-Reply-To: <18328.1473.26122.647283@notabene.brown>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com

Hi,

Thank you for the patch.
I have applied the patch to 2.6.23.14 and it works well.

- In case of 2.6.23.14, the problem is reproduced.
- In case of 2.6.23.14 with this patch, raid1 works well so far.
  The fault injection script continues to run, and it doesn't deadlock.
  I will keep it running for a while.

Also, md raid10 seems to have the same problem.
I will test raid10 applying this patch as well.


Neil Brown wrote:
> On Tuesday January 15, k-tanaka@ce.jp.nec.com wrote:
>> This message describes the details about md-RAID1 issue found by
>> testing the md RAID1 using the SCSI fault injection framework.
>>
>> Abstract:
>> Both the error handler for md RAID1 and write access request to the md RAID1
>> use raid1d kernel thread. The nr_pending flag could cause a race condition
>> in raid1d, results in a raid1d deadlock.
> 
> Thanks for finding and reporting this.
> 
> I believe the following patch should fix the deadlock.
> 
> If you are able to repeat your test and confirm this I would
> appreciate it.
> 
> Thanks,
> NeilBrown
> 
> 
> 
> Fix deadlock in md/raid1 when handling a read error.
> 
> When handling a read error, we freeze the array to stop any other
> IO while attempting to over-write with correct data.
> 
> This is done in the raid1d thread and must wait for all submitted IO
> to complete (except for requests that failed and are sitting in the
> retry queue - these are counted in ->nr_queue and will stay there during
> a freeze).
> 
> However write requests need attention from raid1d as bitmap updates
> might be required.  This can cause a deadlock as raid1 is waiting for
> requests to finish that themselves need attention from raid1d.
> 
> So we create a new function 'flush_pending_writes' to give that attention,
> and call it in freeze_array to be sure that we aren't waiting on raid1d.
> 
> Thanks to "K.Tanaka" <k-tanaka@ce.jp.nec.com> for finding and reporting
> this problem.
> 
> Cc: "K.Tanaka" <k-tanaka@ce.jp.nec.com>
> Signed-off-by: Neil Brown <neilb@suse.de>
> 
-- 
---------------------------------------------------------
Kenichi TANAKA    | Open Source Software Platform Development Division
                  | Computers Software Operations Unit, NEC Corporation
                  | k-tanaka@ce.jp.nec.com
