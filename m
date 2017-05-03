From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH 08/37] smartpqi: add suspend and resume support
Date: Wed, 3 May 2017 19:21:07 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D1951D4004D@avsrvexchmbx2.microsemi.net>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
         <149314960079.13903.626198058289190508.stgit@brunhilda>
 <1493150725.2628.13.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0049.outbound.protection.outlook.com ([104.47.33.49]:6987
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756830AbdECTVN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 May 2017 15:21:13 -0400
In-Reply-To: <1493150725.2628.13.camel@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hch@infradead.org" <hch@infradead.org>, Viswas G <viswas.g@microsemi.com>, Gerry Morong <gerry.morong@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>, Scott Benesh <scott.benesh@microsemi.com>, Bader Ali - Saleh <bader.alisaleh@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, Scott Teel <scott.teel@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Justin Lindley <justin.lindley@microsemi.com>, John Hall <John.Hall@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> On Tue, 2017-04-25 at 14:46 -0500, Don Brace wrote:
> > +static int pqi_device_wait_for_pending_io(struct pqi_ctrl_info *ctrl_i=
nfo,
> > +       struct pqi_scsi_dev *device)
> > +{
> > +       while (atomic_read(&device->scsi_cmds_outstanding)) {
> > +               pqi_check_ctrl_health(ctrl_info);
> > +               if (pqi_ctrl_offline(ctrl_info))
> > +                       return -ENXIO;
> > +               usleep_range(1000, 2000);
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static int pqi_ctrl_wait_for_pending_io(struct pqi_ctrl_info *ctrl_inf=
o)
> > +{
> > +       bool io_pending;
> > +       unsigned long flags;
> > +       struct pqi_scsi_dev *device;
> > +
> > +       while (1) {
> > +               io_pending =3D false;
> > +
> > +               spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, fl=
ags);
> > +               list_for_each_entry(device, &ctrl_info->scsi_device_lis=
t,
> > +                       scsi_device_list_entry) {
> > +                       if (atomic_read(&device->scsi_cmds_outstanding)=
) {
> > +                               io_pending =3D true;
> > +                               break;
> > +                       }
> > +               }
> > +               spin_unlock_irqrestore(&ctrl_info->scsi_device_list_loc=
k,
> > +                                       flags);
> > +
> > +               if (!io_pending)
> > +                       break;
> > +
> > +               pqi_check_ctrl_health(ctrl_info);
> > +               if (pqi_ctrl_offline(ctrl_info))
> > +                       return -ENXIO;
> > +
> > +               usleep_range(1000, 2000);
> > +       }
> > +
> > +       return 0;
> > +}
>=20
> The same comment applies here that applies to the previous patch: please
> use
> scsi_target_block() / scsi_target_unblock() instead of reimplementing the=
se
> functions.
>=20
> Thanks,
>=20
> Bart.

Our LUN reset functions have to do several PQI-specific things in order to =
work correctly,
which is why we did not use scsi_target_block()/scsi_target_unblock()

Hope this is acceptable

Thanks for your review
Don Brace
ESC - Smart Storage
Microsemi Corporation
