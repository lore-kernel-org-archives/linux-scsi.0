From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] [SCSI] sd: fix crash when UA received on DIF enabled
 device
Date: Wed, 10 Jul 2013 15:52:09 -0400
Message-ID: <1373485929.7420.50.camel@localhost.localdomain>
References: <1351863514-12745-1-git-send-email-emilne@redhat.com>
	 <yq1liee4aaw.fsf@sermon.lab.mkp.net>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670Ab3GJTwL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jul 2013 15:52:11 -0400
In-Reply-To: <yq1liee4aaw.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <jbottomley@parallels.com>

On Tue, 2012-11-06 at 17:48 -0500, Martin K. Petersen wrote:
> >>>>> "Ewan" == Ewan D Milne <emilne@redhat.com> writes:
> 
> Ewan> sd_prep_fn will allocate a larger CDB for the command via
> Ewan> mempool_alloc for devices using DIF type 2 protection.  This CDB
> Ewan> was being freed in sd_done, which results in a kernel crash if the
> Ewan> command is retried due to a UNIT ATTENTION.  This change moves the
> Ewan> code to free the larger CDB into sd_unprep_fn instead, which is
> Ewan> invoked after the request is complete.
> 
> The 32-byte CDB support predates unprep. This fix is obviously the
> correct approach.
> 
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
> 

I don't see that this change ever made it in.  Can this go in for
the 3.12 merge window?

http://marc.info/?l=linux-scsi&m=135186352200668&w=2

-Ewan


