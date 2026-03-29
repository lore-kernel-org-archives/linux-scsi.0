Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7EF2BAF7;
	Sun, 29 Mar 2026 03:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774753799; cv=none; b=AbrM2rBfEMZ2Jt78U+bFcfFMqzbC8pea2wm+TD8Qc44ch7BAPsw7IVmSj/wTIF+6FOTUJORJg++5Xt9GYPBh/tZJULQOYOcE6uhouOD56/mEb8THKnw+RtvdrjUoEgZzUMpirwolq1kc14S5j2b5mfXLS7P6t2ETxnsQbLSy0L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774753799; c=relaxed/simple;
	bh=pWYUMfATEtczgIcRkqJvLNJcPdisI0R/YuTy1DN/Xk4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u7uhZfbyNWH97Z8DUmRMmemMZ7kVDOa2HwU0wp6jE/41xnXqdyvG25J0vCXVAnE0l7ljIZVaf393CkZLYGlYqj1s8dv/auopvNbF/zZ+Rmos+nVXQ282ep6LilPbL+culTpDB2D7dxcAQVuY0Gk08HBKVVwtUYnY22/BwYbRPPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.245.197])
	by APP-01 (Coremail) with SMTP id qwCowAD3n2v8l8hpp+d8Cw--.16991S2;
	Sun, 29 Mar 2026 11:09:48 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: njavali@marvell.com,
	mrangankar@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	chad.dupuis@cavium.com,
	hare@suse.de,
	arun.easi@cavium.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pengpeng@iscas.ac.cn
Subject: [PATCH] scsi: qedi: bound UIO TX packet length before copying
Date: Sun, 29 Mar 2026 11:09:47 +0800
Message-ID: <20260329030947.32451-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAD3n2v8l8hpp+d8Cw--.16991S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJr15WryUur47uF47trW8WFg_yoW8XF43pF
	WftayYyay5CF4YgF9rJw1UJF1Fka4kZFW2gF9rZw18ZryfG3yqkF1rGa4UZr10q3Z7AwsF
	yw1qqa4UGF9FqF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9214x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
	8cxan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFV
	Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
	x4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r
	4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j
	6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYx
	BIdaVFxhVjvjDU0xZFpf9x0JUgXocUUUUU=
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

qedi_data_avail() trusts the userspace-written host_tx_pkt_len field and
uses it to size an skb and memcpy() from udev->tx_pkt. qedi_alloc_uio()
lays out udev->tx_pkt and udev->rx_pkt one qedi_ll2_buf_size slot apart
in the shared LL2 buffer, but qedi_data_avail() does not currently
verify that host_tx_pkt_len stays within that TX slot.

Reject oversized host_tx_pkt_len values before allocating and copying the packet.

Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/scsi/qedi/qedi_iscsi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 6ab3a989d281..83200bd063df 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -1219,6 +1219,7 @@ static int qedi_data_avail(struct qedi_ctx *qedi, u16 vlanid)
 	struct qedi_uio_dev *udev;
 	struct qedi_uio_ctrl *uctrl;
 	struct sk_buff *skb;
+	size_t tx_slot_len;
 	u32 len;
 	int rc = 0;
 
@@ -1240,6 +1241,12 @@ static int qedi_data_avail(struct qedi_ctx *qedi, u16 vlanid)
 		return -EINVAL;
 	}
 
+	tx_slot_len = (char *)udev->rx_pkt - (char *)udev->tx_pkt;
+	if (len > tx_slot_len) {
+		QEDI_ERR(&qedi->dbg_ctx, "Invalid tx packet len %u\n", len);
+		return -EINVAL;
+	}
+
 	skb = alloc_skb(len, GFP_ATOMIC);
 	if (!skb) {
 		QEDI_ERR(&qedi->dbg_ctx, "alloc_skb failed\n");
-- 
2.50.1 (Apple Git-155)

