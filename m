Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187042BCF4C
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2026 16:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782146232; cv=none; b=orziDfPMoDsnQhhnA6Bw/+4Hc2rAsWqzCIs6kZWZCLiL/ucSxA+Cz3/iWOgFgoHxshv7L8uMuQZLd5QNsIkplLWgJwS9sbcwtKnsrmwMBxQ9i3b7E14nenqsqprDhxqir4Xf4IjQ6Qgor55SPb7KxN9JHsYcmj9szlMaOvBgS5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782146232; c=relaxed/simple;
	bh=eJCNM22FWjYNfaU/daveGmD12ufPw4KFtvwawl9WsrM=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=HjxrXG3+E2Ut0z9Lo1AQrIQhD3vqZn8GDzDzxj3kpw7o6uv5sLWo9V9FK5VI5eDeT3nL76evAguFjNPZdrG2lqhj1M26s/HKnk3Oa3tWRHukZkfgAgfmyMdifGsPsZE6YacaHicukbIZtpeahDMg+GcP042nFSffynyCdtUNVZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iSHyiqVU; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iSHyiqVU"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-37c6cd1ac98so4064719a91.0
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2026 09:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782146230; x=1782751030; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yj2TH32Y5BL6HWxUhaxiYTaucxWSaRbNj1yzBP5WCS0=;
        b=iSHyiqVUhzAJUgTC82QQtz7+pIJyvOLUPy42C3aZe82httawuAk2rDt4Fx+1W1ODtI
         xeX40SvGFdsjbFcipoJko5gjD72w+CNEZcK5/0d1WjiGJisohjZhNUjk2fBLwhBUprNU
         1fjmN3dF2Nc4DqpMk7tGxag3F12/IVM41cYgp2788Ic82J2VTyjpcc0fvZiBB1/LJ7xV
         OY91rMuMbqX+S7kIH15jpRxWNECqBnI+SLyn6p/DxVk80cGQ7FmSFIB/8JX3Y/SKQaJh
         U0HNYL4sv10xtNf6Y0Xo/UmCDjFy18+i1qPf1RLVdoJZdxoubC2v+5lN+Twvt9dXyrT4
         C4Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782146230; x=1782751030;
        h=mime-version:content-transfer-encoding:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yj2TH32Y5BL6HWxUhaxiYTaucxWSaRbNj1yzBP5WCS0=;
        b=ApPZatI/Q5yYs7L26Ga5QpkStgifEMCxBLUV6GTnwaV1ql1ggJ0uKMLbf3n1zc7DGX
         96u8uxMgYo6j0gqLqvTeO7uLqKZggy0kQjdPyuoslzAhB25eUB2X5EOrtN7ILJ0ONmSJ
         di8R32qvPdpWoRi1mPqlwzSooB3JXU/a7RjU9ukkxwnxB4H/48uelNQvLU947ulM0+tL
         c7xp6gdsBJeY4JGTBzaPEx0kj1xjeji2KO1FvANfI8a5g2OMWqi+sLXt/D7mPVANS4zg
         EZkrRur4jVgZPwX0DN9AHrA3e3Ljb9xh83LVUlmXzuR5kxz90jR9hv8+W2TbBlvtU9tg
         fkEw==
X-Forwarded-Encrypted: i=1; AHgh+RquNZBq1Zsp6UalBx1tBMThaR5Z/9ynybzFEGzDAZtWpEpEW2zCfNtIRQ8TYx0Uw99nX9pO9ioFM29k@vger.kernel.org
X-Gm-Message-State: AOJu0YwHnAYHXmHyvgNFL6GzC7nNQzTUD8e2wpGLYvMi8GvEsyuyZWss
	WHdEZmX2kNF8YWNBU4QsYooQDDpAFNkdzEIWM+dE8xQrHTuzy6OtcO1b
X-Gm-Gg: AfdE7ckTrQy5B5UMq1IeBg7eS4KmH4KLqxw4ECSllZG6k1Zaywnqeq0b74e9ESJVhel
	hI6MXq9V+a47oR6Io2HEwTBrFxRS/Jd0IXDlwD0AuRSFVqNkC98I2688mYWEpZEvKrx8IShrITI
	XZRVR1xLL2AKBk/JIZ1M+EimtDH82tdMxEndAPt7RF+fcp2fZRBw+pE7vyZOM9z2mnDqRnw6TNE
	6BZUM/b1VF8mDLl2k4CoJdT6x//IcEiKSXWGOmkUXIS70vUtcmPg/4IQVYDnqkkcm/ywa4ojSHL
	dhIttBsOB0Nx3EYs97eNvif2bpVwhLq7Qx+kNkTcRwwxBxSSVFapsVfmvFNBApeECTsC4B6YBgQ
	4bMH+S5skU7al5NqlkAYX5FnRVuQuKL+Aod5Q0+Xk5xckDELx+VuV9cloe56gevFKlqMkQvlcKQ
	l8fQMJ2z0UMKihw1lNKWg6lGhfY8etgp39bP+e3A==
X-Received: by 2002:a17:90b:1f83:b0:369:73a:326a with SMTP id 98e67ed59e1d1-37d1e8c9bbemr13858288a91.13.1782146230121;
        Mon, 22 Jun 2026 09:37:10 -0700 (PDT)
Received: from csl-conti-dell7858.ntu.edu.sg ([155.69.195.57])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37d4f008779sm7320273a91.6.2026.06.22.09.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 09:37:09 -0700 (PDT)
From: Maoyi Xie <maoyixie.tju@gmail.com>
To: Justin Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: lpfc: unbounded QFPA response length in lpfc_cmpl_els_qfpa()
Date: Tue, 23 Jun 2026 00:37:06 +0800
Message-ID: <178214622623.2376914.7843191393281628987@maoyixie.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi all,

I think lpfc_cmpl_els_qfpa() in drivers/scsi/lpfc/lpfc_els.c can overflow the
qfpa_res buffer when the fabric returns a large length in the QFPA response.
I would appreciate it if you could take a look.

The completion handler allocates qfpa_res to a fixed size, then copies the
response using a length taken straight from the response payload.

	if (!vport->qfpa_res) {
		max_desc = FCELSSIZE / sizeof(*vport->qfpa_res);
		vport->qfpa_res = kzalloc_objs(*vport->qfpa_res, max_desc);
		...
	}

	len = *((u32 *)(pcmd + 4));
	len = be32_to_cpu(len);
	memcpy(vport->qfpa_res, pcmd, len + 8);

pcmd is the QFPA ELS response from the fabric. len is a 32 bit field read
out of it with no validation. The memcpy then copies len + 8 bytes into
qfpa_res, which was sized for FCELSSIZE. Nothing checks that len + 8 stays
within that. A fabric or target that returns a large len overflows the
qfpa_res heap buffer. The loop just below also walks vmid_range for len
iterations with no clamp against MAX_PRIORITY_DESC.

This runs when the VMID feature is negotiated. The attacker is a malicious
or compromised fabric switch or target answering the QFPA request.

I reproduced the overflow on 7.1-rc7. I ran the same copy with a 1020 byte
qfpa_res buffer and a len that makes len + 8 larger than it. The copy runs
past the buffer and faults.

  BUG: unable to handle page fault ... in memcpy_orig

A check that len + 8 stays within the qfpa_res allocation, and that the
descriptor count stays within MAX_PRIORITY_DESC, would close it.

Does this look like a real bug to you, and is bounding len the right
approach? If so I am happy to send a proper patch with a Fixes tag and Cc
stable.

Kaixuan Li and I found this together.

Thanks,
Maoyi
https://maoyixie.com/
