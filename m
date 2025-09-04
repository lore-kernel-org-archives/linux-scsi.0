Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641C8230BEC;
	Thu,  4 Sep 2025 16:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757003763; cv=none; b=qVid/yEZtmqb/a09I4kN02SkUNuXTOaH1yO3LbZNluICrWKUuBRGyPu+3h67RHPkgAlFe+oio+tZc0wNlCVaizc4mgb9qzQiE7aHGxM0L7/xtguP8MI+H582Moek+teJb7sbybuc1JnGoTj2xk6BURibPB3siSN+poiP9ic7a4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757003763; c=relaxed/simple;
	bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GP8qK/tfGCg5OGJTWspSGrRzJp7tWj0H2eVuJ5hjgw5+5IgPMq8FON+iJdstC2n0SpRUgAMq6XDJBr0rJThAsqWQ5PQMXtChrNRB5aa06YA900uSmfxcNNN5YDHbAZjlAfsk1qdeQtCkj1CW+HS2txfG4Y8XDnP5JJf3ejIp2NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UUNny2Xz; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UUNny2Xz"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-71d60504bf8so12657047b3.2;
        Thu, 04 Sep 2025 09:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757003761; x=1757608561; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=UUNny2XzIlghaU8t5F0yVh1oFaAPe+l0/QZhGspIUsyMldBb/Z52GJYQQkQV/JbY+z
         C3jT/iWVpykzoWQcQ9G3u4xjNjzg8eNZ0AoQyZ08G2PdbwTVPo0UFf1Zg49e1kEc3l2G
         5S07G8q1Mj+ZUsgYAsqMzY3aw3PZ4rEI7eaVN3ZYhfh5DNMhyyf7nuj3F7EwqEE4VllI
         Lda9mqBPBxPYZYLwphcA/XcrwoGvmWQ4zn15z3cwYE5vc+lYPR3ZvzZOYMupoKckxDnE
         I2uBnuUMUrLOIvJyIRn3DPFKssxV5xc1oziHQ1uK90ly5D2em0+GFm05JnHKIJ795xff
         28ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757003761; x=1757608561;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=C60eRlv0XRocycYh7tNh0P7ub2RVlgkO/tBR3wB3Vd5CiE0sige7qwA44OfDjnPLYu
         aePlLgCYvGqv/P9Dpwi66muW6fkNGHQMeLVNJO6O6UQmM/lAnMyQsMybwcH+DFrIA4c9
         nn3BuHg+jp2+Q5TScqadJE8u8cXWn3dsL9ch/kSScAhkYRXNt4PpFKt+peHSiQWUb5Es
         l4LVhDRDjR9FToBM3seG6WRYaXiRWfxU4di4qOK/q4tnWAbkTF62+Bls4n1LxtgDrde8
         eHeGrM+8aDKzi7R94RnsrlrIZo6H1gJ/GAN5PgWOkfDVAg5Oa/BNipXs+lyro4L6gjQu
         1vvw==
X-Forwarded-Encrypted: i=1; AJvYcCUkXdZ1CAt3j2HPkIwgtT6/tYHMXAWumOzWYx+BIlO//F0FOArzlTk9HafsXu1fXOFVySk2mvPp1dGS6CI=@vger.kernel.org, AJvYcCUzJCXgeo47TAFhW8MElCCXuz5dgEPqmh1ZU1nKvNgAmBifaYCCldG6LrnzG4aDkoLtoAdQGfBjd9avtQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YymeKa2xakcbPSSXX+ud4pVGJja8lKAmEDGF4OPAZXNInAhZpgd
	P/oZrwH5x7rdjlqoH1+py4cWmsf+2zJjOThgkIt+OVbyGdrlxDJ72nMnPv0vzG5nUMl/Y3O5eU/
	lKmxX1wjNjCs2qrUrvl78dQMQRgmpxH5vGtHF
X-Gm-Gg: ASbGnct7oDEv3DASMyWnWwwWOSIzyXbTKV5eKrt0JZwv3craEFn1fNiZjEh+Ze9pNdp
	LtIPrKTGrfI00G6ENE47ncG2CESUqSxjF2rNPie+VlAMAA0sdKn2fKZXYVAkLyK320fSNSmKbKA
	/sFu2f1aTWhkecfabRqyq3FX+RcA15bwfvb5s0rISQXqvZiecHXDJq53e6HUsfLGeBxZb0jRfFA
	UKa8Bdb
X-Google-Smtp-Source: AGHT+IEvMBkMGRTR8EguBjURUkXIzun48yw7+ga8Eb2RRBAzc5q2IPU3UOBfHoRTpRuVhibA8WDpyoBzZIpqRTAFMz4=
X-Received: by 2002:a05:690c:6bc6:b0:722:81ef:2979 with SMTP id
 00721157ae682-72281ef69d7mr205949597b3.22.1757003761032; Thu, 04 Sep 2025
 09:36:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250904132351.483297-1-rongqianfeng@vivo.com>
In-Reply-To: <20250904132351.483297-1-rongqianfeng@vivo.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Thu, 4 Sep 2025 09:35:31 -0700
X-Gm-Features: Ac12FXzUFBivrHIqO1NKmjHuS9NvvXHu7zHXiq_RxQ7K0jRxyRJeNuE5d-eWxS8
Message-ID: <CABPRKS9MXLV7JB00Xz65Lzh2gcX1ndURW4dmdeBzLiGd=XoeXQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Use int type to store negative error codes
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: James Smart <james.smart@broadcom.com>, Justin Tee <justin.tee@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Justin Tee <justin.tee@broadcom.com>

Regards,
Justin
