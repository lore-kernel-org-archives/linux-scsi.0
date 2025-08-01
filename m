Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13A91DE4DC
	for <linux-scsi@vger.kernel.org>; Fri,  1 Aug 2025 20:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754081522; cv=none; b=SEy3JRm71Set1FxiQxHaIcjdEghElRCWCwj6Xi3RVEZ0QxT9uYRNQERlO4OBxgTuv2CEFUEAsap5yKD4gxnnxI9/XtdOQPsm58ikutvONpOjudiFDqIGgG6NRnFkTyx2dCfgWqG/NEOQCQNNSq/Dotyv2d2DUtRXGrXVdw6q0ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754081522; c=relaxed/simple;
	bh=QzcKsCFFg0YnzAtuUmkp4gPFe6bE/MQIIwcEYWagV/M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=Obu/MeAlGFl7wW13fIWz3T6I6PXrt9gw9NhxztdBn3v9QKYFdA39j9GASEwRSPj4eplOANa9jBbhI4ttsXz4GK91Qy/o4KhkxFIjJTHQWDPFku8uQ60JB6k2Bsh1iiyMLqjy0eph5TG8G6RYo+1gCr/xp7/it43F86OiEeZk/jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J9gu6xTH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J9gu6xTH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754081519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xhMZpLP4ZvaS5OyLVnWmqht7S/mLRSkYySYaFTrT3pc=;
	b=J9gu6xTHh+aEGdUiPk9nuSntQaVd1pGmOwiUPxmx7i8rWoIMj9R5/A0sORLvmDpzBy4rhE
	aybmiOMQNmckTbaldTyEaccTjbeNChr52+YOJsvev6TZ78SEb05UTZlx5sFTPPzgUtzQmW
	jSKipVAr3ZJjykTNxjb28WSc5ILD+HI=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-435-VdCiDWISPkC2peGzSfin3Q-1; Fri, 01 Aug 2025 16:51:58 -0400
X-MC-Unique: VdCiDWISPkC2peGzSfin3Q-1
X-Mimecast-MFC-AGG-ID: VdCiDWISPkC2peGzSfin3Q_1754081518
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-71a29921b1dso34677317b3.2
        for <linux-scsi@vger.kernel.org>; Fri, 01 Aug 2025 13:51:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754081517; x=1754686317;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xhMZpLP4ZvaS5OyLVnWmqht7S/mLRSkYySYaFTrT3pc=;
        b=khTlWjo5JlO9abAb47GlJtk57jWOBgKAWXlLOTzEdRvA9YIKzBc73NC+ZkIIAwYEPs
         GrosVtx1e0VZ2SJQIsocoTZL4ofgFmYSbOtHQmMPEBgQUCQDBWGA3jI7KD4mZDbo4eKZ
         aBXuYG6gyLXXAQY2PwIInuJdVCeI4mVrtrHi2jGAq8aScg3iQOV6DN4oUyPQBnnK77+e
         /IVPknYkR9KiK4aaN7UaMJGzHLAzFW6feisk6iKT0bCfk3Kox+4WyLDBXE6kRX4f4g6r
         JHW4RArqj4T6AvBWj1MT9GXJDpk+6ZN2QQ1R5U47GOd15oaPg+cHRn9TkPART+VC5Ax+
         LoIQ==
X-Gm-Message-State: AOJu0YxbMgBVjXg7moKvTgfAasbciU1x997soQGEjvCFHePUxasVJfaK
	Et6pvzgDVr81crFtkKfdGxy2gNuvWwNPAQYNVbak3+2LZOhCGaL7CFJKXFgbnGuBxSL7PK7BcWv
	MmBMKiaJCxTqs7r8xBX8vo1sKrlPjA80FxABp9WUBlwlyZxJq9iUhkbt84KRmj3R9vAWrgbIilD
	lEnoJq9HCZRRQRdokxwP+3lNii4gxOOQUyKcWVN9I2Y8Pt8Q==
X-Gm-Gg: ASbGnctPgQb3Bhdm6xs12ZgDO1wNWwoIzD27UrHBGco/BAsgoRNjseTsuYOMEyIyDa7
	+GyXDSuVPg1WoZsCa1msmvx5WA3uYmC18O90SlMUoGKpXC0JaVzcuxus+oj0OgS2RaM//Cr7vy8
	7pDn8V9Y3zfyprF4z1C3m9uA==
X-Received: by 2002:a05:690c:6d82:b0:71a:4517:75a6 with SMTP id 00721157ae682-71b7f593a1emr16564317b3.24.1754081517468;
        Fri, 01 Aug 2025 13:51:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHmsgk8i9cPBbt9hyoR1ZPuaKX4u6+YxFMMv5RK+ADRLRlS5FbJcJM774XfEItKTM6BTaJXo2heSgCCw6Tw1VI=
X-Received: by 2002:a05:690c:6d82:b0:71a:4517:75a6 with SMTP id
 00721157ae682-71b7f593a1emr16564197b3.24.1754081517084; Fri, 01 Aug 2025
 13:51:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250716184833.67055-1-emilne@redhat.com>
In-Reply-To: <20250716184833.67055-1-emilne@redhat.com>
From: Ewan Milne <emilne@redhat.com>
Date: Fri, 1 Aug 2025 16:51:46 -0400
X-Gm-Features: Ac12FXxkagAzxLZOXiWkTBueoB5TK8hcjYxIVhs-jefHV37NVdl0dpFG4jJX9gg
Message-ID: <CAGtn9r=7+y=QyAS=uVwMp3uVJ_y0Pheepi30eMsH66TRbpVVoA@mail.gmail.com>
Subject: Re: [PATCH 0/5] Retry READ CAPACITY(10)/(16) with good status but no data
To: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Gentle ping for reviews.

Thanks.

-Ewan

On Wed, Jul 16, 2025 at 2:48=E2=80=AFPM Ewan D. Milne <emilne@redhat.com> w=
rote:
>
> We encountered a SCSI device that responded to the initial READ CAPACITY =
command
> with a good status, but no data was transferred.  This caused a sudden ch=
ange of
> the device capacity to zero when the device was rescanned, for no obvious=
 reason.
>
> This patch series changes read_capacity_10() and read_capacity_16() in sd=
.c
> to retry the command up to 3 times in an attempt to get valid capacity in=
formation.
> A message is logged if this is ultimately unsuccessful.
>
> There are some predecessor patches, one from a patch in a series by Mike =
Christie
> which changes read_capacity_16() to use the scsi_failures mechanism (whic=
h did
> not eventually get merged), this makes the changes here much more similar=
 for
> both the read_capacity_10 and read_capacity_16() case.  Another patch cor=
rects
> a potential use of an uninitialized variable, and a third one removes a c=
heck
> for -EOVERFLOW that hasn't been needed since commit 72deb455b5ec
> ("block: remove CONFIG_LBDAF").
>
> The final patch to scsi_debug is allow insertion of the fault to test thi=
s change.
>
> Ewan D. Milne (4):
>   scsi: sd: Avoid passing potentially uninitialized "sense_valid" to
>     read_capacity_error()
>   scsi: sd: Remove checks for -EOVERFLOW in sd_read_capacity()
>   scsi: sd: Check for and retry in case of READ_CAPCITY(10)/(16)
>     returning no data
>   scsi: scsi_debug: Add option to suppress returned data but return good
>     status
>
> Mike Christie (1):
>   scsi: sd: Have scsi-ml retry read_capacity_16 errors
>
>  drivers/scsi/scsi_debug.c |  38 ++++++---
>  drivers/scsi/sd.c         | 173 +++++++++++++++++++++++++++-----------
>  2 files changed, 151 insertions(+), 60 deletions(-)
>
> --
> 2.47.1
>
>

