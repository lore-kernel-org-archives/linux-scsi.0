From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: SCSI regression in 4.11
Date: Mon, 27 Feb 2017 17:19:31 -0800
Message-ID: <20170227171931.30b9f619@xeon-e3>
References: <20170227152955.1362aabb@xeon-e3>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:33208 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751419AbdB1BUS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2017 20:20:18 -0500
Received: by mail-pg0-f54.google.com with SMTP id 25so21521354pgy.0
        for <linux-scsi@vger.kernel.org>; Mon, 27 Feb 2017 17:19:39 -0800 (PST)
In-Reply-To: <20170227152955.1362aabb@xeon-e3>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Jens Axboe <axboe@kernel.dk>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com
Cc: linux-scsi@vger.kernel.org

On Mon, 27 Feb 2017 15:30:30 -0800
Stephen Hemminger <stephen@networkplumber.org> wrote:

> Something in SCSI in 4.11 broke booting on Hyper-V Generation 2 VM with 8=
 VCPU and 4G of memory.
> Both Linus's current tree (4.11 pre-rc1) and linux-next fail in a similar=
 manner. It looks like some error
> in SCSI device detection because there is only a single device.
>=20
> The offending commit causing the regression is:
>=20
> $ git bisect bad
> e9c787e65c0c36529745be47d490d998b4b6e589 is the first bad commit
> commit e9c787e65c0c36529745be47d490d998b4b6e589
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Mon Jan 2 21:55:26 2017 +0300
>=20
>     scsi: allocate scsi_cmnd structures as part of struct request
>    =20
>     Rely on the new block layer functionality to allocate additional driv=
er
>     specific data behind struct request instead of implementing it in SCSI
>     it=D1=95elf.
>    =20
>     Signed-off-by: Christoph Hellwig <hch@lst.de>
>     Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
>     Reviewed-by: Hannes Reinecke <hare@suse.com>
>     Signed-off-by: Jens Axboe <axboe@fb.com>
>=20
> :040000 040000 6ff016fcdae227efeb19c1c301b17ccd7ea35da6 70d79f99d9b79ecf4=
dccbe067fc697219f5c78da M	drivers
> :040000 040000 a672ff52df8b2c211b3f98cae4a88d8a96ccde0b 1aaaed7de0994f597=
c7f8290c722a0b4a7789429 M	include
>=20
> I checked and tree is current and up to date and includes=20
> commit ee5242360424b9b967454e9183767323d10cf985
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Tue Feb 21 10:04:55 2017 +0100
>=20
>     scsi: zero per-cmd driver data before each I/O
>=20
> Kernel config is attached. It started with Ubuntu config, but then did lo=
calmodconfig and pruned
> out unnecessary stuff.
>=20

This problem I am seeing looks like the one addressed by:

Fixes: ee5242360424 ("scsi: zero per-cmd driver data before each I/O")

but that is already in linux-next.

Noticed another place where memset(of the data was being done not the extra=
 bits.
Tried this, but didn't fix it either...


diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ba2286652ff6..7e0463e78ff4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1850,7 +1850,7 @@ static int scsi_mq_prep_fn(struct request *req)
=20
 	/* zero out the cmd, except for the embedded scsi_request */
 	memset((char *)cmd + sizeof(cmd->req), 0,
-		sizeof(*cmd) - sizeof(cmd->req));
+		sizeof(*cmd) - sizeof(cmd->req) + sdev->host->hostt->cmd_size);
=20
 	req->special =3D cmd;
=20
