Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857761537C6
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 23:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738280698; cv=none; b=kVaiEV3SuOU46YR3h1rF0Jd97WRT0hQBg9IRxlGFd3GrNuvS9Wd5hxP3dpHn8lEXfKS6NX1nvpqFL/CymGgXgolJ8AK3EWrrf/hLPoZfVDMdCHVsNAlMxODHtf7G8WrVkYwiluLiookpP/GzoIqseFf8pV17RqG6JgR28zxB4Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738280698; c=relaxed/simple;
	bh=Kk05i1C0qrAgHc3l+PWmqqXRrVMRKHkTpiNq4M+JrXc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=S1o5g/B74Zj475pJIRA8l52FIc0kZnmJdx1Ftvw1hyeZwiJhwTSwiVYmpZ84L/s6hOOCs4XhJBabrLltYna8OYSDnfXOhbCB1mCi7ByVXBBEd+mYBCKPWQVVGoJct2P6+e2wE0MKNkIwdu07/zHI89rjH3Pyx2XmtA0J8refjSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ur+B/FcS; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ur+B/FcS"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3f314ff6ffdso825830b6e.0
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 15:44:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738280695; x=1738885495; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=36Xefc05HaB+m0dfXwF0HywLFS8+FHQZh5nIQRsPNpg=;
        b=Ur+B/FcS/s3xDHcvizmz+F9TpCm469qdgy+CpDzKs8LM9BX4LWtTKCODuIDok/je0e
         v3VKNkG+3PdhBImmmYBqP8BCMblAFQs3OurUl+0sM1TQZo8AKPsVec/DOWcZCSm9MjZX
         0UT8DBJOEpAjLVoltmVsNFFI5zd0el2+s5TiQjeeCk/enSUd/LERF8mKQdH8yzi51TvI
         UTMOlMWoYNpvaUqnECmgwviJ5v6glH2iVez1YfvXzObfDHaVP6CxyBDsOoWvgoJxKRN9
         v/9P4ME05oXp7Bi8R0Hc9fPRsPcKpdzAK70bdTRLlWHDm0g2yOm4zeJzQRjjrc/Ma5g/
         dnWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738280695; x=1738885495;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=36Xefc05HaB+m0dfXwF0HywLFS8+FHQZh5nIQRsPNpg=;
        b=TTuGIPCIbvaVNCIK07TeM+8ozasvRlw980He+lpOtS+h360MYdSYKroJY4Dc6grVvy
         /Jd1MzeOrbzQCfPMhAyLjk87+MjtcUmv0OZy42Cpx2744kC43j7y4em369gegU1jZGNH
         mTl0TMtb3AHfu7wb0t0HIvJYBT14JJy5iJuZf17EHFrIsp08jOk5SLJpnvrCidf8KF6f
         rOO6Tdj5dPe0sLAzPLyi5Uy94NDo7zXsNz8OTQU49MbqKV5QyYIQaULRqSqZNio/XExt
         4Mj/Rig9/kOhkYq2Kqs3F+on8f24XBOHRkC9VnO+XEqTNdJ6Ig6jeHI6tWv6FGrM8yUe
         0X+Q==
X-Gm-Message-State: AOJu0Yyx7O2QycIiOnk9FpQfJdqw6iPvPWfpRXzKjfsiDVT4IZbBbQqX
	m5FHzMYf6hUoGxZb2lNxWjoTgZZBsrm3H5j31QjSv3v12Ab7dB2F7I9/SQ==
X-Gm-Gg: ASbGncucMksDB5QnCfq4FWEyGMEmE3bcsMRtqf/de8kmM94WquRoR3v9B8QyoDztLGt
	9ouGz5W+OI0yPrHb9JL9zj4x0+G5e3rX16I+F/0hXmpq6wgtQx+BO7/Gxf6NvId8acmDlAN8AHm
	YScfkNpwD5To74ZEVflfgt8g/bgGjkVBlta1CAq5TprDFKEsYKtqdnX0BdKR6aBHBE8IB3VIazo
	H+yn/ssIHHNzheYMrbcMLHHNK9xOJWfZHxbxKFe+Rctf3SJYGOKhIV9wF03182ulU8bPkLM6OAu
	Yy8e07FTfF/mgYYhEiNxpWgREMrdhBPj9D9iRJYAALY0lPE+5np1la6qSX30mcN/p4OuGqx7QhM
	p
X-Google-Smtp-Source: AGHT+IExqAIVACIMzzO0zXWHqvwfRN1revkJPJ1MzFIUR5AwxbLTNc2wTOpZxKvWL8vywdLRLHn4uw==
X-Received: by 2002:a05:6808:2229:b0:3ea:4bcc:4d9b with SMTP id 5614622812f47-3f323a58b89mr6737113b6e.18.1738280695398;
        Thu, 30 Jan 2025 15:44:55 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5fc105d8a22sm517609eaf.37.2025.01.30.15.44.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jan 2025 15:44:54 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 0/6] Update lpfc to revision 14.4.0.8
Date: Thu, 30 Jan 2025 16:05:18 -0800
Message-Id: <20250131000524.163662-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc to revision 14.4.0.8

This patch set contains fixes related to diagnostic logging, smatch, and
ndlp ptr referencing issues.

The patches were cut against Martin's 6.14/scsi-queue tree.

Justin Tee (6):
  lpfc: Reduce log message generation during ELS ring clean up
  lpfc: Free phba irq in lpfc_sli4_enable_msi when pci_irq_vector fails
  lpfc: Ignore ndlp rport mismatch in dev_loss_tmo callbk
  lpfc: Handle duplicate D_IDs in ndlp search-by D_ID routine
  lpfc: Update lpfc version to 14.4.0.8
  lpfc: Copyright updates for 14.4.0.8 patches

 drivers/scsi/lpfc/lpfc_els.c     | 12 +++++-------
 drivers/scsi/lpfc/lpfc_hbadisc.c | 31 ++++++++++++++++++++++---------
 drivers/scsi/lpfc/lpfc_init.c    |  4 +++-
 drivers/scsi/lpfc/lpfc_version.h |  6 +++---
 4 files changed, 33 insertions(+), 20 deletions(-)

-- 
2.38.0

