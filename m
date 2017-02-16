From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH 00/10] mpt3sas: full mq support
Date: Thu, 16 Feb 2017 16:15:05 +0530
Message-ID: <0c659c1cd2e47ca8e0abf72f56b9d000@mail.gmail.com>
References: <1485854760-122683-1-git-send-email-hare@suse.de>
 <20170131100243.GA1811@lst.de> <9a9d5acd-5f51-ad5b-7364-1d7549c040fd@suse.de>
 <e8d8dbf8dc2fa11b85a90211f2298b20@mail.gmail.com> <255dbb75-9ebd-0c7b-486e-e6fec772b8ca@suse.de>
 <41a4fdd78121e86e13dc874127b0b956@mail.gmail.com> <3e50cfdc-c330-4241-5ac3-a8f2ef5f77b4@suse.de>
 <CAK=zhgqjmpOS7M3WOsC+yUMRiw+y6H0sP2Hca9tuCyM19sAR8Q@mail.gmail.com>
 <1d7e8757-4b25-3f09-77ec-a286e83d3d73@suse.de> <CAK=zhgqBH3YJTo-PJF5nN9futQ-LWjVzAUji9xC_rWO5EA=_+g@mail.gmail.com>
 <4747beb1-0c16-171d-ab39-2e1a4692ba19@suse.de> <CAK=zhgqQ2x5d9Mzo89V95WS8SB0Xqyw4YtL4=cAr_PEv6GS1gQ@mail.gmail.com>
 <2770c802-b8b2-9035-c760-c5b970a9bd99@suse.de> <CAK=zhgqiCh+5tD+kHD15Xef5MnJM0SG=LaP=+cM-40VtMSH7Ew@mail.gmail.com>
 <01e426acae471cf8e599a5100bc8d409@mail.gmail.com> <e34535df-ab24-bf52-579f-faeca8c9c9d4@suse.de>
 <3d257aa567a9a3e0081ca342aaf7c354@mail.gmail.com> <b456fe10-9553-4f0d-9f00-0f0e0fc6210f@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:33722 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752688AbdBPKpH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2017 05:45:07 -0500
Received: by mail-qt0-f180.google.com with SMTP id v23so10553968qtb.0
        for <linux-scsi@vger.kernel.org>; Thu, 16 Feb 2017 02:45:07 -0800 (PST)
In-Reply-To: <b456fe10-9553-4f0d-9f00-0f0e0fc6210f@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>

> > - Later we can explore if nr_hw_queue more than one really add benefit.
> > From current limited testing, I don't see major performance boost if
> > we have nr_hw_queue more than one.
> >
> Well, the _actual_ code to support mq is rather trivial, and really serves
> as a
> good testbed for scsi-mq.
> I would prefer to leave it in, and disable it via a module parameter.

I am thinking as adding extra code for more than one nr_hw_queue will add
maintenance overhead and support. Especially IO error handling code become
complex with nr_hw_queues > 1 case.  If we really like to see performance
boost, we should attempt and bare other side effect.

For time being we should drop this nr_hw_queue > 1 support is what I choose
(not even module parameter base).

>
> But in either case, I can rebase the patches to leave any notions of
> 'nr_hw_queues' to patch 8 for implementing full mq support.

Thanks Hannes. It was just heads up...We are not sure when we can submit
upcoming patch set from Broadcom. May be we can syncup with you offline in
case any rebase requires.

>
> And we need to discuss how to handle MPI2_FUNCTION_SCSI_IO_REQUEST;
> the current method doesn't work with blk-mq.
> I really would like to see that go, especially as sg/bsg supports the same
> functionality ...
>
