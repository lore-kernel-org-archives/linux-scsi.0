From: Peter Jones <pjones@redhat.com>
Subject: Re: Asynchronous scsi scanning
Date: Thu, 17 May 2007 18:00:50 -0400
Message-ID: <464CD092.6050300@redhat.com>
References: <a781481a0705171013j7ddc48edxfb4bdba515a3f53c@mail.gmail.com> <20070517172023.GL10562@parisc-linux.org> <a781481a0705171041y3c3b7fe1m2aa6a8805807942c@mail.gmail.com> <20070517182414.GA12170@infradead.org> <a781481a0705171147s1ef5c205y8873d0bfa201f928@mail.gmail.com> <20070517185115.GA13207@infradead.org> <a781481a0705171204o5b25fafdm36d5970acf9119cd@mail.gmail.com> <20070517193953.GM10562@parisc-linux.org> <20070517194326.GC30571@kvack.org> <20070517213043.GN10562@parisc-linux.org> <20070517214234.GA398@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413AbXEQWAy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 May 2007 18:00:54 -0400
In-Reply-To: <20070517214234.GA398@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Benjamin LaHaise <bcrl@kvack.org>, James Bottomley <james.bottomley@steeleye.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, kernel-packagers@vger.kernel.org, pjones@redhat.com

Dave Jones wrote:
> On Thu, May 17, 2007 at 03:30:43PM -0600, Matthew Wilcox wrote:
>  > On Thu, May 17, 2007 at 03:43:26PM -0400, Benjamin LaHaise wrote:
>  > > On Thu, May 17, 2007 at 01:39:54PM -0600, Matthew Wilcox wrote:
>  > > > On Fri, May 18, 2007 at 12:34:40AM +0530, Satyam Sharma wrote:
>  > > > > Hmmm, actually those other users could easily write and maintain
>  > > > > a 20-line patch that does the wait for async scans thing for them
>  > > > > using /proc/scsi/scsi in any case.

This is one of the things we currently do.  There are problems with it, 
not the least of which being that it's hard to know how long to wait, 
and waiting excessively long generates user complaints.

>  > > > How about the three users who're bothered by this extra module being
>  > > > built maintain a one-line patch to Kconfig and leave well enough alone?

(I assume this is about scsi_wait_scan)

>  > > The module has an added bonus that it doesn't require any new tools to 
>  > > make work.  Doing it via sysfs/procfs means a new rev of whatever tool 
>  > > generates the boot initrd, plus fixing up boot scripts.  Loading a module 
>  > > can be done via a simple option to the existing boot tools.

This isn't really true -- loading the module requires that a user is 
actually running the tools and knows to do it, which is rarely (and 
ideally never) the case.  And frankly, every single one of our users 
would have to do it.

So really, either way means we need to update the tools.  It also 
doesn't really solve the problem -- when I insert "usb-storage", the 
SCSI scan may still finish while we're still enumerating the bus for USB 
devices. (I'd be willing to believe I'm wrong about this specific 
example, but I suspect the principle still applies for some other driver.)

In practice, we wind up doing the compare/timeout loop as on 
/proc/scsi/scsi, but on /proc/bus/usb/devices or 
/sys/bus/ieee1394/drivers/sbp2 instead.

>  > That was what James and I thought.  However, the distros seem unhappy
>  > with it.  Of course, they won't actually *comment* on it, they just
>  > disable the async scan and won't talk about why.
> 
> FWIW, Fedora 7 has it enabled, and afaik, Peter (mkinitrd maintainer) is happy
> with the current situation.  It's my understanding that the latest ubuntu
> release has it enabled too, though obviously I can't speak for whether
> or not they're happy with the status quo.

I wouldn't say I'm *happy* with the current situation, but we're to the 
point where it works for most users.

At the same time, we're moving towards polling on the hotplug socket, 
waiting for specific devices to appear from which to build and mount 
"/".  That should obviate the need for much of this in most cases.

-- 
   Peter
