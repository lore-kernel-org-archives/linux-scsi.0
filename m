Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BB44EFFC1;
	Fri,  9 Oct 2026 16:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791563222; cv=none; b=mgB9yaDPMdyKLcYZLp8W7G33cutH2j5CmXtDbZ5RICAIyq51H3gIhbzIHCVes7vDaOkJsci4U1q7t0uCvrr6Rlv1o5mj6K/kfKXx8AryuwxrSdBpufdE+LueT/p/8q5rXnxiUQvjFBuWRChM/aOLP6WlD5V2PQ2Q8Sy1dyKEt1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791563222; c=relaxed/simple;
	bh=v6XTl+K2KK20GO/ws3ANG/tmGMyPwnadCSZnCt+cxaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUxzgkVEVeFJmU/SX10ygYQ+9EjoZrp8hTpQTCkocfX8Bpedi+gJ5fqBhHhMRljjQ2v97ieOAksm1tDYCEOLcdsVNAjRQeNQx2rImIbjT6eBZBvemnHPM9nSJ2W/YjVRaMm+1pYK64GJQYKK+9eT2nmlDOxXeCfY7BYBPAhmNlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=wa+HCrL/; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="wa+HCrL/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1791563215;
	bh=v6XTl+K2KK20GO/ws3ANG/tmGMyPwnadCSZnCt+cxaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wa+HCrL/NW6rVQITslvqKOUgYnxSd0535qPz/Iiw+B/nTsk5LfFceQQ6A2SosFRlk
	 +AXfL83z/yI5f0qOglojk/gXNLkQ1s3MXm7Z6KTuwQSK8t/ZaZhnlU/pE2KdA+qTCH
	 c4xFYxnLeBpBbHE2ozir8zmdI2mdJrsNxQpCm/Ws=
Received: from wolf.philpem.me.uk (unknown [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 07AF5BE58C;
	Fri,  9 Oct 2026 16:26:55 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id B79E55FB4D;
	Fri,  9 Oct 2026 17:26:54 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Phil Pemberton <philpem@philpem.me.uk>
Subject: [PATCH v10 02/15] scsi: core: release the device tree node at final device release
Date: Fri,  9 Oct 2026 16:55:09 +0100
Message-ID: <20261009155522.593045-3-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261009155522.593045-1-philpem@philpem.me.uk>
References: <20261009155522.593045-1-philpem@philpem.me.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

libata's ata_scsi_assign_ofnode() retains the reference returned by
for_each_available_child_of_node() when assigning a matching child to
sdev_gendev.of_node. Neither SCSI nor the generic device release path
currently drops that reference, leaking it with CONFIG_OF_DYNAMIC.

Drop the reference in scsi_device_dev_release(), after the last reference
to the SCSI device has gone away. The node must remain valid for the
lifetime of the device; putting it at assignment would leave an unowned
pointer. Final release also covers assignment racing with device removal
while the scanner still holds a SCSI device reference.

Fixes: 45b8084f3fcb ("libata: Assign OF node to the SCSI device")
Assisted-by: LLM
Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/scsi/scsi_sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 9480432f650b..5e766e976a1d 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -14,6 +14,7 @@
 #include <linux/device.h>
 #include <linux/pm_runtime.h>
 #include <linux/bsg.h>
+#include <linux/of.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -517,6 +518,7 @@ static void scsi_device_dev_release(struct device *dev)
 	if (vpd_pgb7)
 		kfree_rcu(vpd_pgb7, rcu);
 	kfree(sdev->inquiry);
+	of_node_put(dev->of_node);
 	kfree(sdev);
 
 	if (parent)
-- 
2.43.0

