From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] iscsi-target: remove some dead code
Date: Thu, 17 May 2012 10:08:14 +0300
Message-ID: <20120517070814.GD14660@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:42303 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759685Ab2EQHIc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2012 03:08:32 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Andy Grover <agrover@redhat.com>, Jesper Juhl <jj@chaosbits.net>, Joern Engel <joern@logfs.org>, Roland Dreier <roland@kernel.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org

Neither "acceptor_values" nor "proposer_values" can be NULL here.
Smatch complains because we are not allowed to pass NULL pointers to
strchr().

Also I removed a second later check for "!acceptor_values" because it
gets checked on the next line in the do while condition.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Compile tested only.  Please review carefully.

diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index ad3b3c1..ed5241e 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -1037,13 +1037,6 @@ static char *iscsi_check_valuelist_for_support(
 			tmp2 = strchr(acceptor_values, ',');
 			if (tmp2)
 				*tmp2 = '\0';
-			if (!acceptor_values || !proposer_values) {
-				if (tmp1)
-					*tmp1 = ',';
-				if (tmp2)
-					*tmp2 = ',';
-				return NULL;
-			}
 			if (!strcmp(acceptor_values, proposer_values)) {
 				if (tmp2)
 					*tmp2 = ',';
@@ -1053,8 +1046,6 @@ static char *iscsi_check_valuelist_for_support(
 				*tmp2++ = ',';
 
 			acceptor_values = tmp2;
-			if (!acceptor_values)
-				break;
 		} while (acceptor_values);
 		if (tmp1)
 			*tmp1++ = ',';
