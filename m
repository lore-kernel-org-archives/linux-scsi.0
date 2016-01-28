From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 1/3] target: Fix LUN_RESET active I/O handling for
 ACK_KREF
Date: Wed, 27 Jan 2016 21:34:42 -0800
Message-ID: <1453959282.6746.213.camel@haakon3.risingtidesystems.com>
References: <1453513067-23169-1-git-send-email-nab@daterainc.com>
	 <1453513067-23169-2-git-send-email-nab@daterainc.com>
	 <20160126171900.GA3663@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160126171900.GA3663@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2016-01-26 at 18:19 +0100, Christoph Hellwig wrote:
> > +static bool __target_check_io_state(struct se_cmd *se_cmd)
> > +{
> > +	struct se_session *sess = se_cmd->se_sess;
> > +
> > +	assert_spin_locked(&se_session->sess_cmd_lock);
> > +	WARN_ON_ONCE(!irqs_disabled());
> 
> Btw, I looked a the code and can't really see what sess_cmd_lock is
> supposed to protect here.
> 
> > +		sess = cmd->se_sess;
> > +		if (WARN_ON_ONCE(!sess))
> > +			continue;
> > +
> > +		spin_lock(&sess->sess_cmd_lock);
> > +		rc = __target_check_io_state(cmd);
> > +		spin_unlock(&sess->sess_cmd_lock);
> > +		if (!rc) {
> > +			printk("LUN_RESET I/O: non-zero kref_get_unless_zero\n");
> > +			continue;
> > +		}
> 
> And thus why we care about taking it here.

I'm still working on -v3 series to handle se_session shutdown during
this specific multi-port LUN_RESET case, and considering using the
existing se_cmd->cmd_wait_set bit to signal when this special case
happens.

Currently ->sess_cmd_lock is held in target_release_cmd_kref() and
target_sess_cmd_list_set_waiting() while checking and setting this
value.
