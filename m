Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37EBB364DB
	for <linux-scsi@vger.kernel.org>; Sat, 10 Feb 2024 07:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707549244; cv=none; b=rZh1fl7uaxYcxjdPhrwjQ9aZgSLbHWuuwfAaV4JR0RSbaSJqGqSVTnRU6JVS5aHi+C2FrxkjugqFNzu4wEqrgAOD0zF6XVH5EKzusBnLXCDgNXxhk475OotLj8zyb/Ax9IhO1rzE19GalaBANQzAMEEEbfnVGp+/tvvkPXE9G8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707549244; c=relaxed/simple;
	bh=Umw67NSx6veGxflgycHZ9hWuO+uljq6JdaHaAgRnIAA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kkrdNcCSjzQDHsrZTJ5Xz4D4yfmc2XtXc0/nLe8hPzGfzmpKFHQstdUaM7uEu0DKgMYhSoL+ox6SaXuNe5wwG7aCtSb1n0UGDbHDrk5yQO1GkxVrkt0FHPA/caNSk1hS5eSUDORrccqBrKh8CNIZSzPLwGVElQEOU5ZJcCy+k7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=GeThgPz2; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="GeThgPz2"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1d7354ba334so14838725ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 09 Feb 2024 23:14:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1707549242; x=1708154042; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pMttalflqfwloIFlu0Md5bgBDJMW6J4Nu25+yNhA1O4=;
        b=GeThgPz2pcMNAE0i3ApFnj0QytJZVuqxqeVKrjHxTVGIiZ9kAd2f1tma8CxynCFHVV
         BV4jOfz1VJM/4fmGaUR2QL6BpAExkc1NBNwTWOy88b5dpOxO/IBS1XSwh07kumpJw+h3
         WWQ+5CPRDtSbP1dgJ6vrY+FZf+RkVdgIL/QDE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707549242; x=1708154042;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pMttalflqfwloIFlu0Md5bgBDJMW6J4Nu25+yNhA1O4=;
        b=vkGJQKugrpXHjbtPbQtRE47X4DTRb0jqFlhMnLPhcLHqeyoRDKAZqXnfyDPOtXokqp
         aqRS9hr/4XW32mqpA6lD6kgDB9rzE9L7uoMZKspbJd+UqbzrITSljtTXii2qnVuQAIlE
         60gv0ww4rFVmSdupty4S5fMCQ7u6oZHirGcqLuAMZ3S1jCqaaAMabtpzRSum1AtjaMrX
         PczbHS9fkQd7T8krBba7k52eYX2/yGz2Q2Wvaq6twBw+58ahmzr6VPb1Eqbxm7+A+iiy
         qdttW286DN/gc7B133f3Y6VOxGMe9bBqdxumqw/P3Hvlp9G4G6k/PW/3UolBhfydFpTf
         Ln7Q==
X-Gm-Message-State: AOJu0Yw1elZN1IjvuKmOY1P4fAT+52oHikERz6Qy+/1hx4Z/qgEvUtpq
	P68gi+6Vxos04h7zARsaYKzqt0FieLk0/FWiYOQmjhPTjLSrGC30KX9sOkvjlQ==
X-Google-Smtp-Source: AGHT+IEiCCvJy9lDrOwRv+k1eZW2Eqi3XGmMmZQItYkt98YYvSbj4FAdQnoh7ct/ECZZRerv7l3kew==
X-Received: by 2002:a17:902:f54e:b0:1d9:4544:ed22 with SMTP id h14-20020a170902f54e00b001d94544ed22mr1583577plf.42.1707549242539;
        Fri, 09 Feb 2024 23:14:02 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXC2JgAKS8vHeycLoS66y+OPZvM56enaCv8ISAoq8xgWPmei75tjoykmemdkNOmICU4z+lz4LG+M9cLspRr6SwdRzOq/SXNYi7CRwYxJHm9AgQ/YpL8bUtR07IXLj+vVPtZlgqSjeFt01GIo+btnC57gakrPrTHOZmtLXDb/PJsHth6ScAdHeN5X8+0ErVc37YMivwlTZN3HS3GRnVeCESu6CMLfCncPqSA+77fZlI/ABHEJIoOi0hPmsrQB8UuooCwh8PAO72EOTrztHnOkjEKDFgCevheVfkSblS3zKUf3FKpa36vdnCaanV77tGRcGLA4/aWkA==
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id gw10-20020a17090b0a4a00b0029709f8a976sm2595650pjb.10.2024.02.09.23.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 23:14:02 -0800 (PST)
Date: Fri, 9 Feb 2024 23:14:01 -0800
From: Kees Cook <keescook@chromium.org>
To: Lee Jones <lee@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	Finn Thain <fthain@linux-m68k.org>,
	Michael Schmitz <schmitzmic@gmail.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	drew@colorado.edu, Tnx to <Thomas_Roesch@m2.maus.de>,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 03/10] scsi: NCR5380: Replace snprintf() with the safer
 scnprintf() variant
Message-ID: <202402092313.D3894DC9@keescook>
References: <20240208084512.3803250-1-lee@kernel.org>
 <20240208084512.3803250-4-lee@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240208084512.3803250-4-lee@kernel.org>

On Thu, Feb 08, 2024 at 08:44:15AM +0000, Lee Jones wrote:
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
