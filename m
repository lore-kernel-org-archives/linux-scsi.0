From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] 2.6.10 include/scsi/scsi.h and drivers/scsi/constants.h
Date: Tue, 01 Feb 2005 10:15:33 +1000
Message-ID: <41FECA25.1080109@torque.net>
References: <1107193383.11517.12.camel@localhost.localdomain>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from borg.st.net.au ([65.23.158.22]:44764 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261599AbVBAHHR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2005 02:07:17 -0500
In-Reply-To: <1107193383.11517.12.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

Joe Perches wrote:
> Remove unnecessary ";" from #define and use sense_ macros

 > --- include/scsi/scsi.h~	2004-12-29 18:58:36.000000000 -0800
 > +++ include/scsi/scsi.h	2005-01-31 09:07:16.000000000 -0800
 > @@ -356,7 +356,7 @@
 >
 >  #define sense_class(sense)  (((sense) >> 4) & 0x7)
 >  #define sense_error(sense)  ((sense) & 0xf)
 > -#define sense_valid(sense)  ((sense) & 0x80);
 > +#define sense_valid(sense)  ((sense) & 0x80)
 >

The unnecessary ";" is obviously wrong.

When things settle down a bit it might be good to get rid
of those macros:
    - their names are too generic (e.g. no leading "sam_")
    - the sense "class" concept has long been dropped (10
      years ago?)
    - sense_valid() is a confusing name, that bit means the
      info field within the sense data is valid, not the
      sense data itself as the macro name implies
    - sense_error() yields what is now called the
      "response code"
    - sense_valid() assumes fixed sense data format (i.e. it
      yields the wrong result for descriptor format)

We can help ourselves and others to understand the SCSI code,
especially the error handling, if we clean up some of this stuff.
The definitive modern description of sense data can be found in
SPC-3 (rev 21c) section 4.5 at www.t10.org .

Thanks for bringing those macros to my attention.

Doug Gilbert

P.S. On a more subjective note, the C++ programmer in me cringes
when I see variables (re-)named "class".


>  
>  #define IDENTIFY_BASE       0x80
> --- drivers/scsi/constants.c~	2004-10-18 14:54:39.000000000 -0700
> +++ drivers/scsi/constants.c	2005-01-31 09:06:51.000000000 -0800
> @@ -924,17 +924,17 @@
>  		     const unsigned char *sense_buffer,
>  		     struct request *req)
>  {
> -	int s, sense_class, valid, code, info;
> +	int s, class, valid, code, info;
>  	const char *error = NULL;
>  	unsigned char asc, ascq;
>  	const char *sense_txt;
>  	const char *name = req->rq_disk ? req->rq_disk->disk_name : devclass;
>      
> -	sense_class = (sense_buffer[0] >> 4) & 0x07;
> -	code = sense_buffer[0] & 0xf;
> -	valid = sense_buffer[0] & 0x80;
> +	class = sense_class(sense_buffer[0]);
> +	code = sense_error(sense_buffer[0]);
> +	valid = sense_valid(sense_buffer[0]);
>      
> -	if (sense_class == 7) {	/* extended sense data */
> +	if (class == 7) {	/* extended sense data */
>  		s = sense_buffer[7] + 8;
>  		if (s > SCSI_SENSE_BUFFERSIZE)
>  			s = SCSI_SENSE_BUFFERSIZE;
> @@ -1002,7 +1002,7 @@
>  			       sense_buffer[0], sense_buffer[2]);
>  
>  		printk("Non-extended sense class %d code 0x%0x\n",
> -		       sense_class, code);
> +		       class, code);
>  		s = 4;
>  	}
>      
> 
> 

