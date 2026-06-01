Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311EA41754;
	Mon,  1 Jun 2026 14:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780322562; cv=none; b=uAik3n5z5BOhlpMHE66dUQzAFnubnlumSH0H1K4XFuSJZ3FIXsaxd3bsi7wpnB3EVne7jvZLNKlPjShGkMCvFhF3n9P7kRf6wm/l0sdy82O/BBRv1mDKSx0VY3rH3erBMycVL0/EQZqOY6Fj6gzV9fkQUKnQ3lIlFzyMYNpHC1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780322562; c=relaxed/simple;
	bh=mmzAVlKO2xwJvSKtwzHN4Sz0Fl7+9YMXkQUntX3Nllw=;
	h=Message-ID:Date:MIME-Version:From:To:Cc:Subject:Content-Type; b=CzvlxlG84ygTKQ3vKy0CTq4zNGw40SHHSn+B2zd5s6DmEVzkWL9Ipje1EASsyWThJWWvJz8sUtm+TBuKVfsTvnGiBbvJ1tq1k1cYADSF2t/Mv96kb05nmXytRKT5cTQ39kFKQNcetQJAFhZuQFsVXFlLMojz7GhSO2GDZ7YaDHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=fail smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 9371C461E2;
	Mon, 01 Jun 2026 15:55:21 +0200 (CEST)
Message-ID: <d171cc76-bf25-48ce-b482-d344669dfc24@proxmox.com>
Date: Mon, 1 Jun 2026 15:55:18 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Mira Limbeck <m.limbeck@proxmox.com>
Content-Language: en-US
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
 shivasharan.srikanteshwara@broadcom.com,
 "chandrakanth.patil" <chandrakanth.patil@broadcom.com>,
 megaraidlinux.pdl@broadcom.com, linux-kernel@vger.kernel.org,
 Friedrich Weber <f.weber@proxmox.com>, Daniel Herzig <d.herzig@proxmox.com>
Subject: Kernel panic with megaraid_sas controller and certain NVMes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Bm-Milter-Handled: 55990f41-d878-4baa-be0a-ee34c49e34d2
X-Bm-Transport-Timestamp: 1780322085125

Dear megaraid_sas maintainers,

Some of our users encountered issues with MegaRAID controllers where
certain NVMes(KIOXIA, Micron) lead to crashes during certain I/O patterns=
=2E
The crashes look similar to a previous issue with Broadcom controllers
that use the mpt3sas driver that was recently fixed:
Issue:
https://lore.kernel.org/all/291f78bf-4b4a-40dd-867d-053b36c564b3@proxmox.=
com/
Fix: 04631f55afc5 ("scsi: mpt3sas: Limit NVMe request size to 2 MiB")

In a testsystem we were able to reproduce it by passing disks through as
JBOD and creating Ceph OSDs on top.
Ceph I/O was required to reliably trigger the issue. We were able to trig=
ger
it by cloning RBD images.

Hardware:
Broadcom MegaRAID 9540-8i
2x KIOXIA CD8-R SIE U.2

Controller info:
# storcli64 /c0 show
Generating detailed summary of the adapter, it may take a while to comple=
te.

CLI Version =3D 007.3703.0000.0000 Jan 16, 2026
Operating system =3D Linux 6.18.32-61832-plain
Controller =3D 0
Status =3D Success
Description =3D None

Product Name =3D MegaRAID 9540-8i
Serial Number =3D SPF2101432
SAS Address =3D  500062b224511780
PCI Address =3D 00:81:00:00
System Time =3D 05/22/2026 14:17:11
Mfg. Date =3D 05/24/25
Controller Time =3D 05/22/2026 14:17:10
FW Package Build =3D 52.31.0-5827
BIOS Version =3D 7.31.00.0_0x071F0000
FW Version =3D 5.310.01-4101
Driver Name =3D megaraid_sas
Driver Version =3D 07.734.00.00-rc1
Current Personality =3D RAID-Mode
Vendor Id =3D 0x1000
Device Id =3D 0x10E6
SubVendor Id =3D 0x1000
SubDevice Id =3D 0x40D5
Host Interface =3D PCI-E
Device Interface =3D SAS-12G
Bus Number =3D 129
Device Number =3D 0
Function Number =3D 0
Domain ID =3D 0
Security Protocol =3D None
JBOD Drives =3D 2

JBOD LIST :
=3D=3D=3D=3D=3D=3D=3D=3D=3D

-------------------------------------------------------------------------=
---------------------------
EID:Slt DID State DG     Size Intf Med SED PI SeSz Model                 =
                   Sp Type
-------------------------------------------------------------------------=
---------------------------
14:0      1 JBOD  -  6.986 TB NVMe SSD N   N  512B KIOXIA KCD8XRUG7T68   =
                   U  -
14:1      0 JBOD  -  6.986 TB NVMe SSD N   N  512B KIOXIA KCD8XRUG7T68   =
                   U  -
-------------------------------------------------------------------------=
---------------------------


The kernel panic:
May 21 14:36:13 pve-test-hba kernel: sd 1:0:1:0: [sdb] tag#630 page bound=
ary ptr_sgl: 0x00000000ba62d13f
May 21 14:36:13 pve-test-hba kernel: BUG: unable to handle page fault for=
 address: ff663bcb81e7c000
May 21 14:36:13 pve-test-hba kernel: #PF: supervisor write access in kern=
el mode
May 21 14:36:13 pve-test-hba kernel: #PF: error_code(0x0002) - not-presen=
t page
May 21 14:36:13 pve-test-hba kernel: PGD 100010067 P4D 1004d7067 PUD 1004=
d8067 PMD 121a81067 PTE 0
May 21 14:36:13 pve-test-hba kernel: Oops: Oops: 0002 [#1] SMP NOPTI
May 21 14:36:13 pve-test-hba kernel: CPU: 12 UID: 64045 PID: 4903 Comm: t=
p_osd_tp Tainted: G            E       6.18.32-61832-plain #33 PREEMPT(fu=
ll)=20
May 21 14:36:13 pve-test-hba kernel: Tainted: [E]=3DUNSIGNED_MODULE
May 21 14:36:13 pve-test-hba kernel: Hardware name: [...]
May 21 14:36:13 pve-test-hba kernel: RIP: 0010:megasas_build_and_issue_cm=
d_fusion+0xeaa/0x1870 [megaraid_sas]
May 21 14:36:13 pve-test-hba kernel: Code: 20 48 89 d1 48 83 e1 fc 83 e2 =
01 48 0f 45 d9 4c 8b 73 10 44 8b 6b 18 4c 89 f9 4c 8d 79 08 45 85 fa 0f 8=
4 fd 03 00 00 45 29 cc <4c> 89 31 48 83 c0 08 41 83 c0 01 45 29 cd 45 85 =
e4 7f ab 44 89 c0
May 21 14:36:13 pve-test-hba kernel: RSP: 0018:ff663bcb871078c0 EFLAGS: 0=
0010246
May 21 14:36:13 pve-test-hba kernel: RAX: 00000000ff90a000 RBX: ff3f858da=
3005c40 RCX: ff663bcb81e7c000
May 21 14:36:13 pve-test-hba kernel: RDX: ff663bcb81e7c008 RSI: ff3f858da=
3005b08 RDI: 0000000000000000
May 21 14:36:13 pve-test-hba kernel: RBP: ff663bcb87107990 R08: 000000000=
0000200 R09: 0000000000001000
May 21 14:36:13 pve-test-hba kernel: R10: 0000000000000fff R11: 000000000=
0001000 R12: 0000000000000000
May 21 14:36:13 pve-test-hba kernel: R13: 0000000000001000 R14: 000000008=
ae00000 R15: ff663bcb81e7c008
May 21 14:36:13 pve-test-hba kernel: FS:  00007672b3f866c0(0000) GS:ff3f8=
59143379000(0000) knlGS:0000000000000000
May 21 14:36:13 pve-test-hba kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000=
0000080050033
May 21 14:36:13 pve-test-hba kernel: CR2: ff663bcb81e7c000 CR3: 000000011=
40a400c CR4: 0000000000f71ef0
May 21 14:36:13 pve-test-hba kernel: PKRU: 55555554
May 21 14:36:13 pve-test-hba kernel: Call Trace:
May 21 14:36:13 pve-test-hba kernel:  <TASK>
May 21 14:36:13 pve-test-hba kernel:  ? scsi_alloc_sgtables+0xa3/0x3a0
May 21 14:36:13 pve-test-hba kernel:  megasas_queue_command+0x125/0x1d0 [=
megaraid_sas]
May 21 14:36:13 pve-test-hba kernel:  scsi_queue_rq+0x40c/0xcc0
May 21 14:36:13 pve-test-hba kernel:  blk_mq_dispatch_rq_list+0x124/0x750=

May 21 14:36:13 pve-test-hba kernel:  ? sbitmap_get+0x73/0x180
May 21 14:36:13 pve-test-hba kernel:  ? sbitmap_get+0x73/0x180
May 21 14:36:13 pve-test-hba kernel:  __blk_mq_sched_dispatch_requests+0x=
40b/0x600
May 21 14:36:13 pve-test-hba kernel:  ? elv_attempt_insert_merge+0xa6/0x1=
00
May 21 14:36:13 pve-test-hba kernel:  blk_mq_sched_dispatch_requests+0x2d=
/0x80
May 21 14:36:13 pve-test-hba kernel:  blk_mq_run_hw_queue+0x2c3/0x330
May 21 14:36:13 pve-test-hba kernel:  blk_mq_dispatch_list+0x141/0x460
May 21 14:36:13 pve-test-hba kernel:  blk_mq_flush_plug_list+0x62/0x1e0
May 21 14:36:13 pve-test-hba kernel:  __blk_flush_plug+0xdc/0x140
May 21 14:36:13 pve-test-hba kernel:  blk_finish_plug+0x30/0x50
May 21 14:36:13 pve-test-hba kernel:  __x64_sys_io_submit+0xd1/0x1e0
May 21 14:36:13 pve-test-hba kernel:  ? __secure_computing+0x84/0xe0
May 21 14:36:13 pve-test-hba kernel:  x64_sys_call+0x795/0x2350
May 21 14:36:13 pve-test-hba kernel:  do_syscall_64+0x82/0x6a0
May 21 14:36:13 pve-test-hba kernel:  ? count_memcg_events+0xd7/0x1a0
May 21 14:36:13 pve-test-hba kernel:  ? handle_mm_fault+0x254/0x370
May 21 14:36:13 pve-test-hba kernel:  ? do_user_addr_fault+0x2f8/0x830
May 21 14:36:13 pve-test-hba kernel:  ? irqentry_exit_to_user_mode+0x2e/0=
x320
May 21 14:36:13 pve-test-hba kernel:  ? irqentry_exit+0x43/0x50
May 21 14:36:13 pve-test-hba kernel:  ? exc_page_fault+0x90/0x1b0
May 21 14:36:13 pve-test-hba kernel:  entry_SYSCALL_64_after_hwframe+0x76=
/0x7e
May 21 14:36:13 pve-test-hba kernel: RIP: 0033:0x7672d6f1a7b9
May 21 14:36:13 pve-test-hba kernel: Code: ff c3 66 2e 0f 1f 84 00 00 00 =
00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c=
8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 27 66 0d 00 =
f7 d8 64 89 01 48
May 21 14:36:13 pve-test-hba kernel: RSP: 002b:00007672b3f7f958 EFLAGS: 0=
0000246 ORIG_RAX: 00000000000000d1
May 21 14:36:13 pve-test-hba kernel: RAX: ffffffffffffffda RBX: 00007672b=
3f83740 RCX: 00007672d6f1a7b9
May 21 14:36:13 pve-test-hba kernel: RDX: 00007672b3f7f990 RSI: 000000000=
0000021 RDI: 00007672d22de000
May 21 14:36:13 pve-test-hba kernel: RBP: 00007672d22de000 R08: 000000000=
0000000 R09: 0000561c23ca5d80
May 21 14:36:13 pve-test-hba kernel: R10: 00007672b3f81a3c R11: 000000000=
0000246 R12: 0000000000000021
May 21 14:36:13 pve-test-hba kernel: R13: 0000000000000000 R14: 00007672b=
3f7f990 R15: 0000561c0e7de320
May 21 14:36:13 pve-test-hba kernel:  </TASK>
May 21 14:36:13 pve-test-hba kernel: Modules linked in: ceph(E) libceph(E=
) netfs(E) tcp_diag(E) inet_diag(E) nf_tables(E) sunrpc(E) bonding(E) tls=
(E) softdog(E) nfnetlink_log(E) binfmt_misc(E) ipmi_ssif(E) amd_atl(E) in=
tel_rapl_msr(E) intel_rapl_common(E) amd64_edac(E) edac_mce_amd(E) kvm_am=
d(E) dax_hmem(E) rndis_host(E) cxl_acpi(E) kvm(E) cdc_ether(E) cxl_port(E=
) irqbypass(E) cxl_pmem(E) usbnet(E) input_leds(E) joydev(E) acpi_ipmi(E)=
 ses(E) ast(E) ghash_clmulni_intel(E) cxl_core(E) enclosure(E) aesni_inte=
l(E) i2c_algo_bit(E) mii(E) scsi_transport_sas(E) einj(E) rapl(E) ipmi_si=
(E) ccp(E) spd5118(E) pcspkr(E) hsmp_acpi(E) k10temp(E) wmi_bmof(E) ipmi_=
devintf(E) hsmp_common(E) ipmi_msghandler(E) mac_hid(E) sch_fq_codel(E) m=
sr(E) vhost_net(E) vhost(E) vhost_iotlb(E) nvme_fabrics(E) tap(E) nvme_co=
re(E) nvme_keyring(E) nvme_auth(E) hkdf(E) efi_pstore(E) nfnetlink(E) dmi=
_sysfs(E) autofs4(E) btrfs(E) blake2b_generic(E) xor(E) hid_generic(E) us=
bmouse(E) usbhid(E) hid(E) raid6_pq(E) dm_thin_pool(E) dm_persistent_data=
(E) dm_bio_prison(E) dm_bufio(E)
May 21 14:36:13 pve-test-hba kernel:  xhci_pci_renesas(E) xhci_pci(E) tg3=
(E) xhci_hcd(E) ahci(E) megaraid_sas(E) libahci(E) i2c_piix4(E) i2c_smbus=
(E) wmi(E) 8250_dw(E)
May 21 14:36:13 pve-test-hba kernel: CR2: ff663bcb81e7c000
May 21 14:36:13 pve-test-hba kernel: ---[ end trace 0000000000000000 ]---=

May 21 14:36:13 pve-test-hba kernel: RIP: 0010:megasas_build_and_issue_cm=
d_fusion+0xeaa/0x1870 [megaraid_sas]
May 21 14:36:13 pve-test-hba kernel: Code: 20 48 89 d1 48 83 e1 fc 83 e2 =
01 48 0f 45 d9 4c 8b 73 10 44 8b 6b 18 4c 89 f9 4c 8d 79 08 45 85 fa 0f 8=
4 fd 03 00 00 45 29 cc <4c> 89 31 48 83 c0 08 41 83 c0 01 45 29 cd 45 85 =
e4 7f ab 44 89 c0
May 21 14:36:13 pve-test-hba kernel: RSP: 0018:ff663bcb871078c0 EFLAGS: 0=
0010246
May 21 14:36:13 pve-test-hba kernel: RAX: 00000000ff90a000 RBX: ff3f858da=
3005c40 RCX: ff663bcb81e7c000
May 21 14:36:13 pve-test-hba kernel: RDX: ff663bcb81e7c008 RSI: ff3f858da=
3005b08 RDI: 0000000000000000
May 21 14:36:13 pve-test-hba kernel: RBP: ff663bcb87107990 R08: 000000000=
0000200 R09: 0000000000001000
May 21 14:36:13 pve-test-hba kernel: R10: 0000000000000fff R11: 000000000=
0001000 R12: 0000000000000000
May 21 14:36:13 pve-test-hba kernel: R13: 0000000000001000 R14: 000000008=
ae00000 R15: ff663bcb81e7c008
May 21 14:36:13 pve-test-hba kernel: FS:  00007672b3f866c0(0000) GS:ff3f8=
59143379000(0000) knlGS:0000000000000000
May 21 14:36:13 pve-test-hba kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000=
0000080050033
May 21 14:36:13 pve-test-hba kernel: CR2: ff663bcb81e7c000 CR3: 000000011=
40a400c CR4: 0000000000f71ef0
May 21 14:36:13 pve-test-hba kernel: PKRU: 55555554
May 21 14:36:13 pve-test-hba kernel: note: tp_osd_tp[4903] exited with ir=
qs disabled
May 21 14:36:13 pve-test-hba kernel: ------------[ cut here ]------------=

May 21 14:36:13 pve-test-hba kernel: WARNING: CPU: 4 PID: 4903 at kernel/=
exit.c:905 do_exit+0x82b/0xa70
May 21 14:36:13 pve-test-hba kernel: Modules linked in: ceph(E) libceph(E=
) netfs(E) tcp_diag(E) inet_diag(E) nf_tables(E) sunrpc(E) bonding(E) tls=
(E) softdog(E) nfnetlink_log(E) binfmt_misc(E) ipmi_ssif(E) amd_atl(E) in=
tel_rapl_msr(E) intel_rapl_common(E) amd64_edac(E) edac_mce_amd(E) kvm_am=
d(E) dax_hmem(E) rndis_host(E) cxl_acpi(E) kvm(E) cdc_ether(E) cxl_port(E=
) irqbypass(E) cxl_pmem(E) usbnet(E) input_leds(E) joydev(E) acpi_ipmi(E)=
 ses(E) ast(E) ghash_clmulni_intel(E) cxl_core(E) enclosure(E) aesni_inte=
l(E) i2c_algo_bit(E) mii(E) scsi_transport_sas(E) einj(E) rapl(E) ipmi_si=
(E) ccp(E) spd5118(E) pcspkr(E) hsmp_acpi(E) k10temp(E) wmi_bmof(E) ipmi_=
devintf(E) hsmp_common(E) ipmi_msghandler(E) mac_hid(E) sch_fq_codel(E) m=
sr(E) vhost_net(E) vhost(E) vhost_iotlb(E) nvme_fabrics(E) tap(E) nvme_co=
re(E) nvme_keyring(E) nvme_auth(E) hkdf(E) efi_pstore(E) nfnetlink(E) dmi=
_sysfs(E) autofs4(E) btrfs(E) blake2b_generic(E) xor(E) hid_generic(E) us=
bmouse(E) usbhid(E) hid(E) raid6_pq(E) dm_thin_pool(E) dm_persistent_data=
(E) dm_bio_prison(E) dm_bufio(E)
May 21 14:36:13 pve-test-hba kernel:  xhci_pci_renesas(E) xhci_pci(E) tg3=
(E) xhci_hcd(E) ahci(E) megaraid_sas(E) libahci(E) i2c_piix4(E) i2c_smbus=
(E) wmi(E) 8250_dw(E)
May 21 14:36:13 pve-test-hba kernel: CPU: 4 UID: 64045 PID: 4903 Comm: tp=
_osd_tp Tainted: G      D     E       6.18.32-61832-plain #33 PREEMPT(ful=
l)=20
May 21 14:36:13 pve-test-hba kernel: Tainted: [D]=3DDIE, [E]=3DUNSIGNED_M=
ODULE
May 21 14:36:13 pve-test-hba kernel: Hardware name: [...]
May 21 14:36:13 pve-test-hba kernel: RIP: 0010:do_exit+0x82b/0xa70
May 21 14:36:13 pve-test-hba kernel: Code: fe ff ff 48 8b bb 10 0b 00 00 =
31 f6 e8 ee e1 ff ff e9 e6 fd ff ff 48 89 df e8 b1 44 16 00 e9 95 f9 ff f=
f 0f 0b e9 11 f8 ff ff <0f> 0b e9 18 f8 ff ff 48 8d 55 c0 b9 04 00 00 00 =
31 c0 48 89 d7 f3
May 21 14:36:13 pve-test-hba kernel: RSP: 0018:ff663bcb87107ec0 EFLAGS: 0=
0010286
May 21 14:36:13 pve-test-hba kernel: RAX: 0000000000000286 RBX: ff3f858d9=
6d1b0c0 RCX: 0000000000000000
May 21 14:36:13 pve-test-hba kernel: RDX: 000000000000270f RSI: 000000000=
0002710 RDI: 0000000000000009
May 21 14:36:13 pve-test-hba kernel: RBP: ff663bcb87107f10 R08: 000000000=
0000000 R09: 0000000000000000
May 21 14:36:13 pve-test-hba kernel: R10: 0000000000000000 R11: 000000000=
0000000 R12: 0000000000000009
May 21 14:36:13 pve-test-hba kernel: R13: 0000000000000001 R14: ff3f858d9=
6d1b0c0 R15: 0000000000000000
May 21 14:36:13 pve-test-hba kernel: FS:  00007672b3f866c0(0000) GS:ff3f8=
59142f79000(0000) knlGS:0000000000000000
May 21 14:36:13 pve-test-hba kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000=
0000080050033
May 21 14:36:13 pve-test-hba kernel: CR2: 00007e0d41421070 CR3: 000000011=
40a400c CR4: 0000000000f71ef0
May 21 14:36:13 pve-test-hba kernel: PKRU: 55555554
May 21 14:36:13 pve-test-hba kernel: Call Trace:
May 21 14:36:13 pve-test-hba kernel:  <TASK>
May 21 14:36:13 pve-test-hba kernel:  make_task_dead+0x93/0xa0
May 21 14:36:13 pve-test-hba kernel:  rewind_stack_and_make_dead+0x16/0x2=
0
May 21 14:36:13 pve-test-hba kernel: RIP: 0033:0x7672d6f1a7b9
May 21 14:36:13 pve-test-hba kernel: Code: ff c3 66 2e 0f 1f 84 00 00 00 =
00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c=
8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 27 66 0d 00 =
f7 d8 64 89 01 48
May 21 14:36:13 pve-test-hba kernel: RSP: 002b:00007672b3f7f958 EFLAGS: 0=
0000246 ORIG_RAX: 00000000000000d1
May 21 14:36:13 pve-test-hba kernel: RAX: ffffffffffffffda RBX: 00007672b=
3f83740 RCX: 00007672d6f1a7b9
May 21 14:36:13 pve-test-hba kernel: RDX: 00007672b3f7f990 RSI: 000000000=
0000021 RDI: 00007672d22de000
May 21 14:36:13 pve-test-hba kernel: RBP: 00007672d22de000 R08: 000000000=
0000000 R09: 0000561c23ca5d80
May 21 14:36:13 pve-test-hba kernel: R10: 00007672b3f81a3c R11: 000000000=
0000246 R12: 0000000000000021
May 21 14:36:13 pve-test-hba kernel: R13: 0000000000000000 R14: 00007672b=
3f7f990 R15: 0000561c0e7de320
May 21 14:36:13 pve-test-hba kernel:  </TASK>
May 21 14:36:13 pve-test-hba kernel: ---[ end trace 0000000000000000 ]---=



We tested multiple kernels between:
038d61fd6422 ("Linux 6.16") tag: v6.16
5d6919055dec ("Linux 7.1-rc3") tag: v7.1-rc3

All of them were built from stable, no additional patches on top.

We first see the issue with v6.17, specifically we first see the issue
with 9b8b84879d4a ("block: Increase BLK_DEF_MAX_SECTORS_CAP"), the same
one as for the mpt3sas issue. However, for the mpt3sas issue, it was
discussed that this commit seems to merely uncover a preexisting issue
in the driver [0], likely the case is similar here.

Interestingly enough, we also found that our reproducer did not trigger
a crash anymore on v7.0 (028ef9c96e96).
git bisect identified the following as the first good commit (with which
our reproducer doesn't trigger a crash anymore):
12da89e8844a ("block: open code bio_add_page and fix handling of
mismatching P2P ranges")

We are not sure why it appears to fix the issue in case of our
reproducer. Also, we are not sure if it fixes the issue generally, or
just a specific codepath our reproducer is hitting.
Some users report that their setups with Micron NVMes still trigger the
issue, so probably the commit is not a complete fix. We don't have a
test system with Micron NVMes available to test ourselves though.

While looking for the root cause, we found an unapplied patch that might
be related [1].

Does anyone have an idea how to further debug this issue?


[0]
https://lore.kernel.org/all/7a0cfc66-3131-4b94-87f2-cbb96595ebb6@kernel.o=
rg/
[1]
https://lore.kernel.org/all/GPhsSM0vkgyIrs0DIZ62qeUZX7X4RxwQXVKiuvMx-lHQV=
SPDxpztUyQOGS0xikqvJ-Z94hMV-dW_5KN_0CX2hsfV7kTf_t0MTf6vdAAaSEc=3D@magik.n=
et/

