From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: sgpool-8 double free
Date: Sun, 19 Feb 2006 23:58:15 +0100
Message-ID: <43F8F807.30605@s5r6.in-berlin.de>
References: <20060219202923.GF32492@redhat.com> <1140386164.4559.0.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:62394 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751124AbWBSW7B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Feb 2006 17:59:01 -0500
In-Reply-To: <1140386164.4559.0.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org, bcollins@debian.org

James Bottomley wrote:
> On Sun, 2006-02-19 at 15:29 -0500, Dave Jones wrote:
> 
>>Feb 18 22:30:18 fgrbhw01 kernel: ieee1394: sbp2: Logged into SBP-2 device
>>Feb 18 22:30:18 fgrbhw01 kernel:   Vendor: Initio    Model: 0KLAT80          Rev: 2.05
>>Feb 18 22:30:18 fgrbhw01 kernel:   Type:   Direct-Access                     ANSI SCSI revision: 00
>>Feb 18 22:30:18 fgrbhw01 kernel: SCSI device sdb: 781422768 512-byte hdwr sectors (400088 MB)
>>Feb 18 22:30:18 fgrbhw01 kernel: slab error in cache_free_debugcheck(): cache `sgpool-8': double free, or memory outside object was overwritten
>>Feb 18 22:30:18 fgrbhw01 kernel:  [<c014d8bf>] cache_free_debugcheck+0xce/0x1b9
>>    [<c01486cb>] mempool_free+0x5f/0x63
>>Feb 18 22:30:18 fgrbhw01 kernel:  [<c014e230>] kmem_cache_free+0x2a/0x5c    
>>[<c01486cb>] mempool_free+0x5f/0x63
>>Feb 18 22:30:18 fgrbhw01 kernel:  [<f8864f65>] scsi_io_completion+0x65/0x3ce
>>[scsi_mod]     [<f8860bb3>] scsi_finish_command+0xb8/0xbd [scsi_mod]
>>Feb 18 22:30:18 fgrbhw01 kernel:  [<f8860ab6>] scsi_softirq+0x109/0x128
> 
> 
> This is a characteristic trace for double done() on the same SCSI
> command.

Perhaps. OTOH, maybe there was indeed memory overwritten. SBP-2 targets 
write data into the PC's memory anywhere they see fit, without driver 
intervention. So IMO it is possible that a buggy target writes outside 
of the response data buffer.

I have an Initio based bridge which also claims to implement type 
"Direct-Access". After this device receives a mode_sense command, my 
system reboots straight away (kernel panic while in interrupt; I 
reported it in the thread "TYPE_RBC cache fixes (sbp2.c affected)").

I did not have the time to debug it yet. But at least the very latest 
1394 drivers flag the affected device for BLIST_MS_SKIP_PAGE_08 which 
avoids mode_sense to be sent by sd_mod, thus avoids the panic. Patch: 
"sbp2: update 36byte inquiry workaround (fix compatibility regression)"
http://www.kernel.org/git/?p=linux/kernel/git/scjody/ieee1394.git;a=commit;h=99496037c6744fd938ffb8ccfc8fc91762322ff8
(The skip-page-08 part was actually added for a different bridge with a 
different problem.)

As I can see from the log in the bug report, sbp2's blacklist will also 
spring into action for the reporter's device.

The mentioned patch applies to 2.6.16-rc1 or later. Users of 2.6.14 and 
2.6.15 may apply it by means of rediffs which I provide: 
http://me.in-berlin.de/~s5r6/linux1394/updates/
However instead of patching sbp2, the BLIST_MS_SKIP_PAGE_08 workaround 
can certainly also be enabled by feeding it into scsi_mod's dev_flags 
parameter or default_dev_flags parameter. I guess the syntax would be 
something like
# modprobe scsi_mod dev_flags=Initio:0KLAT80:8192
or
# modprobe scsi_mod default_dev_flags=8192
before sbp2 and scsi_mod are loaded or
# echo 8192 > /sys/module/scsi_mod/parameters/default_dev_flags
when scsi_mod is loaded but before the disk is connected. (Note, I never 
tried setting these parameters myself. Correct me if I got it wrong.)

I will add a pointer to this posting to bugzilla.redhat.com.
-- 
Stefan Richter
-=====-=-==- --=- =--==
http://arcgraph.de/sr/
