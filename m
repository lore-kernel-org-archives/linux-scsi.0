From: vaughan <vaughan.cao@oracle.com>
Subject: Re: [PATCH v2 1/1] [SCSI] sg: fix race condition when do exclusive
 open
Date: Wed, 26 Jun 2013 09:37:59 +0800
Message-ID: <51CA45F7.9020404@oracle.com>
References: <51AF0269.9070900@oracle.com> <20130605132746.GA1690@logfs.org> <51AF646D.7030903@oracle.com> <20130605154106.GA2737@logfs.org> <51BF0ADD.1080604@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51BF0ADD.1080604@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
Cc: dgilbert@interlog.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, vaughan.cao@gmail.com, xitao.cao@gmail.com
List-Id: linux-scsi@vger.kernel.org

Hi J=C3=B6rn Engel,

Ping.
How about this one? I found my lat patch hasn't fix the issue, so I
modified it a little more. Last thread is:
Subject: Re: [PATCH] sg: atomize check and set sdp->exclude in sg_open
Message-ID: <20130605154106.GA2737@logfs.org>

Regards,
Vaughan

=E4=BA=8E 2013=E5=B9=B406=E6=9C=8817=E6=97=A5 21:10, vaughan =E5=86=99=E9=
=81=93:
> Rewrite the last patch.
> Add a new field 'toopen' in sg_device to count ongoing sg_open's. By =
checking both 'toopen' and 'exclude' marks when do exclusive open, old =
race conditions can be avoided.
> Replace global sg_open_exclusive_lock with a per device lock - sfd_lo=
ck. Since sfds list is now protected by the lock owned by the same sg_d=
evice, sg_index_lock becomes a real global lock to only protect sg devi=
ces lookup.
> Also did some cleanup, such as remove get_exclude() and rename set_ex=
clude() to clear_exclude().
>=20
> Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
> ---
>  drivers/scsi/sg.c | 152 ++++++++++++++++++++++++++++++++------------=
----------
>  1 file changed, 90 insertions(+), 62 deletions(-)
>=20
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 25b5455..b0ea73f 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -103,11 +103,8 @@ static int scatter_elem_sz_prev =3D SG_SCATTER_S=
Z;
>  static int sg_add(struct device *, struct class_interface *);
>  static void sg_remove(struct device *, struct class_interface *);
> =20
> -static DEFINE_SPINLOCK(sg_open_exclusive_lock);
> -
>  static DEFINE_IDR(sg_index_idr);
> -static DEFINE_RWLOCK(sg_index_lock);	/* Also used to lock
> -							   file descriptor list for device */
> +static DEFINE_RWLOCK(sg_index_lock);	/* protect sg index */
> =20
>  static struct class_interface sg_interface =3D {
>  	.add_dev	=3D sg_add,
> @@ -144,7 +141,7 @@ typedef struct sg_request {	/* SG_MAX_QUEUE reque=
sts outstanding per file */
>  } Sg_request;
> =20
>  typedef struct sg_fd {		/* holds the state of a file descriptor */
> -	/* sfd_siblings is protected by sg_index_lock */
> +	/* sfd_siblings is protected by sfd_lock of sg_device */
>  	struct list_head sfd_siblings;
>  	struct sg_device *parentdp;	/* owning device */
>  	wait_queue_head_t read_wait;	/* queue read until command done */
> @@ -171,10 +168,10 @@ typedef struct sg_device { /* holds the state o=
f each scsi generic device */
>  	wait_queue_head_t o_excl_wait;	/* queue open() when O_EXCL in use *=
/
>  	int sg_tablesize;	/* adapter's max scatter-gather table size */
>  	u32 index;		/* device index number */
> -	/* sfds is protected by sg_index_lock */
> +	spinlock_t sfd_lock;	/* protect sfds, exclude, toopen */
>  	struct list_head sfds;
> +	int toopen;		/* number of who are ready to open sg */
>  	volatile char detached;	/* 0->attached, 1->detached pending removal=
 */
> -	/* exclude protected by sg_open_exclusive_lock */
>  	char exclude;		/* opened for exclusive access */
>  	char sgdebug;		/* 0->off, 1->sense, 9->dump dev, 10-> all devs */
>  	struct gendisk *disk;
> @@ -224,25 +221,44 @@ static int sg_allow_access(struct file *filp, u=
nsigned char *cmd)
>  	return blk_verify_command(q, cmd, filp->f_mode & FMODE_WRITE);
>  }
> =20
> -static int get_exclude(Sg_device *sdp)
> +static void clear_exclude(Sg_device *sdp)
>  {
>  	unsigned long flags;
> -	int ret;
> =20
> -	spin_lock_irqsave(&sg_open_exclusive_lock, flags);
> -	ret =3D sdp->exclude;
> -	spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
> +	spin_lock_irqsave(&sdp->sfd_lock, flags);
> +	sdp->exclude =3D 0;
> +	spin_unlock_irqrestore(&sdp->sfd_lock, flags);
> +	return;
> +}
> +
> +/* we can add exclusively only when no other addition is going on */
> +static int try_add_exclude(Sg_device *sdp)
> +{
> +	unsigned long flags;
> +	int ret =3D 0;
> +
> +	spin_lock_irqsave(&sdp->sfd_lock, flags);
> +	if (list_empty(&sdp->sfds) && !sdp->toopen) {
> +		sdp->exclude =3D 1;
> +		sdp->toopen++;
> +		ret =3D 1;
> +	}
> +	spin_unlock_irqrestore(&sdp->sfd_lock, flags);
>  	return ret;
>  }
> =20
> -static int set_exclude(Sg_device *sdp, char val)
> +static int try_add_shareable(Sg_device *sdp)
>  {
>  	unsigned long flags;
> +	int ret =3D 0;
> =20
> -	spin_lock_irqsave(&sg_open_exclusive_lock, flags);
> -	sdp->exclude =3D val;
> -	spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
> -	return val;
> +	spin_lock_irqsave(&sdp->sfd_lock, flags);
> +	if (!sdp->exclude && sdp->toopen !=3D INT_MAX) {
> +		sdp->toopen++;
> +		ret =3D 1;
> +	}
> +	spin_unlock_irqrestore(&sdp->sfd_lock, flags);
> +	return ret;
>  }
> =20
>  static int sfds_list_empty(Sg_device *sdp)
> @@ -250,9 +266,9 @@ static int sfds_list_empty(Sg_device *sdp)
>  	unsigned long flags;
>  	int ret;
> =20
> -	read_lock_irqsave(&sg_index_lock, flags);
> +	spin_lock_irqsave(&sdp->sfd_lock, flags);
>  	ret =3D list_empty(&sdp->sfds);
> -	read_unlock_irqrestore(&sg_index_lock, flags);
> +	spin_unlock_irqrestore(&sdp->sfd_lock, flags);
>  	return ret;
>  }
> =20
> @@ -266,6 +282,7 @@ sg_open(struct inode *inode, struct file *filp)
>  	Sg_fd *sfp;
>  	int res;
>  	int retval;
> +	unsigned long iflags;
> =20
>  	nonseekable_open(inode, filp);
>  	SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=3D%d, flags=3D0x%x\n", dev=
, flags));
> @@ -293,27 +310,26 @@ sg_open(struct inode *inode, struct file *filp)
>  		goto error_out;
>  	}
> =20
> -	if (flags & O_EXCL) {
> -		if (O_RDONLY =3D=3D (flags & O_ACCMODE)) {
> -			retval =3D -EPERM; /* Can't lock it with read only access */
> -			goto error_out;
> -		}
> -		if (!sfds_list_empty(sdp) && (flags & O_NONBLOCK)) {
> -			retval =3D -EBUSY;
> -			goto error_out;
> -		}
> -		res =3D wait_event_interruptible(sdp->o_excl_wait,
> -					   ((!sfds_list_empty(sdp) || get_exclude(sdp)) ? 0 : set_exclu=
de(sdp, 1)));
> -		if (res) {
> -			retval =3D res;	/* -ERESTARTSYS because signal hit process */
> -			goto error_out;
> -		}
> -	} else if (get_exclude(sdp)) {	/* some other fd has an exclusive lo=
ck on dev */
> -		if (flags & O_NONBLOCK) {
> +	if ((flags & O_EXCL) && (O_RDONLY =3D=3D (flags & O_ACCMODE))) {
> +		retval =3D -EPERM; /* Can't lock it with read only access */
> +		goto error_out;
> +	}
> +	if (flags & O_NONBLOCK) {
> +		if (flags & O_EXCL)
> +			res =3D try_add_exclude(sdp);
> +		else
> +			res =3D try_add_shareable(sdp);
> +		if (!res) {
>  			retval =3D -EBUSY;
>  			goto error_out;
>  		}
> -		res =3D wait_event_interruptible(sdp->o_excl_wait, !get_exclude(sd=
p));
> +	} else {
> +		if (flags & O_EXCL)
> +			res =3D wait_event_interruptible(sdp->o_excl_wait,
> +				try_add_exclude(sdp));
> +		else
> +			res =3D wait_event_interruptible(sdp->o_excl_wait,
> +				try_add_shareable(sdp));
>  		if (res) {
>  			retval =3D res;	/* -ERESTARTSYS because signal hit process */
>  			goto error_out;
> @@ -331,10 +347,12 @@ sg_open(struct inode *inode, struct file *filp)
>  	if ((sfp =3D sg_add_sfp(sdp, dev)))
>  		filp->private_data =3D sfp;
>  	else {
> -		if (flags & O_EXCL) {
> -			set_exclude(sdp, 0);	/* undo if error */
> -			wake_up_interruptible(&sdp->o_excl_wait);
> -		}
> +		spin_lock_irqsave(&sdp->sfd_lock, iflags);
> +		sdp->toopen--;
> +		if (flags & O_EXCL)
> +			sdp->exclude =3D 0;	/* undo if error */
> +		spin_unlock_irqrestore(&sdp->sfd_lock, iflags);
> +		wake_up_interruptible(&sdp->o_excl_wait);
>  		retval =3D -ENOMEM;
>  		goto error_out;
>  	}
> @@ -362,7 +380,7 @@ sg_release(struct inode *inode, struct file *filp=
)
>  		return -ENXIO;
>  	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_name=
));
> =20
> -	set_exclude(sdp, 0);
> +	clear_exclude(sdp);
>  	wake_up_interruptible(&sdp->o_excl_wait);
> =20
>  	scsi_autopm_put_device(sdp->device);
> @@ -1414,6 +1432,7 @@ static Sg_device *sg_alloc(struct gendisk *disk=
, struct scsi_device *scsidp)
>  	disk->first_minor =3D k;
>  	sdp->disk =3D disk;
>  	sdp->device =3D scsidp;
> +	spin_lock_init(&sdp->sfd_lock);
>  	INIT_LIST_HEAD(&sdp->sfds);
>  	init_waitqueue_head(&sdp->o_excl_wait);
>  	sdp->sg_tablesize =3D queue_max_segments(q);
> @@ -1557,10 +1576,12 @@ static void sg_remove(struct device *cl_dev, =
struct class_interface *cl_intf)
>  	/* Need a write lock to set sdp->detached. */
>  	write_lock_irqsave(&sg_index_lock, iflags);
>  	sdp->detached =3D 1;
> +	spin_lock(&sdp->sfd_lock);
>  	list_for_each_entry(sfp, &sdp->sfds, sfd_siblings) {
>  		wake_up_interruptible(&sfp->read_wait);
>  		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_HUP);
>  	}
> +	spin_unlock(&sdp->sfd_lock);
>  	write_unlock_irqrestore(&sg_index_lock, iflags);
> =20
>  	sysfs_remove_link(&scsidp->sdev_gendev.kobj, "generic");
> @@ -2085,9 +2106,12 @@ sg_add_sfp(Sg_device * sdp, int dev)
>  	sfp->cmd_q =3D SG_DEF_COMMAND_Q;
>  	sfp->keep_orphan =3D SG_DEF_KEEP_ORPHAN;
>  	sfp->parentdp =3D sdp;
> -	write_lock_irqsave(&sg_index_lock, iflags);
> +	spin_lock_irqsave(&sdp->sfd_lock, iflags);
>  	list_add_tail(&sfp->sfd_siblings, &sdp->sfds);
> -	write_unlock_irqrestore(&sg_index_lock, iflags);
> +	sdp->toopen--; /* ongoing open is complete */
> +	if (sdp->toopen =3D=3D INT_MAX-1)
> +		wake_up_interruptible(&sdp->o_excl_wait);
> +	spin_unlock_irqrestore(&sdp->sfd_lock, iflags);
>  	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp: sfp=3D0x%p\n", sfp));
>  	if (unlikely(sg_big_buff !=3D def_reserved_size))
>  		sg_big_buff =3D def_reserved_size;
> @@ -2137,9 +2161,9 @@ static void sg_remove_sfp(struct kref *kref)
>  	struct sg_device *sdp =3D sfp->parentdp;
>  	unsigned long iflags;
> =20
> -	write_lock_irqsave(&sg_index_lock, iflags);
> +	spin_lock_irqsave(&sdp->sfd_lock, iflags);
>  	list_del(&sfp->sfd_siblings);
> -	write_unlock_irqrestore(&sg_index_lock, iflags);
> +	spin_unlock_irqrestore(&sdp->sfd_lock, iflags);
>  	wake_up_interruptible(&sdp->o_excl_wait);
> =20
>  	INIT_WORK(&sfp->ew.work, sg_remove_sfp_usercontext);
> @@ -2531,7 +2555,7 @@ static int sg_proc_seq_show_devstrs(struct seq_=
file *s, void *v)
>  	return 0;
>  }
> =20
> -/* must be called while holding sg_index_lock */
> +/* must be called while holding sg_index_lock and sfd_lock */
>  static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp=
)
>  {
>  	int k, m, new_interface, blen, usg;
> @@ -2616,22 +2640,26 @@ static int sg_proc_seq_show_debug(struct seq_=
file *s, void *v)
> =20
>  	read_lock_irqsave(&sg_index_lock, iflags);
>  	sdp =3D it ? sg_lookup_dev(it->index) : NULL;
> -	if (sdp && !list_empty(&sdp->sfds)) {
> -		struct scsi_device *scsidp =3D sdp->device;
> +	if (sdp) {
> +		spin_lock(&sdp->sfd_lock);
> +		if (!list_empty(&sdp->sfds)) {
> +			struct scsi_device *scsidp =3D sdp->device;
> =20
> -		seq_printf(s, " >>> device=3D%s ", sdp->disk->disk_name);
> -		if (sdp->detached)
> -			seq_printf(s, "detached pending close ");
> -		else
> -			seq_printf
> -			    (s, "scsi%d chan=3D%d id=3D%d lun=3D%d   em=3D%d",
> -			     scsidp->host->host_no,
> -			     scsidp->channel, scsidp->id,
> -			     scsidp->lun,
> -			     scsidp->host->hostt->emulated);
> -		seq_printf(s, " sg_tablesize=3D%d excl=3D%d\n",
> -			   sdp->sg_tablesize, get_exclude(sdp));
> -		sg_proc_debug_helper(s, sdp);
> +			seq_printf(s, " >>> device=3D%s ", sdp->disk->disk_name);
> +			if (sdp->detached)
> +				seq_printf(s, "detached pending close ");
> +			else
> +				seq_printf
> +					(s, "scsi%d chan=3D%d id=3D%d lun=3D%d   em=3D%d",
> +					 scsidp->host->host_no,
> +					 scsidp->channel, scsidp->id,
> +					 scsidp->lun,
> +					 scsidp->host->hostt->emulated);
> +			seq_printf(s, " sg_tablesize=3D%d excl=3D%d\n",
> +					sdp->sg_tablesize, sdp->exclude);
> +			sg_proc_debug_helper(s, sdp);
> +		}
> +		spin_unlock(&sdp->sfd_lock);
>  	}
>  	read_unlock_irqrestore(&sg_index_lock, iflags);
>  	return 0;
>=20
