From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all block pc
	requests and simplify hw handlers
Date: Tue,  7 Jun 2005 10:36:54 -0500
Message-ID: <1118158614.42a5bf160d317@webmail.cs.wisc.edu>
References: <1117847972.23638.62.camel@mina> <1117901234.5005.9.camel@mulgrave>
	<20050607121020.GA6458@infradead.org>
	<1118146802.4998.3.camel@mulgrave>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1118146802.4998.3.camel@mulgrave>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Jens Axboe <axboe@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Quoting James Bottomley <James.Bottomley@SteelEye.com>:

> On Tue, 2005-06-07 at 13:10 +0100, Christoph Hellwig wrote:
> > shouldn't blk_rq_map_kern handle a 0 buffer and do nothing more than
> > blk_get_request?  It's not exactly a criticial fastpath and that woul=
d make
> life
> > easier for the callers.
>=20
> Yes ... and it should probably do bio bouncing as well, since there's
> nothing special we have to do on completion to clean it up.

ok. I just made it like the existing blk_rq_map_user which made the calle=
r do
those things.

>=20
> I also think we might need a blk_rq_kern_iovec call that would take a
> vector of user I/O's and map it to a multiple bio request.  This would

Does it need to be a multiple bio request? A single bio should be able to=
 handle
 a request's segments and sectors limits.
=20
Will the user assure that the iovec will fit in a single request to handl=
e a
case where the iovec is greater than the phys or hw segment limits though=
?
