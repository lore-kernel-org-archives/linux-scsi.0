Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4994EA380
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 17:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790618108; cv=none; b=Tm1Aia5w8oXAzDoszmqSk+trKXRVJiE5ma87arvMJQ8qeDzOE0l78ycyyFc4T8JiUXMR+++4llqJUHdxIdTrBR0MbBs8p14LkRux1C7+AXAnSUvaaiNj8ZWIHNurSGNvyOygP7QNcTDNa6E5TRV1V24AsSuHKTtdDLrb2j58N04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790618108; c=relaxed/simple;
	bh=tER6xlnK90r8Qab1VZSZ1fLyySMbxeBEh1Ay11tOetw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=laUsiWryZpNiacwyYOQjee0U907t6dTozsRd0nooEensSa09zcRMotJWsAgjDz9NiDgHUD2+uFaqh8T4Wz0tUoUtaFI/LVxakLyC6hNk0SGny42JKk1QcWnLAL/hiF1xE1K7boAKO3NNp5bUEXQCgiEalcx7UmDOBwsnRUlM1Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fhgn2w5w; arc=none smtp.client-ip=74.125.229.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fhgn2w5w"
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-34ac03639e7so230782eec.3
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 10:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790618105; x=1791222905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WwBaVdVJ59R0rXXR591zjvN6CoT6wXS7+liHv+BZRLY=;
        b=fhgn2w5w9QdURXrhAugdL4A1U8pknUec8bBc+pd4fcW/thvn/qxLfhKqarF90/6Hiu
         +zKHKYISIZELQgiwo2QtfX4BGP27KLPlgdw1v3YJwRPVBKM3Q01U9xctikAO+/TsNyfe
         wonHxgEjjtfOTXen/XQtFGQRq95VkvR0VxE0CgjWwHEiQ07b3MqtdZnfxJhEZG8WlI5N
         iAzfLgtfjyjPazPHVqa8y4w6fUQZi6Mh2M4XLdpOo/OfdKL4nyajEukdlJcuzD5vhXbr
         S8+R1YPWBPpyLuMCpsXvMFTTnMR8gvqHam6mj36S5kub6F1Q0RKxcQjf3WTZx+llKikL
         PCzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790618105; x=1791222905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WwBaVdVJ59R0rXXR591zjvN6CoT6wXS7+liHv+BZRLY=;
        b=nPq19WUiGyxJ8bXrLVHa0w+TFmO1obZVu3ZmK/wqH5mb6CvAMY18NBxEs1DnBUCMfM
         uVbUu3Th3h7GAOk5IVzvQtM9lgMsXO9wx3kS5CGkpap0u6N+UAj2KSUOAjHq2/yldmCq
         cd+309TPYKVxQSNHf5BLjFdwbpz6N8v/bQdiDB4LfwbkENC0196E1IcjSXb4Z1aJADAe
         l8GvuNtuWNdyf5bOF8sjFlQQTWtlyBCjxyfJluYgN6B7SGTjicl+NwLVTrucfaRleqn/
         Lp8aWT7ubWGQyPHVLEV3FwyFK05m4xUPiEfqam7wHx35Gaum+mOWlYkpFevTzjWdHsjt
         RhLA==
X-Gm-Message-State: AFq9FYLDzCXDOaJMVxLZjaWWp9ASwkbO+yCSqL25XvoY2LPHILyWXqV+
	nfW5vvJg60c6WBqsA1irk5M0YVqPFbjCKnoebGLcyThaCgnOvZ7FOyJocLV3XHyb
X-Gm-Gg: AYBFou3NrwaOUqKa5SsojIeA0eDdmUAfkbJdAlZPMDwvZrTIULFjEywYEvkOQvLwZt2
	98ZTfXGTgFzjVHBwzsXr7FD3MDBvADZZP+Fx8Tr9UM/msG8o7yD+aMf0r6kWFMXM04N1cHLUoD+
	SK/dTYJsZMcf4isnZaNdjiL2Z9lVk7IUaXi59xmH5kikkkxM9H2OY0Po/bIjME66UzBkZ3iZSQ2
	lhg2Vw4/PxzAVGrk4V1+W4UmhAsPt9nEZ4W7+REg/gyvnZYRw5+flrWI9Z3+J1ZXVQojmzDVmQy
	8xo9279SDC5HSyyFAryRkuCEteefRG+8o1pKC9p33F8jq9ix+7Ych3OSze0ETjUqOvCoKtwIyt8
	MSA+K9ecIifthJc3NZrTqnEhslxRQ2s+TRhRygyEElh04RYQ08Z9FlbGUlDzHIYl3q7M1/RSFxV
	J/vLaaDnzmmEFHcJ/rSOFUGVlrLWm5FgpN+xJNtctIdxEnUAK76UoQknn4eZKMl2m5+ppSPA4uH
	n/mMmlhU4Olwix8y99PYcWz0koSGjKquLayr6yIe72NcPmnbYHDdWfG/w==
X-Received: by 2002:a05:7301:78c6:b0:33b:edf8:1919 with SMTP id 5a478bee46e88-342707b407dmr10993782eec.13.1790618105487;
        Mon, 28 Sep 2026 10:55:05 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-342c9c245a7sm21189418eec.11.2026.09.28.10.55.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2026 10:55:05 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v5 10/10] lpfc: Update lpfc version to 15.0.0.1
Date: Mon, 28 Sep 2026 11:17:57 -0700
Message-Id: <20260928181757.21959-11-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260928181757.21959-1-nkirkland2304@gmail.com>
References: <20260928181757.21959-1-nkirkland2304@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc version to 15.0.0.1

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index d6e6e436fbfc..7df63d118234 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "15.0.0.0"
+#define LPFC_DRIVER_VERSION "15.0.0.1"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

