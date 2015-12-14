From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/20] qla2xxx: Add TAS detection for kernel 3.15 n newer
Date: Mon, 14 Dec 2015 02:37:01 -0800
Message-ID: <20151214103701.GB8095@infradead.org>
References: <1449535747-2850-1-git-send-email-himanshu.madhani@qlogic.com>
 <1449535747-2850-12-git-send-email-himanshu.madhani@qlogic.com>
 <20151208024800.GA32255@infradead.org>
 <D28DCACE.1B0B1%quinn.tran@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <D28DCACE.1B0B1%quinn.tran@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Quinn Tran <quinn.tran@qlogic.com>
Cc: Christoph Hellwig <hch@infradead.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 09, 2015 at 08:24:57PM +0000, Quinn Tran wrote:
> >> +	if (se_cmd->transport_state & CMD_T_ABORTED) {
> >> +		/* For TCM TAS support n kernel >= 3.15:
> >> +		 * This cmd is attempting to respond with "Task Aborted Status".
> >> +		 */
> >> +		if (cmd->aborted) {
> >> +			return 0;
> >> +		} else if ((cmd->state == QLA_TGT_STATE_NEED_DATA) &&
> >> +		    cmd->cmd_sent_to_fw) {
> >> +			qlt_abort_cmd(cmd);
> >> +			return 0;
> >> +		} else if (cmd->state == QLA_TGT_STATE_PROCESSED) {
> >> +			if (cmd->cmd_sent_to_fw) {
> >> +				qlt_abort_cmd(cmd);
> >> +				return 0;
> >> +			} else {	/* about to be free */
> >> +				return 0;
> >> +			}
> >> +		}
> >> +	}
> >> +
> >
> >This is really something that should be explicitly communicated
> >from the core instead of having to second guess it.
> 
> QT> The extra protection of the code here is to reduce erroneous error
> message and interaction error with our firmware. I think communicating
> back to the core at this stage might add undue complication.  It?s best to
> allow the initiator to re-drive the command at this point.

I agree with that statement, just not how it's done.  Having parallel
command state machines in the driver and core isn't something that's
maintainable.  We need to attack the root cause instead of trying
to hack around it in drivers.
