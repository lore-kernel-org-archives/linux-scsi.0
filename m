From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [LSF/MM TOPIC] KPTI effect on IO performance
Date: Thu, 1 Feb 2018 13:51:49 -0800
Message-ID: <7dc44387-a232-d610-2a18-b51b095ef9c4@wdc.com>
References: <20180131082331.GA25888@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:50012 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751826AbeBAVvz (ORCPT
        <rfc822;Linux-scsi@vger.kernel.org>); Thu, 1 Feb 2018 16:51:55 -0500
In-Reply-To: <20180131082331.GA25888@ming.t460p>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, lsf-pc@lists.linux-foundation.org, Linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org

On 01/31/18 00:23, Ming Lei wrote:
> After KPTI is merged, there is extra load introduced to context switch
> between user space and kernel space. It is observed on my laptop that one
> syscall takes extra ~0.15us[1] compared with 'nopti'.
> 
> IO performance is affected too, it is observed that IOPS drops by 32% in
> my test[2] on null_blk compared with 'nopti':
> 
> randread IOPS on latest linus tree:
> -------------------------------------------------
> | randread IOPS     | randread IOPS with 'nopti'|	
> ------------------------------------------------
> | 928K              | 1372K                     |	
> ------------------------------------------------
> 
> 
> Two paths are affected, one is IO submission(read, write,... syscall),
> another is the IO completion path in which interrupt may be triggered
> from user space, and context switch is needed.
> 
> So is there something we can do for decreasing the effect on IO performance?
> 
> This effect may make Hannes's issue[3] worse, and maybe 'irq poll' should be
> used more widely for all high performance IO device, even some optimization
> should be considered for KPTI's effect.

For what kind of workload would you like to improve I/O performance? 
Desktop-style workloads where the only third party code is the code that 
runs in the webbrowser and in the e-mail client or datacenter workloads 
where code from multiple customers runs on the same server? I'm asking 
this because the per-task KPTI work seems very useful to me for 
improving I/O performance for desktop-style workloads. I'm not sure 
however whether that work will be as useful for datacenter workloads. 
See also Willy Tarreau, [PATCH RFC 0/4] Per-task PTI activation 
(https://lkml.org/lkml/2018/1/8/568).

Bart.
