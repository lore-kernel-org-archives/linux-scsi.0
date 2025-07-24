Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15A91F3FDC
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2025 21:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753391120; cv=none; b=d6qm+6uBckqt/0UWFX2MEKVb1EsWQHavxLfdmYhHxGLFAvZELD1+QD6HvMGBiVM71mcuIpO9D26tntA0mG9RPhi4wUfExvwQ0BQv15bS+GaA1+GN6zXaHD28r+Zr7FYSRUyYluO6o+AcRk8QUlDT0r62MXE1JiN8BwtGoTSOtZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753391120; c=relaxed/simple;
	bh=RxP6zQdaR70YQUAliiAkYsrKRCWSUAWmKvfFxROJNm0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k6hjDysRyAbzdinFXap/Gr1kipSvS8OqNttvVlyRZuxZPfdZNq9VqVa0EBzU5uw2Jx/D7SQrJsZKKFmhgJTuYq4HHZDOakE8mqbYjy/4ZFNXloQElHhBxdFutw/vvP/8pEapcxD9cLmM/uLni6y1fJfCNj7icIIQeHYPnhf4JtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jf3umRtK; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jf3umRtK"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ab3855fca3so46191cf.1
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2025 14:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753391117; x=1753995917; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0+jPw+Q+nB+FggL5ZzS0C+jGN5ezuxzf8QG/0EUbliU=;
        b=jf3umRtKaFrUHtI9oRI8GARWftTSA1FlogC0ri/P8F56rWuuxhA8pwpE4J6AtFC2/z
         tkzOE2/QMfI3lLxRXGbDOa53yc0LmAId+70fKzjTOBSOlfQrGuOEaswkNSKejUK2/ziC
         sAoxkahiA5UF9sAjerF+3CySnqHIuPi5PuulFOntmFylBFv9ymUyzvjZhvdg6Urg9Oj1
         6oXocHj/Ckvjry4KGdJ0ouRqtNETnZn5SDxtNRLIDlnrxMEfODrOpkRAQC0fBBALd1yg
         6w/5FJywys3ORftKIbPqirWHIV9aR1Nwrk3M1/cigk/mr6NHH8arMRLO0zimWC3lXjIy
         A9BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753391117; x=1753995917;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0+jPw+Q+nB+FggL5ZzS0C+jGN5ezuxzf8QG/0EUbliU=;
        b=W7Ag0ckafCBCWdcIJrSMUzX0IWgstkR+PcPgpTOtN3Hm+rCtaLiYnXqU5FCHBBIfUv
         Q/XkRCVM4NLVb3dB6aTl0kmpMJ03/sf/der4+3pVZ7Avw89h8dxyrHjCPnv4LH8eYAEB
         3qoY8jehQ1opV9cM20FNQv1DC2KtmAPbNIx4n58X6+Oh+RUQE9iDv+MugHNYVWty9Idj
         p/YJ65pTbMAbN38RZ4OhWuGivAOJqP5tLiTgM6w20hvaK/N3fnCnItJby6FEHZCMEalS
         5EkQfMo1WUNd29XO0HXM4LbFafMMIKf5zfQEUr9ACblRypeTe7BoPUVGFkBzz0Fl/bXF
         ctNQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdXgJVwrYHJnkKP8+n++ul80LXW8fjK8icfGxCcifLJzyGU/mEQVRlEqoUsLwkYJ4+FLNHzpC29pgo@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+83iLQ4mtXOSlebZ3xlw5Tl4f3WF1i5bAKqm6Jf1IqznGtW7x
	iuOQ+uwwM3pjWNr4UUZ9XABEERkrPuqsvoWVo0nUd74xZhfrdQE7hav2vhgQPZnW3+0EquFPeA9
	daSpX/Zlc4WmB3mMhgYfgNnCycYB5iB1Id07M8Qk7
X-Gm-Gg: ASbGncvdh9OEMmWC4L+dsqa2DHas8wIDEkDrwYhX8xTH3kqbbgH/6xJx0+cnR41f8b7
	Auru6T/aLmU6Go1lpT1hDxeS5Syi6XZRcTM9CJ0Xtd8vYB6JsD9eH8r+QpBuwonIU9jXXQ4Y5r2
	QGgwvM83acbQ/ebmtStJ8gqFXnUNPn8KI3YOuFtjW7ZI0cbf33vJ6EyEIkFSXTyKBFJqTpaTvxZ
	tz0J9zwty4YFKhgJPVtM8e8UfxlXYDGn1g=
X-Google-Smtp-Source: AGHT+IFgtODzATiWfxFMkF+cB0CCKx9TAdxB+J36KCzgYr+CrQ9mMY1lomvmkNaYizbbCRci5X34CW5Er9q25AOZSR8=
X-Received: by 2002:a05:622a:198d:b0:479:1958:d81a with SMTP id
 d75a77b69052e-4ae89e62470mr1157481cf.6.1753391116413; Thu, 24 Jul 2025
 14:05:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250724203805.93944-1-salomondush@google.com> <ad9e3921-43ed-4abd-acce-ce46d57f32c8@acm.org>
In-Reply-To: <ad9e3921-43ed-4abd-acce-ce46d57f32c8@acm.org>
From: Salomon Dushimirimana <salomondush@google.com>
Date: Thu, 24 Jul 2025 14:05:05 -0700
X-Gm-Features: Ac12FXyaaMFJE7Zv10L5w3pTul2f926wrozl-RuIkD6s3_nVk3bz_zivl1J9GqE
Message-ID: <CAPE3x153br+UdtWYnxdtAX7hz2OwKYovQeWdeOCWvicTxDayeQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: sd: fix sd shutdown to issue START STOP UNIT
 command appropriately
To: Bart Van Assche <bvanassche@acm.org>
Cc: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Vishakha Channapattan <vishakhavc@google.com>, 
	Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Bart,

Thanks for the timely feedback! I also thought that the
manage_system_start_stop flag is more appropriate.

But I wasn't sure why the commit mentioned in the description removed
the manage_system_start_stop from ata_scsi_dev_config() function in
the first place. So other candidates for a fix were:
1. Adding the setting of the manage_system_start_stop flag back to
ata_scsi_dev_config()
2. Configuring our various drivers to individually enable the
manage_system_start_stop flag (less preferable)

If there was no good reason to remove setting the flag, we can go with
option 1.

Thanks,

On Thu, Jul 24, 2025 at 1:46=E2=80=AFPM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> On 7/24/25 1:38 PM, Salomon Dushimirimana wrote:
> > Commit aa3998dbeb3a ("ata: libata-scsi: Disable scsi device
> > manage_system_start_stop") enabled libata EH to manage device power mod=
e
> > trasitions for system suspend/resume and removed the flag from
> > ata_scsi_dev_config. However, since the sd_shutdown() function still
> > relies on the manage_system_start_stop flag, a spin-down command is not
> > issued to the disk with command "echo 1 > /sys/block/sdb/device/delete"
> >
> > sd_shutdown() can be called for both system/runtime start stop
> > operations, so utilize the manage_run_time_start_stop flag set in the
> > ata_scsi_dev_config and issue a spin-down command during disk removal
> > when the system is running. This is in addition to when the system is
> > powering off and manage_shutdown flag is set. The
> > manage_system_start_stop flag will still be used for drivers that still
> > set the flag.
> >
> > Signed-off-by: Salomon Dushimirimana <salomondush@google.com>
> > ---
> >   drivers/scsi/sd.c | 4 +++-
> >   1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > index eeaa6af294b81..282000c761f8e 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -4173,7 +4173,9 @@ static void sd_shutdown(struct device *dev)
> >       if ((system_state !=3D SYSTEM_RESTART &&
> >            sdkp->device->manage_system_start_stop) ||
> >           (system_state =3D=3D SYSTEM_POWER_OFF &&
> > -          sdkp->device->manage_shutdown)) {
> > +          sdkp->device->manage_shutdown) ||
> > +         (system_state =3D=3D SYSTEM_RUNNING &&
> > +          sdkp->device->manage_runtime_start_stop)) {
> >               sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
> >               sd_start_stop_device(sdkp, 0);
> >       }
>
> A Fixes: tag is missing.
>
> manage_runtime_start_stop is for runtime power management.
> /sys/block/*/device/delete is not related to runtime power management.
> Isn't manage_system_start_stop more appropriate here than
> manage_runtime_start_stop? Shouldn't sd_shutdown() calls triggered by
> writing into /sys/block/*/device/delete already be covered by this
> test: system_state !=3D SYSTEM_RESTART &&
>    sdkp->device->manage_system_start_stop?
>
> Thanks,
>
> Bart.
