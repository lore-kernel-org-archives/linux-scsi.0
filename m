From: shailesh parulekar <shailesh.parulekar@gmail.com>
Subject: Re: struct scsi_cmnd --> underflow
Date: Wed, 30 Jun 2010 12:38:50 +0530
Message-ID: <AANLkTimyBMpIswls4gIRYalnBVasFQgpRcOQ4-pwFnaT@mail.gmail.com>
References: <AANLkTilsQ_VMArZPCOnWge2gjxRrJbcwq0FxTsaRamxx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39472 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab0F3HIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jun 2010 03:08:51 -0400
Received: by pwj8 with SMTP id 8so137298pwj.19
        for <linux-scsi@vger.kernel.org>; Wed, 30 Jun 2010 00:08:50 -0700 (PDT)
In-Reply-To: <AANLkTilsQ_VMArZPCOnWge2gjxRrJbcwq0FxTsaRamxx@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Sorry for resending (fixed a typo on prev mail) - Can someone please
reply to this?

On Tue, Jun 29, 2010 at 6:27 PM, shailesh parulekar
<shailesh.parulekar@gmail.com> wrote:
> Hi,
>
> I am writing a SCSI LLD and have a query regarding handling of underf=
low errors.
>
> In function sd_prep_fn (sd.c) the code populates scsi command pointer
> (SCpnt) and it's cmnd.
> Going ahead it also sets the total length to be transferred in the
> scsi data buffer (SCpnt->sdb.length =3D this_count * sdp->sector_size=
).
> Here 'this_count' looks to be the nr_sectors. This assignment looks
> fine too.
> But later when assigning the 'underflow' field of SCpnt, the
> assignment uses a hard-coded bit shift (SCpnt->underflow =3D this_cou=
nt
> << 9). Is this valid? OR
> should it be: SCpnt->underflow =3D this_count *=A0sdp->sector_size?
>
> So, if the sector size exported by the target device is greater than
> 512 (4K in our case), the SCpnt->underflow is not same as
> SCpnt->sdb.length. The later is 8 times bigger. So if I get a read of
> say 8K the 'underflow' is set only to 1K. Now, if the target say
> returns only 2K of data for this read, the amount of data transferred
> is not less than residual (1K in this case). So is the LLD not
> supposed to return (DID_ERROR << 16) in 'result' for this case
> (assuming target returns result =3D=3D GOOD)?
>
> Please let me know.
>
> thanks,
> --shailesh
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
