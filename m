From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 18/21] uas: Use scsi_print_command
Date: Wed, 10 Sep 2014 16:08:49 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C710E7@G9W0745.americas.hpqcorp.net>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
 <1410349611-17573-19-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1410349611-17573-19-git-send-email-hdegoede@redhat.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Hans de Goede
> Sent: Wednesday, 10 September, 2014 6:47 AM
> To: Greg Kroah-Hartman
> Cc: linux-usb@vger.kernel.org; linux-scsi@vger.kernel.org;
> stable@vger.kernel.org; Hans de Goede
> Subject: [PATCH 18/21] uas: Use scsi_print_command
> 
> Use scsi_print_command to print commands during errors, rather then
> printing
> the rather meaningless pointer to the command.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/usb/storage/uas.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 46b8788..220f4c7 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -229,8 +229,8 @@ static void uas_log_cmd_state(struct scsi_cmnd
> *cmnd, const char *caller)
>  	struct uas_cmd_info *ci = (void *)&cmnd->SCp;
> 
>  	scmd_printk(KERN_INFO, cmnd,
> -		    "%s %p tag %d,
> inflight:%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
> -		    caller, cmnd, uas_get_tag(cmnd),
> +		    "%s tag %d inflight:%s%s%s%s%s%s%s%s%s%s%s%s%s ",
> +		    caller, uas_get_tag(cmnd),
>  		    (ci->state & SUBMIT_STATUS_URB)     ? " s-st"  : "",
>  		    (ci->state & ALLOC_DATA_IN_URB)     ? " a-in"  : "",
>  		    (ci->state & SUBMIT_DATA_IN_URB)    ? " s-in"  : "",
> @@ -244,6 +244,7 @@ static void uas_log_cmd_state(struct scsi_cmnd
> *cmnd, const char *caller)
>  		    (ci->state & COMMAND_COMPLETED)     ? " done"  : "",
>  		    (ci->state & COMMAND_ABORTED)       ? " abort" : "",
>  		    (ci->state & IS_IN_WORK_LIST)       ? " work"  : "");
> +	scsi_print_command(cmnd);
>  }

The SCSI midlayer already does a scsi_print_command, under
the MLCOMPLETE logging level.  Printing the command in
the LLD is redundant; Printing the scmd pointer was not,
as it matched the prints in the SCSI midlayer, letting
you find all the messages for a command.

In Hannes' logging patch series, Christoph Hellwig suggested
printing the block layer tag instead of the scmd pointer.
If UAS uses that tag directly, then the uas_get_tag() print
already does that.  If they're not identical (looks like 
they differ by 2), then you might want to print both.

More general comment: 
scsi-mq stress testing has shown that calling printk
on each command with an error is problematic.  If the
system runs into hundreds or thousands of errors, the
printks take so long they induce more timeouts and errors.  

As discussed in the threads by Yoshihiro YUNOMAE and Hannes
Reinecke, you might want to:
* tuck the scmd_printk inside SCSI_LOG_LLCOMPLETE so
the user can control the verbosity
* use a _ratelimited version of each print
* plan to add and eventually switch to tracepoints, so
logging doesn't have performance impacts

---
Rob Elliott    HP Server Storage
