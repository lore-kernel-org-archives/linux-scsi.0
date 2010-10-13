From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] Check return value of fc_block_scsi_eh()
Date: Wed, 13 Oct 2010 15:37:57 -0500
Message-ID: <4CB618A5.8030108@cs.wisc.edu>
References: <20101013114228.96669354D8@ochil.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43037 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294Ab0JMUbY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2010 16:31:24 -0400
In-Reply-To: <20101013114228.96669354D8@ochil.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

On 10/13/2010 06:42 AM, Hannes Reinecke wrote:
>
> fc_block_scsi_eh() might return with status FAST_IO_FAIL
> indicating I/O has been terminated due to fast_io_fail timeout.
> In this case the rport is still blocked, so any error recovery
> will be failing on this port.
> Hence each driver needs to check if the return value from
> fc_block_scsi_eh() is something other than SUCCESS, in which
> case it should just return with that status.
> And we need to update the error handler to deal with a
> status of FAST_IO_FAIL, too.
> And fc_block_scsi_eh() should return SUCCESS on success,
> not 0. Otherwise the calling routine will become confused
> when reusing that value.
>

Is this patch supposed to fix the problem I described or is there more 
patches to follow or do you think I am being too paranoid? It seems the 
patch alone is going to make the problem worse in the drivers you are 
speeding up failure in. In the drivers now checking fc_block_scsi_eh and 
returning when fast io fail is returned then the scsi eh 
scsi_eh_flush_done_q's scsi_finish_command/scsi_queue_insert processing 
is going to get done faster and more likely to conflict with the 
termiante_rport_io callback processing, right?
