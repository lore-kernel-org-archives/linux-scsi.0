From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH+RFC] sg: char_devs + seq_file lk2.6.0t6
Date: Sat, 11 Oct 2003 00:16:49 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F86BF51.8000609@torque.net>
References: <3F8296E6.9060302@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000804060407050305020108"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:41476 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262824AbTJJORj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Oct 2003 10:17:39 -0400
Received: from torque.net (d-241-137.stlucia.uq.net.au [203.101.241.137])
	by bunyip.cc.uq.edu.au (8.12.10/8.12.10) with ESMTP id h9AEHUMA006460
	for <linux-scsi@vger.kernel.org>; Sat, 11 Oct 2003 00:17:33 +1000 (GMT+1000)
In-Reply-To: <3F8296E6.9060302@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------000804060407050305020108
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Douglas Gilbert wrote:
> Changes to scsi generic (sg) driver [gzipped patch against
> lk 2.6.0-test6]:
>     - add "struct cdev" [char_devs] objects to increase
>       maximum number of sg devices from 256 to 8192
>     - use seq_file interface for /proc/scsi/sg/*
>       pseudo files
> 
> The first change re-introduces sg devices into sysfs.
> Each sg device has a directory (currently empty)
> with a name of the form: "/sys/cdev/major/sg<n>". When I tried
> adding 280 scsi "devices" with scsi_debug all the expected
> sg directories appeared (sg0..sg279). However sd registered
> the first 256 "disks" (up to /dev/sdiv) and failed thereafter
> with error "-16" (is anybody working on extending sd's
> disk and partition range?).
> 
> Would it be possible to put a symbolic link in the
> /sys/cdev/major/sg<n> directory to the corresponding
> sysfs scsi device (and vice versa)?

Well nobody objected so attached is another patch on
sg (as found in lk 2.6.0-test7) that additionally sets
up two symlinks from /sys/cdev/major/sg<n> to the
corresponding scsi device in sysfs and back again. A
pruned sysfs "tree" is also attached to illustrate.

Now I need to find somewhere in sysfs to place sg's
driver attributes (e.g. "allow_dio"). char_devs seem
to be deficient in this respect.

Doug Gilbert


--------------000804060407050305020108
Content-Type: application/x-gzip;
 name="sg260t7.diff.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="sg260t7.diff.gz"

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
--------------000804060407050305020108
Content-Type: text/plain;
 name="sg_symlinks.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg_symlinks.txt"

.
|-- block
|   ...
|   |-- sda
|       |-- dev
|       |-- device -> ../../devices/pseudo_0/adapter0/host1/1:0:0:0
|       |-- queue
|        .......
|-- bus
|   ......
|   |-- pseudo
|   |   |-- devices
|   |   |   `-- adapter0 -> ../../../devices/pseudo_0/adapter0
|   |   `-- drivers
|   |       `-- scsi_debug
|   |           |-- adapter0 -> ../../../../devices/pseudo_0/adapter0
|   |           |-- add_host
|   |           .....
|   |-- scsi
|       |-- devices
|       |   `-- 1:0:0:0 -> ../../../devices/pseudo_0/adapter0/host1/1:0:0:0
|       `-- drivers
|           `-- sd
|               `-- 1:0:0:0 -> ../../../../devices/pseudo_0/adapter0/host1/1:0:0:0
|-- cdev
|   ....
|   |-- major
|       |-- sg0
|       |   `-- device -> ../../../devices/pseudo_0/adapter0/host1/1:0:0:0
|-- class
|   ...
|   |-- scsi_device
|   |   `-- 1:0:0:0
|   |       |-- device -> ../../../devices/pseudo_0/adapter0/host1/1:0:0:0
|   |       `-- driver -> ../../../bus/scsi/drivers/sd
|   |-- scsi_host
|       `-- host1
|           |-- cmd_per_lun
|           |-- device -> ../../../devices/pseudo_0/adapter0/host1
|           ....
|-- devices
    ....
    |-- pseudo_0
        |-- adapter0
            |-- detach_state
            |-- host1
                |-- 1:0:0:0
                    |-- block -> ../../../../../block/sda
                    |-- delete
                    |-- detach_state
                    |-- device_blocked
                    |-- generic -> ../../../../../cdev/major/sg0
                    .....

--------------000804060407050305020108--

