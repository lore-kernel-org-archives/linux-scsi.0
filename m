From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2] scsi_sysfs: fix hang when removing scsi device
Date: Sat, 18 Mar 2017 00:05:10 +0000
Message-ID: <1489795496.2826.25.camel@sandisk.com>
References: <1489077442-20610-1-git-send-email-israelr@mellanox.com>
         <1489088191.2597.9.camel@sandisk.com>
         <22efc8bd-ae71-14c7-247b-7399bfd28c6d@mellanox.com>
         <1489430936.2658.9.camel@sandisk.com>
         <1489432986.23810.12.camel@HansenPartnership.com>
         <1489437175.2658.17.camel@sandisk.com>
         <1489442133.23810.24.camel@HansenPartnership.com>
         <1489705225.2574.22.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:47115 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbdCRAIU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Mar 2017 20:08:20 -0400
In-Reply-To: <1489705225.2574.22.camel@sandisk.com>
Content-Language: en-US
Content-ID: <2D05FD9DD72C8540BD08229D9B68A104@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>

On Thu, 2017-03-16 at 23:00 +0000, Bart Van Assche wrote:
> The following crash only occurs with async aborts enabled:
>=20
> general protection fault: 0000 [#1] SMP
> RIP: 0010:scsi_device_put+0xb/0x30
> Call Trace:
>  scsi_disk_put+0x2d/0x40
>  sd_release+0x3d/0xb0
>  __blkdev_put+0x29e/0x360
>  blkdev_put+0x49/0x170
>  dm_put_table_device+0x58/0xc0 [dm_mod]
>  dm_put_device+0x70/0xc0 [dm_mod]
>  free_priority_group+0x92/0xc0 [dm_multipath]
>  free_multipath+0x70/0xc0 [dm_multipath]
>  multipath_dtr+0x19/0x20 [dm_multipath]
>  dm_table_destroy+0x67/0x120 [dm_mod]
>  dev_suspend+0xde/0x240 [dm_mod]
>  ctl_ioctl+0x1f5/0x520 [dm_mod]
>  dm_ctl_ioctl+0xe/0x20 [dm_mod]
>  do_vfs_ioctl+0x8f/0x700
>  SyS_ioctl+0x3c/0x70
>  entry_SYSCALL_64_fastpath+0x18/0xad

(replying to my own e-mail)

With my three scsi_dh_alua patches applied I don't see this crash anymore s=
o
this crash was probably unrelated to async aborts.

Bart.=
