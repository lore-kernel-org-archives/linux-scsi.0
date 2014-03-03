From: Istvan Hubay Cebrian <istvan.cebrian@gmail.com>
Subject: Re: Dell Shared PERC8 RAID Controller
Date: Mon, 3 Mar 2014 16:57:44 +0000
Message-ID: <CABA7EgABdoQK735L5uoW6ydVWpKM_rZSFcLpOCruTHEdcNu-ZA@mail.gmail.com>
References: <CABA7EgDjuvvwYDxzYgO1qQLjTAXbjiqccnF0CxCsJAyz+xDZ7g@mail.gmail.com>
 <20140303160944.50ba399d@harpe.intellique.com> <CABA7EgD+YaOQXEzR25NWxkH+JQ2dN1VW3RsjN3=fLdg6OOoJcQ@mail.gmail.com>
 <20140303163317.543e9a98@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:55582 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbaCCQ6H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2014 11:58:07 -0500
Received: by mail-ve0-f170.google.com with SMTP id pa12so3916420veb.15
        for <linux-scsi@vger.kernel.org>; Mon, 03 Mar 2014 08:58:05 -0800 (PST)
In-Reply-To: <20140303163317.543e9a98@harpe.intellique.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-scsi@vger.kernel.org

So I do have ESXi on one of the blade servers. Curiously "lspci -nn"
output is very different. I for example don't see two RAID controllers
but one:

=2E..
00:10.0 SCSI storage controller [0100]: LSI Logic / Symbios Logic
53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI [1000:0030] (rev 01)
=2E..

Also, lsmod returns the following:

[root@storpro ~]# lsmod
Module                  Size  Used by
nfsd                  304902  13
lockd                  73534  1 nfsd
nfs_acl                 2647  1 nfsd
auth_rpcgss            44917  1 nfsd
autofs4                26449  3
sunrpc                261235  19 nfsd,lockd,nfs_acl,auth_rpcgss
ipv6                  321582  68
xfs                  1088447  2
exportfs                4236  2 nfsd,xfs
ppdev                   8537  0
parport_pc             22690  0
parport                36209  2 p[root@storpro ~]# lsmod
Module                  Size  Used by
nfsd                  304902  13
lockd                  73534  1 nfsd
nfs_acl                 2647  1 nfsd
auth_rpcgss            44917  1 nfsd
autofs4                26449  3
sunrpc                261235  19 nfsd,lockd,nfs_acl,auth_rpcgss
ipv6                  321582  68
xfs                  1088447  2
exportfs                4236  2 nfsd,xfs
ppdev                   8537  0
parport_pc             22690  0
parport                36209  2 ppdev,parport_pc
e1000                 170678  0
microcode             112653  0
vmware_balloon          7199  0
sg                     29350  0
i2c_piix4              12608  0
i2c_core               31084  1 i2c_piix4
shpchp                 32778  0
ext4                  363344  2
jbd2                   91554  1 ext4
mbcache                 8193  1 ext4
sd_mod                 38976  7
crc_t10dif              1541  1 sd_mod
sr_mod                 15177  0
cdrom                  39085  1 sr_mod
mptspi                 16603  4
mptscsih               36700  1 mptspi
mptbase                93647  2 mptspi,mptscsih
scsi_transport_spi     25863  1 mptspi
pata_acpi               3701  0
ata_generic             3837  0
ata_piix               24121  0
dm_mirror              14133  0
dm_region_hash         12085  1 dm_mirror
dm_log                  9930  2 dm_mirror,dm_region_hash
dm_mod                 82839  8 dm_mirror,dm_log
pdev,parport_pc
e1000                 170678  0
microcode             112653  0
vmware_balloon          7199  0
sg                     29350  0
i2c_piix4              12608  0
i2c_core               31084  1 i2c_piix4
shpchp                 32778  0
ext4                  363344  2
jbd2                   91554  1 ext4
mbcache                 8193  1 ext4
sd_mod                 38976  7
crc_t10dif              1541  1 sd_mod
sr_mod                 15177  0
cdrom                  39085  1 sr_mod
mptspi                 16603  4
mptscsih               36700  1 mptspi
mptbase                93647  2 mptspi,mptscsih
scsi_transport_spi     25863  1 mptspi
pata_acpi               3701  0
ata_generic             3837  0
ata_piix               24121  0
dm_mirror              14133  0
dm_region_hash         12085  1 dm_mirror
dm_log                  9930  2 dm_mirror,dm_region_hash
dm_mod                 82839  8 dm_mirror,dm_log

[root@storpro ~]# modinfo mptspi
filename:
/lib/modules/2.6.32-358.18.1.el6.x86_64/kernel/drivers/message/fusion/m=
ptspi.ko
version:        3.04.20
license:        GPL
description:    Fusion MPT SPI Host driver
author:         LSI Corporation
srcversion:     BFB86D57259351D6A601FFB
alias:          pci:v00001000d00000040sv*sd*bc*sc*i*
alias:          pci:v0000117Cd00000030sv*sd*bc*sc*i*
alias:          pci:v00001000d00000030sv*sd*bc*sc*i*
depends:        mptscsih,scsi_transport_spi,mptbase
vermagic:       2.6.32-358.18.1.el6.x86_64 SMP mod_unload modversions
parm:           mpt_saf_te: Force enabling SEP Processor: enable=3D1
(default=3DMPTSCSIH_SAF_TE=3D0) (int)
--
Istvan Hubay Cebrian
http://icebrian.net


On 3 March 2014 15:33, Emmanuel Florac <eflorac@intellique.com> wrote:
> Le Mon, 3 Mar 2014 15:22:13 +0000
> Istvan Hubay Cebrian <istvan.cebrian@gmail.com> =E9crivait:
>
>> I can't however see the Shared storage provided by the VRTX Enclosur=
e.
>> I would assume one controller is for the internal storage of the M52=
0
>> Blade and the other controller for the Shared storage.
>
> Yes, that's probably the case. As I said, I'd first try installing ES=
Xi
> on a blade to check what driver it uses for this particular card (ESX=
i
> is a special Linux distro after all).
>
> --
> ---------------------------------------------------------------------=
---
> Emmanuel Florac     |   Direction technique
>                     |   Intellique
>                     |   <eflorac@intellique.com>
>                     |   +33 1 78 94 84 02
> ---------------------------------------------------------------------=
---
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
