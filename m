From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: DMA doesn't work since "make ata port as parent device of scsi
 host"
Date: Wed, 21 Mar 2012 09:25:33 +0800
Message-ID: <1332293133.17160.12.camel@minggr>
References: <20120315014807.GA3051@alea.gnuu.de>
	 <1331776741.3436.33.camel@minggr> <1331781968.3436.43.camel@minggr>
	 <20120315074835.GA18295@alea.gnuu.de> <1331799598.3436.46.camel@minggr>
	 <20120315155924.GA6738@alea.gnuu.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41387 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417Ab2CUBZg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Mar 2012 21:25:36 -0400
In-Reply-To: <20120315155924.GA6738@alea.gnuu.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
Cc: Jeff Garzik <jgarzik@redhat.com>, Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>

On Thu, 2012-03-15 at 16:59 +0100, J=C3=B6rg Sommer wrote:
> Lin Ming hat am Thu 15. Mar, 16:19 (+0800) geschrieben:
> > On Thu, 2012-03-15 at 08:48 +0100, J=C3=B6rg Sommer wrote:
> > > Lin Ming hat am Thu 15. Mar, 11:26 (+0800) geschrieben:
> > > > On Thu, 2012-03-15 at 09:59 +0800, Lin Ming wrote:
> > > > > On Thu, 2012-03-15 at 02:48 +0100, J=C3=B6rg Sommer wrote:
> > > > > > Hi,
> > > > > >=20
> > > > > > I'm getting these messages in a KVM virtualized host and th=
e access to
> > > > > > the disks is very slow. Using libata.dma=3D0 suppresses the=
 warnings, but
> > > > > > the disks are still slow.
> > > > >=20
> > > > > Hi J=C3=B6rg,
> > > > >=20
> > > > > Let me try to reproduce this issue first.
> > > >=20
> > > > I tried below commands on x86_32, but can't reproduce it.
> > > >=20
> > > > qemu-system-i386 -kernel /root/vmlinuz-3.3.0-rc7 -append "root=3D=
/dev/sda1
> > > > zcache" -hda /root/debian-32.img -hdb /root/data.img
> > > >=20
> > > > Maybe because i386 uses different ata controller than ppc(ata_p=
iix vs
> > > > pata-macio).
> > > >=20
> > > > I'll try qemu-system-ppc.
> > > >=20
> > > > Did you need to run some workload to trigger these warings?
> > > > Or did you get these warnings right after booting the VM?
> > >=20
> > > These warnings come up before =C2=BBINIT started=C2=AB. I don't h=
ave to do
> > > anything, just wait and see.
> > >=20
> > > # truncate -s100M /mnt/data/new
> > > # mke2fs -Fq /mnt/data/new
> > > # mount -o loop /mnt/data/new /mnt/other
> > > # cp --parents /bin/zsh-static /mnt/other/zsh
> > > # umount /mnt/other
> > > # qemu-system-ppc -enable-kvm -M mac99 -cpu G4 -k de -kernel /boo=
t/vmlinuz-3.3.0-rc5-04520-g8d233c0 -append 'root=3D/dev/sda ro console=3D=
ttyPZ0 init=3D/zsh' -hda /mnt/data/new
> > >=20
> > > I've uploaded my config and the kernel:
> > > http://alioth.debian.org/~jo-guest/config-3.3.0-rc5-04520-g8d233c=
0
> > > http://alioth.debian.org/~jo-guest/vmlinuz-3.3.0-rc5-04520-g8d233=
c0
> > >=20
> > > You have to switch to the serial console (Ctrl-Alt-3 or with -nog=
raphic
> > > Ctrl-a c). All kernel messages arrive there.
> > >=20
> > > > Would you please try to disable ata port runtime pm?
> > > > You can disable it by, for example,
> > >=20
> > > Is this also possible with a kernel parameter? It takes very long=
 until I
> > > get a shell prompt.
> >=20
> > No, but you can try below debug patch to disable port runtime pm.
> >=20
> > diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-tr=
ansport.c
> > index 74aaee3..8def3fc 100644
> > --- a/drivers/ata/libata-transport.c
> > +++ b/drivers/ata/libata-transport.c
> > @@ -293,7 +293,6 @@ int ata_tport_add(struct device *parent,
> > =20
> >  	device_enable_async_suspend(dev);
> >  	pm_runtime_set_active(dev);
> > -	pm_runtime_enable(dev);
>=20
> This patch doesn't change anything. The kernel still hangs. If you ha=
ve
> more patches or ideas, let me know.

Hi,=20

Below patch should fix the problem.

Could you help to test it?

=46rom a36022015c97c9a9f80e71b4283f0ff5f481ffc3 Mon Sep 17 00:00:00 200=
1
=46rom: Lin Ming <ming.m.lin@intel.com>
Date: Tue, 20 Mar 2012 14:35:10 +0800
Subject: [PATCH] [SCSI] scsi_lib: use correct DMA device in __scsi_allo=
c_queue

Currently, __scsi_alloc_queue uses SCSI host's parent device
as DMA device to set segment boundary. But the parent device may not
refer to the DMA device. For example, for ATA disk, SCSI host's parent
device now refers to ATA port.

Since commit d139b9b([SCSI] scsi_lib_dma: fix bug with dma maps on
nested scsi objects), a new field Scsi_Host->dma_device was introduced
to refer to the real DMA device.

Use ->dma_device in __scsi_alloc_queue to correctly set segment
boundary.

And use scsi_add_host_with_dma in ata_scsi_add_hosts to pass in the
correct DMA device.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/libata-scsi.c |    3 ++-
 drivers/scsi/scsi_lib.c   |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 7ae1e77..e47f889 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3398,7 +3398,8 @@ int ata_scsi_add_hosts(struct ata_host *host, str=
uct scsi_host_template *sht)
 		 */
 		shost->max_host_blocked =3D 1;
=20
-		rc =3D scsi_add_host(ap->scsi_host, &ap->tdev);
+		rc =3D scsi_add_host_with_dma(ap->scsi_host,
+						&ap->tdev, ap->host->dev);
 		if (rc)
 			goto err_add;
 	}
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f85cfa6..486088b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1642,7 +1642,7 @@ struct request_queue *__scsi_alloc_queue(struct S=
csi_Host *shost,
 					 request_fn_proc *request_fn)
 {
 	struct request_queue *q;
-	struct device *dev =3D shost->shost_gendev.parent;
+	struct device *dev =3D shost->dma_dev;
=20
 	q =3D blk_init_queue(request_fn, NULL);
 	if (!q)
--=20
1.7.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
