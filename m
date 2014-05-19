From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 6/6] virtio-scsi: Enable DIF/DIX modes in SCSI host LLD
Date: Tue, 20 May 2014 01:43:18 +0300
Message-ID: <20140519224318.GC29605@redhat.com>
References: <1396819929-29687-1-git-send-email-nab@daterainc.com>
	<1396819929-29687-7-git-send-email-nab@daterainc.com>
	<20140407084518.GA14091@redhat.com>
	<1396861019.19888.25.camel@haakon3.risingtidesystems.com>
	<20140507091305.GA20044@redhat.com>
	<1400526423.10964.31.camel@haakon3.risingtidesystems.com>
	<20140519191527.GC32382@redhat.com>
	<1400532890.10964.44.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1400532890.10964.44.camel@haakon3.risingtidesystems.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>, virtualization@lists.linux-foundation.org, Sagi Grimberg <sagig@mellanox.com>, target-devel <target-devel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, May 19, 2014 at 01:54:50PM -0700, Nicholas A. Bellinger wrote:
> On Mon, 2014-05-19 at 22:15 +0300, Michael S. Tsirkin wrote:
> > On Mon, May 19, 2014 at 12:07:03PM -0700, Nicholas A. Bellinger wrote:
> > > On Wed, 2014-05-07 at 12:13 +0300, Michael S. Tsirkin wrote:
> > > > On Mon, Apr 07, 2014 at 01:56:59AM -0700, Nicholas A. Bellinger wrote:
> > > > > On Mon, 2014-04-07 at 11:45 +0300, Michael S. Tsirkin wrote:
> > > > > > On Sun, Apr 06, 2014 at 09:32:09PM +0000, Nicholas A. Bellinger wrote:
> > > > > > > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > > > > > > 
> > > > > > > This patch updates virtscsi_probe() to setup necessary Scsi_Host
> > > > > > > level protection resources. (currently hardcoded to 1)
> > > > > > > 
> > > > > > > It changes virtscsi_add_cmd() to attach outgoing / incoming
> > > > > > > protection SGLs preceeding the data payload, and is using the
> > > > > > > new virtio_scsi_cmd_req_pi->d[oi],pi_niv field to signal
> > > > > > > to signal to vhost/scsi how many prot_sgs to expect.
> > > > > > > 
> > > > > > > v3 changes:
> > > > > > >   - Use VIRTIO_SCSI_F_T10_PI to determine PI or non PI header (Paolo)
> > > > > > > 
> > > > > > > v2 changes:
> > > > > > >   - Make protection buffer come before data buffer (Paolo)
> > > > > > >   - Enable virtio_scsi_cmd_req_pi usage (Paolo)
> > > > > > > 
> > > > > > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > > > > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > > > > > Cc: Martin K. Petersen <martin.petersen@oracle.com>
> > > > > > > Cc: Christoph Hellwig <hch@lst.de>
> > > > > > > Cc: Hannes Reinecke <hare@suse.de>
> > > > > > > Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
> > > > > > > Cc: H. Peter Anvin <hpa@zytor.com>
> > > > > > > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > > > > > 
> > > > > > OK but we need to document the new interface in the spec
> > > > > > (and incidentially, this will be useful to verify the assumptions
> > > > > > made here and on the host side).
> > > > > > Could you please submit this proposal to the OASIS Virtio TC
> > > > > > for inclusion into the next spec draft?
> > > > > > Ideally as a patch against the tex source, but a prose
> > > > > > description would do as well.
> > > > > 
> > > > > Most certainly.  Please give me a bit to follow up on this, as the next
> > > > > couple of days are going to be hellishly busy..
> > > > 
> > > > Ping.
> > > > We really need to get this moving to have the interface reviewed for
> > > > the next merge window.
> > > > 
> > > 
> > > Hi MST,
> > > 
> > > So I've finally got some cycles to get back to this code, and wanted to
> > > verify the outstanding items you had previously raised:
> > > 
> > > - Convert vhost-scsi to be independent of IOV layout using 
> > >   memcpy_fromiovecend. (Does this effect existing non PI virtio-scsi 
> > >   operation..?)
> > 
> > Ideally yes.
> 
> Er, so changing vhost-scsi to be independent of IOV layout will have the
> side effect of breaking existing non PI virtio-scsi logic..?

Sorry I didn't make myself clear.
I merely think that all code should do memcpy_fromiovecend etc.
If done peoperly guests will not notice unless they test
VIRTIO_F_ANY_LAYOUT.



> > 
> > > - Report VIRTIO_F_ANY_LAYOUT feature bit to userspace.
> > > - Convert virtio_scsi_cmd_req_pi to bytes field instead of number of 
> > >   iovecs.
> > > - Ensure virtio_scsi_cmd_req_pi is naturally aligned
> > 
> > It turns out other virtio scsi commands aren't aligned?
> 
> Correct, virtio_scsi_cmd_req is currently 51 bytes.
> 
> > If true we don't need to make an exception here.
> 
> <nod>
> 
> > 
> > > - Figure out why QEMU is not acking (any) vhost-scsi feature bits
> > > 
> > > Is there anything else that you'd like to see for an initial merge, or
> > > other issues that need to be addressed with the above..?
> > > 
> > > --nab
> > 
> > FYI Paolo sent a spec patch for the feature.
> > Have you seen it?
> > 
> 
> Yep, looks fine.
> 
> --nab
