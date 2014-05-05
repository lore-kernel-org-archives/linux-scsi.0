From: =?UTF-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Subject: Re: [PATCH v1.1 2/16] arcmsr: Adding code to support MSI-X interrupt
Date: Mon, 5 May 2014 18:43:53 +0800
Message-ID: <CAKiknE8i5ov3RfGaUjnNmZj1FuouYS3cP5q5CAGfwC82wX3NZw@mail.gmail.com>
References: <1399279631.18695.27.camel@localhost>
	<20140505102830.GN4963@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:55194 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222AbaEEKny (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 May 2014 06:43:54 -0400
Received: by mail-we0-f178.google.com with SMTP id u56so6505098wes.9
        for <linux-scsi@vger.kernel.org>; Mon, 05 May 2014 03:43:53 -0700 (PDT)
In-Reply-To: <20140505102830.GN4963@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: James Bottomley <jbottomley@parallels.com>, Tomas Henzl <thenzl@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi Dan,

Thanks for correcting this bug.

Regards,
Ching

2014-05-05 18:28 GMT+08:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Mon, May 05, 2014 at 04:47:11PM +0800, ching wrote:
>> +static int
>> +arcmsr_request_irq(struct pci_dev *pdev, struct AdapterControlBlock *acb)
>> +{
>> +     int     i, j, r;
>> +     struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];
>> +
>> +     if (!pci_find_capability(pdev, PCI_CAP_ID_MSIX))
>> +             goto msi_int;
>> +     for (i = 0; i < ARCMST_NUM_MSIX_VECTORS; i++)
>> +             entries[i].entry = i;
>> +     r = pci_enable_msix(pdev, entries, ARCMST_NUM_MSIX_VECTORS);
>> +     if (r < 0)
>> +             goto msi_int;
>> +     if (r == 0) {
>> +             for (i = 0; i < ARCMST_NUM_MSIX_VECTORS; i++) {
>> +                     if (request_irq(entries[i].vector,
>> +                             arcmsr_do_interrupt, 0, "arcmsr", acb)) {
>> +                             pr_warn("arcmsr%d: request_irq =%d failed!\n",
>> +                                     acb->host->host_no, pdev->irq);
>> +                             for (j = 0 ; j < i ; j++)
>> +                                     free_irq(entries[i].vector, acb);
>
> This is a bug here.  Sorry for not noticing the first time I reviewed
> this patch.  It should be "j" instead of "i" in
> free_irq(entries[i].vector, acb);.
>
>> +                             pci_disable_msix(pdev);
>> +                             goto msi_int;
>> +                     }
>> +                     acb->entries[i] = entries[i];
>> +             }
>> +             acb->acb_flags |= ACB_F_MSIX_ENABLED;
>> +             pr_info("arcmsr%d: msi-x enabled\n", acb->host->host_no);
>> +             return ARC_SUCCESS;
>> +     } else {
>> +             if (pci_enable_msix(pdev, entries, r))
>> +                     goto msi_int;
>> +             for (i = 0; i < r; i++) {
>> +                     if (request_irq(entries[i].vector,
>> +                             arcmsr_do_interrupt, 0, "arcmsr", acb)) {
>> +                             pr_warn("arcmsr%d: request_irq =%d failed!\n",
>> +                                     acb->host->host_no, pdev->irq);
>> +                             for (j = 0 ; j < i ; j++)
>> +                                     free_irq(entries[i].vector, acb);
>
> The same thing here.
>
> But otherwise so far as style goes this function is a lot better in
> this version.  Thanks.  Also the patchset is split up nicely into
> patches which do one thing per patch so that's nice as well.
>
> regards,
> dan carpenter
>
