From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mpath: Fix setup_scsi_dh()
Date: Mon, 17 Sep 2018 11:11:14 -0400
Message-ID: <20180917151113.GA30042@redhat.com>
References: <20180917033354.30745-1-bvanassche@acm.org>
	<20180917142046.GA52842@redhat.com>
	<31642b58-a1de-a162-e9db-46e5a589e2b9@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <31642b58-a1de-a162-e9db-46e5a589e2b9@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bvanassche@acm.org>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 17 2018 at 10:51am -0400,
Bart Van Assche <bvanassche@acm.org> wrote:

> On 9/17/18 7:20 AM, Mike Snitzer wrote:
> >>- Avoid that m->hw_handler_name becomes a dangling pointer if the
> >>   RETAIN_ATTACHED_HW_HANDLER flag is set and scsi_dh_attach() returns
> >>   -EBUSY.
> >
> >What is the concern about a dangling pointer?  How does that manifest?
> >Stale scsi_dh name stored in hw_handler_name?  Pretty sure it gets freed
> >and reassigned as needed (at the start of setup_scsi_dh).
> 
> Hello Mike,
> 
> Thanks for having taken a look. Before commit e8f74a0f0011, if both
> MPATHF_RETAIN_ATTACHED_HW_HANDLER and m->hw_handler_name are set
> before setup_scsi_dh() is called and if scsi_dh_attach() returns
> -EBUSY, scsi_dh_attached_handler_name() was called twice and
> allocated memory twice for the handler name. Since commit
> e8f74a0f0011, in that scenario, the following code related to the
> handler name is executed:
> 
> 	kfree(m->hw_handler_name);
> 	m->hw_handler_name = attached_handler_name;
> 	[ scsi_dh_attach() returns -EBUSY ]
> 	kfree(m->hw_handler_name);
> 	m->hw_handler_name = attached_handler_name;
> 
> I think this sequence makes m->hw_handler_name a dangling pointer.

Ah I see.  My patch happened to fix that up by resetting
attached_handler_name to NULL and also checking it for NULL during 'goto
retain'.

> >diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> >index d94ba6f72ff5..688ac9e719a7 100644
> >--- a/drivers/md/dm-mpath.c
> >+++ b/drivers/md/dm-mpath.c
> >@@ -806,14 +806,14 @@ static int parse_path_selector(struct dm_arg_set *as, struct priority_group *pg,
> >  }
> >  static int setup_scsi_dh(struct block_device *bdev, struct multipath *m,
> >-			 const char *attached_handler_name, char **error)
> >+			 char **attached_handler_name, char **error)
> >  {
> >  	struct request_queue *q = bdev_get_queue(bdev);
> >  	int r;
> >  	if (test_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags)) {
> >  retain:
> >-		if (attached_handler_name) {
> >+		if (*attached_handler_name) {
> >  			/*
> >  			 * Clear any hw_handler_params associated with a
> >  			 * handler that isn't already attached.
> >@@ -830,7 +830,8 @@ static int setup_scsi_dh(struct block_device *bdev, struct multipath *m,
> >  			 * handler instead of the original table passed in.
> >  			 */
> >  			kfree(m->hw_handler_name);
> >-			m->hw_handler_name = attached_handler_name;
> >+			m->hw_handler_name = *attached_handler_name;
> >+			*attached_handler_name = NULL;
> >  		}
> >  	}
> >@@ -867,7 +868,7 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
> >  	struct pgpath *p;
> >  	struct multipath *m = ti->private;
> >  	struct request_queue *q;
> >-	const char *attached_handler_name;
> >+	char *attached_handler_name = NULL;
> >  	/* we need at least a path arg */
> >  	if (as->argc < 1) {
> >@@ -890,7 +891,7 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
> >  	attached_handler_name = scsi_dh_attached_handler_name(q, GFP_KERNEL);
> >  	if (attached_handler_name || m->hw_handler_name) {
> >  		INIT_DELAYED_WORK(&p->activate_path, activate_path_work);
> >-		r = setup_scsi_dh(p->path.dev->bdev, m, attached_handler_name, &ti->error);
> >+		r = setup_scsi_dh(p->path.dev->bdev, m, &attached_handler_name, &ti->error);
> >  		if (r) {
> >  			dm_put_device(ti, p->path.dev);
> >  			goto bad;
> >@@ -905,6 +906,8 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
> >  	return p;
> >   bad:
> >+	if (attached_handler_name)
> >+		kfree(attached_handler_name);
> >  	free_pgpath(p);
> >  	return ERR_PTR(r);
> >  }
> 
> Except that the if (attached_handler_name) should be removed from
> before the kfree() call, the above looks good to me.

Yeah, sure, since kfree() checks for NULL.

> But since we can avoid changing the type of attached_handler_name from
> char * into char ** by moving the kfree() call into setup_scsi_dh(), I
> prefer to avoid to make that change.

Moving kfree() into setup_scsi_dh() would require use of a common goto
for cleanup (something parse_path() already has with 'goto bad;').

But having kfree() in parse_path() is cleaner/symmetric since call to
scsi_dh_attached_handler_name() -- and associated memory allocation --
occurs in parse_path().

If you're OK with this, I'll get a proper patch staged based on your
header and obviously add a Reported-by attributed to you.

Thanks,
Mike
