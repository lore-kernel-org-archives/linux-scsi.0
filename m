From: Josh Boyer <jwboyer@fedoraproject.org>
Subject: Re: [3.12-rc] sg_open: leaving the kernel with locks still held!
Date: Wed, 23 Oct 2013 05:11:02 -0700
Message-ID: <CA+5PVA6+6jZyypZODiuY4NWY3V2CsJeurFTuy4Wt-KcPddzaSQ@mail.gmail.com>
References: <20131022205608.GA6616@hostway.ca>
	<52671B3E.6070804@interlog.com>
	<1382514295.2081.32.camel@dabdike.quadriga.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1382514295.2081.32.camel@dabdike.quadriga.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: dgilbert@interlog.com, Simon Kirby <sim@hostway.ca>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vaughan Cao <vaughan.cao@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 23, 2013 at 12:44 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Tue, 2013-10-22 at 20:41 -0400, Douglas Gilbert wrote:
>> On 13-10-22 04:56 PM, Simon Kirby wrote:
>> > Hello!
>> >
>> > While trying to figure out why the request queue to sda (ext4) was
>> > clogging up on one of our btrfs backup boxes, I noticed a megarc process
>> > in D state, so enabled locking debugging, and got this (on 3.12-rc6):
>> >
>> > [  205.372823] ================================================
>> > [  205.372901] [ BUG: lock held when returning to user space! ]
>> > [  205.372979] 3.12.0-rc6-hw-debug-pagealloc+ #67 Not tainted
>> > [  205.373055] ------------------------------------------------
>> > [  205.373132] megarc.bin/5283 is leaving the kernel with locks still held!
>> > [  205.373212] 1 lock held by megarc.bin/5283:
>> > [  205.373285]  #0:  (&sdp->o_sem){.+.+..}, at: [<ffffffff8161e650>] sg_open+0x3a0/0x4d0
>> >
>> > Vaughan, it seems you touched this area last in 15b06f9a02406e, and git
>> > tag --contains says this went in for 3.12-rc. We didn't see this on 3.11,
>> > though I haven't tried with lockdep.
>> >
>> > This is caused by some of our internal RAID monitoring scripts that run
>> > "megarc.bin -dispCfg -a0" (even though that controller isn't present on
>> > this server -- a PowerEdge 2950 w/Perc 5).
>> >
>> > strace output of the program execution that causes the above message is
>> > here: http://0x.ca/sim/ref/3.12-rc6/megarc_strace.txt
>>
>> This has been reported. That patch will be reverted or,
>> if there is enough time, a fix will (or at least should)
>> go in before the release of lk 3.12 .
>
> I think you've got about a week to prove you can fix it (before 3.12
> goes final).  I'll send my current set of fixes to Linus without doing
> anything about sg.

In the event that a suitable fix isn't found, are you going to revert
the commit(s) that caused the issue?

josh
