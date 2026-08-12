Received: from outbound.qs.icloud.com (qs-2005f-snip4-11.eps.apple.com [57.103.86.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0972138F24C
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 19:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.86.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786564122; cv=none; b=D5D7Ht+vU3YIPX9L07Ef+ioPkV8hKor/kGkrhIHIcUM0okq21EKhQrp1aVNGoc0QbSVMmWZHdIbz86fZc5NeUsZMz3K+ijGxovM3E0tdqcaaY9BMcBEhKDtZvZMq402QPdrtFPsyySShicgkFv2XX0eSCdCwv3jV6Bznedj2ZLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786564122; c=relaxed/simple;
	bh=ETyFHH7OpVgW6lnVqEcsasCu57Wakr7XlduoePEHrBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6o9lTiFO5jY+N4q8jxwY8tyHbn0iImr+FG2Z68QYaBkOMp7X5vE7DVNw0v4ohpqjgc/G8Wb9q2tkMQ/I/oY6ify1i0vzI2yLsK+wcHqmHbN3KtBdml2Jw3Xp8hcz10m25hhu25eloYZvg4MWis7rs/PH7IdBfMIgAWUOIJumbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=CUVevMBU; arc=none smtp.client-ip=57.103.86.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="CUVevMBU"
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-5 (Postfix) with ESMTPS id B81331800353;
	Wed, 12 Aug 2026 19:48:32 +0000 (UTC)
X-ICL-RepId: 019ff784-f0fa-7cd5-942b-6ed91b5d5b55
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQ1PHVwPUxxGClYCVAFLVxQEHUAFVgpcQglLAi1eCF4fTBwdDlgGEhZdRVoOWwRHFBcbXAAXGVFNDlhbCFsEDx9MDFECQgVWXkgLHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBFQAVgeVl5aF15NWgJWTQVKA18BWwpBC0kKWQ9bCl4MTwVYD10fRBQdQAVWClxCCUsCLV4IXh9MHB0OWAYMUE0BQwgKAlEcVg1X
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1786564116; x=1789156116; bh=IQW6+im5CnKExSoqzkvoJaJk0rPKHX1zb5TsV2IFxUk=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=CUVevMBUPUNHnhBBSN8FpyCF4AfsWcj3q+P5eTHmSjTKAfuv47IL7hwuADBFNk29ifz/fm/z1bAn85zExHkt/O+NgbRSNPWs0ACYz3cG9eKblNCxPO4JigGYWbrVyAxUBStKbc5viHNhKtcN/JSfWCWyyEHeR72DR8rkdVL/I36uWFKXnvLu+SU683mOqCWplrTuzxM82GlZnmggXGboOmWl9aHYPoQTPjmyL/qREvI7aPKh7WwpNuMROxIFCtA8w/0PRnDHu2FQzZZsGC4hbMT5VZHdmNnWAKB+EfWOHCW6B2mD07k++KqtOu1OsdiZXV3i2WBMubgWn0b0itg8ww==
Received: from machine (unknown [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-5 (Postfix) with ESMTPSA id 5FD3818000B6;
	Wed, 12 Aug 2026 19:48:31 +0000 (UTC)
From: Eshaan Deshmukh <eshaan2031@icloud.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eshaan Deshmukh <eshaan2031@icloud.com>
Subject: [PATCH v3 3/3] scsi: libsas: Handle errors in  sas_ex_discover_expander()
Date: Wed, 12 Aug 2026 14:48:08 -0500
Message-ID: <20260812194808.576586-4-eshaan2031@icloud.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812194808.576586-1-eshaan2031@icloud.com>
References: <20260812194808.576586-1-eshaan2031@icloud.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Info-Out: v=2.4 cv=ebIwvrEH c=1 sm=1 tr=0 ts=6a7cce12
 cx=c_apl:c_pps:t_out a=bsP7O+dXZ5uKcj+dsLqiMw==:117
 a=bsP7O+dXZ5uKcj+dsLqiMw==:17 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=ea8ixM18I5MA:10 a=VkNPw1HP01LnGYTKEx00:22 a=v3ZZPjhaAAAA:8
 a=mmTTPH3KzcaUb-IWQLwA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEyMDE1OSBTYWx0ZWRfX+H8n8AnHu6Cw
 T/lvVty700ng1wJSEG/8Cnfa/d0aMXPyxnMZe6r7oeYJ9H+7gemqsnOnc8zW/wlDFEFQo+V13Ws
 t74x1mhQZgpXE4K2XHsg2sWSSPnfD+ClHmO3Ox4an1VBNECGadX/Te94RZXQcLljiyF7rukgvcG
 0GGyV+nZjYvCQTciMSSWPstU3CiRvhXF0EgpWpFMjoD5XbDVamBhUy/B6A7APqV1MvUesWCy3yZ
 ykLOv7uKz3jfMhiiR31+CZPWSnn3UNleMKLMMS2rKaLgInCxy2vEeFuhmkm6BpXXClAU3D+NdEq
 LgB9mlF1swKEXP1N5FShkwueW5mJ8R3zMjfOZo+8sFufAJxodpZQZ9hJgo+4OE=
X-Proofpoint-ORIG-GUID: f8rNFQb2RAzFGanhvbFzxHHC_uSG202o
X-Proofpoint-GUID: f8rNFQb2RAzFGanhvbFzxHHC_uSG202o
X-JNJ: AAAAAAABelLZTgkMCsXyF4xgFPlWamHdVsOKZ5uVCvwaESLyC3p+AmudQ7TPkJ/duQZUr6lOXvmWfoFQcaNLXY6JbDT//AlKWXfcxla3uUmilE9ownQctT1zN2ltNZBxk1ZVmU+yWxmy55rxypx2Nvg1+r1q4nnW64cSbOg0jPd7hGvecx2VvtWh6JES+3W0+YgldkTUTd0QChU8MYAGmenpsXUZYV9AH5tPsIA9i1xZlhwkN4Xba5Leo3LKen3StWDTKAMxp92HUAoGtMYq2DdZQmFWXwcQQEMYdxyWJcm7DF3W3ffx2uWIkyihwihPpY0EQ3taikDfvvj16bE8sFCF3r+4HProKckHCINu5h0beNVP07xJkjrnQUpEdaiqkZpLZpnUSy0KDQO0+vKn4OmfkJbCvjTEdDa6X9NEIbsDKGkJ+yvPZ4sNhdPFcYhBoZKWQF6jpVs1llbbbxmVnzLSNsY+2Ch7TIgSbI66Zx/Ygdw3NpVJQOs5qLRwlB18o6KxKqfYc9La+AF69flxgrgDhsvzLISc9ZssM6yC0q80nUMHw1MNsLujfMjtEBxOnMb2v2w9YtKdeamzDNKGWuYoB1hpWI6kQkTy9tV9gbMZLPzkO/9gC8fpVfjI/yQQEgjWSi0708UV3iHVmRLbpwv8TzdSNrd4NyfSvm0VlsPn6JJ21kL1ZY0WyVqrm8QHHqzNhtmRRVJE/GejmNsWtFrOBp1TRCn8COJduqvGmouuWNFyWYXdMn67jnYPYtxogybN+vjaK6vIcn5trzA3jeQ5rfh5nZn9R3XufZENOktCGnxUk8C3

The function sas_ex_discover_expander() does not account for the
potential failure of sas_port_alloc() for phy->port. It also calls
BUG_ON in case sas_port_add fails for phy->port. Add a check for
phy->port after sas_port_alloc() where if it is NULL, it cleans up the
child allocated device and returns NULL. Add another check for
sas_port_add() where if it returns an error code it frees phy->port,
sets it to NULL, cleans up the child allocated device, and returns NULL.

Signed-off-by: Eshaan Deshmukh <eshaan2031@icloud.com>
---
 drivers/scsi/libsas/sas_expander.c | 41 ++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index ab6afbad3..a83493f57 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -911,7 +911,6 @@ static struct domain_device *sas_ex_discover_expander(
 	struct sas_rphy *rphy;
 	struct sas_expander_device *edev;
 	struct asd_sas_port *port;
-	int res;
 
 	if (phy->routing_attr == DIRECT_ROUTING) {
 		pr_warn("ex %016llx:%02d:D <--> ex %016llx:0x%x is not allowed\n",
@@ -925,9 +924,13 @@ static struct domain_device *sas_ex_discover_expander(
 		return NULL;
 
 	phy->port = sas_port_alloc(&parent->rphy->dev, phy_id);
-	/* FIXME: better error handling */
-	BUG_ON(sas_port_add(phy->port) != 0);
+	if (!phy->port) {
+		goto out_put_device;
+	}
 
+	if (sas_port_add(phy->port)) {
+		goto out_free_port;
+	}
 
 	switch (phy->attached_dev_type) {
 	case SAS_EDGE_EXPANDER_DEVICE:
@@ -966,19 +969,29 @@ static struct domain_device *sas_ex_discover_expander(
 	list_add_tail(&child->dev_list_node, &parent->port->dev_list);
 	spin_unlock_irq(&parent->port->dev_list_lock);
 
-	res = sas_discover_expander(child);
-	if (res) {
-		sas_rphy_delete(rphy);
-		spin_lock_irq(&parent->port->dev_list_lock);
-		list_del(&child->dev_list_node);
-		spin_unlock_irq(&parent->port->dev_list_lock);
-		sas_put_device(child);
-		sas_port_delete(phy->port);
-		phy->port = NULL;
-		return NULL;
-	}
+	if (sas_discover_expander(child))
+		goto out_delete_rphy;
+
 	list_add_tail(&child->siblings, &parent->ex_dev.children);
 	return child;
+
+out_free_port:
+	sas_port_free(phy->port);
+	phy->port = NULL;
+
+out_put_device:
+	sas_put_device(child);
+	return NULL;
+
+out_delete_rphy:
+	sas_rphy_delete(rphy);
+	spin_lock_irq(&parent->port->dev_list_lock);
+	list_del(&child->dev_list_node);
+	spin_unlock_irq(&parent->port->dev_list_lock);
+	sas_put_device(child);
+	sas_port_delete(phy->port);
+	phy->port = NULL;
+	return NULL;
 }
 
 static int sas_ex_discover_dev(struct domain_device *dev, int phy_id)
-- 
2.55.0

