From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aacraid: fix panic on short Inquiry
Date: Wed, 16 May 2007 09:14:26 -0400
Message-ID: <1179321266.3787.14.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:54197 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751559AbXEPNOb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 May 2007 09:14:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

This was actually seen at a customer site running RHEL5:

Unable to handle kernel paging request at ffff8101c0000000 RIP: 
 [<ffffffff880b22a1>] :aacraid:aac_internal_transfer+0xd6/0xe3
PGD 8063 PUD 0 
Oops: 0000 [1] SMP 
last sysfs file: /block/sdb/removable
CPU 2 
Modules linked in: autofs4(U) hidp(U) nfs(U) lockd(U) fscache(U) nfs_acl(U) rfcomm(U) l2cap(U) bluetooth(U) sunrpc(U) ipv6(U) cpufreq_ondemand(U) dm_mirror(U) dm_mod(U) video(U) sbs(U) i2c_ec(U) button(U) battery(U) asus_acpi(U) acpi_memhotplug(U) ac(U) parport_pc(U) lp(U) parport(U) joydev(U) ide_cd(U) i2c_i801(U) i2c_core(U) shpchp(U) cdrom(U) bnx2(U) sg(U) pcspkr(U) ata_piix(U) libata(U) aacraid(U) sd_mod(U) scsi_mod(U) ext3(U) jbd(U) ehci_hcd(U) ohci_hcd(U) uhci_hcd(U)
Pid: 2352, comm: syslogd Not tainted 2.6.18-prep #1
RIP: 0010:[<ffffffff880b22a1>]  [<ffffffff880b22a1>] :aacraid:aac_internal_transfer+0xd6/0xe3
RSP: 0000:ffff8101bfd1fe68  EFLAGS: 00010083
RAX: 0000000000000063 RBX: 0000000000000008 RCX: 00000000ffd1fea0
RDX: ffffffff802da628 RSI: ffff8101c0000000 RDI: ffff8101b2a08168
RBP: ffff8101b2728010 R08: ffffffff802da628 R09: 0000000000000046
R10: 0000000000000000 R11: 0000000000000080 R12: 0000000000000010
R13: ffff8101bfd1fea8 R14: ffff8101bc74df58 R15: ffff8101bc74df58
FS:  00002aaaab0146f0(0000) GS:ffff8101bfcd2e40(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff8101c0000000 CR3: 00000001bdecd000 CR4: 00000000000006e0
Process syslogd (pid: 2352, threadinfo ffff8101bc74c000, task ffff8101bd979040)
Stack:  0000000000000012 0000000000000036 0000000000000000 ffff8101bee9a800
 ffff8101be9d3a00 ffff8101be9d3a00 ffff8101be8014f8 ffffffff880b26cc
 40212227607e3141 2029282a26252423 0000000000000003 ffff810037e3a000
Call Trace:
 <IRQ>  [<ffffffff880b26cc>] :aacraid:get_container_name_callback+0x8b/0xb5
 [<ffffffff880b6f67>] :aacraid:aac_intr_normal+0x1b3/0x1f9
 [<ffffffff880b8007>] :aacraid:aac_rkt_intr+0x37/0x115
 [<ffffffff80099749>] __rcu_process_callbacks+0xf8/0x1a8
 [<ffffffff80010705>] handle_IRQ_event+0x29/0x58
 [<ffffffff800b2fe0>] __do_IRQ+0xa4/0x105
 [<ffffffff80011c19>] __do_softirq+0x5e/0xd5
 [<ffffffff8006a193>] do_IRQ+0xe7/0xf5
 [<ffffffff8005b649>] ret_from_intr+0x0/0xa

On digging into it, it turned out that the customer was probing an
aacraid device with an INQUIRY of 8 bytes.  The way aacraid works, it
was blindly trying to use aac_internal_transfer to copy the container
name to byte 16 of the inquiry data, resulting in a negative transfer
length.  It then copies over the whole of kernel memory before dropping
off the end.

The fix is simple.  However, I'm beginning to think that each of these
separate copy into scatterlist routines we have sprayed throughout the
drivers are asking for bugs like this.  I can apply the simple fix now,
but long term I think we want a library routine to do this correctly for
everyone.

James

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 1e82c69..089f5b9 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -351,7 +351,7 @@ static void aac_internal_transfer(struct scsi_cmnd *scsicmd, void *data, unsigne
 		transfer_len = min(scsicmd->request_bufflen, len + offset);
 	}
 	transfer_len -= offset;
-	if (buf && transfer_len)
+	if (buf && transfer_len > 0)
 		memcpy(buf + offset, data, transfer_len);
 
 	if (scsicmd->use_sg) 


