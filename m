From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: fix potential NULL pointer dereference.
Date: Tue, 25 Mar 2014 06:13:06 -0700
Message-ID: <20140325131306.GA25392@infradead.org>
References: <1395752333-12185-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54769 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbaCYNNr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Mar 2014 09:13:47 -0400
Content-Disposition: inline
In-Reply-To: <1395752333-12185-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: JBottomley@Parallels.com, linux-scsi@vger.kernel.org, m.lombardi85@gmail.com

> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 78b004d..4021849 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -2289,6 +2289,9 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
>  		return FAILED;
>  
>  	scmd = scsi_get_command(dev, GFP_KERNEL);
> +	if (!scmd)
> +		return FAILED;
> +

Fails to call scsi_autopm_put_host, or in Jame's latest tree that has
my changes put_device on the sdev gendev.  I sent a correct version
earlier, but there has been very little enthusiasm for it.

