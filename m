Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB5D10E3
	for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2024 00:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708561835; cv=none; b=EEH73cPb/hBcp6BExvcDxMDuzBq/nxaPhRixFt8k8QoH/J4RM/Xd7MoUJTpYwG9F/YCqWGl6HBHDdyavwTRWMXbACSFmqVcjU+DnLQmBMvU6Jx6A/HcRIriopoe7s9o1sKmkIwPiACSbTDg4ghy3MkS2eUdWOEa6Zd05z5+QeUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708561835; c=relaxed/simple;
	bh=0a+PXUr4/M4QxUhsk3p3ht76EXkTT/vUlf3xCYroLtw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u7GkDU3WLXOJ0Htv0czbRRq3ZV8RvHe1FPpzUmUz7af3JUnTymKsoP0BcrzUt1yzpH0qndFwlHQQzjGJJJ7PRAFfnzbGLvXjkYBaPr5t0WCs7XeOe3Cmmw15syqiFXEY1HA13DXSLlpg3JnQMXkxgSYB/Tr3G+82uTgyUQ4dW7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=FewjVpXr; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="FewjVpXr"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2997a92e23bso872918a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 21 Feb 2024 16:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1708561833; x=1709166633; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cphzXha2ug67Fvg8bHldw5MnRmdUMWu6AQ/eN1G60FM=;
        b=FewjVpXrIrXCAek5YMytycaY9A9MQ2RoFd3GLoRK2WyUbT57vK63pWTQjLE7j7ugiX
         nPWzTjI6JiIvnZ6HIzDShW6NbJYJs2Qo3e26peOn8PjRFSgB1gIlF5l4r9fFkVB11kVU
         N9pxagOfd4lKZF/jSVOGF/q8qW7XLoBsp1oRk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708561833; x=1709166633;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cphzXha2ug67Fvg8bHldw5MnRmdUMWu6AQ/eN1G60FM=;
        b=mmsHimfXmp8DFhrc+opEyRHMCBzZpMRHeHjn54CzL5EFNMBCQsAwoEtz8yL9IRzDD9
         Mjr9f8FZeQZBpyUKoD7BxW2b/rTtR7ZiI0gaV19Th9Xw+pkirOW05onOGcOhjNact7Fo
         5/g6wccc3ABRdJLNlVc9DrVOAA1bkzAXId+bGOiYz11+Q1FLi8GQwWJ9ETq4H5gp9rSR
         oC/C3ZZt0lu9B6irxO0Ha3H7MQoA8WPyRXrBnOhYFm415j8fgO2VaqS5oXDCMLS7azfw
         sKun8DdDuy6nJaxTC09g40rGDW3f8XgM4dbf00uI64a1ayxK7xOlh2/rJ7F+vW99H5Tn
         cUsA==
X-Forwarded-Encrypted: i=1; AJvYcCVo08DyTj6Oi4XUHj2qBBKKnnq9e7FAGpzO87LiLU6ucdyVbRTpjTP2Ejp8I1QkPAsLhIxHvxPlKa/LFJrsxkWsB1ZBkPesiqzaYQ==
X-Gm-Message-State: AOJu0Yz2Q62IqT+2WoiiTs8/hxVQW1v2BjXA4Px0EXw5/BoAUrJWtu3T
	7uIz3lBR6i+zz6FCQJvqzbSA507pi5ybFMx0dLBI6Em6t6Cu2sRGNT7JFwBrJg==
X-Google-Smtp-Source: AGHT+IFPk//p0bZSwagAp3iX4U/EP6BCxupu6BvHEFS6IcIIUIlmW54lKSp/YxG5QTnQKWBq6j+csA==
X-Received: by 2002:a17:90a:b902:b0:299:3258:4053 with SMTP id p2-20020a17090ab90200b0029932584053mr14295400pjr.15.1708561833583;
        Wed, 21 Feb 2024 16:30:33 -0800 (PST)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id e21-20020a17090ac21500b00298dd684b8csm10445951pjt.32.2024.02.21.16.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Feb 2024 16:30:33 -0800 (PST)
Date: Wed, 21 Feb 2024 16:30:32 -0800
From: Kees Cook <keescook@chromium.org>
To: Justin Stitt <justinstitt@google.com>
Cc: Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] scsi: libfc: replace deprecated strncpy with memcpy
Message-ID: <202402211630.184FE822FB@keescook>
References: <20240221-strncpy-drivers-scsi-libfc-fc_encode-h-v2-1-019a0889c5ca@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240221-strncpy-drivers-scsi-libfc-fc_encode-h-v2-1-019a0889c5ca@google.com>

On Wed, Feb 21, 2024 at 11:50:26PM +0000, Justin Stitt wrote:
> strncpy() is deprecated [1] and as such we should use different apis to
> copy string data.
> 
> We can see that ct is NUL-initialized with fc_ct_hdr_fill:
> |       ct = fc_ct_hdr_fill(fp, op, sizeof(struct fc_ns_rspn) + len,
> ...
> 
> In fc_ct_hdr_fill():
> |       memset(ct, 0, ct_plen);
> 
> We also calculate the length of the source string:
> |       len = strnlen(fc_host_symbolic_name(lport->host), 255);
> 
> ...then this argument is used in strncpy(), which is bad because the
> pattern of (dest, src, strlen(src)) usually leaves the destination
> buffer without NUL-termination. However, it looks as though we do not
> require NUL-termination since fr_name is part of a seq_buf-like
> structure wherein its length is monitored:
> |       struct fc_ns_rspn {
> |       	struct fc_ns_fid fr_fid;	/* port ID object */
> |       	__u8		fr_name_len;
> |       	char		fr_name[];
> |       } __attribute__((__packed__));
> 
> So, this is really just a byte copy into a length-bounded buffer. Let's
> use memcpy().
> 
> Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
> Link: https://github.com/KSPP/linux/issues/90
> Cc: linux-hardening@vger.kernel.org
> Signed-off-by: Justin Stitt <justinstitt@google.com>

Thanks for the refresh! This looks right to me.

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
