From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/8] scsi: Drop struct Scsi_Host->host_lock around
 SHT->queuecommand()
Date: Thu, 16 Sep 2010 22:46:11 -0400
Message-ID: <1284691571.26423.50.camel@mulgrave.site>
References: <1284676529-10756-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39527 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833Ab0IQCqZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2010 22:46:25 -0400
In-Reply-To: <1284676529-10756-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Mike Christie <michaelc@cs.wisc.edu>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>

On Thu, 2010-09-16 at 15:35 -0700, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch converts scsi_dispatch_cmd() to only hold struct Scsi_Host->host_lock
> for scsi_cmd_get_serial(), and drops the lock because the call into
> the LLD with host->hostt->queuecommand().
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/scsi/scsi.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index ad0ed21..06e5b3a 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -745,6 +745,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>  	 * TODO: kill serial or move to blk layer
>  	 */
>  	scsi_cmd_get_serial(host, cmd); 
> +	spin_unlock_irqrestore(host->host_lock, flags);

So at least from where I stand, my object is to reduce the number of
times we take and release the lock, which this doesn't do.  As I said
before: we need to figure out the rest, which likely includes an atomic
for the serial number (which is almost unused).  I think the check
against SHOST_DEL is fine unlocked.

James


