From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [3.12-rc] sg_open: leaving the kernel with locks still held!
Date: Tue, 22 Oct 2013 20:41:34 -0400
Message-ID: <52671B3E.6070804@interlog.com>
References: <20131022205608.GA6616@hostway.ca>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131022205608.GA6616@hostway.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Simon Kirby <sim@hostway.ca>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Vaughan Cao <vaughan.cao@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 13-10-22 04:56 PM, Simon Kirby wrote:
> Hello!
>
> While trying to figure out why the request queue to sda (ext4) was
> clogging up on one of our btrfs backup boxes, I noticed a megarc process
> in D state, so enabled locking debugging, and got this (on 3.12-rc6):
>
> [  205.372823] ================================================
> [  205.372901] [ BUG: lock held when returning to user space! ]
> [  205.372979] 3.12.0-rc6-hw-debug-pagealloc+ #67 Not tainted
> [  205.373055] ------------------------------------------------
> [  205.373132] megarc.bin/5283 is leaving the kernel with locks still held!
> [  205.373212] 1 lock held by megarc.bin/5283:
> [  205.373285]  #0:  (&sdp->o_sem){.+.+..}, at: [<ffffffff8161e650>] sg_open+0x3a0/0x4d0
>
> Vaughan, it seems you touched this area last in 15b06f9a02406e, and git
> tag --contains says this went in for 3.12-rc. We didn't see this on 3.11,
> though I haven't tried with lockdep.
>
> This is caused by some of our internal RAID monitoring scripts that run
> "megarc.bin -dispCfg -a0" (even though that controller isn't present on
> this server -- a PowerEdge 2950 w/Perc 5).
>
> strace output of the program execution that causes the above message is
> here: http://0x.ca/sim/ref/3.12-rc6/megarc_strace.txt

This has been reported. That patch will be reverted or,
if there is enough time, a fix will (or at least should)
go in before the release of lk 3.12 .

See this thread:
   http://marc.info/?t=138228547300001&r=1&w=2


And you might test the patch and confirm that it does
fix the problem (and report back).

Doug Gilbert
