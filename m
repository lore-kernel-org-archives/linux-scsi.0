From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] Eliminate error handler overload of the SCSI serial number
Date: Thu, 18 Nov 2010 13:40:05 -0600
Message-ID: <4CE58115.7040100@cs.wisc.edu>
References: <1290010257.4736.50.camel@mulgrave.site> <4CE58032.8040304@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43968 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755912Ab0KRTc0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2010 14:32:26 -0500
In-Reply-To: <4CE58032.8040304@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Mike Anderson <andmike@linux.vnet.ibm.com>

On 11/18/2010 01:36 PM, Mike Christie wrote:
> On 11/17/2010 10:10 AM, James Bottomley wrote:
>> -static int scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
>> -{
>> - /*
>> - * scsi_done was called just after the command timed out and before
>> - * we had a chance to process it. (db)
>> - */
>> - if (scmd->serial_number == 0)
>> - return SUCCESS;
>> - return __scsi_try_to_abort_cmd(scmd);
>> -}
>
> Does it matter that with this patch we now call the driver's abort
> handler when the command has been added to the eh list when going
> through scsi_softirq_done-> scsi_decide_disposition returns FAILED ->
> scsi_eh_scmd_add?
>

Ignore this. I see scsi_eh_scmd_add passes the 0 flag, so the abort 
handler is not called.
