From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] fix retries and command completion when using REQ_BLOCK_PC
Date: Sun, 18 Sep 2005 14:58:43 -0500
Message-ID: <432DC6F3.80801@cs.wisc.edu>
References: <1127063944.1421.16.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:6867 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932220AbVIRV6t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Sep 2005 17:58:49 -0400
In-Reply-To: <1127063944.1421.16.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: linux-scsi@vger.kernel.org

Mike Christie wrote:
> Hi Jens and James,
> 
> As you know a side effect of SCSI using REQ_BLOCK_PC is that commands
> that used to originate from SCSI do not obey the retries value, and we
> now add extra processing of failures in scsi_io_completion.
> 
> The patch below adds a retry count on the request which is used like the
> timeout value. And it changes scsi_generic_done to always complete the
> entire command which emulates the old behavior we had with
> scsi_wait_req/scsi_do_req where scsi_io_completeion does not process the
> error and request additional retries.
> 

Oh yeah this is also what sd does with REQ_BLOCK_PC commands and with my 
other patch for st in this mail 
http://marc.theaimsgroup.com/?l=linux-scsi&m=112708046601499&w=2 it is 
what tape will do.
