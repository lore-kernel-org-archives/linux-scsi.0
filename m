From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [announce] scsi_id 0.1 - generate unique scsi id
Date: Mon, 27 Oct 2003 09:31:16 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031027093116.A21595@beaverton.ibm.com>
References: <20031021165857.A8240@beaverton.ibm.com> <1067031185.4772.48.camel@persist.az.mvista.com> <20031027091655.B4263@vienna.EGENERA.COM> <20031027072733.A20720@beaverton.ibm.com> <20031027120631.E4263@vienna.EGENERA.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:7087 "EHLO e34.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S263314AbTJ0RcT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Oct 2003 12:32:19 -0500
Content-Disposition: inline
In-Reply-To: <20031027120631.E4263@vienna.EGENERA.COM>; from pauld@egenera.com on Mon, Oct 27, 2003 at 12:06:31PM -0500
List-Id: linux-scsi@vger.kernel.org
To: "Philip R. Auld" <pauld@egenera.com>
Cc: Steven Dake <sdake@mvista.com>, linux-scsi@vger.kernel.org

On Mon, Oct 27, 2003 at 12:06:31PM -0500, Philip R. Auld wrote:
> Rumor has it that on Mon, Oct 27, 2003 at 07:27:33AM -0800 Patrick Mansfield said:
> I haven't gotten to play with 2.6 yet, so I'm not sure exactly what udev does. 
udev is a device naming or dynamic dev program, pretty much a replacement
for devfs. See:

http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev-FAQ

> However, as long as scsi_id generated the same value for udev it shouldn't 
> be an issue for that. It's just got to match what it found last time 
> it booted to make sure it names the device node the same way, right?

Yes. But broken or devices not fully supporting page 0x80 or 0x83 might
give the same id for different devices.

> Which leads to a question about how this works with udev. If it gets the same 
> value for multiple paths to a devive won't udev them make a single device node?

I'm not sure what it will do now, or how to integrate it (or not integrate
it) with multi-path. For dm/md multipath, as long as we have a way to
persistently name its block devices there is no issue. But, each of the
underlying devices should still be made available - that is, udev should
still create a separate dev entry for each path, even if the devices all
have the same identifying information.

> > And, It is not clear if the specific code called should be a separate
> > program or a new function. A separate program can be released independent
> > of scsi_id, but that means we will need common or duplicated code: mainly
> > for the sg_io usage, and decoding of the result, especially the sense
> > data.
> > 
> 
> A separate program that is called based on the config file makes sense to me. 
> It could then be independent as you say. A small general purpose dynamic sg_io 
> library could remove the code duplication. 

That is possible, but more work, and again I don't have any such devices.

AFAIK dynamic libraries won't work for initramfs or initrd. I have not
tried scsi_id with them, I don't know what the plan is for udev. But we
can use whatever solution udev comes up with ;-)

-- Patrick Mansfield
