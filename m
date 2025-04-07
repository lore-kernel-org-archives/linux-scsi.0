Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DBF20898C;
	Mon,  7 Apr 2025 18:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744051079; cv=none; b=DZSh3YySGx6A9jhvkfbeFIRExZlziBB11HZgSJ5GBL/g2+2Ahq/ItZgZi3AgqYQZmJ2uGNfKxQ5wlKhOT2RFL0a7U7/x08fuIU7Q9uumMzqtF1o2vuu7hsLGLiQN3T1hUeHrB2ckakJSoKUAmlq9K+CyK+Fxh2BxrCcBnlO293Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744051079; c=relaxed/simple;
	bh=q8KGRHuOSc7xz+NvnDVSZTtg4Ny5rvebOBGvxJwpKoA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LRPQgSO/AfgQzbw1yfsOdIdeLGb82nwIF66J7AX6MGICVe/ebU5blPYU7FM57f5YCfrK/nUdgbDd9d4O+hk4b4QYbvcOrD5atPhZwu4n9KVPKDeVRCVfHW8O4Hi/m9LCfl0RDtD8RbnzxnHOMjHhPbycp9qzvdwA0Orx2AF6Md4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ioosVxHw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ioosVxHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4FFC4CEE7;
	Mon,  7 Apr 2025 18:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744051078;
	bh=q8KGRHuOSc7xz+NvnDVSZTtg4Ny5rvebOBGvxJwpKoA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ioosVxHwp9x00u08Cn5gP67i2I2QTE8nn/V7eABcJLZ208uAciSoGlHpwjko8caex
	 9p6E/gi7PUgZGMFYH7dJ7SGVQLhSdnEITtI6yA0jqH9Fd72aqK3kdjKRyFMqIp8wGz
	 /PP5c7HJ40hsljDWrK141AexKB1W6P5r9z3KIiuGJYzYL1Updn1tfea1Aw/WcyUV/y
	 4axj+EPV37kPDwxM0VdSiBjbyF6rBiLsiKh7lhbRJbHAoC9XnI1MyXQ1H1sknPM4wn
	 W3p2dL9xp4RhHizRXFE6JV908quBesbaOhGhOztsbdSZ7aav4M/t/EQ9avsAplPOAP
	 OE4AjbwEpMd2w==
Date: Mon, 7 Apr 2025 11:37:54 -0700
From: Kees Cook <kees@kernel.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: pm80xx: Add __nonstring annotations for
 unterminated strings
Message-ID: <202504071136.73E5C22D0B@keescook>
References: <20250310222553.work.437-kees@kernel.org>
 <98ca3727d65a418e403b03f6b17341dbcb192764.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <98ca3727d65a418e403b03f6b17341dbcb192764.camel@HansenPartnership.com>

On Mon, Mar 10, 2025 at 06:38:01PM -0400, James Bottomley wrote:
> On Mon, 2025-03-10 at 15:25 -0700, Kees Cook wrote:
> > When a character array without a terminating NUL character has a
> > static
> > initializer, GCC 15's -Wunterminated-string-initialization will only
> > warn if the array lacks the "nonstring" attribute[1]. Mark the arrays
> > with __nonstring to and correctly identify the char array as "not a C
> > string" and thereby eliminate the warning.
> > 
> > Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=117178 [1]
> > Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
> > Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> > Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> > Cc: linux-scsi@vger.kernel.org
> > Signed-off-by: Kees Cook <kees@kernel.org>
> > ---
> >  drivers/scsi/pm8001/pm8001_ctl.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/pm8001/pm8001_ctl.c
> > b/drivers/scsi/pm8001/pm8001_ctl.c
> > index 85ff95c6543a..7618f9cc9986 100644
> > --- a/drivers/scsi/pm8001/pm8001_ctl.c
> > +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> > @@ -644,7 +644,7 @@ static DEVICE_ATTR(gsm_log, S_IRUGO,
> > pm8001_ctl_gsm_log_show, NULL);
> >  #define FLASH_CMD_SET_NVMD    0x02
> >  
> >  struct flash_command {
> > -     u8      command[8];
> > +     u8      command[8] __nonstring;
> 
> This looks a bit suboptimal ... is there anywhere in the kernel u8[] is
> actually used for real strings?  In which case it would seem the better
> place to put the annotation is in the typedef for u8 arrays.

I answered this in a merged thread[1]. Can this get picked up?

Thanks!

-Kees

[1] https://lore.kernel.org/lkml/202503111520.CF7527A@keescook/

-- 
Kees Cook
