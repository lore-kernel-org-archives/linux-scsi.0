From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH] sd: read unmap block limits even if lbpme=0
Date: Thu, 17 Aug 2017 23:10:25 +0800
Message-ID: <CAGnHSEnMtQPL65Pas7jeFfmZvXPQV+wpS-48FR1nfeGf3pE-Jg@mail.gmail.com>
References: <59921282.c3341c0a.a8437.1b70@mx.google.com> <yq160dnndst.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:35565 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753136AbdHQPK0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2017 11:10:26 -0400
Received: by mail-qk0-f180.google.com with SMTP id 130so3439800qkg.2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2017 08:10:26 -0700 (PDT)
In-Reply-To: <yq160dnndst.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On 17 August 2017 at 10:11, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> Tom,
>
> I have to confess I'm wary of interpreting values reported by a device
> that messes up setting the single bit flag that enables the feature.
>

FWIW, this implementation in particular works pretty well as far as I
can tell. The values reported on the VPDs are sensical. You can see
that it advertises the same limit as the libata SATL does, which is
(65335 * 512 / 8) blocks.

Also I think it could not hurt anyway, because the scsi disk driver
would use SD_MAX_WS16_BLOCKS if the reported limit is larger, so it's
essentially a conservative thing to do.

Not to mention that if someone is determined to enable it on linux,
the limits reported in the VPD would most likely be the ones that the
he/she would want to start with.

>
> Before I entertain taking your patch I'd like to take a closer look to
> make sure everything is gated by sdkp->lbpme.
>

Sure take your time. Look forward to your favorable reply.

>
> However, instead of relying on UNMAP, does this bridge support WRITE
> SAME with the UNMAP bit? Because in that case you should be able to set
> provisioning_mode to WS10 or WS16 and then adjust max_write_same_blocks.
>

Nope, neither does it report a maximum write same length. Again, IIRC,
Windows does not support WRITE SAME with UNMAP bit set but only the
UNMAP command.

> --
> Martin K. Petersen      Oracle Linux Engineering
