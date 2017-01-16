From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/2] virtio-scsi: Implement FC_HOST feature
Date: Mon, 16 Jan 2017 18:44:27 +0100
Message-ID: <0009b36c-29a9-9486-3fad-197733d905bc@suse.de>
References: <20170116160430.11815-1-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20170116160430.11815-1-famz@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Fam Zheng <famz@redhat.com>, linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, virtualization@lists.linux-foundation.org, stefanha@redhat.com, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 01/16/2017 05:04 PM, Fam Zheng wrote:
> This series implements the proposed fc_host feature of virtio-scsi.
> =

> The first patch updates the data structure changes according to the spec
> proposal; the second patch actually implements the operations.
> =

> Fam Zheng (2):
>   virtio_scsi: Add fc_host definitions
>   virtio_scsi: Implement fc_host
> =

>  drivers/scsi/virtio_scsi.c       | 55 ++++++++++++++++++++++++++++++++++=
+++++-
>  include/uapi/linux/virtio_scsi.h |  6 +++++
>  2 files changed, 60 insertions(+), 1 deletion(-)
> =

Hmm.

How it this supposed to work?
You do export the WWPN/WWNN of the associated host to the guest (nb:
will get interesting for non NPIV setups ...), but virtio scsi will
still do a LUN remapping.
IE the LUNs you see on the host will be different from the LUNs
presented to the guest.

This makes reliable operations very tricky.
Plus you don't _actually_ expose the FC host, but rather the WWPN of the
host presenting the LUN.
So how do you handle LUNs from different FC hosts on the guest?
>From what I've seen virtio will either presenting you with with one host
per LUN (so you'll end up with different SCSI hosts on the guest each
having the _same_ WWPN/WWNN), or a single host presenting all LUNs,
making the WWPN setting ... interesting.

Overall, I'm not overly happy with this approach.
You already added WWPN ids to the virtio transport, so why didn't you
update the LUN field, too, to avoid this ominous LUN remapping?
And we really should make sure to have a single FC host in the guest
presenting all LUNs.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
