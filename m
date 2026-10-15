Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F225D3EB0F4
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 05:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792043851; cv=none; b=QXa81+lBtwhDskPgR3iV9xcVgfj9rSJqigqmyqsXgjwP9wyYEbYoME35UHTP31c+Zn7mJV9d3YV1Tn5SDRXTd9ka0FHRx4yFcolflAAOhn0a83U6fw8MTEO7OnpJxPcPN6B4u4iaBgQjCjo0O5T+2mxKj8JF/UYKhD9r2ppZVPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792043851; c=relaxed/simple;
	bh=Gu9fyWinAvgvqlFRdUdXuUAiYzPurMc/0XfPUDWQ9n8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p1IY7TUg8QXCPTkY0xVrd8zLX0Y7wnL25UvyC8cQjHR/kpn4AsLlOLtwzNpi1EuAilKw529kENGJk0uKzmPQ3famPB8pRArsTy5o8mGzbuf5z087n/472pkaXJspm8Ku4h1qnGHKCLFtQtMULH/0pm3zVOl6l4UN8MO0CESj50A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=fCx9vPQf; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="fCx9vPQf"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2e86dce4510so24934455ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 22:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792043848; x=1792648648; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Gu9fyWinAvgvqlFRdUdXuUAiYzPurMc/0XfPUDWQ9n8=;
        b=fCx9vPQfVa2v/tHm0I3dRtjRxrpWeT3IHrXPRPQV1pbdhRuEeWYUJr5WY7DXTVRmgB
         +vt8UArJcyWQq7oepRF2ZI63pHEtvCnMBl3OEZAnSpSWmoyHkzMGzKWIBTi8o5oE1LTB
         20a/tj7x44soiNkFLtK9idgOZn+sFHNEBRtMjJOwqzS/4XbO1n2nfoxWPd15JjIqXNvc
         JltIZcrBrDCBNk8MqoOcCAe4iS4O9vU5BpZDxnfOTfs0vGrCqEHiLt+CF6TvnkCdkMF4
         QvLeXDfH0s8CPVh/s0yhRriuZQ0ThF+taSgXQrYGbUVwvWNqi8mqZ5vhP2czL58Q3WwM
         9LCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792043848; x=1792648648;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gu9fyWinAvgvqlFRdUdXuUAiYzPurMc/0XfPUDWQ9n8=;
        b=CpfURFxnOHGjJUp5ikPFM/55UFpPmHIxQMERwUuhNQnSoqtYkjVHw2KWvwhqjNT3r1
         1lJnt4mpGLEGCa37dTakF7iu4A7ZGFXKKNyZZfrFdGW9PxUXLizNZnPp241dxcM/GeNE
         R0oQpamQS1BX4LnFigrRKU7LrVr0m9/LxaVn+YY0hZR1Gx7y3Ot0kUgf0Gwhu/xz7KZU
         v0Qdut9RFGbaVN4M8DHPL228JiV+T/NpW3MMbw5uAxVXnZ3UzZsgN+Uutj/HfLdY2ZE/
         Gbyd8hm8C78bsIgeCLja/hNJTdaJH5TlOrLEtPKvIY8RjZijfgtpK0HVqEEeJwFdSvGP
         u1yA==
X-Gm-Message-State: AFq9FYKsXxTMzQbdnVxn/0vgnS1RXVzRMC7HdxC2b6rFF9nUU3u3OTOk
	0YiALyLs2MjWyiUNHk2RykwYH4Np/LcWKPCvIImjH23ZxcSZo0+T7JPI5IFuq1wM4UQN4zQ7Yx+
	FlGRy
X-Gm-Gg: AYBFou1ShzJvA191iyaJ+b9RXY+uPY0vik316x2Pr2lazvWYqx7eEFsxongv6KzJd1r
	Cc6DaeG5o0CsAANsoX/T4Cp6VO2/zjcPzpvYjWNp9LbO0iGElKGgVL1MjU7PWBUIQnWET+HIpBH
	KLAjbyK/e8fMefHDiUdL0yGTUXwDpSpuDzq37gsF6PcN9s+Rr2FPogWkZJHJ1rbXU0ZhQUwdKGU
	aQvp3YJcEokj30by8KZWODlTiE+uPKJ2qlvEe/nmtWgKywnIwZP3Cdcp/DcxAQWlrVsdbGsD2E9
	JQJE//r+BR9jNkusJsCTDJs2N8UCZP4qAiNyWEGojno/3gwQgIwaBVnbbibeJd8ZA+LuWlad99s
	CkH86e3rJhrTFEbUAvHsYqtDnxiooZk4ZSG0tDLm5vRYQOTaApTQA1apTX/Q7uSbf2EQ5Bck9No
	z9pVw/VWEqO+gfpjI7o83aR/Jw03QfIzjDy9+ih6ibOdhb2IBvIw2jOuuAkboaqmvUu84dEqTZo
	9FO7w==
X-Received: by 2002:a17:903:2f87:b0:2e2:dc54:3148 with SMTP id d9443c01a7336-2e842f18260mr133884255ad.66.1792043847931;
        Wed, 14 Oct 2026 22:57:27 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8422b78ecsm80232425ad.48.2026.10.14.22.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 22:57:27 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v9 7/9] scsi: mvumi: free the internal command buffer by what was allocated
Date: Thu, 15 Oct 2026 14:57:19 +0900
Message-ID: <20261015055719.3992456-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-172292@kernel.org>
References: <sashiko-outbox-172292@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Thanks. Two points across the v9 reviews.

7/9, the DMA use-after-free on an internal command timeout: this is real,
but it is pre-existing and this series neither introduces nor widens it.
Patch 7 only changes where mvumi_delete_internal_cmd() gets the address and
length it frees -- from the command frame, to fields kept in struct
mvumi_cmd; mvumi_issue_blocked_cmd() and the point at which the buffers are
freed are byte-for-byte what they were before the series. The window is
real: an internal command (scmd is NULL, so SCSI EH is not involved) that
the controller completes after the 45s timeout would have its frame and
data buffer already freed. Closing it needs either an abort of the
outstanding command, or freeing the timed-out buffer only once the
controller is no longer bus-mastering, which today happens only at
pci_disable_device() -- after the buffer is already freed. That is a
teardown-ordering change beyond this series, and I will follow up on it
separately.

3/9, the endianness of param->size: as in the cover letter, the driver does
no device-to-host endian conversion anywhere and uses these fields natively
throughout, so the check follows the existing convention; making the driver
big-endian-correct is the driver-wide __le series noted there.
