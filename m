Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1ADF288CC;
	Tue, 14 Jan 2025 02:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736823053; cv=none; b=aRjMjfr4TmUGkKxmiMJz8i72X6hlSxdYQJDtTq8irpPezXbSETVYpcjvvSeWsb7K+tAgDxh/T3OjhVb4OWrAoynGHGK2sck23u0cS2Mt1jUmvfH8zaaRb0eAIXmZLUpLAwLDu31saD265PLYoUWL1cotdwzzFx92kv1t/1MT0tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736823053; c=relaxed/simple;
	bh=UWm5y3/ZMfaopHeKjuu2vUzbf6Kl301/+o54N2DrBi0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pE1QBuvW44UxR3CoeYq0KIOKjcPE5/d6bszUWTS/mRr2y0B7zKLtQQyN+WAIdbyj3B4cgM8jV9aoWMybiCsHtGGfG6X1DzvYjcwIFldZhCqiXcOjNUnfO2K5WPMAzG7sWQVfhg5ToPfx9BS+gMf7NyWJ4QxxuTxDet5Hfj4lqHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=DL02xFYK; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="DL02xFYK"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1736823047; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=EU6TwagGDoibJv2sST+W8dmh99DbdVuapWToYMqbmvI=;
	b=DL02xFYKDotTi3WmZEp7KDu/VKr7Dxy1Ds1DWdHY+nXuDxAXNOZTiBMGySTUshQ9kKAMGAp4wZ/lyVjoFWIApvngPCsJhqenG9saHwptw2i52RBUJDuGp8lK+C+1qsnxz2tv4iZt14G3816sdB1mNJqt3JBHAxHCROWIv/q+iu8=
Received: from localhost(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0WNdF3uB_1736823041 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 14 Jan 2025 10:50:47 +0800
From: Guixin Liu <kanie@linux.alibaba.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH] scsi: target: core: add line break to status show
Date: Tue, 14 Jan 2025 10:50:41 +0800
Message-ID: <20250114025041.97301-1-kanie@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To ensure the output is not tangled with the shell prompt, add a
line break to clearly display the status.

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
---
 drivers/target/target_core_stat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index c42cbde8a31b..210648a0092e 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -117,9 +117,9 @@ static ssize_t target_stat_tgt_status_show(struct config_item *item,
 		char *page)
 {
 	if (to_stat_tgt_dev(item)->export_count)
-		return snprintf(page, PAGE_SIZE, "activated");
+		return snprintf(page, PAGE_SIZE, "activated\n");
 	else
-		return snprintf(page, PAGE_SIZE, "deactivated");
+		return snprintf(page, PAGE_SIZE, "deactivated\n");
 }
 
 static ssize_t target_stat_tgt_non_access_lus_show(struct config_item *item,
-- 
2.43.0

