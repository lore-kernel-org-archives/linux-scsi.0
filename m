Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6731B1D9A70
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 02:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791944394; cv=none; b=KAWcj+vqvx7IChMFHvzSLdJ/XqqfYI0pyXCkRX3+YfXLcloT6ex82Y1NFfMjC6loiZOf+i1HPD5qgpRrp3Z8mvW+UR4oDO6Uk6tm9pqpiieW2gGDWcfL2GNsD9yQ5sgc/xUArz3siCWVvRVa31eBcWOZj8D9euYOBjv1Z170nJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791944394; c=relaxed/simple;
	bh=8pqy1oMnA2IatGFDWtUZXA1HErxM5AAlotEenJvAgOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=te4uTE55YqfDTYEV50JmKYPIgOWiBTAyJyoq+Oex43NBeHHyAIoiQ4FM9+jDm/p+rRujahttaAaWcbglxm/QNdrpvqguTkDvtmXT0iP/kJjgvOQQWNHVcq9VG4fwxjSVsohnE45W+JiGMnwaXfOezr+GXG3scqGvjn20twzLbUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=CNm4TTdi; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="CNm4TTdi"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-383b4a3755fso2354509a91.3
        for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 19:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791944393; x=1792549193; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dU08fQsiwmOWxma5Ng7cjNhVY585iQcW31VdocSDwx8=;
        b=CNm4TTdib8ugggzjdkOUa8lS+AxeMxql2xxCXkEu+ptgonlqku2kVUKnS27tpFnjOe
         LZi1RDMeCV8TK5tjblbazaQ/Lz94k4ImwO72cx5dMwphwyLYI1zNrea7hhs53xzqX5iq
         Yj6BvarwUhwW0xJ2W9BNahgxf5TUQzhBnF8BrSeIkVxZiePvbCKB9YuAnnbB5q+Srr6X
         0hsOkAfz52BzA5Q7SW55xlYytu9VffGOLWSVJCuYQi5bX3/0ww2vxmtfVMdFICIPlBi8
         usQ5wpAXJvyRbXyKW1k3GF9uQVOvCfjgOOdWhxoPwlVJcVAUWPEZ2ONEFIhVEoSL0knn
         3I9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791944393; x=1792549193;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dU08fQsiwmOWxma5Ng7cjNhVY585iQcW31VdocSDwx8=;
        b=UG58snBV/Crd8pvauQwGyZA3EsqqEIL5DxKfRt+fYF+J0LOKNrQifsw9s7o+w06IGY
         sJll9FNQFgCXJnF5PQb046IPGa97Q07Lfz1xz4HV6Hk1OGZSRQZmxwW9Zua8hxoCuthJ
         ZDYLQGV9V6BvV2upAAjRNYXvjE0yos/i0Zzh8U6gCMRFA86rrqH+IVwqR5UufsM9Q2c6
         otU48xEEujN/mOABJFOQPRg0FeLYnzkTpUCF7lthly0YrG6dkuumWGevy7ZoVedrd8VB
         lxdjhjV5Lhbx5Gc/IVi+KtqTy8n32J3h4Hl/1aVbITCejWjsKe1COrmqRWdN1ZRCpiVK
         0I7Q==
X-Gm-Message-State: AFq9FYKbIfPJnxL3xMCZc2Ml26j1xczq/8nGpHG+LI2hkOZ7QRTGiVC2
	CqVJe/GitYeHo4w8fRq2TnPEz2XtPvnnFbYD/Si/n3Ol4IfrgMiJgGRTGGalKYyzE8/nR15V4gG
	EN4ZmNdY=
X-Gm-Gg: AYBFou35dMawj0oJZuujZC+YsJ/tArNK94x+2GGoiJCkCggJiCshBqIGRbqzLGUoCIn
	NMK54FPjR4Rbb5BLTDPxnvF31QqUlSWsj86geSE5FxEychfngT6oDh3YaniDLt8wIf2t9h1p13D
	+f0lWuFDYIh/OH6JThIz+CH2tZKNt8tBz7oyKgEecSrdXLWngJDN4pDC7YuIQ+tMJpdOTyfgNuT
	e/eT5FqpqX5MKE3J0RAjC6AIqDchvuC6asMcml1An0Lyg6VmnfDL7w0423WFrSGbN4reioF9eLS
	LkqdTOuHYPaeYn1rd2WD+7qPldvynuWuC4j2Mltwxf5ysr+czpsuQLOLizHaFeKRsob7wAbvKr1
	coyUJfMb4u69FU49FDVZDajOWucsA3FVPNItwy9FZkGXAqom4EYZZXCBq6+RhSDdpco5QYO9Lq5
	HlHyWmbs5lVAty7lF3Sf4ld4tJp4170i52EPtBSTAgwMUWTq/odDUfa8JDqEezTsmbB0c7oQ/OY
	r85H4QOdSvDxJ8Up9MO
X-Received: by 2002:a17:90b:224c:b0:3a8:bbc2:5551 with SMTP id 98e67ed59e1d1-3ab3a0f0a1dmr14151443a91.0.1791944392675;
        Tue, 13 Oct 2026 19:19:52 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:c51c:be8a:c517:276])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac5f05083fsm2254652a91.1.2026.10.13.19.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 19:19:51 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sashiko-bot@kernel.org,
	"Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v2] scsi: mvumi: reject handshake sizes that overflow the list allocations
Date: Wed, 14 Oct 2026 11:19:44 +0900
Message-ID: <20261014021944.3486511-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-170674@kernel.org>
References: <20261014011808.3479480-1-yhlee@isslab.korea.ac.kr> <sashiko-outbox-170674@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Thanks -- v3 addresses the reset path; the find_first_bit() point is below.

- host reset: v3 rejects a reset handshake that reports sizes larger than the
  ones the buffers were allocated for.  mvumi_init_data() does not reallocate
  on reset, so mvumi_hs_process_page() now compares the new sizes against the
  current ones when MVUMI_FW_ALLOC is set and fails the handshake if any grew.
  The shift, list-depth and list_num_io checks already live in that function,
  so they applied on the reset path in v2 as well.
- find_first_bit(): this is in mvumi_hs_build_page(), which this patch does
  not change.  The 8-byte read on a 64-bit build covers list_num_io and the
  adjacent ib_max_size, both members of struct mvumi_hba, so it is a read of a
  neighbouring field rather than an out-of-bounds access.  It is pre-existing,
  and the only input that makes find_first_bit() scan past list_num_io's own
  bits -- list_num_io == 0 -- is rejected by the check this patch adds.
