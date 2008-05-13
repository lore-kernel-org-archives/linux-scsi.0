From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] drivers/scsi/qla1280.c; was Re: Buffered I/O to block
 device very slow and other SCSI issues...
Date: Mon, 12 May 2008 17:18:49 -0700
Message-ID: <20080512171849.21d3508f.akpm@linux-foundation.org>
References: <20080319231654.GA103321673@sgi.com>
	<20080320010807.GA27620@sgi.com>
	<20080320032010.e640c52a.akpm@linux-foundation.org>
	<20080512061703.GC41683@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754133AbYEMATO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 May 2008 20:19:14 -0400
In-Reply-To: <20080512061703.GC41683@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: dgc@sgi.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, jes@sgi.com, stable@kernel.org

On Sun, 11 May 2008 23:17:03 -0700
Jeremy Higdon <jeremy@sgi.com> wrote:

> On Thu, Mar 20, 2008 at 03:20:10AM -0700, Andrew Morton wrote:
> > > > I also suspect that CTQ has not been set up correctly on this
> > > > kernel, because:
> > > > 
> > > > $ cat /sys/block/sdb/device/queue_depth
> > > > 3
> > > > $ ls -l /sys/block/sdb/device/queue_depth
> > > > -r--r--r-- 1 root root 0 Mar 20 09:59 /sys/block/sdb/device/queue_depth
> > > > $
> > > > 
> > > > It appears to be hard coded to 3 and can't be changed....
> > > 
> > > That's a bug in the qla1280 driver.  I thought that had gotten fixed.
> > > It's looking at the wrong mailbox register after setting device parameters.
> > 
> > Was there a patch anywhere?
> 
> Promised patch...
> 
> The qla1280 driver was ANDing the output value of mailbox register
> 0 with (1 << target-number) to determine whether to enable queueing
> on the target in question.
> 
> But mailbox register 0 has the status code for the mailbox command
> (in this case, Set Target Parameters).  Potential values are:
> /*      
>  * ISP mailbox command complete status codes
>  */
> #define MBS_CMD_CMP             0x4000  /* Command Complete. */
> #define MBS_INV_CMD             0x4001  /* Invalid Command. */
> #define MBS_HOST_INF_ERR        0x4002  /* Host Interface Error. */
> #define MBS_TEST_FAILED         0x4003  /* Test Failed. */
> #define MBS_CMD_ERR             0x4005  /* Command Error. */
> #define MBS_CMD_PARAM_ERR       0x4006  /* Command Parameter Error. */
> 
> So clearly that is in error.  I can't think what the author of that
> line was looking for in a mailbox register, so I just eliminated the
> AND.  flag is used later in the function, and I think that the later
> usage was also wrong, though it was used to set values that aren't
> used.  Oh well, an overhaul of this driver is not what I want to do
> now -- just a bugfix. 
> 
> After the fix, I found that my disks were getting a queue depth of
> 255, which is far too many.  Most SCSI disks are limited to 32 or
> 64.  In any case, there's no point, queueing up a bunch of commands
> to the adapter that will just result in queue full or starve other
> targets from being issued commands due to running out of internal
> memory.  So I dropped default queue depth to 32 (from which 1 is
> subtracted elsewhere, giving net of 31).
> 
> I tested with a Seagate ST336753LC, and results look good, so
> I'm satisfied with this patch.
> 
> Signed-off-by: Jeremy Higdon <jeremy@sgi.com>
> 
> 
> ---
> 
> 
> --- a/drivers/scsi/qla1280.c	2008-05-03 11:59:44.000000000 -0700
> +++ b/drivers/scsi/qla1280.c	2008-05-10 21:32:23.451341969 -0700
> @@ -2007,7 +2007,7 @@ qla1280_set_defaults(struct scsi_qla_hos
>  		nv->bus[bus].config_2.req_ack_active_negation = 1;
>  		nv->bus[bus].config_2.data_line_active_negation = 1;
>  		nv->bus[bus].selection_timeout = 250;
> -		nv->bus[bus].max_queue_depth = 256;
> +		nv->bus[bus].max_queue_depth = 32;
>  
>  		if (IS_ISP1040(ha)) {
>  			nv->bus[bus].bus_reset_delay = 3;
> @@ -2051,7 +2051,7 @@ qla1280_config_target(struct scsi_qla_ho
>  	status = qla1280_mailbox_command(ha, 0x0f, mb);
>  
>  	/* Save Tag queuing enable flag. */
> -	flag = (BIT_0 << target) & mb[0];
> +	flag = (BIT_0 << target);
>  	if (nv->bus[bus].target[target].parameter.tag_queuing)
>  		ha->bus_settings[bus].qtag_enables |= flag;

Thanks.  I tagged this for a -stable backport (assuming that is
appropriate?)


