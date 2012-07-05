From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 0/6] tcm_vhost/virtio-scsi WIP code for-3.6
Date: Thu, 5 Jul 2012 12:31:13 +0300
Message-ID: <20120705093113.GC29373@redhat.com>
References: <1341375846-27882-1-git-send-email-nab@linux-iscsi.org>
	<20120704140259.GB26485@redhat.com> <4FF45890.6000205@redhat.com>
	<20120704150557.GA26951@redhat.com>
	<1341453665.23954.224.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1341453665.23954.224.camel@haakon2.linux-iscsi.org>
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
Cc: Jens Axboe <axboe@kernel.dk>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm-devel <kvm@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 04, 2012 at 07:01:05PM -0700, Nicholas A. Bellinger wrote:
> On Wed, 2012-07-04 at 18:05 +0300, Michael S. Tsirkin wrote:
> > On Wed, Jul 04, 2012 at 04:52:00PM +0200, Paolo Bonzini wrote:
> > > Il 04/07/2012 16:02, Michael S. Tsirkin ha scritto:
> > > > On Wed, Jul 04, 2012 at 04:24:00AM +0000, Nicholas A. Bellinger wrote:
> > > >> From: Nicholas Bellinger <nab@linux-iscsi.org>
> > > >>
> > > >> Hi folks,
> > > >>
> > > >> This series contains patches required to update tcm_vhost <-> virtio-scsi
> > > >> connected hosts <-> guests to run on v3.5-rc2 mainline code.  This series is
> > > >> available on top of target-pending/auto-next here:
> > > >>
> > > >>    git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git tcm_vhost
> > > >>
> > > >> This includes the necessary vhost changes from Stefan to to get tcm_vhost
> > > >> functioning, along a virtio-scsi LUN scanning change to address a client bug
> > > >> with tcm_vhost I ran into..  Also, tcm_vhost driver has been merged into a single
> > > >> source + header file that is now living under /drivers/vhost/, along with latest
> > > >> tcm_vhost changes from Zhi's tcm_vhost tree.
> > > >>
> > > >> Here are a couple of screenshots of the code in action using raw IBLOCK
> > > >> backends provided by FusionIO ioDrive Duo:
> > > >>
> > > >>    http://linux-iscsi.org/images/Virtio-scsi-tcm-vhost-3.5-rc2-3.png
> > > >>    http://linux-iscsi.org/images/Virtio-scsi-tcm-vhost-3.5-rc2-4.png
> > > >>
> > > >> So the next steps on my end will be converting tcm_vhost to submit backend I/O from
> > > >> cmwq context, along with fio benchmark numbers between tcm_vhost/virtio-scsi and
> > > >> virtio-scsi-raw using raw IBLOCK iomemory_vsl flash.
> > > > 
> > > > OK so this is an RFC, not for merge yet?
> > > 
> > > Patch 6 definitely looks RFCish, but patch 5 should go in anyway.
> > > 
> > > Paolo
> > 
> > I was talking about 4/6 first of all.
> 
> So yeah, this code is still considered RFC at this point for-3.6, but
> I'd like to get this into target-pending/for-next in next week for more
> feedback and start collecting signoffs for the necessary pieces that
> effect existing vhost code.
> 
> By that time the cmwq conversion of tcm_vhost should be in place as
> well..

I'll try to give some feedback but I think we do need
to see the qemu patches - they weren't posted yet, were they?
This driver has some userspace interface and once
that is merged it has to be supported.
So I think we need the buy-in from the qemu side at the principal level.

> > Anyway, it's best to split, not to mix RFCs and fixes.
> > 
> 
> <nod>, I'll send patch #5 separately to linux-scsi -> James and CC
> stable following Paolo's request.
> 
> Thanks!
> 
> --nab
