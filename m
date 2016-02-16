From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: fix soft lockup in scsi_remove_target() on module
 removal
Date: Tue, 16 Feb 2016 10:46:50 +0100
Message-ID: <20160216094650.GI18134@c203.arch.suse.de>
References: <1455120206.2341.8.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53625 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415AbcBPJqx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Feb 2016 04:46:53 -0500
Content-Disposition: inline
In-Reply-To: <1455120206.2341.8.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Sebastian Herbszt <herbszt@gmx.de>

On Wed, Feb 10, 2016 at 08:03:26AM -0800, James Bottomley wrote:
> This softlockup is currently happening:
>=20
> [  444.088002] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! =
[kworker/1:1:29]
> [  444.088002] Modules linked in: lpfc(-) qla2x00tgt(O) qla2xxx_scst(=
O) scst_vdisk(O) scsi_transport_fc libcrc32c scst(O) dlm configfs nfsd =
lockd grace nfs_acl auth_rpcgss sunrpc ed
> d snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device dm_mod iTCO_wdt sn=
d_hda_codec_realtek snd_hda_codec_generic gpio_ich iTCO_vendor_support =
ppdev snd_hda_intel snd_hda_codec snd_hda
> _core snd_hwdep tg3 snd_pcm snd_timer libphy lpc_ich parport_pc ptp a=
cpi_cpufreq snd pps_core fjes parport i2c_i801 ehci_pci tpm_tis tpm sr_=
mod cdrom soundcore floppy hwmon sg 8250_
> fintek pcspkr i915 drm_kms_helper uhci_hcd ehci_hcd drm fb_sys_fops s=
ysimgblt sysfillrect syscopyarea i2c_algo_bit usbcore button video usb_=
common fan ata_generic ata_piix libata th
> ermal
> [  444.088002] CPU: 1 PID: 29 Comm: kworker/1:1 Tainted: G           =
O    4.4.0-rc5-2.g1e923a3-default #1
> [  444.088002] Hardware name: FUJITSU SIEMENS ESPRIMO E           /D2=
164-A1, BIOS 5.00 R1.10.2164.A1               05/08/2006
> [  444.088002] Workqueue: fc_wq_4 fc_rport_final_delete [scsi_transpo=
rt_fc]
> [  444.088002] task: f6266ec0 ti: f6268000 task.ti: f6268000
> [  444.088002] EIP: 0060:[<c07e7044>] EFLAGS: 00000286 CPU: 1
> [  444.088002] EIP is at _raw_spin_unlock_irqrestore+0x14/0x20
> [  444.088002] EAX: 00000286 EBX: f20d3800 ECX: 00000002 EDX: 0000028=
6
> [  444.088002] ESI: f50ba800 EDI: f2146848 EBP: f6269ec8 ESP: f6269ec=
8
> [  444.088002]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [  444.088002] CR0: 8005003b CR2: 08f96600 CR3: 363ae000 CR4: 000006d=
0
> [  444.088002] Stack:
> [  444.088002]  f6269eec c066b0f7 00000286 f2146848 f50ba808 f50ba800=
 f50ba800 f2146a90
> [  444.088002]  f2146848 f6269f08 f8f0a4ed f3141000 f2146800 f2146a90=
 f619fa00 00000040
> [  444.088002]  f6269f40 c026cb25 00000001 166c6392 00000061 f6757140=
 f6136340 00000004
> [  444.088002] Call Trace:
> [  444.088002]  [<c066b0f7>] scsi_remove_target+0x167/0x1c0
> [  444.088002]  [<f8f0a4ed>] fc_rport_final_delete+0x9d/0x1e0 [scsi_t=
ransport_fc]
> [  444.088002]  [<c026cb25>] process_one_work+0x155/0x3e0
> [  444.088002]  [<c026cde7>] worker_thread+0x37/0x490
> [  444.088002]  [<c027214b>] kthread+0x9b/0xb0
> [  444.088002]  [<c07e72c1>] ret_from_kernel_thread+0x21/0x40
>=20
> What appears to be happening is that something has pinned the target
> so it can't go into STARGET_DEL via final release and the loop in
> scsi_remove_target spins endlessly until that happens.
>=20
> The fix for this soft lockup is to not keep looping over a device tha=
t
> we've called remove on but which hasn't gone into DEL state.  This
> patch will retain a simplistic memory of the last target and not keep
> looping over it.
>=20
> Reported-by: Sebastian Herbszt <herbszt@gmx.de>
> Tested-by: Sebastian Herbszt <herbszt@gmx.de>
> Fixes: 40998193560dab6c3ce8d25f4fa58a23e252ef38
> Cc: stable@vger.kernel.org
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com=
>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
