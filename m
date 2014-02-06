From: Kurt Miller <kurt@intricatesoftware.com>
Subject: LSI SAS2008 SATA TRIM not working
Date: Thu, 06 Feb 2014 18:56:15 -0500
Message-ID: <1391730975.3449.16.camel@sonic.justonedata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 4133fa24.cst.lightpath.net ([65.51.250.36]:44139 "EHLO
	mail1.intricatesoftware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751125AbaBGACV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2014 19:02:21 -0500
Received: from [10.0.0.21] (ool-435468f5.dyn.optonline.net [67.84.104.245])
	(authenticated bits=0)
	by mail1.intricatesoftware.com (8.14.5/8.14.3) with ESMTP id s16NuGYi014906
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 6 Feb 2014 18:56:21 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Various sources indicate that LSI's SAS2008 controllers support TRIM
when running their IT firmware (LSI [1] and this list [2]). However, I
have not been able to get it working with Dell PERC H200 or H310 cross
flashed into LSI IT firmware. Currently I'm testing with Samsung 840 EVO
SATA SSDs. I have tried various LSI IT firmware versions (P14, P16, P18)
and various Linux distributions (Ubuntu 13.10, Ubuntu 12.04, Ubuntu 14
beta, RHEL 7 beta, Fedora 19).

The SSDs report they support TRIM:

# hdparm -I /dev/sdc | grep "TRIM supported"
    *   Data Set Management TRIM supported (limit 8 blocks)

Checking for support shows TRIM support is not making it through:

# cat /sys/block/sdc/queue/discard_granularity 
0

# fstrim /srv/node/disk2p1
fstrim: /srv/node/disk2p1: FITRIM ioctl failed: Operation not supported

I am not using LVM or crypto. I've tried both ext4 and xfs. Here is an
example fstab line:

LABEL=disk2p1 /srv/node/disk2p1 xfs
noatime,nodiratime,nobarrier,logbufs=8,discard 0 0

The dmesg lines for mpt2sas look as follows:

mpt2sas version 15.100.00.00 loaded
mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (16418600
kB)
mpt2sas 0000:04:00.0: irq 79 for MSI/MSI-X
mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 79
mpt2sas0: iomem(0x00000000df2b0000), mapped(0xffffc90011be0000),
size(65536)
mpt2sas0: ioport(0x000000000000fc00), size(256)
mpt2sas0: sending message unit reset !!
mpt2sas0: message unit reset: SUCCESS
mpt2sas0: Allocated physical memory: size(8056 kB)
mpt2sas0: Current Controller Queue Depth(3579), Max Controller Queue
Depth(3712)
mpt2sas0: Scatter Gather Elements per IO(128)
mpt2sas0: LSISAS2008: FWVersion(14.00.01.00), ChipRevision(0x03),
BiosVersion(07.27.00.00)
mpt2sas0: Dell 6Gbps SAS HBA: Vendor(0x1000), Device(0x0072),
SSVID(0x1028), SSDID(0x1F1C)
mpt2sas0: Protocol=(Initiator,Target), Capabilities=(TLR,EEDP,Snapshot
Buffer,Diag Trace Buffer,Task Set Full,NCQ)
mpt2sas0: sending port enable !!
mpt2sas0: host_add: handle(0x0001), sas_addr(0x590b11c027281600),
phys(8)
mpt2sas0: port enable: SUCCESS

Is TRIM working for anyone using LSI SAS2008 controllers?

I'm out of ideas as to what could be the cause of the failure. Is it
just that mpt2sas doesn't support TRIM contrary to the links below?

Thanks,
-Kurt

[1]
http://mycusthelp.info/LSI/_cs/AnswerDetail.aspx?sSessionID=6784104245IHLKQYLMXJTXVUMPQBJOGGFDORLPZB&inc=8039&caller=~%2fFindAnswers.aspx%3ftxtCriteria%3dtrim%26sSessionid%3d6784104245IHLKQYLMXJTXVUMPQBJOGGFDORLPZB

[2] http://comments.gmane.org/gmane.linux.scsi/69511

