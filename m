Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E57D33123A
	for <linux-scsi@vger.kernel.org>; Tue, 20 Jan 2026 16:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768927180; cv=pass; b=seJFkoy7Az26N9L8TnbzIOYnUwrlEDAtbv1D+lqli4i5lb80fCZXcG9fN01JPTgcKxyUpl2RKQdzPBBhfmffNK0Bvujd0j8UQr3GXOU1MeWyJ3PU7ckIiPpAcDq/gGyRAMLTtjOpTMMcpEAfDV09SeAUeS4g2M95fq5JuCIqJLw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768927180; c=relaxed/simple;
	bh=NaCvwwv+xnOpT1PJncRUH9O5joA2zwi80d6Vd18hunY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jZkXwzrlNMGP2VWFS7A9+FsKJpQp3w04ZvbKMg7OwwnX12vR7NRRqlRJRN4TCI6DMmH1Jc8nuGfeW09UvHXZxqqCzj59q6EsaRCIv5lb96spH1O0/XxkjEALW2fxdPjSy7X/Y6laq1dfx9Wk9SOPVmy+APcKi1Bz+je1CUqZxYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jfoHaV43; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jfoHaV43"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64b5eb14e88so863517a12.2
        for <linux-scsi@vger.kernel.org>; Tue, 20 Jan 2026 08:39:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768927178; cv=none;
        d=google.com; s=arc-20240605;
        b=eosfZBlPJcbeg3uNfcDriP9V1OJcIYcogoMcXDEUrzX34dvz7ySGXRGFDpHxwqG2kI
         HBly4PsYYZtkv2nWrhk0F2l+8dxud/aLUyChmNu5BzlPS6ezfaz4f031R3Er21x+dMfp
         oyoYiLsveETyUDZrbgFtgN4NpGukt7VoyMu93BnZcW46GZVNsY8p9RGu5n6KaR3OamBR
         NELp9D1qBVW78lk7qw/5GiAT9lVRSRdPgFRzqP+iyj5H4a24A7NfcELOtWI+hQKy1U95
         4LcoaNFrQOhRAuknI03vAdDeabE8v57g6klRrkXxeiUcokZr9h/psXkhQLZyLdVejO5Z
         qCrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=V/ZdpWXMG+JU47TGO6sM35o1HNuN2rVurUmmqUb6qdk=;
        fh=JlBXWf3RVpgpda9yy9yCsA3wJ3EtqfoNfXFm3WBAybc=;
        b=IvInrFKfYkUQ69OGoJpzl33ixE0rK06JBNd63v8NYoqUeHpUHa3A5MAiJwwEwT160+
         fK+LLovb9yW6PDksbs3PbhqH7DXb7Z0Gz2q5u1NxvHCXg8sd/RAfzlzKi7g41Dik3Ot2
         4OO2zjSxCttEqey+mO7qaGuvivEdMAWsEzaawlFa1XhR/OsixYcNfjUfXrrzFHFje5Bw
         /whNjSjWIFPRc1OUy9DUHKAzl9U/lyqIdrpL+UepbriexgL1/maMKv7nexTJsC4bQBuF
         2MSRJyXKoVegw3etArMiCKWwe9/rSovpdVIK6l+xMSvXmyKdZbPijggj1cIegIbt6YFC
         5o7Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768927178; x=1769531978; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=V/ZdpWXMG+JU47TGO6sM35o1HNuN2rVurUmmqUb6qdk=;
        b=jfoHaV43TXgXJ+DI69gsdMzpFggzzcaj900mQJEiHBYzsGApFG4P3xM3F0XNvamvRQ
         DEgtIQeEE+KsBLIQlPhQ3aXa9k6wtIK//SM9/2G7BD0cFyvUBQNRePlUh4/9OAu/K7gh
         1LF9yRyy4muLdsMHWch/AH4/YBvrrz6KEMc6QN/DZ7wWtuPkAqscQrXwLINOADFEppGA
         xVl3txDgwCztuyPjkpZwZnz8ODW9Fs0NCFgWVtLDGYAC1r032HtvxSF5tbbQ4G/FBY93
         xZH4GyoakK0nHuWfGruYUwgTPOtFkVHhv2WGkEbqeoVuIdF9KUJMKUUimztDLITArY90
         0LoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768927178; x=1769531978;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V/ZdpWXMG+JU47TGO6sM35o1HNuN2rVurUmmqUb6qdk=;
        b=SGp1AclbpJXyuu0Q7Zrt7g1dwMXuNHrKc2XkKpP0QW+cN1df92DbFknKOw0T7wARsc
         RmH5EwsfiuYXswXEHX1uTHeISl0HG99REYEJlekmgGgnYc94j3WBqeFakldl/kdkYqkp
         mtyBaiUz6u7svB9Zg4LXNkjJgGQajbXiQX7BOeoZ0I/j64vpfNX2/gHmJv93zc0Ukkes
         OsjY2e2DrJL892Sz42XWVfhD6fI2LWSukpiAewwk+WjiN/sga5GK0oijV68+0NSyYMvF
         IW3F30VWlvM1s/0gZCReZc9he6M7vuOxB35zOj3GF62lVrHeUVmBCuntBH7fed1iu98f
         htWQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEf5h6/kd3aRwWBwOaf0aX8NqtPg3CP12Ju89a/jC7mshG+MhHGl9T+qIarAkSzPHEe9YPHUjoRJMJ@vger.kernel.org
X-Gm-Message-State: AOJu0YyNddIwX+MaXrAW0M0aNinZZA2denp/WU5c6rd4TleOWuRQL7/y
	x0yqi2epWuGplgW5s6JJxj57GQngVO81hWXiMSSBnc3iJZmF+2cq3hnVrYCql2SGFo8oCaMsiFh
	W5ErWOyfe3wleYR9iYrl6i7PfrtgGWjg=
X-Gm-Gg: AZuq6aINbegHJR+nOW6J3MPTm8m9/ypUEmGE9KYMAc1aV7Jzlw5SrZcpNEQtRj9Ag0R
	iWuuEshTTSIMt6plAAtunv+k3i96FgkJFEfSpOrgiJ6M+4wnSO/s9WkzCmBXfNqPaNS+2OwTFnt
	wG2CMeJvH7P6kTnrnYjePaXfM2/QKGD9MeXvUeWf4MZ8Oo+Q3sOMsNBUPt2Y+px1eQNagN/z5BL
	lfmO3RR6gOSBX27OHNeWmuQUZ3hhQWhrlthDYg2u3siObEbyPbwo5SpTAL6ezPlZKRYUQhg
X-Received: by 2002:a05:6402:1ec4:b0:64d:23ac:6ca6 with SMTP id
 4fb4d7f45d1cf-657f947ba43mr1639474a12.4.1768927177433; Tue, 20 Jan 2026
 08:39:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260117101948.297411-1-dg573847474@gmail.com>
 <ae5cae8b3c4e71cf23b6f48453797ac48bea5914.camel@HansenPartnership.com>
 <CAAo+4rUkmuOruVVVNYePyfqu5OgxUxWupEBwvJg7Aus3g7WDqA@mail.gmail.com>
 <d7040eecadcc3557c04c27f0c74ce40b2885c311.camel@HansenPartnership.com>
 <CAAo+4rX8HT_3zKEQ3vULN-B8StnwsT-7DQPoFCOedZLrMngASQ@mail.gmail.com> <b03e802fce29c90bbc4342e7254c3adb9f48bbf7.camel@HansenPartnership.com>
In-Reply-To: <b03e802fce29c90bbc4342e7254c3adb9f48bbf7.camel@HansenPartnership.com>
From: Chengfeng Ye <dg573847474@gmail.com>
Date: Wed, 21 Jan 2026 00:39:26 +0800
X-Gm-Features: AZwV_QgqmPIPzxNJ3zfLmiE-dCtjMNPbA2k8Z4jkwoKs2XtYNrItWfbSCti7HS8
Message-ID: <CAAo+4rXdBpPTVu0XQvKwUwQUakNgP2ihdfOcz3zO=16wyVnSWw@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm8001: Fix potential TOCTOU race in pm8001_find_tag
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Jack Wang <jinpu.wang@cloud.ionos.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> But this too is a problem: fixes aren't free.  In fact a portion of the
> patches sold as a bug fix eventually turn out to introduce a bug ...
> and that new bug is one we didn't have before.  This is just a sad
> consequence of the fact that all code produced by humans contains bugs.
> The longer code is used, the more chance the bugs are found and the
> less buggy it becomes (even with the bug fixes introducing bugs).  So
> for really old drivers we assume most of the significant bugs have been
> found and we try not to perturb the code base to avoid introducing new
> bugs that, given the small and decreasing user base, will take ages to
> find and eliminate.
>
> On the scale of serious problems in older drivers, theoretical data
> races that cause a crash don't rank highly simply because if the race
> window were significant we'd already have seen it (the detection signal
> is obvious and users aren't shy about reporting driver crashes). That
> makes the probability of encountering the issue in the field way lower
> than the probability that any fix will introduce a new bug.  So the
> balance of risks argues against applying any fix.

Thank you indeed for the detailed response. It helps a lot, appreciate
much of the insightful reply that clarifies my long-standing
confusion...

Best regards,
Chengfeng
