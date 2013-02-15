From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v9 9/9] Avoid reenabling I/O after the transport became
 offline
Date: Fri, 15 Feb 2013 15:56:54 -0600
Message-ID: <511EAF26.9010804@cs.wisc.edu>
References: <511E23DD.2030309@acm.org> <511E25B9.3080301@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60213 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab3BOWAv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2013 17:00:51 -0500
In-Reply-To: <511E25B9.3080301@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>

On 02/15/2013 06:10 AM, Bart Van Assche wrote:
> Disallow the SDEV_TRANSPORT_OFFLINE to SDEV_CANCEL transition such
> that no I/O is sent to devices for which the transport is offline.
> Notes:
> - Functions like sd_shutdown() use scsi_execute_req() and hence
>   set the REQ_PREEMPT flag. Such requests are passed to the LLD
>   queuecommand callback in the SDEV_CANCEL state.
> - This patch does not affect Fibre Channel LLD drivers since these
>   drivers invoke fc_remote_port_chkready() before submitting a SCSI
>   request to the HBA. That prevents a timeout to occur in state
>   SDEV_CANCEL if the transport is offline.
> 

Thanks for fixing this. Looks right to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
