From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v2 27/32] scsi: hisi_sas: add smp protocol support
Date: Mon, 2 Nov 2015 17:03:58 +0000
Message-ID: <5637977E.7000704@huawei.com>
References: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
 <1445868903-183817-28-git-send-email-john.garry@huawei.com>
 <3976707.At0tktvfqn@wuerfel> <5633995D.20607@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:2206 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbbKBREb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2015 12:04:31 -0500
In-Reply-To: <5633995D.20607@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, JBottomley@odin.com, john.garry2@mail.dcu.ie, linux-kernel@vger.kernel.org, linuxarm@huawei.com, robh+dt@kernel.org, hare@suse.de, galak@codeaurora.org, zhangfei.gao@linaro.org

On 30/10/2015 16:22, John Garry wrote:
> On 30/10/2015 13:53, Arnd Bergmann wrote:
>> On Monday 26 October 2015 22:14:58 John Garry wrote:
>>
>>> +       /*
>>> +       * DMA-map SMP request, response buffers
>>> +       */
>>> +       /* req */
>>> +       sg_req = &task->smp_task.smp_req;
>>> +       elem = dma_map_sg(dev, sg_req, 1, DMA_TO_DEVICE);
>>> +       if (!elem)
>>> +               return -ENOMEM;
>>> +       req_len = sg_dma_len(sg_req);
>>> +       req_dma_addr = sg_dma_address(sg_req);
>>
>> If you only use the first element, could you just use dma_map_single()?
>>
>
> Can do. Actually sg_req seems only ever has one element:
> expander.c, smp_execute_task()
> sg_init_one(&task->smp_task.smp_req, req, req_size);
>
>
I tried replacing with dma_map_single, but I feel the code is not as 
clean as I need to manually set sg_dma_len() and sg_dma_address():
     req_len = sg_dma_len(sg_req) = sg_req->length;
     sg_dma_address(sg_req) = dma_map_single(dev, sg_virt(sg_req),
  					 req_len, DMA_TO_DEVICE);
     if (dma_mapping_error(dev, sg_dma_address(sg_req)))
          return -ENOMEM;
sg_dma_address(sg_req) is used in another function for unmap.

opinion?
>
>
> _______________________________________________
> linuxarm mailing list
> linuxarm@huawei.com
> http://rnd-openeuler.huawei.com/mailman/listinfo/linuxarm
>
> .
>


cheers,
John

