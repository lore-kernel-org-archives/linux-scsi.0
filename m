Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B2C3D34A4
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jun 2026 14:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780928896; cv=none; b=RSAU5kTvuv+eGyy+PcIgSsptCL2Iax6Qidr66ljmoAk2gK4TRGht26aKKyGIFXG4Gp/DBL3/r7zmoS/91CucUPlfNBn3cJcbqYr+xelG6LTxlYtftGBY8HA5hrG9/CL85bSSqS/3gnjPLfErvX/dQHmdERmlakD5pI9JzKQ6gjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780928896; c=relaxed/simple;
	bh=LvrQuMufMa2jstaWqw8VwauAYnxPiY07NBjKrPJoU1M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bCyJvBz8PN8gY6BW88kcBvOUH5hEwqk5tiKEm52vuRCnxD/8/zP3ahlKRCesninDCq1Fp3GQcnJOr3AKNu+9SlePRCU8nwZCRRp0nChPKdxxdJKivn95g4q/qNg0F7DxTnKKIUKzl4ueXXRSK9HmmXvIDpN5IxPokknxO/XZLwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kv+vlgp5; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kv+vlgp5"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490d1e54b3bso6072615e9.1
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jun 2026 07:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780928893; x=1781533693; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sp2ANuSp/GV260EEmEmdmugr8RRzCxVHzflIi+KBBt8=;
        b=Kv+vlgp5kdi2qYGCLYtSOBFY7632hpK3jtwqPAW3rjVhdTSXjkuwPcPfoc2xse+V+9
         cW76o1Lh7v/JipbCyAsL66ONeZJHBhFeCZljO35Gr/gEZxpKVK6jMCu5+LTx4OSeMuOj
         gx0YUwWfh6mD3MegG5aiiUIeYb9ioS4YNNvzIWwEc6NN4pCgkSRYF9eA98I7irQoxo+/
         vsOxcU37bAgn95imuybUkTQPx3CcSdZOL4XzewbY72e14h14I1r26VhyhFvyanZSmWOk
         tTN+j82/iNVdVXsjhLbUrltH1Izwl/aJ0i6iJHMAF3SMYQwH6dGQvfb32ayIKhM6CW4/
         OU8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780928893; x=1781533693;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Sp2ANuSp/GV260EEmEmdmugr8RRzCxVHzflIi+KBBt8=;
        b=f6p6GM4wIETSXPY1FwQidmYw1e/BpJluMHh8lwB6z2njzYXNytmXQd3xcHExP4Hh2a
         jAoHlJ7NXUeWVbPjIBD/72IISBAndd8QMmJR8JHrexPuuyHYXqrJqqzAPgIuUOBTe93z
         Jnyd7NIuiqoClgstKHpceRmtYVU0MA3PrAdIIgIlgmcZDYfh6ske4yfJdDK4hfcXxgw1
         WtZz5HX79sEeADRSK4eLqctO85gUQTI5SvDAGt3/xXasR2Tyy//2APz8l85eGvBLw6u9
         q1DtvnC46hG0Z+wbKWWEiWscYsOdwgF1mFCk6rvElYUutfup2Eorgul8ukKqD/CQ9Djv
         7k0g==
X-Forwarded-Encrypted: i=1; AFNElJ+Lc6ASEno+Lr3baYZhZAidPhPFzUn96pLRl7uRCCJT3gux2K91j5DPps+Z1wNvsMTKADwGw70nPa0O@vger.kernel.org
X-Gm-Message-State: AOJu0YwFmYb3q+Redp9uTEdCXJENaGoviJRJp2MTHRWtgDGe+zN5U9y8
	0gzKur8xcdLEjcp+2Q4PBhrYXuH7rfBTgYO0tV/H3GQo5NnPy4HjOt84
X-Gm-Gg: Acq92OH307acUrcpMF4FJljGVGbvs7ElF1M2l6cD8QbmPKH8D3CX2VUnbg96MlgU1Zh
	mXSYnra5on35S0NU2u6aqZi9nOSxSSaV29OSL4HHs7CuYPplCctHp9TrqulNxy9Gl9emVqrLHQN
	ogPITQFUSTcD9p6gW7y6qVXM3o+lEkKa+5DSiY2SwCiPG1AUN3ARA/h7/3v9futVPT1Kk3e+3jI
	j1Z7uyqX4eaQmg/CsF/DAL1vpYA9K55jRZTL4NBT7BZelfM9FQfFQJL5u+nEFKFDBdfOj94z4vI
	UZC/RJjpjws5ZVBT0nTRf7vQSLUSn/QxKH3AhPBbPjcw0Yt/AIUxMZXYaA+zjedo8GemdD6tREM
	MaUizYsWsYr5pmhJon6+h3uElgtF42lo0oSWAQpL1SoW3pZFjI+Vh+ejE7TcMwmp5zoSexA4Lst
	x6LGG72erh5u8hzVxc7VAF/UkM+8HZMMuN
X-Received: by 2002:a05:600c:34cb:b0:48e:6db3:ff3a with SMTP id 5b1f17b1804b1-490c25b09a2mr267979525e9.16.1780928893422;
        Mon, 08 Jun 2026 07:28:13 -0700 (PDT)
Received: from localhost ([94.53.77.213])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3cbfe4sm407415735e9.7.2026.06.08.07.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 07:28:13 -0700 (PDT)
From: Catalin Iacob <iacobcatalin@gmail.com>
Date: Mon, 08 Jun 2026 17:29:16 +0300
Subject: [PATCH v4 1/5] scsi: core: Remove export for
 scsi_device_from_queue()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260608-remove-pktcdvd-references-v4-1-72f88b04cc87@gmail.com>
References: <20260608-remove-pktcdvd-references-v4-0-72f88b04cc87@gmail.com>
In-Reply-To: <20260608-remove-pktcdvd-references-v4-0-72f88b04cc87@gmail.com>
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Rich Felker <dalias@libc.org>, 
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Jens Axboe <axboe@kernel.dk>
Cc: linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org, 
 sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org, 
 Catalin Iacob <iacobcatalin@gmail.com>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2345;
 i=iacobcatalin@gmail.com; h=from:subject:message-id;
 bh=LvrQuMufMa2jstaWqw8VwauAYnxPiY07NBjKrPJoU1M=;
 b=owGbwMvMwCX261qtXAKXKjvjabUkhiy1i/trmY8wXFU74qot2bFMQKYllkdpZl28/6LcZt/OR
 qdEq6qOUhYGMS4GWTFFlhfnrrdt2HMm4F6SXQvMHFYmkCEMXJwCMBGLYEaGGddjWhj5Nom9NZZx
 dnsg6qDb+vSPoVpBs3Rha/1MyRkLGBm+xtTJSfmev1K2/2Tr4t/P9C4Ibt+n+LLSJ2aHYv+PR4K
 sAA==
X-Developer-Key: i=iacobcatalin@gmail.com; a=openpgp;
 fpr=F609BFABD84EB5C9DDDC37EDE89C6A3571CD0E33

Commit 1cea5180f2f8 ("block: remove pktcdvd driver") left behind an
export that is now dead code. Remove it and move the declaration of
scsi_device_from_queue() to drivers/scsi/scsi_priv.h.

Signed-off-by: Catalin Iacob <iacobcatalin@gmail.com>
---
 drivers/scsi/scsi_lib.c    | 8 --------
 drivers/scsi/scsi_priv.h   | 1 +
 include/scsi/scsi_device.h | 1 -
 3 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 85eef401925a..b67f0dc79499 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2224,14 +2224,6 @@ struct scsi_device *scsi_device_from_queue(struct request_queue *q)
 
 	return sdev;
 }
-/*
- * pktcdvd should have been integrated into the SCSI layers, but for historical
- * reasons like the old IDE driver it isn't.  This export allows it to safely
- * probe if a given device is a SCSI one and only attach to that.
- */
-#ifdef CONFIG_CDROM_PKTCDVD_MODULE
-EXPORT_SYMBOL_GPL(scsi_device_from_queue);
-#endif
 
 /**
  * scsi_block_requests - Utility function used by low-level drivers to prevent
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 7a193cc04e5b..37e5601be2b8 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -102,6 +102,7 @@ void scsi_eh_done(struct scsi_cmnd *scmd);
 
 /* scsi_lib.c */
 extern void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd);
+extern struct scsi_device *scsi_device_from_queue(struct request_queue *q);
 extern void scsi_queue_insert(struct scsi_cmnd *cmd,
 			      enum scsi_qc_status reason);
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9c2a7bbe5891..9f716497a959 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -407,7 +407,6 @@ void scsi_attach_vpd(struct scsi_device *sdev);
 void scsi_cdl_check(struct scsi_device *sdev);
 int scsi_cdl_enable(struct scsi_device *sdev, bool enable);
 
-extern struct scsi_device *scsi_device_from_queue(struct request_queue *q);
 extern int __must_check scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
 extern struct scsi_device *scsi_device_lookup(struct Scsi_Host *,

-- 
2.54.0

