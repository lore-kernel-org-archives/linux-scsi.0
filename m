From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] xen-scsiback: clean up a type issue in scsiback_make_tpg()
Date: Mon, 8 Sep 2014 14:17:35 +0300
Message-ID: <20140908111735.GB6947@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18165 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaIHLS0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Sep 2014 07:18:26 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Juergen Gross <jgross@suse.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

This code was confusing because we had an unsigned long and then we
compared it to UINT_MAX and then we stored it in a u16.  How many bytes
is this supposed to have: 2, 4 or 16???

I've made it a u16 throughout.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 7b565632..ad11258 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1885,13 +1885,14 @@ scsiback_make_tpg(struct se_wwn *wwn,
 			struct scsiback_tport, tport_wwn);
 
 	struct scsiback_tpg *tpg;
-	unsigned long tpgt;
+	u16 tpgt;
 	int ret;
 
 	if (strstr(name, "tpgt_") != name)
 		return ERR_PTR(-EINVAL);
-	if (kstrtoul(name + 5, 10, &tpgt) || tpgt > UINT_MAX)
-		return ERR_PTR(-EINVAL);
+	ret = kstrtou16(name + 5, 10, &tpgt);
+	if (ret)
+		return ERR_PTR(ret);
 
 	tpg = kzalloc(sizeof(struct scsiback_tpg), GFP_KERNEL);
 	if (!tpg)
