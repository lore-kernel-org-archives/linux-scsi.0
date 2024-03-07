Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D4F250F3
	for <linux-scsi@vger.kernel.org>; Thu,  7 Mar 2024 20:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709843434; cv=none; b=W27Hv8lPv9h+NGsVtNkiNBSWr1PACkCp1/fYIGCbvO9EgAa65RtGDPxOpZIF++60DeAlMgB2cBgVVsvoqxY5dlaJYMFKixMjKem1piHj9K0vdLeJpkd1dp2SeQTCfy03cGW+iw6fzNxlpKg87hWloEqtjcOcQ0qhPraHec6ZIzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709843434; c=relaxed/simple;
	bh=/2m8wr9YvPcJSlWHZo+onNTgwmYZZu9JhsJGrliXHYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVrbsYVtD6+MOOSQKdfAMy+4tagCcJ3Xm2infRR6sDCi+xowIqD0txE7YhA/wqFjVOtUyEzRSltE8YZ/GXBQ0MGD5VNFqFYW1yW2Wnb/SlCPxh/Cu8B47NO/JsJOOvVaxCUaP61PR1ZgHd8nwrRX8uBNAxvyUrtfO398oHZtJT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BH54EGNl; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BH54EGNl"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4TrLXL3w1dz6Cl2L3;
	Thu,  7 Mar 2024 20:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1709843423; x=1712435424; bh=X3E+n
	8HHe9caA1cPu+Og+soXkjBXYjYRGlbBOsvEcdY=; b=BH54EGNlQ+YiO+3/R6cBr
	9lM3IJpQ/070lxuyeSTpntF3b22k6JclcO3zpuFkrWYS2m3KsNRFpcE0hEq1qUjS
	8kBBGvCVkYjIAqmSO2Sn0X3+Ey6FKXMxe3lteE+pPhZgOzNC8N1HeVTiMW4Mcfjw
	7atS7+jGf8ESC2gcFjV9W5xndR/vcwiE++XEI+Udn9dAPTQ3aRXCcqhA49WhCjj7
	T3QN7faAg26w2aLa8Rx7WQbqfbaE/ECSsJP4dc6nTpOtfSB58SQoP/sJwhD3yTrO
	IPqsgCzUTisiD/aquJebzipEykoHKuZ9PyRvGS8Pll44H3hqRH6vQs1/tdJm8cXW
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id AgWYMpEiU0aH; Thu,  7 Mar 2024 20:30:23 +0000 (UTC)
Received: from bvanassche-linux.mtv.corp.google.com (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4TrLXF64l4z6Cl43n;
	Thu,  7 Mar 2024 20:30:21 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Douglas Gilbert <dgilbert@interlog.com>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 1/4] scsi: scsi_debug: Remove a reference to in_use_bm
Date: Thu,  7 Mar 2024 12:30:04 -0800
Message-ID: <20240307203015.870254-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
In-Reply-To: <20240307203015.870254-1-bvanassche@acm.org>
References: <20240307203015.870254-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Commit f1437cd1e535 ("scsi: scsi_debug: Drop sdebug_queue") removed
the 'in_use_bm' struct member. Hence remove a reference to that struct
member from the procfs host info file.

Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: John Garry <john.g.garry@oracle.com>
Fixes: f1437cd1e535 ("scsi: scsi_debug: Drop sdebug_queue")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index acf0592d63da..36368c71221b 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6516,7 +6516,7 @@ static int scsi_debug_show_info(struct seq_file *m,=
 struct Scsi_Host *host)
 		blk_mq_tagset_busy_iter(&host->tag_set, sdebug_submit_queue_iter,
 					&data);
 		if (f >=3D 0) {
-			seq_printf(m, "    in_use_bm BUSY: %s: %d,%d\n",
+			seq_printf(m, "    BUSY: %s: %d,%d\n",
 				   "first,last bits", f, l);
 		}
 	}
