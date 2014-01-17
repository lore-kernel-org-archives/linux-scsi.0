From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Disk spin-up optimization during system resume
Date: Fri, 17 Jan 2014 14:17:10 -0800
Message-ID: <CAPcyv4iJScXxpAzH99m6VNHv=vM+96KWgfmv-FH+McnCMb5Vfg@mail.gmail.com>
References: <20140116220409.GA1183@linux.intel.com>
	<Pine.LNX.4.44L0.1401170951270.1162-100000@iolanthe.rowland.org>
	<CAA9_cmcHpWOk_GoAZ_6k_0VDNGdac+BmHB1GxaTNkWNVjcztJQ@mail.gmail.com>
	<52D9976C.2010009@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f43.google.com ([209.85.212.43]:38405 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaAQWRL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2014 17:17:11 -0500
Received: by mail-vb0-f43.google.com with SMTP id p5so1823420vbn.16
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2014 14:17:11 -0800 (PST)
In-Reply-To: <52D9976C.2010009@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Todd E Brandt <todd.e.brandt@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, Jan 17, 2014 at 12:49 PM, Phillip Susi <psusi@ubuntu.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 1/17/2014 2:31 PM, Dan Williams wrote:
>> Once dpm_resume of the disk is asynchronous, is there much
>> incremental gain by further deferring spin up?  The drawback of
>> doing on-demand resume of the disk is that you incur the full
>> resume latency right when you need the data.  System resume is a
>> strong hint to warm the disks back up, and they will go back to
>> sleep if unused.
>
> It isn't a strong hint to warm the disks back up at all.

Well, "at all" is overstating it.  The system was idle and now it's
being woken up to do some work.  Inactivity timers are invalidated and
now the decision becomes minimize access latency, or lazily wake up.

> You *may*
> access *a* disk soon after resume, then again, you may not.  Either
> way, it isn't good to spin up *all* disks after a resume only to have
> them stop again after a few minutes when they aren't accessed.

Hiding resume latency is a good reason to resume the disk as soon as possible.

>It puts needless wear and tear on disks.

I'm not sure spin up cycles are predictive of drive failure?

>> Of course it reduces the power savings if dpm_suspend/resume is a
>> frequent occurrence.  However, are systems that make aggressive use
>> of system suspend shipping with rotating media, or do they ship
>> with disks that are cheap to resume?  If suspend is not frequent I
>> wonder if it is worth the trouble/latency cost to keep the disk(s)
>> asleep.
>
> The vast majority of systems still use HDD; SSD isn't *that* popular.

I'm not arguing about the attach rate of HDDs in shipping systems, I'm
asking what is the system suspend / resume frequency of such systems
and is it worth carrying that complexity in the kernel and injecting
unnecessary resume latency for what amounts to a niche use case.

>  Also there is the power savings of leaving the disk in standby when
> there is no need to "spin" it up, which while fast on an SSD, does
> still increase power consumption and so should be avoided.
>
> In any case, this will have no affect for most people since ATA disks
> spin up on their own by default.

So the use case is even more niche...
