From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [LSF/MM TOPIC] irq affinity handling for high CPU count machines
Date: Fri, 2 Feb 2018 14:19:01 +0530
Message-ID: <6754a4c3ed7e1f1ea5473bd97625aa51@mail.gmail.com>
References: <45dc032d-a0ce-816c-d2c5-74c69433bd29@suse.de> <20180201150532.GA31930@ming.t460p>
 <0f650f4b-aa7f-bf52-2ecb-582761b4937f@suse.de> <a6bf37e1aa2c45ef725c4cc1a7f57af9@mail.gmail.com>
 <20180202020235.GE19173@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:35801 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750871AbeBBItE (ORCPT
        <rfc822;Linux-scsi@vger.kernel.org>); Fri, 2 Feb 2018 03:49:04 -0500
Received: by mail-io0-f172.google.com with SMTP id m11so22205854iob.2
        for <Linux-scsi@vger.kernel.org>; Fri, 02 Feb 2018 00:49:03 -0800 (PST)
In-Reply-To: <20180202020235.GE19173@ming.t460p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, lsf-pc@lists.linux-foundation.org, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, linux-nvme@lists.infradead.org

> > > > Today I am looking at one megaraid_sas related issue, and found
> > > > pci_alloc_irq_vectors(PCI_IRQ_AFFINITY) is used in the driver, so
> > > > looks each reply queue has been handled by more than one CPU if
> > > > there are more CPUs than MSIx vectors in the system, which is done
> > > > by generic irq affinity code, please see kernel/irq/affinity.c.
> >
> > Yes. That is a problematic area. If CPU and MSI-x(reply queue) is 1:1
> > mapped, we don't have any issue.
>
> I guess the problematic area is similar with the following link:
>
> 	https://marc.info/?l=linux-kernel&m=151748144730409&w=2

Hi Ming,

Above mentioned link is different discussion and looks like a generic
issue. megaraid_sas/mpt3sas will have same symptoms if irq affinity has
only offline CPUs.
Just for info - "In such condition, we can ask users to disable affinity
hit via module parameter " smp_affinity_enable".

>
> otherwise could you explain a bit about the area?

Please check below post for more details.

https://marc.info/?l=linux-scsi&m=151601833418346&w=2
