Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1332B3611E
	for <linux-scsi@vger.kernel.org>; Sat, 10 Feb 2024 07:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707548790; cv=none; b=V7Q0LjtI5R0hQIa2dIm73MbahrbTsP4UCqEUJZFtHQD/cY91lEVa6DEw3n6Q7wHIVTt512Qq31WxXQH+gVV9of9GmzOnEh4OV7qDqQPD8Y/KrS6KcALhhAh8aBDJVi241DnQbsVNAf7gtxSPxJP79PFp1O0c0yZ+nKqqXTPAJ24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707548790; c=relaxed/simple;
	bh=ir2eU4ZeGjl5Y1G4iwc/uXJYfbxwBRUjFst7H/ZK7Ro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tw3VXbpb72QIbO0vUnC3Dn+5x6nyihb8Xl4YFGY6V/+u3X7+OwHCcm2G5AJagdLJcq+h1dGMYoJ2x0xxcdTH7lRdUyV7KURGptSaU46u2xRUz8apt0qSsrs90OtyMpqdG/QTyDD5ul+HdhY70HjpVeeyVnRItLSZa+lvFlEaRRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=RDIBRpS+; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="RDIBRpS+"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6e06d2180b0so1363613b3a.0
        for <linux-scsi@vger.kernel.org>; Fri, 09 Feb 2024 23:06:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1707548788; x=1708153588; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iCqZp7vIiNiDCK0cy20SXg9L894FR7U3RGqtXfQnefI=;
        b=RDIBRpS+3/6WY2U7At+whg8SCUWQP94czhYxQsZuBH3pri8yOMIO/iWKErzDs4vw+L
         PP71LbzMC8zJrQdHJiUzR+DOiRNELlCq7/TYU6/YzECotGX9p15Bgdl8vv9ss1GBTtsa
         8Hu6W9SQ+vdO9lwngkmtW/S1sKiffzuBHt4Ps=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707548788; x=1708153588;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iCqZp7vIiNiDCK0cy20SXg9L894FR7U3RGqtXfQnefI=;
        b=R5HzpVy7J4EPIXbwF+C7mm6zB+pq3e3sXLEQ9vC04w2hZfBo8T0gXIZ1lb6rRMyyuz
         BmVIX1YvM6vP0qy3nbES0WAFweo1jiajRR5YYadq9mM0OS0wZcEDVnXaaebNhup9hx9D
         jUbw25a9fLNPFZg4CppzjpjamzguFT8YuMHoYmK1XLR90O9+XP6cgqHcv6Q2ODDCv9l7
         TIUwt40sGyyBnrbVoJKnQ0VAObneSsYiNULWvQ46VmBwqy1smUa91Frfj8pa58IbAEjr
         b9FPodI8gZbwG/jRMnLHTmn8oIK0pZ1FmTrxBo5zJOUpClesx3AaNFBDrOXDGP8r8K3b
         gIkQ==
X-Gm-Message-State: AOJu0YxcbLSEXEPmzO1zEDOaPNl9iF/XEJtvUZunwzKdJWl5BjZ2fpsU
	dHfSGlsPtrXbaisJHvd5a1GzOtyXEX2vKyGapzTGJ8vuR0A0+EsoWZhiBsfpJA==
X-Google-Smtp-Source: AGHT+IGkHWNGUSeXP4u+5TcuucyTd2GKgyI8juaMx8P42FtIBV9XRh1JzYI28ll1lWmPtifSnL9VaQ==
X-Received: by 2002:a05:6a21:788c:b0:19e:c3f1:2bde with SMTP id bf12-20020a056a21788c00b0019ec3f12bdemr875076pzc.16.1707548788473;
        Fri, 09 Feb 2024 23:06:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVxw8VRzKF9uH6Nf2zL7Ax94CWw4MwemBqyMhhzI3dwcvQOLn6rSFaxMAGypT/S8o2/B0Ld+aZ5lHigen/kW6A2LWzsnhJRnXbJ7JHOh9Fdv1502yljEDJuNMohUj9qKzT9AoESJ1j+TjSKQGn2Qom/2TtZxpVDGDXy10FK6s6Rg4RwfavfxdSf0AbErjLghjFuRUydYBOZVmxmkgO8cPuwEDelJuDcmF8hKg==
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id sb3-20020a17090b50c300b002961a383303sm2857513pjb.14.2024.02.09.23.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 23:06:28 -0800 (PST)
Date: Fri, 9 Feb 2024 23:06:27 -0800
From: Kees Cook <keescook@chromium.org>
To: Lee Jones <lee@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	Hannes Reinecke <hare@suse.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 08/10] scsi: aic7xxx: aicasm: Replace snprintf() with the
 safer scnprintf() variant
Message-ID: <202402092306.0ED53F66A@keescook>
References: <20240208084512.3803250-1-lee@kernel.org>
 <20240208084512.3803250-9-lee@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240208084512.3803250-9-lee@kernel.org>

On Thu, Feb 08, 2024 at 08:44:20AM +0000, Lee Jones wrote:
> There is a general misunderstanding amongst engineers that {v}snprintf()
> returns the length of the data *actually* encoded into the destination
> array.  However, as per the C99 standard {v}snprintf() really returns
> the length of the data that *would have been* written if there were
> enough space for it.  This misunderstanding has led to buffer-overruns
> in the past.  It's generally considered safer to use the {v}scnprintf()
> variants in their place (or even sprintf() in simple cases).  So let's
> do that.
> 
> Link: https://lwn.net/Articles/69419/
> Link: https://github.com/KSPP/linux/issues/105
> Signed-off-by: Lee Jones <lee@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
