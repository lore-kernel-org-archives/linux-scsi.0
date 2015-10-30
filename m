From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 27/32] scsi: hisi_sas: add smp protocol support
Date: Fri, 30 Oct 2015 16:22:53 +0000
Message-ID: <5633995D.20607@huawei.com>
References: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
 <1445868903-183817-28-git-send-email-john.garry@huawei.com>
 <3976707.At0tktvfqn@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3976707.At0tktvfqn@wuerfel>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: JBottomley-wo1vFcy6AUs@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 30/10/2015 13:53, Arnd Bergmann wrote:
> On Monday 26 October 2015 22:14:58 John Garry wrote:
>
>> +       /*
>> +       * DMA-map SMP request, response buffers
>> +       */
>> +       /* req */
>> +       sg_req = &task->smp_task.smp_req;
>> +       elem = dma_map_sg(dev, sg_req, 1, DMA_TO_DEVICE);
>> +       if (!elem)
>> +               return -ENOMEM;
>> +       req_len = sg_dma_len(sg_req);
>> +       req_dma_addr = sg_dma_address(sg_req);
>
> If you only use the first element, could you just use dma_map_single()?
>

Can do. Actually sg_req seems only ever has one element:
expander.c, smp_execute_task()
sg_init_one(&task->smp_task.smp_req, req, req_size);

>> +       hdr->cmd_table_addr_lo = cpu_to_le32(lower_32_bits(req_dma_addr));
>> +       hdr->cmd_table_addr_hi = cpu_to_le32(upper_32_bits(req_dma_addr));
>> +
>> +       hdr->sts_buffer_addr_lo =
>> +                       cpu_to_le32(lower_32_bits(slot->status_buffer_dma));
>> +       hdr->sts_buffer_addr_hi =
>> +                       cpu_to_le32(upper_32_bits(slot->status_buffer_dma));
>> +
>>
>
> I see these a lot in your code. Could you replace this wit
>
> 	hdr->cmd_table_addr = cpu_to_le64(req_dma_addr);
>
This seems reasonable. They are not swapped.

> and so on? That would be much more readable. Or are the two __le32 variables
> swapped? If so, you could add a small helper function like
>
> static inline __le64 cpu_to_le64_wordswapped(u64 val)
> {
> 	return cpu_to_le64(val >> 32 | val << 32);
> }
>
> 	Arnd
>
> .
>

cheers


--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
