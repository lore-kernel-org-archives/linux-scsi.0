From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/2] virtio-scsi: Implement FC_HOST feature
Date: Mon, 16 Jan 2017 15:17:59 -0500 (EST)
Message-ID: <886576564.9475841.1484597879593.JavaMail.zimbra@redhat.com>
References: <20170116160430.11815-1-famz@redhat.com>
	<0009b36c-29a9-9486-3fad-197733d905bc@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <0009b36c-29a9-9486-3fad-197733d905bc@suse.de>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, stefanha@redhat.com
List-Id: linux-scsi@vger.kernel.org


> How it this supposed to work?
> You do export the WWPN/WWNN of the associated host to the guest (nb:
> will get interesting for non NPIV setups ...), but virtio scsi will
> still do a LUN remapping.
> IE the LUNs you see on the host will be different from the LUNs
> presented to the guest.

This is taken care of in the host by presenting to the host all LUNs from
a host's NPIV vHBA.  (Libvirt probably would be the one taking care of this,
because QEMU may not have enough permissions).

> Plus you don't _actually_ expose the FC host, but rather the WWPN of the
> host presenting the LUN.
> So how do you handle LUNs from different FC hosts on the guest?

I'm not sure I understand.

Neither I nor Fam know this stuff very well, but we are trying to do the same
as Hyper-V (and other proprietary hypervisors too).

> Overall, I'm not overly happy with this approach.
> You already added WWPN ids to the virtio transport, so why didn't you
> update the LUN field, too, to avoid this ominous LUN remapping?

Is this your old idea of adding a separate target field to commands,
in order to support 64-bit LUNs?  That is separate, and most FC drivers
only default to 16-bit LUNs anyway.

> And we really should make sure to have a single FC host in the guest
> presenting all LUNs.

Yes, of course.

Paolo
