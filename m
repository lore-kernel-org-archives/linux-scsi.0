From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 02/41] hpsa: clean up host, channel, target, lun prints
Date: Sun, 8 Mar 2015 08:38:51 -0700
Message-ID: <20150308153851.GB17534@infradead.org>
References: <20150306233504.29973.41322.stgit@brunhilda>
 <20150306234558.29973.69186.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35096 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbbCHPiv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Mar 2015 11:38:51 -0400
Content-Disposition: inline
In-Reply-To: <20150306234558.29973.69186.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com, linux-scsi@vger.kernel.org

> +static inline void hpsa_show_dev_msg(int type, struct ctlr_info *h,
> +	struct hpsa_scsi_dev_t *dev, char *description)
> +{
> +#define HPSA_INFO 0
> +#define HPSA_WARN 1
> +#define HPSA_ERR 2
> +	if (type == HPSA_INFO)
> +		dev_info(&h->pdev->dev,
> +			"scsi %d:%d:%d:%d: %s %s %.8s %.16s RAID-%s SSDSmartPathCap%c En%c Exp=%d\n",

> +	else if (type == HPSA_WARN)
> +		dev_warn(&h->pdev->dev,
> +			"scsi %d:%d:%d:%d: %s %s %.8s %.16s RAID-%s SSDSmartPathCap%c En%c Exp=%d\n",

> +	else if (type == HPSA_ERR)
> +		dev_err(&h->pdev->dev,
> +			"scsi %d:%d:%d:%d: %s %s %.8s %.16s RAID-%s SSDSmartPathCap%c En%c Exp=%d\n",


Why don't you just pass in the kernel KERN_ levels and use dev_printk?


