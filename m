From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5/5] virtio-scsi: introduce multiqueue support
Date: Tue, 04 Sep 2012 16:25:03 +0200
Message-ID: <50460F3F.8080305@redhat.com>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
	<1346154857-12487-6-git-send-email-pbonzini@redhat.com>
	<1346725294.4162.79.camel@haakon2.linux-iscsi.org>
	<5045A3B4.2030101@redhat.com> <20120904084628.GA8437@redhat.com>
	<5045D6FF.5020801@redhat.com> <20120904110905.GA9119@redhat.com>
	<5045E387.4030103@redhat.com> <20120904133543.GF9805@redhat.com>
	<50460615.3000006@redhat.com> <20120904141924.GK9805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20120904141924.GK9805@redhat.com>
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

Il 04/09/2012 16:19, Michael S. Tsirkin ha scritto:
> > > Also - some kind of comment explaining why a similar race can not happen
> > > with this lock in place would be nice: I see why this specific race can
> > > not trigger but since lock is dropped later before you submit command, I
> > > have hard time convincing myself what exactly gurantees that vq is never
> > > switched before or even while command is submitted.
> > 
> > Because tgt->reqs will never become zero (which is a necessary condition
> > for tgt->req_vq to change), as long as one request is executing
> > virtscsi_queuecommand.
> 
> Yes but this logic would apparently imply the lock is not necessary, and
> it actually is. I am not saying anything is wrong just that it
> looks scary.

Ok, I get the misunderstanding.  For the logic to hold, you need a
serialization point after which tgt->req_vq is not changed.  The lock
provides one such serialization point: after you unlock tgt->tgt_lock,
nothing else will change tgt->req_vq until your request completes.

Without the lock, there could always be a thread that is in the "then"
branch but has been scheduled out, and when rescheduled it will change
tgt->req_vq.

Perhaps the confusion comes from the atomic_inc_return, and that was
what my "why is this atomic" wanted to clear.  **tgt->reqs is only
atomic to avoid taking a spinlock in the ISR**.  If you read the code
with the lock, but with tgt->reqs as a regular non-atomic int, it should
be much easier to reason on the code.  I can split the patch if needed.

Paolo
