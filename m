Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76EBDC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 08:25:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 547052064B
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 08:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731737AbgFWIZ3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Jun 2020 04:25:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:44612 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731567AbgFWIZ3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Jun 2020 04:25:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D5E43ADC1;
        Tue, 23 Jun 2020 08:25:26 +0000 (UTC)
Date:   Tue, 23 Jun 2020 10:25:26 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH 6/9] qla2xxx: Make __qla2x00_alloc_iocbs() initialize 32
 bits of request_t.handle
Message-ID: <20200623082526.33hsnrecqig46oha@beryllium.lan>
References: <20200614223921.5851-1-bvanassche@acm.org>
 <20200614223921.5851-7-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200614223921.5851-7-bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jun 14, 2020 at 03:39:18PM -0700, Bart Van Assche wrote:
> The request_t 'handle' member is 32-bits wide, hence use wrt_reg_dword().
> Change the cast in the wrt_reg_byte() call to make it clear that a
> regular pointer is casted to an __iomem pointer.
> 
> Note: 'pkt' points to I/O memory for the qlafx00 adapter family and to
> coherent memory for all other adapter families.
> 
> This patch fixes the following Coverity complaint:
> 
> CID 358864 (#1 of 1): Reliance on integer endianness (INCOMPATIBLE_CAST)
> incompatible_cast: Pointer &pkt->handle points to an object whose effective
> type is unsigned int (32 bits, unsigned) but is dereferenced as a narrower
> unsigned short (16 bits, unsigned). This may lead to unexpected results
> depending on machine endianness.
> 
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Fixes: 8ae6d9c7eb10 ("[SCSI] qla2xxx: Enhancements to support ISPFx00.")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Daniel Wagner <dwagner@suse.de>

> ---
>  drivers/scsi/qla2xxx/qla_iocb.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
> index 8865c35d3421..7c2ad8c18398 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -2305,8 +2305,8 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
>  	pkt = req->ring_ptr;
>  	memset(pkt, 0, REQUEST_ENTRY_SIZE);
>  	if (IS_QLAFX00(ha)) {
> -		wrt_reg_byte((void __iomem *)&pkt->entry_count, req_cnt);
> -		wrt_reg_word((void __iomem *)&pkt->handle, handle);
> +		wrt_reg_byte((u8 __force __iomem *)&pkt->entry_count, req_cnt);
> +		wrt_reg_dword((__le32 __force __iomem *)&pkt->handle, handle);

Makes me wonder how this ever worked.
