From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [linux-usb-devel] Numerous problems, partial success getting FujiFilm Finepix 3800 to work under 2.6.
Date: Wed, 21 Apr 2004 17:39:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040421173952.A22730@beaverton.ibm.com>
References: <Pine.LNX.4.44L0.0404211041220.1106-100000@ida.rowland.org> <4086D17C.2050407@nogin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:53741 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263500AbUDVAkS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 20:40:18 -0400
Content-Disposition: inline
In-Reply-To: <4086D17C.2050407@nogin.org>; from aleksey@nogin.org on Wed, Apr 21, 2004 at 12:54:36PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Aleksey Nogin <aleksey@nogin.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, john stultz <johnstul@us.ibm.com>

On Wed, Apr 21, 2004 at 12:54:36PM -0700, Aleksey Nogin wrote:
> On 21.04.2004 07:43, Alan Stern wrote:
> 
> > On Tue, 20 Apr 2004, Aleksey Nogin wrote:
> > 
> > 
> >>Thanks a lot for your feedback. Unfortunately, your patch does not seem 
> >>to affect anything.
> > 
> > 
> > Yes, now you come to mention it, I see there isn't any code in there to 
> > retry the INQUIRY command after a Unit Attention!  All right, try this 
> > patch instead.
> 
> This works, thanks!
> 
> However, is still only works when connected directly. If connected 
> through a hub, when I start copying files, after transferring in the 
> range of 100-500KB, the system thinks that the hub was disconnected, 
> data transfer gets stuck, then it thinks that the mouse (that is 
> attached to the hub) is disconnected, then it thinks that the mouse is 
> back, then everything becomes stuck. If I turn the camera off at this 
> point, it results in a kernel oops...

Where's the oops? This sounds like a badness John sent to me about a USB
cdrom device that gets an error, and when it is later removed hits a
WARN_ON in scsi_device_set_state.

Here's the back trace:

sr 7:0:0:0: Illegal state transition offline->cancel
Badness in scsi_device_set_state at drivers/scsi/scsi_lib.c:1640
Call Trace:
 [<c02b20e5>] scsi_device_set_state+0xbe/0x10b
 [<c02ac93b>] scsi_device_cancel+0x29/0xf4
 [<c02acad5>] scsi_device_cancel_cb+0x0/0x1c
 [<c0238dd7>] device_for_each_child+0x3e/0x6e
 [<c02acb27>] scsi_host_cancel+0x36/0xab
 [<c02acad5>] scsi_device_cancel_cb+0x0/0x1c
 [<c0344af1>] usb_buffer_free+0x45/0x47
 [<c02acbb7>] scsi_remove_host+0x1b/0x5c
 [<c0360bf1>] storage_disconnect+0x39/0x49
 [<c0343b64>] usb_unbind_interface+0x7a/0x7c
 [<c0239b46>] device_release_driver+0x64/0x66
 [<c0239c6d>] bus_remove_device+0x56/0x98
 [<c0238d40>] device_del+0x5f/0x95
 [<c0238d89>] device_unregister+0x13/0x23
 [<c03495f5>] usb_disable_device+0x71/0xac
 [<c0344451>] usb_disconnect+0x9c/0xe9
 [<c0346482>] hub_port_connect_change+0x282/0x287
 [<c0345e39>] hub_port_status+0x45/0xb0
 [<c03467a9>] hub_events+0x322/0x36e
 [<c0346826>] hub_thread+0x31/0xd1
 [<c0111f86>] default_wake_function+0x0/0x12
 [<c03467f5>] hub_thread+0x0/0xd1
 [<c0102209>] kernel_thread_helper+0x5/0xb

-- Patrick Mansfield
