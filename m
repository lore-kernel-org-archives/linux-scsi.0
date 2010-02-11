From: Ravi Anand <ravi.anand@qlogic.com>
Subject: Re: [PATCH 07/11] qla4xxx: Avoid relogin on device marked missing
Date: Thu, 11 Feb 2010 03:08:58 -0800
Message-ID: <20100211110858.GC8237@linux-qf4p>
References: <20100130062900.GH10274@linux-qf4p> <4B672048.4090600@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:53991 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab0BKLHq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2010 06:07:46 -0500
Content-Disposition: inline
In-Reply-To: <4B672048.4090600@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <james.bottomley@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Nilesh Javali <nilesh.javali@qlogic.com>

On Mon, 01 Feb 2010, Mike Christie wrote:

> 
> On 01/30/2010 12:29 AM, Ravi Anand wrote:
> >
> > From: Vikas Chaudhary<vikas.chaudhary@qlogic.com>
> >
> > Signed-off-by: Nilesh Javali<nilesh.javali@qlogic.com>
> > Signed-off-by: Vikas Chaudhary<vikas.chaudhary@qlogic.com>
> > Signed-off-by: Ravi Anand<ravi.anand@qlogic.com>
> > ---
> >   drivers/scsi/qla4xxx/ql4_os.c |   27 ++++++++++++++++++++++++---
> >   1 files changed, 24 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> > index 9057860..e5c9b85 100644
> > --- a/drivers/scsi/qla4xxx/ql4_os.c
> > +++ b/drivers/scsi/qla4xxx/ql4_os.c
> > @@ -370,6 +370,7 @@ void qla4xxx_mark_device_missing(struct scsi_qla_host *ha,
> >   		      ddb_entry->fw_ddb_index));
> >   	iscsi_block_session(ddb_entry->sess);
> >   	iscsi_conn_error_event(ddb_entry->conn, ISCSI_ERR_CONN_FAILED);
> > +	set_bit(DF_NO_RELOGIN,&ddb_entry->flags);
> >   }
> >
> >   /***
> > @@ -642,6 +643,24 @@ static void qla4xxx_timer(struct scsi_qla_host *ha)
> >
> >   	/* Search for relogin's to time-out and port down retry. */
> >   	list_for_each_entry_safe(ddb_entry, dtemp,&ha->ddb_list, list) {
> > +		/* First check to see if the device has exhausted the
> > +		 * port down retry count */
> > +		if (atomic_read(&ddb_entry->state) == DDB_STATE_MISSING) {
> > +			if (atomic_read(&ddb_entry->port_down_timer) == 0)
> > +				continue;
> > +
> 
> 
> How does the relogin work in this case?

Actually it does not. We have fixed it and will resubmit an updated
patch along with other patches to address the review comments.

> 
> - If you pull a cable and we mark devices missing, then when link up is 
> detected will qla4xxx_isr_decode_mailbox set the AF_LINK_UP bit and then 
> the driver will start to try and relogin? Or would you get a 
> MBOX_ASTS_DATABASE_CHANGED aen, and then that notifies you that that the 
> firmware detected link up and logged back in (so the state would then be 
> DDB_DS_SESSION_ACTIVE?)?
> 
> 
> - What cases do you get a databased change aen where the new device 
> state indicates the session is non active so qla4xxx_process_ddb_changed 
> calls qla4xxx_mark_device_missing? Would it be where the target logs us 
> out, or when the firmware detects a problem with the session/connection 
> and drop the session, what about if the firmware detects a link down?
> 
> In the case qla4xxx_process_ddb_changed calls 
> qla4xxx_mark_device_missing will we get some sort of databased change 
> aen indicating that the state is again DDB_DS_SESSION_ACTIVE?
> 
> - What cases do we now use the relogin code now? Do we always call 
> qla4xxx_mark_device_missing in cases where a relogin is needed, so can 
> we just remove the relogin code? Or is the relogin code still used for 
> the initial driver initialization or something else?

F/W does the auto login only once during the init time once the link is up.
After that any time if there is any connection failure or I/O timeout resulting
in tear down of connection etc, its driver responsibility to relogin.

For cable pull scenario's if there are no I/O oustanding and KATO expires, in
that case driver will receive 8014 indicating that the target was logged out.
Again in that case its driver responsibility to log back in.

So doing a set_ddb() will result in re-establising the session and F/W will
report _SESSION_ACTIVE via 8014.

Thanks for the feedback. We will resubmit all patches as *V2* which
should address your concern.

THanks
Ravi
