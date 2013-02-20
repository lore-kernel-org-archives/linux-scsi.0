From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 1/5] hpsa: Check for dma_mapping_error in hpsa_map_one
Date: Wed, 20 Feb 2013 11:24:34 -0600
Message-ID: <20130220172434.12929.64284.stgit@beardog.cce.hp.com>
References: <20130220172243.12929.69579.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:13920 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964880Ab3BTQYj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Feb 2013 11:24:39 -0500
In-Reply-To: <20130220172243.12929.69579.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, shuah.khan@hp.com, mikem@beardog.cce.hp.com

From: Shuah Khan <shuah.khan@hp.com>

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 4f33806..3b4d195 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1405,6 +1405,11 @@ static void hpsa_map_one(struct pci_dev *pdev,
 	}
 
 	addr64 = (u64) pci_map_single(pdev, buf, buflen, data_direction);
+	if (dma_mapping_error(&pdev->dev, addr64)) {
+		cp->Header.SGList = 0;
+		cp->Header.SGTotal = 0;
+		return;
+	}
 	cp->SG[0].Addr.lower =
 	  (u32) (addr64 & (u64) 0x00000000FFFFFFFF);
 	cp->SG[0].Addr.upper =

