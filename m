From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/2] virtio-scsi: reset virtqueue affinity when doing cpu
	hotplug
Date: Wed, 16 Jan 2013 14:01:49 +1030
Message-ID: <871udlztui.fsf@rustcorp.com.au>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
	<50F525E3.1000100@cn.fujitsu.com> <50F52677.80100@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <50F52677.80100@cn.fujitsu.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>, virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org, mst@redhat.com, hutao@cn.fujitsu.com, linux-kernel@vger.kernel.org, stefanha@redhat.com, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Wanlong Gao <gaowanlong@cn.fujitsu.com> writes:
> Add hot cpu notifier to reset the request virtqueue affinity
> when doing cpu hotplug.

You need to be careful to get_online_cpus() and put_online_cpus() here,
so CPUs can't go up and down in the middle of operations.

In particular, get_online_cpus()/put_online_cpus() around calls to
virtscsi_set_affinity() (except within notifiers).

> +static int virtscsi_cpu_callback(struct notifier_block *nfb,
> +				 unsigned long action, void *hcpu)
> +{
> +	struct virtio_scsi *vscsi = container_of(nfb, struct virtio_scsi, nb);
> +	switch(action) {
> +	case CPU_ONLINE:
> +	case CPU_ONLINE_FROZEN:
> +	case CPU_DEAD:
> +	case CPU_DEAD_FROZEN:
> +		virtscsi_set_affinity(vscsi, true);
> +		break;
> +	default:
> +		break;
> +	}
> +	return NOTIFY_OK;
> +}

You probably want to remove affinities *before* the CPU goes down, and
restore it after the CPU comes up.

So, how about:

        switch (action & ~CPU_TASKS_FROZEN) {
        case CPU_ONLINE:
        case CPU_DOWN_FAILED:
                virtscsi_set_affinity(vscsi, true, -1);
                break;
        case CPU_DOWN_PREPARE:
                virtscsi_set_affinity(vscsi, true, (unsigned long)hcpu);
                break;
        }

The extra argument to virtscsi_set_affinity() is to tell it to ignore a
cpu which seems online (because it's going down).

>  static void virtscsi_init_vq(struct virtio_scsi_vq *virtscsi_vq,
>  			     struct virtqueue *vq)
>  {
> @@ -888,6 +909,13 @@ static int __devinit virtscsi_probe(struct virtio_device *vdev)
>  	if (err)
>  		goto virtscsi_init_failed;
>  
> +	vscsi->nb.notifier_call = &virtscsi_cpu_callback;
> +	err = register_hotcpu_notifier(&vscsi->nb);
> +	if (err) {
> +		pr_err("virtio_scsi: registering cpu notifier failed\n");
> +		goto scsi_add_host_failed;
> +	}
> +

You have to clean this up if scsi_add_host() fails, I think.

Cheers,
Rusty.
