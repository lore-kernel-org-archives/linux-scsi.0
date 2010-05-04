From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] Retry commands with UNIT_ATTENTION sense codes
Date: Tue, 04 May 2010 15:27:12 -0500
Message-ID: <4BE08320.40206@cs.wisc.edu>
References: <20100504144853.D94C72A205@ochil.suse.de> <1272990403.5255.27.camel@mulgrave.site> <4BE0804D.1030406@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42862 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933814Ab0EDU03 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 16:26:29 -0400
In-Reply-To: <4BE0804D.1030406@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On 05/04/2010 03:15 PM, Mike Christie wrote:
> On 05/04/2010 11:26 AM, James Bottomley wrote:
>> The other patch is fine, but I don't think this is necessary. The
>> reason is that even returning SUCCESS here, we go straight into
>> scsi_finish_command() (which passes it up to the driver handler) and
>> then scsi_io_completion(). There's a catch for UNIT_ATTENTION in
>> scsi_io_completion
>
> The request is sent as a REQ_TYPE_BLOCK_PC (this flag is set for the
> request in sd_prepare_flush), and scsi_io_completion's blk_pc_request
> check() that returns the request upwards is before the UNIT_ATTENTION

I was looking at the wrong source.

scsi_finish_command checks for REQ_TYPE_BLOCK_PC and sets good_bytes to 
scsi_bufflen, so when scsi_io_completion calls scsi_end_request, it 
fails the request before we can get to the UNIT_ATTENTION.




> check one so we never hit the UNIT_ATTENTION check.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

