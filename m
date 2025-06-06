Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8311F288C23
	for <linux-scsi@vger.kernel.org>; Fri,  6 Jun 2025 13:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749218369; cv=none; b=nhEJE67oRZrPkKqkoaE6u+aS/x2nv/H+07ejFQG5AaJCtjyfnCgZN2W0joM5jaHhGoFr25RAz7kMYLY0Or/IBQmjleVlffD374/4Wx3vAu0CBlrnww8gUx5XhzS10GHVOQW1HD4VqCimiOPZWabjWTCBRQDanUG+oPQqgqy3OVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749218369; c=relaxed/simple;
	bh=qodz7SlUlYyc/Eg84MNV4W5+dRM+O4sb2E+XCz+DFuI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=buAsQUggHt0Ih3mNRHEGi3G5idscjyVFn5f/OGw8DZ2RkB6tM6Ozk6yuoivDcUKY9o7QArGKrW0UxyVL1xnAlD7wcJRWECzFMJfiQMre+OJ9h4uldwUltaA1qBzsxMmpbvKjX7bQSOmnpSIr0JYE73NzLDWIHs2Db2ki0JrE6EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jYxfGbRe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jYxfGbRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C117FC4CEEB;
	Fri,  6 Jun 2025 13:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749218369;
	bh=qodz7SlUlYyc/Eg84MNV4W5+dRM+O4sb2E+XCz+DFuI=;
	h=From:To:Cc:Subject:Date:From;
	b=jYxfGbRek/o+7XaAc3cTiLb2yW8qL8YIw+O56v7Jxa68MQ2ISaJ623abaTXUGdmcH
	 VzEkTMtHqVDt+Ti2T5hQUnbOKa0I1IkCTlz4gfYLExqjqbBS+llMiSjOJ5MMk+ugQp
	 zPP9wkvGwkx+FrfNyDkK7mBdNfnD8LpKauy74IW90p4qytH4UkbqoVOtFWhws4ocVt
	 SGHsxzq0j13nK5H5+NDmHDp4snrMNoNL9T8NO0jry/nIdkyhJRUC5+M8y9Ad98NKoZ
	 CYhL6b7vpi5sLcshnRRF2u20wNhkNj/QGA+b/lSlzTkaQdfn5SBBZTMyyOrMhzd2qV
	 zX4w2Vk3+bmZg==
From: Hannes Reinecke <hare@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
	linux-scsi@vger.kernel.org,
	Rajashekhar M A <rajs@netapp.com>,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH] I/O errors for ALUA state transitions
Date: Fri,  6 Jun 2025 15:59:24 +0200
Message-Id: <20250606135924.27397-1-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajashekhar M A <rajs@netapp.com>

When a host is configured with a few LUNs and IO is running,
injecting FC faults repeatedly leads to path recovery problems.
The LUNs have 4 paths each and 3 of them come back active after
say an FC fault which makes two of the paths go down, instead of
all 4. This happens after several iterations of continuous FC faults.

Reason here is that we're returning an I/O error whenever we're
encountering sense code 06/04/0a (LOGICAL UNIT NOT ACCESSIBLE,
ASYMMETRIC ACCESS STATE TRANSITION) instead of retrying.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 376b8897ab90..746ff6a1f309 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -665,7 +665,8 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 		 * if the device is in the process of becoming ready, we
 		 * should retry.
 		 */
-		if ((sshdr.asc == 0x04) && (sshdr.ascq == 0x01))
+		if ((sshdr.asc == 0x04) &&
+		    (sshdr.ascq == 0x01 || sshdr.ascq == 0x0a))
 			return NEEDS_RETRY;
 		/*
 		 * if the device is not started, we need to wake
-- 
2.35.3

