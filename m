From: Joe Perches <joe@perches.com>
Subject: [PATCH 1/8] drivers/scsi: Remove uses of NIPQUAD, use %pI4
Date: Tue,  5 Jan 2010 17:20:13 -0800
Message-ID: <60710fff0b8c934d8fc78c5f5cda6409ba20ee92.1262726222.git.joe@perches.com>
References: <cover.1262726222.git.joe@perches.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755377Ab0AFBU0@vger.kernel.org>
In-Reply-To: <cover.1262726222.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c     |    4 ++--
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c   |    5 ++---
 drivers/scsi/cxgb3i/cxgb3i_offload.c |    7 ++++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 33b2294..51709cb 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1426,8 +1426,8 @@ static int bnx2i_conn_get_param(struct iscsi_cls_conn *cls_conn,
 		break;
 	case ISCSI_PARAM_CONN_ADDRESS:
 		if (bnx2i_conn->ep)
-			len = sprintf(buf, NIPQUAD_FMT "\n",
-				      NIPQUAD(bnx2i_conn->ep->cm_sk->dst_ip));
+			len = sprintf(buf, "%pI4\n",
+				      &bnx2i_conn->ep->cm_sk->dst_ip);
 		break;
 	default:
 		return iscsi_conn_get_param(cls_conn, param, buf);
diff --git a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
index 969c831..1fd89b2 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
@@ -591,8 +591,7 @@ static int cxgb3i_conn_bind(struct iscsi_cls_session *cls_session,
 	cxgb3i_conn_max_recv_dlength(conn);
 
 	spin_lock_bh(&conn->session->lock);
-	sprintf(conn->portal_address, NIPQUAD_FMT,
-		NIPQUAD(c3cn->daddr.sin_addr.s_addr));
+	sprintf(conn->portal_address, "%pI4", &c3cn->daddr.sin_addr.s_addr);
 	conn->portal_port = ntohs(c3cn->daddr.sin_port);
 	spin_unlock_bh(&conn->session->lock);
 
@@ -753,7 +752,7 @@ static int cxgb3i_host_get_param(struct Scsi_Host *shost,
 		__be32 addr;
 
 		addr = cxgb3i_get_private_ipv4addr(hba->ndev);
-		len = sprintf(buf, NIPQUAD_FMT, NIPQUAD(addr));
+		len = sprintf(buf, "%pI4", &addr);
 		break;
 	}
 	default:
diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.c b/drivers/scsi/cxgb3i/cxgb3i_offload.c
index 26ffdcd..edef61c 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.c
@@ -1643,10 +1643,11 @@ int cxgb3i_c3cn_connect(struct net_device *dev, struct s3_conn *c3cn,
 	} else
 		c3cn->saddr.sin_addr.s_addr = sipv4;
 
-	c3cn_conn_debug("c3cn 0x%p, %u.%u.%u.%u,%u-%u.%u.%u.%u,%u SYN_SENT.\n",
-			c3cn, NIPQUAD(c3cn->saddr.sin_addr.s_addr),
+	c3cn_conn_debug("c3cn 0x%p, %pI4,%u-%pI4,%u SYN_SENT.\n",
+			c3cn,
+			&c3cn->saddr.sin_addr.s_addr,
 			ntohs(c3cn->saddr.sin_port),
-			NIPQUAD(c3cn->daddr.sin_addr.s_addr),
+			&c3cn->daddr.sin_addr.s_addr,
 			ntohs(c3cn->daddr.sin_port));
 
 	c3cn_set_state(c3cn, C3CN_STATE_CONNECTING);
-- 
1.6.6.rc0.57.gad7a
