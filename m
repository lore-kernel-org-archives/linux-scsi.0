Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A53E364A3
	for <linux-scsi@vger.kernel.org>; Sat, 10 Feb 2024 07:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707549211; cv=none; b=tX+o6dlBFe0134K9ZIMEdR82YVB6FzoaEdw6jsCvC7zCQng7ck9FE6kAsGpDqNiX4bt3s9I5SYTvw+hc3T7BYIzA06g257Jt9kUYdoACokYr1fvEm2kTzoX7BbLhzLoP23eZGRtgvlPXtBaRjTsyxgLlAxt8Ta5rSm9IXU+Jcts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707549211; c=relaxed/simple;
	bh=eLNqhG6BuOwuEDtpbLnGq2B+ck6kSMVlJ6ab7q6aBbg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gneoCHKfmg6hMvdYTy8Q1yIwpBNHy8vVrj/NGs+Zh9VjdkjL654mYhPGvGB//6O4/bnSX4uEGe7llnE7BjyCB+c3bDdI0PGJ3li8a3R5cTweYVLO+GSXtyLT2vUlbZT08xVKBjAgDMXsJ62X6mQGmkxGAoD8XMLUnws7ZHLanWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=ZdzPUxla; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ZdzPUxla"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-2196dd318feso585608fac.2
        for <linux-scsi@vger.kernel.org>; Fri, 09 Feb 2024 23:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1707549209; x=1708154009; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ItG/RHS5QiD2KktNBEoaf7WVQ+4rUlZA95b1HY5B7yQ=;
        b=ZdzPUxlaFF0gJTPgCWJ7o4KR72en/vdlxxnjlbAW7KVi5uedg4dWnB/jbJ8fUGd/r8
         eblmpf+iTfZb3rdx9ABhQq4jrY5V6555iYIGgHIUYD+dqRj/726h67+nbEP7aZipvm9o
         tgYUvblUrIsr/Gc/U5XUQHF8OV4FxZsfUmOGE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707549209; x=1708154009;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ItG/RHS5QiD2KktNBEoaf7WVQ+4rUlZA95b1HY5B7yQ=;
        b=DRetn3hI+PHTKHlFpnMTPDPiktjIkboK3IIyuEFNXdjkRt88dvlz+RNIheqcEhKY00
         symnNvZ1FrlediZvFGbDyPyOYX8n7tAC5ZN0IRoWd6ZOIsNlhLWHkh67JLVDN9yRPjlP
         VexDlJ8cXoGBcY9+UG6xelgwC1SQkubaPhC7fpCWfJRbwkdXCWChCfdWBsPythvLO5W6
         CJPbxtVXCvjuGEUhq0uCMiFeaBv5I2R8BpylJrmtYmPBXu2g4ScxquUpf9QxEkt/XwEY
         mwkC6p+jLILr1xn5HsXCp6FXTBVZSqkn7v/oWMTmidO4SDBgp4beJyHYww/uJcucKoAp
         KK6w==
X-Gm-Message-State: AOJu0Yxxp968yV7Vn0tGqoIUAONkM5xN5pGLPCRWz2rFrIcmbA5xtchq
	aL/hegUKW0j2wmBO0MpjFQ4dbdyJoqXNb+CDz03eF6px4ETdp3ruMpGAMri7mA==
X-Google-Smtp-Source: AGHT+IFvXEOJCe3uJjrX4Rbsofsi7PzYGuVSH33eHEMoSLRIq1/HcJ+88W1asbpwm5g/HR9s4Wh/Kg==
X-Received: by 2002:a05:6870:e89:b0:21a:2e98:75ec with SMTP id mm9-20020a0568700e8900b0021a2e9875ecmr1764810oab.48.1707549209593;
        Fri, 09 Feb 2024 23:13:29 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUfN/Cc5eb2GjsAXYbFZgDAw708o5YX2rlVLoKGUMfFqNNZA4uVKyw/8T6c8ZEHIJcuFLf5e93d/0zw0MoZSsyfO3o1SWHB6PNxMOk+thlGY1FIDz6LG2vxBDpx9TA8tALOPNXFbImXOALV05n1NmHiuN3atGtz2l740zsMhdSiE0Msafll2ubX2g/5FTYTt+SsosmJJN8fkKCb4vGM+bCgKixG41T+kBVJ0ZWLh8bUbcw=
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id cl3-20020a056a02098300b005dbcff5d38esm2528518pgb.68.2024.02.09.23.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 23:13:28 -0800 (PST)
Date: Fri, 9 Feb 2024 23:13:28 -0800
From: Kees Cook <keescook@chromium.org>
To: Lee Jones <lee@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	support@areca.com.tw, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 10/10] scsi: arcmsr: Remove snprintf() from sysfs
 call-backs and replace with sysfs_emit()
Message-ID: <202402092313.DF1409889@keescook>
References: <20240208084512.3803250-1-lee@kernel.org>
 <20240208084512.3803250-11-lee@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240208084512.3803250-11-lee@kernel.org>

On Thu, Feb 08, 2024 at 08:44:22AM +0000, Lee Jones wrote:
> Since snprintf() has the documented, but still rather strange trait of
> returning the length of the data that *would have been* written to the
> array if space were available, rather than the arguably more useful
> length of data *actually* written, it is usually considered wise to use
> something else instead in order to avoid confusion.
> 
> In the case of sysfs call-backs, new wrappers exist that do just that.
> 
> Link: https://lwn.net/Articles/69419/
> Link: https://github.com/KSPP/linux/issues/105
> Signed-off-by: Lee Jones <lee@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
