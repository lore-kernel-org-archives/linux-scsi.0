From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH 1/2] sdev_printk - scsi_device helper macro
Date: 31 Mar 2004 14:29:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080761358.2071.35.camel@mulgrave>
References: <200310071318.11847.dsteklof@us.ibm.com>
	<1080758108.1804.18.camel@mulgrave>
	<200403311123.53361.dsteklof@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:60846 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262356AbUCaT3v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Mar 2004 14:29:51 -0500
In-Reply-To: <200403311123.53361.dsteklof@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Daniel Stekloff <dsteklof@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-03-31 at 14:23, Daniel Stekloff wrote:
> One of the reasons why I didn't make this a #define to dev_printk() in the 
> first place was because dev_printk() references "(dev)->driver->name", which 
> isn't always valid when sdev_printk() is used. Please see scsi_scan.c as an 
> example. The dev_printk() macro has that limitation. 
> 
> How would you like to proceed? 
> 
> 1) Make the #define to dev_printk and only use sdev_printk in situations where 
> struct device_driver is valid? This will reduce the number of places it can 
> be used.

I think this is my preferred option.  That only leaves our scanning and
inquiry code as the exception.  It still sweeps up most of the driver
stuff.

It might be possible to improve this situation by initialising the
device earlier too.

> 2) Keep sdev_printk() as is.
> 
> 3) Create a check in the macro to see if dev->driver is valid.
> 
> 4) Don't use sdev_printk().
> 
> I've noticed a number of patches lately that print out SCSI device information 
> and believe this macro is useful for cleaning things up a bit and providing a 
> standard format for sdev information. 

Yes, that's why I dusted this off again.

James


