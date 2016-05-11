From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] libfc: replace 'rp_mutex' with 'rp_lock'
Date: Wed, 11 May 2016 08:07:19 +0200
Message-ID: <5732CC17.20800@suse.de>
References: <1461571293-953-1-git-send-email-hare@suse.de>
 <57322963.7040507@sandisk.com> <5732C7E5.3000709@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbcEKGHV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 May 2016 02:07:21 -0400
In-Reply-To: <5732C7E5.3000709@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 05/11/2016 07:49 AM, Hannes Reinecke wrote:
> On 05/10/2016 08:33 PM, Bart Van Assche wrote:
>> On 04/25/2016 01:01 AM, Hannes Reinecke wrote:
>>> We cannot use an embedded mutex in a structure with reference
>>> counting, as mutex unlock might be delayed, and the waiters
>>> might then access an already freed memory area.
>>> So convert it to a spinlock.
>>>
>>> For details cf https://lkml.org/lkml/2015/2/11/245
>>
>> Hello Hannes,
>>
>> Is what you describe a theoretical concern or have you observed any
>> issues that could have been caused by the rport mutex? I'm asking
>> this because my interpretation of the thread you refer to is
>> different. My conclusion is that it is safe to embed a mutex in a
>> structure that uses reference counting but that the mutex_unlock()
>> call may trigger a spurious wakeup. I think that the conclusion of
>> that thread was that glibc and kernel code should tolerate such
>> spurious wakeups.
>>
> We have several bugzillas referring to that specific code.
> Most notably triggered when removing target ports with and open-fcoe
> HBA.
>=20
> And this patch seems to resolve it.
> Read: with this patch the issue doesn't occur anymore.
>=20
And for the unbelievers here's the crash:

general protection fault: 0000 [#1] SMP
Modules linked in: raw rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_reso
lver nfs lockd sunrpc fscache iscsi_ibft iscsi_boot_sysfs af_packet
xfs ext4 libcrc32c crc16 mbcache jbd2 joydev coretemp kvm_intel kvm
crct10dif_pclmul crc32_pclmul iTCO_wdt iTCO_vendor_support
aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd
pcspkr lpc_ich mfd_core enic ipmi_si ipmi_msghandler wmi shpchp
acpi_power_meter processor button ac hid_generic usbhid btrfs xor
raid6_pq mgag200 syscopyarea ehci_pci sysfillrect sysimgblt
i2c_algo_bit ehci_hcd drm_kms_helper ttm usbcore drm crc32c_intel
usb_common megaraid_sas dm_service_time sd_mod scsi_dh_rdac
scsi_dh_emc scsi_dh_alua fnic(OEX) libfcoe libfc scsi_transpor
t_fc scsi_tgt dm_multipath scsi_dh sg dm_mod scsi_mod autofs4
Supported: Yes, External
CPU: 0 PID: 16868 Comm: kworker/u25:2 Tainted: G        W  OE X 3
=2E12.55-52.42.1.10435.0.PTF.962846-default #1
Workqueue: fnic_event_wq fnic_handle_frame [fnic]
task: ffff88080021e140 ti: ffff8807cf076000 task.ti: ffff8807cf076000
RIP: 0010:[<ffffffffa00b2adb>]  [<ffffffffa00b2adb>]
fc_rport_lookup+0x4b/0x70 [libfc]
RSP: 0018:ffff8807cf077d20  EFLAGS: 00010202
RAX: 8500a090df03ff00 RBX: ffff8808560386f0 RCX: ffff880846351400
RDX: 8500a090df040000 RSI: 0000000000610c00 RDI: ffff880856038738
RBP: ffff8808560386f0 R08: 0000000000000001 R09: 0000000000000000
R10: ffff8808402f8e40 R11: ffff880856127600 R12: ffff8807cf077d78
R13: 0000000000610c00 R14: ffff880846351400 R15: 0000000000000000
=46S:  0000000000000000(0000) GS:ffff88087fc00000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff6a540f000 CR3: 0000000846831000 CR4: 00000000001407f0
Stack:
8500a090df040000 ffffffffa00b2e17 ffff8808042fe0c0 ffff8808560386f0
ffff8807cf077d78 ffff880856038750 ffffffffa00a9f81 ffff880800007530
ffff8808402f8e40 ffff880856127600 0000000000000001 ffff880846351408
Call Trace:
  [<ffffffffa00b2e17>] fc_rport_create+0x17/0x1b0 [libfc]
  [<ffffffffa00a9f81>] fc_disc_recv_req+0x261/0x480 [libfc]
  [<ffffffffa00b1008>] fc_lport_recv_els_req+0x68/0x130 [libfc]
  [<ffffffffa00afd5a>] fc_lport_recv_req+0x9a/0xf0 [libfc]
  [<ffffffffa00e8333>] fnic_handle_frame+0x63/0xd0 [fnic]
  [<ffffffff8106fd52>] process_one_work+0x172/0x420
  [<ffffffff810709ca>] worker_thread+0x11a/0x3c0
  [<ffffffff81077344>] kthread+0xb4/0xc0
  [<ffffffff81521318>] ret_from_fork+0x58/0x90
Code: ff ff ff 75 26 eb 39 66 0f 1f 84 00 00 00 00 00 48 8b 80 00
 01 00 00 48 89 04 24 48 8b 14 24 48 39 d7 48 8d 82 00 ff ff ff 74
15 <39> b2 28 ff ff ff 75 dd 48 83 c4 08 c3 0f 1f 84 00 00 00 00 00
RIP  [<ffffffffa00b2adb>] fc_rport_lookup+0x4b/0x70 [libfc]

So no, it's not theoretical.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
