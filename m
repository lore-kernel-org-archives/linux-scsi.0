Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200C9213E66;
	Tue, 29 Jul 2025 09:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753780662; cv=none; b=nXivYwl8cYnp9uHs5msFpXG6TWqtNXi0y6T6PY0DBEzFNhrB8j9bMQ4viei5OB9G/Tb8RZZzE3jmHAPYh00vqBNnR7KlmhIzdD77N6ydU0RlXpsj6T2PSCmjcOy5I6EWupupP25FkF6xRl6v8eCqpJnhpAeqJkgL7Ww1v+TSKU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753780662; c=relaxed/simple;
	bh=WeLGtTB9ar+BFGQpy4yU7poIY2hEMrxYQX6hMxIuhwg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qIzNnApQ0KLy6tQMQQDNY7vyZpLNjhVDOmen8C1OOf3ojjp+3ptySfWJWGTRxhBql5MujvHnzDuS3oeyNGyWWN/mpoQwK9uBQ9h1q3nh+F5sX1uHlMhKeOMzpSUbSDGOYdA/dVUhq24DDZLZdlQZWHh9k+mZf6nwY7EP+QPVWm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WM3R40ET; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WM3R40ET"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-3321296a8cfso8761441fa.0;
        Tue, 29 Jul 2025 02:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753780659; x=1754385459; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7MNtzty7rFJgUySAkQlJV2O9frQXPFb7bbFYFWr20zY=;
        b=WM3R40ETp41Ez6M7Iy4pjJPeeiagPA1iDLQ8aov1L6wqRPX9LO1A3/NmrMqoZmarYO
         zXNF78qyguhLFHN6eyjGjasSyj4VGNhuHqp2wnaHjCtcwKhuir73FqsHTv6Rs5VNd6Oz
         OMxO2Rf00qq36aI71y93qSSPFX39egpUexscUbnPAsn7LD7Dpp/riCJ58NQkShZvdblK
         S9+wbEQZIyP/XShLsbyok5iDbcMbaghhgkr88fiCXYHNT4RGczRYsKy9VTV1troCIlhB
         wx/9KUVJDs4+I3hCu4dwDb9nZ/DZinyXcKUJGlLVFTzQcNQBEu7CnbQBl1rI1aOur7uw
         g0SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753780659; x=1754385459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7MNtzty7rFJgUySAkQlJV2O9frQXPFb7bbFYFWr20zY=;
        b=Q0k3M9S1FeRI7Zofd8fa5WtcYjELrmUN2+nNyDLWL8pky9tVO+9XRofb9JjoSa5lIh
         xb8J34hZ8quoiDqroonJPqt6vRlUsEJ7WiMXEpILEuveG+6H+dewjmXzy7mq7cP3+mgT
         Ba4PWktMBkDd1kANmU8yLmqoi1XuECiUNs/A439V9VyIwwgxxwgLS9DL1Q3UE95zSxX9
         akYrYt2kEaYDjR8hZGx2e/8K3bS8i89aLxwHVMKN/wAxoxshxUtR6aEEZ84j69bzOCRQ
         o2EVQI4IKcxcjOvZKC2s9HDFkJiH2DhHjgZpMa98DyBR/MhYtWxxDWXG2zVmY2CcuWJD
         a47Q==
X-Forwarded-Encrypted: i=1; AJvYcCUJpmuwFO8u5GDEuf2Rf3w2qc/ewSCkqdcRO8opYKvV/hkBN/dl4AE+miBeSvlz+nqb2RxzQPDD94bpTLSF@vger.kernel.org, AJvYcCVsI4EePX2l0ODlVYVb/StG4BHCPbFpOk0RGOWWbWIxCJ+q5zZzIXG3+C2Hh/a5pvzTK/WODxZkRvQIQ2M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3YGb+PFKPVzFluJJSvBuLTWydg8GD1No1Qo8UWqrADutfeVKg
	9izr2v7NI1luibsN4STFq19J+3edkbc7ZS6YQjNkNui/ztDjKquKW63fB+cibXM1UwTREfLHJmw
	4KdBmrNGx4PiWnQApWVziEDkBuHSeBx1uAA==
X-Gm-Gg: ASbGncukjNuKlIL1wm+N1xWnKq+Xdjpwc+K1pM+qjH8BE3xArLDpSxLp//1ByJUJAFT
	rzLbHU0tjfEdMzD72yfTRCPocqdP3RV+O3ZeHO1k7caR5mDMsoemKhgwSlfGfOVL76taV9Mb25P
	ewzp1oToeuIwv+Lg1qTQlWNr3yopgtlfk70/hvAeNw9LPflXgUXAvSLdm9q+1K/2Sn0XKT5Mgaz
	sDw37venBxw8b9mQmAJV7pTs9WPH4v9mU2AFo2BSg==
X-Google-Smtp-Source: AGHT+IGvbJZAYxRsjQOkwEVXEYQywo57A1btn+K9lLr1jxhzGNtgg07v1w1L3IEbQ5Apyb52E4PdbuNWX7sIR3uM1sE=
X-Received: by 2002:a05:651c:1108:10b0:32b:4932:d5ad with SMTP id
 38308e7fff4ca-33215441211mr4929531fa.10.1753780658895; Tue, 29 Jul 2025
 02:17:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250706092522.9298-1-pranav.tyagi03@gmail.com>
 <yq1bjp9rqh5.fsf@ca-mkp.ca.oracle.com> <CAH4c4jKgPv-Mb1=WvOW+jvGMABXcEgaDMxV0Wit32LPgJitekQ@mail.gmail.com>
 <yq1ms8nn2g8.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1ms8nn2g8.fsf@ca-mkp.ca.oracle.com>
From: Pranav Tyagi <pranav.tyagi03@gmail.com>
Date: Tue, 29 Jul 2025 14:47:27 +0530
X-Gm-Features: Ac12FXyXbTfsF4-xJHUYe8uTZLOfsxIie85dgr712UYsyAkEnOXJkJFEnqYZ7zs
Message-ID: <CAH4c4jJ+BjGyhapXbHqM5HBmSm1ZNzgsYWS-mNQjbc0XpMns4w@mail.gmail.com>
Subject: Re: [PATCH] target/core: replace strncpy with strscpy
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, 
	linux-kernel-mentees@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2025 at 8:39=E2=80=AFAM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Hi Pranav!
>
> > As far as I looked, I could only find the following 4 instances of
> > strncpy() for the file target_core_transport.c:
> >
> > target_core_transport.c:1115:           strncpy(p_buf, buf, p_buf_len);
> > target_core_transport.c:1165:           strncpy(p_buf, buf, p_buf_len);
> > target_core_transport.c:1225:           strncpy(p_buf, buf, p_buf_len);
> > target_core_transport.c:1279:           strncpy(p_buf, buf, p_buf_len);
> >
> > And I have changed all of them in my patch. Kindly point me out to
> > other instances, if I am missing any.
>
> Sorry, I guess I didn't read far enough. I was focused on the VPD
> identifier dump function and whether it could overrun the static buffer.
>
> > Also, I intended this to be a cleanup patch for the deprecated
> > strncpy() function and wanted to replace it with strscpy() which is
> > encouraged. No functional changes were intended.
>
> In our experience cleanup patches come with a very high risk of
> introducing regressions. Regressions in the I/O stack could potentially
> lead to issues such as systems failing to boot or people losing their
> data. So we generally only merge patches if it can be demonstrated that
> they fix an actual problem.
>
> --
> Martin K. Petersen

Hi Martin,

I did not know about the risks involved with cleanup patches for the
I/O stack. I understand that this could lead to regressions and it is best
to drop this patch. Thank you for reviewing it.

Regards
Pranav Tyagi
