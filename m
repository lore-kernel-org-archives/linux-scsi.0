Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AB813C693
	for <linux-scsi@vger.kernel.org>; Thu,  4 Apr 2024 23:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712275065; cv=none; b=lHO6jlYSQxXbwIOSXaCHu35Je26CVafCcT/gasHhmHIcsjLgwkwwJT9Iiaw93CbgVgixcCSEh37p4OQr59GFhVrhWS8R2DPCpMq4MDy8V2Wgyb71jfcHxWDyozNdEV31XkC3MKBi5CsZWKouxFYfrlgt1DjWjfyRNuRwhMRzCYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712275065; c=relaxed/simple;
	bh=F7SdNCz/QgG6ZV8wSCZ+H09pmXw6N9MK6aTBYH2dPG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KCn95zQ3brbHtmzThDXWKsmbCIrVWd3FSh7jDqIJf/ooEluqB2GOArpZSYGqpHglHdwZ4R2IZEzo8C7pSEdhrw5erllCtV1+ZMxmG4dlolBELBqsAtPdfwhNhCc/8Yxv3TyVfI21K3bNNaBk7zIQjWkwHyuG3FRjX7fse9plJuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=W9oXZkGF; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="W9oXZkGF"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6eaf7c97738so1320810b3a.2
        for <linux-scsi@vger.kernel.org>; Thu, 04 Apr 2024 16:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1712275063; x=1712879863; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HcooNY8RmBqi6mIlR4eXX9gX9Pxcn9LWybg1sRhXfgo=;
        b=W9oXZkGFUYdDInDXESB0PTvSwcYS0yHMXcBnMTmyNbqiqaVBx9NbGGNobfYmfyV0C5
         tFfbmBATcfT3mAImjMPghLqJeTwLZMaybphNESBYiLL1IzZyyXubZrlHPzhtQeE+0V8h
         ioovl7+HQ5yu4gbcMud3vYsBVdxrXr/4eS64g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712275063; x=1712879863;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HcooNY8RmBqi6mIlR4eXX9gX9Pxcn9LWybg1sRhXfgo=;
        b=CBsHsiOtjiEo33oAziVcDIc7pHmXUwGl0jaKjRx/nW7Dn3BN8F3Z4zNQbUoW/Hw537
         Tu69XgBDRSFnAD7V1sQbGoqjK8r5tPmnBlwT9eAel5u7Un/12QhgzjIIGqhKiokFctTP
         3n3u9M4BwGRjtfFyRJDoJ1s5ijgwZWx6wW7ebIhhQHgS2lWCd22okHMehigYbHEBG+1g
         eFIxzXEKhkiLUANIEGedTb3JXvfnrlzfMddCP90qqan5xt6rYRTzLcZYOs5g6jUJVqOe
         0GK5T+959MDM2ZaQs6HOpwE9GDTXWMdD50uIlf265CC6zCYpQCyvNxi7kZ/lI1rv3ghA
         TNcA==
X-Forwarded-Encrypted: i=1; AJvYcCV2GC1wVgl9kfb20D+owc+Q6+kC8cufjAdHZjo0vkAzfiE8ssBgkGEtN3d1eIU6O22aGvU8P+oXFHmykITZoJKDzRYrPC7mi0cwhw==
X-Gm-Message-State: AOJu0Yw5UtCVe00EPPUWql8K8bT61SCpW0pKIZLNRmPTBYfOqw9xuODb
	2tjr2DYfX7US8O+Km9eK4B6TufFRpp09jdvELGttuRd/3H1SzRXgheKOeYCc+w==
X-Google-Smtp-Source: AGHT+IGa1EqFchbbBZ7rjOFofoz001dTXib3yQGi/JoI4Eny7/BNl8qZTmHkqwNUaC7d7PAVi402+g==
X-Received: by 2002:a05:6a00:2918:b0:6ec:b624:ffa8 with SMTP id cg24-20020a056a00291800b006ecb624ffa8mr4031966pfb.13.1712275062933;
        Thu, 04 Apr 2024 16:57:42 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id r3-20020aa78b83000000b006eae6c8d2c3sm223957pfd.106.2024.04.04.16.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 16:57:42 -0700 (PDT)
Date: Thu, 4 Apr 2024 16:57:41 -0700
From: Kees Cook <keescook@chromium.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Justin Stitt <justinstitt@google.com>,
	Charles Bertsch <cbertsch@cox.net>, linux-scsi@vger.kernel.org,
	MPT-FusionLinux.pdl@broadcom.com
Subject: Re: startup BUG at lib/string_helpers.c from scsi fusion mptsas
Message-ID: <202404041646.7B813E9AD@keescook>
References: <5445ba0f-3e27-4d43-a9ba-0cc22ada2fce@cox.net>
 <CAFhGd8pTAKGcu2uLzUDDxto1sk5-9zQevsrXp-xL0cdPcGYaGg@mail.gmail.com>
 <5ac64c472d739a15d513ad21ca1ae7f8543ad91c.camel@HansenPartnership.com>
 <CAFhGd8pg78F1vkd6su6FeF3s0wgF8BdJH+cOUsUdqLmuK6O+Pg@mail.gmail.com>
 <f8b8380bf69a93c94974daaa4e2d119d8fcc6d0f.camel@HansenPartnership.com>
 <784db8a20a3ddeb6c0498f2b31719e5198da6581.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <784db8a20a3ddeb6c0498f2b31719e5198da6581.camel@HansenPartnership.com>

On Thu, Apr 04, 2024 at 06:33:38PM -0400, James Bottomley wrote:
> But additionally this is a common pattern in SCSI: using strncpy to
> zero terminate fields that may be unterminated in the exchange protocol
> so we can send them to sysfs or otherwise treat them as strings.  That
> means we might have this problem in other drivers you've converted ...

This use of copying a maybe-NUL-terminated source is yet another weird
corner-case of strncpy(). :(

But it's also easy to check for this "strncpy used with size
matching source size but destination is bigger" case with some build
instrumentation. I'll see what it turns up.

-- 
Kees Cook
