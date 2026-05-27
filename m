Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0213438B5
	for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 13:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779887942; cv=none; b=pi+wedzWKBmYCgyVkYNV1y3COQoDtmhxWIfTX2HKR5mL66MqQ+69v+o7MOGm6Y4jjRppodpr27r3iA9GIJxv7kpsAPZj0YxXEVznF8qgs627jqr1iRgyCtlwojzAP9IpHivJ4WbhOQqPjcuzV8Pzedf6AVXeNFX9qC3DtHUK0bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779887942; c=relaxed/simple;
	bh=c4k2FbaT4ZE5BrlqmEG2KGVxbA/hohu/6d2zR26S1jA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TY5HdtpbTQTMxdtShgTIVp3KUqQd+zuHo3Pjmlc3W/LSxYKJGl5K5/nysEy6IcNuGyRcu1rN2RkiFXioRx+cYU8I1NGI5oOM55Qq73cKTF3YxsqsCGicSAeFRMSEqUv8KDtaML8sgnio8Eh8EVnC/IWqW6fCnKwkwe+gCehm+5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-57602a2d80aso3773266e0c.2
        for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 06:19:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779887941; x=1780492741;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QCy1VyfY2ZbNrTfHelvIjzn2O+2cJZLSUf7eYXBf/sc=;
        b=RH0H4Y/ZgKhJA44fqnsWrblPx4nkWapH2gXWN9030wikrBa21vHbQchdu0XJpA4LuF
         xvnxNyzPAAC9RQcrwG38QFndJ0rSRDBF0Fy2mMrp8HZYS1Cty7oTEXC1z2hlnWeAFVZA
         z6yQpTc8eb2A3T5Pjog2/ZjKNxZC8XnwOmgUDU7s5eDkzLBbQ8NzbeGjx6B5ckMBnIAC
         LgdG03k3ZqB4oFdtXEI0dVsNcU/F61dvHK4Rg2hXd8meY4AhveVG1lv7i2EMVIYgx8RL
         vyiG9f1aVB8owcrJJlfu9wZQKZI7XXb7VrN47Y7WgdujA9vCJZcNG15HEwY1TGLaa8Bc
         a35g==
X-Forwarded-Encrypted: i=1; AFNElJ+Z8SpMdA1Az92ME22RhvKhNvBzALhbC4uBuF8+SV2StpjcYGb/d0G5cs8XRINeQxy1CzhLUcMwmFyJ@vger.kernel.org
X-Gm-Message-State: AOJu0YyH/ltIr6cRJWrnfqyITn3Yqk/ARF4F25MxDvhIx/un3NFbrbI8
	Sex46T+SXfiPdFa07wLhzid1ymAf0bILgFFjOLHtt5K8xOggJoN869ZyujUUFf4Ca/U=
X-Gm-Gg: Acq92OHDaVQF4VwQJcG5wBEXi0/L+yR7YqPQZ0KI9QMQOcJgxQ1DNg26hEqmhe79LoE
	ebCAdmp6oDGsDLsrR5aCNTpBSxAwDCrXLly65F1k0xyEwQRTyWs1BxOkFewCmPeFKAmnXhyAOoO
	tUHTRXqmQ2AKTlIJfhEpi9RKPm1t3B+a5RnwonkaqS+y82Q0PxIsv5HdG/a4Q82TuZsusKV05uN
	W8tsf2YXBtiQ5CuPPrJD7MM/4fnkhsnWgRy2isTcKqNrlzAoUAdwvSCj4yf847+TvcKUfGg+vS3
	Bh6mcWmMPscrNi8gWC6M9dnORPpr+J/mNbh2XNhdyHsZA/t5Q19FQd5zaJ9yF7HgXaLWoroK/jV
	ADmSDCRcaInzcGz+pPH7KYBd1bHhKHUnsqrVwii7/2mMy8nWi+JUBkQ4jRlPQUGDoaTAnO6uxIU
	UDqsh5aJm1sNkLmklRChDgUGnfRJjKUW5t9vRx22g5eMQH7cr53CpwFf4P06qPhWDgbpkCuhBFM
	VI=
X-Received: by 2002:a05:6122:168b:b0:575:29ef:7e13 with SMTP id 71dfb90a1353d-5865d70e96dmr10432957e0c.3.1779887940639;
        Wed, 27 May 2026 06:19:00 -0700 (PDT)
Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com. [209.85.221.182])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-586f791fa49sm20624457e0c.12.2026.05.27.06.18.59
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 06:19:00 -0700 (PDT)
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-57602a2d80aso3773246e0c.2
        for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 06:18:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ98dqNCvhnoTGUaROECtTb6TqTCHKP7AH3oK8HpnrduiJ1KF4bLR6RE6xloypirMz3R7dN6keMeVadW@vger.kernel.org
X-Received: by 2002:a05:6122:3402:b0:56a:fff5:b4d6 with SMTP id
 71dfb90a1353d-5865e2b5250mr12331762e0c.4.1779887939678; Wed, 27 May 2026
 06:18:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1779803053.git.u.kleine-koenig@baylibre.com> <b7f3b4bfa5daabf8a3043177341b8dbb4e4d980e.1779803053.git.u.kleine-koenig@baylibre.com>
In-Reply-To: <b7f3b4bfa5daabf8a3043177341b8dbb4e4d980e.1779803053.git.u.kleine-koenig@baylibre.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 27 May 2026 15:18:47 +0200
X-Gmail-Original-Message-ID: <CAMuHMdW=8CinkPvBzY1JXJcy_7BGzS=t=T739sDbbJsFoiiW2w@mail.gmail.com>
X-Gm-Features: AVHnY4LVf2HmV7NEUt4hHqvz3XHWWTYsnrOn4NRK1knY3FTiRsXYFw6-dPyILKg
Message-ID: <CAMuHMdW=8CinkPvBzY1JXJcy_7BGzS=t=T739sDbbJsFoiiW2w@mail.gmail.com>
Subject: Re: [PATCH v1 7/8] scsi: zorro7xx: Make use of struct zorro_device_id::driver_data_ptr
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org, 
	"Christian A. Ehrhardt" <christian.ehrhardt@codasip.com>, "Christian A. Ehrhardt" <lk@c--e.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 26 May 2026 at 16:18, Uwe Kleine-K=C3=B6nig (The Capable Hub)
<u.kleine-koenig@baylibre.com> wrote:
> Usage of .driver_data_ptr allows to drop several casts. A nice upside of
> that is that now the constness of the linked structures is kept and the
> compiler warns about zdd missing a const. So add this missing const, too.
>
> While touching the zorro_device_id array, drop an unneeded explicit zero
> in the list terminator.
>
> Signed-off-by: Uwe Kleine-K=C3=B6nig (The Capable Hub) <u.kleine-koenig@b=
aylibre.com>

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
