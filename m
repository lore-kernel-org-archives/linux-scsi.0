Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA423BB124;
	Mon,  8 Jun 2026 09:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780912553; cv=none; b=ULzObHvVq5gt1VBtbADTqAjWoiG6wolkK6DxLu8gQzz9VGCJ6args/dQcZQJjY9rrIIlgUe7jZE9/r1VZnLFUMgkoPXw/4+1xAT3/NQQZeQkWk4k1ndgBAw95nYG5tP77qg9U14z/hwv51NbfjG81F7WbOC6LEWWlCmN0CqZOwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780912553; c=relaxed/simple;
	bh=g6wSEvqw7XZMJ/p+06xBpO8PfFIh9dA9lwYu8bmhdTA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oU6J1tD4WuAJrqNWz3FghNLM/lGU/i6soHeALfVsJiHbJx3wrDawsnBHGIq6H3NrnBbwYYCZPeKYr0KUQfplpfVGxhTcF2vuApIlNZ1hWSFenLeonp1du2baN77oRqOgJWeFS/IHOV8nlWdAcSzi9qiVjTo2xNj80mEOavAwQDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=O48dDjz3; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="O48dDjz3"
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wWWht-00BrEB-Nm; Mon, 08 Jun 2026 11:55:45 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
	Subject:Cc:To:From; bh=FBan7cpFo4fTNH0k/59lx/WnOxklojwuWy7DsoNcmuc=; b=O48dDj
	z3/8asOyQ4y9tIqI69gSphRs/7AKLa8SbGw1vGIxBTa4R53j03L6iN8KKG7RJNudwfgczs6KqomUx
	9SyUnwvDsf9I3WIdnS/XxTXNqImrFk5zODoEQN7PKCV4QKNyjEIF3Tns/sq0TjhhArkfhP8aPjAIC
	WcOtelieaOJqv9rkv4jUybxuv3y8eC0ikHDNBASq5sAC6jQ0HT3YhcvBVfGXTS3VFZaftwwc9igMX
	YDZ9FI4xxsL6O12tJnsEqoLfpgMSxXRY5vJAj+LUC8Z3zFZrg0KvNDMochYF35C3oyNSc9SpZxJo6
	xBhL7h1tGV8unGVE0iHm/QFvxPBQ==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wWWhs-0003hM-R0; Mon, 08 Jun 2026 11:55:45 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1wWWhb-00Ag6G-1a;
	Mon, 08 Jun 2026 11:55:27 +0200
From: david.laight.linux@gmail.com
To: Kees Cook <kees@kernel.org>,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: Arnd Bergmann <arnd@kernel.org>,
	Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH next] drivers/scsi/bfa/bfa_fcs_lport: Use strscpy() to copy strings into arrays
Date: Mon,  8 Jun 2026 10:54:48 +0100
Message-Id: <20260608095523.2606-4-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Laight <david.laight.linux@gmail.com>

Replacing strcpy() with strscpy() ensures that overflow of the target
buffer cannot happen.

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
This is one of a group of patches that remove potentially unbounded
strcpy() calls.

They are mostly replaced by strscpy() or, when strlen() has just been
called, with memcpy() (usually including the '\0').

Calls with copy string literals into arrays are left unchanged.
They are safe and easily detected as such.

The changes were made by getting the compiler to detect the calls and
then fixing the code by hand.

Note that all the changes are only compile tested.

Some Makefiles were changed to allow files to contain strcpy().
As well as 'difficult to fix' files, this included 'show' functions
as they really need to use sysfs_emit() or seq_printf().

All the patches are being sent individually to avoid very long cc lists.
Apologies for the terse commit messages and likely unexpected tags.
(There are about 100 patches in total.)

 drivers/scsi/bfa/bfa_fcs_lport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 2df399c537c1..d8a73cc531c7 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -1086,7 +1086,7 @@ void
 bfa_fcs_lport_set_symname(struct bfa_fcs_lport_s *port,
 				char *symname)
 {
-	strcpy(port->port_cfg.sym_name.symname, symname);
+	strscpy(port->port_cfg.sym_name.symname, symname);
 
 	if (bfa_sm_cmp_state(port, bfa_fcs_lport_sm_online))
 		bfa_fcs_lport_ns_util_send_rspn_id(
-- 
2.39.5

