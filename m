From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mpath: Fix setup_scsi_dh()
Date: Mon, 17 Sep 2018 10:20:47 -0400
Message-ID: <20180917142046.GA52842@redhat.com>
References: <20180917033354.30745-1-bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180917033354.30745-1-bvanassche@acm.org>
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

[dropping stable@ cc and cc'ing linux-scsi instead]

On Sun, Sep 16 2018 at 11:33pm -0400,
Bart Van Assche <bvanassche@acm.org> wrote:

> This patch fixes two bugs that got introduced recently in setup_scsi_dh():
> - Avoid that a memory leak occurs if attached_handler_name is not assigned
>   to m->hw_handler_name.

I do see potential for leak, but I'd prefer to fix it with something
like the patch at the end of this mail.

> - Avoid that m->hw_handler_name becomes a dangling pointer if the
>   RETAIN_ATTACHED_HW_HANDLER flag is set and scsi_dh_attach() returns
>   -EBUSY.

What is the concern about a dangling pointer?  How does that manifest?
Stale scsi_dh name stored in hw_handler_name?  Pretty sure it gets freed
and reassigned as needed (at the start of setup_scsi_dh).

> ---
>  drivers/md/dm-mpath.c      | 14 +++++++++-----
>  include/scsi/scsi_device.h |  9 +++++++++
>  2 files changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index d94ba6f72ff5..0ba58a537182 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -867,7 +870,7 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
>  	struct pgpath *p;
>  	struct multipath *m = ti->private;
>  	struct request_queue *q;
> -	const char *attached_handler_name;
> +	struct scsi_device *sdev;
>  
>  	/* we need at least a path arg */
>  	if (as->argc < 1) {
> @@ -887,10 +890,11 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
>  	}
>  
>  	q = bdev_get_queue(p->path.dev->bdev);
> -	attached_handler_name = scsi_dh_attached_handler_name(q, GFP_KERNEL);
> -	if (attached_handler_name || m->hw_handler_name) {
> +	sdev = scsi_device_from_queue(q);
> +	if (sdev) {
> +		put_device(&sdev->sdev_gendev);
>  		INIT_DELAYED_WORK(&p->activate_path, activate_path_work);
> -		r = setup_scsi_dh(p->path.dev->bdev, m, attached_handler_name, &ti->error);
> +		r = setup_scsi_dh(p->path.dev->bdev, m, &ti->error);
>  		if (r) {
>  			dm_put_device(ti, p->path.dev);
>  			goto bad;

Just because it is a scsi device doesn't mean a scsi_dh needs to be
established (though usually that _is_ the case).

But bigger concern is I'd _really_ rather avoid dm-mpath instantiating
'struct scsi_device'.

scsi_dh_attached_handler_name() provides a more opaque interface.

Uncompiled and untested patch to fix leak follows:

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index d94ba6f72ff5..688ac9e719a7 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -806,14 +806,14 @@ static int parse_path_selector(struct dm_arg_set *as, struct priority_group *pg,
 }
 
 static int setup_scsi_dh(struct block_device *bdev, struct multipath *m,
-			 const char *attached_handler_name, char **error)
+			 char **attached_handler_name, char **error)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
 	int r;
 
 	if (test_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags)) {
 retain:
-		if (attached_handler_name) {
+		if (*attached_handler_name) {
 			/*
 			 * Clear any hw_handler_params associated with a
 			 * handler that isn't already attached.
@@ -830,7 +830,8 @@ static int setup_scsi_dh(struct block_device *bdev, struct multipath *m,
 			 * handler instead of the original table passed in.
 			 */
 			kfree(m->hw_handler_name);
-			m->hw_handler_name = attached_handler_name;
+			m->hw_handler_name = *attached_handler_name;
+			*attached_handler_name = NULL;
 		}
 	}
 
@@ -867,7 +868,7 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 	struct pgpath *p;
 	struct multipath *m = ti->private;
 	struct request_queue *q;
-	const char *attached_handler_name;
+	char *attached_handler_name = NULL;
 
 	/* we need at least a path arg */
 	if (as->argc < 1) {
@@ -890,7 +891,7 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 	attached_handler_name = scsi_dh_attached_handler_name(q, GFP_KERNEL);
 	if (attached_handler_name || m->hw_handler_name) {
 		INIT_DELAYED_WORK(&p->activate_path, activate_path_work);
-		r = setup_scsi_dh(p->path.dev->bdev, m, attached_handler_name, &ti->error);
+		r = setup_scsi_dh(p->path.dev->bdev, m, &attached_handler_name, &ti->error);
 		if (r) {
 			dm_put_device(ti, p->path.dev);
 			goto bad;
@@ -905,6 +906,8 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 
 	return p;
  bad:
+	if (attached_handler_name)
+		kfree(attached_handler_name);
 	free_pgpath(p);
 	return ERR_PTR(r);
 }
