From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH] sd: preserve sysfs updates to max_sectors_kb
Date: Tue, 29 Aug 2017 19:41:02 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D195B8E9191@avsrvexchmbx1.microsemi.net>
References: <150309002518.8999.15900049133748830764.stgit@brunhilda>
         <1503090353.2622.15.camel@wdc.com>
         <4993A297653ECB4581FA5C3C31323D195B8D825D@avsrvexchmbx2.microsemi.net>
         <1503092817.2622.19.camel@wdc.com>
         <4993A297653ECB4581FA5C3C31323D195B8DBDE4@avsrvexchmbx2.microsemi.net>
         <1503345191.2571.13.camel@wdc.com>
        ,<4993A297653ECB4581FA5C3C31323D195B8DBE34@avsrvexchmbx2.microsemi.net>
         <4993A297653ECB4581FA5C3C31323D195B8E9103@avsrvexchmbx1.microsemi.net>,<1504030401.2653.43.camel@wdc.com>,<4993A297653ECB4581FA5C3C31323D195B8E9143@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0082.outbound.protection.outlook.com ([104.47.41.82]:30569
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750822AbdH2TlI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Aug 2017 15:41:08 -0400
In-Reply-To: <4993A297653ECB4581FA5C3C31323D195B8E9143@avsrvexchmbx1.microsemi.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@infradead.org" <hch@infradead.org>, Viswas G <viswas.g@microsemi.com>, Gerry Morong <gerry.morong@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>, Scott Benesh <scott.benesh@microsemi.com>, Bader Ali - Saleh <bader.alisaleh@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, Scott Teel <scott.teel@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Justin Lindley <justin.lindley@microsemi.com>, John Hall <John.Hall@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

=0A=
________________________________________=0A=
From: Don Brace=0A=
Sent: Tuesday, August 29, 2017 11:36 AM=0A=
To: Bart Van Assche; hch@infradead.org; Viswas G; Gerry Morong; Mahesh Raja=
shekhara; POSWALD@suse.com; Scott Benesh; Bader Ali - Saleh; Kevin Barnett;=
 joseph.szczypek@hpe.com; Scott Teel; jejb@linux.vnet.ibm.com; Justin Lindl=
ey; John Hall=0A=
Cc: linux-scsi@vger.kernel.org=0A=
Subject: RE: [PATCH] sd: preserve sysfs updates to max_sectors_kb=0A=
=0A=
________________________________________=0A=
From: Bart Van Assche [Bart.VanAssche@wdc.com]=0A=
Sent: Tuesday, August 29, 2017 11:13 AM=0A=
To: hch@infradead.org; Viswas G; Gerry Morong; Mahesh Rajashekhara; POSWALD=
@suse.com; Scott Benesh; Don Brace; Bader Ali - Saleh; Kevin Barnett; josep=
h.szczypek@hpe.com; Scott Teel; jejb@linux.vnet.ibm.com; Justin Lindley; Jo=
hn Hall=0A=
Cc: linux-scsi@vger.kernel.org=0A=
Subject: Re: [PATCH] sd: preserve sysfs updates to max_sectors_kb=0A=
=0A=
EXTERNAL EMAIL=0A=
=0A=
=0A=
On Tue, 2017-08-29 at 17:42 +0000, Don Brace wrote:=0A=
> From: Don Brace=0A=
> > [ ... ]=0A=
> > Hello Don,=0A=
> >=0A=
> > Can you have another look at the udev rules on your test system? The la=
st=0A=
> > rule in 60-block.rules looks like a watch rule to me. The same holds fo=
r the=0A=
> > upstream version of that file=0A=
> > (https://github.com/systemd/systemd/blob/maste=0A=
> > r/rules/60-block.rules).=0A=
> >=0A=
> > Bart.=0A=
>=0A=
> It is a watch rule.=0A=
>=0A=
> systemd/src/udev/udevd.c=0A=
>    manager_new=0A=
>        manager->fd_inotify =3D udev_watch_init(manager->udev);=0A=
>        sd_event_add_io(manager->event, &manager->inotify_event, manager->=
fd_inotify, EPOLLIN, on_inotify, manager);=0A=
>            on_inotify (systemd source code: src/udev/udevd.c)=0A=
>               synthesize_change=0A=
>                     ioctl --> BLKRRPART=0A=
>=0A=
> This rule ends up calling BLKRRPART.=0A=
=0A=
Hello Don,=0A=
=0A=
Sorry if I'm slow today, but it's not clear to me how the BLKRRPART ioctl=
=0A=
triggers a change of max_sectors_kb? And even if it really is this ioctl th=
at=0A=
triggers a change of max_sectors_kb, should the kernel code that handles=0A=
max_sectors_kb writes be modified or should rather a udev rule be added tha=
t=0A=
sets max_sectors_kb to the desired value after each partition rescan?=0A=
=0A=
Thanks,=0A=
=0A=
Bart.=0A=
=0A=
----=0A=
BLKRRPART ends up in the sd driver function sd_revalidate_disk, which reset=
s=0A=
        q->limits.max_sectors =3D min(rw_max, queue_max_hw_sectors(q));=0A=
back to the value from VPD page 0xb0.=0A=
=0A=
When you cat out max_sectors_kb, it obtains it's valuse from q->limits.max_=
sectors=0A=
=0A=
Adding a udev rule... Will there be a delay between the watch rule and the =
new rule?=0A=
=0A=
Thanks,=0A=
Don Brace=0A=
=0A=
One more point, what will I change the value back to? The watch rule =0A=
changed it and I do not have the original value.=0A=
