From: Tim Small <tim@seoss.co.uk>
Subject: Re: [smartmontools-support] SMART causes disks to go offline on an
	LSI	SAS1068 controller - Dell SAS 5/iR
Date: Tue, 27 Oct 2009 17:30:40 +0000
Message-ID: <4AE72E40.2000903@seoss.co.uk>
References: <20090914142939.GE14072@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-poweredge-bounces@dell.com>
In-Reply-To: <20090914142939.GE14072@boogie.lpds.sztaki.hu>
List-Unsubscribe: <https://lists.us.dell.com/mailman/listinfo/linux-poweredge>,
	<mailto:linux-poweredge-request@dell.com?subject=unsubscribe>
List-Archive: <http://lists.us.dell.com/pipermail/linux-poweredge>
List-Post: <mailto:linux-poweredge@dell.com>
List-Help: <mailto:linux-poweredge-request@dell.com?subject=help>
List-Subscribe: <https://lists.us.dell.com/mailman/listinfo/linux-poweredge>,
	<mailto:linux-poweredge-request@dell.com?subject=subscribe>
Sender: linux-poweredge-bounces@dell.com
Errors-To: linux-poweredge-bounces@dell.com
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: smartmontools-support@lists.sourceforge.net, linux-scsi@vger.kernel.org, Linux-PowerEdge@dell.com
List-Id: linux-scsi@vger.kernel.org

Hello,

Just to say that I'm seeing this bug as well, with smartmontools 5.38 
and smartctl 5.39 2009-10-10 r2955 on Debian lenny.  The machine is a 
Dell PowerEdge 860.  I'm guessing that this is either a firmware or 
driver issue.

02:08.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068 PCI-X 
Fusion-MPT SAS (rev 01)
        Subsystem: Dell SAS 5/iR Adapter RAID Controller
        Flags: bus master, 66MHz, medium devsel, latency 72, IRQ 1275
        I/O ports at ec00 [disabled] [size=256]
        Memory at fe9fc000 (64-bit, non-prefetchable) [size=16K]
        Memory at fe9e0000 (64-bit, non-prefetchable) [size=64K]
        Expansion ROM at fea00000 [disabled] [size=1M]
        Capabilities: [50] Power Management version 2
        Capabilities: [98] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable+
        Capabilities: [68] PCI-X non-bridge device
        Capabilities: [b0] MSI-X: Enable- Mask- TabSize=1
        Kernel driver in use: mptsas
        Kernel modules: mptsas

# modinfo mptsas
filename:       
/lib/modules/2.6.26-2-openvz-amd64/kernel/drivers/message/fusion/mptsas.ko
version:        3.04.06
license:        GPL
description:    Fusion MPT SAS Host driver
author:         LSI Corporation



The errors look like this:

428.524463] mptscsih: ioc0: attempting task abort! (sc=ffff81021b950940)
428.524471] sd 0:0:0:0: [sda] CDB: ATA command pass through(16): 85 08 
0e 00 d5 00 01 00 09 00 4f 00 c2 00 b0 00
433.199851] mptbase: ioc0: LogInfo(0x31140000): Originator={PL}, 
Code={IO Executed}, SubCode(0x0000)
433.199851] mptsas: ioc0: removing sata device, channel 0, id 0, phy 0
433.199851]  port-0:0: mptsas: ioc0: delete port (0)
433.199851] sd 0:0:0:0: [sda] Synchronizing SCSI cache
433.348856] mptscsih: ioc0: task abort: SUCCESS (sc=ffff81021b950940)
433.348868] mptscsih: ioc0: attempting task abort! (sc=ffff81021b950440)
433.348873] sd 0:0:0:0: [sda] CDB: Synchronize Cache(10): 35 00 00 00 00 
00 00 00 00 00
433.348885] mptscsih: ioc0: task abort: SUCCESS (sc=ffff81021b950440)
433.348893] mptscsih: ioc0: attempting target reset! (sc=ffff81021b950940)
433.348896] sd 0:0:0:0: [sda] CDB: ATA command pass through(16): 85 08 
0e 00 d5 00 01 00 09 00 4f 00 c2 00 b0 00
433.605026] mptscsih: ioc0: target reset: SUCCESS (sc=ffff81021b950940)
433.605034] mptscsih: ioc0: attempting bus reset! (sc=ffff81021b950940)
433.605037] sd 0:0:0:0: [sda] CDB: ATA command pass through(16): 85 08 
0e 00 d5 00 01 00 09 00 4f 00 c2 00 b0 00
434.157594] mptscsih: ioc0: bus reset: SUCCESS (sc=ffff81021b950940)
444.546154] mptscsih: ioc0: attempting host reset! (sc=ffff81021b950940)
444.546162] mptbase: ioc0: Initiating recovery
461.540429] mptscsih: ioc0: host reset: SUCCESS (sc=ffff81021b950940)
461.540437] sd 0:0:0:0: Device offlined - not ready after error recovery
461.540440] sd 0:0:0:0: Device offlined - not ready after error recovery
461.540475] end_request: I/O error, dev sda, sector 15631039
461.540480] md: super_written gets error=-5, uptodate=0
461.540485] raid1: Disk failure on sda1, disabling device.



and the drives are:

Model Family:     Seagate Barracuda ES
Device Model:     ST3250620NS
Serial Number:    9QE3L9E0
Firmware Version: 3BKS

and are in JBOD mode (+ sw RAID with md).

lsiutil says:

Current active firmware version is 0.10.51
Firmware image's version is MPTFW-00.10.51.00-IE
  LSI Logic
x86 BIOS image's version is MPTBIOS-6.12.05.00 (2007.09.29)

... which is the latest on Dell's download pages for this server.

The kernel is 2.6.26-2-openvz-amd64 from Debian Lenny (same behaviour 
with non-openvz kernel).  Running smartd makes the drives disappear 
after a few hours, but doing this:

while true ; do smartctl -T permissive -d sat -a /dev/sda > /dev/null && 
echo -n . ; done

seems to knock them out in about a minute.

Subjectively, 5.38 seemed to upset the controller a lot quicker than 
5.39 r2955 does.  For good measure I'm currently stress-testing a PE1950 
with a SAS 6/iR (SAS1068E) in the same way (however this is using RAID 
setup through the BIOS).

smartctl 5.39-pre needs '-T permissive' on the PE860, but 5.38 doesn't 
seem to require it.


It is worth trying a newer mptsas driver?

Regards,

Tim.

-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.  
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

_______________________________________________
Linux-PowerEdge mailing list
Linux-PowerEdge@dell.com
https://lists.us.dell.com/mailman/listinfo/linux-poweredge
Please read the FAQ at http://lists.us.dell.com/faq
