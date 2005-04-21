From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Re: fastfail operation and retries
Date: Thu, 21 Apr 2005 21:54:35 +0200
Message-ID: <20050421195435.GP17315@marowsky-bree.de>
References: <20050419171953.GA8444@lion28.boeblingen.de.ibm.com>
	<20050421164205.GA20482@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050421164205.GA20482@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Andreas Herrmann <aherrman@de.ibm.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2005-04-21T09:42:05, Patrick Mansfield <patmans@us.ibm.com> wrote:

> On Tue, Apr 19, 2005 at 07:19:53PM +0200, Andreas Herrmann wrote:
> > Hi,
> >=20
> > I have question(s) regarding the fastfail operation of the SCSI stack=
.
> >=20
> > Performing multipath-tests with an IBM ESS I encountered problems.
> > During certain operations on an ESS (quiesce/resume and such) request=
s
> > on all paths fail temporarily with an data underrun (resid is set in
> > the FCP-response).  In another situation abort sequences happen (see
> > FC-FS).
> >=20
> > In both cases it is not a path failure but the device (ESS) reports
> > error conditions temporarily (some seconds).
> >=20
> > Now on error on the first path the multipath layer initiates failover
> > to other available path(s) where requests will immediately fail.
> >=20
> > Using linux-2.4 and LVM such problems did not occure. There were
> > enough retries (5 for each path) to handle such situations.
> >=20
> > Now if the FASTFAIL flag is set the SCSI stack prevents retries for
> > failed SCSI commands.
> >=20
> > Problem is that the multipath layer cannot distinguish between path
> > and device failures (and won't do any retries for the failed request
> > on the same path anyway).
> >=20
> > How can an lld force the SCSI stack to retry a failed scsi-command
> > (without using DID_REQUEUE or DID_IMM_RETRY, which both do not change
> > the retry counter).
> >=20
> > What about a DID_FORCE_RETRY ?  Or is there any outlook when there
> > will be a better interface between the SCSI stack and the multipath
> > layer to properly handle retries.
>=20
> We need a patch like Mike Christie had, this:
>=20
> http://marc.theaimsgroup.com/?l=3Dlinux-kernel&m=3D107961883914541&w=3D=
2
>=20
> The scsi core should decode the sense data and pass up the result, then=
 dm
> need not decode sense data, and we don't need sense data passed around =
via
> the block layer.

The most recent udm patchset has a patch by Jens Axboe and myself to
pass up sense data / error codes in the bio so the dm mpath module can
deal with it. =20

Only issue still is that the SCSI midlayer does only generate a single
"EIO" code also for timeouts; however, that pretty much means it's a
transport error, because if it was a media error, we'd be getting sense
data ;-)

Together with the "queue_if_no_path" feature flag for dm-mpath that
should do what you need to handle this (arguably broken) array
behaviour: It'll queue until the error goes away and multipathd retests
and reactivates the paths. That ought to work, but given that I don't
have an IBM ESS accessible, please confirm that.

It is possible that to fully support them a dm mpath hardware handler
(like for the EMC CX family) might be required, too.

(For easier testing, you'll find that all this functionality is
available in the latest SLES9 SP2 betas, to which you ought to have
access at IBM, and the kernels are also available via
ftp://ftp.suse.com/pub/projects/kernel/kotd/.)

> scsi core could be changed to handle device specific decoding via sense
> tables that can be modified via sysfs, similar to devinfo code (well,
> devinfo still lacks a sysfs interface).

dm-path's capabilities go a bit beyond just the error decoding (which
for generic devices is also provided for in a generic
dm_scsi_err_handler()); for example you can code special initialization
commands and behaviour an array might need.

Maybe this could indeed be abstracted further to download the command
and/or specific decoding tables from user-space via sysfs or configfs by
a generic user-space customizable dm-hw-handler-generic.[ch] plugin; I
think patches are being accepted ;-)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
