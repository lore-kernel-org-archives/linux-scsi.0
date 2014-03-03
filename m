From: Istvan Hubay Cebrian <istvan.cebrian@gmail.com>
Subject: Re: Dell Shared PERC8 RAID Controller
Date: Mon, 3 Mar 2014 18:14:37 +0000
Message-ID: <CABA7EgAFi_Geq2Kf6jAOXOLvrKPbPo+4JwWwOh2FdAmK6bkr5w@mail.gmail.com>
References: <CABA7EgDjuvvwYDxzYgO1qQLjTAXbjiqccnF0CxCsJAyz+xDZ7g@mail.gmail.com>
 <20140303160944.50ba399d@harpe.intellique.com> <CABA7EgD+YaOQXEzR25NWxkH+JQ2dN1VW3RsjN3=fLdg6OOoJcQ@mail.gmail.com>
 <20140303163317.543e9a98@harpe.intellique.com> <CABA7EgABdoQK735L5uoW6ydVWpKM_rZSFcLpOCruTHEdcNu-ZA@mail.gmail.com>
 <20140303183531.7ffedbe6@harpe.intellique.com> <CABA7EgDUo5LZAi899-oMMnE5EkuP0GyFSQmtKtc606GG+_nAWA@mail.gmail.com>
 <20140303190535.17a21733@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:42566 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaCCSO6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2014 13:14:58 -0500
Received: by mail-vc0-f169.google.com with SMTP id hq11so4000254vcb.0
        for <linux-scsi@vger.kernel.org>; Mon, 03 Mar 2014 10:14:57 -0800 (PST)
In-Reply-To: <20140303190535.17a21733@harpe.intellique.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-scsi@vger.kernel.org

Here you go (ran modinfo on my Fedora machine):

[icebrian@laptop megaraid]$ modinfo megaraid_sas
filename:
/lib/modules/3.13.5-200.fc20.x86_64/kernel/drivers/scsi/megaraid/megara=
id_sas.ko
description:    LSI MegaRAID SAS Driver
author:         megaraidlinux@lsi.com
version:        06.700.06.00-rc1
license:        GPL
srcversion:     CC8C2EAD4EB0EC0F8B7526C
alias:          pci:v00001000d0000005Fsv*sd*bc*sc*i*
alias:          pci:v00001000d0000005Dsv*sd*bc*sc*i*
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
vermagic:       3.13.5-200.fc20.x86_64 SMP mod_unload
signer:         Fedora kernel signing key
sig_key:        C8:CA:53:8E:94:4B:80:33:51:31:F3:2F:C0:A6:F5:54:E4:8D:A=
1:78
sig_hashalgo:   sha256
parm:           max_sectors:Maximum number of sectors per IO command (i=
nt)
parm:           msix_disable:Disable MSI-X interrupt handling. Default:=
 0 (int)
parm:           msix_vectors:MSI-X max vector count. Default: Set by FW=
 (int)
parm:           throttlequeuedepth:Adapter queue depth when throttled
due to I/O timeout. Default: 16 (int)
parm:           resetwaittime:Wait time in seconds after I/O timeout
before resetting adapter. Default: 180 (int)
--
Istvan Hubay Cebrian
http://icebrian.net


On 3 March 2014 18:05, Emmanuel Florac <eflorac@intellique.com> wrote:
> Le Mon, 3 Mar 2014 17:56:04 +0000
> Istvan Hubay Cebrian <istvan.cebrian@gmail.com> =E9crivait:
>
>> ~ # esxcli system module get -m megaraid_sas
>>    Module: megaraid_sas
>>    Module File: /usr/lib/vmware/vmkmod/megaraid_sas
>>    License: GPL
>>    Version: Version 06.801.52.00, Build: 472560, Interface: 9.2 Buil=
t
>> on: Feb  7 2013
>>    Signed Status: Unsigned
>>    Signature Issuer:
>>    Signature Digest: 50bd fb02 0df9 4ad0 3d99 00de 9234 f055 f7d2 f8=
1e
>> aadf 7120 a941 44b3 61a6 d3b1
>>    Signature FingerPrint: 0000 0000 0000 0000 0000 0000 0000 0000
>>    Provided Namespaces:
>>    Required Namespaces: com.vmware.driverAPI@9.2.0.0,
>> com.vmware.vmkapi@v2_0_0_0
>
> OK so this looks like the normal megaraid_sas under the usual license=
,
> though it obviously works with the weird device:
>
>
> 00:08:00.0 RAID bus controller Mass storage controller: LSI Logic /
> Symbios Logic Shared PERC 8 Mini [vmhba2]
> Class 0104: 1000:002f
>
> Could you grab the file /usr/lib/vmware/vmkmod/megaraid_sas.ko and ru=
n
> modinfo on it (even from a different distro, should work fine I
> suppose).
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
