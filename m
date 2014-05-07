From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 6/6] virtio-scsi: Enable DIF/DIX modes in SCSI host LLD
Date: Wed, 7 May 2014 12:13:05 +0300
Message-ID: <20140507091305.GA20044@redhat.com>
References: <1396819929-29687-1-git-send-email-nab@daterainc.com>
	<1396819929-29687-7-git-send-email-nab@daterainc.com>
	<20140407084518.GA14091@redhat.com>
	<1396861019.19888.25.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1396861019.19888.25.camel@haakon3.risingtidesystems.com>
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

On Mon, Apr 07, 2014 at 01:56:59AM -0700, Nicholas A. Bellinger wrote:
> On Mon, 2014-04-07 at 11:45 +0300, Michael S. Tsirkin wrote:
> > On Sun, Apr 06, 2014 at 09:32:09PM +0000, Nicholas A. Bellinger wrote:
> > > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > > 
> > > This patch updates virtscsi_probe() to setup necessary Scsi_Host
> > > level protection resources. (currently hardcoded to 1)
> > > 
> > > It changes virtscsi_add_cmd() to attach outgoing / incoming
> > > protection SGLs preceeding the data payload, and is using the
> > > new virtio_scsi_cmd_req_pi->d[oi],pi_niv field to signal
> > > to signal to vhost/scsi how many prot_sgs to expect.
> > > 
> > > v3 changes:
> > >   - Use VIRTIO_SCSI_F_T10_PI to determine PI or non PI header (Paolo)
> > > 
> > > v2 changes:
> > >   - Make protection buffer come before data buffer (Paolo)
> > >   - Enable virtio_scsi_cmd_req_pi usage (Paolo)
> > > 
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > Cc: Martin K. Petersen <martin.petersen@oracle.com>
> > > Cc: Christoph Hellwig <hch@lst.de>
> > > Cc: Hannes Reinecke <hare@suse.de>
> > > Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
> > > Cc: H. Peter Anvin <hpa@zytor.com>
> > > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > OK but we need to document the new interface in the spec
> > (and incidentially, this will be useful to verify the assumptions
> > made here and on the host side).
> > Could you please submit this proposal to the OASIS Virtio TC
> > for inclusion into the next spec draft?
> > Ideally as a patch against the tex source, but a prose
> > description would do as well.
> 
> Most certainly.  Please give me a bit to follow up on this, as the next
> couple of days are going to be hellishly busy..

Ping.
We really need to get this moving to have the interface reviewed for
the next merge window.


> > The TC meets on a bi-weekly basis, we should be able to ratify
> > this quickly.
> > 
> 
> Aside from that, please consider ACK'ing the vhost specific changes so
> these can make it into v3.15-rc1 code.
> 
> --nab
> 
