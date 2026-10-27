Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793096512;
	b=ZBP/gZERTfUyZSkNIOtib0J2RreaBgFvC5w5KxiuxhMyBXJS2rIEw1TFWC38b0Mgwl3O
	 hQopI1gIOHDYMQfc0M5eF0/qej8f1LLakwhP91kXX30YhtdUbnx7NaF/nwRVZhWtR05jn
	 VZDU956HpvogvcoeV7AQ9XNxrUcFu7I4Y2YowAYwlLFjFv3JQ/Q227jpZ++OTc5/HYT7w
	 qeuZwSD589dvfJbAOmnNT7PIM1yo2GHvF95JlcU4fHbpw44JpBDWrzIoBl1rjTN66TR7V
	 mVL1UlqaOx2STpmrS4P+lCvdfT0SQ0bst3Km9XTRxwz52LhEAtrF3lbSnhMLTl7fgRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793096512;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=iAbG4TXaudHPChAgyQZBjxq+/WagALvzGHQc1mnxCRc=;
	b=UVYBF5I0MZ/p9vNmUNiukizrUCzkzJxdD8FOeYa+Do8/MG50xuauQsKcyOqe1s+U+lGt
	 JzhsC6SUsbiCaNAUn1PGXW9fb+eLiAeC68f2EU1t9AW4X1HQr5Lm0ZH1QhWkMZ/BdOGUs
	 M9hiPYHsyQf+h/8QS5GtAoIchc8Hy+KUFma+Bmja+sZuvHIlnxmfmIXR5P2ZrzgZwZcRE
	 3E10j20GfhP1bxdEzsxQF58K73IkhzUWhiaPSaqGCgUeVQK02xnQv4GDPrvKtw5m4MTgi
	 8gWkOL/5FTNRe3/KAKK4R+y1TxnCWZ1tr9lFLETg/g34jsJLHRf8uSe6wcwn5eZRAjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=sR8Z5JL6;
	arc=none smtp.remote-ip=209.85.216.72
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EFE606A31A
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 10:21:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45EFE606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=sR8Z5JL6
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ae19907a31so834806a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 03:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793096511; x=1793701311; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iAbG4TXaudHPChAgyQZBjxq+/WagALvzGHQc1mnxCRc=;
        b=sR8Z5JL6Mqy4Khp2MuMfkZpi35b7KLCz+a3IRQcP9qtIz2dbW2lXv7fLGKBj1EkpGP
         c7DvVrAKk83QnaJ4lWiB0SZJAkk8DJHTnYFOtu9QntQTXvg5g7ekIDHvfnDQDVX6y3G0
         60vAkUvcR56pAsP9JinrfYMd5FWlKAU8yf4I5bFXLiOlVwg8/4TvDXotqbCtdOD+PSsJ
         +4mh56N1g3wtqaBE2xCtxOV3iVe2foDh7SyVIkspXKbXQAt8MtuQMBkexCX9AKEqXZ4G
         wpTeqN+m5HSF1d1Owi/ZFpJe2qP8Mkr8v2avrYL1uAxjGkmFSmWOP8oiZksz4K4W3R84
         8nHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793096511; x=1793701311;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iAbG4TXaudHPChAgyQZBjxq+/WagALvzGHQc1mnxCRc=;
        b=yjsB8VbDXJMvrp42sD2G14S0IqZhGRHd6157F/4ouKCNbbildjJcgJ3Vs+E/DOwVCD
         0HXZZmhhQYIhB5O1Lzdv+nQDwbcNXBkgdeXQV0/n/JBRmoB3N8H6v1PT7Ul2ZfH6Q7+q
         Wy+r7WdzLkI8ZMkE6sMAa5sYFwUgVTs3+8wojCoUYnxSh1K2iZBtXK/tiDUtk7BHwGjs
         ev5/RB8x1daD4jxV5AiqafkUDnfmffVqPDOLbbozDY8r+7BiEVrCVFZPXSH8BgeDP6om
         aSTpGO2EvLgWrYKA27/r4xDcIEcOnNX8tai9uNRn3JIyqrk/nRPdKVxHH/dX1EwL24pr
         gzIg==
X-Gm-Message-State: AFq9FYJzoKsz4xukua4xsHqFVXkDiU1DrzNJhOTMWjauuGcHcNnmwQKI
	XelI7lXdU+E+lRyvh6vZOZtdh+zVGJEXAhDKUC40bL/b+7KE2MCX+4pZl/H/uLrymxhcJt01NZw
	fnBmqvIdcQckppYpiaJ+cOQ==
X-Received: from pgn17.prod.google.com ([2002:a63:d51:0:b0:cc7:9d5b:c2a1])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4a07:b0:3ac:67cc:3ca2 with SMTP id 98e67ed59e1d1-3ae4025fbe4mr1373440a91.2.1793096511293;
 Tue, 27 Oct 2026 03:21:51 -0700 (PDT)
Date: Tue, 27 Oct 2026 18:21:49 +0800
In-Reply-To: <20261027021037.3398180-1-hy50.seo@samsung.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261027021037.3398180-1-hy50.seo@samsung.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261027102149.3863280-1-stanleyjhu@google.com>
Subject: Re: [PATCH v5] scsi: ufs: Change the error check sequence for auto hibern8
From: Stanley Jhu <stanleyjhu@google.com>
To: HOYOUNG SEO <hy50.seo@samsung.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com, 
	martin.petersen@oracle.com, bvanassche@acm.org, kwangwon.min@samsung.com, 
	kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Content-Type: text/plain; charset="UTF-8"

On 10/27/26 11:10 AM, HOYOUNG SEO wrote:
> Fixes: fcd8b0450a9a ("scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier to analyze")
>
> Signed-off-by: HOYOUNG SEO <hy50.seo@samsung.com>
> ---
> Changes in v5:
[...]
>  - Move the Signed-off-by above the "---" line and Cc stable.

- The v5 changelog mentions Cc stable, but as far as I can see the
  patch has no "Cc: stable@vger.kernel.org" trailer. Was it meant to
  go right below the Fixes: tag, in the same block as Signed-off-by?

Reviewed-by: Stanley Jhu <stanleyjhu@google.com>
