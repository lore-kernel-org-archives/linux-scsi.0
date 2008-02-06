From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH 1/1] aacraid: do not set valid bit in sense information
Date: Wed, 6 Feb 2008 14:19:36 -0800 (PST)
Message-ID: <560371.69680.qm@web31807.mail.mud.yahoo.com>
References: <532ABFBDAAC3A34EB12EBA6CEC2838F43982A08C@ADPE2K703.adaptec.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31807.mail.mud.yahoo.com ([68.142.207.70]:40123 "HELO
	web31807.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755314AbYBFWTh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2008 17:19:37 -0500
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F43982A08C@ADPE2K703.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Cc: Tony Battersby <tonyb@cybernetics.com>, Mike Snitzer <snitzer@gmail.com>

--- On Wed, 2/6/08, Salyzyn, Mark <Mark_Salyzyn@adaptec.com> wrote:

> From: Salyzyn, Mark <Mark_Salyzyn@adaptec.com>
> Subject: [PATCH 1/1] aacraid: do not set valid bit in sense information
> To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
> Cc: "Tony Battersby" <tonyb@cybernetics.com>, "ltuikov@yahoo.com" <ltuikov@yahoo.com>, "Mike Snitzer" <snitzer@gmail.com>
> Date: Wednesday, February 6, 2008, 1:54 PM
> Luben Tuikov [mailto:ltuikov@yahoo.com] sez:
> > Just as in your case and Tony's case, which I
> presume
> > uses the same RAID firmware vendor, it would've
> > probably been better if the RAID firmware vendor
> > fixed the firmware to not set the VALID bit if the
> > INFORMATION field is not valid.
> 
> Point taken regarding the aacraid driver. Dropped the VALID
> bit, and then did some cleanup/simplification of the
> set_sense procedure and the associated parameters. Mike did
> some preliminary tests when the VALID bit was dropped before
> the 'Re: [PATCH] [SCSI] sd: make error handling more
> robust' patches came on the scene. The change in the
> SCSI subsystem does make this enclosed aacraid patch
> unnecessary, so this aacraid patch is merely post battle
> ground cleanup. If the simplification is an issue,
> repugnant, too much for a back-port to the stable trees or
> clouds the point, this patch could be happily distilled
> down to:

Sounds good.

   Luben

> 
> diff -ru a/drivers/scsi/aacraid/aachba.c
> b/drivers/scsi/aacraid/aachba.c
> --- a/drivers/scsi/aacraid/aachba.c     2008-02-06
> 16:26:45.834938955 -0500
> +++ b/drivers/scsi/aacraid/aachba.c     2008-02-06
> 16:32:01.109035329 -0500
> @@ -865,7 +865,7 @@
>                          u32 residue)
>  {
> -        sense_buf[0] = 0xF0;    /* Sense data valid, err
> code 70h (current error) */
> +        sense_buf[0] = 0x70;    /* Sense data invalid, err
> code 70h (current error) */
>          sense_buf[1] = 0;       /* Segment number, always
> zero */
> 
>          if (incorrect_length) {
> 
> This patch is against current scsi-misc-2.6
> 
> ObligatoryDisclaimer: Please accept my condolences
> regarding Outlook's handling of patch attachments.
> Please use the attached patch and not any inline content.
> 
> Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
> 
>  drivers/scsi/aacraid/aachba.c |   81
> +++++++++++++++---------------------------
>  1 file changed, 30 insertions(+), 51 deletions(-)
> 
> Sincerely -- Mark Salyzyn
