From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] Flexible timout intfrastructure take II
Date: Wed, 16 Jun 2004 18:15:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40D0C666.90408@adaptec.com>
References: <1087421869.2796.80.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:3983 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S266338AbUFPWPF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 18:15:05 -0400
In-Reply-To: <1087421869.2796.80.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> [This is basically the same patch posted on the flexible timeout
> infrastructure thread, but with all the comments/doc stuff done as well]
> 
> The object of this infrastructure is to give HBAs early warning that
> error handling is about to happen and also provide them with the
> opportunity to do something about it.
> 
> It introduces the extra template callback:
> 
> eh_timed_out()
> 
> which scsi_times_out() will call if it is populated to notify the LLD
> that an outstanding command took a timeout.
> 
> There are three possible returns:
> 
> EH_HANDLED:     I've fixed the problem, please complete the command for me
> (as soon as the timer fires, scsi_done will do nothing, so the timer
> itself will call a special version of scsi_done that doesn't check the
> timer).

Maybe this:

EH_HANDLED: The command has completed. The driver has filled
in the status and service response values in the scsi command
structure.  The command is ready to be given ownership back
to SCSI Core. The driver has just NOT called scsi_done(). SCSI
Core will do that for the driver.

The thing in parenthesis is confusing since it implies that a
timer is running at that point, while none is running. We're
here because it fired already.  LLDD need not know the internal
workings of SCSI Core (scsi_done() vs. __scsi_done() mess).
 
> EH_NOT_HANDLED: Invoke error recovery as normal
> 
> EH_RESET_TIMER: The command will complete, reset the timer to its
> original value and start it ticking again.
> 
> James
> 
> ===== Documentation/scsi/scsi_mid_low_api.txt 1.16 vs edited =====
> --- 1.16/Documentation/scsi/scsi_mid_low_api.txt        2004-02-01 
> 04:45:23 -06:00
> +++ edited/Documentation/scsi/scsi_mid_low_api.txt      2004-06-16 
> 14:53:28 -05:00
> @@ -827,6 +827,7 @@
>  Summary:
>     bios_param - fetch head, sector, cylinder info for a disk
>     detect - detects HBAs this driver wants to control
> +   eh_timed_out - notify the host that a command timer expired
>     eh_abort_handler - abort given command
>     eh_bus_reset_handler - issue SCSI bus reset
>     eh_device_reset_handler - issue SCSI device reset
> @@ -892,6 +893,32 @@
>   *                       not invoked in "hotplug initialization mode")
>   **/
>      int detect(struct scsi_host_template * shtp)
> +
> +
> +/**
> + *      eh_timed_out - The timer for the command has just fired
> + *      @scp: identifies command timing out
> + *
> + *      Returns:
> + *
> + *     EH_HANDLED:             I fixed the error, please complete the 
> command
> + *     EH_RESET_TIMER:         I need more time, reset the timer and
> + *                             begin counting again
> + *     EH_NOT_HANDLED          Begin normal error recovery
> +
> + *
> + *      Locks: None held
> + *
> + *      Calling context: interrupt
> + *
> + *     Notes: This is to give the LLD an opportunity to do local recovery.
> + *     This recovery is limited to determining if the outstanding command
> + *     will ever complete.  You may not abort and restart the command from
> + *     this callback.
> + *
> + *      Optionally defined in: LLD
> + **/
> +     int eh_timed_out(struct scsi_cmnd * scp)
>  
> 
>  /**
> ===== drivers/scsi/scsi.c 1.143 vs edited =====
> --- 1.143/drivers/scsi/scsi.c   2004-04-28 11:32:09 -05:00
> +++ edited/drivers/scsi/scsi.c  2004-06-16 10:47:05 -05:00
> @@ -689,8 +689,6 @@
>   */
>  void scsi_done(struct scsi_cmnd *cmd)
>  {
> -       unsigned long flags;
> -
>         /*
>          * We don't have to worry about this one timing out any more.
>          * If we are unable to remove the timer, then the command
> @@ -701,6 +699,14 @@
>          */
>         if (!scsi_delete_timer(cmd))
>                 return;
> +       __scsi_done(cmd);
> +}
> +
> +/* Private entry to scsi_done() to complete a command when the timer
> + * isn't running --- used by scsi_times_out */
> +void __scsi_done(struct scsi_cmnd *cmd)
> +{
> +       unsigned long flags;
>  
>         /*
>          * Set the serial numbers back to zero
> ===== drivers/scsi/scsi_error.c 1.77 vs edited =====
> --- 1.77/drivers/scsi/scsi_error.c      2004-06-06 06:19:15 -05:00
> +++ edited/drivers/scsi/scsi_error.c    2004-06-16 10:53:02 -05:00
> @@ -162,6 +162,24 @@
>  void scsi_times_out(struct scsi_cmnd *scmd)
>  {
>         scsi_log_completion(scmd, TIMEOUT_ERROR);
> +
> +       if (scmd->device->host->hostt->eh_timed_out)
> +               switch (scmd->device->host->hostt->eh_timed_out(scmd)) {
> +               case EH_HANDLED:
> +                       __scsi_done(scmd);
> +                       return;
> +               case EH_RESET_TIMER:
> +                       /* This allows a single retry even of a command
> +                        * with allowed == 0 */
> +                       if (scmd->retries++ > scmd->allowed)
> +                               break;
> +                       scsi_add_timer(scmd, scmd->timeout_per_command,
> +                                      scsi_times_out);
> +                       return;
> +               case EH_NOT_HANDLED:
> +                       break;
> +               }
> +
>         if (unlikely(!scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))) {
>                 panic("Error handler thread not present at %p %p %s %d",
>                       scmd, scmd->device->host, __FILE__, __LINE__);
> ===== drivers/scsi/scsi_priv.h 1.32 vs edited =====
> --- 1.32/drivers/scsi/scsi_priv.h       2004-03-10 22:20:08 -06:00
> +++ edited/drivers/scsi/scsi_priv.h     2004-06-16 10:45:44 -05:00
> @@ -82,6 +82,7 @@
>  extern void scsi_init_cmd_from_req(struct scsi_cmnd *cmd,
>                 struct scsi_request *sreq);
>  extern void __scsi_release_request(struct scsi_request *sreq);
> +extern void __scsi_done(struct scsi_cmnd *cmd);
>  #ifdef CONFIG_SCSI_LOGGING
>  void scsi_log_send(struct scsi_cmnd *cmd);
>  void scsi_log_completion(struct scsi_cmnd *cmd, int disposition);
> ===== include/scsi/scsi_host.h 1.17 vs edited =====
> --- 1.17/include/scsi/scsi_host.h       2004-06-04 11:51:31 -05:00
> +++ edited/include/scsi/scsi_host.h     2004-06-16 14:36:04 -05:00
> @@ -30,6 +30,12 @@
>  #define DISABLE_CLUSTERING 0
>  #define ENABLE_CLUSTERING 1
>  
> +enum scsi_eh_timer_return {
> +       EH_NOT_HANDLED,
> +       EH_HANDLED,
> +       EH_RESET_TIMER,
> +};
> +
>  
>  struct scsi_host_template {
>         struct module *module;
> @@ -124,6 +130,20 @@
>         int (* eh_device_reset_handler)(struct scsi_cmnd *);
>         int (* eh_bus_reset_handler)(struct scsi_cmnd *);
>         int (* eh_host_reset_handler)(struct scsi_cmnd *);
> +
> +       /*
> +        * This is an optional routine to notify the host that the scsi
> +        * timer just fired.  The returns tell the timer routine what to
> +        * do about this:
> +        *
> +        * EH_HANDLED:          I fixed the error, please complete the 
> command
> +        * EH_RESET_TIMER:      I need more time, reset the timer and
> +        *                      begin counting again
> +        * EH_NOT_HANDLED       Begin normal error recovery
> +        *
> +        * Status: OPTIONAL
> +        */
> +       enum scsi_eh_timer_return (* eh_timed_out)(struct scsi_cmnd *);
>  
>         /*
>          * Old EH handlers, no longer used. Make them warn the user of old
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Luben


