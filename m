Received: from outbound.qs.icloud.com (qs-2007k-snip4-2.eps.apple.com [57.103.84.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930A137A85D
	for <linux-scsi@vger.kernel.org>; Mon, 10 Aug 2026 23:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.84.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786404712; cv=none; b=feKIPynycJlNNhTMGz3VsaejFPG1XHqbSHKlavHa2cfNnGTKOV+UA0+WIbhqW9c5zD37k+9BXpv+c7QPlsaFsgsHDoZYGaq5QsZhw22mbkXXpkPd36PiJpZ6OXdOQf3mYV3kuCoruFuxjUaxQDbpjpONkqLHsGBUlbV2HsigeB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786404712; c=relaxed/simple;
	bh=Gm5zOKSEWAhE3mXt3G0dNDJ/PcB4syl2jQ254qbijVE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mJu26hAaxkWKWbFREmT5G6Im5O58t9D5TWtudLzgBdcjMWNWTac0198LzpmxaFo7wp/uNAPtiofHz3Kqg4WivY7t60PSevr722+F7atvh69tJD9XpvF9ZFp5YI6m+exXVw5pVz1Qe+xmphh+TNO+QAeQ9GIxGOTb7bo6WhQOIcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=k7WSRe2E; arc=none smtp.client-ip=57.103.84.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="k7WSRe2E"
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-2 (Postfix) with ESMTPS id 103A21800205;
	Mon, 10 Aug 2026 23:31:47 +0000 (UTC)
X-ICL-RepId: 019fee04-9e91-7779-8bce-5f18995e8d23
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQ1PHVwPUxxGClYCVAFLVxQEHUAFVgpcQglLAi1eCF4fTBwdDlgGEhZdRVoOWwRHFBcbXAAXGVFNDlhbCFsEDx9MDFECQgVWXkgLHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBFQAVgeVl5aF15NWgJWTQVKA18BWwpBCUoAXgZYBV4LTwZfBl0fQRQdQAVWClxCCUsCLV4IXh9MHB0OWAYMUE0BQwgKAlEcVg1X
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1786404710; x=1788996710; bh=ZFPQIxawaE0fVlWGUO2XI7RNDYyUtq2a9C+Qje6V7+o=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=k7WSRe2ErCE+53HqdOBHN2JFb9vMhxXZf76FgHILTPinAHnYmaO/4zjoa0I03OKlZ6+ZWbofIagkiwtBRpyBOIYgkRQhDF8aqThBWpiIf/T0PKFKDbqwbWTiSQiknEBxRnne8sytRLypqGQJjG6Mi6hZyNIhxUN4ejSbCmhFVRgShkQ0JDyyVFaGKh+aqn4gTqviS0/IL2u+jltPCEqkn3wthhbmHUaLkO4WVJgBLQc3W5nV4xMyH4u1xR6GwB0nH9iuKluD/sIDNGqmjfShSJJGBjU5O2xCPxxJ6uqpUDrxfqmQQVTS84CvfcZR/Pn+MsMeAKNYacptRhQ4kPbC+A==
Received: from machine (unknown [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-2 (Postfix) with ESMTPSA id 397F0180023A;
	Mon, 10 Aug 2026 23:31:46 +0000 (UTC)
From: Eshaan Deshmukh <eshaan2031@icloud.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eshaan Deshmukh <eshaan2031@icloud.com>
Subject: [PATCH] scsi: libsas: Handle errors in  sas_ex_discover_expander()
Date: Mon, 10 Aug 2026 18:31:37 -0500
Message-ID: <20260810233137.275216-1-eshaan2031@icloud.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDIwMCBTYWx0ZWRfXxJJgxYfGsoyA
 kRws/6JhRhLapIwFgz401NrPBYRjNJ6LOfpyCKj5ja0crsSg6mvvEmFYtoLOTZyaBP4Wy/Zn+nT
 PW568l1LaHacjL8GFMslETh+7HPVxEkxJJ8pLTBD67cSqYCsN6bPMn+nox7B70UhtI35zgjNt3M
 niQWDHu79O0PjHB561U/E8uopVeQp93reGUD+GaQhR21+MEPIwEJ72mbjpGiXOUUwddpb0YelqN
 JxNL9HhkyFxmRyiLZQVc/7vScQtR6g31hff1Q3J8xeP3hbQTpXRqf2hWxbS3RlVjEdn/jbsg8sp
 Ul3iGiK/yYYb8s+UvsL+K4/yGcyoLD+8l3UNpsI/oKBfisKKTxwjNydDS4kGTk=
X-Proofpoint-GUID: 4z5toeov7Q-hrupBBPI_aE-9qbg5ntWk
X-Authority-Info-Out: v=2.4 cv=NObYOk6g c=1 sm=1 tr=0 ts=6a7a5f64
 cx=c_apl:c_pps:t_out a=bsP7O+dXZ5uKcj+dsLqiMw==:117
 a=bsP7O+dXZ5uKcj+dsLqiMw==:17 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=ea8ixM18I5MA:10 a=VkNPw1HP01LnGYTKEx00:22 a=v3ZZPjhaAAAA:8
 a=G5qPdV8fadFp4kCsiFEA:9
X-Proofpoint-ORIG-GUID: 4z5toeov7Q-hrupBBPI_aE-9qbg5ntWk

The function sas_ex_discover_expander() does not account for the
potential failure of sas_port_alloc() for phy->port. It also calls
BUG_ON in case sas_port_add fails for phy->port. Add a check for
phy->port after sas_port_alloc() where if it is NULL, it cleans up the
child allocated device and returns NULL. Add another check for
sas_port_add() where if it returns an error code it frees phy->port,
sets it to NULL, cleans up the child allocated device, and returns NULL.

Signed-off-by: Eshaan Deshmukh <eshaan2031@icloud.com>
---
 drivers/scsi/libsas/sas_expander.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 1aa99e7c7..f9ae655a2 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -925,9 +925,18 @@ static struct domain_device *sas_ex_discover_expander(
 		return NULL;
 
 	phy->port = sas_port_alloc(&parent->rphy->dev, phy_id);
-	/* FIXME: better error handling */
-	BUG_ON(sas_port_add(phy->port) != 0);
+	if (!phy->port) {
+		sas_put_device(child);
+		return NULL;
+	}
 
+	res = sas_port_add(phy->port);
+	if (res) {
+		sas_port_free(phy->port);
+		phy->port = NULL;
+		sas_put_device(child);
+		return NULL;
+	}
 
 	switch (phy->attached_dev_type) {
 	case SAS_EDGE_EXPANDER_DEVICE:
-- 
2.55.0

