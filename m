From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] scsi/mptsas: add RAID devices in ascending ID order
Date: Fri, 22 Sep 2006 12:17:37 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7032D5CF@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:65172 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S964851AbWIVSRo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Sep 2006 14:17:44 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.wilck@fujitsu-siemens.com
Cc: linux-scsi@vger.kernel.org, mpt_linux_developer <mpt_linux_developer@lsil.com>

On Friday, September 22, 2006 8:58 AM, Martin Wilck wrote: 

> 
> From: Martin Wilck <Martin.Wilck@fujitsu-siemens.com>
> 
>     [SCSI] mptsas: add RAID devices in ascending ID order
>     
>     This patch fixes the order in which mptsas registers
>     RAID devices with the SCSI mid layer. The VolumeID field
>     is not in ascending order. This leads to situations where
>     e.g. device 2:8:2:0 is registered before 2:8:0:0.
>     
>     That may lead to an unbootable system e.g. if a user installs
>     on a two-disk RAID1 array and adds another 2-disk RAID1 later
>     (the new array will be detected as sda, the old one as sdb).
>     
>     The patch makes sure that arrays are added in ascending
>     VolumeID order.
> 

Rejected.  

Ascending ID ordering does not address all cases. 
There is no guarantee which target ids are 
assigned by firmware to volumes when
volumes are created.   I've made similar 
ordering proposals before to this mailing list. 
All been rejected.

I suggest that you not map your devices
to /dev/sda, but instead use persistent
device labels or names.  Most distro's
now days ship with Logical Volume Manager
that does this for you.

Here is a link on udev:

http://en.wikipedia.org/wiki/Udev


Eric
