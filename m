From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH] sd: preserve sysfs updates to max_sectors_kb
Date: Tue, 29 Aug 2017 22:32:04 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D195B8E9288@avsrvexchmbx1.microsemi.net>
References: <150309002518.8999.15900049133748830764.stgit@brunhilda>
         <1503090353.2622.15.camel@wdc.com>
         <4993A297653ECB4581FA5C3C31323D195B8D825D@avsrvexchmbx2.microsemi.net>
         <1503092817.2622.19.camel@wdc.com>
         <4993A297653ECB4581FA5C3C31323D195B8DBDE4@avsrvexchmbx2.microsemi.net>
         <1503345191.2571.13.camel@wdc.com>
         ,<4993A297653ECB4581FA5C3C31323D195B8DBE34@avsrvexchmbx2.microsemi.net>
         <4993A297653ECB4581FA5C3C31323D195B8E9103@avsrvexchmbx1.microsemi.net>
        ,<1504030401.2653.43.camel@wdc.com>
        ,<4993A297653ECB4581FA5C3C31323D195B8E9143@avsrvexchmbx1.microsemi.net>
         <4993A297653ECB4581FA5C3C31323D195B8E9191@avsrvexchmbx1.microsemi.net>,<1504045532.2653.68.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0088.outbound.protection.outlook.com ([104.47.40.88]:8301
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751290AbdH2WcJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Aug 2017 18:32:09 -0400
In-Reply-To: <1504045532.2653.68.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@infradead.org" <hch@infradead.org>, Viswas G <viswas.g@microsemi.com>, Gerry Morong <gerry.morong@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>, Scott Benesh <scott.benesh@microsemi.com>, Bader Ali - Saleh <bader.alisaleh@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, Scott Teel <scott.teel@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Justin Lindley <justin.lindley@microsemi.com>, John Hall <John.Hall@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

________________________________________=0A=
From: Bart Van Assche [Bart.VanAssche@wdc.com]=0A=
Sent: Tuesday, August 29, 2017 3:25 PM=0A=
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
On Tue, 2017-08-29 at 19:41 +0000, Don Brace wrote:=0A=
> BLKRRPART ends up in the sd driver function sd_revalidate_disk, which res=
ets=0A=
>         q->limits.max_sectors =3D min(rw_max, queue_max_hw_sectors(q));=
=0A=
> back to the value from VPD page 0xb0.=0A=
>=0A=
> When you cat out max_sectors_kb, it obtains it's valuse from q->limits.ma=
x_sectors=0A=
>=0A=
> Adding a udev rule... Will there be a delay between the watch rule and th=
e new rule?=0A=
=0A=
Hello Don,=0A=
=0A=
In your original e-mail you wrote that max_sectors_kb was tuned because=0A=
of performance reasons. So does it really matter that for a very short=0A=
time max_sectors_kb does not have the optimal value?=0A=
=0A=
> One more point, what will I change the value back to? The watch rule=0A=
> changed it and I do not have the original value.=0A=
=0A=
To the value you want to set max_sectors_kb to.=0A=
=0A=
Bart.=0A=
=0A=
Users do set max_sectors_kb for performance reasons. They can increase=0A=
performance by setting max_sectors_kb to different values depending on=0A=
their I/O needs.=0A=
=0A=
And, if they set the value, and sd_revalidate_disk changes this value, =0A=
there is no history of what they set the value to. =0A=
=0A=
Thanks,=0A=
Don Brace=0A=
Microsemi Corp.=0A=
=0A=
