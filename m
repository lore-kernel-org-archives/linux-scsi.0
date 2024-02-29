Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6178359149
	for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 00:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709165930; cv=none; b=Qiym7630lDWkzcn/akQN1q5xHj3bMeUVnFuO5nNaSJud9DIqLoh8SWEy8baFFxQFv3SVKQa5czPrGrR0q5pZocpwxJDBTD2mI30ox21q0gQnVihNom2j4Od2SGQgE9eTt4w5KiPsIIKf6uqffFAFGY8kub7PpmMw5jV+QaBiW6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709165930; c=relaxed/simple;
	bh=9DJj6YTz0ZZOl6MAUN9AsplTyADMYRPheFd4FjREcq0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TNHhjwIF/Ejr2OlRThlzitIUarV8uOCjcquy2kpNcbWBCRbptjEfM1dmCQBPEZyZAPxcvLu+YQBiMnPEkZaG1xRXsSD90Kn2oVgU8jcdCEP4jnPI66QF4HyG5LtXRp/+wqafyPR4vwbJLCtyX2mw/F/CJ2UqkyAu5vIgD3gABvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Zd6FsrbG; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Zd6FsrbG"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-299e0271294so191904a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 28 Feb 2024 16:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709165929; x=1709770729; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=K5uqn8jk7ThAKtuWvpjc6qdSbK1EvuBbH6icwTpGIW4=;
        b=Zd6FsrbGvnNHW8S/xTkaP8iOt0/OYTPNpeWEampDlCmOtdciZpBKQacdXgA3W8WqKd
         je2ed3pek8hzLO8jLXSAiCfElrc/dD2tOLHFMyF0P5JuV1g+AZaU0I40tkMAVPEhCjEU
         kbIf/NuBfZz5rKsXoMemtF89f69aO0mt0e9/4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709165929; x=1709770729;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K5uqn8jk7ThAKtuWvpjc6qdSbK1EvuBbH6icwTpGIW4=;
        b=mLwtZYNxECnWad+gHKaemF939NEsxqxgdJD1b4W5uS+kNXPC6kqhQs0fyln4AIzHHB
         KO6gn2/v6AMDDQPx1zxqbQg6xQ5bR0wNvO5L+zrf1SNTzyYixqUUx6qboECpXjLF7gIo
         ARFlXesT35J1TYlf8RHh+5fmrH68lSnQHQXMNSeXP9XgqZbXf5tX/dnJkVBI9e0GWVW0
         xFbmQi/T7p+DtPdVLzlBkBj5dOjgFoAs2ndHJnUrH/5tXkfSO+BMVPte35J8c9/VNXLB
         AJG1BqN5ZO8kw1lSBrQcKLYfkprtohvQbL7UeKnS1AneD/ENsq4RCu7M5PiBOAfp5ptK
         Vtlg==
X-Forwarded-Encrypted: i=1; AJvYcCX2lDJAa+/wOElkdcyqY+oAvs8APQphiblT8RtJRXIPP+0BrM6MMQtQu0tM7sgFg3An7Zk7kzu2pKu3Q7Yn8bo122N48J2c6EmU/A==
X-Gm-Message-State: AOJu0YylvI8k7hfFJFb6SXPlJCQivbNoycKVKXv3oxuoeaLqokfDRcvD
	EI2stJdHwrHuJqhBmrO9l3pmHEP6mQOEF2WilEc/1VoCth3XFi7RVJbdluJntg==
X-Google-Smtp-Source: AGHT+IG9LGv7xga1c26psaW5lSQ/a3FgyK1kDrzHgkNdLgVdVr5RsO1xWGsalLcOFQ/g2GqHBPATsg==
X-Received: by 2002:a17:90b:3905:b0:299:6848:28c1 with SMTP id ob5-20020a17090b390500b00299684828c1mr834549pjb.26.1709165928724;
        Wed, 28 Feb 2024 16:18:48 -0800 (PST)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id su7-20020a17090b534700b002973162eca1sm2292760pjb.17.2024.02.28.16.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 16:18:48 -0800 (PST)
Date: Wed, 28 Feb 2024 16:18:47 -0800
From: Kees Cook <keescook@chromium.org>
To: Justin Stitt <justinstitt@google.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ariel Elior <aelior@marvell.com>,
	Manish Chopra <manishc@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	Don Brace <don.brace@microchip.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	MPT-FusionLinux.pdl@broadcom.com, netdev@vger.kernel.org,
	storagedev@microchip.com
Subject: Re: [PATCH v2 0/7] scsi: replace deprecated strncpy
Message-ID: <202402281617.807B1B7@keescook>
References: <20240228-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v2-0-dacebd3fcfa0@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240228-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v2-0-dacebd3fcfa0@google.com>

On Wed, Feb 28, 2024 at 10:59:00PM +0000, Justin Stitt wrote:
> This series contains multiple replacements of strncpy throughout the
> scsi subsystem.
> 
> strncpy() is deprecated for use on NUL-terminated destination strings
> [1] and as such we should prefer more robust and less ambiguous string
> interfaces. The details of each replacement will be in their respective
> patch.
> 
> ---
> Changes in v2:
> - for (1/7): change strscpy to simple const char* assignments
> - Link to v1: https://lore.kernel.org/r/20240223-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v1-0-9cd3882f0700@google.com

I think you lost my tags for the later patches. I re-reviewed a few and
then remembered I'd already reviewed these and they were unchanged. :)

Please run:

b4 trailers -u 20240223-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v1-0-9cd3882f0700@google.com

:)

-Kees

-- 
Kees Cook
