From: "Nikanth K" <nikanth@gmail.com>
Subject: Re: [dm-devel] [PATCH 10/13] dm: add core functions for request-based dm
Date: Fri, 24 Oct 2008 13:14:50 +0530
Message-ID: <807b3a220810240044v1b9f12e3xc3bd5a429b9d4c5@mail.gmail.com>
References: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
	 <20080912.104612.115643090.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:20436 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbYJXHov (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Oct 2008 03:44:51 -0400
Received: by yx-out-2324.google.com with SMTP id 8so252593yxm.1
        for <linux-scsi@vger.kernel.org>; Fri, 24 Oct 2008 00:44:50 -0700 (PDT)
In-Reply-To: <20080912.104612.115643090.k-ueda@ct.jp.nec.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: jens.axboe@oracle.com, agk@redhat.com, James.Bottomley@hansenpartnership.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Nikanth Karthikesan <knikanth@suse.de>

On Fri, Sep 12, 2008 at 8:16 PM, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
<snip>

> +static int dm_make_request(struct request_queue *q, struct bio *bio)
> +{
> +       struct mapped_device *md = (struct mapped_device *)q->queuedata;
> +
> +       if (unlikely(bio_barrier(bio))) {
> +               bio_endio(bio, -EOPNOTSUPP);
> +               return 0;
> +       }
> +
<snip>

Why not add barrier support in the beginning itself, so that targets
can be developed with barriers in mind? At least can we make the target
to return error, instead of the core?

Thanks
Nikanth Karthikesan
