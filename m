From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ibmvscsi: correct command abort logic
Date: Mon, 8 Dec 2008 14:49:22 -0600
Message-ID: <20081208204922.GA27255@austin.ibm.com>
References: <20081206154139.GA13534@austin.ibm.com> <493D2FEA.5020507@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:49149 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbYLHUtY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Dec 2008 15:49:24 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id mB8KlwcV010329
	for <linux-scsi@vger.kernel.org>; Mon, 8 Dec 2008 13:47:58 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mB8KnNZc204194
	for <linux-scsi@vger.kernel.org>; Mon, 8 Dec 2008 13:49:23 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mB8KnMhs004480
	for <linux-scsi@vger.kernel.org>; Mon, 8 Dec 2008 13:49:22 -0700
Content-Disposition: inline
In-Reply-To: <493D2FEA.5020507@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

My patch is wrong and the current code is correct, I wasn't following
the logic correctly.

--Rob

* Brian King (brking@linux.vnet.ibm.com) wrote:
> I don't think this is right. This will inject an oops into the
> found_evt == NULL path. Additionally, if the event is still on the
> sent list, with this change, we leave it on the sent list. The
> way I thought this was supposed to work was if we got back a successful
> response to the abort command that implied that everything was cleaned
> up for the command we were aborting, which is why we clean up after it
> in the found_evt != NULL case.
> 
> -Brian
> 
> Robert Jennings wrote:
> > The logic is swapped when we determine if a command that we're trying
> > to abort has already completed.  This will keep us from freeing event
> > structures at the correct time, fail to unmap command data properly 
> > and throw off our request_limit count.
> > 
> > Signed-off-by: Robert Jennings <rcjenn@us.ibm.com>
> > 
> > ---
> > 
> >  ibmvscsi.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> > index 6cad175..2d9db9b 100644
> > --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> > +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> > @@ -1099,7 +1099,7 @@ static int ibmvscsi_eh_abort_handler(struct scsi_cmnd *cmd)
> >  		}
> >  	}
> > 
> > -	if (found_evt == NULL) {
> > +	if (found_evt != NULL) {
> >  		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
> >  		sdev_printk(KERN_INFO, cmd->device, "aborted task tag 0x%lx completed\n",
> >  			    tsk_mgmt->task_tag);
> 
> 
> -- 
> Brian King
> Linux on Power Virtualization
> IBM Linux Technology Center
> 
> 
