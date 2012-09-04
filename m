From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5/5] virtio-scsi: introduce multiqueue support
Date: Tue, 04 Sep 2012 15:45:57 +0200
Message-ID: <50460615.3000006@redhat.com>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
	<1346154857-12487-6-git-send-email-pbonzini@redhat.com>
	<1346725294.4162.79.camel@haakon2.linux-iscsi.org>
	<5045A3B4.2030101@redhat.com> <20120904084628.GA8437@redhat.com>
	<5045D6FF.5020801@redhat.com> <20120904110905.GA9119@redhat.com>
	<5045E387.4030103@redhat.com> <20120904133543.GF9805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20120904133543.GF9805@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, target-devel <target-devel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Il 04/09/2012 15:35, Michael S. Tsirkin ha scritto:
> I see.  I guess you can rewrite this as:
> atomic_inc
> if (atomic_read() == 1)
> which is a bit cheaper, and make the fact
> that you do not need increment and return to be atomic,
> explicit.

It seems more complicated to me for hardly any reason.  (Besides, is it
cheaper?  It has one less memory barrier on some architectures I frankly
do not care much about---not on x86---but it also has two memory
accesses instead of one on all architectures).

> Another simple idea: store last processor id in target,
> if it is unchanged no need to play with req_vq
> and take spinlock.

Not so sure, consider the previous example with last_processor_id equal
to 1.

    queuecommand on CPU #0         queuecommand #2 on CPU #1
  --------------------------------------------------------------
    atomic_inc_return(...) == 1
                                   atomic_inc_return(...) == 2
                                   virtscsi_queuecommand to queue #1
    last_processor_id == 0? no
    spin_lock
    tgt->req_vq = queue #0
    spin_unlock
    virtscsi_queuecommand to queue #0

This is not a network driver, there are still a lot of locks around.
This micro-optimization doesn't pay enough for the pain.

> Also - some kind of comment explaining why a similar race can not happen
> with this lock in place would be nice: I see why this specific race can
> not trigger but since lock is dropped later before you submit command, I
> have hard time convincing myself what exactly gurantees that vq is never
> switched before or even while command is submitted.

Because tgt->reqs will never become zero (which is a necessary condition
for tgt->req_vq to change), as long as one request is executing
virtscsi_queuecommand.

Paolo
