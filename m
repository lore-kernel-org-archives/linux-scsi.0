From: Jens Axboe <axboe@suse.de>
Subject: Re: [SCSI] fix wrong context bugs in SCSI
Date: Wed, 8 Feb 2006 09:56:29 +0100
Message-ID: <20060208085629.GE4338@suse.de>
References: <1139342419.6065.8.camel@mulgrave.il.steeleye.com> <1139342922.6065.12.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:13151 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1030585AbWBHIyF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2006 03:54:05 -0500
Content-Disposition: inline
In-Reply-To: <1139342922.6065.12.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Tue, Feb 07 2006, James Bottomley wrote:
> +static void scsi_device_dev_release(struct device *dev)
> +{
> +	execute_in_process_context(scsi_device_dev_release_usercontext,	dev);
> +}
> +

Hmm, this (and further up) could fail, yet you don't check.

I don't think this API is very nice to be honest, there's no good way to
handle failures - you can't just sleep and loop retry the execute if you
are in_interrupt(). I'd prefer passing in a work_queue_work (with a
better name :-) that has been allocated at a reliable time during
initialization.


-- 
Jens Axboe

