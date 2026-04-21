Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F0138F949
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 20:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776802838; cv=none; b=NvVo5oEbM4ITSllBHCftfKDNH3XYncRNrGhsprHIL7CsUHJi0vZfZ7L+iEYMiDNt+9QbW47pd1NrdDefo+ExOIc/wOaSaUiQSkY2/I+1ZtEv0ZuQwKfpjBI242xupnIcpJ4JEmpJBs/1QXZBl3lHTLp7LN6EEcEsaFJHadR1d7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776802838; c=relaxed/simple;
	bh=EReWIRTFn2LmQKWt9AAKohQGH7YPYhWAvxY9Uz9lzbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OlYfgnw0y6qzfxnD7ZfIhWKpYcU81JIUXVZ73z3qii1pzNU54NuX5eQ5fzf9LVSgYsr6qC3YDLiXxQWv56nQpDy8ZKE/I3beD0qELadTk+Y8MkyNLWN5SczeCv2TlB9TlagvuMDmW8JzGzJ1OB8DmPKXn0oaynLw8xz1eZtp/fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DYkpfk8X; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DYkpfk8X"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43eada6d900so4609039f8f.0
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 13:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776802835; x=1777407635; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DKPieHHRSjf/0iyU/nLe6OZrNT7pD4LRnWmDZGQ/fgo=;
        b=DYkpfk8XOVkxXBh6EQBY7087kD66qEpkzPLGh9TjTSOgbuuqeW+SbZ+5JOEEs/TOKm
         pEehsmNWR6bxuhBjcrG7iU3Ju9VhlJGcA/mN+hcgTTc2ZUG+cEsxTh+zkHgD0OC+JbjE
         bGw/T61q4zw+kCPWoYtxZtw+puNk4Nhx/ZMlbBjE4J6zsRtidNp0jjfHhy4fgVfNlBUO
         oOwHkzJXqWdhxx2kmNMuATminAkg3KWg1pAGSq+SSj1NB/oEi8f4PhXL19wMlmn3ksww
         fvRBOX1BtxC/LhjwgdngK2KBwanCdz7c/BD9GPTM19BFLCR+EpZvWWJzHpgqo7I0Eey7
         IIBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776802835; x=1777407635;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DKPieHHRSjf/0iyU/nLe6OZrNT7pD4LRnWmDZGQ/fgo=;
        b=BDl/kc2eZ+eA0E/zDuqHy/TmDU4pLKJj1JDDtcMFUxUEwiUO2WJUyC55ZpD1ueLKiS
         kZaOUtcgwiKfmsZxHMYzr1yPn6DPijZu+ddsqk07byzTl00TunHy5tLH1uJBVB6YuU5b
         XJTfBqwidCOSjgmhXXxYSJaZWHSTvUy3c/fzh3J+aOOUXsyM3LUW4g3O1r73ib+A3DLx
         yAN+GECT8XfANW6JKQtKApOPljRL7UGs90JD/AdAOiGHEZ+EjgCkhX1WRwZOZioG5/P7
         biP0TydsxuNMAVzI9PA5fHs0H9yVdP/81oka2F+NzExchEQZUeiPn+CZOxUOHBcuduO+
         18aA==
X-Gm-Message-State: AOJu0Ywkp9oa1/gBAQoPsKTPUsqW7V4n4yHPhGqTt26yDlUY5ZKLk36A
	ibU4uXc+MSR6VGEsAf5LHs9ZomZHloo14++QATG6TgnkOwiVUNOCGdW5rAgHIeCxTbYyWCSjUA4
	4XnkBzfc=
X-Gm-Gg: AeBDievJhnub6PT7IjRbdfi5SiSljY1sV7NIlZ2+UHHmxoSmxXj0dUEtAfOsL4+t0pU
	DXLfV5Z2+Al0zrUuyDeRpp+hQxe2bl4eHqrbYrJsAQNTbFA3C2saIPggz7vZu4RTp3PBEqXCL50
	iwKY5cFB8D/QVrAFoGiL61FGXtrfR2rJiJxss1UqG7Xhi7/h5ekCkQgdMo2JM+zEu+hWKlUuFhw
	TWyEWzOJfAaNR6ZOTBKjUsC+xKyOIHXUNOHJ+GpFyyjwRsUC8PUNIKEKvjOONzJ0blQ2iYM92kd
	q5ifuf3/SAkukDMVl/oSrzmmsVgtJffyTF+1doaWkqF/u2TzM5jprQufj9qm7STE8zh2PD0X3Ka
	IAolRzpLdf9SYrukGYqLqLw3BKLrzp4tmJuMdRUzrtgg0nl8KFcBh1D5lATzdZhBHuSGB0PnR8b
	guoj2J5r+nYW958nJRgmCxinkbUPZUOIDcGiqWDfmq7TpQIqQ3N2XkHh3PKbjZxIA4yz5jj6VY0
	UiIOgOOIlQNcESLSspZ6osK
X-Received: by 2002:a05:6000:22c5:b0:43b:3d4f:e17a with SMTP id ffacd0b85a97d-43fe3e13f82mr29403797f8f.37.1776802835398;
        Tue, 21 Apr 2026 13:20:35 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-43fe4cb13a0sm39987640f8f.8.2026.04.21.13.20.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 13:20:35 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Don Brace <don.brace@microchip.com>
Cc: linux-scsi@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>,
	Lee Duncan <lduncan@suse.com>,
	Martin Wilck <mwilck@suse.com>,
	storagedev@microchip.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com,
	Yihang Li <liyihang9@h-partners.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 2/2] scsi: sas_user_scan: use scan_start if available
Date: Tue, 21 Apr 2026 22:20:18 +0200
Message-ID: <20260421202018.511388-3-mwilck@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260421202018.511388-1-mwilck@suse.com>
References: <20260421202018.511388-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle wildcard and
multi-channel scans"), a wildcard scan on a SAS host scans all channels.
This can cause excessive resource usage and even system freeze with
some controllers, e.g. smartpqi. smartpqi and other drivers provide
the scan_start() and scan_finished() methods to scan devices
efficiently. Instead of blindly scanning every device, use these
methods to do the wildcard scan when available. Use the existing
function do_scsi_scan_host() for this purpose, which therefore needs
to be exported.

Fixes: 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle wildcard and multi-channel scans")
Signed-off-by: Martin Wilck <mwilck@suse.com>
Cc: Don Brace <don.brace@microchip.com>
Cc: storagedev@microchip.com
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com
Cc: MPT-FusionLinux.pdl@broadcom.com
Cc: Yihang Li <liyihang9@h-partners.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
Cc: John Garry <john.g.garry@oracle.com>

----
This patch has been tested successfully with smartpqi, but it would
affect other drivers that provide scan_start(), and we don't have
hardware to test them all. Affected drivers are aic94xx, hisi_sas,
hpsa, isci, mpi3mr, mpt3sas, mvsas, pm8001, and smartpqi.
I cc'd the maintainers of these drivers above.
---
 drivers/scsi/scsi_scan.c          |  3 ++-
 drivers/scsi/scsi_transport_sas.c | 19 +++++++++++++++++++
 include/scsi/scsi_host.h          |  1 +
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 7b11bc7de0e3..05e0e50b6e42 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -2029,7 +2029,7 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
 	kfree(data);
 }
 
-static void do_scsi_scan_host(struct Scsi_Host *shost)
+void do_scsi_scan_host(struct Scsi_Host *shost)
 {
 	if (shost->hostt->scan_finished) {
 		unsigned long start = jiffies;
@@ -2043,6 +2043,7 @@ static void do_scsi_scan_host(struct Scsi_Host *shost)
 				SCAN_WILD_CARD, SCSI_SCAN_INITIAL);
 	}
 }
+EXPORT_SYMBOL(do_scsi_scan_host);
 
 static void do_scan_async(void *_data, async_cookie_t c)
 {
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 13412702188e..15600394dc31 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1702,6 +1702,20 @@ static void scan_channel_zero(struct Scsi_Host *shost, uint id, u64 lun)
 	}
 }
 
+/*
+ * For wildcard scans on hosts that provide a scan_start method,
+ * use that instead of blindly scanning everything.
+ */
+static int sas_user_scan_with_scan_start(struct Scsi_Host *shost)
+{
+	if (!shost->hostt->scan_finished || !shost->hostt->scan_start)
+		return 1;
+
+	/* scan_finished exists, thus do_scsi_scan_host() will use it  */
+	do_scsi_scan_host(shost);
+	return 0;
+}
+
 /*
  * SCSI scan helper
  */
@@ -1721,6 +1735,11 @@ static int sas_user_scan(struct Scsi_Host *shost, uint channel,
 		break;
 
 	case SCAN_WILD_CARD:
+
+		if (id == SCAN_WILD_CARD && lun == SCAN_WILD_CARD
+			&& !sas_user_scan_with_scan_start(shost))
+			return 0;
+
 		mutex_lock(&sas_host->lock);
 		scan_channel_zero(shost, id, lun);
 		mutex_unlock(&sas_host->lock);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index f6e12565a81d..9717559c5171 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -805,6 +805,7 @@ scsi_template_proc_dir(const struct scsi_host_template *sht);
 #else
 #define scsi_template_proc_dir(sht) NULL
 #endif
+extern void do_scsi_scan_host(struct Scsi_Host *shost);
 extern void scsi_scan_host(struct Scsi_Host *);
 extern int scsi_resume_device(struct scsi_device *sdev);
 extern int scsi_rescan_device(struct scsi_device *sdev);
-- 
2.53.0

