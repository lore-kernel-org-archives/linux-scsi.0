From: Stephan Seidl <stephan.seidl@tu-dresden.de>
Subject: broken reverse_scan in aic7xxx
Date: Sat, 8 Jul 2006 17:21:59 +0200 (MEST)
Message-ID: <Pine.GSO.3.95.1060708171547.28320A-100000@rcs52.urz.tu-dresden.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from RKS36.urz.tu-dresden.de ([141.30.66.166]:9625 "EHLO
	mailgate.urz.tu-dresden.de") by vger.kernel.org with ESMTP
	id S964861AbWGHPWB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Jul 2006 11:22:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: stephan.seidl@tu-dresden.de


Hallo,
between the Linux versions 2.6.8 and 2.6.14, anybody cleaned up
the code of `linux/drivers/scsi/aic7xxx/aic7xxx_osm.c'.
The Kernel 2.6.8 I refer to came with Debian Sarge.

$ ls -al linux-2.6.8-16s/drivers/scsi/aic7xxx/aic7xxx_osm.c
-rw-r--r--  1 seidl seidl 143292 May 19  2005 linux-2.6.8-16s/drivers/scsi/aic7xxx/aic7xxx_osm.c
$ ls -al linux-2.6.14.3/drivers/scsi/aic7xxx/aic7xxx_osm.c
-rw-r--r--  1 seidl seidl 74505 Nov 24  2005 linux-2.6.14.3/drivers/scsi/aic7xxx/aic7xxx_osm.c

A victim of the cleaning operation is the option `aic7xxx=reverse_scan'
which is still documented, but, which does no longer work. Here is some
output.

$ (cd linux-2.6.8-16s/drivers/scsi/aic7xxx && grep reverse_scan *)
aic79xx_osm.c:static uint32_t aic79xx_reverse_scan;
aic79xx_osm.c:" reverse_scan            Sort PCI devices highest Bus/Slot
to lowest\n"
aic79xx_osm.c:  if (aic79xx_reverse_scan != 0)
aic79xx_osm.c:  if (aic79xx_reverse_scan != 0)
aic79xx_osm.c:          { "reverse_scan", &aic79xx_reverse_scan },
aic7xxx_osm.c:static uint32_t aic7xxx_reverse_scan;
aic7xxx_osm.c:" reverse_scan            Sort PCI devices highest Bus/Slot
to lowest\n"
aic7xxx_osm.c:          if (aic7xxx_reverse_scan != 0)
aic7xxx_osm.c:          if (aic7xxx_reverse_scan != 0)
aic7xxx_osm.c:          { "reverse_scan", &aic7xxx_reverse_scan },

$ (cd linux-2.6.14.3/drivers/scsi/aic7xxx && grep reverse_scan *)
aic79xx_osm.c:static uint32_t aic79xx_reverse_scan;
aic79xx_osm.c:" reverse_scan            Sort PCI devices highest Bus/Slot
to lowest\n"
aic79xx_osm.c:  if (aic79xx_reverse_scan != 0)
aic79xx_osm.c:  if (aic79xx_reverse_scan != 0)
aic79xx_osm.c:          { "reverse_scan", &aic79xx_reverse_scan },
aic7xxx_osm.c:" reverse_scan            Sort PCI devices highest Bus/Slot
to lowest\n"

Since `aic7xxx=reverse_scan' is part of my disaster recovery concept,
I would like to ask whether anybody has the resources to reactivate
this driver option as it was before ?

Kind regards,
Stephan Seidl


