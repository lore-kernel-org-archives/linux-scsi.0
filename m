From: Dan Carpenter <error27@gmail.com>
Subject: [patch] pcmcia: add important if statement
Date: Mon, 15 Mar 2010 11:25:10 +0300
Message-ID: <20100315082510.GH18181@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:5630 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759866Ab0COIZX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2010 04:25:23 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, Karsten Keil <keil@b1-systems.de>, Magnus Damm <damm@opensource.se>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>

There was a problem introduced in Jul 2008 by:
0e6f9d270840 pcmcia: use pcmcia_loop_config in scsi pcmcia drivers

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index c2341af..0212464 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -1717,6 +1717,7 @@ static int nsp_cs_config(struct pcmcia_device *link)
 	cfg_mem->data = data;
 
 	ret = pcmcia_loop_config(link, nsp_cs_config_check, cfg_mem);
+	if (ret)
 		goto cs_failed;
 
 	if (link->conf.Attributes & CONF_ENABLE_IRQ) {
