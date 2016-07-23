From: james.smart@broadcom.com (James Smart)
Subject: [PATCH] nvme-fabrics: Patch host code in prep for FC transport
 support
Date: Fri, 22 Jul 2016 17:23:50 -0700
Message-ID: <5792b916.P2ksarpXpcxZ+l9s%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:36591 "EHLO
	mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbcGWAXw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2016 20:23:52 -0400
Received: by mail-pf0-f171.google.com with SMTP id h186so45766364pfg.3
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2016 17:23:52 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org


Patch nvme-fabrics host code in prep for FC transport support:
- Add the host_traddr field to allow specification of the host-port
  connection info for the transport. Will be used by FC transport.
- Revise nvmf_get_address() string to account for not all options being
  present.
- Revise some of the comments so not so ethernet-network centric

Patch is cut against the linux-nvme for-4.8/drivers branch

Note: this patch had been posted to the prior nvme fabrics repository but
not merged before being brought over to linux-nvme.

Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/nvme/host/fabrics.c | 25 +++++++++++++++++++++++--
 drivers/nvme/host/fabrics.h | 11 ++++++++---
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index dc99676..1c07b76 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -109,8 +109,19 @@ static void nvmf_host_put(struct nvmf_host *host)
  */
 int nvmf_get_address(struct nvme_ctrl *ctrl, char *buf, int size)
 {
-	return snprintf(buf, size, "traddr=%s,trsvcid=%s\n",
-			ctrl->opts->traddr, ctrl->opts->trsvcid);
+	int len = 0;
+
+	if (ctrl->opts->mask & NVMF_OPT_TRADDR)
+		len += snprintf(buf, size, "traddr=%s", ctrl->opts->traddr);
+	if (ctrl->opts->mask & NVMF_OPT_TRSVCID)
+		len += snprintf(buf + len, size - len, "%strsvcid=%s",
+				(len) ? "," : "", ctrl->opts->trsvcid);
+	if (ctrl->opts->mask & NVMF_OPT_HOST_TRADDR)
+		len += snprintf(buf + len, size - len, "%shost_traddr=%s",
+				(len) ? "," : "", ctrl->opts->host_traddr);
+	len += snprintf(buf + len, size - len, "\n");
+
+	return len;
 }
 EXPORT_SYMBOL_GPL(nvmf_get_address);
 
@@ -510,6 +521,7 @@ static const match_table_t opt_tokens = {
 	{ NVMF_OPT_RECONNECT_DELAY,	"reconnect_delay=%d"	},
 	{ NVMF_OPT_KATO,		"keep_alive_tmo=%d"	},
 	{ NVMF_OPT_HOSTNQN,		"hostnqn=%s"		},
+	{ NVMF_OPT_HOST_TRADDR,		"host_traddr=%s"	},
 	{ NVMF_OPT_ERR,			NULL			}
 };
 
@@ -666,6 +678,14 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
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
@@ -732,6 +752,7 @@ void nvmf_free_options(struct nvmf_ctrl_options *opts)
 	kfree(opts->traddr);
 	kfree(opts->trsvcid);
 	kfree(opts->subsysnqn);
+	kfree(opts->host_traddr);
 	kfree(opts);
 }
 EXPORT_SYMBOL_GPL(nvmf_free_options);
diff --git a/drivers/nvme/host/fabrics.h b/drivers/nvme/host/fabrics.h
index 89df52c..8f08c3a 100644
--- a/drivers/nvme/host/fabrics.h
+++ b/drivers/nvme/host/fabrics.h
@@ -52,6 +52,7 @@ enum {
 	NVMF_OPT_KATO		= 1 << 7,
 	NVMF_OPT_HOSTNQN	= 1 << 8,
 	NVMF_OPT_RECONNECT_DELAY = 1 << 9,
+	NVMF_OPT_HOST_TRADDR	= 1 << 10,
 };
 
 /**
@@ -64,9 +65,12 @@ enum {
  *		being added.
  * @subsysnqn:	Hold the fully qualified NQN subystem name (format defined
  *		in the NVMe specification, "NVMe Qualified Names").
- * @traddr:	network address that will be used by the host to communicate
- *		to the added NVMe controller.
- * @trsvcid:	network port used for host-controller communication.
+ * @traddr:	The transport-specific TRADDR field for a port on the
+ *              subsystem which is adding a controller.
+ * @trsvcid:	The transport-specific TRSVCID field for a port on the
+ *              subsystem which is adding a controller.
+ * @host_traddr: A transport-specific field identifying the NVME host port
+ *              to use for the connection to the controller.
  * @queue_size: Number of IO queue elements.
  * @nr_io_queues: Number of controller IO queues that will be established.
  * @reconnect_delay: Time between two consecutive reconnect attempts.
@@ -80,6 +84,7 @@ struct nvmf_ctrl_options {
 	char			*subsysnqn;
 	char			*traddr;
 	char			*trsvcid;
+	char			*host_traddr;
 	size_t			queue_size;
 	unsigned int		nr_io_queues;
 	unsigned int		reconnect_delay;
-- 
2.5.0

