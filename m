Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089E324DCE6;
	Fri, 19 Sep 2025 12:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758284269; cv=none; b=iOx5RBBFyLlmLvPHKjwybFRIUy55DJV7ZWsHDuU31ezegSysIm6FbKadyPJr53ruOD4HDb5BGnM4A4vjPeJYX7hIcWqGeYjychOKCDD7Mx8ILdwZkL9dWpO862PhpamNuzO1IXiJOOjYFgYCImh1G8wdIiZUgWHyiuy660MOUZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758284269; c=relaxed/simple;
	bh=acum5vA1h8hlv/HmkYBnlzw3f4Rnyny5s1eA6qENy0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=JZ9zjJdLeKCIiEm+OVnR+EEvpAvVdYpEL94BwADrfve0tT+y3wQS00HF76tauYi0yDmuRIzmKrw29L/G4t9MUr9TTpsme3bunqBc32D+Vwqny4zsNRAnomDClCsj+haKK0Q8itKizJzagQYFa9FU6kiDUj/cTFwxl+WoIH+8uRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CUc3ya5F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CUc3ya5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F4EC4CEF0;
	Fri, 19 Sep 2025 12:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758284268;
	bh=acum5vA1h8hlv/HmkYBnlzw3f4Rnyny5s1eA6qENy0Y=;
	h=Date:From:To:Cc:Subject:From;
	b=CUc3ya5Fsze80m/mQcTGk3xd+C5xlwu9ryJZrkBoyCYgzj742uQJ8FYyNssK6Zq0Y
	 GOnFBUxzUldJMFU5+7quejVNAbrc7qadJ+QVRPhpHQw03HkJYPgMBvpSDm8cWdjgiP
	 e7Rjzr6ved5LQQBXSWs64VJ/NFye+NruHx//D9MMI/gMBeVTHDdHLKzFPTXFPf5tOJ
	 sxWIUnlMR6FEqiBrSALTup0AUl9CuefYYGkVDZ08ZSss2m3bNHz7aRhc7nOMAvT8hI
	 DV7K3KXHHJb85uAdZWCl2pySbwuMO+c5XQuHQ7F6hE+cziGPdnSlDcDOLwPouhDIAa
	 /obY+Bq60Yi6g==
Date: Fri, 19 Sep 2025 14:17:41 +0200
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Yihang Li <liyihang9@h-partners.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH][next] scsi: hisi_sas: Avoid a couple
 -Wflex-array-member-not-at-end warnings
Message-ID: <aM1J5UemZFgdso3F@kspp>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

-Wflex-array-member-not-at-end was introduced in GCC-14, and we are
getting ready to enable it, globally.

Move the conflicting declarations to the end of the corresponding
structures (and in a union). Notice that `struct ssp_command_iu`
is a flexible structure, this is a structure that contains a
flexible-array member.

With these changes fix the following warnings:

drivers/scsi/hisi_sas/hisi_sas.h:639:38: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
drivers/scsi/hisi_sas/hisi_sas.h:616:47: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 1323ed8aa717..55c638dd58b1 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -613,8 +613,8 @@ struct hisi_sas_command_table_ssp {
 	struct ssp_frame_hdr hdr;
 	union {
 		struct {
-			struct ssp_command_iu task;
 			u32 prot[PROT_BUF_SIZE];
+			struct ssp_command_iu task;
 		};
 		struct ssp_tmf_iu ssp_task;
 		struct xfer_rdy_iu xfer_rdy;
@@ -636,13 +636,17 @@ struct hisi_sas_status_buffer {
 
 struct hisi_sas_slot_buf_table {
 	struct hisi_sas_status_buffer status_buffer;
-	union hisi_sas_command_table command_header;
 	struct hisi_sas_sge_page sge_page;
+
+	/* Must be last --ends in a flexible-array member. */
+	union hisi_sas_command_table command_header;
 };
 
 struct hisi_sas_slot_dif_buf_table {
-	struct hisi_sas_slot_buf_table slot_buf;
 	struct hisi_sas_sge_dif_page sge_dif_page;
+
+	/* Must be last --ends in a flexible-array member. */
+	struct hisi_sas_slot_buf_table slot_buf;
 };
 
 extern struct scsi_transport_template *hisi_sas_stt;
-- 
2.43.0

