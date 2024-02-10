Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8228F1BC49
	for <linux-scsi@vger.kernel.org>; Sat, 10 Feb 2024 06:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707548341; cv=none; b=Ya2ZUw5wjZPGkX0cnTaPHYj1vHRna0mRMLXdv0R6vBcKCw2oWSLAtVUCANQK0ngLPc9lU1t8+6eLa5UdhqmLQozTp42OgSraXd3jPahikhMCrKp+JHunHk9+2VAvbqEOrVh/6E9Zam8Ipk9Gxkwdl7YWaqgNDLTg4c/LvU5iyCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707548341; c=relaxed/simple;
	bh=Y5SWwtzlY7akdjVtlZdQaOz5bozkiblf4oOcM6PlM54=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A/YHLHgHuSRIDoB9DuU7OAhrPDLEAv1MF69q3s2GBNeumQrfqs5R/OnD34pPI0MFfad0aaZ0A3vVb1E/2Dm/w+/eU9LjTt7AytSRPZrmajSGiYIZOkPjJSYGCI0G8nCifJeLKpHimRABA/AIFe5i5kPhiH1l+aE9nEqOf8dXW7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=mPEt6gy7; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="mPEt6gy7"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1d94b222a3aso14480075ad.2
        for <linux-scsi@vger.kernel.org>; Fri, 09 Feb 2024 22:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1707548340; x=1708153140; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NGphOPJmB8lCgsiAECv7yh5QjCdlMu1K1EXUdSxvbSo=;
        b=mPEt6gy7rLDFRHrpF/wYVQQH13RKsZYdZZ4x1B5yNhNKImoJ1t04UqvFyNTg1XKgLG
         itHJNetjU6mgOTsnODS53xY+KCo14UagbwCxGMPaSs4W4K760SvwjPEgDmR6pTVt4+2B
         TdS+mIhDVM9wyIr5eYO1IGIq0r1275/Z0yKVc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707548340; x=1708153140;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NGphOPJmB8lCgsiAECv7yh5QjCdlMu1K1EXUdSxvbSo=;
        b=bNmw+KeIoMaFj3q6nfatG04xt9MZZw6GyTM55tWkZBtWVjU6Xm3i2n0VBjRcpbPOYK
         nzZOQ+fw9RWLx4rMafEA5CiMWN84HbT9CC/l5RNmsDRHU9X9iMdWqTH0YDahnRM8K0d9
         v0O3zx1qbN05ZS+OTtRPImTNZDnNmyhLxV0bF+j/uTZKhrzThc6y8Ifm7hu+hzJ1OWkK
         am0itQGQRlJZbUvLVZE3IcFEzzvzly2xqH7BXyDM7fFWy4Zbx0H+UbjimBnS3yBouJI+
         whP9RiRcv258Ez7MMdsGOXCA4zNRrzlsTSRiAaOFqVXVp1N3GK+xREtvjScJcimG8HOg
         sB9A==
X-Forwarded-Encrypted: i=1; AJvYcCXsVOxW0yS4dWgcI7Bx6hv0xR9mQ8BLhC7St67eTASiTACJJCIHxYEKDpEC0JGzDvI1zpc9zEhnc/thwD0NsQciBSBViZQKOIuNBQ==
X-Gm-Message-State: AOJu0YxW65BGtKgYbkwtIe/QmRku9AYK1Dw0QALNM5u28MNGuKXxSyGq
	FC/vLJ8IWiz0s6JhYVHZ/BZ5357CKxKKhHuCRMJIrCMIuVLAtn+8SGUtNUkvyQ==
X-Google-Smtp-Source: AGHT+IHTnF3fGuzslfqsDKip3bFExZj3gSNORqyeS1D8vTDmuOVDSx+jeux26obr0yz2kGNSAwz50A==
X-Received: by 2002:a17:903:40cf:b0:1d9:6c3:e24f with SMTP id t15-20020a17090340cf00b001d906c3e24fmr1719392pld.38.1707548339797;
        Fri, 09 Feb 2024 22:58:59 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVJxTovjWaiv9g0IvLBZWYtRlBzRueKPP4/yrb+Xzr6kaMgQKEcgbUHUQGkTMST1B8UcIKVDo8HYkXhW93TEzKRAW/tBwGmIDMBKV6iAp1MWi/nwB7jrZokLH7Lw3cFTuud2KbwKjlvFfNS2JaLa/z6PbM0GaO3VfUer6+XzKyWYtzkn2pqtDWz4KNNxxGzlWSjNs6tUwRNSB4Llg27wr6lZYd1q6nyD46giA==
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id k12-20020a170902f28c00b001da15580ca8sm1678034plc.52.2024.02.09.22.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 22:58:59 -0800 (PST)
Date: Fri, 9 Feb 2024 22:58:58 -0800
From: Kees Cook <keescook@chromium.org>
To: Lee Jones <lee@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	Hannes Reinecke <hare@suse.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 07/10] scsi: aic7xxx: aicasm: Trivial: Remove trailing
 whitespace
Message-ID: <202402092258.5E568EA69@keescook>
References: <20240208084512.3803250-1-lee@kernel.org>
 <20240208084512.3803250-8-lee@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240208084512.3803250-8-lee@kernel.org>

On Thu, Feb 08, 2024 at 08:44:19AM +0000, Lee Jones wrote:
> Removing out of need rather than want.  I wish to make proper changes to
> this file, but my editor is insistent on removing whitespace on save.
> Rather than go down the rabbit hole of debugging my editor right now,
> I'd rather stay productive.  So, out it comes!
> 
> EDIT: Found it.  Looks like 5a602de99797b ("Add .editorconfig file for
> basic formatting") now forces editors to trim whitespace.

If there is a v2, you can "squash" this. :)

> 
> Signed-off-by: Lee Jones <lee@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
