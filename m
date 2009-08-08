From: Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] SCSI: pcmcia, fix buf overflow
Date: Sat,  8 Aug 2009 11:36:06 +0200
Message-ID: <1249724166-1150-1-git-send-email-jirislaby@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from server1.wserver.cz ([82.113.45.157]:58265 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933770AbZHHJf6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Aug 2009 05:35:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>

In nsp_cs_config there is a wrong struct nsp_cs_configdata allocation.
It allocates only sizeof(pointer to nsp_cs_configdata) for a whole
structure. Add a dereference to the sizeof to allocate
sizeof(nsp_cs_configdata).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
---
 drivers/scsi/pcmcia/nsp_cs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 70b60ad..e32c344 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -1713,7 +1713,7 @@ static int nsp_cs_config(struct pcmcia_device *link)
 
 	nsp_dbg(NSP_DEBUG_INIT, "in");
 
-	cfg_mem = kzalloc(sizeof(cfg_mem), GFP_KERNEL);
+	cfg_mem = kzalloc(sizeof(*cfg_mem), GFP_KERNEL);
 	if (!cfg_mem)
 		return -ENOMEM;
 	cfg_mem->data = data;
-- 
1.6.3.3

