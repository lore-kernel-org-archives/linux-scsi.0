From: "Jan Beulich" <JBeulich@suse.com>
Subject: [PATCH] xen-scsiback: prefer xenbus_write() over
 xenbus_printf() where possible
Date: Thu, 07 Jul 2016 02:02:16 -0600
Message-ID: <577E28A802000078000FBF14@prv-mh.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prv-mh.provo.novell.com ([137.65.248.74]:41118 "EHLO
	prv-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbcGGICQ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-scsi@vger.kernel.org:3:1>);
	Thu, 7 Jul 2016 04:02:16 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Juergen Gross <JGross@suse.com>
Cc: xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org

... as being the simpler variant.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
 drivers/xen/xen-scsiback.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- 4.7-rc6-prefer-xenbus_write.orig/drivers/xen/xen-scsiback.c
+++ 4.7-rc6-prefer-xenbus_write/drivers/xen/xen-scsiback.c
@@ -1260,8 +1260,8 @@ static int scsiback_probe(struct xenbus_
 	INIT_LIST_HEAD(&info->v2p_entry_lists);
 	spin_lock_init(&info->v2p_lock);
 
-	err = xenbus_printf(XBT_NIL, dev->nodename, "feature-sg-grant", "%u",
-			    SG_ALL);
+	err = xenbus_write(XBT_NIL, dev->nodename, "feature-sg-grant",
+			   __stringify(SG_ALL));
 	if (err)
 		xenbus_dev_error(dev, err, "writing feature-sg-grant");
 



