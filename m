From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Remove lasi700.h
Date: Wed, 29 Dec 2004 20:19:56 +0000
Message-ID: <20041229201956.GB18338@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:13461 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261405AbUL2UT5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Dec 2004 15:19:57 -0500
Received: from willy by www.linux.org.uk with local (Exim 4.33)
	id 1CjkIW-0005hn-Gp
	for linux-scsi@vger.kernel.org; Wed, 29 Dec 2004 20:19:56 +0000
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Inline lasi700.h into lasi700.c to cut down on the size of the
drivers/scsi directory.

diff -urpNX dontdiff linus-2.6/drivers/scsi/lasi700.c parisc-2.6/drivers/scsi/lasi700.c
--- linus-2.6/drivers/scsi/lasi700.c	2004-12-26 14:03:10.000000000 -0700
+++ parisc-2.6/drivers/scsi/lasi700.c	2004-12-24 16:39:59.000000000 -0700
@@ -54,13 +54,33 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_spi.h>
 
-#include "lasi700.h"
 #include "53c700.h"
 
 MODULE_AUTHOR("James Bottomley");
 MODULE_DESCRIPTION("lasi700 SCSI Driver");
 MODULE_LICENSE("GPL");
 
+#define LASI_700_SVERSION 0x00071
+#define LASI_710_SVERSION 0x00082
+
+#define LASI700_ID_TABLE {			\
+	.hw_type	= HPHW_FIO,		\
+	.sversion	= LASI_700_SVERSION,	\
+	.hversion	= HVERSION_ANY_ID,	\
+	.hversion_rev	= HVERSION_REV_ANY_ID,	\
+}
+
+#define LASI710_ID_TABLE {			\
+	.hw_type	= HPHW_FIO,		\
+	.sversion	= LASI_710_SVERSION,	\
+	.hversion	= HVERSION_ANY_ID,	\
+	.hversion_rev	= HVERSION_REV_ANY_ID,	\
+}
+
+#define LASI700_CLOCK	25
+#define LASI710_CLOCK	40
+#define LASI_SCSI_CORE_OFFSET 0x100
+
 static struct parisc_device_id lasi700_ids[] = {
 	LASI700_ID_TABLE,
 	LASI710_ID_TABLE,
diff -urpNX dontdiff linus-2.6/drivers/scsi/lasi700.h parisc-2.6/drivers/scsi/lasi700.h
--- linus-2.6/drivers/scsi/lasi700.h	2004-12-26 14:03:10.000000000 -0700
+++ parisc-2.6/drivers/scsi/lasi700.h	1969-12-31 17:00:00.000000000 -0700
@@ -1,49 +0,0 @@
-/* -*- mode: c; c-basic-offset: 8 -*- */
-
-/* PARISC LASI driver for the 53c700 chip
- *
- * Copyright (C) 2001 by James.Bottomley@HansenPartnership.com
-**-----------------------------------------------------------------------------
-**  
-**  This program is free software; you can redistribute it and/or modify
-**  it under the terms of the GNU General Public License as published by
-**  the Free Software Foundation; either version 2 of the License, or
-**  (at your option) any later version.
-**
-**  This program is distributed in the hope that it will be useful,
-**  but WITHOUT ANY WARRANTY; without even the implied warranty of
-**  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-**  GNU General Public License for more details.
-**
-**  You should have received a copy of the GNU General Public License
-**  along with this program; if not, write to the Free Software
-**  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-**
-**-----------------------------------------------------------------------------
- */
-
-#ifndef _LASI700_H
-#define _LASI700_H
-
-#define LASI_710_SVERSION	0x082
-#define LASI_700_SVERSION	0x071
-
-#define LASI700_ID_TABLE {			\
-	.hw_type	= HPHW_FIO,		\
-	.sversion	= LASI_700_SVERSION,	\
-	.hversion	= HVERSION_ANY_ID,	\
-	.hversion_rev	= HVERSION_REV_ANY_ID,	\
-}
-
-#define LASI710_ID_TABLE {			\
-	.hw_type	= HPHW_FIO,		\
-	.sversion	= LASI_710_SVERSION,	\
-	.hversion	= HVERSION_ANY_ID,	\
-	.hversion_rev	= HVERSION_REV_ANY_ID,	\
-}
-
-#define LASI700_CLOCK	25
-#define LASI710_CLOCK	40
-#define LASI_SCSI_CORE_OFFSET 0x100
-
-#endif

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
