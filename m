From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] scsi_scan: Send TEST UNIT READY to the LUN before
 scanning
Date: Wed, 11 Jun 2014 06:40:57 -0700
Message-ID: <20140611134057.GB12240@infradead.org>
References: <1401953203-103015-1-git-send-email-hare@suse.de>
 <1401953203-103015-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58439 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaFKNk7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 09:40:59 -0400
Content-Disposition: inline
In-Reply-To: <1401953203-103015-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Robert Elliot <elliot@hp.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Thu, Jun 05, 2014 at 09:26:42AM +0200, Hannes Reinecke wrote:
> REPORT_LUN_SCAN does not report any outstanding unit attention
> condition as per SAM. However, the target might not be fully
> initialized at that time, so we might end up getting a
> default entry (or even a partially filled one).
> But as we're not able to process the REPORT LUN DATA HAS CHANGED
> unit attention correctly we'll be missing out some LUNs during
> startup.
> So it's better to send a TEST UNIT READY for modern implementations
> and wait until the unit attention condition goes away.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_scan.c | 86 ++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 73 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index e02b3aa..a8e59c3 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -123,6 +123,13 @@ MODULE_PARM_DESC(inq_timeout,
>  		 "Timeout (in seconds) waiting for devices to answer INQUIRY."
>  		 " Default is 20. Some devices may need more; most need less.");
>  
> +static unsigned int scsi_scan_timeout = SCSI_TIMEOUT/HZ + 58;
> +
> +module_param_named(scan_timeout, scsi_scan_timeout, uint, S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(scan_timeout,
> +		 "Timeout (in seconds) waiting for devices to become ready"
> +		 " after INQUIRY. Default is 60.");

Should this be called tur_timeout, similar to the inq_timeout parameter?

Otherwise looks good to me,

Reviewed-by: Christoph Hellwig <hch@lst.de>
