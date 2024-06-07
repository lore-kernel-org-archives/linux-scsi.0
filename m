Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5481C17BB7
	for <linux-scsi@vger.kernel.org>; Fri,  7 Jun 2024 21:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717796177; cv=none; b=AYEY2v0pyP1XPCIn0FmiPsGlNoQDmmpkbv6cw2Onf/Gk5M3pToa1P32NpXP5D7djFMmD6JNnj7EpM6S+6rFXCSj94/ceb0fBK5W06d6LqvUFhvHDoIMw45BtFDBCwAT1B8wbevzYjC/pY30k4suPNMD8TX1RGk6Swuc+QNbG2vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717796177; c=relaxed/simple;
	bh=w7ulkvBJ8MHNux1vQB4j7ZnSrBo2H1oP/7ItTQ7S4Yk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O4SFyT+mY8jdkcuEWhx6XJtk6es673WmvdKmsrIrVEoIY3W5oydKuq2Mz35R2i6xUnskcrKm2m09p20yh1korsNBnn7cxCmM9ijuDrlp2CouKdoVta5O1kzJLKfARPW76VYLEb6U2MXpfIpEvccVfWi2DH3O9YQVdgq7Vf/DKDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=fq/ZHh8i; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="fq/ZHh8i"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Vwvdq5bGyzlgMVV;
	Fri,  7 Jun 2024 21:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1717796173; x=1720388174; bh=tqLjFiJCgI7d5jali+3FQIJNjOQCM0JGRBD
	2FkcWyHU=; b=fq/ZHh8i0rrnfKGY6TZ1rnyfHxxt5DkS+R64jwtym3+cGEjOdjE
	rI7qsMYBlszTqyuE/fxRrFvgw7qMB1AFSCdJ5WyYqlWPe20Uq2c+VKbhddJX1DtY
	BrHMF7lXnGy6BEGKaK0rKaPfecwsla6VjiOmrqadE5lLAc/SShnExAQYWMZ3wPqn
	LqJygAYAmHK2dsCNbt4FIzX+fJt5NAORKfReMHq+hYgdJYuh3IdWjdubNWh0/5XP
	3YuPkMRiylzU/NUrH+L6q7VO7Vm1rQB9xaXudOQQpcx0XYeQC043XnTnPe2HFh57
	RUPQU7e8cGe7Nlfs1AaymNw3c7x8rtLveew==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id AD7CD0vL946H; Fri,  7 Jun 2024 21:36:13 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Vwvdm59j9zlgMVS;
	Fri,  7 Jun 2024 21:36:12 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <Avri.Altman@wdc.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] scsi: core: Remove an incorrect comment
Date: Fri,  7 Jun 2024 14:35:53 -0700
Message-ID: <20240607213553.1743087-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The comment that scsi_static_device_list would go away was added more tha=
n
18 years ago. Today, that list is still there and 84 additional entries h=
ave
been added. This shows that the comment is incorrect. Hence remove that
comment.

Cc: Avri Altman <Avri.Altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_devinfo.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 85111e14c53b..5c23ab2b98ab 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -39,13 +39,9 @@ static LIST_HEAD(scsi_dev_info_list);
 static char scsi_dev_flags[256];
=20
 /*
- * scsi_static_device_list: deprecated list of devices that require
- * settings that differ from the default, includes black-listed (broken)
- * devices. The entries here are added to the tail of scsi_dev_info_list
- * via scsi_dev_info_list_init.
- *
- * Do not add to this list, use the command line or proc interface to ad=
d
- * to the scsi_dev_info_list. This table will eventually go away.
+ * scsi_static_device_list: list of devices that require settings that d=
iffer
+ * from the default, includes black-listed (broken) devices. The entries=
 here
+ * are added to the tail of scsi_dev_info_list via scsi_dev_info_list_in=
it.
  */
 static struct {
 	char *vendor;
