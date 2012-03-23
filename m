From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: WARNING: at fs/sysfs/inode.c:323 sysfs_hash_and_remove+0xa4/0xb0()
Date: Fri, 23 Mar 2012 11:00:42 -0700
Message-ID: <CAA9_cmfJnUYXU9HzBNmruViHagYeyRNtsUm3CtNvotsM0tW2aQ@mail.gmail.com>
References: <005b01cd080a$febd81e0$fc3885a0$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:58328 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964928Ab2CWSAn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Mar 2012 14:00:43 -0400
Received: by vbbff1 with SMTP id ff1so1630286vbb.19
        for <linux-scsi@vger.kernel.org>; Fri, 23 Mar 2012 11:00:42 -0700 (PDT)
In-Reply-To: <005b01cd080a$febd81e0$fc3885a0$@com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?5LqO54ix5Y2O?= <crystal_yu@usish.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com

On Thu, Mar 22, 2012 at 2:05 AM, =E4=BA=8E=E7=88=B1=E5=8D=8E <crystal_y=
u@usish.com> wrote:
> Sometimes, when I use rmmod to remove the module of pm8001, I will go=
t problems as follows:
>
> =C2=A0WARNING: at fs/sysfs/inode.c:323 sysfs_hash_and_remove+0xa4/0xb=
0()
> Hardware name: X7DB8
> sysfs: can not remove 'device', no directory
> Modules linked in: raid456 async_raid6_recov async_pq raid6_pq async_=
xor xor async_memcpy async_tx ses enclosure spcv(O-) libsas scsi_transp=
ort_sas ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE =
iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntra=
ck ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables tun a=
utofs4 sunrpc p4_clockmod freq_table speedstep_lib bridge stp llc ipv6 =
dm_mirror dm_region_hash dm_log virtio_net virtio virtio_ring kvm_intel=
 kvm microcode pcspkr i2c_i801 sg iTCO_wdt iTCO_vendor_support i5000_ed=
ac edac_core i5k_amb ioatdma dca e1000e shpchp ext4 mbcache jbd2 floppy=
 sd_mod crc_t10dif pata_acpi ata_generic ata_piix radeon ttm drm_kms_he=
lper drm i2c_algo_bit i2c_core dm_mod [last unloaded: mperf]
> Pid: 2835, comm: kworker/u:0 Tainted: G =C2=A0 =C2=A0 =C2=A0 =C2=A0W =
=C2=A0O 3.3.0-rc3+ #2
> Call Trace:
> [<ffffffff8104c38f>] warn_slowpath_common+0x7f/0xc0
> [<ffffffff8104c486>] warn_slowpath_fmt+0x46/0x50
> [<ffffffff811d5e04>] sysfs_hash_and_remove+0xa4/0xb0
> [<ffffffff811d8ad6>] sysfs_remove_link+0x26/0x30
> [<ffffffffa00192c6>] enclosure_remove_links+0x56/0x80 [enclosure]
> [<ffffffff811d805b>] ? remove_dir+0x3b/0x50
> [<ffffffffa001940f>] enclosure_component_release+0x2f/0x50 [enclosure=
]
> [<ffffffff8132c827>] device_release+0x27/0xa0

Hmm, why are we removing links in the release routine, shouldn't they
have been removed before the device was deleted... like what happens
in enclosure_remove_device()?

This looks like enclosure_remove_links() should be moved from
enclosure_component_release() to enclosure_unregister().

Thoughts?

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
