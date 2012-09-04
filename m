From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5/5] virtio-scsi: introduce multiqueue support
Date: Tue, 04 Sep 2012 13:18:31 +0200
Message-ID: <5045E387.4030103@redhat.com>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
	<1346154857-12487-6-git-send-email-pbonzini@redhat.com>
	<1346725294.4162.79.camel@haakon2.linux-iscsi.org>
	<5045A3B4.2030101@redhat.com> <20120904084628.GA8437@redhat.com>
	<5045D6FF.5020801@redhat.com> <20120904110905.GA9119@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20120904110905.GA9119@redhat.com>
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

Il 04/09/2012 13:09, Michael S. Tsirkin ha scritto:
>> >     queuecommand on CPU #0         queuecommand #2 on CPU #1
>> >   --------------------------------------------------------------
>> >     atomic_inc_return(...) == 1
>> >                                    atomic_inc_return(...) == 2
>> >                                    virtscsi_queuecommand to queue #1
>> >     tgt->req_vq = queue #0
>> >     virtscsi_queuecommand to queue #0
>> > 
>> > then two requests are issued to different queues without a quiescent
>> > point in the middle.
> What happens then? Does this break correctness?

Yes, requests to the same target should be processed in FIFO order, or
you have things like a flush issued before the write it was supposed to
flush.  This is why I can only change the queue when there is no request
pending.

Paolo
