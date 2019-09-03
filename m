Return-Path: <SRS0=3hcu=W6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 763AAC3A5A2
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 14:47:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C93B20828
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 14:47:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbfICOrA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Sep 2019 10:47:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50230 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfICOq7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Sep 2019 10:46:59 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AC6E218C4269;
        Tue,  3 Sep 2019 14:46:59 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 244C958B9;
        Tue,  3 Sep 2019 14:46:59 +0000 (UTC)
Message-ID: <556857ceabb75f1c6fdb2c8bf54476e30585c096.camel@redhat.com>
Subject: Re: [PATCH 1/6] qla2xxx: Fix message indicating vectors used by
 driver
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Himanshu Madhani <hmadhani@marvell.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Date:   Tue, 03 Sep 2019 10:46:58 -0400
In-Reply-To: <20190830222402.23688-2-hmadhani@marvell.com>
References: <20190830222402.23688-1-hmadhani@marvell.com>
         <20190830222402.23688-2-hmadhani@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.62]); Tue, 03 Sep 2019 14:46:59 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2019-08-30 at 15:23 -0700, Himanshu Madhani wrote:
> This patch updates log message which indicates number
> of vectors used by driver instead of displaying failure
> to get maximum requested vectors. Driver will always
> request maximum vectors during initialization. In the
> event driver is not able to get maximum requested vectors,
> it will adjust the allocated vectors. This is normal and
> does not imply failure in driver.
> 
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_isr.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index d81b5ecce24b..4c26630c1c3e 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -3466,10 +3466,8 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
>  		    ha->msix_count, ret);
>  		goto msix_out;
>  	} else if (ret < ha->msix_count) {
> -		ql_log(ql_log_warn, vha, 0x00c6,
> -		    "MSI-X: Failed to enable support "
> -		     "with %d vectors, using %d vectors.\n",
> -		    ha->msix_count, ret);
> +		ql_log(ql_log_info, vha, 0x00c6,
> +		    "MSI-X: Using %d vectors\n", ret);
>  		ha->msix_count = ret;
>  		/* Recalculate queue values */
>  		if (ha->mqiobase && (ql2xmqsupport || ql2xnvmeenable)) {

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

