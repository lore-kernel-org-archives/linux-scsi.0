From: Matthew Wilcox <willy@debian.org>
Subject: Unification of the SCSI Kconfig menus
Date: Fri, 30 May 2003 13:53:18 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030530125318.GK28581@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:51076 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263620AbTE3Mj7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 May 2003 08:39:59 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Janitors <kernel-janitor-discuss@lists.sourceforge.net>


$ for i in arch/*/Kconfig; do if ! grep 'drivers/scsi/Kconfig' $i >/dev/null; then echo $i; fi; done
arch/h8300/Kconfig
arch/m68k/Kconfig
arch/sparc/Kconfig
arch/sparc64/Kconfig
arch/um/Kconfig

h8300 can be excused since it doesn't support SCSI or PCI.  But at
least large chunks of the existing drivers/scsi/Kconfig file are
appropriate to the other architectures.

I think it would be useful to split the existing drivers/scsi/Kconfig into
drivers/scsi/Kconfig_core and drivers/scsi/Kconfig_drivers.  That allows
um to use Kconfig_core without using the drivers.

sparc probably should be converted to use both bits -- imagine if someone
put a symbios card in a JavaStation PCI slot.  Many of the driver entries
in drivers/scsi/Kconfig need tidying up to depend on PCI or ISA.

sparc64 & m68k definitely need their custom menu options moved to
drivers/scsi/Kconfig.

Volunteer?  This is a good way to get started hacking the Kconfig system.

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
