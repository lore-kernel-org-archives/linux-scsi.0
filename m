From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH 6/8] aic94xx: move list_each_entry_reverse_safe from
	sas_discover.h to list.h
Date: Tue, 09 May 2006 14:37:01 -0700
Message-ID: <1147210621.11847.60.camel@localhost.localdomain>
References: <1147209211.11847.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:35768 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751114AbWEIVhD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 May 2006 17:37:03 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k49Lb32E023002
	for <linux-scsi@vger.kernel.org>; Tue, 9 May 2006 17:37:03 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k49Lb37r159590
	for <linux-scsi@vger.kernel.org>; Tue, 9 May 2006 15:37:03 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k49Lb3PF004850
	for <linux-scsi@vger.kernel.org>; Tue, 9 May 2006 15:37:03 -0600
Received: from alexis.beaverton.ibm.com (alexis.beaverton.ibm.com [9.47.17.121])
	by d03av01.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id k49Lb2QJ004835
	for <linux-scsi@vger.kernel.org>; Tue, 9 May 2006 15:37:02 -0600
In-Reply-To: <1147209211.11847.33.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Move list_each_entry_reverse_safe from sas_discover.h to the more
appropriate file list.h

Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>
Signed-off-by: Mike Anderson <andmike@us.ibm.com>

---
 include/linux/list.h            |    6 ++++++
 include/scsi/sas/sas_discover.h |    7 -------
 2 files changed, 6 insertions(+), 7 deletions(-)

Index: aic94xx-sas-2.6-patched/include/scsi/sas/sas_discover.h
===================================================================
--- aic94xx-sas-2.6-patched.orig/include/scsi/sas/sas_discover.h
+++ aic94xx-sas-2.6-patched/include/scsi/sas/sas_discover.h
@@ -115,13 +115,6 @@ struct domain_device {
 	void *lldd_dev;
 };
 
-#define list_for_each_entry_reverse_safe(pos, n, head, member)		\
-	for (pos = list_entry((head)->prev, typeof(*pos), member),	\
-		n = list_entry(pos->member.prev, typeof(*pos), member);	\
-	     &pos->member != (head); 					\
-	     pos = n, n = list_entry(n->member.prev, typeof(*n), member))
-
-
 
 void sas_init_disc(struct sas_discovery *disc, struct sas_port *port);
 int  sas_discover_event(struct sas_port *sas_port, enum discover_event ev);
Index: aic94xx-sas-2.6-patched/include/linux/list.h
===================================================================
--- aic94xx-sas-2.6-patched.orig/include/linux/list.h
+++ aic94xx-sas-2.6-patched/include/linux/list.h
@@ -542,6 +542,12 @@ static inline void list_splice_init(stru
 		prefetch(rcu_dereference((pos))->next), (pos) != (head); \
         	(pos) = (pos)->next)
 
+#define list_for_each_entry_reverse_safe(pos, n, head, member)          \
+	for (pos = list_entry((head)->prev, typeof(*pos), member),      \
+		n = list_entry(pos->member.prev, typeof(*pos), member); \
+		&pos->member != (head);                                    \
+		pos = n, n = list_entry(n->member.prev, typeof(*n), member))
+
 /*
  * Double linked lists with a single pointer list head.
  * Mostly useful for hash tables where the two pointer list head is


