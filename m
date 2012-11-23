From: vikas.chaudhary@qlogic.com
Subject: [PATCH 3/5] qla4xxx: Fix memory corruption issue in qla4xxx_get_ep_fwdb.
Date: Fri, 23 Nov 2012 06:58:40 -0500
Message-ID: <1353671922-19090-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1353671922-19090-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:7683 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753672Ab2KWMRM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Nov 2012 07:17:12 -0500
In-Reply-To: <1353671922-19090-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Manish Rangankar <manish.rangankar@qlogic.com>

From: Manish Rangankar <manish.rangankar@qlogic.com>

In qla4xxx_get_ep_fwdb(), dst_addr is of type struct sockaddr.
We are copying sizeof(struct sockaddr_in6) bytes to dst_addr
which is 12 bytes larger. This will cause memory corruption.
So we change dst_addr to struct sockaddr_storage which is
of 128 byte, large enough to hold sizeof(struct sockaddr_in6).

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Manish Rangankar <manish.rangankar@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 25e994f..6096866 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4685,7 +4685,8 @@ static struct iscsi_endpoint *qla4xxx_get_ep_fwdb(struct scsi_qla_host *ha,
 	struct iscsi_endpoint *ep;
 	struct sockaddr_in *addr;
 	struct sockaddr_in6 *addr6;
-	struct sockaddr *dst_addr;
+	struct sockaddr *t_addr;
+	struct sockaddr_storage *dst_addr;
 	char *ip;
 
 	/* TODO: need to destroy on unload iscsi_endpoint*/
@@ -4694,21 +4695,23 @@ static struct iscsi_endpoint *qla4xxx_get_ep_fwdb(struct scsi_qla_host *ha,
 		return NULL;
 
 	if (fw_ddb_entry->options & DDB_OPT_IPV6_DEVICE) {
-		dst_addr->sa_family = AF_INET6;
+		t_addr = (struct sockaddr *)dst_addr;
+		t_addr->sa_family = AF_INET6;
 		addr6 = (struct sockaddr_in6 *)dst_addr;
 		ip = (char *)&addr6->sin6_addr;
 		memcpy(ip, fw_ddb_entry->ip_addr, IPv6_ADDR_LEN);
 		addr6->sin6_port = htons(le16_to_cpu(fw_ddb_entry->port));
 
 	} else {
-		dst_addr->sa_family = AF_INET;
+		t_addr = (struct sockaddr *)dst_addr;
+		t_addr->sa_family = AF_INET;
 		addr = (struct sockaddr_in *)dst_addr;
 		ip = (char *)&addr->sin_addr;
 		memcpy(ip, fw_ddb_entry->ip_addr, IP_ADDR_LEN);
 		addr->sin_port = htons(le16_to_cpu(fw_ddb_entry->port));
 	}
 
-	ep = qla4xxx_ep_connect(ha->host, dst_addr, 0);
+	ep = qla4xxx_ep_connect(ha->host, (struct sockaddr *)dst_addr, 0);
 	vfree(dst_addr);
 	return ep;
 }
-- 
1.7.8.GIT

