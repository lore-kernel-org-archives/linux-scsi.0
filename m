From: Dan Carpenter <error27@gmail.com>
Subject: [patch] fusion: fix error handling of mpt_register()
Date: Fri, 6 Aug 2010 08:34:09 +0200
Message-ID: <20100806063409.GO9031@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62895 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab0HFGec (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2010 02:34:32 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <Eric.Moore@lsi.com>
Cc: support@lsi.com, Alexey Dobriyan <adobriyan@gmail.com>, James Bottomley <James.Bottomley@suse.de>, Kashyap Desai <kashyap.desai@lsi.com>, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

mpt_register() returns a positive int between 1 and
MPT_MAX_PROTOCOL_DRIVERS.  It returns MPT_MAX_PROTOCOL_DRIVERS if there
is no slot available.  Most places don't check the return but this is
how it's done in mptctl.c as well.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/message/fusion/mptlan.c b/drivers/message/fusion/mptlan.c
index cbe9607..42affb1 100644
--- a/drivers/message/fusion/mptlan.c
+++ b/drivers/message/fusion/mptlan.c
@@ -1454,7 +1454,7 @@ static int __init mpt_lan_init (void)
 
 	LanCtx = mpt_register(lan_reply, MPTLAN_DRIVER,
 				"lan_reply");
-	if (LanCtx <= 0) {
+	if (LanCtx >= MPT_MAX_PROTOCOL_DRIVERS) {
 		printk (KERN_ERR MYNAM ": Failed to register with MPT base driver\n");
 		return -EBUSY;
 	}
