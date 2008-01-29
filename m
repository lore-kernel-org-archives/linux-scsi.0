From: Robert Hancock <hancockr@shaw.ca>
Subject: DMA mapping on SCSI device?
Date: Mon, 28 Jan 2008 18:08:44 -0600
Message-ID: <479E6E8C.2090501@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-arch@vger.kernel.org, ide <linux-ide@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We've got a bit of a problem with the sata_nv driver that I'm trying to 
figure out a decent solution to (hence all the lists CCed). This is the 
situation:

The nForce4 ADMA hardware has 2 modes: legacy mode, where it acts like a 
normal ATA controller with 32-bit DMA limits, and ADMA mode where it can 
access all of 64-bit memory. Each PCI device has 2 SATA ports, and the 
legacy/ADMA mode can be controlled independently on both of them.

The trick is that if an ATAPI device is connected, we (as far as I'm 
aware) can't use ADMA mode, so we have to switch that port into legacy 
mode. This means it's only capable of 32-bit DMA. However the other port 
on the controller may be connected to a hard drive and therefore still 
capable of 64-bit DMA. (To make things more complicated, devices can be 
hotplugged and so this can change dynamically.) Since the device that 
libata is doing DMA mapping against is attached to the PCI device and 
not the port, it creates a problem here. If we change the mask on one it 
affects the other one as well.

The original solution used by the driver was to leave the DMA mask at 
64-bit and use blk_queue_bounce_limit to try to force the block layer 
not to send any requests with DMA addresses over 4GB into the driver. 
However it seems on x86_64 this doesn't work, since it pushes high 
addresses through anyway and expects the IOMMU to take care of it (which 
it doesn't because of the 64-bit mask).

The last solution I tried was to set the DMA mask on both ports to 
32-bit on slave_configure when an ATAPI device is connected. However, 
this runs into complications as well. This is run on initialization and 
when trying to set the other port into 32-bit DMA, it may not be 
initialized yet. Plus, it forces the port with a hard drive on it into 
32-bit DMA needlessly.

The ideal solution would be to do mapping against a different struct 
device for each port, so that we could maintain the proper DMA mask for 
each of them at all times. However I'm not sure if that's possible. The 
thought of using the SCSI struct device for DMA mapping was brought up 
at one point.. any thoughts on that?
