From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH V5 4/5] virtio-scsi: introduce multiqueue support
Date: Wed, 20 Mar 2013 10:53:59 +0100
Message-ID: <51498737.8000800@redhat.com>
References: <1363687057-13580-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<1363687057-13580-5-git-send-email-gaowanlong@cn.fujitsu.com>
	<20130320014657.GA14714@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20130320014657.GA14714@google.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Venkatesh Srinivas <venkateshs@google.com>
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org, JBottomley@parallels.com, virtualization@lists.linux-foundation.org, vsrinivas@ops101.org, mikew@google.com
List-Id: linux-scsi@vger.kernel.org

Il 20/03/2013 02:46, Venkatesh Srinivas ha scritto:
> This looks pretty good!
> 
> I rather like the (lack of) locking in I/O completion (around the req
> count vs. target/queue binding). It is unfortunate that you need to hold
> the per-target lock in virtscsi_pick_vq() though; have any idea
> how much that lock hurts?

It doesn't hurt, the lock is mostly uncontended.

- if you have lots of I/O, it's held for a very small period of time; if
you have little I/O, it's uncontended anyway.

- the SCSI layer will serialize on the host lock anyway before calling
into the LLD.  Locks are "pipelined" so that in the end the host lock
will be a bigger bottleneck than the others.

Most of the time it only costs 2 extra atomic operations, which should
be galf a microsecond or less.

Paolo

> Just two minor comments:
> 
> (in struct virtio_scsi_target_data):
> +       /* This spinlock never help at the same time as vq_lock. */
>                                ^^^^ held?
> 
> (in struct virtio_scsi):
> +       /* Does the affinity hint is set for virtqueues? */
> Could you rephrase that, please?
> 
> Tested on qemu and w/ Google Compute Engine's virtio-scsi device.
> 
> Reviewed-and-tested-by: Venkatesh Srinivas <venkateshs@google.com>
> 
> Thanks,
> -- vs;
