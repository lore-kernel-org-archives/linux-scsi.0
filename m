From: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: dead CONFIG_ variables:  drivers/scsi/
Date: Thu, 3 May 2007 07:17:34 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0705030713210.680@localhost.localdomain>
References: <Pine.LNX.4.64.0705030606570.32341@localhost.localdomain>
 <20070503111113.GC12018@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nic.NetDirect.CA ([216.16.235.2]:50974 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbXECLSP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 May 2007 07:18:15 -0400
In-Reply-To: <20070503111113.GC12018@flint.arm.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Thu, 3 May 2007, Russell King wrote:

> On Thu, May 03, 2007 at 06:10:28AM -0400, Robert P. J. Day wrote:
> >
> > $ ../dead_config.sh drivers/scsi
> > ========== ACORNSCSI_CONSTANTS ==========
> > drivers/scsi/arm/acornscsi.c:106:#undef CONFIG_ACORNSCSI_CONSTANTS
> > drivers/scsi/arm/acornscsi.c:417:#ifdef CONFIG_ACORNSCSI_CONSTANTS
> > drivers/scsi/arm/acornscsi.c:495:#ifdef CONFIG_ACORNSCSI_CONSTANTS
> > ========== SCSI_ACORNSCSI_LINK ==========
> > drivers/scsi/arm/acornscsi.c:70:#undef CONFIG_SCSI_ACORNSCSI_LINK
> > drivers/scsi/arm/acornscsi.c:169:#ifdef CONFIG_SCSI_ACORNSCSI_LINK
> > drivers/scsi/arm/acornscsi.c:1675:#ifdef CONFIG_SCSI_ACORNSCSI_LINK
> > drivers/scsi/arm/acornscsi.c:2849:#ifdef CONFIG_SCSI_ACORNSCSI_LINK
> > drivers/scsi/arm/acornscsi.c:2880:#ifdef CONFIG_SCSI_ACORNSCSI_LINK
>
> False positives.  That #undef is preceded by a comment describing the
> driver-internal configuration for developers rather than users.  I
> guess they shouldn't be preceded by CONFIG_.

i've already admitted that this script is going to generate false
positives for a number of reasons, the most common one being using the
"CONFIG_" prefix outside the context of Kconfig.

technically, of course, that doesn't hurt but it sure would make the
code clearer if that prefix was officially reserved for Kconfig stuff.

rday

p.s.  "CONFIG_" prefix aside, i would think it's also a bit yucky to
be checking for the definition of a preprocessor symbol that you've
already hardcoded out of existence in the same source file.  :-)

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
