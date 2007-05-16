From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Asynchronous scsi scanning
Date: Tue, 15 May 2007 20:51:21 -0600
Message-ID: <20070516025121.GK10562@parisc-linux.org>
References: <a781481a0705140245s6823df32l5bbf81abf92b0347@mail.gmail.com> <a781481a0705140500q32a891d6g69b40c2d45ec40c6@mail.gmail.com> <a781481a0705140523y789e012bj2ec317565e34366f@mail.gmail.com> <1179153096.3703.23.camel@mulgrave.il.steeleye.com> <a781481a0705141741u4c2f442dk76c68f757cadc38d@mail.gmail.com> <17841.simon.1179228389@5ec7c279.invalid> <20070515120228.GI10562@parisc-linux.org> <4649E03A.1090004@simon.arlott.org.uk> <20070515172905.GJ10562@parisc-linux.org> <a781481a0705151627n18d3be55t6b77885fd7775ffd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:56197 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbXEPCvX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 May 2007 22:51:23 -0400
Content-Disposition: inline
In-Reply-To: <a781481a0705151627n18d3be55t6b77885fd7775ffd@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Simon Arlott <simon@fire.lp0.eu>, James Bottomley <james.bottomley@steeleye.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, kernel-packagers@vger.kernel.org, "Robert P. J. Day" <rpjday@mindspring.com>

On Wed, May 16, 2007 at 04:57:52AM +0530, Satyam Sharma wrote:
> [ I appreciate you forked the thread and gave it a better subject name,
> it would be better still if you could maintain the original CC list, 
> thanks. ]

I removed the people I didn't think needed to be on the Cc list any more,
since I was changing the direction of the thread.

> On 5/15/07, Matthew Wilcox <matthew@wil.cx> wrote:
> >> >It's easy to suggest a sysfs attribute.  What you've failed to do is
> >> >suggest the pathname of the sysfs attribute,
> 
> /sys/module/scsi_mod/parameters/wait_for_async_scans (?)
> Doesn't really matter, but perhaps who created the sysfs namespace
> for scsi in /sys/module/scsi_mod/... could be the best person to suggest.

No, it does matter.  Your suggestion doesn't work, because
/sys/module/scsi_mod/parameters/ belongs to the module code.  To create
a new attribute there, you use the module_param() code -- and there's
no way to have code called when your parameter is changed.

> >Why?  You're not forced to load the module.  In what way does it
> >inconvenience you?  Nobody's making you run 'make modules_install'.
> >I often forget to myself.
> 
> OK, I'll get really silly here myself. I don't want even that half a second 
> of
> overhead when that module is being _built_ (during make modules), not
> the overhead of copying / installing at modules_install time.

You're claiming that 0.7 second (I just timed it on a 3 year old
laptop) *inconveniences* you?

> I apologize if I sounded impolite, and I certainly don't want to act
> demanding / difficult or anything, but it's just that doing this via a sysfs
> attribute (or hey, anything else!) sounds a better way to tackle this than
> this module thing. IMHO, at least.

This whole thing is such a tempest in a teapot.  I really don't
understand why you care so much.
