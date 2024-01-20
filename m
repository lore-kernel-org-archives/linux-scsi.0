Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D823B10A03
	for <linux-scsi@vger.kernel.org>; Sat, 20 Jan 2024 17:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705773168; cv=none; b=ms1AL16O/dloVRiIB/RTl4B5niecV2lsSMystHAV9pbIaGob0A2r17JlHeeS7Ww0pCJV0EHqJUNciak5itk0CrOTDB8xnsjlAWBGgh0B8r5U6jL/wFePX0nhWTRq/IpW83RTTAzgThZcqaj4Cdb3wb/E4MxV0TWUia7ku1Xvs7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705773168; c=relaxed/simple;
	bh=0OynslLcuiszL7t9Q5gMw+ivFZgRtUXMjZlc1SbA09c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JMhO3qvQq8Zo98Bz9smBN8Rc/vtv64w391Zb0aIPnrwCNlvkfxDjNH8Df6Bu3jds+C0+ZyYz1/lOUWUyVUmv76FtHGcKyOE8/iU+n2haQ6RUk1+FOOD9ONJfVvjrU1Cs+CNgyXJj2NcIUByB0o8lNsnBSJiEzEQ+tOpBiVWDir4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FPx+u6Lq; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FPx+u6Lq"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-50e6ee8e911so2482562e87.1
        for <linux-scsi@vger.kernel.org>; Sat, 20 Jan 2024 09:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1705773164; x=1706377964; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kifWIuG0Ei4r0wI/Fhxtdo1VJo2+oGLcsnG+Q+O15fM=;
        b=FPx+u6Lqbf6NfPuTjhwYhVJfk7IgkyaYODPIdiXV4gdiHwVkAvbr028o1vab3vCk71
         CTWsbaneGSWna18U2237Y0BfPsTdTzAK0NhMMY2Pbg/PWPhHwaz7zpzMOl9n2UBfhmZG
         BLxXBrt7cb9AjcINdO3vzHIiMk9h5HZ8DNb9k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705773164; x=1706377964;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kifWIuG0Ei4r0wI/Fhxtdo1VJo2+oGLcsnG+Q+O15fM=;
        b=tsYqRMuRl1oTOgGbaU6CV41HxC9qTrb5Mvw+mONk2RdVtC8I///q7MoHLH+8u3nkQ6
         UNHsIVx91EKO56pfrM1EqKK1qZdZWWpXGEWK3Ph7TYDPYKw2o0DCZU02TodDIiviOAzB
         00+ySx1q2edEgGF7UXwaom+A+fjbGg89Mm48D+bTnCUFLL+B04XpQcHGbskjJ1xrL0xi
         Fi+Z3EVZtgahl0qfqBOgAtDuoEl4jR/UufKOsL+Llqpzru31po443iWxJ/dX2+h/7sB7
         q94SWBD4oqaxtycwBgM/QDbUgmHRl4EO7jyIsGVjGt1TRsJlhDy8WUBCwbzFup9e9nwM
         b3yw==
X-Gm-Message-State: AOJu0YxcBZMJ1W6YFSfQHK+KYHcdvrekGA/SX5TlgNac+RNL9p2HrdHM
	Oo5XQlvMG7zhHlFXRxT9ZkAIMcQ3WK92FcURggAaVbkldp76VMpEduULn8o8JVjt/zkaNvoTq2j
	5gyejrg==
X-Google-Smtp-Source: AGHT+IHbeQYFrj7PiCcjFKW80et8tN5hghBBHwTaI6ob1tijmwVV9aolEmNkDPDJK4utM77aevcCsg==
X-Received: by 2002:ac2:4101:0:b0:50f:1a9b:ef48 with SMTP id b1-20020ac24101000000b0050f1a9bef48mr603061lfi.69.1705773164527;
        Sat, 20 Jan 2024 09:52:44 -0800 (PST)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id bt16-20020a170906b15000b00a2ada87f6a1sm11610750ejb.90.2024.01.20.09.52.44
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jan 2024 09:52:44 -0800 (PST)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-559de6145c3so1945370a12.1
        for <linux-scsi@vger.kernel.org>; Sat, 20 Jan 2024 09:52:44 -0800 (PST)
X-Received: by 2002:a05:6402:3486:b0:559:eca8:fdb3 with SMTP id
 v6-20020a056402348600b00559eca8fdb3mr1068788edc.66.1705773163764; Sat, 20 Jan
 2024 09:52:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d2ce7bc75cadd3d39858c02f7f6f0b4286e6319b.camel@HansenPartnership.com>
In-Reply-To: <d2ce7bc75cadd3d39858c02f7f6f0b4286e6319b.camel@HansenPartnership.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 20 Jan 2024 09:52:27 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi8-9BCn+KxwtwrZ0g=Xpjin_D3p8ZYoT+4n2hvNeCh+w@mail.gmail.com>
Message-ID: <CAHk-=wi8-9BCn+KxwtwrZ0g=Xpjin_D3p8ZYoT+4n2hvNeCh+w@mail.gmail.com>
Subject: Re: [GIT PULL] final round of SCSI updates for the 6.7+ merge window
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 20 Jan 2024 at 07:26, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> As requested, I did a longer extension of my gpg keys, so my key needs
> refreshing, before you pull, to fix the expiry date.  You can get my
> updates via DANE using:
>
> gpg --auto-key-locate dane --recv D5606E73C8B46271BEAD9ADF814AE47C214854D6

No I can't.

I get

  $ gpg --auto-key-locate dane --recv D5606E73C8B46271BEAD9ADF814AE47C214854D6
  gpg: key 814AE47C214854D6: "James Bottomley
<James.Bottomley@HansenPartnership.com>" not changed
  gpg: Total number processed: 1
  gpg:              unchanged: 1

Fine - maybe I already had the update from the last time...

But no:

  git log --show-signature

says

  commit c25b24fa72c734f8cd6c31a13548013263b26286 (HEAD -> master)
  merged tag 'scsi-misc'
  gpg: Signature made Sat 20 Jan 2024 07:22:08 PST
  gpg:                using ECDSA key E76040DB76CA3D176708F9AAE742C94CEE98AC85
  gpg:                issuer "james.bottomley@hansenpartnership.com"
  gpg: Good signature from "James Bottomley
<James.Bottomley@HansenPartnership.com>" [full]
  gpg:                 aka "James Bottomley <jejb@kernel.org>" [full]
  gpg:                 aka "[jpeg image of size 5254]" [full]
  gpg:                 aka "James Bottomley <jejb@linux.vnet.ibm.com>" [unknown]
  gpg:                 aka "James Bottomley <jejb@linux.ibm.com>" [unknown]
  gpg: Note: This key has expired!
  Primary key fingerprint: D560 6E73 C8B4 6271 BEAD  9ADF 814A E47C 2148 54D6
       Subkey fingerprint: E760 40DB 76CA 3D17 6708  F9AA E742 C94C EE98 AC85

and fighting that ^&%%$^ gpg command to try to figure out why, I still see

  gpg: Note: signature key E742C94CEE98AC85 expired 2024-01-16 11:39:15
  sub   nistp256 2018-01-23 [S] [expired: 2024-01-16]
        E760 40DB 76CA 3D17 6708  F9AA E742 C94C EE98 AC85

and that's the one you signed with.

This mess continues to happen only with your crazy setup.

                        Linus
