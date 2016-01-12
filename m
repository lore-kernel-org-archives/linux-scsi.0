From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] target: Fix LUN_RESET active I/O handling for
	ACK_KREF
Date: Tue, 12 Jan 2016 16:20:59 +0100
Message-ID: <20160112152059.GB2294@lst.de>
References: <1452594245-921-1-git-send-email-nab@daterainc.com> <1452594245-921-2-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1452594245-921-2-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

> It also introduces SCF_ACK_KREF to determine when
> transport_cmd_finish_abort() needs to drop the second
> extra reference, ahead of calling target_put_sess_cmd()
> for the final kref_put(&se_cmd->cmd_kref).

It would be really useful to have all drivers follow that
ACK KREF model instead of needing to deal with driver
differences everywhere..

> Finally, move transport_put_cmd() release of SGL +
> TMR + extended CDB memory into target_free_cmd_mem()
> in order to avoid potential resource leaks in TMR
> ABORT_TASK + LUN_RESET code-paths.  Also update
> target_release_cmd_kref() accordingly.

Sounds like that should be a separate patch.

> +/*
> + * Called with se_session->sess_cmd_lock held with irq disabled
> + */

Please enforce this in the code instead of the comments, e.g.

	assert_spin_locked(&se_session->sess_cmd_lock);
	WARN_ON_ONCE(!irqs_disabled());

> +static bool __target_check_io_state(struct se_cmd *se_cmd)
> +{
> +	struct se_session *sess = se_cmd->se_sess;
> +
> +	if (!sess)
> +		return false;

Given that you expect the session lock to be held this doesn't
make sense.

> +		/*
> +		 * Obtain cmd_kref and move to list for shutdown processing
> +		 * if se_cmd->cmd_kref is still active, the command has not
> +		 * already reached CMD_T_COMPLETE
> +		 */

This just explains what __target_check_io_state does, but no why.
I'd suggest to remove the comment as it doesn't add any value.
