From: akpm@osdl.org
Subject: [patch 1/1] iscsi_transport build fix
Date: Wed, 17 Nov 2004 02:03:10 -0800
Message-ID: <200411171003.iAHA3M925908@mail.osdl.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:12973 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262258AbUKQKD1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2004 05:03:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org



drivers/scsi/scsi_transport_iscsi.c:176: structure has no member named `sin6_addr'

Older gcc's dont support anonymous unions.

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 25-akpm/include/scsi/scsi_transport_iscsi.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/scsi/scsi_transport_iscsi.h~iscsi_transport-build-fix include/scsi/scsi_transport_iscsi.h
--- 25/include/scsi/scsi_transport_iscsi.h~iscsi_transport-build-fix	2004-11-17 01:55:06.014731216 -0800
+++ 25-akpm/include/scsi/scsi_transport_iscsi.h	2004-11-17 01:55:50.164019504 -0800
@@ -36,7 +36,7 @@ struct iscsi_class_session {
 	union {
 		struct in6_addr sin6_addr;
 		struct in_addr sin_addr;
-	};
+	} u;
 	sa_family_t addr_type;		/* must be AF_INET or AF_INET6 */
 	uint16_t port;			/* must be in network byte order */
 	int initial_r2t;		/* 1 Yes, 0 No */
@@ -68,9 +68,9 @@ struct iscsi_class_session {
 #define iscsi_addr_type(x) \
 	(((struct iscsi_class_session *)&(x)->starget_data)->addr_type)
 #define iscsi_sin_addr(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->sin_addr)
+	(((struct iscsi_class_session *)&(x)->starget_data)->u.sin_addr)
 #define iscsi_sin6_addr(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->sin6_addr)
+	(((struct iscsi_class_session *)&(x)->starget_data)->u.sin6_addr)
 #define iscsi_tpgt(x) \
 	(((struct iscsi_class_session *)&(x)->starget_data)->tpgt)
 #define iscsi_initial_r2t(x) \
_
