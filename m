Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFEE327BE3;
	Tue, 16 Dec 2025 22:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765924280; cv=none; b=StBeAzTyKh93tSCpDSsRE8i308krvNuTSvOx8QqdBCWjgd4hQO31fQ1+19ZfrHnwtcTtq65pxH9p0k27K/dceK1xfGixik94okKs6js/pemwWyaGKoeOFs1Bsw6z+e3b7+PENb0HeQHj0NeOabIyibx6QNRlMwQBWpAbc4bYCtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765924280; c=relaxed/simple;
	bh=rGQ7cD+WD8VJqSiZwmrjRrv2qXbogTf+qPkCwpSuqvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7CxmADN9Jp+0kR9cWbIJ/CVWhwnRufKV6yRthput7UKMizMaDs1NOqhpU8fnqeLbltWhMLBsnwoBB+z4nRatzoZU467YJlFDR0DudDJYgjgpnOAWe76Oa5+isixoYToSRiSqkwlpvg/MxtSiU8tA0gUzt5takgpu+WarmQG0j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=zkkB1Kqg; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="zkkB1Kqg"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dWBVG32DJzmP6Yq;
	Tue, 16 Dec 2025 22:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1765924276; x=1768516277; bh=1YTad
	rV1D5VanxHmRs1Ii8qKcCpKbjOgxauMNMlR4II=; b=zkkB1Kqgtet0llu8mjyLK
	qP8mTrrUNVZJ+k2WgFcIZSK0XHp8Ja762aiuz/vaF9MnP5db948Ibk7l6sR/i8Mf
	c6FGxg/nmfbx+rwrNaeGjPqK6Dia5Anmzys2BISrQ4mEthkLFldvNINIM1gHAr28
	AkCUlamgWyqGz6gupHe+j1lr0RY+q/NBVRWI7xobAp20ismIz2YAn8Hx9aXPuWQC
	lO7PKVMXczbqc7ruEJvrJpxlNIB2gijoMb/VFlos3ZxiaHhwQrpZmTsSy1klDa6m
	AoOyGlYJ6myXoV7PQZvAsgJS/T4pXhGzWhKF/ULzVxXL+iE7B+KKIsa7MhRu4mL5
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id p5uAYxQsL0gP; Tue, 16 Dec 2025 22:31:16 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dWBV94X4TzmKtSM;
	Tue, 16 Dec 2025 22:31:13 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Niklas Cassel <cassel@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v4 4/6] ata: libata: Set .needs_budget_token
Date: Tue, 16 Dec 2025 14:30:48 -0800
Message-ID: <20251216223052.350366-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.305.g3fc767764a-goog
In-Reply-To: <20251216223052.350366-1-bvanassche@acm.org>
References: <20251216223052.350366-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Make the SCSI core set cmd->budget_token because there is code in the
ATA core that uses this member variable directly. Prepare for skipping
the SCSI budget map allocation if this map is not needed.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Niklas Cassel <cassel@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ata/libata-scsi.c | 1 +
 include/scsi/scsi_host.h  | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 026122bb6f2f..66f69116de60 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4499,6 +4499,7 @@ int ata_scsi_add_hosts(struct ata_host *host, const=
 struct scsi_host_template *s
 		shost->max_lun =3D 1;
 		shost->max_channel =3D 1;
 		shost->max_cmd_len =3D 32;
+		shost->needs_budget_token =3D true;
=20
 		/* Schedule policy is determined by ->qc_defer()
 		 * callback and it needs to see every deferred qc.
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index e87cf7eadd26..2b3fc8dcbf0b 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -695,6 +695,9 @@ struct Scsi_Host {
 	/* The transport requires the LUN bits NOT to be stored in CDB[1] */
 	unsigned no_scsi2_lun_in_cdb:1;
=20
+	/* Whether the LLD uses cmd->budget_token */
+	unsigned needs_budget_token:1;
+
 	/*
 	 * Optional work queue to be utilized by the transport
 	 */
