Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E681F63D9;
	Mon, 17 Aug 2026 19:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786993506; cv=none; b=s3eiBp4rokDQirjb9C6FwZaHoSdYxmyEVxE4LopUrPZ/yKq1//lNPqKovDdIxD3frkAd0PnC2Q4UZYK5MtC2Nqt1LDGH/yliZzGuVD44l3/zPfd86pfqG9jfyOhVtWRTr2IBPJCtKGajNizMihPk/ir28uUY/MBIS7ZI0FOAZzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786993506; c=relaxed/simple;
	bh=lUUmBqqkyEdjdH52ETtXEdeeJGgD/7QohYQfKSe/Bro=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Ka8UdbMAvRVsZAWAuTT/61s2x/Jnrdsam2gifltOo4pf8UeGnDKJr8agjcCmLmKM2qFS37aKYDO7Vl3njixMX8niARcVyerDFezQ8bL9zfHR0oMnSw/k/d/AkreiJLHs0jR56xmgE91CdY9R55kDrCf7j0gIQXSF00a/nbeeBu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AAkeKTUY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AAkeKTUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52D91F000E9;
	Mon, 17 Aug 2026 19:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786993505;
	bh=ML1B2/r+psY08wn0C4kBVmdPYnKuWxTUSYfY6GsO7Ls=;
	h=From:Date:Subject:To:Cc;
	b=AAkeKTUYakkpnGyOQ+HioxNGW3rW7dLbJrjulLpPZzlCO2om5UMh3lmBHhlxYYhdh
	 /PE+P1z9DHDY+C+OU77wpKTfPjMoxgihfoXJuX3LV7S40bQTmM1b1F1XbXWq3uxUnm
	 hBzWsDK1xiAxVgAJHgPbTlOTRHVhGN4hjn/dC9DBsgLDmqDpx0nhUWwENwsBR2fktW
	 tej/uwJL92NQQe/Ij4QyJljQuSGG/EHR2HrJSQPV5LQtWIcFhrjGhzythZj0weAU47
	 QAlr+a5LdikqDyED2ffnuvuBYKWSHvWUVwJLdkYW3MRAMm6eODXTLBmfQ3c6JQTVj1
	 /j+61+xg8T0dw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 17 Aug 2026 12:04:55 -0700
Subject: [PATCH] scsi: ibmvfc: Fix use of uninitialized rport in
 ibmvfc_do_work()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-ibmvscsi-rport-wuninitialized-v1-1-0fdfb27a5f01@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQ6CMBAF0KuQWTtJSwI1XsW4oO2o32ghnYJGw
 t2tunybt5JKhigdmpWyLFCMqcLuGgrXIV2EEaupNW1v9tYx/GPRoOA8jbnwc05IKBjueEtk472
 TLprO9ZbqMWU54/X7j6e/dfY3CeWb0rZ9ADuGQOGBAAAA
X-Change-ID: 20260817-ibmvscsi-rport-wuninitialized-0bb7e5d05761
To: Tyrel Datwyler <tyreld@linux.ibm.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1841; i=nathan@kernel.org;
 h=from:subject:message-id; bh=lUUmBqqkyEdjdH52ETtXEdeeJGgD/7QohYQfKSe/Bro=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDFnN0TF2DWbHf7glL5PhvbvTSmaPItfRr1/9WuXkV++2l
 IiaHWrTUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACbS183wz0rrbvj62OJcmfdG
 qpzyfGrbjRbaPpzPIRv1OGXtmonRRYwMT3QjEwO1PeqqLpRLVO/39hC/OnfO736t+RbMkw7+vir
 ADAA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After commit 696d1cc2aaa2 ("scsi: ibmvfc: process NVMe/FC rports in work
thread"), clang warns (or errors with CONFIG_WERROR=y / W=e):

  drivers/scsi/ibmvscsi/ibmvfc-core.c:6154:15: error: variable 'rport' is uninitialized when used here [-Werror,-Wuninitialized]
   6154 |                         } else if (rport && tgt->action == IBMVFC_TGT_ACTION_DEL_AND_LOGOUT_RPORT) {
        |                                    ^~~~~

The check for rport is unnecessary in this block, it was accidentally
included from copying and pasting. Remove it to clear up the warning.

Fixes: 696d1cc2aaa2 ("scsi: ibmvfc: process NVMe/FC rports in work thread")
Suggested-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Link: https://lore.kernel.org/6ccbe8c5-beb6-483f-bfa4-c2d3819ad5f2@linux.ibm.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 93b9f699c2e5..b3bc3ce872d6 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -6151,7 +6151,7 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 				timer_delete_sync(&tgt->timer);
 				kref_put(&tgt->kref, ibmvfc_release_tgt);
 				return;
-			} else if (rport && tgt->action == IBMVFC_TGT_ACTION_DEL_AND_LOGOUT_RPORT) {
+			} else if (tgt->action == IBMVFC_TGT_ACTION_DEL_AND_LOGOUT_RPORT) {
 				tgt_dbg(tgt, "Deleting NVMe rport with outstanding I/O\n");
 				nvme_rport = tgt->nvme_remote_port;
 				ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_DELETED_RPORT);

---
base-commit: 30733f28c0347d237ffb5333fdfab7a9a2d4ed34
change-id: 20260817-ibmvscsi-rport-wuninitialized-0bb7e5d05761

Best regards,
--  
Cheers,
Nathan

