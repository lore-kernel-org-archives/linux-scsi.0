Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D9E35E1AF
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 17:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783443671; cv=pass; b=IPYxcgP19c6U1jsxWhv5HY7vaYKbFSLES3a/fI84rJZPiNO8drGWuuzDjFssosTUyqkSOLkIPtWlvkoivsh8JwzOQXnxBFiq15G7jq6eQSvXshRdlG/Yp55gJAVI8XjG0GzfOimqVRdCJejXcNekyZc5/gYXVdNW/qPixi54dXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783443671; c=relaxed/simple;
	bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=siFSAWh63BvAg9ge/D+MPDts4Dix/ObNadkvqoOcuUT6VYb8yiuK9r6+ncn3b84Pj9Y5KxHAPjrn8ECtu4v1+n5PEUfYc5Rv/UPNSSL2XaMwowPnlYjaq+B1EYfaEB6HOMTDXJMf5qs16P4LhjnWcRydigc9ljfH/T9kJlMDxz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YSaXsOhZ; arc=pass smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YSaXsOhZ"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8f23e851626so36078466d6.3
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jul 2026 10:01:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783443669; cv=none;
        d=google.com; s=arc-20260327;
        b=kzCL82u/oqiFKNwAhRzNV8+YJZGokgGaTeoyihA1VYJILqGuYoecX5i+969Z14YyXP
         Wph18K0zt/eBv30tRkMaNgcmcoFsKbxg+BjCZSCW77TLovFwS+xO0ph1blhgecBa1CvD
         HZqIWFobZJ8SC1dmAn9zfKGkomvGxU+A5bnzPO26FTPjUPHJVI9Yl7DlAtkCoHx9Ig6J
         ziYDnjRRjbm5IhwcSF77/HctGosxr/KFNBST+Bv50fS95g1plr8gJ3sZf0GAFwtlVxQb
         m+jd7tKTOQ4oaURXdtbkzXBgbzyHApTHOPROQdvD59sZImtUQCjV4BxhEoSrEld5TMMT
         Q24g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        fh=vbRm/IxzqGeyWQO3liQkoGJ1n5UeKQJ3IEbHg2S52B0=;
        b=aOF9rJ3b6ubQmqGytN84WfNJ0wMx/CEJunPjqu4UV3p7FnOX+KpXZPNCBlIGV216pA
         /kylFcL5wiAQy5Flji/EMTyDqLUQcQ+iHeYgCv9n3qXfDNOwm+8L1fehglW8Bomd4I2I
         gY88Gzb2qdSWNTQ4/evMnb7HPWDxxM22To+WTPG9ih+70Y1WyZyPFrk9RCnkj7s9mngS
         WL6aEJ5sl5CeQ8YuyAU7sK2qbZXLN37oztkS9bPAhTCxMS/KgceGJnHjyXwqhyklpqP6
         8mwcQMJQ41OHkp4tp5tFwwAYXw+5TWkBqyzx3nuqOAgSO6pwv9+AvaNd67T1pKzh4q0z
         85Gw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783443669; x=1784048469; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=YSaXsOhZywVt0NT+Hg8yvr5D+7Srj73nu1iZYsuj8Nm603vbrS8WfL2ymYb/dC/0Dg
         P7x6Um6SZq/Iovl4FQOJngrkpwAqP/h7ydhZoG2DtUBLDRoBBbKJB+gVQiEiqTLjUzVo
         8bmEAVn5Ab8QXX9x8xJsnbo5Iocsm6btkr3HDlWUUwkanmItluNs6JVY1+jejMTCtFne
         ietkEaHYCKWzh5D24zBtTY4iGYLi9Uem4EBWNBAvCh5sxPiFzQgnrdpSCcMLYy/avI1y
         8WVUX0OgQ7wVVsK+pK/T/TV1yz3S/ybdJl9zgBES9YAoNHbTVbZEoRUOkgGro3inrPxi
         poXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783443669; x=1784048469;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=ckNsonPO8ZXun1V0Vluth3f2bd0YFqPJYUXckiCNMotNSFbbcxAEOhLJiC0RIXU8oC
         uUXBgXUlRiaOMvRlTI+iFrpkEGLczmMKgUHCkRKmYXj4EmOm+0QQdsjCSIKjSaoRafSR
         RG32w4+iyclXHCps98ULNMaco2LFiJVYT8cgKVVr0kRuQ6NMxUCgXj3cdgkniQO0wPel
         /gL7IemB6GdtYASmCTgLXZUbyIDogXb7Zpg/3JN5xOOaf5+D154z8N8qgNW/uLG5U/SE
         M/Lmt2bKAqbblKzsdA4YDKk4fDH10AjqLnPY7NZswinOhvcyFseqiDLYu0Og506n9Rz3
         HJVg==
X-Forwarded-Encrypted: i=1; AHgh+Rqh7vC/4aYB+Xknx7ZrxwERqqhHTu2NZcBqqXPqpyC2sBb3r3GJy3oC1L2o5XGfZdAoeGxtPc3WmaPQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8FUIHUJ1r8oB7iFrIb1LlJBTcjVtO2HRkgd5alhz9XKcsR96x
	L21TO0CZdzMWbVELFF+rkx/xZ9ZQbpO55GrGkcjuwEmomVA+VPek1FUqMDRE8HGP+K25UBZVjHc
	KWKgaQxzyernOgQgy0vWIONQbeZ8wlRo=
X-Gm-Gg: AfdE7ckr43Q5P7NBz+rlS5n+WMNvqyKouquctMgFZG+qqI/JI5SKEdIP21w9OrhQl0i
	gmHZqyI3V14vO+gCkYeQS76yiY6rzWXeV6YA6ewUE1EUG3AV7NgIGBLsX9dYXFqr7L+nl/lB0xw
	fjzQlfkMZxuksqUY72+cwxFTPsvrs6QUPR6NrvZXbEB3Wj4o47dy/jKajAJSoxagcp/KqFt2X4L
	nz2IMZsdVfFLvgf0+9eSxE6AFI3B7o+NhVj0NoeS/53ufJiuE7h2u+q0X94dUoVD6kmI45u5HHP
	aDWaFEqYomh4BsPYE2U8KofHkNzpQQ==
X-Received: by 2002:a05:6214:1d0e:b0:8dd:3b3d:c2d3 with SMTP id
 6a1803df08f44-8fcb307eb2dmr65476346d6.20.1783443669285; Tue, 07 Jul 2026
 10:01:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260707065304.949135-1-nihaal@cse.iitm.ac.in>
In-Reply-To: <20260707065304.949135-1-nihaal@cse.iitm.ac.in>
From: Justin Tee <justintee8345@gmail.com>
Date: Tue, 7 Jul 2026 10:00:47 -0700
X-Gm-Features: AVVi8CcIVmO5hXbBnEObA62OmktUeVk1RdtKNWLtKUK3KJQxFN6t82f4jV3iwt8
Message-ID: <CABPRKS_rw=dHniXFa4B2rC5vNEp-F7Tq_FAZRx0XmsS8zjPEmQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Fix memory leak in lpfc_sli4_driver_resource_setup()
To: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Cc: justin.tee@broadcom.com, paul.ely@broadcom.com, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Justin Tee <justin.tee@broadcom.com>

Regards,
Justin
