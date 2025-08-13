Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC3723A9AD
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 11:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755085292; cv=none; b=Oee+Jbr+wCFl+L3ydtYQ1JExGOh8gEB4kCgD8TLMpVt4YH6xUQADYTx/J5DgRDXJmEIm8ykSu6eA7Fh90AX4CkcAUBLex/u1PfzDEeaLgjmMGOD5M4xXHwy9ad1S/vv1LbxNIkwUFP+y6QZEKgxfAKNqgeQjNjgKK5RztE3pec0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755085292; c=relaxed/simple;
	bh=kDSg/Iir+/NEXBQmrX7qIcvec0b09MrJ0ty5eQppkFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4R8g72JgRUlAKuHzveVyHN8tD8QE+vP0HEdcKBtvvBkoGkvsahp2yOz/ddLjyszGlmcw0vBVM6wA1QbhGQ6sL+clZskLQxJ0HLdgC/SgbmK+LXJmJ1pvluXkhVtPt4JHuT7U8GW9JW417/gG0LCOiO8+78zJh4Grn5eIAN7SRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ty2FJshU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ty2FJshU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4179C4CEF7;
	Wed, 13 Aug 2025 11:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755085291;
	bh=kDSg/Iir+/NEXBQmrX7qIcvec0b09MrJ0ty5eQppkFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ty2FJshUlTarWAEzCiD4dQ4j+f3xqao9UwYDLBhiH5MCU2GsPez0WjvCGm90d1SB7
	 63KHJeQUIlGkVs71Xt4Lb/fPlxEVbPlsB9KqML29VHCpofK6srUfgaUT0iqSws+LyV
	 lzNt9JjjsmufYbWdKTuwr07C8q+KsciIuY2h28098covksCkg2H2ia5Gox0MeoB1O7
	 qhKSyslQkSR8Fq2JLqo+R8FW5dn20jxQfBNSGWtWJT2DenHVXyKCYl8UWGzVr5Mkf8
	 ChuivAwHgOuv44r6FWClCUnmeQ24DQgoRaWScSWoo0z7d+XRt+WCxvzaqV/uWpSB+N
	 vsgjkWvc38DzA==
From: Niklas Cassel <cassel@kernel.org>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Salomon Dushimirimana <salomondush@google.com>,
	Igor Pylypiv <ipylypiv@google.com>
Cc: Terrence Adams <tadamsjr@google.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 2/5] scsi: pm80xx: Fix array-index-out-of-of-bounds on rmmod
Date: Wed, 13 Aug 2025 13:41:09 +0200
Message-ID: <20250813114107.916919-9-cassel@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250813114107.916919-7-cassel@kernel.org>
References: <20250813114107.916919-7-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2543; i=cassel@kernel.org; h=from:subject; bh=kDSg/Iir+/NEXBQmrX7qIcvec0b09MrJ0ty5eQppkFs=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGDLmVN6YwHXiBZ+FSMmzNta4kzOfHj9zMYn/JYtK35ODs 7+aix2s7ihlYRDjYpAVU2Tx/eGyv7jbfcpxxTs2MHNYmUCGMHBxCsBEeL8yMtwUuf999ruZYQIa kVWT3pv0tv903v+oK837962gtKJHi2Yy/NM69XXbyfdP9bxi7i6wtb9/ITc7nbF2/f+D+rJB85N n6PICAA==
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

