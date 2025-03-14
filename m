Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019A37083D
	for <linux-scsi@vger.kernel.org>; Fri, 14 Mar 2025 22:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741990653; cv=none; b=CGJxG2ttQ5KRmKmNJOiu2pk6YGgW8ebb+VRKQCLKisXyg/GoIvBOg58eCk/aJRq5OZFVh2I4w/mvLv6Nh+PoZ/a04Ro/xdII8rpfHJgU2PkZ5IcXC2zKwvJF1uBgYbHwcNi+/NR0ph8C4h697mCR7I3kKd4Mn1Lx0uo0U4uNx8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741990653; c=relaxed/simple;
	bh=MCa0vkcQsABiNsiBneufPykvB8LMRiVfF0XBRX4jBKE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qx2eMbGsKU1pRFiQnIt/Th8ozkvJgVle0NCkApX8haGb6AnA5IYLJAaUsP+QOmH+H0ZrfRNGNlAeXJ/Lwrs6+ndc22V5HTDnJQiPGnWVFR5JQZ5VgHcHxudSd/JLF6C1OlD60RyoGNdYC7dzJ0I8iG+FG9fhZ+Sn8bed+5KOUTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=G/k4c3PV; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="G/k4c3PV"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741990638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8HlGgSem6D58B/bo6nzktQDox6aIVXarAjOGoDX+TIM=;
	b=G/k4c3PVyqfyZ6Mrqs/U03IIgxT0LRxq/dfHXWbxRJNEVstAjMA0jPIJWldHdOZgeeJKeL
	fTKEo/ZsJt6GyE8fcwRaAX69qT0khj7pVDT0RZrtZOBqPc96v2rwMbW259DOGlLs0G8UF0
	dHOx+eW6KNTg80ysTnj+tLCBJ6LZysw=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: fnic: Remove unnecessary NUL-terminations
Date: Fri, 14 Mar 2025 23:16:26 +0100
Message-ID: <20250314221626.43174-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

strscpy_pad() already NUL-terminates 'data' at the corresponding
indexes. Remove any unnecessary NUL-terminations.

No functional changes intended.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/scsi/fnic/fdls_disc.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 11211c469583..7294645ed6d2 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -1898,7 +1898,6 @@ static void fdls_fdmi_register_hba(struct fnic_iport_s *iport)
 	if (fnic->subsys_desc_len >= FNIC_FDMI_MODEL_LEN)
 		fnic->subsys_desc_len = FNIC_FDMI_MODEL_LEN - 1;
 	strscpy_pad(data, fnic->subsys_desc, FNIC_FDMI_MODEL_LEN);
-	data[FNIC_FDMI_MODEL_LEN - 1] = 0;
 	fnic_fdmi_attr_set(fdmi_attr, FNIC_FDMI_TYPE_MODEL, FNIC_FDMI_MODEL_LEN,
 		data, &attr_off_bytes);
 
@@ -2061,7 +2060,6 @@ static void fdls_fdmi_register_pa(struct fnic_iport_s *iport)
 	snprintf(tmp_data, FNIC_FDMI_OS_NAME_LEN - 1, "host%d",
 		 fnic->host->host_no);
 	strscpy_pad(data, tmp_data, FNIC_FDMI_OS_NAME_LEN);
-	data[FNIC_FDMI_OS_NAME_LEN - 1] = 0;
 	fnic_fdmi_attr_set(fdmi_attr, FNIC_FDMI_TYPE_OS_NAME,
 		FNIC_FDMI_OS_NAME_LEN, data, &attr_off_bytes);
 
@@ -2071,7 +2069,6 @@ static void fdls_fdmi_register_pa(struct fnic_iport_s *iport)
 	sprintf(fc_host_system_hostname(fnic->host), "%s", utsname()->nodename);
 	strscpy_pad(data, fc_host_system_hostname(fnic->host),
 					FNIC_FDMI_HN_LEN);
-	data[FNIC_FDMI_HN_LEN - 1] = 0;
 	fnic_fdmi_attr_set(fdmi_attr, FNIC_FDMI_TYPE_HOST_NAME,
 		FNIC_FDMI_HN_LEN, data, &attr_off_bytes);
 
-- 
2.48.1

