Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792640683;
	b=CiyzZKhwLROb+rBw8oaeFHUmoEqQUoi+VAywPSGKNbpSBOf957SHDXRAWYoFh5CAKU4t
	 vmS1oq7ZCXW4yqgUaF7lCYx8dxqcdFM54I1pI0iIB9v4fDxSctxQ84lUeNZIDeQFcj8pI
	 An3G21s0m97qOJ2fn0+NcWxuje0XNMzw9l8uzgUeAI/+BvzgvAhWCEBZ0ASnIalYz3txj
	 DalyT1AwomZDeFtXTz7IPhRtLHmE1523eSLuhviRrcv5gmSmywgvOw8qnVbpbm2OYP5mS
	 qm3hy189J00nWd5MtkG+eJVXvWEG7MefubOas7u9bU8iayqwIKC2JPRol3LvZDrR2iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792640683;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=IG6kRcjYBU/g4TMKgH392ux+rt1j2tFirKvhQsBLVGA=;
	b=vpSiLuoDvdphUb1KE2iD0hc3i/PatgwbcZpztZPRZn8nkkLSgczux3nb2A8QX9Fi1m6A
	 fep2K45wPmrrKsZ0cgJtGTT0xo+MYXfc4n0AvDJ8POcZ0MN3LGJaMTPzNW9mnyYkFrAlY
	 pp2voNHejU3DtRqo72cC34WzUY5CAxoUH+sSB90QqL9xVy9f3WjqN9LqhZSSMVGJc8/x+
	 YpvXGM7X7asMIemQNKScrAnDGldalTv3VlgKDutvfhtMWXixPeLM6vpmSNGdCdCbxRKy5
	 vT0BSIxdYq9hCMbUUriA83oCeIrwJUoG6GV5ylHjDTfU6L1d3319SXsRJ2UWg9oOCcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=bf3tVT52;
	arc=none smtp.remote-ip=209.85.216.70
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B06606A31D
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 03:44:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4B06606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=bf3tVT52
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ada8bc8575so630357a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 20:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792640682; x=1793245482; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IG6kRcjYBU/g4TMKgH392ux+rt1j2tFirKvhQsBLVGA=;
        b=bf3tVT52Xz5oe7HWwuYdS4vPehCYzK78ylgL27ucbRU+UeqRtEzcHk7F3S011WkXBF
         pQuhp6XFXukbPgM2erGAacWTr/XOdRowGieSeW8VcwaJiC+Y2eNlY3A//Nj8ELV23hxt
         OsBKLdmoEABBSzY/V8U5xamVzwUJdCku0jOLMVUWcMy5jtcKeuzTMhti1bufQZRftZpm
         l8g9Uya13AwmIKkMUb7GpoqwLDpgOf3/M822hqMcL00rWm3tw6buIhmtj4/Y9E0wkdsE
         LHQMfTZEye1o5BMPKPXsFaUuZvYlon1uaBwxocZeCF/iclZfi04952tpqpyZERt8PCoI
         GvBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792640682; x=1793245482;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IG6kRcjYBU/g4TMKgH392ux+rt1j2tFirKvhQsBLVGA=;
        b=iGYS3p+7LkoE0wi3fZA2l2u6uylHpuiZJr9EEX/Rcuak+kTg8XvKymcbMuiXtjtLus
         ZRDMuGL18lKqJMBHTHuVISQ21LZ9rh6ePwvWXYvlIxV2HMSpjm/Am08b1AKrezdvXfP/
         KoPwhkIM60jFN72bN85G4QYMVzXOnYSf0rwjyamM8sv2ne4zj3PaD8QsV1TbhQqH+qbo
         5+hnGzzQBcfcNPmku6aHeF9+0XE5bXXxni7n0hlivkiTb+5O7Iya4Qu7TYouFVkli9aV
         pYAQloGBkKais61MdjbhK9sRRHJgT2Z0Wuur8dwJ7ayF3A70uFI5/U/Psu8/KQT46t5d
         C6kw==
X-Forwarded-Encrypted: i=1; AKwUvBwjRT4zE8OOvYGcwtkDQzW8Ceby1SM3TRD0gvX0/EHpDe2co84vTAIc+oBt7FFAeexyXl5AkhG8DcX1@vger.kernel.org
X-Gm-Message-State: AFq9FYJBIdTdTvvIv17y7T5q5oQNeU7JSOx5TdW1Gq2yq1/wXfFv+FA0
	2AyITJ54MWFDXW4Oli2F+00hzbmeqGq2mrPlcsLQn/wnkS6HisZF2+Oh9ybAF6eOIfDd1olg+QK
	+UmYzL5GqZHxudLnY4utcBw==
X-Received: from pjwo21.prod.google.com ([2002:a17:90a:d255:b0:3ac:989f:b65f])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:548e:b0:3a8:2c7e:8986 with SMTP id 98e67ed59e1d1-3ad86f44838mr3389905a91.17.1792640681540;
 Wed, 21 Oct 2026 20:44:41 -0700 (PDT)
Date: Thu, 22 Oct 2026 11:44:39 +0800
In-Reply-To: <fdb5c391-01ef-4a23-94c2-4f3853909348@acm.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261021035450.3488805-1-stanleyjhu@google.com>
 <20261021040615.3566831-1-stanleyjhu@google.com> <20261021040615.3566831-3-stanleyjhu@google.com>
 <db4d4e246ad6b4769f736db0d3d1678adf9d59cb.camel@mediatek.com>
 <CAE14pdcR7NPqK3W6Pfy+FkRrXSXB9wFuweOhLyFtSye_Bg4vWw@mail.gmail.com> <fdb5c391-01ef-4a23-94c2-4f3853909348@acm.org>
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
Message-ID: <20261022034439.3033316-1-stanleyjhu@google.com>
Subject: Re: [PATCH v4 5/6] scsi: ufs: core: Fix double release in ufshcd_abort()
From: Stanley Jhu <stanleyjhu@google.com>
To: Bart Van Assche <bvanassche@acm.org>, Peter Wang <peter.wang@mediatek.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On 10/21/26 9:37 AM, Bart Van Assche wrote:
> Do we really need the code that checks that a command has completed
> without notification interrupt? I have never encountered any logs on
> any test setup that indicates that this happened.

Agreed, we do not need this branch, and v5 removes it. If a completion
interrupt is lost or arrives after the command times out, leaving the
command to the SCSI error handler makes recovery slower in that rare
corner case, which is acceptable since it only happens after a timeout.

I will send v5 shortly.
