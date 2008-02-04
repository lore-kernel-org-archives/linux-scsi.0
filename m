From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [SCSI] sd: make error handling more robust (v2)
Date: Mon, 4 Feb 2008 01:14:50 -0800 (PST)
Message-ID: <838819.43871.qm@web31812.mail.mud.yahoo.com>
References: <170fa0d20802030714i77d0fd65ka7ff32623da359ae@mail.gmail.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31812.mail.mud.yahoo.com ([68.142.207.75]:34627 "HELO
	web31812.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754031AbYBDJOv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 04:14:51 -0500
In-Reply-To: <170fa0d20802030714i77d0fd65ka7ff32623da359ae@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, Mike Snitzer <snitzer@gmail.com>
Cc: Tony Battersby <tonyb@cybernetics.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>

--- On Sun, 2/3/08, Mike Snitzer <snitzer@gmail.com> wrote:

> From: Mike Snitzer <snitzer@gmail.com>
> Subject: Re: [PATCH] [SCSI] sd: make error handling more robust (v2)
> To: "James Bottomley" <James.Bottomley@hansenpartnership.com>
> Cc: "Tony Battersby" <tonyb@cybernetics.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Luben Tuikov" <ltuikov@yahoo.com>, "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
> Date: Sunday, February 3, 2008, 7:14 AM
> On Feb 2, 2008 5:06 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> >
> > On Fri, 2008-02-01 at 12:03 -0500, Tony Battersby
> wrote:
> > > This patch fixes a problem with some out-of-spec
> SCSI disks that report
> > > hardware or medium errors incorrectly.  Without
> the patch, the kernel
> > > may silently ignore a failed write command or
> return corrupted data on a
> > > failed read command.
> > >
> > > Signed-off-by: Tony Battersby
> <tonyb@cybernetics.com>
> > > ---
> > >
> > > This is a simplified version of the original
> patch that fixes just the
> > > problem at hand, without trying to handle other
> theoretical out-of-spec
> > > cases.
> >
> > Actually, to restore the original check, this is what
> we want, isn't it?
> > Ok, so I also made the sector division logic
> futureproof for the day we
> > have > 4096 sector devices ...
> >
> > James
> >
> > ---
> >
> > >From 5ae2e4a8ff095aab5997f17068d3e4212c33f039 Mon
> Sep 17 00:00:00 2001
> > From: Tony Battersby <tonyb@cybernetics.com>
> > Date: Fri, 1 Feb 2008 12:03:27 -0500
> > Subject: [SCSI] sd: make error handling more robust
> >
> > This patch fixes a problem with some out-of-spec SCSI
> disks that report
> > hardware or medium errors incorrectly.  Without the
> patch, the kernel
> > may silently ignore a failed write command or return
> corrupted data on a
> > failed read command.
> >
> > Signed-off-by: Tony Battersby
> <tonyb@cybernetics.com>
> > Cc: Stable Tree <stable@kernel.org>
> > Signed-off-by: James Bottomley
> <James.Bottomley@HansenPartnership.com>
> 
> I've verified that this patch fixes the 2.6.22.16 SCSI
> IO error
> propagation issue I had when physically pulling a drive
> from an
> enclosure connected to an aacraid controller.

Just as in your case and Tony's case, which I presume
uses the same RAID firmware vendor, it would've
probably been better if the RAID firmware vendor
fixed the firmware to not set the VALID bit if the
INFORMATION field is not valid.

   Luben

