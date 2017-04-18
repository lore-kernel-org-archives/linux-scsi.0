From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v3 0/4] Avoid that __scsi_remove_device() hangs
Date: Tue, 18 Apr 2017 15:40:16 +0000
Message-ID: <1492530014.2689.3.camel@sandisk.com>
References: <20170417173436.15555-1-bart.vanassche@sandisk.com>
         <63e7faf7-f4e7-9e5c-dad5-ec59032df698@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:43244 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756804AbdDRPkT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2017 11:40:19 -0400
In-Reply-To: <63e7faf7-f4e7-9e5c-dad5-ec59032df698@mellanox.com>
Content-Language: en-US
Content-ID: <9FD36D0DE6EBEE49BD5C885E05950EAC@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "israelr@mellanox.com" <israelr@mellanox.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2017-04-18 at 14:58 +0300, Israel Rukshin wrote:
> I tested those patches and I got a NULL dereference at sd_sync_cache_done=
().
> The test is unloading ib_srp while one port is down.
> The previous version worked fine.
>=20
> From the log:
> [  190.272412] BUG: unable to handle kernel NULL pointer dereference at=20
> 00000000000002f0
> [=A0=A0190.281102] IP: sd_sync_cache_done+0x1b/0x80 [sd_mod]

Hello Israel,

Thanks for testing. I assume that this data refers to the sd_printk() state=
ment?
That statement was executed properly in my tests. Anyway, I will leave out =
that
statement, retest and repost this patch series. There is a del_gendisk() ca=
ll in
sd just before the sd_shutdown() call so that means it's not safe to access=
 the
disk pointer from anywhere in sd_shutdown().

Bart.=
