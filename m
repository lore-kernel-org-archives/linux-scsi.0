From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 2.6.11-rc3-bk5, oops in scsi_try_bus_reset
Date: Wed, 2 Mar 2005 17:20:46 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0503021718570.7267-100000@ida.rowland.org>
References: <20050302143413.GA26585@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <20050302143413.GA26585@suse.de>
Sender: linux-usb-devel-admin@lists.sourceforge.net
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Olaf Hering <olh@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Wed, 2 Mar 2005, Olaf Hering wrote:

> When a device is plugged in, rmmod sd_mod fails, does that work for you?
> sda is already unregistered, but rmmod is stuck like that:
> 
> rmmod         D 000F4240     0 11501  11114                     (NOTLB)
> d7a03f1c 00000086 db8b95a0 000f4240 00000000 0001e848 a4c98fc0 000f4236
>        c03b58c8 df666560 df6666b4 e0dbc36c df666560 00000246 e0dbc374 c02cfcbe
>        00000001 df666560 c01171a0 e0dbc374 e0dbc374 c0165981 e0dbc37c e0dfdd40
> Call Trace:
>  [<c02cfcbe>] __down+0x6e/0xd0
>  [<c01171a0>] default_wake_function+0x0/0x10
>  [<c0165981>] dput+0x21/0x180
>  [<c02cfe23>] __down_failed+0x7/0xc
>  [<c01d0430>] kobject_release+0x0/0x10
>  [<c02354e0>] .text.lock.driver+0x8/0x18
>  [<e0dba25d>] exit_sd+0x1d/0x46 [sd_mod]
>  [<c012ccf4>] sys_delete_module+0x154/0x170
>  [<c0151397>] vfs_write+0xa7/0x110
>  [<c01514ac>] sys_write+0x3c/0x70
>  [<c0102c49>] sysenter_past_esp+0x52/0x79

This is a known bug in the way the SCSI midlayer interacts with the driver
model core.  It's not related to usb-storage or the patch you've been
trying out.  You can unblock the rmmod process by unplugging the device.

Alan Stern



-------------------------------------------------------
SF email is sponsored by - The IT Product Guide
Read honest & candid reviews on hundreds of IT Products from real users.
Discover which products truly live up to the hype. Start reading now.
http://ads.osdn.com/?ad_id=6595&alloc_id=14396&op=click
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
