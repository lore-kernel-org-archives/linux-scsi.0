From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [LSF/MM TOPIC] multiqueue and interrupt assignment
Date: Wed, 3 Feb 2016 14:57:53 +0200
Message-ID: <56B1F951.5010001@dev.mellanox.co.il>
References: <56B0D9CF.1080001@suse.de> <56B0F41B.8010706@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36393 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461AbcBCM55 (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Wed, 3 Feb 2016 07:57:57 -0500
Received: by mail-wm0-f42.google.com with SMTP id p63so163859674wmp.1
        for <Linux-scsi@vger.kernel.org>; Wed, 03 Feb 2016 04:57:56 -0800 (PST)
In-Reply-To: <56B0F41B.8010706@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>

Hi Bart and Hannes,

> This topic indeed needs further attention. I also encountered this
> challenge while adding scsi-mq support to the SRP initiator driver. What
> I learned while working on the SRP driver is the following:
> - Although I agree that requests and interrupts should be processed on
>    the same processor (same physical chip) if the request has been
>    submitted from the CPU closest to the HBA, I'm not convinced that
>    processing request completions and interrupts on the same CPU core
>    yields the best performance. I would appreciate it if there would
>    remain some freedom in how to assign interrupts to CPU cores.

This is true not only for this reason. Some block storage transports
(e.g. srp/iser) share the HBA with the networking stack and possibly
with user-space workloads in the case of RDMA. This is why I don't see
how would MSIX assignments can be done anywhere other than user-space.

However what I think we can do is have blk-mq ask the drivers
information about the MSIX mappings. This concept was introduced in
2011 by Ben Hutchings with the CPU affinity reverse-mapping API [1].

Perhaps we'd want to have drivers provide blk-mq a struct cpu_rmap when
assigning the hctx mappings, or possibly per I/O if we want to be
agnostic to MSIX topology changes. I think this approach would solve
Hannes is experiencing.

Thoughts?

[1]:
commit c39649c331c70952700f99832b03f87e9d7f5b4b
Author: Ben Hutchings <bhutchings@solarflare.com>
Date:   Wed Jan 19 11:03:25 2011 +0000

     lib: cpu_rmap: CPU affinity reverse-mapping

     When initiating I/O on a multiqueue and multi-IRQ device, we may want
     to select a queue for which the response will be handled on the same
     or a nearby CPU.  This requires a reverse-map of IRQ affinity.  Add
     library functions to support a generic reverse-mapping from CPUs to
     objects with affinity and the specific case where the objects are
     IRQs.

     Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
     Signed-off-by: David S. Miller <davem@davemloft.net>
