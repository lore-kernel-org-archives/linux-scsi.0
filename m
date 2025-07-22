Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9472C238C1F
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 21:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753220220; cv=none; b=MyO9zZacDaNZsMbZyhcUarn3C37kxmeZq0dTNfzSddw0P/LzYTUSyEYp/ktPfrxiqjKXQ9IMJsaF/0HEm5C4/LyMvzQEBV9TEe1dlTpt4Lmpt9EcbkUaVVCKiCKrpqlC9O8+phrYkNrxHkxQJi5c7hdT+B5ovX/VSPV3gQvfemY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753220220; c=relaxed/simple;
	bh=YO+QT0QrTtIUzwI07JKAwzmUxUrTf8fjGkBBSLuXK/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JyjAKE2e7hTzCetGuW45z7BFBvBp1BsAst6OJekNWc7Jh5u6cd7KmBCyWWtLffPfrT6AMZm0SOCoUGE7fQorw8SUpie1pHBR1AObMKp+zHBlw4toSNqhURiZhWbs50pazVJwthjUfLy4OxIMi6gl4AQbWvy1zm1ykIU2jik4FTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FmSB9Ij2; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FmSB9Ij2"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-237f18108d2so63855ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 14:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753220218; x=1753825018; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I7wjCY+Z7aogSgB0olKQb24xwsoM1JiEPp20xvwYl4o=;
        b=FmSB9Ij2/me4qxcLLPsJUXCDIFBABB4NdzOB3US3i5181JUOY2q/MNH7C9YhGoyYEq
         ODMsRTHx3JQSZQ7SZbbCjKe979hH1+BySNTsz/obYTYbi+RRryvq3+tIEVHR4dqIClJl
         LI5S7Y1R7btHP1KPKN0oZ6CbYIf6v6LDjWn8nHjj98dzHjobLm2ScI9ZGtUclvQDOlsh
         XrfrKOecMvVtTgajNDz4Q32+0vM5Xth+iBhcklpzR+2TSE1XU6U7T7m/tgPOMNkBx02a
         NHVLgSHAAv944NjLRiIDiFfOgY57omRrpo37/BGA5xGQ6UWvq4ctg1iMVgWZgea1bXIy
         n90g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753220218; x=1753825018;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I7wjCY+Z7aogSgB0olKQb24xwsoM1JiEPp20xvwYl4o=;
        b=FCzAc0/2Nf7Qu63Wm+FQYwPUs3AvDRZWG4Udata3mOwqOQ5RK2J01xJxyBUs6pxJsK
         940j16X2uHCopNhUJ/lBZC1WA5g4kJOYg/U0TQ9j8jr7tkAopVCyNctY7Mh30+X4Oodi
         nG7/JA6G8181xH9eSCxEfJ3T0nI18g5Qt3F/4EJx3BBBF3zcsK6O/Xu/VI57aWRQiWqc
         Clmzy7qk1SNJ0VHMIZlP1gt52sX2oDpKREgiKPaZF2owvKpYinTw/Bf+q6h6CxOpV4Ur
         RRut06XcOy93AIg6lqD5sO517WKVFtxfkfNQKfNyXmTlRPMEA4SV8goALlxG6p+LlXCq
         8mLQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZ8KQUnoD35HxgEBBRiTY3yHBd4AWe8NDmq20by8HBKpy8faBqO1Q8MfbcK/q10elx8/6kfWgoAsuA@vger.kernel.org
X-Gm-Message-State: AOJu0YyRE2+iw4NTt6ixJmfc6D9QfBHVskw6lj94CEs1uWli5F64HuqF
	mrjP8zb6LjJJkGVqHTrNPyjF+52Nal5aY1XfsqdsXWHLQKwjvQ6GCvUr5dRlbsG0+g==
X-Gm-Gg: ASbGncvW+kVAEUeM+VBoefEbdsUTpEd17KQdz9Yl96MRfAf+sIyaARpST8oshs93e3B
	ekostKtQzrPc69piCrM965mNAZMRoFEeewMYV5zvAfXzDIzduq4V2NZzJ654w3Mh4cLSuGqHR6y
	MD3BqSwmDxpcqVe7//sqRqoSz9RBKxdz21A8U6ol0guTUu37kHJHhKE13Elo/ODKhkrHn3sfGVk
	7Xvd4FO8WpFddmxkY0jyJRyKzoIW7nCPk/ohAQ4Y7vplgBhm3dU1doeGT00Xde0oVh6vtvdDakq
	J+aWhYznYR2yx8tHX40t04Vf8ZbggYiL+89ytoj4N9sdOSo+48SqRY1H4YTEGKHzeOM69okuVLg
	FLFUdE2t75B3lUpWRegNuk74z0ad1ZmowkJofWjJrCLjyAeG4ilDsv7tbYDuO+qF3NSPh
X-Google-Smtp-Source: AGHT+IGGK+DAxs1GzSoXbQ2grgS4mpN1wVP0262WRd7SOctPda8IkUhMYYB7UIWHojx5EJ21zchK5Q==
X-Received: by 2002:a17:902:f785:b0:234:48b2:fd63 with SMTP id d9443c01a7336-23f98ddd071mr319505ad.21.1753220217386;
        Tue, 22 Jul 2025 14:36:57 -0700 (PDT)
Received: from google.com (166.68.83.34.bc.googleusercontent.com. [34.83.68.166])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-75f89054d32sm1582230b3a.85.2025.07.22.14.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jul 2025 14:36:56 -0700 (PDT)
Date: Tue, 22 Jul 2025 14:36:52 -0700
From: Igor Pylypiv <ipylypiv@google.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Niklas Cassel <cassel@kernel.org>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Terrence Adams <tadamsjr@google.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Revert "scsi: pm80xx: Do not use libsas port ID"
Message-ID: <aIAEdNN88utN4sQJ@google.com>
References: <20250717165606.3099208-2-cassel@kernel.org>
 <aHlpNRsPbmrTgv0O@google.com>
 <a09dea31-0de3-4859-95d9-2d83fc1ccc73@kernel.org>
 <aHrLBPunX8Fuv1zz@google.com>
 <70d2f593-3121-4684-8632-6a4ea1dc72ea@kernel.org>
 <5056b88b-0f42-4a02-906f-197492d76827@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5056b88b-0f42-4a02-906f-197492d76827@kernel.org>

On Tue, Jul 22, 2025 at 01:25:47PM +0900, Damien Le Moal wrote:
> On 7/22/25 10:28 AM, Damien Le Moal wrote:
> > On 7/19/25 7:30 AM, Igor Pylypiv wrote:
> >> Hey Niklas,
> >>
> >> Could you try the following fix with your expander setup, please?
> >> The fix assumes the problematic patch is not yet revered.
> >>
> >> $ git diff
> >> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> >> index f7067878b34f..cd9513c23c71 100644
> >> --- a/drivers/scsi/pm8001/pm8001_sas.c
> >> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> >> @@ -503,7 +503,7 @@ int pm8001_queue_command(struct sas_task *task, gfp_t gfp_flags)
> >>         spin_lock_irqsave(&pm8001_ha->lock, flags);
> >>  
> >>         pm8001_dev = dev->lldd_dev;
> >> -       port = pm8001_ha->phy[pm8001_dev->attached_phy].port;
> >> +       port = dev->port->lldd_port;
> >>  
> >>         if (!internal_abort &&
> >>             (DEV_IS_GONE(pm8001_dev) || !port || !port->port_attached)) {
> > 
> > Igor,
> > 
> > I tested this, or rather, a variation of it that clean things up at the same time:
> > 
> > diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> > index f7067878b34f..753c09363cbb 100644
> > --- a/drivers/scsi/pm8001/pm8001_sas.c
> > +++ b/drivers/scsi/pm8001/pm8001_sas.c
> > @@ -477,7 +477,7 @@ int pm8001_queue_command(struct sas_task *task, gfp_t
> > gfp_flags)
> >         struct pm8001_device *pm8001_dev = dev->lldd_dev;
> >         bool internal_abort = sas_is_internal_abort(task);
> >         struct pm8001_hba_info *pm8001_ha;
> > -       struct pm8001_port *port = NULL;
> > +       struct pm8001_port *port;
> >         struct pm8001_ccb_info *ccb;
> >         unsigned long flags;
> >         u32 n_elem = 0;
> > @@ -502,8 +502,7 @@ int pm8001_queue_command(struct sas_task *task, gfp_t
> > gfp_flags)
> > 
> >         spin_lock_irqsave(&pm8001_ha->lock, flags);
> > 
> > -       pm8001_dev = dev->lldd_dev;
> > -       port = pm8001_ha->phy[pm8001_dev->attached_phy].port;
> > +       port = dev->port->lldd_port;
> > 
> >         if (!internal_abort &&
> >             (DEV_IS_GONE(pm8001_dev) || !port || !port->port_attached)) {
> > 
> > 
> > And it works, I can see the drives in the enclosure behind the expander.
> > Care to send a proper path ?
> > 
> > I think this needs more testing though, especially special cases like yanking
> > the SAS cable and doing device hotplug/unplug. Will do that later today.
> 
> So I did that. And things are not pretty... Even a simple "rmmod pm80xx"
> crashes the kernel on a bad pointer dereference (invalid port address). Same if
> I hot-unplug drives from the enclosure. But that happens even with only Niklas
> revert patch applied. So I think that is unrelated to this change.
> 
> That said, I will dig further to understand how the port pointers become
> invalid, and make sure this change is OK. Note that there are no issues that I
> can see when there is no expander (drives directly attached to the HBA).

Thank you for testing, Damien!

Just guessing, would defining the lldd_port_deformed() callback help?
The callback can set lldd_port to NULL if the problem is due to a dangling
lldd_port pointer.

Thanks,
Igor

> 
> Cheers.
> 
> 
> -- 
> Damien Le Moal
> Western Digital Research
