From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 3/9] [SCSI] mvsas: Add driver version and interrupt
 coalescing to device 	attributes in sysfs
Date: Mon, 30 May 2011 22:48:15 +0800
Message-ID: <20110530144815.GB2689@kroah.com>
References: <mvsas-intr-coal>
 <1306247507-6136-1-git-send-email-yxlraid@gmail.com>
 <20110526021809.GA22496@kroah.com>
 <F766E4F80769BD478052FB6533FA745D19FAD846E0@SC-VEXCH4.marvell.com>
 <20110526141430.GD4164@kroah.com>
 <F766E4F80769BD478052FB6533FA745D19FAD848FB@SC-VEXCH4.marvell.com>
 <20110527073302.GA16178@kroah.com>
 <F766E4F80769BD478052FB6533FA745D19FAD84C40@SC-VEXCH4.marvell.com>
 <20110530074508.GB7806@kroah.com>
 <F766E4F80769BD478052FB6533FA745D19FAD84CD9@SC-VEXCH4.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <F766E4F80769BD478052FB6533FA745D19FAD84CD9@SC-VEXCH4.marvell.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Xiangliang Yu <yuxiangl@marvell.com>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "jslaby@suse.cz" <jslaby@suse.cz>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jacky Feng <jfeng@marvell.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, May 30, 2011 at 04:22:40AM -0700, Xiangliang Yu wrote:
> 
> >> >> +What:          /sys/devices/pci/<devices>/<dev>/host/scsi_host/host/interrupt_coalescing
> >> >> +Date:          May 2011
> >> >> +Kernel Version:        2.6.39
> >> 
> >> >2.6.39 was released already, is this file in that release?
> >> Yes.
> 
> >How, doesn't your patch below implement that option?  How can it already
> >be in the .39 kernel?
> oh, that is my fault, I read the README and find out the misunderstanding of Kernel
> Version. How about 2.6.40?

There never will be such a kernel release number, sorry.

> >> >> +Contact:       yuxiangl@marvell.com
> >> >> +Description:   Determines the maximum time the 88SE94XX waits after the occurrence of a
> >> >> +               Command Done before generating an interrupt.The maximum number of the 
> >> >> +               variable is less than 0x10000.
> >> 
> >> >Why would a user, or anyone else, ever want to be able to change this?
> >> Because different platform can get better performance by setting different value
> 
> >Then you need to document _how_ to do this tuning, and why someone would
> >want to, and lots of other stuff.  Don't just blindly let userspace
> >change a value that they know nothing about.
> How about this HOW_TO: you can get a better I/O throughput by
> decreasing the value of Interrupt coalescing, or you can get a better
> CPU think time if you increase the value. 

I still don't konw what you mean by this.  And you really want the
ability to change this stepping by 0x10000 individual choices?

> >> >Why wouldn't this just be something that the driver handles
> > >>automagically so the user never has to worry about it at all?
> > >>As for now, driver can't do it. The value need to be test, and get the best.
> >Why don't you test it and set it to the proper value now?  What would
> >change in a user's system that require this to be changed?  Size of the
> >machine?  Number of disks?  Something else?
> >It really should be automatic, people do not ever want to have to
> >manually tune their machines anymore they should be smart enough to
> >determine the load on them and make the changes without any user needing
> >to do it for them.
> The default value is best for normal situation, but sometime user need
> to tune The value. For example, the system has more than 16 SATA SSD
> disks, CPU need more time to schedule other jobs while running I/O,
> but the user want to do lots of other jobs at the same time, so, the
> user can write a bigger number to the sysfs, the CPU can execute other
> jobs more quickly. This is a balance between CPU think time and I/O
> throughput. But the value is depend on the system environment, like
> as: disk number, what kind of platform, etc. Actually, the most
> important reason for tuning is what the user want, I/O throughput or
> think time.

But that's up to the block scheduler, not your driver, right?  Why would
the driver matter here at all?

And again, 0x10000 different choices?  That's crazy.

> By default, the value don't need to be changed.

Then I would strongly recommend never exporting this value to allow it
to be changed at all then.  It doesn't sound worth it.

greg k-h
