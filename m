Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50301799F;
	Sat, 12 Oct 2024 03:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728703627; cv=none; b=oQbVPqnrM/vRaGeQARVNd73mBCPctaJWSTpWILYPkKbEdlTi1ZW7qlT22j68IrUTUlAEwd6exQPeL24PRAWPkKnT+OJmO12v8VLkO+B9t9ujmj1ApJBbl9R0wmjlaytPBTlhKVNVpAm92XD/qO7CVyw4RJOjguWpQi5f4Gps/Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728703627; c=relaxed/simple;
	bh=yXK1u5PItF4Ot2af8coMY40M905Rki8UymkHhymTln8=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=gLRGXFN4X9Ev/s1TZnNLUVK2v83ZMdGtt5ZnFC0tkb47Hh3useLsN/SPAZxEyO8zMUUpsDJ7oYNaaR8xMVIMDYCYnv9LoloFBh2UrI7FyBuhnM12k7qYv+f/pk5mIHgDgnR97Udot2T81Yqb0ZpzRE1IgwH2lFZEUT1reRk0YMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=sY5V+3NV; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=sY5V+3NV; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="sY5V+3NV";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="sY5V+3NV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1728703623;
	bh=yXK1u5PItF4Ot2af8coMY40M905Rki8UymkHhymTln8=;
	h=Message-ID:Subject:From:To:Date:From;
	b=sY5V+3NVaRCtWkAhcfIxi/iNb9ZTL5F5Yg8YDVALTcQIHTpLjcyPE5orsWjSIQbOQ
	 qIbdpzTUmJEKJSVOS2rp8QpLgAl8hUmVMLeMlQ2icRcCPIaEikJDLmUl6QoEsLglJV
	 qCn8txz857NUcJc6YbIcor0gySTVtTnxgrdoxxvw=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id DCC781287451;
	Fri, 11 Oct 2024 23:27:03 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id hxWRwQPyqFxc; Fri, 11 Oct 2024 23:27:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1728703623;
	bh=yXK1u5PItF4Ot2af8coMY40M905Rki8UymkHhymTln8=;
	h=Message-ID:Subject:From:To:Date:From;
	b=sY5V+3NVaRCtWkAhcfIxi/iNb9ZTL5F5Yg8YDVALTcQIHTpLjcyPE5orsWjSIQbOQ
	 qIbdpzTUmJEKJSVOS2rp8QpLgAl8hUmVMLeMlQ2icRcCPIaEikJDLmUl6QoEsLglJV
	 qCn8txz857NUcJc6YbIcor0gySTVtTnxgrdoxxvw=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::db7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 4444F12873D4;
	Fri, 11 Oct 2024 23:27:03 -0400 (EDT)
Message-ID: <edf88708320d05c4b2f654a06a7fdbba9f9a868c.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.12-rc2
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Fri, 11 Oct 2024 23:27:01 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

four small fixes, three in drivers and one in the FC transport class to
add idempotence to state setting.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Avri Altman (1):
      scsi: ufs: Use pre-calculated offsets in ufshcd_init_lrb()

Benjamin Marzinski (1):
      scsi: scsi_transport_fc: Allow setting rport state to current state

Daniel Palmer (1):
      scsi: wd33c93: Don't use stale scsi_pointer value

Martin Wilck (1):
      scsi: fnic: Move flush_work initialization out of if block


And the diffstat:

 drivers/scsi/fnic/fnic_main.c    | 2 +-
 drivers/scsi/scsi_transport_fc.c | 4 ++--
 drivers/scsi/wd33c93.c           | 2 +-
 drivers/ufs/core/ufshcd.c        | 5 ++---
 4 files changed, 6 insertions(+), 7 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 0044717d4486..adec0df24bc4 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -830,7 +830,6 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		spin_lock_init(&fnic->vlans_lock);
 		INIT_WORK(&fnic->fip_frame_work, fnic_handle_fip_frame);
 		INIT_WORK(&fnic->event_work, fnic_handle_event);
-		INIT_WORK(&fnic->flush_work, fnic_flush_tx);
 		skb_queue_head_init(&fnic->fip_frame_queue);
 		INIT_LIST_HEAD(&fnic->evlist);
 		INIT_LIST_HEAD(&fnic->vlans);
@@ -948,6 +947,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	INIT_WORK(&fnic->link_work, fnic_handle_link);
 	INIT_WORK(&fnic->frame_work, fnic_handle_frame);
+	INIT_WORK(&fnic->flush_work, fnic_flush_tx);
 	skb_queue_head_init(&fnic->frame_queue);
 	skb_queue_head_init(&fnic->tx_queue);
 
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 62ea7e44460e..082f76e76721 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1250,7 +1250,7 @@ static ssize_t fc_rport_set_marginal_state(struct device *dev,
 		 */
 		if (rport->port_state == FC_PORTSTATE_ONLINE)
 			rport->port_state = port_state;
-		else
+		else if (port_state != rport->port_state)
 			return -EINVAL;
 	} else if (port_state == FC_PORTSTATE_ONLINE) {
 		/*
@@ -1260,7 +1260,7 @@ static ssize_t fc_rport_set_marginal_state(struct device *dev,
 		 */
 		if (rport->port_state == FC_PORTSTATE_MARGINAL)
 			rport->port_state = port_state;
-		else
+		else if (port_state != rport->port_state)
 			return -EINVAL;
 	} else
 		return -EINVAL;
diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index a44b60c9004a..dd1fef9226f2 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -831,7 +831,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 		/* construct an IDENTIFY message with correct disconnect bit */
 
 		hostdata->outgoing_msg[0] = IDENTIFY(0, cmd->device->lun);
-		if (scsi_pointer->phase)
+		if (WD33C93_scsi_pointer(cmd)->phase)
 			hostdata->outgoing_msg[0] |= 0x40;
 
 		if (hostdata->sync_stat[cmd->device->id] == SS_FIRST) {
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 24a32e2fd75e..6a71ebf953e2 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2933,9 +2933,8 @@ static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb, int i)
 	struct utp_transfer_req_desc *utrdlp = hba->utrdl_base_addr;
 	dma_addr_t cmd_desc_element_addr = hba->ucdl_dma_addr +
 		i * ufshcd_get_ucd_size(hba);
-	u16 response_offset = offsetof(struct utp_transfer_cmd_desc,
-				       response_upiu);
-	u16 prdt_offset = offsetof(struct utp_transfer_cmd_desc, prd_table);
+	u16 response_offset = le16_to_cpu(utrdlp[i].response_upiu_offset);
+	u16 prdt_offset = le16_to_cpu(utrdlp[i].prd_table_offset);
 
 	lrb->utr_descriptor_ptr = utrdlp + i;
 	lrb->utrd_dma_addr = hba->utrdl_dma_addr +

