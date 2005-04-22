From: Lan <transter@gmail.com>
Subject: Re: Re: fastfail operation and retries
Date: Fri, 22 Apr 2005 12:13:53 -0700
Message-ID: <ac71172a050422121365a32cc3@mail.gmail.com>
References: <OF8721F851.2661040F-ONC1256FEA.0076595E-C1256FEA.00768C46@de.ibm.com>
	<20050421222409.GY17315@marowsky-bree.de>
Reply-To: tranlan@us.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050421222409.GY17315@marowsky-bree.de>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, aherrman@de.ibm.com
List-Id: linux-scsi@vger.kernel.org

On 4/21/05, Lars Marowsky-Bree <lmb@suse.de> wrote:
> On 2005-04-21T23:33:57, Andreas Herrmann <aherrman@de.ibm.com> wrote:
>=20
> > Well, there are various situations when all paths to the ESS are
> > "temporarily unavailable". In some cases TASK_SET_FULL/BUSY is
> > reported as it should be.
>=20
> Not sure whether this sense data is decoded and handled correctly in
> dm-mpath yet. I don't have detailed specs, nor a feature request to
> allocate time to work on making sure it really does. I recommend that
> someone at IBM takes the real specs for the ESS and makes sure that it
> all works, by a combination of the right defaults in the multipath-tool=
s
> hwtable and, if need be, a dm-ess plugin to handle this.
>=20
> This would be much appreciated.
>

Please correct me if my assumption is wrong, but I would think that
transient errors are expected, especially in a SAN, from both the
fabric and media. A storage device may have to return retryable status
conditions at certain points, and that such retryable conditions are
not necessarily specific to a storage device. For example, a
QUEUE_FULL or BUSY, implying that the device is congested. Wouldn't
most storage devices reasonably expect I/O failed due to this
condition will be retried? [Such a congestion handling mechanism, I
would think, would not have to be storage-specific, although the
policy for handling congestion might be?]  So  in order to deal with
transient conditions given that failfast flag is set, the
queue_if_no_path must be used; I'm not sure why any dm-multipath
storage users would not want to turn on queue_if_no_path by default?

As far as I know, ESS does not require any special handing of special
sense information, besides various sense data status conditions that
it expects would be retried. (Arent' data underruns also an expected
retryable condition?).  I'm not so familiar with all the various
possible transport and media errors/conditions, but I would think that
most could/would want to be handled generically by storage devices
(which is why the scsi core has generic error handling i'd imagine).
But I agree that more testing should be done with ESS and its spec to
verify that a special dm-ess error handler is actually not needed.=20
And at the least, a hw entry should be added to dm to turn on
queue_if_no_path by default for ESS, and any other necessary defaults.
 Although, it seems need to add to multipath-tools the ability to set
a timeout limit on how long an I/O is queued and retried (otherwise in
a permanent failure, I think the I/O  could be queued for a quite
awhile, e.g. until system runs out of memory).
=20
Also, what do you think about allowing a configurable threshold on I/O
failures in dm-multipath before deciding to set a path dead; 1 is
kinda low, and has no tolerance at all for transient errors. I think
it will lessen the dependency on waiting for multipath-tools to
reinstate a path that has been set dead due to a transient condition.

Thanks!
Lan
