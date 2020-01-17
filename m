Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68FB3C33C9E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 19:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4062E2083E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 19:24:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="goKf066Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbgAQTY2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 14:24:28 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38986 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727115AbgAQTY1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Jan 2020 14:24:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579289066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wziT7/3btRIjeudAjW6U2gApWLnr7EIucXnNKacFzKc=;
        b=goKf066YVDgF/UrZHVLIkCywVoXTYdynoEw0yg70scYACc4weqe4xEVAG25qkUa/t38nH3
        CErXCfX69wRNti++B5NKQw0LKpTcYzCxyTH6FbivI0N9oONKE/GOPZ7IZOqajFXdn73LR1
        wTe8toxH/S66r9BD7/kO/FyYxia4dj8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-OzMAUuvVPpOdxfjiZDg8Vg-1; Fri, 17 Jan 2020 14:24:23 -0500
X-MC-Unique: OzMAUuvVPpOdxfjiZDg8Vg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFA0F107ACC5;
        Fri, 17 Jan 2020 19:24:21 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40F49675AF;
        Fri, 17 Jan 2020 19:24:21 +0000 (UTC)
Message-ID: <f77d7150db2bb429353e7f1db57e68b1390920ff.camel@redhat.com>
Subject: Re: [PATCH v2] qla2xxx: Fix unbound NVME response length
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Himanshu Madhani <hmadhani@marvell.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Date:   Fri, 17 Jan 2020 14:24:20 -0500
In-Reply-To: <20200115161243.19151-1-hmadhani@marvell.com>
References: <20200115161243.19151-1-hmadhani@marvell.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-01-15 at 08:12 -0800, Himanshu Madhani wrote:
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
> Changes from v1 -> v2
> 
> o Fixed the tag for stable. 
> o Removed logit which got spilled from other patch to prevent compile failure.
> 
> Thanks,
> Himanshu
> ---
>  drivers/scsi/qla2xxx/qla_isr.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index e7bad0bfffda..36ea934da1a0 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1939,6 +1939,14 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
>  		inbuf = (uint32_t *)&sts->nvme_ersp_data;
>  		outbuf = (uint32_t *)fd->rspaddr;
>  		iocb->u.nvme.rsp_pyld_len = le16_to_cpu(sts->nvme_rsp_pyld_len);
> +		if (unlikely(iocb->u.nvme.rsp_pyld_len > 32)) {
> +			WARN_ONCE(1, "Unexpected response payload length %u.\n",
> +					iocb->u.nvme.rsp_pyld_len);
> +			ql_log(ql_log_warn, fcport->vha, 0x5100,
> +				"Unexpected response payload length %u.\n",
> +				iocb->u.nvme.rsp_pyld_len);
> +			iocb->u.nvme.rsp_pyld_len = 32;
> +		}
>  		iter = iocb->u.nvme.rsp_pyld_len >> 2;
>  		for (; iter; iter--)
>  			*outbuf++ = swab32(*inbuf++);

Please see Bart's comment on the earlier version of this patch
regarding using a symbolic value for the maximum size instead of "32".

-Ewan



