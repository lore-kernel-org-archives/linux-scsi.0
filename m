Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F04279DAF;
	Thu, 11 Jun 2026 05:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781155872; cv=none; b=PUXPp7hSJ7/mrFEq4V5N/uJDc7PwK9scpkr3IpjuveHENV4TkKhHVKEfPFXVXRvyg94z03bYu9WGcwYmE3Ui9KYr7A+4YvtX7f+1dtE6UhxO3uXrmBwftBIFL3+Cy/AX8z7w4475/dbmb4D0FsS7BbIdN4ysBgbg/k6KgklhxXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781155872; c=relaxed/simple;
	bh=IRM+dtaQotklCxJJoISuAXvpw9PcSf9XUvbWScma7Mk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lEqmYYTEtS9HmOcSqDF8k2BE7pkAvrgjXgMkr6CbaEBK7x5CLEzpdLuslwYyLYa9yXmpZZLDAGUgsE+JkrLO1Np1IcGIrhHpNGZdFGkiEcj7vjYLEBvllm4jy3SJ7xt+JUMgz8QLUpY2oxEbbECL7evyh5+UI3iKe6s1oqYK67s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [117.182.75.76])
	by APP-05 (Coremail) with SMTP id zQCowACnMwf_Rypq8qYNEw--.21366S2;
	Thu, 11 Jun 2026 13:30:41 +0800 (CST)
From: WenTao Liang <vulab@iscas.ac.cn>
To: Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>,
	WenTao Liang <vulab@iscas.ac.cn>,
	Daniel Wagner <dwagner@suse.de>,
	Kees Cook <kees@kernel.org>,
	James Smart <jsmart2021@gmail.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] scsi: elx: efct: fix refcount leak in efct_hw_io_abort()
Date: Thu, 11 Jun 2026 13:30:37 +0800
Message-ID: <20260611053037.63756-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowACnMwf_Rypq8qYNEw--.21366S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF17ZrW3Xw45Zr1ftrWDurg_yoW8Wr45pa
	n7u34DuryDXa1xKr48Cr4YyFy8Zws2qr98Gr1rW3y3u3yfJw1rta17Wasa9F1rA3WkKasI
	gFsrGryIqF4DArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCQ8PA2oqQiIRXgAAsl

When efct_hw_reqtag_alloc() fails in efct_hw_io_abort(), the error
path returns -ENOSPC without releasing the reference obtained via
kref_get_unless_zero() earlier in the function. All other error
paths correctly drop the reference. This causes a permanent
reference leak on the io_to_abort object.

Additionally, the abort_in_progress flag is left set to true on
this path, which means future abort attempts for the same I/O will
immediately return -EINPROGRESS even though the abort was never
submitted, effectively blocking recovery.

Fix this by adding the missing kref_put() call and reset
abort_in_progress to false, matching the cleanup done in the
efct_hw_wq_write() failure path below.

Cc: stable@vger.kernel.org
Fixes: 63de51327a64 ("scsi: elx: efct: Hardware I/O and SGL initialization")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/elx/efct/efct_hw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index 1838032f6486..b79c6a7ea791 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -1997,6 +1997,8 @@ efct_hw_io_abort(struct efct_hw *hw, struct efct_hw_io *io_to_abort,
 	wqcb = efct_hw_reqtag_alloc(hw, efct_hw_wq_process_abort, io_to_abort);
 	if (!wqcb) {
 		efc_log_err(hw->os, "can't allocate request tag\n");
+		io_to_abort->abort_in_progress = false;
+		kref_put(&io_to_abort->ref, io_to_abort->release);
 		return -ENOSPC;
 	}
 
-- 
2.50.1 (Apple Git-155)

