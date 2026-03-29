Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FEA22F77B;
	Sun, 29 Mar 2026 03:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774753799; cv=none; b=bzYDR8nJGRQc9oEf1niO5DyUoo6R9brVTaOleL8o0fOWtdqIdeNletrjlDWnoM54pIjgEvtC1SxN00lFnA2e9YolwtGXdnaemFDQHtjTJ4GuuSkEfF7t5HWVBH8CGq7XnUyMzseYcLmfJN8NiyF8eneyHLUoQoLEYYGg3sxaBA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774753799; c=relaxed/simple;
	bh=1ypui5SWBO1NNiClej+/mdKywGLKHZSGRgzd6GrhxaU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FkEaQ0Tw0nSUa2yA5vn1AxObLSy5U4z+ixSzvQaJxDw5zuvWYEMM1F1n9ewH05ygh6Wiq1KjZgt9l7c3M8IIZgNqr4BD9cRU7Z+wDMO4pAV0nxEAGd68fuBNJcuj5kpQpCyT6y3U6Xor/osAbOoS5zim+KJfhZggomu2fXHi1rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.245.197])
	by APP-01 (Coremail) with SMTP id qwCowAB3Hmr4l8hpied8Cw--.15793S2;
	Sun, 29 Mar 2026 11:09:45 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: anil.gurumurthy@qlogic.com,
	sudarsana.kalluru@qlogic.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: kgudipat@brocade.com,
	JBottomley@Parallels.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pengpeng@iscas.ac.cn
Subject: [PATCH] scsi: bfa: reject unterminated adapter name payloads
Date: Sun, 29 Mar 2026 11:09:44 +0800
Message-ID: <20260329030944.30334-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAB3Hmr4l8hpied8Cw--.15793S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tF4rZFyrGF15Cr4fZF1fWFg_yoW8XFykpa
	y3Xas8ur1UJr10ya1rArWrZa98Ca1xKrWDGFWrZas5C3Wvvr9rZF1rJFy0qFn3GF18K39x
	XF4kt34UXFy8JrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoWlkDU
	UUU
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

bfad_iocmd_ioc_set_name() copies the fixed-length BSG request name field into equally sized kernel buffers with strcpy(). The request path validates the payload size, but it does not require the source field itself to be NUL terminated.

Reject full-length unterminated names and copy accepted names with strscpy() instead of strcpy().

Fixes: f2ee76017b30 ("[SCSI] bfa: Extend BSG to support more user commands")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/scsi/bfa/bfad_bsg.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 292bc9aa43f1..4a78de3cb0ab 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -199,10 +199,18 @@ bfad_iocmd_ioc_set_name(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_ioc_name_s *iocmd = (struct bfa_bsg_ioc_name_s *) cmd;
 
+	if (strnlen(iocmd->name, BFA_ADAPTER_SYM_NAME_LEN) >=
+	    BFA_ADAPTER_SYM_NAME_LEN) {
+		iocmd->status = BFA_STATUS_EINVAL;
+		return 0;
+	}
+
 	if (v_cmd == IOCMD_IOC_SET_ADAPTER_NAME)
-		strcpy(bfad->adapter_name, iocmd->name);
+		strscpy(bfad->adapter_name, iocmd->name,
+			sizeof(bfad->adapter_name));
 	else if (v_cmd == IOCMD_IOC_SET_PORT_NAME)
-		strcpy(bfad->port_name, iocmd->name);
+		strscpy(bfad->port_name, iocmd->name,
+			sizeof(bfad->port_name));
 
 	iocmd->status = BFA_STATUS_OK;
 	return 0;
-- 
2.50.1 (Apple Git-155)

