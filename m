From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 1/2] virtio: Reduce BUG if total_sg > virtqueue size to
	WARN.
Date: Fri, 11 Aug 2017 20:23:58 +0300
Message-ID: <20170811201843-mutt-send-email-mst@kernel.org>
References: <20170810164035.19963-1-rjones@redhat.com>
	<20170810164035.19963-2-rjones@redhat.com>
	<20170811001447-mutt-send-email-mst@kernel.org>
	<20170810213038.GC20914@redhat.com>
	<20170811003107-mutt-send-email-mst@kernel.org>
	<20170810213511.GB10017@redhat.com>
	<20170811003621-mutt-send-email-mst@kernel.org>
	<64d3c483-076b-1362-b284-30dda704f80c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <64d3c483-076b-1362-b284-30dda704f80c@redhat.com>
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
Cc: jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 11, 2017 at 04:09:26PM +0200, Paolo Bonzini wrote:
> On 10/08/2017 23:41, Michael S. Tsirkin wrote:
> >>> Then we probably should fail probe if vq size is too small.
> >> What does this mean?
> > 
> > We must prevent driver from submitting s/g lists > vq size to device.
> 
> What is the rationale for the limit?

So the host knows what it needs to support.

>  It makes no sense if indirect
> descriptors are available, especially because...
> 
> > Either tell linux to avoid s/g lists that are too long, or
> > simply fail request if this happens, or refuse to attach driver to device.
> > 
> > Later option would look something like this within probe:
> > 
> >         for (i = VIRTIO_SCSI_VQ_BASE; i < num_vqs; i++)
> > 		if (vqs[i]->num < MAX_SG_USED_BY_LINUX)
> > 			goto err;
> > 
> > 
> > I don't know what's MAX_SG_USED_BY_LINUX though.
> > 
> 
> ... both virtio-blk and virtio-scsi transmit their own value for the
> maximum sg list size (max_seg in virtio-scsi, seg_max in virtio-blk).
> 
> Paolo

No other device has it, and it seemed like a good idea to
limit it generally at the time.

we can fix the spec to relax the requirement for blk and scsi -
want to submit a proposal? Alternatively, add a generic field
for that.

For a quick fix, make sure vq size is >= max sg.

-- 
MST
