From: "Chuck Tuffli" <Chuck_Tuffli@pmc-sierra.com>
Subject: RE: [PATCH v2] libsas: fix bug for vacant phy
Date: Mon, 20 Sep 2010 11:32:04 -0700
Message-ID: <BE430C874DBA6841A75E65151DCC6E1C077DA147@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
References: <BE430C874DBA6841A75E65151DCC6E1C0699F1BA@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca> <D8666BDF2F024F71B478BDCA08C7833D@usish.com.cn> <BE430C874DBA6841A75E65151DCC6E1C0731F42F@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca> <01B7071A8F0947F38977CA217D833D16@usish.com.cn> <27DA42B50CD244D19895F2FCED2191FD@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:54606 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754295Ab0ITTDM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Sep 2010 15:03:12 -0400
Content-class: urn:content-classes:message
In-Reply-To: <27DA42B50CD244D19895F2FCED2191FD@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>, James Bottomley <jejb@kernel.org>, linux-scsi@vger.kernel.org
Cc: lindar_liu <lindar_liu@usish.com>, roy <roy_wang@usish.com>

This fixes the issue I was seeing. Thanks!

-----Original Message-----
From: Jack Wang [mailto:jack_wang@usish.com] 
Sent: Sunday, September 19, 2010 10:52 PM
To: 'Jack Wang'; Chuck Tuffli; 'James Bottomley'; linux-scsi@vger.kernel.org
Cc: 'lindar_liu'; 'roy'
Subject: [PATCH v2] libsas: fix bug for vacant phy


Hi, James

Please drop the previous patch and apply this new one.
Attached patch fix following bugs reported by Chuck.

Chuck
Could you test if this solve your problem ?

Jack -
Signed-off-by: Jack Wang <jack_wang@usish.com>

Signed-off-by: Lindar <lindar_liu@usish.com>
---
 sas_expander.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/sas_expander.c b/sas_expander.c
index d1d86a6..f63dbea 100644
--- a/sas_expander.c
+++ b/sas_expander.c
@@ -175,10 +175,10 @@ static void sas_set_ex_phy(struct domain_device *dev,
int phy_id,
 	switch (resp->result) {
 	case SMP_RESP_PHY_VACANT:
 		phy->phy_state = PHY_VACANT;
-		return;
+		break;
 	default:
 		phy->phy_state = PHY_NOT_PRESENT;
-		return;
+		break;
 	case SMP_RESP_FUNC_ACC:
 		phy->phy_state = PHY_EMPTY; /* do not know yet */
 		break;
@@ -209,7 +209,8 @@ static void sas_set_ex_phy(struct domain_device *dev,
int phy_id,
 	phy->phy->negotiated_linkrate = phy->linkrate;
 
 	if (!rediscover)
-		sas_phy_add(phy->phy);
+		if (sas_phy_add(phy->phy))
+			sas_phy_free(phy->phy);
 
 	SAS_DPRINTK("ex %016llx phy%02d:%c attached: %016llx\n",
 		    SAS_ADDR(dev->sas_addr), phy->phy_id,
-- 
1.7.2.3.msysgit.0


I finally had a chance to try something more recent (2.6.34) and I still see
the problem. I posted my findings to linux-scsi
(http://marc.info/?l=linux-scsi&m=128254243405363&w=2), but no one has
commented. Do you have any suggestions for approaches to fix this? I'm
willing to do the work, but am a little unclear where to look. Thanks!

-----Original Message-----
From: jack wang [mailto:jack_wang@usish.com] 
Sent: Thursday, July 08, 2010 6:35 PM
To: Chuck Tuffli
Cc: 'lindar_liu'; 'aoqingy'; 'roy'
Subject: RE: BUG reported during pm8001 driver rmmod

Hi Jack.

We have been using your Linux driver for testing and it has been working
great (thanks!). Today I tested against a new JBOD (HP D2700) and am
hitting an error when unloading the driver. Note that I don't see this
error with other JBODs (IBM, USI, etc), only the new one. Have you seen
anything like this before?

Chuck

[510] uname -srv
Linux 2.6.31-22-server #60-Ubuntu SMP Thu May 27 03:42:09 UTC 2010
[511] sudo insmod ./pm8001.ko 
[512] sudo rmmod pm8001 
Segmentation fault
[513] dmesg
...
[14131.624620] pm8001 0000:09:00.0: pm8001: driver version 0.1.36
[14131.630619] pm8001 0000:09:00.0: PCI INT A -> GSI 16 (level, low) ->
IRQ 16
[14131.637752] pm8001 0000:09:00.0: setting latency timer to 64
[14132.541239] scsi4 : pm8001
[14132.544347]   alloc irq_desc for 97 on node 0
[14132.548799]   alloc kstat_irqs on node 0
[14132.552851] pm8001 0000:09:00.0: irq 97 for MSI/MSI-X
[14248.581889] scsi 4:0:0:0: Direct-Access     HP       DG0300FARVV
HPD6 PQ: 0 ANSI: 5
[14248.590706] sd 4:0:0:0: Attached scsi generic sg2 type 0
[14248.596738] sd 4:0:0:0: [sdb] 585937500 512-byte logical blocks: (300
GB/279 GiB)
[14248.605469] sd 4:0:0:0: [sdb] Write Protect is off
[14248.610371] sd 4:0:0:0: [sdb] Mode Sense: eb 00 10 08
[14248.616130] sd 4:0:0:0: [sdb] Write cache: disabled, read cache:
enabled, supports DPO and FUA
[14248.627080]  sdb: unknown partition table
[14248.634138] sd 4:0:0:0: [sdb] Attached SCSI disk
[14248.656076] scsi 4:0:1:0: Enclosure         HP       D2700 SAS AJ941A
0052 PQ: 0 ANSI: 5
[14248.667852] scsi 4:0:1:0: Attached scsi generic sg3 type 13
[14248.945688] ses 4:0:1:0: Attached Enclosure device
[14288.328616] pm8001 0000:09:00.0: PCI INT A disabled
[14288.333712] ------------[ cut here ]------------
[14288.338429] kernel BUG at
/build/buildd/linux-2.6.31/include/linux/transport_class.h:92!
[14288.343639] invalid opcode: 0000 [#1] SMP 
[14288.343639] last sysfs file:
/sys/devices/pci0000:00/0000:00:1c.0/0000:09:00.0/host4/port-4:0/expande
r-4:0/port-4:0:36/end_device-4:0:36/target4:0:1/4:0:1:0/type
[14288.362505] CPU 0 
[14288.362505] Modules linked in: ses enclosure pm8001(-) nfs lockd
nfs_acl auth_rpcgss sunrpc radeon ttm drm libsas i2c_algo_bit
scsi_transport_sas iptable_filter psmouse ip_tables i5400_edac edac_core
lp x_tables serio_raw i5k_amb shpchp parport floppy igb dca
[14288.391254] Pid: 1204, comm: rmmod Not tainted 2.6.31-22-server
#60-Ubuntu X7DW3
[14288.392505] RIP: 0010:[<ffffffffa00c10c8>]  [<ffffffffa00c10c8>]
sas_release_transport+0x88/0x90 [scsi_transport_sas]
[14288.402505] RSP: 0018:ffff88003cdd5eb8  EFLAGS: 00010286
[14288.412505] RAX: 00000000fffffff0 RBX: ffff88003b698000 RCX:
01000000000000c1
[14288.422505] RDX: ffff88003b698700 RSI: ffffffff812782b0 RDI:
ffffffff817d8fa0
[14288.422505] RBP: ffff88003cdd5ec8 R08: 0000000000000000 R09:
0000000000000000
[14288.432505] R10: 0000000000000000 R11: ffff88003d94d9f4 R12:
ffffffffa02a6fa0
[14288.442505] R13: 0000000000000000 R14: 00007fff3e63a700 R15:
0000000000000001
[14288.451254] FS:  00007f8dd6c6d6f0(0000) GS:ffff8800019f3000(0000)
knlGS:0000000000000000
[14288.452505] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[14288.462505] CR2: 00007fed69a640a0 CR3: 000000003c8ef000 CR4:
00000000000006f0
[14288.472505] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[14288.472505] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[14288.482505] Process rmmod (pid: 1204, threadinfo ffff88003cdd4000,
task ffff88003ca516b0)
[14288.492505] Stack:
[14288.492505]  0000000000000000 0000000000000880 ffff88003cdd5ed8
ffffffffa029dd20
[14288.502505] <0> ffff88003cdd5f78 ffffffff8108ed38 ffff88003cdd5ef8
ffffffff8107c909
[14288.512505] <0> ffffffffa02a6fa0 ffffffff00000880 ffff88003cdd5f14
0000000000000014
[14288.521254] Call Trace:
[14288.522505]  [<ffffffffa029dd20>] pm8001_exit+0x1c/0x1e [pm8001]
[14288.522505]  [<ffffffff8108ed38>] sys_delete_module+0x1a8/0x280
[14288.532505]  [<ffffffff8107c909>] ? up_read+0x9/0x10
[14288.541254]  [<ffffffff81012042>] system_call_fastpath+0x16/0x1b
[14288.542505] Code: 0f 6c 26 e1 85 c0 75 13 48 89 df e8 d3 31 05 e1 48
83 c4 08 5b c9 c3 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b
eb fe <0f> 0b eb fe 0f 1f 40 00 55 48 89 e5 41 56 41 55 41 54 53 4c 8b 
[14288.562505] RIP  [<ffffffffa00c10c8>] sas_release_transport+0x88/0x90
[scsi_transport_sas]
[14288.572505]  RSP <ffff88003cdd5eb8>
[14288.580975] ---[ end trace 0436c237fa6eeca0 ]---

Hi， Chuck
I haven't seen this bug before and We don't have the HP JBOD to test. It
seams you hit the bug in linux-2.6.31/include/linux/transport_class.h:92!,
the problem is transport unresgister the HP Enclosure HP D2700,
the bug appears. Maybe there something wrong with the ses && enclosure
modules , could you update to newer kernel to see whether the bug 
still exists?
