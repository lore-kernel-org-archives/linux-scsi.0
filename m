Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE751C6894
	for <linux-scsi@vger.kernel.org>; Wed, 29 May 2024 20:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717015978; cv=none; b=UJsZyArX0/M3/JNkYVG4MsHguqQezEVQ+RzqwBtuMj+GhdG4RLmlPYSkM1q5HSQbcUEwZno6R6J4vzMIblllReYRXqUO1X3dQD0bwa+DcIll7OR5omG7MznInI0vSb64dr30019eMFMgnuxDO/rVJEYTa+G8Xjwvh6HUAAg8Jl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717015978; c=relaxed/simple;
	bh=75sRKqeeWHo3+OufbjfCRYtq/53f4mzwbVulvR2GNew=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=swquQVDi6+/h4BCJasH5+PPJBzsosvShGvX0+YbCEo1/eqx+M40rq8U/XxH7Z3SvOF//wuOj9DNYgEswUXfUrpDsNMmee5aqdXOc/3r/36X4RZVjyla4ACRa/PpnbLoq0VNFO7eNR67wq4z0iQbN78FmgQm3f4g9Q/SX2IUtNB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Pn3AvgEr; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Pn3AvgEr"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VqM600PjSzlgMVV;
	Wed, 29 May 2024 20:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:mime-version
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1717015972; x=1719607973; bh=mio49
	aLjBSeNQBX7umG1gbl5XIHa14rCJ5/1benJCew=; b=Pn3AvgErq1nWOOBYwzN1w
	ka6oDurG+1VOxN6A3VMJLt5Rog+zI5oJ7QW3K7KrDRoN1//EDuQgEn/P5u7bTWee
	EjanQMWTPFa5ju1CEAhzLoxpfl+CGeZci8AGu2QQtffTARWGzl8b7sJqvk5VM2gt
	BV19+TRlB15i3/CWz/AkqHap9uRyDAA9hoGpKM0kHQzHAHnwNfMbBz4pRkaoZXBs
	9OWAihKhRgCD5uhEHX3QHeCZX+eHA2NfI5Na8TF7zUj6dZeEMhIggweLzqEI9ucL
	fbmB6BQ8e6vk072iCR5nrcjmSLAW0sZP6IB1zCIkD7AVue+4yfixYffT8h1I7cKD
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id bOaTWvnEL4ID; Wed, 29 May 2024 20:52:52 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VqM5t5W3FzlgMVR;
	Wed, 29 May 2024 20:52:50 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Tomas Henzl <thenzl@redhat.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] scsi: mpi3mr: Fix a format specifier
Date: Wed, 29 May 2024 13:52:26 -0700
Message-ID: <20240529205226.3146936-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Fix the following compiler warning when building a 32-bit kernel:

./include/linux/kern_levels.h:5:25: error: format =E2=80=98%lu=E2=80=99 e=
xpects argument of type =E2=80=98long unsigned int=E2=80=99, but argument=
 4 has type =E2=80=98unsigned int=E2=80=99 [-Werror=3Dformat=3D]
drivers/scsi/mpi3mr/mpi3mr_transport.c:1367:25: note: in expansion of mac=
ro =E2=80=98ioc_warn=E2=80=99
 1367 |                         ioc_warn(mrioc, "skipping port %u, max al=
lowed value is %lu\n",
      |                         ^~~~~~~~

Cc: Tomas Henzl <thenzl@redhat.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Fixes: 3668651def2c ("scsi: mpi3mr: Sanitise num_phys")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr=
/mpi3mr_transport.c
index 329cc6ec3b58..82aa4e418c5a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1364,7 +1364,7 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(=
struct mpi3mr_ioc *mrioc,
 			continue;
=20
 		if (i > sizeof(mr_sas_port->phy_mask) * 8) {
-			ioc_warn(mrioc, "skipping port %u, max allowed value is %lu\n",
+			ioc_warn(mrioc, "skipping port %u, max allowed value is %zu\n",
 			    i, sizeof(mr_sas_port->phy_mask) * 8);
 			goto out_fail;
 		}
