From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH 09/22] [SCSI] mpt2sas, mpt3sas: Added a support to set cpu
 affinity for each MSIX vector enabled by the HBA
Date: Thu, 11 Dec 2014 17:21:33 +0530
Message-ID: <CAK=zhgq12Go0YXY+msuoeXeUoRJZQ=hKqChuoesaAzu-T=FjpA@mail.gmail.com>
References: <1418127401-10090-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<yq11to7dydu.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq11to7dydu.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash <Sathya.Prakash@avagotech.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@avagotech.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> @@ -1373,20 +1380,30 @@ _base_assign_reply_queues(struct MPT2SAS_ADAPTER *ioc)
>
>         cpu = cpumask_first(cpu_online_mask);
>
> -       do {
> +       list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
> +
>
> Why are you reverting to iterating over the queues? A while back I fixed
> this up so it wouldn't fail when nr_cpus > the number of reply queues.
>

I have kept yours CPUs affinity with reply queues logic as it is. This
patch doesn't break any of it's original CPUs affinity with reply
queues calculation  even when nr_cpus > the number of reply queues.
since below loop will help us to calculate CPU groups which needs to
affinity to particular reply queue when nr_cpus > the number of reply
queues

               for (i = 0 ; i < group ; i++) {
                        ioc->cpu_msix_table[cpu] = index;
+                       cpumask_or(reply_q->affinity_hint,
+                                  reply_q->affinity_hint, get_cpu_mask(cpu));
                        cpu = cpumask_next(cpu, cpu_online_mask);
                }

I am iterating over the queues to get the MSIX vector number easily,
while calling irq_set_affinity_hint() API for setting CPUs affinity
hint for that MSIX vector.

Regards,
Sreekanth
