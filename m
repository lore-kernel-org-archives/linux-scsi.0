From: Tim Small <tim@seoss.co.uk>
Subject: Apparent MPT ata pass-through bug SAS1068 and SAS1068E - WAS SMART
 causes disks to go offline on an LSI SAS1068 controller - Dell SAS 5/iR
Date: Wed, 28 Oct 2009 13:18:04 +0000
Message-ID: <4AE8448C.6070709@seoss.co.uk>
References: <20090914142939.GE14072@boogie.lpds.sztaki.hu> <4AE72E40.2000903@seoss.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.allsecurenet.com ([63.246.152.102]:47930 "EHLO
	relay1.allsecurenet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbZJ1NSO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Oct 2009 09:18:14 -0400
In-Reply-To: <4AE72E40.2000903@seoss.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: smartmontools-support@lists.sourceforge.net, linux-scsi@vger.kernel.org, Linux-PowerEdge@dell.com
Cc: Gabor Gombas <gombasg@sztaki.hu>

Hello,

On a Dell PowerEdge 1950 Debian 5.0 amd64 system (2.6.26-2-amd64), which 
includes one of these:

01:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068E 
PCI-Express Fusion-MPT SAS (rev 08)
        Subsystem: Dell SAS 6/iR Integrated RAID Controller
        Flags: bus master, fast devsel, latency 0, IRQ 1270
        I/O ports at ec00 [size=256]
        Memory at fc5fc000 (64-bit, non-prefetchable) [size=16K]
        Memory at fc5e0000 (64-bit, non-prefetchable) [size=64K]
        Expansion ROM at fc600000 [disabled] [size=1M]
        Capabilities: [50] Power Management version 2
        Capabilities: [68] Express Endpoint, MSI 00
        Capabilities: [98] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable+
        Capabilities: [b0] MSI-X: Enable- Mask- TabSize=1
        Capabilities: [100] Advanced Error Reporting <?>
        Kernel driver in use: mptsas
        Kernel modules: mptsas

filename:       
/lib/modules/2.6.26-2-amd64/kernel/drivers/message/fusion/mptsas.ko
version:        3.04.06
license:        GPL
description:    Fusion MPT SAS Host driver
author:         LSI Corporation

.. and a couple of WesternDigitial SATA drives,  I ran the following 
command:

while true ; do smartctl -a /dev/sg0 > /dev/null ; done

After approx 45 minutes this happened:

kernel: [5060492.926757] 
mptctldrivers/message/fusion/mptctl.c::mptctl_ioctl() @602 - Controller 
disabled.

... and all the attached block devices were no-longer available.  The 
machine also runs mpt-status.

Regards,

Tim.

-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.  
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

