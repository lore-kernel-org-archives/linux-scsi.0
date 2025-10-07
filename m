Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A581A8401
	for <linux-scsi@vger.kernel.org>; Tue,  7 Oct 2025 20:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759867563; cv=none; b=J5ay1NCYnYMVDf1lls45lM0aui4SLSyCEtl4YYwgLo58md4+GQEeWuyOr2Mt3pLCzrEZ1GdIpGGBAZhIIlIbtK4ZoIoWtTOOIkR+C9E9zlF+r9UYR/iac0cgNtCPpS9Y1Zpz9X82rTASng1oWrnkVmlMlRG/SkncAir1Lf1onO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759867563; c=relaxed/simple;
	bh=WJQxWT6wF/jboV9xo52lOonbbR/k8DBgj6cYsM2PTrc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uwSKkGdHOUSjxIdCTw4BI/qjayAef1Vc1goYn/grL2WXdwgFG9FcvGBMJxU/YPmDyYwtLpd75OuqKXDNcFTcCklGblSNXpzBPIxXuzWl6tL/X24bZ2/IVgsowN75gV/eA2kDBfs02JMtZmIYbQVYqdbSIQOtJWBYM+V3NDW0j/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lGowQb2Y; arc=none smtp.client-ip=209.85.217.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lGowQb2Y"
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-5d42137abc2so4252180137.2
        for <linux-scsi@vger.kernel.org>; Tue, 07 Oct 2025 13:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759867560; x=1760472360; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U4dyxOrFlOFe4U6sjcUwMolCRd6l1aH8+4CTrd86ew0=;
        b=lGowQb2Y6KL9ee5iwVt5OqtrUatCWrjdsLbHMuBVBF0/M/zNMysGnpEgbGWMF726W2
         PjAfLhnlyiqxtlv6JSRdcXxyCyzteoOM+IpShOBnA7FdUbdlH/M6xcDtve/0djFfS6d6
         i2gxNhk+AFTXyirjKmMV2UoGgJn/+fGxiThlo/CrYw0A+kdeKHgNQP8zo91o1/hlO4z1
         luJ4zJ8qqtxTiuo2UMzqGmlk7c02gEr/mK3e3B7JJEHAt8Mj6DVE/hnGwFxNReqfGV1d
         4M6gEt4CgFjKQ+2iQuQKmt+cYmaWb3pnQX8hdJlNmIFkJ0pBbyvRDHGihfUwjCV0WIAG
         m1Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759867560; x=1760472360;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U4dyxOrFlOFe4U6sjcUwMolCRd6l1aH8+4CTrd86ew0=;
        b=eCQtBIPzFDnQ8Icc4Tc154nxmMtA8mJVBDeB/m/xV03SpQzRhZbDNzye5/Gq8p17DI
         2tkTqL5gVGExwJThesz1AxQNxvAjZAQe4+ZneUWz3kq+yhKEQbaG5dWdE1Or1HJ8jdbF
         nvDnBvq+kQdfWchvxgzIHrrYXqrbFO5qg/lwxHd/ngZUfdvAh4nyuL2bVw+KgJLQlyfw
         X7bxweeoQ7NigQrVo6ScOU9zlvuz4ZZQyIRtcULm261mSNEsdQRrCClZTR7F35/vnkHS
         CESX27yRq+UTdxoRmai6brAIeNo253k5ybRVCO0nM27ZtSuV1+b09Ct3XGGkG2d4j+19
         EhpA==
X-Forwarded-Encrypted: i=1; AJvYcCXgU2Aft8GytsvauJgiBXokuvkAC0bAI4IcIgVGRoANthvdEnDYwvLp/yCbId9irQvN6o3ifJxPbJEi@vger.kernel.org
X-Gm-Message-State: AOJu0YzL8uxBjkG2Kpe6C4gvrcPUVrKtnGPXArhZ5grYzQb6SFc4ht+r
	xEnBcRapwx1GfDuVzo/kWghnI3EvnF0Dac4uudBN+1JhOMwrE/xetS30i1U3s8BH2QGoyfb/hEM
	8GgqrwMJgtY4tW/P8dgmX8FzXa6J76Q4=
X-Gm-Gg: ASbGncu03bxuuKi+slrJIT0T5JgOZn5OlUibHk6a7tP7P94/RuYIA44R9/b4Dwzlwx4
	ttRiZ1RJ8YCBq+ykRWkH5g1jzqUYyn89Ouo7nNjHSwJ0Z5kEkSQPbBn2Bbr6K6E8rbwXZQQgYHy
	Q4gmDn0EBHejiQCusw4oE6/4933WWsQqmki//1Sn4D0V1IolbA+obEyP4BIfy8/aPqqDJ9HkUJJ
	1S9msvpT3c2oPxYu9oKGEMSC2x1YDYn
X-Google-Smtp-Source: AGHT+IGITUrI/yR5IXL/mFkjQlTlGUw1hLwC1/R6yICe1J0nVa6DcOEdCLR2qa/KmQF3kTfOkWB+cDAc8og/Pna9xpA=
X-Received: by 2002:a05:6102:32c6:b0:5a4:69bc:a9e with SMTP id
 ada2fe7eead31-5d5e2347589mr387386137.22.1759867560499; Tue, 07 Oct 2025
 13:06:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251002063038.552399-1-kubik.bartlomiej@gmail.com> <yq1frbvforp.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1frbvforp.fsf@ca-mkp.ca.oracle.com>
From: =?UTF-8?Q?Bart=C5=82omiej_Kubik?= <kubik.bartlomiej@gmail.com>
Date: Tue, 7 Oct 2025 22:05:49 +0200
X-Gm-Features: AS18NWAPKi7YsXhdeE2n6LOH1QCmcymNQDYp9uK4Va4qllY1OBre7oyhLDjL8DI
Message-ID: <CAPqLRf1GAFR=JAo8yuPZ5XRH2aXJrTk=_b78SUqw0jbv+9hLwQ@mail.gmail.com>
Subject: Re: [PATCH RESEND] driver/scsi/mpi3mr.h: Fix build warning for mpi3mr_start_watchdog
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: sathya.prakash@broadcom.com, kashyap.desai@broadcom.com, 
	sumit.saxena@broadcom.com, sreekanth.reddy@broadcom.com, 
	James.Bottomley@hansenpartnership.com, mpi3mr-linuxdrv.pdl@broadcom.com, 
	linux-scsi@vger.kernel.org, skhan@linuxfoundation.org, 
	david.hunter.linux@gmail.com, linux-kernel-mentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Martin,

On Tue, 7 Oct 2025 at 04:25, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Hi Bartlomiej!
>
> > Fix watchdog name truncation.
> >
> > In function mpi3mr_start_watchdog, watchdog_work_q_name is build
> > snprintf(mrioc->watchdog_work_q_name,
> >       sizeof(mrioc->watchdog_work_q_name), "watchdog_%s%d", mrioc->name=
,
> >       mrioc->id);
>
> > +#define MPI3MR_WATCHDOG_NAME_LENGTH  (MPI3MR_NAME_LENGTH + 15)
>
> Please document why 15 is the correct number and describe the code path
> which leads to the watchdog name being truncated.
>
> Also (and I guess this is a question for Broadcom since I don't have any
> mpi3mr hardware so I can't check), as far as I can tell, mrioc->name
> already includes mrioc->id so the id will be listed twice in the
> watchdog name? Or am I missing something?
>
> --
> Martin K. Petersen

GCC warn:
drivers/scsi/mpi3mr/mpi3mr_fw.c:2872:60: warning: =E2=80=98%s=E2=80=99 dire=
ctive
output may be truncated writing up to 63 bytes into a region of size
41 [-Wformat-truncation=3D]

In function mpi3mr_start_watchdog:

The mrioc->watchdog_work_q_name is built from the string "watchdog_" +
mrioc->name[64] and + mrioc->id.
Currently snprintf(...) will truncate this string to size
watchdog_work_q_name[50].

I changed watchdog_work_q_name size to:
-> "watchdog_" are 9 characters.
-> mrioc->name[64] up to 64 characters.
-> mrioc->id is u8 value, 3 characters.
-> plus three extra characters for safety.

Yes, as you suggested, mrioc->id is currently appended twice to the
watchdog_work_q_name, which is unnecessary and makes it harder to
read. I will prepare patch v2 to remove the second occurrence of
mrioc->id from watchdog_work_q_name.

Best regards
Bart=C5=82omiej Kubik
