From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: UBSAN: Undefined behaviour in
 drivers/scsi/aic7xxx/aic7xxx_core.c:2831:31
Date: Thu, 12 May 2016 13:08:30 -0700
Message-ID: <1463083710.2380.46.camel@linux.vnet.ibm.com>
References: <alpine.LRH.2.20.1605121859240.4797@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:49961 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbcELUIj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2016 16:08:39 -0400
Received: from localhost
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
	Thu, 12 May 2016 14:08:38 -0600
In-Reply-To: <alpine.LRH.2.20.1605121859240.4797@math.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Thu, 2016-05-12 at 19:02 +0300, Meelis Roos wrote:
> This is from a dual-AthlonMP 32-bit x86 system with onboard Adaptec
> SCSI 
> controller, once during bootup.
> 
> [    4.896307]
> =====================================================================
> ===========
> [    4.896471] UBSAN: Undefined behaviour in
> drivers/scsi/aic7xxx/aic7xxx_core.c:2831:31
> [    4.896629] shift exponent -1 is negative

Is this some sort of false positive?  The shift in question is

	devinfo->target_mask = (0x01 << devinfo->target_offset);

The code which calls this in ahc_linux_initialize_scsi_bus() looks to
be looping from 0-16 (or variations).  Since the value passed in is
unsigned, it would have to be set to ~0, which doesn't seem possible.

James

