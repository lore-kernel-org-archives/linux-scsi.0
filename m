From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 3/3] nvme-fabrics: Add host_traddr options field to host
 infrastructure
Date: Thu, 28 Jul 2016 17:00:27 -0700
Message-ID: <579a9c9b.pfetMBhIGNhCI9uD%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36674 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbcG2AAa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2016 20:00:30 -0400
Received: by mail-pa0-f53.google.com with SMTP id pp5so25284836pac.3
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2016 17:00:29 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org


Add the host_traddr field to allow specification of the host-port
connection info for the transport. Will be used by FC transport.

Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/nvme/host/fabrics.c | 13 +++++++++++++
 drivers/nvme/host/fabrics.h |  4 ++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 2867b92..1c07b76 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -116,6 +116,9 @@ int nvmf_get_address(struct nvme_ctrl *ctrl, char *buf, int size)
 	if (ctrl->opts->mask & NVMF_OPT_TRSVCID)
 		len += snprintf(buf + len, size - len, "%strsvcid=%s",
 				(len) ? "," : "", ctrl->opts->trsvcid);
+	if (ctrl->opts->mask & NVMF_OPT_HOST_TRADDR)
+		len += snprintf(buf + len, size - len, "%shost_traddr=%s",
+				(len) ? "," : "", ctrl->opts->host_traddr);
 	len += snprintf(buf + len, size - len, "\n");
 
 	return len;
@@ -518,6 +521,7 @@ static const match_table_t opt_tokens = {
 	{ NVMF_OPT_RECONNECT_DELAY,	"reconnect_delay=%d"	},
 	{ NVMF_OPT_KATO,		"keep_alive_tmo=%d"	},
 	{ NVMF_OPT_HOSTNQN,		"hostnqn=%s"		},
+	{ NVMF_OPT_HOST_TRADDR,		"host_traddr=%s"	},
 	{ NVMF_OPT_ERR,			NULL			}
 };
 
@@ -674,6 +678,14 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
 			}
 			opts->reconnect_delay = token;
 			break;
+		case NVMF_OPT_HOST_TRADDR:
+			p = match_strdup(args);
+			if (!p) {
+				ret = -ENOMEM;
+				goto out;
+			}
+			opts->host_traddr = p;
+			break;
 		default:
 			pr_warn("unknown parameter or missing value '%s' in ctrl creation request\n",
 				p);
@@ -740,6 +752,7 @@ void nvmf_free_options(struct nvmf_ctrl_options *opts)
 	kfree(opts->traddr);
 	kfree(opts->trsvcid);
 	kfree(opts->subsysnqn);
+	kfree(opts->host_traddr);
 	kfree(opts);
 }
 EXPORT_SYMBOL_GPL(nvmf_free_options);
diff --git a/drivers/nvme/host/fabrics.h b/drivers/nvme/host/fabrics.h
index 2755efd..8f08c3a 100644
--- a/drivers/nvme/host/fabrics.h
+++ b/drivers/nvme/host/fabrics.h
@@ -52,6 +52,7 @@ enum {
 	NVMF_OPT_KATO		= 1 << 7,
 	NVMF_OPT_HOSTNQN	= 1 << 8,
 	NVMF_OPT_RECONNECT_DELAY = 1 << 9,
+	NVMF_OPT_HOST_TRADDR	= 1 << 10,
 };
 
 /**
@@ -68,6 +69,8 @@ enum {
  *              subsystem which is adding a controller.
  * @trsvcid:	The transport-specific TRSVCID field for a port on the
  *              subsystem which is adding a controller.
+ * @host_traddr: A transport-specific field identifying the NVME host port
+ *              to use for the connection to the controller.
  * @queue_size: Number of IO queue elements.
  * @nr_io_queues: Number of controller IO queues that will be established.
  * @reconnect_delay: Time between two consecutive reconnect attempts.
@@ -81,6 +84,7 @@ struct nvmf_ctrl_options {
 	char			*subsysnqn;
 	char			*traddr;
 	char			*trsvcid;
+	char			*host_traddr;
 	size_t			queue_size;
 	unsigned int		nr_io_queues;
 	unsigned int		reconnect_delay;
-- 
2.5.0

