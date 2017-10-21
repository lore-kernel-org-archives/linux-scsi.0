From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH V2] scsi: storvsc: Allow only one remove lun work item to
 be issued per lun
Date: Sat, 21 Oct 2017 08:44:44 -0700
Message-ID: <20171021154444.GK1302522@devbig577.frc2.facebook.com>
References: <1508261721-24144-1-git-send-email-cavery@redhat.com>
 <20171019153510.GA7633@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171019153510.GA7633@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Cathy Avery <cavery@redhat.com>, kys@microsoft.com, haiyangz@microsoft.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, dan.carpenter@oracle.com, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On Thu, Oct 19, 2017 at 08:35:10AM -0700, Christoph Hellwig wrote:
> On Tue, Oct 17, 2017 at 01:35:21PM -0400, Cathy Avery wrote:
> > +	/*
> > +	 * Set the error handler work queue.
> > +	 */
> > +	snprintf(host_dev->work_q_name, sizeof(host_dev->work_q_name),
> > +		 "storvsc_error_wq_%d", host->host_no);
> > +	host_dev->handle_error_wq =
> > +			create_singlethread_workqueue(host_dev->work_q_name);
> 
> If you use alloc_ordered_workqueue directly instead of
> create_singlethread_workqueue you can pass a format string and don't
> need the separate allocation.
> 
> But I'm not sure if Tejun is fine with using __WQ_LEGACY directly..

The only thing that flag does is exempting the workqueue from possible
flush deadlock check as we don't know whether WQ_MEM_RECLAIM on a
legacy workqueue is intentional.  There's no reason to add it when
converting to alloc_ordered_workqueue().  Just decide whether it needs
forward progress guarantee and use WQ_MEM_RECLAIM if so.

Thanks.

-- 
tejun
