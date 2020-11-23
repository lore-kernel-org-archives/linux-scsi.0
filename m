Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C01D8C2D0E4
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 19:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55BE620717
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 19:52:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dza3WoYt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730765AbgKWTv4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 14:51:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55491 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730165AbgKWTv4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Nov 2020 14:51:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606161115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9Op5q5h1maZabc9drf102YJvjpMQlpdP8+Zo0oPA8pk=;
        b=Dza3WoYtfTFa1S8ELJ3UFXwYuu/NiyQJWqhmVrxVJDhvxLHvgcqVWw0q+mhXQrmw5j4yqc
        Bz1UpHBU6eMKAcvb37jj0HpRqzVhDlw0ny424/LqMtgAMTHqrOSqg1zbK8Cg8BM6odiiLk
        nu0VNi5GZKJ+jm/DA8beDvOUszcqm7k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-7zhSPQyVNLCtLl6ccthQMQ-1; Mon, 23 Nov 2020 14:51:44 -0500
X-MC-Unique: 7zhSPQyVNLCtLl6ccthQMQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA1E087951B;
        Mon, 23 Nov 2020 19:51:42 +0000 (UTC)
Received: from ovpn-112-111.phx2.redhat.com (ovpn-112-111.phx2.redhat.com [10.3.112.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CCDC60864;
        Mon, 23 Nov 2020 19:51:42 +0000 (UTC)
Message-ID: <a2809c58d049541117b8653c143faf19e2dc2398.camel@redhat.com>
Subject: Re: [PATCH v7 5/5] scsi:lpfc: Added support for eh_should_retry_cmd
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Hannes Reinecke <hare@suse.de>,
        Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com
Cc:     jsmart2021@gmail.com, mkumar@redhat.com
Date:   Mon, 23 Nov 2020 14:51:41 -0500
In-Reply-To: <d1c194a9-1b5c-c86c-e1f0-b3ced680f569@suse.de>
References: <1605070685-20945-1-git-send-email-muneendra.kumar@broadcom.com>
         <1605070685-20945-6-git-send-email-muneendra.kumar@broadcom.com>
         <d1c194a9-1b5c-c86c-e1f0-b3ced680f569@suse.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-11-16 at 09:23 +0100, Hannes Reinecke wrote:
> On 11/11/20 5:58 AM, Muneendra wrote:
> > Added support to handle eh_should_retry_cmd in lpfc_template.
> > 
> > Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> > 
> > ---
> > v7:
> > New patch
> > ---
> >   drivers/scsi/lpfc/lpfc_scsi.c | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/scsi/lpfc/lpfc_scsi.c
> > b/drivers/scsi/lpfc/lpfc_scsi.c
> > index 4ffdfd2c8604..dbc80e6423ea 100644
> > --- a/drivers/scsi/lpfc/lpfc_scsi.c
> > +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> > @@ -6040,6 +6040,7 @@ struct scsi_host_template lpfc_template = {
> >   	.info			= lpfc_info,
> >   	.queuecommand		= lpfc_queuecommand,
> >   	.eh_timed_out		= fc_eh_timed_out,
> > +	.eh_should_retry_cmd    = fc_eh_should_retry_cmd,
> >   	.eh_abort_handler	= lpfc_abort_handler,
> >   	.eh_device_reset_handler = lpfc_device_reset_handler,
> >   	.eh_target_reset_handler = lpfc_target_reset_handler,
> > 
> 
> I guess this change is pretty generic, and should be made to every
> FC 
> HBA driver. But probably not your immediate scope, I do agree :-)

Yes, I think this is better left to the other driver maintainers
as it should be tested if it is called via the host template.

-Ewan

> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> 
> Cheers,
> 
> Hannes

