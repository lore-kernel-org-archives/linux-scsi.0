Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21431860
	for <linux-scsi@vger.kernel.org>; Mon,  8 Apr 2024 02:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712544873; cv=none; b=P1Se/7bvvP5hjuQzQmFl4zCvH2QBm6iFkWDwP2QTnRJv9yOuvs4s5iCY3W1JbmefB6IAucfrYNpCMH9+Di3BAVcvmyAGGG0ZpebQV5f20QS56I5w6iVhz8Wd+Y2MAtiodB1WVFe8jftfXA5vg3QxYwhWMGTs4WWhjHBGS6kOkwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712544873; c=relaxed/simple;
	bh=fZ0ki1BC5nv0GPcsixNa0dxew2Ji6gEyUwdq1J6SUuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1QJf0MDdfXd5t9xN2aDqGD806q9R6304AYEfw+axlbooh1zxrQBdYw7n2JF1RjJ0JFOIJEiLBjO0A1PpP+Vz+Wy0H2I20Tt/4lClzr4shPY/5dzuI3vpg2qrfTFtFyEiE/2K1rEmxFaVLsETuNx4bdvo0/X4aVSJ3A5rxxwO10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=m//9W+Jb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m//9W+Jb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VM+0J8e+0hA4kWELiu8/dsyjlme/YSoD1PnAY52mqVw=; b=m//9W+Jbl79oWI305kgQOUTq0P
	ghQg44oNbc5sXoSfoWUjEWyuSOEYOunxB4zdeoWDsG/Dr+ODBy9nMY/L4e6TrnUMo1bjXiNph21oc
	DUhJ6LM2emD3g1O8hFDuoIWaIANtF72q2GQx25uJRaYIydh8GVFG+dFZw3HZboly7XoQ8hF7JCMh4
	C1UZ3d9oJtoHMqBz47Kw7HGpjO2Pf6ydtXlBq8w2vo5DDERZELTlCkgp0gOaTmXHpxtxgBTXDcsdM
	JR9wFPgc8RXpbXXGmM3iQkISFJUSLYmXqxfW0fIFH4+oEOgsEsYwe89MpCy1cSIRYlPnNeEWAVEeS
	wuDu1ywQ==;
Received: from [50.53.2.121] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rtf9T-0000000E7aj-0lHZ;
	Mon, 08 Apr 2024 02:54:31 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 8/8] scsi: scsi_transport_srp: fix a couple of kernel-doc warnings
Date: Sun,  7 Apr 2024 19:54:25 -0700
Message-ID: <20240408025425.18778-9-rdunlap@infradead.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408025425.18778-1-rdunlap@infradead.org>
References: <20240408025425.18778-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a struct short description and a function return value to prevent
kernel-doc warnings:

scsi_transport_srp.h:77: warning: missing initial short description on line:
 * struct srp_function_template
scsi_transport_srp.h:132: warning: No description found for return value of 'srp_chkready'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>

 include/scsi/scsi_transport_srp.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -- a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
--- a/include/scsi/scsi_transport_srp.h
+++ b/include/scsi/scsi_transport_srp.h
@@ -74,7 +74,7 @@ struct srp_rport {
 };
 
 /**
- * struct srp_function_template
+ * struct srp_function_template - template for SRP initiator drivers
  *
  * Fields that are only relevant for SRP initiator drivers:
  * @has_rport_state: Whether or not to create the state, fast_io_fail_tmo and
@@ -124,7 +124,7 @@ enum scsi_timeout_action srp_timed_out(s
  * srp_chkready() - evaluate the transport layer state before I/O
  * @rport: SRP target port pointer.
  *
- * Returns a SCSI result code that can be returned by the LLD queuecommand()
+ * Returns: a SCSI result code that can be returned by the LLD queuecommand()
  * implementation. The role of this function is similar to that of
  * fc_remote_port_chkready().
  */
