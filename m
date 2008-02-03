From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: [PATCH] [SCSI] sd: make error handling more robust (v2)
Date: Sun, 3 Feb 2008 10:14:57 -0500
Message-ID: <170fa0d20802030714i77d0fd65ka7ff32623da359ae@mail.gmail.com>
References: <47A350DF.5020404@cybernetics.com>
	 <1201989983.3187.55.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.245]:29422 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752955AbYBCPPA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Feb 2008 10:15:00 -0500
Received: by hs-out-2122.google.com with SMTP id 54so1613329hsz.5
        for <linux-scsi@vger.kernel.org>; Sun, 03 Feb 2008 07:14:59 -0800 (PST)
In-Reply-To: <1201989983.3187.55.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Tony Battersby <tonyb@cybernetics.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Luben Tuikov <ltuikov@yahoo.com>, "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>

On Feb 2, 2008 5:06 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> On Fri, 2008-02-01 at 12:03 -0500, Tony Battersby wrote:
> > This patch fixes a problem with some out-of-spec SCSI disks that report
> > hardware or medium errors incorrectly.  Without the patch, the kernel
> > may silently ignore a failed write command or return corrupted data on a
> > failed read command.
> >
> > Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
> > ---
> >
> > This is a simplified version of the original patch that fixes just the
> > problem at hand, without trying to handle other theoretical out-of-spec
> > cases.
>
> Actually, to restore the original check, this is what we want, isn't it?
> Ok, so I also made the sector division logic futureproof for the day we
> have > 4096 sector devices ...
>
> James
>
> ---
>
> >From 5ae2e4a8ff095aab5997f17068d3e4212c33f039 Mon Sep 17 00:00:00 2001
> From: Tony Battersby <tonyb@cybernetics.com>
> Date: Fri, 1 Feb 2008 12:03:27 -0500
> Subject: [SCSI] sd: make error handling more robust
>
> This patch fixes a problem with some out-of-spec SCSI disks that report
> hardware or medium errors incorrectly.  Without the patch, the kernel
> may silently ignore a failed write command or return corrupted data on a
> failed read command.
>
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
> Cc: Stable Tree <stable@kernel.org>
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

I've verified that this patch fixes the 2.6.22.16 SCSI IO error
propagation issue I had when physically pulling a drive from an
enclosure connected to an aacraid controller.

Tested-by: Mike Snitzer <snitzer@gmail.com>

Mike
