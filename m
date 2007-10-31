From: Gabriel C <nix.or.die@googlemail.com>
Subject: drivers/scsi/* compile warnings
Date: Wed, 31 Oct 2007 17:09:24 +0100
Message-ID: <4728A8B4.5020702@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:52165 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972AbXJaQJa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2007 12:09:30 -0400
Received: by nf-out-0910.google.com with SMTP id g13so174431nfb
        for <linux-scsi@vger.kernel.org>; Wed, 31 Oct 2007 09:09:28 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org

Hi ,

on current git ( a3634d7169f56eca5e349fce2f1de228fc10efda ) I see the following compile warning from some scsi drivers.

Someone may want to look at these :)

...


--($:/work/crazy/linux-git/fresh-linux2.6)-- grep ^[a-z] build.log|grep scsi
drivers/scsi/advansys.c:71:2: warning: #warning this driver is still not properly converted to the DMA API
drivers/scsi/advansys.c: In function 'advansys_board_found':
drivers/scsi/advansys.c:13874: warning: label 'err_shost' defined but not used
drivers/scsi/advansys.c: At top level:
drivers/scsi/advansys.c:11894: warning: 'Default_3550_EEPROM_Config' defined but not used
drivers/scsi/advansys.c:11932: warning: 'ADVEEP_3550_Config_Field_IsChar' defined but not used
drivers/scsi/advansys.c:11970: warning: 'Default_38C0800_EEPROM_Config' defined but not used
drivers/scsi/advansys.c:12035: warning: 'ADVEEP_38C0800_Config_Field_IsChar' defined but not used
drivers/scsi/advansys.c:12100: warning: 'Default_38C1600_EEPROM_Config' defined but not used
drivers/scsi/advansys.c:12165: warning: 'ADVEEP_38C1600_Config_Field_IsChar' defined but not used
drivers/scsi/advansys.c: In function 'advansys_board_found':
drivers/scsi/advansys.c:13400: warning: 'share_irq' may be used uninitialized in this function
drivers/scsi/advansys.c:13400: warning: 'ret' may be used uninitialized in this function
drivers/scsi/ultrastor.c: In function 'find_and_clear_bit_16':
drivers/scsi/ultrastor.c:303: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:302: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c: In function 'ultrastor_host_reset':
drivers/scsi/ultrastor.c:1013: warning: passing argument 1 of '__constant_c_and_count_memset' discards qualifiers from pointer target type
drivers/scsi/ultrastor.c: At top level:
drivers/scsi/ultrastor.c:1202: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:1202: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c: In function 'ultrastor_queuecommand':
drivers/scsi/ultrastor.c:698: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:698: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:698: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:698: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:698: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:698: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:698: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:698: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:302: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:302: warning: matching constraint does not allow a register
drivers/scsi/aic7xxx_old.c:8902: warning: 'aic7xxx_configure_bugs' defined but not used
drivers/scsi/aic7xxx_old.c: In function 'aic7xxx_free':
drivers/scsi/aic7xxx_old.c:8490: warning: passing argument 3 of 'pci_free_consistent' discards qualifiers from pointer target type
drivers/scsi/sym53c416.c: In function 'sym53c416_detect':
drivers/scsi/sym53c416.c:638: warning: the address of 'sym53c416' will always evaluate as 'true'
drivers/scsi/sym53c416.c:644: warning: the address of 'sym53c416_1' will always evaluate as 'true'
drivers/scsi/sym53c416.c:650: warning: the address of 'sym53c416_2' will always evaluate as 'true'
drivers/scsi/sym53c416.c:656: warning: the address of 'sym53c416_3' will always evaluate as 'true'

...

sh scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux lara 2.6.24-rc1-g97855b49 #355 SMP Tue Oct 30 18:42:16 CET 2007 i686 Intel(R) Xeon(TM) CPU 2.00GHz GenuineIntel GNU/Linux

Gnu C                  4.2.2
Gnu make               3.81
binutils               2.18.50.0.2.20071001
util-linux             2.13
mount                  2.13
module-init-tools      3.2.2
e2fsprogs              1.40.2
xfsprogs               2.9.4
pcmciautils            014
quota-tools            3.15.
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Linux C++ Library      6.0.9
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
Sh-utils               6.9
udev                   116
Modules Loaded         fuse pc87360 hwmon_vid eeprom adm1021 sr_mod shpchp pci_hotplug iTCO_wdt iTCO_vendor_support intel_agp i82860_edac i2c_i801 edac_core cdrom agpgart 3c59x mii ext4dev jbd2 crc16 loop lp parport_pc parport evdev


config is a allmodconfig with CONFIG_PCI and CONFIG_PM disabled.

Regards,

Gabriel 
