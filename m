From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] fix 2.5 scsi queue depth setting
Date: Tue, 5 Nov 2002 20:35:00 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021105203500.A26535@eng2.beaverton.ibm.com>
References: <20021105202417.A26520@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021105202417.A26520@eng2.beaverton.ibm.com>; from patmans@us.ibm.com on Tue, Nov 05, 2002 at 08:24:17PM -0800
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Tue, Nov 05, 2002 at 08:24:17PM -0800, Patrick Mansfield wrote:
> This patch fixes queue depth setting of scsi devices.
> 
> This is done by pairing shost->slave_attach() calls with
> a scsi_build_commandblocks in the new scsi_slave_attach.
> 
> This is a patch aginst linux-scsi.bkbits.net/scsi-for-linus-2.5 after 
> applying the last posted hch version of the "Eliminate scsi_host_tmpl_list"
> patch, it still applies with offset to the current scsi-for-linus-2.5.

BTW, with all these changes, the SCSI messages come out in a bit different
order, like the following for two hosts. I removed the messages for all
but the first two drives found on each adapter, you can see that each host
adapter is scanned and attaches before going to the next host adapter,
and that queue depth setting is happening during attach time (queue depth
messages are interspersed with the attach messages).

scsi2 : QLogic QLA2200 PCI to Fibre Channel Host Adapter: bus 2 device 4 irq 22
        Firmware version:  2.02.03, Driver version 6.03.00b8
  Vendor: IBM       Model: 3542              Rev: 0400
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: IBM       Model: 3542              Rev: 0400
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi(2:0:0:0): Enabled tagged queuing, queue depth 16.
SCSI device : drive cache: write back
SCSI device : 35466240 512-byte hdwr sectors (18159 MB)
 sdc: unknown partition table
Attached scsi disk sdc at scsi2, channel 0, id 0, lun 0
scsi(2:0:0:1): Enabled tagged queuing, queue depth 16.
SCSI device : drive cache: write back
SCSI device : 35466240 512-byte hdwr sectors (18159 MB)
 sdd: unknown partition table
Attached scsi disk sdd at scsi2, channel 0, id 0, lun 1
scsi3 : QLogic QLA2200 PCI to Fibre Channel Host Adapter: bus 2 device 5 irq 23
        Firmware version:  2.02.03, Driver version 6.03.00b8
  Vendor: IBM       Model: 3542              Rev: 0400
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: IBM       Model: 3542              Rev: 0400
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi(3:0:0:0): Enabled tagged queuing, queue depth 16.
SCSI device : drive cache: write back
SCSI device : 35466240 512-byte hdwr sectors (18159 MB)
 sdm: unknown partition table
Attached scsi disk sdm at scsi3, channel 0, id 0, lun 0
scsi(3:0:0:1): Enabled tagged queuing, queue depth 16.
SCSI device : drive cache: write back
SCSI device : 35466240 512-byte hdwr sectors (18159 MB)
 sdn: unknown partition table
Attached scsi disk sdn at scsi3, channel 0, id 0, lun 1
