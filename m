From: Birta Levente <blevi.linux@gmail.com>
Subject: LSI driver and SSD status error in IPMI
Date: Fri, 16 Oct 2015 12:00:26 +0300
Message-ID: <5620BCAA.7080307@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37696 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbbJPI77 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Oct 2015 04:59:59 -0400
Received: by wijq8 with SMTP id q8so280995wij.0
        for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2015 01:59:58 -0700 (PDT)
Received: from [192.168.1.64] ([81.196.63.17])
        by smtp.googlemail.com with ESMTPSA id ht5sm2403762wib.10.2015.10.16.01.59.56
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Fri, 16 Oct 2015 01:59:56 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi to all

I don't know if this is a right list to ask, but I take my chance:


I have a supermicro server with LSI 3108 with
- 2x300GB SAS spin drive in raid1 (virtual drive 0)
- 2x300GB SAS spin drive in raid1 (virtual drive 1)
- 2x200GB Intel SSD DC S3710 drives configured as JBOD in LSI bios

In the IPMI storage health status eveything looks fine until I boot into 
Centos 7.1 (unfortunatelly I didn't try other OS, but also I'm not 
interested in other)
After boot the status for the SSDs changing in ERROR

The same thing happen when boot with the install CD

Otherwise everything works fine.

Is this hurt? Can I do something?

Also I tried to install the latest LSI driver (06.809.18.00), but seems 
it is not loaded after restart:
As the official driver install guide say, before the driver install, I 
installed the dkms from the epel repo.

/var/log/messages:
systemd-modules-load: Failed to find module 'override megaraid_sas 
3.10.* weak-updates/megaraid_sas'

/etc/modules-load.d/megaraid_sas.conf:
override megaraid_sas 3.10.* weak-updates/megaraid_sas

#modinfo megaraid_sas
filename: 
/lib/modules/3.10.0-229.14.1.el7.x86_64/kernel/drivers/scsi/megaraid/megaraid_sas.ko
description:    LSI MegaRAID SAS Driver
author:         megaraidlinux@lsi.com
version:        06.805.06.01-rh2
license:        GPL
rhelversion:    7.1
srcversion:     C0124BBE9453A621D4086DB
alias:          pci:v00001000d0000005Fsv*sd*bc*sc*i*
alias:          pci:v00001000d0000005Dsv*sd*bc*sc*i*
alias:          pci:v00001000d0000002Fsv*sd*bc*sc*i*
alias:          pci:v00001000d0000005Bsv*sd*bc*sc*i*
alias:          pci:v00001028d00000015sv*sd*bc*sc*i*
alias:          pci:v00001000d00000413sv*sd*bc*sc*i*
alias:          pci:v00001000d00000071sv*sd*bc*sc*i*
alias:          pci:v00001000d00000073sv*sd*bc*sc*i*
alias:          pci:v00001000d00000079sv*sd*bc*sc*i*
alias:          pci:v00001000d00000078sv*sd*bc*sc*i*
alias:          pci:v00001000d0000007Csv*sd*bc*sc*i*
alias:          pci:v00001000d00000060sv*sd*bc*sc*i*
alias:          pci:v00001000d00000411sv*sd*bc*sc*i*
depends:
intree:         Y
vermagic:       3.10.0-229.14.1.el7.x86_64 SMP mod_unload modversions
signer:         CentOS Linux kernel signing key
sig_key: E9:9F:C4:37:BD:9C:BF:B4:F1:B1:DA:87:C1:57:FF:66:56:9B:EE:66
sig_hashalgo:   sha256
parm:           lb_pending_cmds:Change raid-1 load balancing outstanding 
threshold. Valid Values are 1-128. Default: 4 (int)
parm:           max_sectors:Maximum number of sectors per IO command (int)
parm:           msix_disable:Disable MSI-X interrupt handling. Default: 
0 (int)
parm:           msix_vectors:MSI-X max vector count. Default: Set by FW 
(int)
parm:           allow_vf_ioctls:Allow ioctls in SR-IOV VF mode. Default: 
0 (int)
parm:           throttlequeuedepth:Adapter queue depth when throttled 
due to I/O timeout. Default: 16 (int)
parm:           resetwaittime:Wait time in seconds after I/O timeout 
before resetting adapter. Default: 180 (int)
parm:           smp_affinity_enable:SMP affinity feature enable/disbale 
Default: enable(1) (int)


I reinstalled again the OS with the new driver loaded/installed as 
driver update diskette (added linux dd option when boot to the install cd)
After install/reboot look like the good driver loaded (the error 
systemd-modules-load: Failed to find module 'override megaraid_sas 
3.10.* weak-updates/megaraid_sas'  still exists in messages).

# modinfo megaraid_sas
filename: 
/lib/modules/3.10.0-229.el7.x86_64/extra/megaraid_sas/megaraid_sas.ko
description:    Avago MegaRAID SAS Driver
author:         megaraidlinux.pdl@avagotech.com
version:        06.809.18.00
license:        GPL
rhelversion:    7.1
srcversion:     27E06D4D7894381BFEDD368
alias:          pci:v00001000d000000CFsv*sd*bc*sc*i*
alias:          pci:v00001000d000000CEsv*sd*bc*sc*i*
alias:          pci:v00001000d0000005Fsv*sd*bc*sc*i*
alias:          pci:v00001000d0000005Dsv*sd*bc*sc*i*
alias:          pci:v00001000d0000002Fsv*sd*bc*sc*i*
alias:          pci:v00001000d0000005Bsv*sd*bc*sc*i*
alias:          pci:v00001028d00000015sv*sd*bc*sc*i*
alias:          pci:v00001000d00000413sv*sd*bc*sc*i*
alias:          pci:v00001000d00000071sv*sd*bc*sc*i*
alias:          pci:v00001000d00000073sv*sd*bc*sc*i*
alias:          pci:v00001000d00000079sv*sd*bc*sc*i*
alias:          pci:v00001000d00000078sv*sd*bc*sc*i*
alias:          pci:v00001000d0000007Csv*sd*bc*sc*i*
alias:          pci:v00001000d00000060sv*sd*bc*sc*i*
alias:          pci:v00001000d00000411sv*sd*bc*sc*i*
depends:
vermagic:       3.10.0-229.el7.x86_64 SMP mod_unload modversions
parm:           lb_pending_cmds:Change raid-1 load balancing outstanding 
threshold. Valid Values are 1-128. Default: 4 (int)
parm:           max_sectors:Maximum number of sectors per IO command (int)
parm:           msix_disable:Disable MSI-X interrupt handling. Default: 
0 (int)
parm:           smp_affinity_enable:SMP affinity feature enable/disbale 
Default: enable(1) (int)
parm:           msix_vectors:MSI-X max vector count. Default: Set by FW 
(int)
parm:           allow_vf_ioctls:Allow ioctls in SR-IOV VF mode. Default: 
0 (int)
parm:           throttlequeuedepth:Adapter queue depth when throttled 
due to I/O timeout. Default: 16 (int)
parm:           resetwaittime:Wait time in seconds after I/O timeout 
before resetting adapter. Default: 180 (int)
parm:           crashdump_enable:Firmware Crash dump feature 
enable/disbale Default: enable(1) (int)
parm:           rdpq_enable: Allocate reply queue in chunks for large 
queue depth enable/disbale Default: disable(0) (int)


But after kernel update modinfo show me the orig driver version provided 
by the OS


Can somebody tell me how to get the driver to work?

Thanks,

-- 
            Levi

