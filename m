From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V4 4/5] scsi: Change default value of max_report_luns to
 16k-1
Date: Thu, 20 Nov 2014 01:23:33 -0800
Message-ID: <20141120092333.GA26901@infradead.org>
References: <1416237730-1862-1-git-send-email-revers@redhat.com>
 <1416237730-1862-5-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40736 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905AbaKTJXe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Nov 2014 04:23:34 -0500
Content-Disposition: inline
In-Reply-To: <1416237730-1862-5-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>

> +++ b/drivers/scsi/scsi_scan.c
> @@ -105,12 +105,13 @@ MODULE_PARM_DESC(scan, "sync, async or none");
>   * in practice, the maximum number of LUNs suppored by any device
>   * is about 16k.
>   */
> -static unsigned int max_scsi_report_luns = 511;
> +static unsigned int max_scsi_report_luns = 16383;
>  
>  module_param_named(max_report_luns, max_scsi_report_luns, uint, S_IRUGO|S_IWUSR);

What's the point of keepign this parameter?  From looking at ancient
history we initially supported just 128 LUNs by default when Doug added
support for REPORT_LUNS, and we later increased it to 511 when Kurt
enabled REPORT_LUNS support by default.

I can't really see any reason to limit the size except for avoiding
large allocations, and with the two step process we take care of that
easily.

Any reason to keep two responses around in the file instead of a
"goto retry" after updating the length?

