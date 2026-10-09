Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B804399E5;
	Fri,  9 Oct 2026 10:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791541449; cv=none; b=W3eE4JAlOoMP7uEWVjzPuSkQSPqlTCXI28IwfeAl30rf5hjo48swJ8Hf5EMCAbr2jZmzEHEEQiLfPTn0NAVWCpFQM5vPbwtFayeKu7+JFkG24oebBT1nBSy8CFBtnv8rsrpPYvv41WdQi4SsB+drNrCFwiS2CLShMcbFCEpaSqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791541449; c=relaxed/simple;
	bh=BJDzcGy4JIU913P6t8mqPRNnnyEvnW+/IXceoboin18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVhj9w2fMJSJAGzHzjW+hCr0d16E3kw/mnd5UHZ1HxfIap81bsvOJtWFvTzvQUrzRKzgXgm6uOoMBkAxcD85+76Bng6l4fUO315N3D8LFxAzVBjcNYB8O5oMsBH3Kif/R9roGsKlVxgh4ODX2GLYwqopUxQYoPgK91ak6ElnmbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=VqUoN0j7; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="VqUoN0j7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Id
	9mTCz2OGtDEmVRucMr/9oLM0Kr8EE4L7PHILKArH8=; b=VqUoN0j7m3jBwm9uw7
	Vs1MjHBrMcs67nBcKjpH6yZQ9zx1SWbPPM6Nt2ogwm6cOdSa3PToA0wk0+4tBz2T
	4VPjnHufDq3ATQHIO06Q8jSr8XPC6A7Gfwi44uOgzoRhXd9yUu79ef3g73e3gxfJ
	uRxjRLSgPLgPf2GKcYs1AIPKI=
Received: from WIN-TOG0NDEIICD.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wBnjvSRwMhqk4VBDQ--.5655S5;
	Fri, 09 Oct 2026 18:23:17 +0800 (CST)
From: Shirong Zhao <shxzhaosr@163.com>
To: "Martin K . Petersen" <mkp@kernel.org>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Dongdong Hao <doubled@leap-io-kernel.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	MPT-FusionLinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] scsi: leapraid: check set_identify result in update_links
Date: Fri,  9 Oct 2026 18:23:12 +0800
Message-ID: <20261009102313.18-4-shxzhaosr@163.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261009102313.18-1-shxzhaosr@163.com>
References: <20261009102313.18-1-shxzhaosr@163.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnjvSRwMhqk4VBDQ--.5655S5
X-Coremail-Antispam: 1Uf129KBjvJXoW7uFWUKry3WFWxAw47Ar4xWFg_yoW8Ar43pa
	1kW3sIk348XF9Y9rs5JF4IqryFkFZYv34Iy393ZwnYkFs8KrW3KwsrKr12qa48Krs7XFnY
	9r4jqryDGFWIya7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jpq2tUUUUU=
X-CM-SenderInfo: hvk06xhdrv2qqrwthudrp/xtbC7hUiYGrIwJWddwAA3k

leapraid_transport_update_links() ignores the return value of
leapraid_transport_set_identify(), which leaves the identify struct
untouched on FW query failure (recovery in progress, config page
error).  The phy is then attached using a stale
card_phy->remote_identify.sas_address from before the failed query.

Fold the call into the if condition so a failed query takes the
existing zeroing else path (same "no valid identify" state as an
invalid handle/rate) instead of attaching with stale data.  The next
successful link event re-fills the identify.

Verified against scsi.git fixes (469fa055664b), the current SCSI
fixes tree.

Signed-off-by: Shirong Zhao <shxzhaosr@163.com>
---
 drivers/scsi/leapraid/leapraid_transport.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/leapraid/leapraid_transport.c b/drivers/scsi/leapraid/leapraid_transport.c
index 77ffbd6dd..38e63327d 100644
--- a/drivers/scsi/leapraid/leapraid_transport.c
+++ b/drivers/scsi/leapraid/leapraid_transport.c
@@ -1150,9 +1150,9 @@ void leapraid_transport_update_links(
 	card_phy->attached_hdl = hdl;
 	spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock, flags);
 
-	if (hdl && link_rate >= LEAPRAID_SAS_NEG_LINK_RATE_1_5) {
-		leapraid_transport_set_identify(adapter, hdl,
-						&card_phy->remote_identify);
+	if (hdl && link_rate >= LEAPRAID_SAS_NEG_LINK_RATE_1_5 &&
+	    !leapraid_transport_set_identify(adapter, hdl,
+					     &card_phy->remote_identify)) {
 		if (topo_node->hdl <= adapter->dev_topo.card.phys_num &&
 		    adapter->adapter_attr.enable_mp) {
 			list_for_each_entry(card_port,

