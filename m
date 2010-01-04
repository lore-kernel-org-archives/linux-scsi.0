From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 3/3] scsi_lib: Collapse scsi_end_request into only user
Date: Mon, 04 Jan 2010 15:56:32 +0200
Message-ID: <4B41F390.9060108@panasas.com>
References: <4B41DADD.4000102@panasas.com> <4B41DC42.1090706@panasas.com> <20100104132338.GA9882@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:42417 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750738Ab0ADN4g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2010 08:56:36 -0500
In-Reply-To: <20100104132338.GA9882@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

On 01/04/2010 03:23 PM, Matthew Wilcox wrote:
> On Mon, Jan 04, 2010 at 02:17:06PM +0200, Boaz Harrosh wrote:
>> Embedding scsi_end_request() into scsi_io_completion actually simplifies the
>> code and makes it clearer what's going on.
> 
> I'm not entirely convinced about that -- scsi_io_completion is currently
> over 200 lines long and needs to be made shorter, not longer.  That said,
> I see no reason that the current factoring of scsi_io_completion() makes
> sense; pushing the decoding of the sense key into a separate function
> looks like a more profitable idea.  It would also let you do without
> the nasty gotos you add in this patch.
> 

I agree, but I want that Alan's retries handling, Hannes's sense for FS_COMMANDS
and mainly the question about good_bytes!=0 and retries are answered first.
Then we can see what the code is really like and make a clean cut.

I'll attempt a second version without the goto.

>> There is absolutely no functional and/or side effects changes after this patch.
>>
>> Patch was inspired by Alan Stern.
>>
>> CC: Alan Stern <stern@rowland.harvard.edu>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
<snip>

Boaz
