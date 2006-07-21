From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [dm-devel] Re: [PATCH RFC] move scsi parts of dm hw handlers to	scsi layer
Date: Fri, 21 Jul 2006 12:35:07 -0700
Message-ID: <20060721193507.GA24693@us.ibm.com>
References: <1153480817.8030.15.camel@max> <581472.1153482088210.SLOX.WebMail.wwwrun@imap-dhs.suse.de> <44C0BF4C.5060102@cs.wisc.edu> <44C0C0BA.90006@cs.wisc.edu> <4880914.1153483821524.SLOX.WebMail.wwwrun@imap-dhs.suse.de> <44C0C548.4080806@cs.wisc.edu> <20060721151656.GA10239@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="XOIedfhf+7KOe/yw"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:6102 "EHLO e35.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1750970AbWGUTfc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Jul 2006 15:35:32 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k6LJZVV0010312
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Fri, 21 Jul 2006 15:35:31 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k6LJZVOE258472
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 21 Jul 2006 13:35:31 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k6LJZUUr016079
	for <linux-scsi@vger.kernel.org>; Fri, 21 Jul 2006 13:35:31 -0600
Content-Disposition: inline
In-Reply-To: <20060721151656.GA10239@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, device-mapper development <dm-devel@redhat.com>, agk@redhat.com, linux-scsi@vger.kernel.org


--XOIedfhf+7KOe/yw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 21, 2006 at 08:16:56AM -0700, Mike Anderson wrote:
> Mike Christie <michaelc@cs.wisc.edu> wrote:
> > Hannes Reinecke wrote:
> > > Am Fr 21.07.2006 13:55 schrieb Mike Christie <michaelc@cs.wisc.edu>:
> > > 
> > >> Mike Christie wrote:
> > >>> Hannes Reinecke wrote:

> > >>> I was adding my fields when I noticed this comment:
> > >>>
> > >>>
> > >>> * Do not add to this list, use the command line or proc interface to
> > >>>  add
> > >>>  * to the scsi_dev_info_list. This table will eventually go away.
> > >>>
> > >>>
> > >>>> We have to have some sort of device table anyway as these handlers
> > >>>> are
> > >>>> far from being generic, so any sense code which triggers action on
> > >>>> one
> > >>>> device might be perfectly ok for others.
> > >>> When I was looking for the history of that commet, I thought I read
> > >>> that
> > >>> we are supposed to be moving to some userspace approach that pushes
> > >>> that
> > >>> info down via some magic interface.
> > >>>
> > >> I added this comment at the wrong place. I meant to say I thought we
> > >> are
> > >> supposed to be moving away from the kernel devinfo list to some
> > >> userspace one that gets sent down via the module_param or some new
> > >> magic
> > >> interface.
> > > 
> > > Or so they claim. I seem to remember some discussion about it; the net
> > > result was the scsi_devinfo will stay with us for the time being.
> > > 
> > > Otherwise you'll end up having to configure your kernel / module during
> > > startup. With parameters which are static anyway. Can't say I like it.
> > > And the tricky bit is that these information has to be present prior
> > > to any initialisation, so you basically have to feed it during
> > > modprobe time. Not really clever.

I would think distros would like the user space method so they would not
have to release a new kernel to add items to the devinfo / blacklist.

> > He He fun :)
> > 
> > Sticking what we need in devinfo is a lot easier. And I think it makes
> > sense since the devices info we want to bind with is in there already.
> > If nobody says anything, I will send the next version of the path with
> > devinfo integration.
> 
> I think Patrick added the comment and the interface so he can add the
> history. One can use the module or proc interface to pass update devinfo
> information in (the sysfs migration never was done). Well it has the
> drawback stated above it can address the issue that certain devices can be
> supported without a kernel recompile.

I just thought that we should not be putting black lists in the kernel,
and AFAIR thought everyone wanted this type of data in user space (even
back then). The comment in the code has never been enforced. I never did
think of a decent (space efficient) method to access a link list or array
in sysfs.

I didn't look close at the other patches in this thread.

I am attaching some simple user space code I wrote some time ago, feel
free to use it. There is a script version and C version. I don't know
devinfo-current is really current :) 

There should also be a corresponding kernel patch (if distros wanted to
use this) to allow disabling the in-kernel devinfo table.

The script (bload.sh) needs indirection (pointer like reference, this:
${!i}), I don't think nash supports indirection, otherwise the script is
very simple.

Like Hannes said, you need some /etc/modprobe.conf juju to load scsi_mod,
run the attached script or program, and only then allow other scsi modules
to load. Plus similar code in the initrd/ramfs. I actually tried out the
modprobe.conf change at some time, I don't recall the exact modprobe
lines, AFAIR it needed to use the --ignore-install option.

> Post storage summit I started creating a hardware handler in SCSI, but for
> some reason that I do not recall I started working on SDEV state model
> change integrated into devinfo. The thought being that devices would come
> up in a standby state and then all the varied commands to determine path
> state could be executed from user space.
> 
> Well it did solve the issue I was trying to address (passive paths
> generating errors on startup), it would need user space assistance with all
> the plus / minus issues that brings.

-- Patrick Mansfield

--XOIedfhf+7KOe/yw
Content-Type: application/x-gzip
Content-Disposition: attachment; filename="scsi_blacklist.tar.gz"
Content-Transfer-Encoding: base64

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

--XOIedfhf+7KOe/yw--
