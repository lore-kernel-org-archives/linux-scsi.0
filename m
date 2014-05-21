From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2/3] hpsa: return -ENOMEM not -1 on kzalloc failure in
	hpsa_get_device_id
Date: Wed, 21 May 2014 11:16:06 -0500
Message-ID: <20140521161606.14409.63048.stgit@beardog.cce.hp.com>
References: <20140521161600.14409.36072.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t1526.atlanta.hp.com ([15.193.200.69]:60438 "EHLO
	g6t1526.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaEUQQ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 May 2014 12:16:59 -0400
In-Reply-To: <20140521161600.14409.36072.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com, hch@lst.de, dan.carpenter@oracle.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
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

