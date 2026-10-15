Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A9E3FC5C4
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 04:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792039962; cv=none; b=hWHyP0p+orzGjezwDknUPZa+4C0YgDAV9OM9/Mec9CKMRv9luMgnMg5q7KBlRi9OeyxMhA5isJ7w2RK2n4C7gkrxPwaigWU3mdp4vAFWsGRh/bSB79BO3YM4363kL5647FtP8A00MX3J6gG1hI4zQKR0+JnVifrnXeW2GBMQgmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792039962; c=relaxed/simple;
	bh=Eg+6P+OUKlUXxx5yNbWV64ZiyS8qmOANre+qfxIs3w0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ti1xo7UM7lNrc1TwHvsuHzg9J6r6uTJjbiLROB5ZIORcLDLIDfs3GO0HH75GbEvHWR2ahahHCrqSI8Gnqw6ukL95lOTpf3LJBAT64dQxu9OH0edQ9fJajQChbEsiDnvuGT7gxlNlzK0417Xu16BIDffiVw7hZ1+im3pIQnMGuds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=DRARn+rW; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="DRARn+rW"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2e5fb79ce82so26971725ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 21:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792039961; x=1792644761; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mTCguH0+TMXN831RGVaTU5hFkr86OVrY/PfeWmuClu0=;
        b=DRARn+rWOU4ls/ZDL2u1Kaz8c2snFd7L7Z2kPxggfraPvlgD5nIaNJswbINpoY/9VI
         +eHaugydiQk6Rn2qyrPAOwTs5bVl04rL7ChzJqF5oezKMcPk87FeODp4V0MfDabsTodr
         Mkxcqxo2NUI/NNgDVJEyRbtgDdUPeuXyx9RbOrUH/rEXec91kyau7o9Im0du8ypBR6hJ
         fTajCc7sn+UziPSyjpfqYwDG8CQdwVEPv3CdWjSESJ9MahUKl+24E+WMgtfSCc9854o4
         u+eHuvBkqwHD6eA2c7iLZlXCJxrFIOt9yl56ijmyXJPwFwPyiIv6IssUgM5Nl449gxLL
         g4Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792039961; x=1792644761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mTCguH0+TMXN831RGVaTU5hFkr86OVrY/PfeWmuClu0=;
        b=jBILB4f33aLQQecQuvRbKpL8o3AqSWV7cfI58sPh5qpJEZshlp4i8VRBBr/xkoPTVu
         8UajNreih/mLJltz0djHMc/u4qsJ3gvBF7TWjqtl7g16aMqyaPE8Q7GHL6XCJBicCmbi
         x2JekVsb0tAW8hqXut2Oq0bw6Zw5wUuHduwtPF+Vr2cjBUpbbx9p39gW0hUAbfEtKrPm
         ZfXjgoqOoLIK98QVf4jLxrSfHxwiKGNd16g7+crMmYbLuuau+XBxAt2g47241ump8i1p
         nwH2RcqWJEruy26mQyHIQqfYhpWUZiYoyHRYAZhmgMlKnTVXCifHM7ITCHZiBbWrYviV
         0ixg==
X-Gm-Message-State: AFq9FYLd74byiTRMTHD4Y3qBBLKZiwYS4d9eQtIrcMrmrod1NoJUgvkO
	0je+DD6Gu5fZxqHkKx3NaMpvdL/jnLzA3NQkzX6RZLKjLkJp/MRMngJc8U+lR9hpGEE=
X-Gm-Gg: AYBFou2u84f7gEaZVAp3Ux/2avjOrlLfxi9g+TqXpVw7/R7+7p7GiZOlIwr4XaE+DUz
	zthTrX605xXVZdkpMNisPJtmiCHn4KpyTohqAkferT69E6qjKZO1N96E1jlrpWH1zI1VV4DCmrL
	spGIZdEgSbfYs2eTXkw+79VedXOjqVJCbTZAGqM4pXwdmu4R349mUsODTooveOVeRIPF8YiBGkq
	pLWXwidjViQfudqkpQgKUcEo5Z2bk5t8Kt/M70RrAIJLfkkh2SfouUXFCywqAricmJ3ul/UK3ip
	PYIEk04MsFMrFLC8NHDEBAnRhtvs4/gj3sGo52eIqGm4t0taRLBkVQWATB8O7uICDYAKav4H/Cy
	fxXZsFTNETTMn/mR9P+f92WPeFPjsb7Zqr1BYrkC9tqkJXqLPdM8n4bbIIhkqwiIaZEmMNHVdZ8
	SmrL1k39GslKGvaLAGXVnAAsVfHc6E0U5GL7xY4FpvPDKmT4CUYeUaPrJqVwPzJKREL/Hhr+f7c
	kjmryyXQhRROJuf
X-Received: by 2002:a17:902:cf4b:b0:2df:a803:efaf with SMTP id d9443c01a7336-2e842bbf513mr158788985ad.23.1792039960654;
        Wed, 14 Oct 2026 21:52:40 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e962a4dfbbsm1615915ad.58.2026.10.14.21.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 21:52:40 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v9 8/9] scsi: mvumi: stamp a consumed outbound list entry out of range
Date: Thu, 15 Oct 2026 13:52:12 +0900
Message-ID: <20261015045213.3975845-9-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015045213.3975845-1-yhlee@isslab.korea.ac.kr>
References: <20261015045213.3975845-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mvumi_receive_ob_list_entry() copies a completion out of the outbound
list and then writes 0xff over the tag, so that the entry is rejected if
the firmware's copy pointer brings the driver back to it.  The comment
right above the checks says why that can happen: "Copy pointer may point
to entry in outbound list before entry has valid data".

Nothing ever compares a tag against 0xff.  The only test for a usable
entry is

	tag >= mhba->tag_pool.size

and tag_pool.size is mhba->max_io, which the firmware supplies in the u16
max_io_support.  As soon as the firmware asks for more than 255 commands,
0xff is a tag in range and tag_cmd[255] can hold a live command, so a
stale consumed entry is no longer turned away by its tag.

What happens next depends on the controller.  Where request_id_enabled is
set, mvumi_check_ob_frame() still compares the request_id left in the
entry and rejects the frame.  Where it is not set, and the MV9580 case in
mvumi_init_fw() never sets it, that comparison is skipped, so the entry
passes, is copied, and completes whichever command owns tag 255 with the
bytes of an older completion.

The tag field is a u16 and tag_pool.size is an unsigned short, so 0xffff
is >= every value the bound can take and is never a valid tag.  Stamp
that instead.  The store is the same width it was.

Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/mvumi.c | 2 +-
 drivers/scsi/mvumi.h | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 133e53bc2cb37..994c04902fa12 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -562,7 +562,7 @@ static void mvumi_receive_ob_list_entry(struct mvumi_hba *mhba)
 		}
 
 		memcpy(ob_data->data, p_outb_frame, mhba->ob_max_size);
-		p_outb_frame->tag = 0xff;
+		p_outb_frame->tag = MVUMI_TAG_CONSUMED;
 
 		list_add_tail(&ob_data->list, &mhba->free_ob_list);
 	}
diff --git a/drivers/scsi/mvumi.h b/drivers/scsi/mvumi.h
index 3fc76addbf304..d998c65c26472 100644
--- a/drivers/scsi/mvumi.h
+++ b/drivers/scsi/mvumi.h
@@ -133,6 +133,12 @@ enum {
  */
 #define MVUMI_MAX_TARGET_ID		255
 
+/*
+ * Stamped into a consumed outbound list entry.  A valid tag is below
+ * tag_pool.size, which is a u16, so the largest u16 is never one.
+ */
+#define MVUMI_TAG_CONSUMED		0xffff
+
 #define DEVICE_OFFLINE	0
 #define DEVICE_ONLINE	1
 
-- 
2.43.0

