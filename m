From: James Smart <James.Smart@Emulex.Com>
Subject: Re: lp8000 and 2.6.18-rc6
Date: Sun, 10 Sep 2006 10:03:31 -0400
Message-ID: <45041B33.9010900@emulex.com>
References: <20060909210142.GA21263@stat.unipd.it>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:59290 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932179AbWIJODh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Sep 2006 10:03:37 -0400
In-Reply-To: <20060909210142.GA21263@stat.unipd.it>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mmzz@stat.unipd.it, linux-scsi@vger.kernel.org

It's not an LP8000 issue...  It's a Clariion issue...
The inquiry data for the 4 target ports looks only partially formed
(no PID, odd SCSI rev). The guess is that the clariion isn't set up
to export any real luns to you yet. See if there's lun-masking
(or selective presentation) that you have to enable on the clariion
based on the wwpn of the adapter.

-- james s

Alberto Cammozzo wrote:
> Hello,
> 
> I have a problem with the Emulex LP8000 lpfc driver:
> - the kernel module loads fine and reports 4 luns from the storage
>   (Clariion 4700),  also listed in /proc/scsi/scsi,  but
> - there is no way to have a SCSI device attached (sdb, sdc, ...), even
>   runing rescan-scsi-bus. The disks are not listed with fdisk -l.
> 
> It's the first time I use this setup... Am I missing something?
> 
>   Thank you for any help.
> 
>     Alberto
> 
> 
> 
> ==== Uname -a:
> Linux novantatre 2.6.18-rc6 #1 SMP Sat Sep 9 09:46:54 CEST 2006 i686 GNU/Linux
> 
> ==== lsmod:
> Module                  Size  Used by
> lpfc                  145600  0 
> scsi_transport_fc      25568  1 lpfc
> iscsi_tcp              19808  1 
> libiscsi               17504  1 iscsi_tcp
> scsi_transport_iscsi    23244  3 iscsi_tcp,libiscsi
> skge                   31312  0 
> [...]
> 
> ==== From dmesg:
> Emulex LightPulse Fibre Channel SCSI driver 8.1.9
> Copyright(c) 2004-2006 Emulex.  All rights reserved.
> PCI: Enabling device 0000:04:01.0 (0158 -> 015b)
> ACPI: PCI Interrupt 0000:04:01.0[A] -> GSI 52 (level, low) -> IRQ 23
> scsi6 :  on PCI bus 04 device 08 irq 23
> lpfc 0000:04:01.0: 0:1303 Link Up Event x1 received Data: x1 x1 x0 x0
>   Vendor: DGC       Model:                   Rev: 0850
>   Type:   Direct-Access                      ANSI SCSI revision: 04
>   Vendor: DGC       Model:                   Rev: 0850
>   Type:   Direct-Access                      ANSI SCSI revision: 04
>   Vendor: DGC       Model:                   Rev: 0850
>   Type:   Direct-Access                      ANSI SCSI revision: 04
>   Vendor: DGC       Model:                   Rev: 0850
>   Type:   Direct-Access                      ANSI SCSI revision: 04
> 
> ===== from /proc/scsi/scsi:
> Host: scsi6 Channel: 00 Id: 00 Lun: 00
>   Vendor: DGC      Model:                  Rev: 0850
>   Type:   Direct-Access                    ANSI SCSI revision: 04
> Host: scsi6 Channel: 00 Id: 01 Lun: 00
>   Vendor: DGC      Model:                  Rev: 0850
>   Type:   Direct-Access                    ANSI SCSI revision: 04
> Host: scsi6 Channel: 00 Id: 02 Lun: 00
>   Vendor: DGC      Model:                  Rev: 0850
>   Type:   Direct-Access                    ANSI SCSI revision: 04
> Host: scsi6 Channel: 00 Id: 03 Lun: 00
>   Vendor: DGC      Model:                  Rev: 0850
>   Type:   Direct-Access                    ANSI SCSI revision: 04
> 
> 
