From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v3 1/5] target: Fix LUN_RESET active I/O handling for
 ACK_KREF
Date: Tue, 02 Feb 2016 15:20:30 -0800
Message-ID: <1454455230.25549.30.camel@haakon3.risingtidesystems.com>
References: <1454132222-29009-1-git-send-email-nab@daterainc.com>
	 <1454132222-29009-2-git-send-email-nab@daterainc.com>
	 <20160202093741.GA26933@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:52522 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbcBBXUd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2016 18:20:33 -0500
In-Reply-To: <20160202093741.GA26933@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>

On Tue, 2016-02-02 at 10:37 +0100, Christoph Hellwig wrote:
> > @@ -282,6 +305,16 @@ static void core_tmr_drain_state_list(
> >  		if (prout_cmd == cmd)
> >  			continue;
> >  
> > +		sess = cmd->se_sess;
> > +		if (WARN_ON_ONCE(!sess))
> > +			continue;
> > +
> > +		spin_lock(&sess->sess_cmd_lock);
> > +		rc = __target_check_io_state(cmd);
> > +		spin_unlock(&sess->sess_cmd_lock);
> > +		if (!rc)
> > +			continue;
> > +
> 
> I still don't understand why we care about the session or sess_cmd_lock
> here.  There isn't anything in __target_check_io_state that relies
> on them (except for the assert checking the lock).

Like I said earlier:

"I'm still working on -v3 series to handle se_session shutdown during
this specific multi-port LUN_RESET case, and considering using the
existing se_cmd->cmd_wait_set bit to signal when this special case
happens.

Currently ->sess_cmd_lock is held in target_release_cmd_kref() and
target_sess_cmd_list_set_waiting() while checking and setting this
value."


