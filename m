Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA028C33C9E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 22:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B75E21D7D
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 22:16:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZR2baJZC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgAQWQt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 17:16:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29105 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726942AbgAQWQs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2020 17:16:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579299407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k6MfOyBBjUHItZQ8gyEUGTAVRn0FcZr0WwPV8jaPivI=;
        b=ZR2baJZCiENbcWgL0cHQ2lR2Tb+vtHv9GHQ0r6B4nKqhOkv0/KOO/ZTDBA/J67LXrG71MZ
        CRlJVk5zYljlUUmc8EgFU4DS98468nuB+fqScvi5LtvkkA0hPLSMRzIkdekCFNY+4Yj54d
        WgmcVMFFynC5KS0mEBbQo3jl/FnI470=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-ugdCllB5P-aC68RJRndeDg-1; Fri, 17 Jan 2020 17:16:43 -0500
X-MC-Unique: ugdCllB5P-aC68RJRndeDg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38BD8107ACC5;
        Fri, 17 Jan 2020 22:16:42 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 71FB4845B4;
        Fri, 17 Jan 2020 22:16:41 +0000 (UTC)
Message-ID: <82a754f713114341a95b19557b5645cd468b9a9a.camel@redhat.com>
Subject: Re: [PATCH v3] qla2xxx: Fix unbound NVME response length
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Himanshu Madhani <hmadhani@marvell.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Date:   Fri, 17 Jan 2020 17:16:40 -0500
In-Reply-To: <20200117203126.4738-1-hmadhani@marvell.com>
References: <20200117203126.4738-1-hmadhani@marvell.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2020-01-17 at 12:31 -0800, Himanshu Madhani wrote:
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
>  drivers/scsi/qla2xxx/qla_isr.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index e7bad0bfffda..2f26f8910d0b 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1939,6 +1939,15 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
>  		inbuf = (uint32_t *)&sts->nvme_ersp_data;
>  		outbuf = (uint32_t *)fd->rspaddr;
>  		iocb->u.nvme.rsp_pyld_len = le16_to_cpu(sts->nvme_rsp_pyld_len);
> +		if (unlikely(iocb->u.nvme.rsp_pyld_len > 32)) {

I think this should have been "> sizeof(struct nvme_fc_ersp_iu)" as well.

-Ewan

> +			WARN_ONCE(1, "Unexpected response payload length %u.\n",
> +					iocb->u.nvme.rsp_pyld_len);
> +			ql_log(ql_log_warn, fcport->vha, 0x5100,
> +				"Unexpected response payload length %u.\n",
> +				iocb->u.nvme.rsp_pyld_len);
> +			iocb->u.nvme.rsp_pyld_len =
> +			    sizeof(struct nvme_fc_ersp_iu);
> +		}
>  		iter = iocb->u.nvme.rsp_pyld_len >> 2;
>  		for (; iter; iter--)
>  			*outbuf++ = swab32(*inbuf++);

