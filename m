From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFC/RFT 2/4] add scsi helpers
Date: Thu, 15 Sep 2005 12:30:07 -0500
Message-ID: <4329AF9F.1030209@cs.wisc.edu>
References: <1126736388.16778.25.camel@max> <20050915101303.GB24689@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:65222 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1030537AbVIORaK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 13:30:10 -0400
In-Reply-To: <20050915101303.GB24689@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
>>+struct __scsi_request {
>>+	void *data;
>>+	void (*done)(void *data, char *sense, int result, int resid);
>>+	char sense[SCSI_SENSE_BUFFERSIZE];
>>+};
> 
> 
> I don't think this is a good structure name.  Just something like
> iocontext  or similar?

ok.

> 
> 
>>+int scsi_execute_async_iov_req(struct scsi_device *sdev,
>>+			       const unsigned char *cmd, int data_direction,
>>+			       struct kvec *vec, int vec_count, int timeout,
>>+			       int retries, void *privdata,
>>+			       void (*done)(void *, char *, int, int))
> 
> 
> If you passed an request_queue_t instead of th scsi_device this function
> would not have any knowledge about scsi internals and could be moved up
> to the block layer.  not sure that's actually a good idea.

Did you want to move scsi_execute too?


> 
> If we stick to putting it into the scsi layer the done callback could
> normalize the sense data, though.
> 
> 
>>+	struct request *req;
>>+	struct __scsi_request *sreq;
>>+	int write = (data_direction == DMA_TO_DEVICE);
> 
> 
> What about just passing in a write parameter directly?

I thought most users would just have the DMA_* value so it would be 
nicer for them to pass that down. It also then works like 
scsi_execute_req/scsi_execute. I guess if we move one of those functions 
to the block layer it would be better to pass in write/read for the 
block layer versions.


> 
> 
>>+
>>+	sreq = kzalloc(sizeof(*sreq), GFP_ATOMIC);
>>+	if (!sreq) {
>>+		return DRIVER_ERROR << 24;
>>+	}
>>+
>>+	req = blk_get_request(sdev->request_queue, write, GFP_ATOMIC);
> 
> 
> can you add a gfp_mask argument instead of hardcoding GFP_ATOMIC?
> 

yeah will do. I think I got lazy :)
