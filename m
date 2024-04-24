Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972D816D9B3
	for <linux-scsi@vger.kernel.org>; Wed, 24 Apr 2024 15:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713974376; cv=none; b=H1JQOpKdUwDPObEV7jFmn9+11Ccgqkqlxd0jQ7cTvx5M9rhc78hxQq6w2qHFGLOo3wRZKOpCCxXqw+piW+V0bCSKI1jk66xYaEKLiORZkbiVw/DYjENbsB9Fbpoybg81Gb44/W4Atu9UqOVD4j1AyCC6E8vrxv4AvVahXdpfbzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713974376; c=relaxed/simple;
	bh=0GiSfYTnN6d165IOBQzb694rnUh8tyUWWbTI6T31ybQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GOkJU980Gi3xvIa2W9W0VoYVaVYP6i5xsjctP8KVN4Mk7Y4DwbjYexTjaVejQBphmndGe33YHN7l5OLhI4aPqMVDxb5MMqvEggWI12K5KZRCSabgAlZmmBLKrF60oZHFDWyDfUhBsUBi1LO1ykt0jPftmQ48cdMhFCbERXaQ5zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=JbZOhrpT; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="JbZOhrpT"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1e9320c2ef6so31542715ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 24 Apr 2024 08:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1713974375; x=1714579175; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3WnnPsbn6LQ0620dM71ztuHhda8zUa4oNBqxG0zPojc=;
        b=JbZOhrpTlsJnQLzZ365dtjwupe70dJDCEXDimOBMkR3Bg7+zZd3iVL9+c/fblvuOJR
         x0/p7JzcKbF5JES4niDrqp9telHI2uMJwCUzDwhUzTuXKR6QJJzAvzo4uhChsQDsbZmc
         tiA0z6vwEp4T0MncXqV7aYzXI91gWY/TuKhuY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713974375; x=1714579175;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3WnnPsbn6LQ0620dM71ztuHhda8zUa4oNBqxG0zPojc=;
        b=Brs140xelAdPs3GNVucvcR9OQbTuqCs9U4H39xLR1/yOi36Nvz3pKAv1w9s1jtIE3c
         v9pXYH1eOH0B/KaJpjabtQEocfkT/Gfzi0fEsHTmnnJHRI0H6/bcqFDAsMNHBBGxyRpM
         epK4QWyiXgB7D1hWQOFuX4GpNtewz+0CuPGtzbh3yhpghd+c/rTphNXVVaXzgTc+5+Vj
         tO3gXDa5zMCVcA69+QXHEc39PKWbCW4WuBxYxGi8LaXGaIylf4CRb7eYUv+6Hit/9HRS
         hzs5Q0K49vIaJf4Jqkt/VyQ4zBT4Y/xm8+xfs2+FpBSCUfR7l9M8Fv3cikl9lJBYE+iY
         b/jA==
X-Forwarded-Encrypted: i=1; AJvYcCVMjoHfdW4t8olMp8ipDg8bx1casZoOSfpdOG9L8oO4wCvu7LCNymGcTvDTddjaeGErzv/8He6bOrH3Se2j4uKzWD49E7wZpdKUpw==
X-Gm-Message-State: AOJu0YzW/t4hBXhN7ELm4M8tw3u2MSjYCW5wAq2I+07VepEQK+uzG1n9
	1K3KKs9PeIUzITWciHw+KGiINdResuEp/Ke/UmZMkLFFfdVHZquXGrl0lHJMEw==
X-Google-Smtp-Source: AGHT+IFH25XoxrsKcb6phfTBuhyybN5yfvn80JCnlXdGkC8eys5A64GweFI7pjlxIx0ItdNyWbfEnQ==
X-Received: by 2002:a17:903:11c3:b0:1e9:9c6e:9732 with SMTP id q3-20020a17090311c300b001e99c6e9732mr3467740plh.19.1713974374923;
        Wed, 24 Apr 2024 08:59:34 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id p9-20020a170902bd0900b001e4565a2596sm12100439pls.92.2024.04.24.08.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Apr 2024 08:59:34 -0700 (PDT)
Date: Wed, 24 Apr 2024 08:59:33 -0700
From: Kees Cook <keescook@chromium.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Justin Stitt <justinstitt@google.com>,
	Andy Shevchenko <andy@kernel.org>, linux-hardening@vger.kernel.org,
	Charles Bertsch <cbertsch@cox.net>,
	Bart Van Assche <bvanassche@acm.org>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Nilesh Javali <njavali@marvell.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com,
	GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH 1/5] string.h: Introduce memtostr() and memtostr_pad()
Message-ID: <202404240858.0FDD390@keescook>
References: <20240410021833.work.750-kees@kernel.org>
 <20240410023155.2100422-1-keescook@chromium.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240410023155.2100422-1-keescook@chromium.org>

On Tue, Apr 09, 2024 at 07:31:50PM -0700, Kees Cook wrote:
> Another ambiguous use of strncpy() is to copy from strings that may not
> be NUL-terminated. These cases depend on having the destination buffer
> be explicitly larger than the source buffer's maximum size, having
> the size of the copy exactly match the source buffer's maximum size,
> and for the destination buffer to get explicitly NUL terminated.
> 
> This usually happens when parsing protocols or hardware character arrays
> that are not guaranteed to be NUL-terminated. The code pattern is
> effectively this:
> 
> 	char dest[sizeof(src) + 1];
> 
> 	strncpy(dest, src, sizeof(src));
> 	dest[sizeof(dest) - 1] = '\0';
> 
> In practice it usually looks like:
> 
> struct from_hardware {
> 	...
> 	char name[HW_NAME_SIZE] __nonstring;
> 	...
> };
> 
> 	struct from_hardware *p = ...;
> 	char name[HW_NAME_SIZE + 1];
> 
> 	strncpy(name, p->name, HW_NAME_SIZE);
> 	name[NW_NAME_SIZE] = '\0';
> 
> This cannot be replaced with:
> 
> 	strscpy(name, p->name, sizeof(name));
> 
> because p->name is smaller and not NUL-terminated, so FORTIFY will
> trigger when strnlen(p->name, sizeof(name)) is used. And it cannot be
> replaced with:
> 
> 	strscpy(name, p->name, sizeof(p->name));
> 
> because then "name" may contain a 1 character early truncation of
> p->name.
> 
> Provide an unambiguous interface for converting a maybe not-NUL-terminated
> string to a NUL-terminated string, with compile-time buffer size checking
> so that it can never fail at runtime: memtostr() and memtostr_pad(). Also
> add KUnit tests for both.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

FYI,

As the string KUnit tests have seen some refactoring, I'm taking this
patch and refactoring it onto my tree. Once the SCSI fixes are reviewed, if
we want to land them in -next, it's probably easiest for them to go via
my tree.

-Kees

-- 
Kees Cook
