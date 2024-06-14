Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEFB16B751
	for <linux-scsi@vger.kernel.org>; Fri, 14 Jun 2024 16:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718381310; cv=none; b=C1eGb1BEdbYQCFhfbXzDzux233dXepD7Zgva58kFjXTk5eIyZcdw4lCnXHCmAkB4wMivkughyI4+pvbh5w/TQBuwGRhm9+3vb2byiJRXWyWQvWzR/f5YKD0pXYcq+C0korzXIizgCskR2DDKB4sc1VEKhvDaTDXbkVujkd88fOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718381310; c=relaxed/simple;
	bh=6M2PqV/7h/kVPTerbxqLHrAdQOpFIkjlO3ANv87ZX/w=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=t92arMhVB62i6qU771pguf94j8gsqvTzsA99cO6HwE3cEaidp5gm3ESGytn4VEJNkclR6Pyy/im8MOUPZzEDPg0WCA+nOX8grWU63D3ATyB5dlaIbCnBB9ApsUdirMva4Sdu/BP2WrngeKH21dDSlj+03DAGTztnS3X0B8t+4Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com; spf=none smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=LVCnsRnU; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="LVCnsRnU"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-6e41550ae5bso1658223a12.3
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jun 2024 09:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1718381308; x=1718986108; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=kcJeTxiX3WM8uQrCcDSKPApG5QEh6G1KM14LKw9t1aU=;
        b=LVCnsRnU/lyKetP1Xer6Ea40j/kbMTaBWHXcPj0S2Zz9Z5sDCfruAuF6/q+088IuMP
         +B55/i4wc4I/CluMlzIxWYMfF2jb3PDwni1CyT/CxUFd+fACigDFDwHcUCvwjcBMSDyu
         0vHXWEjByE7gSrCZlmnhukqD6ucFEg9fCwK/v1MXrWd8tHatuRFmKAywDBhL98Ffjsmw
         wQ5dto40VrAVvcdIgZJUBea7ibx5mqDlQY8H8uu0mA1Q8yGWjEkfTwCn/vWbX/uMRQP9
         epUT18CAnynL8DCe9I4UhC9KnfnzD+bQ77X7B3qc+CMd/mmnn2XWSxcqxR4Oq1kPdto+
         PSaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718381308; x=1718986108;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kcJeTxiX3WM8uQrCcDSKPApG5QEh6G1KM14LKw9t1aU=;
        b=TWWckCGwYEkF4ge8wx56EFWpDZZYIpu1e635mJpufwcBBXt2kKdB7INCT0XGzqDh/C
         JC8mruRt4l0F7QXCk2g1UUeqBwiuqMAv2oITst4Iv7MSy1VoNs8Zd6vFzYkBYKaetVP1
         oNpMAxDUGCiLWIJ3Cyn+Qs95CEUXr/crfMoXTWeVbpkdbwRkYTdXD9zoaTSxIk150if5
         jImEFUlgZtpLb3aUlJVakAjk3sCgr2n1an5AheVnJvWDpc2UxA5+m11/Z4VcT3ssRYwc
         Gq8uh/TmB17afJyB6hSShHDAA1ZMCXINPPrQPtyD0eorS/cg7PLOdTxr1Sc45aXT+ks3
         e26g==
X-Forwarded-Encrypted: i=1; AJvYcCUYkh6zJ8ZyTBq6WN8ujYpM0zPA4h6IXwGUq5LcuVsVflN9c3TTCSDnudCSpP6tUzHb/jHu1WKjRi9T4DCyOIbPfRbeA/Cnr6ircQ==
X-Gm-Message-State: AOJu0YzopFjWzRVhDDX3jU0khn19xPuYQaAcGU2od34ftGPPn2SphCiT
	nk+saZOsGH2acZv77/yy/QMSkTPzRIwUoA5Lqjfr3E/rbuBM8ZaJM8TJd/DWrmE=
X-Google-Smtp-Source: AGHT+IFIgJB6vSmQN+lPIqYX2cO2RPgLhz5hQGek745gmjSMFGXi8hF8p8rCTTHAAuT6SC+VFGSrQw==
X-Received: by 2002:a17:90b:8d5:b0:2c2:db95:80be with SMTP id 98e67ed59e1d1-2c4dc0288b7mr3311560a91.42.1718381307636;
        Fri, 14 Jun 2024 09:08:27 -0700 (PDT)
Received: from localhost.localdomain.cc (vps-bd302c4a.vps.ovh.ca. [15.235.142.94])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4a75d1d40sm6333532a91.9.2024.06.14.09.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 09:08:26 -0700 (PDT)
From: Li Feng <fengli@smartx.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-kernel@vger.kernel.org (open list),
	linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: sd: Keep the discard mode stable
Date: Sat, 15 Jun 2024 00:03:47 +0800
Message-ID: <20240614160350.180490-1-fengli@smartx.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a scenario where a large number of discard commands
are issued when the iscsi initiator connects to the target
and then performs a session rescan operation. There is a time
window, most of the commands are in UNMAP mode, and some
discard commands become WRITE SAME with UNMAP.

The discard mode has been negotiated during the SCSI probe. If
the mode is temporarily changed from UNMAP to WRITE SAME with
UNMAP, IO ERROR may occur because the target may not implement
WRITE SAME with UNMAP. Keep the discard mode stable to fix this
issue.

Signed-off-by: Li Feng <fengli@smartx.com>
---
 drivers/scsi/sd.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f6c822c9cbd2..0165dc70a99b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2598,7 +2598,12 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		if (buffer[14] & 0x40) /* LBPRZ */
 			sdkp->lbprz = 1;
 
-		sd_config_discard(sdkp, SD_LBP_WS16);
+		/*
+		 * When the discard mode has been set to UNMAP, it should not be set to
+		 * WRITE SAME with UNMAP.
+		 */
+		if (!sdkp->max_unmap_blocks)
+			sd_config_discard(sdkp, SD_LBP_WS16);
 	}
 
 	sdkp->capacity = lba + 1;
-- 
2.45.2

