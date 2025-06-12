Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E23153598
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jun 2025 06:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749708238; cv=none; b=a7E1sYU8VT4gbOX+JKiafBxvuXV32xT9LyTP0mGidW7DvgrH510B4r3ne3QbTRaAmA+F+qQSYgWY0/OfbqaIs3ARFDYJOI/IMivm4kE00TKCWipTiIgUR7+ukdklXKhfl6GX0/BPkZ8xnkRL15A9anMMrSjXJw6bEACQVsPxH9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749708238; c=relaxed/simple;
	bh=P5cmbp+JrIEdQA7V5tHfp44IdO3jmgVd2jpBOgGatGs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=LT/FUYshusmeGy5f2ON2saMI5OmY0P6cCDKSmzSzNznomYKPsmURXrcExrd6kTm2vcvUZB+RD0hfkRUMV+n5da0+XQ2K8BwkJLHhllsPo/9qNa2O8I2XkQTImAkrtqT73TrlQYhwhwZxrbTZ+JhjPKyXWJhVLHBRJiOzzTZU8yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=apld2TaK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="apld2TaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8D2C4CEEB;
	Thu, 12 Jun 2025 06:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749708237;
	bh=P5cmbp+JrIEdQA7V5tHfp44IdO3jmgVd2jpBOgGatGs=;
	h=From:To:Subject:Date:From;
	b=apld2TaKxEzZ5yg7MrXt1OIFoccedoeGzIWlxD0nQqRbAk5jhg5W6GvRSWAJUK7ai
	 BTxv9fxXpP8bGvPh80mswDeODLUGs38giA+KqJOlW23mGeHkRXwmaZeHfaMe6gdPR3
	 TjNSeXasV06GE/tWSbJais6ef/e1tmVZ2AMN3ZDJ2lRXcSJiH6+zAGvpv1kN8Kv2gc
	 P9KM181mcT85KQSYb7G6kDJGh/pib30NzVRwx8PEbPp0nqiq9qiJCOdS7o0IuqPu6e
	 4ns/N1H/QWoSkxLXtnFaRrvhIIqHHStvOFpOO8YNyr+Ydl4FSE52e2FtXZqLPoImLF
	 FcgGTYzP2GonQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v3 0/2] Improve optimal IO size initialization
Date: Thu, 12 Jun 2025 15:02:09 +0900
Message-ID: <20250612060211.1970933-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A couple of patches to improve setting the optimal I/O size limit of
scsi disks. A fallback default is added to make sure we always have a
non-zero optimal I/O size so that file systems operate with a
reasonnably sized default read_ahead_kb value, for improving buffered
read performance.

Changes from v1:
 - Changed message level from wrong WARNING level to INFO level
 - Added review tag

Changes from v2:
 - Added patch 1
 - Make sure we do not overflow variables and limits in patch 2

Damien Le Moal (2):
  scsi: sd: Prevent logical_to_bytes() from returning overflowed values
  scsi: sd: Set a default optimal IO size if one is not defined

 drivers/scsi/sd.c | 45 +++++++++++++++++++++++++++++++++++----------
 drivers/scsi/sd.h |  2 +-
 2 files changed, 36 insertions(+), 11 deletions(-)

-- 
2.49.0

