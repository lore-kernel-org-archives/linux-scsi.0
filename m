Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DD3320A1D
	for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2025 15:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761232171; cv=none; b=i6Q+P08Y65p2ODndjozRxk7xDfIyxe77iObK+AXVdVqaZNqbCAFkD5dfIye7yXhpsOZI4ybBZ//W0nnobsKICU0exCs1QP4bliXLNSkCnVhVvxcpGKPZDmBzg4OheOu7ekb2xqa4u/AsHCntQCUajLYK28BaHWQFmUdHGKDpgk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761232171; c=relaxed/simple;
	bh=5X3IgpM/ixFUUNAM9uIBuAadN03MLsIicS3hc4c7CY8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XgLO3RI/IhYuS3wcQiIBuMZ2ySVeubvqmSVUkpIdHdFqyK873CTuYEl7dH927FSlJ6CNxQ4+PktbTE8RBjbW8Vb1d+PsPfL0LvHeGdMDBgXVZ/6eto4cjs1GYN0wV0wkB+cfLyOhhcwemmQqRh33jh2vtQhQjBimLiFe2xY5dK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bMTADMlE; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bMTADMlE"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b6d3effe106so225730966b.2
        for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2025 08:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761232168; x=1761836968; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5X3IgpM/ixFUUNAM9uIBuAadN03MLsIicS3hc4c7CY8=;
        b=bMTADMlE7c3xHIZ6EV8URigXqs67Tu2FForU4ScFR/sou/nW7cuUpwcJJMju3qCqDy
         6zs5pj90bfGw5HziTjMB9MiVcm1urkdTe9UjENG6Ab6tbJXecAVXCB8T+XelN8d8n+JP
         tvReAAhLqIIJRltbdQ4Emsd3K/Jo1C7VGw7W9FzUar3ecHIxlzt/02hLyGlGzt9JFpKx
         wYrKKE4Ihq6/rxpNHQXp2Ot6baOlYA3qj+pnp1uyHNxd3RoD3ywUiXmZI/LlfqGcxnD2
         SRc+BGR/8cnbn5c7Bu6ZgByHDRh7BmhTZfhGJUD/RfhZR7KZ3nOvoXnL2m2PlPx+x/aw
         J7bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761232168; x=1761836968;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5X3IgpM/ixFUUNAM9uIBuAadN03MLsIicS3hc4c7CY8=;
        b=v/vHCd9iWFegl96Bhsnx9ssAwm1gvDIFvHKqELpxIDc4vKXz887Fawrqgpl+oLguMI
         dPjizG3LojYMYN4jfc9BT3RY8pjcCXMJnHBrqsyjMof2dMlzHmOgXusFK7x0xMfGxVRY
         YEe34yQW5IwQV9UVxZ39jkY4Y1rRbmXHpFzMT39Ws9U52/zLJD+Dh4SSUhtBRJuj5YMf
         2yqlpUWazmJOY63c0optOJPEC/rpOfgTUZ7Lm/q62Za3XWC+rpTJPOok0o5XZqqCI/cg
         DytuQxqLsfBx02/EBJzTcou6CHFJH1PB7nyCQc45WjNQ7oenlJdXVY8+ftAD4UcM2VdT
         GA9Q==
X-Forwarded-Encrypted: i=1; AJvYcCW2o2uMBKBJeN0DJe/FfUaQrIHezXZi/VTdJ9m+sL8/I5M//7gLLj7cOvReL9ueWu5KOAESLMNqJ4VF@vger.kernel.org
X-Gm-Message-State: AOJu0Yxh7ymxEYHA7yRnWDlUjz6gjSs+WaHg1FYExA/VN+O/cOT5g82B
	RqrDkXnt6xVlUNi9uDioQkGbAsUuqV4zMqH34uQViGmCo3eNxLR2v+cr
X-Gm-Gg: ASbGncsK/x1cMn3bE9iObRdKLgUc1c8CczyEvkezAIqTvXEE++XrM6pF8XK4Rsq+s6x
	lKrqk+PIPBt3ZWtGKCeIpG4H95DfhzTbPUgqBrD0Ww4hVb/Dg5poBFo82G17C1Ml0FelnNC/IZM
	Z04F5gK8wAK46GO4Y5pI8acbHODB4usjx6PCkKSonGzhXX6h6I7R5FVMKiR2Kp/t5av3wa5OXRY
	P7mAshZby2uS9XceHLaupyMFtu0j65B4rRkmeVdI+QtTW/19XYFt3YAraiGTD4si4y8/D2Not7g
	o5MOgz34lflKM1Ddj+Ycs1WAz3YKXdkk8Kv2NuQAhF+TniA4AyJYCQgg4ExTWLLFTUfDfTJQe7s
	pBIUf++gUn6SE5SubWpsliDfB9bm5kX9mYKfUvPUw4EK2EgNq3rFwnmfdbxvX8+U4bVy4CBj/mW
	y8bBDtXYWWf5+ZQg==
X-Google-Smtp-Source: AGHT+IGjQzu4HQMYvVKaEXQllFhwmuknoqmx0ur/s+VfbFfwCPYQWL9phbO+RD9JNTxazfFwVowNIA==
X-Received: by 2002:a17:907:984:b0:b46:8bad:6972 with SMTP id a640c23a62f3a-b6474b3725fmr3075602666b.38.1761232167735;
        Thu, 23 Oct 2025 08:09:27 -0700 (PDT)
Received: from [10.176.235.211] ([137.201.254.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d511d119asm240701666b.6.2025.10.23.08.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 08:09:27 -0700 (PDT)
Message-ID: <9f3d1d277b0d102b5d912b533be21ed78103e142.camel@gmail.com>
Subject: Re: [PATCH v5 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver
 for UFS devices
From: Bean Huo <huobean@gmail.com>
To: Jens Wiklander <jens.wiklander@linaro.org>
Cc: avri.altman@wdc.com, avri.altman@sandisk.com, bvanassche@acm.org, 
	alim.akhtar@samsung.com, jejb@linux.ibm.com, martin.petersen@oracle.com, 
	can.guo@oss.qualcomm.com, ulf.hansson@linaro.org, beanhuo@micron.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 23 Oct 2025 17:09:25 +0200
In-Reply-To: <CAHUa44FfQAPWGgVbfrCnZfF9HkGwW=fgUhV-y9RKrUQf1V6yNg@mail.gmail.com>
References: <20251021124254.1120214-1-beanhuo@iokpp.de>
	 <20251021124254.1120214-4-beanhuo@iokpp.de>
	 <CAHUa44FfQAPWGgVbfrCnZfF9HkGwW=fgUhV-y9RKrUQf1V6yNg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2025-10-23 at 15:53 +0200, Jens Wiklander wrote:
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 device_id =3D kasprintf(GFP_KERNE=
L, "%04X-%04X-%s-%s-%04X-%04X",
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 dev_info->wmanufacturerid, dev_info-
> > >wspecversion,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 dev_info->model, serial_hex, device_version,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 manufacture_date);
>=20
>=20
> The device ID is part of the ABI with the secure world or the firmware
> we're serving. It might be worth adding a comment so the format isn't
> changed without understanding the consequences.
>=20
> Cheers,
> Jens


Jens,=20

I can add, do you have suggestion for this reminder message, for example:

/*
 * WARNING: This device ID format is part of the stable ABI between
 * the kernel and secure world (OP-TEE). Any changes to this format
 * must be coordinated with firmware updates to avoid breaking
 * communication with the secure world.
 */

or=20

/* Device ID format is ABI with secure world - do not change without firmwa=
re
coordination */



or ?



Kind regards,
Bean

