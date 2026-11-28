Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795857992;
	b=ohLUE6rJAHfHED02C0HBQdELUJeb7qECP8hgEvlWhdhHbiPZnD3WSt51eq+aJpDikauT
	 4QQSRPWhGaqveumf56rgUfnudPQ3hNYvE2K9XwR+CgXWUrTWZdWjis2M6l37JC21f508B
	 HxkcK03we0Hit7+HvIvnoda6OzcSVFzhFjg4jIiZpGac5LFK1mMUZoCD6bdrCqz5q0Qbv
	 VUmREUwvCxlaGQ4xqHYecbfl+UsaqRGvZpEgB9/QrumHlLvVKpBpdUE4eqdZdYmsRNBol
	 YD6Cws+1EIX6aV/z1B+EpXh9IJTMrIZFZTCt459HKRCs+O8OjbO30hQiEYlmybsoEPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795857992;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:Message-ID:From:Subject:To:Cc:MIME-Version:Content-Type:
	 Content-Disposition:User-Agent;
	bh=tdLkNGqwXWjcjO6fjZ/pKxrW+PPoYQ4yhJUHrTAmaIc=;
	b=wdJI5BEQ71vC/3/pGSy6ckPwQPL98F+T9xCed6GxnToZGhpKR9NISac6D/UcS5p6zPSk
	 6qMihWiVICpaTHzj+eM4iRSbPqbPksqQWm0vxJ3u0f1sKxrdGiE4y2CPVtMPx6/1stEg9
	 Y15B4BkkBs6b3cwJ8LrfQfH3fSHlJxzGzbEJZ5NbLN+Q4i8zVkEyG3wJM4WRZAMQEgG4O
	 25W01MT/WdV8w3tXEPRxaXz6HQwFwww0Hvh4SH1W4RYqbVfKWZ5XFALkhsPvWLA4A24mr
	 mtorDJfmucOWKAIeXLq+lLd2xfURt5+HLIFOfcv5g6tjgLWXaWmilxIAHmu8iR/DjHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=XCSibyds;
	arc=none smtp.remote-ip=209.85.128.173
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAB6606A31C
	for <linux-scsi@vger.kernel.org>; Sat, 28 Nov 2026 09:26:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0EAB6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=XCSibyds
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-8b4fb5d96b3so134489417b3.1
        for <linux-scsi@vger.kernel.org>; Sat, 28 Nov 2026 01:26:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1795857991; x=1796462791; darn=vger.kernel.org;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=tdLkNGqwXWjcjO6fjZ/pKxrW+PPoYQ4yhJUHrTAmaIc=;
        b=XCSibydsurMTONfd9P0H4TNm1a4sevJgxr35dF/UJ6OpmvZVzrGQDKYR9P+uW6smgB
         tkWrFWE75OQdALnvjKTHHe4p4YeZjEpcUwhZFrSeUOZUC3Gi1m8SsBq+o6lsQqBUpsst
         eaORUg1tiO3IhYzxVLMpbBNp/eEl3UICcmxgE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795857991; x=1796462791;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=tdLkNGqwXWjcjO6fjZ/pKxrW+PPoYQ4yhJUHrTAmaIc=;
        b=kuYAL3yw8KaK1PUtf9TenJJI7jqa6z8av3ak+hQisBgXVH2FpPoxkwgIzOVBqPq8dI
         rpvKyswXi19JcmwdljA9n6N6Iw4VuVIfuVXe4ULXxWlJfSvxrGrPbHB+WqsnbnxNw7yN
         5yx0DTAiBRyZzdZrci7ZDbn/ZhkKJ12HdzfGpKyrHC4nlniP+acgjYeovjZTpfIRDkkN
         XsmJkPXSORT/pbqGV/lM+o5w1FPSK0RMr3eFWpUEDgqN5ixthW9PVmEutjm+32tHFyhB
         URLY+U+XRVRbP5uqa4MWiuQqiFJD3xEGfObrXKWLIm4DZokVygdAYIFajQReaNgC0/vX
         Xnmw==
X-Forwarded-Encrypted: i=1; AL+hErFBUeAGJvXfXWKNU2/ydBtRINe4H7/r5HQwLlQqMGFpVoG3nmUpFWoMLjKW8QjzmjMHulQ3/VlP8Ts4@vger.kernel.org
X-Gm-Message-State: APuU4Z9qYRrt0Me82ox9n8t4tUw1JNub3JADHBPTxc15oCphZ9oXSi9P
	2+xi+ovvRbY8uFuYmfW4JIlL/6xvmY+1HCchCL8wek9cQYV0HUaX3weK1RsJYbK0tas=
X-Gm-Gg: AZFdTZeJ0GNplpX3Mrh9QhGg1OPTY7SxRSWIXYH3oFx9eHQy13iaDO7F1gJ9sELimsQ
	GLNyb15Y9kiiA4IzPyWIefJHlqerxxEClnEeZS2nKY0wqN4i3b7q7NyaJ8FcHzvYm4+bycVRqYc
	Gdfayu3fh6pAgcZzMPVHJY1h7WC+KLJDys4mXPogZwVpdjs8fgCQBmIypc5dKIQNOGexALovAfB
	Q5NPM4GC+j1CB88PoRLmXyuyv5HicVJXQ1X5kke4M/lL0pVYnRCNAbGrKna+v18lMnlbOJPw8S2
	5iVRWgJrDwV19pb98HCezsyFSTCd9l+QHgumki7iPqkjRb6/IrtrsxAlXIq58ijy95daHzXcy4D
	i7ePsivfl7BsNiQn2bjahbHlpArXLRkBdnmElyhdtW2Gk5xxW1y7o3LyAWUjCzXXUi1B1bkZB5r
	2Govx0cSiIcEn7Ug5JgR2OnhVqyU0P6yt3Dg3bKrCb2v0HSRTRAWf46IsYg3q8JCTt8BqoKJ9dS
	juYs1MacYZLerSVKVMablh1J1v8uxhOhJtzTzP8HRmPfkxUnBqxg3PwauD5/+tColJzHCbnYB7F
	RLwnWobYZNBagnNO5IruE65JnVrSpSSg2iKbSHloHStYD8sZqcak1AUvWrtosbiTdEh3JafEl4a
	onJNd21gT24T1OeCbdVSm0sCCkuejX4vMwkiVeVK+jX/xFw3NLEQCJI2u1xHlHmmTVG8aXQLnAj
	I8LcFavTGYapD3c25rM0K2HoVwUv/7ktaJqtPiC70+XSH1rv0WjxGcgzJWGqHmHDHxDD4CGdpL3
	nW3FMvtY42Uc8qCz5cyh00=
X-Received: by 2002:a05:690c:6d83:b0:8b1:6c4d:6b83 with SMTP id 00721157ae682-8b518f1cf54mr110028987b3.24.1795857991028;
        Sat, 28 Nov 2026 01:26:31 -0800 (PST)
Received: from [172.20.0.3] (c-73-207-185-9.hsd1.ga.comcast.net. [73.207.185.9])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b5201bb6c7sm104732457b3.6.2026.11.28.01.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2026 01:26:29 -0800 (PST)
Date: Sat, 28 Nov 2026 01:26:29 -0800
Message-ID: <cover.1795842371.git.chris@chrisdown.name>
From: Chris Down <chris@chrisdown.name>
Subject: [PATCH v2 0/5] scsi: sd: Fix WRITE SAME(10) data corruption
To: "Martin K. Petersen" <mkp@kernel.org>,
    "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>,
    linux-scsi@vger.kernel.org,
    linux-kernel@vger.kernel.org,
    kernel-team@meta.com
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

With scsi_debug and 512-byte logical blocks, a 1 MiB discard at 2 TiB
succeeds, but it's the first MiB of the disk that gets discarded. This
happens because the starting LBA wraps to zero, because it doesn't fit
in WRITE SAME(10).

Write zeroes can also run out of bits for the block count. With a
0x20000-block WRITE SAME limit, a 64 MiB hole punch sends a count of
zero and leaves the whole range as it was.

Let's only use the WRITE SAME(10) modes when a 32-bit LBA can address
the whole disk, and keep the queue limits and the modes in step so that
requests fit in the count.

v2:

- Don't select or accept the WRITE SAME(10) modes when a 32-bit LBA
  can't address the whole disk, instead of checking each request
  (Christoph)
- Clear max_hw_wzeroes_unmap_sectors when the zeroing mode doesn't
  unmap, since the zeroing mode can now change on a resize
- Change the modes with the queue frozen, so that queued requests are
  not sent in a mode they were not sized for
- Disable discard when the granularity is above the discard limit,
  since the block layer doesn't split discards in that case

v1: https://lore.kernel.org/r/cover.1794069087.git.chris@chrisdown.name

Chris Down (5):
  scsi: sd: Fix stale max_hw_wzeroes_unmap_sectors after a mode change
  scsi: sd: Fix data corruption in WRITE SAME(10) write zeroes
  scsi: sd: Fix data corruption in WRITE SAME(10) discards
  scsi: sd: Fix WRITE SAME(10) count truncation when the mode changes
  scsi: sd: Fix unsplit discards when the granularity exceeds the limit

 drivers/scsi/sd.c | 75 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 66 insertions(+), 9 deletions(-)


base-commit: efd68f17acca65f581b9f2fa9ba50c8643ab544d
-- 
2.56.1

