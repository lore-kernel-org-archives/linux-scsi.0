From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi_device refcounting and list lockdown
Date: Tue, 28 Oct 2003 10:06:00 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031028090600.GA7370@lst.de>
References: <20031027155713.GA28140@lst.de> <20031027160101.76d5291b.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:23021 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263888AbTJ1JGZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 04:06:25 -0500
Content-Disposition: inline
In-Reply-To: <20031027160101.76d5291b.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Mon, Oct 27, 2003 at 04:01:01PM -0800, Randy.Dunlap wrote:
> Hi,
> 
> Even before this patch (which isn't merged AFAIK), are
> scsi_device_get() and scsi_device_put() intended to be used
> by SCSI LLDD's for scsi_device reference counts?

Yes, if they need to.  But usually they should not have to worry.

> I'm trying to determine what needs to be done to fix aha152x.c,
> where it creates a struct scsi_cmnd and then inits as follows,
> with my example patch:

A driver is not allowed to "create" a scsi_cmnd.  It must use
scsi_get_command to allocate one.

