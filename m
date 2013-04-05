From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH V7 0/5] virtio-scsi multiqueue
Date: Fri, 05 Apr 2013 16:55:41 +0800
Message-ID: <515E918D.3090307@cn.fujitsu.com>
References: <1364038124-32479-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<5153A953.2000101@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <5153A953.2000101@cn.fujitsu.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, James Bottomley <James.Bottomley@HansenPartnership.com>, pbonzini@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 03/28/2013 10:22 AM, Wanlong Gao wrote:
> On 03/23/2013 07:28 PM, Wanlong Gao wrote:
>> This series implements virtio-scsi queue steering, which gives
>> performance improvements of up to 50% (measured both with QEMU and
>> tcm_vhost backends).
>>
>> This version rebased on Rusty's virtio ring rework patches, which
>> has already gone into virtio-next today.
>> We hope this can go into virtio-next together with the virtio ring
>> rework pathes.
>>
>> V7: respin to fix the patch apply error
>>
>> V6: rework "redo allocation of target data" (James)
>>     fix comments (Venkatesh)
>>     rebase to virtio-next
>>
>> V5: improving the grammar of 1/5 (Paolo)
>>     move the dropping of sg_elems to 'virtio-scsi: use virtqueue_add_sgs for command buffers'. (Asias)
>>
>> V4: rebase on virtio ring rework patches (rusty's pending-rebases branch)
>>
>> V3 and be found http://marc.info/?l=linux-virtualization&m=136067440717154&w=2
>>
>>
>> It would probably be easier to get it in via Rusty's tree
>> because of the prerequisites.  James, can we get your Acked-by?
> 
> James, any thoughts for this version?

Ping James....


> 
> Thanks,
> Wanlong Gao
> 
>>
>> Paolo Bonzini (3):
>>   virtio-scsi: pass struct virtio_scsi to virtqueue completion function
>>   virtio-scsi: push vq lock/unlock into virtscsi_vq_done
>>   virtio-scsi: introduce multiqueue support
>>
>> Wanlong Gao (2):
>>   virtio-scsi: redo allocation of target data
>>   virtio-scsi: reset virtqueue affinity when doing cpu hotplug
>>
>>  drivers/scsi/virtio_scsi.c | 387 ++++++++++++++++++++++++++++++++++++---------
>>  1 file changed, 309 insertions(+), 78 deletions(-)
>>
> 
> 
