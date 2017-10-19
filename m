From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] scsi: storvsc: Allow only one remove lun work item to
 be issued per lun
Date: Thu, 19 Oct 2017 08:35:10 -0700
Message-ID: <20171019153510.GA7633@infradead.org>
References: <1508261721-24144-1-git-send-email-cavery@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1508261721-24144-1-git-send-email-cavery@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Cathy Avery <cavery@redhat.com>
Cc: kys@microsoft.com, hch@infradead.org, haiyangz@microsoft.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, dan.carpenter@oracle.com, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 17, 2017 at 01:35:21PM -0400, Cathy Avery wrote:
> +	/*
> +	 * Set the error handler work queue.
> +	 */
> +	snprintf(host_dev->work_q_name, sizeof(host_dev->work_q_name),
> +		 "storvsc_error_wq_%d", host->host_no);
> +	host_dev->handle_error_wq =
> +			create_singlethread_workqueue(host_dev->work_q_name);

If you use alloc_ordered_workqueue directly instead of
create_singlethread_workqueue you can pass a format string and don't
need the separate allocation.

But I'm not sure if Tejun is fine with using __WQ_LEGACY directly..

Except for this nit this looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
