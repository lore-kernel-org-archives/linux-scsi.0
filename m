From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2 23/24] hpsa: return -ENOMEM not -1 on kzalloc failure in
	hpsa_get_device_id
Date: Thu, 29 May 2014 10:54:20 -0500
Message-ID: <20140529155420.8180.63726.stgit@beardog.cce.hp.com>
References: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:37911 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965177AbaE2Pzu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2014 11:55:50 -0400
Received: from g4t3425.houston.hp.com (g4t3425.houston.hp.com [15.201.208.53])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id B8D5E615D9
	for <linux-scsi@vger.kernel.org>; Thu, 29 May 2014 15:55:49 +0000 (UTC)
In-Reply-To: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@parallels.com
Cc: webb.scales@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, justin.lindley@hp.com, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com, hch@lst.de, dan.carpenter@oracle.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Mike Miller <michael.miller@canonical.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c5b24e6..af51e7d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2430,7 +2430,7 @@ static int hpsa_get_device_id(struct ctlr_info *h, unsigned char *scsi3addr,
 		buflen = 16;
 	buf = kzalloc(64, GFP_KERNEL);
 	if (!buf)
-		return -1;
+		return -ENOMEM;
 	rc = hpsa_scsi_do_inquiry(h, scsi3addr, VPD_PAGE | 0x83, buf, 64);
 	if (rc == 0)
 		memcpy(device_id, &buf[8], buflen);

