From: michaelc@cs.wisc.edu
Subject: [PATCH 1/2] iscsi: kill redundant casts
Date: Tue,  1 Jul 2014 11:24:37 -0500
Message-ID: <1404231878-3844-2-git-send-email-michaelc@cs.wisc.edu>
References: <1404231878-3844-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:52437 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755994AbaGAQYz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jul 2014 12:24:55 -0400
Received: from localhost.localdomain (c-24-245-27-162.hsd1.mn.comcast.net [24.245.27.162])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id s61GOkHF021409
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 1 Jul 2014 11:24:54 -0500
In-Reply-To: <1404231878-3844-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Nick Black' via open-iscsi <open-iscsi@googlegroups.com>

Remove two redundant casts from char * to char *.

Signed-off-by: Nick Black <nlb@google.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 126bf26..b481e62 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3059,7 +3059,7 @@ iscsi_get_chap(struct iscsi_transport *transport, struct nlmsghdr *nlh)
 		evchap->u.get_chap.host_no = ev->u.get_chap.host_no;
 		evchap->u.get_chap.chap_tbl_idx = ev->u.get_chap.chap_tbl_idx;
 		evchap->u.get_chap.num_entries = ev->u.get_chap.num_entries;
-		buf = (char *) ((char *)evchap + sizeof(*evchap));
+		buf = (char *)evchap + sizeof(*evchap);
 		memset(buf, 0, chap_buf_size);
 
 		err = transport->get_chap(shost, ev->u.get_chap.chap_tbl_idx,
@@ -3463,7 +3463,7 @@ iscsi_get_host_stats(struct iscsi_transport *transport, struct nlmsghdr *nlh)
 		evhost_stats->type = nlh->nlmsg_type;
 		evhost_stats->u.get_host_stats.host_no =
 					ev->u.get_host_stats.host_no;
-		buf = (char *)((char *)evhost_stats + sizeof(*evhost_stats));
+		buf = (char *)evhost_stats + sizeof(*evhost_stats);
 		memset(buf, 0, host_stats_size);
 
 		err = transport->get_host_stats(shost, buf, host_stats_size);
-- 
1.7.1

