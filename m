From: Rajat Jain <rajat.noida.india@gmail.com>
Subject: Incorrect driver getting loaded for Qlogic FC-HBA
Date: Mon, 25 Jul 2005 11:02:39 +0900
Message-ID: <b115cb5f0507241902653b6f72@mail.gmail.com>
Reply-To: Rajat Jain <rajat.noida.india@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-newbie-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-newbie-owner@vger.kernel.org
To: kernelnewbies@nl.linux.org, linux-scsi@vger.kernel.org, linux-newbie@vger.kernel.org, linux-kernel@vger.kernel.org, rajat.noida.india@gmail.com
List-Id: linux-scsi@vger.kernel.org

Hi,

I do not know which list to put this problem on. And hence ...

I'm using Kernel 2.6.9 and am having a Qlogic QLE2362 FC-HBA in my
system. I selected all the Qlogic SCSI drivers while buiding the
kernel. Now the problem is that every time I reboot, I have to
MANUALLY modprobe the qla2322.ko module in the kernel and only then my
HBA works. By default, the kernel loads qla2300.ko, which is not the
correct driver for the card, and hence the HBA does not work. Here is
the lspci output:

-----------------------------------------------------------------
0d:07.1 Fibre Channel: QLogic Corp.: Unknown device 2322 (rev 03)
	Subsystem: QLogic Corp.: Unknown device 0118
	Flags: bus master, 66Mhz, medium devsel, latency 128, IRQ 185
	I/O ports at 6400 [size=256]
	Memory at d0401000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
	Capabilities: [4c] PCI-X non-bridge device.
	Capabilities: [54] Message Signalled Interrupts: 64bit+ Queue=0/3 Enable-
-------------------------------------------------------------------

Here is the relevant extract from modules.pcimap:
-------------------------------------------------------------------
#module  vendor     device     subvendor  subdevice  class     
class_mask driver_data
qla2300  0x00001077 0x00002300 0xffffffff 0xffffffff 0x00000000 0x00000000 0x0
qla2300  0x00001077 0x00002312 0xffffffff 0xffffffff 0x00000000 0x00000000 0x0
qla2322  0x00001077 0x00002322 0xffffffff 0xffffffff 0x00000000 0x00000000 0x0
-------------------------------------------------------------------

As can be seen from above, qla2322 is the correct driver for device
2322 (My QLE2362 HBA has a device no 2322, as seen in lspci output).
But for some reason the kernel always loads qla2300 instead on
qla2322. I even tried putting the "qla2322" line on top of the two
"qla2300" lines in the modules.pcimap file. But with no result.

TIA,

Rajat
-
To unsubscribe from this list: send the line "unsubscribe linux-newbie" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at http://www.linux-learn.org/faqs
