From: Allan Wind <allan_wind@lifeintegrity.com>
Subject: Re: MD/RAID time out writing superblock
Date: Thu, 17 Sep 2009 12:36:47 -0400
Message-ID: <20090917163647.GA6663@lifeintegrity.com>
References: <20090917115728.GA13854@arachsys.com> <4AB2596D.10809@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-173-48-39-13.bstnma.fios.verizon.net ([173.48.39.13]:59145
	"EHLO lifeintegrity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758627AbZIQQgp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2009 12:36:45 -0400
Content-Disposition: inline
In-Reply-To: <4AB2596D.10809@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org

On 2009-09-18T00:44:45, Tejun Heo wrote:
> Hello,
> 
> Chris Webb wrote:
> > It's quite hard for us to do this with these machines as we have
> > them managed by a third party in a datacentre to which we don't have
> > physical access.  However, I could very easily get an extra 'test'
> > machine built in there, generate a work load that consistently
> > reproduces the problems on the six drives, and then retry with an
> > array build from 5, 4, 3 and 2 drives successively, taking out the
> > unused drives from chassis, to see if reducing the load on the power
> > supply with a smaller array helps.
> 
> Yeap, that also should shed some light on it.

I have a SuperMicro X8DT3-F motherboard with 2 (2 TB) WDC drives 
of the 8 bays available in the machine.  They are on a different 
controller LSI Logic / Symbios Logic SAS1068E PCI-Express Fusion-MPT SAS
which was flashed into "Integrated Target Mode" to get it running 
under Linux.

Disabling smartmontools seems to have helped in terms of failure 
frequency.  It is almost always the 2nd drive that is kicked out 
of the mirror although the last time it was the primary after 
disabling smart.  hddtemp was never running on this host.

[2256003.055451] end_request: I/O error, dev sdb, sector 3907028974
[2256003.055674] md: super_written gets error=-5, uptodate=0
[2256003.055677] raid1: Disk failure on sdb2, disabling device.
[2256003.055678] raid1: Operation continuing on 1 devices.
[2256003.437315] RAID1 conf printout:
[2256003.437318]  --- wd:1 rd:2
[2256003.437321]  disk 0, wo:0, o:1, dev:sda2
[2256003.437323]  disk 1, wo:1, o:0, dev:sdb2
[2256003.440542] RAID1 conf printout:
[2256003.440545]  --- wd:1 rd:2
[2256003.440548]  disk 0, wo:0, o:1, dev:sda2

[3880879.007618] end_request: I/O error, dev sda, sector 3907028974
[3880879.007839] md: super_written gets error=-5, uptodate=0
[3880879.007842] raid1: Disk failure on sda2, disabling device.
[3880879.007843] raid1: Operation continuing on 1 devices.
[3880879.028518] RAID1 conf printout:
[3880879.028521]  --- wd:1 rd:2
[3880879.028524]  disk 0, wo:1, o:0, dev:sda2
[3880879.028527]  disk 1, wo:0, o:1, dev:sdb2
[3880879.031607] RAID1 conf printout:
[3880879.031610]  --- wd:1 rd:2
[3880879.031613]  disk 1, wo:0, o:1, dev:sdb2

There is barely any load on this box.  Disabling NCQ did not help 
for me. 


/Allan
-- 
Allan Wind
Life Integrity, LLC
<http://lifeintegrity.com>

