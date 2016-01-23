From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/2] target: Fix LUN_RESET active I/O handling for
 ACK_KREF
Date: Fri, 22 Jan 2016 17:45:45 -0800
Message-ID: <1453513545.6746.6.camel@haakon3.risingtidesystems.com>
References: <1452594245-921-1-git-send-email-nab@daterainc.com>
	 <1452594245-921-2-git-send-email-nab@daterainc.com>
	 <20160112152059.GB2294@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:60052 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732AbcAWBp6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2016 20:45:58 -0500
In-Reply-To: <20160112152059.GB2294@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>

On Tue, 2016-01-12 at 16:20 +0100, Christoph Hellwig wrote:
> > It also introduces SCF_ACK_KREF to determine when
> > transport_cmd_finish_abort() needs to drop the second
> > extra reference, ahead of calling target_put_sess_cmd()
> > for the final kref_put(&se_cmd->cmd_kref).
> 
> It would be really useful to have all drivers follow that
> ACK KREF model instead of needing to deal with driver
> differences everywhere..
> 

tcm_fc, usb-gadget, sbp-target and xen-scsiback are whom
need to be converted.

It should be easy enough to do for v4.6 code.

> > Finally, move transport_put_cmd() release of SGL +
> > TMR + extended CDB memory into target_free_cmd_mem()
> > in order to avoid potential resource leaks in TMR
> > ABORT_TASK + LUN_RESET code-paths.  Also update
> > target_release_cmd_kref() accordingly.
> 
> Sounds like that should be a separate patch.
> 

This should to stay with the original bug-fix for stable back-porting
purposes, and it's been kept together with the original for now.

It's time-consuming enough to back-port given the various upstream
changes recently.

> > +/*
> > + * Called with se_session->sess_cmd_lock held with irq disabled
> > + */
> 
> Please enforce this in the code instead of the comments, e.g.
> 
> 	assert_spin_locked(&se_session->sess_cmd_lock);
> 	WARN_ON_ONCE(!irqs_disabled());
> 

Done.

> > +static bool __target_check_io_state(struct se_cmd *se_cmd)
> > +{
> > +	struct se_session *sess = se_cmd->se_sess;
> > +
> > +	if (!sess)
> > +		return false;
> 
> Given that you expect the session lock to be held this doesn't
> make sense.
> 

Dropped.

> > +		/*
> > +		 * Obtain cmd_kref and move to list for shutdown processing
> > +		 * if se_cmd->cmd_kref is still active, the command has not
> > +		 * already reached CMD_T_COMPLETE
> > +		 */
> 
> This just explains what __target_check_io_state does, but no why.
> I'd suggest to remove the comment as it doesn't add any value.

How about the following for __target_check_io_state()..?

       /*
        * If command already reached CMD_T_COMPLETE state within
        * target_complete_cmd(), this se_cmd has been passed to
        * fabric driver and will not be aborted.
        *
        * Otherwise, obtain a local se_cmd->cmd_kref now for TMR
        * ABORT_TASK + LUN_RESET for CMD_T_ABORTED processing as
        * long as se_cmd->cmd_kref is still active unless zero.
        */

