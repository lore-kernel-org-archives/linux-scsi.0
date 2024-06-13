Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA3D12E61;
	Thu, 13 Jun 2024 19:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718308065; cv=none; b=bx608pg9UCbIV5syXMeFlKtL3Ck4+IXTZ04cRDrVwppULoOI20hcOZYJ3D/qNAwyhpIIyt+XLBGMArW9+dHXzBOFF+DyzPWMAlrVdv2ljDeiCNXaD8E5WtXjU/IdvWTz5Vb+v6l84d1qNS5KQaY8IDbLpHtd6w5FIHtJ8I1zTuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718308065; c=relaxed/simple;
	bh=6VXRhV4mSrJEV2iPjuET48drxr0gVF021T0oAxZkKMM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cNPqekSSapZTGmB8PVvQm3lYNho3p0Pxs/hnhRARdPEAsGZnOMKX69QfafLEY2E2cAdSrk09yHw11FVQJNQaaOeIJCrpLcn1prjclm7DjukZHqpyDK+NcStODvRRFAfrbLd5DTy9A9g9tAGZ47df9wA+IvaUtcZgz2wAREgL/c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FcazJ1xx; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FcazJ1xx"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a6f253a06caso186238366b.1;
        Thu, 13 Jun 2024 12:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718308062; x=1718912862; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6VXRhV4mSrJEV2iPjuET48drxr0gVF021T0oAxZkKMM=;
        b=FcazJ1xxDMVgT4w6TjkIhgdc2DGDgYbD9r2sZjt+E1kH24TMA2Qvb/u//SoFl/8llN
         AAiZpJC6AQ0sUvlgleNzZ/liowg2r9z06VP2C2YJwGbhq9N0970NkEbCqhBQZFg4ps35
         osXxEb7gj2X6eF4Yy5LvsEyOfjGqrqHLmzcylkv48+BbCRduslcnSIAgqS5pjfYCIsF8
         +qYNPu8QH8MKSOVc2I3uwFB5YqUlKChNmUyTmzJHeeZMWZlstBgz42gCIPlngRLNpL5B
         Q+NWhVbN/H9IEIMq2tAnbGEGN81sDSf7L1pyZ9Me5fHDn7aacz52rfNTzKu4TiDzNfhC
         iFBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718308062; x=1718912862;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6VXRhV4mSrJEV2iPjuET48drxr0gVF021T0oAxZkKMM=;
        b=Lcr9FcrCqZwSLmnyfHCGs5bRXrljyY0lUnAJSqRNxEKWZC/ecKbEc03/Qyx6K5SOng
         lwE60dr5m0VIyI7UfEETtq5T4Vw61dTg7XnKRHRlfnLjeryO1kgiB9UfYdJWBEoLLvdn
         pGJe4hDlVFIEU8lfhZ0q0VzArFq64gd9eSnzwqOPMqERHlwq1jD3RZs1sbIBwVQFUpKI
         U5aF9W1KFGTQHDwwHWOxhXogoX7bBBDPvDb8VryIwtAQ6WwBH62doeZ5FOpb1/2Q3VjE
         a1FT3/usoo+WYBOICl42v0Bur4lC6RHlSeT/cSCx8gwq1jJCwbcrufZdYc5SQzQydLxN
         BeBg==
X-Forwarded-Encrypted: i=1; AJvYcCXSnfEHLcxp7sySnySZ/vU+XfjQJ705aHwQj6NClXN3bq30eve8QwHLlwzaMOdDo868ukMc2KdddMNhxHaxojvFEqpgcjLZ3xhVaDpNd7DpcJDvL85NJHLzgrmNSI9QVv0Pi5k5eQFOoqONDC0iyvE6hz/1VJ2BoTyzpC1cJw==
X-Gm-Message-State: AOJu0YzC9xDUmiPYr0eM0WqkPpEf3j+YQYB9WCi6A0FKBgZ3zNaOQ9W3
	r6Egg8R0gD3U5GPhfMA11mS1R/2yloxRqQwSaeSViMrN3qPHHbgQqj9gHfFTZwyoMsbRf/YJCAu
	WcFMZTeg8bwT0otC0eHvhVIY20fo=
X-Google-Smtp-Source: AGHT+IF3Bur5qmIOw1IwsgK8OG9ApG8zpuyu7KPMG6nqneBc6u2oMMZQ549uSxX9fQop5CncU/epiOI6e8WT0jV5JdE=
X-Received: by 2002:a17:906:494c:b0:a6f:2de0:54d with SMTP id
 a640c23a62f3a-a6f60de60b5mr58009866b.76.1718308062430; Thu, 13 Jun 2024
 12:47:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240612203735.4108690-1-bvanassche@acm.org> <20240612203735.4108690-3-bvanassche@acm.org>
 <yq1frtgve5n.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1frtgve5n.fsf@ca-mkp.ca.oracle.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 13 Jun 2024 21:47:06 +0200
Message-ID: <CAHp75Vfa79aSGKDiDCt9Y3umJf9btbSZN_mPoCeM_qkx8XkPrA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] scsi: core: Introduce the BLIST_SKIP_IO_HINTS flag
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Alan Stern <stern@rowland.harvard.edu>, 
	linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, 
	Joao Machado <jocrismachado@gmail.com>, Christian Heusel <christian@heusel.eu>, stable@vger.kernel.org, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 13, 2024 at 9:40=E2=80=AFPM Martin K. Petersen
<martin.petersen@oracle.com> wrote:

...

> PS. I'm not fussy about Cc. But I generally avoid listing anybody who
> will be automatically copied by virtue of any *-by: tags.
>
> I tend to use Cc as an indicator that this entity needs to act upon the
> patch in question. Ack, review, test, respond to comments, or merge in
> case of stable@.

And nobody asks to remove them! The only outcome of what I see is
beneficial, i.e. cleaning up the commit message. Everything else will
work as expected, e.g., all listed people will be informed as you want
to.

> If a person listed in Cc subsequently responds with a tag, their name
> may be listed more than once in the commit description. But I view that
> as documentation that the person whose feedback was requested actually
> responded. That's useful information as far as I'm concerned...

Again, feel free to have a duplicate, but please do it after --- line.

--=20
With Best Regards,
Andy Shevchenko
