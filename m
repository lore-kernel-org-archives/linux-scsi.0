Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82852198E86
	for <linux-scsi@vger.kernel.org>; Fri,  7 Jun 2024 17:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717780014; cv=none; b=t8kJCYozTshczZzuht63rIFkhPQmY/wZxuXIttrt7pIQ/u332wRjqcPRrQqEjTaJ6pFdwcjVFF9W1J7OKMTxdN8NSDjvztkjlKpjHVj9At27XEQ2h3xj2zOTzj0Ww9ROuBGL+YyfnFNucy4TtUYt4h+k9i5x5wH/QWyN3AsZlOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717780014; c=relaxed/simple;
	bh=kceaFwwjaSlBmkhXtusA3USI+23jbBoLODkMZKgX7RE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U0aPT7uA1CpUg+SetFfNQSuskPQMta4Nn4nTd/lB9fJmzdibUGsamWJGUSs5xX+QnWmffUYuFOBzNHRscbMDVDEJYvZW0dRNT1ACIV7pmDJUYLHFYt2BdGu5nAw5tYbTqIAuX1mOOiQQa7TmEFwm7DCM6xYE2Mat7cADiOoapbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mdlzbKav; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mdlzbKav"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-df78ea30f83so3930331276.1
        for <linux-scsi@vger.kernel.org>; Fri, 07 Jun 2024 10:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717780011; x=1718384811; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=68M9FutlL8cAjPUlj6bX6OztbAKg98sW3h68noYav98=;
        b=mdlzbKavxpchLMVgpDhuCEf3Vw3rlSScTo8AR1cOVKYWhSoKCO8sd1kG4o8hKM38zB
         WFRkkDmd1o8AwrwTfIuGkXc9FQSwyrOOogNqgbu28H4W3VbF76zc2heqBRMBfduoKvot
         dbtDXDJZwASVfMJmv3sF6YXmqJvKtED6jYsPsGucDd0eqEK0NMs9WE3OatNcUj3nX1FC
         qIbD8iKkukRA9WwFyzUhLaH8AGbDvPae6o4WB1sFyq0InGkqpTD7ifTfN7i5AGDtnqwz
         4HaVqIMa0IMWTf6dYINYbIt19d6TC0jAR6RWfHgXYNBwAfVQGIUqrkB2Xh5oS3CTZUJx
         Colw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717780011; x=1718384811;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=68M9FutlL8cAjPUlj6bX6OztbAKg98sW3h68noYav98=;
        b=Tib59SI70cb/BHNrKptr2E1zNI+2urdz2AHF6LRyxzkHKGF3ddnvBdmMgzycu9/y9+
         rG0R/hW2YgH69dQ0F8xVnNNQtjJJP+Cq6s8WGzii6/lIGweYdDej2VYOcLbitivXnE2/
         eETWcW2KVKUhYx29cDPENH4t0vih0tzXrm5aK+7ARJmFevRulln6mKkGSAry5D5JboWH
         YhU3m/7RFMNP+qR9vIoOjZMlR7D0vU/DWzlsm3tCxO6zPIj0HhfRr7I2nCNCtBH++FNv
         FkCocxOfr4bFX2Sw8ZgY6hyZ+s8RYEiBzBYhAJgAE5oN3csrZSLBWJ0WfFMTL3bb6pNS
         v/aQ==
X-Gm-Message-State: AOJu0YzodUlN8K3fjHL+JE0wiyxQmpAyWunmzL7m3t/b55Yg78Pgt2zC
	TqJNv2Cmj/8utRx4iwAiYhUEbUsEFVYRHKN828FRLYO4nbFX6cLYzvrwZaZ+xNdvm5BJhQF7Iwh
	4AuPAgMeVKw==
X-Google-Smtp-Source: AGHT+IFT5aEoM2VyFyvMEdDzIdkli7oOXjB1ywaBH9N15G5CUpvbx40Ae/EvDQg+bdLIXR18sBr4Kj91Gu9sMQ==
X-Received: from tadamsjr.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:177c])
 (user=tadamsjr job=sendgmr) by 2002:a05:6902:1209:b0:dfa:ff27:db9 with SMTP
 id 3f1490d57ef6-dfaff2712cdmr498457276.5.1717780011508; Fri, 07 Jun 2024
 10:06:51 -0700 (PDT)
Date: Fri,  7 Jun 2024 17:06:37 +0000
In-Reply-To: <20240607170639.3973949-1-tadamsjr@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240607170639.3973949-1-tadamsjr@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240607170639.3973949-2-tadamsjr@google.com>
Subject: [PATCH 1/3] scsi: pm80xx: Set phy->enable_completion only when we
 wait for it
From: TJ Adams <tadamsjr@google.com>
To: jinpu.wang@cloud.ionos.com
Cc: linux-scsi@vger.kernel.org, ipylypiv@google.com, 
	Terrence Adams <tadamsjr@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Igor Pylypiv <ipylypiv@google.com>

pm8001_phy_control() populates the enable_completion pointer with a
stack address, sends a PHY_LINK_RESET / PHY_HARD_RESET, waits 300 ms,
and returns. The problem arises when a phy control response comes late.
After 300 ms the pm8001_phy_control() function returns and the passed
enable_completion stack address is no longer valid. Late phy control
response invokes complete() on a dangling enable_completion pointer
which leads to a kernel crash.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Terrence Adams <tadamsjr@google.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index a5a31dfa4512..ee2da8e49d4c 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -166,7 +166,6 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 	unsigned long flags;
 	pm8001_ha = sas_phy->ha->lldd_ha;
 	phy = &pm8001_ha->phy[phy_id];
-	pm8001_ha->phy[phy_id].enable_completion = &completion;
 
 	if (PM8001_CHIP_DISP->fatal_errors(pm8001_ha)) {
 		/*
@@ -190,6 +189,7 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 				rates->maximum_linkrate;
 		}
 		if (pm8001_ha->phy[phy_id].phy_state ==  PHY_LINK_DISABLE) {
+			pm8001_ha->phy[phy_id].enable_completion = &completion;
 			PM8001_CHIP_DISP->phy_start_req(pm8001_ha, phy_id);
 			wait_for_completion(&completion);
 		}
@@ -198,6 +198,7 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 		break;
 	case PHY_FUNC_HARD_RESET:
 		if (pm8001_ha->phy[phy_id].phy_state == PHY_LINK_DISABLE) {
+			pm8001_ha->phy[phy_id].enable_completion = &completion;
 			PM8001_CHIP_DISP->phy_start_req(pm8001_ha, phy_id);
 			wait_for_completion(&completion);
 		}
@@ -206,6 +207,7 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 		break;
 	case PHY_FUNC_LINK_RESET:
 		if (pm8001_ha->phy[phy_id].phy_state == PHY_LINK_DISABLE) {
+			pm8001_ha->phy[phy_id].enable_completion = &completion;
 			PM8001_CHIP_DISP->phy_start_req(pm8001_ha, phy_id);
 			wait_for_completion(&completion);
 		}
-- 
2.45.2.505.gda0bf45e8d-goog

