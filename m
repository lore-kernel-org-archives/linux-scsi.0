From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH 0/4] scsi_dh: Make scsi_dh_activate
	asynchronous
Date: Tue, 6 Oct 2009 13:46:19 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474ED90C7@cosmail01.lsi.com>
References: <20090930020811.11455.59565.sendpatchset@chandra-ubuntu>
	<4AC9EE1B.7030702@suse.de> <1254785154.15826.18.camel@chandra-ubuntu>
	<4ACAFAF5.5000805@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4ACAFAF5.5000805@suse.de>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, "sekharan@linux.vnet.ibm.com" <sekharan@linux.vnet.ibm.com>
Cc: "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "Stankey,
	Robert" <Robert.Stankey@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "Chauhan,
	Vijay" <Vijay.Chauhan@lsi.com>, "Benoit_Arthur@emc.com" <Benoit_Arthur@emc.com>, "Qi,
	Yanling" <Yanling.Qi@lsi.com>, "Eddie.Williams@steeleye.com" <Eddie.Williams@steeleye.com>
List-Id: linux-scsi@vger.kernel.org

Thanks Hannes and Chandra for your patches and feedback.  Right now we ar=
e internally discussing the pros and cons of both these approaches. We wi=
ll respond to all your question once we arrive at the conclusion.

Also adding our Team (Bob Stankey, Sudhir, Yanling, Vijay ) in the respon=
se.

Thanks
Babu Moger=20

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Tuesday, October 06, 2009 3:08 AM
> To: sekharan@linux.vnet.ibm.com
> Cc: linux-scsi@vger.kernel.org; dm-devel@redhat.com; Moger, Babu;
> michaelc@cs.wisc.edu; Benoit_Arthur@emc.com;
> Eddie.Williams@steeleye.com; berthiaume_wayne@emc.com
> Subject: Re: [PATCH 0/4] scsi_dh: Make scsi_dh_activate asynchronous
>=20
> Chandra Seetharaman wrote:
> > On Mon, 2009-10-05 at 15:01 +0200, Hannes Reinecke wrote:
> >
> > Thanks for the comment and the patch. I will try the patch.
> >
> >> Hmm. IIRC we added the synchronous mode by request of LSI/IBM, as
> the RDAC
> >> handler could only support on MODE SELECT command at a time.
> >> If LSI checked this, okay, no objections.
> >
> > The original patch (for rdac) came from LSI (Moger Babu), I made
> changes
> > to the infrastructure and to the code to fit them together.
> >
> >> However: The main reason why we're getting flooded with MODE SELECT
> commands
> >> is that the RDAC handler switches _each LUN_, not the entire
> controller.
> >> Seeing that the controller simply cannot cope with the resulting
> MODE SELECT
> >> flood wouldn't it be more sensible to switch the entire controller
> here?
> >
> > I see your point of view.... but here is the rationale...
> >
> > When we originally added the rdac support (as dm_rdac), we decided
> this
> > way consciously for the following reasons:
> >  1. we do not know which link is broken (hba-ctlr or ctlr-lun).
> >     The way it is currently implemented, both these cases are
> handled.
> Quite. But if the ctlr-lun link is broken, we really should receive
> and appropriate error code, which then could be handled in dm-rdac
> appropriately. After all, the controller is still accessible and
> so we don't have to guess what happened (which is all what multipath
> is about). So I doubt we need to worry about this.
>=20
> >  2. multipath layer to decide what to do and this module to just do
> >     what it was told.
> Yep.
>=20
> >  3. since multipath sends pg_init only if there is any IO sent to the
> >     lun, (with the current implementation) we don't have to change
> >     ownership (back and forth) of all the luns if the user is using
> only
> >     a handful.
> Well, yes. But if the implementation is such that changing ownership
> for all LUNs is about as efficient as changing an individual LUN (or,
> as the case might be, as _inefficient_ :-), surely it's better to
> save us some coding here.
>=20
> >  4. to be consistent with LSI's original driver (which does one lun
> at a
> >     time).
> :-/ That's unfair.
> But it still has the drawback that it doesn't scale; given enough LUNs
> and
> access patterns you _inevitably_ have to send MODE SELECT commands for
> each LUN, ie you only delay this issue.
> Only by switching all LUNs you can avoid this.
>=20
> Cheers,
>=20
> Hannes
> --
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
