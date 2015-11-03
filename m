From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 27/32] scsi: hisi_sas: add smp protocol support
Date: Tue, 3 Nov 2015 11:42:30 +0000
Message-ID: <56389DA6.6070103@huawei.com>
References: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
 <5633995D.20607@huawei.com> <5637977E.7000704@huawei.com>
 <4452058.YIXj3BxT1F@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4452058.YIXj3BxT1F@wuerfel>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, JBottomley-wo1vFcy6AUs@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 02/11/2015 20:29, Arnd Bergmann wrote:
> On Monday 02 November 2015 17:03:58 John Garry wrote:
>>>
>>> Can do. Actually sg_req seems only ever has one element:
>>> expander.c, smp_execute_task()
>>> sg_init_one(&task->smp_task.smp_req, req, req_size);
>>>
>>>
>> I tried replacing with dma_map_single, but I feel the code is not as
>> clean as I need to manually set sg_dma_len() and sg_dma_address():
>>       req_len = sg_dma_len(sg_req) = sg_req->length;
>>       sg_dma_address(sg_req) = dma_map_single(dev, sg_virt(sg_req),
>>                                           req_len, DMA_TO_DEVICE);
>>       if (dma_mapping_error(dev, sg_dma_address(sg_req)))
>>            return -ENOMEM;
>> sg_dma_address(sg_req) is used in another function for unmap.
>>
>> opinion?
>>
>
> What I meant was not using a struct scatterlist at all:
> replace the 'sg_req' variable with a normal pointer, and then
> do
>
> 	hdr->cmd_table_addr = cpu_to_le64(dma_map_single(dev, req, len, DMA_TO_DEVICE));
>
> Any reason this won't work?
>
> 	Arnd
>
> .
>
There seems to be some misunderstanding. Are you suggesting I change 
sas_smp_task?
./include/scsi/libsas.h
struct sas_smp_task {
	struct scatterlist smp_req;
	struct scatterlist smp_resp;
};

thanks,
John

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
