From: Aaron Lu <aaron.lwe@gmail.com>
Subject: Re: [PATCH 1/3] scsi: pm: add may_power_off flag
Date: Fri, 31 Aug 2012 19:39:31 +0800
Message-ID: <20120831113927.GA1877@localhost.localdomain>
References: <1346309040-27112-2-git-send-email-aaron.lu@intel.com>
 <Pine.LNX.4.44L0.1208301021181.1511-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59015 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab2HaLnd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Aug 2012 07:43:33 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1208301021181.1511-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lu@intel.com>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org

On Thu, Aug 30, 2012 at 10:24:39AM -0400, Alan Stern wrote:
> On Thu, 30 Aug 2012, Aaron Lu wrote:
> 
> > Add a new flag may_power_off for scsi device, it gives the user a chance
> > to control when the device is runtime suspended, can we remove its power
> > if possible.
> > 
> > I'm planning using this flag for sr and sd.
> > 
> > For sr, if user set 0 to may_power_off, we will disable runtime suspend
> > for ODD, since runtime suspend for ODD is wholly for zero power ODD, if
> > we can't power off the ODD, there is no meaning to do runtime PM on it.
> 
> This doesn't seem like a good idea.  Even though you may not be able to
> reduce the drive's power usage, you can still allow the runtime_suspend
> routine to succeed.  This will tell the kernel to consider the drive as
> being in a suspended (and therefore unusable) state, allowing the
> kernel to do a runtime suspend of the SCSI host that the drive is
> attached to.

Thanks Alan, I agree that this doesn't quite follow the meaning of
may_power_off.

I tried to seperate runtime pm with runtime power off in v5 patch of
ZPODD, please take a look to see if I did it the right way.

Thanks,
Aaron
