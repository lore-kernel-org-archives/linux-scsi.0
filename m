From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 8/8] zfcp: enable FCP hardware data router by default
Date: Wed, 21 Aug 2013 17:05:31 +0200
Message-ID: <1377097531-4942-9-git-send-email-maier@linux.vnet.ibm.com>
References: <1377097531-4942-1-git-send-email-maier@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:45215 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab3HUPHY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Aug 2013 11:07:24 -0400
Received: from /spool/local
	by e06smtp11.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Wed, 21 Aug 2013 16:00:42 +0100
In-Reply-To: <1377097531-4942-1-git-send-email-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>

Enabling the data router support by default
can increase performance in certain situations.
It is safe to do so and tolerated in LPAR and under z/VM
in case there is no data router support in that environment.

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Reviewed-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_qdio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -16,9 +16,9 @@
 
 #define QBUFF_PER_PAGE		(PAGE_SIZE / sizeof(struct qdio_buffer))
 
-static bool enable_multibuffer;
+static bool enable_multibuffer = 1;
 module_param_named(datarouter, enable_multibuffer, bool, 0400);
-MODULE_PARM_DESC(datarouter, "Enable hardware data router support");
+MODULE_PARM_DESC(datarouter, "Enable hardware data router support (default on)");
 
 static int zfcp_qdio_buffers_enqueue(struct qdio_buffer **sbal)
 {

