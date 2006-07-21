From: Edward Goggin <egoggin@emc.com>
Subject: RE: [PATCH RFC] move scsi parts of dm hw handlers to
	scsi layer
Date: Fri, 21 Jul 2006 15:10:07 -0400
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E41491BC@CORPUSMX40A.corp.emc.com>
References: <581472.1153482088210.SLOX.WebMail.wwwrun@imap-dhs.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <581472.1153482088210.SLOX.WebMail.wwwrun@imap-dhs.suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: hare@suse.de, michaelc@cs.wisc.edu
Cc: dm-devel@redhat.com, agk@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org=20
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Hannes Reinecke
> Sent: Friday, July 21, 2006 7:41 AM
> To: Mike Christie
> Cc: dm-devel@redhat.com; linux-scsi@vger.kernel.org; agk@redhat.com
> Subject: Re: [PATCH RFC] move scsi parts of dm hw handlers to=20
> scsi layer
>=20
> Am Fr 21.07.2006 13:20 schrieb Mike Christie <michaelc@cs.wisc.edu>:
>=20
> > Currently dm-multipath has what it calls hw_handlers that contain hw
> > details and currently those handlers can be used to failover storage
> > works, LSI/Engenio RDAC mode, and EMC Clariion boxes. This code is a
> > little strange in dm-multipath and they are doing scsi no=20
> good (think
> > about problems initializing scsi disks/paths when they are in a
> > passive
> > path that requires explicit/manual activation and we retry over and
> > over
> > and over).
> >=20
> Yes, good idea. And it would even solve the problem of=20
> getting all this
> weird
> error messages during booting as now these handlers are=20
> independently of
> of
> the multipathing configuration and we're now able to handle=20
> weird path=20
> configurations natively.
>=20
> > The patch below begins to push the scsi hw handler code down to the
> > scsi
> > layer. I only began to covert dm-emc.c and it only hooks in at the
> > sense
> > decoding in scsi_error.c. I wanted to make sure I was going=20
> about the
> > module loading and binding correctly. With a new target bus we could
> > do
> > some driver model stuff instead, but I was not sure if that was
> > appropriate for this?
> >=20
> Why don't we use scsi_devinfo for this?
> We have to have some sort of device table anyway as these handlers are
> far from being generic, so any sense code which triggers action on one
> device might be perfectly ok for others.
>=20
> Easiest way would be to have one BLIST flag for each hardware handler
> and merge the respective hardware handler into that target if the
> blacklist entry matches.
>=20
> > Next up would be to get Jens's cmd type tree and work on the message
> > passing code.
> >=20
> > And this patch currently does not work since I do not have=20
> a Clariion
> > box and I do not know what to match for the {vendor, model} tuple. I
> > think it was something like DCG or DGC and the model had different
> > RAID
> > strings depending on how it was setup and could have some=20
> other string
> > if it did not use RAID. If you have a Clariion or you work=20
> for EMC and
> > happen to know this info could you pass those strings to me?
> >=20
> IIRC this is
>=20
> 'DGC' 'DISK'
> 'DGC' 'RAID 10'
> 'DGC' 'RAID 5'

And 'DGC' 'LUNZ'

What about supporting a wildcard model string?

>=20
> Hrmph. There is one bit which doesn't quite work out.
> While the hardware handler knows how to handle error codes and how to
> switch
> paths for a specific device, it doesn't know _when_ to switch it.
> I don't think it's a clever idea to switch paths whenever you=20
> encounter
> an
> passive path. Seems like you could do a nice ping-pong that way ...
>=20
> Cheers,
>=20
> Hannes
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe=20
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
