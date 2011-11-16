From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: RE: [PATCH 3/4] scsi_dh_rdac: Adding the match function for	rdac device handler
Date: Wed, 16 Nov 2011 17:10:51 -0500
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD91080A6F5@RTPMVEXC1-PRD.hq.netapp.com>
References: <47D23AD8469A2B448F33C24BD7A39BD9105DB4D8@RTPMVEXC1-PRD.hq.netapp.com> <4EB0EF3F.1010300@suse.de> <47D23AD8469A2B448F33C24BD7A39BD9105DB8EE@RTPMVEXC1-PRD.hq.netapp.com> <20111102154612.GA30632@redhat.com> <47D23AD8469A2B448F33C24BD7A39BD9105DBDC7@RTPMVEXC1-PRD.hq.netapp.com> <20111103151748.GA10627@redhat.com> <20111116173243.GA26675@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:41481 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab1KPWK4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Nov 2011 17:10:56 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20111116173243.GA26675@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, hare@suse.de
Cc: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Peter Jones <pjones@redhat.com>

> -----Original Message-----
> From: Mike Snitzer [mailto:snitzer@redhat.com]
> Sent: Wednesday, November 16, 2011 11:33 AM
> To: Moger, Babu; hare@suse.de
> Cc: Linux SCSI Mailing list; device-mapper development; Peter Jones
> Subject: Re: [PATCH 3/4] scsi_dh_rdac: Adding the match function for
> rdac device handler
>=20
> On Thu, Nov 03 2011 at 11:17am -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
>=20
> > On Thu, Nov 03 2011 at 10:47am -0400,
> > Moger, Babu <Babu.Moger@netapp.com> wrote:
> >
> > > > -----Original Message-----
> > > > From: Mike Snitzer [mailto:snitzer@redhat.com]
> > > > Sent: Wednesday, November 02, 2011 10:46 AM
> > > > To: device-mapper development
> > > > Cc: Linux SCSI Mailing list
> > > > Subject: Re: [dm-devel] [PATCH 3/4] scsi_dh_rdac: Adding the
> match
> > > > function for rdac device handler
>=20
> ...
>=20
> > > > What about the issue where the appropriate scsi_dh isn't attach=
ed
> > > > during
> > > > scan (resulting in boot failures, trespasses, etc)?
> > > >
> > > > Hannes, I know you had plans for how to address the early scsi_=
dh
> > > > attachment (and this match() work is a great step forward).  I
> just
> > > > wanted to touch base with you on what your current vision is on
> how to
> > > > achieve proper early scsi_dh attachment (and what the remaining
> TODO
> > > > is).
> > >
> > > I am not aware of any other issue at this point. Hannes may know
> about it.
> >
> > Yeap Hannes is aware.
> >
> > I was referring to IO being issued to passive paths (ghost LUNs)
> because
> > scsi_dh isn't yet loaded.  Whereby causing the storage backend to
> > trespass unnecessarily.  This bouncing (and corresponding IO errors=
)
> are
> > avoided if the appropriate scsi_dh module is always loaded before t=
he
> > storage driver (e.g. lpfc or qla2xxx).
>=20
> I have reviewed the scsi_dh match() changes (those from Hannes that a=
re
> already upstream and the 4 patches from Babu to complete match() for
> other device handlers and the scsi_dh cleanup).
>=20
> Hannes, in your cover-letter from the original scsi_dh_alua match
> patchset, here: http://www.spinics.net/lists/linux-scsi/msg54281.html=
,
> you said:
>=20
> "In contrast to what we've discussed at LinuxTag I have not tried
> to attach the alua device handler directly from scsi_scan.
> Reason is that I need to issue SCSI commands during activation,
> which means I would have to attach it from near the end of
> scsi_add_lun(), at which point the device_handler would be attached
> via the current method anyway. So I fail to see the gain here."
>=20
> I haven't picked through the scsi_dh/scsi code enough to know what "t=
he
> current method" is (but I'm reviewing the code now).  That said, a
> quick
> recap of what you feel the relevant highlights are would be
> appreciated.
>=20
> But I thought the issue we discussed at LinuxTag was: how do we
> autoload
> the scsi_dh module(s) so that the device handler is even available fo=
r
> attachment?
>=20
>=20
> Babu, you said that your patchset to implement match() for rdac
> resolved
> the problem of the device handler not attaching properly:
> http://www.redhat.com/archives/dm-devel/2011-November/msg00032.html
>=20
> But that is only the case if scsi_dh_rdac has already been loaded ear=
ly
> by the initramfs right?

That is correct. I had included  the handler in initramfs.

>=20
> Given the updated scsi_dh match code: should it be safe for the
> initramfs to just load all scsi_dh modules (and ALUA will be preferre=
d
> if TPGS is set)?

Yes, it would be great..

>=20
> Does it make sense to re-visit Peter Jones' modalias code to autoload
> scsi_dh in kernel rather than relying on adhoc initramfs code to know
> to
> load the modules?

I don=92t have complete understanding that. Can't comment.

>=20
> Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
