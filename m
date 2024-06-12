Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C966EB74
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jun 2024 17:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718212531; cv=none; b=t3j9pv/OeMUtyfAQNC9uIM0JsgRfRG2EX3dAcPtS6hp8DVEHgRK+0+Hj3tZtvaW8qXHM28rUyRWfl2nRCBUAlmdX7ZKAK868dLp6cNdKV0wDyhejiWWC2fR8H93U32Rnr4l7ZuiFs9Pnu+RZ3w70iSap0dXsACsmkNfEIB4/dtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718212531; c=relaxed/simple;
	bh=I9vtZK+uFJhlUDA6Aq9Yv/UiojMLeWsojGZayi8gHJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B5LAvb/AFWBxZsLT1n+ZWXsSTIz73d6eqpnzyB/wjxSmab/DV9V3L8QnbpJNm1KcdM17RjQ2D45tMuQqTE34ugNCMCJodkZXoz81AGQeZ3MHlH6YrTKHyZpxHMXmcBuoGxAMqmvdN+1VyajeZLdW5LGObOZjjOslzmkZXYZyU7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TyL/gXUU; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TyL/gXUU"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Vzscd397LzlgMVW;
	Wed, 12 Jun 2024 17:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1718212526; x=1720804527; bh=v0YvfBIqi7u4xDYwG1sC+9Zr+vG5gtgS/Rw
	5D0SEHGo=; b=TyL/gXUUuANzLkhanTHm+UpkYTulEmLxWyRirR3eYoQnUPkDj7z
	g7mYGHDxqFJrwmHtgy/84FgNbedQau93xwSVPOZVMACPQ4aAYOA6tpcd5ImwVa77
	TNcK8JgR3LLg6MSlGLXTE2dsEp31WhA3TwxZgRirv5Oy6Ar/kA0HijUJLtpyJlA8
	L76m8t5MmSBZi5csaYUZxE4VGZFPrFgTZxCw3pnKOhmg8pY92sGpCN5fZ0ul6iHP
	5qNI8pyhUwDW/C61Tkd/JMS9elvkvGkMQ6ttuIeZkzeNdHlwAR5TFMUBj9kyA1x5
	770+h9cYOJJLdaJ6m9m/+ZI6kR3x2bI9e8g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id lkCC-N1vZf3M; Wed, 12 Jun 2024 17:15:26 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VzscY3nq5zlgMVV;
	Wed, 12 Jun 2024 17:15:25 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@infradead.org>,
	Avri Altman <Avri.Altman@wdc.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2] scsi: core: Fix an incorrect comment
Date: Wed, 12 Jun 2024 10:15:21 -0700
Message-ID: <20240612171522.2677600-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The comment that scsi_static_device_list would go away was added more
than 18 years ago. Today, that list is still there and a large number
of additional entries have been added. This shows that this comment is
incorrect. Hence fix that comment.

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Avri Altman <Avri.Altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---

Changes compared to v1: addressed Christoph's review feedback.

 drivers/scsi/scsi_devinfo.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index a7071e71389e..90f1393a23f8 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -39,13 +39,12 @@ static LIST_HEAD(scsi_dev_info_list);
 static char scsi_dev_flags[256];
=20
 /*
- * scsi_static_device_list: deprecated list of devices that require
- * settings that differ from the default, includes black-listed (broken)
- * devices. The entries here are added to the tail of scsi_dev_info_list
- * via scsi_dev_info_list_init.
+ * scsi_static_device_list: list of devices that require settings that d=
iffer
+ * from the default, includes black-listed (broken) devices. The entries=
 here
+ * are added to the tail of scsi_dev_info_list via scsi_dev_info_list_in=
it.
  *
- * Do not add to this list, use the command line or proc interface to ad=
d
- * to the scsi_dev_info_list. This table will eventually go away.
+ * If possible, set the BLIST_* flags from inside a SCSI LLD rather than
+ * adding an entry to this list.
  */
 static struct {
 	char *vendor;
