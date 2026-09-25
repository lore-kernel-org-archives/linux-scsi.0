Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A654CE662
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790359799; cv=none; b=RPUrTB+bO/1TBMOBCWR+BjI0gHFM6H0er7b8uJh5JsvuUL8o92/wp0lCqFO3nWdYDl1cEPTKLMmit7ClKGmidZwlyne5iivLKeoHjz/uf2b6w/Khd1+IRvTRblWCz/QDS/TcjKJPEHhXTZYA4M7DshyPJlCK88fjLuZ/jFajGYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790359799; c=relaxed/simple;
	bh=I/JvsQ7AsJGPAZ85yrcK0FOXCvmkEDcoby36xD1ucFw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gm+il92Wec4xF4gjKtgFmY7Nui6l5JJKLQL9VVUKmDfb7Jrwvjky/n7BtIvlnw6PJia3uNlREIocstbpKGA+rhma5ZCQBpt/zTlnbSw8yrfIQviwsDgdlPSewHmZ1jK0dR0FxAGJHp1R/cMrTildc7yBBP6TA3gUDM+zcxvlhks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HMkKOj6+; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HMkKOj6+"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hrzJ54dFWzlfvpK;
	Fri, 25 Sep 2026 18:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1790359794; x=1792951795; bh=EPPZhk27wwUpJNS2rT4JYPeo5OBfPc3XwRg
	16BzGEQg=; b=HMkKOj6+TG5C/PsuNOwazdy4GJ20yir+KbnJ8/PNZJuStajfsXe
	3PqL6DasLlYLmNHtyzDYDlqegJCENojE5OFT0GWkViFdQyymJkQLVEAWeWPqIjC2
	bhWsGEZn1jvuITVCVWcHsN/7MkOf2wZWVEScHW6TeR6h8pHKSsjybxiJnUu60QPZ
	OelYc7DBQj4jrtHsEGGltIW+GomjvH12XzfJJoGXVuzFXuf1usYj6NGA5NVgOUXG
	Zx98xUUWZxVEGSuPMlsatxeLAmDZ2vMV2tpNh3JMcZRHFQfscvcqXKN/dRpV3c4o
	upU7xYnogLu+DJEbVewhW9NzCUT+j159xdQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3eeLeXK334Cq; Fri, 25 Sep 2026 18:09:54 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzJ05d9XzlfvpG;
	Fri, 25 Sep 2026 18:09:52 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.garry@linux.dev>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH] scsi: core: Micro-optimize the hot path
Date: Fri, 25 Sep 2026 11:09:45 -0700
Message-ID: <1ac0d4d0c06e55943e188d0dee9b6f2475715f21.1790359761.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Every code path that inserts scmd->eh_entry into a list uses
list_add_tail() (see also scsi_abort_command() and scsi_eh_scmd_add()).
list_add_tail() overwrites the next and prev pointers. Hence, the only
code that depends on the initialization of scmd->eh_entry is the
BUG_ON(!list_empty(&scmd->eh_entry)) statement in scsi_abort_command().
Remove this statement because scsi_timeout() already prevents
scsi_abort_command() from being called twice for the same command by
setting SCMD_STATE_COMPLETE. Remove the scmd->eh_entry initialization
because the only statement that relied on this initialization has been
removed.

Cc: John Garry <john.garry@linux.dev>
Cc: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 1 -
 drivers/scsi/scsi_lib.c   | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 2e0b1909dc69..75442d60c30e 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -270,7 +270,6 @@ scsi_abort_command(struct scsi_cmnd *scmd)
 	spin_lock_irqsave(&shost->host_lock, flags);
 	if (shost->eh_deadline !=3D -1 && !shost->last_reset)
 		shost->last_reset =3D jiffies;
-	BUG_ON(!list_empty(&scmd->eh_entry));
 	list_add_tail(&scmd->eh_entry, &shost->eh_abort_list);
 	spin_unlock_irqrestore(&shost->host_lock, flags);
=20
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index db64470f5229..f695a6605815 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1322,7 +1322,6 @@ void scsi_init_command(struct scsi_device *dev, str=
uct scsi_cmnd *cmd)
 	}
=20
 	cmd->device =3D dev;
-	INIT_LIST_HEAD(&cmd->eh_entry);
 	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
 }
=20
@@ -1590,8 +1589,6 @@ static void scsi_complete(struct request *rq)
 		return;
 	}
=20
-	INIT_LIST_HEAD(&cmd->eh_entry);
-
 	atomic_inc(&cmd->device->iodone_cnt);
 	if (cmd->result)
 		atomic_inc(&cmd->device->ioerr_cnt);
