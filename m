From: Olaf Hering <olh@suse.de>
Subject: Re: [linux-usb-devel] 2.6.11-rc3-bk5, oops in scsi_try_bus_reset
Date: Wed, 2 Mar 2005 15:34:13 +0100
Message-ID: <20050302143413.GA26585@suse.de>
References: <20050217183927.GA8073@suse.de> <Pine.LNX.4.44L0.0502171453170.1383-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Received: from news.suse.de ([195.135.220.2]:31198 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262303AbVCBOeP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2005 09:34:15 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0502171453170.1383-100000@ida.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net

 On Thu, Feb 17, Alan Stern wrote:

> On Thu, 17 Feb 2005, Olaf Hering wrote:
> 
> >  On Mon, Feb 14, Alan Stern wrote:
> > 
> > > https://lists.one-eyed-alien.net/pipermail/usb-storage/2004-November/001201.html
> > 
> > Alan,
> > 
> > this patch seems to fix the crashes. Is it ready for production use, or
> > should I wait for a differnt patch?
> 
> It hasn't been tested very much.  (Would you like to be a beta tester? :-)  
> Right now I'm in the middle of cleaning it up and submitting it to Matt
> Dharm for official inclusion.

When a device is plugged in, rmmod sd_mod fails, does that work for you?
sda is already unregistered, but rmmod is stuck like that:

rmmod         D 000F4240     0 11501  11114                     (NOTLB)
d7a03f1c 00000086 db8b95a0 000f4240 00000000 0001e848 a4c98fc0 000f4236
       c03b58c8 df666560 df6666b4 e0dbc36c df666560 00000246 e0dbc374 c02cfcbe
       00000001 df666560 c01171a0 e0dbc374 e0dbc374 c0165981 e0dbc37c e0dfdd40
Call Trace:
 [<c02cfcbe>] __down+0x6e/0xd0
 [<c01171a0>] default_wake_function+0x0/0x10
 [<c0165981>] dput+0x21/0x180
 [<c02cfe23>] __down_failed+0x7/0xc
 [<c01d0430>] kobject_release+0x0/0x10
 [<c02354e0>] .text.lock.driver+0x8/0x18
 [<e0dba25d>] exit_sd+0x1d/0x46 [sd_mod]
 [<c012ccf4>] sys_delete_module+0x154/0x170
 [<c0151397>] vfs_write+0xa7/0x110
 [<c01514ac>] sys_write+0x3c/0x70
 [<c0102c49>] sysenter_past_esp+0x52/0x79


