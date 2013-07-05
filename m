From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH v2 1/1] [SCSI] sg: fix race condition when do exclusive
 open
Date: Fri, 5 Jul 2013 13:39:53 -0400
Message-ID: <20130705173953.GA15089@logfs.org>
References: <51AF0269.9070900@oracle.com>
 <20130605132746.GA1690@logfs.org>
 <51AF646D.7030903@oracle.com>
 <20130605154106.GA2737@logfs.org>
 <51BF0ADD.1080604@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59747 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab3GETKs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jul 2013 15:10:48 -0400
Content-Disposition: inline
In-Reply-To: <51BF0ADD.1080604@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vaughan <vaughan.cao@oracle.com>
Cc: dgilbert@interlog.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, vaughan.cao@gmail.com, xitao.cao@gmail.com

Sorry about replying so late.

On Mon, 17 June 2013 21:10:53 +0800, vaughan wrote:
>=20
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
=2E..
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
                                            ^
I think the 'toopen' is a bad choice.  I'm having trouble wrapping my
head around the semantics of this variable, your description feels a
bit handwavy, the main noun is missing in the command above, I think I
found one more overflow bug,...

What you ended up doing is reimplement a rw_semaphone.  Why not use
one instead?  down_write() for exclusive access, down_read() for
non-exclusive, _trylock variants for nonblocking opens, etc.

Would this work?

J=C3=B6rn

--
I've never met a human being who would want to read 17,000 pages of
documentation, and if there was, I'd kill him to get him out of the
gene pool.
-- Joseph Costello
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
