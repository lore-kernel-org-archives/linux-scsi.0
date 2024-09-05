Received: from mail.nfschina.com (unknown [42.101.60.213])
	by smtp.subspace.kernel.org (Postfix) with SMTP id F2DBA2746A;
	Thu,  5 Sep 2024 05:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=42.101.60.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725512596; cv=none; b=H8PUYWBqDg7dQ31egHkj83X6JM5xYXJVZHiFgM3DiqkqcKesUcr/jQcCQi2sGtiqj/QYadXDfjTyIJf4Jm2EuNrR4F+p70ubtGRwrFR1iXJkT0fYGiayRSYqDJJiIffIti8RlXpi65lAqSYRR0gKI1eM/dA0s5n+fusWGkELuW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725512596; c=relaxed/simple;
	bh=1OVdmWxQnf2gL69JNspl8eWwRpgkMv2erIHv+Q/JQ7A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=U/uc7O3BEFvWmyYfil/VLrOg81Jbu/UZYdvADWrkncn5usGUEAw0cWzMi0LJA2KDAhOZONpkbNjftqAWqiJ0OC6teseoSb5ifk6stB/bZHlvkZmkZUoNbJM/KjyTR6WrTC1Ds8JrcP8eebAwZAceEJxLgesDuZY1JM8h5WzWI5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com; spf=pass smtp.mailfrom=nfschina.com; arc=none smtp.client-ip=42.101.60.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nfschina.com
Received: from localhost.localdomain (unknown [180.167.10.98])
	by mail.nfschina.com (MailData Gateway V2.8.8) with ESMTPSA id 03187604FCB3F;
	Thu,  5 Sep 2024 13:02:53 +0800 (CST)
X-MD-Sfrom: suhui@nfschina.com
X-MD-SrcIP: 180.167.10.98
From: Su Hui <suhui@nfschina.com>
To: njavali@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	nathan@kernel.org,
	ndesaulniers@google.com,
	morbo@google.com,
	justinstitt@google.com
Cc: Su Hui <suhui@nfschina.com>,
	JBottomley@Parallels.com,
	saurav.kashyap@qlogic.com,
	atul.deshmukh@qlogic.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: qla2xxx: avoid possible garbage in qla8044_rd_reg_indirect()
Date: Thu,  5 Sep 2024 13:02:28 +0800
Message-Id: <20240905050226.1959592-1-suhui@nfschina.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clang static checker (scan-build) warning:
drivers/scsi/qla2xxx/qla_nx2.c:line 2542, column 16:
Assigned value is garbage or undefined.

In qla8044_minidump_process_l1cache(), there is a garbage value
problem as follows.

'r_value' is garbage when qla8044_rd_reg_indirect() failed, so
'*data_ptr++ = r_value' assigned  garbage value to 'data_ptr'.
There are many others examples like this which using
qla8044_rd_reg_indirect() but not checking the return value.
When qla8044_rd_reg_indirect() failed, let 'r_value = 0' to avoid these
garbage values.

Fixes: 7ec0effd30bb ("[SCSI] qla2xxx: Add support for ISP8044.")
Signed-off-by: Su Hui <suhui@nfschina.com>
---
 drivers/scsi/qla2xxx/qla_nx2.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index 41ff6fbdb933..97fd1c7833b4 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -92,11 +92,13 @@ qla8044_rd_reg_indirect(scsi_qla_host_t *vha, uint32_t addr, uint32_t *data)
 	struct qla_hw_data *ha = vha->hw;
 
 	ret_val = qla8044_set_win_base(vha, addr);
-	if (!ret_val)
+	if (!ret_val) {
 		*data = qla8044_rd_reg(ha, QLA8044_WILDCARD);
-	else
+	} else {
+		*data = 0;
 		ql_log(ql_log_warn, vha, 0xb088,
 		    "%s: failed read of addr 0x%x!\n", __func__, addr);
+	}
 	return ret_val;
 }
 
-- 
2.30.2

