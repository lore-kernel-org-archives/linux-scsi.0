From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] Convert sym2 to be hotplug-capable
Date: Wed, 13 Aug 2003 15:13:52 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030813051352.GB30156@krispykreme>
References: <20030716210059.GR23808@parcelfarce.linux.theplanet.co.uk> <20030812234133.GA30156@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:18077 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S271389AbTHMFSt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Aug 2003 01:18:49 -0400
Content-Disposition: inline
In-Reply-To: <20030812234133.GA30156@krispykreme>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org

 
> One problem we found when we hit a bad adapter, we need to use scsi_host_put.

One more fix :)

In sym_attach we call sym_hcb_attach. If it fails we call
sym_free_resources which will call sym_hcb_free. Unfortunately
sym_hcb_attach also calls sym_hcb_free on failure.

This results in a bunch of things being freed twice and it looks like
the sym2 memory allocator adds them to the freelist twice. Sometime later
on we allocate the memory twice, with weird consequences.

Anton

diff -ru /tmp/sym53c8xx_2/sym_hipd.c gr13_work_miltonm_l4/drivers/scsi/sym53c8xx_2/sym_hipd.c
--- /tmp/sym53c8xx_2/sym_hipd.c	2003-07-03 13:57:21.000000000 -0500
+++ gr13_work_miltonm_l4/drivers/scsi/sym53c8xx_2/sym_hipd.c	2003-08-12 23:48:37.000000000 -0500
@@ -5942,14 +5943,7 @@
 	 */
 	return 0;
 
-	/*
-	 *  We have failed.
-	 *  We will try to free all the resources we have 
-	 *  allocated, but if we are a boot device, this 
-	 *  will not help that much.;)
-	 */
 attach_failed:
-		sym_hcb_free(np);
 	return -ENXIO;
 }
 
