Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB32E3074BF
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 17:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755192761; cv=none; b=E3/CqSoEkKRt15Pp1VtJQgDqW2HocnS6PZkReHcHScKbCLgDVBWT18n5unjUYAx2NVEQNovmxdz6reLpgoBGIL447JuK8ehBouOxUilwQd9srT8mFQ3AuVp13z0bb44DGNYAeZo+qdtp5aDjOrzTnYTUxrh7Np4/wvEHKeBsMdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755192761; c=relaxed/simple;
	bh=JLBxq5aNINrQ52bFnV4lmpOxBZ6n2hR029POl77ymts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tAwI2qYPpQvMhUPDuIIkH5c1n1hFWWeX3X9wP5f4Km+MLxUNuPY1Drvxbf1uiZB+Nn0tzlaJjtt82/50I4zQ+O4trlKUn7sl7B2c5mpBeuSqNqJDn0g9Y403r55xxW3fTeV79Himx7IGFMpxOYjqwLSqDwMyxxfbRJuWUotV6mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BzWy68D5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BzWy68D5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E12C4CEED;
	Thu, 14 Aug 2025 17:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755192761;
	bh=JLBxq5aNINrQ52bFnV4lmpOxBZ6n2hR029POl77ymts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BzWy68D5R0APJGPqe7X5KcTW+zmEIJ7YxP9k88GwMbVkEcAS2bRWFrdqyBR5Nnj8o
	 gN1GKMVxzRyw9dsgUIVf67CbdO1Ryxcbnc8M2OESGLKw1ru8r26ZdU+pkPq0bV/xIr
	 zQpsoBsISh4PR+eoDNscMe6jnnkmsMEwQMAHS3aOytDb19KAHbYWhyW/DX63ZTn8yZ
	 U/a1upJRBzYWQ2ey+LGlRBItfIxz5zCOSEwExYHoLw+3kPeNnzP90V+zcxZD78Q/+N
	 H4dy3rKZIqIGd5589OkSZ5zL1jY4zksVAo58315GBYDdcEkiLQi85+W+fWJyKf5Gp/
	 EqyrCQm7lAtIw==
From: Niklas Cassel <cassel@kernel.org>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Igor Pylypiv <ipylypiv@google.com>,
	Salomon Dushimirimana <salomondush@google.com>
Cc: Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v2 02/10] scsi: pm80xx: Fix array-index-out-of-of-bounds on rmmod
Date: Thu, 14 Aug 2025 19:32:17 +0200
Message-ID: <20250814173215.1765055-14-cassel@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250814173215.1765055-12-cassel@kernel.org>
References: <20250814173215.1765055-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2592; i=cassel@kernel.org; h=from:subject; bh=JLBxq5aNINrQ52bFnV4lmpOxBZ6n2hR029POl77ymts=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGDLmyS6VC2V4zbDjx2/XTu1HAp/evVHPnybJtzvHzLrvj ljpjCbvjlIWBjEuBlkxRRbfHy77i7vdpxxXvGMDM4eVCWQIAxenAEzE3ZCRoafk3Z14/RP/Tzsb KXdWOOfutNja8WHn/3ezJkc9lP62fg0jw8lHGvEPEgTe74p6/kbmgPj95DTdPUc7+Ux2LFlz2Oa TCAcA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Since commit f7b705c238d1 ("scsi: pm80xx: Set phy_attached to zero when
device is gone") UBSAN reports:
  UBSAN: array-index-out-of-bounds in drivers/scsi/pm8001/pm8001_sas.c:786:17
  index 28 is out of range for type 'pm8001_phy [16]'
on rmmod when using an expander.

For a direct attached device, attached_phy contains the local phy id.
For a device behind an expander, attached_phy contains the remote phy id,
not the local phy id.

I.e. while pm8001_ha will have pm8001_ha->chip->n_phy local phys, for a
device behind an expander, attached_phy can be much larger than
pm8001_ha->chip->n_phy (depending on the amount of phys of the expander).

E.g. on my system pm8001_ha has 8 phys with phy ids 0-7.
One of the ports has an expander connected.
The expander has 31 phys with phy ids 0-30.

The pm8001_ha->phy array only contains the phys of the HBA.
It does not contain the phys of the expander.
Thus, it is wrong to use attached_phy to index the pm8001_ha->phy array
for a device behind an expander.

Thus, we can only clear phy_attached for devices that are directly
attached.

Fixes: f7b705c238d1 ("scsi: pm80xx: Set phy_attached to zero when device is gone")
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/scsi/pm8001/pm8001_sas.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 753c09363cbb..3e1dac4b820f 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -749,6 +749,7 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 	unsigned long flags = 0;
 	struct pm8001_hba_info *pm8001_ha;
 	struct pm8001_device *pm8001_dev = dev->lldd_dev;
+	struct domain_device *parent_dev = dev->parent;
 
 	pm8001_ha = pm8001_find_ha_by_dev(dev);
 	spin_lock_irqsave(&pm8001_ha->lock, flags);
@@ -765,7 +766,13 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 			spin_lock_irqsave(&pm8001_ha->lock, flags);
 		}
 		PM8001_CHIP_DISP->dereg_dev_req(pm8001_ha, device_id);
-		pm8001_ha->phy[pm8001_dev->attached_phy].phy_attached = 0;
+
+		/*
+		 * The phy array only contains local phys. Thus, we cannot clear
+		 * phy_attached for a device behind an expander.
+		 */
+		if (!(parent_dev && dev_is_expander(parent_dev->dev_type)))
+			pm8001_ha->phy[pm8001_dev->attached_phy].phy_attached = 0;
 		pm8001_free_dev(pm8001_dev);
 	} else {
 		pm8001_dbg(pm8001_ha, DISC, "Found dev has gone.\n");
-- 
2.50.1

