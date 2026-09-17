Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1170E4AC149
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 10:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789642212; cv=none; b=H2PGvX/bGvFbanfg/APtQWPjtv9jwJaf5BmHpBdQNngh1WzvKSlel7y+ulXM8IxmxUxC4NFOCE6rnOXka5uguH8+KlFvHtD3yPacZ2QQ3HFuoooIgTKr4Sa9qyA9yEnLeqNmTwyELU1Gt29FQyl3fbdZTTEQ/584MbUTAwr/4Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789642212; c=relaxed/simple;
	bh=UHOcNkPGfB8EAR0NhglB6gRUnw1qA1vWRCJ3LBgC4PI=;
	h=MIME-Version:In-Reply-To:References:Message-ID:Date:Subject:From:
	 To:Cc:Content-Type; b=pC2aMJtIUldTWSs8+VEVoCUghtSdodh4bgCONIxkuyiliytKM3FGr11hpYNN7G0PqHOqh2ksq+zjyWJBtn+1H23YNJP92owL1HLtt7R+ubJoWMcApCwJ7iwr+k6Q6x50+Upd2qG3anpOC/MuejS4dNb/sgsaMne6VIpl/G1kkq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GCn+rk9n; arc=none smtp.client-ip=209.85.210.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GCn+rk9n"
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8716b158692so520899b3a.3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 03:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789642205; x=1790247005; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:date:message-id:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=UHOcNkPGfB8EAR0NhglB6gRUnw1qA1vWRCJ3LBgC4PI=;
        b=GCn+rk9nypvxX0kkdJz9PC5hWG0wsBDInAZb/WQNnI/qaVIarpQNKEKx4+KcTVchvu
         xYDjaOafS6ATGnAx1ToTR7I0Cnje2G5gLIkiS8Bgh0SgPP5ojBc6W18+7i9NTwFveycU
         V/uTez7QD2zvDTQVysz4J5SVyVDLecxknYTx+YA2dQPqVjHhUnrYkpQWlz8ATfKXhzvk
         E34Pp7bu0YnBTmlXHrgI/fTVVVsWv9vfsbQVvxdYeRz2tYuSov3H99wZgdUe+1CfvQSR
         cmHczhqYufx6E1AZdLB9R7gLCSMegmfY6tC8k6GVkewYX2RlShJ3aW9jsXb1CH7cgG8h
         unsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789642205; x=1790247005;
        h=content-type:cc:to:from:subject:date:message-id:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UHOcNkPGfB8EAR0NhglB6gRUnw1qA1vWRCJ3LBgC4PI=;
        b=a6NSY0WLnmiGVMLZp2ULSASMNGGGIwqxTvpybvYQICAISmQcwB8n5g1uuW2jzN3jKs
         ICh3DfbxOTuEO2CKomoSYaVUI6FnzrE+6kPEnHWaSCUZ5bFiYYyUE7AGyxE6wjXYxcNW
         E+9/1Uszw9FIXBXWsQ4TVXsUcXLJnCIS+04bJFySCu2ViQXOd9fpUryLs3zIFbPQG8LK
         E2bFnlNOwsLzbLrkyibBCzZelwDRlZMYrJzwkT1Ve0Q2bX2scKqgaOYsW2jlM/FLukxe
         06gaH8Y1725WZEiSxJyta0gQMJkdo9y2jHoqrVboZPJvpeic13HeKPiQK2Jd+JCbOS+j
         iiDg==
X-Forwarded-Encrypted: i=1; AKwUvBzCwZL7I8gCK1SkLa2AZGO7vMDkCR+59tdFpIWXytf+ao0i18uF1CmKP5C1ojQLpWVugiID7zU+7jbB@vger.kernel.org
X-Gm-Message-State: AFuF++lEcxWUBjnrgj5xN75ihrrS8Y7lZa3/CAgYRlPeUY5LR3fZe88H
	GYp7mKSDzfJEybtzznbOlzS+vZVhPJ4Em5CDdapEEj8enBG8IzGPbWfQdUYbdkK4U+ZivWTKdQW
	ERHhh4tahTb9a6DbfvfdpTg==
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: from pfwy15.prod.google.com ([2002:a05:6a00:1c8f:b0:84a:2e0d:e14f])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:a112:b0:84c:5b65:ef86 with SMTP id d2e1a72fcca58-87238f87793mr11300575b3a.17.1789642204572;
 Thu, 17 Sep 2026 03:50:04 -0700 (PDT)
In-Reply-To: <B6ED6CADE807138B+422dda6a-301a-4bd1-befd-b932ea9f46e0@radxa.com>
References: <20260910-kioxia-ufs4-fix-v1-1-ac796423057a@radxa.com>
 <CAE14pddvwycWnGNd_VNTzphsDTk+XbYwf6BDFkBnQFaw9hm7+w@mail.gmail.com> <B6ED6CADE807138B+422dda6a-301a-4bd1-befd-b932ea9f46e0@radxa.com>
Message-ID: <18d6161a62d5c156.3137322e31362e3131332e313435.3fb066.0000sendgmr@google.com>
Date: Thu, 17 Sep 2026 10:50:04 +0000
Subject: Re: [PATCH] scsi: ufs: core: Disable timestamp for Kioxia THGJFJT2T85BAT0A
From: Stanley Jhu <stanleyjhu@google.com>
To: Xilin Wu <sophon@radxa.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>, 
	Bart Van Assche <bvanassche@acm.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

On 9/15/26 10:58 PM, Xilin Wu wrote:
> Thanks for the series. It does make the error disappear.

Thank you very much for taking the time to verify the runtime detection
series on actual Kioxia hardware!

With your confirmation that generic QUERY_RESULT_INVALID_IDN (0xFD)
handling resolves the error without a quirk entry, may I include your
tag:

Tested-by: Xilin Wu <sophon@radxa.com>

when posting v2 of the generic series?

I will leave it to you and Martin whether to still take this Kioxia
quirk (for instance, if a one-line quirk is preferred for stable
backports) or go directly with the generic runtime detection.

Thanks again,
Stanley
