From: "Philip R. Auld" <pauld@egenera.com>
Subject: Re: [announce] scsi_id 0.1 - generate unique scsi id
Date: Tue, 28 Oct 2003 09:19:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031028091920.J4263@vienna.EGENERA.COM>
References: <20031021165857.A8240@beaverton.ibm.com> <1067031185.4772.48.camel@persist.az.mvista.com> <20031027091655.B4263@vienna.EGENERA.COM> <20031027072733.A20720@beaverton.ibm.com> <20031027120631.E4263@vienna.EGENERA.COM> <20031027093116.A21595@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:60137 "EHLO
	coyote.egenera.com") by vger.kernel.org with ESMTP id S263963AbTJ1OVe
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 09:21:34 -0500
Content-Disposition: inline
In-Reply-To: <20031027093116.A21595@beaverton.ibm.com>; from patmans@us.ibm.com on Mon, Oct 27, 2003 at 09:31:16AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Steven Dake <sdake@mvista.com>, linux-scsi@vger.kernel.org

Hi Patrick,

Rumor has it that on Mon, Oct 27, 2003 at 09:31:16AM -0800 Patrick Mansfield said:
> On Mon, Oct 27, 2003 at 12:06:31PM -0500, Philip R. Auld wrote:
> > Rumor has it that on Mon, Oct 27, 2003 at 07:27:33AM -0800 Patrick Mansfield said:
> > I haven't gotten to play with 2.6 yet, so I'm not sure exactly what udev does. 
> udev is a device naming or dynamic dev program, pretty much a replacement
> for devfs. See:
> 
> http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev-FAQ
> 

That's excellent. Thanks for the pointer. (reads...)

> > However, as long as scsi_id generated the same value for udev it shouldn't 
> > be an issue for that. It's just got to match what it found last time 
> > it booted to make sure it names the device node the same way, right?
> 
> Yes. But broken or devices not fully supporting page 0x80 or 0x83 might
> give the same id for different devices.

Of course, yes, sorry. 

> 
> > Which leads to a question about how this works with udev. If it gets the same 
> > value for multiple paths to a devive won't udev them make a single device node?
> 
> I'm not sure what it will do now, or how to integrate it (or not integrate
> it) with multi-path. For dm/md multipath, as long as we have a way to
> persistently name its block devices there is no issue. But, each of the
> underlying devices should still be made available - that is, udev should
> still create a separate dev entry for each path, even if the devices all
> have the same identifying information.
> 

>From what I read about it that doesn't make sense. Udev will use the callout 
to scsi_id, get the id and use the name "disk-1" if it matches (in your 
example). What it does when it finds that it has already created "disk-1" 
I guess is the issue. It could just remake it and you'd end up only having 
a udev device for the last one found. I could be misunderstanding udev 
still though :) 

It may be that the way this is used best is to use it as a call out in udev 
if you're not doing multi-path. Then if you are using MP, configure udev to 
use scsi bus based names and have the MP detection script call out to scsi_id.
That's at least how I think I would set it up.

I like the idea of having a single place (with it's own callout or what not) that 
that generates these unique scsi device values. I think scsi_id has the promise 
to do that. 



> 
> AFAIK dynamic libraries won't work for initramfs or initrd. 

They can, but, at least for initrd, it's a little more work. Some of the more
fully funtional initrds (e.g. for NFSroot) do this. I suspect 
initramfs probably will -- it uses udev and hence libsysfs. 

>I have not
> tried scsi_id with them, I don't know what the plan is for udev. But we
> can use whatever solution udev comes up with ;-)
> 

Sounds like a plan. 


> -- Patrick Mansfield



-- 
Philip R. Auld, Ph.D.                  Technical Staff 
Egenera Corp.                        pauld@egenera.com
165 Forest St., Marlboro, MA 01752       (508)858-2600
