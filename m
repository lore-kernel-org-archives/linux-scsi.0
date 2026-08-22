Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C1519EED3
	for <linux-scsi@vger.kernel.org>; Sat, 22 Aug 2026 01:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787362893; cv=none; b=dgIF3RxYywkyr8d4NleM8U60g7hwpyvlC5A5q4gH1jb5X7Y/Dbc3VmyOeN+0hS7dYpgDat9+hNaKqVIKbw6tClwmwcZqV+UBWlg36yzbcgnUD6yTQSvFmFUROcbKI6iqh+nwFm8PjcuOw5pbb5reM/6KvagXIFwyhZM7GqbXyIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787362893; c=relaxed/simple;
	bh=hl71V9pAssx/PVi3zEeEUgZI5ItF07mZ39vu/h302bE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0Mq3NmCwmdS1SravDNOfzmJhWPNZqHM7AW+WfQbZcSw3hX61XaYY5ieUfpA7gX0ZfYdNV1v+f5yIrt9hODbIk4DXRDTaMgdJTim2iux3T4Ai3BjIaF75Rx9l+1NGzxClxy9qM1YcRv+ISp1JrW0wUA2HSqdTbgqetxyctyA2qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=KnRuPBzh; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="KnRuPBzh"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cab973140bso21642845ad.3
        for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 18:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1787362889; x=1787967689; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z3hh2NuhHTLfciNzfEcGGyc+D6Tdw4wKuEkikFppNIQ=;
        b=KnRuPBzhVQzfY1w2k5kSl+CGidZmCglPmMgn4ME+f+ttBE463TAWdHr1lmaDwXq4Sz
         HK9NfgGQ3Wfi3uh9GOJ2tBeYjPDbJZXOtxbc3dDzESTOqM8r4jPUH58+/X9EZ+N99rCo
         wZn7sfEaTjSg+xOb2+/0QHKlZS8gFBAIg/aHz06AWksWtUt6HWqClS8i7oWsd048UP8U
         fUjuPJn0IXZ9xYwKJUBvUYSdF0h1kq0bQoIGCqzjMTeA9jblTy7DBHjlMSViE/oJI2iw
         7KqJbac6FVLdSPlinakMOmvr6FOGX7hjb1YHynlKN9GcAznEJJh6CjWsKbxmsArGsrzB
         NMSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787362889; x=1787967689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z3hh2NuhHTLfciNzfEcGGyc+D6Tdw4wKuEkikFppNIQ=;
        b=UD02TRQtDdBeUavgkDWUx1X6Zskc5ktfOK7ATWHk63HwJoDJcM08F/9+cKT+5MBqIF
         jimVKegysV6PWioHTqpz/zVmTcJxthFrSq/KUKPpCPo5CG7RT3uBNDx+iRylpmPWrAs8
         uWLA0jlfl8MGwYs+yTNyYAMpIYm4LmsEprRAt93PpFefAtabmZNrwGYiiLxVlirZybs5
         nDdyFYUDQO3ZZsGkjUmcijWTivjYaCDxPj3T7Q/DKPToPPN8vD/ozYFjAJV6hXV41YQd
         DHjsCK2IL7AdPcGYTz1m0dLI1weQlCc8NK9SSvUER+BLv1AzVveiIDZCdsWMs65hJ+bm
         Db6w==
X-Forwarded-Encrypted: i=1; AHgh+RrgVUPdldIBOH72cidMdwsdF/wrIIchkFTLhiUJVe150ax+j0gfZIwxeAjN7Se4K5WG8vdbWmWvVB0z@vger.kernel.org
X-Gm-Message-State: AFuF++mXlDXhPEPY3AIG6PFGav43v+kvYZZND05/wLRegEaXn/6HJYPS
	ZSJO6vEeM3YCZX0qwVqiJYNTZwZCkkLALfis6+S/5qTJB6twoPH4WF7jecEfXaOCW0KBKqUCjay
	1gWgG
X-Gm-Gg: AR+sD10ZGIEMdgyS+wlOvWahJSjH6M4LVZ+rIMguyFm9ikePHEj/5wBhhpFjhqPlhgv
	M/FxXbMdKhPIasqNKm1rvK0Y9j7/2iD8RBeNSoAS5XgoyZnd+h1Bt5PIvA/HHGtJiVoWAg7T3+U
	jBRwENSQGoVfIAJYRBr8saAy+mdii7ow/wxOl169O1aiCjMtkZOA5V8x10KtOmD8jcsunj2afZb
	Wp+m2zmlPDYFShRuHaKpDX2sgC0Qrl02UeIktiBeS3FVcqmibQWbDGUdefonmplIjCrKRoEntEr
	xILCO3iTuPeJ6v6ioXBT8Ss8zMP2uedDdB5htvBY4C0RcJiIXUWnZKEK6j+202Z8HxSNqaAL/pQ
	wuF29+6k+iOe4iBKuxC8FTrEqxRUi7GJ/pXBS/VKlh10ynyveaB1sfmMQAnEJwKsOcjV41vZK2q
	HbDqa1bKhXYb1UK2P5uNpWR4Mwo/aYQ0td2WgxjIHW/BTaP7BSM3BR/7BxUTOEqL3WnxoK15+tx
	CpO6w5vQo8=
X-Received: by 2002:a17:90b:1d50:b0:38f:dec8:f7e9 with SMTP id 98e67ed59e1d1-395df29b3c5mr5129435a91.12.1787362889294;
        Fri, 21 Aug 2026 18:41:29 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:a627:8da3:af81:18cc])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395e4968618sm1055793a91.3.2026.08.21.18.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 18:41:28 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: michael.christie@oracle.com
Cc: lduncan@suse.com,
	cleech@redhat.com,
	martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: libiscsi_tcp: check the data direction of a Data-In PDU
Date: Sat, 22 Aug 2026 10:41:20 +0900
Message-ID: <20260822014120.1978945-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260801133635.1986706-1-yhlee@isslab.korea.ac.kr>
References: <20260801133635.1986706-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mike, could you take a look at this one when the merge window is over?
It has had no comments in three weeks.

One thing I should have written under the --- : there is no Fixes: tag
because the check has never been there.  iscsi_tcp.c had the same shape
before a081c13e39b5 ("[SCSI] iscsi_tcp: split module into lib and lld").
Happy to send a v2 that says so.  I kept the Cc: stable because a target
can silently corrupt a write on any tree back to 2008 - pwrite() returns
the full count and nothing is logged; tell me if you disagree.

Best regards,

Yehyeong Lee
