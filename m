Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03C823D2A4
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jun 2026 20:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781036538; cv=none; b=TrajawQ0+P8/RzRrvqFNMJ8RnIhD8xg32xfF9Aq9bA3AZfGwijR2l4YLiXUn2im3RovNcRSNMdZdxM7gA8U8TTvzMYGHZUPVYDjB7GkGawu7+Uowgl7Uns90pZw7i9+YOT4tKhzk2GPZ+aiF1nrOGBF/PC0bdnnpun6mLF2gFPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781036538; c=relaxed/simple;
	bh=G7wiigdU6vV1lII5kNx4T7QY98PZzFdThZZfSKMMfXc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CFv0PJBSnRR7IHY01U6Y8sY6tqjxztuByjZbt5HYg4wYO1+zhGVJOwDnTju3Di3pTk2DhkprBTX6zyhdbYnHr4PUMkSoAjRF3RHFZGGduBJiRWF3wje6pMChoYYbMImNcGIdrPfIcYwk3egTm4dXthGTrO8vAWLSOvTDkQZcwnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nk3KPlxG; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nk3KPlxG"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-486118ecd5dso3767235b6e.0
        for <linux-scsi@vger.kernel.org>; Tue, 09 Jun 2026 13:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781036536; x=1781641336; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MyKzYwyN8XFtjIuYSRUDu+cXND7kKn1hDM3fJApHDs0=;
        b=Nk3KPlxGd44xFqU7OEXUEk5fPdOBw7KZDmaVRXQ4ofAfumI7qKLkvVxvtc7kU7Qc0e
         auAjkPve321iTUELE74kjaossDaW3hCMlGh8j0f7SPcrKrnMjVrXrpJ2QM8seiy1PUtr
         HyJ/qVnZivMr7AgjI16WkBBM75qNkoCFRgUMUJCkC7RRSplE2LPu4w1q12RQFDjRc9cm
         LlPor9a9rDqcHiWXR57rEAmRNaeepm5GvRnpoJqVLimzQVlnyBtMkHWfkOuHIuqA+LBA
         2/My4fl9zd5GGB4xWsKmwUWC8UJoDc2HDUrrVODrgeSRSjqtW7n4J4E5Wkjf4lkTpike
         jomw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781036536; x=1781641336;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MyKzYwyN8XFtjIuYSRUDu+cXND7kKn1hDM3fJApHDs0=;
        b=i6KugwzP5MZZ3EWgCtj2Vp+ziSOqe7mVpTbp+xlJCiN8FHrF8KKhl+GX0m9LjAhl9d
         mvE76Xn2kvtp8JF0PdSxRf+BLM8ihLOj9lyIDQvTrA4kS4M89utU7AAvyFvOFULfhWVA
         Xy5Gzqdd0Di8suu+lbWLgalsrLAD1SWMmDDQtGmZdFCqgBnX06IauJa+qz7uwh68i01A
         XS7qSMlO++WCl98Thvh3IXO0q2eptX97ACMzTCQUBCe+LLwzerf7k9bsDprRNJ9hQYVT
         +XQSty4uPsVFGQGk9WopEmIFKHQ1hrGe7dtRXahWepDwrutkR5yho3/NfhXO84mAlZbQ
         Y4Xw==
X-Forwarded-Encrypted: i=1; AFNElJ9jgakyy3fiK/+l/vWelW8fcve5QVzK9tWHZD2RMuCgWP50t3k/Uvt+HasyMTQNmbAN+OiSvnAhBLhf@vger.kernel.org
X-Gm-Message-State: AOJu0YzwQ1l6q/6ytKhbKzdMwUdWU/UMeBjzGU8GJMPTZrx1ej+bPHC8
	9j+RCCPImXYSlGIaQQjSwVELEUnsjPsz+AhhewOet/oGe2FaQwNxhdAL
X-Gm-Gg: Acq92OEF3rFziDHMPernP0klocNNjZneCLFLBgOK6Yn/DmHVrFKowaQA5hVmsJCj7PK
	1QXFGFuFP7AdikF78cXX7C2XK/7IbHsgNy6fFxV7MV3n0YtvLBnWAZNI9b22Ix9y6QDbLf3mzt9
	V2z+Kdt9SRchYG3/xu7Ixk78OQw6Bv79Kvwui2Rvi4576zWKNR9JyeS5GeHEjHXti4Kd8o7Tqo1
	88djF32iB/tvEL58f7gYs8m3jsqg/1kblCWSOQH+tHpdlZjkMyysaK6hHA0otfEh5xhwvsvubyI
	2KP5AWoMmh890Ay4vTTenDowQWfvhtrvOBqS77NGilKFnUQVcJ2SVgVOI9SgZHFe2bs2ehhFyb7
	mnoS5tV4Zv70UZGBeHudaR61gltE2B074H9MtCtUUVO4Z267vq42dy0SbwQ0RKeXGOrOifGfaWT
	0TKQSM6lUOthUT9bbZHfaFnJCWuQ+NHG2eCQ0MIl3X4b8V2YXa+RyiV4WNeRSOOHTw
X-Received: by 2002:a05:6808:1185:b0:484:afc2:eee3 with SMTP id 5614622812f47-4868dbf2a5fmr12532868b6e.5.1781036535807;
        Tue, 09 Jun 2026 13:22:15 -0700 (PDT)
Received: from localhost.localdomain ([143.166.81.254])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4865b5a5a64sm16888419b6e.4.2026.06.09.13.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 13:22:15 -0700 (PDT)
From: Stuart Hayes <stuart.w.hayes@gmail.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Stuart.Hayes@dell.com,
	Stuart Hayes <stuart.w.hayes@gmail.com>
Subject: [PATCH v2] scsi: target: Allow FUA if no write cache enabled
Date: Tue,  9 Jun 2026 15:21:56 -0500
Message-ID: <20260609202156.90700-1-stuart.w.hayes@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Modify target code to ignore FUA bit in commands to targets with no write
cache enabled.

Without this patch, accesses with FUA set will be rejected, even though
they always go directly to the media when there's no write cache.

This is needed because EDK2 FAT filesystem code sets the FUA bit when
writing, regardless of whether the device advertises support of DPOFUA. If
a UEFI pre-boot write fails, the filesystem can become inaccessible until a
reboot.  This can cause linux installs to iSCSI to be unbootable, because
some systems have firmware that will try to write a file in a
vendor-specific directory under /boot/EFI (such as /boot/EFI/Dell) before
attempting to boot to a UEFI boot entry pointing to a file in the FAT
filesystem.

Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
---
v1->v2:
	- change to only ignore FUA bit set when no write cache is
	  enabled, instead of advertising DPOFUA support
---
 drivers/target/target_core_sbc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 21f5cb86d70c..ffd2b6c9bd23 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -754,6 +754,12 @@ sbc_check_dpofua(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb)
 	}
 	if (cdb[1] & 0x8) {
 		if (!target_check_fua(dev)) {
+			/*
+			 * Silently ignore FUA if there's no write cache.
+			 */
+			if (!target_check_wce(dev))
+				return 0;
+
 			pr_err("Got CDB: 0x%02x with FUA bit set, but device"
 			       " does not advertise support for FUA write\n",
 			       cdb[0]);
-- 
2.47.3

