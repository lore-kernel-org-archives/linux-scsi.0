From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH 1/2] sdev_printk - scsi_device helper macro
Date: Thu, 9 Oct 2003 14:42:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031009144233.A3445@beaverton.ibm.com>
References: <200310071318.11847.dsteklof@us.ibm.com> <009401c38e09$7fecc8a0$2988110a@lsd.css.fujitsu.com> <200310091024.58688.dsteklof@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:10670 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S262613AbTJIVnD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Oct 2003 17:43:03 -0400
Content-Disposition: inline
In-Reply-To: <200310091024.58688.dsteklof@us.ibm.com>; from dsteklof@us.ibm.com on Thu, Oct 09, 2003 at 10:24:58AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Daniel Stekloff <dsteklof@us.ibm.com>
Cc: Hironobu Ishii <ishii.hironobu@jp.fujitsu.com>, linux-scsi@vger.kernel.org

On Thu, Oct 09, 2003 at 10:24:58AM -0700, Daniel Stekloff wrote:
> On Wednesday 08 October 2003 07:03 pm, Hironobu Ishii wrote:

> > And, there are many colon separated bus_id, I prefer adding "scsi" before
> > that. Also, bus_id is separated with ":", so your idea that it is quoted by
> > "< >" is nice.
> > I propose the folloing format.
> >
> > #define sdev_printk(level, sdev, format, arg...) \
> >   printk(level "%s <scsi%s>: " format , (sdev)->sdev_gendev.driver->name, \
> >                 (sdev)->sdev_gendev.bus_id , ## arg)
> >
> > It would produce a message like this:
> >     st <scsi0:0:4:0>: Device offlined - not ready after error recovery

> I am open to other formats, but the problem with doing something like 
> dev_printk() is the driver isn't always there, especially during scan. Or, am 
> I missing something? I decided not to put the driver in because the 
> sdev_printk could be used more throughout the mid-layer and especially in 
> scan when the driver isn't set yet. Please let me know if I'm missing 
> something. 

Right, at scan time we won't have a sdev_gendev.driver.

And, dev_printk won't ever print sg as a driver, since sg is implemented as
a class, so errors when using sg would print st, sd, sr, or maybe crash ;-)

If we have an sdev_printk, it can be modified later to display however you
want.

-- Patrick Mansfield
