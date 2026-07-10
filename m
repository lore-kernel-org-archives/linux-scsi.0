Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2216F1531E8
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2026 02:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783650579; cv=none; b=l5YsPpO4Tx6hWqLT+TwUsEcRjyFh99zst6zHG8NFfOm98zjLG+AT3dneqi/RCuObLjuJOnIricYYHV5n6cQj1A464qSJzDbthjl3URjOtyg5Q44iByy67eNe2y8ipg8k3zL9p91UVEekXB3887tRZsANwuSm0LqZq7i9rDcor3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783650579; c=relaxed/simple;
	bh=d0G78OZFJtynCYU0Yb+pYf0nAFBSfE7NY4RUeGFmbTI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=leQzjVFeyK8Ic3aC37K3f1lohV8RrcC8K0n6anha7bqgdIvDMlXnrEOoJjU6JVh91zc3LX7Iz5Ih5/cHbq46sQapXedAhqTzNAqPk+wzqohW5IHyIg1K7Qs5Yspv+iuSrXmXFckP/T5O84ezSk4U+OAkt75GEa5+6cBu1VTWfu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k4U+iSm1; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k4U+iSm1"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51bfe810293so2145601cf.1
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2026 19:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783650577; x=1784255377; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=T/Wt9nwIkWLRPZshqrH2chvmAQIMoCZXZuZQFMmUS0Y=;
        b=k4U+iSm1ioHpmAPYyfuFjeJPigZro3lwotaD/N0kwCOTzmoMmB2wN31izvyprSyMyw
         v+clGE+WfTunM4If4rcqAGc1CLf9N/J0BpYNVjtb9vagRvJCrBlgQGPUZHpOUVewYpu6
         5gEiE0e1f2NyZWriLDf9gmy9Fp9W8E1Vg3fOBhKJTmD5A50g7ogyojVR0/CwHNOG+uvr
         sUU/upIyAhqGYbI0svwm0yFGnRw5HjL8CjWwReLzv8ZmAxRzLU+HLOBN1JhhsglVYeUk
         ZuvHZgHr61hxkd+sR66A98WveG8VtbOt9Z6gRkjEbcBf8fsqXH8vinm4zMHYdUUuSC7M
         EnSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783650577; x=1784255377;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T/Wt9nwIkWLRPZshqrH2chvmAQIMoCZXZuZQFMmUS0Y=;
        b=PavWzbzlx+tBH1JpTxJRBGPyHpvd8OGzvK8ywIEu6yDV8sFw1h3V4A3HrdBPWisVBE
         aRstZ6hSYb8lU8Vor6c1MkSrnLgi4/nma5IC1r86wE/kbxUwgh3CaFEJHxgAImYpX40H
         SB9fkrP5rslhvNylWSuRljjEsk9ZeS8d5jQ+8xXA7A5ckwm4tvqFc8i75aXep6MmVMaT
         5DPUAPSzpBy1e5sCZ6lphbTVWWpjipfAMR3DoccDPVvT955ReU80yw6Ev8hNxmPtYEcd
         vBRwdmc8XFqHSe1Z+Le2kZsMeZrJ1B0Cb2jMp7enzdl7y7O3WGnQsiMveCUE2Oge8uqi
         f6ig==
X-Forwarded-Encrypted: i=1; AHgh+Rrg5Pdtxqfrg+dz/Xl4+tcJu43HZLR0SwDckv/Cau6HC1xCwVKcT8gnN2JyqQT/0hfzUq80HjlWw2Hw@vger.kernel.org
X-Gm-Message-State: AOJu0Yzr4qI+yHHyF5MQvPYW0aQv7Kendfjsc0I5BU/IAZlGGvnlmHYD
	6c4yvC0ne9ojIlAIfzHnP8wPoJ8JDgqSW0HXwaNWn6liL7JB8ljqRxsV
X-Gm-Gg: AfdE7ckU5GvVb6tUTEi0BuIpspM7DNbU6FGhTMcOx2A70xkSszXr5y2s7rn+9DK4N0R
	dg+qUitdsIymTbzrLkfK+6IivU+A1BF5/gdc/IRfU+KwKS5ylgIbzLv9pL9MW5l1xfjJHbhlv7L
	mdnzPi67QT0eP7mIe74Rrhwt6NdJnByHuiYPupM9ew2a+u/zkG4d8lbwoIhjs6peOLm7H2v+eE2
	iJMCso/goZow1Tiunmq1RQ9VQuhEi8P7MFSIq9GESUBtywjCjzNNpr/hgvUzazzaraVBKWCbl68
	Sb0zB/sOqb5gC2iWHluPIGfvFrco/NlctqGZy9Jhn6Ipd8I0sxUiI+u14flftNAxclpGhE6SzBR
	PoNg3rwdNSuNRBRWk961wCL2W0ETkgXHc63G5x0CoNT6565C4GiOuIuL4SM8F9jyjHrpxOF5AYS
	IihayWJ2hRlRqWM/l5jaT5ZzAxije1IaRMsy69aOnJcmfUoBDU850hd6Y5GHLpBcaCg1+kjzZWh
	iB8o5KUIKblo27Tvo90DH+E7jPn/P2X
X-Received: by 2002:a05:622a:4308:b0:51c:a2ca:3fc0 with SMTP id d75a77b69052e-51ca2ca5e00mr32009521cf.23.1783650577094;
        Thu, 09 Jul 2026 19:29:37 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51caafd8b4fsm6951101cf.31.2026.07.09.19.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 19:29:36 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Justin Tee <justin.tee@broadcom.com>
Cc: Paul Ely <paul.ely@broadcom.com>,
	James Smart <jsmart2021@gmail.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 0/2] scsi: lpfc: bound EDC descriptor TLV walk
Date: Thu,  9 Jul 2026 22:29:30 -0400
Message-ID: <20260710022932.3741311-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

An adjacent Fibre Channel fabric peer or device can crash an LPFC host
with a malformed EDC ELS frame. lpfc_els_rcv_edc() trusts the EDC
descriptor-list length from the received frame without checking that it
fits in the actual ELS payload, so a short frame with an oversized
descriptor-list length walks the TLV list past the receive buffer and
trips a KASAN slab-out-of-bounds read in the ELS receive path.

Patch 1 passes the received payload length into lpfc_els_rcv_edc(),
rejects truncated EDC headers and descriptor lists larger than the
payload, and avoids logging a third payload word unless it is present.
Patch 2 adds same-translation-unit KUnit/KASAN coverage: a benign EDC
frame that must still parse and the malformed frame that must now be
rejected.

Reproduced with the KUnit/KASAN test on f5459048c38a: stock trips
BUG: KASAN: slab-out-of-bounds in lpfc_els_rcv_edc after the benign
control passes; patched rejects the frame and both cases pass.

Cc: stable@vger.kernel.org

Michael Bommarito (2):
  scsi: lpfc: bound EDC descriptor list by payload length
  scsi: lpfc: add KUnit coverage for EDC descriptor bounds

 drivers/scsi/Kconfig         |   7 ++
 drivers/scsi/lpfc/lpfc_els.c | 195 ++++++++++++++++++++++++++++++++---
 2 files changed, 189 insertions(+), 13 deletions(-)

--
2.53.0
