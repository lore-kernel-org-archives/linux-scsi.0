Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99667146D7F
	for <linux-scsi@vger.kernel.org>; Thu, 16 May 2024 15:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715871892; cv=none; b=UIa9h/UnxNYBMSaMSmYSkXzUj3vZ7hvkGgadR/FVGDzzrpGUdcvoUjxx67qhnyZFkn3MffPnEgcEBV48LjRS+cPr2ENS8g7oX5SpASNDC4fOtES+wqcmfChU30T3aoFZ1yHR7hQkhggGMKlStx1mkEhlpC5gwpx4ho73pQtsA7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715871892; c=relaxed/simple;
	bh=1yLuwr5Ny+Gy2jE6b4j91jagshOW1WAMTqW/K2hryZM=;
	h=Date:Subject:In-Reply-To:CC:From:To:Message-ID:Mime-Version:
	 Content-Type; b=Ql/tEqFZFlejy3bjuRC+8d52uLtFofGwsjx7vXX0EJ4+NvVF5VqUkmUxnGZKKybgQ2krgRT3e3O6T//qVs5fCIZUMZXWZHabNJbmJameylBm1ykjM4bWGRaWk8cofKwrY4PIo8S9B6Md/Mbsq9MPsAdNZ58fV2tURxAqzpZoWzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com; spf=pass smtp.mailfrom=dabbelt.com; dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b=0bco7UJb; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b="0bco7UJb"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1f05b669b6cso50803195ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 16 May 2024 08:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1715871890; x=1716476690; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5tFCjyRy326EuMyapGXcH9cbJEkf5Ts4nwZLLLeQ4rw=;
        b=0bco7UJbLrFIwBc7z7WeQoJ/kS5VWhjM74hxgphOzjK0yo2sjuweQQ+xcP9X7zgRm8
         kNYkcTUMCjCIHXTLweRztBc+IgSuGcknCBdS4sQZoICI6jlV7cgcOLywvr+j/E+omV3O
         lyNJUGMV/PI1+ADPvplB41q96cbdR/0N35tBzYIno2Ih7r7ZU25oagea/Em7CHQwffGX
         TNhNfwG+U9IdE4OShOO+zPJ1hjEjtT7b3dtfOlaIaGS0r5GiMcu2l0YOvdptEzPwz/+r
         ojCgi7XmY3LiSPbWZDzBZoAhSD6sgMllRoxc88RnPWu3v52k73SQYbWn1usEp97oIdU2
         +17A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715871890; x=1716476690;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5tFCjyRy326EuMyapGXcH9cbJEkf5Ts4nwZLLLeQ4rw=;
        b=VGVd9voaVf6MoqJJvu7Nngvb04J5InNInVOVBg4yEHrxQe7OFMXjph7Y9jq0oqGczL
         Z7mHangxjPPh3NJKXPZ4o2URG971JnrCv/uPrAxZGQGmaqpEkn9mAz+FDT5iHkPAAyel
         HbZY8j8iiMeFnOr9mt25XPizdLCJRTJVXnFVg2hWwnhu7zdSjVvulR9rQ/+W4LtrqHll
         H2uBeIXFh5AVAO4tHg6VRyS0ohwoSVwOQxWRm753DHMEf3uOVo20C56Tw6Cx1UvdQQLE
         rInZ7mKFDdA7+PaET8yRPgChgSUEVwdfNHmkjb/hh+rQFKm58xEPUQMOxdXy9b4dTRJa
         UE9g==
X-Forwarded-Encrypted: i=1; AJvYcCU70s90Gz253RPLnvzWSqVZa0x0dP6h4/eA7901Bx940haKzocP0jUw/IUk2flej8BHxoADlAz4QL8A/Ks1oKciTUim8vxwOYT7tw==
X-Gm-Message-State: AOJu0YzcBLFHb6BnF7nUyj4gts8XxqIKqFIf44xR9fEK+YslN2JQhBsd
	/uNICvazE+amXmapWZkA+edLlPjMN0BvYaDnTGapjA3wSE1OpVVhOSRF5wAHZts=
X-Google-Smtp-Source: AGHT+IHyr+L3kQts1mekEifNWiW4+PjiSNLgehkncSk5asn5KHFcaUVhYB0qIAyAQvaljXMM2Ch1ig==
X-Received: by 2002:a17:902:6546:b0:1ea:cb6f:ee5b with SMTP id d9443c01a7336-1ef43e2796fmr195159345ad.38.1715871889708;
        Thu, 16 May 2024 08:04:49 -0700 (PDT)
Received: from localhost ([50.145.13.30])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0c2567ccsm139617235ad.301.2024.05.16.08.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 May 2024 08:04:49 -0700 (PDT)
Date: Thu, 16 May 2024 08:04:49 -0700 (PDT)
X-Google-Original-Date: Thu, 16 May 2024 08:04:47 PDT (-0700)
Subject:     Re: [PATCH] scsi: mpi3mr: Use proper format specifier in mpi3mr_sas_port_add()
In-Reply-To: <yq1y18bry3h.fsf@ca-mkp.ca.oracle.com>
CC: nathan@kernel.org, sathya.prakash@broadcom.com, kashyap.desai@broadcom.com,
  sumit.saxena@broadcom.com, sreekanth.reddy@broadcom.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
  thenzl@redhat.com, mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
  patches@lists.linux.dev
From: Palmer Dabbelt <palmer@dabbelt.com>
To: martin.petersen@oracle.com
Message-ID: <mhng-c0ff89cb-4699-4ff6-b0c1-a71fadd710f7@palmer-ri-x1c9a>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Wed, 15 May 2024 06:42:12 PDT (-0700), martin.petersen@oracle.com wrote:
>
> Nathan,
>
>> When building for a 32-bit platform such as ARM or i386, for which
>> size_t is unsigned int, there is a warning due to using an unsigned
>> long format specifier:
>
> Applied to 6.10/scsi-staging, thanks!

This fixes rv32 as well, so

Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>

(don't worry about up the review, it's mostly here so I can find it 
again if I forget)

Thanks!
