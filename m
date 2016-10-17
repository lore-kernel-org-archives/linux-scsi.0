From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 1/2] scsi: Handle Unit Attention when issuing SCSI
 command
Date: Mon, 17 Oct 2016 12:30:11 -0500
Message-ID: <67d2712c-eee7-a8e8-94d3-84488beb8598@linux.vnet.ibm.com>
References: <1476384477-3060-1-git-send-email-krisman@linux.vnet.ibm.com>
 <1476422360.22309.29.camel@linux.vnet.ibm.com>
 <87y41nhrv1.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52051 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933945AbcJQRaQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Oct 2016 13:30:16 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9HHT13G043729
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2016 13:30:15 -0400
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2651vw39wx-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2016 13:30:15 -0400
Received: from localhost
        by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Mon, 17 Oct 2016 11:30:14 -0600
In-Reply-To: <87y41nhrv1.fsf@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

On 10/17/2016 11:17 AM, Gabriel Krisman Bertazi wrote:
> James Bottomley <jejb@linux.vnet.ibm.com> writes:
> 
>> On Thu, 2016-10-13 at 15:47 -0300, Gabriel Krisman Bertazi wrote:
>>> @@ -210,6 +219,13 @@ int scsi_execute(struct scsi_device *sdev, const
>>> unsigned char *cmd,
>>>  	 */
>>>  	blk_execute_rq(req->q, NULL, req, 1);
>>>  
>>> +	if (scsi_sense_unit_attention(sense) && req->retries > 0) {
>>> +		memset(sense, 0, SCSI_SENSE_BUFFERSIZE);
>>> +		retries = req->retries - 1;
>>> +		blk_put_request(req);
>>> +		goto retry;
>>> +	}
>>
>> OK, so this is more theory, but I think you can actually reuse the same
>> request to go around this loop without doing a get/put.  I've cc'd Jens
>> to confirm, since no other driver I can find does this, but if it's
>> legal, it saves freeing and reallocating the request.  You can then
>> replace the goto with a do { } while (...) which makes the loop obvious
>> to the next person looking at this.
> 
> Hi James,
> 
> I don't think the block layer currently has the machinery to reuse the
> request.  I think it would be easy to add for the MQ case but I
> don't know about SQ.  If we don't clean up or reinit the request before
> re-sending, we'll hit the BUG_ON in blk_start_request:
> 
>   BUG_ON(test_bit(REQ_ATOM_COMPLETE, &req->atomic_flags));
> 
> Do you wanna take a v3 of the patch and fix this on a future patch, or
> should I be looking into patching the block layer interface?  I'll be
> looking into it, but I need to get familiar with the SQ code first.

Would it make more sense to try to stick this retry logic in scsi_error.c
in check_sense? Or do we not have enough information there to decide whether
or not to retry 06/29?

-Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

