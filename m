From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [Regression 4.13-rc1] Resume does not work on Lenovo X60t
Date: Thu, 3 Aug 2017 19:42:15 +0200
Message-ID: <7032513a-7a28-5807-40d4-cb0f7005d513@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------4DDA596A5E2C64F07194F253"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.molgen.mpg.de ([141.14.17.11]:44536 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751209AbdHCRmS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 3 Aug 2017 13:42:18 -0400
Received: from keineahnung.molgen.mpg.de (keineahnung.molgen.mpg.de [141.14.17.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 503A62012A59C5
        for <linux-scsi@vger.kernel.org>; Thu,  3 Aug 2017 19:42:16 +0200 (CEST)
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------4DDA596A5E2C64F07194F253
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Linux folks,


Since the merge windows opened for Linux 4.13, I am unable to resume 
from ACPI S3 suspend on a Lenovo X60t. The graphics comes back, but I am 
unable to enter anything, and the system seems to be hung. Magic SysRq 
keys still work though, but powering the system of doesn’t work. The 
power button also does not work.

Please find the stack trace with Linux 4.13-rc3 captured over the serial 
console below.

 > ```
> 46.417: [   58.148083] ata6: port disabled--ignoring
> 46.417: [   58.148243] BUG: unable to handle kernel NULL pointer dereference at 000000f4
> 46.417: [   58.148252] IP: blk_set_runtime_active+0x27/0x60
> 46.417: [   58.148253] *pde = 00000000 
> 46.417: [   58.148254] 
> 46.417: [   58.148256] Oops: 0002 [#1] SMP
> 46.418: [   58.148258] Modules linked in: cpufreq_powersave cpufreq_conservative cpufreq_userspace joydev wacom_w8001 serport binfmt_misc iTCO_wdt iTCO_vendor_support coretemp kvm snd_hda_codec_analog snd_hda_codec_generic arc4 irqbypass pcmcia snd_pcsp thinkpad_acpi serio_raw snd_hda_intel snd_hda_codec yenta_socket lpc_ich iwl3945 mfd_core pcmcia_rsrc snd_hda_core iwlegacy snd_hwdep pcmcia_core snd_pcm mac80211 sg rng_core nvram cfg80211 snd_timer snd soundcore rfkill evdev battery ac shpchp acpi_cpufreq parport_pc ppdev lp parport ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 fscrypto ecb cbc algif_skcipher af_alg dm_crypt dm_mod sr_mod cdrom sd_mod ata_generic psmouse i915 i2c_i801 sdhci_pci ahci ata_piix ehci_pci uhci_hcd libahci firewire_ohci sdhci libata firewire_core ehci_hc
 d mmc_core e1000e crc_itu_t
> 46.416: [   58.148310]  scsi_mod ptp usbcore video pps_core button i2c_algo_bit drm_kms_helper thermal syscopyarea sysfillrect sysimgblt fb_sys_fops drm
> 46.416: [   58.148322] CPU: 0 PID: 808 Comm: kworker/u4:38 Not tainted 4.13.0-rc3+ #94
> 46.416: [   58.148323] Hardware name: LENOVO 636338U/636338U, BIOS CBET4000 TIMELESS 01/01/1970
> 46.416: [   58.148328] Workqueue: events_unbound async_run_entry_fn
> 46.416: [   58.148330] task: f2900180 task.stack: f2902000
> 46.416: [   58.148333] EIP: blk_set_runtime_active+0x27/0x60
> 46.416: [   58.148334] EFLAGS: 00010046 CPU: 0
> 46.416: [   58.148335] EAX: 00000000 EBX: f5f3c628 ECX: f5f3c720 EDX: ffff13c5
> 46.416: [   58.148337] ESI: f87a5cc0 EDI: 00000010 EBP: 00000010 ESP: f2903ea4
> 46.416: [   58.148338]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> 46.416: [   58.148340] CR0: 80050033 CR2: 000000f4 CR3: 363b4000 CR4: 000006d0
> 46.416: [   58.148342] Call Trace:
> 46.416: [   58.148361]  ? scsi_bus_resume_common+0x6e/0x110 [scsi_mod]
> 46.416: [   58.148366]  ? dpm_run_callback+0x4f/0x150
> 46.416: [   58.148369]  ? wait_for_completion+0x29/0x140
> 46.416: [   58.148381]  ? scsi_bus_thaw+0x10/0x10 [scsi_mod]
> 46.416: [   58.148384]  ? device_resume+0x8e/0x180
> 46.416: [   58.148387]  ? async_resume+0x1b/0x40
> 46.416: [   58.148389]  ? async_run_entry_fn+0x3f/0x1a0
> 46.416: [   58.148392]  ? process_one_work+0x136/0x310
> 46.416: [   58.148394]  ? worker_thread+0x39/0x3b0
> 46.416: [   58.148396]  ? kthread+0xd7/0x110
> 46.416: [   58.148398]  ? process_one_work+0x310/0x310
> 46.416: [   58.148400]  ? kthread_create_on_node+0x30/0x30
> 46.416: [   58.148403]  ? ret_from_fork+0x19/0x24
> 46.416: [   58.148404] Code: 8d 74 26 00 3e 8d 74 26 00 53 89 c3 8b 80 fc 00 00 00 e8 5d 43 32 00 31 c0 8b 15 20 7e 64 cf 89 83 54 01 00 00 8b 83 50 01 00 00 <89> 90 f4 00 00 00 ba 09 00 00 00 8b 83 50 01 00 00 e8 e3 ef 16
> 46.416: [   58.148437] EIP: blk_set_runtime_active+0x27/0x60 SS:ESP: 0068:f2903ea4
> 46.416: [   58.148438] CR2: 00000000000000f4
> 46.416: [   58.148441] ---[ end trace 529e3022b2906e41 ]---
 > ```

Please find the full log attached. I don’t know, why the Linux kernel 
messages in the beginning are transferred in the wrong baud rate.


Kind regards,

Paul

--------------4DDA596A5E2C64F07194F253
Content-Type: text/x-log;
 name="seriallog-20170803_085205.log"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="seriallog-20170803_085205.log"



======= Thu Aug  3 08:52:39 2017 (adjust=1041.7us)
00.000: <1a><a4>F0<fd><d6>H<8c>:<a1><8b><d1>e<fd><fc>d<08>4
00.012: <8a><0f>v>7<c5>4<e3><f4>I
00.013: u<bd><c8><cd><z<8d><16><18><fb><d2><a1><e0><aa><15>><0b><0f>X<eb>6<a5>T
00.015: C<aa>A<84><ff><96><c4><c0><fb><02><c2>(<84><18><fc>R4<ea><18><9a>:<ff><c6><9c>X<05><07>d<fd><16><ec><c7><08><92><a5><91>d<e8><1e><ad>><b0>nM<ff>*<c2><87><a4>B@<13><1e><d2><81><83><ff><1e><ec><0c><86><12><95>`<80><ec><fd>Z1<b1><fd><89><99><ca><ff><d2><<00>
00.321: <ff><0e><8c>(B<8d><0c><ff>R<cd><ca><14>H<cf><ff><a6>)<ff>R<e9>X)<c6><b0><ec><8a><81><f6><06><06><b8><fe><b2>4<da>2<fa><f9>JV<f8>.<02><fc><90>uR<e1><c2><eb><15><f9><d2>h<a9><94><92>5<09><fd><a6><95><fe><1a><ad><cd><f9><c2><a4><c7>;<96><b5><ff>26<ad><85><ff>:yZ<a3><ff><e4><c6>4@<94><f1><ff><18><96>i<83><ff><c8><b9>N<f9>Xi<02><95>r<c2><88><17><ad><a5><a3><a8>S<ff><d0><b9><16><c4>(E<d8>"<fd>p<c5>l<82><fc>
00.514: <16><96>4<b4><d8>,<ff><1a><b4><a4>:+<ed><80><9e><a4>8<0c><e5><ff>P<19><f6><12><e5><c4>xB<e2><86><05><1c>*<18>)<ff>xb<02>.<ff><e0>'$<a0><ec><e0>&-
00.539: <b4><08><fa>:<a0><d3>\(<95><12><02><0e><16>i.<fe><dc><a9><16>r<fe>"F<08><ff>*<02><ae>%<ca>:#<cd><02>F,<e4>"<01><a3><fa>p<c5><<8c><f2><a2><1d>Z<92><fc><d0><dd><04><fc><a2><8d><d9><9b>p<85><81><12>$<f1><1a><e5><c4><f0>#<bc><0f><89><c7><fb>l<a5><fe><f9><aa><04><fa><90><bc><c5>l<a4>,<ca><ff>@<99>T<af><04><ed>
00.602: <14><f0><85>1<f9><b2><fa>2<d2><ba><86><be><86>64z<12><f5>*<ff>
00.622: <f6>p<fb><b6>:<08><b1><0e><fe><e8><bc><80><84><e4>
00.634: <e4>P<04><a7>!<ff>x$<e1><ff><80><8a>HD<ee>
00.641: D*<d0><b9><16><c4>>|<1a><10><f7>d<c5>l<86><f8>`<f5><a4><ff><d0><ed><06><c5><16><b4><a4><be><05><f0><9e>e<c4><08>6%<f7><02>D<a4>|<b4>*<00>
00.659: <a1><16>2<90><e4><82>\<8c>i<fe><c0><cd>F<93><e0><1e><b4><ac><fc><a0><05><ed>K<16>4<a4>(]<fd><a2><04><ee>
00.674: <a2><c3><f4>HL<fc><1e>d<8a>%<85><a8>$G<e8>P<db><86><ec>>q<82><8c><d7><0e>8<a1>|<80><f5>"<86><bb>"n<d8><08>
00.685: <a2><99><e8><bb><86><07>"
00.686: <89><19>yo<90><8e>tYd<fe><16>-<07><01><c2>,M<a1><9c><89><9c>M-<c5>9<12><c9>D<94><d5><8a><eb>A<<c0><b9><04><89>F<d9>>[%<dc>.<89>
00.725: <b5>Tf<d6>-^p<e5><ac><8e>p<85><91><94><04>
00.725: <a2>J<fe><1e><90><c6><c3>a<95>)#<84><07><a8>6<ac><cf><a6><04>o<16><1b>Y$<a4><07><80><1f>m<03><06><c5><83><12>V<f6>=<b6>5.<80><98><G<86><e5><17>D<c2><ec><c6><11><fc><01><86><ad><0b>`<a1><ae><e8><ec><c2><08>i<87>)<a2><c3>R<e9><17>}<1f>5<02><17><f5>
01.223: <0e>kY<f5><08>2`<cd><83><af><93><81>'<f0><a0>t"<1c><16><=<09><ff><08>2<e9>"<1c><ce><d5><8d>45B<fa>8<8a><a1>`<17><1a>%C<fe>done.
02.566: Begin: Mounting root file system ... Begin: Running /scripts/local-top ...
02.566: Please unlock disk sda2crypt: […]
18.195: [   22.240550] NET: Registered protocol family 38
18.383: cryptsetup (sda2crypt): set up successfully
18.383: done.
18.383: Begin: Running /scripts/local-premount ... done.
18.383: Begin: Will now check root file system ... fsck from util-linux 2.29.2
18.383: [/sbin/fsck.ext4 (1) -- /dev/mapper/sda2crypt] fsck.ext4 -a -C0 /dev/mapper/sda2crypt
18.383: gm-root: recovering journal
18.417: gm-root: clean, 2381576/15499264[   22.850800] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
18.417:  files, 55727098/61989718 blocks
18.417: done.
18.417: done.
18.417: Begin: Running /scripts/local-bottom ... done.
18.417: Begin: Running /scripts/init-bottom ... done.
18.693: [   23.380229] ip_tables: (C) 2000-2006 Netfilter Core Team
18.708: [   23.456475] systemd[1]: systemd 232 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
18.710: [   23.676958] systemd[1]: Detected architecture x86.
18.959: [   24.101459] systemd[1]: Listening on Syslog Socket.
18.959: [<1b>[0;32m  OK  <1b>[[   24.162477] systemd[1]: Reached target Remote File Systems.
18.959: 0m] Listening on[   24.248603] systemd[1]: Listening on Journal Audit Socket.
18.959:  Syslog Socket.[   24.330859] systemd[1]: Listening on fsck to fsckd communication Socket.
18.959:
18.959: [<1b>[0;32m  OK  [   24.427706] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
18.959: <1b>[0m] Reached ta[   24.525201] systemd[1]: Listening on Network Service Netlink Socket.
18.959: rget Remote File[   24.617933] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
18.959:  Systems.
18.959: [<1b>[0;32m  OK  <1b>[0m] Listening on Journal Audit Socket.
18.959: [<1b>[0;32m  OK  <1b>[0m] Listening on fsck to fsckd communicatio[   24.854067] lp: driver loaded but no devices found
18.959: n Socket.
18.959: [<1b>[0;32m  OK  <1b>[0m] Listening on /dev/initctl Compatibility Named Pi[   24.981381] ppdev: user-space parallel port driver
18.959: pe.
18.959: [<1b>[0;32m  OK  <1b>[0m] Listening on Network Service Netlink Socket.
18.959: [<1b>[0;32m  OK  <1b>[0m] Started Forward Password Requests to Wall Directory Watch.
18.958: [<1b>[0;3[   25.073105] parport0: PC-style at 0x3bc (0x7bc) [PCSPP,TRISTATE]
18.958: 2m  OK  <1b>[0m] Li[   25.294154] parport0: irq 7 detected
18.958: stening on Journal Socket (/dev/log).
18.958: [<1b>[0;32m  OK  <1b>[0m] Created slice User and Session Slice[   25.448262] lp0: using parport0 (polling).
18.958: .
18.958: [<1b>[0;32m  OK  <1b>[0m] Listenin[   25.520620] EXT4-fs (dm-0): re-mounted. Opts: errors=remount-ro,discard
18.958: g on udev Control Socket.
18.958: [<1b>[0;32m  OK  <1b>[0m] Listening on udev Kernel Socket.[   25.686460] systemd-journald[256]: Received request to flush runtime journal from PID 1
18.958:
18.958: [<1b>[0;32m  OK  <1b>[0m] Reached target Swap.
18.958: [<1b>[   25.842847] systemd-journald[256]: File /var/log/journal/3606b1ddb0854918b8e3d24578588f9c/system.journal corrupted or uncleanly shut down, renaming and replacing.
18.961: [0;32m  OK  <1b>[0m] Listening on Journal Socket.
18.961: [<1b>[0;32m  OK  <1b>[0m] Set up automount Arbitrary Executable File Formats File System Automount Point.
18.961: [<1b>[0;32m  OK  <1b>[0m] Created slice System Slice.
18.961:          Mounting POSIX Message Queue File System...
18.961: [   26.272737] e1000e 0000:01:00.0: Disabling ASPM L0s L1
18.961: [<1b>[0;32m  OK  <1b>[0m] Created slice system-serial\x2dgetty.slice.
18.961: [<1b>[0;32m  OK  <1b>[0m] Reached target Slices.
18.961:          Starting Journal Service[   26.484410] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
18.961: ...
18.961:          Starting Set the console keyboard layout...
18.960:          Starting Load Kernel Modules...
18.960: [<1b>[0;32m[   26.684765] IPv6: ADDRCONF(NETDEV_UP): eth8: link is not ready
18.960:   OK  <1b>[0m] Created slice system[   26.784545] ACPI: Battery Slot [BAT0] (battery absent)
18.960: -systemd\x2dfsck[   26.866005] ACPI: Battery Slot [BAT1] (battery absent)
18.961: .slice.
18.961:          Mounting Temporary Directory...
18.960:          Starting Create list of required static device nod[   27.045384] ACPI: AC Adapter [AC] (on-line)
18.960: es for the current kernel...
18.960: [<1b>[0;32m  OK  <1b>[0m] Created slice system-getty.slice.
18.960:          Starting Remount[   27.204220] Non-volatile memory driver v1.3
18.960:  Root and Kernel[   27.281013] sd 0:0:0:0: Attached scsi generic sg0 type 0
18.960:  File Systems...
18.960:          Mounting Debug File [   27.390753] ACPI Exception: AE_NOT_FOUND, Error reading AC Adapter state (20170531/ac-139)
18.960: System...
18.960:     [   27.500579] intel_rng: FWH not detected
18.960:      Mounting Huge Pages File System...
18.960: [<1b>[0;32m  OK  <1b>[0m] Created slice syst[   27.629427] ACPI Warning: SystemIO range 0x0000000000000528-0x000000000000052F conflicts with OpRegion 0x0000000000000500-0x000000000000057F (\PMIO) (20170531/utaddress-247)
18.960: em-systemd\x2dcr[   27.830810] sr 4:0:0:0: Attached scsi generic sg1 type 5
18.960: yptsetup.slice.[   27.911109] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
18.960:
18.960: [<1b>[0;32m  OK  [   28.053620] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:s
18.960: <1b>[0m] Mounted Te[   28.175431] iwl3945: Copyright(c) 2003-2011 Intel Corporation
18.960: mporary Director[   28.175432] iwl3945: hw_scan is disabled
18.960: y.
18.960: [<1b>[0;32m  O[   28.329708] ACPI Warning: SystemIO range 0x00000000000004B0-0x00000000000004BF conflicts with OpRegion 0x0000000000000480-0x00000000000004BB (\GPIO) (20170531/utaddress-247)
18.959: K  <1b>[0m] Mounted[   28.526219] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
18.959:  POSIX Message Q[   28.527728] yenta_cardbus 0000:05:00.0: CardBus bridge found [0000:0000]
18.959: ueue File System[   28.692831] yenta_cardbus 0000:05:00.0: ISA IRQ mask 0x0ca8, PCI irq 16
18.959: .
18.959: [<1b>[0;32m  OK[   28.692836] yenta_cardbus 0000:05:00.0: Socket status: 30000006
18.959:   <1b>[0m] Mounted [   28.692840] pci_bus 0000:05: Raising subordinate bus# of parent bus (#05) from #06 to #09
18.959: Debug File Syste[   28.692850] yenta_cardbus 0000:05:00.0: pcmcia: parent PCI bridge window: [io  0x2000-0x3fff]
18.959: m.
18.959: [<1b>[0;32m  O[   28.692853] yenta_cardbus 0000:05:00.0: pcmcia: parent PCI bridge window: [mem 0xe0000000-0xe20fffff]
18.959: K  <1b>[0m] Mounted[   28.692856] pcmcia_socket pcmcia_socket0: cs: memory probe 0xe0000000-0xe20fffff:
18.959:  Huge Pages File[   28.692868]  excluding 0xe1ef0000-0xe20fffff
18.959:  System.
18.959: [<1b>[0;[   28.692873] yenta_cardbus 0000:05:00.0: pcmcia: parent PCI bridge window: [mem 0xe2100000-0xe40fffff 64bit pref]
18.959: 32m  OK  <1b>[0m] S[   28.692875] pcmcia_socket pcmcia_socket0: cs: memory probe 0xe2100000-0xe40fffff:
18.959: tarted Journal S[   28.692882]  excluding 0xe2100000-0xe40fffff
18.959: ervice.
18.958: [<1b>[0;3[   28.749670] iwl3945 0000:02:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
18.958: 2m  OK  <1b>[0m] St[   28.749673] iwl3945 0000:02:00.0: Detected Intel Wireless WiFi Link 3945ABG
18.958: arted Set the co[   30.008050] input: PC Speaker as /devices/platform/pcspkr/input/input7
18.958: nsole keyboard l[   30.095232] ACPI Warning: SystemIO range 0x0000000000000480-0x00000000000004AF conflicts with OpRegion 0x0000000000000480-0x00000000000004BB (\GPIO) (20170531/utaddress-247)
18.958: ayout.
18.958: [<1b>[0;32m  OK  <1b>[0m] Sta[   30.095246] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
18.958: rted Load Kernel[   30.095248] lpc_ich: Resource conflict(s) found affecting gpio_ich
18.958:  Modules.
18.958: [<1b>[0[   30.095380] thinkpad_acpi: ThinkPad ACPI Extras v0.25
18.958: ;32m  OK  <1b>[0m] [   30.095381] thinkpad_acpi: http://ibm-acpi.sf.net/
18.958: Started Create l[   30.095382] thinkpad_acpi: ThinkPad BIOS CBET4000 TIMELESS, EC 7JHT12WW-3.4
18.958: ist of required [   30.095383] thinkpad_acpi: Lenovo ThinkPad X60 Tablet, model 636338U
18.958: static device no[   30.095639] snd_hda_intel 0000:00:1b.0: probe_mask set to 0x1 for device 17aa:2010
18.958: des for the curr[   30.305951] thinkpad_hwmon thinkpad_hwmon: hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
18.958: ent kernel.
18.958: [<1b>[   30.307356] thinkpad_acpi: Tablet mode switch found (type: MHKG), currently in laptop mode
18.958: [0;32m  OK  <1b>[0m[   30.307379] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
18.958: ] Started Remoun[   30.307380] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
18.957: t Root and Kerne[   30.543476] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
18.957: l File Systems.[   30.544904] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
18.957:
18.957:          Start[   30.548180] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input8
18.957: ing udev Coldplu[   30.887276] snd_hda_codec_analog hdaudioC0D0: autoconfig for AD1981: line_outs=1 (0x5/0x0/0x0/0x0/0x0) type:speaker
18.957: g all Devices...[   30.887279] snd_hda_codec_analog hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
18.957:
18.957:          Star[   30.887282] snd_hda_codec_analog hdaudioC0D0:    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
18.957: ting Load/Save R[   30.887284] snd_hda_codec_analog hdaudioC0D0:    mono: mono_out=0x0
18.957: andom Seed...
18.957: [   30.887286] snd_hda_codec_analog hdaudioC0D0:    dig-out=0xa/0x0
18.957:          Startin[   30.887287] snd_hda_codec_analog hdaudioC0D0:    inputs:
18.957: g Create Static [   30.887290] snd_hda_codec_analog hdaudioC0D0:      Mic=0x8
18.957: Device Nodes in [   30.887293] snd_hda_codec_analog hdaudioC0D0:      CD=0x19
18.957: /dev...
18.957:       [   31.171298] leds_ss4200: no LED devices found
18.957:    Starting Appl[   31.173485] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
18.957: y Kernel Variabl[   31.398842] iwl3945 0000:02:00.0 wlan4: renamed from wlan0
18.957: es...
18.957:         [   32.590354] iTCO_vendor_support: vendor-support=0
18.957:  Starting Flush [   32.855681] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
18.957: Journal to Persi[   32.855761] iTCO_wdt: Found a ICH7-M or ICH7-U TCO device (Version=2, TCOBASE=0x0560)
18.957: stent Storage...[   32.856194] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
18.957:
18.957: [<1b>[0;32m  OK  <1b>[0m] Started Load/Save Random Seed.
18.957: [<1b>[0;32m  OK  <1b>[0m] Started Create Static Device Nodes in /dev.
18.957: [<1b>[0;32m  OK  <1b>[0m] Started Apply Kernel Variables.
18.957: [<1b>[0;32m  OK  <1b>[[   33.009640] intel_powerclamp: No package C-state available
18.957: 0m] Started udev[   33.486002] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: discard
18.957:  Coldplug all Devices.
18.957:          Starting udev Kernel Device Manager...
18.957: [<1b>[0;32m  OK  <1b>[0m] Reached target Local File Systems (Pre).
18.957: [<1b>[0;32m  OK  <1b>[0m] Started udev Kernel Device Manager.
18.956:          Starting Show Plymouth Boot Screen...
18.956:          Starting Network Service...
18.956: [<1b>[0;32m  OK  <1b>[0m] Started Show Plymouth Boot Screen.
18.956: [<1b>[0;32m  OK  <1b>[0m] Started Forward Password Requests to Plymouth Directory Watch.
18.956:          Starting Show Plymouth Boot Screen...
18.956: [<1b>[0;32m  OK  <1b>[0m] Started Network Service.
18.956: [<1b>[0;32m  OK  <1b>[0m] Started Show Plymouth Boot Screen.
18.956: [<1b>[0;32m  OK  <1b>[0m] Reached target Network.
18.956: [<1b>[0;32m  OK  <1b>[0m] Reached target Network is Online.
18.956: [<1b>[0;32m  OK  <1b>[0m] Created slice system-systemd\x2dbacklight.slice.
18.956:          Starting Load/Save Screen Backlight Brightness of backlight:acpi_video0...
18.955: [<1b>[0;32m  OK  <1b>[0m] Started Load/Save Screen Backlight Brightness of backlight:acpi_video0.
18.955:          Starting Load/Save Screen Backlight Brightness of backlight:intel_backlight...
18.955: [<1b>[0;32m  OK  <1b>[0m] Started Load/Save Screen Backlight Brightness of backlight:intel_backlight.
18.955: [<1b>[0;32m  OK  <1b>[0m] Started Flush Journal to Persistent Storage.
18.955: [<1b>[0;32m  OK  <1b>[0m] Found device M4-CT256M4SSD2 2.
18.955: [<1b>[0;32m  OK  <1b>[0m] Found device M4-CT256M4SSD2 gm-boot.
18.955: [<1b>[0;32m  OK  <1b>[0m] Found device /dev/ttyS1.
18.954: [<1b>[0;32m  OK  <1b>[0m] Reached target Sound Card.
18.954: [<1b>[0;32m  OK  <1b>[0m] Listening on Load/Save RF Kill Switch Status /dev/rfkill Watch.
18.954: [<1b>[0;32m  OK  <1b>[0m] Created slice system-wacom\x2dinputattach.slice.
18.954:          Starting Show Plymouth Boot Screen...
18.954:          Starting File System Check on /dev/disk/by-uuid/5843f52e-f13a-4f3f-a105-a91ca427dbd8...
18.954:          Starting Cryptography Setup for sda2crypt...
18.954:          Starting Load/Save RF Kill Switch Status...
18.954: [<1b>[0;32m  OK [   35.546138] serio: Serial port ttyS0
18.954:  <1b>[0m] Started Cryptography Setup for sda2crypt.
18.954: [<1b>[0;32m  OK  <1b>[0m] Started Load/Save RF Kill Switch Status.
18.954: [<1b>[0;32m  OK  <1b>[0m] Started File System Check Daemon to report status.
18.953: [<1b>[0;32m  OK  <1b>[0m] Started Show Plymouth Boot Screen.
18.953: [<1b>[0;32m  OK  <1b>[0m] Reached target Encrypted Volumes.
18.953: [<1b>[0;32m  OK  <1b>[0m] Started File System Check on /dev/disk/by-uuid/5843f52e-f13a-4f3f-a105-a91ca427dbd8.
18.953:          Mounting /boot...
18.953: [<1b>[0;32m  OK  <1b>[0m] Mounted /boot.
18.953: [<1b>[0;32m  OK  <1b>[0m] Reached target Local File Systems.
18.953:          Starting Set console font and keymap...
18.953:          Starting Enable support for additional executable binary formats...
18.953:          Starting Create Volatile Files and Directories...
18.952:          Starting Tell Plymouth To Write Out Runtime Data...
18.952:          Mounting Arbitrary Executable File Formats File System...
18.952: [<1b>[0;32m  OK  <1b>[0m] Started Set console font and keymap.
18.952: [<1b>[0;32m  OK  <1b>[0m] Mounted Arbitrary Executable File Formats File System.
18.952: [<1b>[0;32m  OK  <1b>[0m] Started Tell Plymouth To Write Out Runtime Data.
18.952: [<1b>[0;32m  OK  <1b>[0m] Started Enable support for additional executable binary formats.
18.952: [<1b>[0;32m  OK  <1b>[0m] Started Create Volatile Files and Directories.
18.952:          Starting Network Time S[   36.896273] input: Wacom Serial Penabled Pen as /devices/pnp0/00:06/tty/ttyS0/serio2/input/input10
18.952: ynchronization...
18.952:          Starting Update UTMP about System Boot/Shutdown...
18.951: [<1b>[0;32m  OK  <1b>[0m] Started Update UTMP about System Boot/Shutdown.
18.951: [<1b>[0;32m  OK  <1b>[0m] Started Network Time Synchronization.
18.951: [<1b>[0;32m  OK  <1b>[0m] Reached target System Time Synchronized.
18.951: [<1b>[0;32m  OK  <1b>[0m] Reached target System Initialization.
18.951: [<1b>[0;32m  OK  <1b>[0m] Started CUPS Scheduler.
18.951: [<1b>[0;32m  OK  <1b>[0m] Reached target Paths.
18.951: [<1b>[0;32m  OK  <1b>[0m] Listening on D-Bus System Message Bus Socket.
18.951: [<1b>[0;32m  OK  <1b>[0m] Started Daily apt download activities.
18.951: [<1b>[0;32m  OK  <1b>[0m] Listening on PC/SC Smart Card Daemon Activation Socket.
18.951:          Starting Docker Socket for the API.
18.950: [<1b>[0;32m  OK  <1b>[0m] Listening on Avahi mDNS/DNS-SD Stack Activation Socket.
18.950: [<1b>[0;32m  OK  <1b>[0m] Started Daily Cleanup of Temporary Directories.
18.950: [<1b>[0;32m  OK  <1b>[0m] Started Daily apt upgrade and clean activities.
18.950: [<1b>[0;32m  OK  <1b>[0m] Listening on CUPS Scheduler.
18.950: [<1b>[0;32m  OK  <1b>[0m] Started Trigger anacron every hour.
18.950: [<1b>[0;32m  OK  <1b>[0m] Reached target Timers.
18.950: [<1b>[0;32m  OK  <1b>[0m] Listening on Docker Socket for the API.
18.950: [<1b>[0;32m  OK  <1b>[0m] Reached target Sockets.
18.950: [<1b>[0;32m  OK  <1b>[0m] Reached target Basic System.
18.950:          Starting LSB: Load kernel modules needed to enable cpufreq scaling...
18.949:          Starting /etc/rc.local Compatibility...
18.949:          Starting LSB: starts tcsd...
18.949:          Starting Save/Restore Sound Card State...
18.949:          Starting LSB: Start busybox udhcpd at boot time...
18.949:          Starting Network Name Resolution...
18.949:          Starting Provide limited super user privileges to specific users...
18.949: [<1b>[0;32m  OK  <1b>[0m] Started Run anacron jobs.
18.949: [<1b>[0;32m  OK  <1b>[0m] Started Regular background program processing daemon.
18.949:          Starting LSB: Advanced IEEE 802.11 management daemon...
18.949:          Starting Initialize hardware monitoring sensors...
18.948:          Starting LSB: Init-Script for DCMTK STORE SCP: storescp...
18.948:          Starting Daemon which manages cryptographic hardware tokens for the openCryptoki package...
18.948:          Starting Login Service...
18.948: [<1b>[0;32m  OK  <1b>[0m] Started CUPS Scheduler.
18.948: [<1b>[0;32m  OK  <1b>[0m] Reached target Printer.
18.948:          Starting LSB: Init-Script for DCMTK Central Test Node dcmqrscp...
18.948: [<1b>[0;32m  OK  <1b>[0m] Started inputattach for Wacom ISDv4-compatible serial devices.
18.948:          Starting RealtimeKit Scheduling Policy Service...
18.948: [<1b>[0;32m  OK  <1b>[0m] Started D-Bus System Message Bus.
18.947: [<1b>[0;32m  OK  <1b>[0m] Started RealtimeKit Scheduling Policy Service.
18.947:          Starting System Logging Service...
18.947:          Starting Permit User Sessions...
18.947: [<1b>[0;32m  OK  <1b>[0m] Started irqbalance daemon.
18.947:          Starting LSB: start/stop the battery statistics collector...
18.947:          Starting LSB: Start/stop sysstat's sadc...
18.947:          Starting Avahi mDNS/DNS-SD Stack...
18.947: [<1b>[0;32m  OK  <1b>[0m] Started /etc/rc.local Compatibility.
18.947: [<1b>[0;32m  OK  <1b>[0m] Started Save/Restore Sound Card State.
18.947: [<1b>[0;32m  OK  <1b>[0m] Started Provide limited super user privileges to specific users.
18.946: [<1b>[0;32m  OK  <1b>[0m] Started LSB: Advanced IEEE 802.11 management daemon.
18.946: [<1b>[0;32m  OK  <1b>[0m] Started LSB: Init-Script for DCMTK STORE SCP: storescp.
18.946: [<1b>[0;32m  OK  <1b>[0m] Started Daemon which manages cryptographic hardware tokens for the openCryptoki package.
18.946: [<1b>[0;32m  OK  <1b>[0m] Started LSB: Init-Script for DCMTK Central Test Node dcmqrscp.
18.946: [<1b>[0;32m  OK  <1b>[0m] Started Permit User Sessions.
18.946: [<1b>[0;32m  OK  <1b>[0m] Started Initialize hardware monitoring sensors.
18.946: [<1b>[0;32m  OK  <1b>[0m] Started System Logging Service.
18.945: [<1b>[0;32m  OK  <1b>[0m] Started Network Name Resolution.
18.945: [<1b>[0;32m  OK  <1b>[0m] Started Avahi mDNS/DNS-SD Stack.
18.945: [<1b>[0;32m  OK  <1b>[0m] Started Login Service.
18.945:          Starting Terminate Plymouth Boot Screen...
18.945:          Starting Hold until boot process finishes up...
18.945:          Starting Manage, Install and Generate Color Profiles...
18.945: [<1b>[0;32m  OK  <1b>[0m] Started Manage, Install and Generate Color Profiles.
18.945: [<1b>[0;32m  OK  <1b>[0m] Started LSB: Start/stop sysstat's sadc.
20.168: [   47.430171] systemd-journald[256]: File /var/log/journal/3606b1ddb0854918b8e3d24578588f9c/user-1000.journal corrupted or uncleanly shut down, renaming and replacing.
32.951: [   55.291328] PM: Syncing filesystems ... done.
32.968: [   55.524991] Freezing user space processes ... (elapsed 0.001 seconds) done.
32.968: [   55.609846] OOM killer disabled.
32.969: [   55.648481] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
33.311: [   56.080278] PM: suspend of devices complete after 341.565 msecs
33.328: [   56.168189] PM: late suspend of devices complete after 17.003 msecs
33.349: [   56.264039] PM: noirq suspend of devices complete after 20.817 msecs
33.349: [   56.340404] ACPI: Preparing to enter system sleep state S3
33.700: [   56.756054] ACPI: EC: event blocked
33.699: [   56.760008] ACPI: EC: EC stopped
33.700: [   56.836393] PM: Saving platform NVS memory
33.700: [   56.885384] Disabling non-boot CPUs ...
33.713: [   56.944336] IRQ 1: no longer affine to CPU1
33.713: [   56.948008] IRQ 9: no longer affine to CPU1
33.713: [   56.948008] IRQ 12: no longer affine to CPU1
33.713: [   56.948008] IRQ 14: no longer affine to CPU1
33.713: [   56.948008] IRQ 16: no longer affine to CPU1
33.713: [   56.948008] IRQ 19: no longer affine to CPU1
33.713: [   56.948008] IRQ 29: no longer affine to CPU1
33.714: [   57.300720] smpboot: CPU 1 is now offline
45.494: <00>
46.092: ; <b5>s3<cb>0<b7><a0>#)<07><ac><dd><8b><95>+,<b2><9a><b5><95><a3><b5><ac><a2><a5><a9>; <b5>s3<cb>0<b7><a0>#)<07><a5><a4><a0><1a><a0>F!F%jj<07> <b5>s3<cb>0<b7> -<07><b2><9a><b4><c9><ca><9d>0<85>3/<d6> <d9><06><ad>j/<96>-<fd><07> <b5>s3<cb>0<b7><a0>V3%<91><89> z21<e6>6<86><a0>V<a3><b9><9a>-<dd> <a0><bb><ae>F9<b0><eb><a0>r!<c4>)<9d><ae><b9>K<af><d1>#<b5><06>.<b9>Ko <a0><bb>.<8b>3<ab><b6> 8<d3> <f4>/K<ae><02><b3><c1><a3><b9>J<a7><93>!K/<e9>K<b7> <a0><bb>.<a3><b8><c3><b9><a0><d6>0<f4>/<d3> <f4>/K<ae><02><ae><91><09>00<f6><a3><9a><b3><c9>1!<a9><04>0<b1><a9>; 5s9<c3>0<b8><a0><a5>$<af><f4><a4><d2><a0><a5>$<af><f4><a4><02>5<a4><b4>"<a0>
46.129: 2<e5><b4><81>V<b6><cd><ea><b9>05c
46.132: <b4><02>=20k<b0>k<b0>-m <a0><b3><ae>40<b8><a0><b9><8a><a9><ac><e9><ca><9d>#<b5><14>-<dd> <a0><b3><ae>40<b8> J<b3>"<95><02><a6>3<03>3<93>)<9d>/%<16><b4><bd><cd>K<bf><07> <b5>s<b6>8<c3><b1> <a3>#<95><07><b0><b2>r4#<b5><a0><86><af>c$<ae><d1><a2><02>3<95><09>)<9d>K<df> <a0><bb>.<b3>24=#<b5><a0><cd>5-<fd>; <b5>s63<96><b8><a0>#)<07><b7><ab><b9><02>5 <92><af><81><96>3+-3<95><09><a0>F!+<a0>6-<fd>; <b5>s9<c3>8<b8> -<07><ae><a5><16> V<b3>k%/<02><a4><b2><a9>T3<a3><b5><ac><a2>%!<a2>%<06>2.<a3>9<ad>V<a3><d6><ea><07> 5.<b0>4<cb>=<b0><94>%<c1>00:0<17>#<c1><07><a3><95>0<d3><a0><c6>/C<b0><e9><ac><b9><05>5-}<07> 5.4<cb>9=<b0><e9><a5>2<e5><b2><9a><b5><95>/<02><a4><b2><a9>T3<a3><b5><ac><a2>%!<a2>%<06><b4>s<b5><8b><a0><cd>i<b3><a9>; 5<ae>0<16><b6><d6><a0><9b>"<b5>&1<07><b2><bd><03><a8><13> <bd>F <af>+2
 /<06><b7>3<b2><9a>%k<ea>+<02><02><aa><c2>r<8a><82><92><a2><b2><c2><ea><81>ACPI: EC: event unblocked
46.417: [   58.102706] usb usb3: root hub lost power or was reset
46.418: [   58.102816] usb usb4: root hub lost power or was reset
46.418: [   58.102928] usb usb5: root hub lost power or was reset
46.418: [   58.103168] sdhci-pci 0000:05:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
46.417: [   58.103211] sdhci-pci 0000:05:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
46.417: [   58.104135] ACPI: button: The lid device is not compliant to SW_LID.
46.417: [   58.148083] ata6: port disabled--ignoring
46.417: [   58.148243] BUG: unable to handle kernel NULL pointer dereference at 000000f4
46.417: [   58.148252] IP: blk_set_runtime_active+0x27/0x60
46.417: [   58.148253] *pde = 00000000
46.417: [   58.148254]
46.417: [   58.148256] Oops: 0002 [#1] SMP
46.418: [   58.148258] Modules linked in: cpufreq_powersave cpufreq_conservative cpufreq_userspace joydev wacom_w8001 serport binfmt_misc iTCO_wdt iTCO_vendor_support coretemp kvm snd_hda_codec_analog snd_hda_codec_generic arc4 irqbypass pcmcia snd_pcsp thinkpad_acpi serio_raw snd_hda_intel snd_hda_codec yenta_socket lpc_ich iwl3945 mfd_core pcmcia_rsrc snd_hda_core iwlegacy snd_hwdep pcmcia_core snd_pcm mac80211 sg rng_core nvram cfg80211 snd_timer snd soundcore rfkill evdev battery ac shpchp acpi_cpufreq parport_pc ppdev lp parport ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 fscrypto ecb cbc algif_skcipher af_alg dm_crypt dm_mod sr_mod cdrom sd_mod ata_generic psmouse i915 i2c_i801 sdhci_pci ahci ata_piix ehci_pci uhci_hcd libahci firewire_ohci sdhci libata firewire_core ehci_hcd 
 mmc_core e1000e crc_itu_t
46.416: [   58.148310]  scsi_mod ptp usbcore video pps_core button i2c_algo_bit drm_kms_helper thermal syscopyarea sysfillrect sysimgblt fb_sys_fops drm
46.416: [   58.148322] CPU: 0 PID: 808 Comm: kworker/u4:38 Not tainted 4.13.0-rc3+ #94
46.416: [   58.148323] Hardware name: LENOVO 636338U/636338U, BIOS CBET4000 TIMELESS 01/01/1970
46.416: [   58.148328] Workqueue: events_unbound async_run_entry_fn
46.416: [   58.148330] task: f2900180 task.stack: f2902000
46.416: [   58.148333] EIP: blk_set_runtime_active+0x27/0x60
46.416: [   58.148334] EFLAGS: 00010046 CPU: 0
46.416: [   58.148335] EAX: 00000000 EBX: f5f3c628 ECX: f5f3c720 EDX: ffff13c5
46.416: [   58.148337] ESI: f87a5cc0 EDI: 00000010 EBP: 00000010 ESP: f2903ea4
46.416: [   58.148338]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
46.416: [   58.148340] CR0: 80050033 CR2: 000000f4 CR3: 363b4000 CR4: 000006d0
46.416: [   58.148342] Call Trace:
46.416: [   58.148361]  ? scsi_bus_resume_common+0x6e/0x110 [scsi_mod]
46.416: [   58.148366]  ? dpm_run_callback+0x4f/0x150
46.416: [   58.148369]  ? wait_for_completion+0x29/0x140
46.416: [   58.148381]  ? scsi_bus_thaw+0x10/0x10 [scsi_mod]
46.416: [   58.148384]  ? device_resume+0x8e/0x180
46.416: [   58.148387]  ? async_resume+0x1b/0x40
46.416: [   58.148389]  ? async_run_entry_fn+0x3f/0x1a0
46.416: [   58.148392]  ? process_one_work+0x136/0x310
46.416: [   58.148394]  ? worker_thread+0x39/0x3b0
46.416: [   58.148396]  ? kthread+0xd7/0x110
46.416: [   58.148398]  ? process_one_work+0x310/0x310
46.416: [   58.148400]  ? kthread_create_on_node+0x30/0x30
46.416: [   58.148403]  ? ret_from_fork+0x19/0x24
46.416: [   58.148404] Code: 8d 74 26 00 3e 8d 74 26 00 53 89 c3 8b 80 fc 00 00 00 e8 5d 43 32 00 31 c0 8b 15 20 7e 64 cf 89 83 54 01 00 00 8b 83 50 01 00 00 <89> 90 f4 00 00 00 ba 09 00 00 00 8b 83 50 01 00 00 e8 e3 ef 16
46.416: [   58.148437] EIP: blk_set_runtime_active+0x27/0x60 SS:ESP: 0068:f2903ea4
46.416: [   58.148438] CR2: 00000000000000f4
46.416: [   58.148441] ---[ end trace 529e3022b2906e41 ]---
46.418: [   61.716133] pciehp 0000:00:1c.0:pcie004: Timeout on hotplug command 0x1038 (issued 60400 msec ago)
46.418: [   61.716196] pciehp 0000:00:1c.0:pcie004: Device 0000:01:00.0 already exists at 0000:01:00, cannot hot-add
46.418: [   61.716199] pciehp 0000:00:1c.0:pcie004: Cannot add device at 0000:01:00
46.418: [   61.724651] ata5.00: configured for UDMA/33
46.418: [   61.952061] usb 2-6: reset high-speed USB device number 2 using ehci-pci
46.417: [   61.984061] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
46.417: [   61.984628] ata1.00: ATA Identify Device Log not supported
46.417: [   61.984629] ata1.00: Security Log not supported
46.417: [   61.985241] ata1.00: ATA Identify Device Log not supported
46.418: [   61.985242] ata1.00: Security Log not supported
46.418: [   61.985246] ata1.00: configured for UDMA/100
46.417: [   62.304069] firewire_core 0000:05:00.1: rediscovered device fw0
46.524: [   62.688083] pciehp 0000:00:1c.0:pcie004: Device 0000:01:00.0 already exists at 0000:01:00, cannot hot-add
46.527: [   62.805097] pciehp 0000:00:1c.0:pcie004: Cannot add device at 0000:01:00

--------------4DDA596A5E2C64F07194F253--
