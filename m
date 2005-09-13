From: Dave C Boutcher <sleddog@us.ibm.com>
Subject: [Patch] ibmvscsi compatibility fix
Date: Tue, 13 Sep 2005 10:09:02 -0500
Message-ID: <20050913150902.GA22071@cs.umn.edu>
References: <20050912024350.60e89eb1.akpm@osdl.org> <20050912222437.GA13124@sergelap.austin.ibm.com> <20050912161013.76ef833f.akpm@osdl.org> <20050913013840.GG5382@krispykreme> <20050913085643.GA24156@sergelap.austin.ibm.com>
Reply-To: boutcher@cs.umn.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.34.202]:47342 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S932659AbVIMPJF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 11:09:05 -0400
Content-Disposition: inline
In-Reply-To: <20050913085643.GA24156@sergelap.austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: serue@us.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, lxie@us.ibm.com, santil@us.ibm.com

Linda Xie ever so gently pointed out that she had a patch
to preserve compatibility with older SLES targets, and I told
her we didn't need to push it to mainline.

This patch explicitly checks the version of the IBMVSCSI target
and ensures that large scatterlists are not sent to older 
targets.

Andrew, while this stuff usually goes through James, it would
probably make Serge happier if you could pick it up for the next
mm.  

Signed-off-by: Linda Xie <lxie@us.ibm.com>
Signed-off-by: Dave Boutcher <boutcher@us.ibm.com>

--- linux-2.6.13-mm3-orig/drivers/scsi/ibmvscsi/ibmvscsi.c	2005-09-13 09:50:31.000000000 -0500
+++ linux-2.6.13.1/drivers/scsi/ibmvscsi/ibmvscsi.c	2005-09-13 09:09:41.000000000 -0500
@@ -727,6 +727,16 @@
 		if (hostdata->madapter_info.port_max_txu[0]) 
 			hostdata->host->max_sectors = 
 				hostdata->madapter_info.port_max_txu[0] >> 9;
+		
+		if (hostdata->madapter_info.os_type == 3 &&
+		    strcmp(hostdata->madapter_info.srp_version, "1.6a") <= 0) {
+			printk("ibmvscsi: host (Ver. %s) doesn't support large"
+			       "transfers\n",
+			       hostdata->madapter_info.srp_version);
+			printk("ibmvscsi: limiting scatterlists to %d\n",
+			       MAX_INDIRECT_BUFS);
+			hostdata->host->sg_tablesize = MAX_INDIRECT_BUFS;
+		}
 	}
 }
 
