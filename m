From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] SCSI fixes for 3.18-rc2
Date: Sun, 02 Nov 2014 15:50:49 -0600
Message-ID: <1414965049.5310.26.camel@jarvis>
References: <1414964875.5310.24.camel@jarvis>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57179 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751292AbaKBVuw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Nov 2014 16:50:52 -0500
In-Reply-To: <1414964875.5310.24.camel@jarvis>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Sun, 2014-11-02 at 15:47 -0600, James Bottomley wrote:
> With full diff below.

For those of you paying attention, I managed to generate a reverse diff.
The actual forward diff is below.

James

---

diff --git a/MAINTAINERS b/MAINTAINERS
index dab92a7..82d4ad2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4312,8 +4312,10 @@ F:	Documentation/blockdev/cpqarray.txt
 F:	drivers/block/cpqarray.*
 
 HEWLETT-PACKARD SMART ARRAY RAID DRIVER (hpsa)
-M:	"Stephen M. Cameron" <scameron@beardog.cce.hp.com>
+M:	Don Brace <don.brace@pmcs.com>
 L:	iss_storagedev@hp.com
+L:	storagedev@pmcs.com
+L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	Documentation/scsi/hpsa.txt
 F:	drivers/scsi/hpsa*.[ch]
@@ -4321,8 +4323,10 @@ F:	include/linux/cciss*.h
 F:	include/uapi/linux/cciss*.h
 
 HEWLETT-PACKARD SMART CISS RAID DRIVER (cciss)
-M:	Mike Miller <mike.miller@hp.com>
+M:	Don Brace <don.brace@pmcs.com>
 L:	iss_storagedev@hp.com
+L:	storagedev@pmcs.com
+L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	Documentation/blockdev/cciss.txt
 F:	drivers/block/cciss*
@@ -9606,7 +9610,6 @@ F:     drivers/staging/unisys/
 
 UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER
 M:	Vinayak Holikatti <vinholikatti@gmail.com>
-M:	Santosh Y <santoshsy@gmail.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	Documentation/scsi/ufs.txt
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 54fa6e0..674d498 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -399,6 +399,35 @@ EXPORT_SYMBOL_GPL(cxgbi_hbas_add);
  *   If the source port is outside our allocation range, the caller is
  *   responsible for keeping track of their port usage.
  */
+
+static struct cxgbi_sock *find_sock_on_port(struct cxgbi_device *cdev,
+					    unsigned char port_id)
+{
+	struct cxgbi_ports_map *pmap = &cdev->pmap;
+	unsigned int i;
+	unsigned int used;
+
+	if (!pmap->max_connect || !pmap->used)
+		return NULL;
+
+	spin_lock_bh(&pmap->lock);
+	used = pmap->used;
+	for (i = 0; used && i < pmap->max_connect; i++) {
+		struct cxgbi_sock *csk = pmap->port_csk[i];
+
+		if (csk) {
+			if (csk->port_id == port_id) {
+				spin_unlock_bh(&pmap->lock);
+				return csk;
+			}
+			used--;
+		}
+	}
+	spin_unlock_bh(&pmap->lock);
+
+	return NULL;
+}
+
 static int sock_get_port(struct cxgbi_sock *csk)
 {
 	struct cxgbi_device *cdev = csk->cdev;
@@ -749,6 +778,7 @@ static struct cxgbi_sock *cxgbi_check_route6(struct sockaddr *dst_addr)
 	csk->daddr6.sin6_addr = daddr6->sin6_addr;
 	csk->daddr6.sin6_port = daddr6->sin6_port;
 	csk->daddr6.sin6_family = daddr6->sin6_family;
+	csk->saddr6.sin6_family = daddr6->sin6_family;
 	csk->saddr6.sin6_addr = pref_saddr;
 
 	neigh_release(n);
@@ -2647,12 +2677,14 @@ int cxgbi_get_host_param(struct Scsi_Host *shost, enum iscsi_host_param param,
 		break;
 	case ISCSI_HOST_PARAM_IPADDRESS:
 	{
-		__be32 addr;
-
-		addr = cxgbi_get_iscsi_ipv4(chba);
-		len = sprintf(buf, "%pI4", &addr);
+		struct cxgbi_sock *csk = find_sock_on_port(chba->cdev,
+							   chba->port_id);
+		if (csk) {
+			len = sprintf(buf, "%pIS",
+				      (struct sockaddr *)&csk->saddr);
+		}
 		log_debug(1 << CXGBI_DBG_ISCSI,
-			"hba %s, ipv4 %pI4.\n", chba->ndev->name, &addr);
+			  "hba %s, addr %s.\n", chba->ndev->name, buf);
 		break;
 	}
 	default:
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index 1d98fad..2c7cb1c 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -700,11 +700,6 @@ static inline void cxgbi_set_iscsi_ipv4(struct cxgbi_hba *chba, __be32 ipaddr)
 			chba->ndev->name);
 }
 
-static inline __be32 cxgbi_get_iscsi_ipv4(struct cxgbi_hba *chba)
-{
-	return chba->ipv4addr;
-}
-
 struct cxgbi_device *cxgbi_device_register(unsigned int, unsigned int);
 void cxgbi_device_unregister(struct cxgbi_device *);
 void cxgbi_device_unregister_all(unsigned int flag);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9eff8a3..50a6e1a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1893,6 +1893,11 @@ static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req,
 		blk_mq_start_request(req);
 	}
 
+	if (blk_queue_tagged(q))
+		req->cmd_flags |= REQ_QUEUED;
+	else
+		req->cmd_flags &= ~REQ_QUEUED;
+
 	scsi_init_cmd_errh(cmd);
 	cmd->scsi_done = scsi_mq_done;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0207a78..51d0dc2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1136,8 +1136,7 @@ static inline bool blk_needs_flush_plug(struct task_struct *tsk)
 /*
  * tag stuff
  */
-#define blk_rq_tagged(rq) \
-	((rq)->mq_ctx || ((rq)->cmd_flags & REQ_QUEUED))
+#define blk_rq_tagged(rq)		((rq)->cmd_flags & REQ_QUEUED)
 extern int blk_queue_start_tag(struct request_queue *, struct request *);
 extern struct request *blk_queue_find_tag(struct request_queue *, int);
 extern void blk_queue_end_tag(struct request_queue *, struct request *);
diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
index e645835..56ed843 100644
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -67,8 +67,9 @@ static inline void scsi_activate_tcq(struct scsi_device *sdev, int depth)
 	if (!sdev->tagged_supported)
 		return;
 
-	if (!shost_use_blk_mq(sdev->host) &&
-	    !blk_queue_tagged(sdev->request_queue))
+	if (shost_use_blk_mq(sdev->host))
+		queue_flag_set_unlocked(QUEUE_FLAG_QUEUED, sdev->request_queue);
+	else if (!blk_queue_tagged(sdev->request_queue))
 		blk_queue_init_tags(sdev->request_queue, depth,
 				    sdev->host->bqt);
 
@@ -81,8 +82,7 @@ static inline void scsi_activate_tcq(struct scsi_device *sdev, int depth)
  **/
 static inline void scsi_deactivate_tcq(struct scsi_device *sdev, int depth)
 {
-	if (!shost_use_blk_mq(sdev->host) &&
-	    blk_queue_tagged(sdev->request_queue))
+	if (blk_queue_tagged(sdev->request_queue))
 		blk_queue_free_tags(sdev->request_queue);
 	scsi_adjust_queue_depth(sdev, 0, depth);
 }
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 9cdf62f..c9f2e8c 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -203,10 +203,10 @@ void __sg_free_table(struct sg_table *table, unsigned int max_ents,
 		}
 
 		table->orig_nents -= sg_size;
-		if (!skip_first_chunk) {
-			free_fn(sgl, alloc_size);
+		if (skip_first_chunk)
 			skip_first_chunk = false;
-		}
+		else
+			free_fn(sgl, alloc_size);
 		sgl = next;
 	}
 


