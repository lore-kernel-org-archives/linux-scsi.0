Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5155C1D5CF6;
	Tue,  3 Sep 2024 20:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725396140; cv=none; b=NAQYtSwOWNrXE1ESPUbv9N7Q0glFLqgGdBSMdB/38/J0RpYyoM8Zpzc99Xty6rpgjLMs/ybiz9YiMT+Iri/VAQWky0mYVuzsJ+b1StbQG9DnKshYyrctX9rNA/y6wgN6VJDSGV1anYfbSWL01cZy7VKaVCS49B0gMe+RRo7sGC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725396140; c=relaxed/simple;
	bh=j45dtGe1JbA6NaHG0W7dRRtycTu/PakftatcafLRIr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bljRZNMs4NGyf199nN1A1IpGOG1DOifgJp3k9zmYe5LUqlDoeMq+wdi66n5TJTdXvaeJSjrY/oW0r6civA1/soFYUMs2tHZNAjucJvPV/2C57qKvv1yr4lYS010lqkqOZYvO61dMx1StF/0YD5e6jb9bAWk2v2sQb2nnyvNEL+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eD7r4+AN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eD7r4+AN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984F7C4CEC9;
	Tue,  3 Sep 2024 20:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725396139;
	bh=j45dtGe1JbA6NaHG0W7dRRtycTu/PakftatcafLRIr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eD7r4+AN5u90jhGBCVVVQ/VTL+Xs6xPjwKcb3fELICg+0+3myeBWh05MNXRT0Rccm
	 rT00Ug/zxDZr112/iL+eo0EGItlrVo/xC09fQXu1PtH+yaAVfGMtvu4ywKXGEvgJbN
	 62RNSpTbPmJgb6+P/cwstxLVmu4NaxvpH7/Qca4ktLHRvEv9GYsMlb9yF7RXygmZYS
	 nhbT79gw5Hb2rfPW0pl1Hv3EM4TCqJqBMjVqH9eSRKBZvSivefqsC4CLr/chiBd5F3
	 7B1OFEQ9C/XLGDVENVGZW4ROdH/DRSypjUmUu/UzGa1zdBmNPCKRqQuIqU48ypnB+X
	 3irkR8HIqHezg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Sherry Yang <sherry.yang@oracle.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.10 07/22] scsi: lpfc: Fix overflow build issue
Date: Tue,  3 Sep 2024 15:21:54 -0400
Message-ID: <20240903192243.1107016-7-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240903192243.1107016-1-sashal@kernel.org>
References: <20240903192243.1107016-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.10.7
Content-Transfer-Encoding: 8bit

From: Sherry Yang <sherry.yang@oracle.com>

[ Upstream commit 3417c9574e368f0330637505f00d3814ca8854d2 ]

Build failed while enabling "CONFIG_GCOV_KERNEL=y" and
"CONFIG_GCOV_PROFILE_ALL=y" with following error:

BUILDSTDERR: drivers/scsi/lpfc/lpfc_bsg.c: In function 'lpfc_get_cgnbuf_info':
BUILDSTDERR: ./include/linux/fortify-string.h:114:33: error: '__builtin_memcpy' accessing 18446744073709551615 bytes at offsets 0 and 0 overlaps 9223372036854775807 bytes at offset -9223372036854775808 [-Werror=restrict]
BUILDSTDERR:   114 | #define __underlying_memcpy     __builtin_memcpy
BUILDSTDERR:       |                                 ^
BUILDSTDERR: ./include/linux/fortify-string.h:637:9: note: in expansion of macro '__underlying_memcpy'
BUILDSTDERR:   637 |         __underlying_##op(p, q, __fortify_size);                        \
BUILDSTDERR:       |         ^~~~~~~~~~~~~
BUILDSTDERR: ./include/linux/fortify-string.h:682:26: note: in expansion of macro '__fortify_memcpy_chk'
BUILDSTDERR:   682 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
BUILDSTDERR:       |                          ^~~~~~~~~~~~~~~~~~~~
BUILDSTDERR: drivers/scsi/lpfc/lpfc_bsg.c:5468:9: note: in expansion of macro 'memcpy'
BUILDSTDERR:  5468 |         memcpy(cgn_buff, cp, cinfosz);
BUILDSTDERR:       |         ^~~~~~

This happens from the commit 06bb7fc0feee ("kbuild: turn on -Wrestrict by
default"). Address this issue by using size_t type.

Signed-off-by: Sherry Yang <sherry.yang@oracle.com>
Link: https://lore.kernel.org/r/20240821065131.1180791-1-sherry.yang@oracle.com
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 4156419c52c78..4756a3f825310 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -5410,7 +5410,7 @@ lpfc_get_cgnbuf_info(struct bsg_job *job)
 	struct get_cgnbuf_info_req *cgnbuf_req;
 	struct lpfc_cgn_info *cp;
 	uint8_t *cgn_buff;
-	int size, cinfosz;
+	size_t size, cinfosz;
 	int  rc = 0;
 
 	if (job->request_len < sizeof(struct fc_bsg_request) +
-- 
2.43.0

