Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2D3393DF2
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 06:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785824681; cv=none; b=dxHWkA6okLhyu6chrD5atqS7w+xj1j25lrBvUquTqoggkrZeEmtEStKItra3pzO4AU9joaFLtaM+z4T9loorHjfbWpMdCELZJGVy9L4xhVibRLWh5n/v5HHO7vTBAFp9gIolPp3tMPLhRMOulDDy4P6Vh4uqIHOdZvO0+IOS0xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785824681; c=relaxed/simple;
	bh=AcaeuCEwnp/0s48om4mQgCGlQkM9biG/rwFRBca03+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awCM/HKHdK700bWQsE1QONnSFHRS554BiDLTFSvXvjDQS+q6Lk4hcr+6tUt6G+0mfXRzq6pC/VKDofKpQqZ4Aac/cjnY+Sw+cM6b86AjA7HjnQXp5BilJ63JLF+UtSPi7IhYnTQ1qdG8HzTS/Wkfy524krpr7f/AdhqQYXrBUZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=rHnoHaeu; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="rHnoHaeu"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2d049069377so36108395ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 03 Aug 2026 23:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785824678; x=1786429478; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AcaeuCEwnp/0s48om4mQgCGlQkM9biG/rwFRBca03+w=;
        b=rHnoHaeu+vADywZlv9PUgbqwEHjgdPUdYX6EKwaMz+vKanoIEuTd77ZS2tATVot/DP
         NfNP7M+yswKBM6sPffKQqbmYLWTF2O0jpmoRbP0BBnL+jfUN1Jf2vkqmg98J9qPYN6W0
         7x9tFHW2mflv3LH+sn+iJreYLNexWUc4W+Nq/DWijtcm198SsSLKRzStpQ0pa9BL8BIB
         O069bRqRjPmeAT0/00iMk4jVMiYhKoDoTRw2OZRK84HHcCQr0asjjYCSdqRQhAukOjBU
         gbAA682N8AHSAXD73LFAFKxZAiX/i+rq5LWxXfyBc8O1FCD54ZQHRO9sczE+mcSaeNJ6
         mfNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785824678; x=1786429478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AcaeuCEwnp/0s48om4mQgCGlQkM9biG/rwFRBca03+w=;
        b=c0vER6U6tspPtw8iW74N2sPHg3ZdSq+vpLPze2g/S2Fc3oxGBA6EYZP2504Fk2nZa9
         FqQZfedMNELojvVr8QhFMjixcnQ2nS36kRPxUKoZk+4Vwj4LIfIwJM5ipBPvxbgDxt5H
         gF7s1159ug2v7cIwbaxeAPzeqwNW/6X9++Ej0q988t/kWzAI2EePLBweqbGElXB36hub
         +Di5DgSKRhsu4c6CPzIO2inD3tfqJBeo8IUz3JN8d4J3FDMSBXun9jZFmLuVs7CGkvi3
         KkoLyhWXSs1BJQmVMkdO2zIZ3SWGpEAavQY5ClKAbVTdXRVW3ZxN+ubuIu4s3JsmOEci
         6BHQ==
X-Gm-Message-State: AOJu0Yym2zJLoyCsi/SkmKdRgTpZdHWH4CKvKeg1ppn/HTriZCnsvxPC
	AP9auczX6WBJs/ir6rq52a8blp/of9s8cqivnAgFaxeUyQSz5JHFuflpKF5Pd2Q2588=
X-Gm-Gg: AR+sD10aXxfafzjFVPNs7dyTugda8pKRISLMdYp5WmK6joXdClrZUc53qZkTRn/9RX0
	qPenBFkiZDmWsF1tAHWm77CaehAvdP35eDFsOsUM4fNoUIK99SfmqsU0bH2M9O88uIcsV7A0W1z
	KnxruUBaWw0dQWJFpEgpQlmYKSnXRHA3detf3kuRFl8pkDON6qyDz9eEcISvlpzqyRzkTa8aa/j
	Ty9H5xQypNGNfbK6gAgcARmWK7ZL7TMdFtVTcEnGSS4QYXwwzmw/OmVCAGcLqP+FvY8UT23tO8y
	GC08vQyAbi53G/RZniS2LZ0ttErSKD6oP6f/WQddkjHne7NKZgJsLGJI2FOymF4j1iUDZ3RpIpM
	Lk+t2mwSKnooLHwtixKzbFDODZ8UleibVUWRBFpdiRAbdYDjihoNFfDdj0sykk2C1pUGssR4qB0
	x9715CZ72tVEpfJYR/8HJ1HRtMZ7HYgr6QWcrV0mYhJV2zY07qNl9/ncCJg1Ntbf4uElZXO/ZRd
	v7d0nY=
X-Received: by 2002:a17:903:46cf:b0:2c9:97a7:f544 with SMTP id d9443c01a7336-2d0524241c8mr126575895ad.42.1785824678519;
        Mon, 03 Aug 2026 23:24:38 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0aa492c74sm404395ad.54.2026.08.03.23.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 23:24:38 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: Re: [PATCH v2 0/3] scsi: libiscsi: validate task lookups driven by target-supplied ITTs
Date: Tue,  4 Aug 2026 15:24:23 +0900
Message-ID: <20260804062423.2268122-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260804040546.2264137-1-yhlee@isslab.korea.ac.kr>
References: <20260804040546.2264137-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two notes on the Sashiko reviews of 2/3 and 3/3, both marked pre-existing.

On 2/3, the same validation is indeed needed for the other management
responses in __iscsi_complete_pdu() - that is 3/3 in this series. The
second question there, whether an in-flight SCSI read can complete
without transferring data, is the third case in 2/3's changelog: a 1 MiB
read returned 1048576 with none of its buffer written. The task->sc test
is what blocks it.

On 3/3 the reported lock inversion does not hold. iscsi_complete_pdu()
takes back_lock (libiscsi.c:1358), iscsi_check_transport_timeouts() takes
frwd_lock (libiscsi.c:2249). session->lock does not appear in libiscsi.c;
the only mention left is a stale comment at libiscsi.h:131.
