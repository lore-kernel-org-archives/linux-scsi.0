From: Joe Perches <joe@perches.com>
Subject: [RFC PATCH] hpsa: Change memset using sizeof(ptr) to sizeof(*ptr)
Date: Sun, 08 May 2011 23:32:40 -0700
Message-ID: <1304922760.19586.30.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1371 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308Ab1EIGcl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 May 2011 02:32:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Not at all sure this is correct or appropriate to change,
but this seems odd.

Found via coccinelle script

@@
type T;
T* ptr;
expression E1;
@@

* memset(E1, 0, sizeof(ptr));

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 415ad4f..c8d97b4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1308,7 +1308,7 @@ static void hpsa_scsi_do_simple_cmd_with_retry(struct ctlr_info *h,
 	int retry_count = 0;
 
 	do {
-		memset(c->err_info, 0, sizeof(c->err_info));
+		memset(c->err_info, 0, sizeof(*c->err_info));
 		hpsa_scsi_do_simple_cmd_core(h, c);
 		retry_count++;
 	} while (check_for_unit_attention(h, c) && retry_count <= 3);


