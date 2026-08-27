Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E51322DB7;
	Thu, 27 Aug 2026 06:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787812979; cv=none; b=KwtDII8WujDWiU8sTNz2mAcs/l+spRf6gIc5+IiP3V51GZ5iw9Ts/tyIKIVBNMs+wu/mvbUGafY91HS50uEviSd79knrHcojEWzUSHGrnEuRYhlKrxzlGWZE52QmPisHgWgNwktZgNw0q07b0OorNx0bccgd7yQFjImHeVx6iFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787812979; c=relaxed/simple;
	bh=pw1sL4GCKzOrVaTCSIyFIIP6qDP3kJo7hS6eJKxXYP0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AOzJjEb29E5BArlOic8pR9imL4gftzuUwyaftv6FrFvnu5Vg4DFppVvBAplLfFDG2KgtLfLOLddbytRvdz7WVA1PvsY096EkM0Pcxwl3fubp7+55aLWf4ME5KkD/uuP/xbGIPdCLY+14pKdgohyRizqj8Tk835nC3FIjWOsQmbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=jCwVpxmw; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="jCwVpxmw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=nr
	cvEP3Xhkd19RV4CkWuoVyi53edPcp87hFyJB/+lYw=; b=jCwVpxmwOv2d8zH0Ez
	B00RYhAtKeo14GoFrOGKgIgg7N0D+rZLZSoQDU4V2FXasvRW0x71XiADEVHQEoWr
	xLs10uPOCZ+VKHr/7x17oCMmAsWKVtbG2NT0mKh4hxX976q7uaE7EhuYYE9SsofL
	IblR5TAzN8/os3n7qQRqifT9Y=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wD3n1Ji3I9qCBuTRQ--.33879S3;
	Thu, 27 Aug 2026 14:42:44 +0800 (CST)
From: ghuicao@163.com
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Cao Guanghui <caoguanghui@kylinos.cn>
Subject: [PATCH v4 2/2] scsi: target: iscsi: Fix HeaderDigest to cover AHS data
Date: Thu, 27 Aug 2026 14:42:41 +0800
Message-Id: <20260827064241.88352-2-ghuicao@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260827064241.88352-1-ghuicao@163.com>
References: <20260827013245.21289-1-ghuicao@163.com>
 <20260827064241.88352-1-ghuicao@163.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3n1Ji3I9qCBuTRQ--.33879S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZFWUAFWDZF1fCF4kKrWrAFb_yoW8ury3pw
	s8Ww1jvr45u3y5ur47AF4Yqw1YqayrGFWjvFWfG34093Z8JFWq9a4Iga4agFy8trWvgF1a
	vr4qg345tF40qw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jUXocUUUUU=
X-CM-SenderInfo: 5jkxxuldr6il2tof0z/xtbC4ATOYWqP3GTxpQAA3C

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

