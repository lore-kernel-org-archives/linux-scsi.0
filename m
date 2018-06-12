From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/2] Convert target drivers to use sbitmap
Date: Tue, 12 Jun 2018 16:32:03 +0000
Message-ID: <0c93c72a3a339f3479f82de04223315671e07863.camel@wdc.com>
References: <20180515160043.27044-1-willy@infradead.org>
	<20180515160043.27044-2-willy@infradead.org>
	<da5220a5ed4bed210c31a7517389e787a3b1a01f.camel@wdc.com>
	<20180612161526.GE19433@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20180612161526.GE19433@bombadil.infradead.org>
Content-Language: en-US
Content-ID: <7AFD8DDA9AA78A4B982D4D376906EE4E@namprd04.prod.outlook.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "willy@infradead.org" <willy@infradead.org>
Cc: "jgross@suse.com" <jgross@suse.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "mawilcox@microsoft.com" <mawilcox@microsoft.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "qla2xxx-upstream@qlogic.com" <qla2xxx-upstream@qlogic.com>, "linux1394-devel@lists.sourceforge.net" <linux1394-devel@lists.sourceforge.net>, "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2018-06-12 at 09:15 -0700, Matthew Wilcox wrote:
> On Tue, Jun 12, 2018 at 03:22:42PM +0000, Bart Van Assche wrote:
> > On Tue, 2018-05-15 at 09:00 -0700, Matthew Wilcox wrote:
> > > diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> > > index 025dc2d3f3de..cdf671c2af61 100644
> > > --- a/drivers/scsi/qla2xxx/qla_target.c
> > > +++ b/drivers/scsi/qla2xxx/qla_target.c
> > > @@ -3719,7 +3719,8 @@ void qlt_free_cmd(struct qla_tgt_cmd *cmd)
> > >  		return;
> > >  	}
> > >  	cmd->jiffies_at_free = get_jiffies_64();
> > > -	percpu_ida_free(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag);
> > > +	sbitmap_queue_clear(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag,
> > > +			cmd->se_cmd.map_cpu);
> > >  }
> > >  EXPORT_SYMBOL(qlt_free_cmd);
> > 
> > Please introduce functions in the target core for allocating and freeing a tag
> > instead of spreading the knowledge of how to allocate and free tags over all
> > target drivers.
> 
> I can't without doing an unreasonably large amount of work on drivers that
> I have no way to test.  Some of the drivers have the se_cmd already; some
> of them don't.  I'd be happy to introduce a common function for freeing
> a tag.

Which target drivers are you referring to? If you are referring to the sbp driver:
I think that driver is dead and can be removed from the kernel tree. I even don't
know whether that driver ever has had any users other than the developer of that
driver.

> > This looks weird to me. Shouldn't target code ignore signals instead of causing
> > tag allocation to fail if a signal is received?
> 
> It's what the current code did:
> 
> -               if (signal_pending_state(state, current)) {
> -                       tag = -ERESTARTSYS;
> -                       break;
> -               }
> 
> and the current callers literally indicate that they want signals:
> 
> drivers/infiniband/ulp/isert/ib_isert.c:        cmd = iscsit_allocate_cmd(conn, TASK_INTERRUPTIBLE);
> drivers/target/iscsi/iscsi_target.c:    cmd = iscsit_allocate_cmd(conn, TASK_INTERRUPTIBLE);

Right, the iSCSI target driver uses signals to wake up threads (see also the
send_sig() calls in the iSCSI target code).

Bart.
