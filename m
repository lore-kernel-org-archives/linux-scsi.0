From: Matthias Prager <linux@matthiasprager.de>
Subject: Re: mpt2sas + raid10 goes boom
Date: Mon, 08 Apr 2013 15:13:00 +0200
Message-ID: <5162C25C.3090707@matthiasprager.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dd15408.kasserver.com ([85.13.136.168]:49799 "EHLO
	dd15408.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935600Ab3DHNVW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Apr 2013 09:21:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org
Cc: Matthias Prager <linux@matthiasprager.de>, Chris Dunlop <chris@onthe.net.au>

Hello,

I'm having the same (or a similar) issue. Using a 3.8.5 kernel on a
virtualized 64bit gentoo linux (esxi 5.1 as host) with two lsi 9211-8i
controllers (running IR P15 firmware) passed-through to the linux guest
os. I'm using several linux-md raids (raid1 over two disks each) with
ext4 on top.

I had two arrays dropping one disk each and ext4 reporting errors i/o
errors for the md side. The initial symptoms (or causes?) were several
'mpt2sas1: log_info(0x31120320): originator(PL), code(0x12),
sub_code(0x0320)' lines (see dmesg output timecode 17200). I only
noticed this a few day after the failures - so the system kept running
for a few days without bad things propagating to the user-side (samba
shares). After a reboot (the shutdown went clean, without any
complaints) I did not see this again just yet (~1 day running). Arrays
came up fine, with the two dropped disks out of date (and therefore
expelled). fsck says both filesystems are ok.

As to the cause of these errors I can only speculate. One idea was the
virtualization, but since you Chris are running on bare metal (i
assume), this seems unlikely. The disks themselves say they are fine
(via smart - no uncs or other errors logged). I don't have any expander
hardware in between the disks and the controllers. Both mainboard and
controller firmware are up-to-date, as well as esxi. I generally try to
stay upstream (atm the system is running fine again on a 3.8.6 kernel).
What's odd is that both "failed" (for the lack of a better term) disks
are hanging off the 7th position on the controllers and the their
respective partner disks are on the 8th position (cabeling wise). These
are two separate controllers with two separate cables and the disk pairs
being located in two different places in the case. The disks are two
hitachi 2tb and two seagate 3tb. Which leads me to believe this isn't a
hardware issue.


This is probably unrelated, but the only other issue I had lately was
about a month ago, when I got a filesystem corruption on one of these
arrays. The only log message I could find was:

Mar 24 18:57:07 [kernel] EXT4-fs error (device md3):
ext4_mb_generate_buddy:742: group 5648, 23442 clusters in bitmap, 23443
in gdMar 24 18:57:07 [kernel] EXT4-fs error (device md3):
ext4_mb_generate_buddy:742: group 5648, 23442 clusters in bitmap, 23443
in gd

An fsck run fixed these with minimal data loss. At the time the host
systems lsi hardware raid (on a 9240-8i) was running a consistency
check, which induced latencies for the guests. I disabled the scheduled
consistency checks since then and have not had another issue. (It could
also well have been some data flip on the disks themselves).

Otherwise the system is running without incidents for a while now.

---
Matthias

P.S. mount options in fstab: 'noatime,journal_async_commit,commit=15' (ext4)
P.P.S. I'm including the ext4 mailing list in this, since this could
well be something which touches some corner cases there

----------------------------------------------------------------------
dmesg output (interesting lines start at timecode 17200)
----------------------------------------------------------------------
[    1.959694] pci 0000:00:15.6: bridge window [io  0x1000-0x0fff] to
[bus 09] add_size 1000
[    1.959749] pci 0000:00:15.7: bridge window [io  0x1000-0x0fff] to
[bus 0a] add_size 1000
[    1.959959] pci 0000:00:16.3: bridge window [io  0x1000-0x0fff] to
[bus 0e] add_size 1000
[    1.960015] pci 0000:00:16.4: bridge window [io  0x1000-0x0fff] to
[bus 0f] add_size 1000
[    1.960072] pci 0000:00:16.5: bridge window [io  0x1000-0x0fff] to
[bus 10] add_size 1000
[    1.960127] pci 0000:00:16.6: bridge window [io  0x1000-0x0fff] to
[bus 11] add_size 1000
[    1.960186] pci 0000:00:16.7: bridge window [io  0x1000-0x0fff] to
[bus 12] add_size 1000
[    1.960397] pci 0000:00:17.3: bridge window [io  0x1000-0x0fff] to
[bus 16] add_size 1000
[    1.960452] pci 0000:00:17.4: bridge window [io  0x1000-0x0fff] to
[bus 17] add_size 1000
[    1.960507] pci 0000:00:17.5: bridge window [io  0x1000-0x0fff] to
[bus 18] add_size 1000
[    1.960562] pci 0000:00:17.6: bridge window [io  0x1000-0x0fff] to
[bus 19] add_size 1000
[    1.960617] pci 0000:00:17.7: bridge window [io  0x1000-0x0fff] to
[bus 1a] add_size 1000
[    1.960776] pci 0000:00:18.2: bridge window [io  0x1000-0x0fff] to
[bus 1d] add_size 1000
[    1.960831] pci 0000:00:18.3: bridge window [io  0x1000-0x0fff] to
[bus 1e] add_size 1000
[    1.960886] pci 0000:00:18.4: bridge window [io  0x1000-0x0fff] to
[bus 1f] add_size 1000
[    1.960941] pci 0000:00:18.5: bridge window [io  0x1000-0x0fff] to
[bus 20] add_size 1000
[    1.960996] pci 0000:00:18.6: bridge window [io  0x1000-0x0fff] to
[bus 21] add_size 1000
[    1.961051] pci 0000:00:18.7: bridge window [io  0x1000-0x0fff] to
[bus 22] add_size 1000
[    1.961069] pci 0000:00:15.3: res[13]=[io  0x1000-0x0fff]
get_res_add_size add_size 1000
[    1.961071] pci 0000:00:15.4: res[13]=[io  0x1000-0x0fff]
get_res_add_size add_size 1000
[    1.961073] pci 0000:00:15.5: res[13]=[io  0x1000-0x0fff]
get_res_add_size add_size 1000
[    1.961075] pci 0000:00:15.6: res[13]=[io  0x1000-0x0fff]
get_res_add_size add_size 1000
[    1.961076] pci 0000:00:15.7: res[13]=[io  0x1000-0x0fff]
get_res_add_size add_size 1000
[    1.961078] pci 0000:00:16.3: res[13]=[io  0x1000-0x0fff]
get_res_add_size add_size 1000
[    1.961080] pci 0000:00:16.4: res[13]=[io  0x1000-0x0fff]
get_res_add_size add_size 1000
[    1.961082] pci 0000:00:16.5: res[13]=[io  0x1000-0x0fff]
get_res_add_size add_size 1000
[    1.961084] pci 0000:00:16.6: res[13]=[io  0x1000-0x0fff]
get_res_add_size add_size 1000
[    1.961086] pci 0000:00:16.7: res[13]=[io  0x1000-0x0fff]
get_res_add_size add_size 1000
[    1.961088] pci 0000:00:17.3: res[13]=[io  0x1000-0x0fff]
get_res_add_size add_size 1000
[    1.961089] pci 0000:00:17.4: res[13]=[io  0x1000-0x0fff]
get_res_add_size add_size 1000
[    1.961091] pci 0000:00:17.5: res[13]=[io  0x1000-0x0fff]
get_res_add_size add_size 1000
[    1.961093] pci 0000:00:17.6: res[13]=[io  0x1000-0x0fff]
get_res_add_size add_size 1000
[    1.961095] pci 0000:00:17.7: res[13]=[io  0x1000-0x0fff]
get_res_add_size add_size 1000
[    1.961097] pci 0000:00:18.2: res[13]=[io  0x1000-0x0fff]
get_res_add_size add_size 1000
[    1.961099] pci 0000:00:18.3: res[13]=[io  0x1000-0x0fff]
get_res_add_size add_size 1000
[    1.961100] pci 0000:00:18.4: res[13]=[io  0x1000-0x0fff]
get_res_add_size add_size 1000
[    1.961102] pci 0000:00:18.5: res[13]=[io  0x1000-0x0fff]
get_res_add_size add_size 1000
[    1.961107] pci 0000:00:18.6: res[13]=[io  0x1000-0x0fff]
get_res_add_size add_size 1000
[    1.961109] pci 0000:00:18.7: res[13]=[io  0x1000-0x0fff]
get_res_add_size add_size 1000
[    1.961115] pci 0000:00:0f.0: BAR 6: assigned [mem
0x80000000-0x80007fff pref]
[    1.961271] pci 0000:00:15.3: BAR 13: can't assign io (size 0x1000)
[    1.961397] pci 0000:00:15.4: BAR 13: can't assign io (size 0x1000)
[    1.961522] pci 0000:00:15.5: BAR 13: can't assign io (size 0x1000)
[    1.961647] pci 0000:00:15.6: BAR 13: can't assign io (size 0x1000)
[    1.961770] pci 0000:00:15.7: BAR 13: can't assign io (size 0x1000)
[    1.961893] pci 0000:00:16.3: BAR 13: can't assign io (size 0x1000)
[    1.962016] pci 0000:00:16.4: BAR 13: can't assign io (size 0x1000)
[    1.962139] pci 0000:00:16.5: BAR 13: can't assign io (size 0x1000)
[    1.962261] pci 0000:00:16.6: BAR 13: can't assign io (size 0x1000)
[    1.962385] pci 0000:00:16.7: BAR 13: can't assign io (size 0x1000)
[    1.962508] pci 0000:00:17.3: BAR 13: can't assign io (size 0x1000)
[    1.963406] pci 0000:00:17.4: BAR 13: can't assign io (size 0x1000)
[    1.963530] pci 0000:00:17.5: BAR 13: can't assign io (size 0x1000)
[    1.963653] pci 0000:00:17.6: BAR 13: can't assign io (size 0x1000)
[    1.963818] pci 0000:00:17.7: BAR 13: can't assign io (size 0x1000)
[    1.963944] pci 0000:00:18.2: BAR 13: can't assign io (size 0x1000)
[    1.964067] pci 0000:00:18.3: BAR 13: can't assign io (size 0x1000)
[    1.964189] pci 0000:00:18.4: BAR 13: can't assign io (size 0x1000)
[    1.964312] pci 0000:00:18.5: BAR 13: can't assign io (size 0x1000)
[    1.964440] pci 0000:00:18.6: BAR 13: can't assign io (size 0x1000)
[    1.964568] pci 0000:00:18.7: BAR 13: can't assign io (size 0x1000)
[    1.964694] pci 0000:00:01.0: PCI bridge to [bus 01]
[    1.964898] pci 0000:00:11.0: PCI bridge to [bus 02]
[    1.965015] pci 0000:00:11.0:   bridge window [io  0x2000-0x3fff]
[    1.965163] pci 0000:00:11.0:   bridge window [mem 0xd1900000-0xd23fffff]
[    1.965312] pci 0000:00:11.0:   bridge window [mem
0xdc400000-0xdc9fffff 64bit pref]
[    1.965493] pci 0000:03:00.0: BAR 6: assigned [mem
0xd4400000-0xd440ffff pref]
[    1.965631] pci 0000:00:15.0: PCI bridge to [bus 03]
[    1.965747] pci 0000:00:15.0:   bridge window [io  0x4000-0x4fff]
[    1.965895] pci 0000:00:15.0:   bridge window [mem 0xd2400000-0xd24fffff]
[    1.966043] pci 0000:00:15.0:   bridge window [mem
0xd4400000-0xd44fffff 64bit pref]
[    1.966256] pci 0000:00:15.1: PCI bridge to [bus 04]
[    1.966373] pci 0000:00:15.1:   bridge window [io  0x8000-0x8fff]
[    1.966524] pci 0000:00:15.1:   bridge window [mem 0xd2800000-0xd28fffff]
[    1.966672] pci 0000:00:15.1:   bridge window [mem
0xd4800000-0xd48fffff 64bit pref]
[    1.966859] pci 0000:00:15.2: PCI bridge to [bus 05]
[    1.966976] pci 0000:00:15.2:   bridge window [io  0xc000-0xcfff]
[    1.967124] pci 0000:00:15.2:   bridge window [mem 0xd2c00000-0xd2cfffff]
[    1.967273] pci 0000:00:15.2:   bridge window [mem
0xdcb00000-0xdcbfffff 64bit pref]
[    1.967460] pci 0000:00:15.3: PCI bridge to [bus 06]
[    1.967595] pci 0000:00:15.3:   bridge window [mem 0xd3000000-0xd30fffff]
[    1.967743] pci 0000:00:15.3:   bridge window [mem
0xdcd00000-0xdcdfffff 64bit pref]
[    1.967931] pci 0000:00:15.4: PCI bridge to [bus 07]
[    1.968065] pci 0000:00:15.4:   bridge window [mem 0xd3400000-0xd34fffff]
[    1.968221] pci 0000:00:15.4:   bridge window [mem
0xdcf00000-0xdcffffff 64bit pref]
[    1.968409] pci 0000:00:15.5: PCI bridge to [bus 08]
[    1.968544] pci 0000:00:15.5:   bridge window [mem 0xd3800000-0xd38fffff]
[    1.968692] pci 0000:00:15.5:   bridge window [mem
0xdd100000-0xdd1fffff 64bit pref]
[    1.968880] pci 0000:00:15.6: PCI bridge to [bus 09]
[    1.969013] pci 0000:00:15.6:   bridge window [mem 0xd3c00000-0xd3cfffff]
[    1.969161] pci 0000:00:15.6:   bridge window [mem
0xdd300000-0xdd3fffff 64bit pref]
[    1.969349] pci 0000:00:15.7: PCI bridge to [bus 0a]
[    1.969485] pci 0000:00:15.7:   bridge window [mem 0xd4000000-0xd40fffff]
[    1.969634] pci 0000:00:15.7:   bridge window [mem
0xdd500000-0xdd5fffff 64bit pref]
[    1.969823] pci 0000:00:16.0: PCI bridge to [bus 0b]
[    1.969940] pci 0000:00:16.0:   bridge window [io  0x5000-0x5fff]
[    1.970088] pci 0000:00:16.0:   bridge window [mem 0xd2500000-0xd25fffff]
[    1.970238] pci 0000:00:16.0:   bridge window [mem
0xd4500000-0xd45fffff 64bit pref]
[    1.970426] pci 0000:00:16.1: PCI bridge to [bus 0c]
[    1.970542] pci 0000:00:16.1:   bridge window [io  0x9000-0x9fff]
[    1.970690] pci 0000:00:16.1:   bridge window [mem 0xd2900000-0xd29fffff]
[    1.970838] pci 0000:00:16.1:   bridge window [mem
0xd4900000-0xd49fffff 64bit pref]
[    1.971026] pci 0000:00:16.2: PCI bridge to [bus 0d]
[    1.971142] pci 0000:00:16.2:   bridge window [io  0xd000-0xdfff]
[    1.971293] pci 0000:00:16.2:   bridge window [mem 0xd2d00000-0xd2dfffff]
[    1.971441] pci 0000:00:16.2:   bridge window [mem
0xd4b00000-0xd4bfffff 64bit pref]
[    1.971629] pci 0000:00:16.3: PCI bridge to [bus 0e]
[    1.971763] pci 0000:00:16.3:   bridge window [mem 0xd3100000-0xd31fffff]
[    1.971911] pci 0000:00:16.3:   bridge window [mem
0xd4d00000-0xd4dfffff 64bit pref]
[    1.972099] pci 0000:00:16.4: PCI bridge to [bus 0f]
[    1.972237] pci 0000:00:16.4:   bridge window [mem 0xd3500000-0xd35fffff]
[    1.972385] pci 0000:00:16.4:   bridge window [mem
0xd4f00000-0xd4ffffff 64bit pref]
[    1.972572] pci 0000:00:16.5: PCI bridge to [bus 10]
[    1.972706] pci 0000:00:16.5:   bridge window [mem 0xd3900000-0xd39fffff]
[    1.972854] pci 0000:00:16.5:   bridge window [mem
0xd5100000-0xd51fffff 64bit pref]
[    1.973041] pci 0000:00:16.6: PCI bridge to [bus 11]
[    1.973175] pci 0000:00:16.6:   bridge window [mem 0xd3d00000-0xd3dfffff]
[    1.973325] pci 0000:00:16.6:   bridge window [mem
0xd5300000-0xd53fffff 64bit pref]
[    1.973513] pci 0000:00:16.7: PCI bridge to [bus 12]
[    1.973648] pci 0000:00:16.7:   bridge window [mem 0xd4100000-0xd41fffff]
[    1.973822] pci 0000:00:16.7:   bridge window [mem
0xd5500000-0xd55fffff 64bit pref]
[    1.974012] pci 0000:13:00.0: BAR 6: assigned [mem
0xd4600000-0xd460ffff pref]
[    1.974147] pci 0000:00:17.0: PCI bridge to [bus 13]
[    1.974265] pci 0000:00:17.0:   bridge window [io  0x6000-0x6fff]
[    1.974413] pci 0000:00:17.0:   bridge window [mem 0xd2600000-0xd26fffff]
[    1.974561] pci 0000:00:17.0:   bridge window [mem
0xd4600000-0xd46fffff 64bit pref]
[    1.974748] pci 0000:00:17.1: PCI bridge to [bus 14]
[    1.974865] pci 0000:00:17.1:   bridge window [io  0xa000-0xafff]
[    1.975013] pci 0000:00:17.1:   bridge window [mem 0xd2a00000-0xd2afffff]
[    1.975161] pci 0000:00:17.1:   bridge window [mem
0xdca00000-0xdcafffff 64bit pref]
[    1.975348] pci 0000:00:17.2: PCI bridge to [bus 15]
[    1.975465] pci 0000:00:17.2:   bridge window [io  0xe000-0xefff]
[    1.975613] pci 0000:00:17.2:   bridge window [mem 0xd2e00000-0xd2efffff]
[    1.975761] pci 0000:00:17.2:   bridge window [mem
0xdcc00000-0xdccfffff 64bit pref]
[    1.975948] pci 0000:00:17.3: PCI bridge to [bus 16]
[    1.976082] pci 0000:00:17.3:   bridge window [mem 0xd3200000-0xd32fffff]
[    1.976234] pci 0000:00:17.3:   bridge window [mem
0xdce00000-0xdcefffff 64bit pref]
[    1.976421] pci 0000:00:17.4: PCI bridge to [bus 17]
[    1.976555] pci 0000:00:17.4:   bridge window [mem 0xd3600000-0xd36fffff]
[    1.976704] pci 0000:00:17.4:   bridge window [mem
0xdd000000-0xdd0fffff 64bit pref]
[    1.976892] pci 0000:00:17.5: PCI bridge to [bus 18]
[    1.977830] pci 0000:00:17.5:   bridge window [mem 0xd3a00000-0xd3afffff]
[    1.977979] pci 0000:00:17.5:   bridge window [mem
0xdd200000-0xdd2fffff 64bit pref]
[    1.978176] pci 0000:00:17.6: PCI bridge to [bus 19]
[    1.978314] pci 0000:00:17.6:   bridge window [mem 0xd3e00000-0xd3efffff]
[    1.978464] pci 0000:00:17.6:   bridge window [mem
0xdd400000-0xdd4fffff 64bit pref]
[    1.978654] pci 0000:00:17.7: PCI bridge to [bus 1a]
[    1.978789] pci 0000:00:17.7:   bridge window [mem 0xd4200000-0xd42fffff]
[    1.978938] pci 0000:00:17.7:   bridge window [mem
0xdd600000-0xdd6fffff 64bit pref]
[    1.979126] pci 0000:00:18.0: PCI bridge to [bus 1b]
[    1.979244] pci 0000:00:18.0:   bridge window [io  0x7000-0x7fff]
[    1.979392] pci 0000:00:18.0:   bridge window [mem 0xd2700000-0xd27fffff]
[    1.979540] pci 0000:00:18.0:   bridge window [mem
0xd4700000-0xd47fffff 64bit pref]
[    1.979727] pci 0000:00:18.1: PCI bridge to [bus 1c]
[    1.979844] pci 0000:00:18.1:   bridge window [io  0xb000-0xbfff]
[    1.979992] pci 0000:00:18.1:   bridge window [mem 0xd2b00000-0xd2bfffff]
[    1.980140] pci 0000:00:18.1:   bridge window [mem
0xd4a00000-0xd4afffff 64bit pref]
[    1.980328] pci 0000:00:18.2: PCI bridge to [bus 1d]
[    1.980462] pci 0000:00:18.2:   bridge window [mem 0xd2f00000-0xd2ffffff]
[    1.980610] pci 0000:00:18.2:   bridge window [mem
0xd4c00000-0xd4cfffff 64bit pref]
[    1.980797] pci 0000:00:18.3: PCI bridge to [bus 1e]
[    1.980931] pci 0000:00:18.3:   bridge window [mem 0xd3300000-0xd33fffff]
[    1.981079] pci 0000:00:18.3:   bridge window [mem
0xd4e00000-0xd4efffff 64bit pref]
[    1.981270] pci 0000:00:18.4: PCI bridge to [bus 1f]
[    1.981404] pci 0000:00:18.4:   bridge window [mem 0xd3700000-0xd37fffff]
[    1.981552] pci 0000:00:18.4:   bridge window [mem
0xd5000000-0xd50fffff 64bit pref]
[    1.981739] pci 0000:00:18.5: PCI bridge to [bus 20]
[    1.981873] pci 0000:00:18.5:   bridge window [mem 0xd3b00000-0xd3bfffff]
[    1.982023] pci 0000:00:18.5:   bridge window [mem
0xd5200000-0xd52fffff 64bit pref]
[    1.983380] pci 0000:00:18.6: PCI bridge to [bus 21]
[    1.983516] pci 0000:00:18.6:   bridge window [mem 0xd3f00000-0xd3ffffff]
[    1.983667] pci 0000:00:18.6:   bridge window [mem
0xd5400000-0xd54fffff 64bit pref]
[    1.983879] pci 0000:00:18.7: PCI bridge to [bus 22]
[    1.984015] pci 0000:00:18.7:   bridge window [mem 0xd4300000-0xd43fffff]
[    1.984166] pci 0000:00:18.7:   bridge window [mem
0xd5600000-0xd56fffff 64bit pref]
[    1.984390] pci 0000:00:01.0: setting latency timer to 64
[    1.985265] pci_bus 0000:00: resource 4 [mem 0x000a0000-0x000bffff]
[    1.985266] pci_bus 0000:00: resource 5 [mem 0x000cc000-0x000cffff]
[    1.985268] pci_bus 0000:00: resource 6 [mem 0x000d0000-0x000d3fff]
[    1.985269] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.985271] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.985273] pci_bus 0000:00: resource 9 [mem 0x80000000-0xfebfffff]
[    1.985277] pci_bus 0000:00: resource 10 [io  0x0000-0x0cf7]
[    1.985279] pci_bus 0000:00: resource 11 [io  0x0d00-0xfeff]
[    1.985281] pci_bus 0000:02: resource 0 [io  0x2000-0x3fff]
[    1.985282] pci_bus 0000:02: resource 1 [mem 0xd1900000-0xd23fffff]
[    1.985284] pci_bus 0000:02: resource 2 [mem 0xdc400000-0xdc9fffff
64bit pref]
[    1.985286] pci_bus 0000:02: resource 4 [mem 0x000a0000-0x000bffff]
[    1.985287] pci_bus 0000:02: resource 5 [mem 0x000cc000-0x000cffff]
[    1.985289] pci_bus 0000:02: resource 6 [mem 0x000d0000-0x000d3fff]
[    1.985290] pci_bus 0000:02: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.985292] pci_bus 0000:02: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.985293] pci_bus 0000:02: resource 9 [mem 0x80000000-0xfebfffff]
[    1.985295] pci_bus 0000:02: resource 10 [io  0x0000-0x0cf7]
[    1.985297] pci_bus 0000:02: resource 11 [io  0x0d00-0xfeff]
[    1.985298] pci_bus 0000:03: resource 0 [io  0x4000-0x4fff]
[    1.985300] pci_bus 0000:03: resource 1 [mem 0xd2400000-0xd24fffff]
[    1.985302] pci_bus 0000:03: resource 2 [mem 0xd4400000-0xd44fffff
64bit pref]
[    1.985304] pci_bus 0000:04: resource 0 [io  0x8000-0x8fff]
[    1.985305] pci_bus 0000:04: resource 1 [mem 0xd2800000-0xd28fffff]
[    1.985307] pci_bus 0000:04: resource 2 [mem 0xd4800000-0xd48fffff
64bit pref]
[    1.985308] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    1.985310] pci_bus 0000:05: resource 1 [mem 0xd2c00000-0xd2cfffff]
[    1.985312] pci_bus 0000:05: resource 2 [mem 0xdcb00000-0xdcbfffff
64bit pref]
[    1.985313] pci_bus 0000:06: resource 1 [mem 0xd3000000-0xd30fffff]
[    1.985315] pci_bus 0000:06: resource 2 [mem 0xdcd00000-0xdcdfffff
64bit pref]
[    1.985317] pci_bus 0000:07: resource 1 [mem 0xd3400000-0xd34fffff]
[    1.985319] pci_bus 0000:07: resource 2 [mem 0xdcf00000-0xdcffffff
64bit pref]
[    1.985320] pci_bus 0000:08: resource 1 [mem 0xd3800000-0xd38fffff]
[    1.985322] pci_bus 0000:08: resource 2 [mem 0xdd100000-0xdd1fffff
64bit pref]
[    1.985324] pci_bus 0000:09: resource 1 [mem 0xd3c00000-0xd3cfffff]
[    1.985326] pci_bus 0000:09: resource 2 [mem 0xdd300000-0xdd3fffff
64bit pref]
[    1.985327] pci_bus 0000:0a: resource 1 [mem 0xd4000000-0xd40fffff]
[    1.985329] pci_bus 0000:0a: resource 2 [mem 0xdd500000-0xdd5fffff
64bit pref]
[    1.985331] pci_bus 0000:0b: resource 0 [io  0x5000-0x5fff]
[    1.985332] pci_bus 0000:0b: resource 1 [mem 0xd2500000-0xd25fffff]
[    1.985334] pci_bus 0000:0b: resource 2 [mem 0xd4500000-0xd45fffff
64bit pref]
[    1.985336] pci_bus 0000:0c: resource 0 [io  0x9000-0x9fff]
[    1.985339] pci_bus 0000:0c: resource 1 [mem 0xd2900000-0xd29fffff]
[    1.985341] pci_bus 0000:0c: resource 2 [mem 0xd4900000-0xd49fffff
64bit pref]
[    1.985343] pci_bus 0000:0d: resource 0 [io  0xd000-0xdfff]
[    1.985344] pci_bus 0000:0d: resource 1 [mem 0xd2d00000-0xd2dfffff]
[    1.985346] pci_bus 0000:0d: resource 2 [mem 0xd4b00000-0xd4bfffff
64bit pref]
[    1.985348] pci_bus 0000:0e: resource 1 [mem 0xd3100000-0xd31fffff]
[    1.985349] pci_bus 0000:0e: resource 2 [mem 0xd4d00000-0xd4dfffff
64bit pref]
[    1.985351] pci_bus 0000:0f: resource 1 [mem 0xd3500000-0xd35fffff]
[    1.985353] pci_bus 0000:0f: resource 2 [mem 0xd4f00000-0xd4ffffff
64bit pref]
[    1.985355] pci_bus 0000:10: resource 1 [mem 0xd3900000-0xd39fffff]
[    1.985356] pci_bus 0000:10: resource 2 [mem 0xd5100000-0xd51fffff
64bit pref]
[    1.985358] pci_bus 0000:11: resource 1 [mem 0xd3d00000-0xd3dfffff]
[    1.985360] pci_bus 0000:11: resource 2 [mem 0xd5300000-0xd53fffff
64bit pref]
[    1.985362] pci_bus 0000:12: resource 1 [mem 0xd4100000-0xd41fffff]
[    1.985363] pci_bus 0000:12: resource 2 [mem 0xd5500000-0xd55fffff
64bit pref]
[    1.985365] pci_bus 0000:13: resource 0 [io  0x6000-0x6fff]
[    1.985367] pci_bus 0000:13: resource 1 [mem 0xd2600000-0xd26fffff]
[    1.985369] pci_bus 0000:13: resource 2 [mem 0xd4600000-0xd46fffff
64bit pref]
[    1.985370] pci_bus 0000:14: resource 0 [io  0xa000-0xafff]
[    1.985372] pci_bus 0000:14: resource 1 [mem 0xd2a00000-0xd2afffff]
[    1.985374] pci_bus 0000:14: resource 2 [mem 0xdca00000-0xdcafffff
64bit pref]
[    1.985375] pci_bus 0000:15: resource 0 [io  0xe000-0xefff]
[    1.985377] pci_bus 0000:15: resource 1 [mem 0xd2e00000-0xd2efffff]
[    1.985379] pci_bus 0000:15: resource 2 [mem 0xdcc00000-0xdccfffff
64bit pref]
[    1.985380] pci_bus 0000:16: resource 1 [mem 0xd3200000-0xd32fffff]
[    1.985382] pci_bus 0000:16: resource 2 [mem 0xdce00000-0xdcefffff
64bit pref]
[    1.985384] pci_bus 0000:17: resource 1 [mem 0xd3600000-0xd36fffff]
[    1.985386] pci_bus 0000:17: resource 2 [mem 0xdd000000-0xdd0fffff
64bit pref]
[    1.985387] pci_bus 0000:18: resource 1 [mem 0xd3a00000-0xd3afffff]
[    1.985389] pci_bus 0000:18: resource 2 [mem 0xdd200000-0xdd2fffff
64bit pref]
[    1.985391] pci_bus 0000:19: resource 1 [mem 0xd3e00000-0xd3efffff]
[    1.985393] pci_bus 0000:19: resource 2 [mem 0xdd400000-0xdd4fffff
64bit pref]
[    1.985394] pci_bus 0000:1a: resource 1 [mem 0xd4200000-0xd42fffff]
[    1.985396] pci_bus 0000:1a: resource 2 [mem 0xdd600000-0xdd6fffff
64bit pref]
[    1.985397] pci_bus 0000:1b: resource 0 [io  0x7000-0x7fff]
[    1.985401] pci_bus 0000:1b: resource 1 [mem 0xd2700000-0xd27fffff]
[    1.985403] pci_bus 0000:1b: resource 2 [mem 0xd4700000-0xd47fffff
64bit pref]
[    1.985405] pci_bus 0000:1c: resource 0 [io  0xb000-0xbfff]
[    1.985406] pci_bus 0000:1c: resource 1 [mem 0xd2b00000-0xd2bfffff]
[    1.985408] pci_bus 0000:1c: resource 2 [mem 0xd4a00000-0xd4afffff
64bit pref]
[    1.985410] pci_bus 0000:1d: resource 1 [mem 0xd2f00000-0xd2ffffff]
[    1.985411] pci_bus 0000:1d: resource 2 [mem 0xd4c00000-0xd4cfffff
64bit pref]
[    1.985413] pci_bus 0000:1e: resource 1 [mem 0xd3300000-0xd33fffff]
[    1.985415] pci_bus 0000:1e: resource 2 [mem 0xd4e00000-0xd4efffff
64bit pref]
[    1.985417] pci_bus 0000:1f: resource 1 [mem 0xd3700000-0xd37fffff]
[    1.985418] pci_bus 0000:1f: resource 2 [mem 0xd5000000-0xd50fffff
64bit pref]
[    1.985420] pci_bus 0000:20: resource 1 [mem 0xd3b00000-0xd3bfffff]
[    1.985422] pci_bus 0000:20: resource 2 [mem 0xd5200000-0xd52fffff
64bit pref]
[    1.985424] pci_bus 0000:21: resource 1 [mem 0xd3f00000-0xd3ffffff]
[    1.985425] pci_bus 0000:21: resource 2 [mem 0xd5400000-0xd54fffff
64bit pref]
[    1.985427] pci_bus 0000:22: resource 1 [mem 0xd4300000-0xd43fffff]
[    1.985429] pci_bus 0000:22: resource 2 [mem 0xd5600000-0xd56fffff
64bit pref]
[    1.985463] NET: Registered protocol family 2
[    1.985681] TCP established hash table entries: 16384 (order: 6,
262144 bytes)
[    1.985872] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    1.986050] TCP: Hash tables configured (established 16384 bind 16384)
[    1.986210] TCP: reno registered
[    1.986295] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    1.986423] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    1.986595] NET: Registered protocol family 1
[    1.986704] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.986894] pci 0000:00:0f.0: Boot video device
[    1.987215] PCI: CLS mismatch (32 != 64), using 64 bytes
[    1.996224] Simple Boot Flag at 0x36 set to 0x80
[    1.996341] Switching to clocksource tsc
[    1.997677] microcode: CPU0 sig=0x1067a, pf=0x1, revision=0xa0b
[    1.997813] microcode: CPU1 sig=0x1067a, pf=0x1, revision=0xa0b
[    1.998150] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.999156] AVX or AES-NI instructions are not detected.
[    1.999271] AVX instructions are not detected.
[    1.999370] AVX instructions are not detected.
[    2.000449] AVX instructions are not detected.
[    2.001742] AVX instructions are not detected.
[    2.001846] sha1_ssse3: Using SSSE3 optimized SHA-1 implementation
[    2.003370] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.014041] NTFS driver 2.1.30 [Flags: R/W].
[    2.015642] Btrfs loaded
[    2.015741] msgmni has been set to 3996
[    2.021154] NET: Registered protocol family 38
[    2.021270] async_tx: api initialized (async)
[    2.021639] Block layer SCSI generic (bsg) driver version 0.4 loaded
(major 254)
[    2.021878] io scheduler noop registered
[    2.022006] io scheduler deadline registered (default)
[    2.022123] io scheduler cfq registered
[    2.022584] crc32: CRC_LE_BITS = 64, CRC_BE BITS = 64
[    2.022690] crc32: self tests passed, processed 225944 bytes in
177681 nsec
[    2.023000] crc32c: CRC_LE_BITS = 64
[    2.023090] crc32c: self tests passed, processed 225944 bytes in
88589 nsec
[    2.023993] pcieport 0000:00:15.0: irq 40 for MSI/MSI-X
[    2.025008] pcieport 0000:00:15.1: irq 41 for MSI/MSI-X
[    2.026034] pcieport 0000:00:15.2: irq 42 for MSI/MSI-X
[    2.027030] pcieport 0000:00:15.3: irq 43 for MSI/MSI-X
[    2.028045] pcieport 0000:00:15.4: irq 44 for MSI/MSI-X
[    2.029075] pcieport 0000:00:15.5: irq 45 for MSI/MSI-X
[    2.030079] pcieport 0000:00:15.6: irq 46 for MSI/MSI-X
[    2.031109] pcieport 0000:00:15.7: irq 47 for MSI/MSI-X
[    2.032114] pcieport 0000:00:16.0: irq 48 for MSI/MSI-X
[    2.033117] pcieport 0000:00:16.1: irq 49 for MSI/MSI-X
[    2.034210] pcieport 0000:00:16.2: irq 50 for MSI/MSI-X
[    2.035201] pcieport 0000:00:16.3: irq 51 for MSI/MSI-X
[    2.036259] pcieport 0000:00:16.4: irq 52 for MSI/MSI-X
[    2.037220] pcieport 0000:00:16.5: irq 53 for MSI/MSI-X
[    2.038184] pcieport 0000:00:16.6: irq 54 for MSI/MSI-X
[    2.039152] pcieport 0000:00:16.7: irq 55 for MSI/MSI-X
[    2.040114] pcieport 0000:00:17.0: irq 56 for MSI/MSI-X
[    2.041102] pcieport 0000:00:17.1: irq 57 for MSI/MSI-X
[    2.042079] pcieport 0000:00:17.2: irq 58 for MSI/MSI-X
[    2.043046] pcieport 0000:00:17.3: irq 59 for MSI/MSI-X
[    2.044055] pcieport 0000:00:17.4: irq 60 for MSI/MSI-X
[    2.045018] pcieport 0000:00:17.5: irq 61 for MSI/MSI-X
[    2.045969] pcieport 0000:00:17.6: irq 62 for MSI/MSI-X
[    2.046930] pcieport 0000:00:17.7: irq 63 for MSI/MSI-X
[    2.047898] pcieport 0000:00:18.0: irq 64 for MSI/MSI-X
[    2.048864] pcieport 0000:00:18.1: irq 65 for MSI/MSI-X
[    2.049813] pcieport 0000:00:18.2: irq 66 for MSI/MSI-X
[    2.050769] pcieport 0000:00:18.3: irq 67 for MSI/MSI-X
[    2.051723] pcieport 0000:00:18.4: irq 68 for MSI/MSI-X
[    2.052676] pcieport 0000:00:18.5: irq 69 for MSI/MSI-X
[    2.053702] pcieport 0000:00:18.6: irq 70 for MSI/MSI-X
[    2.054734] pcieport 0000:00:18.7: irq 71 for MSI/MSI-X
[    2.055489] pcieport 0000:00:15.0: Signaling PME through PCIe PME
interrupt
[    2.055637] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    2.055783] pcie_pme 0000:00:15.0:pcie01: service driver pcie_pme loaded
[    2.055885] pcieport 0000:00:15.1: Signaling PME through PCIe PME
interrupt
[    2.056022] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
[    2.056168] pcie_pme 0000:00:15.1:pcie01: service driver pcie_pme loaded
[    2.056272] pcieport 0000:00:15.2: Signaling PME through PCIe PME
interrupt
[    2.056426] pcie_pme 0000:00:15.2:pcie01: service driver pcie_pme loaded
[    2.056534] pcieport 0000:00:15.3: Signaling PME through PCIe PME
interrupt
[    2.056695] pcie_pme 0000:00:15.3:pcie01: service driver pcie_pme loaded
[    2.056803] pcieport 0000:00:15.4: Signaling PME through PCIe PME
interrupt
[    2.056960] pcie_pme 0000:00:15.4:pcie01: service driver pcie_pme loaded
[    2.057068] pcieport 0000:00:15.5: Signaling PME through PCIe PME
interrupt
[    2.057222] pcie_pme 0000:00:15.5:pcie01: service driver pcie_pme loaded
[    2.057324] pcieport 0000:00:15.6: Signaling PME through PCIe PME
interrupt
[    2.057479] pcie_pme 0000:00:15.6:pcie01: service driver pcie_pme loaded
[    2.057584] pcieport 0000:00:15.7: Signaling PME through PCIe PME
interrupt
[    2.057745] pcie_pme 0000:00:15.7:pcie01: service driver pcie_pme loaded
[    2.057850] pcieport 0000:00:16.0: Signaling PME through PCIe PME
interrupt
[    2.057998] pci 0000:0b:00.0: Signaling PME through PCIe PME interrupt
[    2.058143] pcie_pme 0000:00:16.0:pcie01: service driver pcie_pme loaded
[    2.058244] pcieport 0000:00:16.1: Signaling PME through PCIe PME
interrupt
[    2.058378] pci 0000:0c:00.0: Signaling PME through PCIe PME interrupt
[    2.058521] pcie_pme 0000:00:16.1:pcie01: service driver pcie_pme loaded
[    2.058622] pcieport 0000:00:16.2: Signaling PME through PCIe PME
interrupt
[    2.058774] pcie_pme 0000:00:16.2:pcie01: service driver pcie_pme loaded
[    2.058876] pcieport 0000:00:16.3: Signaling PME through PCIe PME
interrupt
[    2.059027] pcie_pme 0000:00:16.3:pcie01: service driver pcie_pme loaded
[    2.059128] pcieport 0000:00:16.4: Signaling PME through PCIe PME
interrupt
[    2.059279] pcie_pme 0000:00:16.4:pcie01: service driver pcie_pme loaded
[    2.059381] pcieport 0000:00:16.5: Signaling PME through PCIe PME
interrupt
[    2.059532] pcie_pme 0000:00:16.5:pcie01: service driver pcie_pme loaded
[    2.059633] pcieport 0000:00:16.6: Signaling PME through PCIe PME
interrupt
[    2.059785] pcie_pme 0000:00:16.6:pcie01: service driver pcie_pme loaded
[    2.059885] pcieport 0000:00:16.7: Signaling PME through PCIe PME
interrupt
[    2.060037] pcie_pme 0000:00:16.7:pcie01: service driver pcie_pme loaded
[    2.060138] pcieport 0000:00:17.0: Signaling PME through PCIe PME
interrupt
[    2.060270] pci 0000:13:00.0: Signaling PME through PCIe PME interrupt
[    2.060418] pcie_pme 0000:00:17.0:pcie01: service driver pcie_pme loaded
[    2.060523] pcieport 0000:00:17.1: Signaling PME through PCIe PME
interrupt
[    2.060675] pcie_pme 0000:00:17.1:pcie01: service driver pcie_pme loaded
[    2.060775] pcieport 0000:00:17.2: Signaling PME through PCIe PME
interrupt
[    2.060927] pcie_pme 0000:00:17.2:pcie01: service driver pcie_pme loaded
[    2.061032] pcieport 0000:00:17.3: Signaling PME through PCIe PME
interrupt
[    2.061183] pcie_pme 0000:00:17.3:pcie01: service driver pcie_pme loaded
[    2.061284] pcieport 0000:00:17.4: Signaling PME through PCIe PME
interrupt
[    2.061436] pcie_pme 0000:00:17.4:pcie01: service driver pcie_pme loaded
[    2.061539] pcieport 0000:00:17.5: Signaling PME through PCIe PME
interrupt
[    2.061691] pcie_pme 0000:00:17.5:pcie01: service driver pcie_pme loaded
[    2.061794] pcieport 0000:00:17.6: Signaling PME through PCIe PME
interrupt
[    2.061947] pcie_pme 0000:00:17.6:pcie01: service driver pcie_pme loaded
[    2.062049] pcieport 0000:00:17.7: Signaling PME through PCIe PME
interrupt
[    2.062202] pcie_pme 0000:00:17.7:pcie01: service driver pcie_pme loaded
[    2.062303] pcieport 0000:00:18.0: Signaling PME through PCIe PME
interrupt
[    2.062436] pci 0000:1b:00.0: Signaling PME through PCIe PME interrupt
[    2.062581] pcie_pme 0000:00:18.0:pcie01: service driver pcie_pme loaded
[    2.062692] pcieport 0000:00:18.1: Signaling PME through PCIe PME
interrupt
[    2.062844] pcie_pme 0000:00:18.1:pcie01: service driver pcie_pme loaded
[    2.062946] pcieport 0000:00:18.2: Signaling PME through PCIe PME
interrupt
[    2.063099] pcie_pme 0000:00:18.2:pcie01: service driver pcie_pme loaded
[    2.063203] pcieport 0000:00:18.3: Signaling PME through PCIe PME
interrupt
[    2.064046] pcie_pme 0000:00:18.3:pcie01: service driver pcie_pme loaded
[    2.064171] pcieport 0000:00:18.4: Signaling PME through PCIe PME
interrupt
[    2.064332] pcie_pme 0000:00:18.4:pcie01: service driver pcie_pme loaded
[    2.064435] pcieport 0000:00:18.5: Signaling PME through PCIe PME
interrupt
[    2.064587] pcie_pme 0000:00:18.5:pcie01: service driver pcie_pme loaded
[    2.064689] pcieport 0000:00:18.6: Signaling PME through PCIe PME
interrupt
[    2.064844] pcie_pme 0000:00:18.6:pcie01: service driver pcie_pme loaded
[    2.064947] pcieport 0000:00:18.7: Signaling PME through PCIe PME
interrupt
[    2.065100] pcie_pme 0000:00:18.7:pcie01: service driver pcie_pme loaded
[    2.126519] Serial: 8250/16550 driver, 2 ports, IRQ sharing enabled
[    2.151444] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.176510] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.177670] Real Time Clock Driver v1.12b
[    2.178294] Linux agpgart interface v0.103
[    2.178880] agpgart-intel 0000:00:00.0: Intel 440BX Chipset
[    2.179896] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x0
[    2.188034] intel_idle: does not run on family 6 model 23
[    2.188182] ACPI: Deprecated procfs I/F for AC is loaded, please
retry with CONFIG_ACPI_PROCFS_POWER cleared
[    2.188561] ACPI: AC Adapter [ACAD] (on-line)
[    2.188908] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    2.189050] ACPI: Power Button [PWRF]
[    2.273814] GHES: HEST is not enabled!
[    2.273920] ERST DBG: ERST support is disabled.
[    2.274020] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    2.277957] brd: module loaded
[    2.280323] loop: module loaded
[    2.281441] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03
EST 2006)
[    2.281712] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST
2006)
[    2.281936] megasas: 06.504.01.00-rc1 Mon. Oct. 1 17:00:00 PDT 2012
[    2.282163] mpt2sas version 14.100.00.00 loaded
[    2.282460] scsi0 : Fusion MPT SAS Host
[    2.283252] mpt2sas0: 32 BIT PCI BUS DMA ADDRESSING SUPPORTED, total
mem (2046052 kB)
[    2.283918] mpt2sas 0000:04:00.0: irq 72 for MSI/MSI-X
[    2.284165] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 72
[    2.284275] mpt2sas0: iomem(0x00000000d2800000),
mapped(0xffffc90000028000), size(16384)
[    2.284422] mpt2sas0: ioport(0x0000000000008000), size(256)
[    3.372570] mpt2sas0: Allocated physical memory: size(2267 kB)
[    3.372725] mpt2sas0: Current Controller Queue Depth(1483), Max
Controller Queue Depth(1720)
[    3.372874] mpt2sas0: Scatter Gather Elements per IO(128)
[    3.949390] mpt2sas0: LSISAS2008: FWVersion(15.00.00.00),
ChipRevision(0x02), BiosVersion(07.29.00.00)
[    3.949603] mpt2sas0: Protocol=(Initiator),
Capabilities=(Raid,TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set
Full,NCQ)
[    3.950240] mpt2sas0: sending port enable !!
[    5.295497] floppy0: no floppy controllers found
[    5.543713] mpt2sas0: host_add: handle(0x0001),
sas_addr(0x500605b0026e1700), phys(8)
[   10.671976] mpt2sas0: port enable: SUCCESS
[   10.684345] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD153WI
 0003 PQ: 0 ANSI: 6
[   10.684577] scsi 0:0:0:0: SATA: handle(0x0009),
sas_addr(0x4433221100000000), phy(0), device_name(0x50024e90035141f8)
[   10.684850] scsi 0:0:0:0: SATA:
enclosure_logical_id(0x500605b0026e1700), slot(3)
[   10.685133] scsi 0:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[   10.685337] scsi 0:0:0:0: qdepth(32), tagged(1), simple(0),
ordered(0), scsi_level(7), cmd_que(1)
[   10.699125] scsi 0:0:1:0: Direct-Access     ATA      SAMSUNG HD203WI
 0003 PQ: 0 ANSI: 6
[   10.699356] scsi 0:0:1:0: SATA: handle(0x000a),
sas_addr(0x4433221102000000), phy(2), device_name(0x50024e90030a1b80)
[   10.699630] scsi 0:0:1:0: SATA:
enclosure_logical_id(0x500605b0026e1700), slot(1)
[   10.699997] scsi 0:0:1:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[   10.700202] scsi 0:0:1:0: qdepth(32), tagged(1), simple(0),
ordered(0), scsi_level(7), cmd_que(1)
[   10.713645] scsi 0:0:2:0: Direct-Access     ATA      SAMSUNG HD203WI
 0003 PQ: 0 ANSI: 6
[   10.713877] scsi 0:0:2:0: SATA: handle(0x000b),
sas_addr(0x4433221103000000), phy(3), device_name(0x50024e9003d0c097)
[   10.714152] scsi 0:0:2:0: SATA:
enclosure_logical_id(0x500605b0026e1700), slot(0)
[   10.714448] scsi 0:0:2:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[   10.714654] scsi 0:0:2:0: qdepth(32), tagged(1), simple(0),
ordered(0), scsi_level(7), cmd_que(1)
[   10.718302] scsi 0:0:3:0: Direct-Access     ATA      ST31500541AS
 CC35 PQ: 0 ANSI: 6
[   10.718505] scsi 0:0:3:0: SATA: handle(0x000c),
sas_addr(0x4433221101000000), phy(1), device_name(0x5000c5001b6da52d)
[   10.718780] scsi 0:0:3:0: SATA:
enclosure_logical_id(0x500605b0026e1700), slot(2)
[   10.719076] scsi 0:0:3:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[   10.719285] scsi 0:0:3:0: qdepth(32), tagged(1), simple(0),
ordered(0), scsi_level(7), cmd_que(1)
[   10.722536] scsi 0:0:4:0: Direct-Access     ATA      Hitachi HDS5C302
A800 PQ: 0 ANSI: 6
[   10.722740] scsi 0:0:4:0: SATA: handle(0x000d),
sas_addr(0x4433221104000000), phy(4), device_name(0x5000cca369c8d933)
[   10.723014] scsi 0:0:4:0: SATA:
enclosure_logical_id(0x500605b0026e1700), slot(7)
[   10.723294] scsi 0:0:4:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[   10.723498] scsi 0:0:4:0: qdepth(32), tagged(1), simple(0),
ordered(0), scsi_level(7), cmd_que(1)
[   10.726878] scsi 0:0:5:0: Direct-Access     ATA      Hitachi HDS5C302
A800 PQ: 0 ANSI: 6
[   10.727107] scsi 0:0:5:0: SATA: handle(0x000e),
sas_addr(0x4433221105000000), phy(5), device_name(0x5000cca369c89aa8)
[   10.727382] scsi 0:0:5:0: SATA:
enclosure_logical_id(0x500605b0026e1700), slot(6)
[   10.727667] scsi 0:0:5:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[   10.727875] scsi 0:0:5:0: qdepth(32), tagged(1), simple(0),
ordered(0), scsi_level(7), cmd_que(1)
[   10.742084] scsi 0:0:6:0: Direct-Access     ATA      SAMSUNG HD154UI
 1118 PQ: 0 ANSI: 6
[   10.742268] scsi 0:0:6:0: SATA: handle(0x000f),
sas_addr(0x4433221106000000), phy(6), device_name(0x50024e900200ccc1)
[   10.742473] scsi 0:0:6:0: SATA:
enclosure_logical_id(0x500605b0026e1700), slot(5)
[   10.742707] scsi 0:0:6:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[   10.742862] scsi 0:0:6:0: qdepth(32), tagged(1), simple(0),
ordered(0), scsi_level(7), cmd_que(1)
[   10.755939] scsi 0:0:7:0: Direct-Access     ATA      SAMSUNG HD153WI
 0003 PQ: 0 ANSI: 6
[   10.756111] scsi 0:0:7:0: SATA: handle(0x0010),
sas_addr(0x4433221107000000), phy(7), device_name(0x50024e9003557848)
[   10.756397] scsi 0:0:7:0: SATA:
enclosure_logical_id(0x500605b0026e1700), slot(4)
[   10.756712] scsi 0:0:7:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[   10.756916] scsi 0:0:7:0: qdepth(32), tagged(1), simple(0),
ordered(0), scsi_level(7), cmd_que(1)
[   10.757945] scsi1 : Fusion MPT SAS Host
[   10.758886] mpt2sas1: 32 BIT PCI BUS DMA ADDRESSING SUPPORTED, total
mem (2046052 kB)
[   10.759725] mpt2sas 0000:1b:00.0: irq 73 for MSI/MSI-X
[   10.759961] mpt2sas1-msix0: PCI-MSI-X enabled: IRQ 73
[   10.760109] mpt2sas1: iomem(0x00000000d2700000),
mapped(0xffffc90000030000), size(16384)
[   10.760310] mpt2sas1: ioport(0x0000000000007000), size(256)
[   11.832442] mpt2sas1: Allocated physical memory: size(2267 kB)
[   11.832618] mpt2sas1: Current Controller Queue Depth(1483), Max
Controller Queue Depth(1720)
[   11.832818] mpt2sas1: Scatter Gather Elements per IO(128)
[   12.408260] mpt2sas1: LSISAS2008: FWVersion(15.00.00.00),
ChipRevision(0x02), BiosVersion(07.29.00.00)
[   12.408535] mpt2sas1: Protocol=(Initiator),
Capabilities=(Raid,TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set
Full,NCQ)
[   12.409370] mpt2sas1: sending port enable !!
[   14.008368] mpt2sas1: host_add: handle(0x0001),
sas_addr(0x500605b0024ee080), phys(8)
[   19.131505] mpt2sas1: port enable: SUCCESS
[   19.135320] scsi 1:0:0:0: Direct-Access     ATA      ST3750330NS
 SN06 PQ: 0 ANSI: 6
[   19.135528] scsi 1:0:0:0: SATA: handle(0x000d),
sas_addr(0x4433221102000000), phy(2), device_name(0x5000c5000266bb02)
[   19.135804] scsi 1:0:0:0: SATA:
enclosure_logical_id(0x500605b0024ee080), slot(1)
[   19.136091] scsi 1:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[   19.136297] scsi 1:0:0:0: qdepth(32), tagged(1), simple(0),
ordered(0), scsi_level(7), cmd_que(1)
[   19.150341] scsi 1:0:1:0: Direct-Access     ATA      SAMSUNG HD154UI
 1118 PQ: 0 ANSI: 6
[   19.150547] scsi 1:0:1:0: SATA: handle(0x0009),
sas_addr(0x4433221100000000), phy(0), device_name(0x50024e9002a049ef)
[   19.150834] scsi 1:0:1:0: SATA:
enclosure_logical_id(0x500605b0024ee080), slot(3)
[   19.151146] scsi 1:0:1:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[   19.151352] scsi 1:0:1:0: qdepth(32), tagged(1), simple(0),
ordered(0), scsi_level(7), cmd_que(1)
[   19.158209] scsi 1:0:2:0: Direct-Access     ATA      WDC WD15EADS-00P
0A01 PQ: 0 ANSI: 6
[   19.158415] scsi 1:0:2:0: SATA: handle(0x000a),
sas_addr(0x4433221101000000), phy(1), device_name(0x50014ee057149fdf)
[   19.158692] scsi 1:0:2:0: SATA:
enclosure_logical_id(0x500605b0024ee080), slot(2)
[   19.158976] scsi 1:0:2:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[   19.159189] scsi 1:0:2:0: qdepth(32), tagged(1), simple(0),
ordered(0), scsi_level(7), cmd_que(1)
[   19.161330] scsi 1:0:3:0: Direct-Access     ATA      ST3000DM001-9YN1
CC4H PQ: 0 ANSI: 6
[   19.161532] scsi 1:0:3:0: SATA: handle(0x000b),
sas_addr(0x4433221104000000), phy(4), device_name(0x5000c50046fa4ce6)
[   19.161805] scsi 1:0:3:0: SATA:
enclosure_logical_id(0x500605b0024ee080), slot(7)
[   19.162087] scsi 1:0:3:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[   19.162291] scsi 1:0:3:0: qdepth(32), tagged(1), simple(0),
ordered(0), scsi_level(7), cmd_que(1)
[   19.166505] scsi 1:0:4:0: Direct-Access     ATA      ST3750330NS
 SN06 PQ: 0 ANSI: 6
[   19.166708] scsi 1:0:4:0: SATA: handle(0x000c),
sas_addr(0x4433221103000000), phy(3), device_name(0x5000c5000267abee)
[   19.166980] scsi 1:0:4:0: SATA:
enclosure_logical_id(0x500605b0024ee080), slot(0)
[   19.167261] scsi 1:0:4:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[   19.167468] scsi 1:0:4:0: qdepth(32), tagged(1), simple(0),
ordered(0), scsi_level(7), cmd_que(1)
[   19.169602] scsi 1:0:5:0: Direct-Access     ATA      ST3000DM001-9YN1
CC4H PQ: 0 ANSI: 6
[   19.169804] scsi 1:0:5:0: SATA: handle(0x000e),
sas_addr(0x4433221105000000), phy(5), device_name(0x5000c5004a3de1a5)
[   19.170077] scsi 1:0:5:0: SATA:
enclosure_logical_id(0x500605b0024ee080), slot(6)
[   19.170360] scsi 1:0:5:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[   19.170563] scsi 1:0:5:0: qdepth(32), tagged(1), simple(0),
ordered(0), scsi_level(7), cmd_que(1)
[   19.184759] scsi 1:0:6:0: Direct-Access     ATA      SAMSUNG HD154UI
 1118 PQ: 0 ANSI: 6
[   19.184966] scsi 1:0:6:0: SATA: handle(0x000f),
sas_addr(0x4433221106000000), phy(6), device_name(0x50024e9203fd8476)
[   19.185999] scsi 1:0:6:0: SATA:
enclosure_logical_id(0x500605b0024ee080), slot(5)
[   19.186283] scsi 1:0:6:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[   19.186489] scsi 1:0:6:0: qdepth(32), tagged(1), simple(0),
ordered(0), scsi_level(7), cmd_que(1)
[   19.200621] scsi 1:0:7:0: Direct-Access     ATA      SAMSUNG HD154UI
 1118 PQ: 0 ANSI: 6
[   19.200829] scsi 1:0:7:0: SATA: handle(0x0010),
sas_addr(0x4433221107000000), phy(7), device_name(0x50024e9002a049f7)
[   19.201103] scsi 1:0:7:0: SATA:
enclosure_logical_id(0x500605b0024ee080), slot(4)
[   19.201385] scsi 1:0:7:0: atapi(n), ncq(y), asyn_notify(n), smart(y),
fua(y), sw_preserve(y)
[   19.201589] scsi 1:0:7:0: qdepth(32), tagged(1), simple(0),
ordered(0), scsi_level(7), cmd_que(1)
[   19.202586] VMware PVSCSI driver - version 1.0.2.0-k
[   19.202822] vmw_pvscsi: using 64bit dma
[   19.203422] vmw_pvscsi 0000:03:00.0: vmw_pvscsi: host->max_id: 16
[   19.204721] vmw_pvscsi 0000:03:00.0: irq 74 for MSI/MSI-X
[   19.204800] vmw_pvscsi: using MSI-X
[   19.204993] scsi2 : VMware PVSCSI storage adapter rev 2, req/cmp/msg
rings: 8/8/1 pages, cmd_per_lun=64
[   19.205498] vmw_pvscsi 0000:03:00.0: VMware PVSCSI rev 2 host #2
[   19.205823] scsi 2:0:0:0: Direct-Access     VMware   Virtual disk
 1.0  PQ: 0 ANSI: 2
[   19.210056] sd 0:0:4:0: [sde] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[   19.210396] sd 0:0:5:0: [sdf] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[   19.210465] sd 0:0:3:0: [sdd] 2930277168 512-byte logical blocks:
(1.50 TB/1.36 TiB)
[   19.211837] sd 1:0:3:0: [sdl] 5860533168 512-byte logical blocks:
(3.00 TB/2.72 TiB)
[   19.212050] sd 1:0:3:0: [sdl] 4096-byte physical blocks
[   19.212640] sd 1:0:5:0: [sdn] 5860533168 512-byte logical blocks:
(3.00 TB/2.72 TiB)
[   19.212650] sd 1:0:0:0: [sdi] 1465149168 512-byte logical blocks:
(750 GB/698 GiB)
[   19.213079] sd 1:0:5:0: [sdn] 4096-byte physical blocks
[   19.213370] sd 1:0:4:0: [sdm] 1465149168 512-byte logical blocks:
(750 GB/698 GiB)
[   19.213827] sd 0:0:0:0: [sda] 2930277168 512-byte logical blocks:
(1.50 TB/1.36 TiB)
[   19.214206] sd 0:0:1:0: [sdb] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[   19.214361] sd 0:0:2:0: [sdc] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[   19.214957] sd 1:0:2:0: [sdk] 2930277168 512-byte logical blocks:
(1.50 TB/1.36 TiB)
[   19.215501] sd 2:0:0:0: [sdq] 69206016 512-byte logical blocks: (35.4
GB/33.0 GiB)
[   19.215707] sd 2:0:0:0: [sdq] Write Protect is off
[   19.215817] sd 0:0:7:0: [sdh] 2930277168 512-byte logical blocks:
(1.50 TB/1.36 TiB)
[   19.215994] sd 2:0:0:0: [sdq] Mode Sense: 61 00 00 00
[   19.216021] sd 2:0:0:0: [sdq] Cache data unavailable
[   19.216042] sd 0:0:6:0: [sdg] 2930277168 512-byte logical blocks:
(1.50 TB/1.36 TiB)
[   19.216345] sd 2:0:0:0: [sdq] Assuming drive cache: write through
[   19.217056] sd 2:0:0:0: [sdq] Cache data unavailable
[   19.217166] sd 2:0:0:0: [sdq] Assuming drive cache: write through
[   19.217422] sd 1:0:1:0: [sdj] 2930277168 512-byte logical blocks:
(1.50 TB/1.36 TiB)
[   19.217741] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   19.217960]  sdq: sdq1 sdq2 sdq3
[   19.218213] sd 0:0:1:0: Attached scsi generic sg1 type 0
[   19.218471] sd 0:0:2:0: Attached scsi generic sg2 type 0
[   19.218723] sd 0:0:3:0: Attached scsi generic sg3 type 0
[   19.218865] sd 1:0:6:0: [sdo] 2930277168 512-byte logical blocks:
(1.50 TB/1.36 TiB)
[   19.218951] sd 0:0:4:0: Attached scsi generic sg4 type 0
[   19.219127] sd 2:0:0:0: [sdq] Cache data unavailable
[   19.219239] sd 2:0:0:0: [sdq] Assuming drive cache: write through
[   19.219360] sd 2:0:0:0: [sdq] Attached SCSI disk
[   19.219539] sd 0:0:5:0: Attached scsi generic sg5 type 0
[   19.219695] sd 1:0:7:0: [sdp] 2930277168 512-byte logical blocks:
(1.50 TB/1.36 TiB)
[   19.219985] sd 0:0:6:0: Attached scsi generic sg6 type 0
[   19.220245] sd 0:0:7:0: Attached scsi generic sg7 type 0
[   19.220514] sd 1:0:0:0: Attached scsi generic sg8 type 0
[   19.220786] sd 1:0:1:0: Attached scsi generic sg9 type 0
[   19.221057] sd 1:0:2:0: Attached scsi generic sg10 type 0
[   19.221339] sd 1:0:3:0: Attached scsi generic sg11 type 0
[   19.221633] sd 1:0:4:0: Attached scsi generic sg12 type 0
[   19.221918] sd 1:0:5:0: Attached scsi generic sg13 type 0
[   19.222166] sd 1:0:6:0: Attached scsi generic sg14 type 0
[   19.222450] sd 1:0:7:0: Attached scsi generic sg15 type 0
[   19.222731] sd 2:0:0:0: Attached scsi generic sg16 type 0
[   19.222890] ahci 0000:0c:00.0: version 3.0
[   19.223127] ahci 0000:0c:00.0: irq 75 for MSI/MSI-X
[   19.223387] ahci 0000:0c:00.0: AHCI 0001.0200 32 slots 6 ports 3 Gbps
0x3f impl SATA mode
[   19.223539] ahci 0000:0c:00.0: flags: 64bit ncq sntf pm led clo pio
slum part ccc ems
[   19.233330] sd 1:0:2:0: [sdk] Write Protect is off
[   19.233442] sd 1:0:2:0: [sdk] Mode Sense: 7f 00 10 08
[   19.239565] sd 1:0:2:0: [sdk] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[   19.247880] sd 0:0:6:0: [sdg] Write Protect is off
[   19.248024] sd 0:0:6:0: [sdg] Mode Sense: 7f 00 10 08
[   19.249455] sd 1:0:1:0: [sdj] Write Protect is off
[   19.249596] sd 1:0:1:0: [sdj] Mode Sense: 7f 00 10 08
[   19.250973] sd 1:0:6:0: [sdo] Write Protect is off
[   19.251114] sd 1:0:6:0: [sdo] Mode Sense: 7f 00 10 08
[   19.251671] sd 1:0:7:0: [sdp] Write Protect is off
[   19.251811] sd 1:0:7:0: [sdp] Mode Sense: 7f 00 10 08
[   19.260684] sd 0:0:6:0: [sdg] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[   19.262219] sd 1:0:1:0: [sdj] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[   19.263740] sd 1:0:6:0: [sdo] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[   19.264420] sd 1:0:7:0: [sdp] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[   19.271834] sd 1:0:3:0: [sdl] Write Protect is off
[   19.271979] sd 1:0:3:0: [sdl] Mode Sense: 7f 00 10 08
[   19.272573] sd 1:0:3:0: [sdl] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[   19.274761] sd 1:0:5:0: [sdn] Write Protect is off
[   19.274904] sd 1:0:5:0: [sdn] Mode Sense: 7f 00 10 08
[   19.275502] sd 1:0:5:0: [sdn] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[   19.276230]  sdk: unknown partition table
[   19.280430] sd 0:0:3:0: [sdd] Write Protect is off
[   19.280590] sd 0:0:3:0: [sdd] Mode Sense: 7f 00 10 08
[   19.282558] sd 0:0:3:0: [sdd] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[   19.305465] sd 1:0:2:0: [sdk] Attached SCSI disk
[   19.322771] scsi3 : ahci
[   19.323254] scsi4 : ahci
[   19.323654] scsi5 : ahci
[   19.324047] scsi6 : ahci
[   19.324459] scsi7 : ahci
[   19.324858] scsi8 : ahci
[   19.325201] ata1: SATA max UDMA/133 abar m2048@0xd2900000 port
0xd2900100 irq 75
[   19.325410] ata2: SATA max UDMA/133 abar m2048@0xd2900000 port
0xd2900180 irq 75
[   19.325619] ata3: SATA max UDMA/133 abar m2048@0xd2900000 port
0xd2900200 irq 75
[   19.325805] ata4: SATA max UDMA/133 abar m2048@0xd2900000 port
0xd2900280 irq 75
[   19.325989] ata5: SATA max UDMA/133 abar m2048@0xd2900000 port
0xd2900300 irq 75
[   19.326175] ata6: SATA max UDMA/133 abar m2048@0xd2900000 port
0xd2900380 irq 75
[   19.326858] ata_piix 0000:00:07.1: version 2.13
[   19.328034] scsi9 : ata_piix
[   19.328471] scsi10 : ata_piix
[   19.328840] ata7: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0x10c0
irq 14
[   19.329556] ata8: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0x10c8
irq 15
[   19.330364] tun: Universal TUN/TAP device driver, 1.6
[   19.330509] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   19.330849] e1000: Intel(R) PRO/1000 Network Driver - version
7.3.21-k8-NAPI
[   19.331027] e1000: Copyright (c) 1999-2006 Intel Corporation.
[   19.331257] sd 1:0:4:0: [sdm] Write Protect is off
[   19.331415] sd 1:0:4:0: [sdm] Mode Sense: 7f 00 10 08
[   19.331505] e1000e: Intel(R) PRO/1000 Network Driver - 2.1.4-k
[   19.331662] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[   19.332281] e1000e 0000:0b:00.0: Interrupt Throttling Rate (ints/sec)
set to dynamic conservative mode
[   19.332588]  sdj: unknown partition table
[   19.332876] e1000e 0000:0b:00.0: irq 76 for MSI/MSI-X
[   19.334066] sd 1:0:4:0: [sdm] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[   19.337647]  sdg: unknown partition table
[   19.340697] sd 1:0:0:0: [sdi] Write Protect is off
[   19.340804] sd 1:0:0:0: [sdi] Mode Sense: 7f 00 10 08
[   19.343241]  sdp: unknown partition table
[   19.343276]  sdo: unknown partition table
[   19.344071] sd 1:0:0:0: [sdi] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[   19.344537]  sdl: unknown partition table
[   19.345528]  sdn: unknown partition table
[   19.355807]  sdd: unknown partition table
[   19.385478] sd 1:0:1:0: [sdj] Attached SCSI disk
[   19.388796] sd 0:0:6:0: [sdg] Attached SCSI disk
[   19.394971] sd 1:0:6:0: [sdo] Attached SCSI disk
[   19.395387] sd 1:0:7:0: [sdp] Attached SCSI disk
[   19.408527] sd 1:0:5:0: [sdn] Attached SCSI disk
[   19.413801] sd 1:0:3:0: [sdl] Attached SCSI disk
[   19.424452] sd 0:0:3:0: [sdd] Attached SCSI disk
[   19.439352] sd 0:0:4:0: [sde] Write Protect is off
[   19.439498] sd 0:0:4:0: [sde] Mode Sense: 7f 00 10 08
[   19.441311] sd 0:0:4:0: [sde] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[   19.455909] sd 0:0:5:0: [sdf] Write Protect is off
[   19.456058] sd 0:0:5:0: [sdf] Mode Sense: 7f 00 10 08
[   19.457879] sd 0:0:5:0: [sdf] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[   19.469424]  sdm:
[   19.478958]  sdi: unknown partition table
[   19.515469] sd 0:0:7:0: [sdh] Write Protect is off
[   19.515583] sd 0:0:7:0: [sdh] Mode Sense: 7f 00 10 08
[   19.518115] sd 0:0:1:0: [sdb] Write Protect is off
[   19.518227] sd 0:0:1:0: [sdb] Mode Sense: 7f 00 10 08
[   19.523055] sd 0:0:0:0: [sda] Write Protect is off
[   19.523168] sd 0:0:0:0: [sda] Mode Sense: 7f 00 10 08
[   19.527184] sd 0:0:7:0: [sdh] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[   19.529969] ata8.00: ATAPI: VMware Virtual IDE CDROM Drive, 00000001,
max UDMA/33
[   19.530117] sd 0:0:1:0: [sdb] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[   19.534516] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[   19.536156] sd 0:0:2:0: [sdc] Write Protect is off
[   19.536275] sd 0:0:2:0: [sdc] Mode Sense: 7f 00 10 08
[   19.547927] sd 0:0:2:0: [sdc] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[   19.549843] ata8.00: configured for UDMA/33
[   19.608110] sd 1:0:4:0: [sdm] Attached SCSI disk
[   19.642654] sd 1:0:0:0: [sdi] Attached SCSI disk
[   19.651847] e1000e 0000:0b:00.0 eth0: (PCI Express:2.5GT/s:Width x1)
00:15:17:ca:c8:35
[   19.652078] e1000e 0000:0b:00.0 eth0: Intel(R) PRO/1000 Network
Connection
[   19.652273] e1000e 0000:0b:00.0 eth0: MAC: 7, PHY: 6, PBA No: 0070FF-0FF
[   19.652558] VMware vmxnet3 virtual NIC driver - version 1.1.29.0-k-NAPI
[   19.652765] # of Tx queues : 2, # of Rx queues : 2
[   19.661921] vmxnet3 0000:13:00.0 (unregistered net_device): features:
sg csum vlan jf tso tsoIPv6 lro highDMA
[   19.662670] vmxnet3 0000:13:00.0: irq 77 for MSI/MSI-X
[   19.662708] vmxnet3 0000:13:00.0: irq 78 for MSI/MSI-X
[   19.662744] vmxnet3 0000:13:00.0: irq 79 for MSI/MSI-X
[   19.662874] RSS is enabled.
[   19.663903] eth1: NIC Link is Up 10000 Mbps
[   19.664114] Fusion MPT base driver 3.04.20
[   19.664212] Copyright (c) 1999-2008 LSI Corporation
[   19.664327] Fusion MPT SAS Host driver 3.04.20
[   19.664511] Fusion MPT misc device (ioctl) driver 3.04.20
[   19.664719] mptctl: Registered with Fusion MPT base driver
[   19.664832] mptctl: /dev/mptctl @ (major,minor=10,220)
[   19.664945] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   19.665069] ehci-pci: EHCI PCI platform driver
[   19.665229] uhci_hcd: USB Universal Host Controller Interface driver
[   19.665420] Initializing USB Mass Storage driver...
[   19.665585] usbcore: registered new interface driver usb-storage
[   19.665706] USB Mass Storage support registered.
[   19.665867] usbcore: registered new interface driver ums-cypress
[   19.666126] i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUS] at
0x60,0x64 irq 1,12
[   19.667102] serio: i8042 KBD port at 0x60,0x64 irq 1
[   19.667848] serio: i8042 AUX port at 0x60,0x64 irq 12
[   19.668196] mousedev: PS/2 mouse device common for all mice
[   19.668608] i2c /dev entries driver
[   19.669010] piix4_smbus 0000:00:07.3: Host SMBus controller not enabled!
[   19.669453] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   19.669593] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   19.669739] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   19.669873] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   19.670006] ata3: SATA link down (SStatus 0 SControl 300)
[   19.670153] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   19.670439] md: raid1 personality registered for level 1
[   19.670595] md: raid6 personality registered for level 6
[   19.670745] md: raid5 personality registered for level 5
[   19.670906] md: raid4 personality registered for level 4
[   19.671017] EDAC MC: Ver: 3.0.0
[   19.671127] ata1.00: ATA-8: ST32000542AS, CC35, max UDMA/133
[   19.671246] ata1.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   19.672449] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input1
[   19.672692] ata2.00: ATA-8: ST32000542AS, CC35, max UDMA/133
[   19.672822] ata2.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   19.672990]  sde: unknown partition table
[   19.673153] ata1.00: configured for UDMA/133
[   19.673371] cpuidle: using governor ladder
[   19.674131] cpuidle: using governor menu
[   19.674444] ata2.00: configured for UDMA/133
[   19.674874] usbcore: registered new interface driver usbhid
[   19.675021] usbhid: USB HID core driver
[   19.675275] TCP: bic registered
[   19.675396] TCP: cubic registered
[   19.675520] TCP: vegas registered
[   19.675645] TCP: yeah registered
[   19.675775] Initializing XFRM netlink socket
[   19.675912] NET: Registered protocol family 17
[   19.676062] 8021q: 802.1Q VLAN Support v1.8
[   19.676204] Key type dns_resolver registered
[   19.676420] scsi 3:0:0:0: Direct-Access     ATA      ST32000542AS
 CC35 PQ: 0 ANSI: 5
[   19.676424] input: ImPS/2 Generic Wheel Mouse as
/devices/platform/i8042/serio1/input/input2
[   19.677239] sd 3:0:0:0: [sdr] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[   19.677547] sd 3:0:0:0: [sdr] Write Protect is off
[   19.677655] sd 3:0:0:0: [sdr] Mode Sense: 00 3a 00 00
[   19.677676] sd 3:0:0:0: Attached scsi generic sg17 type 0
[   19.677775] registered taskstats version 1
[   19.677925] sd 3:0:0:0: [sdr] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   19.682356] scsi 4:0:0:0: Direct-Access     ATA      ST32000542AS
 CC35 PQ: 0 ANSI: 5
[   19.682802] sd 4:0:0:0: [sds] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[   19.683232] sd 4:0:0:0: [sds] Write Protect is off
[   19.683346] sd 4:0:0:0: [sds] Mode Sense: 00 3a 00 00
[   19.683364] sd 4:0:0:0: [sds] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   19.683595] sd 4:0:0:0: Attached scsi generic sg18 type 0
[   19.689430]  sdf: unknown partition table
[   19.698363] ata4.00: ATA-8: ST3750330NS, SN06, max UDMA/133
[   19.698546] ata4.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   19.698855] ata6.00: ATA-8: ST3500320NS, SN16, max UDMA/133
[   19.699009] ata6.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   19.699423] ata5.00: ATA-8: ST3750330NS, SN06, max UDMA/133
[   19.699576] ata5.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   19.732797]  sdr: unknown partition table
[   19.733477] sd 3:0:0:0: [sdr] Attached SCSI disk
[   19.734542]  sds: unknown partition table
[   19.735004] sd 4:0:0:0: [sds] Attached SCSI disk
[   19.740752] ata4.00: configured for UDMA/133
[   19.741015] scsi 6:0:0:0: Direct-Access     ATA      ST3750330NS
 SN06 PQ: 0 ANSI: 5
[   19.741411] ata6.00: configured for UDMA/133
[   19.741721] sd 6:0:0:0: [sdt] 1465149168 512-byte logical blocks:
(750 GB/698 GiB)
[   19.741827] sd 6:0:0:0: Attached scsi generic sg19 type 0
[   19.742111] sd 6:0:0:0: [sdt] Write Protect is off
[   19.742223] ata5.00: configured for UDMA/133
[   19.742301] scsi 7:0:0:0: Direct-Access     ATA      ST3750330NS
 SN06 PQ: 0 ANSI: 5
[   19.742579] sd 6:0:0:0: [sdt] Mode Sense: 00 3a 00 00
[   19.742629] sd 6:0:0:0: [sdt] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   19.743089] sd 7:0:0:0: [sdu] 1465149168 512-byte logical blocks:
(750 GB/698 GiB)
[   19.743342] sd 7:0:0:0: [sdu] Write Protect is off
[   19.743488] sd 7:0:0:0: [sdu] Mode Sense: 00 3a 00 00
[   19.743532] sd 7:0:0:0: [sdu] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   19.743838] sd 7:0:0:0: Attached scsi generic sg20 type 0
[   19.744355] scsi 8:0:0:0: Direct-Access     ATA      ST3500320NS
 SN16 PQ: 0 ANSI: 5
[   19.744965] sd 8:0:0:0: [sdv] 976773168 512-byte logical blocks: (500
GB/465 GiB)
[   19.745045] sd 8:0:0:0: Attached scsi generic sg21 type 0
[   19.745419] scsi 10:0:0:0: CD-ROM            NECVMWar VMware IDE
CDR10 1.00 PQ: 0 ANSI: 5
[   19.745442] sd 8:0:0:0: [sdv] Write Protect is off
[   19.745444] sd 8:0:0:0: [sdv] Mode Sense: 00 3a 00 00
[   19.745469] sd 8:0:0:0: [sdv] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   19.748052] sr0: scsi3-mmc drive: 1x/1x writer dvd-ram cd/rw xa/form2
cdda tray
[   19.748279] cdrom: Uniform CD-ROM driver Revision: 3.20
[   19.748785] sr 10:0:0:0: Attached scsi CD-ROM sr0
[   19.749022] sr 10:0:0:0: Attached scsi generic sg22 type 5
[   19.749935]  sdt: unknown partition table
[   19.750514] sd 6:0:0:0: [sdt] Attached SCSI disk
[   19.755413]  sdv: sdv1
[   19.756104] sd 8:0:0:0: [sdv] Attached SCSI disk
[   19.803383]  sdu: sdu1 sdu2 sdu3
[   19.804695] sd 7:0:0:0: [sdu] Attached SCSI disk
[   19.844729]  sdh: unknown partition table
[   19.847430]  sdb: unknown partition table
[   19.852315]  sda: unknown partition table
[   19.865423]  sdc: unknown partition table
[   19.904692] sd 0:0:4:0: [sde] Attached SCSI disk
[   19.921246] sd 0:0:5:0: [sdf] Attached SCSI disk
[   20.154870] sd 0:0:7:0: [sdh] Attached SCSI disk
[   20.157732] sd 0:0:1:0: [sdb] Attached SCSI disk
[   20.162186] sd 0:0:0:0: [sda] Attached SCSI disk
[   20.175693] sd 0:0:2:0: [sdc] Attached SCSI disk
[   20.183946] Freeing unused kernel memory: 5008k freed
[   21.241534] fuse init (API version 7.20)
[   26.954856] kjournald starting.  Commit interval 5 seconds
[   26.954903] EXT3-fs (sdq3): mounted filesystem with writeback data mode
[   29.594075] systemd-udevd[3525]: starting version 200
[   30.103424] systemd-udevd[3543]: renamed network interface eth1 to lan1
[   30.163234] systemd-udevd[3546]: renamed network interface eth0 to lan0
[   31.842431] md: md1 stopped.
[   31.845624] md: bind<sdl>
[   31.845821] md: bind<sdn>
[   31.872446] md/raid1:md1: active with 2 out of 2 mirrors
[   31.872471] md1: detected capacity change from 0 to 3000591933440
[   31.876036] md: md2 stopped.
[   31.876743] md: bind<sdg>
[   31.877343] md: bind<sdh>
[   31.878547]  md1: unknown partition table
[   31.879557] md/raid1:md2: active with 2 out of 2 mirrors
[   31.879575] md2: detected capacity change from 0 to 1500300861440
[   31.884923] md: md3 stopped.
[   31.885472] md: bind<sde>
[   31.885577] md: bind<sdf>
[   31.890249]  md2: unknown partition table
[   31.891096] md/raid1:md3: active with 2 out of 2 mirrors
[   31.891121] md3: detected capacity change from 0 to 2000397746176
[   31.894037] md: md5 stopped.
[   31.894728] md: bind<sda>
[   31.894953] md: bind<sdd>
[   31.898143]  md3: unknown partition table
[   31.903622] md/raid1:md5: active with 2 out of 2 mirrors
[   31.903670] md5: detected capacity change from 0 to 1500300722176
[   31.906465] md: md6 stopped.
[   31.907540] md: bind<sdt>
[   31.912886] md/raid1:md6: active with 1 out of 2 mirrors
[   31.912910] md6: detected capacity change from 0 to 750155186176
[   31.915116] md: md7 stopped.
[   31.915648] md: bind<sdb>
[   31.915813] md: bind<sdc>
[   31.918754]  md6: unknown partition table
[   31.922642] md/raid1:md7: active with 2 out of 2 mirrors
[   31.922662] md7: detected capacity change from 0 to 2000397746176
[   31.924883] md: md8 stopped.
[   31.925503] md: bind<sdo>
[   31.925620] md: bind<sdk>
[   31.926050]  md5: unknown partition table
[   31.932683] md/raid1:md8: active with 2 out of 2 mirrors
[   31.932702] md8: detected capacity change from 0 to 1500300722176
[   31.934536] md: md9 stopped.
[   31.935230] md: bind<sds>
[   31.935404] md: bind<sdr>
[   31.938871] md/raid1:md9: active with 2 out of 2 mirrors
[   31.938889] md9: detected capacity change from 0 to 2000397746176
[   31.940351] md: md10 stopped.
[   31.941206]  md8: unknown partition table
[   31.941980] md: bind<sdm>
[   31.942387] md: bind<sdi>
[   31.943279]  md7: unknown partition table
[   31.947718]  md9: unknown partition table
[   31.950994] md/raid1:md10: active with 2 out of 2 mirrors
[   31.951020] md10: detected capacity change from 0 to 750155186176
[   31.951949] md: md11 stopped.
[   31.952529] md: bind<sdp>
[   31.952658] md: bind<sdj>
[   31.959718] md/raid1:md11: active with 2 out of 2 mirrors
[   31.959745] md11: detected capacity change from 0 to 1500300722176
[   31.981351]  md11: unknown partition table
[   31.991406]  md10: unknown partition table
[   34.189828] EXT3-fs (sdq3): using internal journal
[   34.638062] Adding 8385924k swap on /dev/sdq2.  Priority:-1 extents:1
across:8385924k
[   34.907840] EXT4-fs (md1): mounted filesystem with writeback data
mode. Opts: journal_async_commit,commit=15
[   34.980752] EXT4-fs (md2): mounted filesystem with writeback data
mode. Opts: journal_async_commit,commit=15
[   35.034441] EXT4-fs (md3): mounted filesystem with writeback data
mode. Opts: journal_async_commit,commit=15
[   35.097927] EXT4-fs (md5): mounted filesystem with writeback data
mode. Opts: journal_async_commit,commit=15
[   35.122859] EXT4-fs (md6): mounted filesystem with writeback data
mode. Opts: journal_async_commit,commit=15
[   35.197959] EXT4-fs (md7): mounted filesystem with writeback data
mode. Opts: journal_async_commit,commit=15
[   35.244388] EXT4-fs (md8): mounted filesystem with writeback data
mode. Opts: journal_async_commit,commit=15
[   35.345470] EXT4-fs (md9): mounted filesystem with writeback data
mode. Opts: journal_async_commit,commit=15
[   35.399100] EXT4-fs (md10): mounted filesystem with writeback data
mode. Opts: journal_async_commit,commit=15
[   35.474727] EXT4-fs (md11): mounted filesystem with writeback data
mode. Opts: journal_async_commit,commit=15
[   35.488879] EXT4-fs (sdv1): mounted filesystem with writeback data
mode. Opts: journal_async_commit,commit=60
[   42.191667] lan1: intr type 3, mode 0, 3 vectors allocated
[   42.192443] lan1: NIC Link is Up 10000 Mbps
[   42.192857] 8021q: adding VLAN 0 to HW filter on device lan1
[   42.848084] device lan1 entered promiscuous mode
[   42.868182] device tap0 entered promiscuous mode
[   42.888674] device tap1 entered promiscuous mode
[   42.908509] device tap2 entered promiscuous mode
[   42.927747] device tap3 entered promiscuous mode
[   42.937785] device br0 entered promiscuous mode
[   42.940994] br0: port 1(lan1) entered forwarding state
[   42.940999] br0: port 1(lan1) entered forwarding state
[   43.841478] e1000e 0000:0b:00.0: irq 76 for MSI/MSI-X
[   43.948907] e1000e 0000:0b:00.0: irq 76 for MSI/MSI-X
[   46.622733] e1000e: lan0 NIC Link is Up 1000 Mbps Full Duplex, Flow
Control: Rx/Tx
[   57.933542] br0: port 1(lan1) entered forwarding state
[  105.018741] br0: port 2(tap0) entered forwarding state
[  105.018761] br0: port 2(tap0) entered forwarding state
[  105.153340] br0: port 3(tap1) entered forwarding state
[  105.153359] br0: port 3(tap1) entered forwarding state
[  105.284504] br0: port 4(tap2) entered forwarding state
[  105.284519] br0: port 4(tap2) entered forwarding state
[  105.401469] br0: port 5(tap3) entered forwarding state
[  105.401493] br0: port 5(tap3) entered forwarding state
[  120.018171] br0: port 2(tap0) entered forwarding state
[  120.137865] br0: port 3(tap1) entered forwarding state
[  120.257570] br0: port 4(tap2) entered forwarding state
[  120.377266] br0: port 5(tap3) entered forwarding state
[17200.123824] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[17200.149429] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[17200.492587] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[17200.492601] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[17201.163984] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[17201.220652] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[17201.484460] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[17201.484471] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[17201.719448] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[17202.212669] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[17202.481848] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[17202.481860] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[17202.481882] sd 1:0:5:0: [sdn] Unhandled error code
[17202.481884] sd 1:0:5:0: [sdn]
[17202.481886] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[17202.481888] sd 1:0:5:0: [sdn] CDB:
[17202.481889] Write(16): 8a 00 00 00 00 00 2e 85 6d 28 00 00 00 08 00 00
[17202.481899] end_request: I/O error, dev sdn, sector 780496168
[17202.481906] sd 1:0:3:0: [sdl] Unhandled error code
[17202.481908] sd 1:0:3:0: [sdl]
[17202.481909] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[17202.481911] sd 1:0:3:0: [sdl] CDB:
[17202.481911] Write(16): 8a 00 00 00 00 00 2e 85 6d 28 00 00 00 08 00 00
[17202.481920] end_request: I/O error, dev sdl, sector 780496168
[17202.482015] md/raid1:md1: Disk failure on sdn, disabling device.
md/raid1:md1: Operation continuing on 1 devices.
[17202.482095] md1: WRITE SAME failed. Manually zeroing.
[17202.715908] RAID1 conf printout:
[17202.715910]  --- wd:1 rd:2
[17202.715911]  disk 0, wo:1, o:0, dev:sdn
[17202.715913]  disk 1, wo:0, o:1, dev:sdl
[17202.749148] RAID1 conf printout:
[17202.749150]  --- wd:1 rd:2
[17202.749152]  disk 1, wo:0, o:1, dev:sdl
[17466.817381] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[17467.056445] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[17467.305270] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[17468.053570] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[17468.302338] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[17468.552218] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[17468.552245] sd 1:0:3:0: [sdl] Unhandled error code
[17468.552247] sd 1:0:3:0: [sdl]
[17468.552248] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[17468.552250] sd 1:0:3:0: [sdl] CDB:
[17468.552252] Write(16): 8a 00 00 00 00 00 37 84 71 60 00 00 00 08 00 00
[17468.552262] end_request: I/O error, dev sdl, sector 931426656
[17468.552331] md1: WRITE SAME failed. Manually zeroing.
[18958.352839] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[18958.613224] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[18958.862514] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[18959.610596] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[18959.860949] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[18960.000653] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[18960.000669] sd 1:0:3:0: [sdl] Unhandled error code
[18960.000671] sd 1:0:3:0: [sdl]
[18960.000673] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[18960.000674] sd 1:0:3:0: [sdl] CDB:
[18960.000676] Write(16): 8a 00 00 00 00 00 a4 46 13 f8 00 00 00 08 00 00
[18960.000693] end_request: I/O error, dev sdl, sector 2756056056
[18960.000777] md1: WRITE SAME failed. Manually zeroing.
[18960.967231] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[18960.967237] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[18961.107765] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[18961.357139] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[18962.097544] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[18962.345974] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[18962.595387] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[18962.595401] sd 1:0:3:0: [sdl] Unhandled error code
[18962.595402] sd 1:0:3:0: [sdl]
[18962.595404] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[18962.595405] sd 1:0:3:0: [sdl] CDB:
[18962.595406] Write(16): 8a 00 00 00 00 00 a4 46 24 80 00 00 00 08 00 00
[18962.595414] end_request: I/O error, dev sdl, sector 2756060288
[18962.595464] md1: WRITE SAME failed. Manually zeroing.
[23696.299522] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[23696.617733] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[23697.365859] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[23697.615461] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[23697.864565] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[23698.612858] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[23698.612879] sd 1:0:3:0: [sdl] Unhandled error code
[23698.612881] sd 1:0:3:0: [sdl]
[23698.612883] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[23698.612885] sd 1:0:3:0: [sdl] CDB:
[23698.612886] Write(16): 8a 00 00 00 00 00 27 84 93 e0 00 00 00 08 00 00
[23698.612896] end_request: I/O error, dev sdl, sector 663000032
[23698.612956] md1: WRITE SAME failed. Manually zeroing.
[26641.112555] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[26641.319452] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[26641.568829] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[26642.316962] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[26642.566362] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[26642.815727] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[26642.815752] sd 1:0:3:0: [sdl] Unhandled error code
[26642.815754] sd 1:0:3:0: [sdl]
[26642.815755] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[26642.815757] sd 1:0:3:0: [sdl] CDB:
[26642.815758] Write(16): 8a 00 00 00 00 00 36 89 88 90 00 00 00 08 00 00
[26642.815766] end_request: I/O error, dev sdl, sector 914983056
[26642.815873] md1: WRITE SAME failed. Manually zeroing.
[27548.997244] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[27549.328076] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[27550.063900] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[27550.063905] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[27550.326222] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[27550.326227] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[27550.574734] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[27551.321730] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[27551.321736] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[27551.321760] sd 1:0:3:0: [sdl] Unhandled error code
[27551.321767] sd 1:0:3:0: [sdl]
[27551.321768] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[27551.321770] sd 1:0:3:0: [sdl] CDB:
[27551.321772] Write(16): 8a 00 00 00 00 00 36 89 8a 78 00 00 00 20 00 00
[27551.321782] end_request: I/O error, dev sdl, sector 914983544
[27551.321923] md1: WRITE SAME failed. Manually zeroing.
[27576.487572] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[27576.759459] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[27577.008719] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[27577.756304] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[27578.006609] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[27578.255378] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[27578.255396] sd 1:0:3:0: [sdl] Unhandled error code
[27578.255399] sd 1:0:3:0: [sdl]
[27578.255400] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[27578.255402] sd 1:0:3:0: [sdl] CDB:
[27578.255403] Write(16): 8a 00 00 00 00 00 36 89 8d d0 00 00 00 08 00 00
[27578.255414] end_request: I/O error, dev sdl, sector 914984400
[27578.255498] md1: WRITE SAME failed. Manually zeroing.
[27592.320796] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[27592.469477] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[27592.718866] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[27593.467995] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[27593.716363] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[27593.965745] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[27593.965762] sd 1:0:3:0: [sdl] Unhandled error code
[27593.965764] sd 1:0:3:0: [sdl]
[27593.965766] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[27593.965767] sd 1:0:3:0: [sdl] CDB:
[27593.965769] Write(16): 8a 00 00 00 00 00 36 89 8e 38 00 00 00 10 00 00
[27593.965779] end_request: I/O error, dev sdl, sector 914984504
[27593.965848] md1: WRITE SAME failed. Manually zeroing.
[27718.370288] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[27718.654740] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[28214.917132] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[28215.171329] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[28215.420698] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[28216.169832] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[28216.418183] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[28216.667795] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[28216.667809] sd 1:0:3:0: [sdl] Unhandled error code
[28216.667812] sd 1:0:3:0: [sdl]
[28216.667813] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[28216.667815] sd 1:0:3:0: [sdl] CDB:
[28216.667827] Write(16): 8a 00 00 00 00 00 36 89 8f 20 00 00 00 20 00 00
[28216.667838] end_request: I/O error, dev sdl, sector 914984736
[28216.667926] md1: WRITE SAME failed. Manually zeroing.
[28218.757651] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[28218.911939] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[28219.161960] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[28219.909464] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[28220.159009] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[28220.408219] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[28220.408236] sd 1:0:3:0: [sdl] Unhandled error code
[28220.408238] sd 1:0:3:0: [sdl]
[28220.408240] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[28220.408241] sd 1:0:3:0: [sdl] CDB:
[28220.408243] Write(16): 8a 00 00 00 00 00 36 89 8f 48 00 00 00 20 00 00
[28220.408253] end_request: I/O error, dev sdl, sector 914984776
[28220.408343] md1: WRITE SAME failed. Manually zeroing.
[28245.315368] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[28245.595278] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[28246.343358] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[28246.593481] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[28246.842118] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[28247.590309] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[28247.590327] sd 1:0:3:0: [sdl] Unhandled error code
[28247.590329] sd 1:0:3:0: [sdl]
[28247.590330] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[28247.590332] sd 1:0:3:0: [sdl] CDB:
[28247.590334] Write(16): 8a 00 00 00 00 00 36 89 8f 18 00 00 00 08 00 00
[28247.590344] end_request: I/O error, dev sdl, sector 914984728
[28247.590414] md1: WRITE SAME failed. Manually zeroing.
[28248.078188] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[28248.837142] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[28249.086928] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[28249.336180] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[28250.083945] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[28250.333349] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[28250.333368] sd 1:0:3:0: [sdl] Unhandled error code
[28250.333370] sd 1:0:3:0: [sdl]
[28250.333372] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[28250.333374] sd 1:0:3:0: [sdl] CDB:
[28250.333375] Write(16): 8a 00 00 00 00 00 36 89 88 50 00 00 00 40 00 00
[28250.333386] end_request: I/O error, dev sdl, sector 914982992
[28250.333457] md1: WRITE SAME failed. Manually zeroing.
[53244.479887] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[53244.653517] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[53244.902909] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[53245.652295] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[53245.901219] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[53246.149769] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[53246.149794] sd 1:0:3:0: [sdl] Unhandled error code
[53246.149795] sd 1:0:3:0: [sdl]
[53246.149797] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[53246.149798] sd 1:0:3:0: [sdl] CDB:
[53246.149799] Write(16): 8a 00 00 00 00 00 36 89 8f 68 00 00 00 08 00 00
[53246.149820] end_request: I/O error, dev sdl, sector 914984808
[53246.149897] md1: WRITE SAME failed. Manually zeroing.
[53418.095304] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[53418.220091] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[53418.468621] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[53419.216764] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[53419.466145] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[53419.716319] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[53419.716349] sd 1:0:3:0: [sdl] Unhandled error code
[53419.716350] sd 1:0:3:0: [sdl]
[53419.716352] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[53419.716353] sd 1:0:3:0: [sdl] CDB:
[53419.716354] Write(16): 8a 00 00 00 00 00 36 89 8f 80 00 00 00 08 00 00
[53419.716362] end_request: I/O error, dev sdl, sector 914984832
[53419.716444] md1: WRITE SAME failed. Manually zeroing.
[103893.420036] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[103893.638237] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[103893.887969] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[103894.635703] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[103894.885038] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[103895.134469] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[103895.134497] sd 1:0:3:0: [sdl] Unhandled error code
[103895.134499] sd 1:0:3:0: [sdl]
[103895.134501] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[103895.134503] sd 1:0:3:0: [sdl] CDB:
[103895.134504] Write(16): 8a 00 00 00 00 00 36 89 97 f0 00 00 00 08 00 00
[103895.134515] end_request: I/O error, dev sdl, sector 914986992
[103895.134604] md1: WRITE SAME failed. Manually zeroing.
[104223.003825] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[104223.323343] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[104224.071522] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[104224.320827] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[104224.570217] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[104225.318321] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[104225.318335] sd 1:0:3:0: [sdl] Unhandled error code
[104225.318336] sd 1:0:3:0: [sdl]
[104225.318338] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[104225.318339] sd 1:0:3:0: [sdl] CDB:
[104225.318340] Write(16): 8a 00 00 00 00 00 a4 f0 b5 50 00 00 00 10 00 00
[104225.318348] end_request: I/O error, dev sdl, sector 2767238480
[104225.318425] md1: WRITE SAME failed. Manually zeroing.
[104225.619461] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[104225.817118] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[104226.565248] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[104226.814640] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[104227.064603] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[104227.812948] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[104227.812964] sd 1:0:3:0: [sdl] Unhandled error code
[104227.812967] sd 1:0:3:0: [sdl]
[104227.812968] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[104227.812980] sd 1:0:3:0: [sdl] CDB:
[104227.812982] Write(16): 8a 00 00 00 00 00 a4 f0 b5 30 00 00 00 20 00 00
[104227.812993] end_request: I/O error, dev sdl, sector 2767238448
[104227.813098] md1: WRITE SAME failed. Manually zeroing.
[144914.823807] md: data-check of RAID array md1
[144914.823810] md: minimum _guaranteed_  speed: 25000 KB/sec/disk.
[144914.823811] md: using maximum available idle IO bandwidth (but not
more than 1000000 KB/sec) for data-check.
[144914.823814] md: using 128k window, over a total of 2930265560k.
[144914.824183] md: md1: data-check done.
[144914.825824] md: data-check of RAID array md8
[144914.825826] md: minimum _guaranteed_  speed: 25000 KB/sec/disk.
[144914.825827] md: using maximum available idle IO bandwidth (but not
more than 1000000 KB/sec) for data-check.
[144914.825829] md: using 128k window, over a total of 1465137424k.
[144914.827190] md: data-check of RAID array md7
[144914.827193] md: minimum _guaranteed_  speed: 25000 KB/sec/disk.
[144914.827194] md: using maximum available idle IO bandwidth (but not
more than 1000000 KB/sec) for data-check.
[144914.827197] md: using 128k window, over a total of 1953513424k.
[144914.828559] md: data-check of RAID array md5
[144914.828561] md: minimum _guaranteed_  speed: 25000 KB/sec/disk.
[144914.828562] md: using maximum available idle IO bandwidth (but not
more than 1000000 KB/sec) for data-check.
[144914.828565] md: using 128k window, over a total of 1465137424k.
[144914.830106] md: data-check of RAID array md2
[144914.830108] md: minimum _guaranteed_  speed: 25000 KB/sec/disk.
[144914.830109] md: using maximum available idle IO bandwidth (but not
more than 1000000 KB/sec) for data-check.
[144914.830111] md: using 128k window, over a total of 1465137560k.
[144914.831822] md: data-check of RAID array md10
[144914.831824] md: minimum _guaranteed_  speed: 25000 KB/sec/disk.
[144914.831825] md: using maximum available idle IO bandwidth (but not
more than 1000000 KB/sec) for data-check.
[144914.831827] md: using 128k window, over a total of 732573424k.
[144914.832919] md: data-check of RAID array md6
[144914.832921] md: minimum _guaranteed_  speed: 25000 KB/sec/disk.
[144914.832922] md: using maximum available idle IO bandwidth (but not
more than 1000000 KB/sec) for data-check.
[144914.832923] md: using 128k window, over a total of 732573424k.
[144914.834004] md: md6: data-check done.
[144914.834422] md: data-check of RAID array md9
[144914.834423] md: minimum _guaranteed_  speed: 25000 KB/sec/disk.
[144914.834424] md: using maximum available idle IO bandwidth (but not
more than 1000000 KB/sec) for data-check.
[144914.834426] md: using 128k window, over a total of 1953513424k.
[144914.835024] md: data-check of RAID array md11
[144914.835027] md: minimum _guaranteed_  speed: 25000 KB/sec/disk.
[144914.835028] md: using maximum available idle IO bandwidth (but not
more than 1000000 KB/sec) for data-check.
[144914.835030] md: using 128k window, over a total of 1465137424k.
[144914.835559] md: data-check of RAID array md3
[144914.835560] md: minimum _guaranteed_  speed: 25000 KB/sec/disk.
[144914.835561] md: using maximum available idle IO bandwidth (but not
more than 1000000 KB/sec) for data-check.
[144914.835563] md: using 128k window, over a total of 1953513424k.
[154089.766849] md: md10: data-check done.
[162897.343141] md: md11: data-check done.
[163137.108376] md: md2: data-check done.
[164490.242738] md: md5: data-check done.
[165401.868392] md: md8: data-check done.
[165402.697628] md: md3: data-check done.
[168665.662817] md: md9: data-check done.
[169957.970275] md: md7: data-check done.
[182680.663764] mpt2sas0: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[182680.663773] mpt2sas0: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[182680.776698] mpt2sas0: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[182680.776706] mpt2sas0: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[182681.026088] mpt2sas0: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[182681.026096] mpt2sas0: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[182681.774190] mpt2sas0: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[182681.774200] mpt2sas0: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[182682.023564] mpt2sas0: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[182682.023574] mpt2sas0: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[182682.272923] mpt2sas0: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[182682.272937] mpt2sas0: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[182682.272967] sd 0:0:4:0: [sde] Unhandled error code
[182682.272970] sd 0:0:4:0: [sde]
[182682.272971] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[182682.272973] sd 0:0:4:0: [sde] CDB:
[182682.272977] Write(10): 2a 00 53 5e 48 c8 00 00 08 00
[182682.272986] end_request: I/O error, dev sde, sector 1398687944
[182682.272996] sd 0:0:5:0: [sdf] Unhandled error code
[182682.272998] sd 0:0:5:0: [sdf]
[182682.272999] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[182682.273001] sd 0:0:5:0: [sdf] CDB:
[182682.273001] Write(10): 2a 00 53 5e 48 c8 00 00 08 00
[182682.273008] end_request: I/O error, dev sdf, sector 1398687944
[182682.273051] md/raid1:md3: Disk failure on sdf, disabling device.
md/raid1:md3: Operation continuing on 1 devices.
[182682.273098] md3: WRITE SAME failed. Manually zeroing.
[182682.965247] RAID1 conf printout:
[182682.965250]  --- wd:1 rd:2
[182682.965251]  disk 0, wo:1, o:0, dev:sdf
[182682.965253]  disk 1, wo:0, o:1, dev:sde
[182683.024011] RAID1 conf printout:
[182683.024014]  --- wd:1 rd:2
[182683.024016]  disk 1, wo:0, o:1, dev:sde
[199849.464508] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[199849.615779] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[199849.865720] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[199850.613607] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[199850.862634] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[199851.112875] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[199851.112909] sd 1:0:3:0: [sdl] Unhandled error code
[199851.112911] sd 1:0:3:0: [sdl]
[199851.112912] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[199851.112914] sd 1:0:3:0: [sdl] CDB:
[199851.112915] Write(16): 8a 00 00 00 00 00 a4 f0 b5 68 00 00 00 08 00 00
[199851.112923] end_request: I/O error, dev sdl, sector 2767238504
[199851.113016] md1: WRITE SAME failed. Manually zeroing.
[200746.890905] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200747.140066] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200747.390549] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200748.137594] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200748.387000] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200748.636371] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200748.636384] sd 1:0:3:0: [sdl] Unhandled error code
[200748.636387] sd 1:0:3:0: [sdl]
[200748.636388] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[200748.636390] sd 1:0:3:0: [sdl] CDB:
[200748.636391] Write(16): 8a 00 00 00 00 00 a4 f0 b5 90 00 00 00 18 00 00
[200748.636402] end_request: I/O error, dev sdl, sector 2767238544
[200748.636478] md1: WRITE SAME failed. Manually zeroing.
[200805.010379] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200805.244699] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200805.495231] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200806.242218] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200806.491577] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200806.741055] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200806.741073] sd 1:0:3:0: [sdl] Unhandled error code
[200806.741074] sd 1:0:3:0: [sdl]
[200806.741076] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[200806.741077] sd 1:0:3:0: [sdl] CDB:
[200806.741078] Write(16): 8a 00 00 00 00 00 eb c2 07 d8 00 00 00 08 00 00
[200806.741086] end_request: I/O error, dev sdl, sector 3955361752
[200806.741153] md1: WRITE SAME failed. Manually zeroing.
[200864.479137] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200864.479143] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200864.479145] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200864.479147] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200864.479154] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200864.479160] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200864.479175] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200864.479177] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200864.583588] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200864.583591] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200864.583601] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200864.583603] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200864.583605] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200864.583609] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200864.583615] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200864.869133] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200864.869139] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200864.869141] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200864.869144] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200864.869146] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200865.613332] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200865.844002] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200866.093366] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200866.093384] sd 1:0:3:0: [sdl] Unhandled error code
[200866.093386] sd 1:0:3:0: [sdl]
[200866.093387] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[200866.093389] sd 1:0:3:0: [sdl] CDB:
[200866.093390] Write(16): 8a 00 00 00 00 00 ec 02 53 f8 00 00 04 00 00 00
[200866.093398] end_request: I/O error, dev sdl, sector 3959575544
[200866.093453] Buffer I/O error on device md1, logical block 494946687
[200866.093461] Buffer I/O error on device md1, logical block 494946688
[200866.093463] Buffer I/O error on device md1, logical block 494946689
[200866.093465] Buffer I/O error on device md1, logical block 494946690
[200866.093466] Buffer I/O error on device md1, logical block 494946691
[200866.093468] Buffer I/O error on device md1, logical block 494946692
[200866.093477] Buffer I/O error on device md1, logical block 494946693
[200866.093480] Buffer I/O error on device md1, logical block 494946694
[200866.093481] Buffer I/O error on device md1, logical block 494946695
[200866.093483] Buffer I/O error on device md1, logical block 494946696
[200866.093485] Buffer I/O error on device md1, logical block 494946697
[200866.093487] Buffer I/O error on device md1, logical block 494946698
[200866.093489] Buffer I/O error on device md1, logical block 494946699
[200866.093490] Buffer I/O error on device md1, logical block 494946700
[200866.093492] Buffer I/O error on device md1, logical block 494946701
[200866.093494] Buffer I/O error on device md1, logical block 494946702
[200866.093495] Buffer I/O error on device md1, logical block 494946703
[200866.093497] Buffer I/O error on device md1, logical block 494946704
[200866.093499] Buffer I/O error on device md1, logical block 494946705
[200866.093500] Buffer I/O error on device md1, logical block 494946706
[200866.093502] Buffer I/O error on device md1, logical block 494946707
[200866.093504] Buffer I/O error on device md1, logical block 494946708
[200866.093506] Buffer I/O error on device md1, logical block 494946709
[200866.093508] Buffer I/O error on device md1, logical block 494946710
[200866.093509] Buffer I/O error on device md1, logical block 494946711
[200866.093511] Buffer I/O error on device md1, logical block 494946712
[200866.093513] Buffer I/O error on device md1, logical block 494946713
[200866.093514] Buffer I/O error on device md1, logical block 494946714
[200866.093516] Buffer I/O error on device md1, logical block 494946715
[200866.093518] Buffer I/O error on device md1, logical block 494946716
[200866.093519] Buffer I/O error on device md1, logical block 494946717
[200866.093521] Buffer I/O error on device md1, logical block 494946718
[200866.093523] Buffer I/O error on device md1, logical block 494946719
[200866.093524] Buffer I/O error on device md1, logical block 494946720
[200866.093526] Buffer I/O error on device md1, logical block 494946721
[200866.093528] Buffer I/O error on device md1, logical block 494946722
[200866.093529] Buffer I/O error on device md1, logical block 494946723
[200866.093531] Buffer I/O error on device md1, logical block 494946724
[200866.093533] Buffer I/O error on device md1, logical block 494946725
[200866.093534] Buffer I/O error on device md1, logical block 494946726
[200866.093536] Buffer I/O error on device md1, logical block 494946727
[200866.093538] Buffer I/O error on device md1, logical block 494946728
[200866.093539] Buffer I/O error on device md1, logical block 494946729
[200866.093541] Buffer I/O error on device md1, logical block 494946730
[200866.093543] Buffer I/O error on device md1, logical block 494946731
[200866.093544] Buffer I/O error on device md1, logical block 494946732
[200866.093546] Buffer I/O error on device md1, logical block 494946733
[200866.093547] Buffer I/O error on device md1, logical block 494946734
[200866.093549] Buffer I/O error on device md1, logical block 494946735
[200866.093551] Buffer I/O error on device md1, logical block 494946736
[200866.093552] Buffer I/O error on device md1, logical block 494946737
[200866.093554] Buffer I/O error on device md1, logical block 494946738
[200866.093556] Buffer I/O error on device md1, logical block 494946739
[200866.093558] Buffer I/O error on device md1, logical block 494946740
[200866.093560] Buffer I/O error on device md1, logical block 494946741
[200866.093561] Buffer I/O error on device md1, logical block 494946742
[200866.093563] Buffer I/O error on device md1, logical block 494946743
[200866.093564] Buffer I/O error on device md1, logical block 494946744
[200866.093566] Buffer I/O error on device md1, logical block 494946745
[200866.093568] Buffer I/O error on device md1, logical block 494946746
[200866.093569] Buffer I/O error on device md1, logical block 494946747
[200866.093571] Buffer I/O error on device md1, logical block 494946748
[200866.093573] Buffer I/O error on device md1, logical block 494946749
[200866.093577] Buffer I/O error on device md1, logical block 494946750
[200866.093579] Buffer I/O error on device md1, logical block 494946751
[200866.093581] Buffer I/O error on device md1, logical block 494946752
[200866.093583] Buffer I/O error on device md1, logical block 494946753
[200866.093584] Buffer I/O error on device md1, logical block 494946754
[200866.093586] Buffer I/O error on device md1, logical block 494946755
[200866.093588] Buffer I/O error on device md1, logical block 494946756
[200866.093589] Buffer I/O error on device md1, logical block 494946757
[200866.093591] Buffer I/O error on device md1, logical block 494946758
[200866.093592] Buffer I/O error on device md1, logical block 494946759
[200866.093594] Buffer I/O error on device md1, logical block 494946760
[200866.093595] Buffer I/O error on device md1, logical block 494946761
[200866.093597] Buffer I/O error on device md1, logical block 494946762
[200866.093599] Buffer I/O error on device md1, logical block 494946763
[200866.093600] Buffer I/O error on device md1, logical block 494946764
[200866.093602] Buffer I/O error on device md1, logical block 494946765
[200866.093604] Buffer I/O error on device md1, logical block 494946766
[200866.093605] Buffer I/O error on device md1, logical block 494946767
[200866.093607] Buffer I/O error on device md1, logical block 494946768
[200866.093609] Buffer I/O error on device md1, logical block 494946769
[200866.093610] Buffer I/O error on device md1, logical block 494946770
[200866.093612] Buffer I/O error on device md1, logical block 494946771
[200866.093613] Buffer I/O error on device md1, logical block 494946772
[200866.093615] Buffer I/O error on device md1, logical block 494946773
[200866.093617] Buffer I/O error on device md1, logical block 494946774
[200866.093618] Buffer I/O error on device md1, logical block 494946775
[200866.093620] Buffer I/O error on device md1, logical block 494946776
[200866.093622] Buffer I/O error on device md1, logical block 494946777
[200866.093623] Buffer I/O error on device md1, logical block 494946778
[200866.093625] Buffer I/O error on device md1, logical block 494946779
[200866.093627] Buffer I/O error on device md1, logical block 494946780
[200866.093628] Buffer I/O error on device md1, logical block 494946781
[200866.093630] Buffer I/O error on device md1, logical block 494946782
[200866.093632] Buffer I/O error on device md1, logical block 494946783
[200866.093633] Buffer I/O error on device md1, logical block 494946784
[200866.093635] Buffer I/O error on device md1, logical block 494946785
[200866.093636] Buffer I/O error on device md1, logical block 494946786
[200866.093638] Buffer I/O error on device md1, logical block 494946787
[200866.093639] Buffer I/O error on device md1, logical block 494946788
[200866.093641] Buffer I/O error on device md1, logical block 494946789
[200866.093643] Buffer I/O error on device md1, logical block 494946790
[200866.093644] Buffer I/O error on device md1, logical block 494946791
[200866.093646] Buffer I/O error on device md1, logical block 494946792
[200866.093648] Buffer I/O error on device md1, logical block 494946793
[200866.093649] Buffer I/O error on device md1, logical block 494946794
[200866.093651] Buffer I/O error on device md1, logical block 494946795
[200866.093653] Buffer I/O error on device md1, logical block 494946796
[200866.093654] Buffer I/O error on device md1, logical block 494946797
[200866.093656] Buffer I/O error on device md1, logical block 494946798
[200866.093657] Buffer I/O error on device md1, logical block 494946799
[200866.093659] Buffer I/O error on device md1, logical block 494946800
[200866.093661] Buffer I/O error on device md1, logical block 494946801
[200866.093662] Buffer I/O error on device md1, logical block 494946802
[200866.093664] Buffer I/O error on device md1, logical block 494946803
[200866.093665] Buffer I/O error on device md1, logical block 494946804
[200866.093667] Buffer I/O error on device md1, logical block 494946805
[200866.093669] Buffer I/O error on device md1, logical block 494946806
[200866.093673] Buffer I/O error on device md1, logical block 494946807
[200866.093680] EXT4-fs warning (device md1): ext4_end_bio:317: I/O
error writing to inode 18743347 (offset 6819840 size 495616 starting
block 494946687)
[200866.093687] Buffer I/O error on device md1, logical block 494946808
[200866.093690] EXT4-fs warning (device md1): ext4_end_bio:317: I/O
error writing to inode 18743347 (offset 7315456 size 4096 starting block
494946808)
[200866.093719] md1: WRITE SAME failed. Manually zeroing.
[200878.494934] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.494938] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.494942] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.494944] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.494953] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.494959] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.494975] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.494977] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.494984] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.494994] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.495011] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.495013] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.495017] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.495028] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.495036] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.495045] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.495054] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.495064] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.495072] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.495076] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.495089] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.495093] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.495106] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.495109] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.495116] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.495126] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.495134] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.495138] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.495150] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.495154] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.495164] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.495174] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.902980] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.902985] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.902988] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.902995] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.903012] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.903014] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.903025] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.903039] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.903042] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.903048] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.903061] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.903065] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.903071] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.903084] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.903093] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.903102] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200878.903110] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200879.606656] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200879.606661] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200879.606663] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200879.606666] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200879.606669] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200879.606684] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200879.606686] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200879.606693] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200879.606699] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200879.829745] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200879.829748] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200879.829765] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200879.829768] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200879.829772] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200879.829775] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200879.829777] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200880.111942] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200880.805651] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200880.805668] sd 1:0:3:0: [sdl] Unhandled error code
[200880.805670] sd 1:0:3:0: [sdl]
[200880.805671] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[200880.805673] sd 1:0:3:0: [sdl] CDB:
[200880.805674] Write(16): 8a 00 00 00 00 01 0c 90 94 08 00 00 00 08 00 00
[200880.805682] end_request: I/O error, dev sdl, sector 4505768968
[200880.805749] md1: WRITE SAME failed. Manually zeroing.
[200927.332214] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200927.332218] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200927.332220] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200927.446118] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200927.446124] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200927.676787] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200928.440346] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200993.199272] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200993.524887] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200994.272967] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200994.522355] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200994.771859] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200995.519897] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[200995.519911] sd 1:0:3:0: [sdl] Unhandled error code
[200995.519913] sd 1:0:3:0: [sdl]
[200995.519914] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[200995.519916] sd 1:0:3:0: [sdl] CDB:
[200995.519918] Write(16): 8a 00 00 00 00 01 0c 94 16 f8 00 00 01 08 00 00
[200995.519928] end_request: I/O error, dev sdl, sector 4505999096
[200995.519992] Buffer I/O error on device md1, logical block 563249631
[200995.519998] Buffer I/O error on device md1, logical block 563249632
[200995.520000] Buffer I/O error on device md1, logical block 563249633
[200995.520002] Buffer I/O error on device md1, logical block 563249634
[200995.520009] Buffer I/O error on device md1, logical block 563249635
[200995.520011] Buffer I/O error on device md1, logical block 563249636
[200995.520013] Buffer I/O error on device md1, logical block 563249637
[200995.520015] Buffer I/O error on device md1, logical block 563249638
[200995.520019] Buffer I/O error on device md1, logical block 563249639
[200995.520021] Buffer I/O error on device md1, logical block 563249640
[200995.520023] Buffer I/O error on device md1, logical block 563249641
[200995.520025] Buffer I/O error on device md1, logical block 563249642
[200995.520027] Buffer I/O error on device md1, logical block 563249643
[200995.520028] Buffer I/O error on device md1, logical block 563249644
[200995.520030] Buffer I/O error on device md1, logical block 563249645
[200995.520032] Buffer I/O error on device md1, logical block 563249646
[200995.520036] Buffer I/O error on device md1, logical block 563249647
[200995.520038] Buffer I/O error on device md1, logical block 563249648
[200995.520040] Buffer I/O error on device md1, logical block 563249649
[200995.520042] Buffer I/O error on device md1, logical block 563249650
[200995.520044] Buffer I/O error on device md1, logical block 563249651
[200995.520045] Buffer I/O error on device md1, logical block 563249652
[200995.520047] Buffer I/O error on device md1, logical block 563249653
[200995.520049] Buffer I/O error on device md1, logical block 563249654
[200995.520053] EXT4-fs warning (device md1): ext4_end_bio:317: I/O
error writing to inode 18743347 (offset 11403264 size 98304 starting
block 563249631)
[200995.520058] Buffer I/O error on device md1, logical block 563249655
[200995.520062] EXT4-fs warning (device md1): ext4_end_bio:317: I/O
error writing to inode 18743347 (offset 11501568 size 4096 starting
block 563249655)
[200995.520099] md1: WRITE SAME failed. Manually zeroing.
[201014.884123] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201015.231239] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201015.969380] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201016.228747] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201016.468746] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201017.226242] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201017.226260] sd 1:0:3:0: [sdl] Unhandled error code
[201017.226263] sd 1:0:3:0: [sdl]
[201017.226264] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201017.226266] sd 1:0:3:0: [sdl] CDB:
[201017.226267] Write(16): 8a 00 00 00 00 01 0c 94 2c 08 00 00 04 00 00 00
[201017.226278] end_request: I/O error, dev sdl, sector 4506004488
[201017.226347] Buffer I/O error on device md1, logical block 563250305
[201017.226354] Buffer I/O error on device md1, logical block 563250306
[201017.226356] Buffer I/O error on device md1, logical block 563250307
[201017.226357] Buffer I/O error on device md1, logical block 563250308
[201017.226370] Buffer I/O error on device md1, logical block 563250309
[201017.226372] Buffer I/O error on device md1, logical block 563250310
[201017.226374] Buffer I/O error on device md1, logical block 563250311
[201017.226376] Buffer I/O error on device md1, logical block 563250312
[201017.226378] Buffer I/O error on device md1, logical block 563250313
[201017.226379] Buffer I/O error on device md1, logical block 563250314
[201017.226381] Buffer I/O error on device md1, logical block 563250315
[201017.226383] Buffer I/O error on device md1, logical block 563250316
[201017.226385] Buffer I/O error on device md1, logical block 563250317
[201017.226386] Buffer I/O error on device md1, logical block 563250318
[201017.226388] Buffer I/O error on device md1, logical block 563250319
[201017.226390] Buffer I/O error on device md1, logical block 563250320
[201017.226391] Buffer I/O error on device md1, logical block 563250321
[201017.226393] Buffer I/O error on device md1, logical block 563250322
[201017.226395] Buffer I/O error on device md1, logical block 563250323
[201017.226396] Buffer I/O error on device md1, logical block 563250324
[201017.226398] Buffer I/O error on device md1, logical block 563250325
[201017.226400] Buffer I/O error on device md1, logical block 563250326
[201017.226401] Buffer I/O error on device md1, logical block 563250327
[201017.226403] Buffer I/O error on device md1, logical block 563250328
[201017.226405] Buffer I/O error on device md1, logical block 563250329
[201017.226406] Buffer I/O error on device md1, logical block 563250330
[201017.226408] Buffer I/O error on device md1, logical block 563250331
[201017.226409] Buffer I/O error on device md1, logical block 563250332
[201017.226411] Buffer I/O error on device md1, logical block 563250333
[201017.226413] Buffer I/O error on device md1, logical block 563250334
[201017.226414] Buffer I/O error on device md1, logical block 563250335
[201017.226416] Buffer I/O error on device md1, logical block 563250336
[201017.226422] Buffer I/O error on device md1, logical block 563250337
[201017.226423] Buffer I/O error on device md1, logical block 563250338
[201017.226425] Buffer I/O error on device md1, logical block 563250339
[201017.226426] Buffer I/O error on device md1, logical block 563250340
[201017.226428] Buffer I/O error on device md1, logical block 563250341
[201017.226429] Buffer I/O error on device md1, logical block 563250342
[201017.226431] Buffer I/O error on device md1, logical block 563250343
[201017.226433] Buffer I/O error on device md1, logical block 563250344
[201017.226434] Buffer I/O error on device md1, logical block 563250345
[201017.226436] Buffer I/O error on device md1, logical block 563250346
[201017.226438] Buffer I/O error on device md1, logical block 563250347
[201017.226439] Buffer I/O error on device md1, logical block 563250348
[201017.226441] Buffer I/O error on device md1, logical block 563250349
[201017.226443] Buffer I/O error on device md1, logical block 563250350
[201017.226444] Buffer I/O error on device md1, logical block 563250351
[201017.226446] Buffer I/O error on device md1, logical block 563250352
[201017.226448] Buffer I/O error on device md1, logical block 563250353
[201017.226449] Buffer I/O error on device md1, logical block 563250354
[201017.226451] Buffer I/O error on device md1, logical block 563250355
[201017.226453] Buffer I/O error on device md1, logical block 563250356
[201017.226454] Buffer I/O error on device md1, logical block 563250357
[201017.226456] Buffer I/O error on device md1, logical block 563250358
[201017.226458] Buffer I/O error on device md1, logical block 563250359
[201017.226460] Buffer I/O error on device md1, logical block 563250360
[201017.226462] Buffer I/O error on device md1, logical block 563250361
[201017.226464] Buffer I/O error on device md1, logical block 563250362
[201017.226465] Buffer I/O error on device md1, logical block 563250363
[201017.226467] Buffer I/O error on device md1, logical block 563250364
[201017.226471] Buffer I/O error on device md1, logical block 563250365
[201017.226473] Buffer I/O error on device md1, logical block 563250366
[201017.226475] Buffer I/O error on device md1, logical block 563250367
[201017.226477] Buffer I/O error on device md1, logical block 563250368
[201017.226479] Buffer I/O error on device md1, logical block 563250369
[201017.226481] Buffer I/O error on device md1, logical block 563250370
[201017.226482] Buffer I/O error on device md1, logical block 563250371
[201017.226484] Buffer I/O error on device md1, logical block 563250372
[201017.226485] Buffer I/O error on device md1, logical block 563250373
[201017.226487] Buffer I/O error on device md1, logical block 563250374
[201017.226488] Buffer I/O error on device md1, logical block 563250375
[201017.226490] Buffer I/O error on device md1, logical block 563250376
[201017.226492] Buffer I/O error on device md1, logical block 563250377
[201017.226494] Buffer I/O error on device md1, logical block 563250378
[201017.226495] Buffer I/O error on device md1, logical block 563250379
[201017.226497] Buffer I/O error on device md1, logical block 563250380
[201017.226499] Buffer I/O error on device md1, logical block 563250381
[201017.226500] Buffer I/O error on device md1, logical block 563250382
[201017.226502] Buffer I/O error on device md1, logical block 563250383
[201017.226503] Buffer I/O error on device md1, logical block 563250384
[201017.226505] Buffer I/O error on device md1, logical block 563250385
[201017.226507] Buffer I/O error on device md1, logical block 563250386
[201017.226508] Buffer I/O error on device md1, logical block 563250387
[201017.226510] Buffer I/O error on device md1, logical block 563250388
[201017.226512] Buffer I/O error on device md1, logical block 563250389
[201017.226513] Buffer I/O error on device md1, logical block 563250390
[201017.226515] Buffer I/O error on device md1, logical block 563250391
[201017.226517] Buffer I/O error on device md1, logical block 563250392
[201017.226518] Buffer I/O error on device md1, logical block 563250393
[201017.226520] Buffer I/O error on device md1, logical block 563250394
[201017.226522] Buffer I/O error on device md1, logical block 563250395
[201017.226523] Buffer I/O error on device md1, logical block 563250396
[201017.226525] Buffer I/O error on device md1, logical block 563250397
[201017.226527] Buffer I/O error on device md1, logical block 563250398
[201017.226528] Buffer I/O error on device md1, logical block 563250399
[201017.226530] Buffer I/O error on device md1, logical block 563250400
[201017.226531] Buffer I/O error on device md1, logical block 563250401
[201017.226533] Buffer I/O error on device md1, logical block 563250402
[201017.226534] Buffer I/O error on device md1, logical block 563250403
[201017.226536] Buffer I/O error on device md1, logical block 563250404
[201017.226538] Buffer I/O error on device md1, logical block 563250405
[201017.226539] Buffer I/O error on device md1, logical block 563250406
[201017.226541] Buffer I/O error on device md1, logical block 563250407
[201017.226542] Buffer I/O error on device md1, logical block 563250408
[201017.226544] Buffer I/O error on device md1, logical block 563250409
[201017.226545] Buffer I/O error on device md1, logical block 563250410
[201017.226547] Buffer I/O error on device md1, logical block 563250411
[201017.226548] Buffer I/O error on device md1, logical block 563250412
[201017.226550] Buffer I/O error on device md1, logical block 563250413
[201017.226551] Buffer I/O error on device md1, logical block 563250414
[201017.226585] Buffer I/O error on device md1, logical block 563250415
[201017.226587] Buffer I/O error on device md1, logical block 563250416
[201017.226588] Buffer I/O error on device md1, logical block 563250417
[201017.226590] Buffer I/O error on device md1, logical block 563250418
[201017.226592] Buffer I/O error on device md1, logical block 563250419
[201017.226593] Buffer I/O error on device md1, logical block 563250420
[201017.226595] Buffer I/O error on device md1, logical block 563250421
[201017.226600] Buffer I/O error on device md1, logical block 563250422
[201017.226602] Buffer I/O error on device md1, logical block 563250423
[201017.226604] Buffer I/O error on device md1, logical block 563250424
[201017.226605] Buffer I/O error on device md1, logical block 563250425
[201017.226607] Buffer I/O error on device md1, logical block 563250426
[201017.226611] EXT4-fs warning (device md1): ext4_end_bio:317: I/O
error writing to inode 18743347 (offset 14163968 size 499712 starting
block 563250305)
[201017.226617] Buffer I/O error on device md1, logical block 563250427
[201017.226621] EXT4-fs warning (device md1): ext4_end_bio:317: I/O
error writing to inode 18743347 (offset 14663680 size 4096 starting
block 563250427)
[201017.226648] md1: WRITE SAME failed. Manually zeroing.
[201019.069621] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069625] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069628] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069630] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069632] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069639] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069650] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069654] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069672] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069674] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069680] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069690] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069698] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069709] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069712] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069722] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069732] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069737] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069746] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069754] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069762] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069771] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069779] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069792] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069794] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069800] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069810] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069820] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069827] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069836] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069844] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.069851] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.323242] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.323246] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.323248] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.323251] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.323278] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.323280] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.323282] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.323288] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.323294] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.323304] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.323316] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.474083] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.474086] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.474088] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.474095] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.474101] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.474109] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.474116] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.474121] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201019.474133] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201020.238965] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201020.238969] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201020.238971] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201020.238974] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201020.462458] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201020.462463] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201020.462466] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201020.706993] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201020.706996] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201020.707014] sd 1:0:3:0: [sdl] Unhandled error code
[201020.707016] sd 1:0:3:0: [sdl]
[201020.707017] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201020.707019] sd 1:0:3:0: [sdl] CDB:
[201020.707020] Read(16): 88 00 00 00 00 00 40 c1 7b d0 00 00 00 08 00 00
[201020.707031] end_request: I/O error, dev sdl, sector 1086421968
[201020.707055] sd 1:0:3:0: [sdl] Unhandled error code
[201020.707057] sd 1:0:3:0: [sdl]
[201020.707058] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201020.707060] sd 1:0:3:0: [sdl] CDB:
[201020.707061] Write(16): 8a 00 00 00 00 01 0d 18 91 08 00 00 00 08 00 00
[201020.707070] end_request: I/O error, dev sdl, sector 4514681096
[201020.707347] md1: WRITE SAME failed. Manually zeroing.
[201033.676383] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201033.933136] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201034.181895] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201034.930676] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201035.180340] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201035.429879] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201035.429897] sd 1:0:3:0: [sdl] Unhandled error code
[201035.429898] sd 1:0:3:0: [sdl]
[201035.429900] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201035.429901] sd 1:0:3:0: [sdl] CDB:
[201035.429902] Write(16): 8a 00 00 00 00 01 0d 18 af f8 00 00 00 08 00 00
[201035.429918] end_request: I/O error, dev sdl, sector 4514689016
[201035.429995] md1: WRITE SAME failed. Manually zeroing.
[201036.319080] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201036.678211] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201037.425621] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201037.675013] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201037.924389] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201043.886771] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201044.157104] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201044.378908] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201045.152459] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201045.263326] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201045.263329] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201045.263331] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201045.384835] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201045.384840] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201045.384842] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201045.384844] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201045.384875] sd 1:0:3:0: [sdl] Unhandled error code
[201045.384877] sd 1:0:3:0: [sdl]
[201045.384878] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201045.384879] sd 1:0:3:0: [sdl] CDB:
[201045.384880] Write(16): 8a 00 00 00 00 00 a4 f0 b7 20 00 00 00 08 00 00
[201045.384889] end_request: I/O error, dev sdl, sector 2767238944
[201045.384926] md1: WRITE SAME failed. Manually zeroing.
[201046.920479] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201047.149521] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201047.399138] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201048.146985] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201048.396319] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201048.645720] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201048.645735] sd 1:0:3:0: [sdl] Unhandled error code
[201048.645737] sd 1:0:3:0: [sdl]
[201048.645738] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201048.645739] sd 1:0:3:0: [sdl] CDB:
[201048.645740] Write(16): 8a 00 00 00 00 01 0d 1a 47 e8 00 00 00 18 00 00
[201048.645749] end_request: I/O error, dev sdl, sector 4514793448
[201048.645814] md1: WRITE SAME failed. Manually zeroing.
[201056.138127] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201056.138134] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201056.138138] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201056.138140] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201056.138142] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201056.138154] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201056.138157] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201056.138163] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201056.138169] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201056.389470] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201056.389475] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201056.389477] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201056.389478] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201056.389482] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201056.648327] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201056.648331] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201057.354491] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201057.621658] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201057.872648] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201057.872666] sd 1:0:3:0: [sdl] Unhandled error code
[201057.872669] sd 1:0:3:0: [sdl]
[201057.872670] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201057.872672] sd 1:0:3:0: [sdl] CDB:
[201057.872673] Write(16): 8a 00 00 00 00 01 0d 18 bf f8 00 00 00 08 00 00
[201057.872684] end_request: I/O error, dev sdl, sector 4514693112
[201057.872766] md1: WRITE SAME failed. Manually zeroing.
[201058.631704] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201058.631708] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201058.631710] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201058.866237] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201058.866241] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201059.114862] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201059.867809] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201060.117011] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201060.366964] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201060.366977] sd 1:0:3:0: [sdl] Unhandled error code
[201060.366980] sd 1:0:3:0: [sdl]
[201060.366981] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201060.366983] sd 1:0:3:0: [sdl] CDB:
[201060.366984] Write(16): 8a 00 00 00 00 01 0d 19 75 c8 00 00 00 08 00 00
[201060.366995] end_request: I/O error, dev sdl, sector 4514739656
[201060.367057] md1: WRITE SAME failed. Manually zeroing.
[201061.149294] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201061.364089] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201061.613253] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201062.098625] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201062.361579] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201062.469717] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201062.469734] sd 1:0:3:0: [sdl] Unhandled error code
[201062.469735] sd 1:0:3:0: [sdl]
[201062.469736] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201062.469738] sd 1:0:3:0: [sdl] CDB:
[201062.469739] Write(16): 8a 00 00 00 00 00 6d b4 c9 78 00 00 00 08 00 00
[201062.469747] end_request: I/O error, dev sdl, sector 1840564600
[201062.469837] md1: WRITE SAME failed. Manually zeroing.
[201082.394896] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201082.560842] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201082.810385] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201083.634781] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201083.807682] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201084.058302] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201084.058318] sd 1:0:3:0: [sdl] Unhandled error code
[201084.058321] sd 1:0:3:0: [sdl]
[201084.058322] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201084.058324] sd 1:0:3:0: [sdl] CDB:
[201084.058325] Write(16): 8a 00 00 00 00 01 0d 1e 98 00 00 00 00 08 00 00
[201084.058335] end_request: I/O error, dev sdl, sector 4515076096
[201084.058421] md1: WRITE SAME failed. Manually zeroing.
[201093.219162] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201093.219166] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201093.219169] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201093.219171] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201093.534630] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201093.534634] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201093.534636] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201094.263033] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201094.263037] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201094.551548] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201094.780281] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201095.528403] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201095.528417] sd 1:0:3:0: [sdl] Unhandled error code
[201095.528419] sd 1:0:3:0: [sdl]
[201095.528420] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201095.528421] sd 1:0:3:0: [sdl] CDB:
[201095.528423] Write(16): 8a 00 00 00 00 00 6d b4 c9 90 00 00 00 08 00 00
[201095.528431] end_request: I/O error, dev sdl, sector 1840564624
[201095.528529] md1: WRITE SAME failed. Manually zeroing.
[201097.041428] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201097.274045] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201097.524446] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201098.271546] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201098.520929] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201098.770309] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201098.770325] sd 1:0:3:0: [sdl] Unhandled error code
[201098.770327] sd 1:0:3:0: [sdl]
[201098.770329] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201098.770331] sd 1:0:3:0: [sdl] CDB:
[201098.770332] Write(16): 8a 00 00 00 00 01 0d 1d 57 f8 00 00 00 08 00 00
[201098.770343] end_request: I/O error, dev sdl, sector 4514994168
[201098.770414] md1: WRITE SAME failed. Manually zeroing.
[201134.131052] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201134.131058] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201134.131061] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201134.131063] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201134.131070] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201134.131076] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201134.131100] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201134.131104] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201134.131106] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201134.131110] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201134.131112] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201134.131118] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201134.131126] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201134.461654] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201134.461658] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201134.461662] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201134.461664] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201134.461671] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201134.461677] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201134.461689] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201134.461692] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201134.461701] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201135.178417] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201135.178424] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201135.178427] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201135.178431] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201135.178434] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201135.178439] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201135.178442] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201135.178445] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201135.450239] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201135.450243] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201135.450246] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201135.450248] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201135.662682] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201135.662687] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201135.662689] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201136.410598] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201136.410602] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201136.410606] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201136.410622] sd 1:0:3:0: [sdl] Unhandled error code
[201136.410624] sd 1:0:3:0: [sdl]
[201136.410626] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201136.410628] sd 1:0:3:0: [sdl] CDB:
[201136.410629] Write(16): 8a 00 00 00 00 01 0d 22 1c 00 00 00 04 00 00 00
[201136.410640] end_request: I/O error, dev sdl, sector 4515306496
[201136.410668] sd 1:0:3:0: [sdl] Unhandled error code
[201136.410670] sd 1:0:3:0: [sdl]
[201136.410671] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201136.410673] sd 1:0:3:0: [sdl] CDB:
[201136.410674] Write(16): 8a 00 00 00 00 01 0d 21 d4 00 00 00 04 00 00 00
[201136.410683] end_request: I/O error, dev sdl, sector 4515288064
[201136.410717] Buffer I/O error on device md1, logical block 564413056
[201136.410725] Buffer I/O error on device md1, logical block 564413057
[201136.410729] Buffer I/O error on device md1, logical block 564413058
[201136.410731] Buffer I/O error on device md1, logical block 564413059
[201136.410733] Buffer I/O error on device md1, logical block 564413060
[201136.410735] Buffer I/O error on device md1, logical block 564413061
[201136.410737] Buffer I/O error on device md1, logical block 564413062
[201136.410738] Buffer I/O error on device md1, logical block 564413063
[201136.410740] Buffer I/O error on device md1, logical block 564413064
[201136.410742] Buffer I/O error on device md1, logical block 564413065
[201136.410743] Buffer I/O error on device md1, logical block 564413066
[201136.410745] Buffer I/O error on device md1, logical block 564413067
[201136.410747] Buffer I/O error on device md1, logical block 564413068
[201136.410748] Buffer I/O error on device md1, logical block 564413069
[201136.410750] Buffer I/O error on device md1, logical block 564413070
[201136.410751] Buffer I/O error on device md1, logical block 564413071
[201136.410753] Buffer I/O error on device md1, logical block 564413072
[201136.410755] Buffer I/O error on device md1, logical block 564413073
[201136.410756] Buffer I/O error on device md1, logical block 564413074
[201136.410758] Buffer I/O error on device md1, logical block 564413075
[201136.410760] Buffer I/O error on device md1, logical block 564413076
[201136.410762] Buffer I/O error on device md1, logical block 564413077
[201136.410763] Buffer I/O error on device md1, logical block 564413078
[201136.410765] Buffer I/O error on device md1, logical block 564413079
[201136.410767] Buffer I/O error on device md1, logical block 564413080
[201136.410768] Buffer I/O error on device md1, logical block 564413081
[201136.410770] Buffer I/O error on device md1, logical block 564413082
[201136.410771] Buffer I/O error on device md1, logical block 564413083
[201136.410777] Buffer I/O error on device md1, logical block 564413084
[201136.410778] Buffer I/O error on device md1, logical block 564413085
[201136.410780] Buffer I/O error on device md1, logical block 564413086
[201136.410782] Buffer I/O error on device md1, logical block 564413087
[201136.410783] Buffer I/O error on device md1, logical block 564413088
[201136.410785] Buffer I/O error on device md1, logical block 564413089
[201136.410786] Buffer I/O error on device md1, logical block 564413090
[201136.410788] Buffer I/O error on device md1, logical block 564413091
[201136.410790] Buffer I/O error on device md1, logical block 564413092
[201136.410791] Buffer I/O error on device md1, logical block 564413093
[201136.410793] Buffer I/O error on device md1, logical block 564413094
[201136.410794] Buffer I/O error on device md1, logical block 564413095
[201136.410796] Buffer I/O error on device md1, logical block 564413096
[201136.410798] Buffer I/O error on device md1, logical block 564413097
[201136.410799] Buffer I/O error on device md1, logical block 564413098
[201136.410801] Buffer I/O error on device md1, logical block 564413099
[201136.410803] Buffer I/O error on device md1, logical block 564413100
[201136.410804] Buffer I/O error on device md1, logical block 564413101
[201136.410806] Buffer I/O error on device md1, logical block 564413102
[201136.410807] Buffer I/O error on device md1, logical block 564413103
[201136.410809] Buffer I/O error on device md1, logical block 564413104
[201136.410811] Buffer I/O error on device md1, logical block 564413105
[201136.410812] Buffer I/O error on device md1, logical block 564413106
[201136.410814] Buffer I/O error on device md1, logical block 564413107
[201136.410816] Buffer I/O error on device md1, logical block 564413108
[201136.410817] Buffer I/O error on device md1, logical block 564413109
[201136.410819] Buffer I/O error on device md1, logical block 564413110
[201136.410821] Buffer I/O error on device md1, logical block 564413111
[201136.410823] Buffer I/O error on device md1, logical block 564413112
[201136.410824] Buffer I/O error on device md1, logical block 564413113
[201136.410826] Buffer I/O error on device md1, logical block 564413114
[201136.410830] Buffer I/O error on device md1, logical block 564413115
[201136.410832] Buffer I/O error on device md1, logical block 564413116
[201136.410834] Buffer I/O error on device md1, logical block 564413117
[201136.410836] Buffer I/O error on device md1, logical block 564413118
[201136.410837] Buffer I/O error on device md1, logical block 564413119
[201136.410839] Buffer I/O error on device md1, logical block 564413120
[201136.410841] Buffer I/O error on device md1, logical block 564413121
[201136.410843] Buffer I/O error on device md1, logical block 564413122
[201136.410844] Buffer I/O error on device md1, logical block 564413123
[201136.410846] Buffer I/O error on device md1, logical block 564413124
[201136.410847] Buffer I/O error on device md1, logical block 564413125
[201136.410849] Buffer I/O error on device md1, logical block 564413126
[201136.410850] Buffer I/O error on device md1, logical block 564413127
[201136.410852] Buffer I/O error on device md1, logical block 564413128
[201136.410853] Buffer I/O error on device md1, logical block 564413129
[201136.410855] Buffer I/O error on device md1, logical block 564413130
[201136.410857] Buffer I/O error on device md1, logical block 564413131
[201136.410858] Buffer I/O error on device md1, logical block 564413132
[201136.410859] Buffer I/O error on device md1, logical block 564413133
[201136.410861] Buffer I/O error on device md1, logical block 564413134
[201136.410862] Buffer I/O error on device md1, logical block 564413135
[201136.410864] Buffer I/O error on device md1, logical block 564413136
[201136.410865] Buffer I/O error on device md1, logical block 564413137
[201136.410867] Buffer I/O error on device md1, logical block 564413138
[201136.410868] Buffer I/O error on device md1, logical block 564413139
[201136.410870] Buffer I/O error on device md1, logical block 564413140
[201136.410872] Buffer I/O error on device md1, logical block 564413141
[201136.410873] Buffer I/O error on device md1, logical block 564413142
[201136.410875] Buffer I/O error on device md1, logical block 564413143
[201136.410876] Buffer I/O error on device md1, logical block 564413144
[201136.410878] Buffer I/O error on device md1, logical block 564413145
[201136.410879] Buffer I/O error on device md1, logical block 564413146
[201136.410881] Buffer I/O error on device md1, logical block 564413147
[201136.410882] Buffer I/O error on device md1, logical block 564413148
[201136.410884] Buffer I/O error on device md1, logical block 564413149
[201136.410885] Buffer I/O error on device md1, logical block 564413150
[201136.410887] Buffer I/O error on device md1, logical block 564413151
[201136.410888] Buffer I/O error on device md1, logical block 564413152
[201136.410890] Buffer I/O error on device md1, logical block 564413153
[201136.410891] Buffer I/O error on device md1, logical block 564413154
[201136.410893] Buffer I/O error on device md1, logical block 564413155
[201136.410894] Buffer I/O error on device md1, logical block 564413156
[201136.410896] Buffer I/O error on device md1, logical block 564413157
[201136.410897] Buffer I/O error on device md1, logical block 564413158
[201136.410899] Buffer I/O error on device md1, logical block 564413159
[201136.410900] Buffer I/O error on device md1, logical block 564413160
[201136.410902] Buffer I/O error on device md1, logical block 564413161
[201136.410903] Buffer I/O error on device md1, logical block 564413162
[201136.410905] Buffer I/O error on device md1, logical block 564413163
[201136.410906] Buffer I/O error on device md1, logical block 564413164
[201136.410908] Buffer I/O error on device md1, logical block 564413165
[201136.410909] Buffer I/O error on device md1, logical block 564413166
[201136.410911] Buffer I/O error on device md1, logical block 564413167
[201136.410912] Buffer I/O error on device md1, logical block 564413168
[201136.410914] Buffer I/O error on device md1, logical block 564413169
[201136.410915] Buffer I/O error on device md1, logical block 564413170
[201136.410919] Buffer I/O error on device md1, logical block 564413171
[201136.410921] Buffer I/O error on device md1, logical block 564413172
[201136.410923] Buffer I/O error on device md1, logical block 564413173
[201136.410925] Buffer I/O error on device md1, logical block 564413174
[201136.410926] Buffer I/O error on device md1, logical block 564413175
[201136.410928] Buffer I/O error on device md1, logical block 564413176
[201136.410930] Buffer I/O error on device md1, logical block 564413177
[201136.410932] Buffer I/O error on device md1, logical block 564413178
[201136.410933] Buffer I/O error on device md1, logical block 564413179
[201136.410935] Buffer I/O error on device md1, logical block 564413180
[201136.410937] Buffer I/O error on device md1, logical block 564413181
[201136.410938] Buffer I/O error on device md1, logical block 564413182
[201136.410942] EXT4-fs warning (device md1): ext4_end_bio:317: I/O
error writing to inode 18743347 (offset 142086144 size 520192 starting
block 564413056)
[201136.410955] Buffer I/O error on device md1, logical block 564410752
[201136.410957] Buffer I/O error on device md1, logical block 564410753
[201136.410959] Buffer I/O error on device md1, logical block 564410754
[201136.410960] Buffer I/O error on device md1, logical block 564410755
[201136.410962] Buffer I/O error on device md1, logical block 564410756
[201136.410964] Buffer I/O error on device md1, logical block 564410757
[201136.410965] Buffer I/O error on device md1, logical block 564410758
[201136.410967] Buffer I/O error on device md1, logical block 564410759
[201136.410968] Buffer I/O error on device md1, logical block 564410760
[201136.410970] Buffer I/O error on device md1, logical block 564410761
[201136.410971] Buffer I/O error on device md1, logical block 564410762
[201136.410973] Buffer I/O error on device md1, logical block 564410763
[201136.410975] Buffer I/O error on device md1, logical block 564410764
[201136.410976] Buffer I/O error on device md1, logical block 564410765
[201136.410978] Buffer I/O error on device md1, logical block 564410766
[201136.410979] Buffer I/O error on device md1, logical block 564410767
[201136.410981] Buffer I/O error on device md1, logical block 564410768
[201136.410982] Buffer I/O error on device md1, logical block 564410769
[201136.410984] Buffer I/O error on device md1, logical block 564410770
[201136.410986] Buffer I/O error on device md1, logical block 564410771
[201136.410987] Buffer I/O error on device md1, logical block 564410772
[201136.410989] Buffer I/O error on device md1, logical block 564410773
[201136.410991] Buffer I/O error on device md1, logical block 564410774
[201136.410992] Buffer I/O error on device md1, logical block 564410775
[201136.410994] Buffer I/O error on device md1, logical block 564410776
[201136.410995] Buffer I/O error on device md1, logical block 564410777
[201136.410997] Buffer I/O error on device md1, logical block 564410778
[201136.410999] Buffer I/O error on device md1, logical block 564410779
[201136.411000] Buffer I/O error on device md1, logical block 564410780
[201136.411002] Buffer I/O error on device md1, logical block 564410781
[201136.411003] Buffer I/O error on device md1, logical block 564410782
[201136.411005] Buffer I/O error on device md1, logical block 564410783
[201136.411007] Buffer I/O error on device md1, logical block 564410784
[201136.411008] Buffer I/O error on device md1, logical block 564410785
[201136.411010] Buffer I/O error on device md1, logical block 564410786
[201136.411012] Buffer I/O error on device md1, logical block 564410787
[201136.411013] Buffer I/O error on device md1, logical block 564410788
[201136.411015] Buffer I/O error on device md1, logical block 564410789
[201136.411017] Buffer I/O error on device md1, logical block 564410790
[201136.411018] Buffer I/O error on device md1, logical block 564410791
[201136.411020] Buffer I/O error on device md1, logical block 564410792
[201136.411021] Buffer I/O error on device md1, logical block 564410793
[201136.411023] Buffer I/O error on device md1, logical block 564410794
[201136.411027] Buffer I/O error on device md1, logical block 564410795
[201136.411029] Buffer I/O error on device md1, logical block 564410796
[201136.411031] Buffer I/O error on device md1, logical block 564410797
[201136.411033] Buffer I/O error on device md1, logical block 564410798
[201136.411034] Buffer I/O error on device md1, logical block 564410799
[201136.411036] Buffer I/O error on device md1, logical block 564410800
[201136.411038] Buffer I/O error on device md1, logical block 564410801
[201136.411039] Buffer I/O error on device md1, logical block 564410802
[201136.411041] Buffer I/O error on device md1, logical block 564410803
[201136.411042] Buffer I/O error on device md1, logical block 564410804
[201136.411044] Buffer I/O error on device md1, logical block 564410805
[201136.411046] Buffer I/O error on device md1, logical block 564410806
[201136.411047] Buffer I/O error on device md1, logical block 564410807
[201136.411049] Buffer I/O error on device md1, logical block 564410808
[201136.411051] Buffer I/O error on device md1, logical block 564410809
[201136.411052] Buffer I/O error on device md1, logical block 564410810
[201136.411054] Buffer I/O error on device md1, logical block 564410811
[201136.411055] Buffer I/O error on device md1, logical block 564410812
[201136.411057] Buffer I/O error on device md1, logical block 564410813
[201136.411059] Buffer I/O error on device md1, logical block 564410814
[201136.411060] Buffer I/O error on device md1, logical block 564410815
[201136.411062] Buffer I/O error on device md1, logical block 564410816
[201136.411064] Buffer I/O error on device md1, logical block 564410817
[201136.411065] Buffer I/O error on device md1, logical block 564410818
[201136.411067] Buffer I/O error on device md1, logical block 564410819
[201136.411069] Buffer I/O error on device md1, logical block 564410820
[201136.411070] Buffer I/O error on device md1, logical block 564410821
[201136.411072] Buffer I/O error on device md1, logical block 564410822
[201136.411073] Buffer I/O error on device md1, logical block 564410823
[201136.411075] Buffer I/O error on device md1, logical block 564410824
[201136.411076] Buffer I/O error on device md1, logical block 564410825
[201136.411078] Buffer I/O error on device md1, logical block 564410826
[201136.411080] Buffer I/O error on device md1, logical block 564410827
[201136.411081] Buffer I/O error on device md1, logical block 564410828
[201136.411083] Buffer I/O error on device md1, logical block 564410829
[201136.411084] Buffer I/O error on device md1, logical block 564410830
[201136.411086] Buffer I/O error on device md1, logical block 564410831
[201136.411088] Buffer I/O error on device md1, logical block 564410832
[201136.411089] Buffer I/O error on device md1, logical block 564410833
[201136.411091] Buffer I/O error on device md1, logical block 564410834
[201136.411092] Buffer I/O error on device md1, logical block 564410835
[201136.411094] Buffer I/O error on device md1, logical block 564410836
[201136.411096] Buffer I/O error on device md1, logical block 564410837
[201136.411097] Buffer I/O error on device md1, logical block 564410838
[201136.411099] Buffer I/O error on device md1, logical block 564410839
[201136.411100] Buffer I/O error on device md1, logical block 564410840
[201136.411102] Buffer I/O error on device md1, logical block 564410841
[201136.411104] Buffer I/O error on device md1, logical block 564410842
[201136.411105] Buffer I/O error on device md1, logical block 564410843
[201136.411107] Buffer I/O error on device md1, logical block 564410844
[201136.411108] Buffer I/O error on device md1, logical block 564410845
[201136.411110] Buffer I/O error on device md1, logical block 564410846
[201136.411112] Buffer I/O error on device md1, logical block 564410847
[201136.411113] Buffer I/O error on device md1, logical block 564410848
[201136.411115] Buffer I/O error on device md1, logical block 564410849
[201136.411117] Buffer I/O error on device md1, logical block 564410850
[201136.411119] Buffer I/O error on device md1, logical block 564410851
[201136.411123] Buffer I/O error on device md1, logical block 564410852
[201136.411125] Buffer I/O error on device md1, logical block 564410853
[201136.411127] Buffer I/O error on device md1, logical block 564410854
[201136.411128] Buffer I/O error on device md1, logical block 564410855
[201136.411130] Buffer I/O error on device md1, logical block 564410856
[201136.411131] Buffer I/O error on device md1, logical block 564410857
[201136.411133] Buffer I/O error on device md1, logical block 564410858
[201136.411135] Buffer I/O error on device md1, logical block 564410859
[201136.411140] md1: WRITE SAME failed. Manually zeroing.
[201136.411143] Buffer I/O error on device md1, logical block 564410860
[201136.411145] Buffer I/O error on device md1, logical block 564410861
[201136.411146] Buffer I/O error on device md1, logical block 564410862
[201136.411148] Buffer I/O error on device md1, logical block 564410863
[201136.411149] Buffer I/O error on device md1, logical block 564410864
[201136.411151] Buffer I/O error on device md1, logical block 564410865
[201136.411152] Buffer I/O error on device md1, logical block 564410866
[201136.411154] Buffer I/O error on device md1, logical block 564410867
[201136.411156] Buffer I/O error on device md1, logical block 564410868
[201136.411157] Buffer I/O error on device md1, logical block 564410869
[201136.411159] Buffer I/O error on device md1, logical block 564410870
[201136.411160] Buffer I/O error on device md1, logical block 564410871
[201136.411162] Buffer I/O error on device md1, logical block 564410872
[201136.411163] Buffer I/O error on device md1, logical block 564410873
[201136.411165] Buffer I/O error on device md1, logical block 564410874
[201136.411167] Buffer I/O error on device md1, logical block 564410875
[201136.411168] Buffer I/O error on device md1, logical block 564410876
[201136.411170] Buffer I/O error on device md1, logical block 564410877
[201136.411171] Buffer I/O error on device md1, logical block 564410878
[201136.411173] Buffer I/O error on device md1, logical block 564410879
[201136.411177] EXT4-fs warning (device md1): ext4_end_bio:317: I/O
error writing to inode 18743347 (offset 137891840 size 524288 starting
block 564410752)
[201160.725031] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201160.864933] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201161.114315] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201161.862428] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201162.111764] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201162.361145] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201162.361165] sd 1:0:3:0: [sdl] Unhandled error code
[201162.361167] sd 1:0:3:0: [sdl]
[201162.361168] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201162.361170] sd 1:0:3:0: [sdl] CDB:
[201162.361171] Write(16): 8a 00 00 00 00 01 0d 22 47 f0 00 00 00 08 00 00
[201162.361179] end_request: I/O error, dev sdl, sector 4515317744
[201162.361241] md1: WRITE SAME failed. Manually zeroing.
[201164.142151] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201164.356185] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201164.607325] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201165.354217] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201165.603101] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201165.852571] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201165.852590] sd 1:0:3:0: [sdl] Unhandled error code
[201165.852592] sd 1:0:3:0: [sdl]
[201165.852593] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201165.852604] sd 1:0:3:0: [sdl] CDB:
[201165.852606] Write(16): 8a 00 00 00 00 01 0d 22 67 f0 00 00 00 08 00 00
[201165.852614] end_request: I/O error, dev sdl, sector 4515325936
[201165.852693] md1: WRITE SAME failed. Manually zeroing.
[201166.692326] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201166.849945] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201167.099337] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201167.847472] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201168.098743] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201168.346521] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201168.346538] sd 1:0:3:0: [sdl] Unhandled error code
[201168.346539] sd 1:0:3:0: [sdl]
[201168.346541] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201168.346542] sd 1:0:3:0: [sdl] CDB:
[201168.346543] Write(16): 8a 00 00 00 00 01 0d 22 9f f8 00 00 00 10 00 00
[201168.346551] end_request: I/O error, dev sdl, sector 4515340280
[201168.346615] md1: WRITE SAME failed. Manually zeroing.
[201597.828255] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201598.031546] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201598.280580] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201599.028626] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201599.277997] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201599.527352] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201599.527376] sd 1:0:3:0: [sdl] Unhandled error code
[201599.527379] sd 1:0:3:0: [sdl]
[201599.527380] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201599.527382] sd 1:0:3:0: [sdl] CDB:
[201599.527383] Write(16): 8a 00 00 00 00 00 6d b4 c9 98 00 00 00 08 00 00
[201599.527394] end_request: I/O error, dev sdl, sector 1840564632
[201599.527460] md1: WRITE SAME failed. Manually zeroing.
[201602.300346] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201602.519907] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201602.770164] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201603.517424] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201603.767187] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201604.016099] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201604.016113] sd 1:0:3:0: [sdl] Unhandled error code
[201604.016115] sd 1:0:3:0: [sdl]
[201604.016116] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201604.016118] sd 1:0:3:0: [sdl] CDB:
[201604.016119] Write(16): 8a 00 00 00 00 00 6d b4 c9 a0 00 00 00 08 00 00
[201604.016127] end_request: I/O error, dev sdl, sector 1840564640
[201604.016204] md1: WRITE SAME failed. Manually zeroing.
[201629.093836] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201629.203107] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201629.452489] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201630.200636] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201630.450051] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201630.699390] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201630.699405] sd 1:0:3:0: [sdl] Unhandled error code
[201630.699416] sd 1:0:3:0: [sdl]
[201630.699417] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201630.699419] sd 1:0:3:0: [sdl] CDB:
[201630.699420] Write(16): 8a 00 00 00 00 00 6d b4 c9 b0 00 00 00 08 00 00
[201630.699428] end_request: I/O error, dev sdl, sector 1840564656
[201630.699501] md1: WRITE SAME failed. Manually zeroing.
[201894.867463] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201894.867467] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201894.867468] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201895.045994] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201895.045998] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201895.278104] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201896.038824] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201896.295353] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201896.545128] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201896.545147] sd 1:0:3:0: [sdl] Unhandled error code
[201896.545149] sd 1:0:3:0: [sdl]
[201896.545150] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201896.545151] sd 1:0:3:0: [sdl] CDB:
[201896.545152] Write(16): 8a 00 00 00 00 00 a4 2e 25 90 00 00 00 08 00 00
[201896.545160] end_request: I/O error, dev sdl, sector 2754487696
[201896.545258] md1: WRITE SAME failed. Manually zeroing.
[201928.676225] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201928.676230] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201928.676233] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201928.676235] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201928.676242] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201928.676248] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201928.676263] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201928.676267] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201928.676277] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201928.676286] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201928.676295] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201928.676308] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201928.676310] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201928.676316] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201928.676327] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201928.676338] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201928.676342] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201928.676354] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201928.676362] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201928.987785] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201928.987790] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201929.692766] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201929.957150] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201930.210196] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201930.958153] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201930.958178] sd 1:0:3:0: [sdl] Unhandled error code
[201930.958180] sd 1:0:3:0: [sdl]
[201930.958181] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201930.958183] sd 1:0:3:0: [sdl] CDB:
[201930.958184] Write(16): 8a 00 00 00 00 00 a4 2e 25 98 00 00 00 08 00 00
[201930.958192] end_request: I/O error, dev sdl, sector 2754487704
[201930.958278] md1: WRITE SAME failed. Manually zeroing.
[201932.599655] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599658] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599660] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599664] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599673] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599685] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599688] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599699] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599709] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599718] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599724] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599734] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599737] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599751] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599759] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599767] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599776] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599779] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599789] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599799] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599806] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599814] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599822] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599829] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599832] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599844] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599852] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599859] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201932.599868] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201933.045578] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201933.045583] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201933.045586] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201933.045589] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201933.045610] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201933.045613] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201933.045616] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201933.045626] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201933.045635] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201933.045653] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201933.045663] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201933.045665] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201933.747605] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201933.747609] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201933.747611] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201933.932829] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201933.932833] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201934.181694] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201934.181698] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201934.953390] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201934.953408] sd 1:0:3:0: [sdl] Unhandled error code
[201934.953410] sd 1:0:3:0: [sdl]
[201934.953411] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201934.953413] sd 1:0:3:0: [sdl] CDB:
[201934.953414] Write(16): 8a 00 00 00 00 00 a4 2e 25 a0 00 00 00 08 00 00
[201934.953422] end_request: I/O error, dev sdl, sector 2754487712
[201934.953509] md1: WRITE SAME failed. Manually zeroing.
[201935.220817] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201935.446917] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201936.195035] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201936.444435] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201936.693785] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201937.441964] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201937.441982] sd 1:0:3:0: [sdl] Unhandled error code
[201937.441984] sd 1:0:3:0: [sdl]
[201937.441986] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201937.441987] sd 1:0:3:0: [sdl] CDB:
[201937.441989] Write(16): 8a 00 00 00 00 00 a4 2e 25 a8 00 00 00 08 00 00
[201937.441999] end_request: I/O error, dev sdl, sector 2754487720
[201937.442088] md1: WRITE SAME failed. Manually zeroing.
[201937.726193] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201937.940658] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201938.688771] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201938.938363] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201939.187541] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201939.935712] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201939.935729] sd 1:0:3:0: [sdl] Unhandled error code
[201939.935731] sd 1:0:3:0: [sdl]
[201939.935732] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201939.935733] sd 1:0:3:0: [sdl] CDB:
[201939.935734] Write(16): 8a 00 00 00 00 00 a4 2e 25 b0 00 00 00 08 00 00
[201939.935742] end_request: I/O error, dev sdl, sector 2754487728
[201939.935817] md1: WRITE SAME failed. Manually zeroing.
[201940.252497] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201940.434766] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201941.182533] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201941.432104] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201941.681315] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201942.464582] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201942.464602] sd 1:0:3:0: [sdl] Unhandled error code
[201942.464604] sd 1:0:3:0: [sdl]
[201942.464605] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201942.464606] sd 1:0:3:0: [sdl] CDB:
[201942.464608] Write(16): 8a 00 00 00 00 00 a4 2e 25 b8 00 00 00 08 00 00
[201942.464616] end_request: I/O error, dev sdl, sector 2754487736
[201942.464745] md1: WRITE SAME failed. Manually zeroing.
[201942.710685] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201942.928954] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201943.676953] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201943.925949] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201944.175038] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201944.924890] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201944.924916] sd 1:0:3:0: [sdl] Unhandled error code
[201944.924918] sd 1:0:3:0: [sdl]
[201944.924919] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201944.924920] sd 1:0:3:0: [sdl] CDB:
[201944.924921] Write(16): 8a 00 00 00 00 00 a4 2e 25 c0 00 00 00 08 00 00
[201944.924930] end_request: I/O error, dev sdl, sector 2754487744
[201944.925057] md1: WRITE SAME failed. Manually zeroing.
[201945.237835] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201945.421974] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201946.170499] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201946.419598] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201946.668841] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201947.416941] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201947.416961] sd 1:0:3:0: [sdl] Unhandled error code
[201947.416963] sd 1:0:3:0: [sdl]
[201947.416964] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201947.416965] sd 1:0:3:0: [sdl] CDB:
[201947.416966] Write(16): 8a 00 00 00 00 00 a4 2e 25 c8 00 00 00 08 00 00
[201947.416974] end_request: I/O error, dev sdl, sector 2754487752
[201947.417070] md1: WRITE SAME failed. Manually zeroing.
[201947.706727] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201947.915752] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201948.663805] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201948.913190] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201949.162578] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201949.910702] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201949.910719] sd 1:0:3:0: [sdl] Unhandled error code
[201949.910721] sd 1:0:3:0: [sdl]
[201949.910722] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201949.910724] sd 1:0:3:0: [sdl] CDB:
[201949.910725] Write(16): 8a 00 00 00 00 00 a4 2e 25 d0 00 00 00 08 00 00
[201949.910733] end_request: I/O error, dev sdl, sector 2754487760
[201949.910808] md1: WRITE SAME failed. Manually zeroing.
[201950.234108] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201950.409469] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201951.157594] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201951.408140] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201951.657015] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201951.879678] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201951.879696] sd 1:0:3:0: [sdl] Unhandled error code
[201951.879698] sd 1:0:3:0: [sdl]
[201951.879699] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201951.879701] sd 1:0:3:0: [sdl] CDB:
[201951.879702] Write(16): 8a 00 00 00 00 00 a4 2e 25 d8 00 00 00 08 00 00
[201951.879710] end_request: I/O error, dev sdl, sector 2754487768
[201951.879798] md1: WRITE SAME failed. Manually zeroing.
[201952.744348] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201952.744353] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201952.902837] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201953.151529] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201953.151535] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201953.897771] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201954.148554] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201954.399618] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201954.399634] sd 1:0:3:0: [sdl] Unhandled error code
[201954.399636] sd 1:0:3:0: [sdl]
[201954.399638] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201954.399640] sd 1:0:3:0: [sdl] CDB:
[201954.399641] Write(16): 8a 00 00 00 00 00 a4 2e 25 e0 00 00 00 08 00 00
[201954.399652] end_request: I/O error, dev sdl, sector 2754487776
[201954.399709] md1: WRITE SAME failed. Manually zeroing.
[201955.196617] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201955.196620] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201955.196624] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201955.380135] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201955.380138] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201955.640057] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201955.640061] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201956.387074] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201956.638747] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201956.889297] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201956.889312] sd 1:0:3:0: [sdl] Unhandled error code
[201956.889314] sd 1:0:3:0: [sdl]
[201956.889315] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201956.889316] sd 1:0:3:0: [sdl] CDB:
[201956.889317] Write(16): 8a 00 00 00 00 00 a4 2e 25 e8 00 00 00 08 00 00
[201956.889326] end_request: I/O error, dev sdl, sector 2754487784
[201956.889371] md1: WRITE SAME failed. Manually zeroing.
[201957.731098] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201957.731102] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201957.731105] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201957.731107] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201957.874171] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201957.874174] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201957.874177] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201958.138239] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201958.138244] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201958.138246] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201958.138249] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201958.872120] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201958.872124] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201958.872127] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201959.135503] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201959.135507] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201959.385302] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201959.385318] sd 1:0:3:0: [sdl] Unhandled error code
[201959.385319] sd 1:0:3:0: [sdl]
[201959.385320] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201959.385322] sd 1:0:3:0: [sdl] CDB:
[201959.385323] Write(16): 8a 00 00 00 00 00 a4 2e 25 f0 00 00 00 08 00 00
[201959.385331] end_request: I/O error, dev sdl, sector 2754487792
[201959.385411] md1: WRITE SAME failed. Manually zeroing.
[201960.167713] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201960.167719] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201960.167721] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201960.368085] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201960.368092] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201960.616709] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201960.616713] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201961.364882] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201961.364888] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201961.631512] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201961.881716] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201961.881719] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201961.881722] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201961.881745] sd 1:0:3:0: [sdl] Unhandled error code
[201961.881747] sd 1:0:3:0: [sdl]
[201961.881748] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201961.881750] sd 1:0:3:0: [sdl] CDB:
[201961.881751] Write(16): 8a 00 00 00 00 00 a4 2e 25 f8 00 00 00 08 00 00
[201961.881762] end_request: I/O error, dev sdl, sector 2754487800
[201961.881846] md1: WRITE SAME failed. Manually zeroing.
[201962.620524] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201962.620529] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201962.620531] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201962.620534] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201962.861966] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201962.861970] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201962.861974] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201963.110443] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201963.110449] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201963.110451] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201963.859428] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201963.859432] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201963.859434] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201964.107965] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201964.107972] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201964.107974] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201964.362926] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201964.362930] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201964.362933] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201964.362953] sd 1:0:3:0: [sdl] Unhandled error code
[201964.362955] sd 1:0:3:0: [sdl]
[201964.362957] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201964.362958] sd 1:0:3:0: [sdl] CDB:
[201964.362960] Write(16): 8a 00 00 00 00 00 a4 2e 26 00 00 00 00 08 00 00
[201964.362970] end_request: I/O error, dev sdl, sector 2754487808
[201964.362998] sd 1:0:3:0: [sdl] Unhandled error code
[201964.363000] sd 1:0:3:0: [sdl]
[201964.363001] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201964.363002] sd 1:0:3:0: [sdl] CDB:
[201964.363003] Read(16): 88 00 00 00 00 00 bb 17 d8 00 00 00 00 20 00 00
[201964.363012] end_request: I/O error, dev sdl, sector 3138902016
[201964.363105] md1: WRITE SAME failed. Manually zeroing.
[201965.156393] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201965.156398] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201965.156400] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201965.156403] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201965.156430] sd 1:0:3:0: [sdl] Unhandled error code
[201965.156432] sd 1:0:3:0: [sdl]
[201965.156434] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201965.156436] sd 1:0:3:0: [sdl] CDB:
[201965.156437] Read(16): 88 00 00 00 00 00 bb 17 d8 60 00 00 00 10 00 00
[201965.156448] end_request: I/O error, dev sdl, sector 3138902112
[201965.356158] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201965.356162] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201965.356180] sd 1:0:3:0: [sdl] Unhandled error code
[201965.356182] sd 1:0:3:0: [sdl]
[201965.356184] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201965.356186] sd 1:0:3:0: [sdl] CDB:
[201965.356187] Read(16): 88 00 00 00 00 00 bb 17 d8 b0 00 00 00 d0 00 00
[201965.356197] end_request: I/O error, dev sdl, sector 3138902192
[201965.619449] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201966.367001] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201966.616698] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201966.867123] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201966.867143] sd 1:0:3:0: [sdl] Unhandled error code
[201966.867145] sd 1:0:3:0: [sdl]
[201966.867147] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201966.867149] sd 1:0:3:0: [sdl] CDB:
[201966.867150] Write(16): 8a 00 00 00 00 00 a4 2e 26 08 00 00 00 08 00 00
[201966.867160] end_request: I/O error, dev sdl, sector 2754487816
[201966.867214] md1: WRITE SAME failed. Manually zeroing.
[201967.690920] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201967.690925] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201967.690927] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201967.849135] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201967.849141] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201968.098021] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201968.098026] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201968.861669] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201968.861673] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201969.095140] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201969.360096] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201969.360125] sd 1:0:3:0: [sdl] Unhandled error code
[201969.360127] sd 1:0:3:0: [sdl]
[201969.360128] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201969.360130] sd 1:0:3:0: [sdl] CDB:
[201969.360132] Write(16): 8a 00 00 00 00 00 a4 2e 26 10 00 00 00 08 00 00
[201969.360142] end_request: I/O error, dev sdl, sector 2754487824
[201969.360208] md1: WRITE SAME failed. Manually zeroing.
[201970.143112] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201970.143117] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201970.143119] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201970.342458] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201970.342462] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201970.591842] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201970.591847] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201971.356867] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201971.356874] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201971.589662] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201971.854226] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201971.854244] sd 1:0:3:0: [sdl] Unhandled error code
[201971.854246] sd 1:0:3:0: [sdl]
[201971.854248] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201971.854250] sd 1:0:3:0: [sdl] CDB:
[201971.854251] Write(16): 8a 00 00 00 00 00 a4 2e 26 18 00 00 00 08 00 00
[201971.854262] end_request: I/O error, dev sdl, sector 2754487832
[201971.854356] md1: WRITE SAME failed. Manually zeroing.
[201972.694812] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201972.694816] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201972.694819] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201972.836447] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201972.836451] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201973.086098] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201973.086102] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201973.833923] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201974.100276] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201974.349626] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201974.349644] sd 1:0:3:0: [sdl] Unhandled error code
[201974.349646] sd 1:0:3:0: [sdl]
[201974.349648] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201974.349650] sd 1:0:3:0: [sdl] CDB:
[201974.349651] Write(16): 8a 00 00 00 00 00 a4 2e 26 28 00 00 00 08 00 00
[201974.349662] end_request: I/O error, dev sdl, sector 2754487848
[201974.349726] md1: WRITE SAME failed. Manually zeroing.
[201975.122525] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201975.347081] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201975.596428] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201976.344602] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201976.593978] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201976.843293] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201976.843311] sd 1:0:3:0: [sdl] Unhandled error code
[201976.843313] sd 1:0:3:0: [sdl]
[201976.843314] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201976.843316] sd 1:0:3:0: [sdl] CDB:
[201976.843318] Write(16): 8a 00 00 00 00 00 a4 2e 26 30 00 00 00 08 00 00
[201976.843328] end_request: I/O error, dev sdl, sector 2754487856
[201976.843393] md1: WRITE SAME failed. Manually zeroing.
[201977.608101] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201977.840841] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201978.091116] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201978.838324] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201979.088171] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201979.337099] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201979.337113] sd 1:0:3:0: [sdl] Unhandled error code
[201979.337115] sd 1:0:3:0: [sdl]
[201979.337116] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201979.337118] sd 1:0:3:0: [sdl] CDB:
[201979.337120] Write(16): 8a 00 00 00 00 00 a4 2e 26 38 00 00 00 08 00 00
[201979.337130] end_request: I/O error, dev sdl, sector 2754487864
[201979.337208] md1: WRITE SAME failed. Manually zeroing.
[201980.101927] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201980.334960] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201980.583934] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201981.332071] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201981.582489] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201981.830878] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201981.830896] sd 1:0:3:0: [sdl] Unhandled error code
[201981.830898] sd 1:0:3:0: [sdl]
[201981.830900] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201981.830902] sd 1:0:3:0: [sdl] CDB:
[201981.830903] Write(16): 8a 00 00 00 00 00 a4 2e 26 40 00 00 00 08 00 00
[201981.830914] end_request: I/O error, dev sdl, sector 2754487872
[201981.830997] md1: WRITE SAME failed. Manually zeroing.
[201982.728799] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201983.077758] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201983.826392] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201984.075569] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201984.324623] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201985.072735] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201985.072755] sd 1:0:3:0: [sdl] Unhandled error code
[201985.072758] sd 1:0:3:0: [sdl]
[201985.072759] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201985.072761] sd 1:0:3:0: [sdl] CDB:
[201985.072762] Write(16): 8a 00 00 00 00 00 a4 2e 26 48 00 00 00 08 00 00
[201985.072773] end_request: I/O error, dev sdl, sector 2754487880
[201985.072858] md1: WRITE SAME failed. Manually zeroing.
[201985.430448] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201985.572126] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201986.319677] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201986.568998] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201986.818946] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201987.566467] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201987.566485] sd 1:0:3:0: [sdl] Unhandled error code
[201987.566487] sd 1:0:3:0: [sdl]
[201987.566488] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201987.566490] sd 1:0:3:0: [sdl] CDB:
[201987.566492] Write(16): 8a 00 00 00 00 00 a4 2e 26 50 00 00 00 08 00 00
[201987.566502] end_request: I/O error, dev sdl, sector 2754487888
[201987.566584] md1: WRITE SAME failed. Manually zeroing.
[201987.832844] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201987.832851] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201988.073701] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201988.073704] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201988.797018] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201989.062777] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201989.312151] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201990.061277] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201990.061294] sd 1:0:3:0: [sdl] Unhandled error code
[201990.061297] sd 1:0:3:0: [sdl]
[201990.061298] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201990.061300] sd 1:0:3:0: [sdl] CDB:
[201990.061301] Write(16): 8a 00 00 00 00 00 a4 2e 26 58 00 00 00 08 00 00
[201990.061312] end_request: I/O error, dev sdl, sector 2754487896
[201990.061396] md1: WRITE SAME failed. Manually zeroing.
[201990.382555] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201990.559046] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201991.307153] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201991.557339] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201991.807053] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201992.554359] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[201992.554378] sd 1:0:3:0: [sdl] Unhandled error code
[201992.554380] sd 1:0:3:0: [sdl]
[201992.554382] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[201992.554384] sd 1:0:3:0: [sdl] CDB:
[201992.554385] Write(16): 8a 00 00 00 00 00 a4 2e 26 60 00 00 00 08 00 00
[201992.554396] end_request: I/O error, dev sdl, sector 2754487904
[201992.554486] md1: WRITE SAME failed. Manually zeroing.
[202083.611234] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202083.826307] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202084.075103] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202084.823169] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202085.072538] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202085.322462] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202085.322475] sd 1:0:3:0: [sdl] Unhandled error code
[202085.322477] sd 1:0:3:0: [sdl]
[202085.322479] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[202085.322481] sd 1:0:3:0: [sdl] CDB:
[202085.322482] Write(16): 8a 00 00 00 00 00 a4 2e 26 68 00 00 00 18 00 00
[202085.322492] end_request: I/O error, dev sdl, sector 2754487912
[202085.322571] md1: WRITE SAME failed. Manually zeroing.
[202252.468346] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202252.653226] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202252.902642] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202253.650766] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202253.900092] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202254.149519] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202254.149537] sd 1:0:3:0: [sdl] Unhandled error code
[202254.149538] sd 1:0:3:0: [sdl]
[202254.149539] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[202254.149541] sd 1:0:3:0: [sdl] CDB:
[202254.149542] Write(16): 8a 00 00 00 00 00 a4 2e 27 98 00 00 00 08 00 00
[202254.149550] end_request: I/O error, dev sdl, sector 2754488216
[202254.149596] md1: WRITE SAME failed. Manually zeroing.
[202368.744191] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202368.872489] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202369.122311] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202369.870105] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202370.119851] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202370.368752] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202370.368765] sd 1:0:3:0: [sdl] Unhandled error code
[202370.368768] sd 1:0:3:0: [sdl]
[202370.368769] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[202370.368771] sd 1:0:3:0: [sdl] CDB:
[202370.368772] Write(16): 8a 00 00 00 00 00 27 84 b2 40 00 00 00 20 00 00
[202370.368783] end_request: I/O error, dev sdl, sector 663007808
[202370.368857] md1: WRITE SAME failed. Manually zeroing.
[202650.304173] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202650.418005] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202650.667721] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202651.423717] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202651.673375] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202651.673382] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202651.673385] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202651.673388] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202651.904739] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202651.904746] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202651.904749] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202651.904770] sd 1:0:3:0: [sdl] Unhandled error code
[202651.904772] sd 1:0:3:0: [sdl]
[202651.904774] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[202651.904776] sd 1:0:3:0: [sdl] CDB:
[202651.904777] Write(16): 8a 00 00 00 00 00 36 8b 99 98 00 00 00 08 00 00
[202651.904788] end_request: I/O error, dev sdl, sector 915118488
[202651.904892] md1: WRITE SAME failed. Manually zeroing.
[202653.667065] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202653.909234] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202654.158638] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202654.907332] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202655.156783] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202655.405479] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202655.405495] sd 1:0:3:0: [sdl] Unhandled error code
[202655.405497] sd 1:0:3:0: [sdl]
[202655.405499] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[202655.405501] sd 1:0:3:0: [sdl] CDB:
[202655.405502] Write(16): 8a 00 00 00 00 00 36 8b 99 a0 00 00 00 08 00 00
[202655.405512] end_request: I/O error, dev sdl, sector 915118496
[202655.405595] md1: WRITE SAME failed. Manually zeroing.
[202864.926215] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202864.926219] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202865.125553] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202865.396621] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202866.139915] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202866.388193] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202866.645436] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202866.645472] sd 1:0:3:0: [sdl] Unhandled error code
[202866.645477] sd 1:0:3:0: [sdl]
[202866.645479] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[202866.645480] sd 1:0:3:0: [sdl] CDB:
[202866.645514] Write(16): 8a 00 00 00 00 00 36 8b 9b 10 00 00 00 08 00 00
[202866.645524] end_request: I/O error, dev sdl, sector 915118864
[202866.645606] md1: WRITE SAME failed. Manually zeroing.
[202868.386035] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202868.631994] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202868.881382] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202869.629476] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202869.878889] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202870.128379] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202870.128407] sd 1:0:3:0: [sdl] Unhandled error code
[202870.128409] sd 1:0:3:0: [sdl]
[202870.128411] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[202870.128413] sd 1:0:3:0: [sdl] CDB:
[202870.128414] Write(16): 8a 00 00 00 00 00 36 8b 9b 18 00 00 00 08 00 00
[202870.128425] end_request: I/O error, dev sdl, sector 915118872
[202870.128565] md1: WRITE SAME failed. Manually zeroing.
[202967.666212] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202967.883713] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202968.132989] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202968.881211] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202969.130721] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202969.380101] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[202969.380120] sd 1:0:3:0: [sdl] Unhandled error code
[202969.380123] sd 1:0:3:0: [sdl]
[202969.380124] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[202969.380126] sd 1:0:3:0: [sdl] CDB:
[202969.380127] Write(16): 8a 00 00 00 00 00 36 8b 9b 38 00 00 00 08 00 00
[202969.380138] end_request: I/O error, dev sdl, sector 915118904
[202969.380214] md1: WRITE SAME failed. Manually zeroing.
[204997.978220] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[204998.103453] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[204998.353550] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[204999.100618] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[204999.350009] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[204999.599349] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[204999.599367] sd 1:0:3:0: [sdl] Unhandled error code
[204999.599370] sd 1:0:3:0: [sdl]
[204999.599371] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[204999.599373] sd 1:0:3:0: [sdl] CDB:
[204999.599374] Write(16): 8a 00 00 00 00 00 36 8b 9e 20 00 00 00 08 00 00
[204999.599385] end_request: I/O error, dev sdl, sector 915119648
[204999.599485] md1: WRITE SAME failed. Manually zeroing.
[205019.579373] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205019.801120] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205020.049384] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205020.797387] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205021.045682] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205021.295082] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205021.295095] sd 1:0:3:0: [sdl] Unhandled error code
[205021.295097] sd 1:0:3:0: [sdl]
[205021.295099] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[205021.295101] sd 1:0:3:0: [sdl] CDB:
[205021.295102] Write(16): 8a 00 00 00 00 00 36 8b 9d 60 00 00 00 08 00 00
[205021.295113] end_request: I/O error, dev sdl, sector 915119456
[205021.295192] md1: WRITE SAME failed. Manually zeroing.
[205257.618330] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205257.962798] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205258.710906] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205258.960958] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205259.209686] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205259.957760] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205259.957772] sd 1:0:3:0: [sdl] Unhandled error code
[205259.957775] sd 1:0:3:0: [sdl]
[205259.957776] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[205259.957778] sd 1:0:3:0: [sdl] CDB:
[205259.957779] Write(16): 8a 00 00 00 00 00 36 8b 9e 80 00 00 00 08 00 00
[205259.957790] end_request: I/O error, dev sdl, sector 915119744
[205259.957859] md1: WRITE SAME failed. Manually zeroing.
[205260.226088] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205260.457330] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205261.204722] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205261.454054] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205261.704537] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205262.451698] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205262.451717] sd 1:0:3:0: [sdl] Unhandled error code
[205262.451719] sd 1:0:3:0: [sdl]
[205262.451720] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[205262.451722] sd 1:0:3:0: [sdl] CDB:
[205262.451724] Write(16): 8a 00 00 00 00 00 36 8b 9e 88 00 00 00 08 00 00
[205262.451734] end_request: I/O error, dev sdl, sector 915119752
[205262.451800] md1: WRITE SAME failed. Manually zeroing.
[205339.108618] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205339.259306] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205339.508702] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205340.256836] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205340.506175] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205340.755573] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205340.755591] sd 1:0:3:0: [sdl] Unhandled error code
[205340.755593] sd 1:0:3:0: [sdl]
[205340.755595] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[205340.755597] sd 1:0:3:0: [sdl] CDB:
[205340.755598] Write(16): 8a 00 00 00 00 00 36 8b 9f 48 00 00 00 08 00 00
[205340.755608] end_request: I/O error, dev sdl, sector 915119944
[205340.755681] md1: WRITE SAME failed. Manually zeroing.
[205341.607449] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205341.753113] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205342.002471] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205342.751530] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205342.999973] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205343.249336] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205343.249354] sd 1:0:3:0: [sdl] Unhandled error code
[205343.249356] sd 1:0:3:0: [sdl]
[205343.249358] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[205343.249360] sd 1:0:3:0: [sdl] CDB:
[205343.249361] Write(16): 8a 00 00 00 00 00 36 8b 9f 50 00 00 00 08 00 00
[205343.249372] end_request: I/O error, dev sdl, sector 915119952
[205343.249436] md1: WRITE SAME failed. Manually zeroing.
[205408.471447] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205408.835846] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205409.584093] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205409.832703] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205410.082047] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205410.830249] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205410.830270] sd 1:0:3:0: [sdl] Unhandled error code
[205410.830272] sd 1:0:3:0: [sdl]
[205410.830274] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[205410.830276] sd 1:0:3:0: [sdl] CDB:
[205410.830277] Write(16): 8a 00 00 00 00 00 36 8b a0 80 00 00 00 20 00 00
[205410.830287] end_request: I/O error, dev sdl, sector 915120256
[205410.830369] md1: WRITE SAME failed. Manually zeroing.
[205411.111885] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205411.328964] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205411.827807] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205412.063443] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205412.313602] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205413.061594] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205413.310883] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205413.561264] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205414.308460] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205414.308478] sd 1:0:3:0: [sdl] Unhandled error code
[205414.308481] sd 1:0:3:0: [sdl]
[205414.308482] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[205414.308484] sd 1:0:3:0: [sdl] CDB:
[205414.308485] Write(16): 8a 00 00 00 00 00 36 8b a0 a8 00 00 00 20 00 00
[205414.308496] end_request: I/O error, dev sdl, sector 915120296
[205414.308588] md1: WRITE SAME failed. Manually zeroing.
[205414.579276] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205414.579283] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205414.829875] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205415.568347] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[205415.568365] sd 1:0:3:0: [sdl] Unhandled error code
[205415.568367] sd 1:0:3:0: [sdl]
[205415.568369] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[205415.568371] sd 1:0:3:0: [sdl] CDB:
[205415.568372] Write(16): 8a 00 00 00 00 00 36 8b 9f 58 00 00 00 08 00 00
[205415.568383] end_request: I/O error, dev sdl, sector 915119960
[205415.568462] md1: WRITE SAME failed. Manually zeroing.
[251066.562438] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[251066.693630] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[251066.942578] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[251067.690661] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[251067.940059] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[251068.199435] mpt2sas1: log_info(0x31120320): originator(PL),
code(0x12), sub_code(0x0320)
[251068.199475] sd 1:0:3:0: [sdl] Unhandled error code
[251068.199478] sd 1:0:3:0: [sdl]
[251068.199479] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[251068.199481] sd 1:0:3:0: [sdl] CDB:
[251068.199483] Write(16): 8a 00 00 00 00 00 36 8b a0 c8 00 00 00 08 00 00
[251068.199493] end_request: I/O error, dev sdl, sector 915120328
[251068.199586] md1: WRITE SAME failed. Manually zeroing.
----------------------------------------------------------------------
