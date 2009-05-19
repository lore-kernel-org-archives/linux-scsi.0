From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] [SQUASHME] "FC Pass Thru support" fixed for block/for-2.6.31
 tree
Date: Tue, 19 May 2009 13:14:38 +0300
Message-ID: <4A12868E.6030108@panasas.com>
References: <4A12797B.2060901@panasas.com> <4A128484.4000708@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:30004 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752354AbZESKOo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2009 06:14:44 -0400
In-Reply-To: <4A128484.4000708@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, James Smart <James.Smart@Emulex.Com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <tomof@acm.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>

On 05/19/2009 01:05 PM, Tejun Heo wrote:
> Hello, Boaz.
> 
> Just two minor things.
> 
> Boaz Harrosh wrote:
>>  	/* we assume all request payload was transferred, residual == 0 */
>> -	req->data_len = 0;
>> +	req->resid_len = 0;
>>  
>>  	if (rsp) {
>> -		rsp_len = blk_rq_bytes(rsp);
>> -		BUG_ON(job->reply->reply_payload_rcv_len > rsp_len);
> 
> Maybe convert it to WARN_ON() instead of removing?

Sorry, You are absolutely correct should add it back. (With a WARN_ON)

> 
>>  		/* set reply (bidi) residual */
>> -		rsp->data_len = (rsp_len - job->reply->reply_payload_rcv_len);
>> +		rsp->resid_len = blk_rq_bytes(rsp) -
>> +					job->reply->reply_payload_rcv_len;
> 
> With the fix-fallouts patchset it, this can be
> 
> 	rsp->resid_len -= job->reply->reply_payload_rcv_len;
> 

Sure.

> Other than above misc points,
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 

Will repost as reply to Original patch, thanks
Boaz
