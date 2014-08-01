From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Save command pool address of Scsi_Host
Date: Fri, 1 Aug 2014 05:03:01 -0700
Message-ID: <20140801120301.GA27198@infradead.org>
References: <1406874425-3528-1-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1406874425-3528-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jgross@suse.com
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 01, 2014 at 08:27:05AM +0200, jgross@suse.com wrote:
> From: Juergen Gross <jgross@suse.com>
> 
> If a scsi host driver specifies .cmd_len in it's scsi_host_template, a driver's
> private command pool is needed. scsi_find_host_cmd_pool() will locate it, but
> scsi_alloc_host_cmd_pool() isn't saving the pool address in the host template.
> 
> This will result in an access error when the host is removed.
> 
> Avoid the problem by saving the address of a new allocated command pool where
> it is expected.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>

Looks good, but minor nitpick below:

> +	if (shost->hostt->cmd_size)
> +		shost->hostt->cmd_pool = pool;
> +


We already have a local hostt variable for the host template in this
function, please use it.
