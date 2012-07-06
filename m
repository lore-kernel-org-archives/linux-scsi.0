From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/6] tcm_vhost/virtio-scsi WIP code for-3.6
Date: Thu, 05 Jul 2012 20:01:12 -0700
Message-ID: <1341543672.23954.285.camel@haakon2.linux-iscsi.org>
References: <1341375846-27882-1-git-send-email-nab@linux-iscsi.org>
	 <20120704140259.GB26485@redhat.com> <4FF45890.6000205@redhat.com>
	 <20120704150557.GA26951@redhat.com> <4FF4BFBD.2080000@us.ibm.com>
	 <1341453135.23954.214.camel@haakon2.linux-iscsi.org>
	 <4FF56AE9.9060201@redhat.com> <20120705135318.GG30572@redhat.com>
	 <4FF59F6B.2000101@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <4FF59F6B.2000101@us.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: Anthony Liguori <aliguori@us.ibm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, ksummit-2012-discuss <ksummit-2012-discuss@lists.linuxfoundation.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-07-05 at 09:06 -0500, Anthony Liguori wrote:
> On 07/05/2012 08:53 AM, Michael S. Tsirkin wrote:
> > On Thu, Jul 05, 2012 at 12:22:33PM +0200, Paolo Bonzini wrote:
> >> Il 05/07/2012 03:52, Nicholas A. Bellinger ha scritto:
> >>>
> >>> fio randrw workload | virtio-scsi-raw | virtio-scsi+tcm_vhost | bare-metal raw block
> >>> ------------------------------------------------------------------------------------
> >>> 25 Write / 75 Read  |      ~15K       |         ~45K          |         ~70K
> >>> 75 Write / 25 Read  |      ~20K       |         ~55K          |         ~60K
> >>
> >> This is impressive, but I think it's still not enough to justify the
> >> inclusion of tcm_vhost.
> 
> We have demonstrated better results at much higher IOP rates with virtio-blk in 
> userspace so while these results are nice, there's no reason to believe we can't 
> do this in userspace.
> 

So I'm pretty sure this discrepancy is attributed to the small block
random I/O bottleneck currently present for all Linux/SCSI core LLDs
regardless of physical or virtual storage fabric.

The SCSI wide host-lock less conversion that happened in .38 code back
in 2010, and subsequently having LLDs like virtio-scsi convert to run in
host-lock-less mode have helped to some extent..  But it's still not
enough..

Another example where we've been able to prove this bottleneck recently
is with the following target setup:

*) Intel Romley production machines with 128 GB of DDR-3 memory
*) 4x FusionIO ioDrive 2 (1.5 TB @ PCI-e Gen2 x2)
*) Mellanox PCI-exress Gen3 HCA running at 56 gb/sec 
*) Infiniband SRP Target backported to RHEL 6.2 + latest OFED

In this setup using ib_srpt + IBLOCK w/ emulate_write_cache=1 +
iomemory_vsl export we end up avoiding SCSI core bottleneck on the
target machine, just as with the tcm_vhost example here for host kernel
side processing with vhost.

Using Linux IB SRP initiator + Windows Server 2008 R2 SCSI-miniport SRP
(OFED) Initiator connected to four ib_srpt LUNs, we've observed that
MSFT SCSI is currently outperforming RHEL 6.2 on the order of ~285K vs.
~215K with heavy random 4k WRITE iometer / fio tests.  Note this with an
optimized queue_depth ib_srp client w/ noop I/O schedulering, but is
still lacking the host_lock-less patches on RHEL 6.2 OFED..

This bottleneck has been mentioned by various people (including myself)
on linux-scsi the last 18 months, and I've proposed that that it be
discussed at KS-2012 so we can start making some forward progress:

http://lists.linux-foundation.org/pipermail/ksummit-2012-discuss/2012-June/000098.html,

> >> In my opinion, vhost-blk/vhost-scsi are mostly
> >> worthwhile as drivers for improvements to QEMU performance.  We want to
> >> add more fast paths to QEMU that let us move SCSI and virtio processing
> >> to separate threads, we have proof of concepts that this can be done,
> >> and we can use vhost-blk/vhost-scsi to find bottlenecks more effectively.
> >
> > A general rant below:
> >
> > OTOH if it works, and adds value, we really should consider including code.
> 
> Users want something that has lots of features and performs really, really well. 
>   They want everything.
> 
> Having one device type that is "fast" but has no features and another that is 
> "not fast" but has a lot of features forces the user to make a bad choice.  No 
> one wins in the end.
> 
> virtio-scsi is brand new.  It's not as if we've had any significant time to make 
> virtio-scsi-qemu faster.  In fact, tcm_vhost existed before virtio-scsi-qemu did 
> if I understand correctly.
> 

So based upon the data above, I'm going to make a prediction that MSFT
guests connected with SCSI miniport <-> tcm_vhost will out perform Linux
guests with virtio-scsi (w/ <= 3.5 host-lock-less) <-> tcm_vhost w/
connected to the same raw block flash iomemory_vsl backends.

Of course that depends upon how fast virtio-scsi drivers get written for
MSFT guests vs. us fixing the long-term performance bottleneck in our
SCSI subsystem.  ;)

(Ksummit-2012 discuss CC'ed for the later)

> > To me, it does not make sense to reject code just because in theory
> > someone could write even better code.
> 
> There is no theory.  We have proof points with virtio-blk.
> 
> > Code walks. Time to marker matters too.
> 
> But guest/user facing decisions cannot be easily unmade and making the wrong 
> technical choices because of premature concerns of "time to market" just result 
> in a long term mess.
> 
> There is no technical reason why tcm_vhost is going to be faster than doing it 
> in userspace.  We can demonstrate this with virtio-blk.  This isn't a 
> theoretical argument.
> 
> > Yes I realize more options increases support. But downstreams can make
> > their own decisions on whether to support some configurations:
> > add a configure option to disable it and that's enough.
> >
> >> In fact, virtio-scsi-qemu and virtio-scsi-vhost are effectively two
> >> completely different devices that happen to speak the same SCSI
> >> transport.  Not only virtio-scsi-vhost must be configured outside QEMU
> >
> > configuration outside QEMU is OK I think - real users use
> > management anyway. But maybe we can have helper scripts
> > like we have for tun?
> 
> Asking a user to write a helper script is pretty awful...
> 

It's easy for anyone with basic python knowledge to use rtslib packages
in the downstream distros to connect to tcm_vhost endpoints LUNs right
now.

All you need is the following vhost.spec, and tcm_vhost works out of the
box for rtslib and targetcli/rtsadmin without any modification to
existing userspace packages:

root@tifa:~# cat /var/target/fabric/vhost.spec 
# WARNING: This is a draft specfile supplied for testing only.

# The fabric module feature set
features = nexus

# Use naa WWNs.
wwn_type = naa

# Non-standard module naming scheme
kernel_module = tcm_vhost

# The configfs group
configfs_group = vhost
