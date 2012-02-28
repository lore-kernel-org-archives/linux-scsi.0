From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] [SCSI] st: expand ability to write immediate filemarks
Date: Tue, 28 Feb 2012 21:40:33 +0200 (EET)
Message-ID: <alpine.LNX.2.00.1202282103460.6053@kai.makisara.local>
References: <4F3C1189.7090406@suse.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs16.mail.saunalahti.fi ([62.142.117.197]:46837 "EHLO
	vs16.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264Ab2B1Tkh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2012 14:40:37 -0500
In-Reply-To: <4F3C1189.7090406@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 15 Feb 2012, Lee Duncan wrote:

> The st tape driver recently added the MTWEOFI ioctl, which writes
> a tape filemark (EOF), like the MTWEOF ioctl, except that MTWEOFI
> returns immediately. This makes certain applications, like backup
> software, run much more quickly on buffered tape drives.
> 
> Since legacy applications do not know about this new MTWEOFI ioctl,
> this patch adds a new flag that tells the st driver to return
> immediately when writing an EOF (i.e. a filemark). This new flag
> is much like the existing flag that tells the st driver to perform
> writes (and certain other IOs) immediately, but this new flag only
> applies to writing EOFs.
> 
> This new feature can be enabled via a new module flag: st_nowait_eof.
> It can also be set or cleared via the MTSETDRVBUFFER ioctl, using
> the newly-defined MT_ST_NOWAIT_EOF flag.
> 
> Lastly, this new feature is displayed via the sysfs tape "options"
> attribute.
> 
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
>  Documentation/scsi/st.txt |    2 ++
>  drivers/scsi/st.c         |   24 +++++++++++++++++++++---
>  drivers/scsi/st.h         |    1 +
>  include/linux/mtio.h      |    1 +
>  4 files changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/scsi/st.txt b/Documentation/scsi/st.txt
> index 691ca29..85c1b1a 100644
> --- a/Documentation/scsi/st.txt
> +++ b/Documentation/scsi/st.txt
> @@ -390,6 +390,8 @@ MTSETDRVBUFFER
>  	     MT_ST_SYSV sets the SYSV semantics (mode)
>  	     MT_ST_NOWAIT enables immediate mode (i.e., don't wait for
>  	        the command to finish) for some commands (e.g., rewind)
> +	     MT_ST_NOWAIT_EOF enables immediate filemark mode (i.e. when
> +	        writing a filemark, don't wait for it to complete)

You could add a note that errors before EOF may not be noticed.

>  	     MT_ST_SILI enables setting the SILI bit in SCSI commands when
>  		reading in variable block mode to enhance performance when
>  		reading blocks shorter than the byte count; set this only
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 9b28f39..f18d10b 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -81,6 +81,7 @@ static int max_sg_segs;
>  static int try_direct_io = TRY_DIRECT_IO;
>  static int try_rdio = 1;
>  static int try_wdio = 1;
> +static int st_nowait_eof;
>  
>  static int st_dev_max;
>  static int st_nr_dev;
> @@ -103,6 +104,8 @@ module_param_named(max_sg_segs, max_sg_segs, int, 0);
>  MODULE_PARM_DESC(max_sg_segs, "Maximum number of scatter/gather segments to use (256)");
>  module_param_named(try_direct_io, try_direct_io, int, 0);
>  MODULE_PARM_DESC(try_direct_io, "Try direct I/O between user buffer and tape drive (1)");
> +module_param_named(st_nowait_eof, st_nowait_eof, int, 0);
> +MODULE_PARM_DESC(st_nowait_eof, "Do not wait when writing EOF (filemark) (0)");
>  

I think this should not be a module option. The property should be 
settable only as a mode option like other options of this kind.
(I may have not written this clearly in my previous reply).

Otherwise the patch looks good.

Kai
