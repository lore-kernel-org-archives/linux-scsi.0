From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: -EAGAIN and -ENOMEM from ->bi_end_io, was Re: [PATCH-v2 2/2]
 target/iblock: Use -EAGAIN/-ENOMEM to propigate SAM BUSY/TASK_SET_FULL
Date: Mon, 07 Mar 2016 14:39:29 -0800
Message-ID: <1457390369.30747.28.camel@haakon3.risingtidesystems.com>
References: <1457161634-15756-1-git-send-email-nab@daterainc.com>
	 <1457161634-15756-2-git-send-email-nab@daterainc.com>
	 <20160305210108.GA16337@lst.de>
	 <1457218287.28660.70.camel@haakon3.risingtidesystems.com>
	 <20160306061910.GA1116@infradead.org>
	 <1457301315.32532.12.camel@haakon3.risingtidesystems.com>
	 <20160307075548.GB13884@lst.de>
	 <1457337836.10643.2.camel@haakon3.risingtidesystems.com>
	 <20160307161854.GA25341@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:42832 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbcCGWjd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2016 17:39:33 -0500
In-Reply-To: <20160307161854.GA25341@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Andy Grover <agrover@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Christie <mchristi@redhat.com>, axboe@kernel.dk, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, 2016-03-07 at 17:18 +0100, Christoph Hellwig wrote:
> On Mon, Mar 07, 2016 at 12:03:56AM -0800, Nicholas A. Bellinger wrote=
:
> > > On Sun, Mar 06, 2016 at 01:55:15PM -0800, Nicholas A. Bellinger w=
rote:
> > > > The intended use is for any make_request_fn() based driver that=
 invokes
> > > > bio_endio() completion directly, and sets bi_error !=3D 0 to si=
gnal
> > > > non GOOD status to target/iblock.
> > >=20
> > > But -EAGAIN and -ENOMEM are not valid drivers for bio_endio,
> >=20
> > Why..?
> >=20
> > >  and as far as I can tell no driver every returns them.
> >=20
> > Correct, it's a new capability for make_request_fn() based drivers =
using
> > target/iblock export.
>=20
> Please only use it once drivers, filesystem and the block layer
> can deal with it.
>=20
> Right now -EAGAIN and -ENOMEM are treated as an unknown error by all
> consumers of bios, so you will get a hard error and file system shutd=
own.
>=20

Yes, the driver needs a way to determine when a bio was submitted via
target/iblock, and it's completion consumer is capable of processing a
non-zero bi_error as retryable.

> What is your driver that is going to return this, and how does it kno=
w
> it's =D1=95afe to do so?

I've been using this with an out-of-tree driver for a while now, but th=
e
most obvious upstream candidate who can benefit from this is RBD.

>=20
> > >  So as-is this might be well intended but either useless or broke=
n.
> > > --
> >=20
> > No, it useful for hosts that have an aggressive SCSI timeout, and i=
t
> > works as expected with Linux/SCSI hosts that either retry on BUSY
> > status, or retry + reduce queue_depth on TASK_SET_FULL status.
>=20
> I explicitly wrote "as-is".  We need a way to opt into this behavior,
> and we also somehow need to communicate the timeout.

What did you have in mind..?

>  I think allowing
> timeouts for bios is useful, but it needs a lot more work than this
> quick hack,

=46rom the target side, it's not a quick hack.

These initial target/iblock changes for processing non-zero bi_error +
propagating up to target-core won't change regardless of how the
underlying driver determines if a completion consumer supports retryabl=
e
bio status, or not.

> which seems to still be missing a driver to actually
> generate these errors.

I'll include the BRD patch I've been using as the first user of this
code.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
