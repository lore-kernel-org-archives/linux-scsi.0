From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] scsi: libiscsi: Fix possible null-pointer dereferences in iscsi_conn_get_addr_param()
Date: Mon, 29 Jul 2019 17:13:39 +0800
Message-ID: <20190729091339.30815-1-baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: lduncan@suse.com, cleech@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
List-Id: linux-scsi@vger.kernel.org

In iscsi_conn_get_addr_param(), sin6 may be NULL when reaching lines
3479 and 3487:
    len = sprintf(buf, "%pI6\n", &sin6->sin6_addr);
    len = sprintf(buf, "%hu\n", be16_to_cpu(sin6->sin6_port));

Thus, possible null-pointer dereferences may occur.

To fix these bugs, sin6 is checked before being used, and len is
initialized to -EINVAL.

These bugs are found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/scsi/libiscsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index ebd47c0cf9e9..58f072d5c43f 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3457,7 +3457,7 @@ int iscsi_conn_get_addr_param(struct sockaddr_storage *addr,
 {
 	struct sockaddr_in6 *sin6 = NULL;
 	struct sockaddr_in *sin = NULL;
-	int len;
+	int len = -EINVAL;
 
 	switch (addr->ss_family) {
 	case AF_INET:
@@ -3475,14 +3475,14 @@ int iscsi_conn_get_addr_param(struct sockaddr_storage *addr,
 	case ISCSI_HOST_PARAM_IPADDRESS:
 		if (sin)
 			len = sprintf(buf, "%pI4\n", &sin->sin_addr.s_addr);
-		else
+		else if (sin6)
 			len = sprintf(buf, "%pI6\n", &sin6->sin6_addr);
 		break;
 	case ISCSI_PARAM_CONN_PORT:
 	case ISCSI_PARAM_LOCAL_PORT:
 		if (sin)
 			len = sprintf(buf, "%hu\n", be16_to_cpu(sin->sin_port));
-		else
+		else if (sin6)
 			len = sprintf(buf, "%hu\n",
 				      be16_to_cpu(sin6->sin6_port));
 		break;
-- 
2.17.0
