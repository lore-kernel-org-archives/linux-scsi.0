From: Jan-Frode Myklebust <janfrode@parallab.uib.no>
Subject: Re: qla2300 at only 1 GBit on kernel 2.6.5
Date: Wed, 5 May 2004 19:46:49 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040505174649.GA21863@ii.uib.no>
References: <B179AE41C1147041AA1121F44614F0B0DD0114@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from noralf.uib.no ([129.177.30.12]:3473 "EHLO noralf.uib.no")
	by vger.kernel.org with ESMTP id S264788AbUEERqw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 May 2004 13:46:52 -0400
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0DD0114@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, May 05, 2004 at 09:27:10AM -0700, Andrew Vasquez wrote:
> 
> How are you verifying that the 2.4 driver is coming-up in 2Gig rather
> than 1gig?  Do you have an analyzer running between the HBA and
> storage device?  

The storage device has a gui telling me current speed. CurSynClk=2 GHz
for the redhat kernel, 1 GHz for the 2.6.5 and 2.6.6-rc3 kernels.

> Or, as you mentioned later in the email when testing
> the 8.x driver, did you force 2gig at the RAID box and reload the
> 2.4 driver?

Initially I was running kernel 2.6.5  had the connection forced at
2Gbit from the storage device side, then I struggled for a while
trying to understand why I didn't get link.  The qla2300 module said
"Cable unplugged". 

Then I set the storage device to autodetect speed, rebooted, and then
it came up at 1 Gbit.

Then (with the setting still at autodetect) I rebooted to the RedHat
kernel, and it got autodetected to 2 Gbit according to the storage
device.

> Which model?  Actually, looking ahead, I can see you are running an
> 
> 	Vendor: IFT       Model: A16F-G1A2         Rev: 334A
> 
> Of the three FC-SATA RAID boxes that are advertised, only the
> A16F-J1210-G1 model mentions support for 'full-duplex 2Gb FC-AL'.

The data-sheet says "Two 2Gbps Fibre Host Channels; Transfer rate up to
200MB/sec for each":

	http://www.infortrend.com/document/pdf/DS_ESA16FU_G_0311.pdf

> 
> Hmm, could you go into the BIOS utility (ctrl-q during boot) and check
> the 'Data Rate' settings for the HBA?  What is the value set to --
> auto/1gb/2gb?  If it is set to auto, could you set it to 2gb and retry
> the test.

During boot it says it has no 'ROM BIOS'. Is this something I can
install?


BTW: here's the log I get with 2.6.6-rc3 when loading the qla2300 with
speed=2GHz set on the infortrend:

QLogic Fibre Channel HBA Driver (f8aec000)
qla2300 0000:01:05.0: Found an ISP2300, irq 145, iobase 0xf89b4000
qla2300 0000:01:05.0: Configuring PCI space...
qla2300 0000:01:05.0: Configure NVRAM parameters...
qla2300 0000:01:05.0: Verifying loaded RISC code...
qla2300 0000:01:05.0: Waiting for LIP to complete...
qla2300 0000:01:05.0: Cable is unplugged...
scsi2 : qla2xxx
qla2300 0000:01:05.0:
 QLogic Fibre Channel HBA Driver: 8.00.00b11-k
  QLogic QLA2300 -
  ISP2300: PCI (33 MHz) @ 0000:01:05.0 hdma-, host#=2, fw=3.02.26 IPX


  -jf
