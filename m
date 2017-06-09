From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/3] target: Add TARGET_SCF_LOOKUP_LUN_FROM_TAG support
 for ABORT_TASK
Date: Thu, 08 Jun 2017 22:52:24 -0700
Message-ID: <1496987544.28997.34.camel@haakon3.risingtidesystems.com>
References: <1496527808-28789-1-git-send-email-nab@linux-iscsi.org>
         <1496527808-28789-3-git-send-email-nab@linux-iscsi.org>
         <1496678246.2623.5.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1496678246.2623.5.camel@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mchristi@redhat.com" <mchristi@redhat.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "quinn.tran@cavium.com" <quinn.tran@cavium.com>, "hare@suse.com" <hare@suse.com>, "hch@lst.de" <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2017-06-05 at 15:57 +0000, Bart Van Assche wrote:
> On Sat, 2017-06-03 at 22:10 +0000, Nicholas A. Bellinger wrote:
> > +static bool target_lookup_lun_from_tag(struct se_session *se_sess, u64 tag,
> > +				       u64 *unpacked_lun)
> > +{
> > +	struct se_cmd *se_cmd;
> > +	unsigned long flags;
> > +	bool ret = false;
> > +
> > +	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
> > +	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
> > +		if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
> > +			continue;
> > +
> > +		if (se_cmd->tag == tag) {
> > +			*unpacked_lun = se_cmd->orig_fe_lun;
> > +			ret = true;
> > +			break;
> > +		}
> > +	}
> > +	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
> > +
> > +	return ret;
> > +}
> > +
> >  /**
> >   * target_submit_tmr - lookup unpacked lun and submit uninitialized se_cmd
> >   *                     for TMR CDBs
> > @@ -1639,19 +1662,31 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
> >  		core_tmr_release_req(se_cmd->se_tmr_req);
> >  		return ret;
> >  	}
> > +	/*
> > +	 * If this is ABORT_TASK with no explicit fabric provided LUN,
> > +	 * go ahead and search active session tags for a match to figure
> > +	 * out unpacked_lun for the original se_cmd.
> > +	 */
> > +	if (tm_type == TMR_ABORT_TASK && (flags & TARGET_SCF_LOOKUP_LUN_FROM_TAG)) {
> > +		if (!target_lookup_lun_from_tag(se_sess, tag, &unpacked_lun))
> > +			goto failure;
> > +	}
> >  
> >  	ret = transport_lookup_tmr_lun(se_cmd, unpacked_lun);
> > -	if (ret) {
> > -		/*
> > -		 * For callback during failure handling, push this work off
> > -		 * to process context with TMR_LUN_DOES_NOT_EXIST status.
> > -		 */
> > -		INIT_WORK(&se_cmd->work, target_complete_tmr_failure);
> > -		schedule_work(&se_cmd->work);
> > -		return 0;
> > -	}
> > +	if (ret)
> > +		goto failure;
> > +
> >  	transport_generic_handle_tmr(se_cmd);
> >  	return 0;
> 
> Hello Nic,
> 
> So after LUN lookup has finished sess_cmd_lock lock is dropped, a context
> switch occurs due to the queue_work() call in transport_generic_handle_tmr()
> and next core_tmr_abort_task() reacquires that lock? Sorry but I'm afraid
> that if after that lock is dropped and before it is reacquired a command
> finishes and the initiator reuses the same tag for another command for the
> same LUN that this may result in the wrong command being aborted.

This is only getting a unpacked_lun to determine where the incoming
ABORT_TASK should perform a se_lun lookup and percpu ref upon.

The scenario you are talking about would require a tag be reused on the
same session for the same device between when the ABORT_TASK is
dispatched here, and actually processed.

Because qla2xxx doesn't reuse tags, it's not a problem since it's the
only consumer of TARGET_SCF_LOOKUP_LUN_FROM_TAG.

Since Himanshu and Quinn are OK it with, I'm OK with it.

If you have another driver that needs to use this logic where an
ABORT_TASK doesn't know the unpacked_lun to reference, and does reuse
tags then I'd consider a patch for that.
