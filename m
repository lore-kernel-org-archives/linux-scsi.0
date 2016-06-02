From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 1/2] scsi: fix race between simultaneous decrements of
 ->host_failed
Date: Thu, 2 Jun 2016 09:20:51 -0700
Message-ID: <20160602162051.GA26699@kroah.com>
References: <1464856958-30647-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1464856958-30647-1-git-send-email-fangwei1@huawei.com>
Sender: linux-doc-owner@vger.kernel.org
To: Wei Fang <fangwei1@huawei.com>
Cc: tj@kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, corbet@lwn.net, hch@infradead.org, dan.j.williams@intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 02, 2016 at 04:42:37PM +0800, Wei Fang wrote:
> sas_ata_strategy_handler() adds the works of the ata error handler
> to system_unbound_wq. This workqueue asynchronously runs work items,
> so the ata error handler will be performed concurrently on different
> CPUs. In this case, ->host_failed will be decreased simultaneously in
> scsi_eh_finish_cmd() on different CPUs, and become abnormal.
> 
> It will lead to permanently inequal between ->host_failed and
>  ->host_busy, and scsi error handler thread won't become running.
> IO errors after that won't be handled forever.
> 
> Since all scmds must have been handled in the strategy handle, just
> remove the decrement in scsi_eh_finish_cmd() and zero ->host_busy
> after the strategy handle to fix this race.
> 
> This fixes the problem introduced in
> commit 50824d6c5657 ("[SCSI] libsas: async ata-eh").
> 
> Signed-off-by: Wei Fang <fangwei1@huawei.com>


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
