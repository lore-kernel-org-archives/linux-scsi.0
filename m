From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: ATTO 6G SAS/SATA HBA Driver
Date: Tue, 03 Sep 2013 12:30:12 -0700
Message-ID: <1378236612.2064.43.camel@dabdike.int.hansenpartnership.com>
References: <52261855.7050503@attotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60798 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760592Ab3ICTaO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Sep 2013 15:30:14 -0400
In-Reply-To: <52261855.7050503@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bradley Grove <bgrove@attotech.com>
Cc: linux-scsi@vger.kernel.org, Jason Seba <jseba@attotech.com>

On Tue, 2013-09-03 at 13:11 -0400, Bradley Grove wrote:
> James,
> 
> Now that we are finishing up development for our esas2r driver, we are 
> planning to start work on a kernel driver for our PM8001 based 6G 
> SAS/SATA HBA product.  We have some questions about the best way to proceed.
> 
> While we haven't done thorough testing, our hardware appears to work 
> with the existing PM8001 kernel driver.   The problem is that the 
> existing kernel driver doesn't support all the features of the hardware 
> or match the feature set of the current closed source driver.

It depends what the features are.

>  For  example, our closed source driver supports SES emulation over
> I2C and SGPIO.

Well, this one wouldn't be acceptable in the pm8001 driver, but if you
wanted to add it to a more appropriate one: like sgpio support to the
in-kernel ses driver.  I2C is probably a little harder because it needs
to be added somewhere in the I2C subsystem.

> Our closed source driver also has custom PHY settings to support 
> longer cable lengths.

If other drivers are likely to have something similar, then we could put
this in the sas transport class, otherwise driver sysfs files would be
the way to go.

> We also have a set of propriety management tools we'd like to work
> with the open source driver, though it looks like the  PM8001's sysfs
> interface provides most of the functionality we need.
> 
> What are our options for supporting these features?  I see that Adaptec 
> had an out-of-tree driver for their PM8001 card that supports additional 
> features.   We'd prefer to have a kernel driver that fully supports our 
> hardware, either based on the existing PM8001 driver or our closed 
> source code base.   Is that possible?

So the best option is figuring out how to add the features you need to
Linux, which doesn't necessarily mean adding them to this particular
driver.

James




