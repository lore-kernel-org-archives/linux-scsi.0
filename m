From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/2] target: Fix LUN_RESET active TMR descriptor handling
Date: Fri, 22 Jan 2016 18:02:09 -0800
Message-ID: <1453514529.6746.14.camel@haakon3.risingtidesystems.com>
References: <1452594245-921-1-git-send-email-nab@daterainc.com>
	 <1452594245-921-3-git-send-email-nab@daterainc.com>
	 <20160112152513.GC2294@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160112152513.GC2294@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2016-01-12 at 16:25 +0100, Christoph Hellwig wrote:
> >  	if (dev) {
> >  		spin_lock_irqsave(&dev->se_tmr_lock, flags);
> > -		list_del(&tmr->tmr_list);
> > +		if (!list_empty(&tmr->tmr_list))
> > +			list_del_init(&tmr->tmr_list);
> 
> list_del_init on a empty list is fine.
> 

Done.

> > +		sess = cmd->se_sess;
> > +		if (!sess) {
> > +			dump_stack();
> > +			continue;
> > +		}
> 
> Why not something like:
> 
> 		if (WARN_ON_ONCE(!sess))
> 			continue;
> 
> same for the previous patch.
> 

Done.

> > +		spin_lock(&sess->sess_cmd_lock);
> > +		rc = kref_get_unless_zero(&cmd->cmd_kref);
> > +		spin_unlock(&sess->sess_cmd_lock);
> 
> no need to take a lock around kref_get_unless_zero, it's not going to
> help with anything.

So for -v2, this lock is being obtained before ->t_state_lock above, to
follow how __target_check_io_state() works with aborted I/O + LUN_RESET
and explicit TMR_ABORT_TASK.

It's been made consistent with the other cases for now, but depending on
how the bug-fix for se_session shutdown plus remote port LUN_RESET works
out, this may or may-not be able to go away for -v3.
