From: michaelc@cs.wisc.edu
Subject: [PATCH 3/4] iscsi class: fix get_host_stats return code when not supported
Date: Sat, 12 Jul 2014 15:51:50 -0500
Message-ID: <1405198311-64449-4-git-send-email-michaelc@cs.wisc.edu>
References: <1405198311-64449-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40870 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764AbaGLUwF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Jul 2014 16:52:05 -0400
Received: from localhost.localdomain (c-24-245-27-162.hsd1.mn.comcast.net [24.245.27.162])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id s6CKpvxK007638
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 12 Jul 2014 15:52:04 -0500
In-Reply-To: <1405198311-64449-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

When the get_host_stats call was not supported we were
returing EINVAL. This has us return ENOSYS, because for
software iscsi drivers where there is no host it is ok to not
have this callout.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 14bfa53..534d3fb 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3429,7 +3429,7 @@ iscsi_get_host_stats(struct iscsi_transport *transport, struct nlmsghdr *nlh)
 	char *buf;
 
 	if (!transport->get_host_stats)
-		return -EINVAL;
+		return -ENOSYS;
 
 	priv = iscsi_if_transport_lookup(transport);
 	if (!priv)
-- 
1.7.1

