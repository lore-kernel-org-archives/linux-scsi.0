Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBD31C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:20:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344189AbiA1WUn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:20:43 -0500
Received: from mail-pj1-f46.google.com ([209.85.216.46]:46835 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241593AbiA1WUm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:20:42 -0500
Received: by mail-pj1-f46.google.com with SMTP id oa14-20020a17090b1bce00b001b61aed4a03so6405367pjb.5
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:20:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R3/F5SDhLAjnFZccXl2J1wDN8CC5ppY4oiBvHUVG8h8=;
        b=tL0cCYW8aZi27CMBarW80I1bjqpsTyiTvYI8HCWeHAiY6q11at39knU0hb5ZRyCqoU
         HZaAv6K9YULcEn7YIkZ4hLDLkKNBqJmaKE8355F1Xz6bWxWxNSH7AoL+Q0g77GkeL19T
         tx8tKdxN22ezftKDi9SeADGu2WXKgs5sQur3eBc0d8CIQixct794SoWHmTcUaDuJTATL
         g3VkbUImNjoWsRMO4zzQetE0RM7tvUdH+Zj3sRbScAnYxqK967PmOvrNxlLVrj7RZt/F
         xralQuWEVjSpWdha/5FZ5I1/P4V2db1LwOP7TAuXF7kX8bE4tnpUSi3qL3YvdlMVE0Mz
         enAA==
X-Gm-Message-State: AOAM5336L23qXd/QrBzICDsiu7V/o+ccdBPNpvYC9xTaa60A9sivilke
        6QV3Tj+53j8I4KI8LQSSbi8=
X-Google-Smtp-Source: ABdhPJwRrzwTgl1Cv5/EuVQLVwPG98ak2t7apbTF3lVd5JlmLeeKj+Gt9JdlE+JQOPgBO5SuZyMwKg==
X-Received: by 2002:a17:90a:4610:: with SMTP id w16mr21216428pjg.175.1643408442300;
        Fri, 28 Jan 2022 14:20:42 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:20:41 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        Russell King <linux@armlinux.org.uk>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 03/44] scsi: Remove drivers/scsi/scsi.h
Date:   Fri, 28 Jan 2022 14:18:28 -0800
Message-Id: <20220128221909.8141-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128221909.8141-1-bvanassche@acm.org>
References: <20220128221909.8141-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following two header files have the same file name: include/scsi/scsi.h
and drivers/scsi/scsi.h. This is confusing. Remove the latter since the
following note was added in drivers/scsi/scsi.h in 2004:

"NOTE: this file only contains compatibility glue for old drivers. All
these wrappers will be removed sooner or later. For new code please use
the interfaces declared in the headers in include/scsi/"

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/a2091.c               |  6 +++-
 drivers/scsi/a3000.c               |  6 +++-
 drivers/scsi/aha152x.c             |  9 ++++--
 drivers/scsi/aha1740.c             |  6 +++-
 drivers/scsi/arm/acornscsi.c       |  6 +++-
 drivers/scsi/arm/arxescsi.c        |  6 +++-
 drivers/scsi/arm/cumana_2.c        |  6 +++-
 drivers/scsi/arm/eesox.c           |  6 +++-
 drivers/scsi/arm/fas216.c          |  6 +++-
 drivers/scsi/arm/powertec.c        |  6 +++-
 drivers/scsi/arm/queue.c           |  6 +++-
 drivers/scsi/gvp11.c               |  6 +++-
 drivers/scsi/ips.c                 |  8 ++++--
 drivers/scsi/megaraid.c            |  8 ++++--
 drivers/scsi/mvme147.c             |  6 +++-
 drivers/scsi/pcmcia/aha152x_stub.c | 10 +++++--
 drivers/scsi/pcmcia/nsp_cs.c       |  5 ++--
 drivers/scsi/pcmcia/qlogic_stub.c  | 10 +++++--
 drivers/scsi/qlogicfas.c           |  6 +++-
 drivers/scsi/qlogicfas408.c        |  6 +++-
 drivers/scsi/scsi.h                | 46 ------------------------------
 drivers/scsi/sg.c                  |  8 ++++--
 drivers/scsi/sgiwd93.c             |  6 +++-
 drivers/usb/image/microtek.c       |  8 ++++--
 drivers/usb/storage/debug.c        |  1 -
 25 files changed, 121 insertions(+), 82 deletions(-)
 delete mode 100644 drivers/scsi/scsi.h

diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index 5853db36eceb..bcbce23478b8 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -12,7 +12,11 @@
 #include <asm/amigaints.h>
 #include <asm/amigahw.h>
 
-#include "scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_tcq.h>
 #include "wd33c93.h"
 #include "a2091.h"
 
diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index 86f1da22aaa5..23f34411f7bf 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -13,7 +13,11 @@
 #include <asm/amigaints.h>
 #include <asm/amigahw.h>
 
-#include "scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_tcq.h>
 #include "wd33c93.h"
 #include "a3000.h"
 
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index d17880b57d17..901b78e8ffe6 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -243,13 +243,16 @@
 #include <linux/workqueue.h>
 #include <linux/list.h>
 #include <linux/slab.h>
-#include <scsi/scsicam.h>
 
-#include "scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
 #include <scsi/scsi_transport_spi.h>
-#include <scsi/scsi_eh.h>
+#include <scsi/scsicam.h>
 #include "aha152x.h"
 
 static LIST_HEAD(aha152x_host_list);
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index 18eb4cfcef9a..134255751819 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -55,8 +55,12 @@
 #include <asm/dma.h>
 #include <asm/io.h>
 
-#include "scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
 #include "aha1740.h"
 
 /* IF YOU ARE HAVING PROBLEMS WITH THIS DRIVER, AND WANT TO WATCH
diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 81eb3bbdfc51..a8a72d822862 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -126,9 +126,13 @@
 
 #include <asm/ecard.h>
 
-#include "../scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
 #include <scsi/scsi_transport_spi.h>
 #include "acornscsi.h"
 #include "msgqueue.h"
diff --git a/drivers/scsi/arm/arxescsi.c b/drivers/scsi/arm/arxescsi.c
index 7f667c198f6d..2527b542bcdd 100644
--- a/drivers/scsi/arm/arxescsi.c
+++ b/drivers/scsi/arm/arxescsi.c
@@ -35,8 +35,12 @@
 #include <asm/io.h>
 #include <asm/ecard.h>
 
-#include "../scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
 #include "fas216.h"
 
 struct arxescsi_info {
diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
index 3c00d7773876..536d6646e40b 100644
--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -29,8 +29,12 @@
 #include <asm/ecard.h>
 #include <asm/io.h>
 
-#include "../scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
 #include "fas216.h"
 #include "scsi.h"
 
diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
index 1394590eecea..ab0f6422a6a9 100644
--- a/drivers/scsi/arm/eesox.c
+++ b/drivers/scsi/arm/eesox.c
@@ -35,8 +35,12 @@
 #include <asm/dma.h>
 #include <asm/ecard.h>
 
-#include "../scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
 #include "fas216.h"
 #include "scsi.h"
 
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 7019b91f0ce6..0d6df5ebf934 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -47,9 +47,13 @@
 #include <asm/irq.h>
 #include <asm/ecard.h>
 
-#include "../scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
 #include "fas216.h"
 #include "scsi.h"
 
diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
index 8fec435cee18..797568b271e3 100644
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -20,8 +20,12 @@
 #include <asm/ecard.h>
 #include <asm/io.h>
 
-#include "../scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
 #include "fas216.h"
 #include "scsi.h"
 
diff --git a/drivers/scsi/arm/queue.c b/drivers/scsi/arm/queue.c
index c6f71a7d1b8e..978df23ce188 100644
--- a/drivers/scsi/arm/queue.c
+++ b/drivers/scsi/arm/queue.c
@@ -20,7 +20,11 @@
 #include <linux/list.h>
 #include <linux/init.h>
 
-#include "../scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_tcq.h>
 
 #define DEBUG
 
diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 727f8c8f30b5..43754c2f36b3 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -12,7 +12,11 @@
 #include <asm/amigaints.h>
 #include <asm/amigahw.h>
 
-#include "scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_tcq.h>
 #include "wd33c93.h"
 #include "gvp11.h"
 
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index b3532d290848..021143bdee5f 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -180,9 +180,13 @@
 #include <linux/types.h>
 #include <linux/dma-mapping.h>
 
-#include <scsi/sg.h>
-#include "scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
+#include <scsi/sg.h>
 
 #include "ips.h"
 
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index bf987f3a7f3f..2061e3fe9824 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -44,10 +44,14 @@
 #include <linux/dma-mapping.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
-#include <scsi/scsicam.h>
 
-#include "scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
+#include <scsi/scsicam.h>
 
 #include "megaraid.h"
 
diff --git a/drivers/scsi/mvme147.c b/drivers/scsi/mvme147.c
index 869b8b058a43..0893d4c3a916 100644
--- a/drivers/scsi/mvme147.c
+++ b/drivers/scsi/mvme147.c
@@ -11,8 +11,12 @@
 #include <asm/mvme147hw.h>
 #include <asm/irq.h>
 
-#include "scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
 #include "wd33c93.h"
 #include "mvme147.h"
 
diff --git a/drivers/scsi/pcmcia/aha152x_stub.c b/drivers/scsi/pcmcia/aha152x_stub.c
index df82a349e969..332c6d573904 100644
--- a/drivers/scsi/pcmcia/aha152x_stub.c
+++ b/drivers/scsi/pcmcia/aha152x_stub.c
@@ -40,13 +40,17 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/ioport.h>
-#include <scsi/scsi.h>
 #include <linux/major.h>
 #include <linux/blkdev.h>
-#include <scsi/scsi_ioctl.h>
 
-#include "scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_ioctl.h>
+#include <scsi/scsi_tcq.h>
 #include "aha152x.h"
 
 #include <pcmcia/cistpl.h>
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index a78a86511e94..dcffda384eaf 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -41,10 +41,9 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 
-#include <../drivers/scsi/scsi.h>
-#include <scsi/scsi_host.h>
-
 #include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
 
 #include <pcmcia/cistpl.h>
diff --git a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlogic_stub.c
index 828d53faf09a..1c21d1b12988 100644
--- a/drivers/scsi/pcmcia/qlogic_stub.c
+++ b/drivers/scsi/pcmcia/qlogic_stub.c
@@ -38,14 +38,18 @@
 #include <linux/string.h>
 #include <linux/ioport.h>
 #include <asm/io.h>
-#include <scsi/scsi.h>
 #include <linux/major.h>
 #include <linux/blkdev.h>
-#include <scsi/scsi_ioctl.h>
 #include <linux/interrupt.h>
 
-#include "scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_ioctl.h>
+#include <scsi/scsi_tcq.h>
 #include "../qlogicfas408.h"
 
 #include <pcmcia/cistpl.h>
diff --git a/drivers/scsi/qlogicfas.c b/drivers/scsi/qlogicfas.c
index 8f709002f746..8f05e3707d69 100644
--- a/drivers/scsi/qlogicfas.c
+++ b/drivers/scsi/qlogicfas.c
@@ -31,8 +31,12 @@
 #include <asm/irq.h>
 #include <asm/dma.h>
 
-#include "scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
 #include "qlogicfas408.h"
 
 /* Set the following to 2 to use normal interrupt (active high/totempole-
diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
index 30a88849a626..3e065d5fc80c 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -55,8 +55,12 @@
 #include <asm/irq.h>
 #include <asm/dma.h>
 
-#include "scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
 #include "qlogicfas408.h"
 
 /*----------------------------------------------------------------*/
diff --git a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
deleted file mode 100644
index 4fd75a3aff66..000000000000
--- a/drivers/scsi/scsi.h
+++ /dev/null
@@ -1,46 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- *  scsi.h Copyright (C) 1992 Drew Eckhardt 
- *         Copyright (C) 1993, 1994, 1995, 1998, 1999 Eric Youngdale
- *  generic SCSI package header file by
- *      Initial versions: Drew Eckhardt
- *      Subsequent revisions: Eric Youngdale
- *
- *  <drew@colorado.edu>
- *
- *       Modified by Eric Youngdale eric@andante.org to
- *       add scatter-gather, multiple outstanding request, and other
- *       enhancements.
- */
-/*
- * NOTE:  this file only contains compatibility glue for old drivers.  All
- * these wrappers will be removed sooner or later.  For new code please use
- * the interfaces declared in the headers in include/scsi/
- */
-
-#ifndef _SCSI_H
-#define _SCSI_H
-
-#include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_device.h>
-#include <scsi/scsi_eh.h>
-#include <scsi/scsi_tcq.h>
-#include <scsi/scsi.h>
-
-/*
- * Some defs, in case these are not defined elsewhere.
- */
-#ifndef TRUE
-#define TRUE 1
-#endif
-#ifndef FALSE
-#define FALSE 0
-#endif
-
-struct Scsi_Host;
-struct scsi_cmnd;
-struct scsi_device;
-struct scsi_target;
-struct scatterlist;
-
-#endif /* _SCSI_H */
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 6b43e97bd417..bbd75026ec93 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -49,11 +49,15 @@ static int sg_version_num = 30536;	/* 2 digits for each component */
 #include <linux/uio.h>
 #include <linux/cred.h> /* for sg_check_file_access() */
 
-#include "scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
-#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_driver.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
+#include <scsi/scsi_tcq.h>
 #include <scsi/sg.h>
 
 #include "scsi_logging.h"
diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index cf1030c9dda1..e797d89c873b 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -28,7 +28,11 @@
 #include <asm/sgi/ip22.h>
 #include <asm/sgi/wd.h>
 
-#include "scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_tcq.h>
 #include "wd33c93.h"
 
 struct ip22_hostdata {
diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index b8dc6fa6a5a3..874ea4b54ced 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -130,11 +130,15 @@
 #include <linux/spinlock.h>
 #include <linux/usb.h>
 #include <linux/proc_fs.h>
-
 #include <linux/atomic.h>
 #include <linux/blkdev.h>
-#include "../../scsi/scsi.h"
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
 
 #include "microtek.h"
 
diff --git a/drivers/usb/storage/debug.c b/drivers/usb/storage/debug.c
index d7f50b7a079e..576be66ad962 100644
--- a/drivers/usb/storage/debug.c
+++ b/drivers/usb/storage/debug.c
@@ -36,7 +36,6 @@
 
 #include "usb.h"
 #include "debug.h"
-#include "scsi.h"
 
 
 void usb_stor_show_command(const struct us_data *us, struct scsi_cmnd *srb)
