Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C1332B100;
	Thu, 27 Aug 2026 02:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787796358; cv=none; b=P5XJAJ5eghqtAicEY3mm3On3aTYy1awq3bLL0hZEOtBmNqimUaZgnruTxE7Rp06hgBX11Al364NGvBolTqJF4MizJF7ca1kGfZd1got/dqQ1cNWAhGhDiRPMYx+bD/g2MxmH10TVPzikC4yNJ13W7OGBm+n79YLtKNLc287nY3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787796358; c=relaxed/simple;
	bh=pw1sL4GCKzOrVaTCSIyFIIP6qDP3kJo7hS6eJKxXYP0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YPfAX94R1axgTpMBYSZOkXsEW17v5bNBHTTqA4CnKQC8Ua40qxl2uQxg4nyCtk7o+7uu7rB+Ui5xk8OHAbDcXAIYK+8YgrIl/MT1zee8CNwjSjp8hIXGniUJXKWYB361YhPzuuhdU70oDpNks8R7Xttj5AOZhTNle8SPtea+gtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=CMdP1DJA; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="CMdP1DJA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=nr
	cvEP3Xhkd19RV4CkWuoVyi53edPcp87hFyJB/+lYw=; b=CMdP1DJAFwPy8JzRU0
	X7TPU1yNvXphzYMhQ6Y5I+7veNJk/jArNfQjVDmqIyADlDYFW7SArGqbb4C3Y63L
	+KQ7smXiI1amx0W5IT9p6/QIQzYx1VBVclR8mgabcNvqfDPwc7AbwoAtXMwfdfcJ
	n474uzCQ/2lSiCBnvndIc1gzQ=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgDXXx91m49q9OxpOQ--.43841S2;
	Thu, 27 Aug 2026 10:05:42 +0800 (CST)
From: ghuicao@163.com
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Cao Guanghui <caoguanghui@kylinos.cn>
Subject: [PATCH] scsi: target: iscsi: Fix HeaderDigest to cover AHS data
Date: Thu, 27 Aug 2026 10:05:36 +0800
Message-Id: <20260827020536.29835-1-ghuicao@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgDXXx91m49q9OxpOQ--.43841S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZFWUAFWDZF1fCF4kKrWrAFb_yoW8ury3pw
	s8Ww1jvr45u3y5ur47AF4Yqw1YqayrGFWjvFWfG34093Z8JFWq9a4Iga4agFy8trWvgF1a
	vr4qg345tF40qw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UpCJQUUUUU=
X-CM-SenderInfo: 5jkxxuldr6il2tof0z/xtbC4BaCFWqPm3bpagAA3q

From: Cao Guanghui <caoguanghui@kylinos.cn>

In iscsit_get_rx_pdu(), the HeaderDigest CRC32C is computed over only
the 48-byte basic header (ISCSI_HDR_LEN), excluding any Additional
Header Segments.  However, RFC 3720 Section 10.2.1.2 specifies that
the header digest covers "all the header segments of a PDU, i.e., BHS
and AHS."

The iSCSI initiator (libiscsi) correctly computes the digest over
BHS + AHS (task->hdr_len = 48 + hlength * 4), so any valid PDU with
both HeaderDigest negotiated and AHS present (e.g., SCSI commands with
Extended CDB) would fail CRC verification on the target side and be
falsely rejected.

Track the total header length in a local variable and use it for the
CRC computation so that the digest covers the full header as required
by the RFC.

Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Cc: stable@vger.kernel.org
Signed-off-by: Cao Guanghui <caoguanghui@kylinos.cn>
---
 drivers/target/iscsi/iscsi_target.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4026,6 +4026,6 @@ static void iscsit_get_rx_pdu(struct iscsit_conn *conn)
 {
 	int ret;
 	u8 *buffer, *tmp_buf, opcode;
-	u32 checksum = 0, digest = 0;
+	u32 checksum = 0, digest = 0, header_length;
 	struct iscsi_hdr *hdr;
 	struct kvec iov;
@@ -4053,8 +4053,10 @@ static void iscsit_get_rx_pdu(struct iscsit_conn *conn)
 		}
 
 		hdr = (struct iscsi_hdr *) buffer;
+		header_length = ISCSI_HDR_LEN;
 		if (hdr->hlength) {
 			iov.iov_len = hdr->hlength * 4;
+			header_length = ISCSI_HDR_LEN + iov.iov_len;
 			tmp_buf = krealloc(buffer,
 					  ISCSI_HDR_LEN + iov.iov_len,
 					  GFP_KERNEL);
@@ -4082,5 +4084,5 @@ static void iscsit_get_rx_pdu(struct iscsit_conn *conn)
 			}
 
-			checksum = iscsit_crc_buf(buffer, ISCSI_HDR_LEN, 0,
-						  NULL);
+			checksum = iscsit_crc_buf(buffer, header_length, 0,
+						  NULL);
 			if (digest != checksum) {
-- 
2.34.1

