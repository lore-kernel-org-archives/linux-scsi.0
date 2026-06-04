Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DAE47D959
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2026 13:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780579200; cv=none; b=CFH4qbugxGgQH47xua+iiSaQ5m1cgenIMvWzQxb0sQzn0HK6tPG+fL798R+3qyAG/k2PTlc2TK8e1TSnk43y4AWP/z0HyjhaUO5VDTANPcR+MbBClk8fPsnuGLF4oxp3qst/Vl826G7T41qD2Y7DQ8hfuKRmB0hQulWNHz0CWHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780579200; c=relaxed/simple;
	bh=9eVs5ZEWu5PvYIeNWvEPYnAIntZhT6pYVPj8oRQzPMQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Xp5+Bl9dwdwy2QL4s/A6IK6XrEOJSQsVCA1iCDJoHdycwksIT5Bb7K5B5oMueL4FhlANIiB2oEyzlng++QGNk7r5+YX9+tRvuqBWWUU2IGnfoXJBY2fUE1oZIqxPcL3r3qC/pm0CPS4zuVws2choLRPOTdWb8HF2v/ombQfVXeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mpZ3l25S; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mpZ3l25S"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490b3637b90so6593025e9.3
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2026 06:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780579193; x=1781183993; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aaZcDuR1/GVoL4knmseDPUzz2J8S5y/tkogd7uxcn0M=;
        b=mpZ3l25SQenUDvGZoaVJnEVxe1HXEkFpGlBhLdeOckjQjtO/yH+NAuqA2SLfFJetF/
         ZyV2JCse2h7PtuwvqwcegCR6ZJxJHTSRACPG53tdpFoPHfPDja/mt2JhBUmQqkEOu57D
         CjV8usPRapvIKuOdiiOoj77OOl2JHfNJOOGZe5ba9Dp8rI58KP1ibBxgzWW0SYp+en+q
         Z1Nhq9YqFJWmXE0Mcb8LErX+EKAxZSz/8uMOzjPVwf+Xx5m4WkzCtXHIag9xR+50hHxZ
         zU3f7CLKizV6i6r0lqWN9tJUEPS/iMAK1dqqyzhsZT972JyNStQUEMtzRVjsTKxXbUfs
         pjEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780579193; x=1781183993;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aaZcDuR1/GVoL4knmseDPUzz2J8S5y/tkogd7uxcn0M=;
        b=Bh6ZXXuZ5wrwH9JFyzD0Gc0EX194R1zxR1sjTxdlLXnO0X4nCAr5q7gGr+LE3cIBSe
         J/jUoXVKxY1xTdc2Hto0xrAhnq34ykgwlsnrkRfeDVcy+NVcUh9IU+jMJRNt/5GKpNVj
         1yDKQ1DIqr+4whGmX/2QzV3wpSb6TJUeHSKKxXtcEgKJmSvQC7tOgVOnKcuXewL1SubI
         ahMUSHTlxPEEb5+zT2V0s6YjHUiqKATrVE6w1iNE5oK7slNdOyXw/OSUKfqz8l9oUffq
         oPftz2OcBlWpLsGKAAkSbnMtiaiq96FFEXL7jk8ciwoBIxquJshOazwHDmLVU6NPi0tw
         ZWIw==
X-Forwarded-Encrypted: i=1; AFNElJ+SNjEWsmCV1SNmu7BC+bgQHzg8tn36rvxDVYkCpoAzwazFeT/3XlMW35w+O3fz0IDSgOIjgG4NOA67@vger.kernel.org
X-Gm-Message-State: AOJu0YyNHs5oHe/yIPZWo4rylHdKu6R2A7tFBTIfYufQYh9JgZnc9rrM
	lIZA+hjj5IEGPlpQsKsp2YCp9iqKNRZeXWGphmdgonTkj6G55rl0XfXF
X-Gm-Gg: Acq92OFFJcnZAB8L0HSMCl2fAqn/ikM6nP1jWisReXhBelTf0ZNYURKOAqS419Pk7Hn
	lDSu02YNzzfOvJp96hZ2J3khzcMLW8G/MXTSpwAK4/qYW1PJ+983oWYFRkxocLhYN2d7p2W98cK
	Ui5EPzA4BV0/ZwhlI/IY2MekmhnF0IbNzKo4vSAZ3lX5oOqEITbxrC9MyID+rD+V2MnXUkN6zQq
	NYuxh/VkKVi1l/F/3gX/Q32xgSLQqiPPGYP8xvIMgvOW62Wm7DI318LRBKSBRIHpY8h+9wTf7ap
	JrKgDS+lEGc+S7dqRPajVtH0l5/d4hWRT4/Dag7OutPNdpj1Y4qLC8jFkC+6KE2xZVgHokhZ6In
	B8aTGnZ3bjsF8IML5+/ydVF52VPJgnIc9nQS5Oo8bDeZnMJtr+PXQ5jHdBEwX0WVhkYl00hZtnF
	Lom1KQpG9FPdBKAaBasEggd9BwGpF099uf
X-Received: by 2002:a05:600c:a09:b0:490:958f:2a5c with SMTP id 5b1f17b1804b1-490b5ed6375mr133235845e9.17.1780579192962;
        Thu, 04 Jun 2026 06:19:52 -0700 (PDT)
Received: from localhost ([94.53.77.213])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490b7a52dacsm7715545e9.1.2026.06.04.06.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 06:19:52 -0700 (PDT)
From: Catalin Iacob <iacobcatalin@gmail.com>
Date: Thu, 04 Jun 2026 16:20:25 +0300
Subject: [PATCH v3 2/6] scsi: core: Move scsi_device_from_queue() to
 scsi_priv.h
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260604-remove-pktcdvd-references-v3-2-e2f06fb4eef4@gmail.com>
References: <20260604-remove-pktcdvd-references-v3-0-e2f06fb4eef4@gmail.com>
In-Reply-To: <20260604-remove-pktcdvd-references-v3-0-e2f06fb4eef4@gmail.com>
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
 Jens Axboe <axboe@kernel.dk>, Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org, 
 sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org, 
 Catalin Iacob <iacobcatalin@gmail.com>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1518;
 i=iacobcatalin@gmail.com; h=from:subject:message-id;
 bh=9eVs5ZEWu5PvYIeNWvEPYnAIntZhT6pYVPj8oRQzPMQ=;
 b=owGbwMvMwCX261qtXAKXKjvjabUkhizF6vU3LqT3G94r9cqys+vtuZina/9q/t07UmFefy8un
 b3PXWxjRykLgxgXg6yYIsuLc9fbNuw5E3Avya4FZg4rE8gQBi5OAZiI+zSGf0qLXDQLS2uXPT03
 Kf2kWOsWYcVL01cdWXVcSm7NuVPX+4MZGWZd0Pu7+WuqS5Kxo3SX/azfa+t/Oh0x/i7Au8Di5/Q
 djEwA
X-Developer-Key: i=iacobcatalin@gmail.com; a=openpgp;
 fpr=F609BFABD84EB5C9DDDC37EDE89C6A3571CD0E33

scsi_device_from_queue() is only referenced in drivers/scsi so move its
prototype to drivers/scsi/scsi_priv.h.

Signed-off-by: Catalin Iacob <iacobcatalin@gmail.com>
---
 drivers/scsi/scsi_priv.h   | 1 +
 include/scsi/scsi_device.h | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

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

