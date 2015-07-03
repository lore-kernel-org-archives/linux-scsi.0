From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: storvsc: make INQUIRY response SPC-compliant
Date: Fri, 3 Jul 2015 09:19:03 -0700
Message-ID: <20150703161903.GA20449@infradead.org>
References: <1435741448-29070-1-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36507 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555AbbGCQTD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2015 12:19:03 -0400
Content-Disposition: inline
In-Reply-To: <1435741448-29070-1-git-send-email-vkuznets@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: linux-scsi@vger.kernel.org, Long Li <longli@microsoft.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "James E.J. Bottomley" <JBottomley@odin.com>, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org

On Wed, Jul 01, 2015 at 11:04:08AM +0200, Vitaly Kuznetsov wrote:
> SPC-2/3/4 specs state that "The standard INQUIRY data (see table ...)
> shall contain at least 36 bytes". Hyper-V host doesn't always honor this
> requirement, e.g. when there is no physical device present at a particular
> LUN host sets Peripheral qualifier to 011b and Additional length to 0
> (thus making the reply 5-bytes long). Upper level SCSI stack complains
> with 'INQUIRY result too short (5), using 36'. Fix the issue by mangling
> Additional length field in host's reply at the driver level.

This looks like a big mess, and usage of phys_to_virt is not generally
safe to start with.

If HyperV really is that broken the warning seems correct, but if you
really have to get rid of it we could add a blist flag to not issue
the warning in the core code instead of hacking around it in the driver.
