Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD24205AD0;
	Fri,  2 May 2025 22:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746225721; cv=none; b=ebVzRPw25Ez+bOOoRXN78K94GFyMMfciaMhrq0kd81/ddZdx5sUfcm+1iRI0nS19OdPE+OGHCqN0FhG/EOIwX4abdS6/wM2RPBu2/JJ/t7eNJQ3NAe6Mfl6ikkHwZKc+0uii9eps0qsv9f7f8uZBVz0S37gBr5o/6q64HlIDL0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746225721; c=relaxed/simple;
	bh=pQj86fi+y58xx2m3KZLT/z77OBsLn8M0nibe3HnDK7U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jGtQLaXbCbAAkX3Lcv7c4KfmZDVmPrnTS2/YCE2j+uDsDkpbxLndmFq7thRMF0mwLdcCxry+2UguDjh/YhW+ghm893Ol+GXXg/u1AbOVptMYtQ+tXn3b8RcgYC4cTeE7eLO2MzNSKTmEqjck7jEemC/zRYmoRim+O9t2DxXiOeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NSxZY+rZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NSxZY+rZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82EFEC4CEE4;
	Fri,  2 May 2025 22:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746225721;
	bh=pQj86fi+y58xx2m3KZLT/z77OBsLn8M0nibe3HnDK7U=;
	h=From:To:Cc:Subject:Date:From;
	b=NSxZY+rZq9oWnD7JrCGpyizGSeRNouZrQ1dmNPdnqfeuhFRKI3xaHzmqg9xwmrYbx
	 8EWa8lhojJVY6/yRZLZwDTcbEPoqNmTEG2j3Sxoo0G/B/plyC+OniRxE7SH/OMDYV+
	 plXH1rkvv/xOjXWK9GzES6HjsaExh3lvElJKxCutrPPznZmtyPrqhDfiYzbnXwKp17
	 T4n5fyBlDqPQzJFeKmsFmfiK0yciBnAZ03Be5ya0TzF2xIMPMfgB00Uu7hQWy4v4oq
	 suUmuZMmyR+711PWq11Muzuc1epCzorfMHelTdlEpGiNBeu8oZa+APbmFrXCs1vtcF
	 loBmGOZRaUDHQ==
From: Kees Cook <kees@kernel.org>
To: Saurav Kashyap <skashyap@marvell.com>
Cc: Kees Cook <kees@kernel.org>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	WangYuli <wangyuli@uniontech.com>,
	Mark Brown <broonie@kernel.org>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] scsi: qedf: Use designated initializer for struct qed_fcoe_cb_ops
Date: Fri,  2 May 2025 15:41:57 -0700
Message-Id: <20250502224156.work.617-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1485; i=kees@kernel.org; h=from:subject:message-id; bh=pQj86fi+y58xx2m3KZLT/z77OBsLn8M0nibe3HnDK7U=; b=owGbwMvMwCVmps19z/KJym7G02pJDBmiXqbRW+858Tw8Ii8nZtjQf76adbfHWRN/rZcViwp+H +pw9TLrKGVhEONikBVTZAmyc49z8XjbHu4+VxFmDisTyBAGLk4BmMhnLkaGP1EW0ltS1ANcF7sU s9y89vaph4fVn/DLQVFPqsTNG+u5GRk2bX4o/a4x2uCblSPH+ianaY+n+CyK2xYZ/MZyvWClnCs LAA==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Recent fixes to the randstruct GCC plugin allowed it to notice
that this structure is entirely function pointers and is therefore
subject to randomization, but doing so requires that it always use
designated initializers. Explicitly specify the "common" member as being
initialized. Silences:

drivers/scsi/qedf/qedf_main.c:702:9: error: positional initialization of field in 'struct' declared with 'designated_init' attribute [-Werror=designated-init]
  702 |         {
      |         ^

Fixes: c2ea09b193d2 ("randstruct: gcc-plugin: Remove bogus void member")
Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Saurav Kashyap <skashyap@marvell.com>
Cc: Javed Hasan <jhasan@marvell.com>
Cc: <GR-QLogic-Storage-Upstream@marvell.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: <linux-scsi@vger.kernel.org>
---
 drivers/scsi/qedf/qedf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 436bd29d5eba..6b1ebab36fa3 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -699,7 +699,7 @@ static u32 qedf_get_login_failures(void *cookie)
 }
 
 static struct qed_fcoe_cb_ops qedf_cb_ops = {
-	{
+	.common = {
 		.link_update = qedf_link_update,
 		.bw_update = qedf_bw_update,
 		.schedule_recovery_handler = qedf_schedule_recovery_handler,
-- 
2.34.1

