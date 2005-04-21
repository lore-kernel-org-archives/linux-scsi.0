From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Re: fastfail operation and retries
Date: Thu, 21 Apr 2005 23:49:33 +0200
Message-ID: <20050421214933.GV17315@marowsky-bree.de>
References: <C2EEB4E538D3DC48BF57F391F422779321A924@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321A924@SRMANNING.eng.emc.com>
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

On 2005-04-21T17:31:46, "goggin, edward" <egoggin@emc.com> wrote:

> > No. Basically every time out error creates a "dunno why" error right
> > now - could be the storage system itself, could be the network in
> > between.
> >
> I was really thinking of the code where the sense key/asc/ascq makes
> it into the bio.

We don't get sense data for transport errors and certain storage
failures, though.

> I agree we and likely other storage vendors could do a better job
> here.  But that said, the multipathing code could also avoid failing
> the path just because an io error occurred on that path.  Instead,
> this could be the sole responsibility of path testing (from user
> space) which could reduce the likelihood of media errors being
> confused with path connectivity ones.

If we can't differentiate in the kernel where we have the IO error
details available, then how would user-space? You're not solving the
problem ;-)

> I agree that its unfortunate that the CLARiion is failing all paths
> during NDU, even for a restricted amount of time.  Even so, it must
> be dealt with as is.

It does? According to my documentation, the CX-family, the FC4700(-2)
and likely the Symmetrix NDU is a rolling update, so that always one
Service-Processor remains accessible, with enough delay in between them
that path retesting will have reenabled the path.

We get an 02/04/03 Path Not Ready error code for this case, which in the
dm-emc.c handler is translated to an immediate switch_pg.

In fact, the user-space testing code will receive pre-notification of a
pending NDU by the LUN Operations field being set to 1, which will cause
user-space to flag that path as down, even if there's no in-flight IO.

This combined ought to cover the NDU case pretty well and is implemented
already. (And supposedly works in SLES9 SP2 beta3.)

According to my docs, the only EMC array which does fail all paths
during a software update (by doing a "Warm Reboot") is a FC4500 array.
Not sure whether this also includes the AX-series, though, my doc
doesn't mention it. The FC4500 might not respond to IO for upto 50
seconds; in which case the queue_if_no_path and user-space retesting
provides adequate (as good as possible) coverage to reinstate the paths.

(The fact that no write/reads complete should automatically throttle the
IO, too; however, this might not be true for certain write patterns, and
in particular async IO (how could we possible throttle _that_?). IO
throttling in this case remains a problem which we might need to
address.)

I guess you get what you pay for: The arrays which _do_ have this
misbehaviour _will_ be problematic in certain configurations; putting
swap on them comes to mind.

As this allows EMC and other vendors to sell their higher end arrays, I
can't see how you could possibly complain ;-)

I stand by my point that any array which does have this behaviour does
not qualify as high-end storage.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
