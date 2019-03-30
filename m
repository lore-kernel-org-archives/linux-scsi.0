From: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH AUTOSEL 4.14 17/37] scsi: iscsi: flush running unbind operations when removing a session
Date: Fri, 29 Mar 2019 20:54:18 -0400
Message-ID: <20190330005441.27540-17-sashal@kernel.org>
References: <20190330005441.27540-1-sashal@kernel.org>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <open-iscsi+bncBDTZTRGMXIFBB3747LSAKGQE3AZJL6A-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <20190330005441.27540-1-sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Maurizio Lombardi <mlombard-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

From: Maurizio Lombardi <mlombard-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

[ Upstream commit 165aa2bfb42904b1bec4bf2fa257c8c603c14a06 ]

In some cases, the iscsi_remove_session() function is called while an
unbind_work operation is still running.  This may cause a situation where
sysfs objects are removed in an incorrect order, triggering a kernel
warning.

[  605.249442] ------------[ cut here ]------------
[  605.259180] sysfs group 'power' not found for kobject 'target2:0:0'
[  605.321371] WARNING: CPU: 1 PID: 26794 at fs/sysfs/group.c:235 sysfs_rem=
ove_group+0x76/0x80
[  605.341266] Modules linked in: dm_service_time target_core_user target_c=
ore_pscsi target_core_file target_core_iblock iscsi_target_mod target_core_=
mod nls_utf8 isofs ppdev bochs_drm nfit ttm libnvdimm drm_kms_helper syscop=
yarea sysfillrect sysimgblt joydev pcspkr fb_sys_fops drm i2c_piix4 sg parp=
ort_pc parport xfs libcrc32c dm_multipath sr_mod sd_mod cdrom ata_generic 8=
021q garp mrp ata_piix stp crct10dif_pclmul crc32_pclmul llc libata crc32c_=
intel virtio_net net_failover ghash_clmulni_intel serio_raw failover sunrpc=
 dm_mirror dm_region_hash dm_log dm_mod be2iscsi bnx2i cnic uio cxgb4i cxgb=
4 libcxgbi libcxgb qla4xxx iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi=
 scsi_transport_iscsi
[  605.627479] CPU: 1 PID: 26794 Comm: kworker/u32:2 Not tainted 4.18.0-60.=
el8.x86_64 #1
[  605.721401] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
?-20180724_192412-buildhw-07.phx2.fedoraproject.org-1.fc29 04/01/2014
[  605.823651] Workqueue: scsi_wq_2 __iscsi_unbind_session [scsi_transport_=
iscsi]
[  605.830940] RIP: 0010:sysfs_remove_group+0x76/0x80
[  605.922907] Code: 48 89 df 5b 5d 41 5c e9 38 c4 ff ff 48 89 df e8 e0 bf =
ff ff eb cb 49 8b 14 24 48 8b 75 00 48 c7 c7 38 73 cb a7 e8 24 77 d7 ff <0f=
> 0b 5b 5d 41 5c c3 0f 1f 00 0f 1f 44 00 00 41 56 41 55 41 54 55
[  606.122304] RSP: 0018:ffffbadcc8d1bda8 EFLAGS: 00010286
[  606.218492] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000000=
00000
[  606.326381] RDX: ffff98bdfe85eb40 RSI: ffff98bdfe856818 RDI: ffff98bdfe8=
56818
[  606.514498] RBP: ffffffffa7ab73e0 R08: 0000000000000268 R09: 00000000000=
00007
[  606.529469] R10: 0000000000000000 R11: ffffffffa860d9ad R12: ffff98bdf97=
8e838
[  606.630535] R13: ffff98bdc2cd4010 R14: ffff98bdc2cd3ff0 R15: ffff98bdc2c=
d4000
[  606.824707] FS:  0000000000000000(0000) GS:ffff98bdfe840000(0000) knlGS:=
0000000000000000
[  607.018333] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  607.117844] CR2: 00007f84b78ac024 CR3: 000000002c00a003 CR4: 00000000003=
606e0
[  607.117844] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  607.420926] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[  607.524236] Call Trace:
[  607.530591]  device_del+0x56/0x350
[  607.624393]  ? ata_tlink_match+0x30/0x30 [libata]
[  607.727805]  ? attribute_container_device_trigger+0xb4/0xf0
[  607.829911]  scsi_target_reap_ref_release+0x39/0x50
[  607.928572]  scsi_remove_target+0x1a2/0x1d0
[  608.017350]  __iscsi_unbind_session+0xb3/0x160 [scsi_transport_iscsi]
[  608.117435]  process_one_work+0x1a7/0x360
[  608.132917]  worker_thread+0x30/0x390
[  608.222900]  ? pwq_unbound_release_workfn+0xd0/0xd0
[  608.323989]  kthread+0x112/0x130
[  608.418318]  ? kthread_bind+0x30/0x30
[  608.513821]  ret_from_fork+0x35/0x40
[  608.613909] ---[ end trace 0b98c310c8a6138c ]---

Signed-off-by: Maurizio Lombardi <mlombard-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transp=
ort_iscsi.c
index f6542c159ed6..b4d06bd9ed51 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2185,6 +2185,8 @@ void iscsi_remove_session(struct iscsi_cls_session *s=
ession)
 	scsi_target_unblock(&session->dev, SDEV_TRANSPORT_OFFLINE);
 	/* flush running scans then delete devices */
 	flush_work(&session->scan_work);
+	/* flush running unbind operations */
+	flush_work(&session->unbind_work);
 	__iscsi_unbind_session(&session->unbind_work);
=20
 	/* hw iscsi may not have removed all connections from session */
--=20
2.19.1

--=20
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
