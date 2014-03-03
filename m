From: Istvan Hubay Cebrian <istvan.cebrian@gmail.com>
Subject: Re: Dell Shared PERC8 RAID Controller
Date: Mon, 3 Mar 2014 15:22:13 +0000
Message-ID: <CABA7EgD+YaOQXEzR25NWxkH+JQ2dN1VW3RsjN3=fLdg6OOoJcQ@mail.gmail.com>
References: <CABA7EgDjuvvwYDxzYgO1qQLjTAXbjiqccnF0CxCsJAyz+xDZ7g@mail.gmail.com>
 <20140303160944.50ba399d@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ve0-f172.google.com ([209.85.128.172]:49818 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbaCCPWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2014 10:22:34 -0500
Received: by mail-ve0-f172.google.com with SMTP id jx11so3786521veb.17
        for <linux-scsi@vger.kernel.org>; Mon, 03 Mar 2014 07:22:33 -0800 (PST)
In-Reply-To: <20140303160944.50ba399d@harpe.intellique.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-scsi@vger.kernel.org

I can't tell you exactly which one is causing me problems but I can
assume it is the unsupported one.

Basically the M520 Blades also have internal storage. I can see and
mount that storage.

[root@hostname ~]# lsmod | grep raid
megaraid_sas           87177  2

[root@hostname ~]# modinfo megaraid_sas
filename:
/lib/modules/2.6.32-431.5.1.el6.x86_64/kernel/drivers/scsi/megaraid/meg=
araid_sas.ko
description:    LSI MegaRAID SAS Driver
author:         megaraidlinux@lsi.com
version:        06.700.06.00-rh1
license:        GPL
srcversion:     9426C5CDA69586AABE13C02
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
vermagic:       2.6.32-431.5.1.el6.x86_64 SMP mod_unload modversions
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
I can't however see the Shared storage provided by the VRTX Enclosure.
I would assume one controller is for the internal storage of the M520
Blade and the other controller for the Shared storage.

--
Istvan Hubay Cebrian
http://icebrian.net


On 3 March 2014 15:09, Emmanuel Florac <eflorac@intellique.com> wrote:
> Le Mon, 3 Mar 2014 14:53:36 +0000
> Istvan Hubay Cebrian <istvan.cebrian@gmail.com> =E9crivait:
>
>> lspci -nn (on Dell PowerEdge M520 Blade)
>> ...
>> 01:00.0 RAID bus controller [0104]: LSI Logic / Symbios Logic MegaRA=
ID
>> SAS 2008 [Falcon] [1000:0073] (rev 03)
>
> This one is  supported by the megaraid_sas driver, provided it's rece=
nt
> enough.
>
>
>> 08:00.0 RAID bus controller [0104]: LSI Logic / Symbios Logic MegaRA=
ID
>> SAS 2208 IOV [Thunderbolt] [1000:002f] (rev 05)
>> ...
>
> This one seems unsupported. I don't know what it's actually for,
> though. Is it the one posing you a problem? I suppose ESXi lets you
> check (with modinfo) if megaraid_sas manages it.
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
