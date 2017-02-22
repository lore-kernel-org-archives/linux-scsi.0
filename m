From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCHv2 0/5] SCSI EH cleanup
Date: Wed, 22 Feb 2017 21:21:49 +0000
Message-ID: <1487798485.10204.1.camel@sandisk.com>
References: <1487779650-1338-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:21105 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933829AbdBVV0c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2017 16:26:32 -0500
In-Reply-To: <1487779650-1338-1-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <ECB0AF2FBC3D5749A902EE86C8473816@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jth@kernel.org" <jth@kernel.org>

On Wed, 2017-02-22 at 17:07 +0100, Hannes Reinecke wrote:
> this is a resend of a small patchset for cleaning up SCSI EH.
> Primary goal is to make asynchronous aborts mandatory; there hasn't
> been a single report so far where asynchronous abort won't work, so
> the 'no_async_abort' flag has never been used and will be removed
> with this patchset.
> Additionally there's a cleanup for handle failed EH commands, and
> to detect retries of failed commands.

An additional comment: I don't think it is safe to execute a host
reset while any asynchronous aborts are ongoing. I think the SCSI EH
will get really confused if after a host reset has been performed a
response is received from an asynchronous abort that was issued
before the host reset started. Although a SCSI target must not send
a LU RESET response before all previously submitted SCSI commands
and TMFs have finished, what prevents in e.g. a multipath topology
that an abort response and a LU RESET response are received out of
order?

Thanks,

Bart.=
