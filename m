Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAEB3F44EB;
	Mon,  7 Sep 2026 02:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749080; cv=none; b=J+rnnVIlsDU1P0k1TgJQoMo54ujvVl8nsoztgBx41BDD3M6b6qDOby8ZBujDyI/qXaY1R9B45GQSRPFPFeSC49/I/hBhwR6bQtd2Lpl6VLiMS1rrL05cl9/tODrcOAXcqdiJct1o5ZyX9gQuuThKDVAJ/GCNQwzaJNCQWy0XEi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749080; c=relaxed/simple;
	bh=2OWP+VZyPtc4rBPqMMAVlnqOxhhJ6iLUTwO35GY2Ecg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qkgh77lWhwrOX3eyR9JOjvHhY1UMTAvOqsNkv27uftOCzgl9sOgWuyeqpyyVFIKJsN3eUlUI1zL0TdIdTnJJRlo6QclkK4Apuiqj5SLzZOIsK1KysdzyL8CzRFK92p58/lGt49AKePnmY8esGMKY4WqmH/ssgbYZ9zCOKSbEYa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KzQfPyHA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KzQfPyHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346841F00A3A;
	Mon,  7 Sep 2026 02:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749079;
	bh=4oZ/sMUzEYF+BJqyR9A58M8g1jra8zNiJWPXbfVMsT4=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=KzQfPyHAvQB6ktavFJVxdgjdunw1MciomsN500aQ9umMZ7QiirCphCIRh7fBifQxq
	 9hUJKNxGc7GGp3Q1/uSQG1T+RemZ+Viy4Z4b7CF3MgXtw4YrkHvERCkLcyIeZoB/cU
	 /9klUILUAvYwnkgdFhvQGJr+72SJRhigOlvNJsZEBhVpfqDlT+ZAVBy6vZnaPV3n9i
	 LiANEcB72dzYwHGtoEqVSw9b1U9x4Rr+5V3tOS2UQWz0oBcCTGQGWQZvcD017phWsY
	 HFKuuyAJ3LEXwK1qCUj8HJ72D2VvBeD9L7aV/k12+4VB5n6YjxHAlhe8eaZO2iAdSb
	 rV+aSmfn9Q19g==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-s390@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH v5 28/40] scsi: mvumi: use 16-bits defined sense codes
Date: Mon,  7 Sep 2026 11:43:31 +0900
Message-ID: <20260907024343.1046387-29-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260907024343.1046387-1-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the Marvell UMI driver to use scsi_set_sense() and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h. This helps with
code clarity as the sense codes being processed are easier to test and
self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/mvumi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index e9e2c25cde68..91c2db697c69 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2067,7 +2067,7 @@ static unsigned char mvumi_build_frame(struct mvumi_hba *mhba,
 	return 0;
 
 error:
-	scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
+	scsi_set_sense(scmd, 0, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB);
 	return -1;
 }
 
-- 
2.55.0

