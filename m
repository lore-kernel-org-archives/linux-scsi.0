Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97F916C854
	for <linux-scsi@vger.kernel.org>; Tue, 10 Sep 2024 21:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726005128; cv=none; b=Iy2gcb0/u2JIaPb83XIUZ56I3hap9KUQRxWTYGDkRjtpHK6i2G5HF7XeQhYchHV6qyjv+8KBaJvWk/9lh02xlbjcGV/xTGjF07JhkiryOSa32Deare7wd8Bufa8gZviC6m84eVOwi+BzBoY3v8DDYIHkvz08LJlkLU576/v5Y7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726005128; c=relaxed/simple;
	bh=CRrI7MdgsLUs4fGbyUb/zjvlwt6WSYBFqlWOHhcJPLY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ERzLcHMIuoq90CDkg5I5R6uWB44JIBqEZqZczUax2zDjxLkuwoXOeF0JdjPQlTkoGgTBf4Tawuf0p4AUwGKwp7Y8KAPWnYxHZeUrIplCe4ZSmHIy2XN7Q3qCalz7h7lsO4FWB8ju3h7Y7pHHpmX33Auo+eGPV01KZ5gngblFJSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hyUhGqdv; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hyUhGqdv"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X3HVG1LgWz6ClY9J;
	Tue, 10 Sep 2024 21:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1726005124; x=1728597125; bh=wbpeN1ZaeNuJ+U9QpRAiZ8wTtkOM232O6AM
	O/zfUGSA=; b=hyUhGqdvFXM+94azGwVsEEcTCuVbjLWnF3mnAcz7B4b7CfAbVVM
	vrEekVPMo2Z55CkN7bLCDKwr65K3Isa2OpZ4PQLHs5YeHmbj40UU4lc7FU6AIroR
	/eiKAjXoOtGi7XJNHqPxjC4HlkR3GfW6Ah+tsNMsuUWoE5nzsOqzDB5DPiAGXEzv
	ssZB8i3CERrZAnF6dp1NpW13+dAV79GvawD7DuaI57IDE+6uyMrUVdOrrb1Ff1pZ
	ILV0TlG1GvhmDA/tElqOL+SmbTBm70PfaSDKbKGwD5ssy4Yx4/nyASm79JQFUUlo
	GaX55pPWCnuhzsa1WqLR+ojIHTDUGjXA+wg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id SyTXfbUvSrMH; Tue, 10 Sep 2024 21:52:04 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X3HVD04j9z6ClY9H;
	Tue, 10 Sep 2024 21:52:03 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v5 00/10] Combine the UFS driver scsi_add_host() calls
Date: Tue, 10 Sep 2024 14:50:48 -0700
Message-ID: <20240910215139.3352387-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
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

Bart Van Assche (10):
  scsi: ufs: core: Introduce ufshcd_add_scsi_host()
  scsi: ufs: core: Introduce ufshcd_post_device_init()
  scsi: ufs: core: Call ufshcd_add_scsi_host() later
  scsi: ufs: core: Introduce ufshcd_process_device_init_result()
  scsi: ufs: core: Move the ufshcd_device_init() call
  scsi: ufs: core: Move the ufshcd_device_init(hba, true) call
  scsi: ufs: core: Expand the ufshcd_device_init(hba, true) call
  scsi: ufs: core: Remove code that is no longer needed
  scsi: ufs: core: Move the MCQ scsi_add_host() call
  scsi: ufs: core: Move code out of an if-statement

 drivers/ufs/core/ufshcd.c | 288 ++++++++++++++++++++++++--------------
 include/ufs/ufshcd.h      |   3 +
 2 files changed, 183 insertions(+), 108 deletions(-)

