From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 06/12] Make __scsi_remove_device go straight from
        BLOCKED to DEL
Date: Fri, 2 Jun 2017 09:18:20 +0200
Message-ID: <20170602071820.GF560@lst.de>
References: <20170601232711.29062-1-bart.vanassche@sandisk.com> <20170601232711.29062-7-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51452 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750772AbdFBHSW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Jun 2017 03:18:22 -0400
Content-Disposition: inline
In-Reply-To: <20170601232711.29062-7-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Israel Rukshin <israelr@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Benjamin Block <bblock@linux.vnet.ibm.com>

On Thu, Jun 01, 2017 at 04:27:05PM -0700, Bart Van Assche wrote:
> If a device is blocked, make __scsi_remove_device() cause it to
> transition to the DEL state. This means that all the commands
> issued in .shutdown() will error in the mid-layer, thus making
> the removal proceed without being stopped.
> 
> This patch is a slightly modified version of a patch from James
> Bottomley. This patch avoids that the following lockup occurs:

Do we really need the printk for this case?  And if we do we should
probably rate limit it.
