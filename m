From: Tony Zelenoff <antonz@parallels.com>
Subject: [PATCH] fcoe: fix compilation warnings of section mismatch
Date: Tue, 26 Jun 2012 16:17:42 +0400
Message-ID: <1340713062-126798-1-git-send-email-antonz@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.parallels.com ([195.214.232.42]:39699 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab2FZMRo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jun 2012 08:17:44 -0400
Received: from msk-exch1.sw.swsoft.com ([10.30.1.231] helo=mail.sw.ru)
	by relay.parallels.com with esmtps (TLSv1:RC4-MD5:128)
	(Exim 4.77)
	(envelope-from <antonz@parallels.com>)
	id 1SjUiF-0000Sn-K0
	for linux-scsi@vger.kernel.org; Tue, 26 Jun 2012 16:17:43 +0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: antonz@parallels.com

Fix this message:
WARNING: drivers/scsi/fcoe/libfcoe.o(.init.text+0x21): Section mismatch
in reference from the function init_module() to the function
.exit.text:fcoe_transport_exit()
The function __init init_module() references
a function __exit fcoe_transport_exit().

Signed-off-by: Tony Zelenoff <antonz@parallels.com>
---
 drivers/scsi/fcoe/fcoe_transport.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index b46f43d..71cc909 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -502,7 +502,7 @@ static int __init fcoe_transport_init(void)
 	return 0;
 }
 
-static int __exit fcoe_transport_exit(void)
+static int fcoe_transport_exit(void)
 {
 	struct fcoe_transport *ft;
 
-- 
1.7.1

