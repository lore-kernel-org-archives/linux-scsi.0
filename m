Received: from mta.al2klimov.de (mta.al2klimov.de [162.55.223.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E103E832A;
	Wed, 20 May 2026 18:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.55.223.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300276; cv=none; b=YIkqwkUHbo+d68D6RrxkvObYz11upQja8ll4+WSqG/b4gWeLhTbVZTxoOLYJ+nQqr8KsRLuHF97T8nXTD2c8wjOUL6fch3gcrcxRZqhEJ1XsZKuE9ooSeJhz7X000URg2ixfqqa5zCWRtrULt3UAqrgVXQcDXDBElzDFzg0l7vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300276; c=relaxed/simple;
	bh=ZA+lEEDncynlWucSKdTaTCH2tn9ptoWSDqJayvUXlcE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m71Ky8mq0xM500hGxXNLVXuD90cOn6P1e4x1Wm/yenn1GfyXSv+rQNLV3wdbOiS2oL7EbX0UWilOrrlShIYvy5JQcT5uHwCl3kJOFv9Sftswg08YKvqxA/p2VJ6frYE5uqeeecRD5zdFwkU1DpG/EKeqp50s8yfJezv4TvKFxiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=al2klimov.de; spf=pass smtp.mailfrom=al2klimov.de; dkim=pass (2048-bit key) header.d=al2klimov.de header.i=@al2klimov.de header.b=jeuE3qaS; arc=none smtp.client-ip=162.55.223.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=al2klimov.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=al2klimov.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=al2klimov.de header.i=@al2klimov.de header.b="jeuE3qaS"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; s=default; bh=ZA+lEEDncynl
	WucSKdTaTCH2tn9ptoWSDqJayvUXlcE=; h=date:subject:cc:to:from;
	d=al2klimov.de; b=jeuE3qaSsY2Belw022WrStl7hfFTcIdhNj9cuF9BanRnMtSYFQXf
	oeI8m8qRNBbm484kRIdL1I0ltH7cU5jZiFb3IwoUjN5W5ERt9+imQEFVJLu7lNQQb/1h7r
	FLNNkG1IlDbSI95yEy8xjuF/AoOG91+LkUr3eV1VrlACAZYz3Eun4iv9n+BtSeyjfsGx84
	sDgcW6+jcZG6bqJcZxzCGBOT7wTut+1G52zQkXQTsG8ZuBesG3pJY66LL6V38IrKEoPKVE
	q4lGKrgGNoEfjdaRozgkG+ZUfJS4P3nYXCxJgWufUIWaSGwAF4ihzFx/e8YiLuAxRWC+h8
	5hFDtY0+WQ==
Received: from cachy-ak (2a02-2455-18e9-e011-4d8a-aad2-c25c-50e5.dyn6.pyur.net [2a02:2455:18e9:e011:4d8a:aad2:c25c:50e5])
	by mta.al2klimov.de (OpenSMTPD) with ESMTPSA id 0eddb8cd (TLSv1.3:TLS_CHACHA20_POLY1305_SHA256:256:NO);
	Wed, 20 May 2026 18:04:32 +0000 (UTC)
From: "Alexander A. Klimov" <grandmaster@al2klimov.de>
To: Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com (maintainer:QLOGIC QLA2XXX FC-SCSI DRIVER),
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Quinn Tran <qutran@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	linux-scsi@vger.kernel.org (open list:QLOGIC QLA2XXX FC-SCSI DRIVER),
	linux-kernel@vger.kernel.org (open list)
Cc: "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH] scsi: qla2xxx: fix NULL deref, check user input
Date: Wed, 20 May 2026 20:03:57 +0200
Message-ID: <20260520180401.539215-1-grandmaster@al2klimov.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

qla2x00_dfs_fce_write() did this:

    OUTPUT = kstrtoul(INPUT, BASE, 0);

Whenever INPUT was successfully parsed, kstrtoul() wrote its output
to *(unsigned long*)0. Otherwise, OUTPUT was set to an error value.
I added proper error handling and call kstrtoul() as expected now:

    ERROR = kstrtoul(INPUT, BASE, &OUTPUT);

Fixes: 841df27d619e ("scsi: qla2xxx: Move FCE Trace buffer allocation to user control")
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
---
 drivers/scsi/qla2xxx/qla_dfs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 43970caca7b3..efb0fb198a30 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -510,7 +510,14 @@ qla2x00_dfs_fce_write(struct file *file, const char __user *buffer,
 		return PTR_ERR(buf);
 	}
 
-	enable = kstrtoul(buf, 0, 0);
+	rc = kstrtoul(buf, 0, &enable);
+	if (rc) {
+		ql_dbg(ql_dbg_user, vha, 0xd03d,
+		    "fail to parse user input.");
+		rc = -EINVAL;
+		goto out_free;
+	}
+
 	rc = count;
 
 	mutex_lock(&ha->fce_mutex);
-- 
2.54.0

