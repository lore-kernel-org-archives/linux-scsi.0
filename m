From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH V7 4/5] virtio-scsi: introduce multiqueue support
Date: Mon, 25 Mar 2013 15:27:30 +0100
Message-ID: <51505ED2.70208@redhat.com>
References: <1364038124-32479-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<1364038124-32479-5-git-send-email-gaowanlong@cn.fujitsu.com>
	<514FFC06.9030703@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <514FFC06.9030703@acm.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org, JBottomley@parallels.com, virtualization@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Il 25/03/2013 08:25, Bart Van Assche ha scritto:
>>
>> +        queue_num = smp_processor_id();
>> +        while (unlikely(queue_num >= vscsi->num_queues))
>> +            queue_num -= vscsi->num_queues;
>> +
>> +        tgt->req_vq = vq = &vscsi->req_vqs[queue_num];
>> +    }
>> +
>> +    spin_unlock_irqrestore(&tgt->tgt_lock, flags);
>> +    return vq;
>> +}
> 
> Is there any reason why the smp_processor_id() % vscsi->num_queues
> computation in virtscsi_pick_vq() has been implemented as a loop instead
> of as an arithmetic operation ? If so, I would appreciate it if that
> could be explained in a comment.

The expectation is that vscsi->num_queues is the same as the number of
CPUs in the virtual machine; see patch 5 too.

Paolo
