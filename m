Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA98148850
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 04:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771475941; cv=none; b=e98ObdwXyGb1gwPy38w2EF5sQAHqozOm28lmmEhDmnTZSb1OZDgd4BKQ4K8h2hDS2jxS1EtL8XkV9jKz8tVXJFEbGj+VaQ9aerWrMuTmWsFStW1eCwpUN0uTN11Hchsk3J1AUSPaJOV/ZE/7HjLtFbDFiyGJSuPbUPoGeqDGtAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771475941; c=relaxed/simple;
	bh=ZkYpi24XB+c2nYpfMZCYd8Pg5EzS7/yqjjFkgZHE9yQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kx6gtrw4Lj9H79XCP8QAg/U6eRxUJQgKwu+HVNz/nlgT+peTszd13Snl3paVBfKm+B5LkYONFapKMmVxKuhb2Of9Pd/9G/WUb0dC1QYDdsd1sE/YmmWdL36avWAAIpz1Xdbm3milBAEfj+pw+2YB/CsZiGlrOZfSBx73GTNqbas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D7M/iGye; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D7M/iGye"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ab47d8b33cso2205285ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Feb 2026 20:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771475940; x=1772080740; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ynSChzznDaxbwFRr4/nc29K8Vokm4ZvjDd1JUgHodKk=;
        b=D7M/iGyeQV5EahTu+DMUF5SUFV2LcAkgHUqgebR9ChrgOO/eeObVmSbtYEaqmzLJ+H
         RMkhHCpZSZMbPNCX4kUILE6ELiR/v6s+eO/SbebpGTwLc15gNbvZsHhTMVvGE82Cr9E3
         QChdYoJXLSsZ8ts+wbRLp5NKQnBTsR+kgysft5iO6h+WT5Ueo35qo7QPYrQac9/H8YrI
         z7pSzEuDpdzg/1GDugWQz3G83p8d53Gb816kq2U+aDOPX8mMYeg7BHsfUGcN+mcK4e1L
         Zmp392LhDtzSzxUh+3d9Pj4tP7hZ4BCeGt5PFRxlk/afJa7oZgSESyPDjq/f2+qE6zQe
         WkDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771475940; x=1772080740;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ynSChzznDaxbwFRr4/nc29K8Vokm4ZvjDd1JUgHodKk=;
        b=j2K/O3FYUa+hjo/dfDIZmjRmakB/NNWHVQxQGFTuJEqYTGohRTt9kBos5KC8txwGNY
         Y4hCbUHqUBIYy+tahZ8Dkpufpi/y4fk4jSP9Xt3SMxrNRtq8o1jCQ7jNSPQCFpaLLLYU
         DEifl3n54ok6/Mdc/s3oqoE6GV5rJtf/DU20WF56cldwa4L+mvynIeYKThcpDbvCvi5k
         F4eH1bkRuJ7YCzY1Jwh+CFFZTQmdi59Nxk0V1ZsFOkFXQe60aRIkYI5zQtFhxTT9bHy3
         EptuGwif9bG7IXOmkZ3noGHcq27xJzKAPOSPZmbEHgsK9s4Fz1C4rWlluovKm+9uwaLl
         UAlg==
X-Forwarded-Encrypted: i=1; AJvYcCX5dnKlWWetcbIvNPrCo+4/37zohcapPPsDr+8K+nS0xHaWIExQWYbpzwgWxObGHFx3wMlzhDJ3sxer@vger.kernel.org
X-Gm-Message-State: AOJu0YxkqwmjpLOG8G4hjo/PpgBO3LGJ7qOkSx10r846VQFwS9eNDFOS
	sX1IgxLl/Lw164FyuNimfis7ve3Do4/SLs5x/gDq1gtOrnfu21zRV2n0
X-Gm-Gg: AZuq6aJI9wwXj7GdftEHlx1NEDBHE1t4Ch+zcwlzUoo/lO1XvvJonjUFIoV4fyxXqrZ
	UzGGxgkJJNZ+2UB27olQxP+K0pKfpZd3fKvQmb6OfF6wHdK0/3quM07WNTe7xPtHMBl1TcEpLCL
	SAXbaOuOBtZPEXlirNyHeXNi0ne5vb+dwM9SxFNvd75ApMyEcV+IpAhvhVTQR8VR5U70xrLtc+P
	jKQLHgX3E3cefYiP1v8l+gtALJ27a6/P3te6fpnhU6KpU52GLCCP9bcCMv2dlRphN4S7KokXFcT
	ENJeUssSeO12KCzWHw/i+THKNIUpV2Yi3IX4Y9EG82gXpvLJ5WCiDi45oq0NXWCnoxQ0aPDydwI
	PW847FCSBvhiJyc5kEVMj7g5UH3/FUIPF80I6596o8tHSmG6AJqK2BUp0a9mgnd/Ou9DCMeefNP
	HfGk1SPVMlAIdrwC0kanSlWZlwyRu4BtNYNXkaHt9kz+zEuqw=
X-Received: by 2002:a17:903:238b:b0:2ab:3e9a:a013 with SMTP id d9443c01a7336-2ad17513f8fmr153279855ad.43.1771475940099;
        Wed, 18 Feb 2026 20:39:00 -0800 (PST)
Received: from 5163NRD-SPRABHU.ssi.samsung.com ([103.50.21.94])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a713675sm203345025ad.27.2026.02.18.20.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 20:38:59 -0800 (PST)
From: sw.prabhu6@gmail.com
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	mcgrof@kernel.org,
	pankaj.raghav@linux.dev,
	bvanassche@acm.org,
	dlemoal@kernel.org,
	Swarna Prabhu <sw.prabhu6@gmail.com>
Subject: [PATCH v4 0/2] enable sector size > PAGE_SIZE for scsi
Date: Wed, 18 Feb 2026 20:37:40 -0800
Message-Id: <20260219043741.276729-1-sw.prabhu6@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Swarna Prabhu <sw.prabhu6@gmail.com>

Hi All,

This is v4 series sent based on the review comments received on v3 [1].
This patchset enables sector sizes > PAGE_SIZE for
sd driver and scsi_debug driver since block layer can support block
size > PAGE_SIZE. There was one issue with write_same16 and write_same10
command, which is fixed as a part of the series.

Changes since v2:
 - Added reviewed by tag for scsi sd driver and scsi_debug patch.
 - Modified the helper function name used for safe creation and destruction
   of the large page mempool.
 - No functional changes.

Thanks to Damien for review.

Testing:
Testing results are same as v3 since no functional changes introduced in v4.

Link to v3: https://lore.kernel.org/all/20260214011829.508272-1-sw.prabhu6@gmail.com/ [1]

Swarna Prabhu (2):
  scsi: sd: enable sector size > PAGE_SIZE in scsi sd driver
  scsi: scsi_debug: enable sdebug_sector_size > PAGE_SIZE

 drivers/scsi/scsi_debug.c |  8 +---
 drivers/scsi/sd.c         | 80 +++++++++++++++++++++++++++++++++------
 2 files changed, 69 insertions(+), 19 deletions(-)

-- 
2.39.5

