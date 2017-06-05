From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 04/12] Protect SCSI device state changes with a mutex
Date: Mon, 5 Jun 2017 10:09:37 +0200
Message-ID: <20170605080937.GB22028@lst.de>
References: <20170602212203.30401-1-bart.vanassche@sandisk.com> <20170602212203.30401-5-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38664 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751336AbdFEIJj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Jun 2017 04:09:39 -0400
Content-Disposition: inline
In-Reply-To: <20170602212203.30401-5-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

On Fri, Jun 02, 2017 at 02:21:55PM -0700, Bart Van Assche wrote:
> Serializing SCSI device state changes avoids that two state changes
> can occur concurrently, e.g. the state changes in scsi_target_block()
> and __scsi_remove_device(). This serialization is essential to make
> patch "Make __scsi_remove_device go straight from BLOCKED to DEL"
> work reliably.
> 
> Enable this mechanism for all scsi_target_*block() callers but not
> for the scsi_internal_device_unblock() calls from the mpt3sas driver
> because that driver can call scsi_internal_device_unblock() from
> atomic context.

And not taking the lock in that path is safe because of what conditions?
