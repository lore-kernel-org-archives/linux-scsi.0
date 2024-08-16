Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6601C68A3
	for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2024 21:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723845420; cv=none; b=bBS22QLfSz1oTF7PzKuVD3RILgdbWlNG3pndDJ5nM5XQy9stoq2Vjr5lzoi4I57J+rW6RcDIpR5i1APINULbB2f+8W+3TaIT7pi1MfDKPSWRVSyfnBnv58fcgVO5JDrKQwn1npU//9iTqbr1X3w7TMUOY/csFcKEIVLVXlL5Vnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723845420; c=relaxed/simple;
	bh=k4PBo4mfMMz3UI4rzFpdLw+5lUCMAfBrhHnCxrDX7t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLhSuVnPu0yAxUo7RRUpPN0CE/klO0pxVAObDDf5dm+mDdZ8zS7jPVy8lPCsY+eEkksv1Tpu2G4qDyFbRMTj85L/8pnUQUBGGxVYj2wnZzLaoE84Vjra0V2YlnfWJa+264rct4sxcC2RxDI8BCOA+9TVDc+hIyBrq99vHjMVE3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=zUS4eN22; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="zUS4eN22"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WlwnQ2QHgz6ClY9G;
	Fri, 16 Aug 2024 21:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1723845414; x=1726437415; bh=lxlYv
	6PbXemYJd0JwWkkY873WX0sYrHCusWF34TE2Hw=; b=zUS4eN22gmdwSQxxR/Eqm
	xQYDNPRC31HORV5cSIHDz3Bu0rJimousrccpkRjyw2ZZ17B1c1gsElgmnZblCu76
	6oEzTT/RkFcxJUl/dASQAm5vOzmad2CpC94YfmpwHrFtViLVdPOyR/cYDq2eEPA5
	hhhUFb75roz47sDt1s+C6PrMaJ5fRtYoasXoqIbiKUAU/RH7bUMqzQimieX2VyMP
	YYGoAUoP+SF1wzpa/Eoq3TcOpzWwx6zvyniatlOjWPav9IPz62X1G1omu8mjqZPe
	pokoBBIMV7O9uboClPQGF+inBcVB2ZMKMsnKtBNpfA8YS1nG1XpQbPxLGQM5N1IJ
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xQ3Vfjg_U7lM; Fri, 16 Aug 2024 21:56:54 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WlwnK0gHmz6ClY98;
	Fri, 16 Aug 2024 21:56:52 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 09/18] scsi: mpt3sas: Simplify an alloc_ordered_workqueue() invocation
Date: Fri, 16 Aug 2024 14:55:32 -0700
Message-ID: <20240816215605.36240-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
In-Reply-To: <20240816215605.36240-1-bvanassche@acm.org>
References: <20240816215605.36240-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Let alloc_ordered_workqueue() format the workqueue name instead of callin=
g
snprintf() explicitly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  | 4 +---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/m=
pt3sas_base.h
index fe1e96fda284..eceb5eeb4651 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1162,8 +1162,7 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct M=
PT3SAS_ADAPTER *ioc);
  * @fault_reset_work_q_name: fw fault work queue
  * @fault_reset_work_q: ""
  * @fault_reset_work: ""
- * @firmware_event_name: fw event work queue
- * @firmware_event_thread: ""
+ * @firmware_event_thread: fw event work queue
  * @fw_event_lock:
  * @fw_event_list: list of fw events
  * @current_evet: current processing firmware event
@@ -1351,7 +1350,6 @@ struct MPT3SAS_ADAPTER {
 	struct delayed_work fault_reset_work;
=20
 	/* fw event handler */
-	char		firmware_event_name[20];
 	struct workqueue_struct	*firmware_event_thread;
 	spinlock_t	fw_event_lock;
 	struct list_head fw_event_list;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
index 97c2472cd434..728cced42b0e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -12301,10 +12301,8 @@ _scsih_probe(struct pci_dev *pdev, const struct =
pci_device_id *id)
 	scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
=20
 	/* event thread */
-	snprintf(ioc->firmware_event_name, sizeof(ioc->firmware_event_name),
-	    "fw_event_%s%d", ioc->driver_name, ioc->id);
 	ioc->firmware_event_thread =3D alloc_ordered_workqueue(
-	    ioc->firmware_event_name, 0);
+		"fw_event_%s%d", 0, ioc->driver_name, ioc->id);
 	if (!ioc->firmware_event_thread) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
 			__FILE__, __LINE__, __func__);
