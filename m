From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 3/3 version 4] scsi_lib: Collapse scsi_end_request into
 only user
Date: Tue, 05 Jan 2010 18:23:56 +0200
Message-ID: <4B43679C.9090009@panasas.com>
References: <Pine.LNX.4.44L0.1001051014200.3002-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:15056 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754791Ab0AEQYF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2010 11:24:05 -0500
In-Reply-To: <Pine.LNX.4.44L0.1001051014200.3002-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

On 01/05/2010 05:20 PM, Alan Stern wrote:
> On Tue, 5 Jan 2010, Boaz Harrosh wrote:
> 
>> Embedding scsi_end_request() into scsi_io_completion actually simplifies
>> the code and makes it clearer what's going on.
>>
>> There is absolutely no functional and/or side effects changes after this
>> patch.
> 
> Here are some suggestions for changes to the comments.  These are quite
> minor and you might not want to bother updating the patch yet again...
> 

Sure, NP. thanks for checking me out, coming from Hebrew I do need support
in these matters. Will update tomorrow.

Alan can I add your Review-by: this time around?

>> +	if (likely(0 == blk_end_request(req, error, good_bytes))) {
>> +		/* All is done and good move to next command */
> 
> 		/* The command completed successfully; move on to the next. */
> 
>> +		cmd->request = NULL;
>> +		action = ACTION_NEXT_CMND;
>> +	} else if (result == 0) {
>> +		/* Wrote some bytes but request was split */
> 
> 		/* The command was successful but not all the data was
> 		 * transferred; re-prep the command to handle the rest.
> 		 */
> 
>> +		action = ACTION_REPREP;
>> +	} else if (error && scsi_noretry_cmd(cmd)) {
>> +		/* kill remainder if no retries */
> 
> 		/* Error.  Kill the request since retries are disallowed. */
> 
>> +		blk_end_request_all(req, error);
>> +		cmd->request = NULL;
>> +		action = ACTION_NEXT_CMND;
>> +	} else if (host_byte(result) == DID_RESET) {
> 
> Alan Stern
> 

Thanks
Boaz
