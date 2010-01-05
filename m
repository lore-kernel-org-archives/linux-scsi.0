From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 3/3 version 2] scsi_lib: Collapse scsi_end_request into
 only user
Date: Tue, 05 Jan 2010 09:27:46 +0200
Message-ID: <4B42E9F2.2050109@panasas.com>
References: <Pine.LNX.4.44L0.1001041315230.3180-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:57818 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750781Ab0AEH1t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2010 02:27:49 -0500
In-Reply-To: <Pine.LNX.4.44L0.1001041315230.3180-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>

On 01/04/2010 08:23 PM, Alan Stern wrote:
> On Mon, 4 Jan 2010, Boaz Harrosh wrote:
> 
>> Embedding scsi_end_request() into scsi_io_completion actually simplifies the
>> code and makes it clearer what's going on.
>>
>> There is absolutely no functional and/or side effects changes after this patch.
>>
>> Patch was inspired by Alan Stern. (version 2 comments by Matthew Wilcox)
> 
>> -	/*
>> -	 * A number of bytes were successfully read.  If there
>> -	 * are leftovers and there is some kind of error
>> -	 * (result != 0), retry the rest.
>> -	 */
>> -	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
>> -		return;
>> -
>> -	error = -EIO;
>> -
>> -	if (host_byte(result) == DID_RESET) {
>> +	if (likely(!blk_end_request(req, error, good_bytes))) {
>> +		cmd->request = NULL;
>> +		action = ACTION_NEXT_CMND;
>> +	} else if (error && scsi_noretry_cmd(cmd)) {
>> +		/* kill remainder if no retrys */
>> +		blk_end_request_all(req, error);
>> +		cmd->request = NULL;
>> +		action = ACTION_NEXT_CMND;
>> +	} else if (result == 0) {
>> +		action = ACTION_REPREP;
>> +	} else if (host_byte(result) == DID_RESET) {
> 
> A few comments in these new "if" cases would help readers to understand
> the logic here.
> 
> My personal preference is to reverse the order of the "if (error && 
> scsi_noretry_cmd(cmd))" and the "if (result == 0)" sections.  It would 
> make more sense; that way we'd have:
> 
> 	If the request is finished [blk_end_request() == 0]
> 		...
> 	else if the request was successful but has more work to do
> 			(result == 0)
> 		...
> 	else if there was an error and retries are disallowed
> 		...
> 	else ... [other error handling]
> 
> Interchanging the order wouldn't make any functional difference, 
> because the code above this point guarantees that we can never have 
> result == 0 and error != 0.
> 
> Apart from these small issues, it looks perfect.
> 
> Alan Stern
> 

Thanks Alan.

I agree with your comments and will send a new version.

Boaz
