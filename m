From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] libsas: Check for completed commands before calling
        lldd_abort_task()
Date: Mon, 8 Jan 2018 12:23:48 +0100
Message-ID: <20180108112348.GA7106@lst.de>
References: <1515408716-102111-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35685 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756211AbeAHLXt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Jan 2018 06:23:49 -0500
Content-Disposition: inline
In-Reply-To: <1515408716-102111-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Yves-Alexis Perez <corsac@debian.org>, Hannes Reinecke <hare@suse.com>

On Mon, Jan 08, 2018 at 11:51:56AM +0100, Hannes Reinecke wrote:
> The abort handler might be racing with command completion, so the
> task might already be NULL by the time the abort handler is called.

But without taking dev_done_lock (or using cmpxchg) what prevents
use from still hitting this, although in a more narrow window?
