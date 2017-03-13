From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2] scsi_sysfs: fix hang when removing scsi device
Date: Mon, 13 Mar 2017 20:33:13 +0000
Message-ID: <1489437175.2658.17.camel@sandisk.com>
References: <1489077442-20610-1-git-send-email-israelr@mellanox.com>
         <1489088191.2597.9.camel@sandisk.com>
         <22efc8bd-ae71-14c7-247b-7399bfd28c6d@mellanox.com>
         <1489430936.2658.9.camel@sandisk.com>
         <1489432986.23810.12.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:23336 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750899AbdCMUdW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2017 16:33:22 -0400
In-Reply-To: <1489432986.23810.12.camel@HansenPartnership.com>
Content-Language: en-US
Content-ID: <1206E33B9CDF9542A66B92DD6E02051C@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "israelr@mellanox.com" <israelr@mellanox.com>
Cc: "maxg@mellanox.com" <maxg@mellanox.com>

On Mon, 2017-03-13 at 12:23 -0700, James Bottomley wrote:
> On Mon, 2017-03-13 at 18:49 +0000, Bart Van Assche wrote:
> > diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> > index 7bfbcfa7af40..b3bb49d06943 100644
> > --- a/drivers/scsi/scsi.c
> > +++ b/drivers/scsi/scsi.c
> > @@ -602,7 +602,7 @@ EXPORT_SYMBOL(scsi_device_get);
> >   */
> >  void scsi_device_put(struct scsi_device *sdev)
> >  {
> > -       module_put(sdev->host->hostt->module);
> > +       module_put(sdev->hostt->module);
> >         put_device(&sdev->sdev_gendev);
> >  }
> >  EXPORT_SYMBOL(scsi_device_put);
> > diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> > index 6f7128f49c30..7134487abbb1 100644
> > --- a/drivers/scsi/scsi_scan.c
> > +++ b/drivers/scsi/scsi_scan.c
> > @@ -227,6 +227,7 @@ static struct scsi_device *scsi_alloc_sdev(struct
> > scsi_target *starget,
> >         sdev->model =3D scsi_null_device_strs;
> >         sdev->rev =3D scsi_null_device_strs;
> >         sdev->host =3D shost;
> > +       sdev->hostt =3D shost->hostt;
> >         sdev->queue_ramp_up_period =3D SCSI_DEFAULT_RAMP_UP_PERIOD;
> >         sdev->id =3D starget->id;
> >         sdev->lun =3D lun;
> > diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> > index 6f22b39f1b0c..cda620ed5922 100644
> > --- a/include/scsi/scsi_device.h
> > +++ b/include/scsi/scsi_device.h
> > @@ -82,6 +82,7 @@ struct scsi_event {
> > =20
> >  struct scsi_device {
> >         struct Scsi_Host *host;
> > +       struct scsi_host_template *hostt;
> >         struct request_queue *request_queue;
> > =20
>=20
> The apparent assumption behind this patch is that sdev->host can be
> freed but the sdev will still exist?  That shouldn't be correct: the
> rule for struct devices is that the child always holds the parent and
> the host is parented (albeit not necessarily directly) to the sdev, so
> it looks like something has gone wrong if the host had been freed
> before the sdev.

Hello James,

scsi_remove_host() decreases the sdev reference count but does not wait
until the sdev release work has finished. This is why the SCSI host can
already have disappeared before the last scsi_device_put() call occurs.

Bart.=
