From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [patch 1/2] scsi: Allow FC LLD to fast-fail scsi eh
Date: Thu, 25 Mar 2010 14:36:39 -0500
Message-ID: <4BABBB47.50203@cs.wisc.edu>
References: <20100324155029.241441000@de.ibm.com> <20100324155827.168989000@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54420 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754424Ab0CYThK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Mar 2010 15:37:10 -0400
In-Reply-To: <20100324155827.168989000@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

On 03/24/2010 10:50 AM, Christof Schmitt wrote:
> From: Christof Schmitt<christof.schmitt@de.ibm.com>
>
> If the scsi eh is running and then a FC LLD calls
> fc_remote_port_delete, the SCSI commands sent from the eh will fail.
> To prevent this, a FC LLD can call fc_block_scsi_eh from the eh
> callback, blocking the eh thread until the dev_loss_tmo fires or the
> remote port is available again.
>
> If (e.g. for a multipathing setup) the dev_loss_tmo is set to a very
> large value, thus preventing the scsi device removal , the scsi eh can
> block for a long time. For multipathing, the fast_io_fail_tmo is then
> set to a low value to detect path problems sooner.
>
> This patch introduces a new return code FAST_IO_FAIL. The function
> fc_block_scsi_eh now returns FAST_IO_FAIL when the fast_io_fail_tmo
> fires. This indicates that the LLD terminated all pending I/O requests
> and there are no more pending SCSI commands for the scsi eh to wait
> for. This return code can be passed back to the scsi eh to stop the
> escalation and finish the recovery process for this device.
>

Patch seems ok to me. It fixes the bug I was trying to fix with my other 
patch but I think your patch is nicer with the new error code to use.
