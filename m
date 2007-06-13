From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 2a/3] Expose Power Management Policy option to users
Date: Wed, 13 Jun 2007 08:26:48 -0700
Message-ID: <1181748408.3421.7.camel@mulgrave.il.steeleye.com>
References: <20070611184146.448266229@intel.com>
	 <20070611114820.5290a903.kristen.c.accardi@intel.com>
	 <466DA9DD.8080004@garzik.org>
	 <20070612104631.44dab4a3.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:57432 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757625AbXFMP0v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jun 2007 11:26:51 -0400
In-Reply-To: <20070612104631.44dab4a3.kristen.c.accardi@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com

On Tue, 2007-06-12 at 10:46 -0700, Kristen Carlson Accardi wrote:
> Expose Power Management Policy option to users
> 
> This patch will modify the scsi subsystem to allow
> users to set a power management policy for the link.
> 
> The scsi subsystem will create a new sysfs file for each
> host in /sys/class/scsi_host called "link_power_management_policy".
> This file can have 3 possible values:

I'm afraid the host isn't really the right place to put the link power
management policy (assuming you want to manage the individual links
separately) because there isn't a one to one correspondence between
links and hosts.

To take the model I understand: SAS; the links are managed at the phy
level, so the power policy should be set there and thus should probably
be a property of the phy object, which doesn't even exist in the SCSI
model, it only exists in the transport class.  It strikes me that even
for ATA, the same thing is probably true.

Now, I can see that the power management models of all the transports
might share some similarities (particularly at this three stage granular
level); if so, it might make sense to export helpers from the mid-layer
for the transport classes to use for this.

> Value		Meaning
> -------------------------------------------------------------------
> min_power	User wishes the link to conserve power as much as
> 		possible, even at the cost of some performance
> 
> max_performance User wants priority to be on performance, not power
> 		savings
> 
> medium_power	User wants power savings, with less performance cost
> 		than min_power (but less power savings as well).

These seem like nicely sane and generic values.

James


