From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Re: fastfail operation and retries
Date: Fri, 22 Apr 2005 00:16:15 +0200
Message-ID: <20050421221614.GX17315@marowsky-bree.de>
References: <C2EEB4E538D3DC48BF57F391F422779321A927@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321A927@SRMANNING.eng.emc.com>
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

On 2005-04-21T18:01:04, "goggin, edward" <egoggin@emc.com> wrote:

> > If we can't differentiate in the kernel where we have the IO error
> > details available, then how would user-space? You're not solving the
> > problem ;-)
> Maybe not completely, but at least an inquiry of page 83 will not trip
> over media errors.  Also, why use a different test for determining path
> success than the one used for path failure?

If the kernel sees an error, it needs to take action. It has immediate
knowledge of the error, while the further user-space diagnosis (or even
further in-kernel diagnosis; where this is actually implemented doesn't
matter) obviously lags behind.

I think the aim is to immediately react and re-route IO to reduce the
interruption to upper layers. In principle, if we have healthy paths,
rerouting is always safe; only if we know for sure it's a media error
(as indicated by appropriate sense data) do we immediately report IO
error to upper layers, or switch pgs instead of failing the path etc.
This is a pessimistic approach: take a potentially failed path out of
service asap.

What also happens though is that an event is sent to user-space, and
user-space "immediately" retests the path, and if it finds it healthy,
will reinstate it.

I believe this is correct behaviour.

> > According to my docs, the only EMC array which does fail all paths
> > during a software update (by doing a "Warm Reboot") is a FC4500 array=
.
> > Not sure whether this also includes the AX-series, though, my doc
> > doesn't mention it. The FC4500 might not respond to IO for upto 50
> > seconds; in which case the queue_if_no_path and user-space retesting
> > provides adequate (as good as possible) coverage to reinstate=20
> > the paths.
>=20
> I am seeing all-paths-down time period whenever I perfrom an NDU
> for a CX300 while running 1 (async write behind) dd thread per
> mapped device for 16 mapped devices.

Are you already running the code with the sense data decoding enabled,
for example a _very_ recent SLES9 SP2 beta kernel (basically, as of a
couple hours ago) or one with all patches applied from the multipath
bugzilla + multipath-tools pre18, and are you connected to both SPs?

If not, it's possible that that combo kernel didn't correctly handle
that case, because it didn't know about triggering a switch_pg etc.

And, if the CX300 indeed fails all paths during NDU at the same time, it
is behaving contrary to the published CX-series specification; in which
case it is an EMC (and not ours! ;-) bug and needs to be fixed in the
firmware ;-)

> > (The fact that no write/reads complete should automatically throttle
> > the IO, too; however, this might not be true for certain write
> > patterns, and in particular async IO (how could we possible throttle
> > _that_?). IO throttling in this case remains a problem which we
> > might need to address.)
> This is the problem I am refering to.

Well, I don't think so. This is an additional problem, but not one you
should be running into.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
