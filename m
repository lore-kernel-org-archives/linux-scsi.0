Received: from iad-out-011.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-011.esa.us-east-1.outbound.mail-perimeter.amazon.com [54.211.126.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCF03E4C74;
	Thu,  2 Apr 2026 13:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.211.126.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775138243; cv=none; b=HbP7mfgTvTz2dKeipPLZNTzjfYTerB9QLsXxcIqjzXIwuTQ68DFb3B0Vth/YlogcgiZkcjbndFFKRhzsNIkbDc2WaUOXjF2SBg6/89g6MNEtfEA2tdcbau1kDA6+7WmJQfCXNi2Isgke5L3i//wK8sGKsLoxA0aouQnLZ6nd60E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775138243; c=relaxed/simple;
	bh=1+WHPwcQvkrDqjN7jtha7n2OLLRrBtkNbbXM9KBS+Vk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=liOckUgTqDSMLDS+maRvpI4Bo4o5vNe5Jt5mwRLb63gjtIWlgTot12ZXlObNVioobo9Mbs72HdG7E/6hySOtB0k1QvbN4V2RKXhzL6Ugq92eztEn0ZmXfUXA299gPWswbKfZe9iHkUobT0Tv0cZaoq81ZBH+By1vp/oaP+sc84U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=EDNHvxwr; arc=none smtp.client-ip=54.211.126.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="EDNHvxwr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1775138241; x=1806674241;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version:content-transfer-encoding;
  bh=wuthZuZJNuIVCbef4TvR92fybPm79mBQ8LikDhPWnf0=;
  b=EDNHvxwrbLXz+qGlkPgo9zRC3f5SmEDBrzuZAzM72EFAITDS63I24f2X
   2IiyI4t3xQ+zlYVbWkOtPTXe/OY7ODBLgLGRNyYj1ApdE70PnMUq4EURH
   iJ2mXXq/x0SC9INAlhPpyHZ3WtVOueZr6PQOUd0AqLuFw2/VqnruRmqhI
   Ev0KiAI+tuHQjvrurZBo4pcgSNS7FJj6zGARVPBjZzDiO+EmoEn1OjCrG
   A/tRT8wN8PXrXxgaYROWqkUtI4h4Ig7yNgWUMZgIPrJgryKdm0uKXqwAB
   A/gLphG5Df6yvOxGTTmUJOkHsoneoMLVvdqdmfX80VnVpLdWO9ACqK+Mh
   g==;
X-CSE-ConnectionGUID: wmue6bv0TJ6AjraC9JMWAw==
X-CSE-MsgGUID: +gr5tpNzQMafIjWemEgWdA==
X-IronPort-AV: E=Sophos;i="6.23,155,1770595200"; 
   d="scan'208";a="15265777"
Received: from ip-10-4-3-150.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.3.150])
  by internal-iad-out-011.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2026 13:57:17 +0000
Received: from EX19MTAUEC001.ant.amazon.com [52.94.133.134:1848]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.95.220:2525] with esmtp (Farcaster)
 id 5af4ab1e-2771-496a-a456-0cc6e54b38d6; Thu, 2 Apr 2026 13:57:17 +0000 (UTC)
X-Farcaster-Flow-ID: 5af4ab1e-2771-496a-a456-0cc6e54b38d6
Received: from EX19D012UEC001.ant.amazon.com (10.252.135.206) by
 EX19MTAUEC001.ant.amazon.com (10.252.135.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 2 Apr 2026 13:57:17 +0000
Received: from EX19D012UEC003.ant.amazon.com (10.252.135.160) by
 EX19D012UEC001.ant.amazon.com (10.252.135.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 2 Apr 2026 13:57:16 +0000
Received: from EX19D012UEC003.ant.amazon.com ([fe80::67ea:859:1e17:25a9]) by
 EX19D012UEC003.ant.amazon.com ([fe80::67ea:859:1e17:25a9%3]) with mapi id
 15.02.2562.037; Thu, 2 Apr 2026 13:57:16 +0000
From: "Heyne, Maximilian" <mheyne@amazon.de>
To: "stable@vger.kernel.org" <stable@vger.kernel.org>
CC: "Heyne, Maximilian" <mheyne@amazon.de>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>, "Keith
 Busch" <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, Hector Martin
	<marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>, Alyssa Rosenzweig
	<alyssa@rosenzweig.io>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin
 K. Petersen" <martin.petersen@oracle.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Bart Van Assche
	<bvanassche@acm.org>, Sasha Levin <sashal@kernel.org>, Peter Wang
	<peter.wang@mediatek.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sanjeev Yadav <sanjeev.y@mediatek.com>, Adrian Hunter
	<adrian.hunter@intel.com>, Seunghwan Baek <sh8267.baek@samsung.com>, "Brian
 Kao" <powenkao@google.com>, Seunghui Lee <sh043.lee@samsung.com>, Wonkon Kim
	<wkon.kim@samsung.com>, Hannes Reinecke <hare@suse.de>, Ming Lei
	<ming.lei@redhat.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "asahi@lists.linux.dev"
	<asahi@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
Subject: [PATCH 6.1.y v2 3/6] nvme-pci: remove an extra queue reference
Thread-Topic: [PATCH 6.1.y v2 3/6] nvme-pci: remove an extra queue reference
Thread-Index: AQHcwqid6cK14LT21EWoDH9t6D61vA==
Date: Thu, 2 Apr 2026 13:57:16 +0000
Message-ID: <20260402-virtual-london-e865225a@mheyne-amazon>
References: <20260402-moral-jockey-f072379b@mheyne-amazon>
In-Reply-To: <20260402-moral-jockey-f072379b@mheyne-amazon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 7dcebef90d35de13a326f765dd787538880566f9 ]

Now that blk_mq_destroy_queue does not release the queue reference, there
is no need for a second admin queue reference to be held by the nvme_dev.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Link: https://lore.kernel.org/r/20221018135720.670094-4-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 03b3bcd319b3 ("nvme: fix admin request_queue lifetime")
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
---
 drivers/nvme/host/pci.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 727585f580362..13c0098939ec0 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1782,7 +1782,6 @@ static void nvme_dev_remove_admin(struct nvme_dev *de=
v)
 		 */
 		nvme_start_admin_queue(&dev->ctrl);
 		blk_mq_destroy_queue(dev->ctrl.admin_q);
-		blk_put_queue(dev->ctrl.admin_q);
 		blk_mq_free_tag_set(&dev->admin_tagset);
 	}
 }
@@ -1811,11 +1810,6 @@ static int nvme_pci_alloc_admin_tag_set(struct nvme_=
dev *dev)
 		dev->ctrl.admin_q =3D NULL;
 		return -ENOMEM;
 	}
-	if (!blk_get_queue(dev->ctrl.admin_q)) {
-		nvme_dev_remove_admin(dev);
-		dev->ctrl.admin_q =3D NULL;
-		return -ENODEV;
-	}
 	return 0;
 }
 =

-- =

2.50.1




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

