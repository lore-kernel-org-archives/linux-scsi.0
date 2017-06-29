From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH 13/47] megaraid: pass in NULL scb for host reset
Date: Thu, 29 Jun 2017 13:21:18 +0530
Message-ID: <d2a8ef7e708fa3b015a83bd6aaa69613@mail.gmail.com>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
 <1498638793-44672-14-git-send-email-hare@suse.de> <f5b7e09b259b22452afe1da669712af6@mail.gmail.com>
 <ce2005d3-420c-3920-dadc-b9d1d36c8ecc@suse.de> <5443ed26d0465a0a277ccf90fdeb1e73@mail.gmail.com>
 <30c84194-89ca-70ca-0bf9-9b101a91b988@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:34637 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751684AbdF2HvU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jun 2017 03:51:20 -0400
Received: by mail-oi0-f53.google.com with SMTP id l130so5246209oib.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jun 2017 00:51:20 -0700 (PDT)
In-Reply-To: <30c84194-89ca-70ca-0bf9-9b101a91b988@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Kashyap Desai <kashyap.desai@broadcom.com>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, adam radford <aradford@gmail.com>

>-----Original Message-----
>From: Hannes Reinecke [mailto:hare@suse.de]
>Sent: Thursday, June 29, 2017 11:23 AM
>To: Kashyap Desai; Sumit Saxena; Christoph Hellwig
>Cc: Martin K. Petersen; James Bottomley; linux-scsi@vger.kernel.org; Hanne=
s
>Reinecke
>Subject: Re: [PATCH 13/47] megaraid: pass in NULL scb for host reset
>
>On 06/28/2017 07:40 PM, Kashyap Desai wrote:
>>> -----Original Message-----
>>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>>> owner@vger.kernel.org] On Behalf Of Hannes Reinecke
>>> Sent: Wednesday, June 28, 2017 9:00 PM
>>> To: Sumit Saxena; Christoph Hellwig
>>> Cc: Martin K. Petersen; James Bottomley; linux-scsi@vger.kernel.org;
>>> Hannes Reinecke
>>> Subject: Re: [PATCH 13/47] megaraid: pass in NULL scb for host reset
>>>
>>> On 06/28/2017 03:41 PM, Sumit Saxena wrote:
>>>>> -----Original Message-----
>>>>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>>>>> owner@vger.kernel.org] On Behalf Of Hannes Reinecke
>>>>> Sent: Wednesday, June 28, 2017 2:03 PM
>>>>> To: Christoph Hellwig
>>>>> Cc: Martin K. Petersen; James Bottomley;
>>>>> linux-scsi@vger.kernel.org;
>>>> Hannes
>>>>> Reinecke; Hannes Reinecke
>>>>> Subject: [PATCH 13/47] megaraid: pass in NULL scb for host reset
>>>>>
>>>>> When calling a host reset we shouldn't rely on the command
>>>>> triggering the reset, so allow megaraid_abort_and_reset() to be
>>>>> called with a NULL
>>> scb.
>>>>> And drop the pointless 'bus_reset' and 'target_reset' handlers,
>>>>> which
>>>> just call
>>>>> the same function as host_reset.
>>>>
>>>> If this patch address any functional issue, then we should consider
>>>> this.
>>>> If it's code optimization, can we ignore this as this is being very
>>>> old driver and no more maintained by Broadcom/LSI ?
>>>>
>>> Sadly, ignoring is not an option.
>>> I'm planning to update the calling convention for SCSI EH, to resolve
>>> the
>>> long-
>>> standing problem with sg_reset ioctls.
>>> sg_reset ioctl will allocate an out-of-band SCSI command, which does
>>> no longer work with the new command allocation scheme in multiqueue.
>>> So it's not possible to just 'ignore' it, as then SCSI EH will cease
>>> to function with that driver.
>>
>> Hannes - We are in process of sending megaraid and 3ware driver
>> removal as LSI/Broadcom  stopped supporting those products.
>> I agree we should review this closely, but lack of test coverage and
>> end of life cycle of product is requesting us to know the rational.
>> For now, let's consider NACK for this patch. We will be removing old
>> megaraid (mbox) driver and 3Ware drivers soon.
>>
>Hmm.
>Can't we do the removal now?
>There is not a lot of testing involved with _that_, surely?
>
>I'd be happy to do a patch if you like ...
We are fine with you submitting the patch to remove megaraid and megaraid_m=
m
drivers. 3ware drivers are maintained by Adam Radford so we can not remove
them.
>
>Cheers,
>
>Hannes
>--
>Dr. Hannes Reinecke		   Teamlead Storage & Networking
>hare@suse.de			               +49 911 74053 688
>SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
>GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton HRB =
21284
>(AG N=C3=BCrnberg)
