From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/3] scsi: pm: add may_power_off flag
Date: Thu, 30 Aug 2012 10:24:39 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1208301021181.1511-100000@iolanthe.rowland.org>
References: <1346309040-27112-2-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:58410 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752260Ab2H3OYk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Aug 2012 10:24:40 -0400
In-Reply-To: <1346309040-27112-2-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>

On Thu, 30 Aug 2012, Aaron Lu wrote:

> Add a new flag may_power_off for scsi device, it gives the user a chance
> to control when the device is runtime suspended, can we remove its power
> if possible.
> 
> I'm planning using this flag for sr and sd.
> 
> For sr, if user set 0 to may_power_off, we will disable runtime suspend
> for ODD, since runtime suspend for ODD is wholly for zero power ODD, if
> we can't power off the ODD, there is no meaning to do runtime PM on it.

This doesn't seem like a good idea.  Even though you may not be able to
reduce the drive's power usage, you can still allow the runtime_suspend
routine to succeed.  This will tell the kernel to consider the drive as
being in a suspended (and therefore unusable) state, allowing the
kernel to do a runtime suspend of the SCSI host that the drive is
attached to.

Alan Stern

