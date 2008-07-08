From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bsg: fix oops on remove
Date: Tue, 8 Jul 2008 09:03:38 +0900
Message-ID: <20080708090323V.fujita.tomonori@lab.ntt.co.jp>
References: <1215463801.3274.40.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:49277 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622AbYGHADz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jul 2008 20:03:55 -0400
In-Reply-To: <1215463801.3274.40.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, Jens.Axboe@oracle.com

On Mon, 07 Jul 2008 15:50:01 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> If you do a modremove of any sas driver, you run into an oops on
> shutdown when the host is removed (coming from the host bsg device).
> The root cause seems to be that there's a use after free of the
> bsg_class_device:  In bsg_kref_release_function, this is used (to do a
> put_device(bcg->parent) after bcg->release has been called.  In sas (and
> possibly many other things) bcd->release frees the queue which contains
> the bsg_class_device, so we get a put_device on unreferenced memory.
> Fix this by taking a copy of the pointer to the parent before releasing
> bsg.

Thanks,

Currently, as you know, only sas SMP handler uses bcg->release so I
overlooked this silly bug with the removal of iSCSI module.


> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
