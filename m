From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 17/22] scsi: print disposition in scsi_print_result()
Date: Sun, 31 Aug 2014 15:23:15 -0700
Message-ID: <20140831222315.GJ16432@infradead.org>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
 <1409247216-76074-18-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48552 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaHaWXR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Aug 2014 18:23:17 -0400
Content-Disposition: inline
In-Reply-To: <1409247216-76074-18-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>

> +const char *
> +scsi_disposition_string(unsigned int disposition) {

The brace placement will need a fix.

> +void scsi_print_result(struct scsi_cmnd *cmd, int disposition)
>  {
>  	const char *devname = cmd->request->rq_disk ?
>  		cmd->request->rq_disk->disk_name : NULL;
> -	scsi_show_result(cmd->device, devname, cmd->result);
> +	scsi_show_result(cmd->device, devname, cmd->result, disposition);

It seems like scsi_show_result should just take a disk argument instead
of the name one, and both scsi_print_result and sd_print_result can
just go away.

