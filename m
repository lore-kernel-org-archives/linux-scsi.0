From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] aic79xx should be able to ignore HostRAID enabled adapters
Date: Thu, 01 Dec 2005 01:41:40 -0500
Message-ID: <438E9B24.9020806@pobox.com>
References: <438E90DD.3010007@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:51136 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932096AbVLAGlq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2005 01:41:46 -0500
In-Reply-To: <438E90DD.3010007@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Chris McDermott <lcm@us.ibm.com>, Luvella McFadden <luvella@us.ibm.com>, AJ Johnson <blujuice@us.ibm.com>, Kevin Stansell <kstansel@us.ibm.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Darrick J. Wong wrote:
> Hi there,
> 
> I have an IBM x346 with some Adaptec 7902 SCSI controllers; one has HostRAID
> enabled in a RAID array, and the other does not.  Upon bootup, the aic79xx
> driver will grab both controllers even though I'd prefer that Adaptec's a320raid
> driver grab the HostRAID controller.  (When attached to the RAID array, the
> aic79xx driver presents each drive in the array as a separate SCSI device.)  If
> HostRAID is turned on, the PCI class code is 0x0104 (RAID) and if it's turned
> off, the class code is 0x0100 (SCSI).
> 
> Unfortunately, there currently is no provision in the aic79xx driver to ignore
> RAID controllers--if the PCI device/vendor IDs match, the driver takes the
> controller.

This is the correct behavior.  Under Linux, the driver should export 
only the underlying hardware, and nothing more.  This is how all the 
SATA controller drivers function, and this is how aic79xx functions.

Use a tool such as 'dmraid' for vendor-proprietary RAID solutions.

Your patch is therefore strongly NAK'd.

	Jeff



