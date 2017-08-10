From: Benjamin Block <bblock-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC PATCH 5/6] bsg: reduce unnecessary arguments for
 bsg_map_hdr()
Date: Fri, 11 Aug 2017 00:19:53 +0200
Message-ID: <20170810221953.GC918@bblock-ThinkPad-W530>
References: <cover.1502120928.git.bblock@linux.vnet.ibm.com>
 <6d4d39222a4b76f9b39ec52e0aca5b01a3fac9e1.1502120928.git.bblock@linux.vnet.ibm.com>
 <20170810093531.GP24539@lst.de>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <open-iscsi+bncBCLYZUM5WUFRBDVYWPGAKGQEGPPC4XI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Disposition: inline
In-Reply-To: <20170810093531.GP24539-jcswGhMUV9g@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: "James E . J . Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Steffen Maier <maier-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 10, 2017 at 11:35:31AM +0200, Christoph Hellwig wrote:
> On Wed, Aug 09, 2017 at 04:11:19PM +0200, Benjamin Block wrote:
> > Since struct bsg_command is now used in every calling case, we don't
> > need separation of arguments anymore that are contained in the same
> > bsg_command.
> >=20
> > Signed-off-by: Benjamin Block <bblock-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > ---
> >  block/bsg.c | 13 ++++++-------
> >  1 file changed, 6 insertions(+), 7 deletions(-)
> >=20
> > diff --git a/block/bsg.c b/block/bsg.c
> > index 8517361a9b3f..6ee2ffca808a 100644
> > --- a/block/bsg.c
> > +++ b/block/bsg.c
> > @@ -212,11 +212,12 @@ bsg_validate_sgv4_hdr(struct sg_io_v4 *hdr, int *=
op)
> >   * map sg_io_v4 to a request.
> >   */
> >  static struct request *
> > -bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_w=
rite_perm,
> > -	    u8 *reply_buffer)
> > +bsg_map_hdr(struct bsg_device *bd, struct bsg_command *bc,
> > +	    fmode_t has_write_perm)
>=20
> I wish we could just rename the argument to mode and pass on the
> whole file->f_mode while you are cleaning up this code.  That should
> be a separate patch, though.
>=20

Hmm, I did a quick pass through the code and the only place this seems
to be used, is to pass it to blk_verify_command() if the subcommand used
in the BSG request is a SCSI Command. And this has the same semantics.
So I guess this would require adjustments to the whole stack, as this is
also used from the 'normal' SG side of the world.



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
