Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8471A83E3
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 20:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734036744; cv=none; b=BuaKK7WqTHMjb3hrXA0aha5ypaPUJFCKkJOU8XbjjfCIZpy46EQDRD3yYBb4nqKDv0/i9FUEyfTilo79iDjOgUPjZPPExzCdT8Is1vkDi6kYTJOpvFbYsK5W2tiWc389EDy+OJFA+ZGG60l9IS2sUH2yVbiaZRVttCJKBWZsENw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734036744; c=relaxed/simple;
	bh=nQv12PEvV2tmUwfrTW4su8DaOdr/1dsZayRhHagha94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eqzi/9Ra6Ual1NYA3VtA2f8yXkRtmFxG7DJ9I0dZQE/7rbVQz8fs2VdhmPw4/1rY86++un/2U0uGzDPQr+i/c0tX76FuhjfKYIEQpjQC5kRsZmXdg8UI1zXnI/UG5AEoMqbDXZnGRdAfOmHEsneDIiWN5scLljUEmnW8jugRriI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Bby4iQlR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Bby4iQlR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=c6eUrfWUzoERxKCckTbpTcUBfrCSpBr7XbzXbOOJD4A=; b=Bby4iQlRtCdcbxXk/wbo3ItZ4J
	LO7t6ni/xEBNeSnebU+CqX0s+iVamPlwRlMkROZmgX6b2WJAhMxTlB/rmzDkgXAECDXb11XcyCYhX
	jGCmkOzaSAFY/xDBknaPHznaTOLbU9NhqTzrM9AFN2H+h0Ph0/2Gk7bFJvQYsNayWLsovZ82WCWzl
	4IGzSflMRYqNZ7G+UsKbRFS/FUOzQMHdQ3xeNHpNKdIbsYoXucjkA0KhCvyJofM0/NbNZJtTEk8h1
	T3pLeU5gsW7kezRDpBufk47ZbRxqd6eVWZH+wnSHCq/cinGcqJQkJJRb+8wnIAkY2mPtt1vo0gT5P
	pxa34ylA==;
Received: from [50.53.2.24] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLqAY-00000001rO5-19UI;
	Thu, 12 Dec 2024 20:52:22 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4/5] scsi: scsi_scan: add kernel-doc for exported function
Date: Thu, 12 Dec 2024 12:52:16 -0800
Message-ID: <20241212205217.597844-5-rdunlap@infradead.org>
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

Add kernel-doc for scsi_add_device() since it is exported.
This allows it to be part of the SCSI driver-api docbook.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
CC: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>
---
 drivers/scsi/scsi_scan.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- linux-next-20241212.orig/drivers/scsi/scsi_scan.c
+++ linux-next-20241212/drivers/scsi/scsi_scan.c
@@ -1634,6 +1634,24 @@ struct scsi_device *__scsi_add_device(st
 }
 EXPORT_SYMBOL(__scsi_add_device);
 
+/**
+ * scsi_add_device - creates a new SCSI (LU) instance
+ * @host: the &Scsi_Host instance where the device is located
+ * @channel: target channel number (rarely other than %0)
+ * @target: target id number
+ * @lun: LUN of target device
+ *
+ * Probe for a specific LUN and add it if found.
+ *
+ * Notes: This call is usually performed internally during a scsi
+ * bus scan when an HBA is added (i.e. scsi_scan_host()). So it
+ * should only be called if the HBA becomes aware of a new scsi
+ * device (lu) after scsi_scan_host() has completed. If successful
+ * this call can lead to sdev_init() and sdev_configure() callbacks
+ * into the LLD.
+ *
+ * Return: %0 on success or negative error code on failure
+ */
 int scsi_add_device(struct Scsi_Host *host, uint channel,
 		    uint target, u64 lun)
 {
@@ -2025,6 +2043,8 @@ static void do_scan_async(void *_data, a
 /**
  * scsi_scan_host - scan the given adapter
  * @shost:	adapter to scan
+ *
+ * Notes: Should be called after scsi_add_host()
  **/
 void scsi_scan_host(struct Scsi_Host *shost)
 {
