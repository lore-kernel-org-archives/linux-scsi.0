From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] sg driver against lk 2.6.1-bk6
Date: Wed, 21 Jan 2004 09:16:17 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040121171617.GB12384@kroah.com>
References: <400E706A.1050008@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([65.200.24.183]:14284 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S263868AbUAURZA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jan 2004 12:25:00 -0500
Content-Disposition: inline
In-Reply-To: <400E706A.1050008@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org, Kai.Makisara@kolumbus.fi, wrlk@riede.org

On Wed, Jan 21, 2004 at 10:28:26PM +1000, Douglas Gilbert wrote:
> This patch is against the sg driver found in lk 2.6.1-bk6 .
> It is an update on the sg patch sent in the "devices with more
> than one node" thread:
> http://marc.theaimsgroup.com/?l=linux-scsi&m=107415435300783&w=2
> 
> The "simple_class" interface in the mm tree has mutated to
> "class_simple" en route to 2.6.1-bk6. There is now an opaque
> struct class_simple ** which does not seem to allow sg to put
> its driver parameters under the /sys/class/scsi_generic
> directory [which is not relevant to st and osst].
> 
> $ cd /sys/class/scsi_generic/
> $ tree
> .
> `-- sg0
>     |-- dev
>     `-- device -> ../../../devices/pseudo_0/adapter0/host0/0:0:0:0
> 
> $ cd sg0/device/
> $ tree
> .
> |-- delete
> |-- detach_state
> |-- device_blocked
> |-- generic -> ../../../../../class/scsi_generic/sg0
> |-- model
> |-- online
> |-- power
> |   `-- state
> |-- queue_depth
> |-- rescan
> |-- rev
> |-- scsi_level
> |-- type
> `-- vendor

Nice, looks good.

> ** struct class_simple's definition is "hidden" in
> /drivers/base/class_simple.c

Is this a problem?  I figured that if you want access to a struct class,
then you need to go through the "hassle" of dealing with class devices
and classes on your own.  It's a trade off.  Do you find this too
limiting for you?

thanks,

greg k-h
