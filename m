Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45585153516
	for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2024 16:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708619110; cv=none; b=HqTNX2ei+yGI8ZqkvOAXax15akQYqVKvUzu/q+kbAitREONfiWeJthtjbOW2GoGeGiygmzBMuAS6SLMey61NRBopGypNxX65fW/jm1SJnIvIMPkfIn66Qb5xi1AI4Ebelkmg4rB5/k2cR2id4c1dEA2zsrHTkunu9N4byIhOMU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708619110; c=relaxed/simple;
	bh=fXcv8giEzlATM1A7JbByzVgUvAtZI63j7NQlt9NdCuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IM3f4LmNVxLZbak7uONL6jJcGpkbzV6ds/vtUcSJisf7G71MWK3/tlXr7yH9bvGu0SRUtB/nIcU6aQ5VWWSjVf4HVPHSR/pEpUzBNY5uJZ6cmzXtHh2GAS0w9OwlHprj4K4fuRLljvVrtoUUIoZXwqSAqVvDUQSGr1wTsk+00GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=f8sSR/yF; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="f8sSR/yF"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1d932f6ccfaso68215085ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2024 08:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1708619108; x=1709223908; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m1AT2qTKdrf74pfg17LdBdyvdHs6LMG9RRMelRGtLLs=;
        b=f8sSR/yFvyEex9zBmAPMmPEz5au5UpmHDP9G9Me5sX3UXf+BqvzgAeoF2kY8OhLQa/
         f11KgniGKHh+O72RGWmXoW42z8Q2Zr139taVtQ0M+B3vb6GdmP/op3Bg2GAkAM+rTjuR
         LgJkf+vtLqrD5u5DlhCSRjH2RF7doExf38eKk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708619108; x=1709223908;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m1AT2qTKdrf74pfg17LdBdyvdHs6LMG9RRMelRGtLLs=;
        b=gImbGTOX23pFPvLJJcsH/KQi3WTs1YjrJXdIogzyn28Sa2yskJr/0LtZMReG21CiFS
         KK/gs3cbHvsXaid1LzP6FxpcLyNUCeZaFTzIWcuuoS3eX18CIKWERSciRDbFe6ssr/4I
         IKx589JMN7vyUe7OPaMUrBU/lZee9/g72LwMmEC6xtqZx1xZXAfSXQlkMiKSmdlTsjms
         KjuVVK0RuB4rCBUB2MiFGmuovMpCqIzvNkqbsEiK47GA/8O1uU5MToBL0NxxL+JtORYT
         Z2rZF9pO95GTD7WPa4cKB2W96W44CmJKWe9PBZmCPf308XdsAOhc8p9V/pskTmGx/ncm
         /cmg==
X-Forwarded-Encrypted: i=1; AJvYcCUsB86wYfakP2+YQwrnhfIBogvdo+C1KJJiKMZTdMVfwcLk4Ab8KsQtYBbkTWRPMU6iQHMzKzG32l25w4O/NoE3orLQ/G6eaohU6w==
X-Gm-Message-State: AOJu0YzAdWo6YX23ZUuW+cSKRvRu5r8aP9f/ltDQpeatWiUEzstxeDSn
	6qUQUmMBejWcT1zhjNvxAuE6eDFLMYS63zAdlDpkmzvj55xl24XL+j2oEUUgZA==
X-Google-Smtp-Source: AGHT+IFMJCLoL7jKkzpS9/TNZ6T7P7Jf8MLbdjmbuuVdSCusuR7itGNkEgPTZM7ffYA5gYmJpOvong==
X-Received: by 2002:a17:902:6847:b0:1db:9fef:b996 with SMTP id f7-20020a170902684700b001db9fefb996mr17759580pln.33.1708619108535;
        Thu, 22 Feb 2024 08:25:08 -0800 (PST)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id i17-20020a17090332d100b001dc3ef7aa2bsm2440647plr.49.2024.02.22.08.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Feb 2024 08:25:07 -0800 (PST)
Date: Thu, 22 Feb 2024 08:25:07 -0800
From: Kees Cook <keescook@chromium.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Azeem Shaikh <azeemshaikh38@gmail.com>,
	James Bottomley <JBottomley@parallels.com>,
	Krishna Gudipati <kgudipat@brocade.com>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH 1/2] [v2] scsi: bfa: fix function pointer type mismatch
 for hcb_qe->cbfn
Message-ID: <202402220824.398177CC@keescook>
References: <20240222124433.2046570-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240222124433.2046570-1-arnd@kernel.org>

On Thu, Feb 22, 2024 at 01:44:06PM +0100, Arnd Bergmann wrote:
> v2: no changes, just rending after I noticed I forgot to follow up
> after https://lore.kernel.org/all/336f2156-220f-47ff-be97-5a2a9c475372@app.fastmail.com/

Thanks!

I assume Martin or James will pick this up?

-Kees

-- 
Kees Cook
