From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [linux-devel:devel-lkp-ib03-powerpc-201501140043 30/31]
 drivers/scsi/scsi_logging.c:254:3: error: format not a string literal and no
 format arguments
Date: Wed, 14 Jan 2015 01:40:43 -0800
Message-ID: <20150114094043.GA21820@infradead.org>
References: <201501140133.IhMp3BqI%fengguang.wu@intel.com>
 <1421170252.2076.9.camel@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55910 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbbANJkn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 04:40:43 -0500
Content-Disposition: inline
In-Reply-To: <1421170252.2076.9.camel@parallels.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "kbuild-all@01.org" <kbuild-all@01.org>, "fengguang.wu@intel.com" <fengguang.wu@intel.com>

On Tue, Jan 13, 2015 at 05:30:20PM +0000, James Bottomley wrote:
> Just for everyone's sake the problem is printk format strings (and all
> the things that indirect there, like pr_xxx and dev_printk).  We must
> never pass a mutable string directly to printk because of the mayhem
> that would result if its contents were altered by the user (because some
> of the things we do in string format parsing are very dangerous), making
> this a potential security issue.  Only ever pass static strings (in the
> ro section) to printk formats.
> 
> So this is wrong:
> 
> dev_printk(KERN_INFO, dev, logbuf);
> 
> This is correct:
> 
> dev_printk(KERN_INFO, dev, "%s", logbuf);

In this case the logbug comes from actually doing just that string
formatting earlier in the function, so it practice it's harmles.
It would be useful to have a dev_puts to avoid that reinterpretation again,
though.
