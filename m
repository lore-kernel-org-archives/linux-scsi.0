Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795192794;
	b=jlrEpciVWAgyyqhshjRPMZ0G/ufp96azauidK+cIVJrUC/CP+WIil/9wHKpx08NJ67rf
	 KuAPIxaFcd2NtPu4wRKw4FKdBSMwdNgM2bHI5Pbk6KzGzzDsy1tdYOm8qX7mgLzNgcH66
	 OtbmrpiOdh7KRopfLUP2acoXe0iBpazviRVhM6NCF5+S1A+GyrVAE/h909TkIcWidkktI
	 rhba8c19dCRYfP5ttQVqZeaJqJWvPi0mtVYnBrUdC02KisHfnfhRemhs8YLXkpSEfRYny
	 o8AB/WHk/lOgss6p5iePYSN/OeLjRIwG89CUp4OzcVdJ9/YgwS0sTa83UsIqPDDZb7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795192794;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=X7CKRTq2Up5l+f6XzAeKjlVv2VDwIKbHcnq42YBLBPQ=;
	b=AyLvpseJeVlDjf+00WELXmaiFjfUijFOZnqi2vs9xDG6o61BsIv+qpUlkX4teKJa1BKB
	 A5S1TjYqtfPuz1zkfsZ7LZEQImcwcNrQQeGamr6mZw4OHpYgdXrhR5f5fRxz354yQFxoS
	 X8WzGzOVwvQlFxhjey/foehuFsWLo8w1idCdrp8h1pUDhKeq13prswjbw/wC23U/cdsfS
	 bS563N2utsEeTGOSjJpFZpgEcz2xJfOJl/Dl/+20Rff8KteWcYQX2D2WIQRGoam1wtrAg
	 JzRAX+R4pML4IrKs6ksFBWecsucd3pfy6DrKmxP/2npOGQepiWtfrTeqtMnuQ3FDq0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=nJJxJhL6;
	arc=none smtp.remote-ip=209.85.214.170
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D242606A336
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 16:39:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D242606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=nJJxJhL6
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2efddf749e5so10312075ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 08:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795192794; x=1795797594; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=X7CKRTq2Up5l+f6XzAeKjlVv2VDwIKbHcnq42YBLBPQ=;
        b=nJJxJhL6n2ctqodT4EO+rNssng5pzWJwvOdKOT/lwdgUYaCFmKn01hkVOK9LNnVgDf
         UdE4GFf4WjDHjSz5Uy/tidBzhiYC7xOhiwWXWpxNd+TSwuSXkX9GUlbtSBlmeMBP38l5
         6tPP+0WujmTqCfnRhc2ujdjHZjP+nBzdu9Q2HzEqBv/sADyLKk7AJZ+uFiqyBtwv6N7f
         1tByluOfG4UN+R3dbNJUbvPF0EXO117JGSiU53rmtTyYPynX8wYmcCl2CvF1pq7eyHfb
         Er5fRjfW4z4T0lhLe6rEs4/MmQXXyguIHys6HloYfyUTv4j0SCVWDaB/FwRfZvetyFzC
         qEqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795192794; x=1795797594;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X7CKRTq2Up5l+f6XzAeKjlVv2VDwIKbHcnq42YBLBPQ=;
        b=y2pi+iLyUulQIR6ryuGx23E5jeLbcEUnHr57ydjlWltC1cwuBDGjhQMPONPzHWpRko
         mc5uhGzyjPW7VE2vAsaqDjPREWLkEJ5G9JNskcIg8riWx0zK3uffGN0boJ07N7M4Tio8
         jE53P2kL1yt/qEkCEKY7M6vv64d6XeKw0t8Z1ng8l9QQQMVMaLlJKj1uzw3oJk47nEpu
         dEk/cfJnkMufjIvOy3XI/N0PW7JdAusqbXTnB5oZ+d2yqKIwBM0TQUfeqPwhlZNSgxvI
         qt31/sr6yTlogcYOYFhgaSx96YQs0f3V5lwqJZSAin/05gIha4xSCKCSkDvXUBCgWpM2
         CkGg==
X-Gm-Message-State: APuU4Z8U78BRRWB15FCBdy53ISmKzClJpwiIxQsaBvSLf/Saczv9ZxeV
	ICiIGcyOdQd+blwXfZjpq3Th4GluVgTunJ/hS/hwrqE9YK+bx1ayduncOzLagEk8nb8=
X-Gm-Gg: AZFdTZfO0sXn8Av67CtbQZFyOmbwlW53EUhVF5OTbdRSUwFoRt76ufDUG4pFMX5Czve
	YZRFkm7EDWkznWBUNkKE227dWW4pTnjWx0qS3qLwFaHp7pR+C3i4qPwwnS4dkv5+GZywBF74GVY
	ri86qS5fTiTWJEE4AcmlEo3eV08JzJieBtllttSyrL7rhJJcFVxnLDiUMjoUtuRyB+kuUJlGeuB
	E+BLtQwoxcWzxXWLHr2w5Fpnc65vYr6CP62ySRTOGayqU4OlVgGmbjLziGWvBMzFrEbLLeeDA1u
	ho+YiU3m9KjCitGzaqv7uXXIKrAyH4kp6rpnXEdNCD80hVQPWkwtHStBoWrYu/mDwp92rX0eVy7
	koHGTaazuN85wowaJkLvFU+vnBgo8C5O0UcQsuLvM2XNtdwAoquRO3VY+xpKJGwzUl0QdwA0/kW
	CneOb9/Er51Z80lazhvNOXo7SDx21fVWPviBSUPvH/9fyg6qfxv+taaO9F7ITe2xym+57fLJz/A
	ZRuJnG6Kcn1pZMsP7q2HHGfeZswbHH9bTiWJwpEK67fN3mG4UAujRHK7j91NNlpyjl8L0yHvRLm
	ooLdLezmXIrMQe5A/X3gPS+ga4YrK+EGfJ1e2THrzQrF1MnUK58Yrc8Oz7UGr80jQszpNWap6JW
	dQBuig79anqPGLQNb3Kmn8Nbpl33BEwlcA64y
X-Received: by 2002:a17:902:e847:b0:2ee:1c36:e25 with SMTP id d9443c01a7336-2f03f211940mr28621045ad.35.1795192793950;
        Fri, 20 Nov 2026 08:39:53 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f14a432sm16865065ad.75.2026.11.20.08.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 08:39:53 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH] scsi: libiscsi_tcp: hold back_lock across the copy of a Data-In
Date: Sat, 21 Nov 2026 01:39:48 +0900
Message-ID: <20261120163948.3238659-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-225445@kernel.org>
References: <20261120145243.3124991-1-yhlee@isslab.korea.ac.kr> <sashiko-outbox-225445@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, Nov 20, 2026 at 03:15:55PM +0000, sashiko-bot@kernel.org wrote:
> Should iscsi_tcp_hdr_dissect() verify that task->state ==
> ISCSI_TASK_RUNNING before accepting a Data-In header and setting
> tcp_conn->in.datain_task?
>
> iscsi_itt_to_ctask() only checks task->sc and session->age, so it also
> returns newly queued commands in ISCSI_TASK_PENDING on conn->cmdqueue.

It already does, in the series this patch follows up on: 3/4 makes
iscsi_itt_to_ctask() return NULL for ISCSI_TASK_PENDING and
ISCSI_TASK_FREE, and 4/4 adds the task->state != ISCSI_TASK_RUNNING test
to the ISCSI_OP_SCSI_DATA_IN arm of iscsi_tcp_hdr_dissect().  Against
plain mainline the PENDING case is real, but it predates this patch.

  https://lore.kernel.org/r/20261117101500.1894608-4-yhlee@isslab.korea.ac.kr
  https://lore.kernel.org/r/20261117101500.1894608-5-yhlee@isslab.korea.ac.kr

> Can dropping session->back_lock before segment->done() let
> iscsi_tcp_process_data_in() complete a newly queued command that reuses
> the freed ITT slot?
[...]
> digests are enabled, iscsi_tcp_segment_splice_digest() sets
> segment->sg = NULL before receiving the 4-byte digest, so a subsequent skb
> carrying the digest skips the if (segment->sg) check and reaches
> segment->done() after the task was already freed.

No.  iscsi_tcp_process_data_in() never touches segment->sg: it verifies
the digest and, for ISCSI_FLAG_DATA_STATUS, calls iscsi_complete_pdu(),
which takes back_lock itself and completes through __iscsi_complete_pdu()
like any other PDU; a task in ISCSI_TASK_PENDING is refused there by 3/4.
That a target can send status for an ITT whose command has been
transmitted is not new.  The digest path is the same answer: after the
splice, segment->data is the four-byte digest buffer, so the copy that
skips the test goes nowhere near the scatterlist.

> Does unlocking session->back_lock at skb_done leave segment->sg_mapped
> mapped with kmap_atomic()?
[...]
> spin_lock_bh(&session->back_lock) while inside kmap_atomic() /
> pagefault_disable() (which violates sleeping spinlock rules on
> CONFIG_PREEMPT_RT).

Not a problem, on either half.  On CONFIG_PREEMPT_RT kmap_atomic() does
migrate_disable() and pagefault_disable() rather than preempt_disable()
(include/linux/highmem-internal.h), so a spinlock_t may be taken under
it.  And a mapping of a page that has since been freed is not
dereferenced: the next skb hits the segment->sg test first, finds
datain_task gone and fails the connection before any copy, and
iscsi_sw_tcp_recv_data() tears the mapping down once tcp_read_sock()
returns.

> Does the conditional locking across copy_locked trigger a Clang
> -Wthread-safety-analysis warning when CONFIG_WARN_CONTEXT_ANALYSIS=y?

Correct, three of them, fixed in v2.  clang 23.1.6 with
CONFIG_WARN_CONTEXT_ANALYSIS=y gives one "spinlock
'conn->session->back_lock' is not held on every path through here" and
two "releasing spinlock 'conn->session->back_lock' that was not held" on
v1.  v2 moves the copy into a helper so the lock is taken and released on
one path, and the file builds clean.

  https://lore.kernel.org/all/20261120163857.3238489-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
