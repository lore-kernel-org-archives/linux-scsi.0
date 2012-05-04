From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH] simscsi breakage in __scsi_alloc_queue()
Date: Fri, 4 May 2012 04:53:13 +0100
Message-ID: <20120504035313.GR6871@ZenIV.linux.org.uk>
References: <f570e9ebfaf5eb31a83808ce7c71e574fa716443.1335913478.git.tony.luck@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:45392 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab2EDDxR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 May 2012 23:53:17 -0400
Content-Disposition: inline
In-Reply-To: <f570e9ebfaf5eb31a83808ce7c71e574fa716443.1335913478.git.tony.luck@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Luck <tony.luck@intel.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <JBottomley@Parallels.com>, Lin Ming <ming.m.lin@intel.com>

With the current mainline we end up oopsing in __scsi_alloc_queue(), since
host->dma_dev is left NULL.  I'm not sure if this is the right fix, but
it gives the behaviour equivalent to what we used to have before
commit 6f381fa344911d5a234b13574433cf23036f9467 ([SCSI] scsi_lib: use
correct DMA device in __scsi_alloc_queue).  And with that applied the
damn thing appears to work correctly...

Current mainline barfs on dma_set_seg_boundary(dev, shost->dma_boundary),
since dev ends up being NULL.  AFAICS, the same problem affects any
driver that does scsi_add_host(host, NULL) and there are other such
beasts as well, so they probably also need fixing...

Again, I'm not sure that this is the right way to deal with that and I'd
prefer to have it reviewed by SCSI folks before it goes into the tree.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/arch/ia64/hp/sim/simscsi.c b/arch/ia64/hp/sim/simscsi.c
index 331de72..fe2b4d0 100644
--- a/arch/ia64/hp/sim/simscsi.c
+++ b/arch/ia64/hp/sim/simscsi.c
@@ -13,6 +13,7 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/timer.h>
+#include <linux/platform_device.h>
 #include <asm/irq.h>
 #include "hpsim_ssc.h"
 
@@ -358,7 +359,7 @@ simscsi_init(void)
 	if (!host)
 		return -ENOMEM;
 
-	error = scsi_add_host(host, NULL);
+	error = scsi_add_host_with_dma(host, NULL, &platform_bus);
 	if (error)
 		goto free_host;
 	scsi_scan_host(host);
