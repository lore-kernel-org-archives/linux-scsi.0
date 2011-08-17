From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 10/21] target: Fix WRITE_SAME usage with transport_get_size
Date: Wed, 17 Aug 2011 23:17:14 +0000
Message-ID: <1313623045-15916-11-git-send-email-nab@linux-iscsi.org>
References: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:58327 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab1HQXmd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2011 19:42:33 -0400
In-Reply-To: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

For all flavours of WRITE_SAME, we only expect to handle a single block
of data-out buffer payload, regardless of the number of logical blocks
presented in the CDB.  This patch changes all flavours of WRITE_SAME in
transport_generic_cmd_sequencer() to pass '1' into transport_get_size()
instead of the extracted 'sectors' to properly handle the default usage
of sg_write_same without the --xferlen parameter.

Reported-by: Eric Seppanen <eric@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@risingtidesystems.com>
---
 drivers/target/target_core_transport.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index eb8055a..d35c2cc 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3103,7 +3103,7 @@ static int transport_generic_cmd_sequencer(
 				goto out_unsupported_cdb;
 
 			if (sectors)
-				size = transport_get_size(sectors, cdb, cmd);
+				size = transport_get_size(1, cdb, cmd);
 			else {
 				pr_err("WSNZ=1, WRITE_SAME w/sectors=0 not"
 				       " supported\n");
@@ -3365,7 +3365,7 @@ static int transport_generic_cmd_sequencer(
 			goto out_unsupported_cdb;
 
 		if (sectors)
-			size = transport_get_size(sectors, cdb, cmd);
+			size = transport_get_size(1, cdb, cmd);
 		else {
 			pr_err("WSNZ=1, WRITE_SAME w/sectors=0 not supported\n");
 			goto out_invalid_cdb_field;
@@ -3383,7 +3383,7 @@ static int transport_generic_cmd_sequencer(
 			goto out_unsupported_cdb;
 
 		if (sectors)
-			size = transport_get_size(sectors, cdb, cmd);
+			size = transport_get_size(1, cdb, cmd);
 		else {
 			pr_err("WSNZ=1, WRITE_SAME w/sectors=0 not supported\n");
 			goto out_invalid_cdb_field;
-- 
1.7.6

