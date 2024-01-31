Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22F120DE2
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 18:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706725895; cv=none; b=cho5a4cmmLemJobCqzMG4aU+21rgR8VeHEZMFESmS2YivKWMCuLGUOqEWFCxdSbAVP2OOHQ7ExUr0IK8i4DVfZYFeQjVQjh8Ek1ZGkoQ+sIZjpQveLPYRyuRxF2cXA7bk8wM9rM+C+tjNin/JnYJ/AUqBRInV5V8FDt62BJXOzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706725895; c=relaxed/simple;
	bh=7bZRmYqjGaCVoQtot+OoRVTpNOqyY4i3uIZoE7UFRWE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J7KVaBH5lxJFD9QREfRaD6GKTMfjMLyySzbxWd5v1oXxKrvIZVo27/qqvp0yursWeRPINdG/ELSuUIcy+QI7uTTCeQb9JFPPAaSAZFQAh2WhoANXlIycwZL2aijG4ZiQ5GWiRTPQ4vdzq+0x1cnMPq+zKWNJddnxOFmF06QpImU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bSERFz9g; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bSERFz9g"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-6040b73a4bdso122107b3.1
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 10:31:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706725893; x=1707330693; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1ITQHa1HYbGif6ZpCpBtPZQ0s6Zr4XKLkONC6qR1ubI=;
        b=bSERFz9gbtj+gU2pseoXKMehaRMYCQDZadef70L5B9tkShE4q+UtdOvIBVZkjUfUs4
         I0MLf5jBLhaNypx576qQlZLN5hi2NwyOMfdNKySz60xv3H1X7z/tAKA66L5encbpmDjP
         Di9kmgtm4Qs8l0tDdXMxOM36naB3pzs0NVXImYhtNtnMaFZJz5r13lUTP3Avgmyoqpkk
         BgSKj8DHvZlbK4kZ5IVviZQTDA49vFrAq2/M0QgSWh4vI+gabTyKVU78Q6UO72UrL6tu
         IaFFe1pTfgESttvtg93xrWCcdz1GUSEtw29LZSyP5aUNcCJV8RK6wDmo9wKVpwZ++qt0
         Ghpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706725893; x=1707330693;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1ITQHa1HYbGif6ZpCpBtPZQ0s6Zr4XKLkONC6qR1ubI=;
        b=XBNJVn0DBUQHLPqkmRoWMEIiH8+oFxGC1N0Sk/Oo2F1keWP793EI4h1gh76DZ+aItM
         Fv49NgXkfbwxIq5jBcVET7PGHil/vsy+H6ogs203366i/2UlTqZH1SyOmRi6yE9bHc33
         03FI4HbKv+c9wyhgOjZJWCRIXFE9PF9UkisQnszJhAKUXGzBDn7g3iK67voKn/p233Uk
         AH5+FVmws58QRLyiHdZ2vZjLx+Ql6mIxHSF49xKlsfDj25pmJpVuzdVm+bf8rAcQyBqQ
         8RqJgUg466PLwawDZpfwQKnyADsj4rhJDzgiFn16L4iKakdpc1xxDR2JOvuP4HVtw4pD
         7xEw==
X-Gm-Message-State: AOJu0YxWEeR/4yk7VnO6aGeX/CqXhLWZppVKR9BHapMzQXQHD4LmsnxL
	ZpPlGwfKBbV8o94fwTtoFZfEc5KBzUdFoXV5KnL2OwtfSKqMKkJgXdWJ1Y99+DAo+YzV8ism+ul
	PlXSa+/zzhmcNVSkRIQ8di3otz1ku3Ip2amM=
X-Google-Smtp-Source: AGHT+IEEnCMkAZd7EsKklWGiI7qtTZNNlXARb4NmiMvmFDRhJLSykpXA57zQWG/n4pY+AvaD2y5NKFbySZb7kQ51y94=
X-Received: by 2002:a81:a511:0:b0:602:cb15:d75f with SMTP id
 u17-20020a81a511000000b00602cb15d75fmr1904497ywg.4.1706725892776; Wed, 31 Jan
 2024 10:31:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240131003549.147784-1-justintee8345@gmail.com>
 <20240131003549.147784-15-justintee8345@gmail.com> <a0674221-3587-4802-a3d2-c8d54f0c4eb2@oracle.com>
In-Reply-To: <a0674221-3587-4802-a3d2-c8d54f0c4eb2@oracle.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Wed, 31 Jan 2024 10:31:22 -0800
Message-ID: <CABPRKS8g1Mx4fkQzxaJ4P2KCu+dsdTyZOX8oUw4XgYuSxE+0rQ@mail.gmail.com>
Subject: Re: [PATCH 14/17] lpfc: Change lpfc_vport fc_flag member into a bitmask
To: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: linux-scsi@vger.kernel.org, jsmart2021@gmail.com, justin.tee@broadcom.com
Content-Type: text/plain; charset="UTF-8"

Hi Himanshu,

> > -     if (sentadisc == 0) {
> > -             spin_lock_irq(shost->host_lock);
> > -             vport->fc_flag &= ~FC_NLP_MORE;
> > -             spin_unlock_irq(shost->host_lock);
> > -     }
> > +     if (!sentadisc)
> > +             clear_bit(FC_NLP_MORE, &vport->fc_flag);

> this should be if (sentadisc == 0).

Sure, I will post a version 2 of this patch series with this change.

Thanks,
Justin
