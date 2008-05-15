From: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: lockdep whine in 2.6.26-rc2-mm1
Date: Thu, 15 May 2008 13:50:30 +0800
Message-ID: <a8e1da0805142250o72049dc4o3cd4ceff7fe3e01b@mail.gmail.com>
References: <20080514000933.56adc131.akpm@linux-foundation.org>
	 <20080514155639.GB28594@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.184]:36186 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbYEOFuc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 May 2008 01:50:32 -0400
Received: by ti-out-0910.google.com with SMTP id b6so165988tic.23
        for <linux-scsi@vger.kernel.org>; Wed, 14 May 2008 22:50:31 -0700 (PDT)
In-Reply-To: <20080514155639.GB28594@kroah.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>

On Wed, May 14, 2008 at 11:56 PM, Greg KH <greg@kroah.com> wrote:
> On Wed, May 14, 2008 at 12:09:33AM -0700, Andrew Morton wrote:
>>
>> =============================================
>> [ INFO: possible recursive locking detected ]
>> 2.6.26-rc2-mm1 #15
>> ---------------------------------------------
>> modprobe/942 is trying to acquire lock:
>>  (&cls->mutex){--..}, at: [<ffffffff811b431e>] device_add+0x43d/0x57a
>>
>> but task is already holding lock:
>>  (&cls->mutex){--..}, at: [<ffffffff811b6787>] class_interface_register+0x48/0xbd
>>
>> other info that might help us debug this:
>> 1 lock held by modprobe/942:
>>  #0:  (&cls->mutex){--..}, at: [<ffffffff811b6787>] class_interface_register+0x48/0xbd
>>
>> stack backtrace:
>> Pid: 942, comm: modprobe Not tainted 2.6.26-rc2-mm1 #15
>>
>> Call Trace:
>>  [<ffffffff81056be1>] __lock_acquire+0x90d/0xc50
>>  [<ffffffff8100c50f>] ? restore_args+0x0/0x30
>>  [<ffffffff811b431e>] ? device_add+0x43d/0x57a
>>  [<ffffffff81057276>] lock_acquire+0x91/0xb7
>>  [<ffffffff811b431e>] ? device_add+0x43d/0x57a
>>  [<ffffffff812b23ab>] mutex_lock_nested+0xf2/0x278
>>  [<ffffffff811b431e>] ? device_add+0x43d/0x57a
>>  [<ffffffff812b3acd>] ? _spin_unlock+0x23/0x28
>>  [<ffffffff811b431e>] device_add+0x43d/0x57a
>>  [<ffffffff811b4471>] device_register+0x16/0x1b
>>  [<ffffffff811b4555>] device_create+0xdf/0x112
>>  [<ffffffff81055fdc>] ? trace_hardirqs_on+0xd/0xf
>>  [<ffffffff81055fdc>] ? trace_hardirqs_on+0xd/0xf
>>  [<ffffffff812b1fe1>] ? mutex_unlock+0x9/0xb
>>  [<ffffffff811b79b7>] ? kobj_map+0x113/0x124
>>  [<ffffffff810ac0f5>] ? exact_lock+0x0/0x14
>>  [<ffffffff810abd09>] ? exact_match+0x0/0x9
>>  [<ffffffffa00ec448>] :sg:sg_add+0x2a3/0x3bd
>>  [<ffffffff811b67b6>] class_interface_register+0x77/0xbd
>>  [<ffffffffa005d869>] :scsi_mod:scsi_register_interface+0x11/0x13
>>  [<ffffffffa00d50a3>] :sg:init_sg+0xa3/0x155
>>  [<ffffffff8105ea8f>] sys_init_module+0x1823/0x197a
>>  [<ffffffff810c45bc>] ? seq_release+0x0/0x56
>>  [<ffffffff8100bebb>] system_call_after_swapgs+0x7b/0x80
>
> I'm guessing that this is due to David's "change the semaphore to a
> mutex" patch that you have in your tree, but I refused to take as I was
> worried about just this issue :)
>
> David, any thoughts?

Yes, put them into -mm is right.
As matthew said, the class_interface_register call add_dev, then
device_add cause the issue.

Regards
dave
