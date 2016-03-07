From: Christoph Hellwig <hch@lst.de>
Subject: -EAGAIN and -ENOMEM from ->bi_end_io, was Re: [PATCH-v2 2/2]
	target/iblock: Use -EAGAIN/-ENOMEM to propigate SAM
	BUSY/TASK_SET_FULL
Date: Mon, 7 Mar 2016 17:18:54 +0100
Message-ID: <20160307161854.GA25341@lst.de>
References: <1457161634-15756-1-git-send-email-nab@daterainc.com> <1457161634-15756-2-git-send-email-nab@daterainc.com> <20160305210108.GA16337@lst.de> <1457218287.28660.70.camel@haakon3.risingtidesystems.com> <20160306061910.GA1116@infradead.org> <1457301315.32532.12.camel@haakon3.risingtidesystems.com> <20160307075548.GB13884@lst.de> <1457337836.10643.2.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1457337836.10643.2.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Andy Grover <agrover@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Christie <mchristi@redhat.com>, axboe@kernel.dk, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 07, 2016 at 12:03:56AM -0800, Nicholas A. Bellinger wrote:
> > On Sun, Mar 06, 2016 at 01:55:15PM -0800, Nicholas A. Bellinger wro=
te:
> > > The intended use is for any make_request_fn() based driver that i=
nvokes
> > > bio_endio() completion directly, and sets bi_error !=3D 0 to sign=
al
> > > non GOOD status to target/iblock.
> >=20
> > But -EAGAIN and -ENOMEM are not valid drivers for bio_endio,
>=20
> Why..?
>=20
> >  and as far as I can tell no driver every returns them.
>=20
> Correct, it's a new capability for make_request_fn() based drivers us=
ing
> target/iblock export.

Please only use it once drivers, filesystem and the block layer
can deal with it.

Right now -EAGAIN and -ENOMEM are treated as an unknown error by all
consumers of bios, so you will get a hard error and file system shutdow=
n.

What is your driver that is going to return this, and how does it know
it's =D1=95afe to do so?

> >  So as-is this might be well intended but either useless or broken.
> > --
>=20
> No, it useful for hosts that have an aggressive SCSI timeout, and it
> works as expected with Linux/SCSI hosts that either retry on BUSY
> status, or retry + reduce queue_depth on TASK_SET_FULL status.

I explicitly wrote "as-is".  We need a way to opt into this behavior,
and we also somehow need to communicate the timeout.  I think allowing
timeouts for bios is useful, but it needs a lot more work than this
quick hack, which seems to still be missing a driver to actually
generate these errors.
