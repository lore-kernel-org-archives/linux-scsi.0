From: Matthias Prager <linux@matthiasprager.de>
Subject: Re: 'Device not ready' issue on mpt2sas since 3.1.10
Date: Mon, 09 Jul 2012 16:40:15 +0200
Message-ID: <4FFAED4F.3080100@matthiasprager.de>
References: <4FE454CA.6080007@matthiasprager.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dd15408.kasserver.com ([85.13.136.168]:51792 "EHLO
	dd15408.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab2GIOkX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jul 2012 10:40:23 -0400
In-Reply-To: <4FE454CA.6080007@matthiasprager.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Matthias Prager <linux@matthiasprager.de>

Hello linux-scsi and linux-raid,

I did some further research regarding my problem.
It appears to me the fault does not lie with the mpt2sas driver (not
that I can definitely exclude it), but with the md implementation.

I reproduced what I think is the same issue on a different machine (also
running Vmware ESXi 5 and an LSI 9211-8i in IR mode) with a different
set of hard-drives of the same model. Using systemrescuecd
(2.8.1-beta003) and booting the 64bit 3.4.4 kernel, I issued the
following commands:

1) 'hdparm -y /dev/sda' (to put the hard-drive to sleep)
2) 'mdadm --create /dev/md1 --metadata 1.2 --level=mirror
--raid-devices=2 --name=test1 /dev/sda missing'
3) 'fdisk -l /dev/md127' (for some reason /proc/mdstat indicates the md
is being created as md127)

2) gave me this feedback:
------
mdadm: super1.x cannot open /dev/sda: Device or resource busy
mdadm: /dev/sda is not suitable for this array.
mdadm: create aborted
-------
Even though it says creating aborted it still created md127.

And 3) lead to these lines in dmesg:
-------
[  604.838640] sd 2:0:0:0: [sda] Device not ready
[  604.838645] sd 2:0:0:0: [sda]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  604.838655] sd 2:0:0:0: [sda]  Sense Key : Not Ready [current]
[  604.838663] sd 2:0:0:0: [sda]  Add. Sense: Logical unit not ready,
initializing command required
[  604.838668] sd 2:0:0:0: [sda] CDB: Read(10): 28 00 00 00 08 00 00 00
20 00
[  604.838680] end_request: I/O error, dev sda, sector 2048
[  604.838688] Buffer I/O error on device md127, logical block 0
[  604.838695] Buffer I/O error on device md127, logical block 1
[  604.838699] Buffer I/O error on device md127, logical block 2
[  604.838702] Buffer I/O error on device md127, logical block 3
[  604.838783] sd 2:0:0:0: [sda] Device not ready
[  604.838785] sd 2:0:0:0: [sda]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  604.838789] sd 2:0:0:0: [sda]  Sense Key : Not Ready [current]
[  604.838793] sd 2:0:0:0: [sda]  Add. Sense: Logical unit not ready,
initializing command required
[  604.838797] sd 2:0:0:0: [sda] CDB: Read(10): 28 00 00 00 08 00 00 00
08 00
[  604.838805] end_request: I/O error, dev sda, sector 2048
[  604.838808] Buffer I/O error on device md127, logical block 0
[  604.838983] sd 2:0:0:0: [sda] Device not ready
[  604.838986] sd 2:0:0:0: [sda]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  604.838989] sd 2:0:0:0: [sda]  Sense Key : Not Ready [current]
[  604.838993] sd 2:0:0:0: [sda]  Add. Sense: Logical unit not ready,
initializing command required
[  604.838998] sd 2:0:0:0: [sda] CDB: Read(10): 28 00 57 54 65 d8 00 00
08 00
[  604.839006] end_request: I/O error, dev sda, sector 1465148888
[  604.839009] Buffer I/O error on device md127, logical block 183143355
[  604.839087] sd 2:0:0:0: [sda] Device not ready
[  604.839090] sd 2:0:0:0: [sda]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  604.839093] sd 2:0:0:0: [sda]  Sense Key : Not Ready [current]
[  604.839097] sd 2:0:0:0: [sda]  Add. Sense: Logical unit not ready,
initializing command required
[  604.839102] sd 2:0:0:0: [sda] CDB: Read(10): 28 00 57 54 65 d8 00 00
08 00
[  604.839110] end_request: I/O error, dev sda, sector 1465148888
[  604.839113] Buffer I/O error on device md127, logical block 183143355
[  604.839271] sd 2:0:0:0: [sda] Device not ready
[  604.839274] sd 2:0:0:0: [sda]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  604.839278] sd 2:0:0:0: [sda]  Sense Key : Not Ready [current]
[  604.839282] sd 2:0:0:0: [sda]  Add. Sense: Logical unit not ready,
initializing command required
[  604.839286] sd 2:0:0:0: [sda] CDB: Read(10): 28 00 00 00 08 00 00 00
20 00
[  604.839321] end_request: I/O error, dev sda, sector 2048
[  604.839324] Buffer I/O error on device md127, logical block 0
[  604.839330] Buffer I/O error on device md127, logical block 1
[  604.840494] sd 2:0:0:0: [sda] Device not ready
[  604.840497] sd 2:0:0:0: [sda]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  604.840504] sd 2:0:0:0: [sda]  Sense Key : Not Ready [current]
[  604.840512] sd 2:0:0:0: [sda]  Add. Sense: Logical unit not ready,
initializing command required
[  604.840516] sd 2:0:0:0: [sda] CDB: Read(10): 28 00 00 00 08 00 00 00
08 00
[  604.840526] end_request: I/O error, dev sda, sector 2048
------

This excludes hardware-errors (different physical machine and devices)
as cause and also ext4 which the other system was using as filesystem.
Maybe Neil Brown (who scripts/get_maintainer.pl identified as the
maintainer of the md-code) can make bits and pieces of this. It may well
be this is the same problem but a different error-path - I don't know.

I will try to make the scenario more generic, but I don't have a
non-virtual machine to spare atm. Also please do let me know if I'm
posting this to the wrong lists (linux-scsi and linux-raid) or if there
is anything which might not be helpful with the way I'm reporting this.

Regards,
Matthias Prager
