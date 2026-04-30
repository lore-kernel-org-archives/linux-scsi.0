Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8366937BE73
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 21:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777582985; cv=none; b=j3t5rkE9SGGyJplRpioxwmk/hO0WUh4mf16rbk5Lc3EChm05DaxzyjfBVRrO8qrUEemtCxmyJD6lWLZxknQXCsfkqNWVCCvwv+t2pmS/aQ7hJYUJ0epV9YActIUYKHB7wE8MF0s9egl3ryIaj+5bPcU+ENAQsNJOq1ep0s2wyMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777582985; c=relaxed/simple;
	bh=lK0vRvzWOSGHsP8Az2h4+v4ZxmaWqeUv//+gTjRmZ/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uklaxUILbHZjuWvUxBPjAHYeB2L4EcVuDxz1NQlixSr3A04569uutIUhMhUm298JTcwkNrS/KtmSiH8z0OkFD530DbbXrAOslAXCWslaw1lWj9+BQAlFUijwZo+mCsEPHIfuqtCzEsZOZ7SW9PjOJWmVlXGqZmo5MxfUgxiBPr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gc4qiaAI; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gc4qiaAI"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-83177129e28so646678b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 14:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777582983; x=1778187783; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BVHVujWPl6gS9nLBw1sM2L5O/6px8rvuzNFbmPH9b+4=;
        b=Gc4qiaAIuLnFDBvwjMQRPOINnEVOqHOdRSF6V0qfun3A8BHAyfibJyeCswXeev0mcA
         RBLmlGAgFhoEch8hZZp5CLIbYCd6r1Mpvfjo4ZpNKm74247FZHb0dhrUSoy8o2SUZexz
         xIGs9AFBv6c+JLvIgfz2mvcyMIEX+LXebP++PX0WYI+sLDCOyAuPp3bzfuveYKqwgg7H
         OV0j+yLB9a0EGhnHlqKxyY5nZQAkb3lli9pNtbup7BUbtE2DlkjMqWsiyWr9Do+e3cd3
         PI3NVTuKM2ppSW6VNvbkQA032rjfH8EIaBgfd1RIstWsnFGmuJ0LVlySC/B7ievGUZk/
         r0HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777582983; x=1778187783;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BVHVujWPl6gS9nLBw1sM2L5O/6px8rvuzNFbmPH9b+4=;
        b=VNRTVsWHsIKyVmEJc0fyxEkJuir/bKgx0J0Eb49SvdIfmOciooTCVwYL9ph0dwwxpV
         NN+g0GPkEWubC9Hki+Rec5xsr6f4578nuFkZDgHb1OxEndm3gAn7g+SgdO+NohbnbOx/
         ni9Mb0VtlmdKQpJLd1vTjny815fSS+3Cw2MEVW2g+mHlrmzjLmYlvfjqxEshjxOdd5n4
         c2/Grit21N4gZ1ErPoUZri9sxQPNIUHMU7PQyglchJV81IDKf1NeuWHSkAUoX88dCxCE
         jTQ4OwC6RWRfwUx2Oe05ULbqG1eqoSOGfHAqIJxKc82QpLAYQK3XReS5coftaO5ZmivO
         4SrQ==
X-Gm-Message-State: AOJu0YywuBYHtm7tBTeddqhGIZa/Sv81Q7O5Wof+bax9PYj73OxNPWud
	z2IpMDlbLNPl1HfUsIdGckRtIUenv+mErx76moK4U6R+2byaNSfuW9rJZhJ6rA==
X-Gm-Gg: AeBDievtZtCpupj/d2NF3R9tC3l4hOHhoWcozxvKerUwPK6J2bTXIPkZ5hnF1QVcldK
	ULSQpTMx/UPvrohbSOjP6XVAjhfo5XsPNBBQAzU/9ZT61pkeHf9Ww1VxgUUE3nwuPeZXRbTRmxr
	F5e+Ojt8dBko95Fq5dt+zVuBDpjAK/QNIMOznqNQRYu+AOBjcC2G6t1BwRLcwwDAY8E740gU4ls
	Tg04lTaTyUMuMmw4zIs6RbMDImH7YSGtOjVR2N8mm09pf6t0U1JMIow3U3CJSd5ZWM6Aw4/elzK
	IlGyrsgNvZ3YKB84ttX02R3rmx4vjT4GOS+fb8qRrYKlOAcqULH8rrabl90gI4zFX+g2P/Y33y1
	fw8lfsKH81RJ66YafO7lumrtTYwUR8fUjmDPT+feT/TILOR8xikzbcFjo6Dl6EvJATMD9viJ+ij
	6EdfAeHCVdQmMPmG2ZcLaVMkba/VHXbjbwRKbtcch9I400lfHLdpVXhKX1lhgbPrW4B3Mu+SUqh
	ds7HIzRe15OPonlqOHzbb0M4mdpajWb2956aOOMuEynDADWsBoECsNe
X-Received: by 2002:a05:6a00:ab09:b0:824:9bc5:e946 with SMTP id d2e1a72fcca58-834fdd113e1mr5490195b3a.46.1777582983308;
        Thu, 30 Apr 2026 14:03:03 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d:7285:c2ff:fe45:8a32])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83515b4f7c1sm516809b3a.51.2026.04.30.14.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 14:03:02 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com (maintainer:BROADCOM BNX2FC 10 GIGABIT FCOE DRIVER),
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 0/3] scsi: bnx2fc: simplify allocation
Date: Thu, 30 Apr 2026 14:02:42 -0700
Message-ID: <20260430210245.29840-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use flexible array members to combine allocations and simplify freeing.

Rosen Penev (3):
  scsi: bnx2fc: simplify allocation of cmgr
  scsi: bnx2fc: no double pointer for io_bdt_pool
  scsi: bnx2fc: tgt_ofld_list to FAM

 drivers/scsi/bnx2fc/bnx2fc.h      | 10 ++---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 14 +-----
 drivers/scsi/bnx2fc/bnx2fc_io.c   | 73 +++++--------------------------
 3 files changed, 18 insertions(+), 79 deletions(-)

--
2.54.0

