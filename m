From: Arne Redlich <arne.redlich@xiranet.com>
Subject: [PATCH] trivial scsi_execute_async fix
Date: Sat, 30 Sep 2006 15:49:40 +0200
Message-ID: <20060930134940.GA21089@cheetah>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tnp-online.de ([212.80.247.147]:16548 "EHLO
	relay2.gigamail.to") by vger.kernel.org with ESMTP id S1750963AbWI3NuB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Sep 2006 09:50:01 -0400
Received: from scanner5.gigamail.to (content5.cluster.gigamail.to [192.168.254.200])
	by mxout2.gigamail.to (Postfix) with ESMTP id 10375ABB07
	for <linux-scsi@vger.kernel.org>; Sat, 30 Sep 2006 15:49:55 +0200 (CEST)
Received: from chimp.subsystem.local (content5.cluster.gigamail.to [192.168.254.200])
	by chimp.scanner5.gigamail.to (Postfix) with ESMTP id E626B9087C
	for <linux-scsi@vger.kernel.org>; Sat, 30 Sep 2006 15:49:54 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by chimpgate.scanner1.gigamail.to (Postfix) with ESMTP id 7EA68908F7
	for <linux-scsi@vger.kernel.org>; Sat, 30 Sep 2006 15:49:54 +0200 (CEST)
Received: from scanner5.gigamail.to ([127.0.0.1])
 by localhost (scanner5.gigamail.to [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 31446-16 for <linux-scsi@vger.kernel.org>;
 Sat, 30 Sep 2006 15:49:54 +0200 (CEST)
Received: from relay1.gigamail.to (relay1.cluster.gigamail.to [192.168.254.12])
	by scanner5.gigamail.to (Postfix) with ESMTP id 6D0C19087C
	for <linux-scsi@vger.kernel.org>; Sat, 30 Sep 2006 15:49:54 +0200 (CEST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

In scsi_execute_async()'s error path, a struct scsi_io_context
allocated with kmem_cache_alloc() is kfree()'d. Obviously
kmem_cache_free() should be used instead.

Signed-off-by: Arne Redlich <arne.redlich@xiranet.com>

diff -prauN a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	2006-09-20 13:59:29.389895000 +0200
+++ b/drivers/scsi/scsi_lib.c	2006-09-30 15:11:36.458871925 +0200
@@ -424,7 +424,7 @@ int scsi_execute_async(struct scsi_devic
 free_req:
 	blk_put_request(req);
 free_sense:
-	kfree(sioc);
+	kmem_cache_free(scsi_io_context_cache, sioc);
 	return DRIVER_ERROR << 24;
 }
 EXPORT_SYMBOL_GPL(scsi_execute_async);
