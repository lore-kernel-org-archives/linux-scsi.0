From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: Re: [PATCH v3 1/2] Ensure that the SCSI error handler gets woken up
Date: Wed, 6 Dec 2017 01:49:49 +0300
Message-ID: <5A27228D.1090705@virtuozzo.com>
References: <1512490788.2660.16.camel@wdc.com>
 <sr4inbsihn7krboba8euqqp1.1512508675214@email.android.com>
 <1512510365.2660.35.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-eopbgr20133.outbound.protection.outlook.com ([40.107.2.133]:18848
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752390AbdLEWvL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 5 Dec 2017 17:51:11 -0500
In-Reply-To: <1512510365.2660.35.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "stuart.w.hayes@gmail.com" <stuart.w.hayes@gmail.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "khorenko@virtuozzo.com" <khorenko@virtuozzo.com>

Hello, Bart!

On 12/06/2017 12:46 AM, Bart Van Assche wrote:
> On Wed, 2017-12-06 at 00:17 +0300, ptikhomirov wrote:
>> I mean threads in scsi_dec_host_busy() the part under rcu_read_lock are
>> divided into two groups: a) finished before call_rcu, b) beginning rcu
>> section after call_rcu. So first, in scsi_eh_inc_host_failed() we will
>> see all changes to host busy from group (a), second, all threads in group
>> (b) will see our change to host_failed. Either there is nobody in (b) and
>> we will start EH, or the thread from (b) which entered spin_lock last will
>> start EH.
>>
>> In your case tasks from b does not see host_failed was incremented, and
>> will not start EH.
>
> Hello Pavel,
>
> What does "your case" mean? In my previous e-mail I explained a scenario that
> cannot happen so it's not clear to me what "your case" refers to?

By "your case" I meant how your code works, especially that host_failed 
increment is inside scsi_eh_inc_host_failed() in your patch.

>
> Additionally, it seems like you are assuming that RCU guarantees ordering of
> RCU read-locked sections against call_rcu()?

Sorry.. Not "call_rcu" itself, In my previous reply I meant the delayed 
callback which actually triggers. (s/call_rcu/call_rcu's callback start/)

> That's not how RCU works. RCU
> guarantees serialization of read-locked sections against grace periods. The
> function scsi_eh_inc_host_failed() is invoked through call_rcu() and hence
> will be called during a grace period.

May be I missunderstand something, but I think that callback from 
call_rcu is guaranteed to _start_ after a grace period, but not to end 
before a next grace period. Other threads can enter rcu_read_lock 
protected critical regions while we are still in a callback and will run 
concurrently with callback.

>
> Anyway, the different scenarios I see are as follows:
> (a) scsi_dec_host_busy() finishes before scsi_eh_inc_host_failed() starts.
> (b) scsi_dec_host_busy() starts after scsi_eh_inc_host_failed() has
>      finished.

So I think in (b) scsi_dec_host_busy starts after 
scsi_eh_inc_host_failed has _started_.

>
> In case (a) scsi_eh_inc_host_failed() will wake up the error handler. And in
> case (b) scsi_dec_host_busy() will wake up the error handler. So it's not
> clear to me why you think that there is a scenario in which the EH won't be
> woken up?

So in case (b), in my understanding, scsi_dec_host_busy can skip wakeups 
as it does not see host_failed change yet.

>
> Bart.
>

To prove my point, some parts of kernel docs:

"This function invokes func(head) after a grace period has elapsed." 
Documentation/RCU/whatisRCU.txt

"
15.     The whole point of call_rcu(), synchronize_rcu(), and friends
         is to wait until all pre-existing readers have finished before
         carrying out some otherwise-destructive operation.
...
         Because these primitives only wait for pre-existing readers, it
         is the caller's responsibility to guarantee that any subsequent
         readers will execute safely.
"
Documentation/RCU/checklist.txt

There is nothing about "callback ends before next grace period".

Sorry, if I'm missing something.

Pavel.
