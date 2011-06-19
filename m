From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device
 structure
Date: Sat, 18 Jun 2011 23:14:54 -0500
Message-ID: <1308456894.2353.422.camel@mulgrave>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
	 <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp>
	 <20110615153337.GA10160@kroah.com> <4DF9F11F.705@hitachi.com>
	 <20110616154129.GA31498@kroah.com> <1308239454.2436.34.camel@mulgrave>
	 <20110616161442.GA32113@kroah.com> <1308241506.2436.44.camel@mulgrave>
	 <20110616181943.GB1439@kroah.com> <1308256290.2436.143.camel@mulgrave>
	 <BANLkTikfCMR_=5Jp7tLhM_Wr3vxihEL+rA@mail.gmail.com>
	 <1308264321.2436.161.camel@mulgrave>
	 <BANLkTinvfmU0dszQyu4U=Pw3_BtrmOUi_g@mail.gmail.com>
	 <1308320844.2586.14.camel@mulgrave>
	 <BANLkTi=BsGjgWk3i_Ke5yBoycqWtNyf1zg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52934 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750739Ab1FSEPA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jun 2011 00:15:00 -0400
In-Reply-To: <BANLkTi=BsGjgWk3i_Ke5yBoycqWtNyf1zg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com

On Sat, 2011-06-18 at 21:54 -0400, Kyle Moffett wrote:
> On Fri, Jun 17, 2011 at 10:27, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > On Fri, 2011-06-17 at 01:04 +0200, Kay Sievers wrote:
> >> >> We need many names, and we need all of them from the very beginning,
> >> >> and they should not change during device lifetime unless the device
> >> >> state changes.
> >> >
> >> > So that's actually an argument for leaving the links, surely?  We can
> >> > have many inbound links, but the kernel can only print one name in
> >> > messages, which would be the preferred name that was currently set.
> >>
> >> I really question any concept of _the_ name. My take on it: It will
> >> never work in reality.
> >
> > OK, so lets take the common example: a desktop with three disks and an
> > enclosure with three slots and labels "fred", "jim", and "betty".
> >
> > The desired outcome is that whenever the user manipulates those devices
> > he uses a name related to the label, so whenever dmesg flags a problem,
> > it says sd betty:  device offline or something.  Whenever he mounts, he
> > mounts by /dev/disk/by-preferred/betty (or whatever the current udev
> > vernacular is).  Whenever smartmon says there's an over temp problem. it
> > says that fred has it;  cat /proc/partitions shows how fred, jim and
> > betty are partitioned and so on.
> 
> Hm...
> 
> So there's already all this work going into an event-tracing framework,
> and most of the interesting device errors are getting converted to use
> functions such as "dev_err()" and the like.
> 
> Perhaps the kernel needs a "log" event?  You could add a basic unique-id
> allocator (64-bit integer) and give each device or other interesting object a
> unique "tag".  A generic printk without a "tag" field would automatically
> get tag 0.
> 
> There would be another few special events generated to make it possible
> to uniquely map tags to device-model objects (or filesystems or whatever)
> long after the fact, including enough information to determine the parent
> device or other key attributes.
> 
> Then all of the dev_dbg() would automatically generate the necessary
> trace events tagged by device, with the log-level and "string" as the
> payload.
> 
> Suddenly you can monitor a device (and optionally all of its parents or
> children) for "interesting kernel events", even if that particular driver
> is still doing all of its logging with "primitive" dev_err() printks.
> 
> Since it's tagged by device you can just install a modified "klogd" that
> cooperates with udev to log events with information about exactly
> which device-model node it applies to.  You can even have that
> program generate dbus messages, so your desktop environment
> can complain that the kernel has reported filesystem errors on that
> thumbdrive you just plugged in, but that the media itself seems to
> be fine (no I/O errors).
> 
> A future extension might be to allow trace-events to have a "fallback"
> handler of sorts analogous to the way that audit messages are
> currently handled.  If a process is monitoring events and has a filter
> which matches the event then it will be handled by that process;
> otherwise it will call the "fallback" handler and resort to a printk().
> 
> That would allow a more advanced driver to generate specific
> status and error messages for consumption by monitoring software,
> but still fall back to dmesg when the system is in single-user-mode
> or the monitoring software dies, etc.
> 
> Thoughts?

It's been tried several times before.  No-one who ever began this
project found the commitment to finish it ... however, perhaps you'll be
the first ...

James


