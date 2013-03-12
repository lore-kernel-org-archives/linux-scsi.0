From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: STANDBY IMMEDIATE failed on NVIDIA MCP5x controllers when system
 suspend
Date: Tue, 12 Mar 2013 10:53:27 +0800
Message-ID: <513E98A7.3040307@intel.com>
References: <Pine.LNX.4.44L0.1303111053060.2246-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28993 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549Ab3CLCwX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Mar 2013 22:52:23 -0400
In-Reply-To: <Pine.LNX.4.44L0.1303111053060.2246-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Aaron Lu <aaron.lwe@gmail.com>, bladud@gmail.com, Joe Sapp <nixphoeni+kernel@gmail.com>, Alberto Mattea <support.intranet@libero.it>, Peter Dons Tychsen <donpedro@tdcadsl.dk>, Robert Hancock <hancockrwd@gmail.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>

Hi James and Alan,

On 03/11/2013 11:00 PM, Alan Stern wrote:
> On Mon, 11 Mar 2013, James Bottomley wrote:
> 
>> Oh, that seems to be the suspend order isn't careful enough.
>> __device_suspend() waits for its children, but the host disk are too far
>> separated in the device tree.  If the immediate children of the host are
>> all sync, that wait never actually waits for anything.
> 
> I was going to make exactly this same point.  During async suspend, the
> PM core is careful to make sure that no device is suspended before its
> children.  But there aren't any other checks, so if device A isn't an
> ancestor of device B then it's possible for async suspend to power down
> A before B.  This can cause problems if B needs A to be active while B
> is suspending.

Thanks for the suggestions.

> 
> Does the ATA system have any non-ancestor dependencies like this?  If 
> it does, the appropriate driver can be fixed to take them into account.

I don't think there is, and the relationship is like this:

    ata_host_controller* (named sata_nv xxx)
	    |
	ata_port* (named atax, while "ata_port atax" is another device)
	/	\
scsi_host	ata_link
    |		   |
scsi_target	ata_device
    |
scsi_device* (named sd x:x:x:x)

With the devices that have actual PM operation functions defined have
the asterisk next to it.

So ata_host_controller waits for all of the ata_ports, and the ata_port
waits for both scsi_host and ata_link. scsi_host waits for scsi_target,
and scsi_target waits for scsi_device. So if scsi_device is not done,
ata_port will not start. Doesn't look like a problem to me.

And from the log:
https://bugzilla.kernel.org/attachment.cgi?id=95101
It also looks like the order is correct.

Thanks,
Aaron
