From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH v2 5/5] virtio-scsi: introduce multiqueue support
Date: Tue, 25 Dec 2012 20:41:09 +0800
Message-ID: <50D99EE5.2090905@cn.fujitsu.com>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
	<1355833972-20319-6-git-send-email-pbonzini@redhat.com>
	<20121218135736.GF26110@redhat.com> <50D078C8.208@redhat.com>
	<20121218150327.GB27400@redhat.com> <50D09100.3060505@redhat.com>
	<20121218160226.GA28445@redhat.com>
Reply-To: gaowanlong@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20121218160226.GA28445@redhat.com>
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
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org, hutao@cn.fujitsu.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, stefanha@redhat.com, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 12/19/2012 12:02 AM, Michael S. Tsirkin wrote:
> On Tue, Dec 18, 2012 at 04:51:28PM +0100, Paolo Bonzini wrote:
>> Il 18/12/2012 16:03, Michael S. Tsirkin ha scritto:
>>> On Tue, Dec 18, 2012 at 03:08:08PM +0100, Paolo Bonzini wrote:
>>>> Il 18/12/2012 14:57, Michael S. Tsirkin ha scritto:
>>>>>> -static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
>>>>>> +static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
>>>>>> +				 struct virtio_scsi_target_state *tgt,
>>>>>> +				 struct scsi_cmnd *sc)
>>>>>>  {
>>>>>> -	struct virtio_scsi *vscsi = shost_priv(sh);
>>>>>> -	struct virtio_scsi_target_state *tgt = &vscsi->tgt[sc->device->id];
>>>>>>  	struct virtio_scsi_cmd *cmd;
>>>>>> +	struct virtio_scsi_vq *req_vq;
>>>>>>  	int ret;
>>>>>>  
>>>>>>  	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
>>>>>> @@ -461,7 +533,8 @@ static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
>>>>>>  	BUG_ON(sc->cmd_len > VIRTIO_SCSI_CDB_SIZE);
>>>>>>  	memcpy(cmd->req.cmd.cdb, sc->cmnd, sc->cmd_len);
>>>>>>  
>>>>>> -	if (virtscsi_kick_cmd(tgt, &vscsi->req_vq, cmd,
>>>>>> +	req_vq = ACCESS_ONCE(tgt->req_vq);
>>>>>
>>>>> This ACCESS_ONCE without a barrier looks strange to me.
>>>>> Can req_vq change? Needs a comment.
>>>>
>>>> Barriers are needed to order two things.  Here I don't have the second thing
>>>> to order against, hence no barrier.
>>>>
>>>> Accessing req_vq lockless is safe, and there's a comment about it, but you
>>>> still want ACCESS_ONCE to ensure the compiler doesn't play tricks.
>>>
>>> That's just it.
>>> Why don't you want compiler to play tricks?
>>
>> Because I want the lockless access to occur exactly when I write it.
> 
> It doesn't occur when you write it. CPU can still move accesses
> around. That's why you either need both ACCESS_ONCE and a barrier
> or none.
> 
>> Otherwise I have one more thing to think about, i.e. what a crazy
>> compiler writer could do with my code.  And having been on the other
>> side of the trench, compiler writers can have *really* crazy ideas.
>>
>> Anyhow, I'll reorganize the code to move the ACCESS_ONCE closer to the
>> write and make it clearer.
>>
>>>>>> +	if (virtscsi_kick_cmd(tgt, req_vq, cmd,
>>>>>>  			      sizeof cmd->req.cmd, sizeof cmd->resp.cmd,
>>>>>>  			      GFP_ATOMIC) == 0)
>>>>>>  		ret = 0;
>>>>>> @@ -472,6 +545,48 @@ out:
>>>>>>  	return ret;
>>>>>>  }
>>>>>>  
>>>>>> +static int virtscsi_queuecommand_single(struct Scsi_Host *sh,
>>>>>> +					struct scsi_cmnd *sc)
>>>>>> +{
>>>>>> +	struct virtio_scsi *vscsi = shost_priv(sh);
>>>>>> +	struct virtio_scsi_target_state *tgt = &vscsi->tgt[sc->device->id];
>>>>>> +
>>>>>> +	atomic_inc(&tgt->reqs);
>>>>>
>>>>> And here we don't have barrier after atomic? Why? Needs a comment.
>>>>
>>>> Because we don't write req_vq, so there's no two writes to order.  Barrier
>>>> against what?
>>>
>>> Between atomic update and command. Once you queue command it
>>> can complete and decrement reqs, if this happens before
>>> increment reqs can become negative even.
>>
>> This is not a problem.  Please read Documentation/memory-barrier.txt:
>>
>>    The following also do _not_ imply memory barriers, and so may
>>    require explicit memory barriers under some circumstances
>>    (smp_mb__before_atomic_dec() for instance):
>>
>>         atomic_add();
>>         atomic_sub();
>>         atomic_inc();
>>         atomic_dec();
>>
>>    If they're used for statistics generation, then they probably don't
>>    need memory barriers, unless there's a coupling between statistical
>>    data.
>>
>> This is the single-queue case, so it falls under this case.
> 
> Aha I missed it's single queue. Correct but please add a comment.
> 
>>>>>>  	/* Discover virtqueues and write information to configuration.  */
>>>>>> -	err = vdev->config->find_vqs(vdev, 3, vqs, callbacks, names);
>>>>>> +	err = vdev->config->find_vqs(vdev, num_vqs, vqs, callbacks, names);
>>>>>>  	if (err)
>>>>>>  		return err;
>>>>>>  
>>>>>> -	virtscsi_init_vq(&vscsi->ctrl_vq, vqs[0]);
>>>>>> -	virtscsi_init_vq(&vscsi->event_vq, vqs[1]);
>>>>>> -	virtscsi_init_vq(&vscsi->req_vq, vqs[2]);
>>>>>> +	virtscsi_init_vq(&vscsi->ctrl_vq, vqs[0], false);
>>>>>> +	virtscsi_init_vq(&vscsi->event_vq, vqs[1], false);
>>>>>> +	for (i = VIRTIO_SCSI_VQ_BASE; i < num_vqs; i++)
>>>>>> +		virtscsi_init_vq(&vscsi->req_vqs[i - VIRTIO_SCSI_VQ_BASE],
>>>>>> +				 vqs[i], vscsi->num_queues > 1);
>>>>>
>>>>> So affinity is true if >1 vq? I am guessing this is not
>>>>> going to do the right thing unless you have at least
>>>>> as many vqs as CPUs.
>>>>
>>>> Yes, and then you're not setting up the thing correctly.
>>>
>>> Why not just check instead of doing the wrong thing?
>>
>> The right thing could be to set the affinity with a stride, e.g. CPUs
>> 0-4 for virtqueue 0 and so on until CPUs 3-7 for virtqueue 3.
>>
>> Paolo
> 
> I think a simple #vqs == #cpus check would be kind of OK for
> starters, otherwise let userspace set affinity.
> Again need to think what happens with CPU hotplug.

How about dynamicly setting affinity this way?
========================================================================
Subject: [PATCH] virtio-scsi: set virtqueue affinity under cpu hotplug

We set virtqueue affinity when the num_queues equals to the number
of VCPUs. Register a hotcpu notifier to notifier whether the
VCPU number is changed. If the VCPU number is changed, we
force to set virtqueue affinity again.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 drivers/scsi/virtio_scsi.c | 72 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 66 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 3641d5f..1b28e03 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -20,6 +20,7 @@
 #include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
 #include <linux/virtio_scsi.h>
+#include <linux/cpu.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
@@ -106,6 +107,9 @@ struct virtio_scsi {
 
 	u32 num_queues;
 
+	/* Does the affinity hint is set for virtqueues? */
+	bool affinity_hint_set;
+
 	struct virtio_scsi_vq ctrl_vq;
 	struct virtio_scsi_vq event_vq;
 	struct virtio_scsi_vq req_vqs[];
@@ -113,6 +117,7 @@ struct virtio_scsi {
 
 static struct kmem_cache *virtscsi_cmd_cache;
 static mempool_t *virtscsi_cmd_pool;
+static bool cpu_hotplug = false;
 
 static inline struct Scsi_Host *virtio_scsi_host(struct virtio_device *vdev)
 {
@@ -555,6 +560,52 @@ static int virtscsi_queuecommand_single(struct Scsi_Host *sh,
 	return virtscsi_queuecommand(vscsi, tgt, sc);
 }
 
+static void virtscsi_set_affinity(struct virtio_scsi *vscsi,
+				  bool affinity)
+{
+	int i;
+
+	/* In multiqueue mode, when the number of cpu is equal to the number of
+	 * request queues , we let the queues to be private to one cpu by
+	 * setting the affinity hint to eliminate the contention.
+	 */
+	if ((vscsi->num_queues == 1 ||
+	    vscsi->num_queues != num_online_cpus()) && affinity) {
+		if (vscsi->affinity_hint_set)
+			affinity = false;
+		else
+			return;
+	}
+
+	for (i = 0; i < vscsi->num_queues - VIRTIO_SCSI_VQ_BASE; i++) {
+		int cpu = affinity ? i : -1;
+		virtqueue_set_affinity(vscsi->req_vqs[i].vq, cpu);
+	}
+
+	if (affinity)
+		vscsi->affinity_hint_set = true;
+	else
+		vscsi->affinity_hint_set = false;
+}
+
+static int __cpuinit virtscsi_cpu_callback(struct notifier_block *nfb,
+					   unsigned long action, void *hcpu)
+{
+	switch (action) {
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		cpu_hotplug = true;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata virtscsi_cpu_notifier =
+{
+	.notifier_call = virtscsi_cpu_callback,
+};
+
 static int virtscsi_queuecommand_multi(struct Scsi_Host *sh,
 				       struct scsi_cmnd *sc)
 {
@@ -563,6 +614,11 @@ static int virtscsi_queuecommand_multi(struct Scsi_Host *sh,
 	unsigned long flags;
 	u32 queue_num;
 
+	if (unlikely(cpu_hotplug == true)) {
+		virtscsi_set_affinity(vscsi, true);
+		cpu_hotplug = false;
+	}
+
 	/*
 	 * Using an atomic_t for tgt->reqs lets the virtqueue handler
 	 * decrement it without taking the spinlock.
@@ -703,12 +759,10 @@ static struct scsi_host_template virtscsi_host_template_multi = {
 
 
 static void virtscsi_init_vq(struct virtio_scsi_vq *virtscsi_vq,
-			     struct virtqueue *vq, bool affinity)
+			     struct virtqueue *vq)
 {
 	spin_lock_init(&virtscsi_vq->vq_lock);
 	virtscsi_vq->vq = vq;
-	if (affinity)
-		virtqueue_set_affinity(vq, vq->index - VIRTIO_SCSI_VQ_BASE);
 }
 
 static void virtscsi_init_tgt(struct virtio_scsi *vscsi, int i)
@@ -736,6 +790,8 @@ static void virtscsi_remove_vqs(struct virtio_device *vdev)
 	struct Scsi_Host *sh = virtio_scsi_host(vdev);
 	struct virtio_scsi *vscsi = shost_priv(sh);
 
+	virtscsi_set_affinity(vscsi, false);
+
 	/* Stop all the virtqueues. */
 	vdev->config->reset(vdev);
 
@@ -779,11 +835,14 @@ static int virtscsi_init(struct virtio_device *vdev,
 	if (err)
 		return err;
 
-	virtscsi_init_vq(&vscsi->ctrl_vq, vqs[0], false);
-	virtscsi_init_vq(&vscsi->event_vq, vqs[1], false);
+	virtscsi_init_vq(&vscsi->ctrl_vq, vqs[0]);
+	virtscsi_init_vq(&vscsi->event_vq, vqs[1]);
 	for (i = VIRTIO_SCSI_VQ_BASE; i < num_vqs; i++)
 		virtscsi_init_vq(&vscsi->req_vqs[i - VIRTIO_SCSI_VQ_BASE],
-				 vqs[i], vscsi->num_queues > 1);
+				 vqs[i]);
+
+	virtscsi_set_affinity(vscsi, true);
+	register_hotcpu_notifier(&virtscsi_cpu_notifier);
 
 	virtscsi_config_set(vdev, cdb_size, VIRTIO_SCSI_CDB_SIZE);
 	virtscsi_config_set(vdev, sense_size, VIRTIO_SCSI_SENSE_SIZE);
@@ -882,6 +941,7 @@ static void __devexit virtscsi_remove(struct virtio_device *vdev)
 	struct Scsi_Host *shost = virtio_scsi_host(vdev);
 	struct virtio_scsi *vscsi = shost_priv(shost);
 
+	unregister_hotcpu_notifier(&virtscsi_cpu_notifier);
 	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG))
 		virtscsi_cancel_event_work(vscsi);
 
-- 
1.8.0

Thanks,
Wanlong Gao

> 
>>>> Isn't the same thing true for virtio-net mq?
>>>>
>>>> Paolo
>>>
>>> Last I looked it checked vi->max_queue_pairs == num_online_cpus().
>>> This is even too aggressive I think, max_queue_pairs >=
>>> num_online_cpus() should be enough.
>>>
> 
