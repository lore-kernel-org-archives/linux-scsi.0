From: "Nikanth K" <nikanth@gmail.com>
Subject: Re: [dm-devel] [PATCH 11/13] dm: enable request-based dm
Date: Fri, 24 Oct 2008 13:22:46 +0530
Message-ID: <807b3a220810240052n6a8b41b0x1ea9c88124b3f5f8@mail.gmail.com>
References: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
	 <20080912.104634.08318008.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:60374 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbYJXHws (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Oct 2008 03:52:48 -0400
Received: by yw-out-2324.google.com with SMTP id 9so251789ywe.1
        for <linux-scsi@vger.kernel.org>; Fri, 24 Oct 2008 00:52:46 -0700 (PDT)
In-Reply-To: <20080912.104634.08318008.k-ueda@ct.jp.nec.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: jens.axboe@oracle.com, agk@redhat.com, James.Bottomley@hansenpartnership.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Nikanth Karthikesan <knikanth@suse.de>

On Fri, Sep 12, 2008 at 8:16 PM, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> This patch enables request-based dm.
>
> o Request-based dm and bio-based dm coexist, since there are
>  some target drivers which are more fitting to bio-based dm.
>  Also, there are other bio-based devices in the kernel
>  (e.g. md, loop).
>  Since bio-based device can't receive struct request,
>  there are some limitations on device stacking between
>  bio-based and request-based.
>
>                     type of underlying device
>                   bio-based      requeset-based
>   ----------------------------------------------
>    bio-based         OK                OK
>    request-based     NG                OK
>

So will some configurations would become impossible, if a target is
made request-based and bio-based one is removed. Hope both
types of targets would co-exist and would be selectable for sometime.

>  The device type is recognized by the queue flag in the kernel,
>  so dm follows that.
>
> o The type of a dm device is decided at the first table loading time.
>  Until then, mempool creations are deferred, since mempools for
>  request-based dm are different from those for bio-based dm.
>  Once the type of a dm device is decided, the type can't be changed.
>
> o Currently, request-based dm supports only tables that have a single
>  target.

Barrier support should be straight forward?

Thanks
Nikanth Karthikesan
