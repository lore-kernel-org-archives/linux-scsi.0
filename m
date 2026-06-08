Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF306326942;
	Mon,  8 Jun 2026 23:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780959879; cv=none; b=MFr0n3v+8/HLpKSj8M1jV72qWRp85pGBymPTfBwDL+v2xABz8N+dUeXlAc85TlYoMOimy8KXuzCzP2DKrWCHxw3N3gBRQuqPO0zroY8IOUZubIRfVsnyyBuFv0N+iwqkWEE5JyLZ3TNJOAx7+pgXb49YA4FwYTnRZTeBVQcL0eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780959879; c=relaxed/simple;
	bh=A7NQMwa8A5mndopGSKOon03gdnAzOvi/KsGAaeecZ/A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VATp1b5O8ENjXrU3QpVlIL5P+3yhqRPNdclJDgi3J4kxnUnqZs85xu8roJs6sa2UZDQ7HGWSwuqr43/umCUUhYBTTlXxqdU+LlZuEGaol/3o24f8ZDDpaiEY+Sjmuh8pooDmgSF4LnKSIC90rrJKQCannfN73obL8hEO8Zus2Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=Q7fSPhfI; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="Q7fSPhfI"
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wWj1C-00D0NR-Mj; Tue, 09 Jun 2026 01:04:30 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
	Subject:Cc:To:From; bh=7gP6YkVyya3OXS3MmDOjeyd3Nhn3Cm5Wz08yFaXZ8o0=; b=Q7fSPh
	fIAO5CRENhF0lbF2JKzFAPdK9KuzYsiOzhT927Ey4JS4vsj+Fx6evumyv/GLg8+/5Qd1f91kQU8QE
	NXC8NI41AH3IbnDZvceWlfEROpkgsl+KgozNIKsr6vRFoS1wvyHLitdcc3AHhbCiK2pvAqjOFkjKE
	hNFM7qGcdwTlre2vkYuA/3pJ1MRmFCdiSkkH+NvWTDA1H3/rbElBf5QC6nR6ecP2lHs8+RjkL2fef
	GxR+m9lxoiBeK4dUww3Vkg5GtdWXOR29klkKHSGjYL9hhZXhhGwjcIFV4U/4RWNpWdDnFyhOYjd0+
	OSU3sW8MbarQLwVsFwhPXRnCV9Xg==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wWj1B-0002Tv-LA; Tue, 09 Jun 2026 01:04:30 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1wWj0s-00C6zU-U4;
	Tue, 09 Jun 2026 01:04:11 +0200
From: David Laight <david.laight.linux@gmail.com>
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
Subject: [PATCH next v2] drivers/scsi/mpt3sas: Replace strcpy() + strcat() with snprintf()
Date: Tue,  9 Jun 2026 00:03:57 +0100
Message-Id: <20260608230357.25889-1-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoids unbounded string functions returning the version string.
Allow 16 characters for the driver name (actually 7 chars) to stop
gcc complaining about possible truncation.

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---

v2: The build test bot reported that the snprintf() can truncate.
(I thought that was the entire point of snprintf.)
In this case ioc->driver_name is either "mpt2sas" or "mpt3sas" and
the version string is like "20.102.00.00".
Keep it all happy by using "%.16s.%s" instead of "%s-%s"

Note that there are a lot of sprintf() related to these strings.

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
+	snprintf(karg.driver_version, sizeof (karg.driver_version), "%.16s-%s",
+		 ioc->driver_name, ver);
 	karg.bios_version = le32_to_cpu(ioc->bios_pg3.BiosVersion);
 
 	karg.driver_capability |= MPT3_IOCTL_IOCINFO_DRIVER_CAP_MCTP_PASSTHRU;
-- 
2.39.5

