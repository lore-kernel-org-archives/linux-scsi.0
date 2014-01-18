From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Disk spin-up optimization during system resume
Date: Fri, 17 Jan 2014 20:09:08 -0800
Message-ID: <CAPcyv4i2+GAEV7NNx6MkOOcZSCxhOWB3sCO1eCuH40Z2fhpw3g@mail.gmail.com>
References: <20140116220409.GA1183@linux.intel.com>
	<Pine.LNX.4.44L0.1401170951270.1162-100000@iolanthe.rowland.org>
	<CAA9_cmcHpWOk_GoAZ_6k_0VDNGdac+BmHB1GxaTNkWNVjcztJQ@mail.gmail.com>
	<52D9976C.2010009@ubuntu.com>
	<CAPcyv4iJScXxpAzH99m6VNHv=vM+96KWgfmv-FH+McnCMb5Vfg@mail.gmail.com>
	<52D9F27F.8060705@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ve0-f182.google.com ([209.85.128.182]:59733 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbaAREJI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2014 23:09:08 -0500
Received: by mail-ve0-f182.google.com with SMTP id jy13so169320veb.27
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2014 20:09:08 -0800 (PST)
In-Reply-To: <52D9F27F.8060705@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Todd E Brandt <todd.e.brandt@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, Jan 17, 2014 at 7:18 PM, Phillip Susi <psusi@ubuntu.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
>
> On 01/17/2014 05:17 PM, Dan Williams wrote:
>> Well, "at all" is overstating it.  The system was idle and now
>> it's being woken up to do some work.  Inactivity timers are
>> invalidated and now the decision becomes minimize access latency,
>> or lazily wake up.
>
> Sure, but that work may or may not involve disk access.  Think of a
> laptop you are using to watch a video on youtube.  You need to get up
> for a minute so you suspend, come back, and continue watching... no
> need for disk IO just because you paused for a few minutes.  For a
> single disk system you may argue that it is likely the disk will be
> needed, but for multiple disk systems, that probability goes down.
>
>>> It puts needless wear and tear on disks.
>>
>> I'm not sure spin up cycles are predictive of drive failure?
>
> Drive makers rate them to handle only so many start/stop cycles before
> they fail, which is why SMART keeps track of the count.  Any time you
> move mechanical parts, they wear out.

They also recommend maximum intervals of spin down time.  Mind you its
on the order of weeks, but spinning up the drive help keeps the
bearing lubricant evenly distributed.

What I was getting at is do these patches have a measurable impact on
drive lifetime?  For example how many spin ups is this saving vs
deferring in your setup.  I buy the power saving impact, but wearing
out the drive prematurely is harder to accept without data.

>> I'm not arguing about the attach rate of HDDs in shipping systems,
>> I'm asking what is the system suspend / resume frequency of such
>> systems and is it worth carrying that complexity in the kernel and
>> injecting unnecessary resume latency for what amounts to a niche
>> use case.
>
> It doesn't add any latency for an SSD, or even an ATA HDD that does
> not have PuiS enabled.  SCSI disks are more likely to be in larger
> systems where it is more likely that at least some of the drives won't
> be accessed soon, and if you really want to avoid the latency, then
> you can configure your user space pm scripts to disable runtime pm
> prior to suspend to get the old behavior back.
>

Larger systems are less likely to ever sleep.

I think it's a bit of an interface surprise to have pm_runtime disable
have side effects only for scsi_disk devices.  I think lazy_resume
needs to be an explicit attribute of the disk.  For ata devices any
command wakes up the drive.  Perhaps we could simply do the same for
scsi devices.  In lazy_resume mode flag the device as "needs spinup"
at sd_resume time and schedule it when a command arrives.
