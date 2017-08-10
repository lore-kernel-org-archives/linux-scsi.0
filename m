From: Benjamin Block <bblock-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC PATCH 1/6] bsg: fix kernel panic resulting from missing
 allocation of a reply-buffer
Date: Fri, 11 Aug 2017 00:45:15 +0200
Message-ID: <20170810224515.GD918@bblock-ThinkPad-W530>
References: <cover.1502120928.git.bblock@linux.vnet.ibm.com>
 <9e67ce3fc2f3cd42e9e05b2753b00d6676f46ee1.1502120928.git.bblock@linux.vnet.ibm.com>
 <20170810093217.GL24539@lst.de>
 <20170810221038.GA918@bblock-ThinkPad-W530>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <open-iscsi+bncBCLYZUM5WUFRBAGEWPGAKGQEKJUHUGY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Disposition: inline
In-Reply-To: <20170810221038.GA918@bblock-ThinkPad-W530>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: "James E . J . Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Steffen Maier <maier-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 11, 2017 at 12:10:38AM +0200, Benjamin Block wrote:
> On Thu, Aug 10, 2017 at 11:32:17AM +0200, Christoph Hellwig wrote:
> > We can't use an on-stack buffer for the sense data, as drivers will
> > dma to it.  So we should reuse the SCSI init_rq_fn() for the BSG
> > queues and/or implement the same scheme.
> >=20
>=20
...
>=20
>  struct sg_io_v4
>  +--------------+
>  |              | =20
>  | request-------->+----------------------------+
>  |   + _len     |  |                            |
>  |   (A)        |  | BSG Request                |
>  |              |  | e.g. struct fc_bsg_request | Depends on BSG implemen=
tation
>  |              |  |                            | FC vs. iSCSI vs. ...
>  |              |  +----------------------------+
>  |              |
>  | response------->+----------------------------+ Used as _Output_
>  |   + max_len  |  |                            | User doesn't initialize
>  |   (B)        |  | BSG Reply                  | User provides (optional=
)
>  |              |  | e.g. struct fc_bsg_reply   |   memory; May be NULL.
>  |              |  |                            |
>  |              |  +----------------------------+
>  |              |
>  | dout_xferp----->+-----------------------+ Stuff send on the wire by
>  |   + _len     |  |                       |   the LLD
>  |   (C)        |  | Transport Protocol IU | Aligned on PAGE_SIZE
>  |              |  | e.g. FC-GS-7 CT_IU    |
>  |              |  |                       |
>  |              |  +-----------------------+
>  |              |
>  | din_xferp------>+-----------------------+ Buffer for response data by
>  |   + _len     |  |                       |   the LLD
>  |   (D)        |  | Transport Protocol IU | Aligned on PAGE_SIZE
>  |              |  | e.g. FC-GS-7 CT_IU    |
>  |              |  |                       |
>  |              |  +-----------------------+
>  +--------------+
>=20
...
>=20
>  struct request (E)
>  +--------------+
>  |              |  struct scsi_request
>  | scsi_request--->+-----------------+
>  |              |  |                 |
>  |              |  | cmd---------------------> Copy of (A)
>  |              |  |  + _len         |         Space in struct or kzalloc
>  |              |  |  (G)            |
>  |              |  |                 |
>  |              |  | sense-------------------> Space for BSG Reply
>  |              |  |  + _len         |         Same Data-Structure as (B)
>  |              |  |  (H)            |         NOT actually pointer (B)
>  |              |  |                 |         'reply_buffer' in my patch=
=20
>  |              |  +-----------------+
>  |              |
>  | bio------------> Mapped via blk_rq_map_user() to (C) dout_xferp
>  |              |
>  | next_rq---------+
>  |              |  |
>  +--------------+  |
>                    |
>  struct request (F)|(if used)
>  +--------------+<-+
>  |              |
>  | scsi_request---> Unused here
>  |              |
>  | bio------------> Mapped via blk_rq_map_user() to (D) din_xferp
>  |              |
>  +--------------+
>=20
...
>=20
>  struct bsg_job
>  +-----------------+
>  |                 |
>  | request-----------> (G) scsi_request->cmd -> Copy of (A)
>  |   + _len        |       e.g. struct fc_bsg_request
>  |                 |
>  | reply-------------> (H) scsi_request->sense -> 'reply_buffer'
>  |   + _len        |       e.g. struct fc_bsg_reply
>  |                 |
>  | request_payload---> struct scatterlist ... map (E)->bio
>  |   + _len        |
>  |   (I)           |
>  |                 |
>  | reply_payload-----> struct scatterlist ... map (F)->bio
>  |   + _len        |
>  |   (J)           |
>  |                 |
>  +-----------------+
>=20
....
>=20
> This worked till it broke. Right now every driver that tries to access
> (H) will panic the system, or cause very undefined behavior. I suspect
> no driver right now tries to do any DMA into (H); before the regression,
> this has been also an on-stack variable (I suspect since BSG was
> introduced, haven't checked though).
>=20
> The asymmetries between the first struct request (E) and the following
> (F) also makes it hard to use the same scheme as in other drivers, where
> init_rq_fn() gets to initialize each request in the same'ish way. Or?
> Just looking at it right now, this would require some bigger rework that
> is not appropriate for a stable bug-fix.
>=20

Just some more brain-dump here.

One more problem for direct DMA into (H) in the current BSG setup is
probably, that the transport classes have each their own private format
for the BSG reply (struct fc_bsg_reply and struct iscsi_bsg_reply right
now I think). The current stack doesn't take any precaution to properly
align this in accords to what the LLDs specifies for the blk-layer... so
lets assume struct fc_bsg_reply. This has fields for actual protocol IUs
(in contrast to iSCSI, where it only has some vendor-reply buffer [an
array with 0 length...]), but they start after some BSG meta-data that
are non-standard. We would have to rewrite that to allow mapping the
start of the protocol IUs in accords to the expectations the LLDs have..
page-aligned and such things. Otherwise we would break whatever handles
the meta-data the LLD pass up the stack - added that this is actually
user visible data, passed back via struct sg_io_v4.

This could be something of a new feature I guess, it would be an
improvement in terms that it could reduce copies even more, but w/o
further research I guess it is a bit more work.



                                                    Beste Gr=C3=BC=C3=9Fe /=
 Best regards,
                                                      - Benjamin Block
--=20
Linux on z Systems Development         /         IBM Systems & Technology G=
roup
		  IBM Deutschland Research & Development GmbH=20
Vorsitz. AufsR.: Martina Koederitz     /        Gesch=C3=A4ftsf=C3=BChrung:=
 Dirk Wittkopp
Sitz der Gesellschaft: B=C3=B6blingen / Registergericht: AmtsG Stuttgart, H=
RB 243294

--=20
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
