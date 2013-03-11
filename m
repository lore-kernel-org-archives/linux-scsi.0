From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: STANDBY IMMEDIATE failed on NVIDIA MCP5x controllers when system
 suspend
Date: Mon, 11 Mar 2013 11:00:14 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1303111053060.2246-100000@iolanthe.rowland.org>
References: <1363012462.2395.57.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1363012462.2395.57.camel@dabdike.int.hansenpartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>, bladud@gmail.com, Joe Sapp <nixphoeni+kernel@gmail.com>, Alberto Mattea <support.intranet@libero.it>, Peter Dons Tychsen <donpedro@tdcadsl.dk>, Robert Hancock <hancockrwd@gmail.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 11 Mar 2013, James Bottomley wrote:

> Oh, that seems to be the suspend order isn't careful enough.
> __device_suspend() waits for its children, but the host disk are too far
> separated in the device tree.  If the immediate children of the host are
> all sync, that wait never actually waits for anything.

I was going to make exactly this same point.  During async suspend, the
PM core is careful to make sure that no device is suspended before its
children.  But there aren't any other checks, so if device A isn't an
ancestor of device B then it's possible for async suspend to power down
A before B.  This can cause problems if B needs A to be active while B
is suspending.

Does the ATA system have any non-ancestor dependencies like this?  If 
it does, the appropriate driver can be fixed to take them into account.

Alan Stern

