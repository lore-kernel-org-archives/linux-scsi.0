From: Grant Grundler <grundler@parisc-linux.org>
Subject: [BUG] modprobe qla2300 doesn't complete
Date: Thu, 4 Mar 2004 21:18:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040305041850.GA9124@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:2452 "EHLO colo.lackof.org")
	by vger.kernel.org with ESMTP id S262203AbUCEESw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2004 23:18:52 -0500
Received: from localhost (localhost [127.0.0.1])
	by colo.lackof.org (Postfix) with ESMTP id 93A4E29804B
	for <linux-scsi@vger.kernel.org>; Thu,  4 Mar 2004 21:18:51 -0700 (MST)
Received: from colo.lackof.org ([127.0.0.1])
	by localhost (colo [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
	id 09157-01 for <linux-scsi@vger.kernel.org>;
	Thu, 4 Mar 2004 21:18:51 -0700 (MST)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi all,
qla2300 driver in 2.6.4-rc1 is showing a robustness problem.
When modprobe'ing the driver, it never completes initialization.
It continually prints the "Topology - (F_Port), Host Loop address 0xffff"
messages.  I know I have a bad disk or something connected to
the FC switch. And when I power off one of the disk arrays
(no raid controllers, just JBOD) the problem goes away...but I
expect better behavior from qla2300 driver.

I can make the system remotely available if someone wants to
debug this some more.

thanks,
grant

gsyprf3:~# modprobe qla2300
QLogic Fibre Channel HBA Driver (a000000200313c28)
PCI: Found IRQ 66 for device 0000:80:01.0
IOSAPIC: vector 66 -> CPU 0x0100, enabled
qla2300 0000:80:01.0: Found an ISP2312, irq 66, iobase 0xc0000000c8041000
qla2300 0000:80:01.0: Configuring PCI space...
qla2300 0000:80:01.0: Configure NVRAM parameters...
qla2300 0000:80:01.0: Verifying loaded RISC code...
qla2300 0000:80:01.0: LIP reset occured (f7f7).
qla2300 0000:80:01.0: Waiting for LIP to complete...
qla2300 0000:80:01.0: LOOP UP detected (2 Gbps).
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
...
