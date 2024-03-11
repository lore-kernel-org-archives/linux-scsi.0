Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300273AC08
	for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2024 11:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710157422; cv=none; b=EPWl/eM+UyL1VXzlbdQvbXC4HoB/+6E4zTlIa9ZdPW0cI43IowCRan56FhT6Fny4oh3clmxbS9XoPtA9ZcjcPlI3NsMTVv3WC6QiMhyQXxksNXOIpletDeK+a9UOFgldTzS5uXl6cvc3ydfrFOUI8lxmar7+YJ677R2tRb3ida0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710157422; c=relaxed/simple;
	bh=3u+vc8xAonqrKeoIVL3PbIslWZGbpLX+X3GVmqmj6LQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EV7OrSPnzeKb2iQzfuVDs5/vZ2RNiOFxPHiS51sMCADnWw9uXzlw55fIeg/MK7dYLbm5uHXmCy4leZTAFfrTtYM7husxP6rpNRjh8gfDdzQzTZ71YoGrMSFGZ/aohc/EhL71LA/No8mho+fikLHvqGDtmrDXYR45tLHKS4dthHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OqDIRLw0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OqDIRLw0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710157419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=idlJC1lAQbF+uMDijYoBn9iTQ1I2FiVeM+W6Mf9gOTo=;
	b=OqDIRLw0WwVW8lgZBEtM0lBPqGjQvFVkpL1qNeV6/tbL4qj+7yy0LTq5aZiOGehiHtfiW7
	4FIjx4KbMqsJvgBKpu7BiSAqeGbPhcNpsDAD+vFn5KnjgaltXo0ZaOSALS6J/6J7ByYEXK
	bza9Bny82QGFU6v92O7bOWhIcwCL4t8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-pqFiFWJjOVuBUP_d3H7fwA-1; Mon, 11 Mar 2024 07:43:37 -0400
X-MC-Unique: pqFiFWJjOVuBUP_d3H7fwA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDE14101A5AD;
	Mon, 11 Mar 2024 11:43:36 +0000 (UTC)
Received: from kaapi.redhat.com (unknown [10.67.24.5])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A933D1C060A6;
	Mon, 11 Mar 2024 11:43:33 +0000 (UTC)
From: Prasad Pandit <ppandit@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	megaraidlinux.pdl@broadcom.com,
	Prasad Pandit <pjp@fedoraproject.org>
Subject: [PATCH] scsi: megaraid: fix MEGARAID_MAILBOX option help text
Date: Mon, 11 Mar 2024 17:13:25 +0530
Message-ID: <20240311114325.1278858-1-ppandit@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

From: Prasad Pandit <pjp@fedoraproject.org>

Fix indentation of MEGARAID_MAILBOX Kconfig option help
text by adding leading spaces. Generally help text is
indented by couple spaces more beyond the leading tab<\t>
character.

Signed-off-by: Prasad Pandit <pjp@fedoraproject.org>
---
 drivers/scsi/megaraid/Kconfig.megaraid | 84 +++++++++++++-------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/megaraid/Kconfig.megaraid b/drivers/scsi/megaraid/Kconfig.megaraid
index 3f2ce1eb081c..61363d37507a 100644
--- a/drivers/scsi/megaraid/Kconfig.megaraid
+++ b/drivers/scsi/megaraid/Kconfig.megaraid
@@ -21,49 +21,49 @@ config MEGARAID_MAILBOX
 	help
 	List of supported controllers
 
-	OEM	Product Name		VID :DID :SVID:SSID
-	---	------------		---- ---- ---- ----
-	Dell PERC3/QC			101E:1960:1028:0471
-	Dell PERC3/DC			101E:1960:1028:0493
-	Dell PERC3/SC			101E:1960:1028:0475
-	Dell PERC3/Di			1028:000E:1028:0123
-	Dell PERC4/SC			1000:1960:1028:0520
-	Dell PERC4/DC			1000:1960:1028:0518
-	Dell PERC4/QC			1000:0407:1028:0531
-	Dell PERC4/Di			1028:000F:1028:014A
-	Dell PERC 4e/Si			1028:0013:1028:016c
-	Dell PERC 4e/Di			1028:0013:1028:016d
-	Dell PERC 4e/Di			1028:0013:1028:016e
-	Dell PERC 4e/Di			1028:0013:1028:016f
-	Dell PERC 4e/Di			1028:0013:1028:0170
-	Dell PERC 4e/DC			1000:0408:1028:0002
-	Dell PERC 4e/SC			1000:0408:1028:0001
-	LSI MegaRAID SCSI 320-0		1000:1960:1000:A520
-	LSI MegaRAID SCSI 320-1		1000:1960:1000:0520
-	LSI MegaRAID SCSI 320-2		1000:1960:1000:0518
-	LSI MegaRAID SCSI 320-0X	1000:0407:1000:0530
-	LSI MegaRAID SCSI 320-2X	1000:0407:1000:0532
-	LSI MegaRAID SCSI 320-4X	1000:0407:1000:0531
-	LSI MegaRAID SCSI 320-1E	1000:0408:1000:0001
-	LSI MegaRAID SCSI 320-2E	1000:0408:1000:0002
-	LSI MegaRAID SATA 150-4		1000:1960:1000:4523
-	LSI MegaRAID SATA 150-6		1000:1960:1000:0523
-	LSI MegaRAID SATA 300-4X	1000:0409:1000:3004
-	LSI MegaRAID SATA 300-8X	1000:0409:1000:3008
-	INTEL RAID Controller SRCU42X	1000:0407:8086:0532
-	INTEL RAID Controller SRCS16	1000:1960:8086:0523
-	INTEL RAID Controller SRCU42E	1000:0408:8086:0002
-	INTEL RAID Controller SRCZCRX	1000:0407:8086:0530
-	INTEL RAID Controller SRCS28X	1000:0409:8086:3008
-	INTEL RAID Controller SROMBU42E	1000:0408:8086:3431
-	INTEL RAID Controller SROMBU42E	1000:0408:8086:3499
-	INTEL RAID Controller SRCU51L	1000:1960:8086:0520
-	FSC MegaRAID PCI Express ROMB	1000:0408:1734:1065
-	ACER MegaRAID ROMB-2E		1000:0408:1025:004D
-	NEC MegaRAID PCI Express ROMB	1000:0408:1033:8287
+	  OEM  Product Name               VID :DID :SVID:SSID
+	  ---  ------------               ---- ---- ---- ----
+	  Dell PERC3/QC                   101E:1960:1028:0471
+	  Dell PERC3/DC                   101E:1960:1028:0493
+	  Dell PERC3/SC                   101E:1960:1028:0475
+	  Dell PERC3/Di                   1028:000E:1028:0123
+	  Dell PERC4/SC                   1000:1960:1028:0520
+	  Dell PERC4/DC                   1000:1960:1028:0518
+	  Dell PERC4/QC                   1000:0407:1028:0531
+	  Dell PERC4/Di                   1028:000F:1028:014A
+	  Dell PERC 4e/Si                 1028:0013:1028:016c
+	  Dell PERC 4e/Di                 1028:0013:1028:016d
+	  Dell PERC 4e/Di                 1028:0013:1028:016e
+	  Dell PERC 4e/Di                 1028:0013:1028:016f
+	  Dell PERC 4e/Di                 1028:0013:1028:0170
+	  Dell PERC 4e/DC                 1000:0408:1028:0002
+	  Dell PERC 4e/SC                 1000:0408:1028:0001
+	  LSI MegaRAID SCSI 320-0         1000:1960:1000:A520
+	  LSI MegaRAID SCSI 320-1         1000:1960:1000:0520
+	  LSI MegaRAID SCSI 320-2         1000:1960:1000:0518
+	  LSI MegaRAID SCSI 320-0X        1000:0407:1000:0530
+	  LSI MegaRAID SCSI 320-2X        1000:0407:1000:0532
+	  LSI MegaRAID SCSI 320-4X        1000:0407:1000:0531
+	  LSI MegaRAID SCSI 320-1E        1000:0408:1000:0001
+	  LSI MegaRAID SCSI 320-2E        1000:0408:1000:0002
+	  LSI MegaRAID SATA 150-4         1000:1960:1000:4523
+	  LSI MegaRAID SATA 150-6         1000:1960:1000:0523
+	  LSI MegaRAID SATA 300-4X        1000:0409:1000:3004
+	  LSI MegaRAID SATA 300-8X        1000:0409:1000:3008
+	  INTEL RAID Controller SRCU42X   1000:0407:8086:0532
+	  INTEL RAID Controller SRCS16    1000:1960:8086:0523
+	  INTEL RAID Controller SRCU42E   1000:0408:8086:0002
+	  INTEL RAID Controller SRCZCRX   1000:0407:8086:0530
+	  INTEL RAID Controller SRCS28X   1000:0409:8086:3008
+	  INTEL RAID Controller SROMBU42E 1000:0408:8086:3431
+	  INTEL RAID Controller SROMBU42E 1000:0408:8086:3499
+	  INTEL RAID Controller SRCU51L   1000:1960:8086:0520
+	  FSC MegaRAID PCI Express ROMB   1000:0408:1734:1065
+	  ACER MegaRAID ROMB-2E           1000:0408:1025:004D
+	  NEC MegaRAID PCI Express ROMB   1000:0408:1033:8287
 
-	To compile this driver as a module, choose M here: the
-	module will be called megaraid_mbox
+	  To compile this driver as a module, choose M here: the
+	  module will be called megaraid_mbox
 
 config MEGARAID_LEGACY
 	tristate "LSI Logic Legacy MegaRAID Driver"
-- 
2.44.0

