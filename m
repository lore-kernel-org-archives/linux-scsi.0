From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Mon, 15 Nov 2010 14:13:59 -0800
Message-ID: <20101115221359.GA9530@kroah.com>
References: <4CDA6CD4.3010308@panasas.com>
 <4CDAFE6E.7050200@vlnb.net>
 <4CDBBE80.40908@panasas.com>
 <4CDC56F9.9040601@vlnb.net>
 <20101112012315.GE17097@core.coreip.homeip.net>
 <4CDEC8D2.8080101@vlnb.net>
 <20101113235938.GA1827@kroah.com>
 <AANLkTi=PxYi8kCsAxbopUHBC+=2QPuoEcojdqugS88sH@mail.gmail.com>
 <20101115184422.GA9566@kroah.com>
 <4CE19A94.8080504@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4CE19A94.8080504@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Bart Van Assche <bvanassche@acm.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, James Smart <James.Smart@emulex.com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 15, 2010 at 11:39:48PM +0300, Vladislav Bolkhovitin wrote:
> Greg KH, on 11/15/2010 09:44 PM wrote:
> > On Mon, Nov 15, 2010 at 06:45:24PM +0100, Bart Van Assche wrote:
> >> On Sun, Nov 14, 2010 at 12:59 AM, Greg KH <greg@kroah.com> wrote:
> >>>
> >>> On Sat, Nov 13, 2010 at 08:20:18PM +0300, Vladislav Bolkhovitin wrote:
> >>>> So, I decided to reimplement it to be completely synchronous. SYSFS
> >>>> authors did really great job and thanks to the excellent internal SYSFS
> >>>> design and implementation it is absolutely safe. See:
> >>>>
> >>>> [root@tgt ~]# modprobe scst
> >>>> [root@tgt ~]# cd /sys/kernel/scst_tgt/
> >>>
> >>> Sorry, but no, you can't put this in /sys/kernel/ without getting the
> >>> approval of the sysfs maintainer.
> >>>
> >>> I really don't understand why you are using kobjects in the first place,
> >>> why isn't this in the main device tree in the kernel, using 'struct
> >>> device'?
> >>
> >> We might have missed something, but as far as we know it has not yet
> >> been explained in this thread why using 'struct device' would be an
> >> advantage over using 'struct kobject'.
> > 
> > It's very simple.
> > 
> > You want your device to show up in the global device tree in the kernel,
> > not off to one side, unconnected to anything else.
> > 
> > Please use 'struct device', it is what you want to do here.
> 
> But we don't have any device to show up in the global device tree!

Not true at all.

> We don't have any devices in the struct device's understanding at all!

Then create them just like you are doing so for your kobject use.

The first device would be the root one, and then everything trickles
down from there.

And use configfs for your configuration stuff, that's what it is there
for, and if it doesn't somehow work properly for you, please work with
the configfs developers to fix that up.

thanks,

greg k-h
