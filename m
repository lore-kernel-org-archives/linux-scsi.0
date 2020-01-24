Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBDE0C2D0DB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 14:32:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1C66206F0
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 14:32:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R/VLq7iT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391943AbgAXOc6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 09:32:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21832 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389436AbgAXOc4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2020 09:32:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579876374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jzyD8A5ofC3A/GFfYScBFThWupYVqYeHHm+oAYWbYWw=;
        b=R/VLq7iTJruY8FiFfTnz9OeFucvnsLFhw21imYOqSseEkODtPy6b0tdMALC4PMN0uyeWKF
        /xcZJCxJqAg11Z96O1N039cMP9Sa1mroyjCjHaZHXpDaoNHBwpdpj9V7VDypiP5RVo2ZFS
        DtaruwIOMgUgi/lhdzNlWtAmts2Sj2o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-NxQVA3nrNxOkt_m-5SuFag-1; Fri, 24 Jan 2020 09:32:48 -0500
X-MC-Unique: NxQVA3nrNxOkt_m-5SuFag-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 088411882CC0;
        Fri, 24 Jan 2020 14:32:47 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A79FA1001B05;
        Fri, 24 Jan 2020 14:32:46 +0000 (UTC)
Message-ID: <0fd75b7ed0586ef757adaa04e2b5ad6a5ad145df.camel@redhat.com>
Subject: Re: [PATCH v5] qla2xxx: Fix unbound NVME response length
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Himanshu Madhani <hmadhani@marvell.com>, linux-scsi@vger.kernel.org
Date:   Fri, 24 Jan 2020 09:32:46 -0500
In-Reply-To: <20200124045014.23554-1-hmadhani@marvell.com>
References: <20200124045014.23554-1-hmadhani@marvell.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-01-23 at 20:50 -0800, Himanshu Madhani wrote:
> From: Arun Easi <aeasi@marvell.com>
> 
> On certain cases when response length is less than 32, NVME response data
> is supplied inline in IOCB. This is indicated by some combination of state
> flags. There was an instance when a high, and incorrect, response length was
> indicated causing driver to overrun buffers. Fix this by checking and
> limiting the response payload length.
> 
> Fixes: 7401bc18d1ee3 ("scsi: qla2xxx: Add FC-NVMe command handling")
> Cc: stable@vger.kernel.org
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> ---
> Hi Martin,
> 
> We discovered issue with our newer Gen7 adapter when response length
> happens to be larger than 32 bytes, could result into crash.
> 
> Please apply this to 5.5/scsi-fixes branch at your earliest convenience.
> 
> Changes from v4 -> v5
> 
> o Added WARN_ONCE and moved it under ql_dbg bits to avoid excessive logging
> 
> Changes from v3 -> v4
> 
> o use "sizeof(struct nvme_fc_ersp_iu)" in missed place.
> 
> Changes from v2 -> v3
> 
> o Use "sizeof(struct nvme_fc_ersp_iu)" to indicate response payload size.
> 
> Changes from v1 -> v2
> 
> o Fixed the tag for stable.
> o Removed logit which got spilled from other patch to prevent compile failure.
> 
> Thanks,
> Himanshu
> ---
>  drivers/scsi/qla2xxx/qla_dbg.c |  6 ------
>  drivers/scsi/qla2xxx/qla_dbg.h |  6 ++++++
>  drivers/scsi/qla2xxx/qla_isr.c | 12 ++++++++++++
>  3 files changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
> index e5500bba06ca..88a56e8480f7 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.c
> +++ b/drivers/scsi/qla2xxx/qla_dbg.c
> @@ -2519,12 +2519,6 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
>  /*                         Driver Debug Functions.                          */
>  /****************************************************************************/
>  
> -static inline int
> -ql_mask_match(uint level)
> -{
> -	return (level & ql2xextended_error_logging) == level;
> -}
> -
>  /*
>   * This function is for formatting and logging debug information.
>   * It is to be used when vha is available. It formats the message
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
> index bb01b680ce9f..433e95502808 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.h
> +++ b/drivers/scsi/qla2xxx/qla_dbg.h
> @@ -374,3 +374,9 @@ extern int qla24xx_dump_ram(struct qla_hw_data *, uint32_t, uint32_t *,
>  extern void qla24xx_pause_risc(struct device_reg_24xx __iomem *,
>  	struct qla_hw_data *);
>  extern int qla24xx_soft_reset(struct qla_hw_data *);
> +
> +static inline int
> +ql_mask_match(uint level)
> +{
> +	return (level & ql2xextended_error_logging) == level;
> +}
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index e7bad0bfffda..e40705d38cea 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1939,6 +1939,18 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
>  		inbuf = (uint32_t *)&sts->nvme_ersp_data;
>  		outbuf = (uint32_t *)fd->rspaddr;
>  		iocb->u.nvme.rsp_pyld_len = le16_to_cpu(sts->nvme_rsp_pyld_len);
> +		if (unlikely(iocb->u.nvme.rsp_pyld_len >
> +		    sizeof(struct nvme_fc_ersp_iu))) {
> +			if (ql_mask_match(ql_dbg_io)) {
> +				WARN_ONCE(1, "Unexpected response payload length %u.\n",
> +				    iocb->u.nvme.rsp_pyld_len);
> +				ql_log(ql_log_warn, fcport->vha, 0x5100,
> +				    "Unexpected response payload length %u.\n",
> +				    iocb->u.nvme.rsp_pyld_len);
> +			}
> +			iocb->u.nvme.rsp_pyld_len =
> +			    sizeof(struct nvme_fc_ersp_iu);
> +		}
>  		iter = iocb->u.nvme.rsp_pyld_len >> 2;
>  		for (; iter; iter--)
>  			*outbuf++ = swab32(*inbuf++);

v5
Reviewed-by: Ewan D. Milne <emilne@redhat.com>

