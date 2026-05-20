Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9BE37D101
	for <linux-scsi@vger.kernel.org>; Wed, 20 May 2026 16:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296003; cv=none; b=EKKjHHKL3PqG473RUvUZxnWxcx1tgm5uoRu176eYDkRLVfWu/JdRYdr4ByemzY4Kgx4LkFkzysJOhiALSAUFJyRmF48dhtor1f4Ph4btf/+VU7d/p2NzfD3b5ndPMOlpGyOUWfESZeHs7x62QeuhqkdC+oGsYgKfrAH5TGEpT3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296003; c=relaxed/simple;
	bh=++VV2z8DF9nYNXw7ZGVhPSn17Ap73p9EQBATvvZQOOI=;
	h=Message-ID:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KoeJ8Mk5BCiI1PEx1BHvG8NtnaeJ/Ucfn1dSJwvzuYxY0CGMo/bdUlss0/niaLsm491iO9BmE0d5R0cXEyTgA3djQSDFom8k+SFBiNsQ74yhR0s9zsXX8C6PAXYW5NxgSNwp6IqeZ0DqwWN2urvM2rWzReZJ3YwVeg8dGnxaINs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a88r0ebo; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a88r0ebo"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-bd8d0e4e341so647076466b.0
        for <linux-scsi@vger.kernel.org>; Wed, 20 May 2026 09:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779295998; x=1779900798; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :subject:cc:to:from:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uW1DWs6dLVxbMJbJA1XC7hMjjnFFtxpIrjpCj7Et85U=;
        b=a88r0ebomWrncpMAU1k1hVlO/8O9b5BTZsgHdTR7xyt6cnrTkR2xbvXR+pTYbUcwSW
         WFN1WCAOPyK40/TM3xPW/3X57uY4dVxOUZRtvCZZ3w00TIY8PSx34NloolnOs04SO/Jl
         +3UokslLUEu3svnFxjxH8ldUmJLhFePs9vjR3MrcF5pq+puw+z34DCUtmePCxDI1AZ+J
         NdyWr0IyUQl0XTFdm/2d6dId1G/eRwEJWOxf/1wb+PdCOkmqJyfIRcwkCJXU8fGHv9iI
         KQ4dQKerFnQT+YkpQ8NqDadATMvk6U2Khz8nfwyB+Oo1cVq6hk51af1v4NEuWln5j9uM
         QMWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779295998; x=1779900798;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :subject:cc:to:from:date:message-id:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uW1DWs6dLVxbMJbJA1XC7hMjjnFFtxpIrjpCj7Et85U=;
        b=sCHZuTLqDJjkgmchU9kFq9x9GGlNSryHwiDDNxgYP2AAkqwBBSmLOWAzGj05J2GSVj
         MSHtqdh9kI9IOokLkRgyfgxCJhqnxYxg6rQfmtS78zusqPTwVbO8W+KLqTFOo1DuMGSo
         hIQilAPZzYFg+E0yA58aMNIHFUBtILGEcWnJ4GCCYkiwR3G0KL5FzX8zBFDaXnZxdxKj
         Zw9OHkG7O80FX7ETrfMMfgEwZPOOWEeNhdecjusBXu1ar6nmFzSWeygbeGE7EmBAKNbC
         05nRpHl54mPMQiydo+/kW6z/U+wC3MEmGLpYIHy0CSem9wyG7EFdVDQNcia1S4cBJSTi
         dXNw==
X-Forwarded-Encrypted: i=1; AFNElJ9aQNbYg+PVJfkbeyzXriuhobrXitAZoTY3g0rnmPtXc79hG7mJHw23U/MHMHEGCfXZxHD/nRgk5N7l@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0HDuAN3OgQAjbA+Xl5EEQtrBJkk67AWoi6c1DqfdxuvbDtkq3
	tdv1uh+f7nhLYkWtd6OlcSBSjBVRAUz/7yn/B1/w5W1Ab/undacrmJvI
X-Gm-Gg: Acq92OEfHnGHSZNzmmS/q4GbMPg0eOqNmQjAG35ePB31q8BWBoSKM/UwOnCxtAt+Mw6
	ndvJDAAd+FYqNDDhlcGqODPvvh+TpvrmH38UZXNwJMKG8HFA87HguKztLr7ye/+UNfp0W/VS1OC
	iWqfENrmLwLuwguzNXqnjkMgPWyTwiqjeP61AIsQy1hlVNz96h0n2B7tToKzYgsyE1pqhfeHfHT
	wB7eG0Ft3a1MQsy4Lvs+mDymo8s1qU4zPqEh7XqESeEd0B/CQTDE6t4LWiEK5McQyVJczOQrYbF
	Rr88o8TCjloBpfxXB//CaYXPBtX64jFXe6u1Eu07Bei/RbLkHyPYXgA/RyPUSNbDywE9AfUdX4d
	Xf+rnfTEQRPF+GV2taSlqkP9qzwHWf9qZh5wsvHdWGFfaKVNK3mI3I8HyK4DLCZ7NnU3VRlia7y
	BX1n+S3n9Ojj+dmnTlNoyAMS1cXqmcIViB1OVlShXvm1NAuiVd4LWSLvCh8udMuVVhP/Ip0w/OG
	HVAcVtCHKOWgejQLouautArEwkaIJkmfQ9356RkB1opsQ0w97HP59J1dH4od5xUNAC6WaL7k3Zn
	8E19lW6Aao7XyCYPDRPqNvqp4gHw
X-Received: by 2002:a17:907:d78b:b0:bd5:2c56:71a2 with SMTP id a640c23a62f3a-bd52c567250mr1328647166b.36.1779295997739;
        Wed, 20 May 2026 09:53:17 -0700 (PDT)
Received: from ahossu.localdomain (ip-217-105-56-94.ip.prioritytelecom.net. [217.105.56.94])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68704a658d3sm1547636a12.17.2026.05.20.09.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 09:53:16 -0700 (PDT)
Message-ID: <6a0de6fc.2d57a604.3a8602.5396@mx.google.com>
Date: Wed, 20 May 2026 09:53:16 -0700 (PDT)
From: Alexandru Hossu <hossu.alexandru@gmail.com>
To: mlombard@arkamax.eu
Cc: martin.petersen@oracle.com, bvanassche@acm.org, ddiss@suse.de,
 target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
 stable@vger.kernel.org, hossu.alexandru@gmail.com
Subject: Re: [PATCH v2] scsi: target: iscsi: validate CHAP_R length before
 base64 decode
In-Reply-To: <DINMKOIB4PRJ.1Y571RHF6NAQJ@arkamax.eu>
References: <20260518121811.385350-1-hossu.alexandru@gmail.com>
 <20260518235040.48647-1-hossu.alexandru@gmail.com>
 <DINMKOIB4PRJ.1Y571RHF6NAQJ@arkamax.eu>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, May 20, 2026, Maurizio Lombardi <mlombard@arkamax.eu> wrote:
> There is something that doesn't totally convince me about this length check.
> Couldn't chap_r contain those Base64 padding '=' characters that
> would make strlen(chap_r) too big to pass this check?

Correct. For SHA-256, a padded encoding of the 32-byte digest is 44
characters (43 data + one '='), but DIV_ROUND_UP(32 * 4, 3) = 43, so a
legitimate padded response would be incorrectly rejected.

v3 strips trailing '=' before the comparison:

	size_t r_len = strlen(chap_r);

	while (r_len > 0 && chap_r[r_len - 1] == '=')
		r_len--;
	if (r_len > DIV_ROUND_UP(chap->digest_size * 4, 3)) {
		pr_err("Malformed CHAP_R: base64 payload too long\n");
		goto out;
	}

chap_base64_decode() already handles '=' by returning early, so
stripping them from the pre-check does not affect decoding.

v3 below.

Alexandru
