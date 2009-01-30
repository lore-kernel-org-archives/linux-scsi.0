From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH][iSCSI-SCST]: Clean up netlink socket correctly
Date: Fri, 30 Jan 2009 21:20:32 +0300
Message-ID: <498344F0.3010109@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:54770 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbZA3SUW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jan 2009 13:20:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net

2.6.25 introduced netlink_socket_release(), to be used to clean up netlink sockets
correctly taking care of namespaces. Fix now wrong sock_release() call in iSCSI-SCST.

Signed-off-by: Arne Redlich <agr@powerkom-dd.de>
Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>

 event.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: iscsi-scst/kernel/event.c
===================================================================
--- iscsi-scst/kernel/event.c	(revision 648)
+++ iscsi-scst/kernel/event.c	(working copy)
@@ -142,6 +142,10 @@ int __init event_init(void)
 
 void event_exit(void)
 {
- 	if (nl)
- 		sock_release(nl->sk_socket);
+	netlink_kernel_release(nl);
 }

