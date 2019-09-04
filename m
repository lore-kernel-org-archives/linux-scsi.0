Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63300C3A5A9
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 12:09:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 476C72339E
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 12:09:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729803AbfIDMJX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 08:09:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33982 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729597AbfIDMJW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Sep 2019 08:09:22 -0400
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8BD342CE95A
        for <linux-scsi@vger.kernel.org>; Wed,  4 Sep 2019 12:09:22 +0000 (UTC)
Received: by mail-oi1-f198.google.com with SMTP id k185so2051690oih.1
        for <linux-scsi@vger.kernel.org>; Wed, 04 Sep 2019 05:09:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EBLnUfaAtvpON2iaBFPpt0UNo0Lp+9e8PyvtjqjIkBo=;
        b=axv/8WJgBp1Ga72b/5/mO7Dj/ziDisdBZOt3KWEuu7kfM2ALfxsLtV/767ctSS1lnh
         ixhLnQnq/deOjBxCneLw4dCn1NhZyGbsNSYV0HkZhw4JDg6e4ootoKB2PdlSddLk9MJb
         LhAvnLm30OEQdEzGhsYUpCC+fVcVySqvSaAAdGuf8hFBNVyvCjg7K3bshyI/7UCHkURY
         jxaG/bqDkoOpLWBxl30VWU8i+R6U+JwdsueCGvJDbr552gmhcWGpGJ4JgEiICDoOh4y1
         OVaks/ebib/76SKVHKC9SKabSkGiLfF2oNezxnFJ64uXDDaW5Qe4zq49dyw7lbyLXOnN
         TLOA==
X-Gm-Message-State: APjAAAUOvWDlHACaGc6MgMN6SfxxQhRYhDV6/6E8LbUz/86ZGpX7UMW0
        NkJ9lT6qRC6VtS1BXsJ4RNWpVzIkkF8SEJc0uczspQh7MvJNbbyURHZEqsMpM+ui13LaDLzsrGs
        5rUEB+ijZyj9w54m9ubK5sVKtlcwcCw/7MOh7MQ==
X-Received: by 2002:a9d:404a:: with SMTP id o10mr3738190oti.94.1567598961943;
        Wed, 04 Sep 2019 05:09:21 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwWXUEuBf3lisKNAzBv9cywSE5x6C0KQ71edplmE4UCiDJ88Cj9cXKSgpOakBPycQVqSXgSfw8TXdQBoxFdCe0=
X-Received: by 2002:a9d:404a:: with SMTP id o10mr3738176oti.94.1567598961785;
 Wed, 04 Sep 2019 05:09:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190827211340.1095-1-gvaradar@cisco.com>
In-Reply-To: <20190827211340.1095-1-gvaradar@cisco.com>
From:   John Pittman <jpittman@redhat.com>
Date:   Wed, 4 Sep 2019 08:09:11 -0400
Message-ID: <CA+RJvhxYHR+ey1wz+mRCL+aufdi3+ox4uUYRge_kLh1MFTV4zg@mail.gmail.com>
Subject: Re: [PATCH] scsi: fnic: fix msix interrupt allocation
To:     Govindarajulu Varadarajan <gvaradar@cisco.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, Satish Kharat <satishkh@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin, would you have a quick look at this one when you get a
moment?  Bugging you for selfish reasons as I'm trying to get this
included in the next RHEL release.  Thanks for any info.

On Tue, Aug 27, 2019 at 5:20 PM Govindarajulu Varadarajan
<gvaradar@cisco.com> wrote:
>
> pci_alloc_irq_vectors() returns number of vectors allocated.
> Fix the check for error condition.
>
> Fixes: cca678dfbad49 ("scsi: fnic: switch to pci_alloc_irq_vectors")
> Acked-by: Satish Kharat <satishkh@cisco.com>
> Signed-off-by: Govindarajulu Varadarajan <gvaradar@cisco.com>
> ---
>  drivers/scsi/fnic/fnic_isr.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/fnic/fnic_isr.c b/drivers/scsi/fnic/fnic_isr.c
> index da4602b63495..2fb2731f50fb 100644
> --- a/drivers/scsi/fnic/fnic_isr.c
> +++ b/drivers/scsi/fnic/fnic_isr.c
> @@ -254,7 +254,7 @@ int fnic_set_intr_mode(struct fnic *fnic)
>                 int vecs = n + m + o + 1;
>
>                 if (pci_alloc_irq_vectors(fnic->pdev, vecs, vecs,
> -                               PCI_IRQ_MSIX) < 0) {
> +                               PCI_IRQ_MSIX) == vecs) {
>                         fnic->rq_count = n;
>                         fnic->raw_wq_count = m;
>                         fnic->wq_copy_count = o;
> @@ -280,7 +280,7 @@ int fnic_set_intr_mode(struct fnic *fnic)
>             fnic->wq_copy_count >= 1 &&
>             fnic->cq_count >= 3 &&
>             fnic->intr_count >= 1 &&
> -           pci_alloc_irq_vectors(fnic->pdev, 1, 1, PCI_IRQ_MSI) < 0) {
> +           pci_alloc_irq_vectors(fnic->pdev, 1, 1, PCI_IRQ_MSI) == 1) {
>                 fnic->rq_count = 1;
>                 fnic->raw_wq_count = 1;
>                 fnic->wq_copy_count = 1;
> --
> 2.21.0
>
