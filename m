Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C938E280CE0
	for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2025 07:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755503207; cv=none; b=tRkc58x3q0na2jTyyla7Vik79XcotEoDhP8XOG8aa9ireQix9OEWLNqWXZU6SUKJ/m633QpW50KfyJvpmRpjEIdg7WayYaZgh1arY/WC37uPvK2nh7/c+G+DEDLzk6hvfsDQ3fIrAOSaVXQse6lWMwIXKKLgBDs1SY4jTThTFW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755503207; c=relaxed/simple;
	bh=f2pEIqCEKqGydl9SMGXO/M4pKyUg7Tmz3Jix0gzHQJs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TN0g/lHR2hQC7msW8DvfBN4c0fU8iNbxwmx2tykeC5izlO84gfHy6qwDDkBQ6QjhCMPAaoWBunpSNGqty6to1O/r65qW90AXiuVFVTPm8muz0fVOUyJCMfBMIvuF9B5w3HR6J0Wp1wJJny4BRvtDXI5VaZ8VCknTtpcjB9oUaxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=Ob6m9h45; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="Ob6m9h45"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6188b761d74so681883a12.3
        for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2025 00:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1755503203; x=1756108003; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8kdKGh0nwlC5p+ihEd1gHsrZngvGHyAG1wUlJn6DKNQ=;
        b=Ob6m9h45YPM8VarDwgUCJdFdxv6V63kYLHvnsbWAD11kr5ZDqc11GPfeg97FBLznju
         Aihy98IRJ5YApvvlOWgM8kvAj4XkXtv/DBVy267eoSAS+pmJOI5f9/SQPkzzO44WNLYh
         0w6VKf5syKh2jPW8NslEZuumciwSxSkBRD+LSJEsSM5YOW/RRt2UI6ErqQH06COY37qE
         m5S0DqD8eoA5VvVYo0Iv6O/bWEPVY4nBteB7MYMPHoT4vkFcgfgFyOPdrQpakCWXiBmT
         3wfA9LZkrvft7CVj6li+oUMZnD2CyGJBlhee+bUJPz5itGPKyCR6yf3KXXv2fgjufAWz
         FmRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755503203; x=1756108003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8kdKGh0nwlC5p+ihEd1gHsrZngvGHyAG1wUlJn6DKNQ=;
        b=jOYR7Jo/D7Ft3ChaIYscLLIfmyDmiYrxb8Bhhp/LDObOpDyS1LjhEa3FxvjD0atA61
         5nv8jysL+ontsW0Kw1OVc7eJrYbUXhmVr3Z+h5LlIuoKKfHcQHFCUSzIWUp+A3xmdeiC
         iGDcUZUkzXj2a0dg24oYAS6rdMe26lEHhZqWiyNVf1nJymXi8GFQu8fMxFmzRpwkXlOF
         tDLlU1zf+9nUdswvbAGZcQg48XFf6MTxYQLJ2uoeUG4bMdEzldeB4O3OEKPQnu/5vBdl
         nqDOn3V0oZLItzaDTIjzK/1T2Dr0gPIIlJ3F+IgIKrn2dvcuPDkIQtlTTxJiqgZk1Ihd
         nhdg==
X-Forwarded-Encrypted: i=1; AJvYcCUTTWMfkWevEp4W3ncPuSoVBO8syUoPWRMLrvqd88cOTshEIyGQugBOAlhDWqeUd4IWo7iFRTD2KuVX@vger.kernel.org
X-Gm-Message-State: AOJu0YzqSUWjn5ILUhPNgzbt5bQs1Z3rrxFdNyW6ezIpda4S+hV45Yd5
	sqcjpX0s4kjzoI6CvZBQ7bXiEheVdj8c1YW/h/iHWOtUJoHxV82syBi9RtnVLbmnB7YdDhaDCB1
	XQQ3CIY8rZQUkqo3Prqp/ORx4TLyEcVdYSNH5qewpuRUeejwo99Cj
X-Gm-Gg: ASbGncuRM7MseD6tKNZEN2NLTqrgtCccFMYQ84dc7v7cZkGVEVwr5YYguDOCihoR01v
	f8+nD04K7FxsqtdbVtuWiO9wghQ5pHIaIFD0+kG7q4GHPzudRcTHx0H2+S4RAZMYA38H/gD2+GI
	D7tJfl/lX/D+VV1qRoM84LuISglnxUQ14AI6MOFwniahZLMDuf/oX/qOOEGl1YWO6GSk15Fl3oY
	52EexE=
X-Google-Smtp-Source: AGHT+IFqSEMYdxukEOmRRcd97Z8gXpZFBl+7A9caxJoq6Pv2krnrFURH2r8CMrwZ3ZHV89fx7ZLgByyGQLB0SmOQm+s=
X-Received: by 2002:a05:6402:1d55:b0:607:eea1:1038 with SMTP id
 4fb4d7f45d1cf-618b076751bmr4743743a12.6.1755503202970; Mon, 18 Aug 2025
 00:46:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250814173215.1765055-12-cassel@kernel.org> <20250814173215.1765055-22-cassel@kernel.org>
In-Reply-To: <20250814173215.1765055-22-cassel@kernel.org>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Mon, 18 Aug 2025 09:46:32 +0200
X-Gm-Features: Ac12FXzHDq3vhTA6ve3gqPm9o2-Ja1Gq7dT-lOC14P4jOiCrwo4Tmk_mC4V6wYM
Message-ID: <CAMGffE=0QjvAzN49ZQ0-ZXrhx8qqotpzCKKt624bhEG0SycrCA@mail.gmail.com>
Subject: Re: [PATCH v2 10/10] scsi: pm80xx: Use pm80xx_get_local_phy_id() to
 access phy array
To: Niklas Cassel <cassel@kernel.org>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 14, 2025 at 7:32=E2=80=AFPM Niklas Cassel <cassel@kernel.org> w=
rote:
>
> While the current code is perfectly fine (because we verify that the
> device is directly attached before using attached_phy to index the
> pm8001_ha->phy array), let's use the pm80xx_get_local_phy_id() helper
> anyway, to reduce the chance that someone will copy paste this pattern to
> other parts of the driver.
>
> Note that in this specific case, we still need to keep the check that the
> device is not behind an expander, because we do not want to clear
> attached_phy of the expander if a device behind the expander disappears
> (as that would disable all the other devices behind the expander).
>
> However, if it is the expander itself that disappears, attached_phy will
> be cleared, just like it would for any other directly attached device.
>
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_sas.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
> index c5354263b45e..6a8d35aea93a 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -780,8 +780,11 @@ static void pm8001_dev_gone_notify(struct domain_dev=
ice *dev)
>                  * The phy array only contains local phys. Thus, we canno=
t clear
>                  * phy_attached for a device behind an expander.
>                  */
> -               if (!dev_parent_is_expander(dev))
> -                       pm8001_ha->phy[pm8001_dev->attached_phy].phy_atta=
ched =3D 0;
> +               if (!dev_parent_is_expander(dev)) {
> +                       u32 phy_id =3D pm80xx_get_local_phy_id(dev);
> +
> +                       pm8001_ha->phy[phy_id].phy_attached =3D 0;
> +               }
>                 pm8001_free_dev(pm8001_dev);
>         } else {
>                 pm8001_dbg(pm8001_ha, DISC, "Found dev has gone.\n");
> --
> 2.50.1
>
