From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH 07/37] smartpqi: enhance resets
Date: Wed, 3 May 2017 19:19:29 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D1951D40034@avsrvexchmbx2.microsemi.net>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
         <149314959452.13903.17367079226921525023.stgit@brunhilda>
 <1493150504.2628.11.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0068.outbound.protection.outlook.com ([104.47.33.68]:42440
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756575AbdECTTu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 May 2017 15:19:50 -0400
In-Reply-To: <1493150504.2628.11.camel@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hch@infradead.org" <hch@infradead.org>, Viswas G <viswas.g@microsemi.com>, Gerry Morong <gerry.morong@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>, Scott Benesh <scott.benesh@microsemi.com>, Bader Ali - Saleh <bader.alisaleh@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, Scott Teel <scott.teel@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Justin Lindley <justin.lindley@microsemi.com>, John Hall <John.Hall@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> On Tue, 2017-04-25 at 14:46 -0500, Don Brace wrote:
> > @@ -4655,23 +4860,46 @@ static int pqi_device_reset(struct pqi_ctrl_inf=
o
> *ctrl_info,
> >  static int pqi_eh_device_reset_handler(struct scsi_cmnd *scmd)
> >  {
> >       int rc;
> > +     struct Scsi_Host *shost;
> >       struct pqi_ctrl_info *ctrl_info;
> >       struct pqi_scsi_dev *device;
> >
> > -     ctrl_info =3D shost_to_hba(scmd->device->host);
> > +     shost =3D scmd->device->host;
> > +     ctrl_info =3D shost_to_hba(shost);
> >       device =3D scmd->device->hostdata;
> >
> >       dev_err(&ctrl_info->pci_dev->dev,
> >               "resetting scsi %d:%d:%d:%d\n",
> > -             ctrl_info->scsi_host->host_no,
> > -             device->bus, device->target, device->lun);
> > +             shost->host_no, device->bus, device->target, device->lun)=
;
> >
> > -     rc =3D pqi_device_reset(ctrl_info, device);
> > +     pqi_check_ctrl_health(ctrl_info);
> > +     if (pqi_ctrl_offline(ctrl_info)) {
> > +             rc =3D FAILED;
> > +             goto out;
> > +     }
> >
> > +     mutex_lock(&ctrl_info->lun_reset_mutex);
> > +
> > +     pqi_ctrl_block_requests(ctrl_info);
> > +     pqi_ctrl_wait_until_quiesced(ctrl_info);
> > +     pqi_fail_io_queued_for_device(ctrl_info, device);
> > +     rc =3D pqi_wait_until_inbound_queues_empty(ctrl_info);
> > +     pqi_device_reset_start(device);
> > +     pqi_ctrl_unblock_requests(ctrl_info);
> > +
> > +     if (rc)
> > +             rc =3D FAILED;
> > +     else
> > +             rc =3D pqi_device_reset(ctrl_info, device);
> > +
> > +     pqi_device_reset_done(device);
> > +
> > +     mutex_unlock(&ctrl_info->lun_reset_mutex);
> > +
> > +out:
> >       dev_err(&ctrl_info->pci_dev->dev,
> >               "reset of scsi %d:%d:%d:%d: %s\n",
> > -             ctrl_info->scsi_host->host_no,
> > -             device->bus, device->target, device->lun,
> > +             shost->host_no, device->bus, device->target, device->lun,
> >               rc =3D=3D SUCCESS ? "SUCCESS" : "FAILED");
> >
> >       return rc;
>=20
> Please use scsi_target_block() / scsi_target_unblock() instead of
> reimplementing
> these functions.
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
