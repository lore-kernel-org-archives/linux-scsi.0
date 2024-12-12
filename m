Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20447174EF0
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 20:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734036744; cv=none; b=ajaELDQh+c9FUkdU+3KY+VyNC76uUVysyM0igH9p+NteS9XI7RmuQ319u4UCLzj8aq1cpiHBaU3S6IsJQw3l3oVsWrdB5dDZZP0AaUiROu4b+V3GdYFT2Bv80UWIa41dnA9vw0Gomuu9yBaR0/Fnzo3X5b2EtXH6wgZN2tBEUVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734036744; c=relaxed/simple;
	bh=4ngiEe0x9XtiiIzntJzGDjQPZ86NDRlTiw/SBm/jL6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWnFjQgaYYI/ABkvM9UqMNjswZ6FOaVFwIOGuQpCqIQaU5MFIip+b7dMyXaTqP2gIIYl/b7jmMM9y2xMWHPIzlL2PK0O3+I4nmo8IKa8XgGIa8pMe6JNYGgp+N/8ojaCuT92bFkLaFm5999wQkRtvpFd4OpmrEHUvBh5qY/NPrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OGw5AVnN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OGw5AVnN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2JSVrMTLtEdvHY3lENAB58Do4Sads+kpExTjyXAj4QQ=; b=OGw5AVnNTt0RaxH2/c2L6TOxN1
	m17n8DRXDBv0kvbvUOQzpsbxqgjqasia/posXJ4SNrXYzPaQd11hJP4UFi5wch77y+BHvK10X/GC+
	bFSFuB0tLjRppNnDfVc5x20R+R2rgWgeNT/wGg5MpLo5iZh2F1p3qG2ZkBZ/yJX3IyrLY0OfgzNy6
	E6eAd3rXRG6oOtUsNUZyC9CH8c9yYcoXOVn2nVbJCWMFbYFpQDgP4Bq1XdaijwkSV4fw/KZuhHJNV
	TD5A6kcJjYRGEwnoauZaVnPPzIl6D/9GwKQbdPa9eJ5f/p5vDBLtWMlOqF5JNRDBe3WWjjJg18095
	xTgFOq9A==;
Received: from [50.53.2.24] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLqAX-00000001rO5-2VvX;
	Thu, 12 Dec 2024 20:52:21 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/5] scsi: scsi_error: add kernel-doc for exported functions
Date: Thu, 12 Dec 2024 12:52:13 -0800
Message-ID: <20241212205217.597844-2-rdunlap@infradead.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212205217.597844-1-rdunlap@infradead.org>
References: <20241212205217.597844-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert scsi_report_bus_reset() and scsi_report_device_reset()
to kernel-doc since they are exported. This allows them to be
part of the driver-api/scsi.rst docbook.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
CC: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>
---
 drivers/scsi/scsi_error.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- linux-next-20241212.orig/drivers/scsi/scsi_error.c
+++ linux-next-20241212/drivers/scsi/scsi_error.c
@@ -2363,14 +2363,14 @@ int scsi_error_handler(void *data)
 	return 0;
 }
 
-/*
- * Function:    scsi_report_bus_reset()
+/**
+ * scsi_report_bus_reset() - report bus reset observed
  *
- * Purpose:     Utility function used by low-level drivers to report that
- *		they have observed a bus reset on the bus being handled.
+ * Utility function used by low-level drivers to report that
+ * they have observed a bus reset on the bus being handled.
  *
- * Arguments:   shost       - Host in question
- *		channel     - channel on which reset was observed.
+ * @shost:      Host in question
+ * @channel:    channel on which reset was observed.
  *
  * Returns:     Nothing
  *
@@ -2395,15 +2395,15 @@ void scsi_report_bus_reset(struct Scsi_H
 }
 EXPORT_SYMBOL(scsi_report_bus_reset);
 
-/*
- * Function:    scsi_report_device_reset()
+/**
+ * scsi_report_device_reset() - report device reset observed
  *
- * Purpose:     Utility function used by low-level drivers to report that
- *		they have observed a device reset on the device being handled.
+ * Utility function used by low-level drivers to report that
+ * they have observed a device reset on the device being handled.
  *
- * Arguments:   shost       - Host in question
- *		channel     - channel on which reset was observed
- *		target	    - target on which reset was observed
+ * @shost:      Host in question
+ * @channel:    channel on which reset was observed
+ * @target:     target on which reset was observed
  *
  * Returns:     Nothing
  *
