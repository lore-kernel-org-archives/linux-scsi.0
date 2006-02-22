From: Brian King <brking@us.ibm.com>
Subject: Re: 2.6.16-rc1 crash in scsi_target_reap_work
Date: Wed, 22 Feb 2006 08:38:03 -0600
Message-ID: <43FC774B.8050301@us.ibm.com>
References: <20060206220434.GA11732@suse.de> <1139265890.3022.63.camel@mulgrave.il.steeleye.com> <20060209200529.GA8968@suse.de> <20060210101124.GA6253@suse.de> <1139580295.3084.3.camel@mulgrave.il.steeleye.com> <20060210141012.GA12147@suse.de> <20060210230140.GA26423@suse.de> <43ED1FE0.1000805@us.ibm.com> <20060210232935.GA27760@suse.de> <43FA49F9.4020309@us.ibm.com> <20060222083657.GA24802@suse.de>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:14048 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751290AbWBVOiF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 09:38:05 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k1MEc5X0008169
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 09:38:05 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k1MEc57X233718
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 09:38:05 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k1MEc4cJ006697
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 09:38:05 -0500
In-Reply-To: <20060222083657.GA24802@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

Olaf Hering wrote:
>  On Mon, Feb 20, Brian King wrote:
> 
>> Olaf Hering wrote:
>>> 1:mon> d c0000000024cacc8
>>> c0000000024cacc8 00000000dead4ead ffffffff00000000  |......N.........|
>>> c0000000024cacd8 ffffffffffffffff c0000000024cace0  |.............L..|
>>> c0000000024cace8 c0000000024cace0 c000000000614f68  |.....L.......aOh|
>>> c0000000024cacf8 c000000000614f38 0000000000000000  |.....aO8........|
>>> c0000000024cad08 0000000000000000 0000000000000000  |................|
>>> c0000000024cad18 0000000000000000 0000000000000000  |................|
>>> c0000000024cad28 0000000000000000 0000000000000000  |................|
>>> c0000000024cad38 0000000000000000 0000000000000000  |................|
>>> c0000000024cad48 0000000000000000 0000000000000000  |................|
>>> c0000000024cad58 0000000000000000 0000000000000000  |................|
>>> c0000000024cad68 0000000000000000 0000000000000000  |................|
>>> c0000000024cad78 0000000000000000 0000000000000000  |................|
>>> c0000000024cad88 0000000000000000 0000000000000000  |................|
>>> c0000000024cad98 0000000000000000 0000000000000000  |................|
>>> c0000000024cada8 0000000000000000 0000000000000000  |................|
>>> c0000000024cadb8 0000000000000000 0000000000000000  |................|
>>> c0000000024cadc8 0000000000000000 0000000000000000  |................|
>>> c0000000024cadd8 0000000000000000 0000000000000000  |................|
>> I've now seen a couple recreates of this problem on various systems in
>> our labs, and there are always a bunch of zeroes in the struct device
>> in the same place as above. I wonder if perhaps the call to device_add
>> is failing in scsi_alloc_target. Failure of this call is not being handled
>> today. Can you give the attached patch a try? 
> 
> This fixes it, tested with plain rc3. Lots of -EEXIST, I wonder if the real bug is elsewhere.

I would guess that the -EEXIST is coming from:

create_dir
sysfs_create_dir
create_dir
kobject_add
device_add

Looking at the scsi_target reap code, it looks like there is a race condition. The
target is removed from the hosts list of targets under the host lock, then the host
lock is released. If another thread tries to add the same target that is being
tore down at this point (before device_del), the device_add will fail with EEXIST
since the sysfs directory for the device still exists.

Any reason we can't protect the target reaping code from this by grabbing the 
scan_mutex?


Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
