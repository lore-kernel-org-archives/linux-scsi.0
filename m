From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: scsi LLD implementation question
Date: Fri, 25 Feb 2011 18:12:36 +0100
Message-ID: <AANLkTinzhNr7FtKW5LR6QJ3O3b_Xy50wN0tS+NRg4KL2@mail.gmail.com>
References: <AANLkTi=+6z4qRS7MGSNTyomtyQTu5A20iBF-T92xAPMA@mail.gmail.com> <1298641025.8617.63.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49166 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932664Ab1BYRNL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Feb 2011 12:13:11 -0500
Received: by vws12 with SMTP id 12so1535829vws.19
        for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2011 09:13:11 -0800 (PST)
In-Reply-To: <1298641025.8617.63.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Feb 25, 2011 at 2:37 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> Having a kthread process responses is generally not a good idea becau=
se
> completions will come in at interrupt level ... you need a context
> switch to get to a thread and this costs latency. =A0The idea of done
> processing in SCSI is to identify the scsi_cmnd as quickly as possibl=
e
> and post it. =A0All back end SCSI processing is done in the block sof=
tirq
> (a level between hard interrupt and user context), again to keep late=
ncy
> low. =A0That also means that the kthread architecture is wrong becaus=
e
> it's difficult for the kernel to go hardirq->user->softirq without
> adding an extra interrupt latency (usually a clock tick).
>
> If you want a "threaded" response in a multiqueue card using MSIs, th=
en
> you bind the MSIs to CPU groups and use the hardware interrupt contex=
t
> as the threading (I think drivers like lpfc already do this). =A0The =
best
> performance is actually observed when the MSI comes back in on the sa=
me
> CPU that issued the I/O because the cache is still hot. =A0The block =
keeps
> an rq->cpu to tag this which internal HBA setup can use for programmi=
ng
> MSI completions.

The above sounds like great advice if the processing time is
reasonably short. But what if the processing time can be anything
between e.g. a microsecond and twenty minutes ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
