From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 5/5] virtio-scsi: introduce multiqueue support
Date: Tue, 4 Sep 2012 18:03:23 +0300
Message-ID: <20120904150323.GA15116@redhat.com>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
	<1346154857-12487-6-git-send-email-pbonzini@redhat.com>
	<20120904144754.GO9805@redhat.com> <5046167C.3070109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <5046167C.3070109@redhat.com>
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
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 04, 2012 at 04:55:56PM +0200, Paolo Bonzini wrote:
> Il 04/09/2012 16:47, Michael S. Tsirkin ha scritto:
> >> >  static void virtscsi_init_vq(struct virtio_scsi_vq *virtscsi_vq,
> >> > -			     struct virtqueue *vq)
> >> > +			     struct virtqueue *vq, bool affinity)
> >> >  {
> >> >  	spin_lock_init(&virtscsi_vq->vq_lock);
> >> >  	virtscsi_vq->vq = vq;
> >> > +	if (affinity)
> >> > +		virtqueue_set_affinity(vq, virtqueue_get_queue_index(vq) -
> >> > +				       VIRTIO_SCSI_VQ_BASE);
> >> >  }
> >> >  
> > This means in practice if you have less virtqueues than CPUs,
> > things are not going to work well, will they?
> 
> Not particularly.  It could be better or worse than single queue
> depending on the workload.

Well interrupts will go to CPU different from the one
that sends commands so ...

> > Any idea what to do?
> 
> Two possibilities:
> 
> 1) Add a stride argument to virtqueue_set_affinity, and make it equal to
> the number of queues.
> 
> 2) Make multiqueue the default in QEMU, and make the default number of
> queues equal to the number of VCPUs.
> 
> I was going for (2).
> 
> Paolo

3. use per target queue if less targets than cpus?

-- 
MST
