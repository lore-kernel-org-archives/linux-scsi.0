From: Florian Mickler <florian@mickler.org>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Tue, 16 Nov 2010 09:49:38 +0100
Message-ID: <20101116094938.5d55f4bf@schatten.dmk.lab>
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
	<20101115221359.GA9530@kroah.com>
	<4CE210D3.5060703@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4CE210D3.5060703@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 15 Nov 2010 21:04:19 -0800
Joe Eykholt <jeykholt@cisco.com> wrote:

> 
> 
> On 11/15/10 2:13 PM, Greg KH wrote:
> > On Mon, Nov 15, 2010 at 11:39:48PM +0300, Vladislav Bolkhovitin wrote:
> >> Greg KH, on 11/15/2010 09:44 PM wrote:
> >> > On Mon, Nov 15, 2010 at 06:45:24PM +0100, Bart Van Assche wrote:
> >> >> On Sun, Nov 14, 2010 at 12:59 AM, Greg KH <greg@kroah.com> wrote:
> >> >>>
> >> >>> On Sat, Nov 13, 2010 at 08:20:18PM +0300, Vladislav Bolkhovitin wrote:
> >> >>>> So, I decided to reimplement it to be completely synchronous. SYSFS
> >> >>>> authors did really great job and thanks to the excellent internal SYSFS
> >> >>>> design and implementation it is absolutely safe. See:
> >> >>>>
> >> >>>> [root@tgt ~]# modprobe scst
> >> >>>> [root@tgt ~]# cd /sys/kernel/scst_tgt/
> >> >>>
> >> >>> Sorry, but no, you can't put this in /sys/kernel/ without getting the
> >> >>> approval of the sysfs maintainer.
> >> >>>
> >> >>> I really don't understand why you are using kobjects in the first place,
> >> >>> why isn't this in the main device tree in the kernel, using 'struct
> >> >>> device'?
> >> >>
> >> >> We might have missed something, but as far as we know it has not yet
> >> >> been explained in this thread why using 'struct device' would be an
> >> >> advantage over using 'struct kobject'.
> >> >
> >> > It's very simple.
> >> >
> >> > You want your device to show up in the global device tree in the kernel,
> >> > not off to one side, unconnected to anything else.
> >> >
> >> > Please use 'struct device', it is what you want to do here.
> >>
> >> But we don't have any device to show up in the global device tree!
> > 
> > Not true at all.
> > 
> >> We don't have any devices in the struct device's understanding at all!
> > 
> > Then create them just like you are doing so for your kobject use.
> > 
> > The first device would be the root one, and then everything trickles
> > down from there.
> > 
> > And use configfs for your configuration stuff, that's what it is there
> > for, and if it doesn't somehow work properly for you, please work with
> > the configfs developers to fix that up.
> > 
> > thanks,
> > 
> > greg k-h
> 
> I don't have any opinion on the above, but I don't see why sysfs can't be
> used for configuration as well as its other roles. It seems to me wasteful
> to require configfs to be used in order to change configuration when
> sysfs works fine for this.

Well, I'm not involved here.. but to me it makes sense. It's just a
useful principle in software design. You don't take something that is
designed for one purpose and mis-use it. It will grow warts and
mutate, stealing flexibility. 

it's one of the reasons many software projects become
unmaintainable... nobody can change anything anymore because the
once simple design has proliferated into a nine headed monster...


> Just my two cents.

My two cents too.

> 
> 	Joe

Flo
