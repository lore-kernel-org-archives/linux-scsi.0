From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: fix race between simultaneous decrements of
 ->host_failed
Date: Sat, 28 May 2016 23:54:52 -0700
Message-ID: <20160529065452.GA21677@infradead.org>
References: <1464407471-3712-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1464407471-3712-1-git-send-email-fangwei1@huawei.com>
Sender: linux-ide-owner@vger.kernel.org
To: Wei Fang <fangwei1@huawei.com>
Cc: tj@kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, May 28, 2016 at 11:51:11AM +0800, Wei Fang wrote:
> async_sas_ata_eh(), which will call scsi_eh_finish_cmd() in some case,
> would be performed simultaneously in sas_ata_strategy_handler(). In this
> case, ->host_failed may be decreased simultaneously in
> scsi_eh_finish_cmd() on different CPUs, and become abnormal.
> 
> It will lead to permanently inequal between ->host_failed and
>  ->host_busy. Then SCSI error handler thread won't become running,
> SCSI errors after that won't be handled forever.
> 
> Use atomic type for ->host_failed to fix this race.

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

But please also update Documentation/scsi/scsi_eh.txt for this
change.
