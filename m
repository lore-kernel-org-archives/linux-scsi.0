Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74D159166
	for <linux-scsi@vger.kernel.org>; Mon, 18 Mar 2024 21:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798176; cv=none; b=Ni8F+aRWVZsPWtP0Nn0nvYDgnXrVZI30amJjJviBj0XJXrN3Vj8yHf9uZtS1RL4wqLU5HYX+F8zYguM9fIwVfxOKzRQ4gD9Alt7XV7+/aM5HI0g3iWCp+RxiArFz/CT2IOkakDMZHGgAcvhPKvo+x7fhEsY+7J64Y/pT5TI7Jd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798176; c=relaxed/simple;
	bh=iVcACEXJ7ByPQf/VBR4On2mYZO1me0Bq9PH9vIqjwdk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HOpcHbtxjkF51QmGP54MxVkXyx/hPusfG08XF5754WFHmaj4uWiUjAASgcEOSXuuOfUvYNSP0r9kSHat9FPjCz/uz9WEQxQiip46vFKClvInKHo/7L/d1K1PyC3hdPUAjiL3w/qt/t7pyZk5rJN9srJ1OpRyssW1EUyeUGLst6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=P07bGrcU; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="P07bGrcU"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-29ddfd859eeso3713578a91.1
        for <linux-scsi@vger.kernel.org>; Mon, 18 Mar 2024 14:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1710798174; x=1711402974; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7ZT3rXspzzYF/8VZb3BdJDfiIw9byhNvhoKVVNwzolw=;
        b=P07bGrcUbCkl6Na9Jht1T9n59gwomnTOspdHFH4AvL0VyCoWGjuVN+oomoYbTJ9bb7
         fu7UXDwbSHJSVNwg459j90QJNN+DhZZWPys+hiNv9JCxeXHTow89eMr95249LnQ6t1m0
         QmTny9xaFOK5tYK8tagQBQpBytPOIXgZ/HNZ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710798174; x=1711402974;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ZT3rXspzzYF/8VZb3BdJDfiIw9byhNvhoKVVNwzolw=;
        b=iObANYNpnmlHFV5LIlWD8wqlDYeJYThfLyo35+U+0ApwTfueGAlm2uGgV3/zCQbMEe
         2ygcE+2Zw5OmZ3Y9VuIJqqRijCghJMhG0BQpvml5a9o/KuA3R5DitXpgEGsqBz6/sDb0
         e7fCoe7Pb53OFFXP6abb1RVy/m+t6kvBii0VY7WvAOstK7tHOZxF5x2WK2jj86JrHal8
         tySE9Zkdjwgr3+fh/UIIrhvhG0m1JQQhrv9mHHjaBXZ1WW2JUBB9sr1Ki3TADM7mm69p
         UwdDSeA+9Fu3LS6culGmvf5NZsLdICZ9C7z5AbJ6ZKZIciMAX+2R94uEYGkFVCM6MuNV
         ZT4g==
X-Forwarded-Encrypted: i=1; AJvYcCWEY9uRSgvU2WrWmrvqF/VzVaYytE3tBLzLrGPFDkuDVdwL0zwZ7PxXGdQvVGnpque/FG66XLIBSbJbn62QWV0f4ALOqn6b0lvOnA==
X-Gm-Message-State: AOJu0YydIlfZ2osLw8DrG6PdvhXdKQeNMoyB+7FdqbEo76tsTfAFJ7bV
	eFKAGPsENFYetl1mVsHJ5o1UX1D5RL2GnNJjULtV5dkoHxk7mP3OefcsqJW9sQ==
X-Google-Smtp-Source: AGHT+IGg9l6bZmeO7Ny5acljZFDqRjc8/N34eF9u08DQc0aZry14iz4qSdvaqNwuhzR5e/Zliea6fQ==
X-Received: by 2002:a17:90a:8044:b0:29c:7931:87f8 with SMTP id e4-20020a17090a804400b0029c793187f8mr10092454pjw.43.1710798174286;
        Mon, 18 Mar 2024 14:42:54 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id l23-20020a17090a3f1700b0029bce05b7dfsm9004860pjc.32.2024.03.18.14.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 14:42:53 -0700 (PDT)
Date: Mon, 18 Mar 2024 14:42:53 -0700
From: Kees Cook <keescook@chromium.org>
To: Justin Stitt <justinstitt@google.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: target: replace deprecated strncpy with strscpy
Message-ID: <202403181442.1E78DAA4@keescook>
References: <20240318-strncpy-drivers-target-target_core_configfs-c-v1-1-dc319e85fe45@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240318-strncpy-drivers-target-target_core_configfs-c-v1-1-dc319e85fe45@google.com>

On Mon, Mar 18, 2024 at 09:32:01PM +0000, Justin Stitt wrote:
> strncpy() is deprecated for use on NUL-terminated destination strings
> [1] and as such we should prefer more robust and less ambiguous string
> interfaces.
> 
> We expect db_root and db_root_stage to be NUL-terminated based on its
> immediate use with pr_debug which expects a C-string argument (%s).
> Moreover, it seems NUL-padding is not required.
> 
> Considering the above, a suitable replacement is `strscpy` [2] due to
> the fact that it guarantees NUL-termination on the destination buffer
> without unnecessarily NUL-padding.
> 
> Additionally, we should also change snprintf() to scnprintf().
> `read_bytes` may be improperly assigned as snprintf() does NOT return
> the number of bytes written into the destination buffer, rather it
> returns the number of bytes that COULD have been written to that buffer
> if it had ample space. Conversely, scnprintf() returns the actual number
> of bytes written into the destination buffer (except the NUL-byte). This
> essentially means the ``if (!read_bytes)`` was probably never a possible
> branch.
> 
> After these changes, this code is more self-describing since it uses
> string APIs that more accurately match the desired behavior.
> 
> Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
> Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
> Link: https://github.com/KSPP/linux/issues/90
> Cc: linux-hardening@vger.kernel.org
> Signed-off-by: Justin Stitt <justinstitt@google.com>

Good catch on "read_bytes"!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
