From: Guido Guenther <agx@sigxcpu.org>
Subject: Re: [PATCH] REPORT LUN scan even if no storage is available on LUN 0
Date: Thu, 13 Jan 2005 13:40:32 +0100
Message-ID: <20050113124032.GB5701@bogon.ms20.nix>
References: <20041210123333.GD685@bogon.ms20.nix> <20041213222206.GA18893@us.ibm.com> <20050110164200.GA8655@bogon.ms20.nix> <20050111181500.GA9046@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from honk1.physik.uni-konstanz.de ([134.34.140.224]:8616 "EHLO
	honk1.physik.uni-konstanz.de") by vger.kernel.org with ESMTP
	id S261625AbVAMNFX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Jan 2005 08:05:23 -0500
Content-Disposition: inline
In-Reply-To: <20050111181500.GA9046@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Jan 11, 2005 at 10:15:00AM -0800, Patrick Mansfield wrote:
> On Mon, Jan 10, 2005 at 05:42:00PM +0100, Guido Guenther wrote:
> > Sorry it took me so long to test this, first time I'm near this hardware
> > again.
> > On Mon, Dec 13, 2004 at 02:22:06PM -0800, Patrick Mansfield wrote:
> > > Patch looks okay, but we should always be trying the report lun scan, and
> > > then failing back to the sequential scan even if there is no storage on
> > > LUN 0.
> > 
> > > Can you test this? I don't have hardware readily available that supports
> > > sparse luns and report lun. Patch is against current bk. I built and
> > > ran with regular disks (lun 0 only).
> > Doesn't work here. I doen't see any devices in /proc/scsi/scsi now.
> >  -- Guido
> 
> So it worked some without the patch (I think you only saw some of the LUNs
> before)?
No. Without any patches we had all the available devices in
/proc/scsi/scsi but none was marked as "claimed by the OS" (all were
marked with a star, but could then be "added" via "scsi
add-single-device ... > /proc/scsi/scsi"). 
This was the actual problem I tried to solve with the patch. Now I don't
see any devices at all in /proc/scsi/scsi.

> What is output during the scan?
qla2300 0000:06:01.0: Found an ISP2312, irq 11, iobase 0xf8806000
qla2300 0000:06:01.0: Configuring PCI space...    
qla2300 0000:06:01.0: Configure NVRAM parameters...
qla2300 0000:06:01.0: Verifying loaded RISC code...                     
qla2300 0000:06:01.0: Waiting for LIP to complete...                            
qla2300 0000:06:01.0: LOOP UP detected (1 Gbps).
qla2300 0000:06:01.0: Topology - (F_Port), Host Loop address 0xffff 
scsi0 : qla2xxx
 QLogic Fibre Channel HBA Driver: 8.00.00b15-k
  QLogic QLA2342 -
qla2300 0000:06:01.0: Found an ISP2312, irq 11, iobase 0xf8806000
  ISP2312: PCI-X (100 MHz) @ 0000:06:01.0 hdma-, host#=0, fw=3.02.30 IPX

qla2300 0000:06:01.1: Found an ISP2312, irq 10, iobase 0xf8854000
qla2300 0000:06:01.1: Configuring PCI space...                                  
qla2300 0000:06:01.1: Configure NVRAM parameters...
qla2300 0000:06:01.1: Verifying loaded RISC code...                 
qla2300 0000:06:01.1: Waiting for LIP to complete...                           
qla2300 0000:06:01.1: LOOP UP detected (1 Gbps).
qla2300 0000:06:01.1: Topology - (F_Port), Host Loop address 0xffff
scsi1 : qla2xxx
 QLogic Fibre Channel HBA Driver: 8.00.00b15-k
  QLogic QLA2342 -
  ISP2312: PCI-X (100 MHz) @ 0000:06:01.1 hdma-, host#=1, fw=3.02.30 IPX

> Can you turn on some scsi logging, and send that?
Sure. I tried scsi_logging_level=... on the kernel command line but it
didn't show anything, did I miss something obvious?
/proc/sys/dev/scsi/logging_level was still zero afterwards.
Cheers,
 -- Guido
> 
> If you have root on scsi, you should shutdown syslogd (though this should
> not generate lots of logging for small amounts of IO it generates some,
> and if you screw up you'll be able to disable the logging), and then 
> capture the console/serial output.
> 
> If root on ide, just leave syslog on and get /var/log/messages output.
> 
> Turn on per-command and scan logging (0x2400 | 0x01c0):
> 
> 	sysctl -w dev.scsi.logging_level=0x25c0
> 
> Set back off afterwards with:
> 
> 	sysctl -w dev.scsi.logging_level=0
> 
> -- Patrick Mansfield
