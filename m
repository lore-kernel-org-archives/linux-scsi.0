Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D901C1741
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2024 20:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729109587; cv=none; b=cvF2ScfKsSaBojramQLG+qXPGY4DpnDa4NzmyDdcUXHCLYnZzIwvhHQfc0iBbw4urDDGJBQ5dd+txGd+ZBAV6DLU7OtOmNwUECTV97qqujkA6uEBLmmzyxLT0q3siOUpWZDyajeBsHCCx6IA3sVz55VWc6kXhan3itCkKBH8r0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729109587; c=relaxed/simple;
	bh=9QM2HOMQP2V772q6wdi3PLDjRjnZLszjXbUAjYJ2fLw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k5wH1jQufdYJMrgmpA/OFKhZB5zxJ5xWfWEokZVihK/gUp7GlKLJnD1iNPskuBoPsmtK4aovgS8uZ850TCCxJg4Q7fRlxK2ewXLyDwRAd/v6nElD/89TOQRp5ewdNzvx7j946/olm23fmdxv8HRZcemeNdV5OtWhiqTVpgJWgkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4fa8eKRV; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4fa8eKRV"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XTMbH16QGz6ClY9h;
	Wed, 16 Oct 2024 20:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1729109577; x=1731701578; bh=3adV5xCEOyCOP//JaNeR8GfWQJmQeqb+oeK
	H/dEQwIE=; b=4fa8eKRVjS7rCRtKvJ6A5PaYmitueMOJaV7VstBw4J6G+VmP1YV
	oqMD9BDALGg6Un6k6w7UIVKjk9Z6AhLdBCiCoNELvm5oGtfEeK0NgKu+aasxcpfG
	mQcL66W057c2T/GD8FIaxnni6EhImbBtYI9FJ8L8accVCoxoWKG/EwnpJ17F+Yet
	V+fV4u9m+gaAEDxxRuebV+uBG64M7q70WXlkPy3aIioUlSSVligfCq+e4F8fd5pP
	mLympEIHUgZC1HfKKabCIMD9wMtc089r9XcZ2bD+0dZ107LsR557NCNtCgMARcRI
	RuxOfnvxLy0RpwOhPrJ5zGn4rGqfwJvngtQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8nzREScNcw_8; Wed, 16 Oct 2024 20:12:57 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XTMbD6Hc4z6ClY9d;
	Wed, 16 Oct 2024 20:12:55 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v6 00/11] Combine the two UFS driver scsi_add_host() calls
Date: Wed, 16 Oct 2024 13:11:56 -0700
Message-ID: <20241016201249.2256266-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

In the UFS driver the legacy and MCQ scsi_add_host() calls occur in diffe=
rent
functions. This patch series reduces the number of scsi_add_host() calls =
from
two to one and hence makes the UFS driver easier to maintain.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v5:
 - Rebased this patch series on top of the v6.12-rc kernel.
 - Removed the probe_start member variable again from struct ufs_hba.
 - Renamed ufshcd_process_device_init_result() into
   ufshcd_process_probe_result().
 - Converted a comment about UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH in=
to an
   explicit test.

Changes compared to v4:
 - Left out the changes that remove the 'init_dev_params' argument.
 - Added a few new patches.

Changes compared to v3:
 - Split patch "Move the MCQ scsi_add_host() call" into two patches to ma=
ke
   it easier for reviewers.

Changes compared to v2:
 - Improved several patch descriptions.
 - Moved one source code comment.

Changes compared to v1:
 - Fixed a compiler warning reported by the kernel build robot.
 - Improved patch descriptions.

Bart Van Assche (11):
  scsi: ufs: core: Introduce ufshcd_add_scsi_host()
  scsi: ufs: core: Introduce ufshcd_post_device_init()
  scsi: ufs: core: Call ufshcd_add_scsi_host() later
  scsi: ufs: core: Introduce ufshcd_process_probe_result()
  scsi: core: ufs: Convert a comment into an explicit check
  scsi: ufs: core: Move the ufshcd_device_init() calls
  scsi: ufs: core: Move the ufshcd_device_init(hba, true) call
  scsi: ufs: core: Expand the ufshcd_device_init(hba, true) call
  scsi: ufs: core: Remove code that is no longer needed
  scsi: ufs: core: Move the MCQ scsi_add_host() call
  scsi: ufs: core: Move code out of an if-statement

 drivers/ufs/core/ufshcd.c | 304 ++++++++++++++++++++++++--------------
 1 file changed, 189 insertions(+), 115 deletions(-)

