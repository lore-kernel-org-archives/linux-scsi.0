From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Remove scsi_wait_scan module
Date: Thu, 31 May 2012 09:21:45 +0100
Message-ID: <1338452505.3073.4.camel@dabdike.int.hansenpartnership.com>
References: <1338110026.2957.5.camel@dabdike.int.hansenpartnership.com>
	 <20120528100015.GB10036@vostochny.stro.at>
	 <1338206866.6330.22.camel@dabdike>
	 <CAA9_cmfh9ZtepX+hjLVRM95u_pAe90kZTkBeVmFPWm8AMaqJ5g@mail.gmail.com>
	 <1338420752.3069.20.camel@dabdike>
	 <CAA9_cmfZFm5+9ARB7tNVwNzwxJh3bPD=h7gMWhByjy00-qZvgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37019 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387Ab2EaI6U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 May 2012 04:58:20 -0400
In-Reply-To: <CAA9_cmfZFm5+9ARB7tNVwNzwxJh3bPD=h7gMWhByjy00-qZvgg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: maximilian attems <max@stro.at>, linux-scsi <linux-scsi@vger.kernel.org>, Dave Jones <davej@redhat.com>, Jeff Mahoney <jeffm@suse.de>, Ben Hutchings <ben@decadent.org.uk>, initramfs@vger.kernel.org

On Wed, 2012-05-30 at 19:34 -0700, Dan Williams wrote:
> On Wed, May 30, 2012 at 4:32 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > On Wed, 2012-05-30 at 11:26 -0700, Dan Williams wrote:
> >> On Mon, May 28, 2012 at 5:07 AM, James Bottomley
> >> <James.Bottomley@hansenpartnership.com> wrote:
> >> > On Mon, 2012-05-28 at 10:00 +0000, maximilian attems wrote:
> >> >> On Sun, May 27, 2012 at 10:13:46AM +0100, James Bottomley wrote:
> >> >> > scsi_wait_scan was introduced with asynchronous host scanning as a hack
> >> >> > for distributions that weren't using proper udev based wait for root to
> >> >> > appear in their initramfs scripts.  In 2.6.30 Commit
> >> >>
> >> >> > c751085943362143f84346d274e0011419c84202
> >> >> > Author: Rafael J. Wysocki <rjw@sisk.pl>
> >> >> > Date:   Sun Apr 12 20:06:56 2009 +0200
> >> >> >
> >> >> >     PM/Hibernate: Wait for SCSI devices scan to complete during resume
> >> >> >
> >> >> > Actually broke scsi_wait_scan because it renders
> >> >> > scsi_complete_async_scans() a nop for modular SCSI if you include
> >> >> > scsi_scans.h (which this module does).
> >> >> >
> >> >> > The lack of bug reports is sufficient proof that this module is no
> >> >> > longer used.
> >> >>
> >> >> We do use it in initramfs-tools.
> >> >>
> >> >> There is quite a number of bug reports moaning about having to boot with
> >> >> `scsi_mod.scan=sync'. I didn't pass them on, because I didn't knew that
> >> >> the module itself got broken, for example:
> >> >> http://bugs.debian.org/616689
> >> >
> >> > OK, so what these bugs show is the breakage ... basically scsi_wait_scan
> >> > isn't really waiting for the scans to complete.  I can fix it in stable
> >> > so you can close your bug reports, but if I do, can you also transition
> >> > away from using it so I can remove it in 3.5?
> >>
> >> Is there some other method whereby userspace can sync all driver
> >> probing actions?
> >
> > No,  but then there never really was.  The theory is you know all the
> > disks you need (/ /usr and so on) and you just wait for them to appear
> > before mounting them and proceeding with boot.
> >
> >> We won't need scsi_complete_async_scans() after:
> >>
> >>   http://marc.info/?l=linux-scsi&m=133840132007532&w=2
> >>
> >> ...but won't initramfs environments still need a way to trigger
> >> wait_for_device_probe()?  Something like echo "flush" >
> >> /sys/devices/async_probe. and maybe reading that file indicates if
> >> some async probing is still in-flight?
> >
> > Why?  The job of an initramfs is to mount root.  All it has to do is
> > wait for root to appear via udev and then proceed.  The whole reason for
> > doing stuff async initially was to speed boot, so probing can still be
> > ongoing even after the initrd exits.
> >
> > If you think about it, most modern fabrics are hot plug.  Just because
> > the initial scan has completed there's no guarantee that all the devices
> > have appeared yet.
> 
> Fine for single device root, but what about raid and degraded assembly?
> 
> Last time I checked scsi_wait_scan was still being used by dracut in
> the case where it decides to stop waiting for all raid members to
> appear.  It's a "last call" before proceeding with degraded assembly.

That's pretty pointless behaviour, isn't it?  What it's basically doing
is allowing a set time for the devices to appear, waiting out that time
(so presumably something is wrong with one or more of the devices), then
inserting scsi_wait_scan as some type of magic incantation to just make
it work.

> If you immediately assemble and mount root as soon as the root device
> could be started it will almost always be a degraded array.  Sure the
> initramfs can just timeout arrival, but at a minimum that timeout
> should be "load module + flush scanning".  Without a flush mechanism
> it's just a shot in the dark what that minimum timeout should be.

No, you wait a specified time for all the devices to appear before
assembling the raid.  If they don't, you try to bring a degraded raid
up.

The behaviour is also dependent on the user: If I'm a savvy user and I
have a raid log, I want my system up as fast as possible, so I only want
to wait until the minimum number of devices appears before assembling
the raid and moving on, knowing that hotplug of the remaining will cause
a log replay.

> If ata error recovery is kicking in and needs 10s of seconds to
> recover a drive I'd want my initramfs to wait for that process to
> quiesce before timing out and moving on.

That's the timeout you specify.

James


