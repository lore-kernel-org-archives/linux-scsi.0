From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH-v2 1/3] target: Fix LUN_RESET active I/O handling for
	ACK_KREF
Date: Tue, 26 Jan 2016 18:19:00 +0100
Message-ID: <20160126171900.GA3663@lst.de>
References: <1453513067-23169-1-git-send-email-nab@daterainc.com> <1453513067-23169-2-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1453513067-23169-2-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

> +static bool __target_check_io_state(struct se_cmd *se_cmd)
> +{
> +	struct se_session *sess = se_cmd->se_sess;
> +
> +	assert_spin_locked(&se_session->sess_cmd_lock);
> +	WARN_ON_ONCE(!irqs_disabled());

Btw, I looked a the code and can't really see what sess_cmd_lock is
supposed to protect here.

> +		sess = cmd->se_sess;
> +		if (WARN_ON_ONCE(!sess))
> +			continue;
> +
> +		spin_lock(&sess->sess_cmd_lock);
> +		rc = __target_check_io_state(cmd);
> +		spin_unlock(&sess->sess_cmd_lock);
> +		if (!rc) {
> +			printk("LUN_RESET I/O: non-zero kref_get_unless_zero\n");
> +			continue;
> +		}

And thus why we care about taking it here.
