From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V2] sd_zbc: Write unlock zone from sd_uninit_cmnd()
Date: Thu, 10 Aug 2017 20:36:55 -0400
Message-ID: <yq1zib70wk8.fsf@oracle.com>
References: <20170809030022.7862-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26422 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751449AbdHKAhD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Aug 2017 20:37:03 -0400
In-Reply-To: <20170809030022.7862-1-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Wed, 9 Aug 2017 12:00:22 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, Christoph Hellwig <hch@lst.de>


Damien,

> Releasing a zone write lock only when the write commnand that acquired
> the lock completes can cause deadlocks due to potential command
> reordering if the lock owning request is requeued and not
> executed. This problem exists only with the scsi-mq path as, unlike
> the legacy path, requests are moved out of the dispatch queue before
> being prepared and so before locking a zone for a write command.
>
> Since sd_uninit_cmnd() is now always called when a request is
> requeued, call sd_zbc_write_unlock_zone() from that function for write
> requests that acquired a zone lock instead of from
> sd_done(). Acquisition of a zone lock by a write command is indicated
> using the new command flag SCMD_ZONE_WRITE_LOCK.

Applied to 4.13/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
