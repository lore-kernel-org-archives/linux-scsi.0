From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH] block: Check that queue is alive in blk_insert_cloned_request()
Date: Mon, 11 Jul 2011 18:40:11 -0400
Message-ID: <CAMM=eLfzKuw-2vbERV6D7dAHb1BWopOKZ=dB7vWxcxSCoj6Tkw@mail.gmail.com>
References: <CAG4TOxMjuntpd3Q5jgn+xDa2tgB9tq+jLcDquM_eAdFHXLDrWA@mail.gmail.com>
 <1310166270-23196-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1310166270-23196-1-git-send-email-roland@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

[cc'ing dm-devel, vivek and tejun]

On Fri, Jul 8, 2011 at 7:04 PM, Roland Dreier <roland@kernel.org> wrote=
:
> From: Roland Dreier <roland@purestorage.com>
>
> This fixes crashes such as the below that I see when the storage
> underlying a dm-multipath device is hot-removed. =A0The problem is th=
at
> dm requeues a request to a device whose block queue has already been
> cleaned up, and blk_insert_cloned_request() doesn't check if the queu=
e
> is alive, but rather goes ahead and tries to queue the request. =A0Th=
is
> ends up dereferencing the elevator that was already freed in
> blk_cleanup_queue().

Your patch looks fine to me:
Acked-by: Mike Snitzer <snitzer@redhat.com>

And I looked at various code paths to arrive at the references DM takes=
=2E

A reference is taken on the underlying devices' block_device via
drivers/md/dm-table.c:open_dev() with blkdev_get_by_dev().  open_dev()
also does bd_link_disk_holder(), resulting in the mpath device
becoming a holder of the underlying devices. e.g.:
/sys/block/sda/holders/dm-4

But at no point does DM-mpath get a reference to the underlying
devices' request_queue that gets assigned to clone->q (in
drivers/md/dm-mpath.c:map_io).

Seems we should, though AFAIK it won't help with the issue you've
pointed out (because the hotplugged device's driver already called
blk_cleanup_queue and nuked the elevator).

So I'm not sure getting the request_queue reference actually fixes
anything (maybe my imagination is lacking?).  But getting the
request_queue reference is "the right thing" if we're going to be
setting pointers to it.
