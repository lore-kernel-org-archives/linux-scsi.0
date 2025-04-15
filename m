Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED861CDA2E
	for <linux-scsi@vger.kernel.org>; Tue, 15 Apr 2025 10:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744712443; cv=none; b=WnaPKmv45NtOEu5MkJ6v2NJblPE+pMqFCzbxqTN34gJzMlhVzdr4Esq39W6wGnTXp9i/CYMKznug/7A3wsv6j9tQiiHSSidWV3ABl/cK0QVyal6iLRbOtn59qAZTpJOuXQwNJrRSj2j86GKXRXppCTiQF+FWxZU2oxCpnRGIOr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744712443; c=relaxed/simple;
	bh=iiYkVxD4JL9wUZUquUsN8qjosgWXJDze2vb4U0CIuk8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=achyb31HqrS0JwaZ0RBahQdlqKcrcbd33llu4FKNq1yFEMrRjynElxHebWEHITMM7nVpEddPi1pZxfnETKVjiyB/9kWCGQBUdHwonAwYe6aoEAYKPmZFdILWlI4WKekKkSSYIxEv9IeHJQqwQnaN2q5h45ihg49ec8iPOMxKb5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Ahh01ogE; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Ahh01ogE"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-af19b9f4c8cso3767011a12.2
        for <linux-scsi@vger.kernel.org>; Tue, 15 Apr 2025 03:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1744712440; x=1745317240; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tovrct2dYWO1eA4wVmENwRP5nytzGa4ONf3qrODrNx4=;
        b=Ahh01ogEoNTro1vAY0Et7lTBLbi0eOhrUxeR2OWL3eqiwZswmuc3dOf3vxajaD/G0B
         yLxTHmAW/JBvOO+KJiW/5spvzxW/WYQYveMx6Iq9oifoDebiotA2mNsNyg++wMYt2Yqp
         KpoPlhVmUcG2Ew/eAv1XDEbLEqIdJEvMp6Kck=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744712440; x=1745317240;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tovrct2dYWO1eA4wVmENwRP5nytzGa4ONf3qrODrNx4=;
        b=Dr20y/1BR1AYkgDd6d54Z+X/a5LbUXCnt34wREnDNN5s0NIix3fkOSVGCRERExOooD
         cZoaY2yLTl09+oh1QzjkiNCpEK3WTm1Y5xwwGtgo9S5s/o3XCMKpD4UzVgm2y7rsCttP
         Spvs/h350zoo0IgbonfAQi7n20EZRAzSDypbbMocCYvT+I/O7v7uP8ke4qQfF9Tl4XKc
         kedLz+nCC+5JphNNJfYKpZGYzNky0QdbDDvhLprUfwvSRHSf9uCuIiPITje1e3zyvaPd
         HoIN2BkK8wUB1cNgVK93W/chk4O7m42uKh+NolQmLM55xdAzFuaokPWHmenr/PL74ekX
         TGuw==
X-Gm-Message-State: AOJu0YzEBIJo1xdebwd8Aj/6BMK2UDuKO9fbVYWdmQeRuV5UdFbYh1aL
	NZ1pQsY3LnPVVCBOqQIJYSOYiBcVCW2DJvDVQ0PQePn+mbg4ZFv3C7K5aKGzjedb2rd7nwDjQ1E
	ApTODswM6kZf5lUBiZJtWynm3dmx+y0PH5LcnNojqXgHEwbALYUJm/2nH41MFDqwjKTh1cBXbX1
	7tc38NCSeptgWojPpKJcAOdzh9fFN9vnr21iQmViaOY+Bdtg==
X-Gm-Gg: ASbGncsTE9B7yJP+wj9/+jFHl5aP3WKW6Y4arGCAk+LWTh2iJyNqLce1+APi7SWogpY
	c8peXUgo5Q09C8CmBL1v1nVPhpwLjLrsvpTpsXK3TYQonA4usCwbAjxObUKfDGC8MphvOk/BIOq
	2KiQRoZpLCh+zP5Hd4RGQ3PMrLGgXRgnVhR+Awb/tXcyRLsCL2NvF4Eq1WLws4pK17GeHx4wsG9
	ksDh2J/Z2hJcZdH3div/NJU9Mk3fAKlQVFqplyAyDw4mD4iLo6OMCOYaK6mZ+0JqEaJM0D8C1/R
	Nfm8wmbnQis6qtCoT4VBNyf91vW5UsunZWHGPNW78Jn0dhem5PNA1BWPBs/GPFZbvfGIrzwQFZz
	Zdv9tZMGN
X-Google-Smtp-Source: AGHT+IE8V2q14u2ZpqErd69vCCj/kwOCpglu/5/SEhBSnupVr+hZtX9byUbytgnJH5GLUC1XCIpTlg==
X-Received: by 2002:a17:90b:4d06:b0:2fe:dd2c:f8e7 with SMTP id 98e67ed59e1d1-308236343c4mr22492483a91.10.1744712439747;
        Tue, 15 Apr 2025 03:20:39 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-306dd12b599sm12878607a91.23.2025.04.15.03.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Apr 2025 03:20:39 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1] mpi3mr: Add logging level check to control event logging
Date: Tue, 15 Apr 2025 15:45:46 +0530
Message-Id: <20250415101546.204018-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The check ensure event logs are only generated when
the debug logging level "MPI3_DEBUG_EVENT" is enabled.
It prevents unnecessary logging.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 003e1f7005c4..1d7901a8f0e4 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -174,6 +174,9 @@ static void mpi3mr_print_event_data(struct mpi3mr_ioc *mrioc,
 	char *desc = NULL;
 	u16 event;
 
+	if (!(mrioc->logging_level & MPI3_DEBUG_EVENT))
+		return;
+
 	event = event_reply->event;
 
 	switch (event) {
-- 
2.31.1

