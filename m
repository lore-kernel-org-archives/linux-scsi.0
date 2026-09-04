Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947B23CF976
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 12:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788525663; cv=none; b=Z35YZu9LtzNcJbTh4TFjwc5Isr0XhfMOCNFIt41HmL71nPnjxluUDaAivLGBhD8DCPDSSjyeKpeHMr1T/F6xosj99ZowvWn2SNvTV/6nxPkV5pPZBRTy97HnLRNNehaCIjYARHRLg6+xdS5HfAQKuJ6/eSU5+eiu3eXab4+M5ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788525663; c=relaxed/simple;
	bh=W9E7oTbSIOoSr5ROfBnqOFjp+a55TyKIr8RY0NeVMW4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C4i8Zq4+omILIQcQ2tOzdoz712pw1u1K+nZ85ZlrUNZ0frh4TEvubfjpv8GEyRMZMet/4Z57TN/ErD1C/ylvUledSOIkJqrHE08MhCsUH952WSjaN3wtGrNBW1NAO/a7r0q/Jkwme0plkkoKeZea0Mz8juB8NZ5TCMWTNhRZzgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XonATC2g; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XonATC2g"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-6b1497f0453so723534eaf.3
        for <linux-scsi@vger.kernel.org>; Fri, 04 Sep 2026 05:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788525661; x=1789130461; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/o2hmJ0LIrPtpf95qcGGCcq5zc3JRhE9kQ0QRna2H5Q=;
        b=XonATC2gLtSoAx71i2zlqNRqBCE4mT+w3dggAeaZsGi0jhLtF+fKYWNLyb+5TeMqGr
         +9YuCaNdd5aN2y+/6RRJgpjScAxfMiUMdjO5O/GpFFRonpy3v5qqvkJ9fGQH9m/nFbvT
         lCpyXdb4Gwk2Ed89KZ2yA8qSl/S4eHbciQoH/IUXGq4L79i8TO1R+Ez9Q2Je2mcnSuTn
         ldddip7R+AZtsIwTSolfumLermoTUsm1FBasYxNn5dPReCozFmDqwXxJp43exWsFFMj4
         DIy+05NzmWa6XhY3jdkQzIjyetMNHioIa/f4xin7rEXztlIyKZaxkge0BKk8ia0GJ28z
         osAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788525661; x=1789130461;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/o2hmJ0LIrPtpf95qcGGCcq5zc3JRhE9kQ0QRna2H5Q=;
        b=P0UwARd7Kp2pihhxz0kgoSHefHQ4o3LK3cJYt4ghapOEuPRVs4NyXKyDIp4O7ggeHm
         mTAdNSUF60qxmkWdm6ia92S2oNj4+45hnWNwVYDtw5Q6XQTywBteV0qEelaLk1J12mSk
         gqgk18wVzz1xJpGfX7z6cQvP7KvvlmRP+d6nTJPRZe4YR9Z2pbtn/J0CA5/PE5KHrdfi
         +xUi+VSmtVv5vcDaXlyTJLXRH0zHfcxCCEuCw6cJ407QfXxLfUV67zWT8T3JN3dD0Ozr
         h2kLJDSRbddPo2qehDj9kU3s05dIqzl1Bg3d++LhjCj0o71WSLJqoSCZAN8/LGtEqS+4
         1/zw==
X-Forwarded-Encrypted: i=1; AKwUvBxJoshZkN/2dC1U8DcgKME3OvqOQ+CG26earwo+CczR83LuKkuG1WozkJGsQfBM1QbUsjWEMgpzZK97@vger.kernel.org
X-Gm-Message-State: AFuF++mVicokhVzkxXcre3DCQTDwTEFkKNueeMPjwyhFsr5D+DMeBWDL
	Z+C6VWVIWctTDtLPyWgHy5adW7xFScQZdgbIHaKZgukRpIe79jQJKpdlJOTNRDGPy6g=
X-Gm-Gg: AYBFou1Gbeelqbtpnj2kXWtxx38wTr6XTlh28CWyYFaQt+YKPyLz9F7lbCeNuUBIKAH
	wCSAk2thLtE7ptajHqmUfIw1WDX/TreYhPNUSYqmMsIRvkAK4GcP5yCK8HKMZl+vH//DKC1tB8q
	U02yqYZbVrIIEvRgHfFwDAzMZ6AGg0WmVSa/VOFEExOihpYqksFXUzezB6Fzf4PUWqvTMFQGiDb
	sk1c9xAadfHvLJRpEtYv/XJvingu6BpVvRsvlganRVfu9g2lG5zdzLFKdvfBl1Nffj5hNscRFyj
	XXDTf9dOzMrbzmLRyCMVIjuWAAXHGjCUBc+46zwxaDoogolWNMhI5fZqqLqBPJ/4b7nOzVoOs7n
	pNAW3/7MZmnpbN23yJzFEq7AhtGv50Zv7l76pOK2hfDqKaqHuEbdvNZCkSemJCisENIRTd+kXwl
	XMqkU+5x+9l9cTGp2mmxEchrS9hclDFWb2rRkjECqwd+DJ5cG/q038t3t8f7sAJgBGcC8aRYPL+
	NF9/qhLxVE/AVU=
X-Received: by 2002:a05:6820:a50e:20b0:6b7:46fa:16ac with SMTP id 006d021491bc7-6b746fa1b09mr1628291eaf.65.1788525661030;
        Fri, 04 Sep 2026 05:41:01 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1432437d0f4sm6185774c88.7.2026.09.04.05.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 05:41:00 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH] bsg: fix typo "deafult" in comment
Date: Fri,  4 Sep 2026 18:10:55 +0530
Message-ID: <20260904124056.3929-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct "deafult" to "default", reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 include/uapi/linux/bsg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/bsg.h b/include/uapi/linux/bsg.h
index 6cff77f5b857..b67d86eff33b 100644
--- a/include/uapi/linux/bsg.h
+++ b/include/uapi/linux/bsg.h
@@ -17,7 +17,7 @@
  * For flag constants below:
  * sg.h sg_io_hdr also has bits defined for it's flags member. These
  * two flag values (0x10 and 0x20) have the same meaning in sg.h . For
- * bsg the BSG_FLAG_Q_AT_HEAD flag is ignored since it is the deafult.
+ * bsg the BSG_FLAG_Q_AT_HEAD flag is ignored since it is the default.
  */
 #define BSG_FLAG_Q_AT_TAIL 0x10 /* default is Q_AT_HEAD */
 #define BSG_FLAG_Q_AT_HEAD 0x20
-- 
2.48.1

