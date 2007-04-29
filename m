From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 4/4] bidi support: bidirectional request
Date: Sun, 29 Apr 2007 18:48:59 +0300
Message-ID: <4634BE6B.3000808@panasas.com>
References: <46225E18.7070404@panasas.com>	<462261E8.5090005@panasas.com> <200704281948.l3SJm9jS001428@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200704281948.l3SJm9jS001428@mbox.iij4u.or.jp>
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: jens.axboe@oracle.com, James.Bottomley@SteelEye.com, akpm@osdl.org, michaelc@cs.wisc.edu, hch@infradead.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, bhalevy@panasas.com
List-Id: linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> From: Boaz Harrosh <bharrosh@panasas.com>
> Subject: [PATCH 4/4] bidi support: bidirectional request
> Date: Sun, 15 Apr 2007 20:33:28 +0300
> 
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index 645d24b..16a02ee 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -322,6 +322,7 @@ struct request {
>>      void *end_io_data;
>>
>>      struct request_io_part uni;
>> +    struct request_io_part bidi_read;
>>  };
> 
> Would be more straightforward to have:
> 
> struct request_io_part in;
> struct request_io_part out;
> 

Yes I wish I could do that. For bidi supporting drivers this is the most logical.
But for the 99.9% of uni-directional drivers, calling rq_uni(), and being some what on
the hotish paths, this means we will need a pointer to a uni request_io_part.
This is bad because:
1st- There is no defined stage in a request life where to definitely set that pointer,
     specially in the preparation stages.
2nd- hacks like scsi_error.c/scsi_send_eh_cmnd() will not work at all. Now this is a
     very bad spot already, and I have a short term fix for it in the SCSI-bidi patches
     (not sent yet) but a more long term solution is needed. Once such hacks are
     cleaned up we can do what you say. This is exactly why I use the access functions
     rq_uni/rq_io/rq_in/rq_out and not open code access.

> 
>>  /*
>> @@ -600,6 +601,34 @@ static inline struct request_io_part* rq_uni(struct request* req)
>>      return &req->uni;
>>  }
>>
>> +static inline struct request_io_part* rq_out(struct request* req)
>> +{
>> +    WARN_ON_BIDI_FLAG(req);
>> +    return &req->uni;
>> +}
>> +
>> +static inline struct request_io_part* rq_in(struct request* req)
>> +{
>> +    WARN_ON_BIDI_FLAG(req);
>> +    if (likely(rq_dma_dir(req) != DMA_BIDIRECTIONAL))
>> +        return &req->uni;
>> +
>> +    if (likely(req->cmd_flags & REQ_BIDI))
>> +        return &req->bidi_read;
>> +
>> +    return &req->uni;
>> +}
>> +
>> +static inline struct request_io_part* rq_io(struct request* req,
>> +                                            enum dma_data_direction dir)
>> +{
>> +    if (dir == DMA_FROM_DEVICE)
>> +        return rq_in(req);
>> +
>> +    WARN_ON( (dir != DMA_TO_DEVICE) && (dir != DMA_NONE) );
>> +    return &req->uni;
>> +}
> 
> static inline struct request_io_part* rq_io(struct request* req)
> {
> 	return (req is WRITE) ? &req->out : &req->in;
> }

Again I'm all for it. But this is a to deep of a change. Too many things changing
at once. If we keep the access functions than it does not matter, we can do it later.

Boaz

