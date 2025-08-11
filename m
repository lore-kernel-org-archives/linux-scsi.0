Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CB3285078
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 21:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754947389; cv=none; b=IwVZgpjDu9+kROZwI8zVwwIp/YkKKtU1NNOFLiwiR+pMNT7dEfrlVqKFwvRbFth89bYCYR5DxJp5NtukIeULxJISwyymf7kl0pWtzgrWFsOLSptBcSWcg6YGsjlOUCieCRgCUZGMmTBA3d+xvmpwdnhU9nuoJjKyWhXjdedmGMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754947389; c=relaxed/simple;
	bh=4nxY/HUaLkGg/Sja8DVECdqZSiZ9DW57Q30+/BRaPw4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zjz+fWp1jR+LrL5IE7inZgB0v+sEi+29d/LtFecmVpTjqieXW4o7j6C/tsW3JKwbf7yOOi2cAucIyDG0hRQ3uRkaQsJIejNHlG+daysIH+aThQCFsFlg9H6D+QBi1gbs8CfLXOLHCV54V0bfyntx5r4YhwcM/iBGGEqO6WuQMGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OFUAn3t1; arc=none smtp.client-ip=209.85.217.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OFUAn3t1"
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-4fbfba13bb4so1489295137.3
        for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 14:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754947386; x=1755552186; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sZdqMxmyzBB1OkAkLeaTzK+1PBVEWeH6ndA/ynyWuPQ=;
        b=OFUAn3t1S1zKIFx4qHEwE9Ag2O5b+ma3NLtTkbATvGEY449xoHtkzkuoQ465EhV5Rc
         noGCnONEUwzwzJ02fA40MkwokYLjHhLREjXy40HNSjnB8Vgi9Z4sA6Pe5ZtQwl+THnRz
         iWJOon2c8wztDaa/QvPqHKNtjd1Sh9AxKXg49caK5Tt9cVT2NfixBGGkolAR2Q+iiHPg
         WeDw+O1XACy7RJSQ9ullIndxjF+3Qq3DTa/pOLLY5YTSh9Q7mv08LodAh4vNf1rdKsVD
         AR29qbBiyP/fWTW2mlfwdLCpnRTiHekVHSwm14StJdzVkhZwcertomCQcTX0yFAvz2BW
         v+Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754947386; x=1755552186;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sZdqMxmyzBB1OkAkLeaTzK+1PBVEWeH6ndA/ynyWuPQ=;
        b=R//SKyUkS7X7UpOtowLuE2cbQOeNjUcgp/bU12+1sCZfnBGL9de8eq6B2A9U+xa1/q
         IYv8gF7WxWzNTWOGd3nAdjVrNAf6KK0Z7WslJEQgFwAP5ajNZqd1ASO9Mm1s5wtCbSjT
         K1xP9sRUdNdnmRsYAcAwBuFEFrbWrCcA5pCcCan19OHV6lUNunRssU07aUaLvqCySm7O
         dnx1MYSzPdh3QrU7HzBWowKPrHJ5jiWsiFH3KVu4YeUDeGgBVE+az6jrs1NLb1QCG1wE
         P67Unn3CP62ZjaY63NjjGiGdfZ1kHLQi4y/vPDBvS3kKEUv04qP3jFqk84Wpq06WoErv
         Exvw==
X-Forwarded-Encrypted: i=1; AJvYcCXS14tQSZ+E4AL1hGE5cM+EeptiYYJqW6vSdrItj9ueHYgEEcncbHvIxjGC9nCiWrPoWOHqPsZK45N+@vger.kernel.org
X-Gm-Message-State: AOJu0YxjMvH1Yh1Qmq5aXG3qFL4M7nYlGdc0PldvfLqZ8StotDqiGZeJ
	o1zN/aE5Azxe3WD4LfON2lhXlIMO1dim5+9FnY/WRnKoXHZ9uiDaU6FCAKF/FpV5QynUWHJ1tcu
	oJ2Zenvf3Sh8+t4lsm6itUBnBeWlewQOc/8YVkNOC
X-Gm-Gg: ASbGnctUi14Cu6mxQYIUm7QFezEF+9wRfEly0NLl94HCzLPI9Fi6naAoZtxaO0OW2dc
	YcouovLZy0DpHRkzteMG5wlEiJLWPiPShlsCski30QT6W+RvNkhT8Vf7j3lxMS61ZM0L8DJwhgQ
	qkV+32R/QBFg0XH+SJyFggL6G4udYllHvWGendE/Oyk4Fq0l0ly0DNzyd79s3IEKPtajpbg1yEm
	WtAzc6c8av6I4zd9m5ucsHFQgDmLWCv49gzLGuXW7FBTy4=
X-Google-Smtp-Source: AGHT+IHNSP3vbp+tuQbd49qGq2dEhZY6RoOdr6qnUgW6nP39Oelsmfq5rhveK1FlrfgOdmZxbuKZm8fey7RqOl3kwf0=
X-Received: by 2002:a05:6102:54a8:b0:4c5:1c2e:79f5 with SMTP id
 ada2fe7eead31-5060eae4ee5mr5032632137.16.1754947386206; Mon, 11 Aug 2025
 14:23:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250723183543.1443301-1-frankramirez@google.com> <yq1y0rx9odi.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1y0rx9odi.fsf@ca-mkp.ca.oracle.com>
From: Francisco Gutierrez Ramirez <frankramirez@google.com>
Date: Mon, 11 Aug 2025 14:22:30 -0700
X-Gm-Features: Ac12FXwXtPlgcqTGdIdExolDfW9JzJwF7lUfU4iCVvyT-kj1KM02fwvKMuSS9o4
Message-ID: <CANxonXNtbo5UoaT0cvdZxAHo2jnmoQn7bzaZ2dk7_=Pf=M6LPA@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm80xx: Fix race condition caused by static variables
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jerry.Wong@microchip.com, vishakhavc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Martin,

Thanks very much for taking the time to review my patch and for your feedba=
ck.

I'm writing to provide a bit more context for the design. The function
in question needs to be called repeatedly, and the struct helps to
track state across those calls without using static variables, instead
tying the state to the specific controller instance. This ensures the
function is thread-safe.

Please let me know if that context clarifies my approach, or if you
have an alternative suggestion for managing state safely in this
scenario.

Thanks again for your help.

Best regards,
Francisco Gutierrez


On Tue, Aug 5, 2025 at 7:30=E2=80=AFPM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Francisco,
>
> > -     for (; start < end; start++)
> > -             str +=3D sprintf(str, "%08x ", *(temp+start));
> > -     count++;
>
> > +     for (; pm8001_ha->iop_log_start < pm8001_ha->iop_log_end; pm8001_=
ha->iop_log_start++)
> > +             str +=3D sprintf(str, "%08x ", *(temp+pm8001_ha->iop_log_=
start));
> > +     pm8001_ha->iop_log_count++;
>
> Since the start, end, and count variables are only used in this
> function, what is the point of putting them in 'struct pm8001_hba_info'?
> It makes the lines longer and harder to read...
>
> --
> Martin K. Petersen
