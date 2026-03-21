Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832C42D061C
	for <linux-scsi@vger.kernel.org>; Sat, 21 Mar 2026 19:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774120662; cv=none; b=NMzLID9DFaQpXW2KYpF1OmY4huUlSRG/k9i3su389+6LAEs8pOr9mRUOZMmjw29/2bUwLpMgNRW+jV9IWQvgxFcm0Proz1o70eoey4YdEjqzztuttE6dzNlaWvllWOUbeiIqkX2IJYo+Pw5pxWUAd3ldFjY7elr1cowkXkPRKfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774120662; c=relaxed/simple;
	bh=POc99bc0onO/LriOLilIpL/JmvdIXpO6ppQHk5DJ8W4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dm16TEGpAtkws2sd5Q50EFRIESmg75BWcZYZn4TgTLWxnXa2RTit2JorGnhxq6kBtAk1U35c92ZamYR8A5KMSpegFgKhVjEdfHVtOUE0KqqszJek4IGioR5aW4uMJH2nAPfBGHOcpTmQGvhqI1gIj4QzRYRTDVy/fUsXSBeyyiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bD36KBGG; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bD36KBGG"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-824c9da9928so3092199b3a.3
        for <linux-scsi@vger.kernel.org>; Sat, 21 Mar 2026 12:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774120660; x=1774725460; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZUDL8tQntpEJtlGp/phZgHmDE2I3nj2Jugu1QtrQteI=;
        b=bD36KBGGmVlHPBbyuyxHntHmBs+gEex2VyzCOpNiqI/Q+3O7r9xW8uswJLdcJNRQJl
         kepb8Ih4Zn8BYhjcX+/EncNc5xHcbLIor6yEZGYSafEnBMjHBnnY7v1tY7AwSxDkHJIF
         /s3pFu7LHOKDmsmfeHZtsQbpvqWW9wMuZbJJgR4539Ue8a14/5xtHTd9WF047kj4wC8f
         2M1N5QZGa52D3KloToFLVoj2HIO5O7omJjGljs5jHgK2xY1vtPTgl8eIjxpXsfTztIiL
         4RXfMavgPMindncg8zHfX9sq3Ob+YwbUE1U8S9rsOZcVx1Onk1lqASBHGVLoSK1Vcb+k
         ZISA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774120660; x=1774725460;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZUDL8tQntpEJtlGp/phZgHmDE2I3nj2Jugu1QtrQteI=;
        b=lR3HS7kSCOY/VcaJ+LHdTJSlvBPBPmGCEM7o47WBe2OR7GQTLim5P6K/IRFm8DwLUq
         V/K85h37rRsBl3YMhepz3mZRRYVZ/OF9M6Z3abGmrpr5u+J2urAJfPC58d1rGWeeh3xE
         7G/mVkdIlKuEXK2dNMaTQS5HZ4lHfILd/9FBhyymokR5OuB22dVFMOM0b1g3wg9RF0ht
         CdHqWqEDbNf06S+WhbHsoU7ezVaYWN0Nhi7a0+YpUZr6UXDMLCxMNU5qyIgDn26cw/HI
         vyBzlQCEwV5XFpGxKU8U7vmZptK0pz0MANQF9wWs14butRE5a/1rboapRJ9IJgo8OOOn
         chJw==
X-Gm-Message-State: AOJu0Yzd4txI2UFRNi/yZEnNonMnqGvYqt0xo7P2iOkESLajG+twSUe6
	GC77s5f9K/Wd5cdusDF3zQx9zEHJridwxhAsvg0opjBwEkgsZWuC10txTVptrDS0
X-Gm-Gg: ATEYQzzJg0bVMHTh6q46FUOdah5M8u9NASuKBM/9pbPGC2n2X8htfRfBJMkOgdYPvBc
	gIf7h+fzUJKdhOkvxipIlp/kuuCTVremobR9+a31Si2mgv7KkV+4Inud4BJHqq1PkhafyIa4wwd
	bcDXIssNYIsxLqtdFK0SkG3s3xz8e2VIBC0anBwYgXSoYzgcdkU/zCJChhpOXIKklzbsxS2cf3R
	J6MQ1VCUK8hEFXNYTEteiPrmNlEdwD8qQSlhPa2IxtfS4iMVlfih6q5ZAfEFMHV7CPRZrhppAYa
	2UjUP+fNR4sJjvPLIzIeTkvvzlskD+p/xg/pw0aGxaADCRfwQCC/b9ss+FaqLQ/R2DYb+ewyS1D
	m2faBnoK6HVWI8s/SMIsTzhAvGTAelWlDh2QQGhWAM/YdfO2NgWfShNKh1JLeNfh7s+WVdEhI5x
	7SN1/xlU4cRvxzdN2SgHNu1/5OLGs5FccxuqIiQW1Xr2oQkOl2666y8Hs=
X-Received: by 2002:a05:6a20:244b:b0:398:c0ef:e15a with SMTP id adf61e73a8af0-39bce97befdmr6563727637.13.1774120660524;
        Sat, 21 Mar 2026 12:17:40 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d::8bd])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c74443cc9edsm4319968a12.23.2026.03.21.12.17.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 12:17:39 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kernel@vger.kernel.org (open list),
	linux-hardening@vger.kernel.org (open list:KERNEL HARDENING (not covered by other areas):Keyword:\b__counted_by(_le|_be)?\b)
Subject: [PATCH 0/2] scsi: be2iscsi: kzalloc + kcalloc to kzalloc_flex
Date: Sat, 21 Mar 2026 12:17:20 -0700
Message-ID: <20260321191722.19235-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Split up previous submission into two patches.

Rosen Penev (2):
  scsi: be2iscsi: simplify cid_array allocation
  scsi: be2iscsi: simplify hwi_controller allocation

 drivers/scsi/be2iscsi/be_main.c | 33 +++------------------------------
 drivers/scsi/be2iscsi/be_main.h |  4 ++--
 2 files changed, 5 insertions(+), 32 deletions(-)

--
2.53.0

