From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] Convert sym2 to be hotplug-capable
Date: Wed, 13 Aug 2003 09:41:33 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030812234133.GA30156@krispykreme>
References: <20030716210059.GR23808@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:45739 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S271235AbTHLXlm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Aug 2003 19:41:42 -0400
Content-Disposition: inline
In-Reply-To: <20030716210059.GR23808@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org


Hi,

> This patch is on top of the patch I posted yesterday.  It..
>  - Stops using Scsi_Cmnd etc typedefs
>  - Removes the unused Scsi_Host_Template argument from sym53c8xx_pci_init
>  - Converts sym53c8xx_2 to be a hotplug-capable driver

One problem we found when we hit a bad adapter, we need to use scsi_host_put.

James, what are the chances of getting Willy's sym2 fixes in? Its much
more predictable than the current probe order.

Anton

--- gr13_work_miltonm_l4/drivers/scsi/sym53c8xx_2/sym_glue.c~	2003-08-12 18:33:03.000000000 -0500
+++ gr13_work_miltonm_l4/drivers/scsi/sym53c8xx_2/sym_glue.c	2003-08-12 18:33:45.000000000 -0500
@@ -2030,7 +2030,7 @@
 	printf_info("%s: giving up ...\n", sym_name(np));
 	if (np)
 		sym_free_resources(np);
-	scsi_unregister(instance);
+	scsi_host_put(instance);
 
         return -1;
  }

