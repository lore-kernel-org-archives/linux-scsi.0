From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: generating a Linux WWN?
Date: Fri, 05 Oct 2007 18:09:06 -0400
Message-ID: <1191622146.3475.51.camel@localhost.localdomain>
References: <4703FAB0.10702@garzik.org>
	 <344765.55522.qm@web31815.mail.mud.yahoo.com>
	 <20071003.151729.95504687.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:34059 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754122AbXJEWJJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 18:09:09 -0400
In-Reply-To: <20071003.151729.95504687.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: ltuikov@yahoo.com, jeff@garzik.org, lydianconcepts@gmail.com, mdr@sgi.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org

On Wed, 2007-10-03 at 15:17 -0700, David Miller wrote:
> From: Luben Tuikov <ltuikov@yahoo.com>
> Date: Wed, 3 Oct 2007 15:08:48 -0700 (PDT)
> 
> > Your "want to get their card working" way of view is very
> > simplistic to justify generating and assigning SAS WWN in the kernel.
> > This is the job of the manufacturer/packager, not the host OS.
> 
> When you are thousands of miles away from the data center and lose all
> of your storage and therefore can't boot correctly because the WWN
> info is corrupted, you won't have this unbelievably fascist attitude
> about this problem.
> 
> Give people an _OPTION_!
> 
> This is about as anti-social as when the Intel folks refused to
> themselves put in a driver option to try to use an eepro100 card even
> if the EEPROM was corrupted and had a bad checksum.
> 
> For the person who hits this, it's a big issue to have a way to still
> try to bring things up.
> 
> If you don't provide this, you want people to suffer more than
> necessary when something goes wrong, and that by definition makes you
> an asshole.

The tenor of this debate is becoming slightly heated, so it needs to
cool down a notch.

For the record, what the current in-kernel aic94xx driver does for this
case is allow a parameter override to specify the WWN in the case where
the card burned in one has gone missing or is corrupt.  I think this is
the correctly balanced approach to the problem.

For the record, I pretty much agree completely with Luben's position on
this:  I want to allow the user a method to correct any problem (i.e.
supply a WWN override).  However, I also want them to think about the
issue before they do this.  What I really don't want is the driver
silently correcting what it thinks to be a defective WWN and generating
its own replacement because that's a recipe for disaster on a SAN (SANs
are a lot less robust than networks to duplicate MAC addresses: because
of the way expander routing is done, you can possibly collapse the
entire SAN with duplicate WWNs).

So, the procedure for a SAS card should be:

     1. Obtain the WWN from a device specific storage method (like
        flash)
     2. Replace this with a passed in command line parameter if one
        exists
     3. refuse to attach if there's still no valid WWN and give an
        explicit method saying what the problem is (and possibly how to
        fix it)

James


