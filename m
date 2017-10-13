From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/8] lib: Introduce sgl_alloc() and sgl_free()
Date: Fri, 13 Oct 2017 08:20:57 -0600
Message-ID: <f8e331f3-d77c-0da2-208e-5d3f68d50565@kernel.dk>
References: <20171012224550.25440-1-bart.vanassche@wdc.com>
 <20171012224550.25440-2-bart.vanassche@wdc.com>
 <ee12eeaf-9848-478d-4ebe-9d3497e248e0@kernel.dk>
 <1507849209.14112.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1507849209.14112.1.camel@wdc.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On 10/12/2017 05:00 PM, Bart Van Assche wrote:
> On Thu, 2017-10-12 at 16:52 -0600, Jens Axboe wrote:
>> On 10/12/2017 04:45 PM, Bart Van Assche wrote:
>>> +++ b/include/linux/sgl_alloc.h
>>> @@ -0,0 +1,16 @@
>>> +#ifndef _SGL_ALLOC_H_
>>> +#define _SGL_ALLOC_H_
>>> +
>>> +#include <linux/types.h> /* bool, gfp_t */
>>> +
>>> +struct scatterlist;
>>> +
>>> +struct scatterlist *sgl_alloc_order(unsigned long long length,
>>> +				    unsigned int order, unsigned int *nent_p,
>>> +				    gfp_t gfp, bool chainable);
>>> +struct scatterlist *sgl_alloc(unsigned long long length, unsigned int *nent_p,
>>> +			      gfp_t gfp);
>>> +void sgl_free_order(struct scatterlist *sgl, int order);
>>> +void sgl_free(struct scatterlist *sgl);
>>> +
>>> +#endif /* _SGL_ALLOC_H_ */
>>
>> Should this just go into linux/scatterlist.h instead of creating a new header
>> file?
> 
> That's something I can change. I don't have a strong opinion about whether
> these declarations should go into a new header file or into linux/scatterlist.h.

I think you should make that change, keep things simpler. As Johannes
suggested, you could move the code to lib/scatterlist.c as well. I would
recommend keeping the kconfig option to only build it when needed, though.

-- 
Jens Axboe
