Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD30347C7
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2026 18:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780599050; cv=none; b=gvYGSGCk74gFgTc8EVz43B56Jb5X3gGar/hDxkUzJfbzOxjw+QLrQiRUDyTI7/OplbkZlhEroZCXUNWrfBTcS3FCLOebyLC2LG+25sXFDSC5V+ltxOE+a3lYkN0WbLfPhGHSEZxvNO0O/AIri5uqpd6QVGaqMRBBtccCTWwhxnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780599050; c=relaxed/simple;
	bh=+3m0JMdiXpuvCHnm1FRh68WRusl50l4Rbyh/OO5Hrs8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hh+wrmaKbnabb4LQm6l/abcD7wqfg3EUaFJ1/mWL3SWOf3SQlYfJTvilv6v/pj4qw+pCtw12Ophkp9He9ra8Jl7JW+/gRKkUqrBiPzGzTO2QRpMFIdFem7VUKCEmNP7n8NrNQBuwXYu4Zz2TyrzmFsi3YqJApJ9vYtwCVZG9x2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TqanoA+g; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TqanoA+g"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-91591f19716so139096885a.3
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2026 11:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780599048; x=1781203848; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4r68B/dC8VXpyqdhvL5gBI3YcpNd9ejYho5aID98pyU=;
        b=TqanoA+gJJWr4lxYJ79Hcjo2LBpgWEhe9S2B764F3VLc0oZyzRMfQmWgte4LWDm3Gv
         Vff3aAaR3MaNpOb/o3s4sdg+WKy7ED4r4pg3En6XO53cYuGth6K95UnYJN+n9bISEIu+
         0cwQ59SW6N//nHY3BfHXHmHhK0s5z0/1X8OEtvt7R3KHbq2pV/4IOSFy16vZYvtNhG30
         pDx8BG4jCjEmTUqvfkxmVDp1tEf3gaPZieSx5CrscBJT/AR9NmAQs3Cs51AiwYLf6pFK
         CCk4Z+aTyF75cFCyipkG2mxEW1lxS1NzvCP89dCH7A388hGOwczkQJJGtZTgQwCXQ7dh
         MVCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780599048; x=1781203848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4r68B/dC8VXpyqdhvL5gBI3YcpNd9ejYho5aID98pyU=;
        b=IAHg1gOGuxrOEOCVXQDKt7QLIuaZjMW4kYRB+7SiWJECpkeDArwLyvLh9JuwQHIBw2
         JPYINaDyhx8+6/hi8BKQa7IIUhlaeQkM9tozOTphTM1kR6bcdDD+ZpiA3Sz1pISoK4Uf
         kgPPZVt5QkVIZrsfk87ZXyyZekiLZApp7XWK3KDhtHZLUFId9tPEHMRuLefLmTztWdcz
         lWbx0cZQbHzQ88g3C+aSof6uAtsYmjB0XmR/Cjrv52D3aLsdqnQAL5D0Z3+AswZ0jhdj
         2keUvLCnobXi8uhPw4fOSHvF6QmbLEwymb5wm5A42Itphr1rpYvBHQZBaUokeVlakG/v
         3yRQ==
X-Gm-Message-State: AOJu0YzgXe6ZNs3OyrKQB2dCoj6ZfpRW8ozInNn4lb7eBRfOahmJs5A/
	ENEyyikYRJNa8d1CY9aN/jgUbcjPDo2vGsSEIiCxGgPPFbdEfEHA6uuC8spOlWFb
X-Gm-Gg: Acq92OHGdHpBlZ66K+BjDzhfDb+8nMK2fp23GpuHcXoRsXekF/F0MAYpwC4LnQ0cUr+
	4vWo5FQMB+b/F92tXzyDhvBqdbI13gVOwYlbW3JYGaDY4Q0rdFTiaJg9sMXFm5RYvqF3uYhYrbg
	DyJyRkz0xeT8mqKiCRWxkknSjNCPHkEdbclHJFj0Wktco6ofszRG5Bq0ja8X99wn2deIyrnG+Kx
	laOfVT5laUelY2BhqdpPFlm7gm2iwBCkwZmUveBm8xTwoiCY0TlIMUr2fMLA7sPUlDcwVkxOjEw
	BfFHeMbJaqRQWep7aM6nSh/3ZpdaJa6s7XLnGeD+KJEYfe437W+gi/4h4pb735punHgIrjuOiOy
	VszN8P2lgkH6/Ktcm5s7rzeEwwx3sfas5CJCxVQ0uPjyz2O1mi6RhHCYaSVcAnannjpjJekhv5m
	PpUdxCysmsevn43WKXZgztha/aMnK0WFQh6Gf4dm5Mnk95W3hk9diPJnkTgdwwb1dU8oeZDXr73
	ZqC3qw0vnZmzPYapZou8NlnElsI0f63fRpNdrlqowFQ0XgyVskWwQ==
X-Received: by 2002:a05:620a:f0e:b0:915:673a:62eb with SMTP id af79cd13be357-915a9c4b680mr65574285a.2.1780599048594;
        Thu, 04 Jun 2026 11:50:48 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a37cab6sm651208685a.22.2026.06.04.11.50.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jun 2026 11:50:48 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 02/14] lpfc: Early return out of lpfc_els_abort when HBA_SETUP flag is not set
Date: Thu,  4 Jun 2026 12:29:25 -0700
Message-Id: <20260604192937.65605-3-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260604192937.65605-1-justintee8345@gmail.com>
References: <20260604192937.65605-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is possible that a dev_loss_tmo callback fires during an hba reset.
The ELS pring structure is cleared by the hba reset path and the
dev_loss_tmo callback executing lpfc_els_abort could be using a stale ELS
pring pointer.  To prevent such a condition, check if HBA_SETUP flag is set
before proceeding to use the ELS pring pointer in lpfc_els_abort. There is
no point to issue aborts when the sli port is not setup anyways.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 9c449055a55e..2c8d995a45bf 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -227,6 +227,11 @@ lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 	struct lpfc_iocbq *iocb, *next_iocb;
 	int retval = 0;
 
+	/* Exit early to prevent race with queue teardown. */
+	if (unlikely(phba->sli_rev == LPFC_SLI_REV4 &&
+		     !test_bit(HBA_SETUP, &phba->hba_flag)))
+		return;
+
 	pring = lpfc_phba_elsring(phba);
 
 	/* In case of error recovery path, we might have a NULL pring here */
-- 
2.38.0

