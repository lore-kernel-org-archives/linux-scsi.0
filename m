Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F0C3769FF
	for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2026 02:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789006402; cv=none; b=ssZ2MvSaUw4Pm774mcj2kJ6c40FVz11FYw9T62zuNMdj0AuUjZEg/P1EqcioO0r9AkgWW8qr1zKIlAPun3wrQKwEJvouDsxZh+3yNjKkgfPCV3QSyOgb2cGe+pYwyscTk0kUhitXRm/z4Fn6oBVvvWJNZrt7UM1CWW6FfVtMY4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789006402; c=relaxed/simple;
	bh=WrJHIFWpxpN8ses6ut4xZ9sUWjWpyRjQEA/aIKGpGDs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aSH7JVFWhSvluGCXGl2FdDeuBu55zRXWDfsLqcURLaqLIOh0KQSqaq6LqugPSRXMIoVfFqAASbSMkYY5eTqs4vLP+EYG5tWHRI43//HtQsV9VM7T57POux5Wy6wML3mpY15R5SRaXqqUeN/lpCQXTspgW0FWRI3WK6Esxzg40yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u3Sc80zS; arc=none smtp.client-ip=209.85.215.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u3Sc80zS"
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc4a447d275so2063518a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 09 Sep 2026 19:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789006400; x=1789611200; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FdNMd2NH5nC5ElhtsJsby8lwVRF/Fgx773JqNLZyz7s=;
        b=u3Sc80zSdqO+QHtkihfZEmEZxNykRRH/sqJLECMDm+PYgYAh0yybdGz7bC6OeHqtLx
         byNzuwrHOjE++d/ejmZtFO5CYm50rEfiODFm9OZyMjOm+TlZQV7Gpa7D/2TfbfB3aPqN
         456fcqwdT40h8pC0S6DmtUy9iSRfjnRsedZpj8DY2w0TsiETvLeDChXJSBiwTRb5fY6b
         Ym4yUGByvl3JlLfoSjNJk093tU/qKjg32SlasdeLQteSplmopVkBf83+aY0lsdvU4PoT
         /StDVd5sCX0IzgMSP6oI8itMydXCPyMphMDsAM6tSVrrl3LjsXYedjUJluJJl+NGw/ht
         lrmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789006400; x=1789611200;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FdNMd2NH5nC5ElhtsJsby8lwVRF/Fgx773JqNLZyz7s=;
        b=L7lsi/dChShN68fbyOHN3r3ENA2Cb1y5IxZo45SNC2DrqWf7+0tYnnmpbV4uGjeA+j
         U7bpIjCRYP3jMs30e1Lnf+xtVzLNYEHMVVYV8f5MMymL2FY00a86uiazB/3jT51Rlrml
         s31ENkASESAECfL0D0DncwXPWY008VflphfF1qKC6Ip2kCAGMZpoCQeMsqqZ9T+D/QJb
         smYImHaa602MV25lrwT7/E4YoAC8CJIBSJNWRdbOoWbPOL7M5u44Sb55Uj/zhlfvpP4o
         gypSCtFeyrVE5ywGTr2Y4xF+0DHVkAi9xbkFtGpUSy6qGrsKXDFK3NwxdKB/aUEGJ/kl
         GU0A==
X-Gm-Message-State: AFuF++krUTuIRySyQeSDGb6gMrabi0vbHPoeQBY/B5MDKRUAiCpPCk++
	uDwyGta+QA5kqZYlx45EuwAZGSn1IV9eWNbZPB8RfY1rDm+fMTYjgFN+ruxgzYIj1ibopJWAWhW
	+bmnkZpECIa1dEbet09FI5w==
X-Received: from pgzz2.prod.google.com ([2002:a05:6a02:6822:b0:cc4:3e92:96dc])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:6016:b0:3d3:ae0f:526c with SMTP id adf61e73a8af0-3da3a15cf74mr64297192637.24.1789006399943;
 Wed, 09 Sep 2026 19:13:19 -0700 (PDT)
Date: Thu, 10 Sep 2026 10:13:18 +0800
In-Reply-To: <20260910020917.C22961F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260910020917.C22961F000FF@smtp.kernel.org>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260910021318.2030765-1-stanleyjhu@google.com>
Subject: Re: [PATCH v3 2/2] scsi: ufs: rpmb: Decouple device lifecycle from
 devres to avoid UAF
From: Stanley Jhu <stanleyjhu@google.com>
To: sashiko-bot@kernel.org
Cc: linux-scsi@vger.kernel.org, sashiko-reviews@lists.linux.dev, 
	"Martin K . Petersen" <mkp@kernel.org>, Brian Kao <powenkao@google.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 10 Sep 2026, sashiko-bot@kernel.org wrote:
> [Severity: Critical]
> This isn't a bug introduced by this patch, but does this sequence still
> leave a use-after-free window during device removal?
> 
> When rpmb_dev_unregister() is called, it internally calls device_del() on
> the child device, which immediately drops the reference to its parent device
> (ufs_rpmb->dev).
> 
> If a consumer is actively holding a reference to the child device via
> rpmb_dev_get(), the child device itself remains allocated. However, the
> subsequent call to device_unregister() here drops the final reference to
> the parent ufs_rpmb structure, causing it to be freed.
> 
> If the consumer then concurrently executes a request, the framework will
> pass the now-dangling parent pointer to the route_frames callback:
> 
> drivers/ufs/core/ufs-rpmb.c:ufs_rpmb_route_frames() {
>     struct ufs_rpmb_dev *ufs_rpmb = dev_get_drvdata(dev);
>     ...
> }
> 
> Could this dev_get_drvdata(dev) dereference the freed parent memory,
> resulting in a use-after-free despite the new lifecycle management?

This specific teardown race is guarded by the companion patch in the
generic RPMB core:
"[PATCH v3] rpmb: core: Guard frame requests and teardown with mutex"
https://lore.kernel.org/r/20260910015515.1991789-1-stanleyjhu@google.com

In rpmb_dev_unregister(), rdev->lock is acquired to drain in-flight
requests and mark rdev->dead = true before device_del() is invoked.
Any concurrent or subsequent call to rpmb_route_frames() is rejected
with -ENODEV under rdev->lock before dereferencing rdev->dev.parent.

Therefore, the dangling parent pointer is never dereferenced once
rpmb_dev_unregister() returns.

Thanks,
Stanley
