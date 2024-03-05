Received: from ns2.wdyn.eu (ns2.wdyn.eu [5.252.227.236])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0553C86AC2
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 15:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.252.227.236
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709651588; cv=none; b=Nlkss9QKwdrKs5Sg1MnYZeJ/yO/0Na2JHz79CD3hmiQW/kiNs17OEFYL1cZZ6ouMdcHk5yduJ9F3zjrkkQShZUYRDXthXPF+Ricj+WdRMhnzgfuVaBzs+CsOmymiemrVj5CzrHMPBvrTVvf35MQLngLQWtvMvdnYzDfD0JMxtKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709651588; c=relaxed/simple;
	bh=p8O//04CuewQ+0fyogK5jas9Kkmg95F1tG+QiRVWdj0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n/CpAAdFYYRaRho6i0geC4X+CKiOxV8jKdsGOBPwscSZkDGTfyevkUFBm0QuYzGpcsKDK9K3KkgJzJ12UJSTwIumD81tFAnWwgniHpTZv4cVeDsbxORptrexSGB5Gx8X5KUbBliBC/nmulTPxU3J4aqIM5JwnNgqhWMHMU/fp5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wetzel-home.de; spf=pass smtp.mailfrom=wetzel-home.de; dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b=l++PNOuI; arc=none smtp.client-ip=5.252.227.236
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wetzel-home.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wetzel-home.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="l++PNOuI"
From: Alexander Wetzel <Alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
	s=wetzel-home; t=1709651118;
	bh=p8O//04CuewQ+0fyogK5jas9Kkmg95F1tG+QiRVWdj0=;
	h=From:To:Cc:Subject:Date;
	b=l++PNOuIESQ/zQc9U4nHDc3RJQweiPAz8BNpXljvJYYDoY9yGuK1Km+jPp3Qo6L+F
	 tTWbwe2zKtY+HjEncl7dqE6tLyo1yXCjaby7G7toStC1Rgcwto7nQ82ZAklisa/THB
	 HSmTCoSQM88AhfploxUpmqpzQZlN60OYVUDSxfww=
To: Doug Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org,
	Alexander Wetzel <Alexander@wetzel-home.de>
Subject: [BUG] scsi: sg: NULL pointer dereference
Date: Tue,  5 Mar 2024 16:05:09 +0100
Message-ID: <20240305150509.23896-1-Alexander@wetzel-home.de>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

My new notebook is nearly always crashing when I phsically disconnect
(some?) USB devices. For testing I used a SealOne USB device. But I
have the same issue with an USB DVD rom drive.

I have the issue with quite some kernel release. Never had a working
kernel on the new system, so the issue should go back till at least
kernel 6.2. (Not tested that. When needed I'm happy to try older
versions, too.)

The attached patch avoides the null pointer dereference without
aiming to be a proper fix. (Instead I then get the Warning from the
new WARN_ON.)

Obvoiusly sdp->device->request_queue in sg_device_destroy() is
sometimes NULL. And since the system is not always crashing it looks
like some kind of cleanup race.

My "normal" kernel with the issue currently is 6.7.5-gentoo.
But since that one is tainted the kernel Oops and debug patch here is
using 6.8.0-rc6-wt. (Interestingly the BUG report below did not freeze
the system as usual, the system continued to be working.)

The kernel messages are:

usb 1-1: USB disconnect, device number 7
BUG: kernel NULL pointer dereference, address: 0000000000000370
PGD 0 P4D 0
Oops: 0002 [#1] PREEMPT SMP NOPTI
CPU: 5 PID: 683 Comm: kworker/5:11 Not tainted 6.8.0-rc6-wt+ #2
Hardware name: LENOVO 21D6CTO1WW/21D6CTO1WW, BIOS N3FET34W (1.19 ) 03/10/20=
23
Workqueue: events sg_remove_sfp_usercontext
RIP: 0010:mutex_lock+0x19/0x30
Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 53 =
48 89 fb e8 22 dd ff ff 31 c0 65 48 8b 14 25 40 fb 02 00 <f0> 48 0f b1 13 7=
5 06 5b c3 cc cc cc cc 48 89 df 5b eb b4 0f 1f 40
RSP: 0000:ffffbb0d412bfdd0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000370 RCX: 00000000820001c6
RDX: ffff985d58152080 RSI: fffff6c0041083c0 RDI: 0000000000000370
RBP: 0000000000000000 R08: ffff985d4420fc28 R09: 00000000820001c6
R10: ffff985d4420fea8 R11: 0000000000000181 R12: 0000000000000370
R13: ffff985d400518b0 R14: ffff985dddd046c0 R15: ffff985d4ebeb328
FS:  0000000000000000(0000) GS:ffff986c6f340000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000370 CR3: 000000015887a000 CR4: 0000000000750ef0
PKRU: 55555554
Call Trace:
 <TASK>
 ? __die+0x1f/0x70
 ? page_fault_oops+0x171/0x4d0
 ? __slab_free+0xe1/0x320
 ? exc_page_fault+0x7b/0x180
 ? asm_exc_page_fault+0x22/0x30
 ? mutex_lock+0x19/0x30
 blk_trace_remove+0x16/0xb0
 sg_device_destroy+0x26/0xa0
 sg_remove_sfp_usercontext+0x12c/0x190
 process_one_work+0x162/0x330
 worker_thread+0x2f1/0x410
 ? __pfx_worker_thread+0x10/0x10
 kthread+0xe1/0x110
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x2d/0x50
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1b/0x30
 </TASK>
Modules linked in: uas usb_storage rfcomm snd_seq_dummy snd_hrtimer snd_seq=
 snd_seq_device xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject=
_ipv4 ip6table_mangle ip6table_nat ip6table_filter ip6_tables iptable_mangl=
e iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_fil=
ter ip_tables bridge stp llc bnep snd_ctl_led ledtrig_audio snd_soc_skl_hda=
_dsp snd_soc_hdac_hdmi snd_sof_probes snd_soc_intel_hda_dsp_common snd_hda_=
codec_realtek snd_hda_codec_generic snd_soc_dmic snd_sof_pci_intel_tgl snd_=
sof_intel_hda_common soundwire_intel soundwire_generic_allocation snd_sof_i=
ntel_hda_mlink soundwire_cadence snd_sof_intel_hda snd_sof_pci snd_sof_xten=
sa_dsp snd_sof snd_sof_utils snd_soc_hdac_hda intel_uncore_frequency snd_hd=
a_ext_core intel_uncore_frequency_common snd_soc_acpi_intel_match intel_tcc=
_cooling snd_soc_acpi soundwire_bus x86_pkg_temp_thermal snd_hda_codec_hdmi=
 intel_powerclamp snd_soc_core snd_compress ac97_bus snd_pcm_dmaengine core=
temp snd_hda_intel kvm_intel uvcvideo
 snd_intel_dspcfg snd_intel_sdw_acpi uvc videobuf2_vmalloc snd_hda_codec vi=
deobuf2_memops kvm iwlmvm processor_thermal_device_pci snd_hda_core videobu=
f2_v4l2 btusb processor_thermal_device iTCO_wdt btrtl snd_hwdep irqbypass v=
ideobuf2_common intel_pmc_bxt processor_thermal_wt_hint btintel mac80211 sn=
d_pcm nxp_nci_i2c processor_thermal_rfim iTCO_vendor_support btbcm rapl nxp=
_nci snd_timer processor_thermal_rapl mei_wdt videodev vfat btmtk fat libar=
c4 intel_rapl_msr intel_rapl_common bluetooth mc nci intel_cstate processor=
_thermal_wt_req iwlwifi snd mei_me processor_thermal_power_floor i2c_i801 t=
hink_lmi intel_uncore pcspkr firmware_attributes_class i2c_smbus wmi_bmof m=
ei idma64 soundcore processor_thermal_mbox nfc intel_pmc_core cfg80211 rfki=
ll intel_vsec int3403_thermal int3400_thermal int340x_thermal_zone pmt_tele=
metry intel_hid acpi_thermal_rel pmt_class sparse_keymap acpi_tad acpi_pad =
joydev loop fuse nfnetlink mmc_block nvme nvme_core crct10dif_pclmul crc32_=
pclmul crc32c_intel polyval_clmulni
 rtsx_pci_sdmmc polyval_generic ghash_clmulni_intel sha512_ssse3 mmc_core s=
ha256_ssse3 ucsi_acpi hid_multitouch sha1_ssse3 thunderbolt typec_ucsi rtsx=
_pci vmd typec i2c_hid_acpi i2c_hid pinctrl_alderlake serio_raw
CR2: 0000000000000370
---[ end trace 0000000000000000 ]---
RIP: 0010:mutex_lock+0x19/0x30
Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 53 =
48 89 fb e8 22 dd ff ff 31 c0 65 48 8b 14 25 40 fb 02 00 <f0> 48 0f b1 13 7=
5 06 5b c3 cc cc cc cc 48 89 df 5b eb b4 0f 1f 40
RSP: 0000:ffffbb0d412bfdd0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000370 RCX: 00000000820001c6
RDX: ffff985d58152080 RSI: fffff6c0041083c0 RDI: 0000000000000370
RBP: 0000000000000000 R08: ffff985d4420fc28 R09: 00000000820001c6
R10: ffff985d4420fea8 R11: 0000000000000181 R12: 0000000000000370
R13: ffff985d400518b0 R14: ffff985dddd046c0 R15: ffff985d4ebeb328
FS:  0000000000000000(0000) GS:ffff986c6f340000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000370 CR3: 000000015887a000 CR4: 0000000000750ef0
PKRU: 55555554
note: kworker/5:11[683] exited with irqs disabled
---
 drivers/scsi/sg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 86210e4dd0d3..94c07cd318a0 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1575,8 +1575,10 @@ sg_device_destroy(struct kref *kref)
 	 * any other cleanup.
 	 */
=20
-	blk_trace_remove(q);
-	blk_put_queue(q);
+	if (!WARN_ON(!q)) {
+		blk_trace_remove(q);
+		blk_put_queue(q);
+	}
=20
 	write_lock_irqsave(&sg_index_lock, flags);
 	idr_remove(&sg_index_idr, sdp->index);
--=20
2.43.2

