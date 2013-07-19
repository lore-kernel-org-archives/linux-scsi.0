From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH v4 3/4] [SCSI] sg: checking sdp->detached isn't
 protected when open
Date: Fri, 19 Jul 2013 17:24:32 -0400
Message-ID: <20130719212432.GC29404@logfs.org>
References: <20130715203730.GA21804@logfs.org>
 <1374075246-22923-1-git-send-email-vaughan.cao@oracle.com>
 <1374075246-22923-4-git-send-email-vaughan.cao@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1374075246-22923-4-git-send-email-vaughan.cao@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vaughan Cao <vaughan.cao@oracle.com>
Cc: dgilbert@interlog.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 17 July 2013 23:34:05 +0800, Vaughan Cao wrote:
>
> -static Sg_fd *sg_add_sfp(Sg_device * sdp, int dev);
> +static Sg_fd *sg_add_sfp(Sg_device * sdp, int dev, int * reason);

You can use ERR_PTR and friends instead of adding another parameter.

>  static void sg_remove_sfp(struct kref *);
>  static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id);
>  static Sg_request *sg_add_request(Sg_fd * sfp);
> @@ -295,21 +295,14 @@ sg_open(struct inode *inode, struct file *filp)
>  	if (flags & O_EXCL)
>  		sdp->exclude =3D 1;	/* used by release lock */
> =20
> -	if (sdp->detached) {
> -		retval =3D -ENODEV;
> -		goto sem_out;
> -	}
>  	if (sfds_list_empty(sdp)) {	/* no existing opens on this device */
>  		sdp->sgdebug =3D 0;
>  		q =3D sdp->device->request_queue;
>  		sdp->sg_tablesize =3D queue_max_segments(q);
>  	}
> -	if ((sfp =3D sg_add_sfp(sdp, dev)))
> -		filp->private_data =3D sfp;
> -	else {
> -		retval =3D -ENOMEM;
> +	if (!(sfp =3D sg_add_sfp(sdp, dev, &retval)))
>  		goto sem_out;
> -	}

	sfp =3D sg_add_sfp(sdp, dev);
	if (IS_ERR(sfp)) {
		retval =3D PTR_ERR(sfp);
		goto sem_out;
	}

> +	filp->private_data =3D sfp;
>  	retval =3D 0;
> =20
>  	if (retval) {
> @@ -2047,15 +2040,18 @@ sg_remove_request(Sg_fd * sfp, Sg_request * s=
rp)
>  }
> =20
>  static Sg_fd *
> -sg_add_sfp(Sg_device * sdp, int dev)
> +sg_add_sfp(Sg_device * sdp, int dev, int * reason)
>  {
>  	Sg_fd *sfp;
>  	unsigned long iflags;
>  	int bufflen;
> =20
>  	sfp =3D kzalloc(sizeof(*sfp), GFP_ATOMIC | __GFP_NOWARN);
> -	if (!sfp)
> +	if (!sfp) {
> +		if (reason)
> +			*reason =3D -ENOMEM;
>  		return NULL;
> +	}

	if (!sfp)
		return ERR_PTR(-ENOMEM);

J=C3=B6rn

--
Luck is when opportunity meets good preparation.
-- Chinese proverb
