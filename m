From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] [v2] aha152x cmnd->device oops
Date: Wed, 29 Oct 2003 14:42:49 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031029134249.GA28862@lst.de>
References: <20031027155713.GA28140@lst.de> <20031027160101.76d5291b.rddunlap@osdl.org> <20031028090600.GA7370@lst.de> <20031028124536.3ce82c23.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:56726 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262066AbTJ2NnA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 08:43:00 -0500
Content-Disposition: inline
In-Reply-To: <20031028124536.3ce82c23.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, fischer@norbit.de

On Tue, Oct 28, 2003 at 12:45:36PM -0800, Randy.Dunlap wrote:
>  			if(!(DONE_SC->SCp.Status & not_issued)) {

Strange variable name..


> +					cmnd->device          = ptr->device;
>  					cmnd->device->host    = ptr->device->host;
>  					cmnd->device->id      = ptr->device->id;
>  					cmnd->device->lun     = ptr->device->lun;

You shouldn't touch either of these.

> -					if(cmnd)
> -						kfree(cmnd);

You need a scsi_put_command here.

