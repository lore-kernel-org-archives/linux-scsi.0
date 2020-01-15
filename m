Return-Path: <SRS0=obCF=3E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 858D4C33CB1
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jan 2020 16:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A85924679
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jan 2020 16:19:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CGusPGB2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgAOQT3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jan 2020 11:19:29 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42598 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726132AbgAOQT3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Jan 2020 11:19:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579105168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=69lWQ+lIgX2E86lMhAssSxs/h+2gwPLDUQPNeqzl4lM=;
        b=CGusPGB2r5Gu84kJVua4FEdhN3Qu+RMFa9JLL83PysdSANzrU6QHGV59Azn7jqgD982+9m
        ygzU/2NEaEeKzg9HRjydIBpX2VWd5XEXhXGNqlGkiRWwYfLWXdwskE3hc/zB2Qriw/isbd
        O5MJ5T/zsAXjutAbUDB1azqifQur6pA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-sA0UxlBUOquEITToUrx3hg-1; Wed, 15 Jan 2020 11:19:23 -0500
X-MC-Unique: sA0UxlBUOquEITToUrx3hg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4CBD198F433;
        Wed, 15 Jan 2020 16:19:21 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD37060BE0;
        Wed, 15 Jan 2020 16:19:20 +0000 (UTC)
Message-ID: <056684d63d04dd1573a00262ffcde8c4754e5d0c.camel@redhat.com>
Subject: Re: [PATCH] qla2xxx: Fix unbound NVME response length
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Date:   Wed, 15 Jan 2020 11:19:20 -0500
In-Reply-To: <97b53726-b26f-9074-a41c-eff4a6ec8613@acm.org>
References: <20200115024431.5421-1-hmadhani@marvell.com>
         <97b53726-b26f-9074-a41c-eff4a6ec8613@acm.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-01-15 at 08:12 -0800, Bart Van Assche wrote:
> On 1/14/20 6:44 PM, Himanshu Madhani wrote:
> > From: Arun Easi <aeasi@marvell.com>
> > 
> > On certain cases when response length is less than 32, NVME response data
> > is supplied inline in IOCB. This is indicated by some combination of state
> > flags. There was an instance when a high, and incorrect, response length was
> > indicated causing driver to overrun buffers. Fix this by checking and
> > limiting the response payload length.
> > 
> > Fixes: 7401bc18d1ee3 ("scsi: qla2xxx: Add FC-NVMe command handling")
> > Cc: stable@vger.kernel.com
> > Signed-off-by: Arun Easi <aeasi@marvell.com>
> > Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> > ---
> > Hi Martin,
> > 
> > We discovered issue with our newer Gen7 adapter when response length
> > happens to be larger than 32 bytes, could result into crash.
> > 
> > Please apply this to 5.5/scsi-fixes branch at your earliest convenience.
> > 
> > Thanks,
> > Himanshu
> > ---
> >   drivers/scsi/qla2xxx/qla_isr.c | 9 +++++++++
> >   1 file changed, 9 insertions(+)
> > 
> > diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> > index e7bad0bfffda..90e816d13b0e 100644
> > --- a/drivers/scsi/qla2xxx/qla_isr.c
> > +++ b/drivers/scsi/qla2xxx/qla_isr.c
> > @@ -1939,6 +1939,15 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
> >   		inbuf = (uint32_t *)&sts->nvme_ersp_data;
> >   		outbuf = (uint32_t *)fd->rspaddr;
> >   		iocb->u.nvme.rsp_pyld_len = le16_to_cpu(sts->nvme_rsp_pyld_len);
> > +		if (unlikely(iocb->u.nvme.rsp_pyld_len > 32)) {
> > +			WARN_ONCE(1, "Unexpected response payload length %u.\n",
> > +					iocb->u.nvme.rsp_pyld_len);
> > +			ql_log(ql_log_warn, fcport->vha, 0x5100,
> > +				"Unexpected response payload length %u.\n",
> > +				iocb->u.nvme.rsp_pyld_len);
> > +			iocb->u.nvme.rsp_pyld_len = 32;
> > +			logit = 1;
> > +		}
> >   		iter = iocb->u.nvme.rsp_pyld_len >> 2;
> >   		for (; iter; iter--)
> >   			*outbuf++ = swab32(*inbuf++);
> > 
> 
> Please change the constant '32' into sizeof(...) or into a symbolic name.

sizeof(struct nvme_fc_ersp_iu), it looks like.

-Ewan

> 
> Thanks,
> 
> Bart.
> 

