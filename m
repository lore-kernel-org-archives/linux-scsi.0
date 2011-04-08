From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/2] SCSI: Add a SCSI option for persistent device names
 in Kernel.
Date: Fri, 8 Apr 2011 09:14:20 -0700
Message-ID: <20110408161420.GB12111@kroah.com>
References: <20110405124946.7969.66796.stgit@ltc233.sdl.hitachi.co.jp>
 <20110405161400.GA885@kroah.com>
 <4D9F17DF.5030601@hitachi.com>
 <4D9F1CD1.2020600@suse.de>
 <1302275652.4090.10.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1302275652.4090.10.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Hannes Reinecke <hare@suse.de>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-hotplug@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, Jon Masters <jcm@redhat.com>, 2nddept-manager@sdl.hitachi.co.jp
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 08, 2011 at 08:14:12AM -0700, James Bottomley wrote:
> So, while I agree totally with the above: udev and userspace is the way
> to go, I'm not totally opposed to having a non-invasive mechanism for
> indicating a user's preferred name for a device.  I think there are a
> couple of ways to do this:
> 
>      1. Entirely in userspace: just have udev consult a preferred name
>         file and create say /dev/disk/by-preferred.  Then have all the
>         tools that normally output device information do the same (i.e.
>         since real name to preferred name is 1:1, they could all do a
>         reverse lookup).
>      2. have a writeable sysfs preferred_name field, either in the
>         generic device or just in SCSI.  The preferred name would be
>         used by outbound only (i.e. kernel dev_printk messages and
>         possibly /proc/partitions).  All inbound uses of the device
>         would come via the standard udev mechanisms
>         (i.e. /dev/disk/by-preferred would be the usual symlink).  This
>         means from the kernel point of view, no renaming has happened.
>         We'd just try to print out the preferred name in certain
>         circumstances, which should solve most of the described problem.

Either, or both, of those options are fine with me as well.

thanks,

greg k-h
