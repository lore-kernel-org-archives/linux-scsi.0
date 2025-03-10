Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2366A1F0980;
	Mon, 10 Mar 2025 22:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741645559; cv=none; b=LcabxHSGno7fuFAWWwmoLSgoGC2Q2Ag2X1hJEibzouy5XMOXELdGlpcbf6TIZ3MuJzMVT3yp7YFk7iFH4kT3eMEQZhwbQiu58Ehuv22I5yGzmbvbAxUYSgRp1b+DZKsnQ48fQZIpPvBeIpHG1+IghdAUqxbOvM+ICykGgVwJdp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741645559; c=relaxed/simple;
	bh=TbMG0G5ruPGPNuDA0sR4FCIF3PfxM4T3VhFvCKDb0ik=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=azLr0dsCqkOVnLIHUgUjBtsBc2DPTQYDp2sds7u9KgXjJ8/bwLgZg58sfmYdM9RrKQVPwT3C/Mbu/2IQ3Wemhkgr9NMf+oMqd/MTd9ZvuoraTxGdQEIeo7qftnIa2K2LxjcsQfpHOZzceWyj1BOd6/AdfntFt+tgMhniFvilOuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SObI+u1e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SObI+u1e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8C9C4CEE5;
	Mon, 10 Mar 2025 22:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741645558;
	bh=TbMG0G5ruPGPNuDA0sR4FCIF3PfxM4T3VhFvCKDb0ik=;
	h=From:To:Cc:Subject:Date:From;
	b=SObI+u1eHtJrhNrnNfjdzHiVMO4L8czNpI1B6OJ4x5ZSOMbMMB0YbRm/2LlTh/TS6
	 OoLC3cw4tKh3alP5FS/bNutCrIfJtmVbAdiKv6iAtgk4Dmf/PKpO5F/sh9Uw7jXQEP
	 q7Z9ik64BbPw5dRXFNAjkPGkOOZL2ec+jeALQmKyWEzMmQiUnZzJvEHW9CQs3zoejJ
	 NhAG4iB+HyR2AnVO1rtbTryY7T4nG6RJeiglH2h+y0Ce6zT3PnJboCfLvP4401J1P6
	 /9STKfOqRpxoaug8EtaTQ02l/40XMr2ZfaDHc4ncndvAPvGonzTTQWo7lmJKPPyceP
	 cgLbcNBsVpWwA==
From: Kees Cook <kees@kernel.org>
To: Jack Wang <jinpu.wang@cloud.ionos.com>
Cc: Kees Cook <kees@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] scsi: pm80xx: Add __nonstring annotations for unterminated strings
Date: Mon, 10 Mar 2025 15:25:54 -0700
Message-Id: <20250310222553.work.437-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1200; i=kees@kernel.org; h=from:subject:message-id; bh=TbMG0G5ruPGPNuDA0sR4FCIF3PfxM4T3VhFvCKDb0ik=; b=owGbwMvMwCVmps19z/KJym7G02pJDOnn0z5FMwuoJQrkmhhPNm2ely9wMjZlo5l1bMfVEI6Zc SJ7Ba07SlkYxLgYZMUUWYLs3ONcPN62h7vPVYSZw8oEMoSBi1MAJnKXn5Hh/uskyVku/kFROc07 /dbx9717q5Mw2edvRMSld+1h4qlqDP9rjFcJlz3Sa365vpp5V0/91aceahObeTa4uEn/ennglRI rAA==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

When a character array without a terminating NUL character has a static
initializer, GCC 15's -Wunterminated-string-initialization will only
warn if the array lacks the "nonstring" attribute[1]. Mark the arrays
with __nonstring to and correctly identify the char array as "not a C
string" and thereby eliminate the warning.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=117178 [1]
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 85ff95c6543a..7618f9cc9986 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -644,7 +644,7 @@ static DEVICE_ATTR(gsm_log, S_IRUGO, pm8001_ctl_gsm_log_show, NULL);
 #define FLASH_CMD_SET_NVMD    0x02
 
 struct flash_command {
-     u8      command[8];
+     u8      command[8] __nonstring;
      int     code;
 };
 
-- 
2.34.1

