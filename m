From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [Bug] Remove and add a mounted device gets a new dev path
Date: Mon, 10 Dec 2012 18:51:48 +1100
Message-ID: <50C59494.5020103@interlog.com>
References: <50C223B4.8050301@oracle.com> <50C55E67.1000507@oracle.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:34149 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab2LJHv5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Dec 2012 02:51:57 -0500
In-Reply-To: <50C55E67.1000507@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-scsi@vger.kernel.org

On 12-12-10 03:00 PM, Anand Jain wrote:
>
>
> # mount /dev/sdb /btrfs
>
> # echo "scsi remove-single-device 1 0 0 0" > /proc/scsi/scsi
>
> # lsscsi
>   [0:0:0:0]    disk    ATA      VBOX HARDDISK    1.0   /dev/sda
>   [2:0:0:0]    disk    ATA      VBOX HARDDISK    1.0   /dev/sdc
>
> # btrfs su create /btrfs/sv1
> Create subvolume '/btrfs/sv1'
> ERROR: cannot create subvolume - Input/output error
>
> # echo "scsi add-single-device 1 0 0 0" > /proc/scsi/scsi
>
> # lsscsi
> [0:0:0:0]    disk    ATA      VBOX HARDDISK    1.0   /dev/sda
> [1:0:0:0]    disk    ATA      VBOX HARDDISK    1.0   /dev/sdd <---
> [2:0:0:0]    disk    ATA      VBOX HARDDISK    1.0   /dev/sdc
>
> The same disk comes back as /dev/sdd
>
> (the issue is same if disk is mounted as an ext4 fs)

That has been called a feature for several years now.
You (and any program that tries to track such things)
should be using the Device Identification VPD page
(e.g. see 'sg_vpd -i <device>').

And if the "VBOX HARDDISK" doesn't have that page
containing a unique identifier then you need to speak
to Oracle.

Linux could be more helpful and make those identifiers
available in sysfs; then lsscsi might display those
identifiers. The udev infrastructure tracks down some
of those identifiers, see the /dev/disk folder.

Doug Gilbert


