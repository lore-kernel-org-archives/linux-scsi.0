Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793709125;
	b=Jumz0UvQaF6feKOSBztTSwehFxHUjRpTJczuXDX0oYoFSV4KZj5+IfZRs80pSoN1jFTF
	 czx5mlVw5aObLU3zVJqdoC2tkrqXoU19Mdx7FkDqHg0pfUNyAdzWuWOXTn1/Cm+KydmcG
	 tz3UOtyIap6UUBVy15gy1CjMonYi5YKIvX9CcYFoy2+I6Gv4xNKNQxTWFIN3HWSGHMu5v
	 omGIIWwL8jiuv85Ljfeam79Zrvo5BNDf37OFZX+FAKRMTC//Erhe4d5cXCV6jzLa6wjz/
	 v+/rBO+s5CVfj4kw7CT4/aEjtBLh5J3MB+pVSY1+z9WZFXbetU/khDi6FTRHyGF+6Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793709125;
	h=DMARC-Filter:Received:Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Rspamd-Pre-Result:
	 X-Rspamd-Queue-Id:X-Rspamd-Pre-Result:X-Rspamd-Action:X-Rspamd-Server:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Flag:X-Spam-Score;
	bh=y9oPlbaqiVwfF0b969Ap4UdNuk7IlxFkpNXXr1LJOqw=;
	b=r1HVg6nMnVVKvpNl12hDLw6yqtpq470aK3/vdyMAn0hE312aLMn82bFdEGXUUAMmcemF
	 kyynok1zsmVYocaUD46gJ8OfEi/fdMJhZiK4Va/2repnhpRZB9rL3IcCCXR7MB3C4Dh6j
	 HGYE2MhCKPvW0daOhb1SzLUY1qBiIc5eqczQS15SjnqlzvJd0Ey90rkW3yuPm2n/BAfUH
	 fWG4AcAUo3IhDWYAOpm0pMrpTmkYwz+iAW/da7q2PR+ebmoDxjvPgmWo3euWIGcCH2S0j
	 U5sUpDzpNA8e/LqJeFP8ETY1qrnRwbyJ88Bfb+s3VxmLQ12OrhblURzKrrqa0T16pHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACFF606A327;
	Tue,  3 Nov 2026 12:32:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9ACFF606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1CC1A20499;
	Tue,  3 Nov 2026 12:32:03 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CE441134B8;
	Tue,  3 Nov 2026 12:32:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id l645KULU6WpWBQAAD6G6ig
	(envelope-from <dwagner@suse.de>); Tue, 03 Nov 2026 12:32:02 +0000
From: Daniel Wagner <dwagner@suse.de>
Date: Tue, 03 Nov 2026 13:31:39 +0100
Subject: [PATCH v2 4/7] scsi: qla2xxx: target: Fix cmd release on CDB
 allocation failure
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
Message-Id: <20261103-qla2xxx-fix-v2-4-c6d2cdf2c806@suse.de>
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
X-Rspamd-Queue-Id: 1CC1A20499
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

If the extra CDB buffer cannot be allocated, qlt_get_tag() releases
the command with tgt_ops->free_cmd(). For tcm_qla2xxx that queues
transport_generic_free_cmd() on a se_cmd that was never initialized
by the target core: its cmd_kref is zero, so the put underflows the
refcount and the command is never released. The session tag is
leaked, and so is the num_pend_cmds increment done earlier in
qlt_get_tag(). Once enough commands have leaked, every new command is
answered with BUSY.

Undo exactly what qlt_get_tag() has done so far, the same way the
qlt_do_work() error path handles a command that never reached the
target core: drop num_pend_cmds and return the tag with rel_cmd().

Fixes: 091719c21d5a ("scsi: qla2xxx: target: Fix invalid memory access with big CDBs")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/qla2xxx/qla_target.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 431a59d499b3..939b5e9f8471 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4660,7 +4660,8 @@ static struct qla_tgt_cmd *qlt_get_tag(scsi_qla_host_t *vha,
 
 		cdb = kmalloc(cdb_len, GFP_ATOMIC);
 		if (unlikely(!cdb)) {
-			vha->hw->tgt.tgt_ops->free_cmd(cmd);
+			qlt_decr_num_pend_cmds(vha);
+			vha->hw->tgt.tgt_ops->rel_cmd(cmd);
 			return NULL;
 		}
 		/* CAUTION: copy CDB from atio not cmd->atio */

-- 
2.56.0

