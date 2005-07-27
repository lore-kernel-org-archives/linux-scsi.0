From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] drivers/scsi/st.c: add command and sense history
Date: Wed, 27 Jul 2005 12:38:50 +0300 (EEST)
Message-ID: <Pine.LNX.4.61.0507271238160.9053@kai.makisara.local>
References: <42E14E61.2080701@electricalscience.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep30-0.kolumbus.fi ([193.229.0.32]:64180 "EHLO
	fep30-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S262073AbVG0Jeu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jul 2005 05:34:50 -0400
In-Reply-To: <42E14E61.2080701@electricalscience.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Stevens <stevens@electricalscience.com>
Cc: linux-scsi@vger.kernel.org

The following comments are based on looking at the patch, not testing it.

The tape devices do not provide much information about problems via the normal
API: mostly it just tells that something went wrong. The driver prints the
sense data to the kernel log but this information may not be accessible and/or
it is difficult to connect it to the specific problem at hand. Exporting the
sense data in some form is a better (although not perfect) method to give more
information in case of problems.

On Fri, 22 Jul 2005, Andy Stevens wrote:

> Hello SCSI tapers,
> 
> Attached is a patch to add some functionality the st driver so that you can
> monitor the most recent SCSI command and sense buffer.  This info is made
> available via sysfs attributes.  I want to add these attributes in order to do
> better error processing in some custom tape software which I am writing.  This
> patch has been tested on Linux kernel 2.6.12.
> 
> The new functionality is as follows:
> 
> 1) the most recent "relevant" SCSI command and sense are stored in hex format
> in:
> 
> /sys/class/scsi_tape/stN/last_cmnd
> /sys/class/scsi_tape/stN/last_sense
> 

Using two files is problematic: the user can't be sure that last_sense is
really related to last_cmnd. If they are in the same file, a single read could
enforce this. (The implementation does not contain the necessary locking. I
don't think it is necessary at this phase but the single file approach would
make atomicity possible if desired.)

> When I say "relevant" SCSI command, I mean: occasionally the most recent SCSI
> command is not the one of interest, e.g. when encountering an ILI, the driver
> will automatically backspace to the beginning of the block. However, the
> last_cmnd and last_sense will show the results of the read error, not the
> backspace.
> 
This is the reason why this should be in the ULD. If only the most recent
data would be exported, it could be done at midlevel to benefit all SCSI
devices.

> 2) The raw sense data is also decoded into English language for primary sense
> key, extended sense, and ILI/FM/EOM flags in these sysfs files:
> 
> /sys/class/scsi_tape/stN/primary_sense
> /sys/class/scsi_tape/stN/extended_sense
> /sys/class/scsi_tape/stN/sense_flags
> 
I don't think these are necessary. Anyway, the sysfs data should be either
single values or an array of values. The contents of the files must be
explained elsewhere (linux/Documentation/scsi/st.txt).

However, I would like to discuss exporting selected fields of the sense data instead
of the raw data as an alternative. This would make interpretation of the data
easier when devices supporting the descriptor based sense data start
appearing. The values exported could be: sense key, ASC, ASCQ, flags (FM, EOM,
ILI), information field. What do the users really need?

> Details of implementation:
> 
> 1) added data fields "last_cmnd" and "last_sense" to struct st_cmdstatus for
> storage of most recent command and sense data.  Removed unused "last_cmnd" and
> "last_sense" fields from struct scsi_tape.
> 
> 2) added routine st_record_last_command() to save command and sense data
> 
> 3) added calls to st_record_last_command() in appropriate locations in the
> code.
> 
> 4) added arg to st_int_ioctl() to indicate whether or not to record the SCSI
> command (necessary so that we can record the "relevant" command)
> 
> 5) added routines for sysfs attribute files
> 
> This is my first time submitting a patch to the list, please go easy on me!!
> 
Could you in future make patches from the linux source tree root using
'diff -up' (i.e., the path to st.c would be linux/drivers/scsi/st.c; the file
linux/Documentation/SubmittingPatches contains a lot of useful
information). Appending the diff instead of putting it into an attachment
would make commenting easier for some of us.

> --- st.c.orig	2005-06-17 15:48:29.000000000 -0400
> +++ st.c	2005-07-22 15:20:06.000000000 -0400
> @@ -17,7 +17,7 @@
>     Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs support
>   */
>  
> -static char *verstr = "20050312";
> +static char *verstr = "20050706";
>  
>  #include <linux/module.h>
>  
> @@ -215,7 +215,7 @@
>  static int find_partition(struct scsi_tape *);
>  static int switch_partition(struct scsi_tape *);
>  
> -static int st_int_ioctl(struct scsi_tape *, unsigned int, unsigned long);
> +static int st_int_ioctl(struct scsi_tape *, unsigned int, unsigned long, int);
>  
>  

>  #include "osst_detect.h"
> @@ -264,6 +264,29 @@
> 	return tape->disk->disk_name;
>  }
>  
> +static void st_clear_last_command(struct scsi_tape *STp)
> +{
> +	/* clear last command and last sense */
> +	memset(STp->buffer->cmdstat.last_cmnd,0,MAX_COMMAND_SIZE);
> +	memset(STp->buffer->cmdstat.last_sense,0,SCSI_SENSE_BUFFERSIZE);
> +}	
> +
> +static void st_record_last_command(struct scsi_tape *STp, struct scsi_request *SRpnt)
> +{
> +	int i;
> +
> +	st_clear_last_command(STp);
> +	

Not necessary.

> +	/* make copy of last SCSI command */
> +	for(i=0; i<MAX_COMMAND_SIZE; i++){
> +		STp->buffer->cmdstat.last_cmnd[i] = SRpnt->sr_cmnd[i];
> +	}
> +
> +	/* make copy of last SCSI sense buffer */
> +	for(i=0; i<SCSI_SENSE_BUFFERSIZE; i++){
> +		STp->buffer->cmdstat.last_sense[i] = SRpnt->sr_sense_buffer[i];
> +	}

Why not use memcpy?

This overwrites the previous command and sense data unconditionally. Would it
be better to do the copy only if the command returns sense data? This change
in semantics could make the feature more useful because the error information
persists.

There are errors that don't return sense data (HBA errors, etc.). Could these
be also reported?

> +}	
>  
>  static void st_analyze_sense(struct scsi_request *SRpnt, struct st_cmdstatus *s)
>  {
> @@ -539,6 +562,7 @@
>  	if (!SRpnt)
>  		return (STp->buffer)->syscall_result;
>  
> +	st_record_last_command(STp,SRpnt);

You have to add these calls to many locations in order to copy the relevant
data. Another way might be to do the copy in one place but make it conditional
on a new flag in struct st_buffer. You set this flag in the few places where
copying of the sense data is not desirable and something like the following
would be added somewhere (st_chk_result?):

      if (!STp->buffer->no_sense_copy) {
              st_record_last_command(STp, SRpnt);
	      STp->buffer->no_sense_copy = 0;
      }

[ changes stripped ]
> @@ -4215,6 +4269,94 @@
>  
>  
>  /* The sysfs simple class interface */
> +static ssize_t st_last_cmnd_show(struct class_device *class_dev, char *buf)
> +{
> +	struct st_modedef *STm = (struct st_modedef *)class_get_devdata(class_dev);
> +	int i;
> +	char last_cmnd_as_string[2*MAX_COMMAND_SIZE+1];
> +
> +	/* convert unsigned char array into string */
> +	for(i=0; i<MAX_COMMAND_SIZE; i++){
> +		sprintf(last_cmnd_as_string+2*i,"%02x",STm->cmdstat->last_cmnd[i]);
> +	}
> +
> +	return snprintf(buf, PAGE_SIZE, "0x%s\n", last_cmnd_as_string);
> +}
> +CLASS_DEVICE_ATTR(last_cmnd, S_IRUGO, st_last_cmnd_show, NULL);
> +
> +static ssize_t st_last_sense_show(struct class_device *class_dev, char *buf)
> +{
> +	struct st_modedef *STm = (struct st_modedef *)class_get_devdata(class_dev);
> +	int i;
> +	char last_sense_as_string[2*SCSI_SENSE_BUFFERSIZE+1];

This is too big array to be allocated from stack.

> +
> +	/* convert unsigned char array into string */
> +	for(i=0; i<SCSI_SENSE_BUFFERSIZE; i++){
> +
> sprintf(last_sense_as_string+2*i,"%02x",STm->cmdstat->last_sense[i]);

Using blanks between bytes of data would make the result easier to read.

> +	}
> +
> +	return snprintf(buf, PAGE_SIZE, "0x%s\n", last_sense_as_string);

It would probably be simpler to format the data directly into buf. The code
would not be longer but the temporary buffer would be avoided.

[ changes stripped ]

-- 
Kai
