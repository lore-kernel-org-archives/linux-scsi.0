From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 02/10] qla2xxx: Include ATIO queue in firmware dump when in target mode
Date: Wed, 21 Dec 2016 13:57:31 -0800
Message-ID: <1482357459-31079-3-git-send-email-himanshu.madhani@cavium.com>
References: <1482357459-31079-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0057.outbound.protection.outlook.com ([104.47.42.57]:37600
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752789AbcLUV6R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Dec 2016 16:58:17 -0500
In-Reply-To: <1482357459-31079-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

Include ATIO queue for ISP27XX when firmware dump is collected
for target mode.

Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
---
 drivers/scsi/qla2xxx/qla_tmpl.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 36935c9..d356ed0 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -433,6 +433,18 @@ static inline void (*qla27xx_read_vector(uint width))(void __iomem*, void *, ulo
 				count++;
 			}
 		}
+	} else if (QLA_TGT_MODE_ENABLED() &&
+	    ent->t263.queue_type == T263_QUEUE_TYPE_ATIO) {
+		struct qla_hw_data *ha = vha->hw;
+		struct atio *atr = ha->tgt.atio_ring;
+
+		if (atr || !buf) {
+			length = ha->tgt.atio_q_length;
+			qla27xx_insert16(0, buf, len);
+			qla27xx_insert16(length, buf, len);
+			qla27xx_insertbuf(atr, length * sizeof(*atr), buf, len);
+			count++;
+		}
 	} else {
 		ql_dbg(ql_dbg_misc, vha, 0xd026,
 		    "%s: unknown queue %x\n", __func__, ent->t263.queue_type);
@@ -676,6 +688,18 @@ static inline void (*qla27xx_read_vector(uint width))(void __iomem*, void *, ulo
 				count++;
 			}
 		}
+	} else if (QLA_TGT_MODE_ENABLED() &&
+	    ent->t274.queue_type == T274_QUEUE_TYPE_ATIO_SHAD) {
+		struct qla_hw_data *ha = vha->hw;
+		struct atio *atr = ha->tgt.atio_ring_ptr;
+
+		if (atr || !buf) {
+			qla27xx_insert16(0, buf, len);
+			qla27xx_insert16(1, buf, len);
+			qla27xx_insert32(ha->tgt.atio_q_in ?
+			    *ha->tgt.atio_q_in : 0, buf, len);
+			count++;
+		}
 	} else {
 		ql_dbg(ql_dbg_misc, vha, 0xd02f,
 		    "%s: unknown queue %x\n", __func__, ent->t274.queue_type);
-- 
1.8.3.1

