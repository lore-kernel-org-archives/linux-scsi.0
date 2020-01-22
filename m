Return-Path: <SRS0=vnQa=3L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35E2DC32771
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 21:24:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 014A021835
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 21:24:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fOa+1RFc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgAVVYD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 16:24:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37425 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725827AbgAVVYD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2020 16:24:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579728242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CFpsGX9S5YwFPvHbixftGN5Jgcsw6azfIyHve2j3IJo=;
        b=fOa+1RFci/0yMoId5Esbiy9hb8JJ0+p42Egn2+jdfl1mgyxCmLDEnqlJY1KJH0UqBK6iYY
        LmfXm1icDpbv3HlQAwZnEYhO0o4LeMtj8SgB4AwFEMayCWjN3qcnM+X94CT2kRhHYgnmpo
        OMVE0E5tcY6QiPeQRxrlfIUbHmlF5VU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-iNRL4wpGNp2B8vg0b7vzpA-1; Wed, 22 Jan 2020 16:23:58 -0500
X-MC-Unique: iNRL4wpGNp2B8vg0b7vzpA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56B3A18A8C86;
        Wed, 22 Jan 2020 21:23:57 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C401C5D9C9;
        Wed, 22 Jan 2020 21:23:56 +0000 (UTC)
Message-ID: <15b378f9e599d45e812822d59c154032f4be56cb.camel@redhat.com>
Subject: Re: [PATCH v4] qla2xxx: Fix unbound NVME response length
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Himanshu Madhani <hmadhani@marvell.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Date:   Wed, 22 Jan 2020 16:23:56 -0500
In-Reply-To: <20200121192710.32314-1-hmadhani@marvell.com>
References: <20200121192710.32314-1-hmadhani@marvell.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-01-21 at 11:27 -0800, Himanshu Madhani wrote:
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
>  drivers/scsi/qla2xxx/qla_isr.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index e7bad0bfffda..4caec94d8e99 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1939,6 +1939,16 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
>  		inbuf = (uint32_t *)&sts->nvme_ersp_data;
>  		outbuf = (uint32_t *)fd->rspaddr;
>  		iocb->u.nvme.rsp_pyld_len = le16_to_cpu(sts->nvme_rsp_pyld_len);
> +		if (unlikely(iocb->u.nvme.rsp_pyld_len >
> +		    sizeof(struct nvme_fc_ersp_iu))) {
> +			WARN_ONCE(1, "Unexpected response payload length %u.\n",
> +			    iocb->u.nvme.rsp_pyld_len);
> +			ql_log(ql_log_warn, fcport->vha, 0x5100,
> +			    "Unexpected response payload length %u.\n",
> +			    iocb->u.nvme.rsp_pyld_len);
> +			iocb->u.nvme.rsp_pyld_len =
> +			    sizeof(struct nvme_fc_ersp_iu);
> +		}
>  		iter = iocb->u.nvme.rsp_pyld_len >> 2;
>  		for (; iter; iter--)
>  			*outbuf++ = swab32(*inbuf++);

Thanks.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


