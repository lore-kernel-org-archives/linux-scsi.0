Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFE3DC43465
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 06:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E97421481
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 06:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgIRGaW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Sep 2020 02:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgIRGaW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2020 02:30:22 -0400
X-Greylist: delayed 300 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 17 Sep 2020 23:30:22 PDT
Received: from durga.tabris.net (durga.tabris.net [IPv6:2604:180:1:5a8::6487])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE06C06174A
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2020 23:30:22 -0700 (PDT)
Received: from bragi.tabris.net (localhost [127.0.0.1])
        (Authenticated sender: mailrelay)
        by durga.tabris.net (Postfix) with ESMTPA id C241EC3202A;
        Thu, 17 Sep 2020 23:25:18 -0700 (PDT)
Received: from sif.tabris.net (bragi.tabris.net [192.168.88.8])
        (Authenticated sender: tabris)
        by bragi.tabris.net (Postfix) with ESMTPA id 6C979C2C8522;
        Fri, 18 Sep 2020 02:25:18 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 bragi.tabris.net 6C979C2C8522
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by sif.tabris.net (Postfix) with ESMTP id 37BB420144;
        Fri, 18 Sep 2020 02:25:18 -0400 (EDT)
To:     linux-scsi@vger.kernel.org
From:   Adam Schrotenboer <adam@domedata.com>
Subject: bug in mpt3sas vs Lenovo 530-8i
Cc:     Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Message-ID: <a29522ab-6246-00b6-57b9-cd8d7c8766dc@domedata.com>
Date:   Fri, 18 Sep 2020 02:25:17 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I have two Lenovo 530-8i with the IT-mode firmware installed, this
occurs with both despite different versions of firmware.

the bootup for the currently installed card says MPT35BIOS-9.03.00.00
(2017.02.02).

The other card has been updated to the most recent off of the website, I
believe it's 9.31.00.00.

This bug occurs with either one. The machine is brand new, Ryzen 3800XT
and an ASUS X570-Pro, and running Debian 10.5; the Lenovo 530-8i are
used from eBay.

This bug does not occur with linux-image-4.19.0-10-amd64  4.19.132-1.

it does occur with linux-image-5.4.0-0.bpo.4-amd64 5.4.19-1~bpo10+1.

a bisect log is below.

In the good case (with the bad commit reverted, on a 5.8 kernel), this
occurs in the dmesg log approximately every 600 seconds:

[ 1804.145603] mpt3sas_cm0: log_info(0x30030109): originator(IOP),
code(0x03), sub_code(0x0109)
[ 1804.145621] mpt3sas_cm0: log_info(0x30030101): originator(IOP),
code(0x03), sub_code(0x0101)

In the bad case [note that the exact output varies by kernel version, I
believe the below is the distro kernel 5.4.19]:

[  664.939927] mf:
[  664.939927] 
[  664.939928] 12000002
[  664.939929] 00000000
[  664.939929] 00000000
[  664.939929] 00000000
[  664.939930] 00000000
[  664.939930] 000c0000
[  664.939930] 00000000
[  664.939931] 00010000
[  664.939931]
[  664.939931] 
[  664.939931] 00010000
[  664.939932]
[  664.939940] mpt3sas_cm0: sending diag reset !!
[  665.697392] mpt3sas_cm0: diag reset: SUCCESS
[  665.760406] mpt3sas_cm0: CurrentHostPageSize is 0: Setting default
host page size to 4k
[  665.877256] mpt3sas_cm0: _base_display_fwpkg_version: complete
[  665.877257] mpt3sas_cm0: FW Package Version (02.00.05.02)
[  665.877521] mpt3sas_cm0: SAS3408: FWVersion(02.00.05.00),
ChipRevision(0x01), BiosVersion(09.03.00.00)
[  665.877522] NVMe
[  665.877522] mpt3sas_cm0: Protocol=(Initiator,Target),
Capabilities=(TLR,EEDP,Diag Trace Buffer,Task Set Full,NCQ)
[  665.877569] mpt3sas_cm0: sending port enable !!
[  673.055652] mpt3sas_cm0: port enable: SUCCESS
[  673.055791] mpt3sas_cm0: search for end-devices: start
[  673.056100] scsi target6:0:1: handle(0x0009),
sas_addr(0x510600b00cf4d920)
[  673.056102] scsi target6:0:1: enclosure logical
id(0x500605b00cf4d920), slot(8)
[  673.056170] scsi target6:0:0: handle(0x000b),
sas_addr(0x500151b0000020b3)
[  673.056171] scsi target6:0:0: enclosure logical
id(0x500151b0000020bf), slot(6)
[  673.056172]  handle changed from(0x000c)!!!
[  673.056207] scsi target6:0:2: handle(0x000c),
sas_addr(0x500151b0000020bd)
[  673.056208] scsi target6:0:2: enclosure logical
id(0x500151b0000020bf), slot(0)
[  673.056208]  handle changed from(0x000d)!!!
[  673.056275] scsi target6:0:3: handle(0x000e),
sas_addr(0x500151b0000000bd)
[  673.056276] scsi target6:0:3: enclosure logical
id(0x500151b0000000bf), slot(0)
[  673.056315] mpt3sas_cm0: search for end-devices: complete
[  673.056316] mpt3sas_cm0: search for end-devices: start
[  673.056316] mpt3sas_cm0: search for PCIe end-devices: complete
[  673.056317] mpt3sas_cm0: search for expanders: start
[  673.056351]  expander present: handle(0x000a),
sas_addr(0x500151b0000020bf)
[  673.056384]  expander present: handle(0x000d),
sas_addr(0x500151b0000000bf)
[  673.056385]  expander(0x500151b0000000bf): handle changed
from(0x000b) to (0x000d)!!!
[  673.056419] mpt3sas_cm0: search for expanders: complete
[  673.056427] mpt3sas_cm0: removing unresponding devices: start
[  673.056428] mpt3sas_cm0: removing unresponding devices: end-devices
[  673.056429] mpt3sas_cm0: Removing unresponding devices: pcie end-devices
[  673.056430] mpt3sas_cm0: removing unresponding devices: expanders
[  673.056430] mpt3sas_cm0: removing unresponding devices: complete
[  673.056432] mpt3sas_cm0: scan devices: start
[  673.056773] mpt3sas_cm0:     scan devices: expanders start
[  673.058860] mpt3sas_cm0:     break from expander scan:
ioc_status(0x0022), loginfo(0x310f0400)
[  673.058860] mpt3sas_cm0:     scan devices: expanders complete
[  673.058861] mpt3sas_cm0:     scan devices: end devices start
[  673.059363] mpt3sas_cm0:     break from end device scan:
ioc_status(0x0022), loginfo(0x310f0400)
[  673.059363] mpt3sas_cm0:     scan devices: end devices complete
[  673.059364] mpt3sas_cm0:     scan devices: pcie end devices start
[  673.059394] mpt3sas_cm0:     break from pcie end device scan:
ioc_status(0x0022), loginfo(0x310f0400)
[  673.059395] mpt3sas_cm0:     pcie devices: pcie end devices complete
[  673.059395] mpt3sas_cm0: scan devices: complete

From the below bisect, this commit appears to be at fault:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e224e03b0c6a2381ed1ea5325c846582d87d6fae
Note that, per https://lkml.org/lkml/2020/7/7/392 [from a static
analysis tool coccinelle], the commit isn't necessary for mpt3sas_base.c.

In my testing, only the change to mpt3sas_ctl.c is causing the issue
(that is, reverting the commit on this file but leaving mpt3sas_base.c
with this change makes the bug disappear).

git bisect start

# good: [84df9525b0c27f3ebc2ebb1864fa62a97fdedb7d] Linux 4.19
git bisect good 84df9525b0c27f3ebc2ebb1864fa62a97fdedb7d
# bad: [219d54332a09e8d8741c1e1982f5eae56099de85] Linux 5.4
git bisect bad 219d54332a09e8d8741c1e1982f5eae56099de85
# good: [5fb5c395e2c4658a57f894ae9ab72b3d4d71a882] nfp: flower: add qos
offload stats request and reply
git bisect good 5fb5c395e2c4658a57f894ae9ab72b3d4d71a882
# good: [168869492e7009b6861b615f1d030c99bc805e83] docs: kbuild: fix
build with pdf and fix some minor issues
git bisect good 168869492e7009b6861b615f1d030c99bc805e83
# good: [e444d51b14c4795074f485c79debd234931f0e49] Merge tag
'tty-5.4-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
git bisect good e444d51b14c4795074f485c79debd234931f0e49
# good: [574cc4539762561d96b456dbc0544d8898bd4c6e] Merge tag
'drm-next-2019-09-18' of git://anongit.freedesktop.org/drm/drm
git bisect good 574cc4539762561d96b456dbc0544d8898bd4c6e
# bad: [298fb76a5583900a155d387efaf37a8b39e5dea2] Merge tag 'nfsd-5.4'
of git://linux-nfs.org/~bfields/linux
git bisect bad 298fb76a5583900a155d387efaf37a8b39e5dea2
# bad: [5c6bd5de3c2e5bc8a17451e281ed2613375a7fd5] Merge tag 'mips_5.4'
of git://git.kernel.org/pub/scm/linux/kernel/git/mips/linux
git bisect bad 5c6bd5de3c2e5bc8a17451e281ed2613375a7fd5
# good: [84da111de0b4be15bd500deff773f5116f39f7be] Merge tag
'for-linus-hmm' of git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma
git bisect good 84da111de0b4be15bd500deff773f5116f39f7be
# bad: [10fd71780f7d155f4e35fecfad0ebd4a725a244b] Merge tag 'scsi-misc'
of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
git bisect bad 10fd71780f7d155f4e35fecfad0ebd4a725a244b
# bad: [328bc6debf3dcaf8859dd1323882e8e24ec6e3f8] scsi: hisi_sas: remove
set but not used variable 'irq_value'
git bisect bad 328bc6debf3dcaf8859dd1323882e8e24ec6e3f8
# bad: [cc74049f35e84b6727c70589750c84e6166963ae] scsi: qla2xxx: Use
strlcpy() instead of strncpy()
git bisect bad cc74049f35e84b6727c70589750c84e6166963ae
# good: [93352abc81a90314bf032038200ce96989a32c62] scsi: hisi_sas: Make
max IPTT count equal for all hw revisions
git bisect good 93352abc81a90314bf032038200ce96989a32c62
# bad: [9c067c053f94d36006cd0a29cf02b0b6be54c6ca] scsi: mpt3sas: Handle
fault during HBA initialization
git bisect bad 9c067c053f94d36006cd0a29cf02b0b6be54c6ca
# good: [a07b48766c5232b98154f68010512a9269f2841e] scsi: hisi_sas:
Remove some unnecessary code
git bisect good a07b48766c5232b98154f68010512a9269f2841e
# bad: [ffedeae1fa545a1d07e6827180c3923bf67af59f] scsi: mpt3sas:
Gracefully handle online firmware update
git bisect bad ffedeae1fa545a1d07e6827180c3923bf67af59f
# good: [afcd609e8e7907ccfa04fef0a3adb7d60a298ed6] scsi: pm80xx: remove
redundant assignments to variable rc
git bisect good afcd609e8e7907ccfa04fef0a3adb7d60a298ed6
# bad: [e224e03b0c6a2381ed1ea5325c846582d87d6fae] scsi: mpt3sas: memset
request frame before reusing
git bisect bad e224e03b0c6a2381ed1ea5325c846582d87d6fae
# good: [f23ca2cb2781102b560dbd96fe093b146fd8ec1a] scsi: mpt3sas: Add
support for PCIe Lane margin
git bisect good f23ca2cb2781102b560dbd96fe093b146fd8ec1a
# first bad commit: [e224e03b0c6a2381ed1ea5325c846582d87d6fae] scsi:
mpt3sas: memset request frame before reusing

`ver_linux` as requested in reporting-bugs

tabris@mercury:~/linux-kernel.git$ awk -f scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux mercury 5.8.10mpt3sas+ #12 SMP Thu Sep 17 11:44:53 EDT 2020 x86_64
GNU/Linux

GNU Make                4.2.1
Binutils                2.31.1
Util-linux              2.33.1
Mount                   2.33.1
Bison                   3.3.2
Flex                    2.6.4
Dynamic linker (ldd)    2.28
Procps                  3.3.15
Kbd                     2.0.4
Console-tools           2.0.4
Sh-utils                8.30
Udev                    241
Modules Loaded          acpi_cpufreq aesni_intel ahci amd64_edac_mod
asus_wmi autofs4 battery bna button ccp cec crc16 crc32c_generic
crc32c_intel crc32_pclmul crct10dif_pclmul cryptd crypto_simd dca drm
drm_kms_helper edac_mce_amd eeepc_wmi efi_pstore efivarfs efivars
enclosure evdev ext4 fat ghash_clmulni_intel glue_helper hid hid_generic
hwmon_vid i2c_algo_bit i2c_piix4 igb ip_tables irqbypass jbd2 jc42
joydev k10temp kvm libahci libata libcrc32c mbcache mpt3sas msr mxm_wmi
nct6775 nls_ascii nls_cp437 pcspkr pps_core ptp radeon raid_class rapl
rfkill rng_core scsi_mod scsi_transport_sas sd_mod ses sg snd snd_pcm
snd_timer soundcore sp5100_tco sparse_keymap t10_pi tiny_power_button
ttm usbcore usbhid vfat video watchdog wmi wmi_bmof xfs xhci_hcd
xhci_pci x_tables

