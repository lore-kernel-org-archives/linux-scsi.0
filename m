From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH 0/5] blk-mq/scsi-mq: support global tags & introduce force_blk_mq
Date: Tue, 6 Feb 2018 11:33:50 +0530
Message-ID: <4c8162129f2a09dca2d1e7eefd61e272@mail.gmail.com>
References: <20180203042112.15239-1-ming.lei@redhat.com> <07c1f41e-de7c-5e3d-1a2d-0cd7af7b46df@suse.de>
 <528c93de0aac9010e274847ab1ae0328@mail.gmail.com> <20180205101734.GA32558@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180205101734.GA32558@ming.t460p>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

> > We still have more than one reply queue ending up completion one CPU.
>
> pci_alloc_irq_vectors(PCI_IRQ_AFFINITY) has to be used, that means
> smp_affinity_enable has to be set as 1, but seems it is the default
setting.
>
> Please see kernel/irq/affinity.c, especially irq_calc_affinity_vectors()
which
> figures out an optimal number of vectors, and the computation is based
on
> cpumask_weight(cpu_possible_mask) now. If all offline CPUs are mapped to
> some of reply queues, these queues won't be active(no request submitted
to
> these queues). The mechanism of PCI_IRQ_AFFINITY basically makes sure
that
> more than one irq vector won't be handled by one same CPU, and the irq
> vector spread is done in irq_create_affinity_masks().
>
> > Try to reduce MSI-x vector of megaraid_sas or mpt3sas driver via
> > module parameter to simulate the issue. We need more number of Online
> > CPU than reply-queue.
>
> IMO, you don't need to simulate the issue, pci_alloc_irq_vectors(
> PCI_IRQ_AFFINITY) will handle that for you. You can dump the returned
irq
> vector number, num_possible_cpus()/num_online_cpus() and each irq
> vector's affinity assignment.
>
> > We may see completion redirected to original CPU because of
> > "QUEUE_FLAG_SAME_FORCE", but ISR of low level driver can keep one CPU
> > busy in local ISR routine.
>
> Could you dump each irq vector's affinity assignment of your megaraid in
your
> test?

To quickly reproduce, I restricted to single MSI-x vector on megaraid_sas
driver.  System has total 16 online CPUs.

Output of affinity hints.
kernel version:
Linux rhel7.3 4.15.0-rc1+ #2 SMP Mon Feb 5 12:13:34 EST 2018 x86_64 x86_64
x86_64 GNU/Linux
PCI name is 83:00.0, dump its irq affinity:
irq 105, cpu list 0-3,8-11

Affinity mask is created properly, but only CPU-0 is overloaded with
interrupt processing.

# numactl --hardware
available: 2 nodes (0-1)
node 0 cpus: 0 1 2 3 8 9 10 11
node 0 size: 47861 MB
node 0 free: 46516 MB
node 1 cpus: 4 5 6 7 12 13 14 15
node 1 size: 64491 MB
node 1 free: 62805 MB
node distances:
node   0   1
  0:  10  21
  1:  21  10

Output of  system activities (sar).  (gnice is 100% and it is consumed in
megaraid_sas ISR routine.)


12:44:40 PM     CPU      %usr     %nice      %sys   %iowait    %steal
%irq     %soft    %guest    %gnice     %idle
12:44:41 PM     all         6.03      0.00        29.98      0.00
0.00         0.00        0.00        0.00        0.00         63.99
12:44:41 PM       0         0.00      0.00         0.00        0.00
0.00         0.00        0.00        0.00       100.00         0


In my test, I used rq_affinity is set to 2. (QUEUE_FLAG_SAME_FORCE). I
also used " host_tagset" V2 patch set for megaraid_sas.

Using RFC requested in -
"https://marc.info/?l=linux-scsi&m=151601833418346&w=2 " lockup is avoided
(you can noticed that gnice is shifted to softirq. Even though it is 100%
consumed, There is always exit for existing completion loop due to
irqpoll_weight  @irq_poll_init().

Average:        CPU      %usr     %nice      %sys   %iowait    %steal
%irq     %soft    %guest    %gnice     %idle
Average:        all          4.25      0.00        21.61      0.00
0.00      0.00         6.61           0.00      0.00     67.54
Average:          0           0.00      0.00         0.00      0.00
0.00      0.00       100.00        0.00      0.00      0.00


Hope this clarifies. We need different fix to avoid lockups. Can we
consider using irq poll interface if #CPU is more than Reply queue/MSI-x.
?

>
> And the following script can do it easily, and the pci path (the 1st
column of
> lspci output) need to be passed, such as: 00:1c.4,
>
> #!/bin/sh
> if [ $# -ge 1 ]; then
>     PCID=$1
> else
>     PCID=`lspci | grep "Non-Volatile memory" | cut -c1-7` fi PCIP=`find
> /sys/devices -name *$PCID | grep pci` IRQS=`ls $PCIP/msi_irqs`
>
> echo "kernel version: "
> uname -a
>
> echo "PCI name is $PCID, dump its irq affinity:"
> for IRQ in $IRQS; do
>     CPUS=`cat /proc/irq/$IRQ/smp_affinity_list`
>     echo "\tirq $IRQ, cpu list $CPUS"
> done
>
>
> Thanks,
> Ming
