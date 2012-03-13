From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3/4] libfcoe: Add fcoe_sysfs
Date: Mon, 12 Mar 2012 22:00:13 -0700
Message-ID: <20120313050013.GB15426@kroah.com>
References: <20120312230915.10580.52548.stgit@localhost6.localdomain6>
 <20120312230931.10580.58845.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49025 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab2CMFAS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Mar 2012 01:00:18 -0400
Received: by ghrr11 with SMTP id r11so148975ghr.19
        for <linux-scsi@vger.kernel.org>; Mon, 12 Mar 2012 22:00:18 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20120312230931.10580.58845.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org, james.smart@emulex.com, giridhar.malavali@qlogic.com

On Mon, Mar 12, 2012 at 04:09:31PM -0700, Robert Love wrote:
> +static void fcoe_ctlr_attrs_release(struct device *dev)
> +{
> +	struct fcoe_ctlr_attrs *ctlr = dev_to_ctlr(dev);
> +
> +	put_device(ctlr->dev.parent);
> +	ctlr->dev.parent = NULL;

You should never have to put a reference count on your parent, nor worry
about setting this value to NULL.  Just assign the parent when you
register the device, no need to increment it.

> +#define fcoe_ctlr_id(x)				\
> +	((x)->id)
> +#define fcoe_ctlr_work_q_name(x)		\
> +	((x)->work_q_name)

<snip>

Ick, what are all of these for, please don't do that.

thanks,

greg k-h
