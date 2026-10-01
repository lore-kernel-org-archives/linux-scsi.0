Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA163F5BFC
	for <linux-scsi@vger.kernel.org>; Thu,  1 Oct 2026 08:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790844094; cv=none; b=PFdHcyEvSIUx8qx+IuOH7Ij4GIHzVhLuAErno/UbWL7n62SFfwZVyRdyG6OJQGBNShY9WOFBHRLYEbJaIzPda6HlFAmsmZRC8eEJ20Xz5uDjX7byR/qzIw3LilTV3cbtZnnVBHIzt7FCLjKThdZ68qCy4aubHrccek5w+XZOZCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790844094; c=relaxed/simple;
	bh=jIEy5cT5mmkkVcGKdpbeH8K331ZFV/0IWVEdNWVBdcc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sWiT8QpPv7iBLPeZlRntV9lUCSHwYpXJHdrDRWAIXVFM6rtrLMINWrXVtKelUhyKBsU2f/DU9qGvBdWl9EP+HWiIsPG9mpZgGGkoJQIxV9bvOtOIuIUDM106ZMLIfwPq8s8wXay47bjgIBFLa/nFQu+IxoWxil0VHVrZ8OPFzRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GXWMbK1K; arc=none smtp.client-ip=209.85.215.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GXWMbK1K"
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-ca8aee88725so3491721a12.3
        for <linux-scsi@vger.kernel.org>; Thu, 01 Oct 2026 01:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790844091; x=1791448891; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jIEy5cT5mmkkVcGKdpbeH8K331ZFV/0IWVEdNWVBdcc=;
        b=GXWMbK1Kv62x+ZZoITp0Ot7q1ybxLRMceh2wjq9i/v6fAQMQ2EWZBNcMgfHuEiMYfD
         qMYHydBHlQRcFBVxKGQYKk8KEoCgISNCk8KS609wWbkXOIKysa7WmOjPEM/IUsvh9BGK
         XN2FPykKFP7j8Qc3OhnXuUTyZuCkLI59fjN8nQTFjNA4vE8yFNupWZaHNCsCjSU3pXLF
         MojyivZbU8lXry8xF5nPMNniqbIlxHzUHinPBLsnFmGDD0Hjt1jVP5cfj7pGiOuuy8HO
         AoqsvulUkHEzFu59us/NG7H87CqZDGL4etwnXSUBqrVPYpRCgOb6Cit97wHE8np4Yqkz
         TsOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790844091; x=1791448891;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jIEy5cT5mmkkVcGKdpbeH8K331ZFV/0IWVEdNWVBdcc=;
        b=fcrz1roLiFxDKPnnBHfKicLChnPUzoAzjkmIKPWzdTElasoK3SiHlENOT7DpfPh3zy
         Bqi64K3wZHT5U2SBdwS0W4sezCEcKnhGT77DgvH6gTC26zs5fhQCx+3V8FOIQLoYbZwi
         r7XFJQeX17Qa/ir9UckvvqjQV8OSWNpZYd9JlivlDfBe6cgJNjvIGp9Z9tkMR8IE2xjP
         cgkpJvm4Uz2IbqChb8C/kk8mDXsCpv2hcktMNeMaCecLarCrFWLDC087XNJX3u2eBAsx
         faQDqH5fbUkyoIIHyk80o9+6fFWiV8bMOlF5BMmrVczXqiJS4dfD1dmf6i0Dk5t2Z/NX
         pCkA==
X-Gm-Message-State: AFuF++mRa9xkG5Y+woA0fc2GkMuF+xaH9UZvhlMrLfciIqcPHlq/PXZO
	gWqvNvBDOgvf01p5iKJtVSoNKvTzvxksmpWpUF7rpCUeiBiWGm2KzNvcVvdtBdL0T05xw8YKqk3
	UwMgW1vd7qtBhjyXwz1pWZA==
X-Received: from pfnn21.prod.google.com ([2002:a05:6a00:2b95:b0:886:fe91:dd9e])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:7d8b:b0:3de:55ce:75d1 with SMTP id adf61e73a8af0-3de9e86af8dmr4024094637.92.1790844091336;
 Thu, 01 Oct 2026 01:41:31 -0700 (PDT)
Date: Thu,  1 Oct 2026 16:41:29 +0800
In-Reply-To: <20260909091045.1134956-1-naomi.chu@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260909091045.1134956-1-naomi.chu@mediatek.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001084129.499805-1-stanleyjhu@google.com>
Subject: Re: [PATCH v1] scsi: ufs: core: Hold a clock reference across the probe
From: Stanley Jhu <stanleyjhu@google.com>
To: Naomi Chu <naomi.chu@mediatek.com>
Cc: linux-scsi@vger.kernel.org, mkp@kernel.org, avri.altman@sandisk.com, 
	alim.akhtar@samsung.com, James.Bottomley@HansenPartnership.com, 
	bvanassche@acm.org, wsd_upstream@mediatek.com, peter.wang@mediatek.com, 
	alice.chao@mediatek.com, chun-hung.wu@mediatek.com, 
	linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org, 
	ed.tsai@mediatek.com
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Stanley Jhu <stanleyjhu@google.com>
