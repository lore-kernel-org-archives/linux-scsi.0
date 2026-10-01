Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B464D42A7A8
	for <linux-scsi@vger.kernel.org>; Thu,  1 Oct 2026 05:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790833992; cv=none; b=UGcNTFBpPjYOaECDZ2DuRweBGauoaMIpPWpeYenU5EqAcKJHhCM4YDFwOfTMGDu8Ded3F98jaAu/PU1wVlTK45b4i9NhceeoZn1ytQOj3b7MqcpHAfArnAfYIMY32Yr7oILQTys7B0mu5xSoem0IyvtnKUssZHp9Uq28dUL6z7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790833992; c=relaxed/simple;
	bh=760bQS5p7L1HDKZOzVSTJkhWQUx4Pnxd7m0W3+v8P98=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cAWjRCIu7uWTWBSEfMTqRLoTPZOgeirtCpy1SDPrr3E60Lvu7JOwgcQ66o5EUjITAYvSRPjoQnbt0bZuDiY1wnqxC5yN4ga4NeBoLFEfSNv4q5m8e3iuzR3Rf8JpOsxcc8C4zhEYuOLFmU7jArH9rNtcbWs2O5q5pRPw0bstSks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ohrOiO+g; arc=none smtp.client-ip=209.85.214.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ohrOiO+g"
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e2d3a3ff86so28929885ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 22:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790833990; x=1791438790; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Utxv0boWzvqXajcS02ASYledFRiYnIYMfBZ4EHEyEQ0=;
        b=ohrOiO+grl37xTOr+kMY4hRojBpgDOrkn9gE1F0q9bh63+sqyvsukCKxDXWn5ulhUo
         SosaWSH1KPApU27hlHq8V44Nq7X8AEbgXtFasvz9kVvhgkpMHe/QLNN6LcOsVJOsMXWn
         MmCVlj9QzGJ12TS7x370Zy9yqwSNFrHPJR3bw6HxF7K4yTfykafssV9D1Lm46r24j8Ow
         mm2/QXsozJc+kyPZ3sUZVDP/YTHl0rGHP6AERk1PC8oKg5Yf/HA1bWS8g8RbiDwtE9+S
         ytbQXyRvM/Ku6S9fp9AbMLVT7YWvEANzhKoNBxf2qPVChSmSLjDASb7f7dXgwHJObdjz
         nprg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790833990; x=1791438790;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Utxv0boWzvqXajcS02ASYledFRiYnIYMfBZ4EHEyEQ0=;
        b=EFKtr8ilqxj7y9OpeCpoAHT0J8x+zLg9pMjuoEgDoyaMzbtGwCaLG7uf629NkgdIPw
         pdWFZ4w7P0ipVVHJEp9zaW/lyJJuHSeWOcTphH8Oe0Jqk5Uv7mJvjTNSc4FMqXaIA9Vy
         2vYfKw5DTwSk0Xi59m9Kf0KAiYiJNz8ZaqtN2sBQmYeLjoVg+PEaLCtGNc3J1vqC4HkY
         MvbyvXWgipStbEnkyCCMZm3OW1JZMEWj11U1ZmCcvq+ts46Ub1SYvV2mQ/gP0kGXXwpu
         ZjpTvr1XIQn+G5UHkR3401MmJ6Ha1ByHIg5udcjVL8ImXU+IsG/CIqXj0h+iZdWR6IQx
         19cw==
X-Forwarded-Encrypted: i=1; AKwUvByTgZkRdI9OkDm9yCtArXuRC2bWftUZ12W2AfTFtzbLptm2iCLAINmsc87Smn689Rd20qJX09gqp1mP@vger.kernel.org
X-Gm-Message-State: AFq9FYLiajV/+6yFiY78DokD/n2HKIzteJfuTeFrFX4ouDBrhAhxUfY6
	Zrzw27+Yexxk+YLkhvRFnKyr0cq7ViEw4NEZKHKCh79atccs+6IqhWzTuzjW8ryn3BM/SIkDMlT
	cVRKc4aSRMRN0E8QLrX7G2w==
X-Received: from plrd4.prod.google.com ([2002:a17:902:aa84:b0:2e2:e0d8:9a3f])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d4d0:b0:2dd:ad74:6d1c with SMTP id d9443c01a7336-2e2e4b89f14mr30381875ad.25.1790833989648;
 Wed, 30 Sep 2026 22:53:09 -0700 (PDT)
Date: Thu,  1 Oct 2026 13:53:07 +0800
In-Reply-To: <1653986196.21790747102619.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <1860250540.01790747102385.JavaMail.epsvc@epcpadp1new> <1653986196.21790747102619.JavaMail.epsvc@epcpadp1new>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001055307.4097978-1-stanleyjhu@google.com>
Subject: Re: [PATCH v2 2/2] scsi: ufs: Serve the device init reads from one
 aggregated read
From: Stanley Jhu <stanleyjhu@google.com>
To: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
Cc: James.Bottomley@HansenPartnership.com, mkp@kernel.org, 
	avri.altman@sandisk.com, bvanassche@acm.org, peter.wang@mediatek.com, 
	linux-scsi@vger.kernel.org, alim.akhtar@samsung.com, 
	Stanley Jhu <stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 30 Sep 2026 14:18:25 +0900, Hyeoncheol Jeong wrote:
> +	for (i = 0; i < idn; i++)
> +		off += ufs_agg_attr_width[i];

This assumes the Attributes group (Group Type 02h) is serialized by
ascending IDN at fixed offsets. JESD220H Section 10.7.9.14 and
Table 10.56 define only the group header and Next Group Offset chain;
the intra-group layout and ordering are not specified.

How does this handle:

- Array attributes: wContextConf (10h) requires INDEX=LUN and
  SELECTOR=ContextID, where valid SELECTOR values are 01h..0Fh so 00h
  is invalid (Table 14.28), yet AGGREGATED READ leaves bytes 14-17
  Reserved (Table 10.42). Assuming 2 bytes in ufs_agg_attr_width[]
  breaks if a device omits it or returns all elements.

- Optional attributes: if a device omits unimplemented optional
  attributes such as PSA (15h, 16h) instead of zero-padding them,
  subsequent attributes shift (e.g. bWriteBoosterBufferLifeTimeEst at
  1Eh shifts by 5 bytes) with no per-entry framing to detect it.

- Write-only attributes: ufs_agg_attr_width[] reserves 4 bytes for
  dSecondsPassed (0Fh), which Table 14.28 marks Write only. Whether a
  device serializes write-only attributes in a read response is
  unspecified.

> +	if (index == 0 && !ufshcd_agg_attr(hba, idn, out))
> +		return 0;

The commit message states that bWriteBoosterBufferLifeTimeEst is
served from the packet only in shared-buffer mode. In LU-dedicated
mode (bWriteBoosterBufferType != 01h, Table 14.28 NOTE 15) with
wb_dedicated_lu == 0, ufshcd_wb_get_query_index() also returns 0, so
this check serves LU 0's lifetime from a packet with no LUN qualifier.

> +	if (!group_buf || idn >= group_len)
> +		return -ENOENT;
> +
> +	*out = group_buf[idn];

The Flags group (Group Type 01h) has the same issue: Table 14.26
NOTE 1 distinguishes device-level flags from array flags addressed by
INDEX and SELECTOR, and the specification defines no 1-byte-per-IDN
packed layout.
