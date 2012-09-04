From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 5/5] virtio-scsi: introduce multiqueue support
Date: Tue, 4 Sep 2012 15:48:00 +0300
Message-ID: <20120904124800.GE9805@redhat.com>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
	<1346154857-12487-6-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1346154857-12487-6-git-send-email-pbonzini@redhat.com>
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

On Tue, Aug 28, 2012 at 01:54:17PM +0200, Paolo Bonzini wrote:
> This patch adds queue steering to virtio-scsi.  When a target is sent
> multiple requests, we always drive them to the same queue so that FIFO
> processing order is kept.  However, if a target was idle, we can choose
> a queue arbitrarily.  In this case the queue is chosen according to the
> current VCPU, so the driver expects the number of request queues to be
> equal to the number of VCPUs.  This makes it easy and fast to select
> the queue, and also lets the driver optimize the IRQ affinity for the
> virtqueues (each virtqueue's affinity is set to the CPU that "owns"
> the queue).
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

I guess an alternative is a per-target vq.
Is the reason you avoid this that you expect more targets
than cpus? If yes this is something you might want to
mention in the log.
