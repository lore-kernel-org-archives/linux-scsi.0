Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EDA3B9DA9;
	Mon,  8 Jun 2026 09:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780912551; cv=none; b=I5kXiNb5/ZRcZwScoguoXYMPKw12/cQOsxvSOoYgDkmypCiE7++BwCcNw8ByrgCUdVqpvyMXh0JkLemggXctEifGKDegpg2j4QGVereYU7N0Nvcwx9I3RYjqE7A4AHhL43nXLY0zjvepquxqdbQ6IiY0yFfaXPeJy6nVBTwxsGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780912551; c=relaxed/simple;
	bh=wQj4yujKMpzJm1/0ZXJiRfEMdCo5t0w2Km2MA2qi9vA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=N8CIPCVTC5EqC6Q6GYG2VudOVx0nhxNTlj3dXnRD1npHDooxYBAMwPhq1OJJ9mi98v2sk30YOkKyydFSvOThPHhv2vjZsC3XAcgA1wKHhgs/toBBsTXBkauVGP13udd39EzbspANglAsyacelcRS/OR1N5v6DXEQITX1InOjnpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=B1XQuHjT; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="B1XQuHjT"
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wWWhr-00BrD9-Q2; Mon, 08 Jun 2026 11:55:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
	Subject:Cc:To:From; bh=hcbIctvqyrWWI4G74b0e6mIOWKLZrfr5ivl2Wstb0h0=; b=B1XQuH
	jTSk8IIj2rFoNyYgOLDOEU29MhbrkP/76ZEtUWUnAXJ2KoYqUUaP++SDl8JZ7DCaoVg8y7ewvAOZ9
	B+dreQe6imnPevQI7pwPPo7b3ZH+MRCi5xKs6LeJqaO5Y5Jky/AhBSKlaTh3YRrqQDw4GihqqOAKS
	2OM0MmHcfDY8Lz1vN1jnodjshXa9lkRnnB2eXTtz8DfFEpgbt91NwOQ7TLCAcHHkPHGEHSXIB5hoS
	hgksAKOHsNyFQv1+H6lmHMpsi1KfpUz+pXdPqR9QJZApzJ6cOK0hFow3XjQYVu8Ol88eiDyjeXNbj
	n3bkycRLkUjqIhFSMYOlXwl36s3w==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wWWhr-0000Hs-FC; Mon, 08 Jun 2026 11:55:43 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1wWWhc-00Ag6G-6g;
	Mon, 08 Jun 2026 11:55:28 +0200
From: david.laight.linux@gmail.com
To: Kees Cook <kees@kernel.org>,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: Arnd Bergmann <arnd@kernel.org>,
	Bradley Grove <linuxdrivers@attotech.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH next] drivers/scsi/esas2r: Use strscpy() to copy strings into arrays
Date: Mon,  8 Jun 2026 10:54:51 +0100
Message-Id: <20260608095523.2606-7-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Laight <david.laight.linux@gmail.com>

Replacing strcpy() with strscpy() ensures that overflow of the target
buffer cannot happen.

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
This is one of a group of patches that remove potentially unbounded
strcpy() calls.

They are mostly replaced by strscpy() or, when strlen() has just been
called, with memcpy() (usually including the '\0').

Calls with copy string literals into arrays are left unchanged.
They are safe and easily detected as such.

The changes were made by getting the compiler to detect the calls and
then fixing the code by hand.

Note that all the changes are only compile tested.

Some Makefiles were changed to allow files to contain strcpy().
As well as 'difficult to fix' files, this included 'show' functions
as they really need to use sysfs_emit() or seq_printf().

All the patches are being sent individually to avoid very long cc lists.
Apologies for the terse commit messages and likely unexpected tags.
(There are about 100 patches in total.)

 drivers/scsi/esas2r/esas2r_ioctl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esas2r_ioctl.c
index 3f7c1d131ec3..6e00f84fc2c1 100644
--- a/drivers/scsi/esas2r/esas2r_ioctl.c
+++ b/drivers/scsi/esas2r/esas2r_ioctl.c
@@ -431,7 +431,7 @@ static int csmi_ioctl_callback(struct esas2r_adapter *a,
 	{
 		struct atto_csmi_get_driver_info *gdi = &ioctl_csmi->drvr_info;
 
-		strcpy(gdi->description, esas2r_get_model_name(a));
+		strscpy(gdi->description, esas2r_get_model_name(a));
 		gdi->csmi_major_rev = CSMI_MAJOR_REV;
 		gdi->csmi_minor_rev = CSMI_MINOR_REV;
 		break;
@@ -829,10 +829,10 @@ static int hba_ioctl_callback(struct esas2r_adapter *a,
 		gai->num_ports = ESAS2R_NUM_PHYS;
 		gai->num_phys = ESAS2R_NUM_PHYS;
 
-		strcpy(gai->firmware_rev, a->fw_rev);
-		strcpy(gai->flash_rev, a->flash_rev);
-		strcpy(gai->model_name_short, esas2r_get_model_name_short(a));
-		strcpy(gai->model_name, esas2r_get_model_name(a));
+		strscpy(gai->firmware_rev, a->fw_rev);
+		strscpy(gai->flash_rev, a->flash_rev);
+		strscpy(gai->model_name_short, esas2r_get_model_name_short(a));
+		strscpy(gai->model_name, esas2r_get_model_name(a));
 
 		gai->num_targets = ESAS2R_MAX_TARGETS;
 
-- 
2.39.5

