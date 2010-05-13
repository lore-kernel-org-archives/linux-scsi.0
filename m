From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [QEMU-KVM]: Megasas + TCM_Loop + SG_IO into Windows XP guests
Date: Thu, 13 May 2010 14:38:51 -0700
Message-ID: <1273786731.13658.49.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp106.sbc.mail.gq1.yahoo.com ([67.195.14.109]:27884 "HELO
	smtp106.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752879Ab0EMVjA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2010 17:39:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Gerd Hoffmann <kraxel@redhat.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.w>
Cc: kvm-devel <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>, linux-scsi <linux-scsi@vger.kernel.org>

Greetings Hannes and co,

I have been spending a bit of time trying Megasas HBA emulation +
TCM_Loop + SG_IO with a Windows XP SP2 KVM guests..  So far, I noticed
that hw/scsi-generic.c:execute_command_run() using bdev_aio_ioctl()
appears to be broken for XP guests, which causes the first 36-byte
INQUIRY sent via SG_IO to never make it back to QEMU and results in the
win32 LSI drive taking the LUN offline, et al.  Note that everything
does appear to be functioning as expected in kernel space for the first
INQUIRY with the TCM_Loop LLD and Linux/SCSI code (AFAICT) and Linux KVM
guests using megasas emulation are still working.

So, I ended up needing requiring the following quick hack for
hw/scsi-generic.c:execute_command_run() to make SG_IO function
synchronously using bdrv_ioctl(), which at least gets LUN registration
and basic control path CDBs working for the XP guest.

Here is how it looks in action on a v2.6.34-rc7 host so far:

http://www.linux-iscsi.org/images/TCM-KVM-megasas-XP-05132010.png


diff --git a/hw/scsi-generic.c b/hw/scsi-generic.c
index 6c58742..aa1eb83 100644
--- a/hw/scsi-generic.c
+++ b/hw/scsi-generic.c
@@ -140,6 +140,7 @@ static int execute_command_run(SCSIGenericReq *r,
 {
     BlockDriverState *bdrv = r->req.dev->conf.dinfo->bdrv;
     SCSIGenericState *s = DO_UPCAST(SCSIGenericState, qdev, r->req.dev);
+    int ret;
 
     r->io_header.interface_id = 'S';
     r->io_header.dxfer_direction = sgdir[r->req.cmd.mode];
@@ -161,11 +162,16 @@ static int execute_command_run(SCSIGenericReq *r,
     printf("\n");
     }
 #endif
+#if 0
     r->req.aiocb = bdrv_aio_ioctl(bdrv, SG_IO, &r->io_header, complete, r);
     if (r->req.aiocb == NULL) {
         BADF("execute_command: read failed !\n");
         return -1;
     }
+#else
+    ret = bdrv_ioctl(bdrv, SG_IO, &r->io_header);
+    complete((void *)r, ret);
+#endif
 
      *      return 0;
 }


Beyond the initial LUN registration and control CDB parts, doing bulk
DATA_SG_IO traffic is completing successfully (and everything looks sane
with TCM_Loop and Linux/SCSI) but it appears that the correct blocks are
not actually getting written/read by megasas.  This appears to be the
case with both hw/scsi-generic.c and hw/scsi-disk.c modes of operation
for megasas with the win32 XP guest.

So I was wondering if anyone aware of known issues with QEMU
asynchronous SG_IO into MSFT KVM guests with virtio or hw/lsi53c895a.c,
or would this be something specific to megasas HBA emulation and XP
guests..?

Hannes, which MSFT guest + driver did you get work stable with bulk
DATA_SG_IO and hw/scsi-disk.c..?

Best,

--nab

