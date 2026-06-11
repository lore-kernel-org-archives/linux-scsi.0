Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879733F54B7
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 12:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781181137; cv=none; b=C33RzIo9pRi4Z9BnIRdK7uwYAw9vFSy0WWnkBXhpqJltDa+dq+d2IRhTJ8zFd4KEKOhnmrY9eTXnuR1RmcHeUVUdJDusq3Z4rKyWx+GAx/EPMBr/3CWSvJoyZ697G5bcTv3b74IVuAnnVt/vw1bfPKy2sUJIPd6vSmTFhRJ7ITQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781181137; c=relaxed/simple;
	bh=5jAwKvcQVAYHQgGBdOtHn5dcMMi9Yqbb8REDi0+fask=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gVfIHBa2R/7PAPvAwyjSkBG+N6sjAKFVacYJa8tL3fEfGozD0WdLCGMNEOdVo0nX2TyyPy5oEU2Fb6RSD0BtBaEC6F1/ouSz3c7dH0bsN0c5ad31sCi3QBR3mb5B62PT3oGVuAVi7eHUeJliIj1CO9gQJU/h7p73S95goku+xOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X7q9MN0f; arc=none smtp.client-ip=209.85.222.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X7q9MN0f"
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-963f63fe025so2334251241.0
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 05:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781181135; x=1781785935; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hGPUMpfdaDQCNkNjTMnCmLU/jdnRUY0BJXqb4atgwFI=;
        b=X7q9MN0frNfh5Do4XeEoxBux4ykD7skkI7f2pljGpOoeD98xIKatArR3IHBBRnJwZ7
         m3gyS28pPcsgjgSdKs4+YcVXYdmzdwhfOW/CN7u8Dzt39gGeXL/t04mP2b3yQGUTpPi0
         +gpmIl3jh7UHhibSKzvBj8hmXl8zCOVi39ryOM922EyqmrKZMVWbAJ1r2Wjm4EIZHa3Q
         AG8yb3jsNjL0AkZ4E7cR7jazyPRIbU2S770xCUB+8dK5hni6NmMJzNAygofAtuPtJqRK
         bi10g754xtWupfkxaANM49DovnPwuzRbamKcYAbyMMctg+Tw1FDXB4wIeLYaUYR9g+qv
         Uc+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781181135; x=1781785935;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hGPUMpfdaDQCNkNjTMnCmLU/jdnRUY0BJXqb4atgwFI=;
        b=QEp204BmVpp3s4sazgdYmapvMqbul6zXx3ycExhDwrGw+0455JNSv+9rOjnbnSQ6kD
         lXCV9MJHHhEx36dCBWhz8JGqvTfzTEPx8yzIstPSzQ8+rDk9bVP8tDvksYmMhT50Ug7L
         5Lueynyn+5D+MNlXHSgzkW7QvrI35PLVUyIqaPjaJA9xTWteDmdpzSQdip1JUw2VRC+A
         nTWQHD01mR5I03jzXIGpXKbFpC6WMOHUz5XBh0JZOkos3KKNNSWBbFMZcFaniBOQZW+E
         SzE+Tgdy37Z/mf3ShuNQFJ+6ROfD2vpIctpkrpx4sHJ82EOzmFFCrHtssEDLUsG+DPME
         a9QQ==
X-Forwarded-Encrypted: i=1; AFNElJ/eUQCfzMjJT9QQLcYpl1jecxjmCFxw2oDYw3Ntm2x1y6a37pMrU1Cd3iiI8ia6R8OmiRsjAm8GcH5w@vger.kernel.org
X-Gm-Message-State: AOJu0YwNNOpkFHJGh6sGFhw8CfQgJCYxoCu6CdPRGGTKK6gRMrw4U2TI
	I2LqCXgjdeZBrnrgHccVlG5WqwEWA/yzlPeqaNnjM1w6eOOv3N7wO84oei4JcNpO3ik=
X-Gm-Gg: Acq92OHFYd9F+lsxnmrphi4jl6jTdEhJ8kaNLzvB48dSf3rjHC7eegmW2S6s4hew6Hd
	/9y+Hl0mmXQAOY1KAltsgCwfoDfuG7qmgBCG+y9eDS/ygWs7dwBe0ISE7e8EWePfOQwH53Upm1O
	k3DH2eFZ7FsmXHHDLqsR97BSgadu2e8kX4S429hSmJJL6CDaYhjvkx1g67uA9S35AJz7vnyeExk
	MOLuP+ReqNXjl77mvs1dB2biLio4tO2+cMQsAInelcsQRYaPEPBJTdWxWgN/DgKYdIvyiqYCzS7
	+g7NX0lFswUc1QLzk9Z6kY72+WucCMswxTtn+c5d3AArOzL9dMLD8q11i5kM82gvvS8aAHi3BVH
	wVTScFnD5fDEcU30IDiagbd+MlHwM7qUQhKd9b4YAZu7ZGd2ZVNw4z4Uj6BOlvK1DJrmcxxEIWG
	rCFM+D1nHfIrCTATUWzCuxtM14awIc11f2K/zmSe1Cwk4tC9YqJ6/uIXPPQZD33rB737e7ccq0n
	fBDqCgMxDogSbvI+Tuq7HViyUm6TfXnQWoiyyYTrw==
X-Received: by 2002:a05:6102:442c:b0:6c2:e290:cc75 with SMTP id ada2fe7eead31-71d5989b9demr795299137.4.1781181135386;
        Thu, 11 Jun 2026 05:32:15 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9160b02f758sm171220685a.36.2026.06.11.05.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 05:32:14 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: xen-devel@lists.xenproject.org,
	linux-scsi@vger.kernel.org,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] xen/scsiback: fix command-tag handling on pre-completion error paths
Date: Thu, 11 Jun 2026 08:30:44 -0400
Message-ID: <20260611123046.2323342-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

scsiback_get_pend_req() hands a pvSCSI frontend request a session tag and
a zeroed se_cmd.  Two error paths that run before the command completes
through the target core mishandle that command and leak (or, in one case,
underflow) the tag.

Impact: a pvSCSI guest can exhaust a LUN's per-session command tag pool,
stopping the LUN, via crafted ring requests; for the first case the
refcount underflow also panics the host under panic_on_warn.

Patch 1 fixes scsiback_do_cmd_fn(): on a failed grant map and on an
unknown request type the never-initialised command (cmd_kref == 0) is
freed with transport_generic_free_cmd(), which underflows the zero
refcount and leaks the tag.

Patch 2 fixes scsiback_device_action(): when target_submit_tmr() fails the
err: path frees nothing.  transport_generic_free_cmd() cannot be used there
either, since the command is initialised by then and se_tmr_req has already
been freed on one error sub-path.

Both paths go through one helper that returns just the tag.

Patch 1's underflow was reproduced on a Xen dom0 (guest to host, with a
panic_on_warn host panic); with the series applied the same request is
handled with no underflow.

Michael Bommarito (2):
  xen/scsiback: free unsubmitted command instead of double-putting it
  xen/scsiback: free the command tag on the TMR submit-failure path

 drivers/xen/xen-scsiback.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
2.53.0

