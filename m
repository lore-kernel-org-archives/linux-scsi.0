From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 1/2] Convert target drivers to use sbitmap
Date: Tue, 12 Jun 2018 09:15:26 -0700
Message-ID: <20180612161526.GE19433@bombadil.infradead.org>
References: <20180515160043.27044-1-willy@infradead.org>
 <20180515160043.27044-2-willy@infradead.org>
 <da5220a5ed4bed210c31a7517389e787a3b1a01f.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <da5220a5ed4bed210c31a7517389e787a3b1a01f.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>, "linux1394-devel@lists.sourceforge.net" <linux1394-devel@lists.sourceforge.net>, "jgross@suse.com" <jgross@suse.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "qla2xxx-upstream@qlogic.com" <qla2xxx-upstream@qlogic.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "mawilcox@microsoft.com" <mawilcox@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 12, 2018 at 03:22:42PM +0000, Bart Van Assche wrote:
> On Tue, 2018-05-15 at 09:00 -0700, Matthew Wilcox wrote:
> > diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> > index 025dc2d3f3de..cdf671c2af61 100644
> > --- a/drivers/scsi/qla2xxx/qla_target.c
> > +++ b/drivers/scsi/qla2xxx/qla_target.c
> > @@ -3719,7 +3719,8 @@ void qlt_free_cmd(struct qla_tgt_cmd *cmd)
> >  		return;
> >  	}
> >  	cmd->jiffies_at_free = get_jiffies_64();
> > -	percpu_ida_free(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag);
> > +	sbitmap_queue_clear(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag,
> > +			cmd->se_cmd.map_cpu);
> >  }
> >  EXPORT_SYMBOL(qlt_free_cmd);
> 
> Please introduce functions in the target core for allocating and freeing a tag
> instead of spreading the knowledge of how to allocate and free tags over all
> target drivers.

I can't without doing an unreasonably large amount of work on drivers that
I have no way to test.  Some of the drivers have the se_cmd already; some
of them don't.  I'd be happy to introduce a common function for freeing
a tag.

> > +int iscsit_wait_for_tag(struct se_session *se_sess, int state, int *cpup)
> > +{
> > +	int tag = -1;
> > +	DEFINE_WAIT(wait);
> > +	struct sbq_wait_state *ws;
> > +
> > +	if (state == TASK_RUNNING)
> > +		return tag;
> > +
> > +	ws = &se_sess->sess_tag_pool.ws[0];
> > +	for (;;) {
> > +		prepare_to_wait_exclusive(&ws->wait, &wait, state);
> > +		if (signal_pending_state(state, current))
> > +			break;
> 
> This looks weird to me. Shouldn't target code ignore signals instead of causing
> tag allocation to fail if a signal is received?

It's what the current code did:

-               if (signal_pending_state(state, current)) {
-                       tag = -ERESTARTSYS;
-                       break;
-               }

and the current callers literally indicate that they want signals:

drivers/infiniband/ulp/isert/ib_isert.c:        cmd = iscsit_allocate_cmd(conn, TASK_INTERRUPTIBLE);
drivers/target/iscsi/iscsi_target.c:    cmd = iscsit_allocate_cmd(conn, TASK_INTERRUPTIBLE);

(etc)
