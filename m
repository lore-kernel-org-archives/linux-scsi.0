From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6/6] sd: add support for TCG OPAL self encrypting disks
Date: Tue, 6 Jun 2017 11:59:55 +0200
Message-ID: <20170606095955.GC20590@lst.de>
References: <20170604124225.27032-1-hch@lst.de> <20170604124225.27032-7-hch@lst.de> <20170605211530.aqxwigcrxgsdvmhs@sbauer-Z170X-UD5>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45368 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751329AbdFFJ75 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Jun 2017 05:59:57 -0400
Content-Disposition: inline
In-Reply-To: <20170605211530.aqxwigcrxgsdvmhs@sbauer-Z170X-UD5>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Scott Bauer <scott.bauer@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Jonathan Derrick <jonathan.derrick@intel.com>, Rafael Antognolli <rafael.antognolli@intel.com>, Robert Elliott <elliott@hpe.com>, linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Jun 05, 2017 at 03:15:31PM -0600, Scott Bauer wrote:
> I'm not familiar at all with ATA, but I noticed there was no unlock from suspend support
> in the series. Does ATA not have a way to determine if we're coming out of a suspend?

I don't know, and not having a test system with a OPAL capable driver
and suspend support I could not even test the code.

> I see there are some power-ops in scsi/sd.c, if you do want to add it you can mabe toss a
> 
> if (sdkp->security)
>    opal_unlock_from_suspend(sdpk->opal_dev)
> 
> somewhere in the resume path? We handle null opal_devs and no unlock from suspend list
> so calling it when nothing is set up is just a no-op.

Yeah, maybe.  We'll just need someone who could test it first.
