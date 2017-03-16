From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2] scsi_sysfs: fix hang when removing scsi device
Date: Thu, 16 Mar 2017 23:00:40 +0000
Message-ID: <1489705225.2574.22.camel@sandisk.com>
References: <1489077442-20610-1-git-send-email-israelr@mellanox.com>
         <1489088191.2597.9.camel@sandisk.com>
         <22efc8bd-ae71-14c7-247b-7399bfd28c6d@mellanox.com>
         <1489430936.2658.9.camel@sandisk.com>
         <1489432986.23810.12.camel@HansenPartnership.com>
         <1489437175.2658.17.camel@sandisk.com>
         <1489442133.23810.24.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:54994 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752333AbdCPXAw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Mar 2017 19:00:52 -0400
In-Reply-To: <1489442133.23810.24.camel@HansenPartnership.com>
Content-Language: en-US
Content-ID: <FF8332A3E85ED74C97516FF2C5963158@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>

On Mon, 2017-03-13 at 14:55 -0700, James Bottomley wrote:
> On Mon, 2017-03-13 at 20:33 +0000, Bart Van Assche wrote:
> > On Mon, 2017-03-13 at 12:23 -0700, James Bottomley wrote:
> > > On Mon, 2017-03-13 at 18:49 +0000, Bart Van Assche wrote:
> > > > diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> > > > index 7bfbcfa7af40..b3bb49d06943 100644
> > > > --- a/drivers/scsi/scsi.c
> > > > +++ b/drivers/scsi/scsi.c
> > > > @@ -602,7 +602,7 @@ EXPORT_SYMBOL(scsi_device_get);
> > > >   */
> > > >  void scsi_device_put(struct scsi_device *sdev)
> > > >  {
> > > > -       module_put(sdev->host->hostt->module);
> > > > +       module_put(sdev->hostt->module);
> > > >         put_device(&sdev->sdev_gendev);
> > > >  }
> > > >  EXPORT_SYMBOL(scsi_device_put);
> > > > diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> > > > index 6f7128f49c30..7134487abbb1 100644
> > > > --- a/drivers/scsi/scsi_scan.c
> > > > +++ b/drivers/scsi/scsi_scan.c
> > > > @@ -227,6 +227,7 @@ static struct scsi_device
> > > > *scsi_alloc_sdev(struct
> > > > scsi_target *starget,
> > > >         sdev->model =3D scsi_null_device_strs;
> > > >         sdev->rev =3D scsi_null_device_strs;
> > > >         sdev->host =3D shost;
> > > > +       sdev->hostt =3D shost->hostt;
> > > >         sdev->queue_ramp_up_period =3D SCSI_DEFAULT_RAMP_UP_PERIOD;
> > > >         sdev->id =3D starget->id;
> > > >         sdev->lun =3D lun;
> > > > diff --git a/include/scsi/scsi_device.h
> > > > b/include/scsi/scsi_device.h
> > > > index 6f22b39f1b0c..cda620ed5922 100644
> > > > --- a/include/scsi/scsi_device.h
> > > > +++ b/include/scsi/scsi_device.h
> > > > @@ -82,6 +82,7 @@ struct scsi_event {
> > > > =20
> > > >  struct scsi_device {
> > > >         struct Scsi_Host *host;
> > > > +       struct scsi_host_template *hostt;
> > > >         struct request_queue *request_queue;
> > > > =20
> > >=20
> > > The apparent assumption behind this patch is that sdev->host can be
> > > freed but the sdev will still exist?  That shouldn't be correct:
> > > the
> > > rule for struct devices is that the child always holds the parent
> > > and
> > > the host is parented (albeit not necessarily directly) to the sdev,
> > > so
> > > it looks like something has gone wrong if the host had been freed
> > > before the sdev.
> >=20
> > Hello James,
> >=20
> > scsi_remove_host() decreases the sdev reference count but does not=20
> > wait until the sdev release work has finished. This is why the SCSI
> > host can already have disappeared before the last scsi_device_put()
> > call occurs.
>=20
> This is true, but I don't see how it can cause the host to be freed
> before the sdev.  The memory for struct Scsi_Host is freed in the
> shost_gendev release routine, which should be pinned by the parent
> traversal from sdev.  So it should not be possible for
>  scsi_host_dev_release() to be called before
>  scsi_device_dev_release_usercontext() becase the latter has the final
> put of the parent device.

Hello Hannes,

The following crash only occurs with async aborts enabled:

general protection fault: 0000 [#1] SMP
RIP: 0010:scsi_device_put+0xb/0x30
Call Trace:
 scsi_disk_put+0x2d/0x40
 sd_release+0x3d/0xb0
 __blkdev_put+0x29e/0x360
 blkdev_put+0x49/0x170
 dm_put_table_device+0x58/0xc0 [dm_mod]
 dm_put_device+0x70/0xc0 [dm_mod]
 free_priority_group+0x92/0xc0 [dm_multipath]
 free_multipath+0x70/0xc0 [dm_multipath]
 multipath_dtr+0x19/0x20 [dm_multipath]
 dm_table_destroy+0x67/0x120 [dm_mod]
 dev_suspend+0xde/0x240 [dm_mod]
 ctl_ioctl+0x1f5/0x520 [dm_mod]
 dm_ctl_ioctl+0xe/0x20 [dm_mod]
 do_vfs_ioctl+0x8f/0x700
 SyS_ioctl+0x3c/0x70
 entry_SYSCALL_64_fastpath+0x18/0xad

I hadn't seen this crash before kernel v4.11-rc1 but with kernel v4.11-rc1
and later I see it if I let the srp-test scripts run for a few minutes. The
patch I used to disable async aborts on my test setup is as follows:

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f2cafae150bc..9075e126d6c8 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -171,6 +171,7 @@ scmd_eh_abort_handler(struct work_struct *work)
 	}
 }
=20
+#if 0
 /**
  * scsi_abort_command - schedule a command abort
  * @scmd:	scmd to abort.
@@ -219,6 +220,12 @@ scsi_abort_command(struct scsi_cmnd *scmd)
 	queue_delayed_work(shost->tmf_work_q, &scmd->abort_work, HZ / 100);
 	return SUCCESS;
 }
+#else
+static int scsi_abort_command(struct scsi_cmnd *scmd)
+{
+	return FAILED;
+}
+#endif
=20
 /**
  * scsi_eh_scmd_add - add scsi cmd to error handling.

Bart.
