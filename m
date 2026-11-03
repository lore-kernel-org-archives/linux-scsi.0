Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793709122;
	b=AYuqU/RliDQRLJsmLttrg4t7215tol7aa4qthB6/nIrY/6jqP89VkROh9abWl58sMe9t
	 bV5f3Dg7zsFpB0T3bQ3Yn36nyoIkdOUe31abLtQDJj6whD/hqXSePDj/fzm8qC400bdCr
	 SzUWa7idPyGEBM/nl07ScJXPJWhSjDZb0OjlbsMfw++JT0mFOk9eyC+XZWK/+n14VMO3Q
	 A+pEtgKKFNSMDde56aLcv9+PH2gX/LS7kfJsKXNzWLtIjVm40BBIsjV8kQkovM8H1P9zL
	 OSzN5x99qZ716NKv7Gsw76HfwWV7j5XbGN78aqUHnu0tG8q2d/STzagp4EiQqxJfvFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793709122;
	h=DMARC-Filter:Received:Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Rspamd-Pre-Result:
	 X-Rspamd-Queue-Id:X-Rspamd-Pre-Result:X-Rspamd-Action:X-Rspamd-Server:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Flag:X-Spam-Score;
	bh=dBUogHeFwnnONvT8C8tb5RaJc7kBvLE4N3DHSryneR0=;
	b=OSI04FQur7uJlMO+cu7R1EQs3HTwqyGAdn5qZKSIdUHfxsaEv2opX6GYRsa0i9e2LWv1
	 p0k16VaTNegWqWiRbnjtMUY8Y/JrYuzxSmbDR4Z37f7Q2O+lGAOvUwP1WX9X8qwGMS0zb
	 yn/Y1mrVidc/jkXE3yJ+igaLWF8Qt2GUIH2uGvr9UpPc7SrcbJt4jAWRec5Q/k9LZeWCw
	 sqYF7J49WzlR5k2nZ3jfsrVPpez14I/qi+kY+TNI0Bo3GxIUI6y0SYlf1fh9LjdXATGC4
	 wWjQ0ZkeYApz3/9F+VOpnlV5SdDcai1PQbMkwZUx4ON/SIRnvx1Kth+1wvZ0Jgymr1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD07B606D809;
	Tue,  3 Nov 2026 12:32:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD07B606D809
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 51B4A22694;
	Tue,  3 Nov 2026 12:32:00 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EA98E134B8;
	Tue,  3 Nov 2026 12:31:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oIIQMD/U6WpOBQAAD6G6ig
	(envelope-from <dwagner@suse.de>); Tue, 03 Nov 2026 12:31:59 +0000
From: Daniel Wagner <dwagner@suse.de>
Date: Tue, 03 Nov 2026 13:31:37 +0100
Subject: [PATCH v2 2/7] scsi: qla2xxx: Don't clear SF_SCANNING of a running
 fabric scan
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-qla2xxx-fix-v2-2-c6d2cdf2c806@suse.de>
References: <20261103-qla2xxx-fix-v2-0-c6d2cdf2c806@suse.de>
In-Reply-To: <20261103-qla2xxx-fix-v2-0-c6d2cdf2c806@suse.de>
To: Nilesh Javali <njavali@marvell.com>, 
 GR-QLogic-Storage-Upstream@marvell.com, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Himanshu Madhani <himanshu.madhani@oracle.com>, 
 Quinn Tran <qutran@marvell.com>
Cc: linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: 51B4A22694
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00

Commit 7adbd2b78090 ("scsi: qla2xxx: Free sp in error path to fix
system crash") changed the "scan active" early exit in
qla_fab_async_scan() from a plain return to a jump to done_free_sp.
Besides freeing sp, that label also clears SF_SCANNING and, if no other
scan flag is set, queues scan_work again. Both belong to the scan that
is still in flight, not to the caller that bailed out:

  - SF_SCANNING is dropped while the GPN_FT/GNN_FT command is still
    outstanding, so the next qla_fab_async_scan() call starts a second
    scan that resets vha->scan.step and clears vha->scan.l under the
    running one.
  - qla2x00_wait_for_hba_ready() stops waiting for the scan.

This also happens for sp == NULL, e.g. when the DPC thread calls
qla_fab_scan_start() during a running scan.

Only release the sp handed in and leave the scan state alone.

Fixes: 7adbd2b78090 ("scsi: qla2xxx: Free sp in error path to fix system crash")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/qla2xxx/qla_gs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 20b1aef455c4..d5ea22f01772 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3621,7 +3621,9 @@ int qla_fab_async_scan(scsi_qla_host_t *vha, srb_t *sp)
 		spin_unlock_irqrestore(&vha->work_lock, flags);
 		ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0x2012,
 		    "%s: scan active for sp:%p\n", __func__, sp);
-		goto done_free_sp;
+		if (sp)
+			qla24xx_sp_unmap(vha, sp);
+		return rval;
 	}
 	vha->scan.scan_flags |= SF_SCANNING;
 	if (!sp)

-- 
2.56.0

