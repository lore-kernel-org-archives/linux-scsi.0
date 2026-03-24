Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3E037B003;
	Tue, 24 Mar 2026 01:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774316710; cv=none; b=sCD/2LCKEoHS7H37O9h/Sj1oD7cZm3KefQp8stKS9/e0rOWzoUBCEtfFWX3vrljmXG1D+gZWJV+J0NVvyR19oh7Y3nFnuYrYAZRfx6ITVSeVn1yuknjbjmToDGo1ZIOy92Rci65awNbwBdZ7sCSrcTpRZh4XJQQL6U7EBDoPEWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774316710; c=relaxed/simple;
	bh=3/ba+0Tu2J42wBebKAy/fx2JJk6fT1FtjYW0yvm4CDY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NkYhbe+MgnJBCwMYgGcPTVsQvEi6rXEZv5KBmGV+YEvjIkh5tbsIlmDS57Nf8glUfnb68TPNkksxk19GXqbzAwJTY8BL1KcHvtosmAePvdmtM1lyOvpkOQw/zJex0c026Q3lo4fmeyneaZdsfk3aeLQUxGERvZEAJWqQmCxtX8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.245.197])
	by APP-05 (Coremail) with SMTP id zQCowACHGw+b7MFpza5JCw--.4486S2;
	Tue, 24 Mar 2026 09:44:59 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: njavali@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pengpeng@iscas.ac.cn
Subject: [PATCH] scsi: qla2xxx: validate reset template state indices
Date: Tue, 24 Mar 2026 09:44:59 +0800
Message-ID: <20260324014459.93363-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowACHGw+b7MFpza5JCw--.4486S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Cr1rCFW3Gw17Wr1xWFyfJFb_yoW8GF17pF
	W5Kry0yryUtrsrAr9rCF4Uu3Z5ua1SqrW8uFWkX3W2vrWkAFyqkr1Yga43Jr9xCws5A34S
	qFWkXFyUuFyqyFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUGVWUXwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUv385UUU
	UU=
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

qla8044_rmw_crb_reg() uses the reset template's index_a field to
select an entry from vha->reset_tmplt.array[]. The field is loaded from
the flash-backed reset template, but the driver does not verify that it
fits the 16-entry state array before indexing it.

Reject template entries whose state index falls outside the local reset
state array and flag the sequence as erroneous instead of reading past
the array.
---
 drivers/scsi/qla2xxx/qla_nx2.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index 41ff6fbdb933..caaf2275b611 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -239,10 +239,19 @@ qla8044_rmw_crb_reg(struct scsi_qla_host *vha,
 {
 	uint32_t value;
 
-	if (p_rmw_hdr->index_a)
+	if (p_rmw_hdr->index_a) {
+		if (p_rmw_hdr->index_a >= QLA8044_MAX_RESET_SEQ_ENTRIES) {
+			ql_log(ql_log_warn, vha, 0xb153,
+			       "%s: invalid reset template state index %u\n",
+			       __func__, p_rmw_hdr->index_a);
+			vha->reset_tmplt.seq_error++;
+			return;
+		}
+
 		value = vha->reset_tmplt.array[p_rmw_hdr->index_a];
-	else
+	} else {
 		qla8044_rd_reg_indirect(vha, raddr, &value);
+	}
 	value &= p_rmw_hdr->test_mask;
 	value <<= p_rmw_hdr->shl;
 	value >>= p_rmw_hdr->shr;
-- 
2.50.1 (Apple Git-155)

