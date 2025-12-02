Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B202E30FF29
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 11:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764675680; cv=none; b=pGw3myRKobqCOlj8TNK1//XTUmKEZ73SUouggj+UcAn8tnCMdYbhJUSYNvoHcX4naKfdvDyiqghl+Jk9nmS6M+7gFDqD+IvOr6y0yG6oxYxzhL9cI1SRB7f9CHXY0YP4+ATBXPNZYRJq/6yQE3QA/MvLBUdKTqz3PkIi7A/yN2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764675680; c=relaxed/simple;
	bh=ipGNmED1zbA8kqk9esjfRm9CpG2tH2cR+aN89hb/KB4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oswmEYIJP2xRGb4d7cak8xvchvf+8ESOpfbiHsPtdr2WOIcC8K2ii8i5bnnkulUSl2t8erF8lWGBmmQwvnsHnrTHGw0sF88fT50esrupYIjYy4b3Rj0O4QfAPPYVfh3FNGgBh46HyY5vzj1Wk324YF9M4YW64f3qM4RzcZKJxQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xIaIKVVE; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xIaIKVVE"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-4511744b411so2633693b6e.3
        for <linux-scsi@vger.kernel.org>; Tue, 02 Dec 2025 03:41:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764675678; x=1765280478; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9HTffDhZfMl7dljduVQCtnVLpLoh5qz7fMTD1xlJDec=;
        b=xIaIKVVERyTJXtQTYVCUYV/fwKucbhF0YPV7RPgWesWQuOknXxdKy48hKFc7o1l/m4
         K+Xd+b3lFjMIKWIGVF9jr19GSxpTAFUe/swbX0NDjJeYfHJ7qLHqk8HCjos+14FH0sXM
         MdUfNtOJYD9p6pbrisIkJldexxTCTzQ2xT0kQDYrqakw3IXdVc5+lG7trCIIBL5fAx3T
         CBqTV2xriBWuDsD0o+FV+U8C135P2pkOpVNL9kVmJhdn45TkapuOISjV100sJtFasQ76
         wSPWYOU+mfc6ekKI88snUOe7admocoUEEeUWd1QP1flNLl3F41EG1gjV23Jwbv2PkksC
         oruw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764675678; x=1765280478;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9HTffDhZfMl7dljduVQCtnVLpLoh5qz7fMTD1xlJDec=;
        b=nxSZsePEZzPQvFhLCiWGAk9TNjosGITS0MMQgtZOWMjJ+HMxdhOBfpZuoe24dSl+u/
         3c0LJqVAeWtpD9j3um8g5C+rT4CMiJ86TqGs0npv/Aqd9QwELgTeeY3VuMW6pxdvd8W6
         JrlXGNDOP4FEtWbbTg8Ewf/3NSzgWT9UgRRlGO9vbUWIQToJ4fqIXoiFXqiMUVOci/9k
         mpAociEJxvEneEBeJ0Qcno6NgHVhGqjDmTxZ0VkwVh0lIOYIZbGeZyQj12ttQXlK1LGO
         ZSLbeBdHJVFbq+gAeyHurC6IIyWT7uEhbRgQ2rC91C33TkIxRmow+3WG+OGLhPZiN2Ud
         IqdQ==
X-Forwarded-Encrypted: i=1; AJvYcCUldAIVl479Q/CCvI9EV3r9gahxKdgKg4nYWDaTD46NV60weAWUNGDcrnn/cL/uTrCbIRcl8dkxMb8E@vger.kernel.org
X-Gm-Message-State: AOJu0YyFdW3RD19KtA04deWBJ0jT0/qpW67Jf+OJPt+Gjl/gfVPN6k1S
	g3kPU3+J/7YGtiOVoml/zDJyDxJCo3pxrPZuDhyzTulBXUJE21rL/LuScZjpqz8Wack/CExpZem
	xN4+wODXTZyls3ZZv1s2xHdQMyZ5zyovfoEkIxq2S7g==
X-Gm-Gg: ASbGncu6A7VW/GRT73grk0E+vjxBXC0rX7oRiVQjN4MzaAyGcOsW4CAWj2lTSGQD1KC
	e+XDEExf8KEDFhkLo2NRhIS/nNkvsEsLy1BtcoCgLkhztZVllXtOErxvSRl+BCwqwbmk95UagZ6
	IpSZORS3EvXpl0SngnSTOHIBmT1/WdzEJS0abRzjyNK5Kzn7EGqp6PHkUUEeVB8haWhDoiZGROt
	x73/+MAX2FAsnD6WVb/IX06LxjBxaE8AW21XuP3Lru0WQy6+DjLqwCeZgEfSZTEgu19VM/8LWBu
	3lICB89GM7JgI/8bOfJ0tvfxkoFsBLFWOduV
X-Google-Smtp-Source: AGHT+IGjxKNTjjCnMR8lIt5wSMQ84tFYdNUsiIZRKWZ7yRiY4FSl26ATiTe5ZxwpmlNQC8eH27fIfufJVChB4hm83a4=
X-Received: by 2002:a05:6808:3007:b0:450:aba0:f006 with SMTP id
 5614622812f47-4514e65b6bamr13200588b6e.17.1764675677660; Tue, 02 Dec 2025
 03:41:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251130151508.3076994-1-beanhuo@iokpp.de> <yq1seduunc2.fsf@ca-mkp.ca.oracle.com>
 <251eb7e20d91ae9c539bde847ea102a53af82b94.camel@iokpp.de> <ef4f3e29-95ad-4094-9742-c37742da26e9@acm.org>
 <aff12099702c07370b069b1bb111302ec4660ad1.camel@iokpp.de>
In-Reply-To: <aff12099702c07370b069b1bb111302ec4660ad1.camel@iokpp.de>
From: Jens Wiklander <jens.wiklander@linaro.org>
Date: Tue, 2 Dec 2025 12:41:05 +0100
X-Gm-Features: AWmQ_bnVUHIY1xA_MAPnjPfF7dX9OAdxn6ZY8EZEL66HmZx-MPFDNIzhErW4Ui8
Message-ID: <CAHUa44E5-c_rN1omhuVteBt9idz_d91r1tRKNgB2=-AWQDP2Jw@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix link error when CONFIG_RPMB=m
To: Bean Huo <beanhuo@iokpp.de>
Cc: Bart Van Assche <bvanassche@acm.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	avri.altman@sandisk.com, alim.akhtar@samsung.com, jejb@linux.ibm.com, 
	can.guo@oss.qualcomm.com, beanhuo@micron.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Dec 2, 2025 at 10:13=E2=80=AFAM Bean Huo <beanhuo@iokpp.de> wrote:
>
> On Mon, 2025-12-01 at 16:53 -0800, Bart Van Assche wrote:
> > On 12/1/25 2:42 PM, Bean Huo wrote:
> > > On Mon, 2025-12-01 at 12:25 -0500, Martin K. Petersen wrote:
> > > > > When CONFIG_SCSI_UFSHCD=3Dy and CONFIG_RPMB=3Dm, the kernel fails=
 to link
> > > > > with undefined references to ufs_rpmb_probe() and ufs_rpmb_remove=
():
> > > > >
> > > > >    ld: drivers/ufs/core/ufshcd.c:8950: undefined reference to
> > > > > `ufs_rpmb_probe'
> > > > >    ld: drivers/ufs/core/ufshcd.c:10505: undefined reference to
> > > > > `ufs_rpmb_remove'
> > > > >
> > > > > The issue occurs because IS_ENABLED(CONFIG_RPMB) evaluates to tru=
e
> > > > > when CONFIG_RPMB=3Dm, causing the header to declare the real func=
tion
> > > > > prototypes.
> > > >
> > > > This now breaks the modular build for me.
> > >
> > > I tested both IS_BUILTIN and IS_REACHABLE for the RPMB dependencies b=
oth
> > > work
> > > correctly in my configuration.
> > >
> > > IS_REACHABLE would provide more flexibility for module configurations=
, but
> > > in
> > > practice, I don't have experience with UFS being used as a module.
> > >
> > > Would you prefer IS_REACHABLE for theoretical flexibility, or is IS_B=
UILTIN
> > > acceptable given the typical UFS built-in configuration?
> >
> > Hi Martin and Bean,
> >
> > Unless someone comes up with a better solution, I propose to apply this
> > patch before sending a pull request to Linus and look into making RPMB
> > tristate again at a later time:
> >
> > diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> > index 9d1de68dee27..e0b7f8fb6ecb 100644
> > --- a/drivers/misc/Kconfig
> > +++ b/drivers/misc/Kconfig
> > @@ -105,7 +105,7 @@ config PHANTOM
> >           say N here.
> >
> >   config RPMB
> > -       tristate "RPMB partition interface"
> > +       bool "RPMB partition interface"
> >         depends on MMC || SCSI_UFSHCD
> >         help
> >           Unified RPMB unit interface for RPMB capable devices such as =
eMMC
> > and
> >
> > Thanks,
> >
> > Bart.
>
> Hi Bart, Martin, (and Jens - adding you to this thread),
>
> Bart, thanks for the proposed solution to change RPMB from tristate
> to bool. This makes sense given our use case that UFS is typically
> built-in, and RPMB should follow the same pattern.
>
>
> Hi Jens,
>
> we wanted to make sure you're aware of this proposed change. The reasonin=
g is:
> 1, avoids module dependency complexity between UFS and RPMB
> 2, matches typical usage where both are built-in
>
> Let me know if there are concerns with making RPMB bool instead of trista=
te.

We use "depends on RPMB || !RPMB" in drivers/tee/optee/Kconfig and
drivers/mmc/core/Kconfig to handle this problem. Could the same
pattern be used here?

Cheers,
Jens
