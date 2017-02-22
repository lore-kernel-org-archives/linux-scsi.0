From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCHv2 0/5] SCSI EH cleanup
Date: Wed, 22 Feb 2017 19:44:26 +0000
Message-ID: <1D08B61A9CF0974AA09887BE32D889DA0ADA73@ULS-OP-MBXIP03.sdcorp.global.sandisk.com>
References: <1487779650-1338-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:58802 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755204AbdBVT4f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2017 14:56:35 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 02/22/2017 08:07 AM, Hannes Reinecke wrote:=0A=
> this is a resend of a small patchset for cleaning up SCSI EH.=0A=
> Primary goal is to make asynchronous aborts mandatory; there hasn't=0A=
> been a single report so far where asynchronous abort won't work, so=0A=
> the 'no_async_abort' flag has never been used and will be removed=0A=
> with this patchset.=0A=
> Additionally there's a cleanup for handle failed EH commands, and=0A=
> to detect retries of failed commands.=0A=
> =0A=
> As usual, comments and reviews are welcome.=0A=
=0A=
Hello Hannes,=0A=
=0A=
Supporting asynchronous aborts means that if no response is received for=0A=
an abort after a certain time that the abort has to be considered as=0A=
failed. A SCSI LLD may have to allocate resources before a TMF can be=0A=
sent (e.g. ib_srp has to do that). These resources have to be cleaned up=0A=
if a TMF times out. We don't want to see a TMF timeout handler in every=0A=
LLD that supports asynchronous aborts. So we need a TMF timeout handler=0A=
in the SCSI core. Have you considered to allocate a new SCSI request for=0A=
submitting a TMF instead of overwriting fields in an existing scsi_cmnd=0A=
structure? In that case we will be able to reuse the block layer timeout=0A=
handler.=0A=
=0A=
Something else I noticed is that the access of .eh_action in=0A=
scsi_eh_done() races with the shost->eh_action =3D NULL assigment in=0A=
scsi_send_eh_cmnd(). Shouldn't these accesses be protected by locking?=0A=
=0A=
Thanks,=0A=
=0A=
Bart.=0A=
