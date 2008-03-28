From: "Grant Grundler" <grundler@google.com>
Subject: Re: [patch 13/17] drivers/scsi/initio.c: suppress compile warning
Date: Fri, 28 Mar 2008 14:55:28 -0700
Message-ID: <da824cf30803281455g22334554y8cb3887beec951a@mail.gmail.com>
References: <200803282148.m2SLmfg7012252@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:42817 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbYC1Vzg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Mar 2008 17:55:36 -0400
Received: from zps36.corp.google.com (zps36.corp.google.com [172.25.146.36])
	by smtp-out.google.com with ESMTP id m2SLtUQe030269
	for <linux-scsi@vger.kernel.org>; Fri, 28 Mar 2008 21:55:31 GMT
Received: from rv-out-0910.google.com (rvfc24.prod.google.com [10.140.180.24])
	by zps36.corp.google.com with ESMTP id m2SLtTLf027301
	for <linux-scsi@vger.kernel.org>; Fri, 28 Mar 2008 14:55:30 -0700
Received: by rv-out-0910.google.com with SMTP id c24so215788rvf.47
        for <linux-scsi@vger.kernel.org>; Fri, 28 Mar 2008 14:55:29 -0700 (PDT)
In-Reply-To: <200803282148.m2SLmfg7012252@imap1.linux-foundation.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Fri, Mar 28, 2008 at 2:48 PM,  <akpm@linux-foundation.org> wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
>
>  powerpc:
>
>  drivers/scsi/initio.c: In function 'initio_build_scb':
>  drivers/scsi/initio.c:2585: warning: large integer implicitly truncated to unsigned type

I posted a fix for this yesterday and Alan Cox ACKed it.

It's here:
    http://marc.info/?l=linux-scsi&m=120668352622659&w=2

hth,
grant

>
>  Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
>  Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>  Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>  ---
>
>   drivers/scsi/initio.c |    6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
>  diff -puN drivers/scsi/initio.c~drivers-scsi-initioc-suppress-compile-warning drivers/scsi/initio.c
>  --- a/drivers/scsi/initio.c~drivers-scsi-initioc-suppress-compile-warning
>  +++ a/drivers/scsi/initio.c
>  @@ -2582,7 +2582,11 @@ static void initio_build_scb(struct init
>         dma_addr = dma_map_single(&host->pci_dev->dev, cmnd->sense_buffer,
>                                   SENSE_SIZE, DMA_FROM_DEVICE);
>         cblk->senseptr = cpu_to_le32((u32)dma_addr);
>  -       cblk->senselen = cpu_to_le32(SENSE_SIZE);
>  +       /*
>  +        * The below needs casting to avoid a "large integer implicitly
>  +        * truncated to unsigned type" warning on powerpc
>  +        */
>  +       cblk->senselen = (u8)cpu_to_le32(SENSE_SIZE);
>         cmnd->SCp.ptr = (char *)(unsigned long)dma_addr;
>         cblk->cdblen = cmnd->cmd_len;
>
>  _
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
