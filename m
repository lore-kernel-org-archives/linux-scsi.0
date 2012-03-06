From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Are these comments in scsi_host.h still true?
Date: Tue, 06 Mar 2012 17:07:16 -0600
Message-ID: <4F5698A4.5090306@cs.wisc.edu>
References: <20120305231858.GB22578@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45897 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031456Ab2CFXKp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Mar 2012 18:10:45 -0500
In-Reply-To: <20120305231858.GB22578@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: linux-scsi@vger.kernel.org

On 03/05/2012 05:18 PM, scameron@beardog.cce.hp.com wrote:
> 
> Is this comment from include/scsi/scsi_host.h still true?
> 
>         /*
>          * This is an error handling strategy routine.  You don't need to
>          * define one of these if you don't want to - there is a default
>          * routine that is present that should work in most cases.  For those
>          * driver authors that have the inclination and ability to write their
>          * own strategy routine, this is where it is specified.  Note - the
> ---->    * strategy routine is *ALWAYS* run in the context of the kernel eh
> ---->    * thread.  Thus you are guaranteed to *NOT* be in an interrupt
> ---->    * handler when you execute this, and you are also guaranteed to
> ---->    * *NOT* have any other commands being queued while you are in the
>          * strategy routine. When you return from this function, operations
>          * return to normal.
>          *
>          * See scsi_error.c scsi_unjam_host for additional comments about
>          * what this function should and should not be attempting to do.
>          *
>          * Status: REQUIRED     (at least one of them)
>          */
> 
> Also what about this, about scsi_unjam_host() from scsi_error.c?
> 
>  * Notes:
>  *    When we come in here, we *know* that all commands on the bus have
>  *    either completed, failed or timed out.  we also know that no further
>  *    commands are being sent to the host, so things are relatively quiet
>  *    and we have freedom to fiddle with things as we wish.
> 
> I'm not seeing what code makes sure those are true.
> 

For the strategy handler/unjam case this is true. See scsi_times_out ->
scsi_eh_scmd_add. That will set the host state so not new commands are
stated and will begin the process of making sure that commands are
either timedout or completed. See the host_busy and host_failed checks
in scsi_error.c. Those will prevent the scsi eh unjam stuff from
starting when commands not completed or timedout (host_busy is
incremented in scsi_request_fn when commands are queued).

However, some of your eh callbacks can be called while IO is still
running. If you did sg_reset /dev/sda for example, that calls
scsi_nonblockable_ioctl and that prevents new IOs from coming in
(scsi_reset_provider sets the tmf_in_progress flag which is checked in
scsi_host_queue_ready's scsi_host_in_recovery call). But in this path we
do not wait for all IO to timeout or complete like we do in the
unjam/strategy handler cases.
