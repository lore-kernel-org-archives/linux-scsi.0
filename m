From: Venkatesh Srinivas <venkateshs@google.com>
Subject: Re: [PATCH V5 4/5] virtio-scsi: introduce multiqueue support
Date: Tue, 19 Mar 2013 18:46:57 -0700
Message-ID: <20130320014657.GA14714@google.com>
References: <1363687057-13580-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<1363687057-13580-5-git-send-email-gaowanlong@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1363687057-13580-5-git-send-email-gaowanlong@cn.fujitsu.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org, JBottomley@parallels.com, virtualization@lists.linux-foundation.org, vsrinivas@ops101.org, pbonzini@redhat.com, mikew@google.com
List-Id: linux-scsi@vger.kernel.org

This looks pretty good!

I rather like the (lack of) locking in I/O completion (around the req
count vs. target/queue binding). It is unfortunate that you need to 
hold the per-target lock in virtscsi_pick_vq() though; have any idea
how much that lock hurts?

Just two minor comments:

(in struct virtio_scsi_target_data):
+       /* This spinlock never help at the same time as vq_lock. */
                                ^^^^ held?

(in struct virtio_scsi):
+       /* Does the affinity hint is set for virtqueues? */
Could you rephrase that, please?

Tested on qemu and w/ Google Compute Engine's virtio-scsi device.

Reviewed-and-tested-by: Venkatesh Srinivas <venkateshs@google.com>

Thanks,
-- vs;
