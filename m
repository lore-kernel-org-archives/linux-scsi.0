From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Error using DC315U to drive ScanJet 4c
Date: Tue, 14 Feb 2006 00:15:31 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0602140000160.18538@poirot.grange>
References: <20060211011457.GA1839@igloo.df.lth.se>
 <Pine.LNX.4.60.0602112153320.3570@poirot.grange> <Pine.LNX.4.60.0602130043540.19775@poirot.grange>
 <20060211011457.GA1839@igloo.df.lth.se> <Pine.LNX.4.60.0602112153320.3570@poirot.grange>
 <20060213171052.GI18853@igloo.df.lth.se>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-1865494336-1139872531=:18538"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.21]:18112 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1030264AbWBMXPU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Feb 2006 18:15:20 -0500
In-Reply-To: <20060213171052.GI18853@igloo.df.lth.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fredrik Roubert <roubert@df.lth.se>
Cc: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-1865494336-1139872531=:18538
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 13 Feb 2006, Fredrik Roubert wrote:

> On Sat 11 Feb 22:06 CET 2006, Guennadi Liakhovetski wrote:
>=20
> > ...and your 64-bit dual-core CPU makes it even more fun. On the other
> > hand, it means we won't be able to test it on highmem... Unless you
> > agree to swap it to a 32-bit machine for a test:-)
>=20
> I actually have an old Pentium machine standing by that I could use for
> testing (when the driver seems to work).

=2E..and you still use your presumably main desktop PC for testing... brave=
=20
man:-)

> > Ok, if you feel adventurous, you might try the patch below.
>=20
> OK, that patch compiles with the following warnings:
>=20
> drivers/scsi/dc395x.c: In function =91dump_register_info=92:
> drivers/scsi/dc395x.c:1226: warning: format =91%i=92 expects type =91int=
=92, but argument 5 has type =91size_t=92
> drivers/scsi/dc395x.c: In function =91data_in_phase0=92:
> drivers/scsi/dc395x.c:2322: warning: comparison of distinct pointer types=
 lacks a cast

64 bit... the first one might be fixed with the attached, the second one I=
=20
removed altogether.

> drivers/scsi/dc395x.c: In function =91dc395x_init_one=92:
> drivers/scsi/dc395x.c:4357: warning: =91ptr=92 may be used uninitialized =
in this function

Actually, even a compiler can guess, that it cannot be used uninitialised=
=20
here. Mine, actually, doesn't complain. What version are you using?

> Then it gives the following syslog output when I load the module and try
> to scan an image:
>=20
> Feb 13 18:00:39 skalman kernel: dc395x: Tekram DC395(U/UW/F), DC315(U) - =
ASIC TRM-S1040 v2.05, 2004/03/08
> Feb 13 18:00:39 skalman kernel: ACPI: PCI Interrupt 0000:04:05.0[A] -> GS=
I 20 (level, low) -> IRQ 19
> Feb 13 18:00:39 skalman kernel: dc395x: Used settings: AdapterID=3D07, Sp=
eed=3D0(20.0MHz), dev_mode=3D0x57
> Feb 13 18:00:39 skalman kernel: dc395x:                AdaptMode=3D0x0f, =
Tags=3D4(16), DelayReset=3D1s
> Feb 13 18:00:39 skalman kernel: dc395x: Connectors:  Termination: Auto Lo=
w High
> Feb 13 18:00:39 skalman kernel: dc395x: Performing initial SCSI bus reset
> Feb 13 18:00:39 skalman kernel: scsi3 : Tekram DC395(U/UW/F), DC315(U) - =
ASIC TRM-S1040 v2.05, 2004/03/08
> Feb 13 18:00:41 skalman kernel:   Vendor: HP        Model: C2520A        =
    Rev: 3503
> Feb 13 18:00:41 skalman kernel:   Type:   Processor                      =
    ANSI SCSI revision: 02
> Feb 13 18:00:41 skalman kernel:  3:0:2:0: Attached scsi generic sg2 type =
3
> Feb 13 18:02:57 skalman kernel: dc395x: reselect: w/o disconnected cmds <=
02-0>
> Feb 13 18:02:57 skalman kernel: dc395x: disconnect: Unexpected reselectio=
n <02-0>
> Feb 13 18:04:57 skalman kernel: dc395x: eh_abort: (pid#751) target=3D<02-=
0> cmd=3Dffff81007eb64080
> Feb 13 18:04:57 skalman kernel: dc395x: eh_abort: Command in progress<6>d=
c395x: eh_bus_reset: (pid#751) target=3D<02-0> cmd=3Dffff81007eb64080
> Feb 13 18:04:57 skalman kernel: dc395x: doing_srb_done: pids G:751(02-0)

It might indeed be a hardware error in the end... Please, try the attached=
=20
patch. It only adds a couple of printk's on the top of the previous one.=20
As the problem happens only ones, hopefully, nothing bad will happen. The=
=20
only thing I am not entirely sure about - you might get a warning for=20
calling printk under spinlock_irqsave, if you have respective debugging=20
enabled, I think. Then we'll hopefully see if at least for you the=20
original patch does the right thing...

Thanks
Guennadi
---
Guennadi Liakhovetski

diff -u a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c=092006-02-13 23:55:52.000000000 +0100
+++ b/drivers/scsi/dc395x.c=092006-02-13 23:53:37.000000000 +0100
@@ -1221,7 +1221,7 @@
 =09=09=09    =09srb, srb->cmd, srb->cmd->pid,
 =09=09=09=09srb->cmd->cmnd[0], srb->cmd->device->id,
 =09=09=09       =09srb->cmd->device->lun);
-=09=09printk("  sglist=3D%p cnt=3D%i idx=3D%i len=3D%i\n",
+=09=09printk("  sglist=3D%p cnt=3D%i idx=3D%i len=3D%u\n",
 =09=09       srb->segment_x, srb->sg_count, srb->sg_index,
 =09=09       srb->total_xfer_length);
 =09=09printk("  state=3D0x%04x status=3D0x%02x phase=3D0x%02x (%sconn.)\n"=
,
@@ -2227,6 +2227,9 @@
=20
 =09BUG_ON(i =3D=3D sg_count);
=20
+=09printk(KERN_DEBUG "dc395x: Found sg-entry #%d[%u] of %d, offset %u afte=
r %u bytes for offset %u\n",
+=09       i, sg[i].length, sg_count, sg[i].offset, l2, *offset);
+
 =09/* Offset starting from the beginning of first page in this sg-entry */
 =09*offset =3D *offset - l2 + sg[i].offset;
=20
@@ -2266,7 +2269,7 @@
 =09 * seem to be a bad idea, actually.
 =09 */
 =09if (!(srb->state & SRB_XFERPAD)) {
-=09=09unsigned int d_left_counter, max_left;
+=09=09unsigned int d_left_counter;
 =09=09if (scsi_status & PARITYERROR) {
 =09=09=09dprintkl(KERN_INFO, "data_in_phase0: (pid#%li) "
 =09=09=09=09"Parity Error\n", srb->cmd->pid);
@@ -2319,7 +2322,6 @@
 =09=09=09DC395x_read32(acb, TRM_S1040_DMA_CXCNT),
 =09=09=09srb->total_xfer_length, d_left_counter);
 #if DC395x_LASTPIO
-=09=09max_left =3D max(d_left_counter, srb->total_xfer_length);
 =09=09/* KG: Less than or equal to 4 bytes can not be transfered via DMA, =
it seems. */
 =09=09if (d_left_counter
 =09=09    && srb->total_xfer_length <=3D DC395x_LASTPIO) {
@@ -2351,6 +2353,8 @@
 =09=09=09=09=09base =3D dc395x_kmap_atomic_sg((struct scatterlist *)srb->c=
md->request_buffer,
 =09=09=09=09=09=09=09=09     srb->sg_count, &offset, &len);
 =09=09=09=09=09virt =3D base + offset;
+=09=09=09=09=09printk(KERN_DEBUG "dc395x: Needed %u bytes in, mapped %u at=
 %p\n",
+=09=09=09=09=09       left_io, len, base);
 =09=09=09=09} else {
 =09=09=09=09=09virt =3D srb->cmd->request_buffer + srb->cmd->request_buffl=
en - left_io;
 =09=09=09=09=09len =3D left_io;
@@ -2395,6 +2399,7 @@
 =09=09=09=09if (srb->cmd->use_sg) {
 =09=09=09=09=09dc395x_kunmap_atomic_sg(base);
 =09=09=09=09=09local_irq_restore(flags);
+=09=09=09=09=09printk(KERN_DEBUG "dc395x: Unmapped at %p\n", base);
 =09=09=09=09}
 =09=09=09}
=20
@@ -2573,6 +2578,8 @@
 =09=09=09=09=09base =3D dc395x_kmap_atomic_sg((struct scatterlist *)srb->c=
md->request_buffer,
 =09=09=09=09=09=09=09=09     srb->sg_count, &offset, &len);
 =09=09=09=09=09virt =3D base + offset;
+=09=09=09=09=09printk(KERN_DEBUG "dc395x: Needed %u bytes out, mapped %u a=
t %p\n",
+=09=09=09=09=09       left_io, len, base);
 =09=09=09=09} else {
 =09=09=09=09=09virt =3D srb->cmd->request_buffer + srb->cmd->request_buffl=
en - left_io;
 =09=09=09=09=09len =3D left_io;
@@ -2591,6 +2598,7 @@
 =09=09=09=09if (srb->cmd->use_sg) {
 =09=09=09=09=09dc395x_kunmap_atomic_sg(base);
 =09=09=09=09=09local_irq_restore(flags);
+=09=09=09=09=09printk(KERN_DEBUG "dc395x: Unmapped at %p\n", base);
 =09=09=09=09}
 =09=09=09}
=20
---1463811839-1865494336-1139872531=:18538--
