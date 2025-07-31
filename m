Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678C42C9A
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2025 11:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753961603; cv=none; b=WURXMcvtDriSIgcROJuDgQpGxaTDsKhVf33bGoUGS0QISJQ592LbIMWIIZG7RFZAPuTT2KWWi1tbTeyYMPpYhqDUiP78LJB7MqltEn9xXC8vOXviSlLRgHg0ylBbwIyD95WsnUgnj0ZnIG7LfenLg5adxeiLKiRMzWoF2j+TUe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753961603; c=relaxed/simple;
	bh=g3TkOqEUdhM1Xe1A8vnvnXNQBwm1iUoPYCFQf2FKwEw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=OXDwfNovHY5EQvFLwwiCkw/UT0x+xAf/QlzknvxszF2kQBHEb5jsjAGpbW8OtUnlDzauWa3ibcQcTPFORjHcrpYnebfZY/476FHiI42F90tBl7zT46qBtMGcAjh1JbVtF/FMx+SHwZ3P3uJM016RdhH1o7xd2i1QRXVb9duPAa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=g/Fc1qAt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ybpRAbVe; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=g/Fc1qAt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ybpRAbVe; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="g/Fc1qAt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ybpRAbVe";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="g/Fc1qAt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ybpRAbVe"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7113421197;
	Thu, 31 Jul 2025 11:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753961594; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XgIYys/l/TmjNRph/+0+wqV0Ch8g097vPIK0jopUOqo=;
	b=g/Fc1qAtOvUTTGFMj61yxfAkEQ41w/KSAkUk99ljPg1t+EfJnglJ3hn8b0PiaSNdw//DXZ
	FiaG+YBMnIgXsqUabIyQvYQs90qnB3vagA2CFU1b/Q/qMr0NtSiXjVZ3n3qv//0XvugY7O
	KDhY5ZegHtR78BeXsitKsBMgjPC+gGE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753961594;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XgIYys/l/TmjNRph/+0+wqV0Ch8g097vPIK0jopUOqo=;
	b=ybpRAbVeUCkXZPH313A8I6L6Nk5uqMoz1CQGXlUpWuDy+RbMQV1YzUHOsq80A8MZg7Luf+
	8JdlODa07+vytiBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753961594; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XgIYys/l/TmjNRph/+0+wqV0Ch8g097vPIK0jopUOqo=;
	b=g/Fc1qAtOvUTTGFMj61yxfAkEQ41w/KSAkUk99ljPg1t+EfJnglJ3hn8b0PiaSNdw//DXZ
	FiaG+YBMnIgXsqUabIyQvYQs90qnB3vagA2CFU1b/Q/qMr0NtSiXjVZ3n3qv//0XvugY7O
	KDhY5ZegHtR78BeXsitKsBMgjPC+gGE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753961594;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XgIYys/l/TmjNRph/+0+wqV0Ch8g097vPIK0jopUOqo=;
	b=ybpRAbVeUCkXZPH313A8I6L6Nk5uqMoz1CQGXlUpWuDy+RbMQV1YzUHOsq80A8MZg7Luf+
	8JdlODa07+vytiBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2B19713A43;
	Thu, 31 Jul 2025 11:33:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YY2OCHpUi2h/RQAAD6G6ig
	(envelope-from <jdelvare@suse.de>); Thu, 31 Jul 2025 11:33:14 +0000
Date: Thu, 31 Jul 2025 13:33:11 +0200
From: Jean Delvare <jdelvare@suse.de>
To: linux-scsi@vger.kernel.org
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy
 <dick.kennedy@broadcom.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] scsi: lpfc: Fix wrong function reference in a comment
Message-ID: <20250731133311.52034cc4@endymion>
Organization: SUSE Linux
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.43; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -3.80

Function scsi_host_remove doesn't exist, the actual function name is
scsi_remove_host.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
---
 drivers/scsi/lpfc/lpfc_vport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-6.16.orig/drivers/scsi/lpfc/lpfc_vport.c
+++ linux-6.16/drivers/scsi/lpfc/lpfc_vport.c
@@ -666,7 +666,7 @@ lpfc_vport_delete(struct fc_vport *fc_vp
 	 * Take early refcount for outstanding I/O requests we schedule during
 	 * delete processing for unreg_vpi.  Always keep this before
 	 * scsi_remove_host() as we can no longer obtain a reference through
-	 * scsi_host_get() after scsi_host_remove as shost is set to SHOST_DEL.
+	 * scsi_host_get() after scsi_remove_host as shost is set to SHOST_DEL.
 	 */
 	if (!scsi_host_get(shost))
 		return VPORT_INVAL;


-- 
Jean Delvare
SUSE L3 Support
