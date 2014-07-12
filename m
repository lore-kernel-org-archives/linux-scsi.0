From: michaelc@cs.wisc.edu
Subject: [PATCH 1/4] iscsi class: fix get_host_stats error handling
Date: Sat, 12 Jul 2014 15:51:48 -0500
Message-ID: <1405198311-64449-2-git-send-email-michaelc@cs.wisc.edu>
References: <1405198311-64449-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40868 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbaGLUwF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Jul 2014 16:52:05 -0400
Received: from localhost.localdomain (c-24-245-27-162.hsd1.mn.comcast.net [24.245.27.162])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id s6CKpvxI007638
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 12 Jul 2014 15:52:03 -0500
In-Reply-To: <1405198311-64449-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

iscsi_get_host_stats was dropping the error code returned
by drivers like qla4xxx.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index b481e62..14bfa53 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3467,6 +3467,10 @@ iscsi_get_host_stats(struct iscsi_transport *transport, struct nlmsghdr *nlh)
 		memset(buf, 0, host_stats_size);
 
 		err = transport->get_host_stats(shost, buf, host_stats_size);
+		if (err) {
+			kfree(skbhost_stats);
+			goto exit_host_stats;
+		}
 
 		actual_size = nlmsg_total_size(sizeof(*ev) + host_stats_size);
 		skb_trim(skbhost_stats, NLMSG_ALIGN(actual_size));
-- 
1.7.1

