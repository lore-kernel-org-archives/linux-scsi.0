From: "goggin, edward" <egoggin@emc.com>
Subject: RE: Re: fastfail operation and retries
Date: Thu, 21 Apr 2005 17:31:46 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A924@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'Lars Marowsky-Bree' <lmb@suse.de>, device-mapper development <dm-devel@redhat.com>, Andreas Herrmann <aherrman@de.ibm.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org=20
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Lars=20
> Marowsky-Bree
> Sent: Thursday, April 21, 2005 5:19 PM
> To: device-mapper development; Andreas Herrmann
> Cc: Linux SCSI
> Subject: Re: [dm-devel] Re: fastfail operation and retries
>=20
> On 2005-04-21T17:02:44, "goggin, edward" <egoggin@emc.com> wrote:
>=20
> > Depending on the "queue_if_no_path" feature has the current=20
> undesirable
> > side-effect of requiring intervention of the user space=20
> multipath components
> > to reinstate at least one of the paths to a useable state=20
> in the multipath
> > target driver.  This dependency currently creates the=20
> potential for deadlock
> > scenarios since the user space multipath components (nor=20
> the kernel for that
> > matter) are currently architected to avoid them.
>=20
> multipath-tools is, to a certain degree, architected to avoid=20
> them. And
> the kernel is meant to be, too - there's bugs and known FIXME's, but
> those are just bugs and we're taking patches gladly ;-)
>=20
> > I think for now it may be better to try to avoid having to=20
> fail a path if it
> > is possible that an io error is not path related.
>=20
> No. Basically every time out error creates a "dunno why"=20
> error right now
> - could be the storage system itself, could be the network in between.
>

I was really thinking of the code where the sense key/asc/ascq makes it
into the bio.
=20
> A failover to another path is the obvious remedy; take for example the
> CX series where even if it's not the path, it's the SP, and=20
> failing over
> to the other SP will cure the problem.
>=20
> If the storage at least rejects the IO with a specific error code, it
> can be worked around by a specific hw handler which doesn't fail the
> path but just causes the IO to be queued and retried; that's a pretty
> simple hardware handler to write.

I agree we and likely other storage vendors could do a better job here.
But that said, the multipathing code could also avoid failing the path
just because an io error occurred on that path.  Instead, this could be
the sole responsibility of path testing (from user space) which could
reduce the likelihood of media errors being confused with path
connectivity ones.

>=20
> But quite frankly, storage subsystems which _reject_ all IO=20
> for a given
> time are just broken for reliable configurations. What good=20
> are they in
> multipath configurations if they fail _all_ paths at the same=20
> time? How
> can they even dare claim redundancy? We can build more or less smelly
> kludges around them, but it remains a problem to be fixed at=20
> the storage
> subsystem level IMNSHO.

I agree that its unfortunate that the CLARiion is failing all paths
during NDU, even for a restricted amount of time.  Even so, it must
be dealt with as is.

>=20
>=20
> Sincerely,
>     Lars Marowsky-Br=E9e <lmb@suse.de>
>=20
> --=20
> High Availability & Clustering
> SUSE Labs, Research and Development
> SUSE LINUX Products GmbH - A Novell Business
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe=20
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
