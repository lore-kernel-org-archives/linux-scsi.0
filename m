Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C471CB508
	for <linux-scsi@vger.kernel.org>; Tue, 22 Oct 2024 19:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729625512; cv=none; b=pRMMZycriZ7lkup6Fr0hSZprgmp+65jDlc5gmZU8lOiXt5PQhjFn17KBrjBs7WJX4y1Y4XgfT1ytEZKAig/u3Mhg/2p5r35pLbmnr6VV+dZ77z9yxivxw8isPcYQkj2Gr0yG0riPnQTebutfHnalOBkeNwSyaJ5AclrJlsH5YSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729625512; c=relaxed/simple;
	bh=k/z0tUyJpTa626njYPzqre1snrj1NOWXRzUcAl0YSqw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C6lV7WA5JIAZh/43TIXZZ2gSUddXsa6aZCoUH7lDMHIkBoOI417CAbbI+a5KYJnF/TNqqM53htpNkoOn8x3YLuvohAFi+OKJlfUuHDZLMkdg2Bi6w17QY7i6pLgMOKF+u8axa13GI95PPJ4rpvjUHelM5xj5aXylkOkWVS2Qhr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=dc5Wx+NB; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="dc5Wx+NB"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XY2P22QYdzlgTWQ;
	Tue, 22 Oct 2024 19:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1729625508; x=1732217509; bh=sChJN0QszgUIqUkVnHfZe3NHtL6cX3rb2jo
	eDhTV5UU=; b=dc5Wx+NBrJacb2yhZa6WAhxAeAufU/vZ7zZ50sG624zeSwUcqvj
	aKNu0fCmzDOKuDNnK9ZthZL34PbETbMEydP2XvjaFSefjLWKl6IpsyUBn3VMhTo6
	jB68BDVp4Gx2rA4plwrqDW4KmwPCvNrQeVnBRtVGXvCcxc3Hc0ON86hTNAjHUNwF
	+UdInXNB42LHqE9oFEdT5NPlNEBOEXuU4wRHB1BxZlJZpA7Q37n2w1nmGMJ0olUP
	pGTfvI3mgTP0LPv6z+1/exa3r+RRXzoybeLWKDOsrJf218B3fJ4yHKxzbKW7ET2p
	BQL9fywjgNOkG+QZAAzDLOSsfVLZQJK0SfQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id HScxB9bnqmek; Tue, 22 Oct 2024 19:31:48 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XY2Nz5sQmzlgTWP;
	Tue, 22 Oct 2024 19:31:47 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/6] UFS driver fixes and cleanups
Date: Tue, 22 Oct 2024 12:30:56 -0700
Message-ID: <20241022193130.2733293-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series includes several fixes and cleanup patches for the UFS =
driver.
Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v1:
 - Reworked patch 4. Instead of changing ufshcd_scsi_block_requests() int=
o
   blk_mq_quiesce_tagset(), remove the calls for blocking and unblocking =
SCSI
   requests.
 - Made the patch description of patch 6 more detailed.
 - Dropped patch 7 from this series and posted it separately.

Bart Van Assche (6):
  scsi: ufs: core: Move the ufshcd_mcq_enable_esi() definition
  scsi: ufs: core: Remove goto statements from
    ufshcd_try_to_abort_task()
  scsi: ufs: core: Simplify ufshcd_try_to_abort_task()
  scsi: ufs: core: Simplify ufshcd_exception_event_handler()
  scsi: ufs: core: Simplify ufshcd_err_handling_prepare()
  scsi: ufs: core: Improve ufshcd_mcq_sq_cleanup()

 drivers/ufs/core/ufs-mcq.c | 26 ++++++++------
 drivers/ufs/core/ufshcd.c  | 73 ++++++++++----------------------------
 include/ufs/ufshcd.h       |  4 +--
 3 files changed, 34 insertions(+), 69 deletions(-)

