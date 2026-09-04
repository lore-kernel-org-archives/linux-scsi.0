Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8802222AA;
	Fri,  4 Sep 2026 00:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788481667; cv=none; b=n8GIS6S5Ccr3zgHLhg6ULhycjfeZykXnpGMEnJOlQEutlZHAQ9nbn/fPib4wUbUMn38sD6oPlXdmAQNYYRvir3v9htSWNSx3cls1H1cKHd1i5zPkxSwlAApSIrwojsyCBFr8P8OYQdq0f2jxSbULRbYLHnss4jU2hzuxqJNu+Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788481667; c=relaxed/simple;
	bh=0EYWFEYW65Y16rbTiCerbOr1TaGf/UwUikK6l+Fxl2k=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+qRvQrY6UALxcp4CIko5FdD1IEQYVm/zCdllnj5wMEscNy6KlpEeu+TO4rRC0JjyNSbK2WDZ39JmiVOMzFGtqgJxIEoH9lT/8h9snmgpZpD8GV3MgnsN9IqCt48lwA0mRZitMBZrK7GTbMd6HNQUUbkLkuFiLpGlFvoGOgoozs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f9TfI7EQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f9TfI7EQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081901F000E9;
	Fri,  4 Sep 2026 00:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788481666;
	bh=OOmP+AAn35Yx6p3Mt4dGknMDab/j7jCN8TP38qbLk7c=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=f9TfI7EQ6u89VRJSzXh7ec0s2JCTUQer1JFKVQ0EYm3JYVhvUu7FkHe7kyOJIgyy8
	 CmR9v+gfqw5w4zhjaSp9Pbxyf3KxSV5wf+bRG4VzVUPysbbZenZghOiaNcpg5IAk1c
	 Q0p/Rq9vtHAAw2u/90Cma+LTzzUkdV1O59TFAd21ERGK7so0zUIIMrwCG1ZhVSG0P0
	 Yo8ioGGV+4yK+JRc8YLhsoOrDsX9/bfNVh3Si/R1in/WSm9NjrtRaVw2+cwnuiBpMr
	 iX4KqoHTvcTlEWSa+oHuf16LH66irWRM13Odqhd2kC8oR/6GmkKd3TwPg/czILcka6
	 unUQjggSigkzg==
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
Subject: [PATCH v3 28/40] scsi: mvumi: use 16-bits defined sense codes
Date: Fri,  4 Sep 2026 09:26:32 +0900
Message-ID: <20260904002644.157668-29-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904002644.157668-1-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
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
index e70d336b4ab3..a5bd3258a399 100644
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

