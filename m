From: Daniel Stekloff <dsteklof@us.ibm.com>
Subject: Re: [PATCH 1/2] sdev_printk - scsi_device helper macro
Date: Wed, 31 Mar 2004 11:23:53 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200403311123.53361.dsteklof@us.ibm.com>
References: <200310071318.11847.dsteklof@us.ibm.com> <1080758108.1804.18.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:28669 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262329AbUCaTZt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Mar 2004 14:25:49 -0500
In-Reply-To: <1080758108.1804.18.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wednesday 31 March 2004 10:35 am, James Bottomley wrote:
> On Tue, 2003-10-07 at 16:18, Daniel Stekloff wrote:
> > +#define sdev_printk(level, sdev, format, arg...) \
> > +	printk(level "scsi <%s>: " format , (sdev)->sdev_gendev.bus_id , ##
> > arg) +
>
> OK, after six months, I've reconsidered on this one.
>
> Make it #define to dev_printk() and it can go in.


Hi James,

One of the reasons why I didn't make this a #define to dev_printk() in the 
first place was because dev_printk() references "(dev)->driver->name", which 
isn't always valid when sdev_printk() is used. Please see scsi_scan.c as an 
example. The dev_printk() macro has that limitation. 

How would you like to proceed? 

1) Make the #define to dev_printk and only use sdev_printk in situations where 
struct device_driver is valid? This will reduce the number of places it can 
be used.

2) Keep sdev_printk() as is.

3) Create a check in the macro to see if dev->driver is valid.

4) Don't use sdev_printk().

I've noticed a number of patches lately that print out SCSI device information 
and believe this macro is useful for cleaning things up a bit and providing a 
standard format for sdev information. 

Sorry this isn't a slam dunk.

Thanks,

Dan



