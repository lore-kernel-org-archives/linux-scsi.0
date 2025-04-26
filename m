Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E93F6FC3;
	Sat, 26 Apr 2025 06:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745648396; cv=none; b=OmacnC9pdn3OUXJwi1NzvK102j6YdANPj+tOP3pn35DfrYCqMJNfBasB2uF22x9kV1smD+x+8tTN+M1EkRIn5/tYWM7TZbPbyiwQVN+bFNwA+7zwUBimWxbPVwJb4JGB7aT/8Q2pmh35pcvjEzKrKFrTJgUbBZD4giBUKv+Gp3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745648396; c=relaxed/simple;
	bh=x+wjGCxq6CdZEfzj11+IBzAkoE449GT6JMAUDrUw0OU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oE4hKkZlk+4HPavs/bb2ekbwxbhOsD4o68WgcAMUdl0VGwWadoZT/sWwKvysvi/703A4ANEaovSk1yyGHCitRu5b93w+W1VaI5YySMsIu0YrWlZ0euH9tjvXaW96e8jieV+3FaWpuACJrtR8ZseYk/UYzNuPkfHUV5WDwnYD7Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=np/IU0g7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="np/IU0g7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00781C4CEE2;
	Sat, 26 Apr 2025 06:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745648396;
	bh=x+wjGCxq6CdZEfzj11+IBzAkoE449GT6JMAUDrUw0OU=;
	h=From:To:Cc:Subject:Date:From;
	b=np/IU0g7FT3imZCnYT5lawGi45+ka2Uay8DuA+dvxERUE9O7gkCYbQxEGkUpAQb9t
	 w3HUORylDb3DyFi2BoYHTPt2vJpmC9PC3Hwe1I8mb0PF6vqEF9ZH/K6hpPTXAhMyFm
	 0XvPEg1yLtWZRWIYuLnDDvZxgqWPbvi8668p9K29aojMo9PujgsMZePyB3u7aI7ztz
	 xG4hyDU+YYAU2bCCOUtSkotZQEXRxqnJfV7WoBec7aYWF2hEXCrERM7JX7cKFYeu3w
	 tfcZAJW6MhVqvP8d4pU8GOl/5paUA4fiHXvqFYS4IpFIVO/bb8mWm1oeXBpU+a6OEd
	 rZ/QjRmhsYAOA==
From: Kees Cook <kees@kernel.org>
To: Nilesh Javali <njavali@marvell.com>
Cc: Kees Cook <kees@kernel.org>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] scsi: qla2xxx: Remove duplicate struct crb_addr_pair
Date: Fri, 25 Apr 2025 23:19:52 -0700
Message-Id: <20250426061951.work.272-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1373; i=kees@kernel.org; h=from:subject:message-id; bh=x+wjGCxq6CdZEfzj11+IBzAkoE449GT6JMAUDrUw0OU=; b=owGbwMvMwCVmps19z/KJym7G02pJDBk81eyal94sbD/Hv2iPyusPfkKNT6fm1Nk+Spwml3LUc cEmdiWnjlIWBjEuBlkxRZYgO/c4F4+37eHucxVh5rAygQxh4OIUgIkwaDMybPNTZFzL+1ZAfEEr Q/36vImHYq98TzONbcs72NkYfv3iTUaGqWnFdrevnV6yaX1mnMA1LTUTWXnuc0Es7kzdFuYem/x YAA==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

In preparation for making the kmalloc family of allocators type aware,
we need to make sure that the returned type from the allocation matches
the type of the variable being assigned. (Before, the allocator would
always return "void *", which can be implicitly cast to any pointer type.)

The assigned type is "struct crb_addr_pair *" and the returned type will
be a _different_ "struct crb_addr_pair *", causing a warning. This really
stumped me for a bit. :) Drop the redundant declaration.

Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Nilesh Javali <njavali@marvell.com>
Cc: <GR-QLogic-Storage-Upstream@marvell.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: <linux-scsi@vger.kernel.org>
---
 drivers/scsi/qla2xxx/qla_nx.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 6dfb70edb9a6..470fe1d38973 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1099,11 +1099,6 @@ qla82xx_pinit_from_rom(scsi_qla_host_t *vha)
 	unsigned offset, n;
 	struct qla_hw_data *ha = vha->hw;
 
-	struct crb_addr_pair {
-		long addr;
-		long data;
-	};
-
 	/* Halt all the individual PEGs and other blocks of the ISP */
 	qla82xx_rom_lock(ha);
 
-- 
2.34.1

