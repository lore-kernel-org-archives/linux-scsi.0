From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: dangling pointers and/or reentrancy in scmd_eh_abort_handler?
Date: Tue, 20 May 2014 10:46:51 +0200
Message-ID: <537B167B.801@acm.org>
References: <537A105B.4080504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:37396 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaETIqx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 May 2014 04:46:53 -0400
In-Reply-To: <537A105B.4080504@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Ulrich Obergfell <uobergfe@redhat.com>

On 05/19/14 16:08, Paolo Bonzini wrote:
> 1) dangling pointers: scsi_put_command calls cancel_delayed_work(), but
> that doesn't mean that the scmd_eh_abort_handler couldn't be already
> running.  If the scmd_eh_abort_handler starts while the softirq handler
> is calling scsi_put_command (e.g. scsi_finish_command ->
> scsi_io_completion -> scsi_end_request -> scsi_next_command), the
> pointer to the Scsi_Cmnd* becomes invalid in the middle of the abort
> handler.

Hannes, can you clarify why a cancel_delayed_work() statement was added
in scsi_put_command() ? How can scsi_put_command() get invoked after the
SCSI timeout handler queued &scmd->abort_work and before the function
associated with that work struct (scmd_eh_abort_handler()) is called ?

Thanks,

Bart.
