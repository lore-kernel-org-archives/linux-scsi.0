Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D09446E003;
	Tue, 11 Aug 2026 21:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786484404; cv=none; b=ZrZTHT0uaAsZkjEV8EY79zvsFtwO6ze6iv+gKxDhLjKiN+4pu6pP0piL0M9Zc7Gv9u8n3v+rz+tKIBYLdWz/t1cpCd/qtNhi8gLJiLb5GPqLIuwVza0ug/Hj0n1Nq3lCZlD9VkRXm9N5tm6vDu/OcpbkxBAM4ZgENU5c09FKhzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786484404; c=relaxed/simple;
	bh=vIE0vAS5hC8k+IS7OM8i2og1MguSCZYXRCq3Kg80fhI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=IF1/DDkHuwxGNFRXJFutfjNLww1NjxLRQwU4yGCjTZEz130pTpsRVWfuXX5rxUDkfQyBmEwFOh4Fg1PVyjUOckZXWXuOSEhta8aAzgJHHdrZO+8TlclQ5Gyeg5Zmia3ISc8owIrHyQ6LDwseA3jm8UwKUsM6VDEz9JuUNULYDRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NseR48iI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NseR48iI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147F41F000E9;
	Tue, 11 Aug 2026 21:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786484402;
	bh=0LrgNbSzPvVvkUXP/4ygDy5OGRqFGL39AOM31zICDKE=;
	h=From:Date:Subject:To:Cc;
	b=NseR48iIhGjrzjzzP0QHquUVJMsIHz56nlXD6bDrpWP1PROy9FdkNOYG4e7eDLfQk
	 EMJzLmV9GngC9u/yALlG9rHNbuPjZKQpfipVMuXCn2RqQMxnO5Zt2t2gG/f0TmXM1K
	 cMF+I07GkAUmCp/fEVQ5MKsp7Q+9kSR7E6ZWZ1Xcnt/fPuFs0f+8nZVQ2K/mEDGXVh
	 HPN5I+tIoB60Aze+tDonkksCZekL4nde+2Kqs9T7JtPqTV2bIVia/2c+L8ZF2AFuwZ
	 A6eSGZAjKugci+MHXjxWcyuZNYMgAwh+vOKck3LF0yYJeauKyNtO4ymhgMbgGu3snf
	 tJdw1wn8uG8Hg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 11 Aug 2026 14:39:51 -0700
Subject: [PATCH] scsi: qla2xxx: Fix size_t format specifier in
 qla29xx_process_rd_image()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260811-scsi-qla2xxxx-qla_init-wformat-v1-1-50760021914f@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWN0Q6CMAxFf4X02SZsKjH+ijGmlE5rdMg6lYTw7
 wy9T+e8nDuBSVIxOFYTJPmoaR+LuE0FfKN4FdSuOPjaN/XBOTQ2xeFBfixb4aJRM35Dn56Ukfc
 73245UBMISuSVJOj4Ozid/27v9i6c1yrM8wKLPqi3ggAAAA==
X-Change-ID: 20260811-scsi-qla2xxxx-qla_init-wformat-c542b3cfa6fa
To: Nilesh Javali <njavali@marvell.com>, 
 GR-QLogic-Storage-Upstream@marvell.com, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@kernel.org>, 
 Manish Rangankar <mrangankar@marvell.com>, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2476; i=nathan@kernel.org;
 h=from:subject:message-id; bh=vIE0vAS5hC8k+IS7OM8i2og1MguSCZYXRCq3Kg80fhI=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDFnV0zbM7E4XfugvoHr+jFSwgpThzgdH+ZeId5QIW7Z9E
 XON/2/fUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACbyfC7DP405v5l/WaXbysXX
 7LLrNp2zt9+sd8+vdwnhKqw862q/qDH8z2y+fXf917sf3oTpHHqU9eLrgz0LT7adKOJd/NjpQ/H
 PyawA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After commit c3930ec119cb ("scsi: qla2xxx: Add FC operational firmware
load for 29xx"), there is a warning due to an incorrect format specifier
for a 'size_t' variable when building for 32-bit platforms, for which
'size_t' is 'unsigned int':

  drivers/scsi/qla2xxx/qla_init.c: In function 'qla29xx_process_rd_image':
  drivers/scsi/qla2xxx/qla_init.c:9272:74: error: format '%lx' expects argument of type 'long unsigned int', but argument 6 has type 'size_t' {aka 'unsigned int'} [-Werror=format=]
   9272 |                             "TIM section too large (0x%x bytes, ring 0x%lx bytes).\n",
        |                                                                        ~~^
        |                                                                          |
        |                                                                          long unsigned int
        |                                                                        %x
   9273 |                             section_size,
   9274 |                             req->length * qla_req_entry_size(ha));
        |                             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        |                                         |
        |                                         size_t {aka unsigned int}
  cc1: all warnings being treated as errors

Use '%zx', the proper 'size_t' format specifier, to clear up the
warning.

Fixes: c3930ec119cb ("scsi: qla2xxx: Add FC operational firmware load for 29xx")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2b9a9c672ec6..900cd141928e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -9269,7 +9269,7 @@ static int qla29xx_process_rd_image(struct scsi_qla_host *vha,
 	if (section == TIM) {
 		if (section_size > req->length * qla_req_entry_size(ha)) {
 			ql_log(ql_log_fatal, vha, 0x0098,
-			    "TIM section too large (0x%x bytes, ring 0x%lx bytes).\n",
+			    "TIM section too large (0x%x bytes, ring 0x%zx bytes).\n",
 			    section_size,
 			    req->length * qla_req_entry_size(ha));
 			return QLA_FUNCTION_FAILED;

---
base-commit: 376a3960e5efe85ff765abfb5b5b7e4655ad6aed
change-id: 20260811-scsi-qla2xxxx-qla_init-wformat-c542b3cfa6fa

Best regards,
--  
Cheers,
Nathan

