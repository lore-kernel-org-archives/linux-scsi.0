From: David Miller <davem@davemloft.net>
Subject: Re: 3.4.0-02580-g72c04af regression on sparc64 - partitions not
 recognized
Date: Wed, 23 May 2012 14:04:51 -0400 (EDT)
Message-ID: <20120523.140451.386112705611304887.davem@davemloft.net>
References: <alpine.SOC.1.00.1205221200050.9585@math.ut.ee>
	<20120522.151217.278388169416093561.davem@davemloft.net>
	<alpine.SOC.1.00.1205231945480.12326@math.ut.ee>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.SOC.1.00.1205231945480.12326@math.ut.ee>
Sender: linux-kernel-owner@vger.kernel.org
To: mroos@linux.ee
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dan.j.williams@intel.com, stern@rowland.harvard.edu, JBottomley@Parallels.com
List-Id: linux-scsi@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Wed, 23 May 2012 19:46:46 +0300 (EEST)

CC:'ing interested parties.

>> > Just tested 3.4.0-02580-g72c04af on about 10 machines. While most of 
>> > them work (including 3 different sparc64 machines with real scsi disks), 
>> > Sun Netra X1 with pata_ali and IDE disk consistently fails to boot. sda 
>> > is recognized but no partitions. 3.3.0 works fine, as did something 
>> > around 3.4-rc7 (plain 3.4 not tested yet). No other IDE machines tested 
>> > yet since I have none with remote console at the moment.
>> 
>> If 3.4.0-final is OK, start bisecting from v3.4.0 until 72c04af.  One
>> possibility could be the sparc64 NOBOOTMEM conversion that went into
>> the merge window.
> 
> Bisecting leads to this commit:
> 
> a7a20d103994fd760766e6c9d494daa569cbfe06 is the first bad commit
> commit a7a20d103994fd760766e6c9d494daa569cbfe06
> Author: Dan Williams <dan.j.williams@intel.com>
> Date:   Thu Mar 22 17:05:11 2012 -0700
> 
>     [SCSI] sd: limit the scope of the async probe domain
>     
>     sd injects and synchronizes probe work on the global kernel-wide domain.
>     This runs into conflict with PM that wants to perform resume actions in
>     async context:
>     
>     [  494.237079] INFO: task kworker/u:3:554 blocked for more than 120 seconds.
>     [  494.294396] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>     [  494.360809] kworker/u:3     D 0000000000000000     0   554      2 0x00000000
>     [  494.420739]  ffff88012e4d3af0 0000000000000046 ffff88013200c160 ffff88012e4d3fd8
>     [  494.484392]  ffff88012e4d3fd8 0000000000012500 ffff8801394ea0b0 ffff88013200c160
>     [  494.548038]  ffff88012e4d3ae0 00000000000001e3 ffffffff81a249e0 ffff8801321c5398
>     [  494.611685] Call Trace:
>     [  494.632649]  [<ffffffff8149dd25>] schedule+0x5a/0x5c
>     [  494.674687]  [<ffffffff8104b968>] async_synchronize_cookie_domain+0xb6/0x112
>     [  494.734177]  [<ffffffff810461ff>] ? __init_waitqueue_head+0x50/0x50
>     [  494.787134]  [<ffffffff8131a224>] ? scsi_remove_target+0x48/0x48
>     [  494.837900]  [<ffffffff8104b9d9>] async_synchronize_cookie+0x15/0x17
>     [  494.891567]  [<ffffffff8104ba49>] async_synchronize_full+0x54/0x70  <-- here we wait for async contexts to complete
>     [  494.943783]  [<ffffffff8104b9f5>] ? async_synchronize_full_domain+0x1a/0x1a
>     [  495.002547]  [<ffffffffa00114b1>] sd_remove+0x2c/0xa2 [sd_mod]
>     [  495.051861]  [<ffffffff812fe94f>] __device_release_driver+0x86/0xcf
>     [  495.104807]  [<ffffffff812fe9bd>] device_release_driver+0x25/0x32  <-- here we take device_lock()
>     
>     [  853.511341] INFO: task kworker/u:4:549 blocked for more than 120 seconds.
>     [  853.568693] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>     [  853.635119] kworker/u:4     D ffff88013097b5d0     0   549      2 0x00000000
>     [  853.695129]  ffff880132773c40 0000000000000046 ffff880130790000 ffff880132773fd8
>     [  853.758990]  ffff880132773fd8 0000000000012500 ffff88013288a0b0 ffff880130790000
>     [  853.822796]  0000000000000246 0000000000000040 ffff88013097b5c8 ffff880130790000
>     [  853.886633] Call Trace:
>     [  853.907631]  [<ffffffff8149dd25>] schedule+0x5a/0x5c
>     [  853.949670]  [<ffffffff8149cc44>] __mutex_lock_common+0x220/0x351
>     [  854.001225]  [<ffffffff81304bd7>] ? device_resume+0x58/0x1c4
>     [  854.049082]  [<ffffffff81304bd7>] ? device_resume+0x58/0x1c4
>     [  854.097011]  [<ffffffff8149ce48>] mutex_lock_nested+0x2f/0x36   <-- here we wait for device_lock()
>     [  854.145591]  [<ffffffff81304bd7>] device_resume+0x58/0x1c4
>     [  854.192066]  [<ffffffff81304d61>] async_resume+0x1e/0x45
>     [  854.237019]  [<ffffffff8104bc93>] async_run_entry_fn+0xc6/0x173  <-- ...while running in async context
>     
>     Provide a 'scsi_sd_probe_domain' so that async probe actions actions can
>     be flushed without regard for the state of PM, and allow for the resume
>     path to handle devices that have transitioned from SDEV_QUIESCE to
>     SDEV_DEL prior to resume.
>     
>     Acked-by: Alan Stern <stern@rowland.harvard.edu>
>     [alan: uplevel scsi_sd_probe_domain, clarify scsi_device_resume]
>     Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>     [jejb: remove unneeded config guards in include file]
>     Signed-off-by: James Bottomley <JBottomley@Parallels.com>
> 
> :040000 040000 4e59ccb852f261f97701a245e637a690dfce9d20 fc73ca0da1288a7f30b81a8593ddad2146d7bfb5 M      drivers
> 
> -- 
> Meelis Roos (mroos@linux.ee)
