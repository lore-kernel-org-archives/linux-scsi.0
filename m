Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18673446C0;
	Thu, 11 Jun 2026 08:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781167419; cv=none; b=lHJ2hF4dWmuwKDwnOjDT4MLmgBk7OiyKRxy6DvRSBbyzfEZaIlR7Cj+WfLXgYYi1uw6JFoj/G4mOPQIk1snQ9FGGWM5Cfpv853Ek0Ua4IqBbRLnU2gSIQ6SFxQky5+9Z6GqWqJ6wbxNvJAdIs5fdCBS0Xtm8qNadKPJy0m0eWQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781167419; c=relaxed/simple;
	bh=CWD0Mxp3GNtqQXI1I0aSkG4k1ua5HOdfpwalFPgaH6I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EPYjL2DCgZbC5Rq8z+V+kXbeAJVnXIkeaG4+U+t+x3iQy0aZBA9zrkIgy8VVTy1toBsqaPfwB3U4UUUpFDpjvuVEVZb7ZGs60Cpr0CsrIyxP3NboTJLs///2KO9sGBsYTVHzHkAEsE/pDCiP0TpQ1nIl6hkFrEPTNdDB2XqYdTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [117.182.75.76])
	by APP-01 (Coremail) with SMTP id qwCowAB3HtcudSpq1C5IAQ--.2776S2;
	Thu, 11 Jun 2026 16:43:28 +0800 (CST)
From: WenTao Liang <vulab@iscas.ac.cn>
To: sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	ranjan.kumar@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	WenTao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: mpt3sas: fix refcount leak in mpt3sas_transport_port_add()
Date: Thu, 11 Jun 2026 16:43:24 +0800
Message-ID: <20260611084324.70303-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAB3HtcudSpq1C5IAQ--.2776S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar15ury8GrWUGryrAF1DWrg_yoW8Ww1rpa
	yq9Fy5Ar98Gr4I9rnrGw18Zr4rX3W7A3s8KrW0v3Z5Cr45AFyIqrWxCrZ0qFyUAFZ5Ja4D
	JrWDJ395KFW5GrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwkPA2oqQh7AHQAAsD

In mpt3sas_transport_port_add(), after acquiring the sas_device by
calling mpt3sas_get_sdev_by_addr() (which bumps the reference count via
sas_device_get()), several error paths leak the reference.  If
sas_node->parent_dev is NULL, or port creation/sas_port_add() fails, or
rphy allocation or sas_rphy_add() fails, the function jumps to out_fail
or out_delete_port, where the sas_device reference is not released.  The
reference is only dropped on the success path via sas_device_put().

Add the missing sas_device_put() call in the out_fail cleanup, which
also covers the out_delete_port label that falls through to out_fail.
This fixes the leak for all error paths that occur after the sas_device
is acquired.  Before that point, sas_device is NULL, so the put is safe.

Cc: stable@vger.kernel.org
Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index e74a526efa8d..f831d4823503 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -869,6 +869,8 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	list_for_each_entry_safe(mpt3sas_phy, next, &mpt3sas_port->phy_list,
 	    port_siblings)
 		list_del(&mpt3sas_phy->port_siblings);
+	if (sas_device)
+		sas_device_put(sas_device);
 	kfree(mpt3sas_port);
 	return NULL;
 }
-- 
2.50.1 (Apple Git-155)

