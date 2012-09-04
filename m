From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 5/5] virtio-scsi: introduce multiqueue support
Date: Tue, 4 Sep 2012 16:35:43 +0300
Message-ID: <20120904133543.GF9805@redhat.com>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
	<1346154857-12487-6-git-send-email-pbonzini@redhat.com>
	<1346725294.4162.79.camel@haakon2.linux-iscsi.org>
	<5045A3B4.2030101@redhat.com> <20120904084628.GA8437@redhat.com>
	<5045D6FF.5020801@redhat.com> <20120904110905.GA9119@redhat.com>
	<5045E387.4030103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <5045E387.4030103@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, target-devel <target-devel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 04, 2012 at 01:18:31PM +0200, Paolo Bonzini wrote:
> Il 04/09/2012 13:09, Michael S. Tsirkin ha scritto:
> >> >     queuecommand on CPU #0         queuecommand #2 on CPU #1
> >> >   --------------------------------------------------------------
> >> >     atomic_inc_return(...) == 1
> >> >                                    atomic_inc_return(...) == 2
> >> >                                    virtscsi_queuecommand to queue #1
> >> >     tgt->req_vq = queue #0
> >> >     virtscsi_queuecommand to queue #0
> >> > 
> >> > then two requests are issued to different queues without a quiescent
> >> > point in the middle.
> > What happens then? Does this break correctness?
> 
> Yes, requests to the same target should be processed in FIFO order, or
> you have things like a flush issued before the write it was supposed to
> flush.  This is why I can only change the queue when there is no request
> pending.
> 
> Paolo

I see.  I guess you can rewrite this as:
atomic_inc
if (atomic_read() == 1)
which is a bit cheaper, and make the fact
that you do not need increment and return to be atomic,
explicit.

Another simple idea: store last processor id in target,
if it is unchanged no need to play with req_vq
and take spinlock.

Also - some kind of comment explaining why a similar race can not happen
with this lock in place would be nice: I see why this specific race can
not trigger but since lock is dropped later before you submit command, I
have hard time convincing myself what exactly gurantees that vq is never
switched before or even while command is submitted.




-- 
MST
