From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass larger receive buffer
Date: Mon, 17 Nov 2003 14:00:32 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031117140032.A21143@beaverton.ibm.com>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org> <1068766632.2851.142.camel@patrh9> <20031113162401.A29775@beaverton.ibm.com> <1069105104.2324.331.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:41438 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261735AbTKQWAi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2003 17:00:38 -0500
Content-Disposition: inline
In-Reply-To: <1069105104.2324.331.camel@patrh9>; from p.lavarre@ieee.org on Mon, Nov 17, 2003 at 02:38:24PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

[Trimmed the cc line]

On Mon, Nov 17, 2003 at 02:38:24PM -0700, Pat LaVarre wrote:
> > I don't have any sd removable read only media.
> 
> Eh?  Does http://www.torque.net/sg/sdebug26.html
> not give us all sd removable read only media?

Yes, looks like I would have to modify scsi_debug.c DEV_READONLY to make
it behave as read only.

> > If you want to test with your read only media,
> > just use the dev flags:
> > 
> > 	echo "vendor:model:0x4000" > /proc/scsi/device_info 
> > 
> > Then add your device, see if it comes back as writable, and try to mount
> > or write it, and compare without the above (you can't remove device_info
> > entry without rebooting or rmmod-ing scsi).
> 
> Thanks for kindly finding the time to share these hints, I have now
> begun the work of decrypting them.
> 
> 1) `find /lib/modules -name '*.ko'` says I have no scsi.ko.  If I kick
> around in `make xconfig` long enough, I may find one.

It is named scsi_mod.ko if you built it as a module.

Once you have a base .config it is easier to modify the .config and then
run make oldconfig and answer y/n/m.

I usually just delete the line in question from .config, and run make
oldconfig. In this case delete the line with CONFIG_SCSI and run make
oldconfig.

> 2) By vendor:model I first guess we mean what bash would say as
> "$vendor:$model", of 8 and x10 bytes respectively, same as in op x12
> Inquiry.

Yes.

-- Patrick Mansfield
