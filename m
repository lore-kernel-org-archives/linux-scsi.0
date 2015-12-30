From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 03/20] scsi_dh_alua: Make stpg synchronous
Date: Wed, 30 Dec 2015 12:10:27 +0100
Message-ID: <20151230111027.GB13951@lst.de>
References: <1449560260-53407-1-git-send-email-hare@suse.de> <1449560260-53407-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49159 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192AbbL3LK3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Dec 2015 06:10:29 -0500
Content-Disposition: inline
In-Reply-To: <1449560260-53407-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jbottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Tue, Dec 08, 2015 at 08:37:23AM +0100, Hannes Reinecke wrote:
> The 'activate_complete' function needs to be executed after
> stpg has finished, so we can as well execute stpg synchronously
> and call the function directly.

We could also execute that from the end_io handler.  I think that
was Bart's main issue.  I have to admit that I'd prefer synchronous
execution if possible, and with a work item only per port group
and not every SCSI device I think we are fine.

Otherwise looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
