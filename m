Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1202DC768;
	Wed, 30 Apr 2025 00:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745974030; cv=none; b=FdIJ0/zw5YxgOHHmX3E+ifynXwPeBKNk+6d3QMA6qi1pj2oRMXegGs8wIsmzs24Gcs5emldQzggVxAZHsFXXXMHxfsmh2ZLDbrSvkrfnlwGOzBOfh+f7+D4jNTmicVI+WaXcTgwmAn/DlMBQ5WtJULCFFigmWFLa7l/14apvFfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745974030; c=relaxed/simple;
	bh=0y9B9wg71iPcc94hYHsLcd4ggl+XIo8SKgRXNkzmgnQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=BLBkS7F/d05XT3mAIyigOawe2eAU0Omuv29ASTLzflM+//bUq38HcT9bMWdw+9HR+Iy2/fdEXs4tmMEF+PRFTrgXCafS44mDtdl5IlQf1AZ/hbcqPh46h3ryNnXFg2BhCZRtRV9YUYweZHM3rYgYq1Eg4k81XcEX9mbCCx0tBmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sdy2T0GX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sdy2T0GX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859E7C4CEE3;
	Wed, 30 Apr 2025 00:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745974030;
	bh=0y9B9wg71iPcc94hYHsLcd4ggl+XIo8SKgRXNkzmgnQ=;
	h=From:Date:Subject:To:Cc:From;
	b=sdy2T0GXO8CQlUN6voiRN1QFUXKDE5Aoouowjk4T3KqnfwqXPFd7eqJtTdIgVLcHk
	 lA10dVUhAHGMVG4+hLd1ENGrYkZfVSg1LSuiP1dipodi3K8c8HhK/uH4MyGkTrzXyl
	 9E+CG4mF7DePlUX6YBNqUzRiSs+X3ZMy1FFCNKphVe28Vs8qm4IBu9YQgcbP6giBNr
	 kPNKOj7AebpQEVe+cYXtnNdkrY5zhmyiPiID8/OgnXrtp1UEMXGltFkm5sU0YHib3l
	 /jwG+cUXFMAb2VasHwHokXZSApuPhVy6KxhQeaGiq8h1BvoyoNazF2b4a55xoyymQo
	 7f/oa0t0iAisg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 29 Apr 2025 17:46:49 -0700
Subject: [PATCH] scsi: dc395x: Remove leftover if statement in reselect()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250429-scsi-dc395x-fix-uninit-var-v1-1-25215d481020@kernel.org>
X-B4-Tracking: v=1; b=H4sIAPhyEWgC/x3MMQqAMAxA0atIZgPaqlivIg4ljZqlSqMiiHe3O
 D74/AeUk7DCUDyQ+BKVLWbUZQG0+rgwSsgGU5m2aoxDJRUMZF174yw3nlGiHHj5hFTTHPre+c4
 GyIM9cS7++Ti97wcvjvGybAAAAA==
X-Change-ID: 20250429-scsi-dc395x-fix-uninit-var-c1cfd889a63d
To: Oliver Neukum <oneukum@suse.com>, Ali Akcaagac <aliakc@web.de>, 
 Jamie Lenehan <lenehan@twibble.org>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Colin Ian King <colin.i.king@gmail.com>, linux-scsi@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1855; i=nathan@kernel.org;
 h=from:subject:message-id; bh=0y9B9wg71iPcc94hYHsLcd4ggl+XIo8SKgRXNkzmgnQ=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBmCxTxr1x745q7GrN2nevQjX6vWN0al5y/f3JvsWHg4Y
 u3r5HfGHaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAiv3gZ/lmJf69excOhbcHE
 fPHMXoH7qw+FKcnEXDAWvbfou3p7yFxGhpZuidc5kh9/H/r2wPyF/b6o5TKp2zOFPM7Nnf8myp/
 tBDMA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR=y):

  drivers/scsi/dc395x.c:2553:6: error: variable 'id' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
   2553 |         if (!(rsel_tar_lun_id & (IDENTIFY_BASE << 8)))
        |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  drivers/scsi/dc395x.c:2556:22: note: uninitialized use occurs here
   2556 |         dcb = find_dcb(acb, id, lun);
        |                             ^~
  drivers/scsi/dc395x.c:2553:2: note: remove the 'if' if its condition is always true
   2553 |         if (!(rsel_tar_lun_id & (IDENTIFY_BASE << 8)))
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   2554 |         id = rsel_tar_lun_id & 0xff;

This if statement only existed for a debugging print but it was not
removed with the debugging print in a recent cleanup, leading to id only
being initialized when the if condition is true. Remove the if
statement to ensure id is always initialized, clearing up the warning.

Fixes: 62b434b0db2c ("scsi: dc395x: Remove DEBUG conditional compilation")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/scsi/dc395x.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 95145b9d9ce3..96b335c92603 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -2550,7 +2550,6 @@ static void reselect(struct AdapterCtlBlk *acb)
 		}
 	}
 	/* Read Reselected Target Id and LUN */
-	if (!(rsel_tar_lun_id & (IDENTIFY_BASE << 8)))
 	id = rsel_tar_lun_id & 0xff;
 	lun = (rsel_tar_lun_id >> 8) & 7;
 	dcb = find_dcb(acb, id, lun);

---
base-commit: e142de4aac2aae697d7e977b01e7a889e9f454df
change-id: 20250429-scsi-dc395x-fix-uninit-var-c1cfd889a63d

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

