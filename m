From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFC/RFT 2/4] add scsi helpers
Date: Thu, 15 Sep 2005 12:55:18 -0500
Message-ID: <4329B586.6010802@cs.wisc.edu>
References: <1126736388.16778.25.camel@max> <20050915101303.GB24689@infradead.org> <4329AF9F.1030209@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:12743 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1030560AbVIORzU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 13:55:20 -0400
In-Reply-To: <4329AF9F.1030209@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

Mike Christie wrote:
>>
>>
>>> +int scsi_execute_async_iov_req(struct scsi_device *sdev,
>>> +                   const unsigned char *cmd, int data_direction,
>>> +                   struct kvec *vec, int vec_count, int timeout,
>>> +                   int retries, void *privdata,
>>> +                   void (*done)(void *, char *, int, int))
>>
>>
>>
>> If you passed an request_queue_t instead of th scsi_device this function
>> would not have any knowledge about scsi internals and could be moved up
>> to the block layer.  not sure that's actually a good idea.
> 
> 
> Did you want to move scsi_execute too?
> 

Actually after talking with Jens, I think it is better to keep the 
function in scsi_lib and move my blk_rq_map_iov() function there. The 
problem is that sg and st have some special needs and as a result do 
some things like partial setup themselves. It looks like nobody wants 
the burdon of having these special case fucntions :) but since SCSI's 
ULDs are the only user and probably will be the only user does it make 
sense to keep them there?
