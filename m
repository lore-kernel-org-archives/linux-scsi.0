From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v5 3/3] scsi: async sd resume
Date: Mon, 10 Mar 2014 22:26:58 -0700
Message-ID: <CAPcyv4gLEQ9-e2GJpfbQQ+DN+nsv-90oFwXxh-_K_hU0z4U5YQ@mail.gmail.com>
References: <Pine.LNX.4.44L0.1403101658490.5966-100000@netrider.rowland.org>
	<1394511589.2142.5.camel@dabdike.int.hansenpartnership.com>
	<CAPcyv4gJssEE7hADEDXmi4ao031uSVjMenKk9AFcbTukm1MKNg@mail.gmail.com>
	<1394515014.2142.11.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ve0-f172.google.com ([209.85.128.172]:59561 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbaCKF07 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Mar 2014 01:26:59 -0400
Received: by mail-ve0-f172.google.com with SMTP id jx11so8180017veb.31
        for <linux-scsi@vger.kernel.org>; Mon, 10 Mar 2014 22:26:58 -0700 (PDT)
In-Reply-To: <1394515014.2142.11.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Len Brown <len.brown@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, Phillip Susi <psusi@ubuntu.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, Todd Brandt <todd.e.brandt@linux.intel.com>

On Mon, Mar 10, 2014 at 10:16 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Mon, 2014-03-10 at 21:47 -0700, Dan Williams wrote:
>> On Mon, Mar 10, 2014 at 9:19 PM, James Bottomley
>> <James.Bottomley@hansenpartnership.com> wrote:
>> > On Mon, 2014-03-10 at 16:59 -0400, Alan Stern wrote:
>> >> On Mon, 10 Mar 2014, Dan Williams wrote:
>> >>
>> >> > > The only thing which is a bit concerning is that this doesn't have any
>> >> > > throttling mechanism for simultaneous wakeups.  Would this be able to
>> >> > > blow up the PSU if used on a machine with a lot of spindles?
>> >> >
>> >> > Good point.  The primary benefit is completing userspace resume
>> >> > without needlessly waiting for the disk.  For now I think it would be
>> >> > enough to have a mutex to maintain one disk at a time.  We can follow
>> >> > on later with something more complex to enable a max simultaneous
>> >> > spin-up tunable.
>> >>
>> >> Why?  The existing code doesn't have anything like that.
>> >
>> > This only becomes a problem if enterprise class systems want to suspend
>> > and resume.  Last I heard, this wasn't on the cards.
>> >
>> > We also don't usually need to bother with in-kernel staggered spin ups
>> > because if the device can blow the PSU by doing simultaneous spinups,
>> > staggering is usually hard jumpered in the system.  The main reason for
>> > this is that there's no way for us to work out the PSU topology to do
>> > the stagger in kernel, so the enterprise likes to be sure.
>> >
>>
>> In that case shouldn't we limit it to a disk at a time?  Enterprise
>> doesn't care and home brew folks that both put a lot of disks in a
>> system and suspend/resume them are less likely to burn themselves.
>
> Where do you get that idea from?  the enterprise is amazingly sensitive
> to system start times; they'd demand my head on a plate if we started a
> disk at a time and their start times went up by 10x.  That's why we
> leave it to hard wiring ... they can start in batches the maximum number
> allowable and thus get the shortest start up times.

Just considering the dpm_resume path, not device discovery...

> In the long game, though this whole debate is moot: setups with hard
> wired start times adhere to them regardless of what the system does, so
> they ignore start unit commands.  Systems without hard wired start times
> can usually be started at once, so us introducing a delay is unnecessary
> in either case.

Ok, then I'll let the patch stand as is.
