From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V3 02/16] scsi: balance out autopm get/put calls in
 scsi_sysfs_add_sdev()
Date: Sat, 13 Sep 2014 11:54:57 -0700
Message-ID: <20140913185457.GC30010@infradead.org>
References: <1410350063-23267-1-git-send-email-draviv@codeaurora.org>
 <1410350063-23267-3-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1410350063-23267-3-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Dolev Raviv <draviv@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Subhash Jadavani <subhashj@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 10, 2014 at 02:54:09PM +0300, Dolev Raviv wrote:
> From: Subhash Jadavani <subhashj@codeaurora.org>
> 
> SCSI Well-known logical units generally don't have any scsi driver
> associated with it which means no one will call scsi_autopm_put_device()
> on these wlun scsi devices and this would result in keeping the
> corresponding scsi device always active (hence LLD can't be suspended as
> well). Same exact problem can be seen for other scsi device representing
> normal logical unit whose driver is yet to be loaded. This patch fixes
> the above problem with this approach:
> 
> - make the scsi_autopm_put_device call at the end of scsi_sysfs_add_sdev
>   to make it balance out the get earlier in the function.
> - let drivers do paired get/put calls in their probe methods.
> 
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

Looks good to me, I will pick this up for the next core-for-3.18 update.
