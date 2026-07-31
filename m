Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55713330307
	for <linux-scsi@vger.kernel.org>; Fri, 31 Jul 2026 21:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785534793; cv=none; b=OewNig0GjJi4sxdp0E1BW/P67lJIcMoRhV6gw+uwvg1pYf1aCKv29WT2KhCwXJTC9fOWe6hFvP51In256c9xYAupkKFD5WH0rLZ80YdZuHngOQLZa8DahInVxyRBfhYbCKYGbaKLKgEjQQ/MKUQsuL4yD4YZTNOxJtI3pTCI28s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785534793; c=relaxed/simple;
	bh=hAwBmDjVio3brGCPC2rLlCv3/VZAtvtTyusu8+6Dfoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PfDY8S3AZ7aTfNzg+x1dSo4CDRQzj/cEdH7YprUh6wTQmG5rH3+eREXODvdG4Nt0VS+szMK8GiX6SmxVk5RTe9LjMf3Yx1xgEUjWIZhBtH5RHfEuoHKoGoq02MRVpnVWpsKJoHn/HM4G78/URqNDM9FdOAdwwJLLhoUEgqKMLRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=f8o6rRPK; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="f8o6rRPK"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hBfvW5ylKzlfvq2;
	Fri, 31 Jul 2026 21:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785534788; x=1788126789; bh=DlHQo
	ymSOWSbcBs0Nc1Q6H61t824/g96El4RSLTbR4Q=; b=f8o6rRPKhsNRV7gonDM1h
	DIX/u1WvIh+Jkzcxqg+04TJvUxGkiKRAVQ+ued3wVuIYf1MntL38oEy9p7UGJFhe
	f+dBtK5Cv9MRLKaJrIaKD+ZkNPE0BtrQ6fnCgxwplK0alQneJuk/Mh7EXdTEdxft
	8ovXaQx9NyLgV40KSYfiST2G15l4u0Pl+hVMAsss2gR1IoWUYHZixl5c2A47nYDF
	eBFMdaTlGKKRNl0KQ3EaPxx5GA5tIjHOPn8VjlImXminnLYuvJ6R9VbYvvN2wc+D
	pyaA43q3GkSAO+koTf/TbCVEqOYNEjOfL63BSLu3KBu+r2nTuMjYIYBnf39+4uNp
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id H_sRapTr7nMY; Fri, 31 Jul 2026 21:53:08 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hBfvR19xYzlfpMK;
	Fri, 31 Jul 2026 21:53:06 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v4 6/6] scsi: core: Enable lock context analysis
Date: Fri, 31 Jul 2026 14:52:11 -0700
Message-ID: <377b28286cab215eea4e6f0f35ba5a9c4eff3455.1785534722.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <68f3346cab2be570839350831f82b6c9233832ed.1785534721.git.bvanassche@acm.org>
References: <68f3346cab2be570839350831f82b6c9233832ed.1785534721.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Enable lock context analysis for those SCSI core files that build
without triggering any compiler warnings.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/Makefile                | 22 ++++++++++++++++++++++
 drivers/scsi/device_handler/Makefile |  3 +++
 2 files changed, 25 insertions(+)

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 842c254bb226..69ea80819f3b 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -14,6 +14,28 @@
 # satisfy certain initialization assumptions in the SCSI layer.
 # *!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
=20
+CONTEXT_ANALYSIS_constants.o :=3D y
+CONTEXT_ANALYSIS_scsi.o :=3D y
+CONTEXT_ANALYSIS_scsicam.o :=3D y
+CONTEXT_ANALYSIS_common.o :=3D y
+CONTEXT_ANALYSIS_devinfo.o :=3D y
+CONTEXT_ANALYSIS_dh.o :=3D y
+CONTEXT_ANALYSIS_ioctl.o :=3D y
+CONTEXT_ANALYSIS_lib.o :=3D y
+CONTEXT_ANALYSIS_lib_dma.o :=3D y
+CONTEXT_ANALYSIS_error.o :=3D y
+CONTEXT_ANALYSIS_logging.o :=3D y
+CONTEXT_ANALYSIS_netlink.o :=3D y
+CONTEXT_ANALYSIS_pm.o :=3D y
+CONTEXT_ANALYSIS_scan.o :=3D y
+CONTEXT_ANALYSIS_sysfs.o :=3D y
+CONTEXT_ANALYSIS_trace.o :=3D y
+CONTEXT_ANALYSIS_sd.o :=3D y
+CONTEXT_ANALYSIS_sd_dif.o :=3D y
+CONTEXT_ANALYSIS_sd_zbc.o :=3D y
+CONTEXT_ANALYSIS_sr.o :=3D y
+CONTEXT_ANALYSIS_sr_ioctl.o :=3D y
+CONTEXT_ANALYSIS_proc.o :=3D y
=20
 CFLAGS_aha152x.o =3D   -DAHA152X_STAT -DAUTOCONF
=20
diff --git a/drivers/scsi/device_handler/Makefile b/drivers/scsi/device_h=
andler/Makefile
index 0a603aefd2bb..5aa282a63e24 100644
--- a/drivers/scsi/device_handler/Makefile
+++ b/drivers/scsi/device_handler/Makefile
@@ -2,6 +2,9 @@
 #
 # SCSI Device Handler
 #
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_SCSI_DH_RDAC)	+=3D scsi_dh_rdac.o
 obj-$(CONFIG_SCSI_DH_HP_SW)	+=3D scsi_dh_hp_sw.o
 obj-$(CONFIG_SCSI_DH_EMC)	+=3D scsi_dh_emc.o
