From: Shivasharan Srikanteshwara
        <shivasharan.srikanteshwara@broadcom.com>
Subject: RE: [PATCH V2] megaraid: kmemleak: Track page allocation for fusion
Date: Mon, 25 Sep 2017 13:38:23 +0530
Message-ID: <a2ebb72c902c9bd33c0af4ccd7299888@mail.gmail.com>
References: <20170915052152.5032-1-shuwang@redhat.com> <20170915180007.GA24045@infradead.org>
 <f582abfe99a5a00f876d5bbefdb306fe@mail.gmail.com> <20170918162135.GA20366@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:51842 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933136AbdIYIsp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Sep 2017 04:48:45 -0400
Received: by mail-wr0-f174.google.com with SMTP id z39so6438301wrb.8
        for <linux-scsi@vger.kernel.org>; Mon, 25 Sep 2017 01:48:45 -0700 (PDT)
In-Reply-To: <20170918162135.GA20366@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: shuwang@redhat.com, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chuhu@redhat.com, yizhan@redhat.com, catalin.marinas@arm.com

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Monday, September 18, 2017 9:52 PM
> To: Shivasharan Srikanteshwara
> Cc: Christoph Hellwig; shuwang@redhat.com; Kashyap Desai; Sumit Saxena;
> jejb@linux.vnet.ibm.com; martin.petersen@oracle.com;
> PDL,MEGARAIDLINUX; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org; chuhu@redhat.com; yizhan@redhat.com;
> catalin.marinas@arm.com
> Subject: Re: [PATCH V2] megaraid: kmemleak: Track page allocation for
fusion
>
> Oh, I missed log_to_span.  Well, in that case log_to_span is _the_
candidate
> for moving into a separate allocation.
>
> And in fact you're probably better off by using a sensible data
structure for it,
> e.g. a radix tree.

Thanks Christoph.
We will make the changes suggested in phased approach.
First we will fix kmemleak false positives by moving log_to_span
allocation separate from fusion_context.
The data structure change would involve major changes which affects IO
path as well.
Also driver expects log_to_span and other data structures to be available
at load time itself. Considering this, we need to understand if radix tree
would be a good choice for the change.
Based on internal discussions, we see other similar arrays in driver code
that we can change similarly eg. load_balance_info.
This is definitely something to add to our to-do lists.
These changes need to go through our internal regression test cycle and
then submit it to upstream.

Best regards,
Shivasharan
