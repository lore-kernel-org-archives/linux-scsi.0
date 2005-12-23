From: Sergey Vlasov <vsu@altlinux.ru>
Subject: Re: [SCSI] fix scsi_reap_target() device_del from atomic context
Date: Fri, 23 Dec 2005 23:43:38 +0300
Message-ID: <20051223234338.798294f9.vsu@altlinux.ru>
References: <200512212359.jBLNxluV016971@hera.kernel.org>
	<20051222221329.5f317b8d.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__23_Dec_2005_23_43_38_+0300_84/E6P8rY+rDm.kX"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from master.altlinux.org ([62.118.250.235]:18446 "EHLO
	master.altlinux.org") by vger.kernel.org with ESMTP
	id S1161044AbVLWUoJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Dec 2005 15:44:09 -0500
In-Reply-To: <20051222221329.5f317b8d.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

--Signature=_Fri__23_Dec_2005_23_43_38_+0300_84/E6P8rY+rDm.kX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 22 Dec 2005 22:13:29 -0800 Andrew Morton wrote:

> Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> > tree d2f74a0351a09e184e124fd6ecf16e02ab768a0b
> > parent 42e33148df38c60b99d984b76b302c64397ebe4c
> > author James Bottomley <James.Bottomley@steeleye.com> Fri, 16 Dec 2005 =
12:01:43 -0800
> > committer James Bottomley <jejb@mulgrave.(none)> Sat, 17 Dec 2005 22:48=
:08 -0600
> >=20
> > [SCSI] fix scsi_reap_target() device_del from atomic context
> >=20
> > scsi_reap_target() was desgined to be called from any context.
> > However it must do a device_del() of the target device, which may only
> > be called from user context.  Thus we have to reimplement
> > scsi_reap_target() via a workqueue.
> >=20
> > Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
> >=20
> >  drivers/scsi/scsi_scan.c |   48 +++++++++++++++++++++++++++++++++++++-=
---------
> >  1 files changed, 38 insertions(+), 10 deletions(-)
> >=20
> > diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> > index 94e5167..e36c21e 100644
> > --- a/drivers/scsi/scsi_scan.c
> > +++ b/drivers/scsi/scsi_scan.c
[skip]
> >  void scsi_target_reap(struct scsi_target *starget)
> >  {
> > -	struct Scsi_Host *shost =3D dev_to_shost(starget->dev.parent);
> > -	unsigned long flags;
> > -	spin_lock_irqsave(shost->host_lock, flags);
> > +	struct work_queue_wrapper *wqw =3D=20
> > +		kzalloc(sizeof(struct work_queue_wrapper), GFP_ATOMIC);
>=20
> kmalloc() would suffice.
>=20
> > -	if (--starget->reap_ref =3D=3D 0 && list_empty(&starget->devices)) {
> > -		list_del_init(&starget->siblings);
> > -		spin_unlock_irqrestore(shost->host_lock, flags);
> > -		device_del(&starget->dev);
> > -		transport_unregister_device(&starget->dev);
> > -		put_device(&starget->dev);
> > +	if (!wqw) {
> > +		starget_printk(KERN_ERR, starget,
> > +			       "Failed to allocate memory in scsi_reap_target()\n");
> >  		return;

So if that GFP_ATOMIC allocation ever fails, the target is leaked
forever - does not look nice.

Does anything depend on starget->siblings being empty after we had
removed it from the shost->__targets list it was on?  Seems that all
other uses of this field are:

drivers/scsi/scsi_scan.c:313:   list_for_each_entry(starget, &shost->__targ=
ets, siblings) {
drivers/scsi/scsi_scan.c:365:   INIT_LIST_HEAD(&starget->siblings);
drivers/scsi/scsi_scan.c:373:   list_add_tail(&starget->siblings, &shost->_=
_targets);

So probably we can reuse this field and do deferred reaping without any
memory allocation at all.  The following patch should be applied
_instead_ of the James' patch, not on top of it (I can make a combined
patch if it is desired).  The difference with the previous patch is that
scsi_target_reap() still removes the target from shost->__targets
immediately - only device_del() and subsequent actions are deferred to a
workqueue.

Patch is only compile tested.

------------------------------------------------------------------------

[SCSI] fix scsi_target_reap() device_del from atomic context

scsi_target_reap() may be called from any context, however, it needs to
call device_del(), which requires a process context.  Thus we have to
perform device_del() via a workqueue.

Signed-off-by: Sergey Vlasov <vsu@altlinux.ru>

---

 drivers/scsi/scsi_scan.c |   33 +++++++++++++++++++++++++++++----
 1 files changed, 29 insertions(+), 4 deletions(-)

28763f31e602e7265b61e676dcc1b536b5442fbf
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 94e5167..ac4c75f 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -400,6 +400,30 @@ static struct scsi_target *scsi_alloc_ta
 	return found_target;
 }
=20
+static LIST_HEAD(scsi_target_reap_list);
+static DEFINE_SPINLOCK(scsi_target_reap_list_lock);
+
+static void scsi_target_reap_work_fn(void *data)
+{
+	struct scsi_target *starget;
+	unsigned long flags;
+
+	spin_lock_irqsave(&scsi_target_reap_list_lock, flags);
+	while (!list_empty(&scsi_target_reap_list)) {
+		starget =3D list_entry(scsi_target_reap_list.next,
+				     struct scsi_target, siblings);
+		list_del_init(&starget->siblings);
+		spin_unlock_irqrestore(&scsi_target_reap_list_lock, flags);
+		device_del(&starget->dev);
+		transport_unregister_device(&starget->dev);
+		put_device(&starget->dev);
+		spin_lock_irqsave(&scsi_target_reap_list_lock, flags);
+	}
+	spin_unlock_irqrestore(&scsi_target_reap_list_lock, flags);
+}
+
+static DECLARE_WORK(scsi_target_reap_work, scsi_target_reap_work_fn, NULL);
+
 /**
  * scsi_target_reap - check to see if target is in use and destroy if not
  *
@@ -416,11 +440,12 @@ void scsi_target_reap(struct scsi_target
 	spin_lock_irqsave(shost->host_lock, flags);
=20
 	if (--starget->reap_ref =3D=3D 0 && list_empty(&starget->devices)) {
-		list_del_init(&starget->siblings);
+		list_del(&starget->siblings);
 		spin_unlock_irqrestore(shost->host_lock, flags);
-		device_del(&starget->dev);
-		transport_unregister_device(&starget->dev);
-		put_device(&starget->dev);
+		spin_lock_irqsave(&scsi_target_reap_list_lock, flags);
+		list_add_tail(&starget->siblings, &scsi_target_reap_list);
+		spin_unlock_irqrestore(&scsi_target_reap_list_lock, flags);
+		schedule_work(&scsi_target_reap_work);
 		return;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
--=20
1.0.GIT

--Signature=_Fri__23_Dec_2005_23_43_38_+0300_84/E6P8rY+rDm.kX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.9.17 (GNU/Linux)

iD8DBQFDrGF+FIWJ+mVp1nQRAtfPAKCBq+IpcFFGeS4qywPZEHVDwF/u1ACgjiJD
8+/nDCwQUvp28FEMz4YhXko=
=Ow4W
-----END PGP SIGNATURE-----

--Signature=_Fri__23_Dec_2005_23_43_38_+0300_84/E6P8rY+rDm.kX--
