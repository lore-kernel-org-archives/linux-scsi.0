From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: Re: [PATCH] scsi: mpt2sas: mpt2sas_base.c: Fix for possible null
 pointer dereference
Date: Thu, 3 Jul 2014 20:45:18 +0200
Message-ID: <CAFo99gaJ1oyXjAmiWCXBitBUe-G6a+4eHxHPSnv5h-+We7zv3Q@mail.gmail.com>
References: <1400429439-11184-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140528112628.GB11953@infradead.org>
	<alpine.DEB.2.02.1407031331520.9641@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:58377 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaGCSpU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2014 14:45:20 -0400
Received: by mail-oa0-f50.google.com with SMTP id n16so692521oag.37
        for <linux-scsi@vger.kernel.org>; Thu, 03 Jul 2014 11:45:19 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.02.1407031331520.9641@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Christoph Hellwig <hch@infradead.org>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, "James E.J. Bottomley" <JBottomley@parallels.com>, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

2014-07-03 19:45 GMT+02:00 Joe Lawrence <joe.lawrence@stratus.com>:
> On Wed, 28 May 2014, Christoph Hellwig wrote:
>
>> > -   ioc_status = le16_to_cpu(mpi_reply->IOCStatus) & MPI2_IOCSTATUS_MASK;
>> > +   if (mpi_reply) {
>> > +           ioc_status = le16_to_cpu(mpi_reply->IOCStatus) & MPI2_IOCSTATUS_MASK;
>> > +   }
>> >
>> >     if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
>> >             ioc->port_enable_failed = 1;
>>
>> ioc_status isn't initialized without the reply and used here as well
>> as later in the function.  I think we'll need input from LSI or others
>> with the spec on what to do when we didn't get a reply.
>
> Any update on this?
>
> The mpt3 version checks for !mpi_reply and returns 1.  Which leads to
> another question -- should mpt{2,3}sas_port_enable_done ever return 0 (as their
> respective comments describe)?
>
> Regards,
>
> -- Joe


Hi

Good questions Joe!
And good someone else brought this up, because I guess it's not meant to me.

And it looks however now that I've done quite a few more patches that
there should not have been any {}
And then, it is perhaps good to sett a start value for ioc_status. My
suggestion is:

u16 ioc_status = MPI2_IOCSTATUS_OP_STATE_NOT_SUPPORTED;


Kind regards
Rickard Strandqvist
