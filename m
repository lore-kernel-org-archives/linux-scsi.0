From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] Promise 'stex' driver
Date: Sat, 10 Jun 2006 21:47:57 +0400
Message-ID: <20060610174757.GB7268@martell.zuzino.mipt.ru>
References: <20060610160852.GA15316@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:20613 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S1030457AbWFJRrs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jun 2006 13:47:48 -0400
Received: by nf-out-0910.google.com with SMTP id y38so662867nfb
        for <linux-scsi@vger.kernel.org>; Sat, 10 Jun 2006 10:47:43 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20060610160852.GA15316@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@osdl.org, promise_linux@promise.com

On Sat, Jun 10, 2006 at 12:08:52PM -0400, Jeff Garzik wrote:
> --- /dev/null
> +++ b/drivers/scsi/stex.c

> +static inline void stex_gettime(u32 *time)

__le32 *time

> +{
> +	struct timeval tv;
> +	do_gettimeofday(&tv);
> +
> +	*time = cpu_to_le32(tv.tv_sec & 0xffffffff);
> +	*(time + 1) = cpu_to_le32((tv.tv_sec >> 16) >> 16);
> +}

> +static void
> +stex_send_cmd(struct st_hba *hba, struct req_msg *req, u16 tag)
> +{
> +	req->tag = cpu_to_le16(tag);
> +	req->task_attr = TASK_ATTRIBUTE_SIMPLE;
> +	req->task_manage = 0; /* not supported yet */
> +	req->payload_sz = (u8)(sizeof(struct req_msg)/sizeof(u32));

sparse warns here. Is this OK?

drivers/scsi/stex.c:442:47: warning: cast truncates bits from constant value (106 becomes 6)

