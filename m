From: Nish Aravamudan <nish.aravamudan@gmail.com>
Subject: Re: [PATCH 2.6.13 5/14] sas-class: sas_discover.c Discover process (end devices)
Date: Fri, 9 Sep 2005 12:59:08 -0700
Message-ID: <29495f1d05090912591d55be5f@mail.gmail.com>
References: <4321E51F.8040906@adaptec.com>
Reply-To: nish.aravamudan@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.192]:50509 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1030406AbVIIT7M convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Sep 2005 15:59:12 -0400
Received: by zproxy.gmail.com with SMTP id r28so1418410nza
        for <linux-scsi@vger.kernel.org>; Fri, 09 Sep 2005 12:59:08 -0700 (PDT)
In-Reply-To: <4321E51F.8040906@adaptec.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 9/9/05, Luben Tuikov <luben_tuikov@adaptec.com> wrote:
> Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>

<snip>


+static int sas_execute_task(struct sas_task *task, void *buffer, int size,
+                           int pci_dma_dir)

<snip>

+                       set_current_state(TASK_INTERRUPTIBLE);
+                       schedule_timeout(HZ);

<snip>

+                               set_current_state(TASK_INTERRUPTIBLE);
+                               schedule_timeout(5*HZ);

Can you use msleep_interruptible() here? I don't see wait-queues in
the immediate vicinity. If not, and you're going for the normal -mm
route (and from there to mainline), can you use
schedule_timeout_interruptible(), please?

Thanks,
Nish
