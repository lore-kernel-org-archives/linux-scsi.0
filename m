Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA12D3D4103;
	Mon,  8 Jun 2026 09:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780912561; cv=none; b=ZeaTNlMR2515BgSWbDcQIArm5ilSvIuf+ajorPw5Do9Zw9a3QkyNKavcI/eazZKwA7RV7S8ZYLmtxjBgavtM39gHO1FSSD/sp6qrD0dHs38vIjHO7vJhrWpLVWuw4pRg4bVWfQfxEcWfc/ef2SYSyy1N0UXuY/28lKQWyTMbZOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780912561; c=relaxed/simple;
	bh=5VvG5+U4LsahTv6wDAD2J/uJ2zNjbZWkhlbZ2kFSxJg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZMAtiZQCQid19rNfHRfTgcgu5m+Bsd4Znb73eYncEayLFu+UCp+cFkZVhVXKSrZeS/msimx1LQOZbOYmHLjxyQm5BjMmO0fJVdDiuxaEpDz49LuF0LlSPxxke4C98yi5siOtw7nuKWptHEWyzk1+Fu+M2JvL8mF0JrWl/FCFUvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=WqyDBvQr; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="WqyDBvQr"
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wWWi5-00BS6x-3S; Mon, 08 Jun 2026 11:55:57 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
	Subject:Cc:To:From; bh=K2JUH26H+YSfyHVLo3H9Z/4BZS5IM73i1NunbGvTgng=; b=WqyDBv
	Qr+zGIfQUZQWf4ZLLgP1zFGTazCz0kC0eKzBTjLs9DbDDIBy9z3ppwgJ53GvKs3290+3Hji/2BcaD
	WnYkrV5fgQSCMUioavZkOb3Nvg5NzOrAA6dweoBxt61MYNJhXnpoV2i2K8VY4ZS5IEgPwwKVu0o2m
	RPoRwwsdqGC0BsNs3zr2YcmzWtSb+V1vrzeU9RCO14aHjdDH4mOw6DJt5uH2nL92jcGr6MRozFWRW
	/VUBo4hNjJr2Gg9oEuIyaDWB3ROFhokW9ZI4d6vgIGO49sLbKudcgPZfXJni8Lda7Fd/LfmuTw1R1
	C/1Ls3R7UAxtkbG8YZjjG72E49dw==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wWWi4-0000LC-M3; Mon, 08 Jun 2026 11:55:56 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1wWWhn-00Ag6G-MC;
	Mon, 08 Jun 2026 11:55:39 +0200
From: david.laight.linux@gmail.com
To: Kees Cook <kees@kernel.org>,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	MPT-FusionLinux.pdl@broadcom.com
Cc: Arnd Bergmann <arnd@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH next] drivers/scsi/mpt3sas: Replace strcpy() + strcat() with snprintf()
Date: Mon,  8 Jun 2026 10:55:19 +0100
Message-Id: <20260608095523.2606-35-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Laight <david.laight.linux@gmail.com>

Avoids unbounded string functions creating version string.

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

 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 8bb947004885..3488446d38a3 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1225,6 +1225,7 @@ static long
 _ctl_getiocinfo(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 {
 	struct mpt3_ioctl_iocinfo karg;
+	const char *ver = "";
 
 	dctlprintk(ioc, ioc_info(ioc, "%s: enter\n",
 				 __func__));
@@ -1241,15 +1242,13 @@ _ctl_getiocinfo(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 	karg.pci_information.u.bits.function = PCI_FUNC(ioc->pdev->devfn);
 	karg.pci_information.segment_id = pci_domain_nr(ioc->pdev->bus);
 	karg.firmware_version = ioc->facts.FWVersion.Word;
-	strcpy(karg.driver_version, ioc->driver_name);
-	strcat(karg.driver_version, "-");
 	switch  (ioc->hba_mpi_version_belonged) {
 	case MPI2_VERSION:
 		if (ioc->is_warpdrive)
 			karg.adapter_type = MPT2_IOCTL_INTERFACE_SAS2_SSS6200;
 		else
 			karg.adapter_type = MPT2_IOCTL_INTERFACE_SAS2;
-		strcat(karg.driver_version, MPT2SAS_DRIVER_VERSION);
+		ver = MPT2SAS_DRIVER_VERSION;
 		break;
 	case MPI25_VERSION:
 	case MPI26_VERSION:
@@ -1257,9 +1256,11 @@ _ctl_getiocinfo(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 			karg.adapter_type = MPT3_IOCTL_INTERFACE_SAS35;
 		else
 			karg.adapter_type = MPT3_IOCTL_INTERFACE_SAS3;
-		strcat(karg.driver_version, MPT3SAS_DRIVER_VERSION);
+		ver = MPT3SAS_DRIVER_VERSION;
 		break;
 	}
+	snprintf(karg.driver_version, sizeof (karg.driver_version), "%s-%s",
+		 ioc->driver_name, ver);
 	karg.bios_version = le32_to_cpu(ioc->bios_pg3.BiosVersion);
 
 	karg.driver_capability |= MPT3_IOCTL_IOCINFO_DRIVER_CAP_MCTP_PASSTHRU;
-- 
2.39.5

