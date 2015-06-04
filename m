From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [RFC 0/2] target: Add TFO->complete_irq queue_work bypass
Date: Thu, 04 Jun 2015 20:01:09 +0300
Message-ID: <55708455.2080500@dev.mellanox.co.il>
References: <1432281446-31080-1-git-send-email-nab@daterainc.com>	 <20150603125756.GA19696@lst.de> <1433401569.18125.112.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:32837 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbbFDRAs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jun 2015 13:00:48 -0400
Received: by wgez8 with SMTP id z8so38465046wge.0
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2015 10:00:47 -0700 (PDT)
In-Reply-To: <1433401569.18125.112.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>

On 6/4/2015 10:06 AM, Nicholas A. Bellinger wrote:
> On Wed, 2015-06-03 at 14:57 +0200, Christoph Hellwig wrote:
>> This makes lockdep very unhappy, rightly so.  If you execute
>> one end_io function inside another you bas=D1=96cally nest every pos=
sible
>> lock taken in the I/O completion path.  Also adding more work
>> to the hardirq path generally isn't a smart idea.  Can you explain
>> what issues you were seeing and how much this helps?  Note that
>> the workqueue usage in the target core so far is fairly basic, so
>> there should some low hanging fruit.
>
> So I've been using tcm_loop + RAMDISK backends for prototyping, but t=
his
> patch is intended for vhost-scsi so it can avoid the unnecessary
> queue_work() context switch within target_complete_cmd() for all back=
end
> driver types.
>
> This is because vhost_work_queue() is just updating vhost_dev->work_l=
ist
> and immediately wake_up_process() into a different vhost_worker()
> process context.  For heavy small block workloads into fast IBLOCK
> backends, avoiding this extra context switch should be a nice efficie=
ncy
> win.

I can see that, did you get a chance to measure the expected latency
improvement?

>
> Also, AFAIK RDMA fabrics are allowed to do ib_post_send() response
> callbacks directly from IRQ context as well.

This is correct in general, ib_post_send is not allowed to schedule.
isert/srpt might benefit here in latency, but it would require the
the drivers to pre-allocate the sgls (ib_sge's) and use a worst-case
approach (or use GFP_ATOMIC allocations - I'm not sure which is
better...)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
