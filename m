Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4020C19AD90
	for <linux-scsi@vger.kernel.org>; Fri,  7 Jun 2024 17:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717783069; cv=none; b=QAo5VsvSALYkkS29/MtF4pXFNAENwZ8NJWI0JQ1fiQ+SxBC36FRPCpkbyg3psa9t7WUEK1SMT4ykcESpIPxLI5q2LhOgn+51N5flUjDlJRlBh3mTekaGUgJJrzL7HbCmjRURSOltWhSJ0T8y0qq7ULNTbBWhEKkLsPgSItkSwdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717783069; c=relaxed/simple;
	bh=8M5R5sbddtd+EtOHByWpR1T0myw7qJde+U5UKaenM9s=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=P+Hbx7WEQ+2dY62BZ11AGDPBDfc9QW+3LrGoL7he5exg0893XnE9d9hhpyFNY1mGBCrRyX98uuwAJjkwnsNozSmnejV2GccxOEafzkpEj90wjd07z/+0+JHaXHYEdEpP5c8Hfi3BZyKGC7ergKMD7povGTfzHECnXCoFqORvBow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L9kqaOdM; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L9kqaOdM"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70258e95605so1810457b3a.0
        for <linux-scsi@vger.kernel.org>; Fri, 07 Jun 2024 10:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717783067; x=1718387867; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ESs0u2tV++sCsmPbje03XNCRerEoVavzKTKXXHcLNgU=;
        b=L9kqaOdMw1RgLaYnAQ/hRl/OmH8C4isF3VQubDYFt0uxBtZ8z80BytDkFKg4ihdIqD
         ION1r2imrpgHQpmILuWxAKVT4QVli08iQngYq4u1IyzfxmXCAUnCzhYE89RoiONn5GnZ
         gF/WP6/ix9AQoNuj1Y/q2WvS1CpoTl/g1XSBhLANgEoLiJI1ncCntQF5Tb7ieqJgCB9A
         iw2SvYOZv5CfNsjiL8bxdvpUBIdsQhXFyda+qYDFVLhVCauLhUc+thnSvLIMCpCA47dt
         IESK4DpXxJnyaeQxiRX46or+Kv1nsuXdYFvBxguWYuIfaoydLfC3Tcb/Qc4kM5wlYuU0
         wiCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717783067; x=1718387867;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ESs0u2tV++sCsmPbje03XNCRerEoVavzKTKXXHcLNgU=;
        b=hepCHmMcRxm3BuLS3kRmbbGfQ9b6RjFxPzwjoll1GA0zOiaa2nDbUQzFT2WB8o3567
         yEeK9WCawM7XOstQ2WYkY978nFSI6UNF5DeA+YiajYa7DSKEA8v84ZKOvUMy+LztghZ7
         ypBDYY50pVR1vSBNuyLzJgrziKEeqau5dbpO/FdtZa4ZiolYYWPHTQMqJknlkhyAdvZw
         gRdOaZsgU27uX9+op7mOjR9xQ2/2AVpY2IwKnH4qTwGd95FJcefPWo5xB3V5moD6LXdn
         APWfW9oovIpMBxdyGkvh3Y+6JuwLAc9EuWpa8pIGaIHRTI3hvbjnqXPY4w1mR+tZeNJl
         mZGA==
X-Gm-Message-State: AOJu0YxnGeWpFG0SGIgznp5u1Ug2dS/lFYWO5LuQRPSdA0kHMQBRicv8
	rvCzfvzKADV8Lg68LsvZWH1Qv2AqawtngT6vo37KiN4RyQbNBVB2PfltzJ1vETMb1BncE76j1ic
	XqgpEUhQrgw==
X-Google-Smtp-Source: AGHT+IHrD7lGtUhyWnPgie2iMfmsGFX6Ir3Nqf3BVkCOrhxNuWKJNoWk3xiQ53pt5TEKfPDDHGYsDCIlWh2mng==
X-Received: from tadamsjr.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:177c])
 (user=tadamsjr job=sendgmr) by 2002:a05:6a00:92a9:b0:6f3:8489:90c4 with SMTP
 id d2e1a72fcca58-7040c741e69mr9712b3a.3.1717783067393; Fri, 07 Jun 2024
 10:57:47 -0700 (PDT)
Date: Fri,  7 Jun 2024 17:57:40 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240607175743.3986625-1-tadamsjr@google.com>
Subject: [RESEND][PATCH 0/3] small pm80xx driver fixes
From: TJ Adams <tadamsjr@google.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Igor Pylypiv <ipylypiv@google.com>, TJ Adams <tadamsjr@google.com>
Content-Type: text/plain; charset="UTF-8"

These are 3 small patches to prevent a kernel crash, prevent ncq from
being turned off accidentally, and change some logs' levels. Resending
because I missed some recipients the first time.

Igor Pylypiv (2):
  scsi: pm80xx: Set phy->enable_completion only when we wait for it
  scsi: pm80xx: Do not issue hard reset before NCQ EH

Terrence Adams (1):
  scsi: pm8001: Update log level when reading config table

 drivers/scsi/pm8001/pm8001_hwi.c | 11 +++++++++++
 drivers/scsi/pm8001/pm8001_sas.c |  4 +++-
 drivers/scsi/pm8001/pm80xx_hwi.c |  6 +++---
 3 files changed, 17 insertions(+), 4 deletions(-)

-- 
2.45.2.505.gda0bf45e8d-goog

