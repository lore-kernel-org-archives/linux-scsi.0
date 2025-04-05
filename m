Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D9213D52F;
	Sat,  5 Apr 2025 17:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743874137; cv=none; b=ty07BCJuoEUceDEyhimz5I9JyOPXQtcZc4l3uneOXxZOpd7f1HfEgIgeMLvVIObV7svCoQtyeeUrqr55bn9sEmzYUDY7fLxcvERDrG8dUEswG7ZMr0Ktkq2B+s8T+kPTwWyG6msWOF63UL+xcTe+T5rZQc3WtiGxtdR2k6UI3PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743874137; c=relaxed/simple;
	bh=zj/fmiI253uvBAVahnE/+QFJ/fun3Lssp1wjLuyp634=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LkgYJJE+zo1Yq5ThcJr5OqXsQOMr/kaB/mEHP3wYJncQMrFJutlOnjavUsbgxIr1Ddc1Fs1FOMuYR+TY1A652i6rNsgMr3fojHPXU70VPWzJ6R1q5ETHdJh2+N9c8R3neOXLvzeEXrQV8nLb5VNzxjaVSWhWLob3bCCwBKXOnrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h0m/Q7yS; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h0m/Q7yS"
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e3978c00a5aso2441286276.1;
        Sat, 05 Apr 2025 10:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743874134; x=1744478934; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jW1xAus8FHDpywvQBlSsYf1NBRChzXtls8jPIo8+8H0=;
        b=h0m/Q7ySs3L8RGcvaEOmGHq04EayLXaLAmv2zLZrfXl9MvOY8Zyh/nbvQGMrahnKW1
         anBfAAz14YmwO217v15iKW1fwrkixJiaUVZ777qf1e+QXtBUCOKEYkoAvX586byMxiHx
         R75nsmwlbP893bNe4vfKWpPJqUQvJBpZqZ4WzczCwp2HITxSh1KZCOa7c6QEZAN+rqoi
         cebfbNtfw3i7va+5HY58XsnJ47hT3/Fhe1C/n8+YNzHCCcEkmfJufBoM40CTWCQhoAwG
         THhNDaRPDiCtzAqLD/b3uzR8anVEdS5vX/HeaJiJri0VJ1mAAwFImGu0U8ocphyqx+px
         6vWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743874134; x=1744478934;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jW1xAus8FHDpywvQBlSsYf1NBRChzXtls8jPIo8+8H0=;
        b=MHqqQHykW3AleqLn6w4dr9LPOoD4rUgZ1YHIh+2WlSfT9yBhP3Ai4MYOWBurGePacg
         VAkQKZvHLPMpK+fczDzniVVxNfxKfQjePWQipJE9rUTJm0L6A5ilmlKg6d7AV+t9w9LC
         GBceFYbZV4WQmovgBzBMu9b7W21a1wSBNBBFOWctH5oQGnel87yB93/HP2t4HMOYmQre
         WO4D8zyS/yGcesYymoeNog3zyl4WcICEBerVKw3cYPa1HntJ8AKh4sYpgVD0gGUEplV5
         G29RNoki+yqL1ctb7lGzieqU4+n1mTz/jBPYycVMdiV01dbzXhGSNuytHanHhrs+ak2Q
         GkCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUeGkrFHZsp/e2Lcfmys6WaHzAJEj0MYjSFcINZdjCITq6IH4/7BSC11aYfg9t7PZ3+9bOARIUO2y4CWM68@vger.kernel.org, AJvYcCVZxjNJgIJq6qZ+cZOtbPF9qyFaGQ8aAsKVi3+V/6zDBQK7xNDGE11zCLOlP2Hx8v2caLWhMgFHZFGDow==@vger.kernel.org, AJvYcCX+YK7MaEhbpFBy7S3igJXOGg8uIDhAoPurOfPB4r5FL/DRapsiTFoVG39c1tq2g0bdQqt3+HJGpfc9tbg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzc5jGDaQeKs2cRA5kPehF3cE7nDpt2NmSFP8NFGfw2kZcBaHT/
	0EtddtVnqFJ4jo75Z7qMYG4I7+VPSTIFn0ryp7tMW84LxIwnS8C7Q2pNHpbmJhEwZLWVDHzo94T
	LzrPu8PW+CMHy9BC7GliXgo53+ao=
X-Gm-Gg: ASbGncs+x+2seKiXxO931jrt56QW05f4ZQ4OMzJbqnNV+xSTnSzfVKwlM0tf4B7jmS6
	tBj1jf+QVaLzbfCUd7gEgS4/pWMolnxnjMdimxq/29IXbbk6v1i9A4jR2voQb3tNysl+GrXHMvK
	pM7a+cXzOZ30kV0vamhnraZiDb
X-Google-Smtp-Source: AGHT+IESo5T95fFyvW3R59tyJsVhxEya1iUHOTcTxLLMetNdAkOMzfreJMAvHRkABNsC5C5mnlH10P5ER6FbNPfqX1I=
X-Received: by 2002:a05:690c:6d02:b0:6fd:a226:fb4c with SMTP id
 00721157ae682-703e154f5a0mr132981617b3.15.1743874134572; Sat, 05 Apr 2025
 10:28:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250402204554.205560-1-goralbaris@gmail.com> <20250405143646.10722-1-goralbaris@gmail.com>
 <20250405162548.310dea37@pumpkin> <CAJOJxizEDm_th4G=BvejM4_jGcF6+QYT=LjD_J_FTbsNFVTjCQ@mail.gmail.com>
In-Reply-To: <CAJOJxizEDm_th4G=BvejM4_jGcF6+QYT=LjD_J_FTbsNFVTjCQ@mail.gmail.com>
From: baris goral <goralbaris@gmail.com>
Date: Sat, 5 Apr 2025 20:28:42 +0300
X-Gm-Features: ATxdqUFXJGOJznQfdtlC7tZTYAw3xNF7XEDd6qaqt_Ax-jNxnhVZ9v2lAxz3u3E
Message-ID: <CAJOJxiyOZgRrf=e3tJuKiAdZP4U4MS4Y0EQFd5HPYAHgUhXVww@mail.gmail.com>
Subject: Re: [PATCH v4] scsi: target: transform strncpy into strscpy
To: David Laight <david.laight.linux@gmail.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,
Trying to understand, it has if check a few lines above:

if (count > (DB_ROOT_LEN - 1))

Does not it met our expectations?


Best Reagrds,
Baris


baris goral <goralbaris@gmail.com>, 5 Nis 2025 Cmt, 19:35 tarihinde =C5=9Fu=
nu yazd=C4=B1:
>
> Hi,
> Trying to understand, it has if check a few lines above:
>
> if (count > (DB_ROOT_LEN - 1))
>
> Does not it met our expectations?
>
>
> David Laight <david.laight.linux@gmail.com>, 5 Nis 2025 Cmt, 18:25 tarihi=
nde =C5=9Funu yazd=C4=B1:
>>
>> On Sat,  5 Apr 2025 17:36:47 +0300
>> Baris Can Goral <goralbaris@gmail.com> wrote:
>>
>> > The strncpy() function is actively dangerous to use since it may not
>> > NULL-terminate the destination string,resulting in potential memory
>> > content exposures, unbounded reads, or crashes.
>> >
>> > Link:https://github.com/KSPP/linux/issues/90
>> > Signed-off-by: Baris Can Goral <goralbaris@gmail.com>
>> > ---
>> > Changes from v4:
>> >       -Description added
>> >       -User name corrected
>> >       -formatting issues.
>> >       -commit name changed
>> >  drivers/target/target_core_configfs.c | 4 ++--
>> >  1 file changed, 2 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/drivers/target/target_core_configfs.c b/drivers/target/ta=
rget_core_configfs.c
>> > index c40217f44b1b..5c0b74e76be2 100644
>> > --- a/drivers/target/target_core_configfs.c
>> > +++ b/drivers/target/target_core_configfs.c
>> > @@ -143,7 +143,7 @@ static ssize_t target_core_item_dbroot_store(struc=
t config_item *item,
>> >       }
>> >       filp_close(fp, NULL);
>> >
>> > -     strncpy(db_root, db_root_stage, read_bytes);
>> > +     strscpy(db_root, db_root_stage, read_bytes);
>> >       pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
>>
>> That code is broken, it reads:
>>         read_bytes =3D snprintf(db_root_stage, DB_ROOT_LEN, "%s", page);
>>         if (!read_bytes)
>>                 goto unlock;
>>
>>         if (db_root_stage[read_bytes - 1] =3D=3D '\n')
>>                 db_root_stage[read_bytes - 1] =3D '\0';
>>
>>         /* validate new db root before accepting it */
>>         fp =3D filp_open(db_root_stage, O_RDONLY, 0);
>>         if (IS_ERR(fp)) {
>>                 pr_err("db_root: cannot open: %s\n", db_root_stage);
>>                 goto unlock;
>>         }
>>         if (!S_ISDIR(file_inode(fp)->i_mode)) {
>>                 filp_close(fp, NULL);
>>                 pr_err("db_root: not a directory: %s\n", db_root_stage);
>>                 goto unlock;
>>         }
>>         filp_close(fp, NULL);
>>
>>         strncpy(db_root, db_root_stage, read_bytes);
>>         pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
>>
>>         r =3D read_bytes;
>>
>> unlock:
>>         mutex_unlock(&target_devices_lock);
>>         return r;
>>
>> 'Really nasty (tm)' things happen if 'page' is too long.
>>
>>         David
>>
>> >
>> >       r =3D read_bytes;
>> > @@ -3664,7 +3664,7 @@ static void target_init_dbroot(void)
>> >       }
>> >       filp_close(fp, NULL);
>> >
>> > -     strncpy(db_root, db_root_stage, DB_ROOT_LEN);
>> > +     strscpy(db_root, db_root_stage, DB_ROOT_LEN);
>> >       pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
>> >  }
>> >
>>
