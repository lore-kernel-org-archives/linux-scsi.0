Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793292595;
	b=1o/RASGsRrdX7izd48sCA4cPosrC+5sVpJW9MVjYFX4ofmY/YnQuX10//ohrYjTb6oDe
	 SXKGuqgvxZCyvYMqGkTMLCnzD61wCoL78V251T2Aju1RrN8565Jwy0aUVa94a50M+sb5b
	 EsPeXYi1kGtUMre5hnJiRa/Q3cbsnYLd8MtLASLQqS5JzB+IJAExkcIa8W81OTU9cUsgY
	 3vA59lZdwndxRFGteq7XxQGcD8W3YzIl2s64+abfVoIE+t14mq7OSozRtJhtMJ996eTGU
	 p2BWNqHfiw7gvqMasvMoDRnEX+WzJj69P+Zac3h/pkO1LkC/aQW+fRl9sWhoClAJjFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793292595;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/Ihe5xDRm7YzAbw2ufUadalpI7O7ZFyS8M5TV5k1zvs=;
	b=NcLBCEWZ4e5aS5Q+d0ViNZ2ddmqFwcJIH+dSsJT9ygp1nzy39Wi0ufBdDqxswWdzGPeM
	 GUoEC7eYUGS1iWogDwXmjlfO4OSgqJvyz1k3jdLOoepYM7Te2o0zmPO0LZ6tg8QSHUCvw
	 z4aX7gvDEZy7U3lS2QtpcGMv0u4HntUeQ2WycYhQPNz/VjenE1DBuuWDwBzt3wxOp5Itz
	 6Do1isbanWaekQw98GwaXd6MJ8BmXG8GWGYj9YeCgLJC2TrnWdkj54zL8EQCFHZujTS1B
	 1PtmSxbXwy+xCeBF9jOwpIob6a403s1F5Lqu98zO8d6a0Jvk9wmtI0KlAsF2cx6b5Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=AZaGTcUQ;
	arc=none smtp.remote-ip=74.125.82.46
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272E6606A31A
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 16:49:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 272E6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=AZaGTcUQ
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-19305bcb72cso2255492c88.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 09:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1793292594; x=1793897394; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/Ihe5xDRm7YzAbw2ufUadalpI7O7ZFyS8M5TV5k1zvs=;
        b=AZaGTcUQbwwvAFJn+7wMAoQGerIVzwfWyezSGcVfujYsj2pmx5ArhWEtU2BqkON4KI
         5iDS3mTSysGeU6sQn4NIaTdwSLrx8USbZ2p+9n08QmYjbTO3AOU0tZz0NuFwuYsyljq8
         1Wx2G8cFztlHQfc+GYbGB86koqAx+DguiWmEh1UBzdTAws01PQC2qMQ06M316Joc/S+5
         6vmgAvwNrECYAyKEA/qWkAOv0gJuzqKkeL2Hs7W+Aqs9pvrghsWHtk80m6JNLHqSC7M9
         qEwn4zbJOc3dCPlWcjaiO4uFLQ14rNGsF5rwlNI8IIRBQd1W2JEVh5yacjxOrQDmPWf9
         dI0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793292594; x=1793897394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/Ihe5xDRm7YzAbw2ufUadalpI7O7ZFyS8M5TV5k1zvs=;
        b=w6vjzFNF6o7dv0PNbcKGD4otd/kS+4xEdBTYMVNbf+7JOk0TuULOHKQd7uD4INi5xq
         4wWm273+GPKcrRyMB1FnT9tUxy6ROI40LxUnC3zFhvfOU1UbNpz69st6cD42gfmjBGtj
         ibyCsHcWL8IJJ5FU6XMzBW0BXzFTPydgLSf+fLc+kjaMOoKO8Z4s7P0D1BriNeZmJYui
         v7eg4jr1vs3pHh5g00QAUFSLiQtOS7JaiuBn518FZUxUVkyXIHngAPM5oNKGaqo6rI4v
         1f67XJqVztfHWQ8Z+X4OjaDntZjsnzm9fTmkJoMqdi+hCzZHaNYNkdihV2B7SDXJfypK
         xBWQ==
X-Gm-Message-State: AFq9FYLwXVbJpXKPg6qDKsjiQDJlnvUwL85cIx00S5nrzjd/z1gU68al
	xInqwGAEkblt9qji0bfexdq7GF+uEPdQgRjSswzCcuIK5o1iusRMjXCp3SQPZcOUV2c=
X-Gm-Gg: AYBFou1voWUo/U39f1jjTp6T16sG+WdLmQfMCw8Se6oBUAYNReayKqVkkaL8+rMEpJN
	vl5nmvL5TPUhJrgvNP5YDER+uaI6kuH3RoVjCB4HWALtdbug9GLIFYAJn/ufbdS17FmwWVCDzjK
	ya28OsgsBUSs9rv02dmHVaWGWR20VaqnT8/wZBP+LoTDCh9pyLI+Grf/hmrVzWno1yDzFN6P0g6
	RXIBNwdDyV34bbiZ0aIXDVrPVvMvpZEKxFhih3JKHe9DHChnMINLV6ovM2W4q9PE3vffI4kTX9N
	OiZrnZYuegAjt649vUYNl/DKJNv84UYyTQre91RZxyBN12vExjGOcvH+MicNgNc3cqgudMxOoam
	S4W02pFYKM5istA9SMnWINYHh2osH4VwFq3/1YjLBA9XjdPbqtfIgm24EoKg1/GX8ojnus5YYuw
	N/6m28ZwW/tRlz+a5+eIQJJ/cq0xl9vj6J3Adjrfzz3cPHv/3INTXGl7ierO1Z3UvLvnJ2ZbH5a
	bm1y6wzl++EzzqOldeG8F8PO8aZs0FGDZMttt7pweHBY+YEwOOTIl87qMRTWgG8cd+jzEau12b+
	88206VR5eTEbwBHSGE0sKEyK3yyqTtN11/ihhwbHZaWmWqYY3xtGotDalk1Fq+rDb9CcV8IaAAe
	20cgsauG7VWBzTR3Vb+qksiH1fmP8DxiFolCGsXV/Y1E+XDaVX0Dm2Ub7muLhVxRZlCalX+9poG
	2R0npWiKJW/0WN0N+loxWAESGC
X-Received: by 2002:a05:7022:ea86:b0:143:5cb4:30 with SMTP id a92af1059eb24-1a6c85d11ffmr7356229c88.3.1793292594012;
        Thu, 29 Oct 2026 09:49:54 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.93])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1abe8ffd231sm312518c88.10.2026.10.29.09.49.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 29 Oct 2026 09:49:53 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: "Martin K . Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: Re: [PATCH v5 0/5] scsi: Refresh INQUIRY data and reprobe on rescan
Date: Thu, 29 Oct 2026 09:49:43 -0700
Message-ID: <20261029164943.11979-1-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <yq1v775f1nn.fsf@mail.kernel.org>
References: <yq1v775f1nn.fsf@mail.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Martin,

> Please address the issues reported by Sashiko and resubmit.

I did address the Sashiko findings in v6 through v8. In the discussion
of v8, Hannes then suggested a simpler approach for the ALUA unavailable
case: have the SCSI core read the ALUA state when a device is scanned,
and match peripheral qualifier 001b in scsi_bus_match() when the LU is
in the unavailable state. That needs no INQUIRY refresh and no reprobe,
so it avoids the locking and driver unbind and rebind questions that the
v5 to v8 series raised.

That is now a separate three patch series. v3 is here:

https://lore.kernel.org/linux-scsi/20261029002531.82824-1-brian@purestorage.com/

Hannes has reviewed all three patches. The Sashiko findings on v1 and v2
are addressed in v2 and v3, and the cover letter lists what changed.
Sashiko reviewed v3 and reported no regressions.

Please treat the INQUIRY refresh and reprobe series (v8 was the last
version) as superseded, and consider the series above for staging.

Thanks,
Brian
