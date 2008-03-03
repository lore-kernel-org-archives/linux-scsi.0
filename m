From: "Grant Grundler" <grundler@google.com>
Subject: Re: [RFC PATCH 1/3] block: add rq->complete_io hook for request stacking
Date: Mon, 3 Mar 2008 09:33:15 -0800
Message-ID: <da824cf30803030933j5647b0d4k61f6d110ff9f29bb@mail.gmail.com>
References: <20080215.172727.39155014.k-ueda@ct.jp.nec.com>
	 <47CC2652.1080601@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:58487 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761593AbYCCRd0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2008 12:33:26 -0500
Received: from zps76.corp.google.com (zps76.corp.google.com [172.25.146.76])
	by smtp-out.google.com with ESMTP id m23HXHAf022141
	for <linux-scsi@vger.kernel.org>; Mon, 3 Mar 2008 09:33:17 -0800
Received: from el-out-1112.google.com (elfr23.prod.google.com [10.126.194.23])
	by zps76.corp.google.com with ESMTP id m23HXGNP012020
	for <linux-scsi@vger.kernel.org>; Mon, 3 Mar 2008 09:33:16 -0800
Received: by el-out-1112.google.com with SMTP id r23so191942elf.20
        for <linux-scsi@vger.kernel.org>; Mon, 03 Mar 2008 09:33:15 -0800 (PST)
In-Reply-To: <47CC2652.1080601@suse.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com

On Mon, Mar 3, 2008 at 8:24 AM, Hannes Reinecke <hare@suse.de> wrote:

>  I would rather have rq->complete_io() to be pointing to blk_end_io in the
>  default case, this way rq->complete_io() would always be valid and we
>  would be saving us the if() clause.

This is a good idea. But...

...
>  So when using my proposal this would just become:
>
>  {
>     BUG_ON(!rq->complete_io);
>
>     return rq->complete_io(rq, error, nr_bytes, 0, NULL);
>  }

This "BUG_ON" is also an "if()" clause except
it will panic. The box will panic if the function
pointer is a null pointer and it won't be hard to
sort out why. I suggest omitting the BUG_ON.

thanks,
grant
