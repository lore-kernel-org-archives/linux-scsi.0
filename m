From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 13/35] scsi: drop bus reset for wd33c93-compatible
        boards
Date: Wed, 28 Jun 2017 02:00:42 +0200
Message-ID: <20170628000042.GM13988@lst.de>
References: <1498222975-71858-1-git-send-email-hare@suse.de> <1498222975-71858-14-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46563 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753975AbdF1AAo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Jun 2017 20:00:44 -0400
Content-Disposition: inline
In-Reply-To: <1498222975-71858-14-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Fri, Jun 23, 2017 at 03:02:33PM +0200, Hannes Reinecke wrote:
> The bus reset function is just a wrapper around host reset, so drop it.

It also takes the host_lock, which the direct host_reset invokation
doesn't.  Given that before we'd always get the bus reset first
that probably was the actually tested path, so we should move the
lock into wd33c93_host_reset.
