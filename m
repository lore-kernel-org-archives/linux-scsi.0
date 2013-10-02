From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv6 0/3] New EH command timeout handler
Date: Wed, 2 Oct 2013 00:25:43 -0700
Message-ID: <20131002072543.GA24881@infradead.org>
References: <1378123118-111972-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42362 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab3JBHZy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Oct 2013 03:25:54 -0400
Content-Disposition: inline
In-Reply-To: <1378123118-111972-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@purestorage.com>

James, and comments on this?

It would be really good if we could make some progress getting various
infrastructure merged.

On Mon, Sep 02, 2013 at 01:58:35PM +0200, Hannes Reinecke wrote:
> Hi all,
> 
> this patchset implements a new SCSI EH command timeout handler
> which will be sending command aborts inline without actually
> engaging SCSI EH.
> SCSI EH will only be invoked if command abort fails.
> 
> In addition the commands will be returned directly
> if the command abort succeeded, cutting down recovery
> times dramatically.
> 
> With the original SCSI EH I got:
> # time dd if=/dev/zero of=/dev/dm-2 bs=4k count=4k oflag=direct
> 4096+0 records in
> 4096+0 records out
> 16777216 bytes (17 MB) copied, 142.652 s, 118 kB/s
> 
> real	2m22.657s
> user	0m0.013s
> sys	0m0.145s
> 
> With this patchset I got:
> # time dd if=/dev/zero of=/dev/dm-2 bs=4k count=4k oflag=direct
> 4096+0 records in
> 4096+0 records out
> 16777216 bytes (17 MB) copied, 52.1579 s, 322 kB/s
> 
> real	0m52.163s
> user	0m0.012s
> sys	0m0.145s
> 
> Test was to disable RSCN on the target port, disable the
> target port, and then start the 'dd' command as indicated.
> 
> Changes to the original version:
> - Use a private list in scsi_eh_abort_handler to avoid
>   list starvation (pointed out by Joern Engel)
> - Terminate command aborts when the first abort fails
> - Do not attempt command aborts if the host is already in recovery
>   or if the device is removed.
> - Flush abort workqueue if the device is removed.
> 
> Changes to v2:
> - Removed eh_entry initialisation
> - Convert to per-command workqueue
> 
> Changes to v3:
> - Use delayed_work
> - Enable new eh timeout handler for virtio, SAS, and FC
> - Modify logging messages to include scmd pointer
> 
> Changes to v4:
> - Remove stubs when enabling new eh timeout handler
>   for other drivers
> 
> Changes to v5:
> - Enable new eh timeout handler per default
> - Update documentation
> 
> Hannes Reinecke (3):
>   scsi: Fix erratic device offline during EH
>   scsi: improved eh timeout handler
>   scsi_error: Update documentation
> 
>  Documentation/scsi/scsi_eh.txt          |  69 +++++++------
>  Documentation/scsi/scsi_mid_low_api.txt |   9 +-
>  drivers/scsi/scsi.c                     |   9 +-
>  drivers/scsi/scsi_error.c               | 177 ++++++++++++++++++++++++++++----
>  drivers/scsi/scsi_priv.h                |   2 +
>  include/scsi/scsi_cmnd.h                |   1 +
>  include/scsi/scsi_host.h                |   5 +
>  7 files changed, 214 insertions(+), 58 deletions(-)
> 
> -- 
> 1.7.12.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
