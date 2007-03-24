From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [-mm patch] drivers/scsi/constants.c: make 2 functions static
Date: Sat, 24 Mar 2007 18:02:06 +0100
Message-ID: <20070324170206.GB2078@stusta.de>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <20070324130647.GI752@stusta.de> <46054D99.8070705@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33518 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932286AbXCXRCE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Mar 2007 13:02:04 -0400
Content-Disposition: inline
In-Reply-To: <46054D99.8070705@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, Mar 24, 2007 at 12:11:05PM -0400, Douglas Gilbert wrote:
> Adrian Bunk wrote:
> > On Mon, Mar 19, 2007 at 08:56:23PM -0800, Andrew Morton wrote:
> >> ...
> >> Changes since 2.6.21-rc3-mm1:
> >> ...
> >>  git-scsi-misc.patch
> >> ...
> >>  git trees
> >> ...
> > 
> > 
> > This patch makes two needlessly global functions static.
> > 
> > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> > 
> > ---
> > 
> >  drivers/scsi/constants.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > --- linux-2.6.21-rc4-mm1/drivers/scsi/constants.c.old	2007-03-23 23:26:39.000000000 +0100
> > +++ linux-2.6.21-rc4-mm1/drivers/scsi/constants.c	2007-03-23 23:26:55.000000000 +0100
> > @@ -1235,7 +1235,7 @@
> >  }
> >  EXPORT_SYMBOL(scsi_print_sense_hdr);
> >  
> > -void
> > +static void
> >  scsi_decode_sense_buffer(const unsigned char *sense_buffer, int sense_len,
> >  		       struct scsi_sense_hdr *sshdr)
> >  {
> > @@ -1258,7 +1258,7 @@
> >  	}
> >  }
> >  
> > -void
> > +static void
> >  scsi_decode_sense_extras(const unsigned char *sense_buffer, int sense_len,
> >  			 struct scsi_sense_hdr *sshdr)
> >  {
> 
> Adrian,
> Who put those functions in?



[SCSI] constants.c: cleanup, verbose result printing

From: Martin K. Petersen

Clean up constants.c and make result printing more user friendly:

 - Refactor the command and sense functions so that the actual
   formatting can be called from the various helper functions with the
   correct prefix.

 - Replace scsi_print_hostbyte() and scsi_print_driverbyte() with
   scsi_print_result() which is verbose when CONFIG_SCSI_CONSTANTS is
   on.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>



> The names and arguments look very similar to these
> exported functions in scsi_error.c *** :
>   scsi_normalize_sense
>   scsi_sense_desc_find
>   scsi_get_sense_info_fld
> 
> that I can see in 2.6.21-rc4
> 
> The proposed scsi_decode_sense_buffer() looks broken because
> it can fail and should return an int reflecting that.
> How scsi_decode_sense_extras() works is intriguing, unless
> struct scsi_sense_hdr has been changed as well.
> 
> 
> *** Putting sense decode logic in scsi_error.c is wrong
> because:
>   - the ATA command set is proposing an ATA REQUEST SENSE
>     command to yield a sense buffer
>   - sense buffers don't necessarily indicate errors.
> 
> So moving those functions out of scsi_error.c IMO is a
> good idea. Breaking them in the move isn't.
> 
> Doug Gilbert
> 

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

