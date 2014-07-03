From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH 3/4] megaraid_sas: Fix LD/VF affiliation parsing
Date: Thu, 3 Jul 2014 16:17:59 -0700
Message-ID: <CAHtARFFxzYPkMi=ePxbWpRUsTR3Om2rJ2b34-y31ZJg4evPQgg@mail.gmail.com>
References: <1404173998-24363-1-git-send-email-aradford@gmail.com>
	<1404173998-24363-4-git-send-email-aradford@gmail.com>
	<20140703081801.GA22818@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:54784 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaGCXR7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2014 19:17:59 -0400
Received: by mail-qa0-f43.google.com with SMTP id k15so762950qaq.16
        for <linux-scsi@vger.kernel.org>; Thu, 03 Jul 2014 16:17:59 -0700 (PDT)
In-Reply-To: <20140703081801.GA22818@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com

On Thu, Jul 3, 2014 at 1:18 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Jun 30, 2014 at 05:19:57PM -0700, Adam Radford wrote:
>> James/linux-scsi,
>>
>> The following patch for megaraid_sas fixes the LD/VF affiliation policy parsing code to account for LD targetId's and Hidden LD's (not yet affiliated with any Virtual Functions).
>
> Hi Adam,
>
> this doesn't address Martins comment about removing the initial != 0
> case.  And while we're at it there basically is no significant shared
> code between the PlasmaFW111 and !PlasmaFW111, so split these into
> two different functions.  With those two levels of indentation removed
> the code might actually become readable, too.
>
> Also please remove the "James/linux-scsi," address in the individual
> patches, that's something that should just go into the cover letter,
> and make sure to include all "Reviewed-by:" and "Acked-by:" tags when
> resending already reviewd patches.
>
> Thanks,
>         Christoph

Christoph,

Thanks for your and Martin's feedback.

Actually there is a missing call to megasas_get_ld_vf_affiliation()
with initial = 1 that should be at the bottom of megasas_probe_one().
This got dropped inadvertently during a manual merge.  I will add that
and split the megasas_get_ld_vf_affiliation() function into 2
functions (as you suggested) and resubmit the patch series while
including all currently received "Reviewed-by" and "Acked-by" messages
for the other patches and dropping the "James/linux-scsi" text.

-Adam
