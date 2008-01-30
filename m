From: Geert Uytterhoeven <Geert.Uytterhoeven-osDt5Q4Chk1BDgjK7y7TUQ@public.gmane.org>
Subject: Re: [BUG] 2.6.24-git usb reset problems
Date: Wed, 30 Jan 2008 11:27:47 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801301125350.26562@vixen.sonytel.be>
References: <20080128204935.GI15220@kernel.dk> <479F32E9.10609@panasas.com>
 <20080129141108.GV15220@kernel.dk> <200801291531.39825.oliver@neukum.org>
 <20080129143109.GW15220@kernel.dk> <20080129183910.GI15220@kernel.dk>
 <20080129191024.GO14375@one-eyed-alien.net> <1201635195.3069.36.camel@localhost.localdomain>
 <20080129193520.GQ15220@kernel.dk> <20080129194543.GR15220@kernel.dk>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-829811562-1201688867=:26562"
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20080129194543.GR15220-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Matthew Dharm <mdharm-kernel-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, Oliver Neukum <oliver-GvhC2dPhHPQdnm+yROfE0A@public.gmane.org>, Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-829811562-1201688867=:26562
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 29 Jan 2008, Jens Axboe wrote:
> On Tue, Jan 29 2008, Jens Axboe wrote:
> > On Tue, Jan 29 2008, James Bottomley wrote:
> > > On Tue, 2008-01-29 at 11:10 -0800, Matthew Dharm wrote:
> > > > For some reason, usb_sg_init is boned during auto-sense.
> > > 
> > > OK, that's implicating the scsi_eh_prep_cmnd() in the auto sense
> > > code ... that was also an update in 2.6.24
> > 
> > yeah, already found the bug - it's assuming ->request_buffer holds the
> > sglist, oops. Preparing a fix.
> 
> ok here goes, this saves and restores the sg table correctly. it also
> fixes the usb bug for me.

I can confirm this patch fixes the errors I was seeing with current
linux-2.6.git for the USB memory card readers in a Dell TFT connected to a PS3.

> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 547e85a..12770ef 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -622,13 +622,15 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
>  	ses->use_sg = scmd->use_sg;
>  	ses->resid = scmd->resid;
>  	ses->result = scmd->result;
> +	memcpy(&ses->sense_sgl, &scmd->sg_table, sizeof(ses->sense_sgl));
>  
>  	if (sense_bytes) {
>  		scmd->request_bufflen = min_t(unsigned,
>  		                       SCSI_SENSE_BUFFERSIZE, sense_bytes);
>  		sg_init_one(&ses->sense_sgl, scmd->sense_buffer,
>  		                                       scmd->request_bufflen);
> -		scmd->request_buffer = &ses->sense_sgl;
> +		scmd->sg_table.sgl = &ses->sense_sgl;
> +		scmd->sg_table.nents = scmd->sg_table.orig_nents = 1;
>  		scmd->sc_data_direction = DMA_FROM_DEVICE;
>  		scmd->use_sg = 1;
>  		memset(scmd->cmnd, 0, sizeof(scmd->cmnd));
> @@ -679,6 +681,7 @@ void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
>  	scmd->request_bufflen = ses->bufflen;
>  	scmd->request_buffer = ses->buffer;
>  	scmd->use_sg = ses->use_sg;
> +	memcpy(&scmd->sg_table, &ses->sg_table, sizeof(scmd->sg_table));
>  	scmd->resid = ses->resid;
>  	scmd->result = ses->result;
>  }
> diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
> index d21b891..d43dc83 100644
> --- a/include/scsi/scsi_eh.h
> +++ b/include/scsi/scsi_eh.h
> @@ -75,6 +75,7 @@ struct scsi_eh_save {
>  
>  	void *buffer;
>  	unsigned bufflen;
> +	struct sg_table sg_table;
>  	unsigned short use_sg;
>  	int resid;
>  

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven-osDt5Q4Chk1BDgjK7y7TUQ@public.gmane.org
Internet: http://www.sony-europe.com/

Sony Network and Software Technology Center Europe
A division of Sony Service Centre (Europe) N.V.
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
VAT BE 0413.825.160 · RPR Brussels
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584349381-829811562-1201688867=:26562--
