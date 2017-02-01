From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: LIO: FILEIO vs IBLOCK read performance
Date: Wed, 1 Feb 2017 19:55:21 +0000
Message-ID: <1485978900.2560.9.camel@sandisk.com>
References: <CAGqmi770AJ1v5188DijUB6oNZvsrRAMca4yeo=mqe1AW_x-Zjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0057.outbound.protection.outlook.com ([104.47.32.57]:44384
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751548AbdBATzb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Feb 2017 14:55:31 -0500
In-Reply-To: <CAGqmi770AJ1v5188DijUB6oNZvsrRAMca4yeo=mqe1AW_x-Zjw@mail.gmail.com>
Content-Language: en-US
Content-ID: <5D836F2684033E49A96EAD154D6C8DB3@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "nefelim4ag@gmail.com" <nefelim4ag@gmail.com>

On Wed, 2017-02-01 at 11:18 +0300, Timofey Titovets wrote:
> so, short results (random read on /dev/sdb on client):
> block + /dev/sdb ~ 500 iops (emulate_write_cache=3D0)
> fileio + /dev/sdb ~ 90 iops (emulate_write_cache=3D0)
> fileio + /dev/sdb ~ 90 iops (emulate_write_cache=3D1)
> fileio + /storage/LUN/1 ~90 iops (emulate_write_cache=3D0)
> fileio + /storage/LUN/1 ~90 iops (emulate_write_cache=3D1)
> block + /dev/loop0 ~ 90 iops loop directio=3D0
> block + /dev/loop0 ~ 500 iops loop directio=3D0

The address of the LIO mailing list is target-devel@vger.kernel.org instead
of linux-scsi@vger.kernel.org. Anyway, have you tried to disable readahead
on /dev/sdb (blockdev --setra / --setfra)? Readahead can have a significant
negative impact on random I/O. There is a heuristic in the kernel for
automatically disabling readahead for random I/O but maybe that algorithm
did not recognize your workload properly.

Bart.=
