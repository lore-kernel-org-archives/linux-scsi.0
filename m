From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 2.6.30] libsrp: fix memory leak in srp_ring_free()
Date: Sat, 5 Sep 2009 11:34:40 +0200
Message-ID: <e2e108260909050234h6d5a391fh915ee85b4410f9a4@mail.gmail.com>
References: <e2e108260908300336p777654bbw2f0b1eef9b6858c@mail.gmail.com>
	 <20090905182034M.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:58441 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbZIEJej (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Sep 2009 05:34:39 -0400
Received: by fxm17 with SMTP id 17so1123551fxm.37
        for <linux-scsi@vger.kernel.org>; Sat, 05 Sep 2009 02:34:40 -0700 (PDT)
In-Reply-To: <20090905182034M.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, tomof@acm.org

On Sat, Sep 5, 2009 at 11:20 AM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
>
> On Sun, 30 Aug 2009 12:36:48 +0200
> Bart Van Assche <bart.vanassche@gmail.com> wrote:
>
> > This patch fixes a memory leak in the libsrp function srp_ring_free().
> > It is not documented whether or not this function should free the ring
> > pointer itself. But the source code of the callers of this function
> > (srp_target_alloc() and srp_target_free()) makes it clear that
> > srp_ring_free() should deallocate the ring pointer itself. Furthermore,
> > the patch below makes srp_ring_free() deallocate all memory allocated by
> > srp_ring_alloc().
> >
> > This patch affects the ibmvstgt driver, which is the only in-tree driver
> > that calls the srp_ring_free() function (indirectly).
> >
> > Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
> > Cc: James Bottomley <James.Bottomley@suse.de>
> > Cc: FUJITA Tomonori <tomof@acm.org>
>
> Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>
> Better to add:
>
> Cc: stable@kernel.org

Thanks for the review. I will submit this patch to stable@kernel.org
as soon as it has been committed. Patches are only accepted for
backporting after they have been committed in the mainline kernel.

Bart.
