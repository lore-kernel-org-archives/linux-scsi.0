Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D9042CB19;
	Mon,  6 Jul 2026 09:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783329301; cv=none; b=SVyE5cnNfdbZv8eRZipHrVh1vrpNBlEWe9FrYVaivDhlteACsaAVi5MjeBXuhVgms8FSLOHDQKrjcJumiVYmk5u9cjOLUqhtzg/nCg/pRx3q3J7f4kKkRaJRmErySjH+hEStxKB7bHpgO/YbQpkYxdtvDle71TWfGUWSqiDtImM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783329301; c=relaxed/simple;
	bh=I0l1TmY+4WUC7T8BmrT/+R5RJBO69D+iu9VhsTrl5+E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E7LUJKWTVaIL7h7zvWPdfvdgxVO3+TWU0SwYFKH80H7hrS7RasBayDNg4r5Sb+LSPzZhQnyqFlXoTRtz9ljwwgsAP8G2unoLditdV+4wYM5SH2MEOkh41E/4OPtPq0XJK7grSBJ6oVYiwONXeJpkDhT8qO33gi4/A9yA8A1Krv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.245.140])
	by APP-01 (Coremail) with SMTP id qwCowADHZc4BcktqdgTxBA--.35036S2;
	Mon, 06 Jul 2026 17:14:42 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Pengpeng <pengpeng@iscas.ac.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Brian Bunker <brian@purestorage.com>,
	Riya Savla <rsavla@purestorage.com>,
	Krishna Kant <krishna.kant@purestorage.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Hannes Reinecke <hare@suse.de>,
	Kees Cook <kees@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: scsi_dh_alua: validate RTPG descriptors
Date: Mon,  6 Jul 2026 17:14:40 +0800
Message-ID: <20260706091440.77131-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowADHZc4BcktqdgTxBA--.35036S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Wry7Ww43tFyDAr4UJw48Crg_yoW8JF43pF
	yDGa4YyryUWF17uF1Uuw4Iq3W3uay09ayfWay2v3s5CasrJFW5try3Kr1Yqa97JFZ7XryU
	Zr1Yya47ZFn8Cr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8Jw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0JUL0edUUUUU=
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

From: Pengpeng <pengpeng@iscas.ac.cn>

alua_rtpg() walks REPORT TARGET PORT GROUPS descriptors using the
response length, but the loop reads descriptor bytes 2 and 7 before
proving that the current descriptor has the fixed eight-byte header.

Stop parsing a truncated trailing descriptor before reading its group id,
state fields or relative target port count.

Signed-off-by: Pengpeng <pengpeng@iscas.ac.cn>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 80ab0ff921d4..f63f32bad12a 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -681,7 +681,12 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	for (k = tpg_desc_tbl_off, desc = buff + tpg_desc_tbl_off;
 	     k < len;
 	     k += off, desc += off) {
-		u16 group_id = get_unaligned_be16(&desc[2]);
+		u16 group_id;
+
+		if (len - k < 8)
+			break;
+
+		group_id = get_unaligned_be16(&desc[2]);
 
 		spin_lock_irqsave(&port_group_lock, flags);
 		tmp_pg = alua_find_get_pg(pg->device_id_str, pg->device_id_len,
-- 
2.43.0

