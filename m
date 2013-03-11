From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH V4 1/5] virtio-scsi: redo allocation of target data
Date: Mon, 11 Mar 2013 12:31:19 +0100
Message-ID: <513DC087.6000508@redhat.com>
References: <1362969842-9145-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<1362969842-9145-2-git-send-email-gaowanlong@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1362969842-9145-2-git-send-email-gaowanlong@cn.fujitsu.com>
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
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org, JBottomley@parallels.com, virtualization@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Il 11/03/2013 03:43, Wanlong Gao ha scritto:
> virtio_scsi_target_state is now empty, but we will find new uses
> for it in the next few patches.  However, dropping the sglist lets
> us turn the array-of-pointers into a simple array, which simplifies
> the allocation.
> 
> However, we do not leave the virtio_scsi_target_state structs in the
> flexible array member at the end of struct virtio_scsi, because
> we will place the virtqueues there in the next patches.

If you have to respin, consider improving the grammar:

virtio_scsi_target_state is now empty.  We will find new uses for it in
the next few patches, so this patch does not drop it completely.
However, having dropped the sglist flexible array member, we can turn
the tgt array-of-pointers into a simple array.  This simplifies the
allocation.

Even simpler would be to place the virtio_scsi_target_state structs in a
flexible array member at the end of struct virtio_scsi.  But we do not
do that, because we will place the virtqueues there in the next patches.

Paolo

> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
