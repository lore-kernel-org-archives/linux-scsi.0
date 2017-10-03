From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: system hung up when offlining CPUs
Date: Tue, 3 Oct 2017 23:44:33 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1710032328280.2278@nanos>
References: <c55a33b4-a886-8882-dd8d-5c488f94ee06@gmail.com> <20170809124213.0d9518bb@why.wild-wind.fr.eu.org> <cd524af7-1f20-1956-1e44-92a451053387@gmail.com> <c1c7e0d6-d908-b511-8418-bca288a0d20a@arm.com> <20170821131809.GA17564@lst.de>
 <fce0ad52-8739-09c8-ec9d-a23eb92cec5a@arm.com> <8e0d76cd-7cd4-3a98-12ba-815f00d4d772@gmail.com> <2f2ae1bc-4093-d083-6a18-96b9aaa090c9@gmail.com> <b3e88f4d-8ca4-e265-5e09-437285cb18f5@suse.de> <8cb26204cb5402824496bbb6b636e0af@mail.gmail.com>
 <alpine.DEB.2.20.1709131529400.1874@nanos> <3ce6837a-9aba-0ff4-64b9-7ebca5afca13@gmail.com> <alpine.DEB.2.20.1709161212160.2105@nanos> <alpine.DEB.2.20.1709161630580.2105@nanos> <78ce7246-c567-3f5f-b168-9bcfc659d4bd@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:54951 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751117AbdJCVoz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2017 17:44:55 -0400
In-Reply-To: <78ce7246-c567-3f5f-b168-9bcfc659d4bd@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: YASUAKI ISHIMATSU <yasu.isimatu@gmail.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Hannes Reinecke <hare@suse.de>, Marc Zyngier <marc.zyngier@arm.com>, Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, mpe@ellerman.id.au, keith.busch@intel.com, peterz@infradead.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>

On Mon, 2 Oct 2017, YASUAKI ISHIMATSU wrote:
> On 09/16/2017 11:02 AM, Thomas Gleixner wrote:
> > Which driver are we talking about?
> 
> We are talking about megasas driver.

Can you please apply the debug patch below.

After booting enable stack traces for the tracer:

# echo 1 >/sys/kernel/debug/tracing/options/stacktrace

Then offline CPUs 24-29. After that do

# cat /sys/kernel/debug/tracing/trace >somefile

Please compress the file and upload it to some place or if you have no place
to upload it then send it to me in private mail.

Thanks,

	tglx

8<------------
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -171,11 +171,16 @@ void irq_set_thread_affinity(struct irq_
 int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
 			bool force)
 {
+	const struct cpumask *eff = irq_data_get_effective_affinity_mask(data);
 	struct irq_desc *desc = irq_data_to_desc(data);
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
 	int ret;
 
 	ret = chip->irq_set_affinity(data, mask, force);
+
+	trace_printk("irq: %u ret %d mask: %*pbl eff: %*pbl\n", data->irq, ret,
+		     cpumask_pr_args(mask), cpumask_pr_args(eff));
+
 	switch (ret) {
 	case IRQ_SET_MASK_OK:
 	case IRQ_SET_MASK_OK_DONE:
