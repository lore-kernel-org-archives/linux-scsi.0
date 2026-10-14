Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE972C11EE
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 01:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791940719; cv=none; b=Jny7YUed9SHr5iTqK7Ya3f1750EFvQPmhUHw2yYHD9CzsAaP2WDL0wk03kaCQsZvIihlmUT4tMnPIziEVxTUVl5G8ecUwB1ezSE9Y21GtnSekLouXKuP5heSxzsPRM6ORnJ6q5RjPYi4SGtIhfHLZDURYymPUHuXVZPgVbwBdGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791940719; c=relaxed/simple;
	bh=b+2Mv1LpDFg9goZtZ1oDMZLOr1tRhG1QhMX5Qn6Q2Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HkaOa5de3lPznpSGnj4Ey2OMlfqmh036+1kcMzn/m3QUoqjZBmjM6OfCHVPjWb/JC+Q4AhO1xHZZNmmMwNHXulUBmjehyVjNgMh7+pFiEbDW2GfWostlYNuH+WBTb7shT8wvG3gWojRoLCB3cRhx/XU23AsVifSrAV2EDQhLxP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=Wy86SfeX; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="Wy86SfeX"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cd5e6f0a22bso196306a12.1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 18:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791940716; x=1792545516; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ja8EyJvuRT6hgl8HNzUWNQGXZ1QnpSq8JcxdmHiFCDc=;
        b=Wy86SfeXomgiHiyv7uM1cWpswNtwte32c+KhRk2xe44zezfebC+WmmCc3pHqMnfIdj
         6j+Me2jecZ3XWVn2e/gnWpIQmmj1GalwfMPxVavgQ78FDtp/2wPLSehIier7mL9bIjEB
         jk+ZDeTOnmWtsVXU2TgYcZk5t3vt+diw7vbTYYsbn13SuZmHP+ZtHQOdCc6ZRa/KIAHp
         jl0SLcoumQNq8RF/0bCSYmH4hPeEImKt8WKY2z0elvGae1/x7XAvzevHLfdPJlNf6V5L
         7pu6jipINhiB+6L3V6QfFSHkStVFTfFU4sRsv7oK+UyMhVSMMvE3V7K2CW27GIc48K2b
         MF8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791940716; x=1792545516;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ja8EyJvuRT6hgl8HNzUWNQGXZ1QnpSq8JcxdmHiFCDc=;
        b=YbMu7lC3IlXcOyFbyD7zRtfmS8AAPfMb5s6lNWviq0vhUGLx2uKVO2kbYEhw58rnjC
         sDomVc5OoV71A3f5yl2p+k+ydYL6cYAuDidttalaH7M7lahPNeWYcxUVoYSDFyXHk6Da
         jKZ5d+Vrg5WLccwpdVaPQPom8e6ksjrzAgqxh0mZ/lCHg3TikfgouaPHvyU7jNFwdmh+
         8qY6fqoUXZqQxWYpzlIvOx7/CrfPqNkJW8A79y7Jp6wrIaKrHN735bQ2IwKQOb/6Z6jD
         6VsVFBG3/+dldKY83qjKy0ERMxHSRcPRHIkxM1iWBu5ZXRwGVn5afzVPkhXSUQuDxDIf
         gqlg==
X-Gm-Message-State: AFq9FYIzwLl76uqeoEixlr1OFMs2QsjqPVM0y3kPossukDPzBZy2QO9W
	hJxK93lDK2MhA2PWhlrK4K3bQTG6N2KzHdBcugpWI+zwhufvTDP05oJaunTkK1KxdLs=
X-Gm-Gg: AYBFou1ED0rTbt83IvWsKp+q1b03ECqEPUxOfFZ0WYlM8TEOnHDAybT10aYJhTNXeWI
	ILpIdYQQI2gAo34m47PKnv4t+MnrH8ncmPCRzwb57yjTrKQk9GH5THJfMcdSdtPzWv37ncknYYy
	G4DpUMKrKx1qbcUuyX8eQYzn9Lj0ZtMT7uRD68NWx/VrbUKJ5AmkdBixRnkVeMNYpRFyr6ZSh9R
	iCHIcUXS6px01VQRaKxBW9Z8Ann67kpdcG/LztCujDO1qG6pkIftL0Yeq7h75DYnXSINuOPskK2
	k9hGRLew+3hxeU2f7GjxIdxGtctAMvpO89oV4zVXkJkUYpc27TGCCYmG6I1xFk4ueeUQlArcWZC
	RsTUvgNBGBkZfq2zGwa237Dtc93FXXxfReaDyoqfo8JU5uuCTyKNvs7ymwgeoDvMqKED/xH+BnM
	DGkCKgF1LHdU7lJmphGqSjgFwaJWdid/XmgE31LxXvQHiY6e1a4TebN1kNXj87gpeujUD8GFZAa
	UQp0flpaPIrf9cByjZ2
X-Received: by 2002:a17:90b:3c04:b0:3a7:db88:3495 with SMTP id 98e67ed59e1d1-3ab3a93262dmr12843399a91.52.1791940715867;
        Tue, 13 Oct 2026 18:18:35 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:c51c:be8a:c517:276])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac5f3db2f5sm1967806a91.1.2026.10.13.18.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 18:18:35 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sashiko-bot@kernel.org,
	"Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH] scsi: mvumi: reject handshake sizes that overflow the list allocations
Date: Wed, 14 Oct 2026 10:18:27 +0900
Message-ID: <20261014011827.3479523-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-170653@kernel.org>
References: <20261014004226.3469868-1-yhlee@isslab.korea.ac.kr> <sashiko-outbox-170653@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Thanks -- both are addressed in v2.

- 32-bit truncation: correct.  size_t is 32 bits on 32-bit targets, so the
  products wrap and "total > UINT_MAX" can never be true there.  v2 computes
  the total in u64, which is 64-bit on every architecture.

- list_num_io vs max_io: v2 rejects a handshake list depth that is zero or
  yields more entries than max_io.  The inbound and outbound rings are
  allocated for max_io entries and the slot index wraps on list_num_io, so
  bounding list_num_io by max_io keeps the index within the rings.
