Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA42A30DD14
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 10:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763114409; cv=none; b=owAtYp4Th9FzTuedAEsEoOJnKUE09OMLT3HyIFhRLKMC9YSyT1gzOwbeaX+eNbGcglhaveeF3GWyxvWDKg+hqROpEgojH1kdjWZ3rAN36GZJ3a5k3RKwGhVLNrm7s4W6azlEpI+OvltpTNqNzDrolSJnlQja31UYigxjS/TZXP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763114409; c=relaxed/simple;
	bh=/FUY0v+htwnu1CF9LO/QH/vtcUvsUmFwxVAj0GZZt94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W/BjC1RmXwRexn33qV6GyuVfeSxQpPmQszWCVeWnghMr2GBl2vLs7aKR9wihQWSdFw54sbAzrR4bok+wqOvQ6ciq5IQtGrlEMBu66pHnIAW0Cx8qxuGcm8rNyDqwELmAdFTIRUaI5KL7cSHUNTKH3e+peIULga5UOwYjsq1qnlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HEp14c+B; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HEp14c+B"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-297ef378069so17197665ad.3
        for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 02:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763114405; x=1763719205; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GlLIJfW5kYx8oRi5VGvCrY+a5MlnVb5xLPFUIR6E2IU=;
        b=HEp14c+Bt+XC5xFoeBqa5vXgyv0vETFocIaew7AvfB9gS/Pz837CQG0UZEnpXNGalD
         QVWRO3v+riPfz0LqgornjsottOK1j82hyDKZ/Pav+S/WSAkBBdafXQyzklywENJ8DNzl
         6wXPzFiFI/5ffv/Ly/GbLl0zMEiHENkHb5dEKv9MuIkyIy2fH9dWDWx4gocfcw44rYok
         BQy4FYjSUWlPFixRSiyIHqtoq2AegueXjCUL42lsRNhJMglHPfF3ZWFH5wp0iqN9sKPZ
         bZVa1636qzk1R6wZAHBnTgRhOgwRgyH7GaWdqMJwEUApMpErZB/QB2KQ6wTofvXbDNf8
         kyoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763114405; x=1763719205;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GlLIJfW5kYx8oRi5VGvCrY+a5MlnVb5xLPFUIR6E2IU=;
        b=JpUlcFB2z3rNdUgLv5CFDpojpTl4Ow7zsJy7lIYZRoFbMAjIkML4TElIFfI2cnTLKa
         Gud/B4Lfp2jr5raoCdt7vKB4fY8Lpkjc/TNd1fKJTG65OWIU7MN6WyzKlkO+XVRl+fl/
         makldwh8G5pekybP/VW0VWdN0BYne6xnOFgT7E3QjWUNivDHl9pX1jOT/ylEG0kMxRKS
         bt7uoUv+2ALJcX7AkcgoMjh9L1dC7CRo+I4vswgEGmPrWs7e6j/X++rNvSVj5dyrL4p8
         L84lOEP1NzFi8D9zmrRDTO/Noqh6YzlSXtV+lYZQNAiUXF6ZN6CDtICmv0MKJR0EYsP/
         5nhw==
X-Forwarded-Encrypted: i=1; AJvYcCXlJGhfLTiuY5zbd4Uf/IXZfAX/pPge1DBakaVoC4wIjNFNwF7j4Q9UJxlGKPwEheF9wUsmmTZ8FOtl@vger.kernel.org
X-Gm-Message-State: AOJu0YzxBefvUFN9Lwt3gxLGtOJPFlve+Hr0NFkEWTMfYh6/E1b41fvJ
	vFkuyf0kx52k5jzUGVZucoIs4/yE0ZocGQ07Q7ozKujsW8D7STQaH0f8
X-Gm-Gg: ASbGnctey7AoRa1p2mcyJ0lSL85mmxbcPIRsYsXG+wCqmtroPND38PfX7PY7Ok2qweZ
	arDHiLr5IgJ1lC45a4ZTM84gTPNqeUvGEGeCO2O9fIQy4LxiUeQ36CQ9A7WpNjPZUo3HyxXWpxF
	fmtpAnTX5Ss8qZUwhgnkAGg43gFECRRXLVRAyr76GtLeIWc6v7XrSt6FnuY6B76Rs2+F2OiG7S7
	8uwgTUB/TLRpQM5m8vQMx0GNK981YWTlENVUtnwLx+nmmtLuqJmewpQmftoCdHMgWz3OwJi4itm
	6sJ6lcQHE5WOKcOGoFGUncum/2Q7CIJ1J77pfCvbaYPe2iHYSczyC4OSp2smK0Gfd4yw5MFeKVX
	f4DH0wX3uG0Akc7F/RpAdxJiRpByxS9aDzulTWdAc3hkvPKZOERT5je61y6v5B2ftU4QwYoD6Qd
	E=
X-Google-Smtp-Source: AGHT+IGMJLl3DNtLsPwbv16seta19HS5bB73qrMfyQnjzmWsLVtl0VgB5NNKm4JDX5fYFK7WAzF6gQ==
X-Received: by 2002:a17:902:e810:b0:295:a1a5:baee with SMTP id d9443c01a7336-2986a6b7c36mr25436565ad.4.1763114405066;
        Fri, 14 Nov 2025 02:00:05 -0800 (PST)
Received: from fedora ([110.224.242.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2b0c4bsm49828545ad.62.2025.11.14.02.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 02:00:04 -0800 (PST)
Date: Fri, 14 Nov 2025 15:29:56 +0530
From: ShiHao <i.shihao.999@gmail.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James.Bottomley@hansenpartnership.com, MPT-FusionLinux.pdl@broadcom.com,
	i.shihao.999@gmail.com, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com
Subject: Re: [PATCH] scsi: mpt3sas: use sysfs_emit function in sysfs
Message-ID: <aRb9nLQVYwH4SUzE@fedora>
References: <20251103130501.40158-1-i.shihao.999@gmail.com>
 <yq1cy5sif94.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <yq1cy5sif94.fsf@ca-mkp.ca.oracle.com>

On Sat, Nov 08, 2025 at 12:53:52PM -0500, Martin K. Petersen wrote:
>
> From Documentation/filesystems/sysfs.rst:
>
>  - New implementations of show() methods should only use sysfs_emit() or
>    sysfs_emit_at() when formatting the value to be returned to user space.
>
> mpt3sas is not a "new implementation".
>

Thanks for letting me know about this.Regret not Thoroughly
investigating this further Thanks for you time .
