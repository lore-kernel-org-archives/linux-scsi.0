From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH 05/37] smartpqi: ensure controller is in SIS mode at init
Date: Wed, 3 May 2017 15:46:01 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D1951D3FD9D@avsrvexchmbx2.microsemi.net>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
         <149314958226.13903.4820392053805213524.stgit@brunhilda>
 <1493150271.2628.9.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0044.outbound.protection.outlook.com ([104.47.41.44]:50271
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751307AbdECPqJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 May 2017 11:46:09 -0400
In-Reply-To: <1493150271.2628.9.camel@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hch@infradead.org" <hch@infradead.org>, Viswas G <viswas.g@microsemi.com>, Gerry Morong <gerry.morong@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>, Scott Benesh <scott.benesh@microsemi.com>, Bader Ali - Saleh <bader.alisaleh@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, Scott Teel <scott.teel@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Justin Lindley <justin.lindley@microsemi.com>, John Hall <John.Hall@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Bart Van Assche [mailto:Bart.VanAssche@sandisk.com]
> Sent: Tuesday, April 25, 2017 2:58 PM
> To: hch@infradead.org; Viswas G <viswas.g@microsemi.com>; Gerry
> Morong <gerry.morong@microsemi.com>; Mahesh Rajashekhara
> <mahesh.rajashekhara@microsemi.com>; POSWALD@suse.com; Scott
> Benesh <scott.benesh@microsemi.com>; Don Brace
> <don.brace@microsemi.com>; Bader Ali - Saleh
> <bader.alisaleh@microsemi.com>; Kevin Barnett
> <kevin.barnett@microsemi.com>; joseph.szczypek@hpe.com; Scott Teel
> <scott.teel@microsemi.com>; jejb@linux.vnet.ibm.com; Justin Lindley
> <justin.lindley@microsemi.com>; John Hall <John.Hall@microsemi.com>
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 05/37] smartpqi: ensure controller is in SIS mode at =
init
>=20
> EXTERNAL EMAIL
>=20
>=20
> On Tue, 2017-04-25 at 14:46 -0500, Don Brace wrote:
> > +bool sis_is_kernel_up(struct pqi_ctrl_info *ctrl_info)
> > +{
> > +     u32 status;
> > +     bool kernel_up;
> > +
> > +     status =3D readl(&ctrl_info->registers->sis_firmware_status);
> > +
> > +     if (status & SIS_CTRL_KERNEL_UP)
> > +             kernel_up =3D true;
> > +     else
> > +             kernel_up =3D false;
> > +
> > +     return kernel_up;
> > +}
>=20
> Since bool is a synonym for the C11 type _Bool, it is not necessary to
> convert explicitly to a truth value. The above code can be simplified int=
o:
>=20
> bool sis_is_kernel_up(struct pqi_ctrl_info *ctrl_info)
> {
>         return readl(&ctrl_info->registers->sis_firmware_status) &
>                 SIS_CTRL_KERNEL_UP;
> }

Done
Thanks for your review

Thanks,
Don Brace
ESC - Smart Storage
Microsemi Corporation
