From: Patrick Mansfield <patmans@us.ibm.com>
Subject: still BUG's for smp_processor_id() on interrupt
Date: Tue, 8 Feb 2005 17:09:29 -0800
Message-ID: <20050209010929.GA2933@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from e34.co.us.ibm.com ([32.97.110.132]:9455 "EHLO e34.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S261727AbVBIBKg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2005 20:10:36 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e34.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j191AaBu486738
	for <linux-scsi@vger.kernel.org>; Tue, 8 Feb 2005 20:10:36 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j191Aagp452564
	for <linux-scsi@vger.kernel.org>; Tue, 8 Feb 2005 18:10:36 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j191AZLX022366
	for <linux-scsi@vger.kernel.org>; Tue, 8 Feb 2005 18:10:35 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi@vger.kernel.org

Hi Andrew -

I'm still getting lots of BUG's for the smp_processor_id, but via the
interrupt function.

I am running the latest bk, it has your patch to qla_os.c:

[elm3b79 qla2xxx]$ grep smp_proc qla_os.c
        if (_smp_processor_id() == ha->last_irq_cpu || was_empty)

I'm running on a NUMAQ (sometimes has funky latencies). There are no
errors for simple IO (dd if=/dev/sda of=/dev/null bs=64k). There are about
40 disk drives attached.

More information available on request ...

elm3b79.beaverton.ibm.com login: QLogic Fibre Channel HBA Driver
qla2300 0000:01:0c.0: Found an ISP2300, irq 40, iobase 0xf888a000
qla2300 0000:01:0c.0: Configuring PCI space...
qla2300 0000:01:0c.0: Configure NVRAM parameters...
qla2300 0000:01:0c.0: Verifying loaded RISC code...
BUG: using smp_processor_id() in preemptible [00000001] code: modprobe/1362
caller is qla2300_intr_handler+0x184/0x204 [qla2xxx]
 [<c01aea79>] smp_processor_id+0x99/0xb8
 [<f88c0294>] qla2300_intr_handler+0x184/0x204 [qla2xxx]
 [<f88be39a>] qla2x00_mailbox_command+0x246/0x444 [qla2xxx]
 [<c0128487>] autoremove_wake_function+0x1b/0x40
 [<f88beb05>] qla2x00_mbx_reg_test+0x5d/0xa0 [qla2xxx]
 [<c01161e1>] release_console_sem+0xa9/0xb4
 [<c01ae350>] __delay+0x10/0x14
 [<f88bae73>] qla2x00_chip_diag+0x23b/0x29c [qla2xxx]
 [<f88ba5c8>] gcc2_compiled.+0x108/0x22c [qla2xxx]
 [<f88b76aa>] qla2x00_probe_one+0x42e/0x874 [qla2xxx]
 [<f88d0012>] gcc2_compiled.+0x12/0x18 [qla2300]
 [<c01b2424>] pci_device_probe_static+0x2c/0x40
 [<c01b2457>] __pci_device_probe+0x1f/0x34
 [<c01b2488>] pci_device_probe+0x1c/0x34
 [<c01d918d>] driver_probe_device+0x41/0x64
 [<c01d9260>] driver_attach+0x34/0x68
 [<c01d96bb>] bus_add_driver+0x8b/0xbc
 [<c01d9c08>] driver_register+0x50/0x54
 [<c01b2686>] pci_register_driver+0x86/0xa0
 [<f888800a>] qla2300_init+0xa/0x10 [qla2300]
 [<c012c479>] sys_init_module+0x111/0x270
 [<c0102443>] syscall_call+0x7/0xb
BUG: using smp_processor_id() in preemptible [00000001] code: modprobe/1362
...

-- Patrick Mansfield
