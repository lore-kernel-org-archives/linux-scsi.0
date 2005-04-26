From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Re: fastfail operation and retries
Date: Tue, 26 Apr 2005 11:55:51 +0200
Message-ID: <20050426095551.GE32085@marowsky-bree.de>
References: <OF8721F851.2661040F-ONC1256FEA.0076595E-C1256FEA.00768C46@de.ibm.com>
	<20050421222409.GY17315@marowsky-bree.de>
	<ac71172a050422121365a32cc3@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <ac71172a050422121365a32cc3@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: tranlan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, aherrman@de.ibm.com
List-Id: linux-scsi@vger.kernel.org

On 2005-04-22T12:13:53, Lan <transter@gmail.com> wrote:

>  Although, it seems need to add to multipath-tools the ability to set
> a timeout limit on how long an I/O is queued and retried (otherwise in
> a permanent failure, I think the I/O  could be queued for a quite
> awhile, e.g. until system runs out of memory).

This can actually be implemented in user-space. If the paths stay down
for N seconds, remove the queue_if_no_path feature flag, and all IO will
be failed.

> Also, what do you think about allowing a configurable threshold on I/O
> failures in dm-multipath before deciding to set a path dead; 1 is
> kinda low, and has no tolerance at all for transient errors.

That might be a good idea.=20

Note however that DM mpath already distinguishes between path failures
and media failures for example: A media failure will not cause a path to
be failed.

And there's also a trade-off: As long as the path is not failed, it'll
receive more IO. Which, if it doesn't turn out to be a transient error,
we will need to wait on to fail, has to be requeued and retried
somewhere else. This causes delays.

Failing the path on the first error potentially attributable to the
transport will cause an immediate retry on another path though; and if
it turns out to be a transient error, the path will be returned into
operation within a couple of seconds by user-space.

> I think it will lessen the dependency on waiting for multipath-tools
> to reinstate a path that has been set dead due to a transient
> condition.

True, but this is actually by current design, because we want to
redirect IO to healthy paths as quickly as possible.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
