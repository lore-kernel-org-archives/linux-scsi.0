Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3A5339847
	for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 23:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779148267; cv=none; b=bdaHdF4Y6MgG7EePusxCb1gE0EE609A3FeVab3wsztSg+6EueK9892tahQGQ0dBkNDxHJ65As1K6p+FsdW9zYA0pCoGCyBI52vAZJHM/0+RfywrWCJ5wXN0+fFAnahqzF5Q/ObrzD99Big3PLZFU5mdB8WPLiC0ZVnGFPygvG68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779148267; c=relaxed/simple;
	bh=oHzqtxHYGtsFWWs1IIVZkaaC0dsURSMDJdI1EptB08Q=;
	h=Message-ID:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hqxKn9hiZ5q9WW1LnNy70ifFGPqwJoL4uK/ArJnQ4fYUQ/URH0ES8jYaE4maVEx5kqjvFWKK/lnnyrJFSpIlEehfRXH5kiUWVH9BEZKiM+JVV0oaG6lgU9Zj+bgrE+M9l6bVUH6YugSeyfPlGRzTyqGply8q33AnrBVXP6DIbaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ciah3Nw2; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ciah3Nw2"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6746d0b2b4aso5080727a12.3
        for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 16:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779148264; x=1779753064; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :subject:cc:to:from:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oHzqtxHYGtsFWWs1IIVZkaaC0dsURSMDJdI1EptB08Q=;
        b=Ciah3Nw2xdOjcg3w3zBcgShZ+S2a32iIm6TT/7UCDctORSU9A1oFXCLWRiPVu7quwL
         DQnONi/AmCqEf6+i3vfQVAadZsVyW9ulr3FTd3S74EqkIjpUBusmdF7UgMvolLQkW8x3
         FocarObjL7BAof4v287V0tRUiwwKcINFa8q4XgigacbMAoConEBa1vWOkqvtqW7I9lgc
         o1vX/Yi6HtPvE0VmbAl1dgWidsAsmzUSEiyt4Q6Zo1z4fclvpclhGOvK94QOf6C5R4GV
         KFRKKrsfff8gsFRixT5X4B9Fa5+Z5eWztsygea3fKVV2FRFIeThYkwwAqFaJFTWV6fGo
         Ay+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779148264; x=1779753064;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :subject:cc:to:from:date:message-id:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oHzqtxHYGtsFWWs1IIVZkaaC0dsURSMDJdI1EptB08Q=;
        b=McuJnCijDjGIFpbDn8XVju6i3z9dP8KPmaYZwipwnjAs6dIw6pwuxSzVBr9mnVuFl6
         Tg26U8eWm9s5oRmqKuoSqw8xQtlxSXODgSj0UqfD6T5YwIRbDuSyy4nEsG3FCqlhwapv
         Utu3T9rZKQ0UTVoPOp2CnHIBhQ9OjTO5r20atwFpkXrQUn3VMIQMgAuzsze0HLQP33c+
         FeAOEEkfr0IKadqk6HQT9N3S98TxvS+pgA3AsIjpzo2lHErk6k/hd39zZWa9HsUyZW//
         YhsMZLRQ7l7EWiz1ioqeJA6jJALFdAro+EtjMSmdRBhgW4ilYcxDAXWsJKOA9Ic2crrC
         +y2A==
X-Forwarded-Encrypted: i=1; AFNElJ+Nyc+E9ld59mnrJflq5FUeqlrnzvFoniFFa4YJR8gNB+/cMW7iobf96X3kxj2wJWESkOm7AtqF4XUW@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6B/hIih/2WyDlbuValKIjNCIiwkIBRfom0+Wm3yxGWRjOUWs6
	zw6VNYRReg3P/mGrOBVum3noaUERXknvbI6ab5jfTbHtsQtKLrhyKFks
X-Gm-Gg: Acq92OFU7s53Y865IvxvZt81mFrt5QfLslmZ+J2euBcdGEBT0YxoF59dqvkaRfHgUH2
	vSnGby8PYq3/0cOrFiRWER0AcH9TXeDN2ZATSd+YKak6pPy5H7diMHgtsKRRlw3J9R76QbqBlDs
	mslrLgQdQ9b6KV/VaZLCm/bBmV/F24LRriLS+0kqX4fbZm5TCsL3b9gh4AsihSD0lbFThyd/kmq
	Ep/0pPdPRC4t87a7gVED0ao4k7iJDllIf1MmVQB4buK7jvRaDwt3x4xNTjJyMuT5tkQgpbtYSHc
	LBYQhEtxbA3RZY2UUDLpCSmdou7Dv4sEl6MO3sFP7vcE5ea0+totu+USPQaf8yWVyMgESLZE05D
	Mqee6u0RHJFEzBquWFFIsYKEPVFZmDhV1Enj05o735yVQvZJG1yv7kOqJBNO7CNW3BpAbi5fOBz
	UvfjUfc5a8SHqjwq8Tbpgu2bCJAnTGz4F6HhtkFG4lh6RZjG7wo5AFZFEnkAcSan5JMF0idn2zv
	FTgHRTw3ZYH6byX6lEnI5Jjak25QxezvWxSnyIIf2SPWYllf3z8+31QkQviotmD2jDTJn7KgFW4
	OY59UQ6bBr1qQ2pdlTrBAPwO1p8M
X-Received: by 2002:a05:6402:46d6:b0:678:b2c5:6915 with SMTP id 4fb4d7f45d1cf-683bd38be0dmr8809786a12.22.1779148264415;
        Mon, 18 May 2026 16:51:04 -0700 (PDT)
Received: from ahossu.localdomain (ip-217-105-56-94.ip.prioritytelecom.net. [217.105.56.94])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68310d58c79sm5829140a12.12.2026.05.18.16.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 16:51:02 -0700 (PDT)
Message-ID: <6a0ba5e6.cd541789.157749.6e89@mx.google.com>
Date: Mon, 18 May 2026 16:51:02 -0700 (PDT)
From: Alexandru Hossu <hossu.alexandru@gmail.com>
To: ddiss@suse.de
Cc: martin.petersen@oracle.com, bvanassche@acm.org,
 target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
 stable@vger.kernel.org, hossu.alexandru@gmail.com
Subject:
 Re: [PATCH] scsi: target: iscsi: validate CHAP_R length before base64 decode
In-Reply-To: <20260518121811.385350-1-hossu.alexandru@gmail.com>
References: <20260518121811.385350-1-hossu.alexandru@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, May 19, 2026, David Disseldorp <ddiss@suse.de> wrote:
> nit: this could be DIV_ROUND_UP(chap->digest_size * 4, 3) to match
> base64.h BASE64_CHARS(), right?

Yes, equivalent and will use it in v2.

> The above check doesn't appear to catch undersize base64 CHAP responses,
> unlike the hex path. How does that affect the handshake?

An undersize response decodes to fewer than digest_size bytes.
chap_base64_decode() returns cp - dst, which is less than digest_size,
so the existing != digest_size check at line 345 fires and the handshake
fails. The result is the same as the hex path.

> Finally, don't we need a similar check for the mutual CHAP code-path?

The mutual path decodes CHAP_C into initiatorchg_binhex, allocated as
kzalloc(CHAP_CHALLENGE_STR_LEN) = kzalloc(4096). extract_param() caps
the input at CHAP_CHALLENGE_STR_LEN characters, so at most 4095 base64
chars reach the decoder, producing at most 3071 decoded bytes. 3071 < 4096,
so the destination cannot overflow. The post-decode > 1024 check is a
semantic limit on challenge size, not a safety net against overflow.

v2 with DIV_ROUND_UP below.

Alexandru
