Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F491E515
	for <linux-scsi@vger.kernel.org>; Thu, 14 May 2026 07:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778745492; cv=none; b=sw/030MLkmSFh7YFh5E500pq917DfqqGn/B6ETV21g+K2H/WIB2Qe+mWjPQkQZAYkUTL+vYA5JDpNmPX72ZgzZvdgNmLRAgeObxYTLSUHgb1JFkriFXfV4BL6CWGBJG6H/NCx1zRjUuyXJBq5IGrP8Y/EC+O0JN//Ur23bNHNJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778745492; c=relaxed/simple;
	bh=S91ZsN8M/14W1Cf0Mz2i0BwevkgWsYnSSV7xvLUS6Q8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hhT+0J5N/wKlxYb76U1osmu5cuj1e8FP/Y9fImkb2qx8unH3F/hGWUGDKggBo7kEDfcuTfgbDblRgZCYobz1RjW8cX4cS3o/sslC489500BD4MxtVR9JzQLQ5OW+BbEUKLII26pvNlnzYjYjgFYI2A0E6kmPGIjm8383lwNgArA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cdDBMhKR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=hvbY4ZSS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cdDBMhKR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="hvbY4ZSS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778745489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pCTUHzrRIWVUxvIV/1vG6PkzmjwBpL1hYToIFGA0mv0=;
	b=cdDBMhKRSmwHlxSQaY8+cM42MW3Y3+98BZBvmUpTJm6YdCXN82ElvXPZ9njSgvlmE5nB9e
	JkPvNR6OM9DFqBuAf2IllCDQnWuLUyTxEpl/4GFKvLVLdFwrNs8jy7kdyuua9Bj+/IydeO
	FEbALZ0+LPeP1397umfdQBE3z/jSMUQ=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-36-6NZVW4hXO7S7RyP_FWHSMw-1; Thu, 14 May 2026 03:58:07 -0400
X-MC-Unique: 6NZVW4hXO7S7RyP_FWHSMw-1
X-Mimecast-MFC-AGG-ID: 6NZVW4hXO7S7RyP_FWHSMw_1778745486
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2bd04e4fe3dso53781505ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2026 00:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1778745486; x=1779350286; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pCTUHzrRIWVUxvIV/1vG6PkzmjwBpL1hYToIFGA0mv0=;
        b=hvbY4ZSSd9LrttTWWm5ArtKBzYz0967mwB323/uM7grl6HRwTAkvCJKoyLoJCmWk0Y
         6qb862xu6mcMaupXgMrX9bv9z8lD3NTuC2v9afVxo9el4sSSqYK/mw7dr1NYJeBRLnGF
         AfYR3ozlq9BaSO/wyjv15rNMSfnK5zl7Tx7dckYjCfcQF7jlSvncCDHds+SnHUcsHrZ3
         bmKYOFX/cMn9YR/AAJQ/gsgpNT2NKBLoiJRor6rwKr9E6WNG/Wc2LM+CN+MBIRGb5TrD
         KkFmj1dfSQGyM7qvGJ50lQOvTG5XIb/EHrF25Sc0JAzKzfWAxI8WzLh8PkagdCAHqaT4
         nvNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778745486; x=1779350286;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pCTUHzrRIWVUxvIV/1vG6PkzmjwBpL1hYToIFGA0mv0=;
        b=KSbiS+LQxvTQkQgzEaUdwyPw976JQC3z+EXbIOOLa+V0U49yU4Y6ticKqlSy8rQiGt
         O0+vhKw4u1XwO1EBu+fo4Z9kHGqxwBR9b5CTQGK02OlqlgNF/D1ThqL40+H/Y3Qtt4W0
         PkvuvXx0NCJGUskW+KsXqOgI9daT+quTmaAVJ8nJojwIVtd8ciPwlYDae2L0L6RqF31l
         mdGvb3cj7dgk8r+KZ997OT2EIgXhuh+tpISAR4kS1lK6cgPXK51UmYrm8he9yfisJ2er
         akemKVfRZ/0Yxr0mbYDz5oMmhrjXs71ehyZIVUnpMP82Kj/hW8DVqQn0ZRSuEo0Mmcxr
         CS0A==
X-Gm-Message-State: AOJu0YxUwtQZeg40PK6+i0fnrv4sdE7l0Ikv06x+frqLohqM1hDL/Lqk
	eAl3eFvBONObRDTClLsRQE19QNggXZn21oxjRapgIlKdZnrWIDUh6Zu0v0X/X9MRjzkCpZFN7Ga
	ku8FMnCkyk35nElj9dY7rzH38Szx3n13MHjO/A8xxzlygdmhSFeLjyMh4d2yT5N0U3qhWSUvSHi
	dfGdycb5MQFL39QJuEnJVx5c6dO02DScFf+bPclUogYIN91A==
X-Gm-Gg: Acq92OHBEgZBv9ZLt/y1zqW8P30/qyKcYAVd8goTnilCEm87s2BDtdS5ixR2qIywAU7
	pDpaGYJItDPI1nZT91Rvjy8/hL4ctq7qcizCCpTIYXeWyeD97wBzY92HPXbsgUoWNdT1rclSGYp
	Hcfc/pxvA+BvUo5sDw0gI0uZ4ghvHe3vKtONpkMZs86t+5RgYNI1Vqqel3ZMZJU1LDhMYi8V0Bk
	rEK58sb1afq+9j81sGNDlaY6D79Ayzu3raaOJgOvRIw1FfBK5v35snz8lCK4Vvf3O6KZXorKF7S
	mHDWNo/iQ2+RvmFFQ4LZiyCOAXGoloO6UkTc99m8u29ctytnOI1G35hts3Au37SxazENL8Aw3pF
	fBZVgoRWQ5Y/dWNIAeMAp4lQPE0lx16Wy5Cqzltf2VhVd2sTc8X4=
X-Received: by 2002:a17:903:120f:b0:2b2:eaec:c810 with SMTP id d9443c01a7336-2bd2f4f76c1mr66376635ad.8.1778745486328;
        Thu, 14 May 2026 00:58:06 -0700 (PDT)
X-Received: by 2002:a17:903:120f:b0:2b2:eaec:c810 with SMTP id d9443c01a7336-2bd2f4f76c1mr66376425ad.8.1778745485753;
        Thu, 14 May 2026 00:58:05 -0700 (PDT)
Received: from machine1 ([2401:4900:88fb:5ab3:dad7:3a92:7bfe:7bf5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5d11d659sm14978635ad.73.2026.05.14.00.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 00:58:05 -0700 (PDT)
Date: Thu, 14 May 2026 13:27:54 +0530
From: "Milan P. Gandhi" <mgandhi@redhat.com>
To: linux-scsi@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James.Bottomley@hansenpartnership.com
Cc: Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] scsi: megaraid_sas: Fix NULL pointer dereference on firmware
 duplicate completion
Message-ID: <agWAgtk6rtHqNWb5@machine1>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Add NULL check for scmd_local in the MPI2_FUNCTION_SCSI_IO_REQUEST case
to handle firmware duplicate/stale completions.

When firmware sends a duplicate completion for a command that was already
processed and returned to the pool, the driver accesses NULL scmd pointer
causing a crash.

Timeline of the bug:
1. Command completes normally, megasas_return_cmd_fusion() called
2. This sets cmd->scmd = NULL and clears io_request with
   memset(..., 0, ...)
3. Firmware sends duplicate/stale completion for same SMID (firmware bug)
4. Driver processes reply descriptor again
5. Cleared io_request has Function = 0 (MPI2_FUNCTION_SCSI_IO_REQUEST)
6. Switch statement matches SCSI_IO_REQUEST case by accident
7. Accesses megasas_priv(NULL scmd)->status → crash at offset 0x228

The offset 0x228 = sizeof(struct scsi_cmnd) 0x220 + offsetof(status) 0x8.

This issue was observed on PERC H330 Mini running firmware 25.5.9.0001
after 3+ days of heavy I/O load.

Crash signature:
  BUG: unable to handle kernel NULL pointer dereference at 0x228
  RIP: complete_cmd_fusion+0x428
  Function: megasas_priv(cmd_fusion->scmd)->status

Add defensive check to skip processing when scmd_local is NULL. This
handles duplicate completions from firmware and prevents accessing
freed command structures. The check protects all scmd_local uses in
both the SCSI_IO path and the fallthrough LDIO path.

Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 2699e4e09b5b..056cbe50e19e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3612,6 +3612,15 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex,
 			complete(&cmd_fusion->done);
 			break;
 		case MPI2_FUNCTION_SCSI_IO_REQUEST:  /*Fast Path IO.*/
+			/*
+			 * Firmware can send stale/duplicate completions for
+			 * commands already returned to the pool. scmd_local
+			 * would be NULL for such cases. Skip processing to
+			 * avoid NULL pointer access.
+			 */
+			if (!scmd_local)
+				break;
+
 			/* Update load balancing info */
 			if (fusion->load_balance_info &&
 			    (megasas_priv(cmd_fusion->scmd)->status &
-- 
2.46.2

