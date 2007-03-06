From: Doug Maxey <dwm@enoyolf.org>
Subject: Re: improve sg_luns output for iscsi
Date: Tue, 06 Mar 2007 12:50:56 -0600
Message-ID: <2894.1173207056@bebe.enoyolf.org>
References: <20070306180428.GA16826@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:45776 "EHLO
	bebe.enoyolf.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S964777AbXCFTqA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Mar 2007 14:46:00 -0500
In-reply-to: <20070306180428.GA16826@suse.de> 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org


On Tue, 06 Mar 2007 19:04:28 +0100, Olaf Hering wrote:
> 
> Upcoming IBM pSeries firmware can boot from iscsi. To configure the
> openfirmware boot-device string, we need to construct a correct
> devicepath. This path includes the lun. Its currently not 100% clear
> how exactly this lun value has to look like.
> 
> sg_luns may be the tool to get the value. But its current output is not
> parseable by scripts. It even gives the same output for two different
> scsi devices:
> 
> girgendwas:~ # lsscsi
> [0:0:0:0]    disk    DGC      RAID 5           0219  /dev/sda
> [0:0:0:1]    disk    DGC      RAID 5           0219  /dev/sdb
> [0:0:0:2]    disk    DGC      RAID 5           0219  /dev/sdc
> [0:0:0:3]    disk    DGC      RAID 5           0219  /dev/sdd
> girgendwas:~ # sg_luns -V
> sg_luns: version: 1.05 20060127
> girgendwas:~ # sg_luns /dev/sdd
> Lun list length = 32 which imples 4 lun entries
> Report luns [select_report=0]:
>     0000000000000000
>     0001000000000000
>     0002000000000000
>     0003000000000000
> girgendwas:~ # sg_luns /dev/sdc
> Lun list length = 32 which imples 4 lun entries
> Report luns [select_report=0]:
>     0000000000000000
>     0001000000000000
>     0002000000000000
>     0003000000000000
> 
> Is it possible to print the lun only for the requested scsi device?

In the simple test I did on pseries, I just determined the boot device, 
and passed that path to sg_luns.  For pseries, there will be only a 
single lun for boot.  At least for the time being primary storage 
will be on another (possibly raid/lvm) device.

So to me, using 
sg_luns |tail -1 
should get the line with the singleton lun in it, albeit with some 
amount of leading whitespace.

Can you extract some value from the installer that will give you the 
path to the target?

++doug

