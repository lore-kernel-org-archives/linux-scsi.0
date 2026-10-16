Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEC0236453
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 00:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792109732; cv=none; b=Xr7VXF7sjHuiQ2CuHYqU6SoRmWyxOtzldeROw9t1pRS+kwjJWCwrOtzEsRh8+5kRmh0J8OMPyOfjmPXu9Y9HcU3iTWZQp1n/556ve1rhwHRTfKUur+arjApY0rQtW/eekAvqnrSG/WtYIT23/CdMQc5HrMGjuq5khr1aLzR53c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792109732; c=relaxed/simple;
	bh=+Mg4GKIG7vBJxh3Spr6i8YJoCnvsDKGxlhwXDi5Dpfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MVNw9wOduJBf9c+uVUfymnETAyXxfE+biQ1+H3wdD3JWi2m9jgwFB/nCEFlBh5b7njez+lO9IswKAHtmep1eSkZW+/QGk2Vd6FfNHxiJwGgTwFlDbrtuTQPNNccEv3V6ppJQESlKYFyym8rvsXV/VgA+2b0U/FDj20Hhfj6p+CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=ytBAsO4R; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="ytBAsO4R"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3acb512a7a0so502732a91.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 17:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792109729; x=1792714529; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qG3Z5711Og3u/lGH7QsJENyYY+NO7dBeUmZ2sJ109RY=;
        b=ytBAsO4Rqh3MCtIUTH1vkaCLST77OYPjH5rXiTDKSLeNk0Sj5V8k+RNYZqLv1J19HW
         0+ke1tyhfudsq62JWLBXymWtzvm2ajDGptUMpByc37KaW9JTfp5ALG0TRt2HCsqOtoiZ
         cwHXdo2HODd27/ZO3Y4pzjDWAW1sJGO7nzm9o5TsSusfLhu+IqQhuAoKDvzmL/WX3hBq
         +vZzRSbv58Dwz5BzqO3YLCK8nLKCu4S+RNYrv0YmTOPByrtWO5cAde09fA1tdDl9OJ6T
         eQWRFtSiWzi6conVXNpP1l/aqpZQisiFXpHKuNmFMqIaI3l7uKht/vhJzWJ0Hujh14Is
         gCXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792109729; x=1792714529;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qG3Z5711Og3u/lGH7QsJENyYY+NO7dBeUmZ2sJ109RY=;
        b=ThvfBlIXl+WsuwUqj649ufAe8daFqvL6on+wHnGLVtlpC/+KagU2Duk7g7fHoYVVjO
         UOI0RKG3+1Tr77dvarcYGSQglEj/QYt/R0lD87cR+6AQVE3JJUMQ3EXAb7nrr3qwxdJz
         CNpMZNs4vPCtAMQA361runyIWhDDKnl0j8ThIIpCInlRXdh6hUzKIgPhRklSz4do6ykU
         ka2YlvCv3FBULUwMaOgj0fWLthWgixAuWhZ/j6p8stCjUFYcg3vlNqpt+52fImUKv101
         51vusHNaOHquXGGvD2el7Fw1Md1ZJ7C5J4O9t4mG7xP0ADWGLUY60mtx4Yno0PwSjvPP
         JyVQ==
X-Gm-Message-State: AFq9FYInqqoVsl6EkQh6r2JjBaouxplplR4vmgJxrp1pBWpiisXLTRFX
	Tb2t5TrFA2OfDiQdhknEq1jUWSbkxRbw9PPZSYY8zrkEC1Vs1Ep5G0mEOtn90RrGXXM=
X-Gm-Gg: AYBFou2U1jQmIuntJ4R2t86sr/0xUGqEluHwCZnKPTnjdMSMGp0rf+ftMCIgPxx3PWK
	jHXOtTEo35MJorJ3ReAErObcACRvO8F50GbJ++lLty0sTFQaAHlvo542SO5hcYIjSJl3seXA8PS
	9K99n8v+OxNsJl/iPq1TAxWQNRzXgOU+RcF3d3alpSRz8B6OrNLkQND22HPx425VKXSxUL6LzOw
	7Uqc2c18eMUvuNshU/SyBiDvpdNeSrDU5ld91Q7l5JL5WjuIa8VdcXlezaPwnRvGo4ntynzwKde
	GfZD6rySX7Bon9tje3XtBMpsEWW5XQ4mJu+tK8JGGHP9khhduEGZPya9X8RqyxeDkL2cbWgRM1j
	aRzM2Q7UQuphy2hq+o8rf9CR34tTljsNNxN3I0TrA8caHP3ZD29e7OOcgvkwRQJH7RbXV1GoMxR
	yyv9CGOiSCk4GH1yKpQQmdqy0ccUfqd0U3z3sFmgzCk0mgcnidN8lL/VKwn4YJTQxZIou09t7qk
	IsOiR4m4M/odMTw
X-Received: by 2002:a17:90a:1196:b0:3a8:a1f6:3b32 with SMTP id 98e67ed59e1d1-3ab423f7336mr10912239a91.38.1792109729218;
        Thu, 15 Oct 2026 17:15:29 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc487cccdsm1311466a91.8.2026.10.15.17.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 17:15:28 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: Re: [PATCH v3 2/5] scsi: aic94xx: validate the EDB index in asd_get_response_tasklet()
Date: Fri, 16 Oct 2026 09:14:53 +0900
Message-ID: <20261016001453.232046-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <06bbaf40d9188e478c4b58eaaffb58139839d217.camel@HansenPartnership.com>
References: <20261015091747.4184349-1-yhlee@isslab.korea.ac.kr> <20261015091747.4184349-3-yhlee@isslab.korea.ac.kr> <06bbaf40d9188e478c4b58eaaffb58139839d217.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

> have you actually tested this on real hardware?

No -- the hardware is twenty years old and I couldn't get a board. I
exercised the path by fault injection: built the function into a KUnit
harness, fed it a status block with those three bits zero, and KASAN
reported the read one entry before seq->edb_arr[] without the guard and
nothing with it. That isn't evidence the sequencer does this, and I'm not
presenting it as such.

> is there any evidence of the sequencer ever setting these three bits
> to a zero value?

I can't show that it does. I looked for something authoritative -- an
AIC-9410 done-list/status-block layout -- and there's no public Adaptec
spec; the sequencer is an opaque request_firmware() blob, and the only
in-tree description of this field is the commented-out size line just
above the decode. What the tree does settle is the decode: the index is
one-based, and the same seq->edb_arr[edb_id + edb_index] access is also
reached from the empty-buffer path (escb_tasklet_complete ->
asd_bytes_dmaed_tasklet), where edb < 0 is rejected before the access --
aic94xx_scb.c:410, the 0xc0 "no buffer" case. The response path reaches
the identical access with no such check. So it really turns on whether
the sequencer can set those bits to zero on a response: if you know it
can't, this is dead code like the second comparison and I'll drop it; if
the field is as unbounded as it looks, this is the guard the driver
already applies to the same array on its other producer.

> Why the second comparison?  As you say the value could only be -1..6
> and ASD_EDBS_PER_SCB is defined to 7.

You're right, it's dead -- (resp_sb->flags & 0x70) >> 4 is 0..7, so
edb_id is -1..6 and -1 is the only out-of-range value. I'll cut it to

	if (edb_id < 0)

here and in the aic94xx_tmf.c copy. (scb.c carries both halves; I can
make them match whichever you prefer.)
