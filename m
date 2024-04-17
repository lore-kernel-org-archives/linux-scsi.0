Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74A61487DE
	for <linux-scsi@vger.kernel.org>; Wed, 17 Apr 2024 17:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713375351; cv=none; b=Kwomr1dYPdKFd0kbuBf18Rm4r8JBmXBu9Zjq0XSzirjiHpwbkZvUGTfrLLUayuZHeovfSjCiMUbgPv9e4YWHtFVyu0zlOH7j2EYhmoOlkSOLdhr45zX/3m8954trb6n1Egew/y7Rk61smvgxABZwcyRX8LzUTaszbeo7Xveyj4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713375351; c=relaxed/simple;
	bh=EUEq5eCikvb1PA+1pE5jT5oLwrFNWhGgWfY9hb71rBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sSgu61zjTGubS3ahTCx767nVjRKRq9TAXhGLTRGdfh2bFtvIwRBugTXiugL3nkluibiPcaixdpjCJfM0iDZfWfd34ZMe1f315L8AKHYq+gZ8jC2+0SYOiiktZiyEWOMfgI1SiE95zGy2JO3ee7I4cPHzNyqF52cwFI3qnmjLR40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=NsJKJOXw; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="NsJKJOXw"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6e46dcd8feaso19177b3a.2
        for <linux-scsi@vger.kernel.org>; Wed, 17 Apr 2024 10:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1713375349; x=1713980149; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pBJiH4urg4DBG6eZbcNPwgnZOdXfIaMFo9RuiRFHB0E=;
        b=NsJKJOXwccHJwQ85rjFYE5qWw9ab4sPiSFGsQinb/nv07xhBj94Ty+ttoygJ0Ayekz
         IIgZxNprKvMkfksYKhW89s9hAPPiknzK/5deAJu7lU0fzVuUuzZEBlx/o2LjL3ZEwbWS
         JOzOo19mCKfQko9dmQUoQpDC+YeeC3P/p0bH4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713375349; x=1713980149;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pBJiH4urg4DBG6eZbcNPwgnZOdXfIaMFo9RuiRFHB0E=;
        b=GVmrHml2wLoFzp4NksDe4LjLSxJLBLXMGnJPMdwbwvSNfAgsMEjza0yCvOqNKeh2S4
         JwdN26iKNuY9LEoSq4HT4bqIB5FJzwgkyW0Hj8AQhlb8hRptVKuge9IZoBxpIkt9hnx+
         hHVqLT3MAr+DC4yQplalLFL7583TtCXttjsQFpESrDksXgzqLd3DmEtt8ISd9JIokZIY
         22sNJ9P4wfEECGLwitEDaKh/vj73Jad/o4K8IBUAU5ZkGE1F85nKrFi61uZGm17bj/sg
         Wg15uFSxWU0DFm45siW+05aI0Ry3ODdWFHJqO5BTjcgbnYlE/EMgo7h9GqAxBi1eWlD/
         sCiw==
X-Forwarded-Encrypted: i=1; AJvYcCV80h33CUSwHIZdoIoMBG7dmQXdrGx0RQBR1Ua8xUliDhuL+2M/NDGxitkFI0IlOmCQwql50QOhj2e+dZmwP7XDERsQ9nFQ1fi17w==
X-Gm-Message-State: AOJu0YyvYKEpPkRpgd7v9hiNOoJGL0ylRhxoTwaBBMYeFS0uLffRx7gs
	4GQ4/D5C1d4e1i3/Sh7/uWQMTbIjWPdTvYPa4oTKXq7eG3yIWrElHDjyzEoQNg==
X-Google-Smtp-Source: AGHT+IGRhXAn8BnFec3OXIieh95t6IYTWzPHJKZQXAIRwjXtFeTGFo/I0JMHxUAOWhgdyp8JVnjm6A==
X-Received: by 2002:a05:6a00:22c4:b0:6ec:ec8f:d588 with SMTP id f4-20020a056a0022c400b006ecec8fd588mr281477pfj.16.1713375349095;
        Wed, 17 Apr 2024 10:35:49 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id gx15-20020a056a001e0f00b006e71aec34a8sm10927754pfb.167.2024.04.17.10.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 10:35:48 -0700 (PDT)
Date: Wed, 17 Apr 2024 10:35:47 -0700
From: Kees Cook <keescook@chromium.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Charles Bertsch <cbertsch@cox.net>,
	Justin Stitt <justinstitt@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Andy Shevchenko <andy@kernel.org>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Nilesh Javali <njavali@marvell.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH 0/5] scsi: Avoid possible run-time warning with long
 manufacturer strings
Message-ID: <202404171035.BDFF28D@keescook>
References: <20240410021833.work.750-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240410021833.work.750-kees@kernel.org>

On Tue, Apr 09, 2024 at 07:31:49PM -0700, Kees Cook wrote:
> Hi,
> 
> Another code pattern using the gloriously ambiguous strncpy() function was
> turning maybe not-NUL-terminated character arrays into NUL-terminated
> strings. In these cases, when strncpy() is replaced with strscpy()
> it creates a situation where if the non-terminated string takes up the
> entire character array (i.e. it is not terminated) run-time warnings
> from CONFIG_FORTIFY_SOURCE will trip, since strscpy() was expecting to
> find a NUL-terminated source but checking for the NUL would walk off
> the end of the source buffer.
> 
> In doing an instrumented build of the kernel to find these cases, it
> seems it was almost entirely a code pattern used in the SCSI subsystem,
> so the creation of the new helper, memtostr(), can land via the SCSI
> tree. And, as it turns out, inappropriate conversions have been happening
> for several years now, some of which even moved through strlcpy() first
> (and were never noticed either).
> 
> This series fixes all 4 of the instances I could find in the SCSI
> subsystem.

Friendly ping. Can the SCSI tree pick this up, or should I take it
through the hardening tree?

Thanks!

-Kees

> 
> Thanks,
> 
> -Kees
> 
> Kees Cook (5):
>   string.h: Introduce memtostr() and memtostr_pad()
>   scsi: mptfusion: Avoid possible run-time warning with long
>     manufacturer strings
>   scsi: mpt3sas: Avoid possible run-time warning with long manufacturer
>     strings
>   scsi: mpi3mr: Avoid possible run-time warning with long manufacturer
>     strings
>   scsi: qla2xxx: Avoid possible run-time warning with long model_num
> 
>  drivers/message/fusion/mptsas.c          | 14 +++----
>  drivers/scsi/mpi3mr/mpi3mr_transport.c   | 14 +++----
>  drivers/scsi/mpt3sas/mpt3sas_base.c      |  2 +-
>  drivers/scsi/mpt3sas/mpt3sas_transport.c | 14 +++----
>  drivers/scsi/qla2xxx/qla_mr.c            |  6 +--
>  include/linux/string.h                   | 49 ++++++++++++++++++++++++
>  lib/strscpy_kunit.c                      | 26 +++++++++++++
>  7 files changed, 93 insertions(+), 32 deletions(-)
> 
> -- 
> 2.34.1
> 

-- 
Kees Cook
