From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: [PATCH] [SCSI] sd: make error handling more robust (v2)
Date: Fri, 1 Feb 2008 19:43:54 -0500
Message-ID: <170fa0d20802011643u600c4386wb801c0490800ea5f@mail.gmail.com>
References: <47A350DF.5020404@cybernetics.com>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F43976569D@ADPE2K703.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.244]:37315 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760837AbYBBAn4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2008 19:43:56 -0500
Received: by hs-out-2122.google.com with SMTP id 54so1096149hsz.5
        for <linux-scsi@vger.kernel.org>; Fri, 01 Feb 2008 16:43:55 -0800 (PST)
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F43976569D@ADPE2K703.adaptec.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>, stable@kernel.org
Cc: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>, Tony Battersby <tonyb@cybernetics.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Luben Tuikov <ltuikov@yahoo.com>

Hi Greg,

Given your recent call for review of the next 2.6.22-stable I'd
appreciate it if you and the rest of the stable team would strongly
consider this SCSI IO error propagation fix for inclusion in 2.6.22.17
(as well as the other stable trees).

please advise, thanks.
Mike


On Feb 1, 2008 3:47 PM, Salyzyn, Mark <Mark_Salyzyn@adaptec.com> wrote:
> ACK
>
> Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
>
> Mike Snitzer tested this also in conjunction with the aacraid driver and it resolved the error propagation problem he experienced with MD on a 2.6.22.16 kernel, recommend that this also be added to any stabilization for these other kernels. By his permission:
>
> Signed-off-by: Mike Snitzer <snitzer@gmail.com>
>
> Sincerely -- Mark Salyzyn
>
> > -----Original Message-----
> > From: Tony Battersby [mailto:tonyb@cybernetics.com]
> > Sent: Friday, February 01, 2008 12:03 PM
> > To: linux-scsi@vger.kernel.org; James Bottomley
> > Cc: Luben Tuikov; Salyzyn, Mark
> > Subject: [PATCH] [SCSI] sd: make error handling more robust (v2)
> >
> > This patch fixes a problem with some out-of-spec SCSI disks
> > that report
> > hardware or medium errors incorrectly.  Without the patch, the kernel
> > may silently ignore a failed write command or return
> > corrupted data on a
> > failed read command.
> >
> > Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
> > ---
> >
> > This is a simplified version of the original patch that fixes just the
> > problem at hand, without trying to handle other theoretical
> > out-of-spec
> > cases.
> >
> > Applies to kernels 2.6.18 - 2.6.24-git10+.
> >
> > --- linux-2.6.24-git10/drivers/scsi/sd.c.orig   2008-02-01
> > 11:24:37.000000000 -0500
> > +++ linux-2.6.24-git10/drivers/scsi/sd.c        2008-02-01
> > 11:26:12.000000000 -0500
> > @@ -990,6 +990,8 @@ static int sd_done(struct scsi_cmnd *SCp
> >                 /* This computation should always be done in terms of
> >                  * the resolution of the device's medium.
> >                  */
> > +               if (bad_lba < start_lba)
> > +                       goto out;
> >                 good_bytes = (bad_lba -
> > start_lba)*SCpnt->device->sector_size;
> >                 break;
> >         case RECOVERED_ERROR:
> >
> >
> >
>
