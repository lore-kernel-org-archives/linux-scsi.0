From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/8] lib: Introduce sgl_alloc() and sgl_free()
Date: Thu, 12 Oct 2017 16:52:51 -0600
Message-ID: <ee12eeaf-9848-478d-4ebe-9d3497e248e0@kernel.dk>
References: <20171012224550.25440-1-bart.vanassche@wdc.com>
 <20171012224550.25440-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:43259 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757419AbdJLWwz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Oct 2017 18:52:55 -0400
Received: by mail-pf0-f179.google.com with SMTP id a8so6569040pfc.0
        for <linux-scsi@vger.kernel.org>; Thu, 12 Oct 2017 15:52:55 -0700 (PDT)
In-Reply-To: <20171012224550.25440-2-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org

On 10/12/2017 04:45 PM, Bart Van Assche wrote:
> Many kernel drivers contain code that allocate and free both a
> scatterlist and the pages that populate that scatterlist.
> Introduce functions under lib/ that perform these tasks instead
> of duplicating this functionality in multiple drivers.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> ---
>  include/linux/sgl_alloc.h |  16 ++++++++
>  lib/Kconfig               |   4 ++
>  lib/Makefile              |   1 +
>  lib/sgl_alloc.c           | 102 ++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 123 insertions(+)
>  create mode 100644 include/linux/sgl_alloc.h
>  create mode 100644 lib/sgl_alloc.c
> 
> diff --git a/include/linux/sgl_alloc.h b/include/linux/sgl_alloc.h
> new file mode 100644
> index 000000000000..a0f719690c9e
> --- /dev/null
> +++ b/include/linux/sgl_alloc.h
> @@ -0,0 +1,16 @@
> +#ifndef _SGL_ALLOC_H_
> +#define _SGL_ALLOC_H_
> +
> +#include <linux/types.h> /* bool, gfp_t */
> +
> +struct scatterlist;
> +
> +struct scatterlist *sgl_alloc_order(unsigned long long length,
> +				    unsigned int order, unsigned int *nent_p,
> +				    gfp_t gfp, bool chainable);
> +struct scatterlist *sgl_alloc(unsigned long long length, unsigned int *nent_p,
> +			      gfp_t gfp);
> +void sgl_free_order(struct scatterlist *sgl, int order);
> +void sgl_free(struct scatterlist *sgl);
> +
> +#endif /* _SGL_ALLOC_H_ */

Should this just go into linux/scatterlist.h instead of creating a new header
file?

-- 
Jens Axboe
