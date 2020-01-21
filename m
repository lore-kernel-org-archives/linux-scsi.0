Return-Path: <SRS0=h99Q=3K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 661BAC2D0CE
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 08:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25602217F4
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 08:55:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="gOY95Wgw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgAUIzz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jan 2020 03:55:55 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:34539 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbgAUIzz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jan 2020 03:55:55 -0500
Received: by mail-ot1-f67.google.com with SMTP id a15so2276415otf.1
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jan 2020 00:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IU5Z/JCAExszHlIH/kdMNtsgCo8fxRM6luOGTgfMI7I=;
        b=gOY95WgwuPbrBPbcxN7Ch2jR7FY49ssT9WgYSOHiZuKpZBpLMG7dI4wvs9RTMfRckQ
         cZlGQ+j4pPgi2hI6SqiGSoI586uJ4Ui1YCB2hiejDYBljBMPDrLH58eYldax9PbDjJ+d
         4nGHQd8BLZsXoQiDOHdLfAyi3FOBbOpEGsTXU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IU5Z/JCAExszHlIH/kdMNtsgCo8fxRM6luOGTgfMI7I=;
        b=uBdGGy+O/DOQewiKgw1oodapS53ni9odoR49LvWBXWEq2yAkffVMcez2BqZANxn3Wq
         J2DZR4WuWqmHshBjLXRtAQRn0YKIhN26qH2y4ctODqDpKwtvN119HfdeSNuH1u9k5FEy
         xwZm80QJNJAw7xJ+huGbTzyVjAfvylW4z4SQ3FpcWNDD57ESi5D6qiv0qm9WDjS45J6a
         /R+tyRv5otVXASDvtxBjxi3lXdpQojM+Dstdv9rORed9TKySPCJrOQ6R90boAmjRsHZc
         StcOHUmOpYwdZY69QDkIALoRhLuiO1uhcyyLCY1TUQuO9GxPXpebwaLLB5ERViU72htX
         i4oA==
X-Gm-Message-State: APjAAAVUPsPHJPZvBLEUsIV2fwxVgF69cV2Mhc01fxsO1RuCbo/HJQdX
        5sbrK8j6PQe9kQ1yld7Cb1APXeuGZjLBp28d/QpI9A==
X-Google-Smtp-Source: APXvYqzQJCOEHKpMFlSC+i8dDnKxwhnJndo4feJjUc1YwPRIJFYgFYi6+WZ5ZcaGLSME1GwJUV34+ofVJzSPeLlh7XA=
X-Received: by 2002:a05:6830:1f13:: with SMTP id u19mr2664405otg.237.1579596954686;
 Tue, 21 Jan 2020 00:55:54 -0800 (PST)
MIME-Version: 1.0
References: <20200117134506.633586-1-hch@lst.de> <yq1h80piecs.fsf@oracle.com>
In-Reply-To: <yq1h80piecs.fsf@oracle.com>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Tue, 21 Jan 2020 14:25:42 +0530
Message-ID: <CAK=zhgqgCOZ1x1e_gK2arcj63AcVj8XGvXn4=tEP_SdkLV-adQ@mail.gmail.com>
Subject: Re: [PATCH] mpt3sas: don't change the dma coherent mask after allocations
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        abdhalee@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 21, 2020 at 10:40 AM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> [Adding Sreekanth]
>
> > The DMA layer does not allow changing the DMA coherent mask after
> > there are outstanding allocations.  Stop doing that and always
> > use a 32-bit coherent DMA mask in mpt3sas.
>
> Broadcom: Please review!

Sure Martin, I will complete the review by this Friday.

Thanks,
Sreekanth

>
> --
> Martin K. Petersen      Oracle Linux Engineering
