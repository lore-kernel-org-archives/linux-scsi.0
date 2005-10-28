From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 2/5] scsi_error thread exits in TASK_INTERRUPTIBLE
	state.
Date: Fri, 28 Oct 2005 17:21:44 -0500
Message-ID: <1130538105.3328.21.camel@mulgrave>
References: <200510282207.j9SM7WuB022257@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:22252 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750704AbVJ1WVz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 18:21:55 -0400
In-Reply-To: <200510282207.j9SM7WuB022257@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: linux-scsi@vger.kernel.org, rostedt@goodmis.org

On Fri, 2005-10-28 at 15:07 -0700, akpm@osdl.org wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> 
> Found in the -rt patch set.  The scsi_error thread likely will be in the
> TASK_INTERRUPTIBLE state upon exit.  This patch fixes this bug.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> Cc: James Bottomley <James.Bottomley@steeleye.com>
> Signed-off-by: Andrew Morton <akpm@osdl.org>
> ---
> 
>  drivers/scsi/scsi_error.c |    1 +
>  1 files changed, 1 insertion(+)
> 
> diff -puN drivers/scsi/scsi_error.c~scsi_error-thread-exits-in-task_interruptible-state drivers/scsi/scsi_error.c
> --- 25/drivers/scsi/scsi_error.c~scsi_error-thread-exits-in-task_interruptible-state	Fri Oct 28 15:06:03 2005
> +++ 25-akpm/drivers/scsi/scsi_error.c	Fri Oct 28 15:06:03 2005
> @@ -1644,6 +1644,7 @@ int scsi_error_handler(void *data)
>  		scsi_restart_operations(shost);
>  		set_current_state(TASK_INTERRUPTIBLE);
>  	}
> +	__set_current_state(TASK_RUNNING);
^^^^^^^^^^^^^^^^^^^^^
>  	__set_current_state(TASK_RUNNING);
^^^^^^^^^^^^^^^^^^^^^

Mismerge, I think (of a patch which is already present)

James


