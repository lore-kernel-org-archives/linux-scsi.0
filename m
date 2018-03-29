From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Recent kernels fail to boot on POWER8 with multipath
	SCSI
Date: Thu, 29 Mar 2018 11:16:54 -0400
Message-ID: <20180329151654.GA3839@redhat.com>
References: <20180329083909.GA15766@fergus.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180329083909.GA15766@fergus.ozlabs.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Paul Mackerras <paulus@ozlabs.org>
Cc: Michael Ellerman <michael@ellerman.id.au>, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 29 2018 at  4:39am -0400,
Paul Mackerras <paulus@ozlabs.org> wrote:

> Since commit 8d47e65948dd ("dm mpath: remove unnecessary NVMe
> branching in favor of scsi_dh checks", 2018-03-05), upstream kernels
> fail to boot on my POWER8 box which has multipath SCSI disks.  The
> host adapters are IPR and the userspace is CentOS 7.
> 
> Before that commit, the system booted fine.  After that, it fails with
> a NULL pointer dereference until we get to commits c37366742baa ("dm
> mpath: fix uninitialized 'pg_init_wait' waitqueue_head NULL pointer",
> 2018-03-12) and e8f74a0f0011 ("dm mpath: eliminate need to use
> scsi_device_from_queue", 2018-03-12), both of which say they fix
> 8d47e65948dd.  From commit e8f74a0f0011 on, I see some warnings from
> the workqueue code, and the system does not find its root disk.
> 
> Here are some annotated logs.
> 
> The crash from e8f74a0f0011 until c37366742baa looks like this:

<snip, not _that_ interesting other than we know the fix (c37366742baa)
unlocks your next hurdle: the pg_init_all_paths hang>
 
> After e8f74a0f0011, the logs look like this:
> 
> [   38.042638] device-mapper: multipath service-time: version 0.3.0 loaded
> [   38.049825] WARNING: CPU: 16 PID: 1414 at /home/paulus/kernel/kvm/kernel/workqueue.c:1513 __queue_delayed_work+0x10c/0x130
> [   38.049936] Modules linked in: dm_service_time lpfc(+) radeon(+) nvme_fc nvme_fabrics nvme_core scsi_transport_fc i2c_algo_bit drm_kms_helper tg3 syscopyarea sysfillrect sysimgblt fb_sys_fops ttm dm_multipath drm drm_panel_orientation_quirks i2c_core cxgb3(+) mlx5_core(+) mdio
> [   38.050176] CPU: 16 PID: 1414 Comm: systemd-udevd Not tainted 4.16.0-rc5-kvm+ #117
> [   38.050264] NIP:  c00000000012bcac LR: c00000000012bd94 CTR: c00000000012bcd0
> [   38.050347] REGS: c000000ff3df3800 TRAP: 0700   Not tainted  (4.16.0-rc5-kvm+)
> [   38.050422] MSR:  9000000000029033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 24022884  XER: 00000000
> [   38.050475] tg3 0003:05:00.3 enP3p5s0f3: renamed from eth3
> [   38.050504] CFAR: c00000000012bbf8 SOFTE: 1 
> [   38.050504] GPR00: c00000000012bd94 c000000ff3df3a80 c00000000149a100 c000000feef30c50 
> [   38.050504] GPR04: c000000fdb660800 c000000feef30c30 0000000000000000 0000000000000000 
> [   38.050504] GPR08: 0000000000000001 c00000000012bb50 0000000000000000 d00000000be25130 
> [   38.050504] GPR12: c00000000012bcd0 c00000000fd4b000 0000000112942aa0 0000000000000000 
> [   38.050504] GPR16: 0000000112940fe0 0000000112941048 0000000112980a00 0000000112942b00 
> [   38.050504] GPR20: 0000000112980030 000001003cdc3059 000001003cdc3199 0000000000000007 
> [   38.050504] GPR24: 0000000000000000 0000000000000000 c000000ff3df3c88 0000000000000400 
> [   38.050504] GPR28: 0000000000000000 0000000000000400 c000000fdb660800 c000000feef30c30 
> [   38.051216] NIP [c00000000012bcac] __queue_delayed_work+0x10c/0x130
> [   38.051284] LR [c00000000012bd94] queue_delayed_work_on+0xc4/0x100
> [   38.051350] Call Trace:
> [   38.051381] [c000000ff3df3a80] [c000000ff14e0180] 0xc000000ff14e0180 (unreliable)
> [   38.051462] [c000000ff3df3ac0] [c00000000012bd94] queue_delayed_work_on+0xc4/0x100
> [   38.051541] [c000000ff3df3b10] [d00000000be20c98] __pg_init_all_paths+0x108/0x190 [dm_multipath]
> [   38.051635] [c000000ff3df3b50] [d00000000be20d68] pg_init_all_paths+0x48/0x80 [dm_multipath]
> [   38.051729] [c000000ff3df3b90] [d00000000be22b18] multipath_prepare_ioctl+0x148/0x160 [dm_multipath]
> [   38.051825] [c000000ff3df3bd0] [c000000000914e20] dm_get_bdev_for_ioctl+0x120/0x1b0
> [   38.051908] [c000000ff3df3c20] [c00000000091525c] dm_blk_ioctl+0x4c/0x110
> [   38.051977] [c000000ff3df3ca0] [c0000000005a62c8] blkdev_ioctl+0x5f8/0xbd0
> [   38.052046] [c000000ff3df3d00] [c0000000003e8b74] block_ioctl+0x64/0xd0
> [   38.052115] [c000000ff3df3d40] [c0000000003a87b8] do_vfs_ioctl+0xd8/0x8c0
> [   38.052184] [c000000ff3df3de0] [c0000000003a9074] SyS_ioctl+0xd4/0x130
> [   38.052254] [c000000ff3df3e30] [c00000000000b8e0] system_call+0x58/0x6c
> [   38.052320] Instruction dump:
> [   38.052359] 38210040 e8010010 eb81ffe0 eba1ffe8 ebc1fff0 ebe1fff8 7c0803a6 4bfff810 
> [   38.052438] 0fe00000 4bffff78 0fe00000 4bffff60 <0fe00000> 4bffff4c 0fe00000 4bffff30 
> [   38.052538] ---[ end trace a130dfb7aec21e53 ]---
> [   38.052662] WARNING: CPU: 16 PID: 1414 at /home/paulus/kernel/kvm/kernel/workqueue.c:1515 __queue_delayed_work+0xfc/0x130
> [   38.052912] Modules linked in: dm_service_time lpfc(+) radeon(+) nvme_fc nvme_fabrics nvme_core scsi_transport_fc i2c_algo_bit drm_kms_helper tg3 syscopyarea sysfillrect sysimgblt fb_sys_fops ttm dm_multipath drm drm_panel_orientation_quirks i2c_core cxgb3(+) mlx5_core(+) mdio
> [   38.053563] CPU: 16 PID: 1414 Comm: systemd-udevd Tainted: G        W        4.16.0-rc5-kvm+ #117
> [   38.053788] NIP:  c00000000012bc9c LR: c00000000012bd94 CTR: c00000000012bcd0
> [   38.053939] REGS: c000000ff3df3800 TRAP: 0700   Tainted: G        W         (4.16.0-rc5-kvm+)
> [   38.054104] MSR:  9000000000029033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 24022884  XER: 00000000
> [   38.054264] CFAR: c00000000012bc14 SOFTE: 1 
> [   38.054264] GPR00: c00000000012bd94 c000000ff3df3a80 c00000000149a100 c000000feef30c50 
> [   38.054264] GPR04: c000000fdb660800 c000000feef30c30 0000000000000000 0000000000000000 
> [   38.054264] GPR08: 0000000000000001 c000000feef30c38 0000000000000000 d00000000be25130 
> [   38.054264] GPR12: c00000000012bcd0 c00000000fd4b000 0000000112942aa0 0000000000000000 
> [   38.054264] GPR16: 0000000112940fe0 0000000112941048 0000000112980a00 0000000112942b00 
> [   38.054264] GPR20: 0000000112980030 000001003cdc3059 000001003cdc3199 0000000000000007 
> [   38.054264] GPR24: 0000000000000000 0000000000000000 c000000ff3df3c88 0000000000000400 
> [   38.054264] GPR28: 0000000000000000 0000000000000400 c000000fdb660800 c000000feef30c30 
> [   38.055499] NIP [c00000000012bc9c] __queue_delayed_work+0xfc/0x130
> [   38.055611] LR [c00000000012bd94] queue_delayed_work_on+0xc4/0x100
> [   38.055725] Call Trace:
> [   38.055775] [c000000ff3df3a80] [c000000ff14e0180] 0xc000000ff14e0180 (unreliable)
> [   38.055912] [c000000ff3df3ac0] [c00000000012bd94] queue_delayed_work_on+0xc4/0x100
> [   38.056051] [c000000ff3df3b10] [d00000000be20c98] __pg_init_all_paths+0x108/0x190 [dm_multipath]
> [   38.056211] [c000000ff3df3b50] [d00000000be20d68] pg_init_all_paths+0x48/0x80 [dm_multipath]
> [   38.056370] [c000000ff3df3b90] [d00000000be22b18] multipath_prepare_ioctl+0x148/0x160 [dm_multipath]
> [   38.056531] [c000000ff3df3bd0] [c000000000914e20] dm_get_bdev_for_ioctl+0x120/0x1b0
> [   38.056668] [c000000ff3df3c20] [c00000000091525c] dm_blk_ioctl+0x4c/0x110
> [   38.056783] [c000000ff3df3ca0] [c0000000005a62c8] blkdev_ioctl+0x5f8/0xbd0
> [   38.056898] [c000000ff3df3d00] [c0000000003e8b74] block_ioctl+0x64/0xd0
> [   38.057013] [c000000ff3df3d40] [c0000000003a87b8] do_vfs_ioctl+0xd8/0x8c0
> [   38.057121] [c000000ff3df3de0] [c0000000003a9074] SyS_ioctl+0xd4/0x130
> [   38.057184] [c000000ff3df3e30] [c00000000000b8e0] system_call+0x58/0x6c
> [   38.057245] Instruction dump:
> [   38.057283] 60420000 7fa3eb78 7fc4f378 7fe5fb78 38210040 e8010010 eb81ffe0 eba1ffe8 
> [   38.057360] ebc1fff0 ebe1fff8 7c0803a6 4bfff810 <0fe00000> 4bffff78 0fe00000 4bffff60 
> [   38.057437] ---[ end trace a130dfb7aec21e54 ]---
> [   38.057491] WARNING: CPU: 16 PID: 1414 at /home/paulus/kernel/kvm/kernel/workqueue.c:1444 __queue_work+0x15c/0x5c0
> [   38.057588] Modules linked in: dm_service_time lpfc(+) radeon(+) nvme_fc nvme_fabrics nvme_core scsi_transport_fc i2c_algo_bit drm_kms_helper tg3 syscopyarea sysfillrect sysimgblt fb_sys_fops ttm dm_multipath drm drm_panel_orientation_quirks i2c_core cxgb3(+) mlx5_core(+) mdio
> [   38.057818] CPU: 16 PID: 1414 Comm: systemd-udevd Tainted: G        W        4.16.0-rc5-kvm+ #117
> [   38.057905] NIP:  c00000000012b5fc LR: c00000000012b5d0 CTR: c00000000012bcd0
> [   38.057979] REGS: c000000ff3df3760 TRAP: 0700   Tainted: G        W         (4.16.0-rc5-kvm+)
> [   38.058063] MSR:  9000000000029033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 24022844  XER: 00000000
> [   38.058141] CFAR: c000000000b9e020 SOFTE: 1 
> [   38.058141] GPR00: c00000000012b5d0 c000000ff3df39e0 c00000000149a100 c000000ffa210800 
> [   38.058141] GPR04: c000000feef30c30 0000000000000000 0000000000000000 c0000000014c9d70 
> [   38.058141] GPR08: 0000000000000000 0000000000000001 0000000000000000 d00000000be25130 
> [   38.058141] GPR12: c00000000012bcd0 c00000000fd4b000 0000000112942aa0 0000000000000000 
> [   38.058141] GPR16: 0000000112940fe0 0000000112941048 c000000000dd89f0 0000000000000001 
> [   38.058141] GPR20: 0000000000000000 c000000000fec8a8 c000000001664b30 0000000000000000 
> [   38.058141] GPR24: c000000001664b28 c000000fff526e80 0000000000000010 c000000000fec8a8 
> [   38.058141] GPR28: 0000000000000400 c000000fdb660800 c000000feef30c30 c000000fd9530400 
> [   38.058879] NIP [c00000000012b5fc] __queue_work+0x15c/0x5c0
> [   38.058972] LR [c00000000012b5d0] __queue_work+0x130/0x5c0
> [   38.059064] Call Trace:
> [   38.059114] [c000000ff3df39e0] [c00000000012b5d0] __queue_work+0x130/0x5c0 (unreliable)
> [   38.059252] [c000000ff3df3ac0] [c00000000012bd94] queue_delayed_work_on+0xc4/0x100
> [   38.059390] [c000000ff3df3b10] [d00000000be20c98] __pg_init_all_paths+0x108/0x190 [dm_multipath]
> [   38.059549] [c000000ff3df3b50] [d00000000be20d68] pg_init_all_paths+0x48/0x80 [dm_multipath]
> [   38.059709] [c000000ff3df3b90] [d00000000be22b18] multipath_prepare_ioctl+0x148/0x160 [dm_multipath]
> [   38.059869] [c000000ff3df3bd0] [c000000000914e20] dm_get_bdev_for_ioctl+0x120/0x1b0
> [   38.060006] [c000000ff3df3c20] [c00000000091525c] dm_blk_ioctl+0x4c/0x110
> [   38.060121] [c000000ff3df3ca0] [c0000000005a62c8] blkdev_ioctl+0x5f8/0xbd0
> [   38.060237] [c000000ff3df3d00] [c0000000003e8b74] block_ioctl+0x64/0xd0
> [   38.060362] [c000000ff3df3d40] [c0000000003a87b8] do_vfs_ioctl+0xd8/0x8c0
> [   38.060477] [c000000ff3df3de0] [c0000000003a9074] SyS_ioctl+0xd4/0x130
> [   38.060592] [c000000ff3df3e30] [c00000000000b8e0] system_call+0x58/0x6c
> [   38.060706] Instruction dump:
> [   38.060777] 48a729fd 60000000 813f0018 2f890000 41de0318 60000000 7fc9f378 e9490009 
> [   38.060919] 7d295278 7d290074 7929d182 69290001 <0b090000> 2fa90000 40de0364 815f0010 
> [   38.061061] ---[ end trace a130dfb7aec21e55 ]---
> 
> After that, apart from a few messages from unrelated drivers, the
> system just sits there, and never finds its disks.  There are no
> messages with "alua" in them.
> 
> Interestingly (and puzzlingly) if I build a kernel with everything
> built in including dm-multipath, and adjust the startup scripts to
> ignore errors on "modprobe dm-multipath", the system boots
> successfully with recent upstream kernels (4.16.0-rc6 and on).

Rather than build in all the modules, you likely could've accomplished
the same by telling dracut (initramfs) to load all the scsi_dh modules
immediately, e.g. (assuming the initramfs has the scsi_dh_alua module):
  add this to the kernel commandline: rd.driver.pre=scsi_dh_alua

FYI, this racey scsi_dh-needed-at-boot situation is _exactly_ why
RHEL7's config builds in all the scsi_dh rather than leave them as
modules.

> Any ideas what's going wrong here, or how to start debugging it?

Certainly a staggering level of complexity to pick through.

So to be clear: you are _not_ using multipath for the root volume?
If not, the first thing I'd do is eliminate multipath from the
initramfs, e.g.: dracut -o multipath

But please share the 'dm table' for the multipath device(s) in
question -- as collected from having gotten the system to boot.

I'd also appreciate if you shared earlier in the boot log, specifically:
when is scsi_dh_alua loaded?  Is it loaded _before_ the scsi scan?  Or
are you relying on dm-multipath to load the scsi_dh_alua?  I'm thinking
the initramfs is managing to get scsi_dh_alua loaded _before_ multipath
given that there is no late ALUA attachment in the log.

But that aside, it doesn't change the fact that I shouldn't have caused
this unnecessary-multipath-activation-via-init to regress ;)

Looking at the diff for the changes in question:
  git diff 8d47e65948dd^..e8f74a0f001 -- drivers/md/dm-mpath.c

The collective changes rely on more heavily is whether or not
m->hw_handler_name is set.  In your case it _should_ be set to alua.

But now that I look at it, this hunk could cause problems if the scsi_dh
isn't already attached (as would be the case if scsi_dh_alua wasn't
loaded yet, even if you specified "alua" in the multipath dm table):

@@ -891,9 +885,11 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
                goto bad;
        }

-       if (m->queue_mode != DM_TYPE_NVME_BIO_BASED) {
+       q = bdev_get_queue(p->path.dev->bdev);
+       attached_handler_name = scsi_dh_attached_handler_name(q, GFP_KERNEL);
+       if (attached_handler_name) {
                INIT_DELAYED_WORK(&p->activate_path, activate_path_work);
-               r = setup_scsi_dh(p->path.dev->bdev, m, &ti->error);
+               r = setup_scsi_dh(p->path.dev->bdev, m, attached_handler_name, &ti->error);
                if (r) {
                        dm_put_device(ti, p->path.dev);
                        goto bad;

Please try this patch, it'll likely fix your issues:

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index dbddcdc5a4ec..746dd8a75b4a 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -887,7 +887,7 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 
 	q = bdev_get_queue(p->path.dev->bdev);
 	attached_handler_name = scsi_dh_attached_handler_name(q, GFP_KERNEL);
-	if (attached_handler_name) {
+	if (attached_handler_name || m->hw_handler_name) {
 		INIT_DELAYED_WORK(&p->activate_path, activate_path_work);
 		r = setup_scsi_dh(p->path.dev->bdev, m, attached_handler_name, &ti->error);
 		if (r) {
