From: akpm@osdl.org
Subject: scsi-ahc_target_state-check-starget-valid.patch added to -mm tree
Date: Fri, 24 Jun 2005 16:35:01 -0700
Message-ID: <200506242334.j5ONY2pE019525@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:32130 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S263232AbVFXXeJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jun 2005 19:34:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: apw@shadowen.org, linux-scsi@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled

     scsi: ahc_target_state check starget valid

has been added to the -mm tree.  Its filename is

     scsi-ahc_target_state-check-starget-valid.patch

Patches currently in -mm which might be from apw@shadowen.org are

gregkh-pci-pci-assign-unassigned-resources-fix.patch
scsi-ahc_target_state-check-starget-valid.patch
sparsemem-extreme.patch
kgdb-ga.patch



From: Andy Whitcroft <apw@shadowen.org>

Since 2.6.12-git1 we have been seeing the Oops below when accessing /proc
files for the aix7xxx driver.  This seems to be as a result of a new
abstraction for scsi targets.  Looking at other uses of the aic7xxx
'starget[]' seems to indicate that it is possible for this to be NULL.  The
patch below adds a check to ahc_dump_target_state before we attempt to map
it to a scsi target.

Unable to handle kernel NULL pointer dereference at virtual address 00000124
 printing eip:
c02482dc
*pde = 1b971001
*pte = 00000000
Oops: 0000 [#1]
SMP
CPU:    2
EIP:    0060:[<c02482dc>]    Not tainted VLI
EFLAGS: 00010296   (2.6.12-git4-autokern1)
EIP is at scsi_is_host_device+0x4/0x18
eax: 00000014   ebx: 00000014   ecx: 00000000   edx: e017fb80
esi: 00000000   edi: ddc0b100   ebp: dffe3ef4   esp: dffe3dac
ds: 007b   es: 007b   ss: 0068
Process cp (pid: 6942, threadinfo=dffe2000 task=dcc27a60)
Stack: c026825b 00000014 00000000 dffe3ef4 dfc55600 0000000f 41268703 c02687c9
       dfc55600 dffe3ef4 00000007 00000041 00000000 00000000 dffe3f68 00000c00
       db6aa000 dffe3f64 37636961 3a393938 746c5520 36316172 69572030 43206564
Call Trace:
 [<c026825b>] ahc_dump_target_state+0xa3/0x10c
 [<c02687c9>] ahc_linux_proc_info+0x199/0x1ca
 [<c0141af6>] do_anonymous_page+0x1ee/0x21c
 [<c0141b0e>] do_anonymous_page+0x206/0x21c
 [<c0141b79>] do_no_page+0x55/0x3d8
 [<c0135f15>] prep_new_page+0x49/0x50
 [<c01365a3>] buffered_rmqueue+0x153/0x1b4
 [<c0136a4b>] __alloc_pages+0x3bb/0x3c8
 [<c024ff3b>] proc_scsi_read+0x2b/0x44
 [<c017d5d8>] proc_file_read+0xec/0x200
 [<c01506b5>] vfs_read+0x8d/0xec
 [<c0150924>] sys_read+0x40/0x6c
 [<c0102df9>] syscall_call+0x7/0xb
Code: fd ff 83 c4 04 c3 90 68 20 ce 3a c0 e8 ca 31 fd ff 83 c4 04 c3 89 f6 68 20 ce 3a c0 e8 46 32 fd ff 83 c4 04 c3 89 f6 8b 44 24 04 <81> b8 10 01 00 00 80 7d 24 c0 0f 94 c0 0f b6 c0 c3 8d 76 00 8b
 <1>Unable to handle kernel NULL pointer dereference at virtual address 00000124 printing eip:
c02482dc
*pde = 1ff59001
*pte = 00000000

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: <linux-scsi@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/aic7xxx/aic7xxx_proc.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/scsi/aic7xxx/aic7xxx_proc.c~scsi-ahc_target_state-check-starget-valid drivers/scsi/aic7xxx/aic7xxx_proc.c
--- 25/drivers/scsi/aic7xxx/aic7xxx_proc.c~scsi-ahc_target_state-check-starget-valid	Fri Jun 24 16:34:43 2005
+++ 25-akpm/drivers/scsi/aic7xxx/aic7xxx_proc.c	Fri Jun 24 16:34:43 2005
@@ -155,6 +155,8 @@ ahc_dump_target_state(struct ahc_softc *
 	copy_info(info, "\tUser: ");
 	ahc_format_transinfo(info, &tinfo->user);
 	starget = ahc->platform_data->starget[target_offset];
+	if (starget == NULL)
+		return;
 	targ = scsi_transport_target_data(starget);
 	if (targ == NULL)
 		return;
_
